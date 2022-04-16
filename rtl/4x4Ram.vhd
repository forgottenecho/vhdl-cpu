library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity 4x4Ram is port(
address : in std_logic_vector(1 downto 0);
data_in : in std_logic_vector(1 downto 0);
write_in : in std_logic;
clock : in std_logic;
data_out : out std_logic_vector(3 downto 0);

);
end 4x4Ram;

architecture sim of 4x4Ram is
    type RamArray is array (0 to 3) of std_logic_vector(3 downto 0);

    signal RamData: RamArray :=(

    );

    end architecture;
