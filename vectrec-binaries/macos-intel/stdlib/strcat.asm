	SECTION code

_strcat	EXPORT

_strcpy IMPORT


* byte *strcat(byte *dest, byte *src);
* Returns dest.
*
_strcat
	pshs	x
	ldx	6,s		source string
	pshs	x		pass it to _strcpy

	ldx	6,s		destination string
_strcat_010
	tst	,x+
	bne	_strcat_010

	leax	-1,x		point back to '\0'
	pshs	x		pass as destination string to _strcpy

	lbsr	_strcpy

	leas	4,s		dispose of _strcpy arguments
	ldd	4,s		return original destination address
	puls	x,pc




	ENDSECTION
