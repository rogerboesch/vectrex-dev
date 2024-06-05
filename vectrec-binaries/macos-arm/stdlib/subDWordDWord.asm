	SECTION code

subDWordDWord	EXPORT


subDWordDWord
	pshs	u,y
	ldu	6,s		; left
	ldy	8,s		; right

	ldd	2,u		; low word
	subd	2,y
	std	2,x

	ldd	,u		; high word
	sbcb	1,y
	sbca	,y
	std	,x

	puls	y,u,pc




	ENDSECTION
