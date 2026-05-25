----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:27:17 12/16/2025 
-- Design Name: 
-- Module Name:    Bus_Signe_AVEC_Pourcent - Behavioral 
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

entity Bus_Signe_AVEC_Pourcent is
    Port ( Signe : in  STD_LOGIC;
           Pourcent : in  STD_LOGIC_VECTOR(3 downto 0);
           Signe_AVEC_Pourcent : out  STD_LOGIC_VECTOR(4 downto 0));
end Bus_Signe_AVEC_Pourcent;

architecture Behavioral of Bus_Signe_AVEC_Pourcent is

begin

	Signe_AVEC_Pourcent <= Signe & Pourcent;

end Behavioral;

