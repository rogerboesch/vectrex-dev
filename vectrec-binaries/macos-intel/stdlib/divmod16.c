asm void
divmod16(unsigned dividend, unsigned divisor, unsigned *quotient, unsigned *remainder)
{
    asm
    {
DIV16   IMPORT
        ldx     2,s         ; dividend
        ldd     4,s         ; divisor
        lbsr    DIV16
        stx     [6,s]       ; quotient
        std     [8,s]       ; remainer
    }
}
