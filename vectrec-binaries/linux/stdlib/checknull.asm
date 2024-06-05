	SECTION code

_set_null_ptr_handler	EXPORT
check_null_ptr_x	EXPORT

null_ptr_handler	IMPORT


* void set_null_ptr_handler(char *newHandler);
*
_set_null_ptr_handler:
	LDD	2,S	first argument
	STD	null_ptr_handler,pcr
check_null_ptr_x_end:
	RTS


* Checks if the pointer in X in null and if it is, invokes
* the handler in null_ptr_handler.
* 
check_null_ptr_x:
	CMPX	#0
	BNE	check_null_ptr_x_end
	PSHS	U,Y,X,B,A
	LDD	8,S	return address of LBSR that led to this routine
	SUBD	#3	point to LBSR instruction
	PSHS	B,A
	JSR	[null_ptr_handler,pcr]
	LEAS	2,S
	PULS	A,B,X,Y,U,PC


	ENDSECTION
