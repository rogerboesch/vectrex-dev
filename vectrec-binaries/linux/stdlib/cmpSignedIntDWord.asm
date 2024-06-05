	SECTION code

cmpSignedIntDWord	EXPORT

cmpDWordDWord           IMPORT


cmpSignedIntDWord
	pshs	u,x
	ldu	8,s		; address of dword
	ldd	6,s		; signed int
	pshs	b,a		; create temp dword in stack
	tfr	a,b
	sex			; sign extend int into A
	pshs	a
	pshs	a		; pushed dword version of int
	leax	,s		; point to dword (left side)
	pshs	u,x
	lbsr	cmpDWordDWord
	leas	8,s		; clean up pushed U and X, and temp long
	puls	x,u,pc




	ENDSECTION
