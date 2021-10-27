library ieee;
use ieee.std_logic_1164.all;

entity D_FF is
	port( 
			CLK,D,CLR : in std_logic;
			Q :out std_logic);
end D_FF;

architecture BEHAVIORAL of D_FF is
	signal DFF: std_logic;
begin
	seq0 : process(CLK,CLR)
	begin
		if(CLR='1') then DFF<='0';
		elsif(CLK'event and CLK='1')then DFF<=D;
		end if;
	end process;
	Q<=DFF;
end BEHAVIORAL;
	