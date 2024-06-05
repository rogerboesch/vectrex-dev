	SECTION code

_readword	EXPORT

ATOW            IMPORT
_readline       IMPORT


* unsigned readword();
* Read an unsigned decimal 16-bit integer from the user.  Return result in D.
_readword
	LBSR	_readline
	TFR	D,X		pass string address in X
	LBRA	ATOW


_

	ENDSECTION
