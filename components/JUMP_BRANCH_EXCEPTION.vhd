library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.or_reduce;

entity JUMP_BRANCH_EXCEPTION is
	port( 
			NEW_PC : in std_logic_vector(31 downto 0);
			JB_EXCEPTION : out std_logic);
end JUMP_BRANCH_EXCEPTION;

architecture BEHAVIORAL of JUMP_BRANCH_EXCEPTION is
begin
	JB_EXCEPTION<= or_reduce(NEW_PC and x"FFFFFF00" );
end BEHAVIORAL;