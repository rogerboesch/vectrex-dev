		SECTION code

_strcmp		EXPORT

strcmpimpl	IMPORT


* int strcmp(char *, char *);
*
_strcmp
        leax	noTransform,pcr
		lbra	strcmpimpl

noTransform
		rts


		ENDSECTION
