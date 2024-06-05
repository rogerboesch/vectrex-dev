#include "coco.h"


asm byte readJoystickButtons()
{
    asm
    {
        ldb     #$FF    ; set column strobe to check buttons
        stb     $FF02   ; PIA0+2
        ldb     $FF00   ; PIA0
        andb    #$0F    ; return low 4 bits
    }
}
