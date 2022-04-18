library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MainMem is port(
address : in std_logic_vector(15 downto 0);
write_in : in std_logic;
read_in : in std_logic;
clock : in std_logic;
data_in : in std_logic_vector(7 downto 0);
data_out : out std_logic_vector(7 downto 0)

);
end entity;

architecture rtl of MainMem is
    type RamArray is array (0 to (64*1024) - 1) of std_logic_vector(7 downto 0);

    signal RamData: RamArray :=(others=>(others=>'0'));

begin
process(clock)
begin
    if(rising_edge(clock)) then
        if (write_in = '1') then
            RamData(to_integer(unsigned(address))) <= data_in;
        end if;
        if (read_in = '1') then
            data_out <= RamData(to_integer(unsigned(address)));
        else
            data_out <= "XXXXXXXX";
        end if;
    end if;
end process;

    
end architecture;
