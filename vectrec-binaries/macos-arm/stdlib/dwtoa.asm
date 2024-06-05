        SECTION code

_dwtoa  EXPORT

sub32   IMPORT


* Utility routine for dwtoa.
*
doDigit:
	PSHS	U	
	TFR	S,U	
	LEAS	-5,S	
* Line 84: init of variable c
	CLR	-1,U		variable c

doDigit_010:
* Line 85: for body
* Line 87: init of variable hiCopy
	LDX	4,U		variable hi (word *)
	LDD	,X		read *hi (word)
	STD	-5,U		variable hiCopy
* Line 88: init of variable loCopy
	LDD	2,X		load hi[1] (word)
	STD	-3,U		variable loCopy
* Line 90: if
* Line 90: function call: sub32()
	LDD	8,U		variable l
	PSHS	B,A		argument 3 of sub32()
	LDD	6,U		variable h
	PSHS	B,A		argument 2 of sub32()
	PSHS	X		'hi': argument 1 of sub32()
	LBSR	sub32		sub32(): returns carry in B
	LEAS	6,S	
	TSTB
	BEQ	doDigit_020	no carry: continue subtracting
* Line 93: assignment: =
	LDX	4,U		variable hi
	LDD	-5,U	
	STD	,X	
* Line 94: assignment: =
	LDD	-3,U	
	STD	2,X	
	BRA	doDigit_030	break

doDigit_020:
	INC	-1,U		variable c
	BRA	doDigit_010	

doDigit_030:

* Line 101: assignment: +=
	LDB	-1,U	
	ADDB	#$30	
* Line 103: assignment: =
	LDX	10,U		variable dest (byte *)
	STB	,X		store character in *dest

	TFR	U,S	
	PULS	U,PC		end of doDigit


* char *dwtoa(char *buffer, unsigned hi, unsigned lo)
*
* Prints the 32-bit unsigned integer given by 'hi' and 'lo'
* in the designated 11-byte buffer as an ASCII decimal string
* terminated by a '\0' character.
* The resulting buffer always receives a 10-character string
* and is zero padded at the left.
* Returns (in D) the address of the first non-'0' character in the
* resulting buffer, or of the last '0' character if the given
* value was zero.
* Preserves U. Trashes X.
*
_dwtoa	PSHS	U	
	LEAU	,S
	LEAS	-5,S	
* Line 125: init of variable dest
	LDD	4,U		variable buffer
	STD	-4,U		variable dest
* Line 127: init of variable pPower
	LEAX	powersOfTen,PCR	variable pow10_9_hi (upper-case PCR b/c code ref)
	STX	-2,U		variable pPower
* Line 131: for init
* Line 131: init of variable i
	LDB	#$09	
	STB	-5,U		variable i
	BRA	dwtoa_020	jump to for condition

dwtoa_010:
* Line 131: for body

* Line 138: function call: doDigit()
	ldx	-4,U		variable dest
	PSHS	x		argument 4 of doDigit()
	leax	1,x		point to next byte for next iteration
	stx	-4,u

	LDX	-2,U		variable pPower

	LDD	2,X		low word of that power of 10
	PSHS	B,A		argument 3 of doDigit()

	LDD	,X		high word of a power of 10
	PSHS	B,A		argument 2 of doDigit()

	leax	4,x		advance pPower to next power of 10
	stx	-2,U		store into variable pPower for next iteration

	LEAX	6,U		point to argument 'hi', which is followed by 'lo'
	PSHS	X		argument 1 of doDigit()

	BSR	doDigit

	LEAS	8,S	

* Line 131: for increment
	DEC	-5,U		variable i
dwtoa_020:
* Line 131: for condition
	TST	-5,U	
	BNE	dwtoa_010	end of loop of calls to doDigit()

* Store last digit, which is in variable 'lo', at 'dest'.
* Line 143: assignment: =
	LDB	9,U		low byte of variable lo (contains 0..9)
	addb	#$30		make 0..9 into '0'..'9' in ASCII
	LDX	-4,U		variable dest
	STB	,X+
	clr	,x		write terminating '\0'

* Skip leading zeroes in the resulting string.
	LDX	4,U		variable buffer
dwtoa_030:
	LDB	,X+
	CMPB	#$30
	BEQ	dwtoa_030	

	leax	-1,x

* If entire string contains '\0' characters, return address of last '\0'.
	TST	,X	
	BNE	dwtoa_040	
	leax	-1,x

dwtoa_040:
	tfr	x,d		return address of 1st non-0 digit, or of last 0 if value is 0

	LEAS	,U
	PULS	U,PC	

* Powers of ten as 32-bit integers, in descending order.
* Used by dwtoa.
*
powersOfTen:
	FDB	$3b9a,$ca00	10**9
	FDB	$05f5,$e100	10**8
	FDB	$0098,$9680	10**7
	FDB	$000f,$4240	10**6
	FDB	$0001,$86a0	10**5
	FDB	$0000,$2710	10**4
	FDB	$0000,$03E8	10**3
	FDB	$0000,$0064	10**2
	FDB	$0000,$000A	10**1


        ENDSECTION

