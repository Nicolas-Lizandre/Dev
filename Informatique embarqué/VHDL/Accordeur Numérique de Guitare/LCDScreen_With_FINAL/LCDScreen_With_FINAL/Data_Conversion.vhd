library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Converter is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;

        note_en_cours: in  std_logic_vector(2 downto 0);
        SensCroiss   : in  std_logic;
        Pourcentage  : in  std_logic_vector(3 downto 0);

        -- Vers Data_Sequenceur
        instr_tasks : out std_logic_vector(7 downto 0);
        list_data_full : in std_logic;

        -- Signal de Data_Sequenceur pour remettre read_index/write_index à 0
        reset_request : in std_logic;

        --De Sending_data pour assurer passage d'un set d'instruction à l'autre
        all_data_sent : in std_logic
    );
end entity;



architecture rtl of Data_Converter is

    ------------------------------------------------------------------------
    -- �TATS
    ------------------------------------------------------------------------
    type state_t is (
        FrequencyTooHigh,
        Corde_1_Pos, Corde_1_Neg,
        Corde_2_Pos, Corde_2_Neg,
        Corde_3_Pos, Corde_3_Neg,
        Corde_4_Pos, Corde_4_Neg,
        Corde_5_Pos, Corde_5_Neg,
        Corde_6_Pos, Corde_6_Neg,
        FrequencyTooLow,
        Waiting_New_Instructions,
        Instruction_Transmission
    );
    signal state : state_t := Waiting_New_Instructions;

    ------------------------------------------------------------------------
    -- LISTE LOCALE D?INSTRUCTIONS
    ------------------------------------------------------------------------
    type instr_list is array(0 to 31) of std_logic_vector(7 downto 0);
    signal data_to_be_send : instr_list := (others => (others => '0'));

    signal write_index : integer range 0 to 31 := 0;
    signal read_index  : integer range 0 to 31 := 0;

    ------------------------------------------------------------------------
    -- Timer 20 ms @ 25 MHz
    ------------------------------------------------------------------------
    signal wait_counter : unsigned(23 downto 0) := (others => '0');
    constant WAIT_20MS  : unsigned(23 downto 0) := to_unsigned(500_000, 24);

    ------------------------------------------------------------------------
    -- Conversion des nombres en instructions ASCII
    ------------------------------------------------------------------------
    type numbers_list is array(0 to 15) of std_logic_vector(15 downto 0);
    signal conv_nb_instructions : numbers_list := (
        x"2030", -- ' 0'
        x"2031", -- ' 1'
        x"2032", -- ' 2'
        x"2033",
        x"2034",
        x"2035",
        x"2036",
        x"2037",
        x"2038", -- ' 8'
        x"2039", -- ' 9'
        x"3130", -- '10'
        x"3131", -- '11'
        x"3132",
        x"3133",
        x"3134",
        x"3135"  -- '15'
    );

    ------------------------------------------------------------------------
    -- Glue logic pour Instruction_Transmission
    ------------------------------------------------------------------------
    signal phase_instr : std_logic_vector(1 downto 0) := "00";
    signal cnt_delay : unsigned(7 downto 0) := (others => '0');
    signal wait_between_trip          : std_logic := '0';
    signal activate_wait_between_trip : std_logic := '0';
    signal retour_deb_ligne_2         : std_logic := '0';

begin


    ------------------------------------------------------------------------
    -- FSM
    ------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            ----------------------------------------------------------------
            -- RESET DEMANDE PAR TOP-2
            ----------------------------------------------------------------
            if reset = '1' or reset_request = '1' then
                write_index <= 0;
                read_index  <= 0;
                data_to_be_send <= (others => (others=>'0'));
                instr_tasks <= x"00";
                phase_instr <= "00";
                cnt_delay   <= (others => '0');
                wait_between_trip <= '0';
                activate_wait_between_trip <= '0';
                retour_deb_ligne_2 <= '0';
                state <= Waiting_New_Instructions;
            end if;


            case state is

                ----------------------------------------------------------------
                -- FREQUENCE TROP HAUTE / BASSE
                ----------------------------------------------------------------
                when FrequencyTooHigh =>
                    -- TODO : remplir data_to_be_send() ici
                    -- puis basculer vers Instruction_Transmission
                    null;

                when FrequencyTooLow =>
                    -- TODO
                    null;


                ----------------------------------------------------------------
                -- CORDES (remplissage de data_to_be_send)
                ----------------------------------------------------------------
                when Corde_1_Pos  =>
                    -- ici tu construis la phrase ASCII :
                    -- "XXXHZ MI +10% CORDE1 (A VIDE)"
                    -- en remplissant data_to_be_send(write_index)
                    -- puis state <= Instruction_Transmission
                    null;
                --//Ici remplit en Caractères


                --------------------------------------------------------////////////////////////////////////////////////////
                when Corde_1_Neg  => --//Remplir les autres en dernier sinon le code est absolument illible (assurer validité par contre)
                    write_index <= 0;

                    -- "329.6Hz Mi -"
                    data_to_be_send(write_index) <= x"33"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"32"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"39"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"2E"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"36"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"48"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"7A"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"20"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"4D"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"69"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"20"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"2D"; write_index <= write_index + 1; -- ici est le signe

                    -- conv_nb_instructions(pourcentage)
                    data_to_be_send(write_index) <= conv_nb_instructions(to_integer(unsigned(Pourcentage)))(15 downto 8);
                    write_index <= write_index + 1;
                    data_to_be_send(write_index) <= conv_nb_instructions(to_integer(unsigned(Pourcentage)))(7 downto 0);
                    write_index <= write_index + 1;

                    -- "%"
                    data_to_be_send(write_index) <= x"25";
                    write_index <= write_index + 1;

                    -- "CORDE 1 (A VIDE)"
                    data_to_be_send(write_index) <= x"43"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"4F"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"52"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"44"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"45"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"20"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"31"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"20"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"28"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"41"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"20"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"56"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"49"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"44"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"45"; write_index <= write_index + 1;
                    data_to_be_send(write_index) <= x"29"; write_index <= write_index + 1;

                    -- Fin de liste
                    data_to_be_send(write_index) <= x"00";
                    state <= Instruction_Transmission;
                ---------------------------------------------------/////////////////////////////////////
                when Corde_2_Pos  => null;
                when Corde_2_Neg  => null;
                when Corde_3_Pos  => null;
                when Corde_3_Neg  => null;
                when Corde_4_Pos  => null;
                when Corde_4_Neg  => null;
                when Corde_5_Pos  => null;
                when Corde_5_Neg  => null;
                when Corde_6_Pos  => null;
                when Corde_6_Neg  => null;


                ----------------------------------------------------------------
                -- MODE D’ATTENTE AVANT LECTURE
                ----------------------------------------------------------------
                when Waiting_New_Instructions => -- C'est bon

                    if wait_counter = WAIT_20MS then
                        wait_counter <= (others => '0');
                        if Pourcentage = "1111" then      -- Cas POURCENTAGE INVALIDE
                            --A voir en détail plus tard
                            if note_en_cours = "110" then         -- Si Corde 6
                                state <= FrequencyTooHigh;

                            elsif note_en_cours = "001" then      -- Si Corde 1
                                state <= FrequencyTooLow;

                            else
                                -- Cas impossible / sécurité
                                state <= Waiting_New_Instructions;
                            end if;
                        else                              -- Cas POURCENTAGE VALIDE
                            case note_en_cours is --C'est bon

                                when "001" =>      -- Corde 1
                                    if SensCroiss = '1' then
                                        state <= Corde_1_Pos;
                                    else
                                        state <= Corde_1_Neg;
                                    end if;

                                when "010" =>      -- Corde 2
                                    if SensCroiss = '1' then
                                        state <= Corde_2_Pos;
                                    else
                                        state <= Corde_2_Neg;
                                    end if;

                                when "011" =>      -- Corde 3
                                    if SensCroiss = '1' then
                                        state <= Corde_3_Pos;
                                    else
                                        state <= Corde_3_Neg;
                                    end if;

                                when "100" =>      -- Corde 4
                                    if SensCroiss = '1' then
                                        state <= Corde_4_Pos;
                                    else
                                        state <= Corde_4_Neg;
                                    end if;

                                when "101" =>      -- Corde 5
                                    if SensCroiss = '1' then
                                        state <= Corde_5_Pos;
                                    else
                                        state <= Corde_5_Neg;
                                    end if;

                                when "110" =>      -- Corde 6
                                    if SensCroiss = '1' then
                                        state <= Corde_6_Pos;
                                    else
                                        state <= Corde_6_Neg;
                                    end if;

                                when others =>
                                    -- Sécurité
                                    state <= Waiting_New_Instructions;
                            end case;

                        end if;

                    else
                        wait_counter <= wait_counter + 1;
                    end if;




                ----------------------------------------------------------------
                -- ENVOI DES INSTRUCTIONS VERS Data_Sequenceur
                -- read_index parcourt data_to_be_send
                -- mais attend pendant list_data_full='1'
                ----------------------------------------------------------------
                when Instruction_Transmission => --//ici le header se décidera ! [Choix entre : 7C, 40, ASCII /et 7C, 80, XX]
                --//je dois sauter ligne1 -> ligne2 et inversement après avoir mis un STOP 
                --//je peux juste rajouter un gros délai par flemme (1 instruction == ~10us donc 18 == ~180us soit attendre 500us en prenant bq de marges)
                --//Au total un tour == 36(ASCII) +6(saut ligne) instructions dont 4 STOP (mettre x00?)
                    -- Blocage global si la liste aval est pleine
                    if list_data_full = '1' then
                        instr_tasks <= x"00";
                    else

                        ----------------------------------------------------------------
                        -- Attente entre deux triplets (~40us)
                        ----------------------------------------------------------------
                        if all_data_sent = '1' then activate_wait_between_trip <= '1'; end if; --In case too long SCL

                        if wait_between_trip = '1' and activate_wait_between_trip = '1' then
                            if cnt_delay = x"08" then
                                cnt_delay         <= (others => '0');
                                wait_between_trip <= '0';
                                activate_wait_between_trip <= '0';
                            else
                                cnt_delay <= cnt_delay + 1;
                            end if;

                        else
                            ----------------------------------------------------------------
                            -- LIGNE 1 : indices 0 à 15
                            ----------------------------------------------------------------
                            if read_index <= 15 then
                                retour_deb_ligne_2 <= '0';

                                if all_data_sent = '1' then
                                    case phase_instr is
                                        when "00" =>
                                            instr_tasks <= x"7C";
                                            phase_instr <= "01";

                                        when "01" =>
                                            instr_tasks <= x"40";
                                            phase_instr <= "10";

                                        when others =>
                                            instr_tasks <= data_to_be_send(read_index);
                                            phase_instr <= "00";
                                            read_index <= read_index + 1;
                                            wait_between_trip <= '1';
                                    end case;
                                end if;

                            ----------------------------------------------------------------
                            -- RETOUR DEBUT LIGNE 2 (avant index 16)
                            ----------------------------------------------------------------
                            elsif (read_index = 16) and (retour_deb_ligne_2 = '0') then

                                if all_data_sent = '1' then
                                    case phase_instr is
                                        when "00" =>
                                            instr_tasks <= x"7C";
                                            phase_instr <= "01";

                                        when "01" =>
                                            instr_tasks <= x"80";
                                            phase_instr <= "10";

                                        when others =>
                                            instr_tasks <= x"02"; -- début ligne 2
                                            phase_instr <= "00";
                                            retour_deb_ligne_2 <= '1';
                                            wait_between_trip <= '1';
                                    end case;
                                end if;

                            ----------------------------------------------------------------
                            -- LIGNE 2 : indices 16 à 31
                            ----------------------------------------------------------------
                            elsif read_index <= 31 then

                                if all_data_sent = '1' then
                                    case phase_instr is
                                        when "00" =>
                                            instr_tasks <= x"7C";
                                            phase_instr <= "01";

                                        when "01" =>
                                            instr_tasks <= x"40";
                                            phase_instr <= "10";

                                        when others =>
                                            instr_tasks <= data_to_be_send(read_index);
                                            phase_instr <= "00";
                                            read_index <= read_index + 1;
                                            wait_between_trip <= '1';
                                    end case;
                                end if;

                            ----------------------------------------------------------------
                            -- FIN : RETOUR DEBUT LIGNE 1
                            ----------------------------------------------------------------
                            else

                                if all_data_sent = '1' then
                                    case phase_instr is
                                        when "00" =>
                                            instr_tasks <= x"7C";
                                            phase_instr <= "01";

                                        when "01" =>
                                            instr_tasks <= x"80";
                                            phase_instr <= "10";

                                        when others =>
                                            instr_tasks <= x"C0";
                                            phase_instr <= "00";
                                            read_index  <= 0;
                                            state       <= Waiting_New_Instructions;
                                            wait_between_trip <= '1';
                                    end case;
                                end if;

                            end if;
                        end if;
                    end if;
            end case;
        end if;
    end process;
end architecture;


------------------------------------------------------------------------
--  TABLE DE CONVERSION ASCII → CODES (LCD I2C : envoyer 7C, 40, ASCII)
------------------------------------------------------------------------
            --ATTENTION :
            --afficher un caractère ASCII      :7C, 40, ASCII
            --retour début ligne/aller ligne 2 :7C, 80, XX
-- ============================
-- LETTRES MAJUSCULES LATINES
-- ============================
-- A = x41     B = x42     C = x43     D = x44
-- E = x45     F = x46     G = x47     H = x48
-- I = x49     J = x4A     K = x4B     L = x4C
-- M = x4D     N = x4E     O = x4F     P = x50
-- Q = x51     R = x52     S = x53     T = x54
-- U = x55     V = x56     W = x57     X = x58
-- Y = x59     Z = x5A

-- ============================
-- CHIFFRES
-- ============================
-- '0' = x30   '1' = x31   '2' = x32   '3' = x33
-- '4' = x34   '5' = x35   '6' = x36   '7' = x37
-- '8' = x38   '9' = x39

-- ============================
-- SYMBOLES UTILISÉS
-- ============================
-- ' '  (espace)    = x20
-- '+'              = x2B
-- '-'              = x2D
-- '%'              = x25
-- '('              = x28
-- ')'              = x29
-- ','              = x2C
-- ':'              = x3A
-- '/'              = x2F

-- ============================
-- MOTS MUSICAUX FRÉQUENTS
-- ============================
-- "DO"     → x44 x4F
-- "RE"     → x52 x45
-- "MI"     → x4D x49
-- "FA"     → x46 x41
-- "SOL"    → x53 x4F x4C
-- "LA"     → x4C x41
-- "SI"     → x53 x49

-- ============================
-- "CORDE"
-- ============================
-- "CORDE" → x43 x4F x52 x44 x45
-- ============================
-- "A VIDE" (sans accent)
-- ============================
-- "A"      = x41
-- ' '      = x20
-- "VIDE"   = x56 x49 x44 x45
-- donc "(A VIDE)" =
-- '(' x28, 'A' x41, ' ' x20, 'V' x56, 'I' x49, 'D' x44, 'E' x45, ')' x29

-- ============================
-- "HZ" 
-- ============================
-- "H" x48
-- "Z" x5A
-- ============================
-- MOTS "DESSUS" / "DESSOUS"
-- ============================
-- "DESSUS"  → x44 x45 x53 x53 x55 x53
-- "DESSOUS" → x44 x45 x53 x53 x4F x55 x53
--
-- ============================
-- COMMANDES CURSEUR (PAS ASCII)
-- ============================
-- Retour début ligne : x02 (avec RS=0 → envoyer via contrôle x80)
-- Ligne 2          : xC0 (position 0 ligne 2)
-- Effacer écran    : x01
-- Entrée mode      : x06
-- Affichage ON     : x0C

-- Exemple :
-- Pour aller début ligne :
--   7C 80 02
-- Pour aller ligne 2 :
--   7C 80 C0
------------------------------------------------------------------------