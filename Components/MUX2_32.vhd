library IEEE;
use IEEE.std_logic_1164.all;

entity MUX2_32 is
	port(
		D0,D1 : in std_logic_vector (31 downto 0);
		SEL : in std_logic;
		Y : out std_logic_vector (31 downto 0));
end MUX2_32;

architecture BEHAVIORAL of MUX2_32 is
	component MUX2_1 is
		port(
			D0,D1 : in std_logic;
			SEL : in std_logic;
			Y : out std_logic);
	end component;
	
begin
	GEN_MUX2_1: 
   for i in 0 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>D0(i), D1=>D1(i), SEL=>SEL, Y=>Y(i) );
   end generate GEN_MUX2_1;
end BEHAVIORAL;