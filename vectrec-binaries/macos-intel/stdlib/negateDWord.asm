	SECTION code

negateDWord	EXPORT


; Input: X => Long to negate.
; Preserves X. Trashes D.
;
negateDWord
	com	3,x
	com	2,x
	com	1,x
	com	,x
	ldd	2,x		; low word
	addd	#1		; sets carry value
	std	2,x
	ldd	,x		; high word
	adcb	#0		; add carry
	adca	#0
	std	,x
	rts




	ENDSECTION
