# TODO

## General

- [ ] Create Windows version (binaries)
- [ ] Create Linux version (binaries)
- [ ] Create macOS Intel version (binaries)
- [ ] Create macOS ARM version (binaries)
- [x] Finish vec2x emulator
- [x] Make vectrec repo public
- [x] Use same install script for macos and linux
- [x] Rename install-vectrex_macos.sh in install-vectrec.sh
- [x] Create install script for all dependencies (macos, linux)
- [x] LWTOOLS make failed, fix (Software issue, see below)
- [x] CMOC make failed, fix (Missed dependencies, path, needs lwasm)

## Install script (install-vectrec.sh)

- [x] Added OS detection to script
- [x] Different copy path for linux and macos (compile.sh)
- [x] Different copy path for linux and macos (Emulator)
- [x] CMOC was cloned again, removed that
- [x] Different copy for compile.sh
- [x] Name change from compile_* to compile-* 
- [x] Add copy of start-*.sh script

## Compile script (compile-*.sh)

- [x] New file compile-linux.sh
- [x] Start of emulator (path)

## Start script (start-*.sh)

- [x] New file start-macos.sh
- [x] New file start-linux.sh

## Visual Studio Code Extension

- [ ] Extension (package.json)
- [x] tasks.json -- Call start.sh

## LWTOOLS

- [x] Changes in source
- [x] Create tar

## CMOC

- [x] Dependencies
- [x] Needs path to lwasm

### Changes in lwasm\input.h

```
#ifdef __load_from_input__
struct ifl *ifl_head;
#else 
extern struct ifl *ifl_head;
#endif
```

### Changes in lwasm\input.c

```
#define __load_from_input__
#include "input.h"
```

## Dependencies

### Essential developer tools

```
sudo apt-get update
sudo apt-get install build-essential
```

### automake

```
sudo apt-get autoremove automake
sudo apt-get install automake
```

### bison

```
sudo apt update
sudo apt-get -y install bison
```

### flex

```
sudo apt-get update
sudo apt-get install flex
```

### Cmake
	
```
sudo apt-get update
sudo apt install cmake
```

### Git

```
sudo apt-get update
sudo apt-get install git-all
```

### SDL

```
sudo apt-get update
sudo apt-get install libsdl2-dev	
```
