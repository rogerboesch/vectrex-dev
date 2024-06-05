#include "coco.h"


void showLowResTextAddress()
{
    setSAMRegisters((byte *) 0xFFC6, 2, 7);  // 2 == 0x0400 / 512
    setSAMRegisters((byte *) 0xFFC0, 0, 3);  // 0 == 32x16 mode
}
