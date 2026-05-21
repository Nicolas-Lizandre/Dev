/*
 * util.c
 *
 *  Created on: Sep 13, 2024
 *      Author: nicol
 */
#include <stdio.h>
#include "util.h"
void setup(){printf("Hello World ! \r\n");}
/* PROJET 1
void loop(){v++;
	  HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,GPIO_PIN_RESET);
  HAL_Delay(250);
  HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,GPIO_PIN_SET);
  HAL_Delay(250);
  printf("%d \n\r",v);}

PROJET 2

if (HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_13)==GPIO_PIN_SET){
	HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,1);}else{
	HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,0);}



*/
int e=0;
int v=0;
void loop(){while(1){if (HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_13)==GPIO_PIN_SET){
  	HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,1);
  	if(e==0){printf("%d\t 1\r\n",v); e=1; v++; }}
  else{if(e==1){printf("%d\t 0\r\n",v); e=0;  }
  	HAL_GPIO_WritePin(GPIOA,GPIO_PIN_5,0);}

}}
