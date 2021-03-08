library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

--64 Bytes Memory

entity DATA_MEMORY is
	port(
		ADDRESS_IN,DATA_WR : in std_logic_vector (31 downto 0);
		MEM_OP : in std_logic_vector (2 downto 0); --000:LB,SB | 001:LH,SH | 010:LW,SW | 100:LBU | 101:LHU
		MEM_WR,CLK : in std_logic;
		DATA_OUT : out std_logic_vector (31 downto 0);
		EXP_PINS : out std_logic_vector (7 downto 0));
end DATA_MEMORY;

architecture BEHAVIORAL of DATA_MEMORY is	
	--array of signals
	type MEMORY_256 is array(0 to 63) of std_logic_vector(7 downto 0);
	signal DATA_MEM : MEMORY_256; 
	signal ADDRESS_S : std_logic_vector (31 downto 0);
	signal DATA_WORD : std_logic_vector (31 downto 0);
	signal DATA_HALF : std_logic_vector (15 downto 0);
	signal DATA_BYTE : std_logic_vector (7 downto 0);
	signal SIGN_HALF : std_logic_vector (15 downto 0);
	signal SIGN_BYTE : std_logic_vector (23 downto 0);
	
begin
	ADDRESS_S<=ADDRESS_IN and (x"000000" & "00111111"); --We dont generate exception if ADDRESS_IN outside of bounds,but we keep only the 6 LSB bits as ADDRESS_IN.
	DATA_WORD<=DATA_MEM(to_integer(unsigned(ADDRESS_S) + 3)) & DATA_MEM(to_integer(unsigned(ADDRESS_S) + 2)) & DATA_MEM(to_integer(unsigned(ADDRESS_S) + 1)) & DATA_MEM(to_integer(unsigned(ADDRESS_S)));
	DATA_HALF<= DATA_MEM(to_integer(unsigned(ADDRESS_S) + 1)) & DATA_MEM(to_integer(unsigned(ADDRESS_S)));
	DATA_BYTE<=DATA_MEM(to_integer(unsigned(ADDRESS_S)));
	SIGN_HALF<=x"0000" when DATA_HALF(15)='0' else x"FFFF";
	SIGN_BYTE<=x"000000" when DATA_BYTE(7)='0' else x"FFFFFF";
	
	MEM_WRITE: process(CLK,MEM_WR,MEM_OP) 
	begin
		if(CLK'event and CLK='1' and MEM_WR ='1') then
			if(MEM_OP="000") then
				DATA_MEM(to_integer(unsigned(ADDRESS_S))) <= DATA_WR(7 downto 0);
			elsif(MEM_OP="001") then
				DATA_MEM(to_integer(unsigned(ADDRESS_S))) <= DATA_WR(7 downto 0);
				DATA_MEM(to_integer(unsigned(ADDRESS_S) + 1)) <= DATA_WR(15 downto 8);
			elsif(MEM_OP="010") then
				DATA_MEM(to_integer(unsigned(ADDRESS_S))) <= DATA_WR(7 downto 0);
				DATA_MEM(to_integer(unsigned(ADDRESS_S) + 1)) <= DATA_WR(15 downto 8);
				DATA_MEM(to_integer(unsigned(ADDRESS_S) + 2)) <= DATA_WR(23 downto 16);
				DATA_MEM(to_integer(unsigned(ADDRESS_S) + 3)) <= DATA_WR(31 downto 24);
			end if;
		end if;
	
	end process;
	
	EXP_PINS<=DATA_MEM(0);
	DATA_OUT <= (SIGN_BYTE & DATA_BYTE) when MEM_OP="000" else
					(SIGN_HALF & DATA_HALF) when MEM_OP="001" else
					DATA_WORD when MEM_OP="010" else
					(x"000000" & DATA_BYTE) when MEM_OP="100" else
					(x"0000" & DATA_HALF) when MEM_OP="101" else
					x"00000000";
	
end BEHAVIORAL;