library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Sending_data is
    port(
        clk  : in  std_logic;
        --reset: in  std_logic;  Prlm pour les TOPs
        --//reset non utilisé utilisé ici pour éviter des potentiels corruptions et parce que le gain de temps est dérisoire
        instr_in           : in  std_logic_vector(7 downto 0);
        --transmission_enable: in  std_logic; --//Sert à rien (on laisse le TOP s'occuper des timings donc sert à rien)

        scl : inout std_logic;
        sda : inout std_logic;

        all_data_sent : out std_logic;-- Pour Data_conversion
        list_data_full: out std_logic --//Doit forcer TOP-1 à arrrêter l'envoi d'instructions temporairement
    );
end entity;


architecture rtl of Sending_data is

    ---------------------------------------------------------------------
    -- LISTE FIXE 7 OCTETS
    ---------------------------------------------------------------------
    type instr_list is array(0 to 6) of std_logic_vector(7 downto 0);
    signal list : instr_list := (others => (others => '0'));

    ---------------------------------------------------------------------
    -- I2C CLOCK
    ---------------------------------------------------------------------
    signal scl_reg        : std_logic := '1';
    signal scl_prev_delay : std_logic_vector(9 downto 0) := (others=>'1');
    signal scl_rise, scl_fall : std_logic := '0';
    signal div_cnt : unsigned(8 downto 0) := (others => '0');

    -----
    -- Utilities to fill the instr_list
    -----
    signal the_writing_in_the_list_has_to_be_done_once : std_logic := '0';

    ---------------------------------------------------------------------
    -- SDA open drain simple
    ---------------------------------------------------------------------
    signal sda_out : std_logic := '1';

    ---------------------------------------------------------------------
    -- FSM
    ---------------------------------------------------------------------
    type state_t is (WAIT_INSTR, START, INSTR, RW, ACK, STOP_OR_CONTINUE);
    signal state : state_t := WAIT_INSTR;

    signal bit_cnt : integer range 0 to 6 := 6;

    signal wait_for_middle_of_SCL : std_logic := '0';

    ---------------------------------------------------------------------
    -- Nouveau signal pour éviter multi-driver sur list()
    ---------------------------------------------------------------------
    signal shift_list : std_logic := '0';

begin

    ---------------------------------------------------------------------
    -- OUTPUTS
    ---------------------------------------------------------------------
    list_data_full <= '1' when list(6) /= x"00" else '0';
    sda <= '0' when sda_out='0' else 'Z';
    scl <= '0' when scl_reg='0' else 'Z';
    the_writing_in_the_list_has_to_be_done_once <='0'; --Sert pour la transmission des intructions TOP-1 et SendingData

    ---------------------------------------------------------------------
    -- I2C CLOCK with RC delay
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then --//à désactiver à STOP_OR_CONTINUE? et WAIT_INSTR
            if state /= WAIT_INSTR then
                scl_prev_delay <= scl_prev_delay(8 downto 0) & scl_reg; 
                scl_rise <= '0';
                scl_fall <= '0';

                if div_cnt = 249 then --//à changer pour correspondre à 100kHz
                    div_cnt <= (others=>'0');
                    scl_reg <= not scl_reg;
                else
                    div_cnt <= div_cnt + 1;
                end if;

                if scl_prev_delay(9)='0' and scl_reg='1' then scl_rise <= '1'; end if;
                if scl_prev_delay(9)='1' and scl_reg='0' then scl_fall <= '1'; end if;
            end if;
        end if;
    end process;


    ---------------------------------------------------------------------
    -- AJOUT D?INSTRUCTION (unique driver de list)
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            the_writing_in_the_list_has_to_be_done_once <= '0';

            if list(6) = x"00" then --Dans ce cas il reste de la place
                for i in 0 to 6 loop
                    if (list(i) = x"00") and (the_writing_in_the_list_has_to_be_done_once='0') and (instr_in /= x"00") then
                        list(i) <= instr_in;
                        the_writing_in_the_list_has_to_be_done_once <='1';
                    end if;
                end loop;
            end if;
        end if;
    end process;


    ---------------------------------------------------------------------
    -- PROCESS DÉDIÉ AU DÉCALAGE DE LA LISTE (unique driver de list)
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if shift_list = '1' then
                for i in 0 to 5 loop
                    list(i) <= list(i+1);
                end loop;
                list(6) <= x"00";
            end if;

            shift_list <= '0';
        end if;
    end process;



    ---------------------------------------------------------------------
    -- FSM PRINCIPALE
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            case state is

                -----------------------------------------------------------------
                when WAIT_INSTR =>
                -----------------------------------------------------------------
                    all_data_sent <= '0';
                    div_cnt <= (others=>'0');
                    scl_reg <= '1';

                    if list(0) /= x"00" then
                        bit_cnt <= 6;
                        state <= START;
                    end if;


                -----------------------------------------------------------------
                when START =>
                -----------------------------------------------------------------
                    sda_out <= '0';
                    state <= INSTR;


                -----------------------------------------------------------------
                when INSTR =>
                -----------------------------------------------------------------
                    if scl_fall='1' then
                        sda_out <= list(0)(bit_cnt+1);  -- skip MSB

                        if bit_cnt = 0 then
                            state <= RW;
                        else
                            bit_cnt <= bit_cnt - 1;
                        end if;
                    end if;


                -----------------------------------------------------------------
                when RW =>
                -----------------------------------------------------------------
                    if scl_fall='1' then
                        sda_out <= '0';
                        state <= ACK;
                    end if;


                -----------------------------------------------------------------
                when ACK =>
                -----------------------------------------------------------------
                    if scl_fall='1' then
                        state <= STOP_OR_CONTINUE;
                    end if; 


                -----------------------------------------------------------------
                when STOP_OR_CONTINUE =>
                -----------------------------------------------------------------

                    -- CAS CONTINUE
                    if list(1) /= x"00" then
                        bit_cnt <= 5;
                        sda_out <= list(0)(6);
                        state <= INSTR;
                        shift_list <= '1'; -- demande de décalage

                    -- CAS STOP
                    else
                        all_data_sent <= '1';

                        if scl_rise='1' then
                            wait_for_middle_of_SCL<='1';
                        end if;

                        if wait_for_middle_of_SCL='1' and div_cnt=125 then
                            wait_for_middle_of_SCL<='0';
                            shift_list <= '1'; -- consommer dernière instruction
                            sda_out <='0';
                            state <= WAIT_INSTR;
                        end if;
                    end if;

            end case;
        end if;
    end process;

end architecture;
