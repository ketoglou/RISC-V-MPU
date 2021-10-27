library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_misc.nor_reduce;

entity CLA_32_PC_ADD is
	port(
		A,B : in std_logic_vector(31 downto 0);
		S : out std_logic_vector(31 downto 0));
end CLA_32_PC_ADD;

architecture BEHAVIORAL of CLA_32_PC_ADD is
	component FULL_ADDER is
		port(
			A,B,Cin : in std_logic;
			S,Cout : out std_logic);
	end component;
	
	signal GENERATOR : std_logic_vector (31 downto 0);
	signal PROPAGATES : std_logic_vector (31 downto 0);
	signal CARRY : std_logic_vector (31 downto 0);
	signal S2 : std_logic_vector (31 downto 0);
	
begin

	--Generate GEMERATOR and PROPAGATOR bits of every A(i),B(i) addition
	GEN_GEN_PROP: 
   for i in 0 to 31 generate
      GEN :  GENERATOR(i) <= A(i) and B(i);
		PROP : PROPAGATES(i) <= A(i) xor B(i);
   end generate GEN_GEN_PROP;
	
	--Generate CARRY bits
	CARRY(0)<= '0';
	GEN_CAR: 
   for i in 1 to 31 generate
      GENC : CARRY(i) <= GENERATOR(i-1) or (PROPAGATES(i-1) and CARRY(i-1));
   end generate GEN_CAR;
	
	GEN_FADDER: 
   for i in 0 to 30 generate
      FADDERX : FULL_ADDER port map(A=>A(i), B=>B(i), Cin=>CARRY(i), S=>S2(i), Cout=>open);
   end generate GEN_FADDER;
	FADDERX : FULL_ADDER port map(A=>A(31), B=>B(31), Cin=>CARRY(31), S=>S2(31), Cout=>open);
	
	
	S <= S2;
end BEHAVIORAL;