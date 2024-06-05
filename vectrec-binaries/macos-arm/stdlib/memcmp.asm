        SECTION code

_memcmp         EXPORT

memcmpimpl      IMPORT


_memcmp
        leax    compareBytes,pcr
        lbra    memcmpimpl


compareBytes
        lda     ,x+
        cmpa    ,u+
        rts


        ENDSECTION
