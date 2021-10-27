library ieee;
use ieee.std_logic_1164.all;

entity PIP_REG_ID_EXE is
	port( 
			CSR_WB,WB : in std_logic;
			WR : in std_logic_vector(2 downto 0);
			BRANCH : in std_logic;
			MEM_WR : in std_logic;
			EX1,EN_IMM,C1,C2,NE1,NE2 : in std_logic;
			ALU_OP : in std_logic_vector(3 downto 0);
			FUNCT3 : in std_logic_vector(2 downto 0);
			CSR_WB_O,WB_O : out std_logic;
			WR_O : out std_logic_vector(2 downto 0);
			BRANCH_O : out std_logic;
			MEM_WR_O : out std_logic;
			FUNCT3_O : out std_logic_vector(2 downto 0);
			EX1_O,EN_IMM_O,C1_O,C2_O,NE1_O,NE2_O : out std_logic;
			ALU_OP_O : out std_logic_vector(3 downto 0);	
			CLK,CLR : in std_logic);
end PIP_REG_ID_EXE;

architecture BEHAVIORAL of PIP_REG_ID_EXE is
	
	signal EX1_S,MEM_WR_S,WB_S,BRANCH_S,EN_IMM_S,CSR_WB_S,C1_S,C2_S,NE1_S,NE2_S : std_logic;
	signal WR_S : std_logic_vector(2 downto 0);
	signal FUNCT3_S : std_logic_vector(2 downto 0);
	signal ALU_OP_S : std_logic_vector(3 downto 0);
	
begin
	
	PIP_REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				EX1_S<='0';
				MEM_WR_S<='0';
				WB_S<='0';
				WR_S<="000";
				BRANCH_S<='0';
				FUNCT3_S<="000";
				ALU_OP_S<="0000";
				EN_IMM_S<='0';
				CSR_WB_S<='0';
				C1_S<='0';
				C2_S<='0';
				NE1_S<='0';
				NE2_S<='0';
			else
				EX1_S<=EX1;
				MEM_WR_S<=MEM_WR;
				WB_S<=WB;
				WR_S<=WR;
				BRANCH_S<=BRANCH;
				FUNCT3_S<=FUNCT3;
				ALU_OP_S<=ALU_OP;
				EN_IMM_S<=EN_IMM;
				CSR_WB_S<=CSR_WB;
				C1_S<=C1;
				C2_S<=C2;
				NE1_S<=NE1;
				NE2_S<=NE2;
			end if;
		end if;
	end process;
	
	EX1_O<=EX1_S;
	MEM_WR_O<=MEM_WR_S;
	WB_O<=WB_S;
	BRANCH_O<=BRANCH_S;
	FUNCT3_O<=FUNCT3_S;
	WR_O<=WR_S;
	ALU_OP_O<=ALU_OP_S;
	EN_IMM_O<=EN_IMM_S;
	CSR_WB_O<=CSR_WB_S;
	C1_O<=C1_S;
	C2_O<=C2_S;
	NE1_O<=NE1_S;
	NE2_O<=NE2_S;
end BEHAVIORAL;