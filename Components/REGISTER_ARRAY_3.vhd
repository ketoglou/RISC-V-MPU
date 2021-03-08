library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_ARRAY_3 is
	port( 
			DATA1_IN,DATA2_IN,DATA3_IN : in std_logic_vector(31 downto 0);
			CLR,CLK,HOLD : in std_logic;
			DATA1_OUT,DATA2_OUT,DATA3_OUT : out std_logic_vector(31 downto 0));
end REGISTER_ARRAY_3;

architecture BEHAVIORAL of REGISTER_ARRAY_3 is
	component REGISTER_32 is
	port( 
			D_IN : in std_logic_vector(31 downto 0);
			CLK,CLR,HOLD : in std_logic;
			D_OUT : out std_logic_vector(31 downto 0));
	end component;
begin
	
	GD1 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA1_IN,HOLD=>HOLD,D_OUT=>DATA1_OUT);
	GD2 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA2_IN,HOLD=>HOLD,D_OUT=>DATA2_OUT);
	GD3 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA3_IN,HOLD=>HOLD,D_OUT=>DATA3_OUT);
	
end BEHAVIORAL;