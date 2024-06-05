	SECTION code

DIV8	EXPORT


* Divide A by B, unsigned; return quotient in B, remainder in A.
* Does not preserve X.
DIV8	PSHS	A		push dividend
	PSHS	B		push divisor
	LDA	#8		loop counter
	CLRB
	PSHS	B
* 0,S=8-bit quotient;
* 1,S=8-bit divisor; 2,S=8-bit dividend

DV8010	LSL	2,S		shift dividend into carry
	ROLB			new bit of dividend now in bit 0 of B
	CMPB	1,S		does the divisor "fit" into B?
	BLO	DV8020		if not
	SUBB	1,S
	ORCC	#1		set carry
	BRA	DV8030
DV8020	ANDCC	#$FE		reset carry
DV8030	ROL	,S		shift carry into quotient

	DECA			another bit of the dividend to process?
	BNE	DV8010		if yes

	TFR	B,A		remainder to return
	PULS	B		quotient to return
	LEAS	2,S
	RTS




	ENDSECTION
