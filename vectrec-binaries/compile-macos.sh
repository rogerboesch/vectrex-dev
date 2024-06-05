#
# Call cmoc
#
# Parameter #1: workspaceFolder
# Parameter #2: fileBasenameNoExtension
#
export PATH=$HOME/vectrec:$PATH
cmoc -I$HOME/vectrec/stdlib -L$HOME/vectrec/stdlib --vectrex --verbose -o $1/$2.bin $1/$2.c
$HOME/vectrec/vec2x right $HOME/vectrec/roms/romfast.bin $1/$2.bin $HOME/vectrec/roms/empty.png