/*
 * task.c
 *
 *  Created on: Nov 8, 2024
 *      Author: nicol
 */
#include "main.h"
#include "task.h"
#include "led.h"
//TASK LED
static int globalDelayInMs=200;

typedef struct motif_type{
int size;
int * motif;
char * name; }MOTIF_TYPE;

int upDownMotif[]={0,128,192,224,240,248,252,254,255,254,252,248,240,224,192,128};
int chenillardUpMotif[]={1,2,4,8,16,32,64,128};
int chenillardDownMotif[]={128,64,32,16,8,4,2,1};
const MOTIF_TYPE upDown={16,upDownMotif,"Up Down"};
const MOTIF_TYPE chenillardUp={8,chenillardUpMotif,"K 2000"};
const MOTIF_TYPE chenillardDown={8,chenillardDownMotif,"K -2000"};
const MOTIF_TYPE* tableau_motif[3]={&upDown, &chenillardUp, &chenillardDown};
static int index_tableau_motif=0;

void taskLED(){
	int numero_motif
	=(HAL_GetTick()/globalDelayInMs)%(tableau_motif[index_tableau_motif%3]->size);
	LED_Set_Value_With_Int(tableau_motif[index_tableau_motif]->name[numero_motif]); //s'applique sur tout les pins en même temps
	LED_Update();
	return;}

//TASK BUTTON
void taskButton(){
	BUTTON_Update();
	index_tableau_motif = index_tableau_motif + BUTTON_Get_Pressed(0);
	if((BUTTON_Get_Value(1) == 0) && (BUTTON_Get_Value(2) == 1)){
		globalDelayInMs=50;
	}
	else if(BUTTON_Get_Value(1) == 1 && BUTTON_Get_Value(2) == 0){
		globalDelayInMs=800;
	}
	else{
		globalDelayInMs=200;
	}
	return;}

//TASK SCREEN
void taskScreen(){

	return;}

