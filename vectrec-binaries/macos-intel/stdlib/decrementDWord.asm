	SECTION code

decrementDWord	EXPORT


; Preserves X. 
;
decrementDWord
	ldd	2,x		; low word
	subd	#1
	std	2,x
	ldd	,x
	sbcb	#0
	sbca	#0
	std	,x
	rts




	ENDSECTION
