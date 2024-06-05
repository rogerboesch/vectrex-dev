	SECTION code

_zerodw	EXPORT


* void zerodw(word *dw)
*
_zerodw
	ldx	2,s	load dw to point to double word
	clra
	clrb
	std	,x
	std	2,x
	rts




	ENDSECTION
