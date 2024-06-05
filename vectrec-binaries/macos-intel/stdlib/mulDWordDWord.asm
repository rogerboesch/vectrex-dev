	SECTION code

mulDWordDWord	EXPORT

MUL32           IMPORT


; Input: pushed arguments: addresses of left and right dwords
;        X => destination dword: X is allowed to be the same address
;             as that of the left dword.
; Output: product at X.
; Preserves X. Trashes D.
;
mulDWordDWord
	pshs	u,y,x
	leas	-4,s		; temp result
	leay	,s		; make MUL32 store result at ,s
	ldx	12,s		; left address
	ldu	14,s		; right address
	lbsr	MUL32
	ldx	4,s		; original X points to destination
    	ldd	,y		; copy MUL32 result to original X
	std	,x
	ldd	2,y
	std	2,x
	leas	4,s
	puls	x,y,u,pc




	ENDSECTION
