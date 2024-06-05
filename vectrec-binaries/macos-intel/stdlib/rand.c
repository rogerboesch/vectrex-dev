static unsigned _Rand_seed = 1;


#define USE_ASM


int
rand(void)
{
#ifdef USE_ASM
    asm
    {
; _Rand_seed ^= _Rand_seed << 7;
        leax    :_Rand_seed
        lda     1,x
        clrb                    ; D is now _Rand_seed << 8
        lsra
        rorb                    ; D is now _Rand_seed << 7, without bit 15
        pshs    a
        lda     ,x              ; test bit 8 of _Rand_seed
        lsra
        puls    a
        bcc     @bit15Done
        ora     #$80            ; bit 8 of _Rand_seed now in bit 15 of D
@bit15Done
        eora    ,x
        eorb    1,x
        std     :_Rand_seed
;
; _Rand_seed ^= _Rand_seed >> 9;
        ldb     ,x              ; high byte
        lsrb                    ; B = _Rand_seed >> 9 (high byte is 0)
        eorb    1,x             ; no need to EOR high byte of _Rand_seed
        stb     1,x
;
; _Rand_seed ^= _Rand_seed << 8;
        lda     1,x             ; A = _Rand_seed << 8 (low byte is 0)
        eora    ,x              ; no need to EOR low byte of _Rand_seed
        sta     ,x
;
; return (int) (_Rand_seed & 0x7FFF);
        anda    #$7F
        rts
    }
    return 0;  // dummy
#else
    _Rand_seed ^= _Rand_seed << 7;
    _Rand_seed ^= _Rand_seed >> 9;
    _Rand_seed ^= _Rand_seed << 8;
    return (int) (_Rand_seed & 0x7FFF);
#endif
}


asm void
srand(unsigned newSeed)
{
    // _Rand_seed = newSeed ? newSeed : 1U;
    asm
    {
        ldd     2,s     ; newSeed
        bne     @store
        ldd     #1
@store
        std     :_Rand_seed
    }
}
