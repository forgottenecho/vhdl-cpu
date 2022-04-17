library ieee;
use ieee.std_logic_1164.all;

entity MicrosequencerTb is
end entity;

architecture sim of MicrosequencerTb is
	signal clk : std_logic;
	signal fakeZ : std_logic := '0'; -- emulating register file's Z register
	signal csigs : std_logic_vector(26 downto 0); -- control signals from usequencer
	signal fakeIR : std_logic_vector(7 downto 0); -- fake instruction register
begin

	useq : entity work.Microsequencer(rtl) port map(
		clk => clk,
		zFlag => fakeZ,
		ctrlSignals => csigs,
		IR => fakeIR);
	
	-- 20 ns clock cycle
	process is
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;
	
	process is
		-- used to detect if the process is in its first loop
		variable firstTime : integer := 1;
	begin
		-- for first time must wait for NOP->FETCH1 transition
		if firstTime = 1 then
			firstTime := 0;
			wait for 20 ns;
		end if;
		
		-- every type of instr must wait 60 ns for FETCH1-3
		
		--fakeIR <= "00001010"; -- INAC (1 state)
		--wait for 80 ns;
		
		--fakeIR <= "00001011"; -- CLAC (1 state)
		--wait for 80 ns;
		
		--fakeIR <= "00000101"; -- JUMP (3 states)
		--wait for 120 ns;
		
		--fakeIR <= "00000110"; -- JMPZ w/ Z=1 (4 states)
		--fakeZ <= '1';
		--wait for 140 ns;
		
		--fakeIR <= "00000110"; -- JMPZ w/ Z=0 (3 states)
		--fakeZ <= '0';
		--wait for 120 ns;
		
		--fakeIR <= "00000111"; -- JPNZ w/ Z=1 (3 states), should perform microcode STATE jump but not PC jump
		--fakeZ <= '1';
		--wait for 120 ns;
		
		--fakeIR <= "00000111"; -- JPNZ w/ Z=0 (4 states), should NOT perform ucode STATE jump but should --perform PC jump
		--fakeZ <= '0';
		--wait for 140 ns;
		
		--fakeIR <= "00000001"; -- LDAC (5 states)
        --wait for 160 ns;
		
        --fakeIR <= "00000010"; -- STAC (5 states)
        --wait for 160 ns;

        --fakeIR <= "00000011"; -- MVAC (1 states)
        --wait for 80 ns;

        --fakeIR <= "00000100"; -- MOVR (1 states)
        --wait for 80 ns;

        fakeIR <= "00001000"; -- ADD (1 states)
        wait for 80 ns;
		
        fakeIR <= "00001001"; -- SUB (1 states)
        wait for 80 ns;		
		
        fakeIR <= "00001100"; -- AND (1 states)
        wait for 80 ns;

        fakeIR <= "00001101"; -- OR (1 states)
        wait for 80 ns;

        fakeIR <= "00001110"; -- XOR (1 states)
        wait for 80 ns;
		
        fakeIR <= "00001111"; -- NOT (1 states)
        wait for 80 ns;
		
	end process;
end architecture;	