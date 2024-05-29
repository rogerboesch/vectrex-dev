#
# Compile using cmoc
# - Parameter $1: Name of file
# - Parameter $2: Path to CMOC
#
cmoc -I$2/stdlib -L$2/stdlib --vectrex --verbose -o $1.bin $1.c
