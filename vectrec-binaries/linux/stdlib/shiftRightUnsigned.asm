	SECTION code

shiftRightUnsigned	EXPORT


* Shifts the 16-bit unsigned value on the stack right
* by a number of bits given in D.
* Result left in D.
* CAUTION: Trashes X and pops the 16-bit value off the stack.
*
shiftRightUnsigned
	addd	#0	any shift to do?
	beq	shiftRightUnsigned_no_change

	cmpd	#16	shifting all bits out?
	blo	shiftRightUnsigned_general	if not

* Shifting >= 16 bits out.
	clra
	clrb
	bra	shiftRightUnsigned_end

shiftRightUnsigned_no_change
	ldd	2,s	return left side of shift operator as is
	bra	shiftRightUnsigned_end

shiftRightUnsigned_general
	pshs	b	save number of bits to shift
	ldd	3,s	get left side of shift operator
shiftRightUnsigned_loop
	lsra
	rorb
	dec	,s
	bne	shiftRightUnsigned_loop
	leas	1,s	discard counter
shiftRightUnsigned_end
	puls	x	pop return value
	leas	2,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
