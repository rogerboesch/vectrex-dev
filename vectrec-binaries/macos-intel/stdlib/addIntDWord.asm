	SECTION code

addIntDWord	EXPORT


; Input: Pushed arguments: value of signed int, address of dword.
;        X => destination dword.
; Preserves X.
;
addIntDWord
	pshs	u
	ldu	6,s		; source dword
	ldd	4,s		; word to add
	addd	2,u		; add to low word of source dword; sets carry
	std	2,x		; store in low word of result dword
	ldd	,u		; load high word of source dword
	adcb	#0		; add carry of low word add
	adca	#0
	tst	4,s		; test sign bit of high word of int
	bpl	@intNotNeg
	addd	#$FFFF		; as if int had been sign-extended to 32 bits
@intNotNeg
	std	,x
	puls	u,pc




	ENDSECTION
