	SECTION code

shiftByteLeft	EXPORT


* Shifts the 8-bit value on the stack left by
* a number of bits given in D.
* Result left in B.
* CAUTION: Trashes X and pops the 8-bit value off the stack.
*
shiftByteLeft
	addd	#0	any shift to do?
	beq	shiftByteLeft_no_change

	cmpd	#8	shifting all bits out?
	blo	shiftByteLeft_general	if not

* Shifting >= 8 bits out.
	clrb
	bra	shiftByteLeft_end

shiftByteLeft_no_change
	ldb	2,s	return left side of shift operator as is
	bra	shiftByteLeft_end

shiftByteLeft_general
	tfr	b,a	use A for number of bits to shift
	ldb	2,s	get left side of shift operator
shiftByteLeft_loop
	lslb
	deca
	bne	shiftByteLeft_loop
shiftByteLeft_end
	puls	x	pop return value
	leas	1,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
