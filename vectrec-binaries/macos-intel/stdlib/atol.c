// atol.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include "cmoc.h"


long atol(_CMOC_CONST_ char *nptr)
{
    char *endptr;
    return (long) strtoul(nptr, &endptr, 10);
}
