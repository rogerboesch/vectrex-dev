	SECTION code

_toupper	EXPORT


_toupper
	ldd	2,s		character in B
	cmpb	#97		'a'
	blo	_toupper_done
	cmpb	#122		'z'
	bhi	_toupper_done
	subb	#32
_toupper_done
	rts




	ENDSECTION
