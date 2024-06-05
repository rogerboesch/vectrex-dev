	SECTION code

testAndRemoveSignOnDWord	EXPORT

negateDWord                     IMPORT


; Input: pushed address => dword to test;
;        X => destination to copy absolute value of dword to;
; Output: non-negative dword at X;
;         N is 1 if input dword was negative, 0 otherwise.
; Preserves X. Trashes D.
;
testAndRemoveSignOnDWord
	pshs	u
	ldu	4,s		; address of input dword
	ldd	2,u		; copy input dword to destination
	std	2,x
	ldd	,u
	std	,x
	bpl	@done		; branch if high bit of high word is 0
; Input dword is negative: remove sign of destination dword.
	lbsr	negateDWord
	orcc	#8		; set N = 1
@done
	puls	u,pc



	ENDSECTION
