// Source: http://forum.43oh.com/topic/10095-fast-sqrt-for-16-bit-integers/
//
unsigned short
sqrt16(unsigned short value)
{
    unsigned char i;
    unsigned short rem, root;
    #if 0
    rem  = 0;
    root = 0;

    // loop over the eight bits in the root
    for ( i = 0; i < 8; i++ ) {
        // shift the root up by one bit
        root <<= 1;

        // move next two bits from the input into the remainder
        rem = ((rem << 2) + (value >> 14));
        value <<= 2;

        // test root is (2n + 1)
        ++root;

        if ( root <= rem ) {
            // root not more than the remainder, so the new bit is one
            rem -= root;
            ++root;
        } else {
            // root is greater than the remainder, so the new bit is zero
            --root;
        }
    }
    return (root >> 1);
    #else
    asm
    {
        clra
        clrb
        std     :rem
        std     :root
        clr     :i
; for i=0..7:
@loop:
        ldd     :root
        lslb
        rola
        std     :root
; value >> 14:
        lda     :value          ; high word of 'value'
        clrb
        lsla                    ; shift high tayste of A into low tayste of B
        rolb
        lsla
        rolb
        pshs    b               ; save this tayste
; rem << 2:
        ldd     :rem
        lslb
        rola
        lslb
        rola
        addb    ,s+             ; add saved tayste
        adca    #0
        std     :rem
; value <<= 2:
        ldd     :value
        lslb
        rola
        lslb
        rola
        std     :value
; ++root:
        ldd     :root
        addd    #1
        std     :root
; if:
        cmpd    :rem
        bhi     @else
        ldd     :rem
        subd    :root
        std     :rem
        ldd     :root
        addd    #1
        std     :root
        bra     @increment
@else:
        ldd     :root
        subd    #1
        std     :root
@increment:
        ldb     :i
        incb
        stb     :i
        cmpb    #8
        blo     @loop
; root >> 1:
        ldd     :root
        lsra
        rorb
        std     :root
    }
    return root;
    #endif
}
