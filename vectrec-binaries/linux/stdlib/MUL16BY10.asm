        SECTION code

MUL16BY10	EXPORT


* Multiply D by 10, signed or unsigned; return result in D; preserve X.
MUL16BY10
        * Let n be the original value of D.
        * Compute 2n and 8n, then add them up.
        lslb
        rola        ; D is now 2n
        pshs    b,a
        lslb
        rola
        lslb
        rola        ; D is now 8n
        addd    ,s++
        rts


        ENDSECTION
