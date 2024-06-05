#include <cmoc.h>


#if 0  /* Original C code. */
static void
qsort_swap(char *a, char *b, size_t len) 
{ 
    //printf("swap(%p, %p, %u)\n", a, b, len);
    char temp;
    for (size_t i = 0; i < len; ++i)
    {
        temp = a[i];
        a[i] = b[i];
        b[i] = temp;
    }
}
#else
static asm __norts__ void
qsort_swap(char *a, char *b, size_t len) 
{ 
    asm
    {
        pshs    u,y
        ldx     6,s             ; a
        ldu     8,s             ; b
        ldy     10,s            ; len (assumed > 0)
@loop
        lda     ,x
        ldb     ,u
        stb     ,x+
        sta     ,u+
        leay    -1,y
        bne     @loop
        puls    y,u,pc
    }
}
#endif


typedef int (*qsort_compare)(_CMOC_CONST_ void *, _CMOC_CONST_ void *);


static size_t
qsort_partition(char *array, size_t elemSize, qsort_compare comparator, size_t l, size_t h) 
{ 
    char *x = array + h * elemSize; 
    size_t i = l - 1; 
    //printf("P: START: A=%p ES=%u L=%u H=%u\n", array, elemSize, l, h);
  
    for (size_t j = l; j < h; ++j)
    { 
        char *y = array + j * elemSize;
        int res = comparator(y, x);
        //printf("P:   J=%u Y=%p X=%p -> RES=%d\n", j, y, x, res);
        if (res <= 0)
        { 
            ++i;
            //printf("P:     I=%u Y=%p\n", i, y);
            qsort_swap(array + i * elemSize, y, elemSize); 
        } 
    }

    //printf("P: END: I=%u H=%p\n", i, h);
    qsort_swap(array + (i + 1) * elemSize, array + h * elemSize, elemSize); 
    return i + 1; 
}


static void
qsort_work(char *array, size_t elemSize, qsort_compare comparator, size_t l, size_t h) 
{ 
    //printf("work: %u < %u: unsigned=%d, signed=%d\n", l, h, l < h, (signed) l < (signed) h);
    //if ((signed) l < (signed) h)
    if (l < h)
    { 
        size_t p = qsort_partition(array, elemSize, comparator, l, h); 
        //printf("work: got p=%u\n", p);
        if (p > 0)
            qsort_work(array, elemSize, comparator, l, p - 1); 
        qsort_work(array, elemSize, comparator, p + 1, h); 
    } 
} 


void
qsort(void *base, size_t nmemb, size_t size, int (*compar)(_CMOC_CONST_ void *, _CMOC_CONST_ void *))
{
    if (nmemb > 1 && size > 0)
        qsort_work((char *) base, size, compar, 0, nmemb - 1);
}
