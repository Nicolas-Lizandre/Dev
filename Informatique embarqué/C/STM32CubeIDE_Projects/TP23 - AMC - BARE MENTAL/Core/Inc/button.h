/*
 * button.h
 *
 *  Created on: Feb 10, 2025
 *      Author: nicol
 */

#ifndef INC_BUTTON_H_
#define INC_BUTTON_H_

void BUTTON_Enable();
void BUTTON_Config();
int BUTTON_GetBlueLevel();
int BUTTON_GetBluePressed();

//Pour la Partie 6

#include "main.h"
typedef struct button {
int isOn;
int hasBeenPressed;
GPIO_TypeDef* port;
uint16_t pinNumber;
}BUTTON;
typedef enum direction{CENTER, DOWN, RIGHT, UP, LEFT}DIRECTION;
int BUTTON_GetValue(DIRECTION direction);
int BUTTON_GetPressed(DIRECTION direction);
#define BTN_CENTER_Pin GPIO_PIN_5
#define BTN_CENTER_GPIO_Port GPIOC
#define BTN_BOTTOM_Pin GPIO_PIN_11
#define BTN_BOTTOM_GPIO_Port GPIOB
#define BTN_RIGHT_Pin GPIO_PIN_9
#define BTN_RIGHT_GPIO_Port GPIOC
#define BTN_TOP_Pin GPIO_PIN_8
#define BTN_TOP_GPIO_Port GPIOC
#define BTN_LEFT_Pin GPIO_PIN_6
#define BTN_LEFT_GPIO_Port GPIOC

int BUTTON_GetValue(DIRECTION direction);
int BUTTON_GetPressed(DIRECTION direction);
void BUTTON_IT_GET(DIRECTION direction,int a);
#endif /* INC_BUTTON_H_ */

