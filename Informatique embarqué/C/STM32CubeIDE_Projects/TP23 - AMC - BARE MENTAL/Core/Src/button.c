/*
 * button.c
 *
 *  Created on: Feb 10, 2025
 *      Author: nicol
 */
#include "button.h"
#include "main.h"
#include "LED.h"
#include <math.h>

extern BUTTON joystick[5] = {
{0,0,BTN_CENTER_GPIO_Port,BTN_CENTER_Pin},
{0,0,BTN_BOTTOM_GPIO_Port,BTN_BOTTOM_Pin},
{0,0,BTN_RIGHT_GPIO_Port,BTN_RIGHT_Pin},
{0,0,BTN_TOP_GPIO_Port,BTN_TOP_Pin},
{0,0,BTN_LEFT_GPIO_Port,BTN_LEFT_Pin}
};



//Button enable
int * ptEna=0x48000800;
int * Rcc = 0x4002104C;
void BUTTON_Enable(){
*Rcc=*Rcc | 0x4; //Voir slide 23 du 3e cours (on a oublié d'activer l'horloge de GPIOC
*ptEna = *ptEna & 0xF3FFFFFF; }//Masque logique mettant MODE_PC13 à 00 [Input Mode]

//Button Config
int * ptConfig =0x4800080C;
void BUTTON_Config(){
*ptConfig = *ptConfig & 0xF3FFFFFF; //Masque logique mettant PUPDR_PC13 à 00
*ptConfig = *ptConfig | 0x04000000; //Masque logique mettant PUPDR_PC13 à 10 //Essai à 01 (pull-up)
int b = *ptConfig;
}

int BUTTON_GetBlueLevel(){
	return HAL_GPIO_ReadPin(GPIOC, pow(2,13)); //On veut mettre 1 au 13e bit
}

int BUTTON_GetBluePressed(){
	joystick->isOn=1;
	static int BB_PreviousValue=1;
	if ((BUTTON_GetBlueLevel()== 1) & (BB_PreviousValue==0)){BB_PreviousValue=1;}//unpressed
	if ((BUTTON_GetBlueLevel()== 0) & (BB_PreviousValue==1)){BB_PreviousValue=0; return 1;}//pressed
	return 0;
}


int BUTTON_GetValue(DIRECTION direction) {
return joystick[direction].isOn;
}
int BUTTON_GetPressed(DIRECTION direction) {
int pressed;
pressed=joystick[direction].hasBeenPressed;
joystick[direction].hasBeenPressed=0;
// when read, a button is no more pressed
return pressed;
}//Lorsque l'on relache notre doigt, on veut le démarrage !


void BUTTON_IT_GET(DIRECTION direction,int a){
	joystick[direction].isOn=a;
	joystick[direction].hasBeenPressed=a;
}
