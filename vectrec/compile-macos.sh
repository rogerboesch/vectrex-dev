#
# Call cmoc
#
# Parameter #1: workspaceFolder
# Parameter #2: fileBasenameNoExtension
#
export PATH=$HOME/vectrec:$PATH
cmoc -I$HOME/vectrec/stdlib -L$HOME/vectrec/stdlib --vectrex --verbose -o $1/$2.bin $1/$2.c
$HOME/vectrec/VectreC.app/Contents/MacOS/VectreC $1/$2.bin right