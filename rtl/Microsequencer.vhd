library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MicroSequencer is
port(
	clk : in std_logic;
	zFlag : in std_logic;
	IR : in std_logic_vector(7 downto 0);
	
	-- see README.md for which bits of ctrlSignals correspond to which control singals
	ctrlSignals : out std_logic_vector(26 downto 0)
);
end entity;

architecture rtl of MicroSequencer is
	signal addrRegister : std_logic_vector(5 downto 0) := "000000";
	signal addrPlusOne : std_logic_vector(5 downto 0);
	signal mapFuncAddr : std_logic_vector(5 downto 0);
	signal condition : std_logic;
	
	-- unused signal, port map unused output bits to this signal
	signal trash : std_logic_vector(1 downto 0);
	
	-- 64x8B ROM for microcode memory, only 36 data bits are used though
	signal dataOut : std_logic_vector(63 downto 0);
	type ROM is array (0 to 63) of std_logic_vector(63 downto 0);
	constant uMem : ROM := (
		--   PADDING      CONTROL SIGNALS                 BT    CSel   ADDR
		0 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- NOP1
		1 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000010", -- FECTH1
		2 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000011", -- FETCH2
		3 => x"0000000" & "000000000000000000000000000" & '1' & "--" & "------", -- FETCH3
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
        40 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- INAC 1
        41 => x"FFFFFFFFFFFFFFFF",
        42 => x"FFFFFFFFFFFFFFFF",
        43 => x"FFFFFFFFFFFFFFFF",
        44 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- CLAC 1
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
			if dataOut(8) = '0' then
				-- BT = 0 means we look at the condition for next addr
				
				if condition = '0' then
					-- do not jump microcode states
					addrRegister <= addrPlusOne;
				elsif condition = '1' then
					-- jump to the microcode state addressed by ADDR
					addrRegister <= dataOut(5 downto 0);
				end if;
			elsif dataOut(8) = '1' then	
				-- BT = 1 means we use the mapping function for next addr
				addrRegister <= mapFuncAddr;
			end if;
			
		end if;
	end process;
	
	-- access ROM when address input changes
	process(addrRegister) is
	begin
		dataOut <= uMem(to_integer(unsigned(addrRegister)));
	end process;
	
	-- perform the mapping function when instruction reg changes
	process(IR) is
	begin
		mapFuncAddr <= IR(3 downto 0) & "00";
	end process;
	
	-- evaluate condition when condition select bits are changed
	process(dataOut(7 downto 6)) is
	begin
		case dataOut(7 downto 6) is
			when "00" => condition <= '1';
			when "01" => condition <= zFlag;
			when "10" => condition <= not zFlag;
			when others => condition <= 'X';
		end case;
	end process;
	
end architecture;
