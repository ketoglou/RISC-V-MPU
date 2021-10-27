library IEEE;
use IEEE.std_logic_1164.all;

entity BARREL_SHIFTER is
	port(
		DATA_IN : in std_logic_vector (31 downto 0);
		OPCODE : in std_logic_vector(1 downto 0); --00:SRL,01:SLL,10:SRA,11:SLA
		SHIFT : in std_logic_vector(4 downto 0);
		DATA_OUT : out std_logic_vector (31 downto 0));
end BARREL_SHIFTER;

architecture BEHAVIORAL of BARREL_SHIFTER is
	component MUX2_1 is
		port(
			D0,D1 : in std_logic;
			SEL : in std_logic;
			Y : out std_logic);
	end component;
	
	signal SELECT_R0,SELECT_L0,SELECT_R1,SELECT_L1,SELECT_R2,SELECT_L2,SELECT_R3,SELECT_L3,SELECT_R4,SELECT_L4: std_logic;
	signal L_A: std_logic;
	signal Y0,Y1,Y2,Y3,Y4 : std_logic_vector (31 downto 0);
	signal A0,A1,A2,A3,A4 : std_logic_vector (31 downto 0);
	
begin
	------------------------------------------------------------------------------------------
	--GENERATE CONTROLS
	SELECT_L0<= OPCODE(0) and SHIFT(0);
	SELECT_R0<= (not OPCODE(0)) and SHIFT(0);
	SELECT_L1<= OPCODE(0) and SHIFT(1);
	SELECT_R1<= (not OPCODE(0)) and SHIFT(1);
	SELECT_L2<= OPCODE(0) and SHIFT(2);
	SELECT_R2<= (not OPCODE(0)) and SHIFT(2);
	SELECT_L3<= OPCODE(0) and SHIFT(3);
	SELECT_R3<= (not OPCODE(0)) and SHIFT(3);
	SELECT_L4<= OPCODE(0) and SHIFT(4);
	SELECT_R4<= (not OPCODE(0)) and SHIFT(4);
	
	GEN_MUX2_1_LOG_ARITH : MUX2_1 port map(D0=>'0', D1=>DATA_IN(31), SEL=>OPCODE(1), Y=>L_A );
	------------------------------------------------------------------------------------------
	--LEVEL 4 MUXES, 32 FOR SLL
	LEVEL4_L0: 
   for i in 0 to 15 generate
      GMUX2_1 : MUX2_1 port map(D0=>DATA_IN(i), D1=>L_A, SEL=>SELECT_L4, Y=>Y4(i) );
   end generate LEVEL4_L0;
	
	LEVEL4_L1: 
   for i in 16 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>DATA_IN(i), D1=>DATA_IN(i-16), SEL=>SELECT_L4, Y=>Y4(i) );
   end generate LEVEL4_L1;
	
	--...AND 32 FOR SRL,SRA
	LEVEL4_R0: 
   for i in 0 to 15 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y4(i), D1=>DATA_IN(i+16), SEL=>SELECT_R4, Y=>A4(i) );
   end generate LEVEL4_R0;
	
	LEVEL4_R1: 
   for i in 16 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y4(i), D1=>L_A, SEL=>SELECT_R4, Y=>A4(i) );
   end generate LEVEL4_R1;
	------------------------------------------------------------------------------------------
	--LEVEL 3 MUXES, 32 FOR SLL
	LEVEL3_L0: 
   for i in 0 to 7 generate
      GMUX2_1 : MUX2_1 port map(D0=>A4(i), D1=>L_A, SEL=>SELECT_L3, Y=>Y3(i) );
   end generate LEVEL3_L0;
	
	LEVEL3_L1: 
   for i in 8 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>A4(i), D1=>A4(i-8), SEL=>SELECT_L3, Y=>Y3(i) );
   end generate LEVEL3_L1;
	
	--...AND 32 FOR SRL,SRA
	LEVEL3_R0: 
   for i in 0 to 23 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y3(i), D1=>A4(i+8), SEL=>SELECT_R3, Y=>A3(i) );
   end generate LEVEL3_R0;
	
	LEVEL3_R1: 
   for i in 24 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y3(i), D1=>L_A, SEL=>SELECT_R3, Y=>A3(i) );
   end generate LEVEL3_R1;
	------------------------------------------------------------------------------------------
	--LEVEL 2 MUXES, 32 FOR SLL
	LEVEL2_L0: 
   for i in 0 to 3 generate
      GMUX2_1 : MUX2_1 port map(D0=>A3(i), D1=>L_A, SEL=>SELECT_L2, Y=>Y2(i) );
   end generate LEVEL2_L0;
	
	LEVEL2_L1: 
   for i in 4 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>A3(i), D1=>A3(i-4), SEL=>SELECT_L2, Y=>Y2(i) );
   end generate LEVEL2_L1;
	
	--...AND 32 FOR SRL,SRA
	LEVEL2_R0: 
   for i in 0 to 27 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y2(i), D1=>A3(i+4), SEL=>SELECT_R2, Y=>A2(i) );
   end generate LEVEL2_R0;
	
	LEVEL2_R1: 
   for i in 28 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y2(i), D1=>L_A, SEL=>SELECT_R2, Y=>A2(i) );
   end generate LEVEL2_R1;
	------------------------------------------------------------------------------------------
	--LEVEL 1 MUXES, 32 FOR SLL
	LEVEL1_L0: 
   for i in 0 to 1 generate
      GMUX2_1 : MUX2_1 port map(D0=>A2(i), D1=>L_A, SEL=>SELECT_L1, Y=>Y1(i) );
   end generate LEVEL1_L0;
	
	LEVEL1_L1: 
   for i in 2 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>A2(i), D1=>A2(i-2), SEL=>SELECT_L1, Y=>Y1(i) );
   end generate LEVEL1_L1;
	
	--...AND 32 FOR SRL,SRA
	LEVEL1_R0: 
   for i in 0 to 29 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y1(i), D1=>A2(i+2), SEL=>SELECT_R1, Y=>A1(i) );
   end generate LEVEL1_R0;
	
	LEVEL1_R1: 
   for i in 30 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y1(i), D1=>L_A, SEL=>SELECT_R1, Y=>A1(i) );
   end generate LEVEL1_R1;
	------------------------------------------------------------------------------------------
	--LEVEL 0 MUXES, 32 FOR SLL

   GMUX2_1_L0 : MUX2_1 port map(D0=>A1(0), D1=>L_A, SEL=>SELECT_L0, Y=>Y0(0) );
	
	LEVEL0_L1: 
   for i in 1 to 31 generate
      GMUX2_1 : MUX2_1 port map(D0=>A1(i), D1=>A1(i-1), SEL=>SELECT_L0, Y=>Y0(i) );
   end generate LEVEL0_L1;
	
	--...AND 32 FOR SRL,SRA
	LEVEL0_R0: 
   for i in 0 to 30 generate
      GMUX2_1 : MUX2_1 port map(D0=>Y0(i), D1=>A1(i+1), SEL=>SELECT_R0, Y=>A0(i) );
   end generate LEVEL0_R0;
	
   GMUX2_1_R1 : MUX2_1 port map(D0=>Y0(31), D1=>L_A, SEL=>SELECT_R0, Y=>A0(31) );
	------------------------------------------------------------------------------------------
	
	DATA_OUT<=A0;
	
end BEHAVIORAL;