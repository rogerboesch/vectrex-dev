#include "coco.h"


void sleep(int seconds)
{
    if (!seconds)
        return;
    unsigned limit = 60 * (unsigned) seconds; 
    setTimer(0);
    while (getTimer() < limit)
        ;
}
