	SECTION code

SDIV8	EXPORT

DIV8    IMPORT


* Divide A by B, signed; return quotient in B, remainder in A.
* Non-zero remainder is negative iff dividend is negative.
* Does not preserve X.
SDIV8
	CLR	,-S		counter: number of negative arguments (0..2)
	CLR	,-S		boolean: was dividend negative?
	TSTB			is divisor negative?
	BGE	SDIV8_10	if not
	INC	1,S		increment counter of negative arguments
	NEGB			negate divisor
SDIV8_10
	TSTA			is dividend negative?
	BGE	SDIV8_20	if not
	INC	,S		remember that dividend was negative
	INC	1,S		increment counter of negative arguments
	NEGA			negate dividend
SDIV8_20
	LBSR	DIV8

* Counter is 0, 1 or 2. Quotient negative if counter is 1.
	LSR	1,S		check bit 0 of counter (1 -> negative quotient)
	BCC	SDIV8_30	quotient not negative
	NEGB			negate quotient

SDIV8_30
* Negate the remainder if the dividend was negative.
	TST	,S		was dividend negative?
	BEQ	SDIV8_40	if not
	NEGA			negate remainder
SDIV8_40
	LEAS	2,S
	RTS




	ENDSECTION
