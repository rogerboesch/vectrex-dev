	SECTION code

push5ByteStruct	EXPORT


; Copies a 5-byte region of memory into the stack.
; X: Address of the 5-byte region to read.
; S: Address where to copy the region to.
; Example:
;       LEAX    destination,PCR
;       LEAS    -5,S
;       LBSR    push5ByteStruct
; Preserves X. Trashes D. Returns nothing.
;
push5ByteStruct
	ldd	,x
	std	2,s
	ldd	2,x
	std	4,s
	ldb	4,x
	stb	6,s
	rts




	ENDSECTION
