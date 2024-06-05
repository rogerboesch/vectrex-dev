// _FinishIntegerToASCII.c - CMOC's standard library functions.
//
// By Pierre Sarrazin <http://sarrazip.com/>.
// This file is in the public domain.

#include <cmoc.h>


char *
_FinishIntegerToASCII(char *firstDigit, char *endOfString, char *returnValue)
{
    *endOfString = '\0';

    // Invert characters from 'firstDigit' to before 'endOfString'.
    for (--endOfString; firstDigit < endOfString; ++firstDigit, --endOfString)
    {
        char tmp = *firstDigit;
        *firstDigit = *endOfString;
        *endOfString = tmp;
    }

    return returnValue;
}
