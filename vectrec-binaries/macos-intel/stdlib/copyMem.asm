	SECTION code

copyMem	EXPORT


; Like memcpy, but with only one argument passed on the stack.
; Input: X => Destination address.
;        D => Number of bytes to copy.
;        Pushed argument => Source address.
; Does not return anything.
; Does not preserve X or D.
; Preserves U and Y.
;
copyMem
	pshs	u		preserve frame pointer
	ldu	4,s		source address
	leau	d,u		end of source region
	pshs	u		store for loop condition
	ldu	6,s		source address
	bra	@cond
@loop
	lda	,u+
	sta	,x+
@cond
	cmpu	,s		compare with end address
	bne	@loop

	puls	x,u,pc		pull end address in X instead of leas 2,s




	ENDSECTION
