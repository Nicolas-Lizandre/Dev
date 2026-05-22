/*
 * stepperMotor.c
 *
 *  Created on: Nov 22, 2024
 *      Author: nicol
 */
#include "stepperMotor.h"
#include "main.h"
#include <stdlib.h>
#include "tim.h"

static STEPPERMOTOR stepper_motor;
void init_stepper(STEPPERMOTOR stepper_motor){
	stepper_motor.htim_pwm= &htim3;
	stepper_motor.pwm_channel_number = 6;
	stepper_motor.gpio_direction = GPIOA;
	stepper_motor.gpio_direction_pin = 7;
	stepper_motor.gpio_ms1 = GPIOA;
	stepper_motor.gpio_ms1_pin = 11;
	stepper_motor.gpio_ms2 = GPIOB;
	stepper_motor.gpio_ms2_pin = 12;
	stepper_motor.gpio_enable = GPIOA;
	stepper_motor.gpio_enable_pin = 12;
	HAL_GPIO_WritePin(stepper_motor.gpio_direction, stepper_motor.gpio_direction_pin,0);
	HAL_GPIO_WritePin(stepper_motor.gpio_enable, stepper_motor.gpio_enable_pin,1);
	HAL_GPIO_WritePin(stepper_motor.gpio_ms1, stepper_motor.gpio_ms1_pin,0);
	HAL_GPIO_WritePin(stepper_motor.gpio_ms2, stepper_motor.gpio_ms2_pin,0);
	stepper_motor.htim_pwm->Instance->CCR1=stepper_motor.htim_pwm->Instance->ARR/2;
	HAL_TIM_PWM_Start(stepper_motor.htim_pwm,stepper_motor.pwm_channel_number);
	}

void launch_stepper(int speed){
int abs_speed_value = abs(speed);
abs_speed_value = (abs_speed_value>8)?8:abs_speed_value;
stepper_motor.speed=speed;
const uint16_t period_counter_value[8]={1599,1399,1199,999,799,599,399,299};
if (abs_speed_value==0){
stepper_motor.htim_pwm->Instance->CCR1=0;
}
else{
HAL_GPIO_WritePin(stepper_motor.gpio_enable, stepper_motor.gpio_enable_pin,0);
HAL_GPIO_WritePin(stepper_motor.gpio_direction, stepper_motor.gpio_direction_pin,(speed>0)?1:0);
stepper_motor.htim_pwm->Instance->ARR=period_counter_value[abs_speed_value-1];
stepper_motor.htim_pwm->Instance->CCR1=stepper_motor.htim_pwm->Instance->ARR/2;
}
}

float get_speed(){
if (stepper_motor.speed==0){ return 0;}
int32_t period_value = ((stepper_motor.htim_pwm->Instance->ARR+1)*80)/(stepper_motor.htim_pwm->Instance->PSC + 1);
int32_t one_turn = period_value * 1600;
float speed = (((stepper_motor.speed>0)?1:-1)*(60 * 1000000))/one_turn;
return speed;
}
