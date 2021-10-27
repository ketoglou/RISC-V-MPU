library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_8 is
	port( 
			CLK,CLR : in std_logic;
			D_IN : in std_logic_vector(7 downto 0);
			D_OUT : out std_logic_vector(7 downto 0));
end REGISTER_8;

architecture BEHAVIORAL of REGISTER_8 is
	
	signal REG_8 : std_logic_vector(7 downto 0);
	
begin
	
	REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				REG_8<= x"00";
			else
				REG_8<=D_IN;
			end if;
		end if;
	end process;
	
	D_OUT<=REG_8;
end BEHAVIORAL;