	SECTION code

MUL16	EXPORT


* Multiply D by X, unsigned; return result in D; preserve X.
MUL16	PSHS	U,X,B,A		U pushed to create 2 temp bytes at 4,S
	LDB	3,S		low byte of original X
	MUL
	STD	4,S		keep for later
	LDD	1,S		low byte of orig D, high byte of orig X
	MUL
	ADDB	5,S		only low byte is needed
	STB	5,S
	LDA	1,S		low byte of orig D
	LDB	3,S		low byte of orig X
	MUL
	ADDA	5,S
	LEAS	6,S
	RTS




	ENDSECTION
