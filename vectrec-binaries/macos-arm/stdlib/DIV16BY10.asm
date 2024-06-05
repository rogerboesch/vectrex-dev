	SECTION code

DIV16BY10	EXPORT


* Divide D by 10.
* Quotient left in D.
* Does not preserve X.
* Source: Hacker's Delight (Addison-Wesley, 2003, 2012)
*         http://www.hackersdelight.org/divcMore.pdf
*
DIV16BY10
	TFR	D,X	save n
	LSRA
	RORB		D = n >> 1
	PSHS	B,A	q := ,S (word)
	LSRA
	RORB		D = n >> 2
	ADDD	,S
	STD	,S	q = (n >> 1) + (n >> 2)
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	ADDD	,S
	STD	,S	D = q + (q >> 4)
	TFR	A,B
	CLRA		q >> 8
	ADDD	,S
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB		q >> 3
	STD	,S
	LSLB
	ROLA
	LSLB
	ROLA		q << 2
	ADDD	,S
	LSLB
	ROLA
	PSHS	B,A
	TFR	X,D	D = n
	SUBD	,S++	D = r
	CMPD	#9	r > 9 ?
	BLS	DIV16BY10_010
	LDB	#1
	BRA	DIV16BY10_020
DIV16BY10_010
	CLRB
DIV16BY10_020
	LDA	,S
	ADDB	1,S
	ADCA	#0
	PULS	X,PC	discard q and return D




	ENDSECTION
