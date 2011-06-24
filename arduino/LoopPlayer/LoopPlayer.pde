/*
 * FabLab Munich Arduino Loop Player with PWM playback and SD Card support
 * 
 * Notes: 
 * - The audio data needs to be unsigned PCM, 8-bit, 11025 Hz, raw (no header)
 * - Looks for files Sample[1-4].raw on SD card root dir
 * - for used pins see const.h
 * 
 * PWM playback code taken from 
 * speaker_pcm by Michael Smith <michael@hurts.ca>
 * 
 * SD card support code and SdFat library taken from William Greiman
 */

#include <SdFat.h>
#include "const.h"

void setup()
{
  pinMode(PIN_LED1, OUTPUT);    // set pin to output
  pinMode(PIN_LED2, OUTPUT);    // set pin to output
  pinMode(PIN_LED3, OUTPUT);    // set pin to output
  pinMode(PIN_LED4, OUTPUT);    // set pin to output
  pinMode(PIN_LED5, OUTPUT);    // set pin to output
  pinMode(PIN_LED6, OUTPUT);    // set pin to output

  digitalWrite(PIN_LED1, HIGH);   // turn on LED1

  pinMode(PIN_BUTTON1, INPUT);           // set pin to input
  digitalWrite(PIN_BUTTON1, HIGH);       // turn on pullup resistor
  pinMode(PIN_BUTTON2, INPUT);           // set pin to input
  digitalWrite(PIN_BUTTON2, HIGH);       // turn on pullup resistor
  pinMode(PIN_BUTTON3, INPUT);           // set pin to input
  digitalWrite(PIN_BUTTON3, HIGH);       // turn on pullup resistor
  pinMode(PIN_BUTTON4, INPUT);           // set pin to input
  digitalWrite(PIN_BUTTON4, HIGH);       // turn on pullup resistor

  pinMode(PIN_BUTTON_STOP, INPUT);       // set pin to input
  digitalWrite(PIN_BUTTON_STOP, HIGH);   // turn on pullup resistor

  digitalWrite(PIN_LED2, HIGH);  // turn on LED2
  
  debugInit();

  digitalWrite(PIN_LED3, HIGH);  // turn on LED3

  // open files
  if (!initFilesystem())
  {
    while(1);
  }
        
  // turn on LED4 - 6      
  digitalWrite(PIN_LED4, HIGH);
  digitalWrite(PIN_LED5, HIGH);
  digitalWrite(PIN_LED6, HIGH);

  // wait a bit                        
  delay(1000);
  
  ledsOff(); // LEDs 1-4 off
  digitalWrite(PIN_LED5, LOW);
  digitalWrite(PIN_LED6, HIGH);
}

void loop()
{           
  keepAudioPlaying();

  if (digitalRead(PIN_BUTTON1) == LOW)     
  {
    ledsOff();
    digitalWrite(PIN_LED1, HIGH);
    switchToFile(1);
  }
  
  if (digitalRead(PIN_BUTTON2) == LOW)     
  {
    ledsOff();
    digitalWrite(PIN_LED2, HIGH);
    switchToFile(2);
  }
  
  if (digitalRead(PIN_BUTTON3) == LOW)     
  {
    ledsOff();
    digitalWrite(PIN_LED3, HIGH);
    switchToFile(3);
  }
  
  if (digitalRead(PIN_BUTTON4) == LOW)     
  {
    ledsOff();
    digitalWrite(PIN_LED4, HIGH);
    switchToFile(4);
  }

  if (digitalRead(PIN_BUTTON_STOP) == LOW)     
  {
    ledsOff();
    stopPlayback();
  }
}

// turn LEDs 1-4 off
void ledsOff()
{
  digitalWrite(PIN_LED1, LOW); 
  digitalWrite(PIN_LED2, LOW);
  digitalWrite(PIN_LED3, LOW);
  digitalWrite(PIN_LED4, LOW);
}
