----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:57:38 09/23/2025 
-- Design Name: 
-- Module Name:    Diviseur - Behavioral 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

---

entity Diviseur2 is
    Port ( FreqVar : in  STD_LOGIC;
			  FreqRef : in STD_LOGIC;
           TVar100 : out  STD_LOGIC := '0'
			);
end Diviseur2;

---Attention le retour a zero se fait par Overflow
architecture Behavioral of Diviseur2 is
signal compteur : natural :=0;
signal compteur_reel : natural :=0;
signal Q : std_logic:='0';
signal Qavant : std_logic:='0';

begin

	---Incrémentation
	process(FreqRef)
	begin
		if(rising_edge(FreqRef)) then
			if(compteur<=128) then  
				if(compteur_reel=7500) then 
					if(Q /= Qavant) then 
							compteur <= compteur+1;
							Qavant <= Q;
					else Q<=FreqVar; end if;
	
				compteur_reel <= 0;
				else compteur_reel <= compteur_reel+1;
				end if;
			else compteur <=0;
			end if;
		end if;
	end process;
	
---Créneau Tvar100
TVar100 <= '1' when(compteur < 100) else 
           '0';
end Behavioral;

