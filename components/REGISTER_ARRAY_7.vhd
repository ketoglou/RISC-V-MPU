library ieee;
use ieee.std_logic_1164.all;

entity REGISTER_ARRAY_7 is
	port( 
			DATA1_IN,DATA2_IN,DATA3_IN,DATA4_IN,DATA5_IN,DATA6_IN,DATA7_IN : in std_logic_vector(31 downto 0);
			CLR,CLK : in std_logic;
			DATA1_OUT,DATA2_OUT,DATA3_OUT,DATA4_OUT,DATA5_OUT,DATA6_OUT,DATA7_OUT : out std_logic_vector(31 downto 0));
end REGISTER_ARRAY_7;

architecture BEHAVIORAL of REGISTER_ARRAY_7 is
	component REGISTER_32 is
	port( 
			D_IN : in std_logic_vector(31 downto 0);
			CLK,CLR,HOLD : in std_logic;
			D_OUT : out std_logic_vector(31 downto 0));
	end component;
begin
	
	GD1 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA1_IN,HOLD=>'0',D_OUT=>DATA1_OUT);
	GD2 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA2_IN,HOLD=>'0',D_OUT=>DATA2_OUT);
	GD3 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA3_IN,HOLD=>'0',D_OUT=>DATA3_OUT);
	GD4 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA4_IN,HOLD=>'0',D_OUT=>DATA4_OUT);
	GD5 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA5_IN,HOLD=>'0',D_OUT=>DATA5_OUT);
	GD6 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA6_IN,HOLD=>'0',D_OUT=>DATA6_OUT);
	GD7 : REGISTER_32 port map(CLK=>CLK,CLR=>CLR,D_IN=>DATA7_IN,HOLD=>'0',D_OUT=>DATA7_OUT);
	
end BEHAVIORAL;