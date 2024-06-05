#include "coco.h"


void asm setOutputDevice(sbyte deviceNum)
{
    asm
    {
        ldb     3,s     // deviceNum
        stb     $6F     // Color Basic's DEVNUM
    }
}
