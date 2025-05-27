
library ieee;
use ieee.std_logic_1164.all;

entity tb_reg_4 is
end tb_reg_4;

architecture test of tb_reg_4 is

    -- Sinais para interligar com o DUT (Device Under Test)
    signal clk    : std_logic := '0';
    signal clear  : std_logic := '0';
    signal preset : std_logic := '0';
    signal dados  : std_logic_vector(3 downto 0) := (others => '0');
    signal q      : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instanciação do componente reg_4
    uut: entity work.reg_4
        port map (
            clk     => clk,
            clear   => clear,
            preset  => preset,
            dados   => dados,
            q       => q
        );

    -- Geração de clock
    clk_process: process
    begin
        while now < 150 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo de estímulo
    stim_proc: process
    begin
        -- Aguarda um pouco e aplica clear
        wait for 5 ns;
        clear <= '1';
        wait for 10 ns;       -- Deve forçar q = "0000"
        clear <= '0';

        -- Aplica preset
        wait for 10 ns;
        preset <= '1';
        wait for 10 ns;       -- Deve forçar q = "1010"
        preset <= '0';

        -- Aplicação de dados com clock
        wait for 10 ns;
        dados <= "1100";      -- Deve ser armazenado na próxima borda de subida do clock
        wait for clk_period;

        dados <= "0011";      -- Novo valor para testar outra borda
        wait for clk_period;

        -- Aplica clear novamente no meio do clock
        wait for 2 ns;
        clear <= '1';
        wait for 8 ns;
        clear <= '0';

        -- Aplica novo dado para ver se armazena corretamente depois do clear
        dados <= "1111";
        wait for clk_period;

        wait;
    end process;

end architecture;
