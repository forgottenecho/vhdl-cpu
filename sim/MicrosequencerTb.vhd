library ieee;
use ieee.std_logic_1164.all;

entity MicrosequencerTb is
end entity;

architecture sim of MicrosequencerTb is
	signal clk : std_logic;
	signal z : std_logic := '0';
	signal csigs : std_logic_vector(26 downto 0);
begin
	useq : entity work.Microsequencer(rtl) port map(
		clk => clk,
		zFlag => z,
		ctrlSignals => csigs
	);
	
	process is
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;
end architecture;	