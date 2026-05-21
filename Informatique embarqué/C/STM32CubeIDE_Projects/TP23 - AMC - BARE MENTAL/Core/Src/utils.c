/*
 * utils.c
 *
 *  Created on: Feb 10, 2025
 *      Author: nicol
 */
#include "button.h"
#include "LED.h"
#include "utils.h"
#include "main.h"
int GreenLED_state;
int LED_N10ms;


void LED_WaitN10ms(int N){
	int n=0;
	int i=0;
	int s=0;
	for(n=1;n<=N;n++){
		for(i=0;i<=2500;i++){
			s=s+i;
		}
	}
}
int a =0;
void loop(){ //A loop independemment de main? -oui
	//if BUTTON_GetBlueLevel()
	//LED_DriveGreen(GreenLED_state);
	//HAL_Delay(BUTTON_GetBlueLevel());
	//GreenLED_state=1-GreenLED_state;
	a=BUTTON_GetBlueLevel();
	LED_DriveGreen(a);

}

void setup(){
	GreenLED_state=0;
	LED_N10ms = 100;
}
