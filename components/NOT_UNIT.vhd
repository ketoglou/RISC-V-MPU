library IEEE;
use IEEE.std_logic_1164.all;

entity NOT_UNIT is
	port(
		NOT_ENABLE : in std_logic;
		DATA_IN : in std_logic_vector (31 downto 0);
		DATA_OUT : out std_logic_vector (31 downto 0));
end NOT_UNIT;

architecture BEHAVIORAL of NOT_UNIT is
	
begin
	DATA_OUT <= DATA_IN when NOT_ENABLE='0' else not(DATA_IN);
end BEHAVIORAL;