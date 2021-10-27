library ieee;
use ieee.std_logic_1164.all;

entity DATA_HAZARD_UNIT is
	port( 
			WR_ID_EX : in std_logic_vector(2 downto 0);
			RD_ID_EX,RS1_IF_ID,RS2_IF_ID: in std_logic_vector(4 downto 0);
			OPCODE : in std_logic_vector(6 downto 0);
			DH_EN : out std_logic);
end DATA_HAZARD_UNIT;

architecture BEHAVIORAL of DATA_HAZARD_UNIT is

begin
	
	DANGERS : process(WR_ID_EX,RD_ID_EX,RS1_IF_ID,RS2_IF_ID,OPCODE)
	begin
		DH_EN<='0';
		if(WR_ID_EX="100") then
			if((OPCODE="1100011" or OPCODE="0100011" or OPCODE="0110011") and (RD_ID_EX=RS1_IF_ID or RD_ID_EX=RS2_IF_ID)) then
				DH_EN<='1';
			elsif((OPCODE="0000011" or OPCODE="0010011") and RD_ID_EX=RS1_IF_ID) then
				DH_EN<='1';
			end if;
		end if;
	end process;
	
end BEHAVIORAL;