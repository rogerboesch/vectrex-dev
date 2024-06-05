	SECTION code

_atoui	EXPORT

ATOW    IMPORT


* unsigned atoui(char *s);
_atoui
        ldx     2,s             argument 's'
        lbra    ATOW




	ENDSECTION
