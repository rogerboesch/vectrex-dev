        INCLUDE std.inc

	SECTION code

_printf	EXPORT

CHROUT          IMPORT
putchar_a       IMPORT
negateDWord     IMPORT
_dwtoa          IMPORT
ATOW            IMPORT
_strlen         IMPORT


* void printf(const char *fmt, ...)
*
* Minimal printf(3) function.
* To redirect the output characters, store a routine pointer in CHROUT.
* That routine must accept the character to print in register A.
*
_printf
	PSHS	U
	LDX	4,S		format string
	LEAU	6,S		variable argument pointer
	LDA	#$20		default padding char
	PSHS	A
	CLR	,-S
	CLR	,-S
* ,S = width parameter (word) (as in "%12u").
* 2,S = current padding char (byte)

PTF010	LDA	,X+		get char from format string
	LBEQ	PTF900
	CMPA	#$25		'%'?
	BEQ	PTF490
PTF020	LBSR    putchar_a	ordinary char: print it
	BRA	PTF010

PTF490				* '%' just seen
	CLR	,S		clear width word
	CLR	1,S
	LDA	#$20
	STA	2,S		reinit padding char

PTF500				* process chars that follow '%'
	LDA	,X+		get char after '%'
	BNE	PTF510
	LDA	#$25		string ends after '%', so print '%'
	JSR	[CHROUT,pcr]
	LBRA	PTF900
PTF510	CMPA	#$75		%u?
	BNE	PTF515
	LDD	,U++		get 16-bit argument
	LBSR	PADWRD		width is in ,S, padding char in 2,S
	LBSR	PRNTWD		print as decimal
	BRA	PTF010
PTF515	CMPA	#$64		%d?
	BNE	PTF520
	LDD	,U		get number to print
	BGE	PTF517
	COMA			negate D
	COMB
	ADDD	#1
	PSHS	B,A
	LDD	2,S		subtract 1 one width, because number to print is < 0
	SUBD	#1
	STD	2,S
	PULS	A,B
PTF517
	LBSR	PADWRD		16-bit width is in ,S, padding char in 2,S

	PSHS	B,A		if number to print < 0, print minus sign
	LDD	,U++		reload number to print, advance arg pointer
	BGE	PTF518
	LDA	#45		minus sign
	JSR	[CHROUT,pcr]
PTF518
	PULS	A,B		restore absolute value of number to print

	LBSR	PRNTWD		print as decimal
	BRA	PTF010
PTF520	CMPA	#$78		%x?
	BNE	PTF525
PTF522	LDD	,U++		get 16-bit argument
	LBSR	PADHEX		16-bit width is in ,S, padding char in 2,S
	LBSR	PRNTWH		print as hex
	BRA	PTF010
PTF525	CMPA	#$58		%X?
	BEQ	PTF522
	CMPA	#$70		%p?
	BNE	PTF530
	LDA	#$24		prefix pointer representation with $
	JSR	[CHROUT,pcr]
	LDD	#4		always 4 hex digits for a pointer
	STD	,S
	LDA	#$30		pad pointer with '0'
	STA	2,S
	BRA	PTF522		do %X

PTF530	CMPA	#$73		%s?
	BNE	PTF540

	LDD	,S		width of the string field
	BLT	PTF532		if post-padding requested (signed branch)

	LDD	,U		get address of string
	LBSR	PADSTR_PRE
PTF532
	LDD	,U		get address of string
	LBSR	PRINTS

	LDD	,S		width of the string field
	BPL	PTF538		if pre-padding requested: it's done, we're finished with %s

	LDD	,U		reload address of string
	LBSR	PADSTR_POST	do post-padding
PTF538
	LEAU	2,U		pass string address argument
	LBRA	PTF010		finished with %s

PTF540	CMPA	#$63		%c?
	BNE	PTF550
        LDD     ,U++            get char in B
	TFR     B,A
	LBSR    putchar_a
	LBRA	PTF010
PTF550	CMPA	#$66		%f?
	BNE	PTF555
	LBSR	printReal
	LEAU	PRINTF_FLOAT_SIZE,U	pass the float
	LBRA	PTF010
PTF555	CMPA	#'l		%lu, %ld or %lx?
	LBNE	PTF559
	LDA	,X+		check letter that follows %l
	CMPA	#'u
	BEQ	@ulong
	CMPA	#'d
	BEQ	@slong
	CMPA	#'x
	LBEQ	@xlong
	CMPA	#'X
	LBEQ	@xlong
	LEAX	-1,X		unknown specifier: tolerate %l as alias for %ld
	CLRA			indicates that no minus sign must be printed
@slong
* If the (big endian) dword at ,U is negative, negate it and
* print a minus sign.
	TST	,U
	BPL	@longNotNeg
	EXG	U,X
	LBSR	negateDWord
	EXG	U,X
	LDA	#'-
@longNotNeg
@ulong
*
* Here, A is '-' iff a minus sign must be printed before the number.
* Also, 16-bit width is in ,S, padding char in 2,S
*
* Call dwtoa().
	PSHS	X,A		X trashed by _dwtoa, A indicates if minus sign needed
	LEAS	-11,S		buffer for dwtoa
	LDD	,U		high word
	LDX	2,U		low word
	PSHS	X,B,A		pushes 4 bytes for _dwtoa
	LEAX	4,S		point to 11-byte buffer
	PSHS	X		pass address to _dwtoa
	LBSR	_dwtoa
	LEAS	6,S		discard arguments
	TFR	D,X		point to first digit to print
* Here, 16-bit width is in 14,S, padding char in 16,S, minus sign indicator in 11,S
*
* Print minus sign BEFORE padding IF padding char is NOT space.
	LDA	16,S		padding char
	CMPA	#$20		is space?
	BEQ	@checkPadding
	LDA	11,S		load minus sign indicator
	CMPA	#'-
	BNE	@checkPadding	no minus sign to print
	JSR	[CHROUT,pcr]	print it
*
@checkPadding
*
	LBSR	@decPadding
*
* Print minus sign AFTER padding IF padding char is space.
	LDA	16,S		padding char
	CMPA	#$20		is space?
	BNE	@printCond
	LDA	11,S		load minus sign indicator
	CMPA	#'-
	BNE	@printCond	no minus sign to print
	JSR	[CHROUT,pcr]	print it
	BRA	@printCond
*
@printLoop
	JSR	[CHROUT,pcr]	print digit in A
@printCond
	LDA	,X+		load digit
	BNE	@printLoop	if not '\0'
	LEAS	11,S		discard buffer
	PULS	A,X		restore X (points into printf format string)
	LEAU	4,U		pass the 32-bit long
	LBRA	PTF010
;
;
; Input: U => dword to be printed in hex.
; Output: D => number of hex digits needed to print dword (1..8).
; Preserves X and U.
;
@countHexDigitsInDWord
	CLRB
@nextDWordByte
	LDA	B,U		get byte from dword
	BNE	@nonNullByte	found 1st non-null byte
	INCB			count another null byte
	CMPB	#4		if reached 4, all bytes null
	BEQ	@oneDigitNeeded
	BRA	@nextDWordByte
@nonNullByte			; B is index (0..3) of 1st non null byte
	LSLB
	NEGB
	ADDB	#8		number of digits needed is B or B-1
	BITA	#$F0		is high nybble null?
	BNE	@highNybbleNotNull
	DECB			one less digit needed
@highNybbleNotNull	
	CLRA
	RTS
@oneDigitNeeded
	LDB	#1		A is already 0
@done
	RTS
;
;
@xlong
; Pad if required.
* Here, 16-bit width is in ,S, padding char in 2,S
	BSR	@countHexDigitsInDWord		uses U; result in D
	SUBD	,S				subtract width
	BHS	@noHexPadding
	PSHS	X
	TFR	D,X				use X as upwards counter
@hexPad
	LDA	4,S				padding char
	JSR	[CHROUT,pcr]
	LEAX	1,X
	BNE	@hexPad
	PULS	X
@noHexPadding
	LDD	,U		high word
	BEQ	@highWordZero   if no digit to print
	LBSR	PRNTWH		print high word
; Print low word, padded with zeroes to a width of 4.
	LDB	#'0		padding char for PADHEX
	PSHS	B
	LDD	#4		print 2nd word as 4 digits
	PSHS	B,A		pass to PADHEX
	LDD	2,U		low word
	LBSR	PADHEX		preserves D and X
	LEAS	3,S
@highWordZero
	LDD	2,U		low word
	LBSR	PRNTWH		print D (low word)
	LEAU	4,U		pass the 32-bit long
	LBRA	PTF010		done with %lx
;
; Input: S (before call) => 11-digit buffer;
;        X => first digit to print in the 11-digit buffer;
;        16-bit width is in 14,S, padding char in 16,S, minus sign indicator in 11,S.
; Preserves X. Trashes D.
;
@decPadding
	PSHS	X
; Here, 16-bit width is in 18,S, padding char in 20,S, minus sign indicator in 15,S.
	TFR	S,D
	ADDD	#2+2+10		addr of NUL-terminating byte of buffer (written by _dwtoa)
	PSHS	X
	SUBD	,S++		D minus addr of 1st digit to print = # of digits to print
	PSHS	A
	LDA	16,S		get minus sign indicator
	CMPA	#'-		minus needed?
	PULS	A
	BNE	@noMinusNeeded
	ADDD	#1		count minus as 1 more char to print
@noMinusNeeded
	SUBD	18,S		compare with width; negative result means padding needed
	BHS	@noPadding	if width matched or exceeded, no padding
	TFR	D,X		use X as upwards counter (must reach up to 0)
@decPadPrint
	LDA	20,S		padding char
	JSR	[CHROUT,pcr]
	LEAX	1,X
	BNE	@decPadPrint
@noPadding
	PULS	X,PC

PTF559	CMPA	#$25		%%?
	BNE	PTF560
	JSR	[CHROUT,pcr]
	LBRA	PTF010
PTF560	CMPA	#45		minus? *** CAUTION: ONLY SUPPORTED FOR STRING PADDING ***
	BNE	PTF562

	LBSR	ATOW		read integer following minus sign into D
	PSHS	B,A		negate D
	CLRA
	CLRB
	SUBD	,S++
	STD	,S		store negative width
	LBRA	PTF500		continue to process the chars following the %

PTF562	CMPA	#$30		width?
	BLO	PTF570
	CMPA	#$39
	BHI	PTF570
	CMPA	#$30		zero?
	BNE	PTF565
	STA	2,S		exception: this zero specifies the padding char
	BRA	PTF567
PTF565	LEAX	-1,X
PTF567	LBSR	ATOW
	STD	,S
	LBRA	PTF500		continue to process the chars following the %
PTF570	EQU	*
PTF800	PSHS	A		unknown code after '%': print '%' then the code
	LDA	#$25
	JSR	[CHROUT,pcr]
	PULS	A
	LBSR    putchar_a
	LBRA	PTF010

PTF900	LEAS	3,S
	PULS	U,PC


* Input: D = word to write in decimal.
PADWRD	PSHS	X,B,A
	LDX	6,S		width of the number
	LEAX	-5,X		assume word in D has 5 decimal digits
	CMPD	#10
	BHS	PWD020
	LEAX	1,X		D < 10, so add one padding char
PWD020	CMPD	#100
	BHS	PWD030
	LEAX	1,X
PWD030	CMPD	#1000
	BHS	PWD040
	LEAX	1,X
PWD040	CMPD	#10000
	BHS	PWD050
	LEAX	1,X

PWD050	CMPX	#0
	BLE	PWD900		no padding if X negative or zero
PWD060	LDA	8,S		get padding char
	JSR	[CHROUT,pcr]
	LEAX	-1,X
	BNE	PWD060

PWD900	CLR	6,S		clear width for next time
	CLR	7,S
	LDA	#$20		restore default padding char for next time
	STA	8,S
	PULS	A,B,X,PC


* Input: D = address of string to write
PADSTR_PRE
	PSHS	X,B,A
	PSHS	B,A		send string address to _strlen
	LBSR	_strlen		get length of string
	STD	,S		reuse arg slot to store length
	LDD	8,S		width of the string field
	SUBD	,S		substract string length; D = number of padding chars
	BLE	PADSTR_900	if nothing to do
PADSTR_050
	TFR	D,X		use X as padding counter
PADSTR_100
	LDA	#32		use space as padding char
	JSR	[CHROUT,pcr]
	LEAX	-1,X
	BNE	PADSTR_100
PADSTR_900
	LEAS	2,S		pop arg slot
	PULS	A,B,X,PC

* Input: D = address of string to write
PADSTR_POST
	PSHS	X,B,A
	PSHS	B,A		send string address to _strlen
	LBSR	_strlen		get length of string
	STD	,S		save length
	CLRA
	CLRB
	SUBD	8,S		negated field width, which is now > 0
	SUBD	,S		subtract number of printed chars
	BLS	PADSTR_900	if nothing to do
	BRA	PADSTR_050	/* reuse previous subroutine's padding loop */


* Input: D = number to write.
*        Before call, ,S must contain 16-bit width in chars
*        and 2,S must contain padding char.
*
PADHEX	PSHS	X,B,A
	LDX	6,S		width of the number
	LEAX	-4,X		assume word in D has 4 hex digits
	CMPD	#$10
	BHS	PHX020
	LEAX	1,X		D < 16, so add one padding char
PHX020	CMPD	#$100
	BHS	PHX030
	LEAX	1,X
PHX030	CMPD	#$1000
	BHS	PHX050
	LEAX	1,X
PHX050	CMPX	#0
	BLE	PHX900		no padding if X negative or zero
PHX060	LDA	8,S		get padding char
	JSR	[CHROUT,pcr]	note that this may trash A
	LEAX	-1,X
	BNE	PHX060

PHX900	CLR	6,S		clear width for next time
	CLR	7,S
	LDA	#$20		restore default padding char for next time
	STA	8,S
	PULS	A,B,X,PC


; Prints D in hex.
; Preserves D and X.
; Uses HEXDIG.
;
PRNTWH	PSHS	X,B,A
	SUBD	#0		handle special case
	BNE	PRWH10
	LDA	#'0
	JSR	[CHROUT,pcr]
	BRA	PRWH99
PRWH10	CLR	,-S		create 4-character buffer for 4 hex digits
	CLR	,-S
	CLR	,-S
	CLR	,-S
	LEAX	HEXDIG,PCR
	LSRA			get first nybble of 16-bit value to print
	LSRA
	LSRA
	LSRA
	LDA	A,X
	STA	,S
	LDA	4,S		retrieve MSB of 16-bit value of print
	ANDA	#$0F		get second nybble of 16-bit value
	LDA	A,X
	STA	1,S
	LSRB			get third nybble
	LSRB
	LSRB
	LSRB
	LDB	B,X
	STB	2,S
	LDB	5,S
	ANDB	#$0F
	LDB	B,X
	STB	3,S

	LEAX	,S		have X point to 4-char buffer
	LDB	#5		char counter
PRWH30	LDA	,X+		search for first non-'0' character
	DECB
	CMPA	#'0
	BEQ	PRWH30

	LEAX	-1,X		go back to first non-'0'
PRWH40	LDA	,X+		print the characters
	JSR	[CHROUT,pcr]
	DECB
	BNE	PRWH40

	LEAS	4,S		remove 4-char buffer

PRWH99	PULS	A,B,X,PC


* Table of ASCII characters for hexadecimal digits
HEXDIG	FCC	"0123456789ABCDEF"


* Print unsigned number in D in decimal.
PRNTWD	PSHS	X,B,A

	CLR	,-S
PRWD10	INC	,S
	SUBD	#10000
	BHS	PRWD10
	ADDD	#10000

	CLR	,-S
PRWD20	INC	,S
	SUBD	#1000
	BHS	PRWD20
	ADDD	#1000

	CLR	,-S
PRWD30	INC	,S
	SUBD	#100
	BHS	PRWD30
	ADDD	#100

	CLR	,-S
PRWD40	INC	,S
	SUBD	#10
	BHS	PRWD40
	ADDD	#10

	INCB
	PSHS	B
* All five digits are 1 more than their intended value.

	LDB	#5
	PSHS	B		loop counter
	LEAX	6,S

PRWD60	LDB	,-X		find first non-zero digit
	CMPB	#1
	BNE	PRWD80		if found
	DEC	,S
	BNE	PRWD60

	INC	,S		all zeroes: print one zero
	LEAX	1,X

PRWD70	LDB	,-X
PRWD80	ADDB	#$2F
	BSR	PRINTC
	DEC	,S
	BNE	PRWD70

	LEAS	6,S
PRWD90	PULS	A,B,X,PC


* Print the ASCII character in B.  Preserves X and D.
PRINTC	PSHS	A
	TFR	B,A
	LBSR    putchar_a
	PULS	A,PC


* Print the ASCIIZ pointed by D.  Preserves X and D.
PRINTS	PSHS	X,B,A
	TFR	D,X
	BRA	PRS020
PRS010	LBSR    putchar_a
PRS020	LDA	,X+
	BNE	PRS010
	PULS	A,B,X,PC

* Input: U => packed real number.
printReal

        IFDEF _COCO_BASIC_

	PSHS	U,Y,X
	LEAU	,S		; stack frame pointer
	LEAS	-38,S		; buffer to write ASCII string to

	LDX	4,U		; address of packed number (saved U)
	JSR	$BC14		; unpack into Basic's FPA0

	PSHS	U		; save frame pointer
	LEAU	-38,U		; address of ASCII buffer
	JSR	$BDDC		; convert FPA0 to ASCII
	PULS	U

	LEAX	-38,U		; address of ASCII buffer
	LDA	,X
	CMPA	#32		; is 1st char space?
	BNE	@print
	LEAX	1,X		; skip space
@print
	LDA	,X+
	BEQ	@donePrinting
	JSR	[CHROUT,pcr]
	BRA	@print
@donePrinting
	LEAS	,U
	PULS	X,Y,U,PC

        ELSE

	LDA	#'!
	JMP	[CHROUT,pcr]

        ENDC




	ENDSECTION
