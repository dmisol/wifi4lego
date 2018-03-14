/******************************************************************************
 * Copyright 2013-2014 Espressif Systems (Wuxi)
 *
 * FileName: legopwm.c
 *
 * Description: light demo's function realization
 *
 * Modification history:
 *     2014/5/1, v1.0 create this file.
*******************************************************************************/
#include "ets_sys.h"
#include "osapi.h"
#include "os_type.h"
#include "mem.h"
#include "user_interface.h"

#include "legopwm.h"
#include <pwm.h>


//uint32 old_duty[PWM_CHANNEL]= {SERVO_CENT,SERVO_CENT,SERVO_CENT};
uint32 old_duty[PWM_CHANNEL]= {0,0,0};

uint32 ICACHE_FLASH_ATTR legopwm_get_duty(uint8 channel)
{
    return old_duty[channel];
}

void ICACHE_FLASH_ATTR legopwm_set_duty(uint32 duty, uint8 channel)
{
    if (duty != old_duty[channel]) {
        pwm_set_duty(duty, channel);

        old_duty[channel] = pwm_get_duty(channel);
    }
}

void ICACHE_FLASH_ATTR legopwm_init(void)
{
	uint32 io_info[][3] = {   {PWM_0_OUT_IO_MUX,PWM_0_OUT_IO_FUNC,PWM_0_OUT_IO_NUM},
		                      {PWM_1_OUT_IO_MUX,PWM_1_OUT_IO_FUNC,PWM_1_OUT_IO_NUM},
		                      {PWM_2_OUT_IO_MUX,PWM_2_OUT_IO_FUNC,PWM_2_OUT_IO_NUM},
		                      };
	
    /*PIN FUNCTION INIT FOR PWM OUTPUT*/
    pwm_init(PWM_PERIOD,  old_duty, PWM_CHANNEL, io_info);
    
    set_pwm_debug_en(1);//disable debug print in pwm driver
    
    pwm_start();
}


