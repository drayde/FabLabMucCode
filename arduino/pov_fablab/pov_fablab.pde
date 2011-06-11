/*
 
 */

int ledPin1 =  9;   
int ledPin2 =  8;   
int ledPin3 =  7;   
int ledPin4 =  6;   
int ledPin5 =  5;   
int ledPin6 =  4;   
int ledPin7 =  3;   


// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pin as an output:
  pinMode(ledPin1, OUTPUT);     
  pinMode(ledPin2, OUTPUT);     
  pinMode(ledPin3, OUTPUT);     
  pinMode(ledPin4, OUTPUT);     
  pinMode(ledPin5, OUTPUT);     
  pinMode(ledPin6, OUTPUT);     
  pinMode(ledPin7, OUTPUT);     
  
  digitalWrite(ledPin1, 0);    // set the LED off
  digitalWrite(ledPin2, 0);    // set the LED off
  digitalWrite(ledPin3, 0);    // set the LED off
  digitalWrite(ledPin4, 0);    // set the LED off
  digitalWrite(ledPin5, 0);    // set the LED off
  digitalWrite(ledPin6, 0);    // set the LED off
  digitalWrite(ledPin7, 0);    // set the LED off
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
  ShowF();
  space();  
  ShowA();
  space();
  ShowB();
  space();  
  ShowL();
  space();
  ShowA();
  space();
  ShowB();
  space();
  delay(10);  
}

void ShowA() {
  setLEDs(1, 1, 1, 1, 1, 1, 0);  
  setLEDs(0, 0, 0, 1, 0, 0, 1);  
  setLEDs(0, 0, 0, 1, 0, 0, 1);  
  setLEDs(1, 1, 1, 1, 1, 1, 0);  
}

void ShowB() {
  setLEDs(1, 1, 1, 1, 1, 1, 1);  
  setLEDs(1, 0, 0, 1, 0, 0, 1);  
  setLEDs(1, 0, 0, 1, 0, 0, 1);  
  setLEDs(0, 1, 1, 0, 1, 1, 0);  
}

void ShowF() {
  setLEDs(1, 1, 1, 1, 1, 1, 1);  
  setLEDs(0, 0, 0, 1, 0, 0, 1);  
  setLEDs(0, 0, 0, 1, 0, 0, 1);  
  setLEDs(0, 0, 0, 0, 0, 0, 1);  
}

void ShowL() {
  setLEDs(1, 1, 1, 1, 1, 1, 1);  
  setLEDs(1, 0, 0, 0, 0, 0, 0);  
  setLEDs(1, 0, 0, 0, 0, 0, 0);  
  setLEDs(1, 0, 0, 0, 0, 0, 0);  
}

void space() {
  setLEDs(0, 0, 0, 0, 0, 0, 0);  
  delayMicroseconds(500);
}


// Switch the LEDs on/off, wait a little bit
// led7 is the lowest LED */
void setLEDs(byte led7, byte led6, byte led5,
  byte led4, byte led3, byte led2, byte led1)
{
  digitalWrite(ledPin1, led1);
  digitalWrite(ledPin2, led2);
  digitalWrite(ledPin3, led3);
  digitalWrite(ledPin4, led4);
  digitalWrite(ledPin5, led5);
  digitalWrite(ledPin6, led6);
  digitalWrite(ledPin7, led7);
  delayMicroseconds(1000);
}


