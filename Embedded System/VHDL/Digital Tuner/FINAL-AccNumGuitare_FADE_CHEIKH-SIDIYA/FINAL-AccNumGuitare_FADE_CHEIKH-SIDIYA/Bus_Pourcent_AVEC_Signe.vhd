----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:53 12/16/2025 
-- Design Name: 
-- Module Name:    Bus_Pourcent_AVEC_Signe - Behavioral 
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

entity Bus_Pourcent_AVEC_Signe is
    Port ( Pourcent : in  STD_LOGIC;
           Signe : in  STD_LOGIC;
           Pourcent_AVEC_Signe : out  STD_LOGIC);
end Bus_Pourcent_AVEC_Signe;

architecture Behavioral of Bus_Pourcent_AVEC_Signe is

begin


end Behavioral;

