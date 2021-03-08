library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity CONTROL_UNIT is
	port(
		OPCODE,FUNCT7 : in std_logic_vector(6 downto 0);
		FUNCT3 : in std_logic_vector(2 downto 0);
		CSR_WB,WB : out std_logic;
		WR : out std_logic_vector(2 downto 0);
		BRANCH : out std_logic;
		MEM_WR : out std_logic;
		EX1,EN_IMM,C1,C2,NE1,NE2 : out std_logic;
		ALU_OP : out std_logic_vector(3 downto 0);
		OP_EXP,MRET_EN : out std_logic);
end CONTROL_UNIT;

architecture BEHAVIORAL of CONTROL_UNIT is
	
begin
	
	BEHAVE: process(FUNCT7,FUNCT3,OPCODE)
	begin
	
		ALU_OP<='0' & FUNCT3;
		CSR_WB<='0';
		WB<='0';
		MEM_WR<='0';
		EX1<='0';
		EN_IMM<='0';
		WR<="000"; --AUIPC
		BRANCH<='0';
		C1<='0';
		C2<='0';
		NE1<='0';
		NE2<='0';
		OP_EXP<='0';
		MRET_EN<='0';
		if(OPCODE="0110111") then
			--LUI
			WB<='1';
			WR<="010";
		elsif(OPCODE="0010111") then
			--AUIPC
			WB<='1';
		elsif(OPCODE="1101111") then
			--JAL
			WB<='1';
			WR<="001";
		elsif(OPCODE="1100111") then
			--JALR
			WB<='1';
			WR<="001";
			EX1<='1';
		elsif(OPCODE="1100011") then
			--BEQ,BNE,BLT,BGE,BLTU,BGEU
			ALU_OP<="1000"; --SUB
			BRANCH<='1';
		elsif(OPCODE="0000011") then
			--LB,LH,LW,LBU,LHU
			EX1<='1';
			WB<='1';
			WR<="100";
		elsif(OPCODE="0100011") then
			--SB,SH,SW
			EX1<='1';
			MEM_WR<='1';
		elsif(OPCODE="0010011") then
			--ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI,SRAI
			--All immediate instructions have same FUNCT3 code with the non immediate and zeros at FUNCT7.Exception is the SRAI command with FUNCT3=101 and FUNCT7(5)=1
			if(FUNCT3="101") then 
				ALU_OP<=FUNCT7(5) & FUNCT3;
			end if;
			WB<='1';
			EN_IMM<='1';
			WR<="101";
		elsif(OPCODE="0110011") then
			--ADD,SUB,SLL,SLT,SLTU,XOR,SRL,SRA,OR,AND
			ALU_OP<=FUNCT7(5) & FUNCT3; --for R type
			WB<='1';
			WR<="101";
		elsif(OPCODE="1110011") then
			--MRET,CSRRW,CSRRWI,CSRRS,CSRRSI,CSRRC,CSRRCI
			CSR_WB<='1';
			WB<='1';
			WR<="101";
			if(FUNCT3="000") then --xRET
				if(FUNCT7="0011000") then --MRET
					MRET_EN<='1';
				end if;
			elsif(FUNCT3="001") then --CSRRW
				WR<="011";
			elsif(FUNCT3="010") then --CSRRS
				C2<='1';
				ALU_OP<="0110";
			elsif(FUNCT3="011") then --CSRRC
				C2<='1';
				NE1<='1';
				ALU_OP<="0111";
			elsif(FUNCT3="101") then --CSRRWI
				WR<="010";
			elsif(FUNCT3="110") then --CSRRRSI
				C1<='1';
				EN_IMM<='1';
				ALU_OP<="0110";
			elsif(FUNCT3="111") then --CSRRRCI
				C1<='1';
				NE2<='1';
				EN_IMM<='1';
				ALU_OP<="0111";
			end if;
		else
			OP_EXP<='1';
		end if;
		
	end process;

end BEHAVIORAL;