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
***************************************************************/
#include "sys/alt_stdio.h"
#include "alt_types.h"
#define Km 1/127

float a_0 = 0.57919222017388228000;
float a_1 = -0.57919222017388228000;
float b_0 = 1.00000000000000000000,
float b_1 = -0.15838444034776453000

static alt_u8 TxRx_in; // байт данных в дополнительном коде
alt_8 counter;

alt_8 x_n = 0;
alt_8 x_n-1 = 0;
alt_8 y_n = 0;
alt_8 y_n-1 = 0;
alt_8 temp = 0;

// основная программа
int main() {
    while (1) {
        TxRx_in = alt_getchar(); // чтение одного байта данных по UART
        
        //перевод из доп. кода в дробное число со знаком
        if(TxRx_in & 128){
            x_n = (-1)*(TxRx_in*Km);
        }
        else {
            x_n = TxRx_in*Km;
        }

        //операторы для реализации цифрового фильтра
        y_n-1 = y_n;
        y_n = b_0*x_n+b_1*x_n-1-a_1*y_n-1;
        x_n-1 = x_n;

        //перевод дробного числа со знаком в целое в доп. коде
        if(y_n<0){
            TxRx_out = 128 + y_n/Km;
        }
        else{
            TxRx_out = y_n/Km;
        }

        // запись результата в порт UART
        alt_putchar(TxRx_out);
    }
    
    return 0;
} 
