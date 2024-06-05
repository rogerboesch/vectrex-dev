	SECTION code

_sbrkmax	EXPORT

	IFNDEF OS9
end_of_sbrk_mem IMPORT
program_break   IMPORT
	ENDC


* size_t sbrkmax();
*
* Returns (in D) the maximum number of bytes that can be successfully
* asked of sbrk().
*
_sbrkmax
	IFNDEF OS9

	ldd	end_of_sbrk_mem,pcr
	subd	program_break,pcr
	bhs     sbrkmax_non_neg
* The program break is after the stack space. Not supported by sbrk().

	ENDC

	clra
	clrb
sbrkmax_non_neg
	rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Support for the "long" type.
;


	ENDSECTION
