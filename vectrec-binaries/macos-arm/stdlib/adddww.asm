	SECTION code

_adddww	EXPORT


* void adddww(word *dw, word w)
*
_adddww
	ldx	2,s	load dw to point to double word
	ldd	2,x	low word of dword
	addd	4,s	add w: affects carry flag
	std	2,x	store low word of result (does not affect carry flag)
	ldd	,x	load high word of dword (does not affect carry flag)
	adcb	#0	add possible carry from add of low word with w
	adca	#0	add possible carry from adcb
	std	,x
	rts




	ENDSECTION
