/*
 * scheduler.h
 *
 *  Created on: Apr 3, 2023
 *      Author: TRUONG_GIANG
 */

#ifndef INC_SCHEDULER_H_
#define INC_SCHEDULER_H_

#include <stdint.h>
#include <stddef.h>

typedef struct {
	void (*exec)(void);
	uint32_t Delay;
	uint32_t Period;
	uint8_t RunMe;
	uint32_t TaskID;
}sTasks;

#define SCH_MAX_TASKS 10

void SCH_Init(void);

void SCH_Add_Task(void (*exec)(),
					uint32_t DELAY,
					uint32_t PERIOD);

void SCH_Update(void);

void SCH_Execute_Tasks(void);
#endif /* INC_SCHEDULER_H_ */
