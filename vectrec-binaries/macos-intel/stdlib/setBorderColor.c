#include "coco.h"


byte setBorderColor(byte color)
{
    #ifdef _COCO_BASIC_
    if (!isCoCo3)
        return FALSE;

    * (byte *) 0xFF9A = color;
    return TRUE;
    #else
    return FALSE;
    #endif
}
