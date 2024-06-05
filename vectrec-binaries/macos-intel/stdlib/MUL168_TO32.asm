	SECTION code

MUL168_TO32	EXPORT
_mulww		EXPORT


* Multiply D by X, unsigned; return 32-bit result in D (high 16 bits)
* and X (low 16 bits).
*
MUL168_TO32
	pshs	x,b,a
	clr	,-s		allocate 4 bytes to store 24-bit product
	clr	,-s
	clr	,-s
	clr	,-s

	lda	7,s		low byte of X
	mul			mul by B
	std	2,s		low 16-bit of 32-bit storage

	ldd	5,s		original B in A, high byte of X in B
	mul

	addd	1,s		add D to middle 16 bits of storage
	pshs	cc		preserve carry
	std	2,s		store sum in middle 16 bits of storage
	puls	b
	andb	#1		carry from sum
	stb	,s		store carry in high byte of storage

	lda	4,s		original A
	ldb	7,s		low byte of X
	mul
	addd	1,s		add D to middle 16 bits of storage
	pshs	cc		preserve carry
	std	2,s		store sum in middle 16 bits of storage
	puls	b
	andb	#1		carry from sum
	addb	,s		add carry to high byte of storage
	stb	,s

	lda	4,s		original A
	ldb	6,s		high byte of X
	mul
	addd	,s		add D to high word of storage
	std	,s		drop carry

	ldx	2,s		return low word of product in X

	leas	8,s
	rts


* word mulww(word *productHi, word u, word v)
*
* Multiples u by v to obtain a 32-bit product.
* Stores the high word of the product in *productHi,
* and returns the low word of the product.
*
_mulww
	pshs	u
	tfr	s,u

	ldx	6,u	load u
	ldd	8,u	load v
	bsr	MUL168_TO32
	pshs	x	preserve low word of product
	ldx	4,u	get productHi pointer
	std	,x	return high byte of product
	puls	a,b	retrieve and return low word of product

	tfr	u,s
	puls	u,pc




	ENDSECTION
