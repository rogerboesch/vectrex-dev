	SECTION code

initDWordFromUnsignedWord	EXPORT


; Input: X => dword to initialize. D => unsigned word to initialize the dword with.
; Preserves X.
;
initDWordFromUnsignedWord
	std	2,x		; low word
	clr	1,x
	clr	,x
	rts




	ENDSECTION
