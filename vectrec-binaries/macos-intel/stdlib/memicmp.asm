        SECTION code

_memicmp                EXPORT

convertABToUpperCase    IMPORT
memcmpimpl              IMPORT


_memicmp
        leax    compareBytes,pcr
        lbra    memcmpimpl


compareBytes
        lda     ,x+
        ldb     ,u+
        lbsr    convertABToUpperCase
        pshs    b
        cmpa    ,s+
        rts


        ENDSECTION
