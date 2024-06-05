// itoa.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include <cmoc.h>


char *
itoa10(int value, char *str)
{
    char *writer = str;

    // Process the negative case.
    unsigned u;
    if (value < 0)
    {
        *writer++ = '-';
        u = -value;
    }
    else
        u = value;

    (void) utoa10(u, writer);
    return str;
}
