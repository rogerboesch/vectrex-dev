// strtol.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include "cmoc.h"


long strtol(_CMOC_CONST_ char *nptr, char **endptr, int base)
{
    return (long) strtoul(nptr, endptr, base);
}
