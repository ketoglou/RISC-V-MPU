library ieee;
use ieee.std_logic_1164.all;

entity PIP_REG_EXE_MEM is
	port( 
			CSR_WB,WB : in std_logic;
			WR : in std_logic_vector(2 downto 0);
			BRANCH,MEM_WR : in std_logic;
			FUNCT3 : in std_logic_vector(2 downto 0);
			ZERO,LESS_THAN_SIGNED,LESS_THAN_UNSIGNED : in std_logic;
			CLK,CLR : in std_logic;
			CSR_WB_O,WB_O : out std_logic;
			WR_O : out std_logic_vector(2 downto 0);
			BRANCH_O : out std_logic;
			ZERO_O,LESS_THAN_SIGNED_O,LESS_THAN_UNSIGNED_O : out std_logic;
			FUNCT3_O : out std_logic_vector(2 downto 0);
			MEM_WR_O : out std_logic);
end PIP_REG_EXE_MEM;

architecture BEHAVIORAL of PIP_REG_EXE_MEM is
	
	signal MEM_WR_S,WB_S,JUMP_S,BRANCH_S,ZERO_S,LESS_THAN_SIGNED_S,LESS_THAN_UNSIGNED_S,CSR_WB_S : std_logic;
	signal WR_S : std_logic_vector(2 downto 0);
	signal FUNCT3_S : std_logic_vector(2 downto 0);
	
begin
	
	PIP_REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				BRANCH_S<='0';
				WR_S<="000";
				MEM_WR_S<='0';
				WB_S<='0';
				ZERO_S<='0';
				LESS_THAN_SIGNED_S<='0';
				LESS_THAN_UNSIGNED_S<='0';
				FUNCT3_S<="000";
				CSR_WB_S<='0';
			else
				BRANCH_S<=BRANCH;
				WR_S<=WR;
				MEM_WR_S<=MEM_WR;
				WB_S<=WB;
				ZERO_S<=ZERO;
				LESS_THAN_SIGNED_S<=LESS_THAN_SIGNED;
				LESS_THAN_UNSIGNED_S<=LESS_THAN_UNSIGNED;
				FUNCT3_S<=FUNCT3;
				CSR_WB_S<=CSR_WB;
			end if;
		end if;
	end process;
	
	BRANCH_O<=BRANCH_S;
	WR_O<=WR_S;
	MEM_WR_O<=MEM_WR_S;
	WB_O<=WB_S;
	ZERO_O<=ZERO_S;
	LESS_THAN_SIGNED_O<=LESS_THAN_SIGNED_S;
	LESS_THAN_UNSIGNED_O<=LESS_THAN_UNSIGNED_S;
	FUNCT3_O<=FUNCT3_S;
	CSR_WB_O<=CSR_WB_S;
end BEHAVIORAL;