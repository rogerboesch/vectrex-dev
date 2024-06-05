	SECTION code

mulDWordUnsignedInt	EXPORT

MUL32                   IMPORT


; Input: Pushed arguments: address of dword, value of unsigned int.
;        X => destination dword: X is allowed to be the same address
;             as that of the left dword.
; Preserves X.
;
mulDWordUnsignedInt
	pshs	u,y,x
	leas	-4,s		; temp result
	leay	,s		; make MUL32 store result at ,s
	ldx	12,s		; left address
	ldd	14,s		; right side
	pshs	b,a
	clr	,-s
	clr	,-s
	leau	,s		; point to zero-extended right side
	lbsr	MUL32
	ldx	8,s		; original X points to destination
    	ldd	,y		; copy MUL32 result to original X
	std	,x
	ldd	2,y
	std	2,x
	leas	8,s
	puls	x,y,u,pc




	ENDSECTION
