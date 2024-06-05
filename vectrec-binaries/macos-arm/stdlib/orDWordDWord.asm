	SECTION code

orDWordDWord	EXPORT


; Input: Pushed arguments: addresses of left and right dword;
;        X => destination dword (may be same as address of left dword).
; Preserves X. Trashes D.
;
orDWordDWord
	pshs	u,y
	ldu	6,s		; left dword
	ldy	8,s		; right dword
	ldd	,u		; high word
	ora	,y
	orb	1,y
	std	,x
	ldd	2,u		; low word
	ora	2,y
	orb	3,y
	std	2,x
	puls	y,u,pc




	ENDSECTION
