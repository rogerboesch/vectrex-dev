#include "coco.h"


byte getTextMode()
{
    #ifdef _COCO_BASIC_
    if (isCoCo3)
    {
        byte hrWidth = * (byte *) 0x00E7;
        if (hrWidth == 1)
            return 40;
        if (hrWidth == 2)
            return 80;
    }
    #endif
    return 32;
}
