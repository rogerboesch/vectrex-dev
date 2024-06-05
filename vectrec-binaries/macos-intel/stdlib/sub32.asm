	SECTION code

sub32	EXPORT

sub32xu IMPORT


* byte sub32(word *hi, word h, word l)
* Subtracts 32-bit integer h:l from 32-bit unsigned integer
* pointed by 'hi'.
* Returns carry of the subtraction in B.
*
sub32:
	PSHS	U	
	LEAU	,S
	LEAS	-1,S		variable carry
	pshs	x,b
	pshs	u
	ldx	4,U		variable hi
	leau	6,U		variable h
	lbsr	sub32xu
	puls	u
	tfr	cc,b
	andb	#1
	stb	-1,U		variable carry
	puls	b,x
	LDB	-1,U		variable carry
	LEAS	,U
	PULS	U,PC	


	ENDSECTION
