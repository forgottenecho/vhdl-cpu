library ieee;
use ieee.std_logic_1164.all;

entity MicrosequencerTb is
end entity;

architecture sim of MicrosequencerTb is
	signal clk : std_logic;
	signal fakeZ : std_logic := '0';
	signal csigs : std_logic_vector(26 downto 0);
	signal fakeIR : std_logic_vector(7 downto 0);
begin
	useq : entity work.Microsequencer(rtl) port map(
		clk => clk,
		zFlag => fakeZ,
		ctrlSignals => csigs,
		IR => fakeIR);
	
	process is
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;
	
	process is
		variable firstTime : integer := 1;
	begin
		-- for first time must wait for NOP->FETCH1 transition
		if firstTime = 1 then
			firstTime := 0;
			wait for 20 ns;
		end if;
		
		fakeIR <= "00001010"; -- INAC (1 state)
		wait for 80 ns;
		
		fakeIR <= "00001011"; -- CLAC (1 state)
		wait for 80 ns;
	end process;
end architecture;	