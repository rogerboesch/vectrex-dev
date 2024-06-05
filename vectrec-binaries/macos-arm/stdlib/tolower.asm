	SECTION code

_tolower	EXPORT


_tolower
	ldd	2,s		character in B
	cmpb	#65		'A'
	blo	_tolower_done
	cmpb	#90		'Z'
	bhi	_tolower_done
	addb	#32
_tolower_done
	rts




	ENDSECTION
