#
# Call cmoc
#
# Parameter #1: workspaceFolder
# Parameter #2: fileBasenameNoExtension
#
echo $1
echo $2
export PATH=$HOME/vectrec:$PATH
cmoc -I$HOME/vectrec/stdlib -L$HOME/vectrec/stdlib --vectrex --verbose -o $1/$2.bin $1/$2.c
$HOME/vectrec/VectreC $1/$2.bin right