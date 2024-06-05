#include <cmoc.h>


void *
bsearch(_CMOC_CONST_ void *key, _CMOC_CONST_ void *base, size_t nmemb, size_t size,
        int (*compar)(_CMOC_CONST_ void *key, _CMOC_CONST_ void *element))
{
    while (nmemb > 0)
    {
        _CMOC_CONST_ void *pivot = base + (nmemb >> 1) * size;
        int result = compar(key, pivot);
        if (result == 0)
            return (void *) pivot;
        if (result > 0)
        {
            base = pivot + size;
            --nmemb;
        }
        nmemb >>= 1;
    }
    return NULL;
}
