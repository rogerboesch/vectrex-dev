#include "coco.h"


static byte pmodeNo = 2;
static byte *pmodeScreenBuffer = 0x0E00;


// Sets pmodeNo and pmodeScreenBuffer.
//
BOOL
pmode(byte mode, byte *screenBuffer)
{
    if (mode > 4 || ((word) screenBuffer & 511) != 0)
        return FALSE;
    pmodeNo = mode;
    pmodeScreenBuffer = screenBuffer;
    byte *pia1bData = (byte *) 0xff22;
    *pia1bData = *pia1bData & 7 | ((mode + 3) << 4);
    return TRUE;
}


// Uses pmodeNo and pmodeScreenBuffer.
//
void pcls(byte byteToClearWith)
{
    word size;
    switch (pmodeNo)
    {
    case 4:
    case 3:
       size = 6144;
        break;
    case 2:
    case 1:
        size = 3072;
        break;
    default:
        size = 1536;
    }

    word *end = (word *) (pmodeScreenBuffer + size);

    asm {
        lda     :byteToClearWith
        tfr     a,b
        ldx     :pmodeScreenBuffer
@pcls_loop:
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        std     ,x++
        cmpx    :end
        bne     @pcls_loop
    }
}


// Uses pmodeNo and pmodeScreenBuffer if type == 1 (graphics).
//
void
screen(byte type, byte colorset)
{
    byte *pia1bData = (byte *) 0xff22;
    byte b = *pia1bData;
    if (type)
    {
        b |= 0x80;
        byte samVRegisterValue = (pmodeNo == 4 ? 6 : pmodeNo + 3);
        showGraphicsAddress(samVRegisterValue, (byte) ((word) pmodeScreenBuffer / 512));
    }
    else
    {
        b &= 0x07;
        showLowResTextAddress();
    }
    if (colorset)
        b |= 8;
    else
        b &= ~8;
    *pia1bData = b;
}


void
setPmodeGraphicsAddress(byte *newPmodeScreenBuffer)
{
    setPmodeGraphicsAddressEx(newPmodeScreenBuffer, TRUE);
}


void
setPmodeGraphicsAddressEx(byte *newPmodeScreenBuffer, BOOL makeVisible)
{
    pmodeScreenBuffer = newPmodeScreenBuffer;
    if (makeVisible)
        setSAMRegisters((byte *) 0xFFC6, (byte) ((word) pmodeScreenBuffer / 512), 7);
}
