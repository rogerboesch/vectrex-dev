	SECTION code

addDWordUnsignedInt	EXPORT


; Input: Pushed arguments: address of dword, value of unsigned int.
;        X => destination dword.
; Preserves X.
;
addDWordUnsignedInt
	pshs	u
	ldu	4,s		; source dword
	ldd	6,s		; word to add
	addd	2,u		; add to low word of source dword; sets carry
	std	2,x		; store in low word of result dword
	ldd	,u		; load high word of source dword
	adcb	#0		; add carry of low word add
	adca	#0
	std	,x
	puls	u,pc




	ENDSECTION
