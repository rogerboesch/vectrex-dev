	SECTION code

addUnsignedIntDWord	EXPORT


; Input: Pushed arguments: value of unsigned int, address of dword.
;        X => destination dword.
; Preserves X.
;
addUnsignedIntDWord
	pshs	u
	ldu	6,s		; source dword
	ldd	4,s		; word to add
	addd	2,u		; add to low word of source dword; sets carry
	std	2,x		; store in low word of result dword
	ldd	,u		; load high word of source dword
	adcb	#0		; add carry of low word add
	adca	#0
	std	,x
	puls	u,pc




	ENDSECTION
