library ieee;
use ieee.std_logic_1164.all;


entity MicroSequencer is
port(
	clk : in std_logic;
	
	-- see README.md for which bits of ctrlSignals correspond to which control singals
	ctrlSignals : out std_logic_vector(26 downto 0)
);
end entity;

architecture rtl of MicroSequencer is
	signal addrRegister : std_logic_vector(6 downto 0);
	signal nextAddr: std_logic_vector(6 downto 0);
	
	-- 64x8B ROM for microcode memory, only 36 bits are used though
	type uMem is array (0 to 63) of std_logic_vector(64 downto 0);
begin
	-- select the next address for uMem
	addrMUX : entity work.MUX4to1(rtl) port map(
		-- gets current addr plus one
		a(7 downto 6) => open,
		a(5 downto 0) => addPlusOne,
		
		-- gets addr from uMem
		b(7 downto 6) => open,
		b(5 downto 0) => ,
		
		-- gets addr from mapping hardware
		c(7 downto 6) => open,
		c(5 downto 0) => ,
		
		-- unused
		d => open,
		
		sel => ,
		
		y(7 downto 6) => open,
		y(5 downto 0) => nextAddr);
	
	condMUX : entity work.MUX4to1(rtl) port map(
	)
	process(clk) is
		if rising_edge(clk) then
			-- perform register transfer, its the only synchronous component
			addrRegister <= nextAddr;
		end if;
	begin
	end process;
	
	process(addrRegister) is
	begin
		
	end process;
	
end architecture;
