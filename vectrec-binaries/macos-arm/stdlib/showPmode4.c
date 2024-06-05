#include "coco.h"


void showPmode4(byte colorset)
{
    byte *pia1bData = (byte *) 0xff22;
    byte b = *pia1bData & 7 | 0xf0;
    if (colorset)
         b |= 8;
    *pia1bData = b;
}
