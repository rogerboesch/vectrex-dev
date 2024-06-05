	SECTION code

addDWordDWord	EXPORT


; Input: pushed addresses: left dword, right dword.
;        X => destination dword.
; Output: Result at X.
; Preserves X. Trashes D.
;
addDWordDWord
	pshs	u,y
	ldu	6,s		; left
	ldy	8,s		; right

	ldd	2,u		; low word
	addd	2,y
	std	2,x

	ldd	,u		; high word
	adcb	1,y
	adca	,y
	std	,x

	puls	y,u,pc




	ENDSECTION
