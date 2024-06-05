#include "coco.h"


byte waitkey(byte blinkCursor)
{
    byte key;
    if (blinkCursor)
    {
        asm
        {
            #ifdef _COCO_BASIC_
            jsr $A1B1  // blink cursor while waiting for a keystroke
            #elif defined(DRAGON)
            jsr $A0EA
            #else
            clra
            #endif
            sta key
        }
        return key;
    }

    for (;;)
    {
        key = inkey();
        if (key)
            return key;
    }
}
