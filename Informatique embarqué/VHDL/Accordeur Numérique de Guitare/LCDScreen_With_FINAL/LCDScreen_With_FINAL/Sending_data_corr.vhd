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

    --signal all_data_sent_reg : std_logic := '0';
    signal wait_for_middle_of_SCL : std_logic := '0';
	 
	 ---
	 --Lock
	 ---
	 signal lock_cnt : integer range 0 to 200 := 0;
	 signal lock     : std_logic := '0';

	 
	 
begin

    ---------------------------------------------------------------------
    -- OUTPUTS
    ---------------------------------------------------------------------
    list_data_full <= '1' when (list(6) /= x"00") or (state = STOP_OR_CONTINUE) else '0';
    sda <= '0' when sda_out='0'  else 'Z';  
    scl <= '0' when scl_reg='0' else 'Z';  -- On voudra modifier scl nous même pour l'état STOP et
    ---------------------------------------------------------------------
    -- I2C CLOCK with RC delay
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then --//à désactiver à STOP_OR_CONTINUE? et WAIT_INSTR
            if state /= WAIT_INSTR then
					 if lock = '1' then
						if lock_cnt = 0 then
							 lock <= '0';  -- fin du temps interdit
						else
							 lock_cnt <= lock_cnt - 1;
						end if;
					 end if;
                scl_prev_delay <= scl_prev_delay(8 downto 0) & scl_reg; 
                -- '&' rajoute un bit pour former un vecteur (9 downto 0) | scl_prev_delay(8 downto 0) détruit le dernier bit (110->10)
                scl_rise <= '0';
                scl_fall <= '0';

                if div_cnt = 249 then --//à changer pour correspondre à 100kHz -- /?/rajouter ici block pd clock stretching
                    div_cnt <= (others=>'0');
                    scl_reg <= not scl_reg;
                else
                    div_cnt <= div_cnt + 1;
                end if;

                if lock = '0' then
						 if scl_prev_delay(7)='0' and scl_prev_delay(6)='0' and scl_prev_delay(5)='0' and scl_prev_delay(4)='0' 
							 and scl_reg='1' then
							  scl_rise <= '1';
							  lock <= '1';
							  lock_cnt <= 100;  -- 2 �s � 50 MHz
						 end if; 
	
						 -- D�tection front descendant
						 if scl_prev_delay(7)='1' and scl_prev_delay(6)='1' and scl_prev_delay(5)='1' and scl_prev_delay(4)='1'
							 and scl_reg='0' then
							  scl_fall <= '1';
							  lock <= '1';
							  lock_cnt <= 100;  -- 2 �s
						 end if;
					 
            end if; --/??/le clk_streching doit remettre div_cnt à 0; cela se fait pour scl_reg = '0' (pas besoin de l'assurer)
					 --scl descend en 100ns
				elsif state = WAIT_INSTR then
                div_cnt <= (others=>'0'); --//éviter des offsets lors de reprise (à vérifier)
                scl_reg <= '1'; --//Pour relâcher la ligne (techniquement inutile car le dernier état de SCL est forcément '1')
                scl_prev_delay  <= (others => '1'); -- cohérent avec scl_reg='1'
                scl_rise        <= '0';
                scl_fall        <= '0';
					 lock <= '0';
                lock_cnt <= 0;
            end if;
        end if;
    end process;


    ---------------------------------------------------------------------
    -- AJOUT D?INSTRUCTION
    ---------------------------------------------------------------------
    process(clk) --//Fonctionne si et seulement si les instructions sont envoyés à clk-rate !!
    begin        --Cette partie NE s'occupe PAS de dire au TOP-1 de se calmer (instructions je parle) [voir dans le process - OUTPUT]
        if rising_edge(clk) then
            if (list(6) = x"00")  and (state /= STOP_OR_CONTINUE) then --Dans ce cas il reste de la place / Je ne veux pas recevoir d'instructions pd que je fait mon arrêt
                for i in 0 to 6 loop
                    if (list(i) = x"00") and (instr_in /= x"00") then --On considère x"00" comme une non-instruction
                        -- state /= STOP_OR_CONTINUE because in this state we need to shift the register (2 sources at the same time)
                        list(i) <= instr_in;
                        exit;
                    end if;
                end loop;
            
            elsif (list(1) /= x"00") and (state = STOP_OR_CONTINUE) then -- Censé se faire pd un coup d'horloge (Cas CONTINUE)
                for i in 0 to 5 loop -- Consommer instruction = d�caler toute la LISTE
                    list(i) <= list(i+1); end loop;
                    list(6) <= x"00";

            elsif (state = STOP_OR_CONTINUE) and (wait_for_middle_of_SCL='1') and (div_cnt=125) then -- (Cas STOP)
                for i in 0 to 5 loop -- Consommer instruction = d�caler toute la LISTE
                    list(i) <= list(i+1); end loop;
                    list(6) <= x"00";
            end if;
        end if;
    end process;




    ---------------------------------------------------------------------
    -- FSM PRINCIPALE
    ---------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then --scl_rise et scl_fall s'occupe de la synchronisation
            case state is
                -----------------------------------------------------------------
                when WAIT_INSTR =>
                -----------------------------------------------------------------
                    --all_data_sent_reg <= '0';
                    all_data_sent <= '0';
                    if list(0) /= x"00" then
                        bit_cnt <= 6;
                        state <= START; 
                    --elsif list(0)=x"00" then
                        --all_data_sent_reg <= '1';
                    end if;


                -----------------------------------------------------------------
                when START =>
                -----------------------------------------------------------------
                    sda_out <= '0';--/?/Ai-je besoin de mettre div_cnt à 125 pour moitié créneau [voir WAIT_INSTR] comme pour STOP ?
                    state <= INSTR;
                --SCL vaut '1', il suffit de balancer tout de suite sda_out à 0 puis le reste n'est pas son prlm

                -----------------------------------------------------------------
                when INSTR =>
                -----------------------------------------------------------------
                    if scl_fall='1' then
                        sda_out <= list(0)(bit_cnt+1);  

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


                when ACK => --Ici je vais supposer que le composant renvoie tjrs ACK (flemmme de dire 3 RESTART sinon STOP)
                -----------------------------------------------------------------
					     sda_out <= '1'; --Je rel�che la ligne
                    if scl_fall='1' then --On ne lit pas le composant - par soucis de simplicité
                        state <= STOP_OR_CONTINUE;
                    end if; 


                -----------------------------------------------------------------
                when STOP_OR_CONTINUE =>
                -----------------------------------------------------------------
                --CAS CONTINUE
                if list(1) /= x"00" then --//Potentiellement erreur voir MSB ect
                    bit_cnt <= 5;           --bit_cnt <= 5;
                    sda_out <= list(0)(6);  --sda_out <= list(0)(7);
						  --Les données se transmettent aux scl_fall='1' or celui-ci est déjà passé ! (lecture du composant si SCL='1'!)
                    --Pour décalage--Voir Ajout d'instructions--
                    state <= INSTR; -- pas de STOP

                --CAS STOP
                else
                    --Le seul témoin me permettant de faire STOP (sans scl_fall) est div_cnt
                    all_data_sent <= '1';
                    if scl_rise='1' then
                        wait_for_middle_of_SCL<='1'; end if;

                    if wait_for_middle_of_SCL='1' and div_cnt=125 then -- Une opération à Ajout d'instructions se fait en parallèle
                        wait_for_middle_of_SCL<='0';
                        --Pour décalage--Voir Ajout d'instructions--
                        sda_out <='0'; -- Nécessaire pour détection STOP
                        state <= WAIT_INSTR; end if;
                end if;
            end case;
        end if;
    end process;

end architecture;
--//Je dois supprimer le bit 0 (le poids faible) Pas le poids fort ! (bit 7)