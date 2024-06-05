	SECTION code

cmpDWordSignedInt	EXPORT

cmpDWordDWord           IMPORT


; Input: 2 pushed arguments.
; Preserves X and U. Trashes D.
;
cmpDWordSignedInt
	pshs	u,x
	ldx	6,s		; address of dword
	ldd	8,s		; signed int
	pshs	b,a		; create temp dword in stack
	tfr	a,b
	sex			; sign extend int into A
	pshs	a
	pshs	a		; pushed dword version of int
	leau	,s		; point to dword (right side)
	pshs	u,x
	lbsr	cmpDWordDWord
	leas	8,s		; clean up pushed U and X, and temp long
	puls	x,u,pc




	ENDSECTION
