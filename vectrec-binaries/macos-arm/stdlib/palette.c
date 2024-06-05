#include "coco.h"


byte palette(byte slot, byte color)
{
    #ifdef _COCO_BASIC_
    if (!isCoCo3)
        return FALSE;
    if (slot > 15)
        return FALSE;
    if (color > 63)
        return FALSE;
    byte *palette = (byte *) 0xFFB0;
    palette[slot] = color;
    return TRUE;
    #else
    return FALSE;
    #endif
}
