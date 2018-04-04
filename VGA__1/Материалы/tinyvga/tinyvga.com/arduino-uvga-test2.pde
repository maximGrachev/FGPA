/*
 http://www.MicroVGA.com/arduino
  
 NEVER RUN THIS SKETCH WITH THE MICROVGA CONNECTED TO ARDUINO!!!
 Doing so may kill both boards!!!

 The sketch toggles indefinitely MicroVGA pins so as you can
 see using a LED diode if anything is wrong (i.e. burned pin)
 
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
  pinMode(pin_miso, OUTPUT);     
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
  int i;
 
  digitalWrite(pin_sck, HIGH);
  delay(500);                  
  digitalWrite(pin_sck, LOW);

  digitalWrite(pin_miso, HIGH);
  delay(500);                  
  digitalWrite(pin_miso, LOW);
  
  
  digitalWrite(pin_mosi, HIGH);
  delay(500);                  
  digitalWrite(pin_mosi, LOW);

  digitalWrite(pin_rdy, HIGH);
  delay(500);                  
  digitalWrite(pin_rdy, LOW);  
}
