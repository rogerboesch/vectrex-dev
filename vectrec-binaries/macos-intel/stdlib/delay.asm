	INCLUDE std.inc

	SECTION code

_delay	EXPORT


* Wait for a number of ticks (1/60 second) which is given on the stack.
_delay

	IFDEF _COCO_OR_DRAGON_BASIC_

	LDD	2,S		number of ticks to wait
	BEQ	DELAY9
	ADDD	TIMER		value that TIMER must reach
DELAY1	CMPD	TIMER
	BNE	DELAY1
DELAY9	RTS

	ENDC


	IFDEF USIM

	LDD	2,S		number of ticks to wait
	STD	$FF02		ask simulator to wait
	RTS

	ENDC


	IFDEF OS9

	ldx	2,s
	os9	F$Sleep
	rts

	ENDC


	IFDEF VECTREX

	RTS

	ENDC


	ENDSECTION
