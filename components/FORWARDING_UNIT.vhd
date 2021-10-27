library ieee;
use ieee.std_logic_1164.all;

entity FORWARDING_UNIT is
	port( 
			RS1_ID_EX,RS2_ID_EX,RS1_ID,RS2_ID,RD_MEM_WB,RD_EX_MEM : in std_logic_vector(4 downto 0);
			WB_EX_MEM,WB_MEM_WB,EN_IMM : in std_logic;
			FORWARD_ID1,FORWARD_ID2 : out std_logic;
			FORWARD_1,FORWARD_2 : out std_logic_vector(1 downto 0));
end FORWARDING_UNIT;

architecture BEHAVIORAL of FORWARDING_UNIT is

	
begin
	
	DANGERS : process(RS1_ID_EX,RS2_ID_EX,RS1_ID,RS2_ID,RD_EX_MEM,RD_MEM_WB,WB_EX_MEM,WB_MEM_WB,EN_IMM)
	begin
		FORWARD_1<="00";
		FORWARD_2<="00";
		FORWARD_ID1<='0';
		FORWARD_ID2<='0';
		
		if(EN_IMM='1') then
			FORWARD_2<="11";
		end if;
		
		if(WB_EX_MEM='1' and RD_EX_MEM/="00000") then
			if(RD_EX_MEM=RS1_ID_EX) then
				FORWARD_1<="01";
			end if;
			
			if(RD_EX_MEM=RS2_ID_EX and EN_IMM='0') then
				FORWARD_2<="01";
			end if;
		end if;
		
		if(WB_MEM_WB='1' and RD_MEM_WB/="00000")then
			if(RD_MEM_WB=RS1_ID_EX and (WB_EX_MEM='0' or RD_EX_MEM/=RS1_ID_EX)) then
				FORWARD_1<="10";
			end if;
			
			if(RD_MEM_WB=RS2_ID_EX and (WB_EX_MEM='0' or RD_EX_MEM/=RS2_ID_EX) and EN_IMM='0') then
				FORWARD_2<="10";
			end if;
		end if;
		
		if(WB_MEM_WB='1' and RD_MEM_WB/="00000")then
			if(RD_EX_MEM=RS1_ID) then
				FORWARD_ID1<='1';
			end if;
			
			if(RD_EX_MEM=RS2_ID) then
				FORWARD_ID1<='1';
			end if;
		end if;
		
	end process;
	
end BEHAVIORAL;