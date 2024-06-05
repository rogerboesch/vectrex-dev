	SECTION code

divModUnsignedIntDWord	EXPORT

DIV32                   IMPORT


; Input: Pushed arguments: value of unsigned int, address of dword.
;        X => destination dword.
; Preserves X.
;
divModUnsignedIntDWord
	pshs	u,y,x,b
	leas	-12,s
; 0,s: Dividend extended to 32 bits.
; 4,s: Quotient received from DIV32.
; 8,s: Remainder received from DIV32.
	ldd	21,s		; value of dividend
	std	2,s		; extend to 32 bits
	clr	1,s
	clr	,s
	leax	,s		; point to dividend
	ldu	23,s		; address of divisor
	leay	4,s		; point to quotient and remainder (8 bytes)
	lbsr	DIV32
	ldx	13,s		; retrieve destination address for quotient
	tst	12,s		; caller wants quotient or remainder?
	bne	@remainder
	leau	4,s
	bra	@copy
@remainder
	leau	8,s
@copy
	ldd	,u		; copy quotient to X
	std	,x
	ldd	2,u
	std	2,x
	leas	12,s
	puls	b,x,y,u,pc




	ENDSECTION
