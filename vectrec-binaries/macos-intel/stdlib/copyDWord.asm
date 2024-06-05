	SECTION code

copyDWord	EXPORT


; Input: X = destination address; D = source address.
; Preserves X. Trashes D.
;
copyDWord
	pshs	u
	tfr     d,u		; source address
	ldd	,u		; high word
	std	,x
	ldd	2,u		; low word
	std	2,x
	puls	u,pc




	ENDSECTION
