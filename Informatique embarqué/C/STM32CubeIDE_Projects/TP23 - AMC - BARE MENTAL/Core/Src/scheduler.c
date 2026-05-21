/*
 * scheduler.c
 *
 *  Created on: Mar 3, 2025
 *      Author: nicol
 */
#include "scheduler.h"
#include "task.h"

void SCHEDULER_Step(){
	static int taskNumber=0;
	taskNumber =(taskNumber+1)%3;
	switch(taskNumber){
	case 0 : TASK_LED(); break;
	case 1 : TASK_Button(); break;
	case 2 : TASK_Evolve(); break;
	}
}

