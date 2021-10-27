library IEEE;
use IEEE.std_logic_1164.all;

entity MUX8_32 is
	port(
		D0,D1,D2,D3,D4,D5,D6,D7 : in std_logic_vector (31 downto 0);
		SEL : in std_logic_vector (2 downto 0);
		Y : out std_logic_vector (31 downto 0));
end MUX8_32;

architecture BEHAVIORAL of MUX8_32 is
	component MUX2_32 is
		port(
			D0,D1 : in std_logic_vector (31 downto 0);
			SEL : in std_logic;
			Y : out std_logic_vector (31 downto 0));
	end component;
	
	component MUX4_32 is
		port(
			D0,D1,D2,D3 : in std_logic_vector (31 downto 0);
			SEL : in std_logic_vector (1 downto 0);
			Y : out std_logic_vector (31 downto 0));
	end component;
	
	signal Y1,Y2 : std_logic_vector (31 downto 0);
begin
	GMUX4_32_1 : MUX4_32 port map(D0=>D0, D1=>D1,D2=>D2,D3=>D3, SEL=>SEL(1 downto 0), Y=>Y1 );
	GMUX4_32_2 : MUX4_32 port map(D0=>D4, D1=>D5,D2=>D6,D3=>D7, SEL=>SEL(1 downto 0), Y=>Y2 );
	GMUX2_32_1 : MUX2_32 port map(D0=>Y1, D1=>Y2, SEL=>SEL(2), Y=>Y );
end BEHAVIORAL;