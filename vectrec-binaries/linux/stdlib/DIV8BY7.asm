	SECTION code

DIV8BY7	EXPORT


* Unsigned division by seven
* Input: an unsigned byte (0..255) in A
* Output: Computes A/7
*         quotient (0..36) in B
*         remainder (0..6) in A
* Using (8a+b)/7 = a + (a+b)/7
* where a = higher five bits and b = lower three bits
* Source: DIVIDE7 on http://mirrors.apple2.org.za/ground.icaen.uiowa.edu/MiscInfo/Programming/div7
*
DIV8BY7
	TFR	A,B
	ANDA	#7
	PSHS	A	low bits (b)
	TFR	B,A
	LSRA
	LSRA
	LSRA
	TFR	A,B	high bits, divided by 8 (a)
	ANDCC	#$FE	clear carry
	ADCA	,S+	a + b. here we know carry is low.
DIV8BY7_010:
	INCB		the loop is executed between 1 and 6 times
	SBCA	#7	since A is at most 38
	BCC	DIV8BY7_010
	ADDA	#7
	DECB
	RTS
PAUL	EQU	12




	ENDSECTION
