	SECTION code

shiftByteRightUnsigned	EXPORT


* Shifts the 8-bit unsigned value on the stack right
* by a number of bits given in D.
* Result left in B.
* CAUTION: Trashes X and pops the 8-bit value off the stack.
*
shiftByteRightUnsigned
	addd	#0	any shift to do?
	beq	shiftByteRightUnsigned_no_change

	cmpd	#16	shifting all bits out?
	blo	shiftByteRightUnsigned_general	if not

* Shifting >= 16 bits out.
	clrb
	bra	shiftByteRightUnsigned_end

shiftByteRightUnsigned_no_change
	ldb	2,s	return left side of shift operator as is
	bra	shiftByteRightUnsigned_end

shiftByteRightUnsigned_general
	tfr	b,a	use A for number of bits to shift
	ldb	2,s	get left side of shift operator
shiftByteRightUnsigned_loop
	lsrb
	deca
	bne	shiftByteRightUnsigned_loop
shiftByteRightUnsigned_end
	puls	x	pop return value
	leas	1,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
