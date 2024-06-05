	SECTION code

_setConsoleOutHook	EXPORT

CHROUT                  IMPORT


* void *setConsoleOutHook(void *routine)
*
_setConsoleOutHook
	ldd	CHROUT,pcr	; to be returned
	ldx	2,s        	; 1st argument: 'routine'
	stx	CHROUT,pcr
	rts




	ENDSECTION
