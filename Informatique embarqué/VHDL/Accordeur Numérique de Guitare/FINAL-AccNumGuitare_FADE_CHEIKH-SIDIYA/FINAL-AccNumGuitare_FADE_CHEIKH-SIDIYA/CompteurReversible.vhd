--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2.04i
--  \   \         Application : 
--  /   /         Filename : xil_4928_18
-- /___/   /\     Timestamp : 10/07/2025 16:35:18
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: 
--

-- Company: -- Engineer: -- -- Create Date: 16:14:52 09/30/2025 -- Design Name: -- Module Name: CompteurReversible - Behavioral -- Project Name: -- Target Devices: -- Tool versions: -- Description: -- -- Dependencies: -- -- Revision: -- Revision 0.01 - File Created -- Additional Comments: -- 

 

library IEEE; use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.numeric_std.all;

---- Uncomment the following library declaration if instantiating ---- any Xilinx primitives in this code. --library UNISIM; --use UNISIM.VComponents.all; 

entity CompteurReversible is 
	Port ( 
		Init_Compt : in STD_LOGIC; 
		Valid_Compt : in STD_LOGIC; 
		SensCroiss : in STD_LOGIC; --- Devra être raccordé à 2 LEDs : une pour +(verte) l'autre pour -(rouge) 
		FreqRef : in STD_LOGIC; ---FreqRef est un signal *Enable*
		Clk : in STD_LOGIC;
		Etat_0 : out STD_LOGIC; 
		Pourcent_to_output : out STD_LOGIC_VECTOR(3 downto 0)
		);
end CompteurReversible; 

--- La conversion de pourcentage_to_output de 8bits->4bits a posteriori en PERMANENCE!!!!! doit se faire ICI 

---ATTENTION
---Le seuil pris est pour calculer 329.6Hz (pour passer à un autre il suffit de changer *) Voir cahier pour seuils
---ATTENTION

architecture Behavioral of CompteurReversible is 
signal compteur : natural :=100;

begin 
--- Compteur Management (y mettre SensCroiss) 
process(Clk,FreqRef,Init_Compt) 
begin
	---Incré/Décré
	---rising_edge ne peut pas se mélanger avec autres choses, 
	---sa propagation se fait dans des pistes en Or (meilleur conductivité) allouées séparé du circuit!
	
	if(rising_edge(Clk)) then
		if(Init_Compt='1') then 
		compteur<=100; 
		Etat_0<='0';
		else 
				if(compteur=0) then Etat_0 <= '1'; end if; ---Prise en compte le retard de la machine à état ne fait rien (compteur n'y change pas - trop court)
				if(Valid_compt='1') then  
						  if(SensCroiss='0' and FreqRef='1') then compteur <= compteur - 1;   --- SensCroiss='0' => décomptage
						  elsif(FreqRef='1') then compteur<=compteur+1;
						  end if; 
				end if; 
		end if;
	 end if;
end process;

--- PARTIE Combinatoire
--- Etat_0 Management (Multiplexeur)
	Pourcent_to_output <= std_logic_vector(to_unsigned(compteur,4)) when (compteur <= 8) else "1111"; 

end Behavioral; 

