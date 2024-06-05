	SECTION code

incrementDWord	EXPORT


; Preserves X. 
;
incrementDWord
	ldd	2,x		; low word
	addd	#1
	std	2,x
	ldd	,x
	adcb	#0
	adca	#0
	std	,x
	rts




	ENDSECTION
