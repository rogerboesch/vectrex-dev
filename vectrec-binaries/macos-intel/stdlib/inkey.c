#include "coco.h"


asm byte inkey()
{
    asm
    {
        jsr     [$A000]     // POLCAT
        tfr     a,b         // byte return value goes in B
    }
}
