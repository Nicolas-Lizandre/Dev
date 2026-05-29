
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:22:49 11/04/2025
-- Design Name:   Sequenceur
-- Module Name:   D:/Utilisateurs/lizafade50/Exemples/AccNumGuitare_FADE_CHEIKH-SIDIYA/Sequenceur_tb.vhd
-- Project Name:  AccNumGuitare_FADE_CHEIKH-SIDIYA
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Sequenceur
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

ENTITY Sequenceur_tb_vhd IS
END Sequenceur_tb_vhd;

ARCHITECTURE behavior OF Sequenceur_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Sequenceur
	PORT(
		Etat_0 : IN std_logic;
		Mesure : IN std_logic;
		FreqRef : IN std_logic;          
		Init_Compt : OUT std_logic;
		Charg_Reg : OUT std_logic;
		Valid_Compt : OUT std_logic;
		SensCroiss : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL Etat_0 :  std_logic := '1';
	SIGNAL Mesure :  std_logic := '0';
	SIGNAL FreqRef :  std_logic := '0';

	--Outputs
	SIGNAL Init_Compt :  std_logic;
	SIGNAL Charg_Reg :  std_logic;
	SIGNAL Valid_Compt :  std_logic;
	SIGNAL SensCroiss :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Sequenceur PORT MAP(
		Etat_0 => Etat_0,
		Mesure => Mesure,
		FreqRef => FreqRef,
		Init_Compt => Init_Compt,
		Charg_Reg => Charg_Reg,
		Valid_Compt => Valid_Compt,
		SensCroiss => SensCroiss
	);


tb : PROCESS
	BEGIN
	Mesure <= '1';
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	wait for 10 ns;
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	wait for 10 ns;
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	
	wait for 10 ns;
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	wait for 10 ns;
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	wait for 10 ns;
	FreqRef <= '1';
	wait for 10 ns;
	FreqRef <= '0';
	wait for 10 ns;
	
	END PROCESS;
	
	process
	begin
		if(Etat_0='0') then Etat_0 <= '1'; else Etat_0 <='0'; end if;
		wait for 100 ns; 
	end process;


END;
