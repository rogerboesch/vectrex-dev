	INCLUDE std.inc

	SECTION code

INILIB			EXPORT
_exit			EXPORT
INISTK                  EXPORT
CHROUT                  EXPORT
null_ptr_handler        EXPORT

        IFNDEF OS9
end_of_sbrk_mem         EXPORT
program_break           EXPORT
stack_overflow_handler  EXPORT
        ENDC

INITGL			IMPORT
program_end		IMPORT



; Initializes the standard library.
; Input: D = minus the number of bytes for the stack space (e.g., -1024 for 1k stack).
;        Not used under OS-9.
; Initializes the "bss" section with zeroes, under non OS-9 platforms.
; Saves the initial stack for use by exit().
; Initializes internal variables used by sbrk(), except under OS-9.
; Initializes the null pointer handler pointer.
; Initializes the stack overflow handler pointer, except under OS-9.
; Initializes CHROUT, which points to the system's character output routine.
; Initializes the user program's global variables.
;
INILIB

	IFNDEF OS9
; Zero out BSS segment (for OS-9, done by OS9PREP).
; Must be done first, because code that follows initializes INISTK, etc.
l_bss   IMPORT
s_bss   IMPORT
        LDX     #l_bss                  ; number of bytes in "bss" section
        BEQ     @done
        LEAU    s_bss,pcr               ; address of "bss" section
@loop
        CLR     ,U+
        LEAX    -1,X
        BNE     @loop
@done
        ENDC

        IFDEF OS9
	LEAX	6,S			X = initial stack pointer (OS-9 has argc and argv in stack)
        ELSE
	LEAX	2,S			X = initial stack pointer
        ENDC
	STX	INISTK,pcr		save this for exit()

        IFNDEF OS9
	LEAX	D,X			point to top of stack space
	STX	end_of_sbrk_mem,pcr	sbrk() will not allocate past this
	LEAX	program_end,PCR		end of generated code and data
	STX	program_break,pcr	initial Unix-like "program break" (cf sbrk)
        ENDC

	LEAX	nop_handler,PCR
	STX	null_ptr_handler,pcr

	IFNDEF OS9
        LDX	#0
	STX	stack_overflow_handler,pcr	
        ENDC

	IFDEF _COCO_OR_DRAGON_BASIC_
	LDX	$A002			; system's current address for PUTCHR
	ELSE
	LEAX	PUTCHR,PCR
	ENDC
	STX	CHROUT,pcr

	LBSR	INITGL		initialize global variables
        LBRA    constructors

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        IFDEF OS9

OS9PREP     EXPORT

; Input: U => data segment.
;        Y => address of top of data memory.
;        X => command line (ends with $0D).
; Output: U and Y exchanged.
;         Fills argv[] (defined in argv.asm).
;         Stores NULs in the command line after each argument.
;         X => argv[].
;         D = number of arguments (maxed at maxargc).
; Trashes U.
;
OS9PREP

stacksiz    EXPORT
_stkchec    EXPORT
_stkcheck   EXPORT
freemem     EXPORT

program_start IMPORT

s_rwdata    IMPORT
l_rwdata    IMPORT
s_rodata    IMPORT
l_rodata    IMPORT
s_bss       IMPORT
l_bss       IMPORT

s_initgl_end IMPORT
l_initgl_end IMPORT
s_rwdata    IMPORT

        exg     u,y                 ; CMOC wants Y to point to data segment
        pshs    u,y,x

; Clear first 256 bytes (Direct Page)
;        clra                        ; setup to clear
;        clrb                        ; 256 bytes
;dpclrl  sta     ,u+                 ; clear dp bytes
;        decb
;        bne     dpclrl

; Copy the initialized data, if any, to the data segment at Y.
        leau    ,y                  ; destination: data segment
        clr     ,u+                 ; reserve 1st byte so that (void *) serves as invalid ptr
        ldy     #l_rwdata           ; length to copy
        beq     @done               ; if table empty
        leax    s_rodata+l_rodata,PCR   ; 1st (writable) data address to copy
@loop
        ldb     ,x+
        stb     ,u+
        leay    -1,y
        bne     @loop
@done

; Zero out the uninitialized data area (at U, right after initialized data).
        ldx     #l_bss              ; length to write
        beq     @done
@zero
        clr     ,u+
        leax    -1,x
        bne     @zero
@done

        bsr     _fixtop             ; U contains equivalent to rlink's "end"

        puls    x,y,u
        stu     __memend,y
        
; FALLTHROUGH

; Command-line argument parsing.
; OS-9 provides the address of the command line in X.
; That line ends with a $0D character. NULs get poked in it by this routine.
; Global 'argv' is used, so this must be done after OS9PREP.
;
; Parses up to 'maxargc' arguments on the command line at X.
; Any arguments beyond 'maxargc' are unreachable from argv[].
;
; Input: X => command line (ends with $0D).
; Output: Fills argv[] (defined in argv.asm).
;         Stores NULs in the command line after each argument.
;         X => argv[].
;         D = number of arguments (maxed at maxargc).
; Preserves Y. Trashes U.
;
parseCmdLine
        LEAU    argv,Y              ; start of pointer array
        CLRA
        CLRB                        ; arg counter
        STD     ,U++                ; null pointer for argv[0] (program name)
        INCB                        ; count this as 1st arg
@findArgStart
        LDA     ,X+
        BSR     isArgEndingChar
        BEQ     @findArgStart
        CMPA    #$0D
        BEQ     @eol
; Found an argument starting at X-1.
        LEAX    -1,X
        STX     ,U++
        LEAX    1,X
        INCB                        ; count the argument
@findArgEnd
        LDA     ,X+
        BSR     isArgEndingChar
        BEQ     @foundArgEnd
        CMPA    #$0D
        BNE     @findArgEnd
@foundArgEnd
        CLR     -1,X                ; replace space/tab w/ NUL to turn arg into C string
        CMPB    #maxargc            ; reached max?
        BHS     @eol                ; if yes
        CMPA    #$0D
        BNE     @findArgStart
@eol
        CLR     ,U+                 ; add NULL to mark end of pointer array
        CLR     ,U+
        LEAX    argv,Y
        CLRA
        RTS

isArgEndingChar
        CMPA    #' '
        BEQ     @done
        CMPA    #$09
@done
        RTS

_fixtop
;        leax    end,y               ; get the initial memory end address
        stu     __mtop,y             ; it's the current memory top
        sts     __sttop,y            ; this is really two bytes short!
        sts     __stbot,y
        bsr     _stkcheck            ; give ourselves some breathing space
        fdb     -126                 ; argument for _stkcheck
        rts


; The word following the call to this routine must hold the negative
; of a stack reservation request.
; Example call to check for 42 bytes:
;       LBSR    _stkcheck
;       FDB     -42
; Preserves registers except CC.
; Does not return upon a failed check.
;
_stkchec:
_stkcheck:
        pshs    x,b,a               ; preserve caller's registers
        ldx     4,s                 ; get return address
        ldd     ,x                  ; get negative stack reservation word
        leax    2,x                 ; point after reservation word
        stx     4,s                 ; change return address
;
        leax    d,s                 ; calculate the requested size
        cmpx    __stbot,y            ; is it lower than already reserved?
        bhs     stk10               ; no - return
        cmpx    __mtop,y             ; yes - is it lower than possible?
        blo     fsterr              ; yes - can't cope
        stx     __stbot,y            ; no - reserve it
stk10   puls    a,b,x,pc            ; restore caller's registers, return to after reservation word


fixserr fcc     /**** STACK OVERFLOW ****/
        fcb     13

fsterr  leax    <fixserr,pcr        ; address of error string
E$MemFul equ    $CF
        ldb     #E$MemFul           ; MEMORY FULL error number

erexit  pshs    b                   ; stack the error number
        lda     #2                  ; standard error output
        ldy     #100                ; more than necessary
        os9     I$WritLn           ; write it
        clr     ,-s                 ; clear MSB of status
        lbsr    _exit               ; and out
; no return here

; stacksize()
; returns the extent of stack requested
; can be used by programmer for guidance
; in sizing memory at compile time
stacksiz:
        ldd     __sttop,y            ; top of stack on entry
        subd    __stbot,y            ; subtract current reserved limit
        rts

; freemem()
; returns the current size of the free memory area
freemem:
        ldd     __stbot,y
        subd    __mtop,y
        rts

        ENDC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

* void exit(int exitStatus);
*
* Clean up before returning control to the host environment.
* That environment does not necessarily use the exit status.
* It may only use the low byte.
*
* MUST be called by BSR, LBSR or JSR, not jumped to with BRA, LBRA or JMP,
* so that 2,S can be used to get 'exitStatus'.
*
_exit

	LBSR	destructors

	IFDEF _COCO_OR_DRAGON_BASIC_

* Zero out the LINBUF line buffer.  This seems necessary to avoid
* ?SN ERROR after program execution on the CoCo.
	LDX	#LINBUF
EXIT10	CLR	,X+
	CMPX	#LINBUF+1+LBUFMX
	BLO	EXIT10

        LDD     2,S             get exit() arg (may be main() return value)
	LDS	INISTK,pcr	retrieve stack pointer saved at beginning
; Fall through to the RTS at nop_handler.

	ENDC

	IFDEF OS9

	ldb     3,s             get LSB of exit() argument
	os9	F$Exit

	ENDC

	IFDEF USIM

	SYNC			to leave usim

	ENDC

	IFDEF VECTREX

	BRA	_exit	The eternal Vectrex loop on exit...

	ENDC

nop_handler:
	RTS


	ENDSECTION


	SECTION bss

INISTK		RMB	2		receives initial stack pointer

; Initialized by INILIB to an RTS routine.
; Call set_null_ptr_handler() to specify another handler.
; The handler is assumed to have this signature:
; void handler(char *addressOfFailedCheck);
;
null_ptr_handler	RMB	2

        IFNDEF OS9

; Initialized by INILIB to a null pointer.
; Call set_stack_overflow_handler() to specify another handler.
; The handler is assumed to have this signature:
; void handler(char *addressOfFailedCheck, char *stackRegister);
;
stack_overflow_handler	RMB	2


end_of_sbrk_mem	RMB	2
program_break	RMB	2

        ENDC

CHROUT  RMB     2       Routine to write char to current device

        IFDEF OS9

_errno   EXPORT
__memend EXPORT
__mtop   EXPORT
__sttop  EXPORT
__stbot  EXPORT
argv     EXPORT

_errno   RMB     2
__memend RMB     2
__mtop   RMB     2
__sttop  RMB     2
__stbot  RMB     2
argv     RMB     maxargc*2+2     ; one more entry for terminating NULL

        ENDC

	ENDSECTION


        SECTION code

        IFNDEF _COCO_OR_DRAGON_BASIC_
PUTCHR  EXPORT
        ENDC


	IFDEF USIM

* Code to be used with the version of usim that comes with CMOC.
*
PUTCHR	STA	$FF00
	RTS

        ENDC


        IFDEF OS9

* NOTE: This is inefficient for a string: have printf accumulate, then send a string.
PUTCHR	pshs	u,y,x,a
	leax	,s		point to char pushed in stack
	ldy	#1		1 char to print
	lda	#1		write to stdout
	os9	I$WritLn
	puls	a,x,y,u,pc

        ENDC


        IFDEF VECTREX

PUTCHR
	RTS

        ENDC


        ENDSECTION


* This section will precede the "constructors" section, i.e., all code that initializes
* user libraries. Such code must not end with an RTS instruction.
* This section exists to define the address of the pre-main constructor subroutine.
        SECTION constructors_start
constructors
        ENDSECTION

# This section will follow the "constructors" section. It ends the pre_main_init routine.
        SECTION constructors_end
        RTS
        ENDSECTION


* Similarly for destructor code.
        SECTION destructors_start
destructors
        ENDSECTION

        SECTION destructors_end
        RTS
        ENDSECTION
