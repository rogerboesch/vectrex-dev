#include "coco.h"


byte isCoCo3;
byte textScreenWidth;
byte textScreenHeight;


void initCoCoSupport()
{
    #ifdef _COCO_BASIC_
    word irqServiceRoutineAddress = * (word *) 0xFFF8;
    isCoCo3 = (irqServiceRoutineAddress == 0xFEF7);
    #else
    isCoCo3 = FALSE;
    #endif
    textScreenWidth  = 32;
    textScreenHeight = 16;
}
