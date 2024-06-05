#include "coco.h"


asm byte isKeyPressed(byte probe, byte testBit)
{
    asm
    {
        ldb     3,s     ; probe
        stb     $FF02
        ldb     $FF00
        andb    5,s     ; testBit
        eorb    5,s
    }
}
