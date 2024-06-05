	SECTION code

_strupr	EXPORT


* byte *strupr(byte *)
_strupr	pshs	x
	ldx	4,s		string address
	bra	_strupr_020
_strupr_010
	cmpa	#97		'a'
	blo	_strupr_020
	cmpa	#122		'z'
	bhi	_strupr_020
	suba	#32		make uppercase
	sta	-1,x
_strupr_020
	lda	,x+
	bne	_strupr_010
	ldd	4,s		return string address
	puls	x,pc




	ENDSECTION
