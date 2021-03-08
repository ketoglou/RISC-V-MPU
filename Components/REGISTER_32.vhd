library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_32 is
	port( 
			D_IN : in std_logic_vector(31 downto 0);
			CLK,CLR,HOLD : in std_logic;
			D_OUT : out std_logic_vector(31 downto 0));
end REGISTER_32;

architecture BEHAVIORAL of REGISTER_32 is
	
	signal REG_32 : std_logic_vector(31 downto 0);
	
begin
	
	REG : process(CLK,CLR,HOLD)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				REG_32<= x"00000000";
			elsif(HOLD='0') then
				REG_32<=D_IN;
			end if;
		end if;
	end process;
	
	D_OUT<=REG_32;
end BEHAVIORAL;