        SECTION code

_strstr EXPORT


* char *strstr(const char *haystack, const char *needle)
*
_strstr pshs    u,x
        ldx     6,s             haystack
        ldu     8,s             needle
        tst     ,u              is needle empty string?
        beq     @returnX        yes: empty string found at start of haystack
@mainLoop
        lda     ,x+             end of haystack?
        beq     @notFound       yes: fail
        cmpa    ,u              is current char of haystack same as current char of needle?
        bne     @mainLoop       loop if not
; Check if rest of strings are the same
        pshs    x               candidate position is X - 1: save it
        leau    1,u             point to 2nd needle char
@subLoop
        lda     ,u+             get next needle char
        beq     @found          if end of needle, found
        cmpa    ,x+             compare with next haystack char
        beq     @subLoop
@badCandidate
        puls    x               back to main loop with position after candidate position
        ldu     8,s             point to start of needle again
        bra     @mainLoop
@notFound
        clra
        clrb
        bra     @end
@found
        puls    x
        leax    -1,x
@returnX
        tfr     x,d
@end
        puls    x,u,pc


        ENDSECTION
