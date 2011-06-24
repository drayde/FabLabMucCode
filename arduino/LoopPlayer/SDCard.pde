
// we are using sdfatlib, see http://code.google.com/p/sdfatlib/
#include <SdFatUtil.h>
#include "const.h"

SdFile file1;
SdFile file2;
SdFile file3;
SdFile file4;
SdFile* currentFile;
uint32_t sampleLength = 0; 

Sd2Card card;
SdVolume volume;
SdFile root;

// store error strings in flash to save RAM
#define error(s) error_P(PSTR(s))

void error_P(const char* str) 
{
  PgmPrint("error: ");
  SerialPrintln_P(str);
  if (card.errorCode()) 
  {
    PgmPrint("SD error: ");
    debugOut(card.errorCode());
    debugOut(",");
    debugOut(card.errorData());
    debugOut("\n");
  }
  while(1);
}

uint32_t openFile(SdFile& file, const char* filename)
{
  debugOut("Opening ");
  debugOut(filename);
  if (!file.open(&root, filename, O_READ)) 
    debugOut(" Open failed!");

  uint32_t length = 0; 
  if( file.seekEnd() )
     length = file.curPosition();
  file.rewind();

  debugOut("\nFile size: ");
  debugOut(length);         
  debugOut("\n");
  
  return length;
}

bool initFilesystem()
{
  // initialize the SD card at SPI_HALF_SPEED to avoid bus errors with
  // breadboards.  use SPI_FULL_SPEED for better performance.
  if (!card.init(SPI_HALF_SPEED)) 
    debugOut("card.init failed\n");
  
  // initialize a FAT volume
  if (!volume.init(&card)) 
    debugOut("volume.init failed\n");
  
  // open the root directory
  if (!root.openRoot(&volume)) 
    debugOut("openRoot failed\n");
  
  // open files
  uint32_t l1 = openFile(file1, FILE_NAME1);
  uint32_t l2 = openFile(file2, FILE_NAME2);
  uint32_t l3 = openFile(file3, FILE_NAME3);
  uint32_t l4 = openFile(file4, FILE_NAME4);

  sampleLength = min(min(l1, l2), min(l3, l4));
    
  debugOut("Sample size used: ");
  debugOut(sampleLength);
  debugOut("\n");  

  currentFile = NULL;
  
  return sampleLength > 0;
}

void switchToFile(int file)
{
  switch(file)
  {
    case 1: currentFile = &file1; break;
    case 2: currentFile = &file2; break;
    case 3: currentFile = &file3; break;
    case 4: currentFile = &file4; break;
  }
}

uint32_t SampleLength()
{
  return sampleLength;
}
