/*
 * util.c
 *
 *  Created on: Oct 4, 2024
 *      Author: nicol
 */
#include "utils.h"
#include "main.h"

extern UART_HandleTypeDef huart1;
extern UART_HandleTypeDef huart2;

void loop(){
	char buffer[BUFFER_MAX_SIZE];
	int size;
	while(1){
		size=fillBuffer(buffer,BUFFER_MAX_SIZE);
		printf("Received %d char : %s \n\r",size,buffer);
}}


int fillBuffer(char * buffer, int size){
	char received_char;//i?
	int total = 0;
	for(int index=0; index <= size;index++){
	buffer[index]=0;
	HAL_UART_Abort(&huart1); }
	//Annulation de la r´eception en cours.
	// Cette ligne permet de d´emarrer une r´eception proprement m^eme si
	// elle d´emarre au milieu d'une trame.
	do{
	HAL_UART_Receive(&huart1, (uint8_t *)&received_char, 1, -1); // -1 pour qu'il receive indéfinément
	} while(received_char != '$');
	do{
	*buffer = received_char ;
	HAL_UART_Receive(&huart1, (uint8_t *)&received_char, 1, -1); //

	total = total+1;
	buffer = buffer+1; }
	while(received_char != '\n');
	*buffer = received_char ;
	return total;
}



void setup(){
	HAL_UART_Abort(&huart1); }
