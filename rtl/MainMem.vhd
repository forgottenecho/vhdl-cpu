library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MainMem is port(
address : in std_logic_vector(15 downto 0);
write_en : in std_logic;
read_en : in std_logic;
data_in : in std_logic_vector(7 downto 0);
data_out : out std_logic_vector(7 downto 0)

);
end entity;

architecture rtl of MainMem is
    type RamArray is array (0 to (64*1024) - 1) of std_logic_vector(7 downto 0);

    signal RamData: RamArray :=(others=>(others=>'0'));
    signal is_start : std_logic := '1';

begin

process(address, write_en, read_en, data_in)
begin
    -- initialize memory
    if is_start = '1' then
        is_start <= '0';
		
		-- INSTRUCTIONS
        RamData(0) <= x"0A"; -- INAC
        RamData(1) <= x"00"; -- NOP
        RamData(2) <= x"06"; -- JMPZ
        RamData(3) <= x"33"; -- GAMMA LOW
        RamData(4) <= x"12"; -- GAMMA HIGH
        RamData(5) <= x"0B"; -- CLAC
        RamData(6) <= x"05"; -- JUMP
        RamData(7) <= x"01"; -- GAMMA LOW
        RamData(8) <= x"00"; -- GAMMA HIGH

        RamData(4659) <= x"01"; -- LDAC
        RamData(4660) <= x"EF"; -- GAMMA LOW
        RamData(4661) <= x"BE"; -- GAMMA HIGH
        RamData(4662) <= x"03"; -- MVAC
        RamData(4663) <= x"01"; -- LDAC
        RamData(4664) <= x"AD"; -- GAMMA LOW
        RamData(4665) <= x"DE"; -- GAMMA HIGH
        RamData(4666) <= x"0D"; -- OR
        RamData(4667) <= x"09"; -- SUB
        RamData(4668) <= x"0E"; -- XOR
        RamData(4669) <= x"0C"; -- AND
        RamData(4670) <= x"08"; -- ADD
        RamData(4671) <= x"07"; -- JPNZ
        RamData(4672) <= x"61"; -- GAMMA LOW
        RamData(4673) <= x"68"; -- GAMMA HIGH
        RamData(4674) <= x"0F"; -- NOT
        RamData(4675) <= x"02"; -- STAC
        RamData(4676) <= x"BE"; -- GAMMA LOW
        RamData(4677) <= x"BA"; -- GAMMA HIGH
        RamData(4678) <= x"0B"; -- CLAC
        RamData(4679) <= x"01"; -- LDAC
        RamData(4680) <= x"BE"; -- GAMMA LOW
        RamData(4681) <= x"BA"; -- GAMMA HIGH
		
        RamData(26721) <= x"04"; -- MOVR
        RamData(26722) <= x"01"; -- LDAC
        RamData(26723) <= x"BE"; -- GAMMA LOW
        RamData(26724) <= x"BA"; -- GAMMA HIGH
        RamData(26725) <= x"03"; -- MVAC
        RamData(26726) <= x"05"; -- JUMP
        RamData(26727) <= x"3E"; -- GAMMA LOW
        RamData(26728) <= x"12"; -- GAMMA HIGH
		
		-- DATA
        RamData(47806) <= x"00"; -- JMP 1000
        RamData(48879) <= x"AA"; -- GAMMA LOW
        RamData(57005) <= x"F0"; -- GAMMA HIGH
		
		



        end if;

    if (write_en = '1') then
        RamData(to_integer(unsigned(address))) <= data_in;
    end if;
    if (read_en = '1') then
        data_out <= RamData(to_integer(unsigned(address)));
    else
        data_out <= "XXXXXXXX";
    end if;
end process;

    
end architecture;
