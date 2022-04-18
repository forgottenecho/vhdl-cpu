library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity 4x8Ram is port(
address : in std_logic_vector(1 downto 0);
data_in : in std_logic_vector(1 downto 0);
write_in : in std_logic;
clock : in std_logic;
data_out : out std_logic_vector(7 downto 0);

);
end 4x8Ram;

architecture sim of 4x8Ram is
    type RamArray is array (0 to 3) of std_logic_vector(7 downto 0);

    signal RamData: RamArray :=(

    );

begin
process(clock)
begin
    if(rising_edge(clock)) then
        if (write_in = '1') then
            RamData(to_integer(unsigned(address))) <= data_in;
        end if
    end if
end process
end architecture;
