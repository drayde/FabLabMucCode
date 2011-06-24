
extern SdFile* currentFile;

byte buffer1[BUFFER_SIZE];
byte buffer2[BUFFER_SIZE];
byte* readBuffer = 0L;
byte* writeBuffer = 0L;
boolean isPlaying = false;
boolean isReadyToWrite = false;
uint32_t samplePos = 0;

volatile uint16_t bufferReadPosition;
 
// This is called at 11025 Hz to load the next sample.
ISR(TIMER1_COMPA_vect) 
{           
  // reset sample read position when end of buffer is reached
  if (bufferReadPosition >= BUFFER_SIZE) 
  {
    bufferReadPosition = 0;
    swapBuffers();
    // end reached, check whether lower buffer was filled
  }        
  OCR2B = *(readBuffer+bufferReadPosition);
  ++bufferReadPosition;           
}

void startPlayback()
{
  // set up out pin
  pinMode(PIN_AUDIO, OUTPUT);

  // prepare buffers
  initDoubleBuffer();

  // Set up Timer 2 to do pulse width modulation on the speaker pin.

  // Use internal clock (datasheet p.160)
  ASSR &= ~(_BV(EXCLK) | _BV(AS2));

  // Set fast PWM mode  (p.157)
  TCCR2A |= _BV(WGM21) | _BV(WGM20);
  TCCR2B &= ~_BV(WGM22);

  // Do non-inverting PWM on pin OC2A (p.155)
  // On the Arduino this is pin 3.
  TCCR2A = (TCCR2A | _BV(COM2B1)) & ~_BV(COM2B0);

  // No prescaler (p.158)
  TCCR2B = (TCCR2B & ~(_BV(CS12) | _BV(CS11))) | _BV(CS10);

  // Set initial pulse width to the first sample.
  OCR2B = *readBuffer;

  // Set up Timer 1 to send a sample every interrupt.
  cli();

  TCCR1A = 0;              // no pwm
  TCCR1B = _BV(WGM12) | _BV(CS10); // no clock div, CTC mode

  // Set the compare register (OCR1A).
  // OCR1A is a 16-bit register, so we have to do this with
  // interrupts disabled to be safe.
  OCR1A = F_CPU / SAMPLE_RATE;    // 16e6 / 11025 = 1451
  OCR1B = 1;

  // Enable interrupt when TCNT1 == OCR1A (p.136)
  TIMSK1 |= _BV(OCIE1A);

  // initialize sample read position
  bufferReadPosition = 0;

  isPlaying = true;

  sei();
}

void stopPlayback()
{
  // Disable playback per-sample interrupt.
  TIMSK1 &= ~_BV(OCIE1A);

  // Disable the per-sample timer completely.
  TCCR1B &= ~_BV(CS10);

  // Disable the PWM timer.
  TCCR2B &= ~_BV(CS10);

  currentFile = NULL;
  isPlaying = false;
  
  digitalWrite(PIN_AUDIO, LOW);
}


boolean initDoubleBuffer()
{  
  debugOut("using two sample buffers of size ");
  debugOut(BUFFER_SIZE);
  debugOut("\n");
        
  // on initialization, set buffer1 as write buffer
  writeBuffer = buffer1;
  readBuffer = buffer2;    
  samplePos = 0;
  
  // fill first buffer         
  fillBuffer();
        
  // swap buffers & signal that second buffer is ready for write
  swapBuffers();          
}


void swapBuffers()
{
  if( writeBuffer == buffer1 )
  {
    readBuffer = buffer1;
    writeBuffer = buffer2;  
  }
  else
  {
    readBuffer = buffer2;
    writeBuffer = buffer1; 
  }
  
  isReadyToWrite = true;
}

void fillBuffer()
{
  int16_t n = 0;
  SdFile* f = currentFile; // make sure it is not changed during this method

  // read to buffer
  f->seekSet(samplePos);
  n = f->read(writeBuffer, BUFFER_SIZE);
    
  if( n < BUFFER_SIZE )
  {    
    int16_t remaining = BUFFER_SIZE - n;
    f->rewind();
      
    // read so many samples that the buffer can be filled
    n = f->read(writeBuffer + n, remaining);                    
  }
  samplePos = f->curPosition();
    
  isReadyToWrite = false;
}

// call this in loop()
void keepAudioPlaying()
{
  if (!isPlaying && currentFile)
  {
     startPlayback();
  }
  
  if (isReadyToWrite)
  {
    fillBuffer();
  }
}
