	SECTION code

rightShiftDWord	EXPORT

rightShiftDWordAtXByB   IMPORT


; Input: 1st pushed argument: address of dword;
;        2nd pushed argument: byte containing sign extension flag
;                             (0 = zero-extended; $FF = sign-extend);
;        3rd pushed argument: byte containing number of bits to shift;
;        X => destination dword (may point to left dword).
; Output: Result at X.
; Preserves X. Trashes D.
;
rightShiftDWord
	pshs	u
	ldb	7,s		; number of bits to shift
	cmpb	#32
	bhs	@shiftAll	; all bits of left dword get shifted out
	ldu	4,s		; address of left dword
	ldd	,u		; copy left dword to destination
	std	,x
	ldd	2,u
	std	2,x
	ldd	6,s		; A = sign extension flag, B = number of bits to shift
	lbsr	rightShiftDWordAtXByB	; preserves X
	bra	@done
@shiftAll
	ldb	6,s		; sign extension flag
	beq	@allZeroes
	tst	[4,s]		; test high byte of input dword
	bmi	@fillWithB
@allZeroes
	clrb			; fill with 0's b/c zero-extend or signed dword >= 0
@fillWithB
	stb	,x
	stb	1,x
	stb	2,x
	stb	3,x
@done
	puls	u,pc




	ENDSECTION
