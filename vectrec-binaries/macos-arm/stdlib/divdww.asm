	SECTION code

_divdww	EXPORT


* void divdww(unsigned dividend[2], unsigned divisor)
*
* Writes quotient into dividend[0..1].
* Does nothing if divisor is zero.
*
_divdww
_div3216
	pshs	u
	tfr	s,u

	ldd	6,u		load divisor
	beq	div3216_900	division by zero: do nothing

	clra			push 32-bit zero
	clrb
	pshs	b,a
	pshs	b,a		-4,u will be 32-bit quotient

	ldx	4,u		X points to 4-byte dividend

	ldb	#32		one iteration per bit in the dividend
	pshs	b		-5,u is loop counter

* Dividend will be shifted left into a 17-bit accumulator.
* The low 16 bits are in D, and the low bit of -6,u is bit 16.
* Bits 1..7 of -6,u are ignored.
	clra			
	clrb
	clr	,-s		-6,u

div3216_loop
	lsl	3,x		shift dividend left
	rol	2,x
	rol	1,x
	rol	,x		MSB of dividend now in carry
	rolb
	rola
	rol	-6,u		17th bit of accumulator
	bsr	div3216_tryfit	does divisor fit into accumulator?
	blo	div3216_nofit	if not

	bsr	div3216_sub	substract divisor from accumulator
	orcc	#1		set carry
	bra	div3216_rolq

div3216_nofit
	andcc	#$fe		reset carry

div3216_rolq
	rol	-1,u		shift carry into quotient
	rol	-2,u
	rol	-3,u
	rol	-4,u

	dec	-5,u		dec loop counter
	bne	div3216_loop

* Copy quotient into dividend space.
	ldd	-4,u
	std	,x
	ldd	-2,u
	std	2,x

div3216_900
	tfr	u,s
	puls	u,pc

* Determines if divisor fits into accumulator.
* Input:
*   6,u = 16-bit divisor
*   -6,u and D = 17-bit accumulator
* Output:
*   C = 0 iff divisor fits into accumulator.
* Preserves all registers.
div3216_tryfit
	pshs	b
	ldb	-6,u		bit 16 of acc
	andb	#1
	bne	@fit		bit 16 high, so acc > divisor
	puls	b
* Acc is just D, so compare directly with divisor.
	cmpd	6,u
	rts
@fit
	andcc	#0		return C = 0
	puls	b,pc

* Subtracts divisor from accumulator.
* Assumes result NOT negative.
* Same interface as div3216_tryfit.
div3216_sub
	subd	6,u
	bcc	@noBorrow
	dec	-6,u		bit 16, assumed to 1, becomes 0
@noBorrow
	rts




	ENDSECTION
