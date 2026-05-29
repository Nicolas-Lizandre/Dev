----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:03:42 12/16/2025 
-- Design Name: 
-- Module Name:    Sequenceur_Aux - Behavioral 
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

entity Sequenceur_Aux is
    Port ( Etat_0 : in  STD_LOGIC;
           Mesure : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Init_Compt : out  STD_LOGIC;
           Valid_Compt : out  STD_LOGIC;
           SensCroiss : out  STD_LOGIC);
end Sequenceur_Aux;

architecture Behavioral of Sequenceur_Aux is

begin


end Behavioral;

