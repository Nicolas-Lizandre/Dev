
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:14:53 12/09/2025
-- Design Name:   CompteurReversible
-- Module Name:   D:/Utilisateurs/lizafade50/Exemples/AccNumGuitare_FADE_CHEIKH-SIDIYA/Compteur_Reversible_tb.vhd
-- Project Name:  AccNumGuitare_FADE_CHEIKH-SIDIYA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CompteurReversible
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

ENTITY Compteur_Reversible_tb_vhd IS
END Compteur_Reversible_tb_vhd;

ARCHITECTURE behavior OF Compteur_Reversible_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT CompteurReversible
	PORT(
		Init_Compt : IN std_logic;
		Valid_Compt : IN std_logic;
		SensCroiss : IN std_logic;
		FreqRef : IN std_logic;          
		Etat_0 : OUT std_logic;
		LED_bad_ftment_cdt1 : OUT std_logic;
		Pourcent_to_output : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL Init_Compt :  std_logic := '0';
	SIGNAL Valid_Compt :  std_logic := '0';
	SIGNAL SensCroiss :  std_logic := '0';
	SIGNAL FreqRef :  std_logic := '0';

	--Outputs
	SIGNAL Etat_0 :  std_logic;
	SIGNAL LED_bad_ftment_cdt1 :  std_logic;
	SIGNAL Pourcent_to_output :  std_logic_vector(3 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: CompteurReversible PORT MAP(
		Etat_0 => Etat_0,
		Init_Compt => Init_Compt,
		Valid_Compt => Valid_Compt,
		SensCroiss => SensCroiss,
		FreqRef => FreqRef,
		LED_bad_ftment_cdt1 => LED_bad_ftment_cdt1,
		Pourcent_to_output => Pourcent_to_output
	);

		--Clock Management
tb :	PROCESS
	BEGIN		
		wait for 20 ns;
		FreqRef<='0';
		wait for 20 ns;
		FreqRef<='1';
	END PROCESS tb;
	--Init Compting Manangement
	PROCESS
	BEGIN	
		wait for 100 ns;
		Valid_Compt <= '1';
		Init_Compt <= '1';
		wait for 100 ns;
		Init_Compt <= '0';
		wait;
	END PROCESS;

END;
