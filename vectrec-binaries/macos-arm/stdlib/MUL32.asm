	SECTION code

MUL32	EXPORT


; Multiplies the two unsigned longs whose addresses are in X (left)
; and U (right). Stores the result in the unsigned long at Y.
; Synopsis:
;	pshs	y
; 	leax	left,pcr
;	leau	right,pcr
;	leay	product,pcr
;	lbsr	MUL32
;	puls	y
; Preserves X, U and Y. Trashes D.
;
MUL32
;
; Let L0,L1,L2,L3 be the 4 bytes of the left operand.
; Let R0,R1,R2,R3 be the 4 bytes of the right operand.
; The product is
;	         L3 * (R0,R1,R2,R3)
;	+ 2^8  * L2 * (R0,R1,R2,R3)
;	+ 2^16 * L1 * (R0,R1,R2,R3)
;	+ 2^24 * L0 * (R0,R1,R2,R3)
; But some parts of this formula overflow the resulting 32-bit word.
; The 32-bit result is
;	         L3 * (R0,R1,R2,R3)
;	+ 2^8  * L2 * (R1,R2,R3)
;	+ 2^16 * L1 * (R2,R3)
;	+ 2^24 * L0 * R3.
; 
; Let P3,P2,P1,P0 be the product to be computed in the result buffer.
;
	lda	3,x		; L3
	ldb	3,u		; R3
	mul
	std	2,y		; store in P2,P3

	lda	3,x		; L3
	ldb	2,u		; R2
	mul
	addb	2,y		; add P2
	adca	#0
	std	1,y		; store in P1,P2

	lda	3,x		; L3
	ldb	1,u		; R1
	mul
	addb	1,y		; add P1
	adca	#0
	std	,y		; store in P0,P1

	lda	3,x		; L3
	ldb	,u		; R0
	mul
	addb	,y		; add P0
	stb	,y		; store in P0

; Done with L3.

	lda	2,x		; L2
	ldb	3,u		; R3
	mul
	addb	2,y		; add P2
	adca	1,y		; add P1
	std	1,y		; store in P1,P2
	ldb	,y		; add carry to P0
	adcb	#0
	stb	,y

	lda	2,x		; L2
	ldb	2,u		; R2
	mul
	addb	1,y		; add P1
	adca	,y		; add P0
	std	,y		; store in P0,P1

	lda	2,x		; L2
	ldb	1,u		; R1
	mul
	addb	,y		; add P0
	stb	,y		; store in P0

; Done with L2.

	lda	1,x		; L1
	ldb	3,u		; R3
	mul
	addb	1,y		; add P1
	adca	,y		; add P0
	std	,y		; store in P0,P1

	lda	1,x		; L1
	ldb	2,u		; R2
	mul
	addb	,y		; add P0
	stb	,y		; store in P0

; Done with L1.

	lda	,x		; L0
	ldb	3,u		; R3
	mul
	addb	,y		; add P0
	stb	,y		; store in P0

; Done with L0.

	rts




	ENDSECTION
