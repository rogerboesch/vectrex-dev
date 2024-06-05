	SECTION code

shiftLeft	EXPORT


* Shifts the 16-bit value on the stack left by
* a number of bits given in D.
* Result left in D.
* CAUTION: Trashes X and pops the 16-bit value off the stack.
*
shiftLeft
	addd	#0	any shift to do?
	beq	shiftLeft_no_change

	cmpd	#16	shifting all bits out?
	blo	shiftLeft_general	if not

* Shifting >= 16 bits out.
	clra
	clrb
	bra	shiftLeft_end

shiftLeft_no_change
	ldd	2,s	return left side of shift operator as is
	bra	shiftLeft_end

shiftLeft_general
	pshs	b	save number of bits to shift
	ldd	3,s	get left side of shift operator
shiftLeft_loop
	lslb
	rola
	dec	,s
	bne	shiftLeft_loop
	leas	1,s	discard counter
shiftLeft_end
	puls	x	pop return value
	leas	2,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
