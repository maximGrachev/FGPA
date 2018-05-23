/**************************************************************
WinFilter version 0.8
http://www.winfilter.20m.com
akundert@hotmail.com

Filter type: High Pass
Filter model: Butterworth
Filter order: 1
Sampling Frequency: 1000 Hz
Cut Frequency: 200.000000 Hz
Coefficents Quantization: float

Z domain Zeros
z = 1.000000 + j 0.000000

Z domain Poles
z = 0.158384 + j -0.000000
y_n = b_0*x_n+b_1*x_(n-1)-a_1*y_(n-1);
***************************************************************/
/*System ID
#include "system.h"
#include "altera_avalon_sysid_qsys.h"
#include "altera_avalon_sysid_qsys_regs.h"
#include "alt_types.h"

static alt_u32 hardware_id;

hardware_id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_BASE);

alt_putchar(hardware_id & 255);
hardware_id = hardware_id >> 8;
alt_putchar(hardware_id & 255);
hardware_id = hardware_id >> 8;
alt_putchar(hardware_id & 255);
hardware_id = hardware_id >> 8;
alt_putchar(hardware_id & 255);
*/

#include "sys/alt_stdio.h"
#include "alt_types.h"
#define Km 194 // (1/1.316 = 0.758)

alt_u8 b_0 = 148 // 0.579;
alt_u8 b_1 = 148 // 0.579;
alt_u8 a_0 = 1 // 1;
alt_u8 a_1 = 40 // 0.158;

alt_8 x_n = 0;
alt_8 x_n1 = 0;
alt_8 y_n = 0;
alt_8 y_n1 = 0;
// p1 = b_0*x_n; p2 = b_1*x_n1; p3 = a_1*y_n1;
alt_16 p1 = 0;
alt_16 p2 = 0;
alt_16 p3 = 0;

// основная программа
int main() {
    while (1) {
        y_n1 = y_n;
	
	x_n = alt_getchar(); // чтение одного байта данных по UART
	
	//операторы для реализации цифрового фильтра
	
	p1 = x_n*b_0;
	p2 = x_n1*b_1;
	p3 = y_n1*a_1;

	y_n = p1-p2+p3;
	y_n = y_n>>8;
        x_n1 = x_n;

        // запись результата в порт UART
        alt_putchar(y_n);

    }

    return 0;
}
