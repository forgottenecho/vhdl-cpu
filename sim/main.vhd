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
	signal csigs : std_logic_vector(26 downto 0);
	signal memToBusBuffer : std_logic_vector(7 downto 0);
	signal busToMemBuffer : std_logic_vector(7 downto 0);
	signal ALUOutput : std_logic_vector(7 downto 0);
	
	-- try to group the registers for convenience
	signal AR : std_logic_vector(15 downto 0) := x"0000";
	signal PC : std_logic_vector(15 downto 0) := x"0000";
	signal DR : std_logic_vector(7 downto 0) := x"00";
	signal TR : std_logic_vector(7 downto 0) := x"00";
	signal IR : std_Logic_vector(7 downto 0) := x"00";
	signal R : std_Logic_vector(7 downto 0) := x"00";
	signal AC : std_Logic_vector(7 downto 0) := x"00";
	signal Z : std_logic := '1';

	-- for incrementation
	signal ARPlusOne : std_logic_vector(15 downto 0);
	signal PCPlusOne : std_logic_vector(15 downto 0);

begin
	-- here you will create instances of all modular objects you are pulling into this file
	useq : entity work.Microsequencer(rtl) port map(
		clk => mainClk,
		zFlag => Z,
		IR => IR,
		ctrlSignals => csigs);
	
	addrIncrementer : entity work.ParaAdder16bit(rtl) port map(
		a => AR,
		b => x"0000",
		cin => '1',
		
		s => ARPlusOne,
		co => open);

	PCIncrementer : entity work.ParaAdder16bit(rtl) port map(
		a => PC,
		b => x"0000",
		cin => '1',
		
		s => PCPlusOne,
		co => open);
	
	ALU : entity work.ALU(rtl) port map(
		fromBUS => mainBus(7 downto 0),
		fromAC => AC,
		ALUS => csigs(26 downto 20),
		output => ALUOutput
	);
	
	MEM : entity work.MainMem(rtl) port map(
		address => AR,
		write_en => csigs(19),
		read_en => csigs(18),
		data_in => busToMemBuffer,
		data_out => memToBusBuffer
	);

	-- pulse the main clock
	process is
	begin
		mainClk <= '0';
		wait for 10 ns;
		mainClk <= '1';
		wait for 10 ns;
	end process;

	-- this is a process, you can think of it as a program thread, it runs concurrently with other processes
	process(mainClk)
		-- any variables local to the process go here (I usually just use signals, which are global "variables" defined above)
	begin
		if rising_edge(mainClk) then
			-- on every clock pulse, process the control signals
			-- CONTROL SIGNAL MAPPINGS ARE HERE https://github.com/forgottenecho/vhdl-cpu/blob/main/README.md
			
			-- if ARINC is HIGH, 
			if csigs(0) = '1' then
				AR <= ARPlusOne;
			end if;
			
			-- PCINC
			if csigs(1) = '1' then
				PC <= PCPlusOne;
			end if;
			
			-- ARLOAD
			if csigs(2) = '1' then
				AR <= mainBus;
			end if;
			
			-- PCLOAD
			if csigs(3) = '1' then
				PC <= mainBus;
			end if;
			
			-- HANDLE SIGNALS 4-9!!!
			-- DRLOAD
			if csigs(4) = '1' then
				DR <= mainBus(7 downto 0);
			end if;

			-- TRLOAD
			if csigs(5) = '1' then
				TR <= DR;
			end if;

			-- IRLOAD
			if csigs(6) = '1' then
				IR <= DR;
			end if;

			-- RLOAD
			if csigs(7) = '1' then
				R <= mainBus(7 downto 0);
			end if;

			-- ACLOAD (temp)
			if csigs(8) = '1' then
				AC <= ALUOutput;
			end if;

			-- ZLOAD
			if csigs(9) = '1' then
				Z <= not (ALUOutput(0) or ALUOutput(1) or ALUOutput(2) or ALUOutput(3) or ALUOutput(4) or ALUOutput(5) or ALUOutput(6) or ALUOutput(7));
			end if;
			
			
			-- ALU is not a synchronous component, its control sigs are hard wired through port mapping
			
		end if;

	end process;
	
	-- FIXME clear out unused parts of BUS & "XX"
	process(csigs, memToBusBuffer) is
	begin
		-- clear the bus in case no one uses it this cycle
		mainBus <= "XXXXXXXXXXXXXXXX";
		
		-- PCBUS
		if csigs(10) = '1' then
			mainBus <= PC;
		end if;

		-- DRHBUS
		if csigs(11) = '1' then
			mainBus(15 downto 8) <= DR;
		end if;
			
		-- DRLBUS
		if csigs(12) = '1' then
			mainBus(7 downto 0) <= DR;
		end if;
		
		-- HANDLE SIGNALS 13-19
		-- TRBUS
		if csigs(13) = '1' then
			mainBus(7 downto 0) <= TR;
		end if;

		-- RBUS
		if csigs(14) = '1' then
			mainBus(7 downto 0) <= R;
		end if;

		-- ACBUS
		if csigs(15) = '1' then
			mainBus(7 downto 0) <= AC;
		end if;

		-- MEMBUS
		if csigs(16) = '1' then
			mainBus(7 downto 0) <= memToBusBuffer;
		end if;

		-- BUSMEM
		if csigs(17) = '1' then
			busToMemBuffer <= mainBus(7 downto 0);
		end if;
	end process;
end architecture;
