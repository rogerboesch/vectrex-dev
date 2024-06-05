	SECTION code

initWordFromDWord	EXPORT


; Input: X => destination word; D => source dword.
; Preserves X. Trashes D.
;
initWordFromDWord
	pshs	u
	tfr	d,u
	ldd	2,u		; low word of source dword
	std	,x
	puls	u,pc




	ENDSECTION
