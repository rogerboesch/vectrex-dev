asm void
divmod8(unsigned char dividend, unsigned char divisor,
        unsigned char *quotient, unsigned char *remainder)
{
    asm
    {
DIV8    IMPORT
        lda     3,s         ; dividend
        ldb     5,s         ; divisor
        lbsr    DIV8
        stb     [6,s]       ; quotient
        sta     [8,s]       ; remainer
    }
}
