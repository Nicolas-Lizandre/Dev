/*
 * utils.h
 *
 *  Created on: Oct 17, 2024
 *      Author: nicol
 */

#ifndef SRC_UTILS_H_
#define SRC_UTILS_H_

#define BUFFER_MAX_SIZE 64

extern UART_HandleTypeDef huart1;

void loop();
int fillBuffer(char * buffer, int size);
int isGPGGA(char * frame);
int extractChecksum(char * buffer);
int calculateChecksum(char * buffer);
int checkFrame(char * buffer);
float getLatitude(char * frame);
float getLongitude(char * frame);
float norme (VILLE * v, float latitude, float longitude);

#endif /* SRC_UTILS_H_ */
