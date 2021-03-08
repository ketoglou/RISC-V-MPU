library IEEE;
use IEEE.std_logic_1164.all;

entity MUX8_1 is
	port(
		D0,D1,D2,D3,D4,D5,D6,D7 : in std_logic;
		SEL : in std_logic_vector(2 downto 0);
		Y : out std_logic);
end MUX8_1;

architecture BEHAVIORAL of MUX8_1 is
begin
	Y <= 	D0 when SEL="000" else 
			D1 when SEL="001" else
			D2 when SEL="010" else
			D3 when SEL="011" else
			D4 when SEL="100" else
			D5 when SEL="101" else
			D6 when SEL="110" else
			D7;
end BEHAVIORAL;