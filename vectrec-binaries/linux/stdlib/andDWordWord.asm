	SECTION code

andDWordWord	EXPORT

; Input: Pushed arguments: addresses of left dword, value of right word;
;        X => destination dword (may be same as address of left dword).
; Preserves X. Trashes D.
;
andDWordWord
	pshs	u
	clr	,x		; high word becomes 0
	clr	1,x
	ldu	4,s		; left dword
	ldd	2,u		; low word
	anda	6,s		; right word is at S+6
	andb	7,s
	std	2,x
	puls	u,pc

#endif

	ENDSECTION
