/*  stdarg.c - Support for variable argument functions

    By Pierre Sarrazin <http://sarrazip.com/>.
    This file is in the public domain.
*/

#include "stdarg.h"


asm char *__va_arg(va_list *app, unsigned int sizeInBytes)
{
#if 0  // Code on which the following asm{} is based.
    char *origAddr = (char *) *app;
    if (sizeInBytes == 1)  // if char type or 1-byte struct
        ++origAddr;  // skip MSB of argument in stack; point to LSB
    *app = (va_list) (origAddr + sizeInBytes);
    return origAddr;
#else
    asm
    {
        ldx     [2,s]   ; 2,s is 'app', so get *app in X
        ldd     4,s     ; sizeInBytes
        cmpd    #1
        bne     @notSingleByte
        leax    1,x     ; ++origAddr
@notSingleByte
        pshs    x       ; app is now at 4,s
        leax    d,x
        stx     [4,s]   ; store in *app
        puls    a,b     ; return origAddr in D
    }
#endif
}
