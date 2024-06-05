#include "coco.h"


#ifdef _COCO_BASIC_
#define GETJOY  $A9DE
#else
#define GETJOY  $BD52
#endif

asm const byte *readJoystickPositions()
{
    asm
    {
        pshs    u,y     ; protect against Basic
        jsr     GETJOY
        puls    y,u
        ldd     #$015A  ; return POTVAL
    }
}
