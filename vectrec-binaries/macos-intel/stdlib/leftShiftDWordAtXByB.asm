	SECTION code

leftShiftDWordAtXByB	EXPORT


; Input: Z must reflect B.
; Preserves X. Trashes D.
;
leftShiftDWordAtXByB
	beq	@done
	cmpb	#8	; at least 8 bits to shift?
	blo	@bitLoop
@byteLoop
	lda	1,x
	sta	,x
	lda	2,x
	sta	1,x
	lda	3,x
	sta	2,x
	clr	3,x
	subb	#8
	beq	@done
	cmpb	#8
	bhs	@byteLoop
@bitLoop
	lsl	3,x
	rol	2,x
	rol	1,x
	rol	,x
	decb
	bne	@bitLoop
@done
	rts




	ENDSECTION
