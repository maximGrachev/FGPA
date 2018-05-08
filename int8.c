/**************************************************************
WinFilter version 0.8
http://www.winfilter.20m.com
akundert@hotmail.com

Filter type: High Pass
Filter model: Butterworth
Filter order: 1
Sampling Frequency: 1000 Hz
Cut Frequency: 200.000000 Hz
Coefficents Quantization: 8-bit

Z domain Zeros
z = 1.000000 + j 0.000000

Z domain Poles
z = 0.156250 + j -0.000000
***************************************************************/
#define NCoef 1
#define DCgain 1

__int8 iir(__int8 NewSample) {
    __int8 ACoef[NCoef+1] = {
           74,
          -74
    };

    __int8 BCoef[NCoef+1] = {
          128,
          -20
    };

    static __int16 y[NCoef+1]; //output samples
    //Warning!!!!!! This variable should be signed (input sample width + Coefs width + 1 )-bit width to avoid saturation.

    static __int8 x[NCoef+1]; //input samples
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

    y[0] /= BCoef[0];
    
    return y[0] / DCgain;
}
