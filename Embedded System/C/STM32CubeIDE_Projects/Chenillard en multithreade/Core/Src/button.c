/*
 * button.c
 *
 *  Created on: Jun 14, 2024
 *      Author: nicohaas57
 */

#include "button.h"

//typedef enum direction{CENTER, DOWN, RIGHT, UP, LEFT}DIRECTION; //aaaaaaaaaaaaaaaa

static BUTTON joystick[5] = {{0,0,BTN_CENTER_GPIO_Port,BTN_CENTER_Pin}, {0,0,BTN_BOTTOM_GPIO_Port,BTN_BOTTOM_Pin},
							 {0,0,BTN_RIGHT_GPIO_Port,BTN_RIGHT_Pin}, {0,0,BTN_TOP_GPIO_Port,BTN_TOP_Pin},
							 {0,0,BTN_LEFT_GPIO_Port,BTN_LEFT_Pin}
};

int BUTTON_Get_Value(DIRECTION direction) {
	return joystick[direction].isOn;
}

int BUTTON_Get_Pressed(DIRECTION direction) {
	return joystick[direction].hasBeenPressed;
}

void BUTTON_Update() {
	int a=0;
	for(int i =0; i<= 5;i++){
		a=1-HAL_GPIO_ReadPin(joystick[i].port,joystick[i].pinNumber);
		joystick[i].hasBeenPressed = (1-joystick[i].isOn)*a;
		joystick[i].isOn = a;

	}
	return;
}
