        SECTION code

signedJumpTableSwitch   EXPORT
unsignedJumpTableSwitch EXPORT


; Input: X => Table of 16-bit offsets, one for each non-default case.
;        D => Switch expression.
; Table: -6,X = minimum case value; -4,X: max value; -2,X: offset for default case.
;
; An offset is to be added to the address of the table (in X) to obtain
; the effective address of the case code to jump to.
;
signedJumpTableSwitch
        cmpd    -4,x        ; higher than max?
        bgt     @default
        subd    -6,x        ; switch value lower than minimum case value?
        blt     @default
        bra     @useTable
unsignedJumpTableSwitch
        cmpd    -4,x        ; higher than max?
        bhi     @default
        subd    -6,x        ; switch value lower than minimum case value?
        blo     @default
@useTable
        lslb                ; 2 bytes per address in table
        rola
        ldd     d,x         ; get offset from table
        jmp     d,x         ; add table address to offset to get absolute address to jump to
@default
        ldd     -2,x        ; get offset of default routine
        jmp     d,x


        ENDSECTION
