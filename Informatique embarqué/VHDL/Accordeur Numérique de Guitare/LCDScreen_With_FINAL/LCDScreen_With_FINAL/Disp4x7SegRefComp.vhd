----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:25:47 11/07/2011 
-- Design Name: 
-- Module Name:    Disp4x7SegRefComp - Behavioral 
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

---Pour choper PINs
---https://digilent.com/reference/_media/basys2/basys2_rm.pdf?rev=1440716164

entity Disp4x7SegRefComp is
    Port ( 	Clk : in std_logic;
				--DataA : in  STD_LOGIC_VECTOR (3 downto 0); 
			   --DataB : in  STD_LOGIC_VECTOR (3 downto 0); 
				--DataC : in  STD_LOGIC_VECTOR (3 downto 0);
				--DataD : in  STD_LOGIC_VECTOR (3 downto 0);
				Pourcentage : in  STD_LOGIC_VECTOR (3 downto 0):="0001"; ---Pourcentage
				Signe : in  STD_LOGIC:='1'; --Signe
				Bad_ftment : in STD_LOGIC; 
				Note : in STD_LOGIC_VECTOR(2 downto 0);
				Anodes : out  STD_LOGIC_VECTOR (3 downto 0);
				Cathodes : out  STD_LOGIC_VECTOR (6 downto 0));
end Disp4x7SegRefComp;

architecture Behavioral of Disp4x7SegRefComp is

signal DataA : STD_LOGIC_VECTOR (3 downto 0); 
signal DataB : STD_LOGIC_VECTOR (3 downto 0); 
signal DataC : STD_LOGIC_VECTOR (3 downto 0);
signal DataD : STD_LOGIC_VECTOR (3 downto 0);

type MATRICE is array (0 to 15) of STD_LOGIC_VECTOR (6 downto 0);--tochange

signal Data4x4Bits : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal Adressage : STD_LOGIC_VECTOR (3 downto 0) := x"0";

-- signal Comptage : STD_LOGIC_VECTOR (3 downto 0) := x"0";
-- alias Decodage is Comptage (3 downto 2);
signal Comptage : STD_LOGIC_VECTOR (17 downto 0) := (others =>'0'); --Coupé de 19->17 car 2 dernières broches servent à rien 
alias Decodage is Comptage (17 downto 16);                    --(code de Gray: On a toujours une répartition équilibrée de "00"/"01"/"10" et "11")

constant CODAGE7SEGMENTS : MATRICE := ("1000000", -- Caractere "0"
                                       "1111001", -- Caractere "1"
                                       "0100100", -- Caractere "2"
                                       "0110000", -- Caractere "3"
                                       "0011001", -- Caractere "4"
                                       "0010010", -- Caractere "5"
                                       "0000010", -- Caractere "6"
                                       "1111000", -- Caractere "7"
                                       "0000000", -- Caractere "8"
                                       "0010000", -- Caractere "9"
                                       "0001000", -- Caractere "A"
                                       "0000011", -- Caractere "b"
                                       "1000110", -- Caractere "C"
                                       "0101011", -- Caractere "n"
													"0111111", -- Caractere "-"
													"1111111"  -- Caractere " "
													);

begin

process (CLK)
	begin
		if (CLK' event and CLK = '1') then
			 Comptage <= Comptage + '1';
		end if;
end process;


Anodes <= "1110" when Decodage = "00" else 
	       "1101" when Decodage = "01" else 
	       "1011" when Decodage = "10" else 
	       "0111";

DataA <= Pourcentage; --Pourcentage (void se fait automatiquement + haut)
DataB <= "1111" when (Signe='0') else "1110";	   -- rien ou -
DataC <= "1111" when (Bad_ftment='0') else "0000"; -- rien ou le o de no
DataD <= "0"&Note when (Bad_ftment='0') else "1101"; -- la note ou le n de no

Data4x4Bits <= DataD & DataC & DataB & DataA; 
Adressage <= Data4x4Bits (((CONV_INTEGER(Decodage) * 4) + 3) downto (CONV_INTEGER(Decodage) * 4));	
Cathodes <= CODAGE7SEGMENTS (CONV_INTEGER(Adressage)); 

end Behavioral;
