----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:29:59 09/30/2025 
-- Design Name: 
-- Module Name:    RegistreParallele - Behavioral 
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

entity RegistreParallele is
    Port ( Charg_Reg : in  STD_LOGIC;
           Pourcent_to_output : in unsigned(3 downto 0):="0001"; ---Le comptage ne peut pas depasser 129 et si c'est le cas on se fiche de la mesure
			  SensCroiss : in STD_LOGIC:='1';
			  Clk : in STD_LOGIC;
           Pourcent_in_use : out unsigned(3 downto 0):="0001";
			  Sign_output : out STD_LOGIC:='1');
end RegistreParallele;

architecture Behavioral of RegistreParallele is
begin
	process(Clk,Charg_Reg)
	begin
		if(rising_edge(Clk)) then
			if(Charg_Reg='1') then
					Pourcent_in_use <= Pourcent_to_output;
					Sign_output <= SensCroiss;
				end if;
		end if;
	end process;
end Behavioral;

