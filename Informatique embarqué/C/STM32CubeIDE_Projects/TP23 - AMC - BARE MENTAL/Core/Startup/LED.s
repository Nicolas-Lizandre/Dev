// COMMON DIRECTIVES to Use ASM Language
 .syntax unified
 .cpu cortex-m4
 .fpu softvfp
 .thumb
 //////////////////
// Here is a pattern to write your own functions
// Do not forget to replace all 3 occurences of YOURFUNCT
//////////////////

//.global YOURFUNCT
//.type YOURFUNCT, %function
//.text
// a label must be followed by :
// YOURFUNCT: PUSH {R4,LR}
// R0 is always the first entering parameter then R1,R2,R3
// R4 is always the first variable then R5,R6..
// insert your code here
// the return value must be copied in R0 before return
// POP {R4,PC}
///////////////////////
// To call this code in ASM: BL YOURFUNCT
///////////////////////
// To call this function in C: YOURFUNCT();
// add the right prototype: void YOURFUNCT(void); in header file (*.h)
///////////////////////
//The starting point of your code (remember previous lab) is given by this label:

Reset_Handler:
.global LED_Enable
.type LED_Enable, %function
.text
//Activation du port GPIOA|Ecriture à l'adresse de RCC_AHB2ENR
LED_Enable: PUSH {R9,LR} //Adresse à récupérer pour sortir de la fonction
            MOV R4,#1 //Le 1 a mettre dans GPIOA
            MOV R5,#4 //R5,R6 etR7 servent à faire l'adresse ABH2....
            LSL R5,R5,#28
            MOV R6,#33 //0x21
            LSL R6,#12
            MOV R7,#76 //0x4C
            //Add
            ADD R7,R7,R6
            ADD R7,R7,R5
            //Ecriture
            LDR R0,[R7]
            ORR R4,R0
            STR R4,[R7]

            POP {R9,LR}   //Sortie de la fonction
            BX LR


//Configuration de la LED verte
.global LED_Configure
.type LED_Configure, %function
.text
LED_Configure: PUSH {R9,LR}//Dans le doute, on modif tout les registres pour notre LED
               MOV R4,#72 //0x48
			   LSL R4,#24//Création de l'adresse du MODER

			   //Masque pour 11e et 10e bit + Cas MODER
			   MOV R5,#3 // 0b11
			   LSL R5,#10//Création du masque (qui sera utilisé pour OSPEED et OTYPER)
			   MOV R6,#1
			   LSL R6,#11//Pour faire passer le 11e bit de 1 à 0 du MODER

			   //MODER
			   LDR R0,[R4] //Load de l'état actuel du MODER
			   ORR R0,R5   //xxXXxx->xx11xx
			   EOR R0,R6   //xx11xx->xx01xx
			   STR R0,[R4]

			   //OTYPER
			   ADD R4,#4   //Pour se mettre à 0x48000004 adresse du OTYPER
			   MOV R7,#32
			   LDR R0,[R4]//
			   ORR R0,R7 //xxXxx->xx1xx
			   EOR R0,R7 //xx1xx->xx0xx
			   STR R0,[R4]

			   //OSPEEDR
			   ADD R4,#4   //Pour se mettre à 0x48000008 adresse du OSPEEDR
			   LDR R0,[R4] //Load de l'état actuel du OPUPDR
			   ORR R0,R5   //xxXXxx->xx11xx
			   EOR R0,R5   //xx11xx->xx00xx
			   STR R0,[R4]

			   //OPUPDR
			   ADD R4,#4   //Pour se mettre à 0x4800000C adresse du OPUPDR
			   LDR R0,[R4] //Load de l'état actuel du OPUDR
			   ORR R0,R5   //xxXXxx->xx11xx
			   EOR R0,R5   //xx11xx->xx00xx
			   STR R0,[R4]

               POP {R9,LR}
               BX LR
//Configuration de la LED verte
.global LED_DriveGreen
.type LED_DriveGreen, %function
.text
//la ft a l'arg val qui va être mis à R0 [les fts asm n'ont pas besoin d'être typé ICI],
//si R0,R1etR2 sont déjà affectés alors les autrres paramèters vont dans le Stack
LED_DriveGreen: PUSH {R4,R7,R8,R9,LR}
                MOV R4,#72
                LSL R4,#24
                ADD R4,R4,#20 //Création de l'adresse GPIOA_ODR
                //Comparaison
                MOV R9,R0   //Transparence à garantir, on ne doit pas modif R0
                AND R9,#1   //Le but est d'extraire le LSB (avoir XXXXX -> 0000X), permet de traiter les cas si nb != 0 et 1
                CMP R9,#1 //On veut voir si R9!=1
                BNE ELSE //Exécuté si condition non vérifiée
                //Ecriture si val=1 (R9=1)
                MOV R7,#32
                LDR R8,[R4] //Load de l'état actuel du ODR
			    ORR R8,R7   //xxXxx->xx1xx
			    STR R8,[R4]
			    B END_DG
			    //Ecriture si val=0 (R9=0)
ELSE:           MOV R7,#32
                LDR R8,[R4] //Load de l'état actuel du ODR
			    ORR R8,R7   //xxXxx->xx1xx
			    EOR R8,R7   //xx1xx->xx0xx
			    STR R8,[R4]
END_DG:
                POP {R4,R7,R8,R9,PC}
                BX LR



