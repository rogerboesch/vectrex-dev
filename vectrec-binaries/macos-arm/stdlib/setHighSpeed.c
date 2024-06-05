#include "coco.h"


void setHighSpeed(byte fast)
{
    asm
    {
        ldx     #65494
        tst     fast
        beq     setHighSpeed_010
        leax    1,x
setHighSpeed_010:
#ifdef _COCO_BASIC_
        tst     isCoCo3
        beq     setHighSpeed_020
        leax    2,x
#endif
setHighSpeed_020:
        clr     ,x
    }
}
