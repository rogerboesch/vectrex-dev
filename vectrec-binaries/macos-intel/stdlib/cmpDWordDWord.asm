	SECTION code

cmpDWordDWord	EXPORT


; Input: Stacked arguments: address of left dword, address of right dword.
; Output: Sets N, Z, V, C.
; Preserves X, Y, U. Trashes D.
;
cmpDWordDWord
	pshs	u,x
	ldx	6,s		; left long
	ldu	8,s		; right long
	leas	-5,s		; locals
; ,s (4 bytes): temp long
; 4,s: temp flags
;
	bsr	sub32Stack	; *X - *U in ,s; sets N, V, C
	tfr	cc,b
	andb	#$FB		; reset Z (Z to be computed separatedly)
	stb	4,s		; preserve CC from sub32Stack

	bsr	isLongZeroStack	; checks 4 bytes at ,s
	tfr	cc,a
	anda	#4		; keep only Z
	ora	4,s		; add flags from CC obtained from sub32Stack

	tfr	a,cc
	leas	5,s
	puls	x,u,pc

; Pushed long receives *X - *U (unsigned).
; Sets N, V, C. Trashes D.
;
sub32Stack
	ldd	2,x
	subd	2,u
	std	4,s	; low word of result
	ldd	,x	
	sbcb	1,u
	sbca	,u
	pshs	cc	; preserve flags to be returned
	std	3,s	; high word of result
	puls	cc,pc

; Checks if pushed long is zero. Sets Z flag.
; Preserves registers.
;
isLongZeroStack
	tst	2,s
	bne	@done
	tst	3,s
	bne	@done
	tst	4,s
	bne	@done
	tst	5,s
@done	rts




	ENDSECTION
