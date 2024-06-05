	SECTION code

ATOW	EXPORT


* Convert unsigned decimal integer pointed by X into word returned in D.
* Upon return, X points to character where conversion stopped.
ATOW	CLR	,-S		init 16-bit accumulator
	CLR	,-S

ATW100	LDB	,X+		read next char from line buffer
	CMPB	#$30
	BLO	ATW900		stop reading at non-digit char
	CMPB	#$39
	BHI	ATW900		stop reading at non-digit char
	SUBB	#$30		convert from ASCII '0'..'9' to 0..9
	CLRA

	PSHS	X,B,A
	LDX	4,S		multiply acc by ten
	LDB	#10
	BSR	MUL168
	STD	4,S
	PULS	A,B,X

	ADDD	,S		add this digit to acc
	STD	,S
	BRA	ATW100

ATW900	LEAX	-1,X
	PULS	A,B,PC


* Multiply B by X, unsigned; return result in D; preserve X.
MUL168	PSHS	X,B,A		acc A pushed to create temp byte at ,S
	LDA	2,S		high byte of X
	MUL			multiply by B
	STB	,S		keep intermediate result
	LDB	1,S		original B
	LDA	3,S		low byte of X
	MUL
	ADDA	,S
	LEAS	4,S
	RTS





	ENDSECTION
