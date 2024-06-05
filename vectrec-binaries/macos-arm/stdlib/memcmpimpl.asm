        SECTION code

memcmpimpl		EXPORT


* Input: Two pointers and a word on stack.
*        X => Routine that loads bytes through X and U, advances X and U,
*		  	  transforms the two bytes if needed, then compares the bytes
*			  and returns with CC reflecting this comparison. (May trash D.)
*
* Returns 0, 1 or -1 in D.
*
memcmpimpl
        pshs    u,y,x
; Stack map here:
;  0,S = Routine address.
;  2,S = Saved Y.
;  4,S = Saved U.
;  6,S = Return address.
;  8,S = Address of 1st string.
; 10,S = Address of 2nd string.
; 12,S = Word giving number of bytes to compare.
;
        ldy     12,s            number of bytes to compare
        beq     _memcmp_equal
        ldx     8,s             1st string
        ldu     10,s            2nd string

_memcmp_loop
		jsr		[,s]			call load+transform+compare+advance routine
        bne     _memcmp_diff    if bytes different

        leay    -1,y            one byte done
        bne     _memcmp_loop    if more to do

_memcmp_equal
        clrb                    return 0: regions are equal
        bra     _memcmp_end

_memcmp_diff
        bhi     _memcmp_ret1    return +1: 1st string comes after

        ldb     #$FF            return -1: 1st string comes before
        bra     _memcmp_end

_memcmp_ret1
        ldb     #1

_memcmp_end
        sex                     return int
        puls    x,y,u,pc


        ENDSECTION
