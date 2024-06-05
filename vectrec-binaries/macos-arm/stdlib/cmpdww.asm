	SECTION code

_cmpdww	EXPORT


* char cmpdww(unsigned left[2], unsigned right)
*
_cmpdww
        ldx     2,s             left
        ldd     ,x              high word of left
        bne     @leftGreater
        ldd     2,x             low word of left
        cmpd    4,s             compare with right
        bhi     @leftGreater
        blo     @leftSmaller
        clrb                    left == right
        rts
@leftSmaller
        ldb     #-1             left < right
        rts
@leftGreater
        ldb     #1              left > right
        rts




	ENDSECTION
