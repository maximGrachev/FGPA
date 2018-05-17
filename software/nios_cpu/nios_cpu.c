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
#define Km 1.0f/128

float b_0 = 0.579;
float b_1 = -0.579;
float a_0 = 1;
float a_1 = -0.158;

static alt_8 TxRx_in = 0; // ���� ������ � �������������� ����
static alt_8 TxRx_out = 0; // ���� ������ � �������������� ����
alt_8 counter;


float x_n = 0;
float x_n1 = 0;
float y_n = 0;
float y_n1 = 0;
float temp = 0;

// �������� ���������

int main() {
    while (1) {
        TxRx_in = alt_getchar(); // ������ ������ ����� ������ �� UART

        //������� �� ���. ���� � ������� ����� �� ������
            x_n = TxRx_in*Km;

        //��������� ��� ���������� ��������� �������
        y_n1 = y_n;
        y_n = b_0*x_n+b_1*x_n1-a_1*y_n1;
        x_n1 = x_n;

        TxRx_out = (alt_8)(y_n*128);

        // ������ ���������� � ���� UART
        alt_putchar(TxRx_out);

    }

    return 0;
}
