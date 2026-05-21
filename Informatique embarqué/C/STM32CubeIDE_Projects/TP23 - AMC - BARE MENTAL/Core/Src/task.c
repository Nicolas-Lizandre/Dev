/*
 * task.c
 *
 *  Created on: Mar 3, 2025
 *      Author: nicol
 */
#include "task.h"
#include "button.h"
#include "LED.h"
#include "main.h"
///PARTIE 6

int Timelnms;
typedef enum {DRAW_WAIT_LAUNCH,DRAW_ANIMATION,DRAW_BLINK,DRAW_RESULT}DRAW;
DRAW DrawState;
int LEDSSPEED;
int Position;
extern TIM_HandleTypeDef htim4;
int TimePartie6;
int speed;
int TimeAllocated;
int WaitPartie6=0;
int CycleBlink=0;
void TASK_Init(){
	HAL_TIM_Base_Start_IT(&htim4);
	TimePartie6=0;
	DrawState=DRAW_WAIT_LAUNCH;
	LEDSSPEED=1000; //Ch de position une toutes les 5s
	TimeAllocated=2000; //Choisi (orth) arbitrairement
	Position=0;
	LED_Set_Value_With_Int(1); //On veut qu'uniquement la LED en position 0 soit allumée
	LED_Update();
}
///


int Button_has_been_pressed = 1;
void TASK_Button(){
	Button_has_been_pressed = BUTTON_GetBluePressed();}

#define OFF 0
float List_LEDspeed[]={OFF,2,0.5,0.125}; //période en seconde
float GREEN_LED_Speed = OFF;
//Parce que je ne veux pas manipuler des chaines de caractères
#define GREEN_LED_OFF 0
#define GREEN_LED_SLOW 1
#define GREEN_LED_MEDIUM 2
#define GREEN_LED_FAST 3
void TASK_Evolve(){ //Est appelée séparemment par soucis d'allocation temporelle
	TimePartie6=TimePartie6+3*5;
	WaitPartie6 =WaitPartie6+3*5;
	static int GREEN_LED_State = 0;
	if (Button_has_been_pressed == 1){
	switch(GREEN_LED_State){
	case GREEN_LED_OFF : GREEN_LED_Speed=List_LEDspeed[GREEN_LED_OFF]; break;
	case GREEN_LED_SLOW : GREEN_LED_Speed=List_LEDspeed[GREEN_LED_SLOW]; break;
	case GREEN_LED_MEDIUM : GREEN_LED_Speed=List_LEDspeed[GREEN_LED_MEDIUM]; break;
	case GREEN_LED_FAST : GREEN_LED_Speed=List_LEDspeed[GREEN_LED_FAST]; break;}

	GREEN_LED_State = (GREEN_LED_State+1)%4;
	}
	if(DrawState == DRAW_WAIT_LAUNCH){
		if (BUTTON_GetPressed(LEFT)==1){}
		if (BUTTON_GetPressed(DOWN)==1){}
		if (BUTTON_GetPressed(UP)==1){}
		if (BUTTON_GetPressed(RIGHT)==1){}
		if (BUTTON_GetPressed(CENTER)==1){ //Problème ici !
			TimePartie6=0;
			DrawState = DRAW_ANIMATION;
			WaitPartie6=0;
		}
	}
	else {
		if(TimePartie6 < TimeAllocated){
			speed = LEDSSPEED;
			DrawState=DRAW_ANIMATION;
			static int PositionStock;
			speed =speed -5; // Ralentissement "linéaire"
			if((TimePartie6/speed) > 1){
				speed= LEDSSPEED+speed; //On "reset"
				PositionStock=Position;
				Position=(Position+1)%8;
				LED_Set_Value_With_Int(LED_Get_Value()|(1<<Position));
				LED_Set_Value_With_Int(LED_Get_Value()&(0xFF -(1<<(PositionStock))));
				LED_Update();
			}
			return;}
		}
		if(TimePartie6 > TimeAllocated+1000){//On veut que cet état le soit pendant 1s
			TimePartie6 =0;
			DrawState =DRAW_WAIT_LAUNCH; //Je veux que l'on puisse faire plusieurs tirages !

			return;
		}
		if(TimePartie6 > TimeAllocated){
			speed = LEDSSPEED;
			DrawState =DRAW_BLINK;
			CycleBlink=WaitPartie6%200;//oui il y a décalage et tant pis
			if(CycleBlink > WaitPartie6/2){
				LED_Set_Value_With_Int(LED_Get_Value()|(1<<Position));
				LED_Update();
			}
			else{LED_Set_Value_With_Array(LED_Get_Value()&(0xFF &(1<<Position)));
			LED_Update();//Tentative pour xxx1xxx -> xxx0xxx
			}
			//clignoter toutes les 0.2 secondes revient à être activé 0.1s toutes les 7 WaitNCycle
			return;
		}

}

uint32_t TempsCourant = 0;
int WaitcycleN=0; //par paquets de 5ms
void TASK_LED(){ //Le tour de Task_LED est toutes les 15ms
	WaitcycleN=WaitcycleN+3*5;
	static int GreenLED_state=1;
	if(GREEN_LED_Speed == OFF){
		LED_DriveGreen(0); //Pour éteindre la LED
		GreenLED_state=0;
		return;}
	if( WaitcycleN >= GREEN_LED_Speed *1000){// Periode   //Rajouter HAL_TIM_GET_COUNTER(&htim4)/1000  pour plus de précision
		WaitcycleN=0;
		LED_DriveGreen(1-GreenLED_state);
		GreenLED_state=1-GreenLED_state;
	}
	return;

}


