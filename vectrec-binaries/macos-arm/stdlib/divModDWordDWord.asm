	SECTION code

divModDWordDWord	EXPORT

DIV32                   IMPORT


; Input: pushed addresses of dividend and divisor;
;        X => address of result (quotient or remainder);
;        B => 0 for division, 1 for remainder.
; Preserves X, Y, U. Trashes D.
;
divModDWordDWord
	pshs	u,y,x,b
	leas	-12,s
; 0,s: Copy of dividend (to avoid modifying the caller's).
; 4,s: Quotient received from DIV32.
; 8,s: Remainder received from DIV32.
	ldx	21,s		; address of dividend
	ldd	,x		; copy to 0,s
	std	,s
	ldd	2,x
	std	2,s
	leax	,s		; point to dividend
	ldu	23,s		; point to divisor
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
	ldd	,u		; copy result to X
	std	,x
	ldd	2,u
	std	2,x
	leas	12,s
	puls	b,x,y,u,pc




	ENDSECTION
