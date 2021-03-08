library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

--256 Bytes Memory

entity INSTRUCTION_MEMORY is
	port(
		ADDRESS_IN,DATA_WR : in std_logic_vector (31 downto 0);
		MEM_WR,CLK : in std_logic;
		DATA_OUT : out std_logic_vector (31 downto 0));
end INSTRUCTION_MEMORY;

architecture BEHAVIORAL of INSTRUCTION_MEMORY is	
	--array of signals
	type MEMORY_256 is array(0 to 255) of std_logic_vector(7 downto 0);
	signal DATA_MEM : MEMORY_256; 
	
begin
	
	MEM_WRITE: process(CLK,MEM_WR,ADDRESS_IN) 
	begin
		if(CLK'event and CLK='1') then
			DATA_OUT <= x"00000000";
			if(MEM_WR ='1') then
				DATA_MEM(to_integer(unsigned(ADDRESS_IN))) <= DATA_WR(7 downto 0);
				DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 1)) <= DATA_WR(15 downto 8);
				DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 2)) <= DATA_WR(23 downto 16);
				DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 3)) <= DATA_WR(31 downto 24);
			else
				DATA_OUT <= DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 3)) & DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 2)) & DATA_MEM(to_integer(unsigned(ADDRESS_IN) + 1)) & DATA_MEM(to_integer(unsigned(ADDRESS_IN)));
			end if;
		end if;
	
	end process;
	
end BEHAVIORAL;