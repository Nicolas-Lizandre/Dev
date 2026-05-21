/*
 * LED.h
 *
 *  Created on: Feb 2, 2025
 *      Author: nicol
 */

#ifndef SRC_LED_H_
#define SRC_LED_H_

void LED_Enable(void);
void LED_Configure(void);
void LED_DriveGreen(int val);

#include "main.h"
typedef struct led {
int isOn;
GPIO_TypeDef* port;
uint16_t pinNumber;
}LED;

void LED_Set_Value_With_Int(int value);
void LED_Set_Value_With_Array(int value[8]);
int LED_Get_Value();
void LED_Update();
void LED_Test_All();

#define LED_0_Pin GPIO_PIN_7
#define LED_0_GPIO_Port GPIOC
#define LED_1_Pin GPIO_PIN_2
#define LED_1_GPIO_Port GPIOB
#define LED_2_Pin GPIO_PIN_8
#define LED_2_GPIO_Port GPIOA
#define LED_3_Pin GPIO_PIN_1
#define LED_3_GPIO_Port GPIOB
#define LED_4_Pin GPIO_PIN_15
#define LED_4_GPIO_Port GPIOB
#define LED_5_Pin GPIO_PIN_4
#define LED_5_GPIO_Port GPIOB
#define LED_6_Pin GPIO_PIN_14
#define LED_6_GPIO_Port GPIOB
#define LED_7_Pin GPIO_PIN_5
#define LED_7_GPIO_Port GPIOB
#endif /* SRC_LED_H_ */
