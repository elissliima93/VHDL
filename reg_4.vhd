library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_UNSIGNED.all;

-- implemente em Verilog e em VHDL um registrador de 4 
--bits com clear e preset assíncronos, sensível a borda de subida do clock. 
-- Na condição de preset o valor "1010" deve ser carregado no registrador.Realize
-- uma simulação comportamental e sintetize o circuito
-- na ausencia de clear e preset, o resgistrador armazena os dados de entrada


entity reg_4 is
    port (
        clk     : in  std_logic;
        clear   : in  std_logic;                     -- reset
        preset  : in  std_logic;                     -- força um valor especifico na saida do reg ou flipflop
        dados   : in  std_logic_vector(3 downto 0);  -- Entrada de dados
        q       : out std_logic_vector(3 downto 0)   -- Saída do registrador
    );
end entity;

architecture behaviour of reg_4 is
    signal q_reg : std_logic_vector(3 downto 0);     --  registrador interno
begin

    -- Atribuição da saída
    q <= q_reg;

    -- Processo com clear e preset assíncronos, devem estar na lista de sensibilidade
    process(clk, clear, preset)
    begin
        -- Clear assíncrono
        if clear = '1' then
            q_reg <= (others => '0');

        -- Preset assíncrono
        elsif preset = '1' then
            q_reg <= "1010";

        -- Sensível à borda de subida do clock
        elsif rising_edge(clk) then
            q_reg <= dados;
        end if;
    end process;
end behaviour;
