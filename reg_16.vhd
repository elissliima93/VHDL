library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_UNSIGNED.all;

-- implemente em Verilog e em VHDL um registrador de 16 
--bits sensível à borda de descida do clock com reset síncrono. Realize 
--uma simulação comportamental e sintetize o circuito. Analise o 
--esquemático RTL

entity reg_16 is
	Port (
		 clk  : in  STD_LOGIC;
        reset : in  STD_LOGIC;
      --  load  : in  STD_LOGIC_VECTOR(1 downto 0);--enable
        dados : in  STD_LOGIC_VECTOR(15 downto 0);
        q     : out STD_LOGIC_VECTOR(15 downto 0)
	
	);
	end reg_16;
	
ARCHITECTURE behaviour of reg_16 is

begin

	process(reset,clk,dados)
	begin 
	
	if falling_edge(clk) then
		if reset = '1' then
			q<= (others =>'0');
		else 
				q<= dados;
			end if;
		end if;
	
	end process;
	
end behaviour;

	