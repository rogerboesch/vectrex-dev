	SECTION code

_strlwr	EXPORT


* byte *strlwr(byte *)
_strlwr	pshs	x
	ldx	4,s		string address
	bra	_strlwr_020
_strlwr_010
	cmpa	#65		'A'
	blo	_strlwr_020
	cmpa	#90		'Z'
	bhi	_strlwr_020
	adda	#32		make lowercase
	sta	-1,x
_strlwr_020
	lda	,x+
	bne	_strlwr_010
	ldd	4,s		return string address
	puls	x,pc




	ENDSECTION
