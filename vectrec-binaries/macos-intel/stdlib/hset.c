#include "coco.h"


byte hset(word x, word y, byte color)
{
    #ifdef _COCO_BASIC_
    if (x >= 640 || y >= 192 || color >= 16)
        return FALSE;
    byte hrmode = * (byte *) 0x00E6;
    if (hrmode == 0)
        return FALSE;  // hi-res mode not enabled
    if (hrmode <= 2)
        if (x >= 320)
            return FALSE;
    * (byte *) 0x00C2 = 1;  // SETFLG: 1 = HSET, 0 = HRESET
    * (word *) 0x00BD = x;  // HORBEG
    * (word *) 0x00BF = y;  // VERBEG
    asm("PSHS", "U,Y");  // protect against BASIC routine
    asm("LDB", color);
    asm("JSR", "$E73B");  // save the working color
    asm("JSR", "$E785");  // put the pixel on the screen
    asm("PULS", "Y,U");
    return TRUE;
    #else
    return FALSE;
    #endif
}
