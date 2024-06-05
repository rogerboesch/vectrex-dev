#include "coco.h"


void setCaseFlag(byte upperCase)
{
    if (upperCase != 0)
        upperCase = 0xFF;
    #ifdef _COCO_BASIC_
    * (byte *) 0x11a = upperCase;
    #elif defined(DRAGON)
    * (byte *) 0x149 = upperCase;
    #endif
}
