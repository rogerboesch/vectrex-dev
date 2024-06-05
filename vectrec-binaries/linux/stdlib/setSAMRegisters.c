#include "coco.h"


void setSAMRegisters(byte *samAddr, byte value, byte numBits)
{
    while (numBits)
    {
        // Write at even address to send a 0, odd to send a 1.
        //
        *(samAddr + (value & 1)) = 0;

        value = value >> 1;

        --numBits;

        // Next SAM bit is two addresses further.
        //
        samAddr += 2;
    }
}
