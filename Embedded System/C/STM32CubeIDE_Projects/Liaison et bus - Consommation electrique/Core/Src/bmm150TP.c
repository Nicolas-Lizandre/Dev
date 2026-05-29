/*
 * bmm150.c
 *
 *  Created on: Jun 17, 2024
 *      Author: antotauv
 */
#include <stdio.h>
#include "main.h"
#include "bmm150.h"
#include <math.h>
#define CHIP_ID_ADRESS 0x40
#define CHIP_ID_VALUE 0x32

#define POWER_CONTROL_ADRESS 0x4b
#define POWER_ON 0x01
#define CONTROL_REGISTER_ADRESS 0x4c
#define CONTROL_REGISTER_NORMAL_MODE 0x0
#define X_REGISTER_LSB_ADRESS 0x42
#define X_REGISTER_MSB_ADRESS 0x43
#define Y_REGISTER_LSB_ADRESS 0x44
#define Y_REGISTER_MSB_ADRESS 0x45

static SPI_HandleTypeDef * localSPIHandler;
static uint8_t isConnected=0;

uint8_t initDriverBMM150(SPI_HandleTypeDef * param){
	localSPIHandler=param;
	checkForBMM150Connection();
	if (isConnected==1){
		writeOneRegister(CONTROL_REGISTER_ADRESS,CONTROL_REGISTER_NORMAL_MODE);
	}
	return isConnected;
}

uint8_t readOneRegister(uint8_t adress){
	printf("adress : %x\n\r",adress);
	uint8_t dataToSend=adress|0x80;			// Permet de mettre un bit de poids fort
	uint8_t receiveBuffer=0;
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,0);      // Mise à 0 de la ligne de chip select
	HAL_SPI_Transmit(localSPIHandler,&dataToSend,1,-1);    // Transmission de l'adresse modifié dans dataToSend
	HAL_SPI_Receive(localSPIHandler,&receiveBuffer,1,-1);  // Réception d'un seul octet
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,1);      // Mise à 1 de la ligne de chip select.
	return receiveBuffer;
}

void readManyRegister(uint8_t adress, int8_t * pData, uint8_t size){
	uint8_t dataToSend=adress;			/// Permet de mettre un bit de poids fort
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,0);                              // Mise à 0 de la ligne de chip select
	HAL_SPI_Transmit(localSPIHandler,&dataToSend,1,-1);    // Transmission de l'adresse modifié dans dataToSend (1 seul octet)
	HAL_SPI_Receive(localSPIHandler,pData,size,-1);   // Réception de size octets
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,1);          // Mise à 1 de la ligne de chip select.
	printf("pData : %d\n\r",pData);
}




void writeOneRegister(uint8_t adress, uint8_t value){
	uint8_t dataToSend[2]={0};
	dataToSend[0]=adress;
	dataToSend[1]=value;
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,0);
	HAL_SPI_Transmit(localSPIHandler,dataToSend,2,-1);
	HAL_GPIO_WritePin(SPI_CS_GPIO_Port,SPI_CS_Pin,1);
}


uint8_t checkForBMM150Connection(){
	writeOneRegister(POWER_CONTROL_ADRESS,POWER_ON);
	uint8_t chip_id=readOneRegister(CHIP_ID_ADRESS);
	if (chip_id==CHIP_ID_VALUE){
		isConnected=1;
		printf("BMM150 connected \n\r");
		return 1;
	}
	printf("BMM150 connection failed\n\r");
	return -1;
}

float readAngle(){
	uint8_t drdy = 0;
		do{
			drdy=readOneRegister(0x48);
		}while((drdy & 1) !=1);
	int8_t dataBuffer[6]={0};
	readManyRegister(X_REGISTER_LSB_ADRESS,dataBuffer,6);
	int16_t xMagnitude=dataBuffer[1];
	int16_t yMagnitude=dataBuffer[3];
	float magnitude=sqrt((xMagnitude*xMagnitude)+(yMagnitude*yMagnitude));
	float angle=acos((float)(xMagnitude/magnitude));
	return angle;
}

uint16_t readYValue(){
	uint8_t drdy = 0;
	do{
		drdy=readOneRegister(0x48);
	}while((drdy & 1) !=1);

	uint8_t lsb = readOneRegister(Y_REGISTER_LSB_ADRESS);
	uint8_t msb = readOneRegister(Y_REGISTER_MSB_ADRESS);
	return ((uint16_t)lsb>>3)+((uint16_t)msb<<8);
}
