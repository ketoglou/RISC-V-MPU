library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;


entity EXP_INT_HANDLER is
	port(
		MRET_EN,OP_EXP,JB_EXP,INT_EXTERNAL : in std_logic;
		PC,INVALID_ADDRESS : in std_logic_vector (31 downto 0);
		INVALID_INST : in std_logic_vector (19 downto 0);
		CSR_ADDRESS,CSR_ADDRESS_WR : in std_logic_vector (11 downto 0);
		CSR_DATA_WR : in std_logic_vector (31 downto 0);
		CSR_WR,EXP_INT_EN_RETURN,CLR,CLK : in std_logic;
		EXP_INT_EN : out std_logic;
		EXP_INT_PC,CSR_DATA : out std_logic_vector (31 downto 0));
end EXP_INT_HANDLER;

architecture BEHAVIORAL of EXP_INT_HANDLER is

	signal MSTATUS,MEPC,MCASE,MTVAL,MSCRATCH : std_logic_vector (31 downto 0);
	signal MTVEC : std_logic_vector (31 downto 0) := x"00000008"; --BASE is at address 4(1st bit is MODE)
	signal CSR_DATA_S,EXP_INT_PC_S : std_logic_vector (31 downto 0);
	signal OP_EXP_FLAG,JB_EXP_FLAG,INT_EXTERNAL_FLAG : std_logic;
	
begin
	
	REGISTERS_WR_AND_HANDLER: process(CLK,CLR,CSR_ADDRESS_WR,CSR_WR,CSR_DATA_WR,OP_EXP,JB_EXP,INT_EXTERNAL,EXP_INT_EN_RETURN,MRET_EN)
	begin
		if(CLK'event and CLK='1') then
			EXP_INT_EN<='0';
			
			--RETURN INSTRUCTION,ENABLE AGAIN INTERRUPTS,WRITE BACK PC
			if(MRET_EN='1') then
				MSTATUS(3)<='1'; --Enable global interrupts
				EXP_INT_PC_S<=MEPC;
				EXP_INT_EN<='1'; --Set PC to the EXP_INT_PC
			end if;
			
			--FLAG SET
			----------------------------------------------------
			if(OP_EXP='1') then
				OP_EXP_FLAG<='1';
			end if;
			
			if(JB_EXP='1') then
				JB_EXP_FLAG<='1';
			end if;
			
			if(INT_EXTERNAL='1') then
				INT_EXTERNAL_FLAG<='1';
			end if;
		----------------------------------------------------
		
			if(CLR='1') then
				--CLEAR REGISTERS
				----------------------------------------------
				MSTATUS<=x"00000000";
				MTVEC<=x"00000004";
				MEPC<=x"00000000";
				MCASE<=x"00000000";
				MTVAL<=x"00000000";
				MSCRATCH<=x"00000000";
			elsif(CSR_WR='1' ) then
				--WRITE REGISTERS
				----------------------------------------------
				if(CSR_ADDRESS_WR=x"300") then --mstatus
					MSTATUS<=CSR_DATA_WR;
				elsif(CSR_ADDRESS_WR=x"305") then --mtvec
					MTVEC<=CSR_DATA_WR and x"00000009";
				elsif(CSR_ADDRESS_WR=x"340") then --mscratch
					MSCRATCH<=CSR_DATA_WR;
				end if;
			end if;
			
			if(MSTATUS(3)='1') then --If MIE enabled then handle interrupts
				--HANDLE EXCEPTIONS AND INTERRUPTS
				----------------------------------------------
				if(OP_EXP_FLAG='1') then
					OP_EXP_FLAG<='0'; --Clear flag
					MSTATUS(3)<='0'; --Clear MIE so next interrupts not handed until this one return(MRETURN)
					MCASE<=x"00000002"; --Illegal instruction
					EXP_INT_PC_S<=MTVEC(31 downto 1) & '0'; --All exception have BASE address
					MTVAL<= CSR_ADDRESS & INVALID_INST; --Save illegal instruction
				elsif(JB_EXP_FLAG='1') then
					JB_EXP_FLAG<='0'; --Clear flag
					MSTATUS(3)<='0'; --Clear MIE so next interrupts not handed until this one return(MRETURN)
					MCASE<=x"00000000"; --Instruction address misaligned
					EXP_INT_PC_S<=MTVEC(31 downto 1) & '0'; --All exception have BASE address
					MTVAL<=INVALID_ADDRESS; --Save illegal address
				elsif(INT_EXTERNAL_FLAG='1') then
					INT_EXTERNAL_FLAG<='0'; --Clear flag
					MSTATUS(3)<='0'; --Clear MIE so next interrupts not handed until this one return(MRETURN)
					MCASE<=x"8000000B"; --Machine external interrupt
					if(MTVEC(0)='0') then
						EXP_INT_PC_S<=MTVEC(31 downto 1) & '0'; --All interrupts have BASE address(MTVAL=DIRECT MODE)
					else
						EXP_INT_PC_S<=x"00000030"; --All interrupts have BASE+4*case_code address (MTVAL=VECTOR MODE),for machine external interrupt => 4 + 4*11 = 48(0x30)
					end if;
				end if;
				MEPC<=PC; --Save current PC
				EXP_INT_EN<='1'; --Set PC to the EXP_INT_PC
			end if;
			
			--When EXP_INT_EN come back set to 0 so normal operation continue
			if(EXP_INT_EN_RETURN='1') then
				EXP_INT_EN<='0';
			end if;
			
		end if;
	end process;
	
	REGISTERS_READ: process(CSR_ADDRESS,MSTATUS,MTVEC,MEPC,MCASE,MTVAL,MSCRATCH)
	begin
		CSR_DATA_S<=x"00000000";
		if(CSR_ADDRESS=x"300") then --mstatus
			CSR_DATA_S<=MSTATUS;
		elsif(CSR_ADDRESS=x"305") then --mtvec
			CSR_DATA_S<=MTVEC;
		elsif(CSR_ADDRESS=x"341") then --mepc
			CSR_DATA_S<=MEPC;
		elsif(CSR_ADDRESS=x"342") then --mcase
			CSR_DATA_S<=MCASE;
		elsif(CSR_ADDRESS=x"343") then --mtval
			CSR_DATA_S<=MTVAL;
		elsif(CSR_ADDRESS=x"340") then --mscratch
			CSR_DATA_S<=MSCRATCH;
		end if;

	end process;
	
	EXP_INT_PC<=EXP_INT_PC_S;
	CSR_DATA<=CSR_DATA_S;
end BEHAVIORAL;