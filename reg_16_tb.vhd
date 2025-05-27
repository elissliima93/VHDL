
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

	COMPONENT reg_16
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		dados : IN std_logic_vector(15 downto 0);          
		q : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	SIGNAL clk :  std_logic:='1';
	SIGNAL reset :  std_logic:='0';
	SIGNAL dados :  std_logic_vector(15 downto 0):= (others => '0');
	SIGNAL q :  std_logic_vector(15 downto 0);


    constant clk_period : time := 10 ns;
	
BEGIN

-- Please check and add your generic clause manually
	uut: reg_16 PORT MAP(
		clk => clk,
		reset => reset,
		dados => dados,
		q => q
	);

-- Geração do clock
    clk_process: process
    begin
        while now < 200 ns loop
            clk <= '1';
            wait for clk_period / 2;
            clk <= '0';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   wait for 15 ns;
        reset <= '1';                       -- Aplica reset na borda de descida (em 20ns)
        wait for clk_period;
        reset <= '0';                       -- Libera reset

        -- Aplica valor 1
        wait for clk_period;               -- Borda de descida em 40ns
        dados <= "0001001000110100";       -- 0x1234

        wait for clk_period;               -- Borda de descida em 50ns
        dados <= "1010101111001101";       -- 0xABCD

        wait for clk_period;               -- Borda de descida em 60ns
        dados <= "1111111111111111";       -- 0xFFFF

        wait for clk_period;               -- Borda de descida em 70ns
        reset <= '1';                      -- Reset
        wait for clk_period;               -- Borda de descida em 80ns
        reset <= '0';

        wait for clk_period;               -- Borda de descida em 90ns
        dados <= "0101010101010101";       -- 0x5555

        wait for clk_period;
        wait;
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
