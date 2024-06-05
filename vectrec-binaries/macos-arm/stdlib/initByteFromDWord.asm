	SECTION code

initByteFromDWord	EXPORT


; Input: X => destination byte; D => source dword.
; Preserves X. Trashes D.
;
initByteFromDWord
	pshs	u
	tfr	d,u
	ldb	3,u		; low byte of source dword
	stb	,x
	puls	u,pc




	ENDSECTION
