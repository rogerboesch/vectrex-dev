	SECTION code

_atoi	EXPORT

ATOW    IMPORT


* int atoi(char *s);
_atoi
        ldx     2,s             s
        clr     ,-s             sign byte: 0 = positive
        ldb     ,x              1st char
        cmpb    #'-             minus sign?
        bne     atoi_010        no
        com     ,s              $FF = negative
        leax    1,x             pass minus sign
atoi_010
        lbsr    ATOW            convert rest of s
        tst     ,s+             apply sign byte
        beq     atoi_020        positive
        coma
        comb
        addd    #1
atoi_020
        rts




	ENDSECTION
