#include <pwm.h>

#define PWM_CHANNEL	3
#define PWM_PERIOD      20000	// 20ms period

#define SERVO_DIV	45
#define SERVO_MIN		15000   //1000000/SERVO_DIV	// 1ms
#define SERVO_MAX               56000   //2000000/SERVO_DIV	// 2ms
#define SERVO_CENT              38000   //1500000/SERVO_DIV	// 1.5ms

#define PWM_0_OUT_IO_MUX PERIPHS_IO_MUX_MTDI_U
#define PWM_0_OUT_IO_NUM 12
#define PWM_0_OUT_IO_FUNC  FUNC_GPIO12

#define PWM_1_OUT_IO_MUX PERIPHS_IO_MUX_MTCK_U
#define PWM_1_OUT_IO_NUM 13
#define PWM_1_OUT_IO_FUNC  FUNC_GPIO13

#define PWM_2_OUT_IO_MUX PERIPHS_IO_MUX_MTMS_U
#define PWM_2_OUT_IO_NUM 14
#define PWM_2_OUT_IO_FUNC  FUNC_GPIO14

void legopwm_init(void);
uint32 legopwm_get_duty(uint8 channel);
void legopwm_set_duty(uint32 duty, uint8 channel);

