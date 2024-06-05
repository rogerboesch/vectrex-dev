	SECTION code

subDWordUnsignedInt	EXPORT


; Input: Pushed arguments: address of dword, value of unsigned int.
;        X => destination dword.
; Preserves X.
;
subDWordUnsignedInt
	pshs	u
	ldu	4,s		; source dword
	ldd	2,u		; load low word of source dword
	subd	6,s		; subtract right side
	std	2,x		; store in low word of result dword
	ldd	,u		; load high word of source dword
	sbcb	#0		; sub carry of low word sub
	sbca	#0
	std	,x
	puls	u,pc




	ENDSECTION
