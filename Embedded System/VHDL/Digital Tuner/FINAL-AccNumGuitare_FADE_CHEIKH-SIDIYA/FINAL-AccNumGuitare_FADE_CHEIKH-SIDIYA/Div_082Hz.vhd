----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:59:26 12/16/2025 
-- Design Name: 
-- Module Name:    FreqRefDiviseur - Behavioral 
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

entity Div_082Hz is
    Port ( Clk : in  STD_LOGIC;
           FreqRef : out  STD_LOGIC:='0'); ---FreqRef agit comme un signal enable
end Div_082Hz;

architecture Behavioral of Div_082Hz is
signal compteur_reel : natural := 0; 
constant SEUIL_082Hz : natural :=151699; --303398/2 car le M6 compte 2 fois plus lentement que prévu

begin 

process(Clk) 
begin
	if(rising_edge(Clk)) then
			if(compteur_reel=SEUIL_082Hz) then compteur_reel<=0; FreqRef <= '1';   
			else compteur_reel<=compteur_reel+1; FreqRef <= '0'; end if; 
   end if;
end process;
end Behavioral;

