#include "coco.h"


byte width(byte columns)
{
    #ifdef _COCO_BASIC_
    if (!isCoCo3)
        return FALSE;

    if (columns != 32 && columns != 40 && columns != 80)
        return FALSE;

    asm("PSHS", "U,Y");  // protect against BASIC routine
    asm("LDB", columns);
    asm("JSR", "$F643");  // inside the WIDTH command
    asm("PULS", "Y,U");

    textScreenWidth = columns;
    textScreenHeight = (columns == 32 ? 16 : 24);

    return TRUE;
    #else
    return FALSE;
    #endif
}

