/*
 http://www.MicroVGA.com/arduino
 
 This sketch is very basic test of the MicroVGA.
 
 Before running it, please make sure the MicroVGA is connected
 properly to the arduino and it is configured for SPI mode
 using built-in setup tool.
 
 The demo should SLOWLY display "U" character infinitely.
 
 If something else is displayed, there is a problem with
 noise on SCK pin. Or something else...

*/

int pin_cs = 8; 
int pin_sck = 13; 
int pin_rdy = 9; 
int pin_mosi = 12; 
int pin_miso = 11; 

 
// Other experimental variant:
/*
int pin_cs = 0; 
int pin_sck = 7; 
int pin_rdy = 1;
int pin_mosi = 5; 
int pin_miso = 6; 
*/



// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pins used for the MicroVGA
  pinMode(pin_cs, OUTPUT);     
  pinMode(pin_sck, OUTPUT);     
  pinMode(pin_mosi, OUTPUT);     
  pinMode(pin_miso, INPUT);     
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
  int i;
  
  digitalWrite(pin_cs, LOW); 
  
  // wait for a second
  // this is required to make sure the MicroVGA is idle
  // normally there would be loop, but to keep this
  // sketch simple, we have replaced it with delay
  delay(1000);                  

  // now output 8 bits using software SPI  
  for (i=0;i<8;i++) {
    digitalWrite(pin_mosi, i&1 ? LOW : HIGH); 
    delay(10);                  // wait for a while
    digitalWrite(pin_sck, LOW);
    delay(10);                  // wait for a while
    digitalWrite(pin_sck, HIGH); 
    delay(10);                  // wait for a while
    digitalWrite(pin_sck, LOW);
  }
}
