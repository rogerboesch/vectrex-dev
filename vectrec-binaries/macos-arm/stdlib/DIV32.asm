	SECTION code

DIV32	EXPORT

cmpDWordDWord   IMPORT
sub32xu         IMPORT


; Divides the unsigned long at X by the one at U.
; Stores the quotient in the unsigned long at Y
; and the remainder in the unsigned long at 4,Y.
; The 8 bytes at Y must not overlap the dividend or divisor.
; Synopsis:
;	pshs	y
; 	leax	dividend,pcr
;	leau	divisor,pcr
;	leay	eightByteBuffer,pcr
;	lbsr	DIV32
;	puls	y
; Preserves the divisor, X, Y, U. Trashes the dividend and D.
;
DIV32
	ldb	#32
	pshs	b
; 0,s: loop counter.
	clra
	clrb
	std	,y		; clear quotient
	std	2,y
	std	4,y		; clear accumulator (finishes as the remainder)
	std	6,y
@loop	lsl	3,x		; shift high bit of dividend into carry
	rol	2,x
	rol	1,x
	rol	,x
	rol	7,y		; shift that bit into bit 0 of acc
	rol	6,y
	rol	5,y
	rol	4,y
	bsr	@doesDivisorFitAcc
	blo	@noFit		; if not
	bsr	@subDivisorFromAcc
	orcc	#1		; set carry
	bra	@carryToQuotient
@noFit
	andcc	#$FE		; reset carry
@carryToQuotient
	rol	3,y		; shift carry into quotient
	rol	2,y
	rol	1,y
	rol	,y
	dec	,s		; another bit of the dividend to process?
	bne	@loop		; if yes
	puls	b,pc
;
; Input: U => divisor, 4,Y => accumulator.
; Output: C=1 if accumulator < divisor, C=0 otherwise (i.e., divisor goes into acc).
;
@doesDivisorFitAcc
	pshs	x		; preserve X
	leax	4,y
	pshs	u,x
	lbsr	cmpDWordDWord	; sets C
	leas	4,s
	puls	x,pc
;
; Input: U => divisor, 4,Y => accumulator.
;
@subDivisorFromAcc
	pshs	x		; preserve X
	leax	4,y
	lbsr	sub32xu		; *X -= *U
	puls	x,pc




	ENDSECTION
