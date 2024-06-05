# $Id: Makefile.am,v 1.45 2020/06/06 04:41:44 sarrazip Exp $

# N.B.: CMOC must already have been compiled before this directory can be processed.

# CAUTION: In this library, references to data must be specified with lowercase ",pcr",
#          while references to code must be specified with uppercase ",PCR".
#          This is for the benefit of OS-9, where ",pcr" gets converted to ",Y".

# The eader files go in /usr/share/cmoc/include.
#
cmocincdir = $(pkgdatadir)/include
cmocinc_HEADERS = \
	assert.h \
	cmoc.h \
	coco.h \
	disk.h \
	stdarg.h \
	vectrex.h

vectrexincdir = $(cmocincdir)/vectrex
vectrexinc_HEADERS = \
	vectrex/stdlib.h \
    vectrex/compatibility.h \
    vectrex/types.h \
	vectrex/bios.h

# The ecb, usim, os9, vec and dgn keywords in these library names
# are specified in invokeLinker() [main.cpp].
#
cmoclibdir = $(pkgdatadir)/lib
cmoclib_DATA = \
	libcmoc-crt-ecb.a \
	libcmoc-crt-usim.a \
	libcmoc-crt-os9.a \
	libcmoc-crt-vec.a \
	libcmoc-crt-dgn.a \
	libcmoc-std-ecb.a \
	libcmoc-std-usim.a \
	libcmoc-std-os9.a \
	libcmoc-std-vec.a \
	libcmoc-std-dgn.a

CRT_ASM = \
	crt.asm \
	addDWordDWord.asm \
	addDWordInt.asm \
	addDWordUnsignedInt.asm \
	adddww.asm \
	addIntDWord.asm \
	addUnsignedIntDWord.asm \
	andDWordDWord.asm \
	andDWordWord.asm \
	cmpDWordDWord.asm \
	cmpDWordSignedInt.asm \
	cmpDWordUnsignedInt.asm \
	cmpdww.asm \
	cmpSignedIntDWord.asm \
	cmpUnsignedIntDWord.asm \
	copyDWord.asm \
	copyDWordFromXToD.asm \
	copyMem.asm \
	copyWordToDWord.asm \
	decrementDWord.asm \
	DIV16.asm \
	DIV16BY10.asm \
	DIV32.asm \
	DIV8.asm \
	DIV8BY7.asm \
	divDBy16.asm \
	divdwb.asm \
	divDWordDWord.asm \
	divDWordUnsignedInt.asm \
	divdww.asm \
	divModDWordDWord.asm \
	divModDWordUnsignedInt.asm \
	divModUnsignedIntDWord.asm \
	divUnsignedIntDWord.asm \
	incrementDWord.asm \
	initByteFromDWord.asm \
	initDWordFromSignedWord.asm \
	initDWordFromUnsignedWord.asm \
	initSingleFromSingle.asm \
	initWordFromDWord.asm \
	isDWordZero.asm \
	jumpTableSwitch.asm \
	leftShiftDWord.asm \
	leftShiftDWordAtXByB.asm \
	modDWordDWord.asm \
	modDWordUnsignedInt.asm \
	modUnsignedIntDWord.asm \
	MUL168_TO24.asm \
	MUL168_TO32.asm \
	MUL16.asm \
	MUL16BY10.asm \
	MUL32.asm \
	mulDWordDWord.asm \
	mulDWordInt.asm \
	mulDWordUnsignedInt.asm \
	mulIntDWord.asm \
	mulUnsignedIntDWord.asm \
	negateDWord.asm \
	orDWordDWord.asm \
	orDWordWord.asm \
	push4ByteStruct.asm \
	push5ByteStruct.asm \
	pushStruct.asm \
	rightShiftDWord.asm \
	rightShiftDWordAtXByB.asm \
	SDIV16.asm \
	SDIV8.asm \
	shiftByteLeft.asm \
	shiftByteRightSigned.asm \
	shiftByteRightUnsigned.asm \
	shiftLeft.asm \
	shiftRightSigned.asm \
	shiftRightUnsigned.asm \
	signedDivDWordDWord.asm \
	signExtWordToDWord.asm \
	sub32.asm \
	sub32xu.asm \
	subDWordDWord.asm \
	subDWordInt.asm \
	subDWordUnsignedInt.asm \
	subdww.asm \
	subIntDWord.asm \
	subUnsignedIntDWord.asm \
	testAndRemoveSignOnDWord.asm \
	testAndRemoveSignOnWord.asm \
	xorDWordDWord.asm \
	xorDWordWord.asm

STD_ASM = \
	atoi.asm \
	atoui.asm \
	ATOW.asm \
	checknull.asm \
	checkstack.asm \
	delay.asm \
	dwtoa.asm \
	LINBUF.asm \
	memcmp.asm \
	memicmp.asm \
	memcmpimpl.asm \
	memcpy.asm \
	memset.asm \
	printf.asm \
	putchar_a.asm \
	putstr.asm \
	readline.asm \
	readword.asm \
	sbrk.asm \
	sbrkmax.asm \
	seed.asm \
	setConsoleOutHook.asm \
	sprintf.asm \
	strcat.asm \
	strchr.asm \
	strstr.asm \
	strcmp.asm \
	stricmp.asm \
	strcmpimpl.asm \
	strcpy.asm \
	strlen.asm \
	strlwr.asm \
	strncpy.asm \
	strtoul.asm \
	strupr.asm \
	tolower.asm \
	toupper.asm \
	zerodw.asm \
	convertABToUpperCase.asm

# Also part of 'std' library:
C_COMMON = \
	atol.c \
	atoul.c \
	strtol.c \
	utoa.c \
	itoa.c \
	ultoa.c \
	ltoa.c \
	_FinishIntegerToASCII.c \
	stdarg.c \
	sqrt16.c \
	divmod16.c \
	divmod8.c \
	rand.c \
	initCoCoSupport.c \
	qsort.c \
	bsearch.c

# Also part of 'std' library, but only under Color Basic and Dragon:

C_COCO_OR_DRAGON_BASIC = \
	attr.c \
	cls.c \
	coldStart.c \
	getTextMode.c \
	hscreen.c \
	hset.c \
	inkey.c \
	isKeyPressed.c \
	locate.c \
	palette.c \
	paletteRGB.c \
	pcls.c \
	readJoystickButtons.c \
	readJoystickPositions.c \
	resetPalette.c \
	setBorderColor.c \
	setCaseFlag.c \
	setHighSpeed.c \
	setOutputDevice.c \
	setSAMRegisters.c \
	showGraphicsAddress.c \
	showLowResTextAddress.c \
	showPmode4.c \
	sleep.c \
	sound.c \
	waitkey.c \
	width.c

# Also part of 'std' library, but only under Color Basic:
C_COCO_BASIC = \
	disk.c

# Also part of 'std' library, but only for the Vectrex:
C_VECTREX = vectrex_bios.c

CRT_ECB_OBJ  = $(CRT_ASM:.asm=.ecb_o)
CRT_USIM_OBJ = $(CRT_ASM:.asm=.usim_o)
CRT_OS9_OBJ  = $(CRT_ASM:.asm=.os9_o)
CRT_VECTREX_OBJ  = $(CRT_ASM:.asm=.vec_o)
CRT_DRAGON_OBJ  = $(CRT_ASM:.asm=.dgn_o)

libcmoc-crt-ecb.a: $(CRT_ECB_OBJ)
	$(LWAR) -c $@ $(CRT_ECB_OBJ)
libcmoc-crt-usim.a: $(CRT_USIM_OBJ)
	$(LWAR) -c $@ $(CRT_USIM_OBJ)
libcmoc-crt-os9.a: $(CRT_OS9_OBJ)
	$(LWAR) -c $@ $(CRT_OS9_OBJ)
libcmoc-crt-vec.a: $(CRT_VECTREX_OBJ)
	$(LWAR) -c $@ $(CRT_VECTREX_OBJ)
libcmoc-crt-dgn.a: $(CRT_DRAGON_OBJ)
	$(LWAR) -c $@ $(CRT_DRAGON_OBJ)

STD_ECB_OBJ  = $(STD_ASM:.asm=.ecb_o)  $(C_COMMON:.c=.ecb_o) $(C_COCO_OR_DRAGON_BASIC:.c=.ecb_o) $(C_COCO_BASIC:.c=.ecb_o)
STD_USIM_OBJ = $(STD_ASM:.asm=.usim_o) $(C_COMMON:.c=.usim_o)
STD_OS9_OBJ  = $(STD_ASM:.asm=.os9_o)  $(C_COMMON:.c=.os9_o)
STD_VECTREX_OBJ = $(STD_ASM:.asm=.vec_o) $(C_COMMON:.c=.os9_o) $(C_VECTREX:.c=.vec_o)
STD_DRAGON_OBJ  = $(STD_ASM:.asm=.dgn_o)  $(C_COMMON:.c=.dgn_o) $(C_COCO_OR_DRAGON_BASIC:.c=.dgn_o)

libcmoc-std-ecb.a: $(STD_ECB_OBJ)
	$(LWAR) -c $@ $(STD_ECB_OBJ)
libcmoc-std-usim.a: $(STD_USIM_OBJ)
	$(LWAR) -c $@ $(STD_USIM_OBJ)
libcmoc-std-os9.a: $(STD_OS9_OBJ)
	$(LWAR) -c $@ $(STD_OS9_OBJ)
libcmoc-std-vec.a: $(STD_VECTREX_OBJ)
	$(LWAR) -c $@ $(STD_VECTREX_OBJ)
libcmoc-std-dgn.a: $(STD_DRAGON_OBJ)
	$(LWAR) -c $@ $(STD_DRAGON_OBJ)

.asm.ecb_o:
	$(LWASM) -fobj -D_COCO_BASIC_ -D_COCO_OR_DRAGON_BASIC_ --output=$@ $<
.asm.usim_o:
	$(LWASM) -fobj -DUSIM --output=$@ $<
OS9TEMP = $(notdir $<.os9asm)
.asm.os9_o:
	$(PERL) $(srcdir)/os9fixup.pl < $< > $(OS9TEMP)
	$(LWASM) -fobj -DOS9 -I$(srcdir) --pragma=dollarnotlocal --output=$@ $(OS9TEMP)
	rm $(OS9TEMP)
# OS9: dollarnotlocal is necessary to avoid errors on identifiers like "F$Exit".
.asm.vec_o:
	$(LWASM) -fobj -DVECTREX --output=$@ $<
.asm.dgn_o:
	$(LWASM) -fobj -DDRAGON -D_COCO_OR_DRAGON_BASIC_ --output=$@ $<

CMOC_LIB_FLAGS = -O2 -DNDEBUG -nostdinc -I $(srcdir)

.c.ecb_o:
	../cmoc -c $(CMOC_LIB_FLAGS) -o $@ $<
.c.usim_o:
	../cmoc -c $(CMOC_LIB_FLAGS) --usim -o $@ $<
.c.os9_o:
	../cmoc -c $(CMOC_LIB_FLAGS) --os9 -o $@ $<
.c.vec_o:
	../cmoc -c $(CMOC_LIB_FLAGS) --vectrex -DSTD_INC_PATH='$(srcdir)/std.inc' -o $@ $<
.c.dgn_o:
	../cmoc -c $(CMOC_LIB_FLAGS) --dragon -o $@ $<

# Checks if some files contain non-breakable spaces (character 160).
# The statement in the 'continue' clause resets the line counter ($.)
# at the end of each processed file.
#
check:
	$(PERL) -e 'while (<>) { if (/\xA0/) { print "ERROR: non-breakable space at $$ARGV:$$.\n"; exit 1 } } continue { close ARGV if eof }' \
		$(cmocinc_HEADERS) $(vectrexinc_HEADERS) \
		$(CRT_ASM) $(STD_ASM) \
		$(C_COMMON) $(C_COCO_OR_DRAGON_BASIC) $(C_COCO_BASIC) $(C_VECTREX) \
		Makefile.am

CLEANFILES = $(cmoclib_DATA) \
        $(CRT_ECB_OBJ) $(CRT_USIM_OBJ) $(CRT_OS9_OBJ) $(CRT_VECTREX_OBJ) $(CRT_DRAGON_OBJ) \
        $(STD_ECB_OBJ) $(STD_USIM_OBJ) $(STD_OS9_OBJ) $(STD_VECTREX_OBJ) $(STD_DRAGON_OBJ)

EXTRA_DIST = std.inc os9fixup.pl $(CRT_ASM) $(STD_ASM) \
		$(C_COMMON) $(C_COCO_OR_DRAGON_BASIC) $(C_COCO_BASIC) $(C_VECTREX)
