library ieee;
use ieee.std_logic_1164.all;

entity SIGN_EXTENSION is
	port( 
			INST : in std_logic_vector(31 downto 0);
			IMMEDIATE :out std_logic_vector(31 downto 0));
end SIGN_EXTENSION;

architecture BEHAVIORAL of SIGN_EXTENSION is
	signal IMM: std_logic_vector(31 downto 0);
	signal SIGN: std_logic_vector(19 downto 0);
	signal I_TYPE,S_TYPE,U_TYPE,J_TYPE,B_CSR_TYPE,B_TYPE,CSR_TYPE : std_logic;
begin
	
	GEN_SIGN: 
   for i in 0 to 19 generate
      GEN :  SIGN(i) <= '1' and INST(31);
   end generate GEN_SIGN;
	
	I_TYPE <= ((INST(2) nor INST(3)) and (INST(5) nor INST(6))) or ((INST(2) xor INST(3)) and (INST(5) and INST(6)));
	S_TYPE <= (INST(2) nor INST(3)) and (INST(5) xor INST(6));
	U_TYPE <= ((INST(2) xor INST(3)) and (INST(5) nor INST(6))) or ((INST(2) xor INST(3)) and (INST(5) xor INST(6)));
	J_TYPE <= (INST(2) and INST(3)) and (INST(5) and INST(6));
	B_CSR_TYPE <= (INST(2) nor INST(3)) and (INST(5) and INST(6));
	B_TYPE <= B_CSR_TYPE and not(INST(4));
	CSR_TYPE <= B_CSR_TYPE and INST(4);
	
	seq0 : process(INST,SIGN,I_TYPE,S_TYPE,B_TYPE,U_TYPE,J_TYPE,CSR_TYPE)
	begin
		IMM <= x"00000000";
		if(I_TYPE='1') then
			IMM <= SIGN & INST(31 downto 20);
		elsif(S_TYPE='1') then
			IMM <= SIGN & INST(31 downto 25) & INST(11 downto 7);
		elsif(B_TYPE='1') then
			IMM <= SIGN & INST(7) & INST(30 downto 25) & INST(11 downto 8) & '0';
		elsif(U_TYPE='1') then
			IMM <= INST(31 downto 12) & x"000";
		elsif(J_TYPE='1') then
			IMM <= SIGN(11 downto 0) & INST(19 downto 12) & INST(20) & INST(30 downto 21) & '0';
		elsif(CSR_TYPE='1') then
			IMM <= x"000000" & "000" & INST(19 downto 15);
		end if;
	
	end process;
	
	IMMEDIATE <= IMM;
end BEHAVIORAL;
	