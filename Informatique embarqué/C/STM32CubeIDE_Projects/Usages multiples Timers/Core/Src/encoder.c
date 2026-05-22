/*
 * encoder.c
 *
 *  Created on: Nov 22, 2024
 *      Author: nicol
 */

#include "encoder.h"
static ENCODER encoder;
void encoder_init(TIM_HandleTypeDef * htim_param, int32_t min, int32_t max){
	encoder.htim = htim_param;
	encoder.htim->Instance->CNT=0;
	encoder.max_value = max;
	encoder.min_value = min;
	HAL_TIM_Encoder_Start(encoder.htim,TIM_CHANNEL_ALL);
	return;
}

int32_t encoder_read(){
	int32_t cpt = encoder.htim->Instance->CNT;
	if(cpt <encoder.min_value){
		encoder.htim->Instance->CNT =encoder.min_value;
		}
	if(cpt > encoder.max_value){
		encoder.htim->Instance->CNT = encoder.max_value;
		}
	return encoder.htim->Instance->CNT;
}

