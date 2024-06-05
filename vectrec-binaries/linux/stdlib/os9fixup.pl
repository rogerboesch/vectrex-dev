#!/usr/bin/perl -w
#
# Changes lower-case ",pcr" to ",Y", as per the convention that
# upper-case ",PCR" is a reference to code or to a read-only global.

use strict;


#my $inOS9Region = 1;

while (<>)
{
    s/,pcr/,Y/;  # case sensitive
    print;
    #if (/^\s+IFDEF\s+(\S+)/ && $1 ne "OS9")  # if starting non-OS-9 region
    #{
    #    $inOS9Region = 0;
    #}
    #elsif (/^\s+ENDC\b/)
    #{
    #    $inOS9Region = 1;
    #}
}
