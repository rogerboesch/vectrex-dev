	SECTION code

andDWordDWord	EXPORT


; Input: Pushed arguments: addresses of left and right dword;
;        X => destination dword (may be same as address of left dword).
; Preserves X. Trashes D.
;
andDWordDWord
	pshs	u,y
	ldu	6,s		; left dword
	ldy	8,s		; right dword
	ldd	,u		; high word
	anda	,y
	andb	1,y
	std	,x
	ldd	2,u		; low word
	anda	2,y
	andb	3,y
	std	2,x
	puls	y,u,pc




	ENDSECTION
