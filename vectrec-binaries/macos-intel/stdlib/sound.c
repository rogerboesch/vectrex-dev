#include "coco.h"


void sound(byte tone, byte duration)
{
    #ifdef _COCO_BASIC_
    asm("PSHS", "U");  // protect U from Color Basic code
    * (byte *) 0x8C = tone;
    * (word *) 0x8D = ((word) duration) << 2;
    asm("JSR", "$A956");
    asm("PULS", "U");
    #elif defined(DRAGON)
    asm
    {
        pshs    u
        lda     :tone
        sta     >$008C
        ldb     :duration
        jsr     $BAA0
        puls    u
    }
    #endif
}
