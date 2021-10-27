library IEEE;
use IEEE.std_logic_1164.all;

entity MUX2_1 is
	port(
		D0,D1 : in std_logic;
		SEL : in std_logic;
		Y : out std_logic);
end MUX2_1;

architecture BEHAVIORAL of MUX2_1 is
begin
	Y <= D0 when SEL='0' else D1;
end BEHAVIORAL;