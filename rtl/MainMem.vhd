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
        RamData(0) <= x"0A"; -- INAC
        RamData(1) <= x"00"; -- NOP
        RamData(2) <= x"0A"; -- INAC
        RamData(3) <= x"00"; -- NOP
        RamData(4) <= x"0A"; -- INAC
        RamData(5) <= x"0A"; -- INAC
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
