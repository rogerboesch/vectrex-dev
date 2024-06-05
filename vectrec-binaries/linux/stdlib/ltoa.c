// ltoa.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include <cmoc.h>


char *
ltoa10(long value, char *str)
{
    char *writer = str;

    // Process the negative case.
    unsigned long u;
    if (value < 0)
    {
        *writer++ = '-';
        u = -value;
    }
    else
        u = value;

    (void) ultoa10(u, writer);
    return str;
}
