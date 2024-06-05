	SECTION code

MUL168_TO24	EXPORT
_mulwb		EXPORT


* Multiply B by X, unsigned; return 24-bit result in B (high 8 bits)
* and X (low 16 bits). Register A preserved.
MUL168_TO24
	pshs	x,b,a
	clr	,-s		allocate 3 bytes to store 24-bit product
	clr	,-s
	clr	,-s

	lda	6,s		low byte of X
	mul
	std	1,s		low 16-bit of 24-bit storage

	ldd	4,s		original B in A, high byte of X in B
	mul

	addd	,s		add D to high 16 bits of storage
	std	,s

	ldb	,s
	ldx	1,s

	lda	3,s		restore orignal A
	leas	7,s
	rts


* word mulwb(byte *productHi, word w, byte b)
*
* Multiples w by b to obtain a 24-bit product.
* Stores the high byte of the product in *productHi,
* and returns the low word of the product.
*
_mulwb
	pshs	u
	tfr	s,u

	ldx	6,u	load w
	ldb	9,u	load b
	bsr	MUL168_TO24
	pshs	x	preserve low word of product
	ldx	4,u	get productHi pointer
	stb	,x	return high byte of product
	puls	a,b	retrieve and return low word of product

	tfr	u,s
	puls	u,pc




	ENDSECTION
