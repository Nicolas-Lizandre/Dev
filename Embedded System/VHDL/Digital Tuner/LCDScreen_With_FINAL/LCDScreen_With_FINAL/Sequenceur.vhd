----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:03 09/30/2025 
-- Design Name: 
-- Module Name:    Sequenceur - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sequenceur is
    Port ( Etat_0 : in  STD_LOGIC;
			  Mesure : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
			  Init_Compt : out STD_LOGIC;
           Charg_Reg : out  STD_LOGIC;
           Valid_Compt : out  STD_LOGIC:='0';
           SensCroiss : out  STD_LOGIC);
end Sequenceur;

----On construit ici un séquenceur. Un séquenceur a tout les avantages d'un détecteur 
--de front montant et est même meilleur surtout lors... de changement d'état de variables !
architecture Behavioral of Sequenceur is

	type STATE is (No_Mesure,Beg_Mesure,During_Mesure_Before_Etat_0,During_Mesure_After_Etat_0,End_Mesure_Before_Etat_0,End_Mesure_After_Etat_0);
	signal CURRENT_STATE, NEXT_STATE : STATE:=No_Mesure;
begin
---Synchro
CLK_state : process(Clk)
begin
	if rising_edge(Clk) then CURRENT_STATE<=NEXT_STATE; end if;
end process CLK_state;

---Combi pour det Etat_Futur
ETF : process(CURRENT_STATE, Mesure,Etat_0)
	begin
		 -- valeur par défaut : dans le premier when si il n'y avait pas de else CURRENT_STATE ne serait pas affecté = erreur
		 -- l'autre solution est justement de le mettre
    NEXT_STATE <= CURRENT_STATE;
	 
	case CURRENT_STATE is
	
	when No_Mesure => if(Mesure='1') then NEXT_STATE <=Beg_Mesure; else NEXT_STATE <=No_Mesure; end if;
	
	when Beg_Mesure => NEXT_State <=During_Mesure_Before_Etat_0;
	---Init_compt<= '1';
	
	when During_Mesure_Before_Etat_0 => 
			if(Mesure='0') then NEXT_STATE <=End_Mesure_Before_Etat_0; 
			elsif(Etat_0='1') then NEXT_STATE<=During_Mesure_After_Etat_0; end if; --Permet de créer un mini délai
			
	when During_Mesure_After_Etat_0 => 
			if(Mesure='0') then NEXT_STATE <=End_Mesure_After_Etat_0; end if;
	
	when End_Mesure_Before_Etat_0 => NEXT_STATE <=No_Mesure;
	when End_Mesure_After_Etat_0 => NEXT_STATE <=No_Mesure;
	when others => NEXT_STATE <= No_Mesure; --A METTRE !

	end case;
end process ETF;
---Combi pour sortie fait entre chaque états
--Init_comp sert à reset le compteur réversible
Init_compt<= '1' when (CURRENT_STATE=Beg_Mesure) else '0';
SensCroiss <= '1' when (CURRENT_STATE=During_Mesure_After_Etat_0 or CURRENT_STATE=End_Mesure_After_Etat_0) else '0'; -- décalage de 1 attendu -- Neccss car Etat_0 se signaale par qu'un front montant
Charg_Reg<= '1' when (CURRENT_STATE=End_Mesure_Before_Etat_0 or CURRENT_STATE=End_Mesure_After_Etat_0) else '0';
Valid_Compt<='1' when ((CURRENT_STATE=Beg_Mesure) or (CURRENT_STATE=During_Mesure_Before_Etat_0) or (CURRENT_STATE=During_Mesure_After_Etat_0)) else '0';

end Behavioral;

