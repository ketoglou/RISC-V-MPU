library ieee;
use ieee.std_logic_1164.all;

entity FLAG_REG is
	port( 
			FLAG_IN : in std_logic;
			CLK,CLR : in std_logic;
			FLAG_OUT : out std_logic);
end FLAG_REG;

architecture BEHAVIORAL of FLAG_REG is
	
	signal FLAG : std_logic;
	
begin
	
	REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				FLAG<= '0';
			else
				FLAG<=FLAG_IN;
			end if;
		end if;
	end process;
	
	FLAG_OUT<=FLAG;
end BEHAVIORAL;