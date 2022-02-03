#
# Use user path to avoid permission issues
# 
export DESTDIR="$HOME"
export PATH="$HOME/usr/bin:$HOME/usr/local/bin:$PATH"
#
# Call cmoc
#
cmoc -I$HOME/usr/share/cmoc/include -L$HOME/usr/share/cmoc/lib --vectrex --verbose -o $1.bin $1.c
