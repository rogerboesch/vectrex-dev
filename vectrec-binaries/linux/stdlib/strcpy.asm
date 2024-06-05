	SECTION code

_strcpy	EXPORT


* byte *strcpy(byte *dest, byte *src);
* Returns dest.
*
_strcpy
	pshs	u,x
	ldx	6,s		destination string
	ldu	8,s		source string

_strcpy_010
	lda	,u+
	sta	,x+
	bne	_strcpy_010

	ldd	6,s		destination string
	puls	x,u,pc




	ENDSECTION
