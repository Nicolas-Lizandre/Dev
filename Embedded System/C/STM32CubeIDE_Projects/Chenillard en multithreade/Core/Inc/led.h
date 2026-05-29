/*
 * led.h
 *
 *  Created on: Nov 8, 2024
 *      Author: nicol
 */

#ifndef INC_LED_H_
#define INC_LED_H_
//#include <stm32l4xx_hal.h>
typedef struct led {
int isOn;
GPIO_TypeDef* port;
uint16_t pinNumber;
}LED;
void LED_Update();
void LED_Set_Value_With_Int(int value);
void LED_Test_All();

#endif /* INC_LED_H_ */
