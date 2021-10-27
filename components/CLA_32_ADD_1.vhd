library IEEE;
use IEEE.std_logic_1164.all;

entity CLA_32_ADD_1 is
	port(
		A : in std_logic_vector(31 downto 0);
		S : out std_logic_vector(31 downto 0));
end CLA_32_ADD_1;

architecture BEHAVIORAL of CLA_32_ADD_1 is
	component CLA_32 is
	port(
		A,B : in std_logic_vector(31 downto 0);
		OP : in std_logic;
		S : out std_logic_vector(31 downto 0);
		Cout : out std_logic);
	end component;
	
begin

	GCLA: CLA_32 port map(A=>A,B=>x"00000004",OP=>'0',S=>S,Cout=>open);	
	
end BEHAVIORAL;