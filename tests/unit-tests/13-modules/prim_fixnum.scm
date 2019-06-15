(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-fixnum#.scm")

;; Gambit

(fixnum? 'a) (fixnum? 536870911) (fixnum? 2305843009213693952)

(fx*) (fx* 2) (fx* 3 4) (fx* 5 6 7) (fx* ##max-fixnum -1)
(fx+) (fx+ 1) (fx+ 2 3) (fx+ 4 5 6)
(fx- 1) (fx- 2 3) (fx- 4 5 6)

(fx<) (fx< 1) (fx< 1 2) (fx< 1 1) (fx< 2 1) (fx< 1 2 3) (fx< 1 1 1) (fx< 3 2 1)
(fx<=)(fx<= 1)(fx<= 1 2)(fx<= 1 1)(fx<= 2 1)(fx<= 1 2 3)(fx<= 1 1 1)(fx<= 3 2 1)
(fx=) (fx= 1) (fx= 1 2) (fx= 1 1) (fx= 2 1) (fx= 1 2 3) (fx= 1 1 1) (fx= 3 2 1)
(fx>) (fx> 1) (fx> 1 2) (fx> 1 1) (fx> 2 1) (fx> 1 2 3) (fx> 1 1 1) (fx> 3 2 1)
(fx>=)(fx>= 1)(fx>= 1 2)(fx>= 1 1)(fx>= 2 1)(fx>= 1 2 3)(fx>= 1 1 1)(fx>= 3 2 1)

(fxabs -10) (fxabs 10)
(fxand) (fxand 13) (fxand 13 7) (fxand 13 7 6)

(fxarithmetic-shift 241 -2)
(fxarithmetic-shift 241 0)
(fxarithmetic-shift 241 5)

(fxarithmetic-shift-left 241 0)
(fxarithmetic-shift-left 241 5)

(fxarithmetic-shift-right 241 0)
(fxarithmetic-shift-right 241 2)
(fxarithmetic-shift-right 241 5)

(fxbit-count -8) (fxbit-count -1) (fxbit-count 0) (fxbit-count 256)
(fxbit-set? 0 5) (fxbit-set? 1 5) (fxbit-set? 2 5) (fxbit-set? 10 5)
(fxeven? -1) (fxeven? 0) (fxeven? 1)
(fxfirst-bit-set -8)(fxfirst-bit-set 0)(fxfirst-bit-set 1)(fxfirst-bit-set 8)
(fxif 12 10 5)
(fxior) (fxior 13) (fxior 13 7) (fxior 13 7 6)
(fxlength -2) (fxlength -1) (fxlength -0) (fxlength 1) (fxlength 2) (fxlength 3)
(fxmax 1) (fxmax 1 2) (fxmax 2 1) (fxmax 1 3 2) (fxmax 2 4 1 3)
(fxmin 1) (fxmin 1 2) (fxmin 2 1) (fxmin 1 3 2) (fxmin 2 4 1 3)
(fxmodulo 17 3) (fxmodulo -17 -3) (fxmodulo -17 3) (fxmodulo 17 -3)
(fxnegative? -1) (fxnegative? 0) (fxnegative? 1)
(fxnot -1) (fxnot 0) (fxnot 1) (fxnot 5) (fxnot ##max-fixnum)
(fxodd? -1) (fxodd? 0) (fxodd? 1)
(fxpositive? -1) (fxpositive? 0) (fxpositive? 1)
(fxquotient 17 3) (fxquotient -17 -3) (fxquotient -17 3) (fxquotient 17 -3)
(fxremainder 17 3) (fxremainder -17 -3) (fxremainder -17 3) (fxremainder 17 -3)
(fxsquare -23170) (fxsquare 0) (fxsquare 23170)
(fxwrap*) (fxwrap* 1) (fxwrap* 2 3) (fxwrap* 4 5 6) (fxwrap* ##min-fixnum -1)
(fxwrap+) (fxwrap+ 1) (fxwrap+ 2 3) (fxwrap+ 4 5 6) (fxwrap+ ##max-fixnum 1)
(fxwrap- 1) (fxwrap- 2 3) (fxwrap- 4 5 6) (fxwrap- ##min-fixnum 1)
(fxwrapabs -10) (fxwrapabs 10) (fxwrapabs ##min-fixnum)

(fxwraparithmetic-shift 241 -2)
(fxwraparithmetic-shift 241 0)
(fxwraparithmetic-shift ##max-fixnum 5)

(fxwraparithmetic-shift-left 241 0)
(fxwraparithmetic-shift-left 241 5)

(fxwraplogical-shift-right 241 0)
(fxwraplogical-shift-right 241 2)
(fxwraplogical-shift-right ##min-fixnum 5)

(fxwrapquotient 17 3) (fxwrapquotient -17 -3) (fxwrapquotient ##min-fixnum -1)
(fxwrapsquare -23170) (fxwrapsquare ##min-fixnum) (fxwrapsquare ##max-fixnum)
(fxxor) (fxxor 13) (fxxor 13 7) (fxxor 13 7 6)
(fxzero? -1) (fxzero? 0) (fxzero? 1)

)
