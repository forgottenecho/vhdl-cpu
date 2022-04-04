-- library section
library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
port(
    -- inputs
    fromDR : in std_logic_vector (7 downto 0);
    fromAC : in std_logic_vector (7 downto 0);

    -- outputs
    output : out std_logic_vector (7 downto 0) -- last dec doesn't have semicolon

);
end entity;

architecture rtl of ALU is 
begin

    process(fromDR, fromAC) is

    -- for now, ALU is just ANDing the two inputs
    -- FIXME implement the whole ALU!
    begin
        -- output <= fromDR and fromAC;
        output <= fromDR and fromAC;
    end process;
end architecture;
