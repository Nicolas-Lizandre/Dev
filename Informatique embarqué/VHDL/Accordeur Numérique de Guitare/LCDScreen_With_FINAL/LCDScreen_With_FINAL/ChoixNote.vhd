----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:09:41 12/16/2025 
-- Design Name: 
-- Module Name:    ChoixNote - Behavioral 
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

entity ChoixNote is
    Port ( SigneAVECPourcent_1_329Hz : in  STD_LOGIC_VECTOR(4 downto 0);
           SigneAVECPourcent_2_246Hz : in  STD_LOGIC_VECTOR(4 downto 0);
           SigneAVECPourcent_3_196Hz : in  STD_LOGIC_VECTOR(4 downto 0);
           SigneAVECPourcent_4_146Hz : in  STD_LOGIC_VECTOR(4 downto 0);
           SigneAVECPourcent_5_110Hz : in  STD_LOGIC_VECTOR(4 downto 0);
           SigneAVECPourcent_6_082Hz : in  STD_LOGIC_VECTOR(4 downto 0);
			  Clk : in STD_LOGIC;
           Note : out  STD_LOGIC_VECTOR(2 downto 0);
           Pourcentage : out  STD_LOGIC_VECTOR(3 downto 0);
           Signe : out  STD_LOGIC;
           Bad_ftment : out  STD_LOGIC);
			  
end ChoixNote;

architecture Behavioral of ChoixNote is

begin
	process(Clk,SigneAVECPourcent_1_329Hz, SigneAVECPourcent_2_246Hz, SigneAVECPourcent_3_196Hz,
            SigneAVECPourcent_4_146Hz, SigneAVECPourcent_5_110Hz, SigneAVECPourcent_6_082Hz)
    begin
	 if(rising_edge(Clk)) then
        if SigneAVECPourcent_1_329Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_1_329Hz(3 downto 0);
				Note <= "001";
				Signe <= SigneAVECPourcent_1_329Hz(4);
				Bad_ftment <= '0';
        elsif SigneAVECPourcent_2_246Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_2_246Hz(3 downto 0);
				Note <= "010";
				Signe <= SigneAVECPourcent_2_246Hz(4);
				Bad_ftment <= '0';
        elsif SigneAVECPourcent_3_196Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_3_196Hz(3 downto 0);
				Note <= "011";
				Signe <= SigneAVECPourcent_3_196Hz(4);
				Bad_ftment <= '0';
        elsif SigneAVECPourcent_4_146Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_4_146Hz(3 downto 0);
				Note <= "100";
				Signe <= SigneAVECPourcent_4_146Hz(4);
				Bad_ftment <= '0';
        elsif SigneAVECPourcent_5_110Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_5_110Hz(3 downto 0);
				Note <= "101";
				Signe <= SigneAVECPourcent_5_110Hz(4);
				Bad_ftment <= '0';
        elsif SigneAVECPourcent_6_082Hz(3 downto 0) /= "1111" then
            Pourcentage <= SigneAVECPourcent_6_082Hz(3 downto 0);
				Note <= "110";
				Signe <= SigneAVECPourcent_6_082Hz(4);
				Bad_ftment <= '0';
        else
            Pourcentage <= "1111";  -- pour signaler aucun signal détecté
				Bad_ftment <= '1';

        end if;
	 end if;
    end process;

end Behavioral;

