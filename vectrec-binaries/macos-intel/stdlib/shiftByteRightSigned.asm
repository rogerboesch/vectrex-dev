	SECTION code

shiftByteRightSigned	EXPORT


* Shifts the 8-bit signed value on the stack right
* by a number of bits given in D.
* Result left in B.
* CAUTION: Trashes X and pops the 8-bit value off the stack.
*
shiftByteRightSigned
	addd	#0	any shift to do?
	beq	shiftByteRightSigned_no_change

	cmpd	#7	shifting all mantissa bits out?
	blo	shiftByteRightSigned_general	if not

* Shifting >= 7 bits out.
	ldb	2,s	left side of shift operator
	sex		repeat bit 7 of B eight times in A
	tfr	a,b	B = $FF if original D < 0; B = 0 otherwise
	bra	shiftByteRightSigned_end

shiftByteRightSigned_no_change
	ldb	2,s	return left side of shift operator as is
	bra	shiftByteRightSigned_end

shiftByteRightSigned_general
	tfr	b,a	use A for number of bits to shift
	ldb	2,s	get right side of shift operator
shiftByteRightSigned_loop
	asrb
	deca
	bne	shiftByteRightSigned_loop
shiftByteRightSigned_end
	puls	x	pop return value
	leas	1,s	pop left side
	tfr	x,pc	return from routine (with result in D)




	ENDSECTION
