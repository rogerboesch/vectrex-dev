	SECTION code

shiftRightSigned	EXPORT


* Shifts the 16-bit signed value on the stack right
* by a number of bits given in D.
* Result left in D.
* CAUTION: Trashes X and pops the 16-bit value off the stack.
*
shiftRightSigned
	addd	#0	any shift to do?
	beq	shiftRightSigned_no_change

	cmpd	#15	shifting all mantissa bits out?
	blo	shiftRightSigned_general	if not

* Shifting >= 15 bits out.
	ldd	2,s	left side of shift operator
	tfr	a,b	sign bit of D into bit 7 of B
	sex		repeat bit 7 of B eight times in A
	tfr	a,b	D = $FFFF if original D < 0; D = 0 otherwise
	bra	shiftRightSigned_end

shiftRightSigned_no_change
	ldd	2,s	return left side of shift operator as is
	bra	shiftRightSigned_end

shiftRightSigned_general
	pshs	b	save number of bits to shift
	ldd	3,s	get right side of shift operator
shiftRightSigned_loop
	asra
	rorb
	dec	,s
	bne	shiftRightSigned_loop
	leas	1,s	discard counter
shiftRightSigned_end
	puls	x	pop return value
	leas	2,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
