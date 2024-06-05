	SECTION code

divDBy16    EXPORT
divDBy8     EXPORT

divDBy16
    lsra
    rorb
divDBy8
    lsra
    rorb
    lsra
    rorb
    lsra
    rorb
    rts

    ENDSECTION
