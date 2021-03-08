library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER is
	port(
		A,B,Cin : in std_logic;
		S,Cout : out std_logic);
end FULL_ADDER;

architecture BEHAVIORAL of FULL_ADDER is
begin
	S <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (Cin AND (A XOR B));
end BEHAVIORAL;