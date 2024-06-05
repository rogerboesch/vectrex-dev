#include "coco.h"


byte hscreen(byte mode)
{
    #ifdef _COCO_BASIC_
    if (!isCoCo3)
        return FALSE;

    if (mode > 4)
        return FALSE;
    asm("PSHS", "U,Y");  // protect against BASIC routine
    asm("LDB", mode);
    asm("JSR", "$E69C");
    asm("PULS", "Y,U");
    return TRUE;
    #else
    return FALSE;
    #endif
}
