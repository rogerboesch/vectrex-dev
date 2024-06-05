	SECTION code

testAndRemoveSignOnWord	EXPORT

negateDWord             IMPORT


; Input: pushed word => signed word to test;
;        X => dword that receives absolute value of word.
; Output: non-negative dword at X;
;         N is 1 if input word was negative, 0 otherwise.
; Preserves X. Trashes D.
;
testAndRemoveSignOnWord
	ldd	2,s		; pushed argument
	std	2,x
	tfr	a,b		; sign extension
	sex
	sta	1,x
	sta	,x
	bpl	@done
	lbsr	negateDWord	; dword at X is < 0; make is positive
	orcc	#8		; set N = 1
@done
	rts




	ENDSECTION
