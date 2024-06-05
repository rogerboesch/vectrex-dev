#include "coco.h"


void showGraphicsAddress(byte samVRegisterValue, byte pageNum)
{
    setSAMRegisters((byte *) 0xFFC6, pageNum, 7);
    setSAMRegisters((byte *) 0xFFC0, samVRegisterValue, 3);
}
