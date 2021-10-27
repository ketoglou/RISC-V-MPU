library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_misc.nor_reduce;

entity ALU is
	port(
		DATAIN_1,DATAIN_2 : in std_logic_vector(31 downto 0);
		OP : in std_logic_vector(3 downto 0);
		DATA_OUT : out std_logic_vector(31 downto 0);
		ZERO,LESS_THAN_SIGNED,LESS_THAN_UNSIGNED : out std_logic);
end ALU;

architecture BEHAVIORAL of ALU is
	component CLA_32 is
		port(
			A,B : in std_logic_vector(31 downto 0);
			OP : in std_logic; --0:ADD,1:SUB
			S : out std_logic_vector(31 downto 0);
			COUT,OVERFLOW : out std_logic);
	end component;
	
	component BARREL_SHIFTER is
		port(
			DATA_IN : in std_logic_vector (31 downto 0);
			OPCODE : in std_logic_vector(1 downto 0); --00:SRL,01:SLL,10:SRA,11:SLA
			SHIFT : in std_logic_vector(4 downto 0);
			DATA_OUT : out std_logic_vector (31 downto 0));
	end component;
	
	component MUX2_1 is
	port(
		D0,D1 : in std_logic;
		SEL : in std_logic;
		Y : out std_logic);
	end component;

	signal RESULT : std_logic_vector(31 downto 0);
	signal RESULT_AS,RESULT_BS,RESULT_XOR,RESULT_AND,RESULT_OR : std_logic_vector(31 downto 0);
	signal LESS_THAN_SIGNED_R,LESS_THAN_UNSIGNED_R : std_logic;
	signal S : std_logic_vector(31 downto 0); 
	signal OP_AS,COUT,SEL_LT : std_logic;
	signal OP_BS : std_logic_vector(1 downto 0);
	
begin

	GCLA : CLA_32 port map(A=>DATAIN_1,B=>DATAIN_2,OP=>OP_AS,S=>RESULT_AS,COUT=>COUT,OVERFLOW=>open);
	GBSHIFTER: BARREL_SHIFTER port map(DATA_IN=>DATAIN_1,OPCODE=>OP_BS,SHIFT=>DATAIN_2(4 downto 0),DATA_OUT=>RESULT_BS);
	RESULT_AND<= DATAIN_1 and DATAIN_2;
	RESULT_OR<= DATAIN_1 or DATAIN_2;
	RESULT_XOR<= DATAIN_1 xor DATAIN_2;
	SEL_LT <= DATAIN_1(31) xor DATAIN_2(31);
	LT_RES : MUX2_1 port map(D0=>RESULT_AS(31),D1=>DATAIN_1(31),SEL=>SEL_LT,Y=>LESS_THAN_SIGNED_R);
	LESS_THAN_UNSIGNED_R<= not COUT;
	
	SET_PR : process(OP)
	begin
		OP_AS <= '0';
		OP_BS <= "00";
		if(OP="0000") then
			--ADD,ADDI COMMAND
			OP_AS <= '0';
		elsif(OP="1000" or OP="0010" or OP="0011") then
			--SUB,SLT,SLTU,SLTI,SLTIU,BEQ,BNE,BLT,BLTU,BGE,BGEU COMMAND
			OP_AS <= '1';
		elsif(OP="0101") then
			--SRL,SRLI COMMAND
			OP_BS <= "00";
		elsif(OP="0001") then
			--SLL,SLLI COMMAND
			OP_BS <= "01";
		elsif(OP="1101") then
			--SRA,SRAI COMMAND
			OP_BS <= "10";
		end if;
	end process;
	
	GET_PR : process(OP,RESULT_AS,RESULT_BS,RESULT_AND,RESULT_OR,RESULT_XOR,LESS_THAN_SIGNED_R,LESS_THAN_UNSIGNED_R,COUT)
	begin
		RESULT<=x"00000000";
		if(OP="0000" or OP="1000") then
			--ADD,SUB,ADDI COMMAND
			RESULT <= RESULT_AS;
		elsif(OP="0101" or OP="0001" or OP="1101") then
			--SRL,SLL,SRA,SRLI,SLLI,SRAI COMMAND
			RESULT <= RESULT_BS;
		elsif(OP="0111") then
			--AND,ANDI COMMAND
			RESULT <= RESULT_AND;
		elsif(OP="0110") then
			--OR,ORI COMMAND
			RESULT <= RESULT_OR;
		elsif(OP="0100") then
			--XOR,XORI COMMAND
			RESULT <= RESULT_XOR;
		elsif(OP="0010") then
			--SLT,SLTI COMMAND
			RESULT <= x"0000000" & "000" & LESS_THAN_SIGNED_R;
		elsif(OP="0011") then
			--SLTU,SLTUI COMMAND
			RESULT <= x"0000000" & "000" & LESS_THAN_UNSIGNED_R;	
		end if;
		
	end process;
	
	LESS_THAN_SIGNED <= LESS_THAN_SIGNED_R;
	LESS_THAN_UNSIGNED<=LESS_THAN_UNSIGNED_R;
	ZERO <= nor_reduce(RESULT);
	DATA_OUT <= RESULT;
end BEHAVIORAL;