	SECTION code

initSingleFromSingle	EXPORT


; Interface of routines named initXXXFromSingle:
; Input: D = Address of packed single-precision real to use as source.
;        X = Address of location to be initialized, of type XXX.
;
initSingleFromSingle
	pshs	u
	tfr	d,u
	ldd	,u
	std	,x
	ldd	2,u
	std	2,x
	ldb	4,u
	stb	4,x
	puls	u,pc
	rts




	ENDSECTION
