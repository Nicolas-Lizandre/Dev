/*
 * mesure_consommation_courant.c
 *
 *  Created on: Jun 19, 2024
 *      Author: antotauv
 */
#include "main.h"
#include "mesure_consommation_courant.h"
#include "led.h"
#include "bmm150.h"
#include "spi.h"
#include <stdio.h>
#define SIZE 16
#define CHIP_ID_ADRESS 0x40
void setup(){
	printf("**** TP5 : liaisons et bus, consommation electrique**** \n\r");
	HAL_TIM_Base_Start(&htim4);
	HAL_ADC_Start_IT(&hadc1);
	if (initDriverBMM150(&hspi2)==1){
		int8_t pData[SIZE];
		readOneRegister(CHIP_ID_ADRESS);
		readManyRegister(CHIP_ID_ADRESS, pData, SIZE);
		while(1){
		float a = readAngle();
		printf("angle : %f \n\r",a);}
	}

}

void loop(){
	HAL_PWR_EnterSLEEPMode(NULL,PWR_SLEEPENTRY_WFI);
}

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin){
	static int isOn=0;
	if(GPIO_Pin==ENC_BTN_Pin){
		printf("BTN pressed \n\r");
		LED_Set_Value_With_Int((isOn==0)?0:255);
		isOn=1-isOn;
		LED_Update();
	}
}

void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *hadc){
	if(hadc->Instance == ADC1){
		uint16_t adc_read=HAL_ADC_GetValue(&hadc1);
		float voltage = (adc_read*3.3)/4095;
		float intensity = (voltage*1000)/(0.4*200);
		//printf("Mesure courant : %d \t %f \t %f\r\n",(int) adc_read, voltage, intensity);   Desactivé pour voir autre chose
	}
}
