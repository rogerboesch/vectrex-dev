// ultoa.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include <cmoc.h>


char *_FinishIntegerToASCII(char *firstDigit, char *endOfString, char *returnValue);


char *
ultoa10(unsigned long value, char *str)
{
    if (value == 0)
    {
        str[0] = '0';
        str[1] = '\0';
        return str;
    }

    char *writer = str;

    // Write the digits in reverse order, then reverse them.
    char *firstDigit = writer;
    while (value > 0)
    {
        unsigned long next = value / 10;
        *writer++ = '0' + (char) (value - next * 10);  // value % 10
        value = next;
    }
    
    return _FinishIntegerToASCII(firstDigit, writer, str);
}
