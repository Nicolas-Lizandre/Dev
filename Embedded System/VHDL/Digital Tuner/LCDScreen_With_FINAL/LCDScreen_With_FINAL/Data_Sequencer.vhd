library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Sequenceur is
    port(
        clk   : in std_logic;
        reset : in std_logic;  -- Reset NE s?active que dans Mode_Idle

        -- Unique sortie vers Sending_data
        instr_in : out std_logic_vector(7 downto 0);

        -- En provenance de Sending_data
        list_data_full : in std_logic;
        all_data_sent  : in std_logic;

        -- En provenance de Data_Conversion (et retour d?�tat)
        list_data_full_forDC : out std_logic;
        instr_tasks          : in std_logic_vector(7 downto 0);
        --instr_tasks_enable : in std_logic; --//Sert � quelle chose ?

        -- Debug
        reset_request_to_top : out std_logic
    );
end entity;



architecture rtl of Data_Sequenceur is

    ---------------------------------------------------------------------
    -- ETATS
    ---------------------------------------------------------------------
    type state_t is (
        Mode_Reset,
        Mode_Startup,
        Mode_Working,
        Mode_Idle
    );
    signal state : state_t := Mode_Reset;

    ---------------------------------------------------------------------
    -- LISTE INIT SEULE (les seules donn�es internes)
    ---------------------------------------------------------------------
    type init_array is array(0 to 15) of std_logic_vector(7 downto 0);

    constant init_list : init_array :=
    (
        
        x"38", x"39", x"14", x"70",
        x"56", x"6C", x"FE",       -- FE = d�lai 200ms
        x"38", x"0C",
        x"01", x"FF",             -- FF = d�lai 4ms
        x"06",
        others => x"00"
    ); -----//////Rajouter un d�lai de 40us

    -- I2C_ADDR   = 0x7C  (adresse LCD << 1)
    -- CTRL_BYTE  = 0x80  (RS=0, Co=1 ? envoi d?une commande)
    -- DATA       = instruction LCD

    signal init_index : integer range 0 to 15 := 0;

    ---------------------------------------------------------------------
    -- Compteurs d�lais
    ---------------------------------------------------------------------
    signal ms4_cnt     : natural := 0;
    signal ms200_cnt   : natural := 0;
    signal startup_cnt : natural := 0;
    signal idle_count  : natural := 0;

    constant SEUIL_4ms           : natural := 100_000; -- 1 coups = 40ns
    constant SEUIL_200ms         : natural := 5_000_000;
    constant SEUIL_startup_delay : natural := 2_500_000;
    constant SEUIL_idle          : natural := 200_000;

    ---------------------------------------------------------------------
    -- Gestion des triplets et d�lais inter-triplets (~40us)
    ---------------------------------------------------------------------
    signal phase_instr : natural range 0 to 2 := 0;  -- 0=7C, 1=80, 2=DATA

    signal cnt_40us                 : natural := 0;
    constant SEUIL_40us             : natural := 1_000;  -- marge volontaire
    signal wait_between_trip        : std_logic := '0';
    signal activate_wait_between_trip : std_logic := '0';

    ---------------------------------------------------------------------
    -- m�morisation
    ---------------------------------------------------------------------
    signal instr_prev : std_logic_vector(7 downto 0) := (others=>'0');

begin
    list_data_full_forDC <= list_data_full;

    ---------------------------------------------------------------------
    -- FSM PRINCIPALE
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            case state is

                -----------------------------------------------------------------
                -- MODE RESET
                -----------------------------------------------------------------
                when Mode_Reset =>
                    init_index  <= 0;
                    ms4_cnt     <= 0;
                    ms200_cnt   <= 0;
                    startup_cnt <= 0;
                    idle_count  <= 0;
                    cnt_40us    <= 0;

                    phase_instr <= 0;
                    wait_between_trip <= '0';
                    activate_wait_between_trip <= '0';

                    instr_in    <= x"00";
                    reset_request_to_top <= '1';

                    state <= Mode_Startup;



                -----------------------------------------------------------------
                -- MODE STARTUP
                -----------------------------------------------------------------
                when Mode_Startup =>

                    reset_request_to_top <= '0';

                    -- Activation attente si la fin d?un paquet est vue
                    if all_data_sent = '1' then
                        activate_wait_between_trip <= '1';
                    end if;

                    ----------------------------------------------------------------
                    -- Attente ~40us entre TRIPLETS
                    ----------------------------------------------------------------
                    if wait_between_trip = '1' and activate_wait_between_trip = '1' then
                        cnt_40us <= cnt_40us + 1;
                        if cnt_40us = SEUIL_40us then
                            cnt_40us <= 0;
                            wait_between_trip <= '0';
                        end if;

                    else
                        case init_list(init_index) is

                            ------------------------------------------------------------
                            -- DELAI 200 ms
                            ------------------------------------------------------------
                            when x"FE" =>
                                ms200_cnt <= ms200_cnt + 1;
                                if ms200_cnt = SEUIL_200ms then
                                    ms200_cnt  <= 0;
                                    init_index <= init_index + 1;
                                end if;

                            ------------------------------------------------------------
                            -- DELAI 4 ms
                            ------------------------------------------------------------
                            when x"FF" =>
                                ms4_cnt <= ms4_cnt + 1;
                                if ms4_cnt = SEUIL_4ms then
                                    ms4_cnt    <= 0;
                                    init_index <= init_index + 1;
                                end if;

                            ------------------------------------------------------------
                            -- FIN STARTUP
                            ------------------------------------------------------------
                            when x"00" =>
                                startup_cnt <= startup_cnt + 1;
                                if startup_cnt = SEUIL_startup_delay then
                                    startup_cnt <= 0;
                                    state <= Mode_Working;
                                end if;

                            ------------------------------------------------------------
                            -- INSTRUCTION NORMALE : TRIPLET 7C ? 80 ? DATA
                            ------------------------------------------------------------
                            when others =>
                                if list_data_full = '0' then
                                    case phase_instr is
                                        when 0 =>
                                            instr_in <= x"7C";
                                            phase_instr <= 1;

                                        when 1 =>
                                            instr_in <= x"80";
                                            phase_instr <= 2;

                                        when 2 =>
                                            instr_in <= init_list(init_index);
                                            phase_instr <= 0;
                                            init_index <= init_index + 1;
                                            wait_between_trip <= '1';
                                            startup_cnt <= 0;
													 
                                    end case;
                                end if;

                        end case;
                    end if;



                -----------------------------------------------------------------
                -- MODE WORKING (simple relais)
                -----------------------------------------------------------------
                when Mode_Working =>

                    if list_data_full = '0' then
                        instr_in <= instr_tasks;
                    else
                        instr_in <= x"00";
                    end if;

                    -- passage en Mode_Idle si r�p�tition
                    if instr_tasks = instr_prev then
                        idle_count <= idle_count + 1;
                        if idle_count >= SEUIL_idle then
                            idle_count <= 0;
                            state <= Mode_Idle;
                        end if;
                    else
                        idle_count <= 0;
                    end if;

		    instr_prev <= instr_tasks;

                -----------------------------------------------------------------
                -- MODE IDLE
                -- Reset n'est autoris� que dans ce mode
                -----------------------------------------------------------------
                when Mode_Idle =>

                    if reset = '1' then
                        state <= Mode_Reset;

                    elsif instr_tasks /= instr_prev then
                        instr_in <= instr_tasks;
                        state <= Mode_Working;
                    end if;

                    instr_prev <= instr_tasks;

            end case;

        end if;
    end process;

end architecture;