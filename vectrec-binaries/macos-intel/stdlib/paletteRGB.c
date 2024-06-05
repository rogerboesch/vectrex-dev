#include "coco.h"


// A palette value is a six-bit mask of the form RGBrgb,
// where R = medium red, etc., r = light red, etc.
// For example: 0x08 and 0x01 represent two intensities of blue,
// so 0x09 is light blue.
//
void paletteRGB(byte slot, byte red, byte green, byte blue)
{
    #ifdef _COCO_BASIC_
    if (!isCoCo3)
        return;
    if (slot > 15)
        return;
    * (((byte *) 0xFFB0) + slot) =   ((red   & 2) << 4)
                                   | ((red   & 1) << 2)
                                   | ((green & 2) << 3)
                                   | ((green & 1) << 1)
                                   | ((blue  & 2) << 2)
                                   |  (blue  & 1);
    #else
    return;
    #endif
}
