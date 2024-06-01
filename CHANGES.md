make vectrec repo public
mac and linux uses same install script
renamed install-vectrex_macos.sh to install-vectrec.sh
Copy emulator failed
LWTOOLS make failed
CMOC make failed

Changes in install-vectrec.sh
	Added OS detection to script
	Different copy statement for mac and linux
	CMOC was cloned again, removed that
	Different copy for compile.sh

New file compile_linux.sh
	Start of emulator (path)

Changes in LWTOOLS

lwasm\input.h

#ifdef __load_from_input__
struct ifl *ifl_head;
#else 
extern struct ifl *ifl_head;
#endif

lwasm\input.c


#define __load_from_input__
#include "input.h"



DEPENDENDECIES

basics
	sudo apt-get update
	sudo apt-get install build-essential

automake
	sudo apt-get autoremove automake
	sudo apt-get install automake
bison
	sudo apt update
	sudo apt-get -y install bison
flex
	sudo apt-get update
	sudo apt-get install flex

cmake
	sudo apt-get update
	sudo apt install cmake
git
	sudo apt-get update
	sudo apt-get install git-all
SDL
	see description in vectrex newsletter	