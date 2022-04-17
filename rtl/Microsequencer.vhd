library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MicroSequencer is
port(
	clk : in std_logic;
	zFlag : in std_logic; -- from register file
	IR : in std_logic_vector(7 downto 0); -- instruciton register, used in FETCH3's mapped ucode jump
	
	-- see README.md for which bits of ctrlSignals correspond to which control singals
	ctrlSignals : out std_logic_vector(26 downto 0)
);
end entity;

architecture rtl of MicroSequencer is
	-- addressing signals
	signal addrRegister : std_logic_vector(5 downto 0) := "000000";
	signal addrPlusOne : std_logic_vector(5 downto 0);
	signal mapFuncAddr : std_logic_vector(5 downto 0);
	signal condition : std_logic;
	
	-- unused signal, port map unused output bits to this signal
	signal trash : std_logic_vector(1 downto 0);
	
	-- 64x8B ROM for microcode memory, only 36 data bits are used, not all 64 locations are used either
	signal dataOut : std_logic_vector(63 downto 0);
	type ROM is array (0 to 63) of std_logic_vector(63 downto 0);
	constant uMem : ROM := (
		--   PADDING      CONTROL SIGNALS                 BT    CSel   ADDR
		0 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- NOP1
		1 => x"0000000" & "000000000000000010000000100" & '0' & "00" & "000010", -- FECTH1
		2 => x"0000000" & "000000000010000000000010010" & '0' & "00" & "000011", -- FETCH2
		3 => x"0000000" & "000000000000001000001000000" & '0' & "00" & "001110", -- FETCH3
        4 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000101", -- LDAC1
        5 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000110", -- LDAC2
        6 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000111", -- LDAC3
        7 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "100001", -- LDAC4
        8 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "001001", -- STAC1
        9 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "001010", -- STAC2
        10 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "001011", -- STAC3
        11 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "100010", -- STAC4
        12 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- MVAC1
        13 => x"FFFFFFFFFFFFFFFF",
        14 => x"0000000" & "000000000000000010000000100" & '1' & "--" & "------", -- FETCH4
        15 => x"FFFFFFFFFFFFFFFF",
        16 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- MOVR1
        17 => x"FFFFFFFFFFFFFFFF",
        18 => x"FFFFFFFFFFFFFFFF",
        19 => x"FFFFFFFFFFFFFFFF",
        20 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "010101", -- JUMP1
        21 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "010110", -- JUMP2
        22 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- JUMP3
        23 => x"FFFFFFFFFFFFFFFF",
        24 => x"0000000" & "000000000000000000000000000" & '0' & "10" & "101001", -- JMPZ1
        25 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "011010", -- JMPZY1
        26 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "011011", -- JMPZY2
        27 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- JMPZY3
        28 => x"0000000" & "000000000000000000000000000" & '0' & "01" & "101101", -- JPNZ1
        29 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "011110", -- JPNZY1
        30 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "011111", -- JPNZY2
        31 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- JPNZY3
        32 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- ADD1
        33 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- LDAC5
        34 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- STAC5
        35 => x"FFFFFFFFFFFFFFFF",
        36 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- SUB1
        37 => x"FFFFFFFFFFFFFFFF",
        38 => x"FFFFFFFFFFFFFFFF",
        39 => x"FFFFFFFFFFFFFFFF",
        40 => x"0000000" & "0XX100100000000000100000000" & '0' & "00" & "000001", -- INAC1
        41 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "101010", -- JMPZN1
        42 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- JMPZN2
        43 => x"FFFFFFFFFFFFFFFF",
        44 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- CLAC1
        45 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "101110", -- JPNZN1
        46 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- JPNZN2
        47 => x"FFFFFFFFFFFFFFFF",
        48 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- AND1
        49 => x"FFFFFFFFFFFFFFFF",
        50 => x"FFFFFFFFFFFFFFFF",
        51 => x"FFFFFFFFFFFFFFFF",
        52 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- OR1
        53 => x"FFFFFFFFFFFFFFFF",
        54 => x"FFFFFFFFFFFFFFFF",
        55 => x"FFFFFFFFFFFFFFFF",
        56 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- XOR1
        57 => x"FFFFFFFFFFFFFFFF",
        58 => x"FFFFFFFFFFFFFFFF",
        59 => x"FFFFFFFFFFFFFFFF",
        60 => x"0000000" & "000000000000000000000000000" & '0' & "00" & "000001", -- NOT1
        61 => x"FFFFFFFFFFFFFFFF",
        62 => x"FFFFFFFFFFFFFFFF",
        63 => x"FFFFFFFFFFFFFFFF");
begin

	-- generates the current address plus one
	plusOne : entity work.ParaAdder8bit(rtl) port map(
		a(7 downto 6) => "00",
		a(5 downto 0) => addrRegister,
		b => x"00",
		cin => '1',
		
		s(7 downto 6) => trash,
		s(5 downto 0) => addrPlusOne, -- will overflow to 000000
		co => open);
	
	-- latch correct address in the the address register
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
	
	-- access ROM location specified by the address
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
			when "00" => condition <= '1'; -- unconditional ucode jump
			when "01" => condition <= zFlag; -- ucode jump when Z==1
			when "10" => condition <= not zFlag; -- ucode jump when Z==0
			when others => condition <= 'X';
		end case;
	end process;
	
end architecture;
