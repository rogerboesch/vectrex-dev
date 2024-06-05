	SECTION code

copyWordToDWord	EXPORT


; Input: pushed word => input word;
;        X => destination dword.
; Output: Zero-extended dword at X.
; Preserves X. Trashes D.
;
copyWordToDWord
	ldd	2,s
	std	2,x
	clr	1,x
	clr	,x
	rts




	ENDSECTION
