library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MicroSequencer is
port(
	clk : in std_logic;
	z_flag : in std_logic;
	
	-- see README.md for which bits of ctrlSignals correspond to which control singals
	ctrlSignals : out std_logic_vector(26 downto 0)
);
end entity;

architecture rtl of MicroSequencer is
	signal addrRegister : std_logic_vector(5 downto 0) := "000000";
	signal addrPlusOne : std_logic_vector(5 downto 0);
	signal nextAddr : std_logic_vector(5 downto 0);
	
	-- unused signal, port map unused output bits to this signal
	signal trash : std_logic_vector(1 downto 0);
	
	-- 64x8B ROM for microcode memory, only 36 data bits are used though
	signal dataOut : std_logic_vector(63 downto 0);
	type ROM is array (0 to 63) of std_logic_vector(63 downto 0);
	constant uMem : ROM := (
		0 => x"0000000" & "000000000000000000000000000" & '1' & "00" & "000001", -- NOP1
		1 => x"0000000" & "000000000000000000000000000" & '1' & "00" & "000010", -- FECTH1
		2 => x"0000000" & "000000000000000000000000000" & '1' & "00" & "000011", -- FETCH2
		3 => x"0000000" & "000000000000000000000000000" & '1' & "00" & "000001", -- FETCH3
        4 => x"FFFFFFFFFFFFFFFF",
        5 => x"FFFFFFFFFFFFFFFF",
        6 => x"FFFFFFFFFFFFFFFF",
        7 => x"FFFFFFFFFFFFFFFF",
        8 => x"FFFFFFFFFFFFFFFF",
        9 => x"FFFFFFFFFFFFFFFF",
        10 => x"FFFFFFFFFFFFFFFF",
        11 => x"FFFFFFFFFFFFFFFF",
        12 => x"FFFFFFFFFFFFFFFF",
        13 => x"FFFFFFFFFFFFFFFF",
        14 => x"FFFFFFFFFFFFFFFF",
        15 => x"FFFFFFFFFFFFFFFF",
        16 => x"FFFFFFFFFFFFFFFF",
        17 => x"FFFFFFFFFFFFFFFF",
        18 => x"FFFFFFFFFFFFFFFF",
        19 => x"FFFFFFFFFFFFFFFF",
        20 => x"FFFFFFFFFFFFFFFF",
        21 => x"FFFFFFFFFFFFFFFF",
        22 => x"FFFFFFFFFFFFFFFF",
        23 => x"FFFFFFFFFFFFFFFF",
        24 => x"FFFFFFFFFFFFFFFF",
        25 => x"FFFFFFFFFFFFFFFF",
        26 => x"FFFFFFFFFFFFFFFF",
        27 => x"FFFFFFFFFFFFFFFF",
        28 => x"FFFFFFFFFFFFFFFF",
        29 => x"FFFFFFFFFFFFFFFF",
        30 => x"FFFFFFFFFFFFFFFF",
        31 => x"FFFFFFFFFFFFFFFF",
        32 => x"FFFFFFFFFFFFFFFF",
        33 => x"FFFFFFFFFFFFFFFF",
        34 => x"FFFFFFFFFFFFFFFF",
        35 => x"FFFFFFFFFFFFFFFF",
        36 => x"FFFFFFFFFFFFFFFF",
        37 => x"FFFFFFFFFFFFFFFF",
        38 => x"FFFFFFFFFFFFFFFF",
        39 => x"FFFFFFFFFFFFFFFF",
        40 => x"FFFFFFFFFFFFFFFF",
        41 => x"FFFFFFFFFFFFFFFF",
        42 => x"FFFFFFFFFFFFFFFF",
        43 => x"FFFFFFFFFFFFFFFF",
        44 => x"FFFFFFFFFFFFFFFF",
        45 => x"FFFFFFFFFFFFFFFF",
        46 => x"FFFFFFFFFFFFFFFF",
        47 => x"FFFFFFFFFFFFFFFF",
        48 => x"FFFFFFFFFFFFFFFF",
        49 => x"FFFFFFFFFFFFFFFF",
        50 => x"FFFFFFFFFFFFFFFF",
        51 => x"FFFFFFFFFFFFFFFF",
        52 => x"FFFFFFFFFFFFFFFF",
        53 => x"FFFFFFFFFFFFFFFF",
        54 => x"FFFFFFFFFFFFFFFF",
        55 => x"FFFFFFFFFFFFFFFF",
        56 => x"FFFFFFFFFFFFFFFF",
        57 => x"FFFFFFFFFFFFFFFF",
        58 => x"FFFFFFFFFFFFFFFF",
        59 => x"FFFFFFFFFFFFFFFF",
        60 => x"FFFFFFFFFFFFFFFF",
        61 => x"FFFFFFFFFFFFFFFF",
        62 => x"FFFFFFFFFFFFFFFF",
        63 => x"FFFFFFFFFFFFFFFF");
begin
	-- select the next address for uMem
	addrMUX : entity work.MUX4to1(rtl) port map(
		-- gets current addr plus one
		a(7 downto 6) => "XX",
		a(5 downto 0) => addrPlusOne,
		
		-- gets addr from uMem
		b(7 downto 6) => "XX",
		b(5 downto 0) => dataOut(5 downto 0),
		
		-- gets addr from mapping hardware
		c(7 downto 6) => "XX",
		c(5 downto 0) => "XXXXXX", -- FIXME
		
		-- unused
		d => "XXXXXXXX",
		
		sel => "01", -- FIXME
		
		y(7 downto 6) => trash, -- unused
		y(5 downto 0) => nextAddr);
	
	--condMUX : entity work.MUX4to1(rtl) port map(
	--);
	
	plusOne : entity work.ParaAdder8bit(rtl) port map(
		a(7 downto 6) => "00",
		a(5 downto 0) => addrRegister,
		b => x"00",
		cin => '1',
		
		s(7 downto 6) => trash,
		s(5 downto 0) => addrPlusOne, -- will overflow to 000000
		co => open);
	
	process(clk) is
	begin
		if rising_edge(clk) then
			-- perform register transfer, its the only synchronous component
			addrRegister <= nextAddr;
		end if;
	end process;
	
	process(addrRegister) is
	begin
		-- acces the ROM
		dataOut <= uMem(to_integer(unsigned(addrRegister)));
		
		
	end process;
	
end architecture;
