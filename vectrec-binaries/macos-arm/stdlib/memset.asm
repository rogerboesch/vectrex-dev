	SECTION code

_memset	EXPORT


* void *memset(void *s, int c, size_t n)
*
_memset	pshs	u
	tfr	s,u
	leas	-2,s		end address

	ldd	4,u		start address (s)
	tfr	d,x
	addd	8,u		add number of bytes (n) to get end address
	std	-2,u		store in local var

	lda	7,u		byte to write (c)
	bra	_memset_cond
_memset_loop
	sta	,x+
_memset_cond
	cmpx	-2,u		at end?
	bne	_memset_loop	no, continue

	ldd	4,u		return start address
	tfr	u,s
	puls	u,pc




	ENDSECTION
