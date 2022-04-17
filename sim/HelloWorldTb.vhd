-- this file was used for learning about VHDL
entity HelloWorldTb is
end entity;

architecture sim of HelloWorldTb is
begin

    process is
    begin

        report "Hello world!";
        wait; -- causes "thread" to wait forever
    end process;
    
end architecture;