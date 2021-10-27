library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;


entity X_REGISTERS is
	port(
		RS1,RS2 : in std_logic_vector (4 downto 0);
		DATA1,DATA2 : out std_logic_vector (31 downto 0);
		WR : in std_logic;
		DATA_WRITE : in std_logic_vector (31 downto 0);
		RD : in std_logic_vector (4 downto 0);
		CLK : in std_logic);
end X_REGISTERS;

architecture BEHAVIORAL of X_REGISTERS is

	type xreg_type is array(0 to 15) of std_logic_vector(31 downto 0);
	signal xregs : xreg_type :=  (others =>x"00000000");
	
begin

	REGISTERS_WR: process(CLK,RD,WR,DATA_WRITE)
	begin
		if(CLK'event and CLK='1') then
			--Allow writes to all registers except reg0, reg0 is always zero.
			if(WR='1' and RD/="00000") then
				xregs(to_integer(unsigned(RD(3 downto 0))))<=DATA_WRITE;
			end if;
		end if;
	end process;
	
	DATA1 <= xregs(to_integer(unsigned(RS1(3 downto 0))));
	DATA2<=xregs(to_integer(unsigned(RS2(3 downto 0))));
end BEHAVIORAL;