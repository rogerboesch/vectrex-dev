	SECTION code

mulIntDWord	EXPORT

MUL32           IMPORT


; Input: Pushed arguments: value of unsigned int, address of dword.
;        X => destination dword.
; Preserves X.
;
mulIntDWord
	pshs	u,y,x
	tfr	x,y		; result address
	ldd	8,s		; left side
	ldx	10,s		; right address
	pshs	b,a
	tfr	a,b
	sex
	pshs	a
	pshs	a
	leau	,s		; point to zero-extended left side
	lbsr	MUL32
	leas	4,s	
	puls	x,y,u,pc




	ENDSECTION
