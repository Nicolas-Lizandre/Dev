/*
 * utils.c
 *
 *  Created on: Oct 17, 2024
 *      Author: nicol
 */

#include "main.h"
#include <stdio.h>
#include "utils.h"
#include "ville.h"
#include "math.h"
extern UART_HandleTypeDef huart1;
extern UART_HandleTypeDef huart2;

const VILLE Kiev = {50.4501, 30.5234};
const VILLE Cergy = {49.033, 2.066};
const VILLE Chicago = {41.88, -87.623};
const VILLE Barcelone = {41.385, 2.173};

VILLE cities[4] ={Kiev, Cergy, Chicago, Barcelone};

void loop(){
char received_char;
while(HAL_UART_Receive(&huart1, (uint8_t *)&received_char, 1, 0)!=HAL_OK){}
HAL_UART_Transmit( &huart2, (uint8_t *) &received_char, 1, HAL_MAX_DELAY);
}

int fillBuffer(char * buffer, int size){
	HAL_UART_Abort(&huart1); //Je sais pas vraiment à quoi ça sert
	char received_char;
	HAL_UART_Transmit( &huart2, (uint8_t *) &received_char, 1, HAL_MAX_DELAY);
	int total=0;
	for(int i=0;i<=size;i++){
		buffer[i]=0;
	}
	while(received_char != '$'){HAL_UART_Receive(&huart1, (uint8_t *)&received_char, 1, -1);}

	do{buffer[total]=received_char;
	printf("%c",buffer[total]);
	HAL_UART_Receive(&huart1, (uint8_t *)&received_char, 1, -1);
	total++;
	}while(received_char != '\n');

	HAL_UART_Abort(&huart1);
	printf("\n\r");
	return total;
}

int isGPGGA(char * frame){
	char gpgga[6]="$GPGGA";
	for(int i =0; i<= 5; i++){
		if(frame[i] != gpgga[i]){ return -1; } //pas de printf à cause du système---si en fait
	} return 1;
}

int extractChecksum(char * buffer){
	int i=0;
	while(buffer[i] != '*'){i++;}

	return (buffer[i+1]&0x0f)*16 + (buffer[i+2]&0x0f);
}

int calculateChecksum(char * buffer){
	int ck=0;
	int i =1;
	while(buffer[i] != '*'){ck=ck^buffer[i]; i++;}
	return ck;
}

int checkFrame(char * buffer){
	if(isGPGGA(buffer)==-1){return 0;}
	if(calculateChecksum(buffer) == extractChecksum(buffer)){
		 return 1;}
return 0;
}

float getLatitude(char * frame){
	int i =0;
	while(frame[i] != ','){i++;}i++;
	while(frame[i] != ','){i++;}
	float latitude_non_orientee = 10.0*(frame[i+1]&0xf) + 1.0*(frame[i+2]&0xf); //PARENTHESE A METTRE IMPERATIVEMENT AUTOUR DE fram... sinon ERREUR
	float latitude_non_orientee2 = (1/60.0) * (10.0*(frame[i+3]&0xf) + 1.0*(frame[i+4]&0xf) + 0.1*(frame[i+6]&0xf) + 0.01 *(frame[i+7]&0xf) + 0.001*(frame[i+8]&0xf));
	latitude_non_orientee = latitude_non_orientee +latitude_non_orientee2;
	i++;
	while(frame[i] != ','){i++;}
	float latitude = ((frame[i+1] == 'N')?1:-1)*latitude_non_orientee;
	printf("Latitude : %.4f\n\r",latitude);
	return latitude;
}

float getLongitude(char * frame){ //Latitude -> Lontitude parce que flemme et latitude locale
	int i =0;
	while(frame[i] != ','){i++;}i++;
	while(frame[i] != ','){i++;}i++;
	while(frame[i] != ','){i++;}i++;
	while(frame[i] != ','){i++;}
	float longitude_non_orientee = 10.0*(frame[i+1]&0xf) + 1.0*(frame[i+2]&0xf); //PARENTHESE A METTRE IMPERATIVEMENT AUTOUR DE fram... sinon ERREUR
	float longitude_non_orientee2 = (1/60.0) * (10.0*(frame[i+3]&0xf) + 1.0*(frame[i+4]&0xf) + 0.1*(frame[i+5]&0xf) + 0.01 *(frame[i+7]&0xf) + 0.001*(frame[i+8]&0xf)+ 0.0001*(frame[i+9]&0xf));
	longitude_non_orientee = longitude_non_orientee +longitude_non_orientee2;
	i++;
	while(frame[i] != ','){i++;}
	float longitude = ((frame[i+1] == 'E')?1:-1)*longitude_non_orientee;
	printf("Longitude : %.5f\n\r",longitude);
	return longitude;
}

float norme (VILLE * v, float latitude, float longitude){
	float norme_d = (v[0]-latitude)*(v[0]-latitude) + ((v[1]-longitude)*cos((v[0]+latitude)/2))*((v[1]-longitude)*cos((v[0]+latitude)/2));
	return 6370.0 * sqrt(norme_d);
}

VILLE * findNearest(VILLE tableau[], int size, float latitude, float longitude);























