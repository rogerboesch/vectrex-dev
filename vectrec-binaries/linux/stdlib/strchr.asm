	SECTION code

_strchr	EXPORT


* byte *strchr(byte *s, word c)
* Note that CMOC passes a character value (e.g., 'x')
* as a word to a function.
*
_strchr pshs	x
	ldx	4,s		string
	lda	7,s		char to search for (ignore MSB)

_strchr_100
	cmpa	,x
	beq	_strchr_800	found
	tst	,x+
	bne	_strchr_100

	clra			not found: return NULL
	clrb
	bra	_strchr_900
_strchr_800
	tfr	x,d		return address where char found
_strchr_900
	puls	x,pc




	ENDSECTION
