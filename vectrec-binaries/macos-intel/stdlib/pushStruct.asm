	SECTION code

pushStruct	EXPORT


; Copies a region of memory into the stack.
; X: Address of the region to read.
; D: Size in bytes of the region. Must not be zero.
; S: Address where to copy the region to.
; Example:
;       LEAX    destination,PCR
;       LDD     #17
;       LEAS    -17,S
;       LBSR    pushStruct
; Preserves U, Y. Trashes D, X. Returns nothing.
;
pushStruct
        pshs	u
	leau    4,s             destination (past pushed U and return address)
        leas    -2,s
	pshs    x               preserve source address
        leax    d,x             compute end of source region
        stx     2,s             preserve end
	puls    x               restore source address; ,s is now end
@copyByte
	lda	,x+
	sta	,u+
	cmpx	,s		compare with end address
	bne	@copyByte
	leas	2,s		dispose of end address
	puls	u,pc




	ENDSECTION
