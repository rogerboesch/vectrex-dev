	SECTION code

memcpy	EXPORT
_memcpy	EXPORT


* Preserves X and U. Trashes D.
*
memcpy
_memcpy pshs	u,x
	ldx	6,s		destination string
	ldu	8,s		source string
	tfr	u,d
	addd	10,s		end of source region
	pshs	b,a
	bra	_memcpy_100
_memcpy_050
	lda	,u+
	sta	,x+
_memcpy_100
	cmpu	,s		compare with end address
	bne	_memcpy_050

	leas	2,s		dispose of end address
	ldd	6,s		return start address
	puls	x,u,pc




	ENDSECTION
