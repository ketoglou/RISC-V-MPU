library ieee;
use ieee.std_logic_1164.all;

entity REGISTERS_ID is
	port( 
			RD : in std_logic_vector(4 downto 0);
			CSR : in std_logic_vector(11 downto 0);
			RS1,RS2 : in std_logic_vector(4 downto 0);
			CLR,CLK : in std_logic;
			RD_O : out std_logic_vector(4 downto 0);
			CSR_O : out std_logic_vector(11 downto 0);
			RS1_O,RS2_O : out std_logic_vector(4 downto 0));
end REGISTERS_ID;

architecture BEHAVIORAL of REGISTERS_ID is
	signal RS1_S,RS2_S,RD_S : std_logic_vector(4 downto 0);
	signal CSR_S : std_logic_vector(11 downto 0);
begin

	REG : process(CLK,CLR)
	begin
		if(CLK'event and CLK='1') then
			if(CLR='1') then
				RS1_S<="00000";
				RS2_S<="00000";
				RD_S<="00000";
				CSR_S<="000000000000";
			else
				RS1_S<=RS1;
				RS2_S<=RS2;
				RD_S<=RD;
				CSR_S<=CSR;
			end if;
		end if;
	end process;
	
	RS1_O<=RS1_S;
	RS2_O<=RS2_S;
	RD_O<=RD_S;
	CSR_O<=CSR_S;
	
end BEHAVIORAL;