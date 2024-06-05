	SECTION code

sub32xu	EXPORT


* Subtract 32-bit unsigned integer from another.
* In: X => first integer, U => second integer.
* Out: first minus second in space pointed by X,
*      carry bit reflects subtraction.
* Preserves: all, except CC
*
sub32xu	pshs	b,a

	ldd	2,x		low word of first
	subd	2,u		low word of second
	std	2,x		store in low word of first

	ldd	,x		high word of first
	sbcb	1,u
	sbca	,u
	std	,x

	puls	a,b,pc		carry bit from last sub returned




	ENDSECTION
