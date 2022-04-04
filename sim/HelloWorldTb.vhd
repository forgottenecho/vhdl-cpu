entity ALUTb is
end entity;

architecture sim of ALUTb is
begin

    process is
    begin

        report "Hello world!";
        wait; -- causes "thread" to wait forever
    end process;
    
end architecture;