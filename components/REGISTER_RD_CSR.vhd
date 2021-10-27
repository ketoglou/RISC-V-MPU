library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_RD_CSR is
	port( 
			RD : in std_logic_vector(4 downto 0);
			CSR : in std_logic_vector(11 downto 0);
			CLK,CLR : in std_logic;
			RD_O : out std_logic_vector(4 downto 0);
			CSR_O : out std_logic_vector(11 downto 0));
end REGISTER_RD_CSR;

architecture BEHAVIORAL of REGISTER_RD_CSR is
	
	signal REG_5 : std_logic_vector(4 downto 0);
	signal REG_12 : std_logic_vector(11 downto 0);
begin
	
	REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				REG_5<= "00000";
				REG_12<="000000000000";
			else
				REG_5<=RD;
				REG_12<=CSR;
			end if;
		end if;
	end process;
	
	RD_O<=REG_5;
	CSR_O<=REG_12;
end BEHAVIORAL;