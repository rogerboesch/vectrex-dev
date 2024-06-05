	SECTION code

DIV16	EXPORT


* Divide X by D, unsigned; return quotient in X, remainder in D.
DIV16	PSHS	X,B,A
	LDB	#16
	PSHS	B
	CLRA
	CLRB
	PSHS	B,A
* 0,S=16-bit quotient; 2,S=loop counter;
* 3,S=16-bit divisor; 5,S=16-bit dividend

D16010	LSL	6,S		shift MSB of dividend into carry
	ROL	5,S		shift carry and MSB of dividend, into carry
	ROLB			new bit of dividend now in bit 0 of B
	ROLA
	CMPD	3,S		does the divisor "fit" into D?
	BLO	D16020		if not
	SUBD	3,S
	ORCC	#1		set carry
	BRA	D16030
D16020	ANDCC	#$FE		reset carry
D16030	ROL	1,S		shift carry into quotient
	ROL	,S

	DEC	2,S		another bit of the dividend to process?
	BNE	D16010		if yes

	PULS	X		quotient to return
	LEAS	5,S
	RTS




	ENDSECTION
