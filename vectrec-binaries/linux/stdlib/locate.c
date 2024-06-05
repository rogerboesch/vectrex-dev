#include "coco.h"


byte locate(byte column, byte row)
{
    #ifdef _COCO_BASIC_
    byte hrwidth;
    if (isCoCo3)
        hrwidth = * (byte *) 0x00E7;
    else
        hrwidth = 0;

    if (hrwidth == 0)  // if 32 col mode
    #endif
    {
        if (column >= 32)
            return FALSE;
        if (row >= 16)
            return FALSE;
        * (word *) 0x0088 = 1024 + (((word) row) << 5) + column;
    }
    #ifdef _COCO_BASIC_
    else
    {
        if (column >= 80)
            return FALSE;
        if (row >= 24)
            return FALSE;
        if (hrwidth == 1)  // if 40 col mode
            if (column >= 40)
                return FALSE;
        asm("PSHS", "U,Y");  // protect against BASIC routine
        asm("LDA", column);
        asm("LDB", row);
        asm("JSR", "$F8F7");  // inside the LOCATE command
        asm("PULS", "Y,U");
    }
    #endif
    return TRUE;
}
