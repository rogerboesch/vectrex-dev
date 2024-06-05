	SECTION code

_strncpy	EXPORT


* byte *strncpy(byte *dest, byte *src, word n);
* Returns dest.
*
_strncpy
	pshs	u,y,x
	ldx	8,s		destination string
	ldu	10,s		source string
	ldy	#0		counts bytes filled
	bra	_strncpy_020

_strncpy_010
	lda	,u+		is next source byte terminator?
	beq	_strncpy_050	yes

	sta	,x+		store in destination string
	leay	1,y		one more byte filled
_strncpy_020
	cmpy	12,s		filled all bytes to fill?
	blo	_strncpy_010	no

	bra	_strncpy_090

_strncpy_040
	clr	,x+		pad with '\0'
	leay	1,y

_strncpy_050
	cmpy	12,s		filled all bytes to fill?
	blo	_strncpy_040	no
	
_strncpy_090
	ldd	8,s		destination string
	puls	x,y,u,pc




	ENDSECTION
