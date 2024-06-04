#
# Start emulator
#
# Parameter #1: workspaceFolder
# Parameter #2: fileBasenameNoExtension
#
export PATH=$HOME/vectrec:$PATH
$HOME/vectrec/vec2x right $HOME/vectrec/roms/romfast.bin $1/$2.bin $HOME/vectrec/roms/empty.png