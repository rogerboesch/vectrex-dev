	SECTION code

signExtWordToDWord	EXPORT


; Input: pushed word => input signed word;
;        X => destination dword.
; Output: Sign-extended dword at X.
; Preserves X. Trashes D.
;
signExtWordToDWord
	ldd	2,s
	std	2,x
	tfr	a,b
	sex
	sta	1,x
	sta	,x
	rts




	ENDSECTION
