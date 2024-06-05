	SECTION code

subDWordInt	EXPORT


; Input: Pushed arguments: address of dword, value of unsigned int.
;        X => destination dword.
; Preserves X.
;
subDWordInt
	pshs	u
	ldu	4,s		; source dword
	ldd	2,u		; load low word of source dword
	subd	6,s		; subtract right side
	std	2,x		; store in low word of result dword
	ldd	,u		; load high word of source dword
	sbcb	#0		; sub carry of low word sub
	sbca	#0
	tst	6,s		; test sign bit of high word of int
	bpl	@intNotNeg
	subd	#$FFFF		; as if int had been sign-extended to 32 bits
@intNotNeg
	std	,x
	puls	u,pc




	ENDSECTION
