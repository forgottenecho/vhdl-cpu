library ieee;
use ieee.std_logic_1164.all;

-- this will stay empty because main is not a modular object
-- we define a modular objects "interface" in entity
entity main is
end entity;


architecture sim of main is
	-- here you will define all "signals" to be shared among all processes
	
	signal mainBus : std_logic_vector(15 downto 0);
	
	signal mainClk : std_logic;
	signal mainClk : std_logic;
	signal ctrlSignals : std_logic_vector(26 downto 0);
	
	-- try to group the registers for convenience
	signal AR : std_logic_vector(15 downto 0) := x"00";
	signal PC : std_logic_vector(15 downto 0) := x"00";
	signal Z : std_logic;

	-- for incrementation
	signal ARPlusOne : std_logic_vector(15 downto 0);
	signal PCPlusOne : std_logic_vector(15 downto 0);
	
	-- here you will create instances of all modular objects you are pulling into this file
	entity useq : work.Microsequener(rtl) port map(
		clk => mainClk,
		zFlag => Z,
		ctrlSignals => csigs);
	
	entity addrIncrementer : work.ParaAdder16bit(rtl) port map(
		a => AR,
		b => x"0000",
		cin => '1',
		
		s => ARPlusOne,
		co => open);

	entity PCIncrementer : work.ParaAdder16bit(rtl) port map(
		a => PC,
		b => x"0000",
		cin => '1',
		
		s => PCPlusOne,
		co => open);
	
	-- this is a process, you can think of it as a program thread, it runs concurrently with other processes
	process(clk)
		-- any variables local to the process go here (I usually just use signals, which are global "variables" defined above)
	begin
		if rising_edge(clk) then
			-- on every clock pulse, process the control signals
			-- CONTROL SIGNAL MAPPINGS ARE HERE https://github.com/forgottenecho/vhdl-cpu/blob/main/README.md
			
			-- if ARINC is HIGH, 
			if csigs(0) == '1' then
				AR <= ARPlusOne;
			end if;
			
			-- PCINC
			if csigs(1) == '1' then
				PC <= PCPlusOne;
			end if;
			
			-- ARLOAD
			if csigs(2) == '1' then
				AR <= mainBus;
			end if;
			
			-- PCLOAD
			if csigs(3) == '1' then
				PC <= mainBus;
			end if;
			
			-- HANDLE SIGNALS 4-10!!!
			
			-- DRHBUS
			if csigs(11) == '1' then
				mainBus(15 downto 8) <= DR;
			end if;
				
			-- DRLBUS
			if csigs(12) == '1' then
				mainBus(7 downto 0) <= DR;
			end if;
			
			-- HANDLE SIGNALS 13-19
			
			-- ALU is not a synchronous component, its control sigs are hard wired through port mapping
			
		end if;
	end process;
end architecture;
