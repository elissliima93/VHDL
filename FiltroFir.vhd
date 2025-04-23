library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FiltroFIR IS 
    port( 
        clk, Ca1, Ca0, CL : in STD_LOGIC;
        X : in STD_LOGIC_VECTOR (3 DOWNTO 0);
        Y : out STD_LOGIC_VECTOR(7 DOWNTO 0)
       -- cout : out STD_LOGIC
    );
end FiltroFIR;

ARCHITECTURE Behaviour OF FiltroFIR IS
    
    TYPE arrayC IS ARRAY (2 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0); -- Coeficientes (4 bits)
    TYPE arrayM IS ARRAY (2 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- Produtos (8 bits)
    TYPE arrayS IS ARRAY (1 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0); -- Somas (8 bits)
	type shift_array is array(2 downto 0) of std_logic_vector(3 downto 0);--Shift register, para registrar valores anteriores;
	
    signal C : arrayC;
    signal M : arrayM;
    signal S : arrayS;
	signal xreg : shift_array;

	signal sel : STD_LOGIC_VECTOR(1 DOWNTO 0); --- Para substituir no case do primeiro processo~;
	--signal xreg : ARRAY(2 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0); -- Shift register, para registrar valores anteriores;
	
BEGIN

    -- Carregamento dos coeficientes
    PROCESS(CL, Ca1, Ca0, X)
    BEGIN
        IF CL = '1' THEN 
           sel <= Ca1 & Ca0;
           CASE sel IS
                WHEN "00" => 
				C(0) <= X;
                WHEN "01" => 
				C(1) <= X;
                WHEN "10" => 
				C(2) <= X;
                WHEN OTHERS => 
                    C(0) <= (OTHERS => '0');
                    C(1) <= (OTHERS => '0');
                    C(2) <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;


-- Shift register para armazenar x(t), x(t-1), x(t-2)
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            xreg(2) <= xreg(1);
            xreg(1) <= xreg(0);
            xreg(0) <= X;
        END IF;
    END PROCESS;
	
	
    -- Multiplicação
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            M(0) <= std_logic_vector(unsigned(C(0)) * unsigned( xreg(0)));
            M(1) <= std_logic_vector(unsigned(C(1)) * unsigned(xreg(1)));
            M(2) <= std_logic_vector(unsigned(C(2)) * unsigned(xreg(2)));
        END IF;
    END PROCESS;

    -- Soma dos produtos
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            S(0) <= std_logic_vector(unsigned(M(0)) + unsigned(M(1)));
            S(1) <= std_logic_vector(unsigned(S(0)) + unsigned(M(2)));
        END IF;
    END PROCESS;

    -- Saída
    Y <= S(1);

END Behaviour;
