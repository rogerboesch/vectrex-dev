	SECTION code

_putstr	EXPORT

putchar_a       IMPORT


* void putstr(byte *s, word len)
*
* Sends characters s[0] to s[len - 1] to standard output.
*
_putstr
putstr:
	pshs	u
	ldx	6,s	number of characters to write
	beq	putstr_900
	ldu	4,s	address of string to write
putstr_100:
	lda	,u+
	lbsr    putchar_a
	leax    -1,x
	bne	putstr_100
putstr_900:
	puls    u,pc




	ENDSECTION
