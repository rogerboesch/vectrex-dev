	SECTION code

_strlen	EXPORT


_strlen pshs	x
	ldx	4,s
_strlen_010
	tst	,x+
	bne	_strlen_010

	tfr	x,d
	subd	#1		compensate for increment past '\0'
	subd	4,s		substract start address

	puls	x,pc




	ENDSECTION
