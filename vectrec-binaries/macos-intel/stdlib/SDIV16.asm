	SECTION code

SDIV16	EXPORT

DIV16   IMPORT


* Divide X by D, signed; return quotient in X, remainder in D.
* Non-zero remainder is negative iff dividend is negative.
SDIV16	PSHS	X,B,A
	CLR	,-S		counter: number of negative arguments (0..2)
	CLR	,-S		boolean: was dividend negative?
	TSTA			is divisor negative?
	BGE	SDIV16_10	if not
	INC	1,S
	COMA			negate divisor
	COMB
	ADDD	#1
	STD	2,S
SDIV16_10
	LDD	4,S		is dividend negative?
	BGE	SDIV16_20	if not
	INC	,S
	INC	1,S
	COMA			negate dividend
	COMB
	ADDD	#1
	STD	4,S
SDIV16_20
	LDD	2,S		reload divisor
	LDX	4,S		reload dividend
	LBSR	DIV16

* Counter is 0, 1 or 2. Quotient negative if counter is 1.
	LSR	1,S		check bit 0 of counter (1 -> negative quotient)
	BCC	SDIV16_30	quotient not negative
	EXG	X,D		put quotient in D and remainder in X
	COMA			negate quotient
	COMB
	ADDD	#1
	EXG	X,D		return quotient and remainder in X and D

SDIV16_30
* Negate the remainder if the dividend was negative.
	TST	,S		was dividend negative?
	BEQ	SDIV16_40	if not
	COMA			negate remainder
	COMB
	ADDD	#1
SDIV16_40
	LEAS	6,S
	RTS




	ENDSECTION
