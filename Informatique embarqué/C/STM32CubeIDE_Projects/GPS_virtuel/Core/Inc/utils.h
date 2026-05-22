/*
 * utils.h
 *
 *  Created on: Apr 26, 2024
 *      Author: antotauv
 */

#ifndef INC_TP1_H_
#define INC_TP1_H_

#define BUFFER_MAX_SIZE 128
#include <stdio.h>
#include <stm32l4xx_hal.h>
int fillBuffer(char * buffer, int size);
extern UART_HandleTypeDef huart1;
void setup();
void loop();


#endif /* INC_TP1_H_ */
