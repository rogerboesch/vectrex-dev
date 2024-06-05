#include "coco.h"


#ifdef _COCO_BASIC_
#define CLEAR_TEXT_SCREEN $A928
#elif defined(DRAGON)
#define CLEAR_TEXT_SCREEN $BA77
#endif

void cls(byte color)
{
    #ifdef _COCO_BASIC_
    byte hrwidth;
    if (isCoCo3)
        hrwidth = * (byte *) 0x00E7;
    else
        hrwidth = 0;

    if (hrwidth != 0)
    {
        if (color > 8)
            color = 1;
        // This is the hi-res CLS routine,
        // which must not be called in 32 column mode.
        asm
        {
            ldb     :color
            pshs    u,y
            jsr     $F6B8
            puls    y,u
        }
    }
    else
    #endif
    if (color > 8)
    {
        asm
        {
            pshs    u,y     ; protect against BASIC routine
            jsr     CLEAR_TEXT_SCREEN
            puls    y,u
        }
    }
    else
    {
        asm
        {
            ldb     :color
            #if _COCO_BASIC_
            pshs    u,y
            jsr     $A91C   ; takes CLS argument in B
            puls    y,u
            #elif DRAGON
            beq     @black  ; if B == 0
            decb            ; 0..7, i.e., 3 color bits
            lslb
            lslb
            lslb
            lslb            ; 3 color bits now in bits 5..7 of B
            orb     #$8F    ; set all pixels of graphical char
            bra     @clear
@black
            ldb     #$80    ; black block character
@clear
            pshs    u,y
            jsr     $BA79   ; takes byte to clear with in B
            puls    y,u
            #endif
        }
    }
}
