	SECTION code

copyDWordFromXToD       EXPORT


; Copies a 4-byte region of memory.
; X: Address of the 4 bytes to read.
; D: Address where to copy the bytes to.
; Preserves X. Trashes D. Returns nothing.
;
copyDWordFromXToD
        pshs    u
        tfr     d,u
	ldd	,x
	std	,u
	ldd	2,x
	std	2,u
	puls    u,pc


	ENDSECTION
