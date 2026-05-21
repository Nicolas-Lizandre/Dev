////////////////////////////////////////////
// ENSEA 2024-2025 STM32L476 version
// STARTUP LAB
// VERSION 2024/12/06
////////////////////////////////////////////
// COMMON DIRECTIVES to Use ASM Language
  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

////////////////////////// WE START HERE
	.global Reset_Handler
	.text
Reset_Handler:
// 1:initializations to clear the stack
	mov R6,#0
	ldr	R7,=0x20017FF0
	str R6,[R7]
	ADD R7,#4
	str R6,[R7]
	ADD R7,#4
	str R6,[R7]
	ADD R7,#4
	str R6,[R7]
// 2:initialization of the stack pointer
	ldr	SP,=0x20018000 //(just after the RAM)
// 3:other initialization
	ldr	R0,=0x20000000 // at the beginning of the RAM
	MOV R1,#1
	STR R1,[R0]
 	B Test_FUNCTN

//////////////

///////////////////
	.global STACKA
	.text
STACKA:
	MOV R4,#234
	MOV R5,#235
	MOV R6,#236

	PUSH {R4}
	PUSH {R5}
	PUSH {R6}

	MOV R4,#0
	MOV R5,#0
	MOV R6,#0

	POP {R4}
	POP {R5}
	POP {R6}

END_STACKA: B END_STACKA

////////////////////////

///////////////////
	.global STACKB
	.text
STACKB:
	MOV R4,#234
	MOV R5,#235
	MOV R6,#236

	PUSH {R4}
	PUSH {R5}
	PUSH {R6}

	MOV R4,#0
	MOV R5,#0
	MOV R6,#0

	POP {R6}
	POP {R5}
	POP {R4}

END_STACKB: B END_STACKB

////////////////////////


////////////////////////
	.global Test_FUNCT1
	.text
Test_FUNCT1:

	MOV R4,#2 //first variable is 2
	MOV R5,#6 //second variable is 6
       	BL FUNCT1	//call of FUNCT1
       	ADD R4,R4,R5 // addition of the two variables
END_Test_FUNCT1: B END_Test_FUNCT1
//////////////////
	.global FUNCT1
	.text
FUNCT1:
        MOV R4,#0	// That's it!
        MOV R5,#0 	// Not very useful we must admit it!
		BX LR		//and no more
/////////////////////////////////

///////////////////////
	.global Test_FUNCT2
	.text
Test_FUNCT2:
	MOV R4,#2 //first variable is 2
	MOV R5,#6 //second variable is 6
       	BL FUNCT2	//call of FUNCT2
       	ADD R4,R4,R5 // addition of the two variables
END_Test_FUNCT2: B END_Test_FUNCT2
//////////////////
	.global FUNCT2
	.text
FUNCT2:
		PUSH {LR}
        MOV R4,#0	// That's it!
        MOV R5,#0 	// Not very useful again I must admit it!
		POP {PC}	//and no more
/////////////////////////////////

///////////////////////
	.global Test_FUNCT3
	.text
Test_FUNCT3:
	MOV R4,#2 //first variable is 2
	MOV R5,#6 //second variable is 6
       	BL FUNCT3	//call of FUNCT3
       	ADD R4,R4,R5 // addition of the two variables
END_Test_FUNCT3: B END_Test_FUNCT3
//////////////////
	.global FUNCT3
	.text
FUNCT3:
		PUSH {R4,R5,LR}
        MOV R4,#0	// That's it!
        MOV R5,#0 	// Not very useful again I must admit it!
		POP {R4,R5,PC}	//and no more
/////////////////////////////////////

/////////////////////////
	.global Test_FUNCT4_5
	.text
Test_FUNCT4_5:
	MOV R4,#2 //first variable is 2
	MOV R5,#6 //second variable is 6
       	BL FUNCT4	//call of FUNCT4
       	ADD R4,R4,R5 // addition of the two variables
END_Test_FUNCT4_5: B END_Test_FUNCT4_5
//////////////////
	.global FUNCT4
	.text
FUNCT4:
        PUSH {R4,R5,LR}
        MOV R4,#3 //first variable is 3
        MOV R5,#7 //second variable is 7
        BL FUNCT5 // remember: the call of a function should be transparent for variables
        ADD R4,R4,R5 // addition of the 2 variables
		POP {R4,R5,PC}
//////////////////
	.global FUNCT5
	.text
FUNCT5:
        MOV R4,#0
        MOV R5,#0
        BX LR
/////////////

/////////////////////////
	.global Test_FUNCT6_7
	.text
Test_FUNCT6_7:
	MOV R4,#2 //first variable is 2
	MOV R5,#6 //second variable is 6
       	BL FUNCT6	//call of FUNCT6
       	ADD R4,R4,R5 // addition of the two variables
END_Test_FUNCT6_7: B END_Test_FUNCT6_7
//////////////////
	.global FUNCT6
	.text
FUNCT6:
        PUSH {R4,R5}
        MOV R4,#3 //first variable is 3
        MOV R5,#7 //second variable is 7
        BL FUNCT7 // remember: the call of a function should be transparent for variables
        ADD R4,R4,R5 // addition of the 2 variables
	POP {R4,R5}
	BX LR
//////////////////
	.global FUNCT7
	.text
FUNCT7:
	PUSH {R4,R5}
        MOV R4,#0
        MOV R5,#0
        POP {R4,R5}
        BX LR
/////////////

///////////////////////
	.global Test_FUNCTN
	.text
Test_FUNCTN:
// R0 is the entering parameter of FUNCTN
		MOV 	R0,#1125
		BL 		FUNCTN
// after a call R0 is expected to store the result
// We copy it in R4:
		MOV R4,R0
END_Test_FUNCTN: B END_Test_FUNCTN
//////////////////
	.global FUNCTN
	.type  FUNCTN, %function
	.text
FUNCTN: 	PUSH 	{R4,LR}
// R0 is the first entering parameter of FUNCTN
		CMP 	R0,#1
		BEQ 	RET_FUNCTN
		MOV 	R4,R0
		SUB 	R0,#1 // before a call R0 is the entering parameter
		BL 		FUNCTN
		MUL		R0,R4 // after a call R0 is the return value
RET_FUNCTN:
		POP		{R4,PC}
///////////////////////

//////////////////
	.global YOURFUNCT
	.type  YOURFUNCT, %function
	.text
YOURFUNCT: 	PUSH 	{R4,LR}
// R0 is the first entering parameter of FUNCTN
// insert your code here

		POP		{R4,PC}
///////////////////////




