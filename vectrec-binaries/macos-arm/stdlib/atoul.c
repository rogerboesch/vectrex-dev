// atoul.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include "cmoc.h"


unsigned long atoul(_CMOC_CONST_ char *nptr)
{
    char *endptr;
    return strtoul(nptr, &endptr, 10);
}
