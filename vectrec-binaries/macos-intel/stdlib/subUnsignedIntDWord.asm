	SECTION code

subUnsignedIntDWord	EXPORT


; Input: Pushed arguments: value of unsigned int, address of dword.
;        X => destination dword.
; Preserves X.
;
subUnsignedIntDWord
	pshs	u
	ldd	4,s		; left side
	ldu	6,s		; source dword
	subd	2,u		; sub low word of source dword
	std	2,x		; store in low word of result dword
	ldd	#0		; zero-extend left side (clra & clrb would clear C)
	sbcb	1,u		; sub carry of low word sub from zero-extension
	sbca	,u
	std	,x
	puls	u,pc




	ENDSECTION
