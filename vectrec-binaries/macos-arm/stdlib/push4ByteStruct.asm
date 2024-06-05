	SECTION code

push4ByteStruct	EXPORT


; Copies a 4-byte region of memory into the stack.
; X: Address of the 4-byte region to read.
; S: Address where to copy the region to.
; Example:
;       LEAX    destination,PCR
;       LEAS    -4,S
;       LBSR    push4ByteStruct
; Preserves X. Trashes D. Returns nothing.
;
push4ByteStruct
	ldd	,x
	std	2,s
	ldd	2,x
	std	4,s
	rts




	ENDSECTION
