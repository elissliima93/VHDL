library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_UNSIGNED.all;

-- implemente em Verilog e em VHDL um registrador de 4 
--bits com clear e preset ass�ncronos, sens�vel a borda de subida do clock. 
-- Na condi��o de preset o valor "1010" deve ser carregado no registrador.Realize
-- uma simula��o comportamental e sintetize o circuito
-- na ausencia de clear e preset, o resgistrador armazena os dados de entrada


entity reg_4 is
    port (
        clk     : in  std_logic;
        clear   : in  std_logic;                     -- reset
        preset  : in  std_logic;                     -- for�a um valor especifico na saida do reg ou flipflop
        dados   : in  std_logic_vector(3 downto 0);  -- Entrada de dados
        q       : out std_logic_vector(3 downto 0)   -- Sa�da do registrador
    );
end entity;

architecture behaviour of reg_4 is
    signal q_reg : std_logic_vector(3 downto 0);     --  registrador interno
begin

    -- Atribui��o da sa�da
    q <= q_reg;

    -- Processo com clear e preset ass�ncronos, devem estar na lista de sensibilidade
    process(clk, clear, preset)
    begin
        -- Clear ass�ncrono
        if clear = '1' then
            q_reg <= (others => '0');

        -- Preset ass�ncrono
        elsif preset = '1' then
            q_reg <= "1010";

        -- Sens�vel � borda de subida do clock
        elsif rising_edge(clk) then
            q_reg <= dados;
        end if;
    end process;
end behaviour;
