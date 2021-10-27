library IEEE;
use IEEE.std_logic_1164.all;

entity CLA_32 is
	port(
		A,B : in std_logic_vector(31 downto 0);
		OP : in std_logic; --ADD=0,SUB=1
		S : out std_logic_vector(31 downto 0);
		COUT,OVERFLOW : out std_logic);
end CLA_32;

architecture BEHAVIORAL of CLA_32 is
	component FULL_ADDER is
		port(
			A,B,Cin : in std_logic;
			S,Cout : out std_logic);
	end component;
	
	signal GENERATOR : std_logic_vector (31 downto 0);
	signal PROPAGATES : std_logic_vector (31 downto 0);
	signal CARRY : std_logic_vector (31 downto 0);
	signal S2 : std_logic_vector (31 downto 0);
	signal B2 : std_logic_vector(31 downto 0);
	signal COUT2 : std_logic;
	
begin

	--Generate GEMERATOR and PROPAGATOR bits of every A(i),B(i) addition
	GEN_GEN_PROP: 
   for i in 0 to 31 generate
      GEN :  GENERATOR(i) <= A(i) and B2(i);
		PROP : PROPAGATES(i) <= A(i) xor B2(i);
   end generate GEN_GEN_PROP;
	
	--Generate CARRY bits
	GEN_CAR: 
   for i in 1 to 31 generate
      GENC : CARRY(i) <= GENERATOR(i-1) or (PROPAGATES(i-1) and CARRY(i-1));
   end generate GEN_CAR;
	
	GEN_FADDER: 
   for i in 0 to 30 generate
      FADDERX : FULL_ADDER port map(A=>A(i), B=>B2(i), Cin=>CARRY(i), S=>S2(i), Cout=>open);
   end generate GEN_FADDER;
	FADDERX : FULL_ADDER port map(A=>A(31), B=>B2(31), Cin=>CARRY(31), S=>S2(31), Cout=>COUT2);
	
	PR : process (A,B,OP)
	begin
		if(OP='0') then
			CARRY(0)<= '0';
			B2<=B;
		else
			CARRY(0)<= '1';
			B2<= not B;
		end if;
	end process;
	
	S <= S2;
	COUT <= COUT2;
	OVERFLOW <= COUT2 xor CARRY(31);
end BEHAVIORAL;