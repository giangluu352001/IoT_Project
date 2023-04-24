/*
 * scheduler.c
 *
 *  Created on: Apr 3, 2023
 *      Author: TRUONG_GIANG
 */

#include "scheduler.h"

sTasks SCH_tasks_G[SCH_MAX_TASKS];
uint8_t current_index_task = 0;

void SCH_Init(void) {
	current_index_task = 0;
}

void SCH_Add_Task(void (*Exec)(), uint32_t DELAY, uint32_t PERIOD) {
	if (current_index_task < SCH_MAX_TASKS) {
		SCH_tasks_G[current_index_task].exec = Exec;
		SCH_tasks_G[current_index_task].Delay = DELAY;
		SCH_tasks_G[current_index_task].Period = PERIOD;
		SCH_tasks_G[current_index_task].RunMe = 0;
		SCH_tasks_G[current_index_task].TaskID = current_index_task;
		current_index_task++;
	}
}

void SCH_Update(void){
	for(int i = 0; i < current_index_task; i++) {
		if (SCH_tasks_G[i].exec != NULL) {
			if (SCH_tasks_G[i].Delay > 0) {
				SCH_tasks_G[i].Delay--;
			}
			else {
				SCH_tasks_G[i].Delay = SCH_tasks_G[i].Period;
				SCH_tasks_G[i].RunMe++;
			}
		}
	}
}

void SCH_Execute_Tasks(void){
	for(int i = 0; i < current_index_task; i++) {
		if (SCH_tasks_G[i].exec != NULL && SCH_tasks_G[i].RunMe > 0) {
			SCH_tasks_G[i].RunMe--;
			(*SCH_tasks_G[i].exec)();
			if (SCH_tasks_G[i].Period == 0) {
				SCH_tasks_G[i].exec = NULL;
			}
		}
	}
}
