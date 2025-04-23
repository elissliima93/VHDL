library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FiltroFIR is
end entity;

architecture sim of tb_FiltroFIR is

    -- Declaração do componente DUT (Device Under Test)
    component FiltroFIR is
        port(
            clk : in std_logic;
            Ca1 : in std_logic;
            Ca0 : in std_logic;
            CL  : in std_logic;
            X   : in std_logic_vector(3 downto 0);
            Y   : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Sinais para interligar com o DUT
    signal clk_sig  : std_logic := '0';
    signal Ca1_sig  : std_logic := '0';
    signal Ca0_sig  : std_logic := '0';
    signal CL_sig   : std_logic := '0';
    signal X_sig    : std_logic_vector(3 downto 0) := (others => '0');
    signal Y_sig    : std_logic_vector(7 downto 0);

    -- Período do clock
    constant clk_period : time := 10 ns;

begin

    -- Instanciação do DUT
    DUT: FiltroFIR
        port map (
            clk => clk_sig,
            Ca1 => Ca1_sig,
            Ca0 => Ca0_sig,
            CL  => CL_sig,
            X   => X_sig,
            Y   => Y_sig
        );

    -- Processo para geração do clock (10 ns de período)
    clk_gen: process
    begin
        while now < 500 ns loop
            clk_sig <= '0';
            wait for clk_period / 2;
            clk_sig <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo de estímulo
    stim_proc: process
    begin
        -- Carregar coeficientes através do mecanismo de CL:
        -- Supondo: C(0) = 2  ("0010"),  C(1) = 1 ("0001"),  C(2) = 3 ("0011")
        CL_sig <= '1';
        
        X_sig   <= "0010";  -- Carrega coeficiente C(0)=2
        Ca1_sig <= '0';     -- Seleciona posição 0 (sel = "00")
        Ca0_sig <= '0';
        wait for clk_period;
        
        X_sig   <= "0001";  -- Carrega coeficiente C(1)=1
        Ca1_sig <= '0';     -- Seleciona posição 1 (sel = "01")
        Ca0_sig <= '1';
        wait for clk_period;
        
        X_sig   <= "0011";  -- Carrega coeficiente C(2)=3
        Ca1_sig <= '1';     -- Seleciona posição 2 (sel = "10")
        Ca0_sig <= '0';
        wait for clk_period;
        
        CL_sig <= '0';  -- Finaliza o carregamento dos coeficientes
        wait for clk_period;

        -- Aplicar sequência de amostras em X
        -- Sequência de entrada: x(t)=1, x(t)=2, x(t)=1, x(t)=3
        X_sig <= "0001";  -- 1
        wait for clk_period;
        X_sig <= "0010";  -- 2
        wait for clk_period;
        X_sig <= "0001";  -- 1
        wait for clk_period;
        X_sig <= "0011";  -- 3
        wait for clk_period;

        wait for 50 ns;
        wait;  -- Finaliza a simulação
    end process;

end architecture;
