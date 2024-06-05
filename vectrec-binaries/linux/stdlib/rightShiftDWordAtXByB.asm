	SECTION code

rightShiftDWordAtXByB	EXPORT


; Input: A: 0 = zero-extend, $FF = sign-extend;
;        B: number of bits to shift;
;        X => dword to shift (in place).
; Preserves X. Trashes D.
;
rightShiftDWordAtXByB
	pshs	a
	tstb
	beq	@done
	cmpb	#8	; at least 8 bits to shift?
	blo	@bitLoop
@byteLoop
	lda	2,x
	sta	3,x
	lda	1,x
	sta	2,x
	lda	,x
	sta	1,x
	bmi	@useExtByte	; if high bit of dword is 1
	clra
	bra	@storeExtByte
@useExtByte
	lda	,s		; zero/sign extension byte
@storeExtByte
	sta	,x
	subb	#8
	beq	@done
	cmpb	#8
	bhs	@byteLoop
@bitLoop
	tst	,s		; zero or sign extension?
	beq	@zeroExtBitLoop
@signExtBitLoop
	asr	,x
	ror	1,x
	ror	2,x
	ror	3,x
	decb
	bne	@signExtBitLoop
	bra	@done
@zeroExtBitLoop
	lsr	,x
	ror	1,x
	ror	2,x
	ror	3,x
	decb
	bne	@zeroExtBitLoop
@done
	puls	a,pc




	ENDSECTION
