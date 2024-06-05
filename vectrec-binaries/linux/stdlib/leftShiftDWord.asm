	SECTION code

leftShiftDWord	EXPORT

leftShiftDWordAtXByB    IMPORT


; Input: 1st pushed argument: address of dword;
;        2nd pushed argument: byte containing number of bits to shift;
;        X => destination dword (may point to left dword).
; Output: Result at X.
; Preserves X. Trashes D.
;
leftShiftDWord
	pshs	u
	ldb	6,s		; number of bits to shift
	cmpb	#32
	bhs	@resultZero	; all bits of left dword get shifted out
	ldu	4,s		; address of left dword
	ldd	,u		; copy left dword to destination
	std	,x
	ldd	2,u
	std	2,x
	ldb	6,s		; number of bits to shift
	lbsr	leftShiftDWordAtXByB	; preserves X
	bra	@done
@resultZero
	clr	,x
	clr	1,x
	clr	2,x
	clr	3,x
@done
	puls	u,pc




	ENDSECTION
