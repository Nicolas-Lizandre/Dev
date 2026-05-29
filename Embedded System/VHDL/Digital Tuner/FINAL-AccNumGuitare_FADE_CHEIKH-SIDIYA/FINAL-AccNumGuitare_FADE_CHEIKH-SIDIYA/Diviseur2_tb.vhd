
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:41:59 12/09/2025
-- Design Name:   Diviseur
-- Module Name:   D:/Utilisateurs/lizafade50/Exemples/AccNumGuitare_FADE_CHEIKH-SIDIYA/Diviseur_tb.vhd
-- Project Name:  AccNumGuitare_FADE_CHEIKH-SIDIYA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Diviseur
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY Diviseur2_tb_vhd IS
END Diviseur2_tb_vhd;

ARCHITECTURE behavior OF Diviseur2_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Diviseur2
	PORT(
		FreqVar : IN std_logic;
		FreqRef : IN std_logic;          
		TVar100 : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL FreqVar :  std_logic := '0';
	SIGNAL FreqRef :  std_logic := '0';

	--Outputs
	SIGNAL TVar100 :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Diviseur2 PORT MAP(
		FreqVar => FreqVar,
		FreqRef => FreqRef,
		TVar100 => TVar100
	);



	tb : PROCESS
	BEGIN
		FreqRef <= '0';
		wait for 20 ns;
		FreqRef <= '1';
		wait for 20 ns;
	END PROCESS;
	process
	begin
		FreqVar<='1';
		wait for 1 ms;
		FreqVar<='0';
		wait for 1 ms;
	end process;
END;
