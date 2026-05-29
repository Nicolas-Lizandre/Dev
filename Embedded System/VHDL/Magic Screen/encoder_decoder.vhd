library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder_decoder is
    generic (
        COUNTER_WIDTH : positive := 10;     -- Largeur du compteur
        INITIAL_VALUE : integer  := 0;      -- Valeur au reset
        SAMPLE_PERIOD : positive := 270000  -- Période d'échantillonnage (~100Hz pour un clk de 27MHz)
    );
    port (
        -- Entrées
        i_clk   : in  std_logic;
        i_rst_n : in  std_logic;
        i_ch_a  : in  std_logic;
        i_ch_b  : in  std_logic;
        
        -- Sortie
        o_count : out signed(COUNTER_WIDTH - 1 downto 0)
    );
end entity encoder_decoder;

architecture rtl of encoder_decoder is
    -- Signaux internes
    signal r_count      : signed(COUNTER_WIDTH - 1 downto 0);
    signal r_sample_clk : natural range 0 to SAMPLE_PERIOD - 1;
    signal r_a_prev     : std_logic;
    signal r_b_prev     : std_logic;
begin

    process(i_clk, i_rst_n)
    begin
        if i_rst_n = '0' then
            -- Initialisation au reset
            r_count      <= to_signed(INITIAL_VALUE, COUNTER_WIDTH);
            r_sample_clk <= 0;
            r_a_prev     <= '0';
            r_b_prev     <= '0';
        elsif rising_edge(i_clk) then
            -- Compteur pour l'échantillonnage lent
            if r_sample_clk = SAMPLE_PERIOD - 1 then
                r_sample_clk <= 0;
            else
                r_sample_clk <= r_sample_clk + 1;
            end if;

            -- Échantillonnage et décodage à la fin de la période
            if r_sample_clk = SAMPLE_PERIOD - 1 then
                -- Logique de décodage de quadrature correcte
                -- On regarde si A a changé, et on regarde la valeur de B pour le sens
                if i_ch_a /= r_a_prev then
                    if r_a_prev = i_ch_b then
                        -- Décrémenter
                        r_count <= r_count - 1;
                    else
                        -- Incrémenter
                        r_count <= r_count + 1;
                    end if;
                end if;

                -- Mémoriser l'état actuel pour la prochaine comparaison
                r_a_prev <= i_ch_a;
                r_b_prev <= i_ch_b;
            end if;
        end if;
    end process;

    -- Assignation de la sortie
    o_count <= r_count;

end architecture rtl;