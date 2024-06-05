	SECTION code

initDWordFromSignedWord	EXPORT


; Input: X => dword to initialize. D => signed word to initialize the dword with.
; Preserves X. Trashes D.
;
initDWordFromSignedWord
	std	2,x		; low word
	tfr	a,b
	sex
	sta	1,x
	sta	,x
	rts




	ENDSECTION
