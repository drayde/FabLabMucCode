

void debugInit()
{
  Serial.begin(SERIAL_SPEED);
}

void debugOut(const char* str)
{
  Serial.print(str);    
}

void debugOut(long dec)
{
  Serial.print(dec, DEC);    
}
