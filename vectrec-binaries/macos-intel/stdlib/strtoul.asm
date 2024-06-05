	SECTION code

_strtoul	EXPORT

mulDWordUnsignedInt     IMPORT
negateDWord             IMPORT


; unsigned long strtoul(char *nptr, char **endptr);
;
; A hidden first argument is passed to point to the 32-bit return value slot.
;
_strtoul
	pshs	u
	leau	,s
	clr	,-s		-1,U: boolean: string contains negative number

	ldx	4,u		address of return value slot
	clra
	clrb
	std	,x		clear return value (accumulator)
	std	2,x

	ldx	6,u		nptr
	ldb	,x
	cmpb	#'-		negative number?
	bne	@loop		no
	inc	-1,u
	leax	1,x		pass minus sign
@loop
	LDB	,X+		read next char from ASCII buffer
	CMPB	#'0
	BLO	@done		stop reading at non-digit char
	CMPB	#'9
	BHI	@done		stop reading at non-digit char
	SUBB	#'0		convert from ASCII '0'..'9' to 0..9
	CLRA
	pshs	x,b		preserve char reader, new digit
; Call mulDWordUnsignedInt to multiply accumulator by 10.
	ldb	#10
	pshs	b,a
	ldx	4,u		address of return value slot
	pshs	x
	lbsr	mulDWordUnsignedInt	preserves X, trashes D
	leas	4,s
;
	puls	b		restore new digit
; Add B to accumulator.
	clra
	ldx	4,u		address of return value slot
	addd	2,x		add low word of acc, sets carry
	std	2,x
	ldd	,x		get high word of acc
	adcb	#0		add carry
	adca	#0
	std	,x
;
	puls	x		restore char reader
	bra	@loop
@done
	leax	-1,x		go back to last non-digit char
	stx	[8,U]		return that address in *endptr

	ldx	4,u		address of return value slot

; Negate the result if minus sign was read.
	tst	-1,u
	beq	@notNeg
	lbsr	negateDWord
@notNeg
	leas	,u
	puls	u,pc




	ENDSECTION
