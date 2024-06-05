#include "coco.h"


asm void coldStart()
{
    asm("CLR", "$71");
    #ifdef _COCO_BASIC_
    asm("JMP", "$A027");
    #elif defined(DRAGON)
    asm("JMP", "$B3B4");
    #endif
}
