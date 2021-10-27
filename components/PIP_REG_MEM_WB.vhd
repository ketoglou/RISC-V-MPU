library ieee;
use ieee.std_logic_1164.all;

entity PIP_REG_MEM_WB is
	port( 
			CSR_WB,WB : in std_logic;
			WR : in std_logic_vector(2 downto 0);
			CLK,CLR : in std_logic;
			CSR_WB_O,WB_O : out std_logic;
			WR_O : out std_logic_vector(2 downto 0));
end PIP_REG_MEM_WB;

architecture BEHAVIORAL of PIP_REG_MEM_WB is
	
	signal WB_S,CSR_WB_S : std_logic;
	signal WR_S : std_logic_vector(2 downto 0);
	
begin
	
	PIP_REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				WR_S<="000";
				WB_S<='0';
				CSR_WB_S<='0';
			else
				WR_S<=WR;
				WB_S<=WB;
				CSR_WB_S<=CSR_WB;
			end if;
		end if;
	end process;
	
	WR_O<=WR_S;
	WB_O<=WB_S;
	CSR_WB_O<=CSR_WB_S;
end BEHAVIORAL;