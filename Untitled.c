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
static alt_u8 TxRx; // байт данных в дополнительном коде
<объявление массивов переменных для цифрового фильтра>;
// основная программа
int main() {
while (1) { // организация бесконечного цикла
TxRx = alt_getchar(); // чтение одного байта данных по UART
<перевод из доп. кода в дробное число со знаком>;
<операторы для реализации цифрового фильтра>;
<перевод дробного числа со знаком в целое в доп. коде>;
// запись результата в порт UART
alt_putchar(<байт данных с результатом фильтрации>);
} // end while
return 0;
} // end main



#define NCoef 1
float iir(float NewSample) {
    float ACoef[NCoef+1] = {
        0.57919222017388228000,
        -0.57919222017388228000
    };

    float BCoef[NCoef+1] = {
        1.00000000000000000000,
        -0.15838444034776453000
    };

    static float y[NCoef+1]; //output samples
    static float x[NCoef+1]; //input samples
    int n;

    //shift the old samples
    for(n=NCoef; n>0; n--) {
       x[n] = x[n-1];
       y[n] = y[n-1];
    }

    //Calculate the new output
    x[0] = NewSample;
    y[0] = ACoef[0] * x[0];
    for(n=1; n<=NCoef; n++)
        y[0] += ACoef[n] * x[n] - BCoef[n] * y[n];
    
    return y[0];
}
