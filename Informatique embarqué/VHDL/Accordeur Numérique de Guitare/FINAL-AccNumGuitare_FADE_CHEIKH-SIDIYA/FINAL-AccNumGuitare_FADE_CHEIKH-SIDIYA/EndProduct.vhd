--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2.04i
--  \   \         Application : sch2vhdl
--  /   /         Filename : EndProduct.vhf
-- /___/   /\     Timestamp : 03/31/2026 14:12:19
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: C:\PROGRAMS\Xilinx92i\bin\nt\sch2vhdl.exe -intstyle ise -family spartan3e -flat -suppress -w D:/Utilisateurs/lizafade50/Exemples/FINAL-AccNumGuitare_FADE_CHEIKH-SIDIYA/EndProduct.sch EndProduct.vhf
--Design Name: EndProduct
--Device: spartan3e
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesis and simulted, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity EndProduct is
   port ( Clk      : in    std_logic; 
          FreqVar  : in    std_logic; 
          ANODES   : out   std_logic_vector (3 downto 0); 
          CATHODES : out   std_logic_vector (6 downto 0));
end EndProduct;

architecture BEHAVIORAL of EndProduct is
   signal XLXN_63  : std_logic_vector (4 downto 0);
   signal XLXN_64  : std_logic_vector (4 downto 0);
   signal XLXN_65  : std_logic_vector (4 downto 0);
   signal XLXN_66  : std_logic_vector (4 downto 0);
   signal XLXN_67  : std_logic_vector (4 downto 0);
   signal XLXN_68  : std_logic_vector (4 downto 0);
   signal XLXN_72  : std_logic;
   signal XLXN_73  : std_logic;
   signal XLXN_74  : std_logic_vector (2 downto 0);
   signal XLXN_75  : std_logic_vector (3 downto 0);
   signal XLXN_167 : std_logic_vector (3 downto 0);
   signal XLXN_168 : std_logic;
   signal XLXN_169 : std_logic;
   signal XLXN_170 : std_logic_vector (3 downto 0);
   signal XLXN_171 : std_logic_vector (3 downto 0);
   signal XLXN_172 : std_logic;
   signal XLXN_173 : std_logic_vector (3 downto 0);
   signal XLXN_174 : std_logic;
   signal XLXN_175 : std_logic_vector (3 downto 0);
   signal XLXN_176 : std_logic;
   signal XLXN_177 : std_logic_vector (3 downto 0);
   signal XLXN_178 : std_logic;
   signal XLXN_179 : std_logic_vector (3 downto 0);
   signal XLXN_180 : std_logic;
   signal XLXN_185 : std_logic;
   signal XLXN_186 : std_logic;
   signal XLXN_191 : std_logic;
   signal XLXN_192 : std_logic;
   signal XLXN_193 : std_logic;
   signal XLXN_200 : std_logic_vector (3 downto 0);
   signal XLXN_201 : std_logic;
   signal XLXN_202 : std_logic;
   signal XLXN_203 : std_logic_vector (3 downto 0);
   signal XLXN_206 : std_logic;
   signal XLXN_208 : std_logic;
   signal XLXN_209 : std_logic;
   signal XLXN_210 : std_logic;
   signal XLXN_211 : std_logic_vector (3 downto 0);
   signal XLXN_213 : std_logic;
   signal XLXN_214 : std_logic;
   signal XLXN_215 : std_logic;
   signal XLXN_216 : std_logic;
   signal XLXN_218 : std_logic;
   signal XLXN_219 : std_logic;
   signal XLXN_220 : std_logic;
   signal XLXN_221 : std_logic;
   signal XLXN_222 : std_logic;
   signal XLXN_223 : std_logic;
   signal XLXN_224 : std_logic;
   signal XLXN_225 : std_logic;
   signal XLXN_226 : std_logic;
   signal XLXN_227 : std_logic;
   signal XLXN_228 : std_logic;
   signal XLXN_229 : std_logic_vector (3 downto 0);
   signal XLXN_230 : std_logic;
   signal XLXN_231 : std_logic;
   signal XLXN_232 : std_logic;
   signal XLXN_233 : std_logic_vector (3 downto 0);
   signal XLXN_235 : std_logic;
   signal XLXN_236 : std_logic;
   signal XLXN_237 : std_logic;
   signal XLXN_238 : std_logic;
   signal XLXN_239 : std_logic;
   signal XLXN_241 : std_logic;
   signal XLXN_247 : std_logic;
   signal XLXN_248 : std_logic;
   signal XLXN_249 : std_logic;
   signal XLXN_250 : std_logic;
   signal XLXN_251 : std_logic;
   signal XLXN_252 : std_logic;
   component ChoixNote
      port ( Clk                       : in    std_logic; 
             SigneAVECPourcent_1_329Hz : in    std_logic_vector (4 downto 0); 
             SigneAVECPourcent_2_246Hz : in    std_logic_vector (4 downto 0); 
             SigneAVECPourcent_3_196Hz : in    std_logic_vector (4 downto 0); 
             SigneAVECPourcent_4_146Hz : in    std_logic_vector (4 downto 0); 
             SigneAVECPourcent_5_110Hz : in    std_logic_vector (4 downto 0); 
             SigneAVECPourcent_6_082Hz : in    std_logic_vector (4 downto 0); 
             Signe                     : out   std_logic; 
             Bad_ftment                : out   std_logic; 
             Note                      : out   std_logic_vector (2 downto 0); 
             Pourcentage               : out   std_logic_vector (3 downto 0));
   end component;
   
   component Disp4x7SegRefComp
      port ( Clk         : in    std_logic; 
             Signe       : in    std_logic; 
             Bad_ftment  : in    std_logic; 
             Pourcentage : in    std_logic_vector (3 downto 0); 
             Note        : in    std_logic_vector (2 downto 0); 
             Anodes      : out   std_logic_vector (3 downto 0); 
             Cathodes    : out   std_logic_vector (6 downto 0));
   end component;
   
   component Sequenceur
      port ( Etat_0      : in    std_logic; 
             Mesure      : in    std_logic; 
             Init_Compt  : out   std_logic; 
             Charg_Reg   : out   std_logic; 
             Valid_Compt : out   std_logic; 
             SensCroiss  : out   std_logic; 
             Clk         : in    std_logic);
   end component;
   
   component Div_082Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component Div_110Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component Div_146Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component Div_196Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component Div_246Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component Div_329Hz
      port ( Clk     : in    std_logic; 
             FreqRef : out   std_logic);
   end component;
   
   component CompteurReversible
      port ( Init_Compt         : in    std_logic; 
             Valid_Compt        : in    std_logic; 
             SensCroiss         : in    std_logic; 
             FreqRef            : in    std_logic; 
             Clk                : in    std_logic; 
             Etat_0             : out   std_logic; 
             Pourcent_to_output : out   std_logic_vector (3 downto 0));
   end component;
   
   component Bus_Signe_AVEC_Pourcent
      port ( Signe               : in    std_logic; 
             Pourcent            : in    std_logic_vector (3 downto 0); 
             Signe_AVEC_Pourcent : out   std_logic_vector (4 downto 0));
   end component;
   
   component RegistreParallele
      port ( Charg_Reg          : in    std_logic; 
             SensCroiss         : in    std_logic; 
             Clk                : in    std_logic; 
             Pourcent_to_output : in    std_logic_vector (3 downto 0); 
             Sign_output        : out   std_logic; 
             Pourcent_in_use    : out   std_logic_vector (3 downto 0));
   end component;
   
   component Diviseur
      port ( FreqVar : in    std_logic; 
             Clk     : in    std_logic; 
             TVar100 : out   std_logic);
   end component;
   
begin
   XLXI_17 : ChoixNote
      port map (Clk=>Clk,
                SigneAVECPourcent_1_329Hz(4 downto 0)=>XLXN_66(4 downto 0),
                SigneAVECPourcent_2_246Hz(4 downto 0)=>XLXN_65(4 downto 0),
                SigneAVECPourcent_3_196Hz(4 downto 0)=>XLXN_64(4 downto 0),
                SigneAVECPourcent_4_146Hz(4 downto 0)=>XLXN_63(4 downto 0),
                SigneAVECPourcent_5_110Hz(4 downto 0)=>XLXN_67(4 downto 0),
                SigneAVECPourcent_6_082Hz(4 downto 0)=>XLXN_68(4 downto 0),
                Bad_ftment=>XLXN_73,
                Note(2 downto 0)=>XLXN_74(2 downto 0),
                Pourcentage(3 downto 0)=>XLXN_75(3 downto 0),
                Signe=>XLXN_72);
   
   XLXI_20 : Disp4x7SegRefComp
      port map (Bad_ftment=>XLXN_73,
                Clk=>Clk,
                Note(2 downto 0)=>XLXN_74(2 downto 0),
                Pourcentage(3 downto 0)=>XLXN_75(3 downto 0),
                Signe=>XLXN_72,
                Anodes(3 downto 0)=>ANODES(3 downto 0),
                Cathodes(6 downto 0)=>CATHODES(6 downto 0));
   
   XLXI_21 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_241,
                Mesure=>XLXN_239,
                Charg_Reg=>XLXN_180,
                Init_Compt=>XLXN_238,
                SensCroiss=>XLXN_210,
                Valid_Compt=>XLXN_237);
   
   XLXI_22 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_235,
                Mesure=>XLXN_236,
                Charg_Reg=>XLXN_185,
                Init_Compt=>XLXN_232,
                SensCroiss=>XLXN_209,
                Valid_Compt=>XLXN_231);
   
   XLXI_23 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_230,
                Mesure=>XLXN_226,
                Charg_Reg=>XLXN_186,
                Init_Compt=>XLXN_228,
                SensCroiss=>XLXN_206,
                Valid_Compt=>XLXN_227);
   
   XLXI_24 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_225,
                Mesure=>XLXN_224,
                Charg_Reg=>XLXN_191,
                Init_Compt=>XLXN_223,
                SensCroiss=>XLXN_202,
                Valid_Compt=>XLXN_222);
   
   XLXI_25 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_220,
                Mesure=>XLXN_216,
                Charg_Reg=>XLXN_192,
                Init_Compt=>XLXN_219,
                SensCroiss=>XLXN_201,
                Valid_Compt=>XLXN_218);
   
   XLXI_26 : Sequenceur
      port map (Clk=>Clk,
                Etat_0=>XLXN_221,
                Mesure=>XLXN_213,
                Charg_Reg=>XLXN_193,
                Init_Compt=>XLXN_215,
                SensCroiss=>XLXN_208,
                Valid_Compt=>XLXN_214);
   
   XLXI_35 : Div_082Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_252);
   
   XLXI_36 : Div_110Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_251);
   
   XLXI_37 : Div_146Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_250);
   
   XLXI_38 : Div_196Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_249);
   
   XLXI_39 : Div_246Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_247);
   
   XLXI_40 : Div_329Hz
      port map (Clk=>Clk,
                FreqRef=>XLXN_248);
   
   XLXI_41 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_248,
                Init_Compt=>XLXN_238,
                SensCroiss=>XLXN_210,
                Valid_Compt=>XLXN_237,
                Etat_0=>XLXN_241,
                Pourcent_to_output(3 downto 0)=>XLXN_179(3 downto 0));
   
   XLXI_42 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_247,
                Init_Compt=>XLXN_232,
                SensCroiss=>XLXN_209,
                Valid_Compt=>XLXN_231,
                Etat_0=>XLXN_235,
                Pourcent_to_output(3 downto 0)=>XLXN_233(3 downto 0));
   
   XLXI_43 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_249,
                Init_Compt=>XLXN_228,
                SensCroiss=>XLXN_206,
                Valid_Compt=>XLXN_227,
                Etat_0=>XLXN_230,
                Pourcent_to_output(3 downto 0)=>XLXN_229(3 downto 0));
   
   XLXI_44 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_250,
                Init_Compt=>XLXN_223,
                SensCroiss=>XLXN_202,
                Valid_Compt=>XLXN_222,
                Etat_0=>XLXN_225,
                Pourcent_to_output(3 downto 0)=>XLXN_203(3 downto 0));
   
   XLXI_45 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_251,
                Init_Compt=>XLXN_219,
                SensCroiss=>XLXN_201,
                Valid_Compt=>XLXN_218,
                Etat_0=>XLXN_220,
                Pourcent_to_output(3 downto 0)=>XLXN_200(3 downto 0));
   
   XLXI_46 : CompteurReversible
      port map (Clk=>Clk,
                FreqRef=>XLXN_252,
                Init_Compt=>XLXN_215,
                SensCroiss=>XLXN_208,
                Valid_Compt=>XLXN_214,
                Etat_0=>XLXN_221,
                Pourcent_to_output(3 downto 0)=>XLXN_211(3 downto 0));
   
   XLXI_48 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_177(3 downto 0),
                Signe=>XLXN_178,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_66(4 downto 0));
   
   XLXI_49 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_175(3 downto 0),
                Signe=>XLXN_176,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_65(4 downto 0));
   
   XLXI_50 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_173(3 downto 0),
                Signe=>XLXN_174,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_64(4 downto 0));
   
   XLXI_51 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_171(3 downto 0),
                Signe=>XLXN_172,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_63(4 downto 0));
   
   XLXI_52 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_170(3 downto 0),
                Signe=>XLXN_169,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_67(4 downto 0));
   
   XLXI_53 : Bus_Signe_AVEC_Pourcent
      port map (Pourcent(3 downto 0)=>XLXN_167(3 downto 0),
                Signe=>XLXN_168,
                Signe_AVEC_Pourcent(4 downto 0)=>XLXN_68(4 downto 0));
   
   XLXI_54 : RegistreParallele
      port map (Charg_Reg=>XLXN_180,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_179(3 downto 0),
                SensCroiss=>XLXN_210,
                Pourcent_in_use(3 downto 0)=>XLXN_177(3 downto 0),
                Sign_output=>XLXN_178);
   
   XLXI_55 : RegistreParallele
      port map (Charg_Reg=>XLXN_185,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_233(3 downto 0),
                SensCroiss=>XLXN_209,
                Pourcent_in_use(3 downto 0)=>XLXN_175(3 downto 0),
                Sign_output=>XLXN_176);
   
   XLXI_56 : RegistreParallele
      port map (Charg_Reg=>XLXN_186,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_229(3 downto 0),
                SensCroiss=>XLXN_206,
                Pourcent_in_use(3 downto 0)=>XLXN_173(3 downto 0),
                Sign_output=>XLXN_174);
   
   XLXI_57 : RegistreParallele
      port map (Charg_Reg=>XLXN_191,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_203(3 downto 0),
                SensCroiss=>XLXN_202,
                Pourcent_in_use(3 downto 0)=>XLXN_171(3 downto 0),
                Sign_output=>XLXN_172);
   
   XLXI_58 : RegistreParallele
      port map (Charg_Reg=>XLXN_192,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_200(3 downto 0),
                SensCroiss=>XLXN_201,
                Pourcent_in_use(3 downto 0)=>XLXN_170(3 downto 0),
                Sign_output=>XLXN_169);
   
   XLXI_59 : RegistreParallele
      port map (Charg_Reg=>XLXN_193,
                Clk=>Clk,
                Pourcent_to_output(3 downto 0)=>XLXN_211(3 downto 0),
                SensCroiss=>XLXN_208,
                Pourcent_in_use(3 downto 0)=>XLXN_167(3 downto 0),
                Sign_output=>XLXN_168);
   
   XLXI_61 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_239);
   
   XLXI_62 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_226);
   
   XLXI_63 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_224);
   
   XLXI_64 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_216);
   
   XLXI_65 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_213);
   
   XLXI_67 : Diviseur
      port map (Clk=>Clk,
                FreqVar=>FreqVar,
                TVar100=>XLXN_236);
   
end BEHAVIORAL;


