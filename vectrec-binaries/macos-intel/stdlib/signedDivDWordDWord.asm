	SECTION code

signedDivOrModOnDWord	EXPORT

DIV32                           IMPORT
negateDWord                     IMPORT
testAndRemoveSignOnDWord        IMPORT
testAndRemoveSignOnWord         IMPORT
copyDWord                       IMPORT
copyWordToDWord                 IMPORT
signExtWordToDWord              IMPORT



; Input: bit 3 of B: sign to give to the quotient.
;        X => 2 unsigned dwords (dividend, divisor).
; Output: quotient written in place of dividend; remainder in place of divisor
; Preserves B. Trashes A and X.
; 
signedDivDWordDWord
	pshs	u,y,b
	leas	-8,s		; result of DIV32

	leau	4,x		; point to divisor
	leay	,s		; point to result dwords
	lbsr	DIV32

	ldd	,y		; copy quotient over dividend
	std	,x
	ldd	2,y
	std	2,x
	ldd	4,y		; copy remainder over divisor
	std	4,x
	ldd	6,y
	std	6,x

	ldb	8,s		; look at input B: is quotient negative?
	bitb	#8		; N flag
	beq	@notNeg		; branche if quotient non-negative
	lbsr	negateDWord	; negative quotient (at X)
@notNeg
	leas	8,s
	puls	b,y,u,pc

; Input: push word: address of source dword;
;        X => address of destination dword;
;        bit 3 or B: sign to give to the destination dword.
; Preserves X.
;
copyModuloDWord
	pshs	u,b
	ldu	5,s		; address of source dword
	ldd	,u
	std	,x
	ldd	2,u
	std	2,x
	ldb	,s		; check N in flags received in B
	bitb	#8
	beq	@done
	lbsr	negateDWord
@done
	puls	b,u,pc


; Output: X => destination dword; B = flag byte.
; Trashes D.
;
signedDivOrModOnDWord
	pshs	u
	leau	,s
	leas	-10,s
	pshs	b
; Arguments:
; 4,U: address of destination dword.
; 6,U: dividend (address if dword; word value if short integral).
; 8,U: divisor (address if dword; word value if short integral).
; Locals:
; -4,U: 2nd temp dword (divisor as dword)
; -8,U: 1st temp dword (dividend as dword)
; -9,U: CC of divisor.
; -10,U: CC of dividend.
; -11,U: flag byte received from caller in B:
;            bit 0 ($01): operation flag (0 = modulo, 1 = division)
;            bit 1 ($02): quotient signedness flag (0 = unsigned, 1 = signed)
;            bit 2 ($04): dividend size flag (0 = word, 1 = dword)
;            bit 3 ($08): dividend signedness flag
;            bit 4 ($10): divisor size flag
;            bit 5 ($20): divisor signedness flag
;
; Convert divisor to non-negative.
	
	ldx	8,u	; divisor
	pshs	x	; pass to utility routine
	leax	-4,u	; 2nd temp word
	ldb	-11,u	; flag byte
	andb	#$22	; divisor and quotient signedness flags
	cmpb	#$22
	bne	@noSignToRemoveOnDivisor
; Remove sign on divisor.
	ldb	-11,u		; flag byte
	bitb	#$10		; is divisor word or dword?
	beq	@wordDivisor_0
	lbsr	testAndRemoveSignOnDWord
	bra	@divisorSignRemoved
@wordDivisor_0
	lbsr	testAndRemoveSignOnWord
@divisorSignRemoved
	tfr	cc,b		; preserve N flag for divisor
	stb	-9,u
	bra	@divisorNowDWord
;
@noSignToRemoveOnDivisor
; Copy divisor to 2nd temp dword.
	ldb	-11,u		; flag byte
	bitb	#$10		; is divisor word or dword?
	beq	@wordDivisor_1
        ldd     ,s              ; address of word to copy
	lbsr	copyDWord
	bra	@nullN
@wordDivisor_1
	bitb	#$20		; divisor signedness
	beq	@unsignedWordDivisor
	lbsr	signExtWordToDWord
	bra	@nullN
@unsignedWordDivisor
	lbsr	copyWordToDWord
@nullN
	clr	-9,u		; null N flag for divisor
;
@divisorNowDWord
	leas	2,s		; discard arg of utility routine
;
; Convert dividend to non-negative.
	ldx	6,u	; dividend
	pshs	x	; pass to utility routine
	leax	-8,u	; 1st temp dword
	ldb	-11,u	; flag byte
	andb	#$0A	; dividend and quotient signedness
	cmpb	#$0A
	bne	@noSignToRemoveOnDividend
; Remove sign on dividend.
	ldb	-11,u	; flag byte
	bitb	#$04	; is dividend word or dword?
	beq	@wordDividend_0
	lbsr	testAndRemoveSignOnDWord
	bra	@dividendSignRemoved
@wordDividend_0
	lbsr	testAndRemoveSignOnWord
@dividendSignRemoved
	bra	@dividendNowDWord
;
@noSignToRemoveOnDividend
; Copy dividend to 1st temp dword.
	ldb	-11,u	; flag byte
	bitb	#$04	; is dividend word or dword?
	beq	@wordDividend_1
        ldd     ,s             ; address of word to copy
	lbsr	copyDWord
	bra	@andcc
@wordDividend_1
	bitb	#$08	; dividend signedness
	beq	@unsignedWordDividend
	lbsr	signExtWordToDWord
	bra	@andcc
@unsignedWordDividend
	lbsr	copyWordToDWord
@andcc
	andcc	#$F7		; null N flag for dividend
;
@dividendNowDWord
	leas	2,s		; discard arg of utility routine
;
; Here, the N flag represents the sign of the left side.
; Call the division routine.
	tfr	cc,b		; N flag in B
	stb	-10,u		; preserve sign of dividend
	eorb	-9,u		; XOR with sign of divisor
	leax	-8,u		; point to the 2 temp dwords
	lbsr	signedDivDWordDWord
;
; Resulting dword is one of temp dwords, depending on operation.
;
	leax	-8,u		; 1st temp dword (contains quotient)
	ldb	-11,u	; flag byte
	bitb	#$01		; operation
	bne	@division_0
	leax	4,x		; 2nd temp dword (contains modulo)
@division_0
	pshs	x		; address to dword to copy
	ldx	4,u		; address of destination dword
	bitb	#$01		; operation
	bne	@division_1
	ldb	-10,u		; sign of dividend
	lbsr	copyModuloDWord	; preserves X
	bra	@done
@division_1
        ldd     ,s              ; address of word to copy
	lbsr	copyDWord	; preserves X
@done
	leas	,u		; discards arg pushed to copy*DWord
	puls	u,pc




	ENDSECTION
