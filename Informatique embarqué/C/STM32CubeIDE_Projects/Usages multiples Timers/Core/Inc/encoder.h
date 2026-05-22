/*
 * encoder.h
 *
 *  Created on: Nov 22, 2024
 *      Author: nicol
 */

#ifndef INC_ENCODER_H_
#define INC_ENCODER_H_
#include "main.h"
typedef struct encoder{
	TIM_HandleTypeDef * htim;
	int32_t max_value;
	int32_t min_value;
}ENCODER;

void encoder_init(TIM_HandleTypeDef * htim_param, int32_t min, int32_t max);
int32_t encoder_read();


#endif /* INC_ENCODER_H_ */
