	SECTION code

_subdww	EXPORT


* void subdww(word *dw, word w)
*
_subdww
	ldx	2,s	load dw to point to double word
	ldd	2,x	low word of dword
	subd	4,s	sub w: affects carry flag
	std	2,x	store low word of result (does not affect carry flag)
	ldd	,x	load high word of dword (does not affect carry flag)
	sbcb	#0	sub possible borrow from subd
	sbca	#0	sub possible borrow from sbcb
	std	,x
	rts




	ENDSECTION
