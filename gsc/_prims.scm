;;;============================================================================

;;; File: "_prims.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

;;;----------------------------------------------------------------------------
;;
;; Primitive procedure database:

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define prim-procs '
(
;;                                                       lift pattern
;;                                                       /
;;                          side-effects?   strictness  /  result
;;                                      \   pattern    /   type
;; name                  call pattern    \  \         /    /     standard
;;  /                               \     \  \       /    /      |

;; boolean

("boolean?"                           (1)   #f 0     0    boolean ieee)
("##boolean?"                         (1)   #f ()    0    boolean extended)
("not"                                (1)   #f 0     0    boolean ieee)
("##not"                              (1)   #f ()    0    boolean extended)

("boolean=?"                          0     #f 0     0    boolean r7rs)
("##boolean=?"                        0     #f ()    0    boolean extended)

;; number

("*"                                  0     #f 0     0    number  ieee)
("##*"                                0     #f ()    0    number  extended)
("+"                                  0     #f 0     0    number  ieee)
("##+"                                0     #f ()    0    number  extended)
("-"                                  1     #f 0     0    number  ieee)
("##-"                                1     #f ()    0    number  extended)
("/"                                  1     #f 0     0    number  ieee)
("##/"                                1     #f ()    0    number  extended)
("<"                                  0     #f 0     0    boolean ieee)
("##<"                                0     #f ()    0    boolean extended)
("<="                                 0     #f 0     0    boolean ieee)
("##<="                               0     #f ()    0    boolean extended)
("="                                  0     #f 0     0    boolean ieee)
("##="                                0     #f ()    0    boolean extended)
(">"                                  0     #f 0     0    boolean ieee)
("##>"                                0     #f ()    0    boolean extended)
(">="                                 0     #f 0     0    boolean ieee)
("##>="                               0     #f ()    0    boolean extended)
("abs"                                (1)   #f 0     0    number  ieee)
("##abs"                              (1)   #f ()    0    number  extended)
("acos"                               (1)   #f 0     0    number  ieee)
("##acos"                             (1)   #f ()    0    number  extended)
("angle"                              (1)   #f 0     0    real    ieee)
("##angle"                            (1)   #f ()    0    real    extended)
("asin"                               (1)   #f 0     0    number  ieee)
("##asin"                             (1)   #f ()    0    number  extended)
("atan"                               (1 2) #f 0     0    number  ieee)
("##atan"                             (1 2) #f ()    0    number  extended)
("ceiling"                            (1)   #f 0     0    integer ieee)
("##ceiling"                          (1)   #f ()    0    integer extended)
("complex?"                           (1)   #f 0     0    boolean ieee)
("##complex?"                         (1)   #f ()    0    boolean extended)
("cos"                                (1)   #f 0     0    number  ieee)
("##cos"                              (1)   #f ()    0    number  extended)
("denominator"                        (1)   #f 0     0    integer ieee)
("##denominator"                      (1)   #f ()    0    integer extended)
("even?"                              (1)   #f 0     0    boolean ieee)
("##even?"                            (1)   #f ()    0    boolean extended)
("exact->inexact"                     (1)   #f 0     0    number  ieee)
("##exact->inexact"                   (1)   #f ()    0    number  extended)
("exact?"                             (1)   #f 0     0    boolean ieee)
("##exact?"                           (1)   #f ()    0    boolean extended)
("exp"                                (1)   #f 0     0    number  ieee)
("##exp"                              (1)   #f ()    0    number  extended)
("expt"                               (2)   #f 0     0    number  ieee)
("##expt"                             (2)   #f ()    0    number  extended)
("floor"                              (1)   #f 0     0    integer ieee)
("##floor"                            (1)   #f ()    0    integer extended)
("gcd"                                1     #f 0     0    integer ieee)
("##gcd"                              1     #f ()    0    integer extended)
("imag-part"                          (1)   #f 0     0    real    ieee)
("##imag-part"                        (1)   #f ()    0    real    extended)
("inexact->exact"                     (1)   #f 0     0    number  ieee)
("##inexact->exact"                   (1)   #f ()    0    number  extended)
("inexact?"                           (1)   #f 0     0    boolean ieee)
("##inexact?"                         (1)   #f ()    0    boolean extended)
("integer?"                           (1)   #f 0     0    boolean ieee)
("##integer?"                         (1)   #f ()    0    boolean extended)
("lcm"                                1     #f 0     0    integer ieee)
("##lcm"                              1     #f ()    0    integer extended)
("log"                                (1)   #f 0     0    number  ieee)
("##log"                              (1)   #f ()    0    number  extended)
("magnitude"                          (1)   #f 0     0    real    ieee)
("##magnitude"                        (1)   #f ()    0    real    extended)
("make-polar"                         (2)   #f 0     0    number  ieee)
("##make-polar"                       (2)   #f ()    0    number  extended)
("make-rectangular"                   (2)   #f 0     0    number  ieee)
("##make-rectangular"                 (2)   #f ()    0    number  extended)
("max"                                1     #f 0     0    number  ieee)
("##max"                              1     #f ()    0    number  extended)
("min"                                1     #f 0     0    number  ieee)
("##min"                              1     #f ()    0    number  extended)
("modulo"                             (2)   #f 0     0    integer ieee)
("##modulo"                           (2)   #f ()    0    integer extended)
("negative?"                          (1)   #f 0     0    boolean ieee)
("##negative?"                        (1)   #f ()    0    boolean extended)
("number->string"                     (1 2) #f 0     0    string  ieee)
("##number->string"                   (1 2) #f ()    0    string  extended)
("number?"                            (1)   #f 0     0    boolean ieee)
("##number?"                          (1)   #f ()    0    boolean extended)
("numerator"                          (1)   #f 0     0    integer ieee)
("##numerator"                        (1)   #f ()    0    integer extended)
("odd?"                               (1)   #f 0     0    boolean ieee)
("##odd?"                             (1)   #f ()    0    boolean extended)
("positive?"                          (1)   #f 0     0    boolean ieee)
("##positive?"                        (1)   #f ()    0    boolean extended)
("quotient"                           (2)   #f 0     0    integer ieee)
("##quotient"                         (2)   #f ()    0    integer extended)
("rational?"                          (1)   #f 0     0    boolean ieee)
("##rational?"                        (1)   #f ()    0    boolean extended)
("rationalize"                        (2)   #f 0     0    number  ieee)
("##rationalize"                      (2)   #f ()    0    number  extended)
("real-part"                          (1)   #f 0     0    real    ieee)
("##real-part"                        (1)   #f ()    0    real    extended)
("real?"                              (1)   #f 0     0    boolean ieee)
("##real?"                            (1)   #f ()    0    boolean extended)
("remainder"                          (2)   #f 0     0    integer ieee)
("##remainder"                        (2)   #f ()    0    integer extended)
("round"                              (1)   #f 0     0    integer ieee)
("##round"                            (1)   #f ()    0    integer extended)
("sin"                                (1)   #f 0     0    number  ieee)
("##sin"                              (1)   #f ()    0    number  extended)
("sqrt"                               (1)   #f 0     0    number  ieee)
("##sqrt"                             (1)   #f ()    0    number  extended)
("string->number"                     (1 2) #f 0     0    number  ieee)
("##string->number"                   (1 2) #f ()    0    number  extended)
("tan"                                (1)   #f 0     0    number  ieee)
("##tan"                              (1)   #f ()    0    number  extended)
("truncate"                           (1)   #f 0     0    integer ieee)
("##truncate"                         (1)   #f ()    0    integer extended)
("zero?"                              (1)   #f 0     0    boolean ieee)
("##zero?"                            (1)   #f ()    0    boolean extended)

("bitwise-and"                        0     #f 0     0    integer r6rs)
("##bitwise-and"                      0     #f ()    0    integer extended)
("bitwise-andc1"                      (2)   #f ()    0    integer extended)
("##bitwise-andc1"                    (2)   #f ()    0    integer extended)
("bitwise-andc2"                      (2)   #f ()    0    integer extended)
("##bitwise-andc2"                    (2)   #f ()    0    integer extended)
("bitwise-eqv"                        0     #f 0     0    integer extended)
("##bitwise-eqv"                      0     #f ()    0    integer extended)
("bitwise-ior"                        0     #f 0     0    integer r6rs)
("##bitwise-ior"                      0     #f ()    0    integer extended)
("bitwise-nand"                       (2)   #f ()    0    integer extended)
("##bitwise-nand"                     (2)   #f ()    0    integer extended)
("bitwise-nor"                        (2)   #f ()    0    integer extended)
("##bitwise-nor"                      (2)   #f ()    0    integer extended)
("bitwise-not"                        (1)   #f 0     0    integer r6rs)
("##bitwise-not"                      (1)   #f ()    0    integer extended)
("bitwise-orc1"                       (2)   #f ()    0    integer extended)
("##bitwise-orc1"                     (2)   #f ()    0    integer extended)
("bitwise-orc2"                       (2)   #f ()    0    integer extended)
("##bitwise-orc2"                     (2)   #f ()    0    integer extended)
("bitwise-xor"                        0     #f 0     0    integer r6rs)
("##bitwise-xor"                      0     #f ()    0    integer extended)
("exact-integer-sqrt"                 (1)   #f 0     0    #f      r6rs)
("##exact-integer-sqrt"               (1)   #f ()    0    #f      extended)
("finite?"                            (1)   #f 0     0    boolean r6rs)
("##finite?"                          (1)   #f ()    0    boolean extended)
("infinite?"                          (1)   #f 0     0    boolean r6rs)
("##infinite?"                        (1)   #f ()    0    boolean extended)
("nan?"                               (1)   #f 0     0    boolean r6rs)
("##nan?"                             (1)   #f ()    0    boolean extended)
("inexact"                            (1)   #f 0     0    number  r6rs)
("##inexact"                          (1)   #f ()    0    number  extended)
("exact"                              (1)   #f 0     0    number  r6rs)
("##exact"                            (1)   #f ()    0    number  extended)

("exact-integer?"                     (1)   #f 0     0    boolean r7rs)
("##exact-integer?"                   (1)   #f ()    0    boolean extended)
("floor-quotient"                     (2)   #f 0     0    integer r7rs)
("##floor-quotient"                   (2)   #f ()    0    integer extended)
("floor-remainder"                    (2)   #f 0     0    integer r7rs)
("##floor-remainder"                  (2)   #f ()    0    integer extended)
("floor/"                             (2)   #f 0     0    #f      r7rs)
("##floor/"                           (2)   #f ()    0    #f      extended)
("square"                             (1)   #f 0     0    number  r7rs)
("##square"                           (1)   #f ()    0    number  extended)
("truncate-quotient"                  (2)   #f 0     0    integer r7rs)
("##truncate-quotient"                (2)   #f ()    0    integer extended)
("truncate-remainder"                 (2)   #f 0     0    integer r7rs)
("##truncate-remainder"               (2)   #f ()    0    integer extended)
("truncate/"                          (2)   #f 0     0    #f      r7rs)
("##truncate/"                        (2)   #f ()    0    #f      extended)

("acosh"                              (1)   #f 0     0    number  gambit)
("##acosh"                            (1)   #f ()    0    number  extended)
("all-bits-set?"                      (2)   #f 0     0    boolean gambit)
("##all-bits-set?"                    (2)   #f ()    0    boolean extended)
("any-bits-set?"                      (2)   #f 0     0    boolean gambit)
("##any-bits-set?"                    (2)   #f ()    0    boolean extended)
("arithmetic-shift"                   (2)   #f 0     0    integer gambit)
("##arithmetic-shift"                 (2)   #f ()    0    integer extended)
("asinh"                              (1)   #f 0     0    number  gambit)
("##asinh"                            (1)   #f ()    0    number  extended)
("atanh"                              (1)   #f 0     0    number  gambit)
("##atanh"                            (1)   #f ()    0    number  extended)
("bit-count"                          (1)   #f 0     0    fix>=0  gambit)
("##bit-count"                        (1)   #f ()    0    fix>=0  extended)
("bit-set?"                           (2)   #f 0     0    boolean gambit)
("##bit-set?"                         (2)   #f ()    0    boolean extended)
("bitwise-merge"                      (3)   #f 0     0    integer gambit)
("##bitwise-merge"                    (3)   #f ()    0    integer extended)
("clear-bit-field"                    (3)   #f 0     0    integer gambit)
("##clear-bit-field"                  (3)   #f ()    0    integer extended)
("conjugate"                          (1)   #f 0     0    number  gambit)
("##conjugate"                        (1)   #f ()    0    number  extended)
("copy-bit-field"                     (4)   #f 0     0    integer gambit)
("##copy-bit-field"                   (4)   #f ()    0    integer extended)
("cosh"                               (1)   #f 0     0    number  gambit)
("##cosh"                             (1)   #f ()    0    number  extended)
("extract-bit-field"                  (3)   #f 0     0    integer gambit)
("##extract-bit-field"                (3)   #f ()    0    integer extended)
("first-set-bit"                      (1)   #f 0     0    fix>=-1 gambit)
("##first-set-bit"                    (1)   #f ()    0    fix>=-1 extended)
("integer-length"                     (1)   #f 0     0    fix>=0  gambit)
("##integer-length"                   (1)   #f ()    0    fix>=0 extended)
("integer-nth-root"                   (2)   #f 0     0    integer gambit)
("##integer-nth-root"                 (2)   #f ()    0    integer extended)
("integer-sqrt"                       (1)   #f 0     0    integer gambit)
("##integer-sqrt"                     (1)   #f ()    0    integer extended)
("replace-bit-field"                  (4)   #f 0     0    integer gambit)
("##replace-bit-field"                (4)   #f ()    0    integer extended)
("sinh"                               (1)   #f 0     0    number  gambit)
("##sinh"                             (1)   #f ()    0    number  extended)
("tanh"                               (1)   #f 0     0    number  gambit)
("##tanh"                             (1)   #f ()    0    number  extended)
("test-bit-field?"                    (3)   #f 0     0    boolean gambit)
("##test-bit-field?"                  (3)   #f ()    0    boolean extended)

("##bignum?"                          (1)   #f ()    0    boolean extended)
("##bignum.negative?"                 (1)   #f ()    0    boolean extended)
("##bignum.adigit-length"             (1)   #f ()    0    fix>=0  extended)
("##bignum.adigit-inc!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-dec!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-add!"               (5)   #t ()    0    integer extended)
("##bignum.adigit-sub!"               (5)   #t ()    0    integer extended)
("##bignum.mdigit-length"             (1)   #f ()    0    fix>=0  extended)
("##bignum.mdigit-ref"                (2)   #f ()    0    integer extended)
("##bignum.mdigit-set!"               (3)   #t ()    0    #f      extended)
("##bignum.mdigit-mul!"               (6)   #t ()    0    integer extended)
("##bignum.mdigit-div!"               (6)   #t ()    0    integer extended)
("##bignum.mdigit-quotient"           (3)   #f ()    0    integer extended)
("##bignum.mdigit-remainder"          (4)   #f ()    0    integer extended)
("##bignum.mdigit-test?"              (4)   #f ()    0    boolean extended)
("##bignum.adigit-ones?"              (2)   #f ()    0    boolean extended)
("##bignum.adigit-zero?"              (2)   #f ()    0    boolean extended)
("##bignum.adigit-negative?"          (2)   #f ()    0    boolean extended)
("##bignum.adigit-="                  (3)   #f ()    0    boolean extended)
("##bignum.adigit-<"                  (3)   #f ()    0    boolean extended)
("##bignum.make"                      (3)   #f ()    0    integer extended)
("##fixnum->bignum"                   (1)   #f ()    0    integer extended)
("##bignum.adigit-shrink!"            (2)   #t ()    0    #f      extended)
("##bignum.adigit-copy!"              (4)   #t ()    0    #f      extended)
("##bignum.adigit-cat!"               (7)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-and!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-andc1!"     (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-andc2!"     (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-eqv!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-ior!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-nand!"      (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-nor!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-not!"       (2)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-orc1!"      (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-orc2!"      (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-xor!"       (4)   #t ()    0    #f      extended)
("##bignum.fdigit-length"             (1)   #f ()    0    fix>=0  extended)
("##bignum.fdigit-ref"                (2)   #f ()    0    integer extended)
("##bignum.fdigit-set!"               (3)   #t ()    0    #f      extended)

("##ratnum?"                          (1)   #f ()    0    boolean extended)
("##ratnum-make"                      (2)   #f ()    0    number  extended)
("##ratnum-numerator"                 (1)   #f ()    0    integer extended)
("##ratnum-denominator"               (1)   #f ()    0    integer extended)

("##cpxnum?"                          (1)   #f ()    0    boolean extended)
("##cpxnum-make"                      (2)   #f ()    0    number  extended)
("##cpxnum-real"                      (1)   #f ()    0    number  extended)
("##cpxnum-imag"                      (1)   #f ()    0    number  extended)

;; fixnum

("fixnum?"                            (1)   #f 0     0    boolean r6rs)
("##fixnum?"                          (1)   #f ()    0    boolean extended)
("fx*"                                0     #f 0     0    fixnum  r6rs)
("##fx*"                              0     #f ()    0    fixnum  extended)
("##fx*?"                             (2)   #f ()    0    ?fixnum extended)
("fx+"                                0     #f 0     0    fixnum  r6rs)
("##fx+"                              0     #f ()    0    fixnum  extended)
("##fx+?"                             (2)   #f ()    0    ?fixnum extended)
("fx-"                                1     #f 0     0    fixnum  r6rs)
("##fx-"                              1     #f ()    0    fixnum  extended)
("##fx-?"                             (1 2) #f ()    0    ?fixnum extended)
("fx<"                                0     #f 0     0    boolean r6rs)
("##fx<"                              0     #f ()    0    boolean extended)
("fx<="                               0     #f 0     0    boolean r6rs)
("##fx<="                             0     #f ()    0    boolean extended)
("fx="                                0     #f 0     0    boolean r6rs)
("##fx="                              0     #f ()    0    boolean extended)
("fx>"                                0     #f 0     0    boolean r6rs)
("##fx>"                              0     #f ()    0    boolean extended)
("fx>="                               0     #f 0     0    boolean r6rs)
("##fx>="                             0     #f ()    0    boolean extended)
("fxand"                              0     #f 0     0    fixnum  r6rs)
("##fxand"                            0     #f ()    0    fixnum  extended)
("fxandc1"                            (2)   #f 0     0    fixnum  extended)
("##fxandc1"                          (2)   #f ()    0    fixnum  extended)
("fxandc2"                            (2)   #f 0     0    fixnum  extended)
("##fxandc2"                          (2)   #f ()    0    fixnum  extended)
("fxarithmetic-shift"                 (2)   #f 0     0    fixnum  r6rs)
("##fxarithmetic-shift"               (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift?"              (2)   #f ()    0    ?fixnum extended)
("fxarithmetic-shift-left"            (2)   #f 0     0    fixnum  r6rs)
("##fxarithmetic-shift-left"          (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-left?"         (2)   #f ()    0    ?fixnum extended)
("fxarithmetic-shift-right"           (2)   #f 0     0    fixnum  r6rs)
("##fxarithmetic-shift-right"         (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-right?"        (2)   #f ()    0    ?fixnum extended)
("fxbit-count"                        (1)   #f 0     0    fix>=0  r6rs)
("##fxbit-count"                      (1)   #f ()    0    fix>=0  extended)
("fxbit-set?"                         (2)   #f 0     0    boolean r6rs)
("##fxbit-set?"                       (2)   #f ()    0    boolean extended)
("fxeven?"                            (1)   #f 0     0    boolean r6rs)
("##fxeven?"                          (1)   #f ()    0    boolean extended)
("fxeqv"                              0     #f 0     0    fixnum  extended)
("##fxeqv"                            0     #f ()    0    fixnum  extended)
("fxfirst-set-bit"                    (1)   #f 0     0    fix>=-1 r6rs)
("##fxfirst-set-bit"                  (1)   #f ()    0    fix>=-1 extended)
("fxif"                               (3)   #f 0     0    fixnum  r6rs)
("##fxif"                             (3)   #f ()    0    fixnum  extended)
("fxior"                              0     #f 0     0    fixnum  r6rs)
("##fxior"                            0     #f ()    0    fixnum  extended)
("fxlength"                           (1)   #f 0     0    fix>=0  r6rs)
("##fxlength"                         (1)   #f ()    0    fix>=0  extended)
("fxmax"                              1     #f 0     0    fixnum  r6rs)
("##fxmax"                            1     #f ()    0    fixnum  extended)
("fxmin"                              1     #f 0     0    fixnum  r6rs)
("##fxmin"                            1     #f ()    0    fixnum  extended)
("fxmodulo"                           (2)   #f 0     0    fixnum  r6rs)
("##fxmodulo"                         (2)   #f ()    0    fixnum  extended)
("fxnegative?"                        (1)   #f 0     0    boolean r6rs)
("##fxnegative?"                      (1)   #f ()    0    boolean extended)
("fxnand"                             (2)   #f 0     0    fixnum  extended)
("##fxnand"                           (2)   #f ()    0    fixnum  extended)
("fxnor"                              (2)   #f 0     0    fixnum  extended)
("##fxnor"                            (2)   #f ()    0    fixnum  extended)
("fxnot"                              (1)   #f 0     0    fixnum  r6rs)
("##fxnot"                            (1)   #f ()    0    fixnum  extended)
("fxodd?"                             (1)   #f 0     0    boolean r6rs)
("##fxodd?"                           (1)   #f ()    0    boolean extended)
("fxorc1"                             (2)   #f 0     0    fixnum  extended)
("##fxorc1"                           (2)   #f ()    0    fixnum  extended)
("fxorc2"                             (2)   #f 0     0    fixnum  extended)
("##fxorc2"                           (2)   #f ()    0    fixnum  extended)
("fxpositive?"                        (1)   #f 0     0    boolean r6rs)
("##fxpositive?"                      (1)   #f ()    0    boolean extended)
("fxquotient"                         (2)   #f 0     0    fixnum  r6rs)
("##fxquotient"                       (2)   #f ()    0    fixnum  extended)
("fxremainder"                        (2)   #f 0     0    fixnum  r6rs)
("##fxremainder"                      (2)   #f ()    0    fixnum  extended)
("fxxor"                              0     #f 0     0    fixnum  r6rs)
("##fxxor"                            0     #f ()    0    fixnum  extended)
("fxzero?"                            (1)   #f 0     0    boolean r6rs)
("##fxzero?"                          (1)   #f ()    0    boolean extended)

;;R6RS fixnum primitives not yet implemented:
;;(fixnum-width)
;;(least-fixnum)
;;(greatest-fixnum)
;;(fxdiv-and-mod fx1 fx2)
;;(fxdiv fx1 fx2)
;;(fxmod fx1 fx2)
;;(fxdiv0-and-mod0 fx1 fx2)
;;(fxdiv0 fx1 fx2)
;;(fxmod0 fx1 fx2)
;;(fx+/carry fx1 fx2 fx3)
;;(fx-/carry fx1 fx2 fx3)
;;(fx*/carry fx1 fx2 fx3)
;;(fxcopy-bit fx1 fx2 fx3)
;;(fxbit-field fx1 fx2 fx3)
;;(fxcopybit-field fx1 fx2 fx3 fx4)
;;(fxrotate-bit-field fx1 fx2 fx3 fx4)
;;(fxreverse-bit-field fx1 fx2 fx3 fx4)

("fxabs"                              (1)   #f 0     0    fix>=0  gambit)
("##fxabs"                            (1)   #f ()    0    fix>=0  extended)
("##fxabs?"                           (1)   #f ()    0    ?fix>=0 extended)
("fxsquare"                           (1)   #f 0     0    fix>=0  gambit)
("##fxsquare"                         (1)   #f ()    0    fix>=0  extended)
("##fxsquare?"                        (1)   #f ()    0    ?fix>=0 extended)
("fxwrap*"                            0     #f 0     0    fixnum  gambit)
("##fxwrap*"                          0     #f ()    0    fixnum  extended)
("fxwrap+"                            0     #f 0     0    fixnum  gambit)
("##fxwrap+"                          0     #f ()    0    fixnum  extended)
("fxwrap-"                            1     #f 0     0    fixnum  gambit)
("##fxwrap-"                          1     #f ()    0    fixnum  extended)
("fxwrapabs"                          (1)   #f 0     0    fixnum  gambit)
("##fxwrapabs"                        (1)   #f ()    0    fixnum  extended)
("fxwraparithmetic-shift"             (2)   #f 0     0    fixnum  gambit)
("##fxwraparithmetic-shift"           (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift?"          (2)   #f ()    0    ?fixnum extended)
("fxwraparithmetic-shift-left"        (2)   #f 0     0    fixnum  gambit)
("##fxwraparithmetic-shift-left"      (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift-left?"     (2)   #f ()    0    ?fixnum extended)
("fxwraplogical-shift-right"          (2)   #f 0     0    fixnum  gambit)
("##fxwraplogical-shift-right"        (2)   #f ()    0    fixnum  extended)
("##fxwraplogical-shift-right?"       (2)   #f ()    0    ?fixnum extended)
("fxwrapquotient"                     (2)   #f 0     0    fixnum  gambit)
("##fxwrapquotient"                   (2)   #f ()    0    fixnum  extended)
("fxwrapsquare"                       (1)   #f 0     0    fixnum  gambit)
("##fxwrapsquare"                     (1)   #f ()    0    fixnum  extended)

;; flonum

("fixnum->flonum"                     (1)   #f 0     0    flonum  r6rs)
("##fixnum->flonum"                   (1)   #f ()    0    flonum  extended)
("fl*"                                0     #f 0     0    flonum  r6rs)
("##fl*"                              0     #f ()    0    flonum  extended)
("fl+"                                0     #f 0     0    flonum  r6rs)
("##fl+"                              0     #f ()    0    flonum  extended)
("fl-"                                1     #f 0     0    flonum  r6rs)
("##fl-"                              1     #f ()    0    flonum  extended)
("fl/"                                1     #f 0     0    flonum  r6rs)
("##fl/"                              1     #f ()    0    flonum  extended)
("fl<"                                0     #f 0     0    boolean r6rs)
("##fl<"                              0     #f ()    0    boolean extended)
("fl<="                               0     #f 0     0    boolean r6rs)
("##fl<="                             0     #f ()    0    boolean extended)
("fl="                                0     #f 0     0    boolean r6rs)
("##fl="                              0     #f ()    0    boolean extended)
("fl>"                                0     #f 0     0    boolean r6rs)
("##fl>"                              0     #f ()    0    boolean extended)
("fl>="                               0     #f 0     0    boolean r6rs)
("##fl>="                             0     #f ()    0    boolean extended)
("flabs"                              (1)   #f 0     0    flonum  r6rs)
("##flabs"                            (1)   #f ()    0    flonum  extended)
("flacos"                             (1)   #f 0     0    flonum  r6rs)
("##flacos"                           (1)   #f ()    0    flonum  extended)
("flasin"                             (1)   #f 0     0    flonum  r6rs)
("##flasin"                           (1)   #f ()    0    flonum  extended)
("flatan"                             (1 2) #f 0     0    flonum  r6rs)
("##flatan"                           (1 2) #f ()    0    flonum  extended)
("flceiling"                          (1)   #f 0     0    flonum  r6rs)
("##flceiling"                        (1)   #f ()    0    flonum  extended)
("flcos"                              (1)   #f 0     0    flonum  r6rs)
("##flcos"                            (1)   #f ()    0    flonum  extended)
("fldenominator"                      (1)   #f 0     0    flonum  r6rs)
("##fldenominator"                    (1)   #f ()    0    flonum  extended)
("fleven?"                            (1)   #f 0     0    boolean r6rs)
("##fleven?"                          (1)   #f ()    0    boolean extended)
("flexp"                              (1)   #f 0     0    flonum  r6rs)
("##flexp"                            (1)   #f ()    0    flonum  extended)
("flexpt"                             (2)   #f 0     0    flonum  r6rs)
("##flexpt"                           (2)   #f ()    0    flonum  extended)
("flfinite?"                          (1)   #f 0     0    boolean r6rs)
("##flfinite?"                        (1)   #f ()    0    boolean extended)
("flfloor"                            (1)   #f 0     0    flonum  r6rs)
("##flfloor"                          (1)   #f ()    0    flonum  extended)
("flinfinite?"                        (1)   #f 0     0    boolean r6rs)
("##flinfinite?"                      (1)   #f ()    0    boolean extended)
("flinteger?"                         (1)   #f 0     0    boolean r6rs)
("##flinteger?"                       (1)   #f ()    0    boolean extended)
("fllog"                              (1 2) #f 0     0    flonum  r6rs)
("##fllog"                            (1 2) #f ()    0    flonum  extended)
("flmax"                              1     #f 0     0    flonum  r6rs)
("##flmax"                            1     #f ()    0    flonum  extended)
("flmin"                              1     #f 0     0    flonum  r6rs)
("##flmin"                            1     #f ()    0    flonum  extended)
("flnan?"                             (1)   #f 0     0    boolean r6rs)
("##flnan?"                           (1)   #f ()    0    boolean extended)
("flnegative?"                        (1)   #f 0     0    boolean r6rs)
("##flnegative?"                      (1)   #f ()    0    boolean extended)
("flnumerator"                        (1)   #f 0     0    flonum  r6rs)
("##flnumerator"                      (1)   #f ()    0    flonum  extended)
("flodd?"                             (1)   #f 0     0    boolean r6rs)
("##flodd?"                           (1)   #f ()    0    boolean extended)
("flonum?"                            (1)   #f 0     0    boolean r6rs)
("##flonum?"                          (1)   #f ()    0    boolean extended)
("flpositive?"                        (1)   #f 0     0    boolean r6rs)
("##flpositive?"                      (1)   #f ()    0    boolean extended)
("flround"                            (1)   #f 0     0    flonum  r6rs)
("##flround"                          (1)   #f ()    0    flonum  extended)
("flsin"                              (1)   #f 0     0    flonum  r6rs)
("##flsin"                            (1)   #f ()    0    flonum  extended)
("flsqrt"                             (1)   #f 0     0    flonum  r6rs)
("##flsqrt"                           (1)   #f ()    0    flonum  extended)
("fltan"                              (1)   #f 0     0    flonum  r6rs)
("##fltan"                            (1)   #f ()    0    flonum  extended)
("fltruncate"                         (1)   #f 0     0    flonum  r6rs)
("##fltruncate"                       (1)   #f ()    0    flonum  extended)
("flzero?"                            (1)   #f 0     0    boolean r6rs)
("##flzero?"                          (1)   #f ()    0    boolean extended)

;;R6RS flonum primitives not yet implemented:
;;(fldiv-and-mod fl1 fl2)
;;(fldiv fl1 fl2)
;;(flmod fl1 fl2)
;;(fldiv0-and-mod0 fl1 fl2)
;;(fldiv0 fl1 fl2)
;;(flmod0 fl1 fl2)

("flacosh"                            (1)   #f 0     0    flonum  gambit)
("##flacosh"                          (1)   #f ()    0    flonum  extended)
("flasinh"                            (1)   #f 0     0    flonum  gambit)
("##flasinh"                          (1)   #f ()    0    flonum  extended)
("flatanh"                            (1)   #f 0     0    flonum  gambit)
("##flatanh"                          (1)   #f ()    0    flonum  extended)
("flcosh"                             (1)   #f 0     0    flonum  gambit)
("##flcosh"                           (1)   #f ()    0    flonum  extended)
("flexpm1"                            (1)   #f 0     0    flonum  gambit)
("##flexpm1"                          (1)   #f ()    0    flonum  extended)
("flhypot"                            (2)   #f 0     0    flonum  gambit)
("##flhypot"                          (2)   #f ()    0    flonum  extended)
("flilogb"                            (1)   #f 0     0    fixnum  gambit)
("##flilogb"                          (1)   #f ()    0    flonum  extended)
("fllog1p"                            (1)   #f 0     0    flonum  gambit)
("##fllog1p"                          (1)   #f ()    0    flonum  extended)
("flscalbn"                           (2)   #f 0     0    flonum  gambit)
("##flscalbn"                         (2)   #f ()    0    flonum  extended)
("flsinh"                             (1)   #f 0     0    flonum  gambit)
("##flsinh"                           (1)   #f ()    0    flonum  extended)
("flsquare"                           (1)   #f 0     0    flonum  gambit)
("##flsquare"                         (1)   #f ()    0    flonum  extended)
("fltanh"                             (1)   #f 0     0    flonum  gambit)
("##fltanh"                           (1)   #f ()    0    flonum  extended)

("##fixnum->flonum-exact?"            (1)   #f ()    0    boolean extended)
("##flonum->fixnum"                   (1)   #f ()    0    fixnum  extended)
("##flonum->string-host"              (1)   #f ()    0    string  extended)
("##flcopysign"                       (2)   #f ()    0    flonum  extended)
("##fleqv?"                           (2)   #f ()    0    boolean extended)

;; list

("append"                             0     #f 0     0    list    ieee)
("##append"                           0     #f ()    0    list    extended)
("assoc"                              (2)   #f 0     0    #f      ieee)
("##assoc"                            (2)   #f ()    0    #f      extended)
("assq"                               (2)   #f 0     0    #f      ieee)
("##assq"                             (2)   #f ()    0    #f      extended)
("assv"                               (2)   #f 0     0    #f      ieee)
("##assv"                             (2)   #f ()    0    #f      extended)
("caaaar"                             (1)   #f 0     0    (#f)    ieee)
("##caaaar"                           (1)   #f ()    0    (#f)    extended)
("caaadr"                             (1)   #f 0     0    (#f)    ieee)
("##caaadr"                           (1)   #f ()    0    (#f)    extended)
("caaar"                              (1)   #f 0     0    (#f)    ieee)
("##caaar"                            (1)   #f ()    0    (#f)    extended)
("caadar"                             (1)   #f 0     0    (#f)    ieee)
("##caadar"                           (1)   #f ()    0    (#f)    extended)
("caaddr"                             (1)   #f 0     0    (#f)    ieee)
("##caaddr"                           (1)   #f ()    0    (#f)    extended)
("caadr"                              (1)   #f 0     0    (#f)    ieee)
("##caadr"                            (1)   #f ()    0    (#f)    extended)
("caar"                               (1)   #f 0     0    (#f)    ieee)
("##caar"                             (1)   #f ()    0    (#f)    extended)
("cadaar"                             (1)   #f 0     0    (#f)    ieee)
("##cadaar"                           (1)   #f ()    0    (#f)    extended)
("cadadr"                             (1)   #f 0     0    (#f)    ieee)
("##cadadr"                           (1)   #f ()    0    (#f)    extended)
("cadar"                              (1)   #f 0     0    (#f)    ieee)
("##cadar"                            (1)   #f ()    0    (#f)    extended)
("caddar"                             (1)   #f 0     0    (#f)    ieee)
("##caddar"                           (1)   #f ()    0    (#f)    extended)
("cadddr"                             (1)   #f 0     0    (#f)    ieee)
("##cadddr"                           (1)   #f ()    0    (#f)    extended)
("caddr"                              (1)   #f 0     0    (#f)    ieee)
("##caddr"                            (1)   #f ()    0    (#f)    extended)
("cadr"                               (1)   #f 0     0    (#f)    ieee)
("##cadr"                             (1)   #f ()    0    (#f)    extended)
("car"                                (1)   #f 0     0    (#f)    ieee)
("##car"                              (1)   #f ()    0    (#f)    extended)
("cdaaar"                             (1)   #f 0     0    (#f)    ieee)
("##cdaaar"                           (1)   #f ()    0    (#f)    extended)
("cdaadr"                             (1)   #f 0     0    (#f)    ieee)
("##cdaadr"                           (1)   #f ()    0    (#f)    extended)
("cdaar"                              (1)   #f 0     0    (#f)    ieee)
("##cdaar"                            (1)   #f ()    0    (#f)    extended)
("cdadar"                             (1)   #f 0     0    (#f)    ieee)
("##cdadar"                           (1)   #f ()    0    (#f)    extended)
("cdaddr"                             (1)   #f 0     0    (#f)    ieee)
("##cdaddr"                           (1)   #f ()    0    (#f)    extended)
("cdadr"                              (1)   #f 0     0    (#f)    ieee)
("##cdadr"                            (1)   #f ()    0    (#f)    extended)
("cdar"                               (1)   #f 0     0    (#f)    ieee)
("##cdar"                             (1)   #f ()    0    (#f)    extended)
("cddaar"                             (1)   #f 0     0    (#f)    ieee)
("##cddaar"                           (1)   #f ()    0    (#f)    extended)
("cddadr"                             (1)   #f 0     0    (#f)    ieee)
("##cddadr"                           (1)   #f ()    0    (#f)    extended)
("cddar"                              (1)   #f 0     0    (#f)    ieee)
("##cddar"                            (1)   #f ()    0    (#f)    extended)
("cdddar"                             (1)   #f 0     0    (#f)    ieee)
("##cdddar"                           (1)   #f ()    0    (#f)    extended)
("cddddr"                             (1)   #f 0     0    (#f)    ieee)
("##cddddr"                           (1)   #f ()    0    (#f)    extended)
("cdddr"                              (1)   #f 0     0    (#f)    ieee)
("##cdddr"                            (1)   #f ()    0    (#f)    extended)
("cddr"                               (1)   #f 0     0    (#f)    ieee)
("##cddr"                             (1)   #f ()    0    (#f)    extended)
("cdr"                                (1)   #f 0     0    (#f)    ieee)
("##cdr"                              (1)   #f ()    0    (#f)    extended)
("cons"                               (2)   #f ()    0    pair    ieee)
("##cons"                             (2)   #f ()    0    pair    extended)
("length"                             (1)   #f 0     0    fix>=0  ieee)
("##length"                           (1)   #f ()    0    fix>=0  extended)
("list"                               0     #f ()    0    list    ieee)
("##list"                             0     #f ()    0    list    extended)
("list-ref"                           (2)   #f 0     0    (#f)    ieee)
("##list-ref"                         (2)   #f ()    0    (#f)    extended)
("list?"                              (1)   #f 0     0    boolean ieee)
("##list?"                            (1)   #f ()    0    boolean extended)
("member"                             (2)   #f 0     0    list    ieee)
("##member"                           (2)   #f ()    0    list    extended)
("memq"                               (2)   #f 0     0    list    ieee)
("##memq"                             (2)   #f ()    0    list    extended)
("memv"                               (2)   #f 0     0    list    ieee)
("##memv"                             (2)   #f ()    0    list    extended)
("null?"                              (1)   #f 0     0    boolean ieee)
("##null?"                            (1)   #f ()    0    boolean extended)
("pair?"                              (1)   #f 0     0    boolean ieee)
("##pair?"                            (1)   #f ()    0    boolean extended)
("reverse"                            (1)   #f 0     0    list    ieee)
("##reverse"                          (1)   #f ()    0    list    extended)
("set-car!"                           (2)   #t (1)   0    pair    ieee)
("##set-car!"                         (2)   #t ()    0    pair    extended)
("set-cdr!"                           (2)   #t (1)   0    pair    ieee)
("##set-cdr!"                         (2)   #t ()    0    pair    extended)

("list-tail"                          (2)   #f 0     0    (#f)    r4rs)
("##list-tail"                        (2)   #f ()    0    (#f)    extended)

("make-list"                          (1 2) #f (1)   0    list    r7rs)
("##make-list"                        (1 2) #f ()    0    list    extended)
("list-copy"                          (1)   #f 0     0    list    r7rs)
("##list-copy"                        (1)   #f ()    0    list    extended)
("list-set!"                          (3)   #t (1 2) 0    #f      r7rs)
("##list-set!"                        (3)   #t ()    0    #f      extended)

("circular-list"                      1     #f ()    0    list    gambit)
("##circular-list"                    1     #f ()    0    list    extended)
("cons*"                              1     #f ()    0    #f      gambit)
("##cons*"                            1     #f ()    0    #f      extended)
("drop"                               (2)   #f 0     0    list    gambit)
("##drop"                             (2)   #f ()    0    list    extended)
("fold"                               3     #t (1 . 3) 0  (#f)    gambit)
("##fold"                             3     #t ()    0    (#f)    extended)
("fold-right"                         3     #t (1 . 3) 0  (#f)    gambit)
("##fold-right"                       3     #t ()    0    (#f)    extended)
("iota"                               (1 2 3) #f 0   0    list    gambit)
("##iota"                             (1 2 3) #f ()  0    list    extended)
("last"                               (1)   #f 0     0    (#f)    gambit)
("##last"                             (1)   #f ()    0    (#f)    extended)
("last-pair"                          (1)   #f 0     0    pair    gambit)
("##last-pair"                        (1)   #f ()    0    pair    extended)
("list-set"                           (3)   #f (1 2) 0    pair    gambit)
("##list-set"                         (3)   #f ()    0    pair    extended)
("list-tabulate"                      (2)   #t 0     0    list    gambit)
("##list-tabulate"                    (2)   #t ()    0    list    extended)
("reverse!"                           (1)   #t 0     0    list    gambit)
("##reverse!"                         (1)   #t ()    0    list    extended)
("take"                               (2)   #f 0     0    list    gambit)
("##take"                             (2)   #f ()    0    list    extended)
("xcons"                              (2)   #f ()    0    pair    gambit)
("##xcons"                            (2)   #f ()    0    pair    extended)

;; char

("char->integer"                      (1)   #f 0     0    fix>=0  ieee)
("##char->integer"                    (1)   #f ()    0    fix>=0  extended)
("char-alphabetic?"                   (1)   #f 0     0    boolean ieee)
("##char-alphabetic?"                 (1)   #f ()    0    boolean extended)
("char-ci<=?"                         0     #f 0     0    boolean ieee)
("##char-ci<=?"                       0     #f ()    0    boolean extended)
("char-ci<?"                          0     #f 0     0    boolean ieee)
("##char-ci<?"                        0     #f ()    0    boolean extended)
("char-ci=?"                          0     #f 0     0    boolean ieee)
("##char-ci=?"                        0     #f ()    0    boolean extended)
("char-ci>=?"                         0     #f 0     0    boolean ieee)
("##char-ci>=?"                       0     #f ()    0    boolean extended)
("char-ci>?"                          0     #f 0     0    boolean ieee)
("##char-ci>?"                        0     #f ()    0    boolean extended)
("char-downcase"                      (1)   #f 0     0    char    ieee)
("##char-downcase"                    (1)   #f ()    0    char    extended)
("char-lower-case?"                   (1)   #f 0     0    boolean ieee)
("##char-lower-case?"                 (1)   #f ()    0    boolean extended)
("char-numeric?"                      (1)   #f 0     0    boolean ieee)
("##char-numeric?"                    (1)   #f ()    0    boolean extended)
("char-upcase"                        (1)   #f 0     0    char    ieee)
("##char-upcase"                      (1)   #f ()    0    char    extended)
("char-upper-case?"                   (1)   #f 0     0    boolean ieee)
("##char-upper-case?"                 (1)   #f ()    0    boolean extended)
("char-whitespace?"                   (1)   #f 0     0    boolean ieee)
("##char-whitespace?"                 (1)   #f ()    0    boolean extended)
("char<=?"                            0     #f 0     0    boolean ieee)
("##char<=?"                          0     #f ()    0    boolean extended)
("char<?"                             0     #f 0     0    boolean ieee)
("##char<?"                           0     #f ()    0    boolean extended)
("char=?"                             0     #f 0     0    boolean ieee)
("##char=?"                           0     #f ()    0    boolean extended)
("char>=?"                            0     #f 0     0    boolean ieee)
("##char>=?"                          0     #f ()    0    boolean extended)
("char>?"                             0     #f 0     0    boolean ieee)
("##char>?"                           0     #f ()    0    boolean extended)
("char?"                              (1)   #f 0     0    boolean ieee)
("##char?"                            (1)   #f ()    0    boolean extended)
("integer->char"                      (1)   #f 0     0    char    ieee)
("##integer->char"                    (1)   #f ()    0    char    extended)

("char-foldcase"                      (1)   #f 0     0    char    r7rs)
("##char-foldcase"                    (1)   #f ()    0    char    extended)
("digit-value"                        (1)   #f 0     0    ?fix>=0<=9 r7rs)
("##digit-value"                      (1)   #f ()    0    ?fix>=0<=9 extended)

;; string

("list->string"                       (1)   #f 0     0    string    r4rs)
("##list->string"                     (1)   #f ()    0    string    extended)
("make-string"                        (1 2) #f 0     0    string    ieee)
("##make-string"                      (1 2) #f ()    0    string    extended)
("##make-string-small"                (1 2) #f ()    0    string    extended)
("substring"                          (3)   #f 0     0    string    ieee)
("##substring"                        (3)   #f ()    0    string    extended)
("##substring-small"                  (3)   #f ()    0    string    extended)
("string"                             0     #f 0     0    string    ieee)
("##string"                           0     #f ()    0    string    extended)
("string->list"                       (1)   #f 0     0    list      r4rs)
("##string->list"                     (1)   #f ()    0    list      extended)
("string-append"                      0     #f 0     0    string    ieee)
("##string-append"                    0     #f ()    0    string    extended)
("string-copy"                        (1 2 3)#f 0    0    string    r4rs)
("##string-copy"                      (1 2 3)#f ()   0    string    extended)
("##string-copy-small"                (1 2 3)#f ()   0    string    extended)
("string-fill!"                       (2 3 4)#t 0    0    #f        r4rs)
("##string-fill!"                     (2 3 4)#t ()   0    #f        extended)
("string-length"                      (1)   #f 0     0    fix>=0    ieee)
("##string-length"                    (1)   #f ()    0    fix>=0    extended)
("string-ref"                         (2)   #f 0     0    char      ieee)
("##string-ref"                       (2)   #f ()    0    char      extended)
("string-set!"                        (3)   #t 0     0    #f        ieee)
("##string-set!"                      (3)   #t ()    0    string    extended)
("string?"                            (1)   #f 0     0    boolean   ieee)
("##string?"                          (1)   #f ()    0    boolean   extended)
("string<=?"                          0     #f 0     0    boolean   ieee)
("##string<=?"                        0     #f ()    0    boolean   extended)
("string<?"                           0     #f 0     0    boolean   ieee)
("##string<?"                         0     #f ()    0    boolean   extended)
("string=?"                           0     #f 0     0    boolean   ieee)
("##string=?"                         0     #f ()    0    boolean   extended)
("string>=?"                          0     #f 0     0    boolean   ieee)
("##string>=?"                        0     #f ()    0    boolean   extended)
("string>?"                           0     #f 0     0    boolean   ieee)
("##string>?"                         0     #f ()    0    boolean   extended)
("string-ci<=?"                       0     #f 0     0    boolean   ieee)
("##string-ci<=?"                     0     #f ()    0    boolean   extended)
("string-ci<?"                        0     #f 0     0    boolean   ieee)
("##string-ci<?"                      0     #f ()    0    boolean   extended)
("string-ci=?"                        0     #f 0     0    boolean   ieee)
("##string-ci=?"                      0     #f ()    0    boolean   extended)
("string-ci>=?"                       0     #f 0     0    boolean   ieee)
("##string-ci>=?"                     0     #f ()    0    boolean   extended)
("string-ci>?"                        0     #f 0     0    boolean   ieee)
("##string-ci>?"                      0     #f ()    0    boolean   extended)

("utf8->string"                       (1)   #f 0     0    string    r7rs)
("##utf8->string"                     (1)   #f ()    0    string    extended)
("string->utf8"                       (1)   #f 0     0    u8vector  r7rs)
("##string->utf8"                     (1)   #f ()    0    u8vector  extended)
("string-copy!"                       (3 4 5)#t 0    0    #f        r7rs)
("##string-copy!"                     (3 4 5)#t ()   0    string    extended)
("##string-insert"                    (3)   #f ()    0    string    extended)
("##string-insert-small"              (3)   #f ()    0    string    extended)
("##string-delete"                    (2)   #f ()    0    string    extended)
("##string-delete-small"              (2)   #f ()    0    string    extended)
("string-foldcase"                    (1)   #f 0     0    string    r7rs)
("##string-foldcase"                  (1)   #f ()    0    string    extended)
("string-upcase"                      (1)   #f 0     0    string    r7rs)
("##string-upcase"                    (1)   #f ()    0    string    extended)
("string-downcase"                    (1)   #f 0     0    string    r7rs)
("##string-downcase"                  (1)   #f ()    0    string    extended)

("string-concatenate"                 (1 2) #f 0     0    string    gambit)
("##string-concatenate"               (1 2) #f ()    0    string    extended)
("substring-fill!"                    (4)   #t 0     0    #f        gambit)
("##substring-fill!"                  (4)   #t ()    0    #f        extended)
("substring-move!"                    (5)   #t 0     0    #f        gambit)
("##substring-move!"                  (5)   #t ()    0    string    extended)
("string-set"                         (3)   #f 0     0    string    gambit)
("##string-set"                       (3)   #f ()    0    string    extended)
("##string-set-small"                 (3)   #f ()    0    string    extended)
("string-shrink!"                     (2)   #t 0     0    #f        gambit)
("##string-shrink!"                   (2)   #t ()    0    string    extended)

;; vector

("list->vector"                       (1)   #f 0     0    vector    r4rs)
("##list->vector"                     (1)   #f ()    0    vector    extended)
("make-vector"                        (1 2) #f (1)   0    vector    ieee)
("##make-vector"                      (1 2) #f ()    0    vector    extended)
("##make-vector-small"                (1 2) #f ()    0    vector    extended)
("vector"                             0     #f ()    0    vector    ieee)
("##vector"                           0     #f ()    0    vector    extended)
("vector->list"                       (1)   #f 0     0    list      r4rs)
("##vector->list"                     (1)   #f ()    0    list      extended)
("vector-fill!"                       (2 3 4)#t 0    0    #f        r4rs)
("##vector-fill!"                     (2 3 4)#t ()   0    #f        extended)
("vector-length"                      (1)   #f 0     0    fix>=0    ieee)
("##vector-length"                    (1)   #f ()    0    fix>=0    extended)
("vector-ref"                         (2)   #f 0     0    (#f)      ieee)
("##vector-ref"                       (2)   #f ()    0    (#f)      extended)
("vector-set!"                        (3)   #t 0     0    #f        ieee)
("##vector-set!"                      (3)   #t ()    0    vector    extended)
("vector?"                            (1)   #f 0     0    boolean   ieee)
("##vector?"                          (1)   #f ()    0    boolean   extended)

("vector-append"                      0     #f 0     0    vector    r7rs)
("##vector-append"                    0     #f ()    0    vector    extended)
("vector-copy"                        (1 2 3)#f 0    0    vector    r7rs)
("##vector-copy"                      (1 2 3)#f ()   0    vector    extended)
("##vector-copy-small"                (1 2 3)#f ()   0    vector    extended)
("vector-copy!"                       (3 4 5)#t 0    0    #f        r7rs)
("##vector-copy!"                     (3 4 5)#t ()   0    vector    extended)
("##vector-insert"                    (3)   #f ()    0    vector    extended)
("##vector-insert-small"              (3)   #f ()    0    vector    extended)
("##vector-delete"                    (2)   #f ()    0    vector    extended)
("##vector-delete-small"              (2)   #f ()    0    vector    extended)

("vector-concatenate"                 (1 2) #f 0     0    vector    gambit)
("##vector-concatenate"               (1 2) #f ()    0    vector    extended)
("subvector"                          (3)   #f 0     0    vector    gambit)
("##subvector"                        (3)   #f ()    0    vector    extended)
("##subvector-small"                  (3)   #f ()    0    vector    extended)
("subvector-fill!"                    (4)   #t 0     0    #f        gambit)
("##subvector-fill!"                  (4)   #t ()    0    #f        extended)
("subvector-move!"                    (5)   #t 0     0    #f        gambit)
("##subvector-move!"                  (5)   #t ()    0    vector    extended)
("vector-cas!"                        (4)   #t (1 2 4) 0  #f        gambit)
("##vector-cas!"                      (4)   #t ()      0  #f        extended)
("vector-inc!"                        (2 3) #t 0     0    fixnum    gambit)
("##vector-inc!"                      (2 3) #t ()    0    fixnum    extended)
("vector-set"                         (3)   #f 0     0    vector    gambit)
("##vector-set"                       (3)   #f ()    0    vector    extended)
("##vector-set-small"                 (3)   #f ()    0    vector    extended)
("vector-shrink!"                     (2)   #t 0     0    #f        gambit)
("##vector-shrink!"                   (2)   #t ()    0    vector    extended)

;; homogeneous vector

("s8vector-concatenate"               (1 2) #f 0     0    s8vector  gambit)
("##s8vector-concatenate"             (1 2) #f ()    0    s8vector  extended)
("list->s8vector"                     (1)   #f 0     0    s8vector  gambit)
("##list->s8vector"                   (1)   #f ()    0    s8vector  extended)
("make-s8vector"                      (1 2) #f 0     0    s8vector  gambit)
("##make-s8vector"                    (1 2) #f ()    0    s8vector  extended)
("##make-s8vector-small"              (1 2) #f ()    0    s8vector  extended)
("subs8vector"                        (3)   #f 0     0    s8vector  gambit)
("##subs8vector"                      (3)   #f ()    0    s8vector  extended)
("##subs8vector-small"                (3)   #f ()    0    s8vector  extended)
("subs8vector-fill!"                  (4)   #t 0     0    #f        gambit)
("##subs8vector-fill!"                (4)   #t ()    0    #f        extended)
("subs8vector-move!"                  (5)   #t 0     0    #f        gambit)
("##subs8vector-move!"                (5)   #t ()    0    s8vector  extended)
("s8vector"                           0     #f 0     0    s8vector  gambit)
("##s8vector"                         0     #f ()    0    s8vector  extended)
("s8vector->list"                     (1)   #f 0     0    list      gambit)
("##s8vector->list"                   (1)   #f ()    0    list      extended)
("s8vector-append"                    0     #f 0     0    s8vector  gambit)
("##s8vector-append"                  0     #f ()    0    s8vector  extended)
("s8vector-copy"                      (1 2 3)#f 0    0    s8vector  gambit)
("##s8vector-copy"                    (1 2 3)#f ()   0    s8vector  extended)
("##s8vector-copy-small"              (1 2 3)#f ()   0    s8vector  extended)
("s8vector-copy!"                     (3 4 5)#t 0    0    #f        gambit)
("##s8vector-copy!"                   (3 4 5)#t ()   0    s8vector  extended)
("s8vector-fill!"                     (2 3 4)#t 0    0    #f        gambit)
("##s8vector-fill!"                   (2 3 4)#t ()   0    #f        extended)
("s8vector-length"                    (1)   #f 0     0    fix>=0    gambit)
("##s8vector-length"                  (1)   #f ()    0    fix>=0    extended)
("s8vector-ref"                       (2)   #f 0     0    s8        gambit)
("##s8vector-ref"                     (2)   #f ()    0    s8        extended)
("s8vector-set"                       (3)   #f 0     0    s8vector  gambit)
("##s8vector-set"                     (3)   #f ()    0    s8vector  extended)
("##s8vector-set-small"               (3)   #f ()    0    s8vector  extended)
("s8vector-set!"                      (3)   #t 0     0    #f        gambit)
("##s8vector-set!"                    (3)   #t ()    0    s8vector  extended)
("s8vector-shrink!"                   (2)   #t 0     0    #f        gambit)
("##s8vector-shrink!"                 (2)   #t ()    0    s8vector  extended)
("s8vector?"                          (1)   #f 0     0    boolean   gambit)
("##s8vector?"                        (1)   #f ()    0    boolean   extended)
("##s8vector-insert"                  (3)   #f ()    0    s8vector  extended)
("##s8vector-insert-small"            (3)   #f ()    0    s8vector  extended)
("##s8vector-delete"                  (2)   #f ()    0    s8vector  extended)
("##s8vector-delete-small"            (2)   #f ()    0    s8vector  extended)

("u8vector-concatenate"               (1 2) #f 0     0    u8vector  gambit)
("##u8vector-concatenate"             (1 2) #f ()    0    u8vector  extended)
("list->u8vector"                     (1)   #f 0     0    u8vector  gambit)
("##list->u8vector"                   (1)   #f ()    0    u8vector  extended)
("make-u8vector"                      (1 2) #f 0     0    u8vector  gambit)
("##make-u8vector"                    (1 2) #f ()    0    u8vector  extended)
("##make-u8vector-small"              (1 2) #f ()    0    u8vector  extended)
("subu8vector"                        (3)   #f 0     0    u8vector  gambit)
("##subu8vector"                      (3)   #f ()    0    u8vector  extended)
("##subu8vector-small"                (3)   #f ()    0    u8vector  extended)
("subu8vector-fill!"                  (4)   #t 0     0    #f        gambit)
("##subu8vector-fill!"                (4)   #t ()    0    #f        extended)
("subu8vector-move!"                  (5)   #t 0     0    #f        gambit)
("##subu8vector-move!"                (5)   #t ()    0    u8vector  extended)
("u8vector"                           0     #f 0     0    u8vector  gambit)
("##u8vector"                         0     #f ()    0    u8vector  extended)
("u8vector->list"                     (1)   #f 0     0    list      gambit)
("##u8vector->list"                   (1)   #f ()    0    list      extended)
("u8vector-append"                    0     #f 0     0    u8vector  gambit)
("##u8vector-append"                  0     #f ()    0    u8vector  extended)
("u8vector-copy"                      (1 2 3)#f 0    0    u8vector  gambit)
("##u8vector-copy"                    (1 2 3)#f ()   0    u8vector  extended)
("##u8vector-copy-small"              (1 2 3)#f ()   0    u8vector  extended)
("u8vector-copy!"                     (3 4 5)#t 0    0    #f        gambit)
("##u8vector-copy!"                   (3 4 5)#t ()   0    u8vector  extended)
("u8vector-fill!"                     (2 3 4)#t 0    0    #f        gambit)
("##u8vector-fill!"                   (2 3 4)#t ()   0    #f        extended)
("u8vector-length"                    (1)   #f 0     0    fix>=0    gambit)
("##u8vector-length"                  (1)   #f ()    0    fix>=0    extended)
("u8vector-ref"                       (2)   #f 0     0    u8        gambit)
("##u8vector-ref"                     (2)   #f ()    0    u8        extended)
("u8vector-set"                       (3)   #f 0     0    u8vector  gambit)
("##u8vector-set"                     (3)   #f ()    0    u8vector  extended)
("##u8vector-set-small"               (3)   #f ()    0    u8vector  extended)
("u8vector-set!"                      (3)   #t 0     0    #f        gambit)
("##u8vector-set!"                    (3)   #t ()    0    u8vector  extended)
("u8vector-shrink!"                   (2)   #t 0     0    #f        gambit)
("##u8vector-shrink!"                 (2)   #t ()    0    u8vector  extended)
("u8vector?"                          (1)   #f 0     0    boolean   gambit)
("##u8vector?"                        (1)   #f ()    0    boolean   extended)
("##u8vector-insert"                  (3)   #f ()    0    u8vector  extended)
("##u8vector-insert-small"            (3)   #f ()    0    u8vector  extended)
("##u8vector-delete"                  (2)   #f ()    0    u8vector  extended)
("##u8vector-delete-small"            (2)   #f ()    0    u8vector  extended)

("s16vector-concatenate"              (1 2) #f 0     0    s16vector gambit)
("##s16vector-concatenate"            (1 2) #f ()    0    s16vector extended)
("list->s16vector"                    (1)   #f 0     0    s16vector gambit)
("##list->s16vector"                  (1)   #f ()    0    s16vector extended)
("make-s16vector"                     (1 2) #f 0     0    s16vector gambit)
("##make-s16vector"                   (1 2) #f ()    0    s16vector extended)
("##make-s16vector-small"             (1 2) #f ()    0    s16vector extended)
("subs16vector"                       (3)   #f 0     0    s16vector gambit)
("##subs16vector"                     (3)   #f ()    0    s16vector extended)
("##subs16vector-small"               (3)   #f ()    0    s16vector extended)
("subs16vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subs16vector-fill!"               (4)   #t ()    0    #f        extended)
("subs16vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subs16vector-move!"               (5)   #t ()    0    s16vector extended)
("s16vector"                          0     #f 0     0    s16vector gambit)
("##s16vector"                        0     #f ()    0    s16vector extended)
("s16vector->list"                    (1)   #f 0     0    list      gambit)
("##s16vector->list"                  (1)   #f ()    0    list      extended)
("s16vector-append"                   0     #f 0     0    s16vector gambit)
("##s16vector-append"                 0     #f ()    0    s16vector extended)
("s16vector-copy"                     (1 2 3)#f 0    0    s16vector gambit)
("##s16vector-copy"                   (1 2 3)#f ()   0    s16vector extended)
("##s16vector-copy-small"             (1 2 3)#f ()   0    s16vector extended)
("s16vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##s16vector-copy!"                  (3 4 5)#t ()   0    s16vector extended)
("s16vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##s16vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("s16vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##s16vector-length"                 (1)   #f ()    0    fix>=0    extended)
("s16vector-ref"                      (2)   #f 0     0    s16       gambit)
("##s16vector-ref"                    (2)   #f ()    0    s16       extended)
("s16vector-set"                      (3)   #f 0     0    s16vector gambit)
("##s16vector-set"                    (3)   #f ()    0    s16vector extended)
("##s16vector-set-small"              (3)   #f ()    0    s16vector extended)
("s16vector-set!"                     (3)   #t 0     0    #f        gambit)
("##s16vector-set!"                   (3)   #t ()    0    s16vector extended)
("s16vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##s16vector-shrink!"                (2)   #t ()    0    s16vector extended)
("s16vector?"                         (1)   #f 0     0    boolean   gambit)
("##s16vector?"                       (1)   #f ()    0    boolean   extended)
("##s16vector-insert"                 (3)   #f ()    0    s16vector extended)
("##s16vector-insert-small"           (3)   #f ()    0    s16vector extended)
("##s16vector-delete"                 (2)   #f ()    0    s16vector extended)
("##s16vector-delete-small"           (2)   #f ()    0    s16vector extended)

("u16vector-concatenate"              (1 2) #f 0     0    u16vector gambit)
("##u16vector-concatenate"            (1 2) #f ()    0    u16vector extended)
("list->u16vector"                    (1)   #f 0     0    u16vector gambit)
("##list->u16vector"                  (1)   #f ()    0    u16vector extended)
("make-u16vector"                     (1 2) #f 0     0    u16vector gambit)
("##make-u16vector"                   (1 2) #f ()    0    u16vector extended)
("##make-u16vector-small"             (1 2) #f ()    0    u16vector extended)
("subu16vector"                       (3)   #f 0     0    u16vector gambit)
("##subu16vector"                     (3)   #f ()    0    u16vector extended)
("##subu16vector-small"               (3)   #f ()    0    u16vector extended)
("subu16vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subu16vector-fill!"               (4)   #t ()    0    #f        extended)
("subu16vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subu16vector-move!"               (5)   #t ()    0    u16vector extended)
("u16vector"                          0     #f 0     0    u16vector gambit)
("##u16vector"                        0     #f ()    0    u16vector extended)
("u16vector->list"                    (1)   #f 0     0    list      gambit)
("##u16vector->list"                  (1)   #f ()    0    list      extended)
("u16vector-append"                   0     #f 0     0    u16vector gambit)
("##u16vector-append"                 0     #f ()    0    u16vector extended)
("u16vector-copy"                     (1 2 3)#f 0    0    u16vector gambit)
("##u16vector-copy"                   (1 2 3)#f ()   0    u16vector extended)
("##u16vector-copy-small"             (1 2 3)#f ()   0    u16vector extended)
("u16vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##u16vector-copy!"                  (3 4 5)#t ()   0    u16vector extended)
("u16vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##u16vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("u16vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##u16vector-length"                 (1)   #f ()    0    fix>=0    extended)
("u16vector-ref"                      (2)   #f 0     0    u16       gambit)
("##u16vector-ref"                    (2)   #f ()    0    u16       extended)
("u16vector-set"                      (3)   #f 0     0    u16vector gambit)
("##u16vector-set"                    (3)   #f ()    0    u16vector extended)
("##u16vector-set-small"              (3)   #f ()    0    u16vector extended)
("u16vector-set!"                     (3)   #t 0     0    #f        gambit)
("##u16vector-set!"                   (3)   #t ()    0    u16vector extended)
("u16vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##u16vector-shrink!"                (2)   #t ()    0    u16vector extended)
("u16vector?"                         (1)   #f 0     0    boolean   gambit)
("##u16vector?"                       (1)   #f ()    0    boolean   extended)
("##u16vector-insert"                 (3)   #f ()    0    u16vector extended)
("##u16vector-insert-small"           (3)   #f ()    0    u16vector extended)
("##u16vector-delete"                 (2)   #f ()    0    u16vector extended)
("##u16vector-delete-small"           (2)   #f ()    0    u16vector extended)

("s32vector-concatenate"              (1 2) #f 0     0    s32vector gambit)
("##s32vector-concatenate"            (1 2) #f ()    0    s32vector extended)
("list->s32vector"                    (1)   #f 0     0    s32vector gambit)
("##list->s32vector"                  (1)   #f ()    0    s32vector extended)
("make-s32vector"                     (1 2) #f 0     0    s32vector gambit)
("##make-s32vector"                   (1 2) #f ()    0    s32vector extended)
("##make-s32vector-small"             (1 2) #f ()    0    s32vector extended)
("subs32vector"                       (3)   #f 0     0    s32vector gambit)
("##subs32vector"                     (3)   #f ()    0    s32vector extended)
("##subs32vector-small"               (3)   #f ()    0    s32vector extended)
("subs32vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subs32vector-fill!"               (4)   #t ()    0    #f        extended)
("subs32vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subs32vector-move!"               (5)   #t ()    0    s32vector extended)
("s32vector"                          0     #f 0     0    s32vector gambit)
("##s32vector"                        0     #f ()    0    s32vector extended)
("s32vector->list"                    (1)   #f 0     0    list      gambit)
("##s32vector->list"                  (1)   #f ()    0    list      extended)
("s32vector-append"                   0     #f 0     0    s32vector gambit)
("##s32vector-append"                 0     #f ()    0    s32vector extended)
("s32vector-copy"                     (1 2 3)#f 0    0    s32vector gambit)
("##s32vector-copy"                   (1 2 3)#f ()   0    s32vector extended)
("##s32vector-copy-small"             (1 2 3)#f ()   0    s32vector extended)
("s32vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##s32vector-copy!"                  (3 4 5)#t ()   0    s32vector extended)
("s32vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##s32vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("s32vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##s32vector-length"                 (1)   #f ()    0    fix>=0    extended)
("s32vector-ref"                      (2)   #f 0     0    s32       gambit)
("##s32vector-ref"                    (2)   #f ()    0    s32       extended)
("s32vector-set"                      (3)   #f 0     0    s32vector gambit)
("##s32vector-set"                    (3)   #f ()    0    s32vector extended)
("##s32vector-set-small"              (3)   #f ()    0    s32vector extended)
("s32vector-set!"                     (3)   #t 0     0    #f        gambit)
("##s32vector-set!"                   (3)   #t ()    0    s32vector extended)
("s32vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##s32vector-shrink!"                (2)   #t ()    0    s32vector extended)
("s32vector?"                         (1)   #f 0     0    boolean   gambit)
("##s32vector?"                       (1)   #f ()    0    boolean   extended)
("##s32vector-insert"                 (3)   #f ()    0    s32vector extended)
("##s32vector-insert-small"           (3)   #f ()    0    s32vector extended)
("##s32vector-delete"                 (2)   #f ()    0    s32vector extended)
("##s32vector-delete-small"           (2)   #f ()    0    s32vector extended)

("u32vector-concatenate"              (1 2) #f 0     0    u32vector gambit)
("##u32vector-concatenate"            (1 2) #f ()    0    u32vector extended)
("list->u32vector"                    (1)   #f 0     0    u32vector gambit)
("##list->u32vector"                  (1)   #f ()    0    u32vector extended)
("make-u32vector"                     (1 2) #f 0     0    u32vector gambit)
("##make-u32vector"                   (1 2) #f ()    0    u32vector extended)
("##make-u32vector-small"             (1 2) #f ()    0    u32vector extended)
("subu32vector"                       (3)   #f 0     0    u32vector gambit)
("##subu32vector"                     (3)   #f ()    0    u32vector extended)
("##subu32vector-small"               (3)   #f ()    0    u32vector extended)
("subu32vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subu32vector-fill!"               (4)   #t ()    0    #f        extended)
("subu32vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subu32vector-move!"               (5)   #t ()    0    u32vector extended)
("u32vector"                          0     #f 0     0    u32vector gambit)
("##u32vector"                        0     #f ()    0    u32vector extended)
("u32vector->list"                    (1)   #f 0     0    list      gambit)
("##u32vector->list"                  (1)   #f ()    0    list      extended)
("u32vector-append"                   0     #f 0     0    u32vector gambit)
("##u32vector-append"                 0     #f ()    0    u32vector extended)
("u32vector-copy"                     (1 2 3)#f 0    0    u32vector gambit)
("##u32vector-copy"                   (1 2 3)#f ()   0    u32vector extended)
("##u32vector-copy-small"             (1 2 3)#f ()   0    u32vector extended)
("u32vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##u32vector-copy!"                  (3 4 5)#t ()   0    u32vector extended)
("u32vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##u32vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("u32vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##u32vector-length"                 (1)   #f ()    0    fix>=0    extended)
("u32vector-ref"                      (2)   #f 0     0    u32       gambit)
("##u32vector-ref"                    (2)   #f ()    0    u32       extended)
("u32vector-set"                      (3)   #f 0     0    u32vector gambit)
("##u32vector-set"                    (3)   #f ()    0    u32vector extended)
("##u32vector-set-small"              (3)   #f ()    0    u32vector extended)
("u32vector-set!"                     (3)   #t 0     0    #f        gambit)
("##u32vector-set!"                   (3)   #t ()    0    u32vector extended)
("u32vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##u32vector-shrink!"                (2)   #t ()    0    u32vector extended)
("u32vector?"                         (1)   #f 0     0    boolean   gambit)
("##u32vector?"                       (1)   #f ()    0    boolean   extended)
("##u32vector-insert"                 (3)   #f ()    0    u32vector extended)
("##u32vector-insert-small"           (3)   #f ()    0    u32vector extended)
("##u32vector-delete"                 (2)   #f ()    0    u32vector extended)
("##u32vector-delete-small"           (2)   #f ()    0    u32vector extended)

("s64vector-concatenate"              (1 2) #f 0     0    s64vector gambit)
("##s64vector-concatenate"            (1 2) #f ()    0    s64vector extended)
("list->s64vector"                    (1)   #f 0     0    s64vector gambit)
("##list->s64vector"                  (1)   #f ()    0    s64vector extended)
("make-s64vector"                     (1 2) #f 0     0    s64vector gambit)
("##make-s64vector"                   (1 2) #f ()    0    s64vector extended)
("##make-s64vector-small"             (1 2) #f ()    0    s64vector extended)
("subs64vector"                       (3)   #f 0     0    s64vector gambit)
("##subs64vector"                     (3)   #f ()    0    s64vector extended)
("##subs64vector-small"               (3)   #f ()    0    s64vector extended)
("subs64vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subs64vector-fill!"               (4)   #t ()    0    #f        extended)
("subs64vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subs64vector-move!"               (5)   #t ()    0    s64vector extended)
("s64vector"                          0     #f 0     0    s64vector gambit)
("##s64vector"                        0     #f ()    0    s64vector extended)
("s64vector->list"                    (1)   #f 0     0    list      gambit)
("##s64vector->list"                  (1)   #f ()    0    list      extended)
("s64vector-append"                   0     #f 0     0    s64vector gambit)
("##s64vector-append"                 0     #f ()    0    s64vector extended)
("s64vector-copy"                     (1 2 3)#f 0    0    s64vector gambit)
("##s64vector-copy"                   (1 2 3)#f ()   0    s64vector extended)
("##s64vector-copy-small"             (1 2 3)#f ()   0    s64vector extended)
("s64vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##s64vector-copy!"                  (3 4 5)#t ()   0    s64vector extended)
("s64vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##s64vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("s64vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##s64vector-length"                 (1)   #f ()    0    fix>=0    extended)
("s64vector-ref"                      (2)   #f 0     0    s64       gambit)
("##s64vector-ref"                    (2)   #f ()    0    s64       extended)
("s64vector-set"                      (3)   #f 0     0    s64vector gambit)
("##s64vector-set"                    (3)   #f ()    0    s64vector extended)
("##s64vector-set-small"              (3)   #f ()    0    s64vector extended)
("s64vector-set!"                     (3)   #t 0     0    #f        gambit)
("##s64vector-set!"                   (3)   #t ()    0    s64vector extended)
("s64vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##s64vector-shrink!"                (2)   #t ()    0    s64vector extended)
("s64vector?"                         (1)   #f 0     0    boolean   gambit)
("##s64vector?"                       (1)   #f ()    0    boolean   extended)
("##s64vector-insert"                 (3)   #f ()    0    s64vector extended)
("##s64vector-insert-small"           (3)   #f ()    0    s64vector extended)
("##s64vector-delete"                 (2)   #f ()    0    s64vector extended)
("##s64vector-delete-small"           (2)   #f ()    0    s64vector extended)

("u64vector-concatenate"              (1 2) #f 0     0    u64vector gambit)
("##u64vector-concatenate"            (1 2) #f ()    0    u64vector extended)
("list->u64vector"                    (1)   #f 0     0    u64vector gambit)
("##list->u64vector"                  (1)   #f ()    0    u64vector extended)
("make-u64vector"                     (1 2) #f 0     0    u64vector gambit)
("##make-u64vector"                   (1 2) #f ()    0    u64vector extended)
("##make-u64vector-small"             (1 2) #f ()    0    u64vector extended)
("subu64vector"                       (3)   #f 0     0    u64vector gambit)
("##subu64vector"                     (3)   #f ()    0    u64vector extended)
("##subu64vector-small"               (3)   #f ()    0    u64vector extended)
("subu64vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subu64vector-fill!"               (4)   #t ()    0    #f        extended)
("subu64vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subu64vector-move!"               (5)   #t ()    0    u64vector extended)
("u64vector"                          0     #f 0     0    u64vector gambit)
("##u64vector"                        0     #f ()    0    u64vector extended)
("u64vector->list"                    (1)   #f 0     0    list      gambit)
("##u64vector->list"                  (1)   #f ()    0    list      extended)
("u64vector-append"                   0     #f 0     0    u64vector gambit)
("##u64vector-append"                 0     #f ()    0    u64vector extended)
("u64vector-copy"                     (1 2 3)#f 0    0    u64vector gambit)
("##u64vector-copy"                   (1 2 3)#f ()   0    u64vector extended)
("##u64vector-copy-small"             (1 2 3)#f ()   0    u64vector extended)
("u64vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##u64vector-copy!"                  (3 4 5)#t ()   0    u64vector extended)
("u64vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##u64vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("u64vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##u64vector-length"                 (1)   #f ()    0    fix>=0    extended)
("u64vector-ref"                      (2)   #f 0     0    u64       gambit)
("##u64vector-ref"                    (2)   #f ()    0    u64       extended)
("u64vector-set"                      (3)   #f 0     0    u64vector gambit)
("##u64vector-set"                    (3)   #f ()    0    u64vector extended)
("##u64vector-set-small"              (3)   #f ()    0    u64vector extended)
("u64vector-set!"                     (3)   #t 0     0    #f        gambit)
("##u64vector-set!"                   (3)   #t ()    0    u64vector extended)
("u64vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##u64vector-shrink!"                (2)   #t ()    0    u64vector extended)
("u64vector?"                         (1)   #f 0     0    boolean   gambit)
("##u64vector?"                       (1)   #f ()    0    boolean   extended)
("##u64vector-insert"                 (3)   #f ()    0    u64vector extended)
("##u64vector-insert-small"           (3)   #f ()    0    u64vector extended)
("##u64vector-delete"                 (2)   #f ()    0    u64vector extended)
("##u64vector-delete-small"           (2)   #f ()    0    u64vector extended)

("f32vector-concatenate"              (1 2) #f 0     0    f32vector gambit)
("##f32vector-concatenate"            (1 2) #f ()    0    f32vector extended)
("list->f32vector"                    (1)   #f 0     0    f32vector gambit)
("##list->f32vector"                  (1)   #f ()    0    f32vector extended)
("make-f32vector"                     (1 2) #f 0     0    f32vector gambit)
("##make-f32vector"                   (1 2) #f ()    0    f32vector extended)
("##make-f32vector-small"             (1 2) #f ()    0    f32vector extended)
("subf32vector"                       (3)   #f 0     0    f32vector gambit)
("##subf32vector"                     (3)   #f ()    0    f32vector extended)
("##subf32vector-small"               (3)   #f ()    0    f32vector extended)
("subf32vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subf32vector-fill!"               (4)   #t ()    0    #f        extended)
("subf32vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subf32vector-move!"               (5)   #t ()    0    f32vector extended)
("f32vector"                          0     #f 0     0    f32vector gambit)
("##f32vector"                        0     #f ()    0    f32vector extended)
("f32vector->list"                    (1)   #f 0     0    list      gambit)
("##f32vector->list"                  (1)   #f ()    0    list      extended)
("f32vector-append"                   0     #f 0     0    f32vector gambit)
("##f32vector-append"                 0     #f ()    0    f32vector extended)
("f32vector-copy"                     (1 2 3)#f 0    0    f32vector gambit)
("##f32vector-copy"                   (1 2 3)#f ()   0    f32vector extended)
("##f32vector-copy-small"             (1 2 3)#f ()   0    f32vector extended)
("f32vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##f32vector-copy!"                  (3 4 5)#t ()   0    f32vector extended)
("f32vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##f32vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("f32vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##f32vector-length"                 (1)   #f ()    0    fix>=0    extended)
("f32vector-ref"                      (2)   #f 0     0    flonum    gambit)
("##f32vector-ref"                    (2)   #f ()    0    flonum    extended)
("f32vector-set"                      (3)   #f 0     0    f32vector gambit)
("##f32vector-set"                    (3)   #f ()    0    f32vector extended)
("##f32vector-set-small"              (3)   #f ()    0    f32vector extended)
("f32vector-set!"                     (3)   #t 0     0    #f        gambit)
("##f32vector-set!"                   (3)   #t ()    0    f32vector extended)
("f32vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##f32vector-shrink!"                (2)   #t ()    0    f32vector extended)
("f32vector?"                         (1)   #f 0     0    boolean   gambit)
("##f32vector?"                       (1)   #f ()    0    boolean   extended)
("##f32vector-insert"                 (3)   #f ()    0    f32vector extended)
("##f32vector-insert-small"           (3)   #f ()    0    f32vector extended)
("##f32vector-delete"                 (2)   #f ()    0    f32vector extended)
("##f32vector-delete-small"           (2)   #f ()    0    f32vector extended)

("f64vector-concatenate"              (1 2) #f 0     0    f64vector gambit)
("##f64vector-concatenate"            (1 2) #f ()    0    f64vector extended)
("list->f64vector"                    (1)   #f 0     0    f64vector gambit)
("##list->f64vector"                  (1)   #f ()    0    f64vector extended)
("make-f64vector"                     (1 2) #f 0     0    f64vector gambit)
("##make-f64vector"                   (1 2) #f ()    0    f64vector extended)
("##make-f64vector-small"             (1 2) #f ()    0    f64vector extended)
("subf64vector"                       (3)   #f 0     0    f64vector gambit)
("##subf64vector"                     (3)   #f ()    0    f64vector extended)
("##subf64vector-small"               (3)   #f ()    0    f64vector extended)
("subf64vector-fill!"                 (4)   #t 0     0    #f        gambit)
("##subf64vector-fill!"               (4)   #t ()    0    #f        extended)
("subf64vector-move!"                 (5)   #t 0     0    #f        gambit)
("##subf64vector-move!"               (5)   #t ()    0    f64vector extended)
("f64vector"                          0     #f 0     0    f64vector gambit)
("##f64vector"                        0     #f ()    0    f64vector extended)
("f64vector->list"                    (1)   #f 0     0    list      gambit)
("##f64vector->list"                  (1)   #f ()    0    list      extended)
("f64vector-append"                   0     #f 0     0    f64vector gambit)
("##f64vector-append"                 0     #f ()    0    f64vector extended)
("f64vector-copy"                     (1 2 3)#f 0    0    f64vector gambit)
("##f64vector-copy"                   (1 2 3)#f ()   0    f64vector extended)
("##f64vector-copy-small"             (1 2 3)#f ()   0    f64vector extended)
("f64vector-copy!"                    (3 4 5)#t 0    0    #f        gambit)
("##f64vector-copy!"                  (3 4 5)#t ()   0    f64vector extended)
("f64vector-fill!"                    (2 3 4)#t 0    0    #f        gambit)
("##f64vector-fill!"                  (2 3 4)#t ()   0    #f        extended)
("f64vector-length"                   (1)   #f 0     0    fix>=0    gambit)
("##f64vector-length"                 (1)   #f ()    0    fix>=0    extended)
("f64vector-ref"                      (2)   #f 0     0    flonum    gambit)
("##f64vector-ref"                    (2)   #f ()    0    flonum    extended)
("f64vector-set"                      (3)   #f 0     0    f64vector gambit)
("##f64vector-set"                    (3)   #f ()    0    f64vector extended)
("##f64vector-set-small"              (3)   #f ()    0    f64vector extended)
("f64vector-set!"                     (3)   #t 0     0    #f        gambit)
("##f64vector-set!"                   (3)   #t ()    0    f64vector extended)
("f64vector-shrink!"                  (2)   #t 0     0    #f        gambit)
("##f64vector-shrink!"                (2)   #t ()    0    f64vector extended)
("f64vector?"                         (1)   #f 0     0    boolean   gambit)
("##f64vector?"                       (1)   #f ()    0    boolean   extended)
("##f64vector-insert"                 (3)   #f ()    0    f64vector extended)
("##f64vector-insert-small"           (3)   #f ()    0    f64vector extended)
("##f64vector-delete"                 (2)   #f ()    0    f64vector extended)
("##f64vector-delete-small"           (2)   #f ()    0    f64vector extended)

;; symbol

("symbol?"                            (1)   #f 0     0    boolean ieee)
("##symbol?"                          (1)   #f ()    0    boolean extended)
("symbol->string"                     (1)   #f 0     0    string  ieee)
("##symbol->string"                   (1)   #f ()    0    string  extended)
("##symbol->string?"                  (1)   #f ()    0    #f      extended)
("string->symbol"                     (1)   #f 0     0    symbol  ieee)
("##string->symbol"                   (1)   #f ()    0    symbol  extended)

("symbol=?"                           0     #f 0     0    boolean r7rs)
("##symbol=?"                         0     #f ()    0    boolean extended)

("gensym"                             (1 2) #f 0     0    symbol  gambit)
("##gensym"                           (1 2) #f ()    0    symbol  extended)
("string->uninterned-symbol"          (1 2) #f 0     0    symbol  gambit)
("##string->uninterned-symbol"        (1 2) #f ()    0    symbol  extended)
("symbol-hash"                        (1)   #f 0     0    fix>=0  gambit)
("##symbol-hash"                      (1)   #f ()    0    fix>=0  extended)
("##symbol-hash-set!"                 (2)   #t ()    0    #f      extended)
("uninterned-symbol?"                 (1)   #f 0     0    boolean gambit)
("##uninterned-symbol?"               (1)   #f ()    0    boolean extended)

("##make-uninterned-symbol"           (2)   #f ()    0    symbol  extended)
("##symbol-name"                      (1)   #f ()    0    string  extended)
("##symbol-name-set!"                 (2)   #t ()    0    #f      extended)
("##symbol-interned?"                 (1)   #f ()    0    boolean extended)

;; keyword

("keyword->string"                    (1)   #f 0     0    string  gambit)
("##keyword->string"                  (1)   #f ()    0    string  extended)
("##keyword->string?"                 (1)   #f ()    0    #f      extended)
("keyword-hash"                       (1)   #f 0     0    fix>=0  gambit)
("##keyword-hash"                     (1)   #f ()    0    fix>=0  extended)
("##keyword-hash-set!"                (2)   #t ()    0    #f      extended)
("keyword?"                           (1)   #f 0     0    boolean gambit)
("##keyword?"                         (1)   #f ()    0    boolean extended)
("string->keyword"                    (1)   #f 0     0    keyword gambit)
("##string->keyword"                  (1)   #f ()    0    keyword extended)
("string->uninterned-keyword"         (1 2) #f 0     0    keyword gambit)
("##string->uninterned-keyword"       (1 2) #f ()    0    keyword extended)
("uninterned-keyword?"                (1)   #f 0     0    boolean gambit)
("##uninterned-keyword?"              (1)   #f ()    0    boolean extended)

("##make-uninterned-keyword"          (2)   #f ()    0    keyword extended)
("##keyword-name"                     (1)   #f ()    0    string  extended)
("##keyword-name-set!"                (2)   #t ()    0    #f      extended)
("##keyword-interned?"                (1)   #f ()    0    boolean extended)

;; box

("box?"                               (1)   #f 0     0    boolean gambit)
("##box?"                             (1)   #f ()    0    boolean extended)
("box"                                (1)   #f ()    0    box     gambit)
("##box"                              (1)   #f ()    0    box     extended)
("unbox"                              (1)   #f 0     0    (#f)    gambit)
("##unbox"                            (1)   #f ()    0    (#f)    extended)
("set-box!"                           (2)   #t (1)   0    #f      gambit)
("##set-box!"                         (2)   #t ()    0    #f      extended)

;; values

("call-with-values"                   (2)   #t 0     0    (#f)    r5rs)
("##call-with-values"                 (2)   #t ()    0    (#f)    extended)
("values"                             0     #f ()    0    (#f)    r5rs)
("##values"                           0     #f ()    0    (#f)    extended)

("##values?"                          (1)   #f ()    0    boolean extended)
("##values"                           0     #f ()    0    (#f)    extended)
("##make-values"                      (1 2) #f ()    0    (#f)    extended)
("##make-values-small"                (1 2) #f ()    0    (#f)    extended)
("##values-length"                    (1)   #f ()    0    fix>=0  extended)
("##values-ref"                       (2)   #f ()    0    (#f)    extended)
("##values-set!"                      (3)   #t ()    0    (#f)    extended)
("##values-set"                       (3)   #f ()    0    (#f)    extended)
("##values-set-small"                 (3)   #f ()    0    (#f)    extended)
("##values-insert"                    (3)   #f ()    0    (#f)    extended)
("##values-insert-small"              (3)   #f ()    0    (#f)    extended)
("##values-delete"                    (2)   #f ()    0    (#f)    extended)
("##values-delete-small"              (2)   #f ()    0    (#f)    extended)

;; table

("##gc-hash-table?"                   (1)   #f ()    0    boolean extended)
("##gc-hash-table-ref"                (2)   #f ()    0    (#f)    extended)
("##gc-hash-table-set!"               (3)   #t ()    0    (#f)    extended)
("##gc-hash-table-union!"             (3)   #t ()    0    fix>=0  extended)
("##gc-hash-table-find!"              (3)   #t ()    0    fix>=0  extended)
("##gc-hash-table-rehash!"            (2)   #t ()    0    (#f)    extended)

;; will

("make-will"                          (2)   #t (2)   0    #f      gambit)
("##make-will"                        (2)   #t ()    0    #f      extended)
("will-testator"                      (1)   #f 0     0    (#f)    gambit)
("##will-testator"                    (1)   #f ()    0    (#f)    extended)
("##will-testator-set!"               (2)   #t ()    0    #f      extended)
("will?"                              (1)   #f 0     0    boolean gambit)
("##will?"                            (1)   #f ()    0    boolean extended)

("##will-action"                      (1)   #f ()    0    (#f)    extended)
("##will-action-set!"                 (2)   #t ()    0    #f      extended)

;; port

("call-with-input-file"               (2)   #t 0     0    (#f)    ieee)
("call-with-output-file"              (2)   #t 0     0    (#f)    ieee)
("input-port?"                        (1)   #f 0     0    boolean ieee)
("output-port?"                       (1)   #f 0     0    boolean ieee)
;parameter! ("current-input-port"                 (0)   #f 0     0    port    ieee)
;parameter! ("current-output-port"                (0)   #f 0     0    port    ieee)
("open-input-file"                    (1)   #t 0     0    port    ieee)
("open-output-file"                   (1)   #t 0     0    port    ieee)
("close-input-port"                   (1)   #t 0     0    #f      ieee)
("close-output-port"                  (1)   #t 0     0    #f      ieee)
("with-input-from-file"               (2)   #t 0     0    (#f)    r4rs)
("with-output-to-file"                (2)   #t 0     0    (#f)    r4rs)

("char-ready?"                        (0 1) #f 0     0    boolean r4rs)
("##char-ready?"                      (0 1) #f ()    0    boolean extended)
("##char-ready?0"                     (0)   #f ()    0    boolean extended)
("##char-ready?1"                     (1)   #f ()    0    boolean extended)
("read"                               (0 1) #t 0     0    #f      ieee)
("##read"                             (0 1) #t ()    0    #f      extended)
("read-char"                          (0 1) #t 0     0    #f      ieee)
("##read-char"                        (0 1) #t ()    0    #f      extended)
("##read-char0"                       (0)   #t ()    0    #f      extended)
("##read-char1"                       (1)   #t ()    0    #f      extended)
("##read-char0?"                      (0)   #t ()    0    #f      extended)
("##read-char1?"                      (1)   #t ()    0    #f      extended)
("peek-char"                          (0 1) #t 0     0    #f      ieee)
("##peek-char"                        (0 1) #t ()    0    #f      extended)
("##peek-char0"                       (0)   #t ()    0    #f      extended)
("##peek-char1"                       (1)   #t ()    0    #f      extended)
("##peek-char0?"                      (0)   #t ()    0    #f      extended)
("##peek-char1?"                      (1)   #t ()    0    #f      extended)
("write"                              (1 2) #t 0     0    #f      ieee)
("##write"                            (1 2) #t ()    0    #f      extended)
("display"                            (1 2) #t 0     0    #f      ieee)
("##display"                          (1 2) #t ()    0    #f      extended)
("newline"                            (0 1) #t 0     0    #f      ieee)
("##newline"                          (0 1) #t ()    0    #f      extended)
("##newline0"                         (0)   #t ()    0    #f      extended)
("##newline1"                         (1)   #t ()    0    #f      extended)
("write-char"                         (1 2) #t 0     0    #f      ieee)
("##write-char"                       (1 2) #t ()    0    #f      extended)
("##write-char1"                      (1)   #t ()    0    #f      extended)
("##write-char2"                      (2)   #t ()    0    #f      extended)
("##write-char1?"                     (1)   #t ()    0    #f      extended)
("##write-char2?"                     (2)   #t ()    0    #f      extended)
("##char-input-port?-cached"          (1)   #f 0     0    boolean extended)
("##char-output-port?-cached"         (1)   #f 0     0    boolean extended)

("eof-object?"                        (1)   #f 0     0    boolean ieee)
("##eof-object?"                      (1)   #f ()    0    boolean extended)
("eof-object"                         (0)   #f 0     0    #f      r7rs)
("##eof-object"                       (0)   #f ()    0    #f      extended)

;; procedure

("procedure?"                         (1)   #f 0     0    boolean ieee)
("##procedure?"                       (1)   #f ()    0    boolean extended)
("apply"                              2     #t 0     0    (#f)    ieee)
("##apply"                            (2)   #t ()    0    (#f)    extended)
("map"                                2     #t 0     0    list    ieee)
("##map"                              2     #t ()    0    list    extended)
("for-each"                           2     #t 0     0    #f      ieee)
("##for-each"                         2     #t ()    0    #f      extended)

("##closure?"                         (1)   #f ()    0    boolean extended)
("##make-closure"                     (2)   #f ()    0    #f      extended)
("##closure-length"                   (1)   #f ()    0    fix>=0  extended)
("##closure-code"                     (1)   #f ()    0    #f      extended)
("##closure-ref"                      (2)   #f ()    0    (#f)    extended)
("##closure-set!"                     (3)   #t ()    0    #f      extended)

("##subprocedure?"                    (1)   #f ()    0    boolean extended)
("##make-subprocedure"                (2)   #f ()    0    #f      extended)
("##subprocedure-id"                  (1)   #f ()    0    #f      extended)
("##subprocedure-nb-parameters"       (1)   #f ()    0    #f      extended)
("##subprocedure-nb-closed"           (1)   #f ()    0    #f      extended)
("##subprocedure-parent"              (1)   #f ()    0    #f      extended)
("##subprocedure-parent-name"         (1)   #f ()    0    #f      extended)
("##subprocedure-parent-info"         (1)   #f ()    0    #f      extended)

;; control

("call-with-current-continuation"     1     #t 0     1113 (#f)    ieee)
("##call-with-current-continuation"   1     #t ()    1113 (#f)    extended)
("dynamic-wind"                       (3)   #t 0     0    (#f)    r5rs)
("##dynamic-wind"                     (3)   #t ()    0    (#f)    extended)

("call/cc"                            1     #t 0     1113 (#f)    gambit)
("continuation?"                      (1)   #f 0     0    boolean gambit)
("##continuation?"                    (1)   #f ()    0    boolean extended)
("continuation-capture"               1     #t 0     1113 (#f)    gambit)
("##continuation-capture"             1     #t ()    1113 (#f)    extended)
("continuation-graft"                 2     #t 0     2203 #f      gambit)
("##continuation-graft"               2     #t ()    2203 #f      extended)
("##continuation-graft-no-winding"    2     #t ()    2203 #f      extended)
("continuation-return"                (2)   #t 0     0    #f      gambit)
("##continuation-return"              (2)   #t ()    0    #f      extended)
("##continuation-return-no-winding"   (2)   #t ()    0    #f      extended)

("##make-continuation"                (2)   #f ()    0    #f      extended)
("##continuation-frame"               (1)   #f ()    0    #f      extended)
("##continuation-frame-set!"          (2)   #t ()    0    #f      extended)
("##continuation-denv"                (1)   #f ()    0    #f      extended)
("##continuation-denv-set!"           (2)   #t ()    0    #f      extended)
("##continuation-next"                (1)   #f ()    0    #f      extended)
("##continuation-ret"                 (1)   #f ()    0    #f      extended)
("##continuation-fs"                  (1)   #f ()    0    fix>=0  extended)
("##continuation-link"                (1)   #f ()    0    #f      extended)
("##continuation-ref"                 (2)   #f ()    0    (#f)    extended)
("##continuation-set!"                (3)   #t ()    0    #f      extended)
("##continuation-slot-live?"          (2)   #f ()    0    boolean extended)

("##frame?"                           (1)   #f ()    0    boolean extended)
("##make-frame"                       (1)   #f ()    0    #f      extended)
("##frame-ret"                        (1)   #f ()    0    #f      extended)
("##frame-fs"                         (1)   #f ()    0    fix>=0  extended)
("##frame-link"                       (1)   #f ()    0    #f      extended)
("##frame-ref"                        (2)   #f ()    0    (#f)    extended)
("##frame-set!"                       (3)   #t ()    0    #f      extended)
("##frame-slot-live?"                 (2)   #f ()    0    boolean extended)

("##return?"                          (1)   #f ()    0    boolean extended)
("##return-fs"                        (1)   #f ()    0    fix>=0  extended)

("##with-exception-catcher"           (2)   #t 0     0    (#f)    extended)
("##r7rs-with-exception-catcher"      (2)   #t 0     0    (#f)    extended)

;; eval

("load"                               (1)   #t 0     0    (#f)    r4rs)
("transcript-on"                      (1)   #t 0     0    #f      r4rs)
("transcript-off"                     (0)   #t 0     0    #f      r4rs)

("eval"                               (1 2) #t 0     0    (#f)    r5rs)
("interaction-environment"            (0)   #f 0     0    #f      r5rs)
("null-environment"                   (0)   #f 0     0    #f      r5rs)
("scheme-report-environment"          (1)   #f 0     0    #f      r5rs)

("##make-global-var"                  (1)   #t ()    0    #f      extended)
("##global-var?"                      (1)   #f ()    0    #f      extended)
("##global-var-ref"                   (1)   #f ()    0    (#f)    extended)
("##global-var-primitive-ref"         (1)   #f ()    0    (#f)    extended)
("##global-var-set!"                  (2)   #t ()    0    #f      extended)
("##global-var-primitive-set!"        (2)   #t ()    0    #f      extended)

;; promise

("force"                              (1)   #t 0     0    #f      r4rs)
("##force"                            (1)   #t 0     0    #f      extended)

("promise?"                           (1)   #f ()    0    boolean r7rs)
("##promise?"                         (1)   #f ()    0    boolean extended)
("##make-delay-promise"               (1)   #f 0     0    (#f)    extended)
("##promise-state"                    (1)   #f ()    0    #f      extended)
("##promise-state-set!"               (2)   #t ()    0    #f      extended)

("touch"                              (1)   #t 0     0    #f      multilisp)

;; foreign

("##foreign?"                         (1)   #f ()    0    boolean extended)
("##foreign-address"                  (1)   #f ()    0    #f      extended)
("##foreign-tags"                     (1)   #f ()    0    #f      extended)
("##foreign-release!"                 (1)   #t ()    0    #f      extended)
("##foreign-released?"                (1)   #f ()    0    boolean extended)

;; structure

("##structure?"                       (1)   #f ()    0    boolean extended)
("##structure-direct-instance-of?"    (2)   #f ()    0    boolean extended)
("##structure-instance-of?"           (2)   #f ()    0    boolean extended)
("##structure-type"                   (1)   #f ()    0    (#f)    extended)
("##structure-type-set!"              (2)   #t ()    0    (#f)    extended)
("##structure"                        1     #f ()    0    (#f)    extended)
("##make-structure"                   (2)   #f ()    0    (#f)    extended)
("##structure-length"                 (1)   #f ()    0    fix>=0  extended)
("##structure-ref"                    (4)   #f ()    0    (#f)    extended)
("##structure-set!"                   (5)   #t ()    0    (#f)    extended)
("##structure-cas!"                   (6)   #t ()    0    (#f)    extended)
("##direct-structure-ref"             (4)   #f ()    0    (#f)    extended)
("##direct-structure-set!"            (5)   #t ()    0    (#f)    extended)
("##direct-structure-cas!"            (6)   #t ()    0    (#f)    extended)
("##unchecked-structure-ref"          (4)   #f ()    0    (#f)    extended)
("##unchecked-structure-set!"         (5)   #t ()    0    (#f)    extended)
("##unchecked-structure-cas!"         (6)   #t ()    0    (#f)    extended)

("##type-id"                          (1)   #f ()    0    #f      extended)
("##type-name"                        (1)   #f ()    0    #f      extended)
("##type-flags"                       (1)   #f ()    0    #f      extended)
("##type-super"                       (1)   #f ()    0    #f      extended)
("##type-fields"                      (1)   #f ()    0    #f      extended)

;; thread

("current-thread"                     (0)   #f ()    0    #f      gambit)
("##current-thread"                   (0)   #f ()    0    #f      extended)
("##current-processor"                (0)   #f ()    0    #f      extended)
("##current-processor-id"             (0)   #f ()    0    fix>=0  extended)
("##processor"                        (1)   #f ()    0    #f      extended)
("##current-vm"                       (0)   #f ()    0    #f      extended)

("##thread-save!"                     1     #t ()    1113 (#f)    extended)
("##thread-restore!"                  2     #t ()    2203 #f      extended)

("##primitive-lock!"                  (3)   #t ()    0    #f      extended)
("##primitive-trylock!"               (3)   #t ()    0    #f      extended)
("##primitive-unlock!"                (3)   #t ()    0    #f      extended)

;; miscellaneous

("eq?"                                (2)   #f 0     0    boolean ieee)
("##eq?"                              (2)   #f ()    0    boolean extended)
("equal?"                             (2)   #f 0     0    boolean ieee)
("##equal?"                           (2)   #f ()    0    boolean extended)
("eqv?"                               (2)   #f 0     0    boolean ieee)
("##eqv?"                             (2)   #f ()    0    boolean extended)

("identity"                           (1)   #f 0     0    (#f)    gambit)
("##identity"                         (1)   #f ()    0    (#f)    extended)

("void"                               (0)   #f 0     0    #f      gambit)
("##void"                             (0)   #f ()    0    #f      extended)

("dead-end"                           (0)   #t 0     0    #f      extended)
("##dead-end"                         (0)   #t ()    0    #f      extended)

;; for system interface

("##type"                             (1)   #f ()    0    fix>=0  extended)
("##type-cast"                        (2)   #f ()    0    (#f)    extended)
("##subtype"                          (1)   #f ()    0    fix>=0  extended)
("##subtype-set!"                     (2)   #t ()    0    #f      extended)

("##false-or-null?"                   (1)   #f ()    0    boolean extended)
("##false-or-void?"                   (1)   #f ()    0    boolean extended)
("##unbound?"                         (1)   #f ()    0    boolean extended)

("##mutable?"                         (1)   #f ()    0    boolean extended)

("##special?"                         (1)   #f ()    0    boolean extended)
("##meroon?"                          (1)   #f ()    0    boolean extended)
("##jazz?"                            (1)   #f ()    0    boolean extended)
("##mem-allocated?"                   (1)   #f ()    0    boolean extended)
("##subtyped?"                        (1)   #f ()    0    boolean extended)
("##subtyped.vector?"                 (1)   #f ()    0    boolean extended)
("##subtyped.symbol?"                 (1)   #f ()    0    boolean extended)
("##subtyped.flonum?"                 (1)   #f ()    0    boolean extended)
("##subtyped.bignum?"                 (1)   #f ()    0    boolean extended)

("##object-before?"                   (2)   #t ()    0    boolean extended)

("##first-argument"                   1     #f ()    0    (#f)    extended)
("##check-heap-limit"                 (0)   #t ()    0    (#f)    extended)

("##poll-point"                       (0)   #t ()    0    (#f)    extended)

;; for front end

("##quasi-append"                     0     #f 0     0    list    extended)
("##quasi-list"                       0     #f ()    0    list    extended)
("##quasi-cons"                       (2)   #f ()    0    pair    extended)
("##quasi-list->vector"               (1)   #f 0     0    vector  extended)
("##quasi-vector"                     0     #f ()    0    vector  extended)
("##case-memv"                        (2)   #f 0     0    list    extended)

)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure specializers

(define (setup-prim-specializers targ)

;; TODO: remove dependencies to C back-end

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

(define (def-spec name specializer-maker)
  (let ((proc (get-prim-info name))
        (proc-name (string->canonical-symbol name)))
    (proc-obj-specialize-set! proc (specializer-maker proc proc-name))))

(define (spec-s name) ;; Safe specialization
  (lambda (proc proc-name)
    (let ((spec (get-prim-info name)))
      (lambda (env call)
        (make-call spec (call-args call))))))

(define (spec-u name) ;; Unsafe specialization
  (lambda (proc proc-name)
    (let ((spec (get-prim-info name)))
      (lambda (env call)
        (if (not (safe? env))
            (make-call spec (call-args call))
            call)))))

(define (spec-nargs . names) ;; Argument count specialization
  (lambda (proc proc-name)
    (let ((specs (map (lambda (n) (and n (get-prim-info n))) names)))
      (lambda (env call)
        (let* ((args (call-args call))
               (nargs (length args)))
          (if (< nargs (length specs))
              (make-call (list-ref specs nargs) args)
              call))))))

(define (spec-arith fix-name . flo-name-and-unsafe-name) ;; Arithmetic specialization
  (let ((flo-name
         (and (pair? flo-name-and-unsafe-name)
              (car flo-name-and-unsafe-name)))
        (unsafe-name
         (and (pair? flo-name-and-unsafe-name)
              (pair? (cdr flo-name-and-unsafe-name))
              (cadr flo-name-and-unsafe-name))))
    (lambda (proc proc-name)
      (let ((fix-spec
             (and fix-name (get-prim-info fix-name)))
            (flo-spec
             (and flo-name (get-prim-info flo-name)))
            (unsafe-spec
             (and unsafe-name (get-prim-info unsafe-name))))
        (lambda (env call)
          (let* ((args (call-args call))
                 (arith (arith-implementation proc-name env)))
            (cond ((and unsafe-spec (not (safe? env)))
                   (make-call unsafe-spec args))
                  ((and fix-spec (eq? arith fixnum-sym))
                   (make-call fix-spec args))
                  ((and flo-spec (eq? arith flonum-sym))
                   (make-call flo-spec args))
                  (else
                   call))))))))

(define (spec-arith-no-overflow fix-name) ;; Fixnum arithmetic specialization
  (lambda (proc proc-name)
    (let ((fix-spec
           (get-prim-info fix-name)))
      (lambda (env call)
        (define tctx (make-tctx)) ;; TODO store in target
        (let* ((args (call-args call))
               (arith (arith-implementation proc-name env)))
          (if (eq? arith fixnum-sym)
              (make-call fix-spec args)
              (let* ((type-infer
                      (proc-obj-type-infer proc))
                     (result-type
                      (and type-infer
                           (type-infer tctx
                                       (map call-arg-val args)))))
                (if (type-included? tctx result-type type-fixnum)
                    (make-call fix-spec args)
                    call))))))))

(define (spec-s-eqv?) ;; Safe specialization for eqv? and ##eqv?
  (lambda (proc proc-name)
    (let ((spec (get-prim-info "##eq?")))
      (lambda (env call)
        ;; TODO: improve to allow specializing (eqv? x "foo")
        (let ((args (call-args call)))
          (if (or (eq? (arith-implementation proc-name env) fixnum-sym)
                  (eq-testable? (call-arg-val (car args)))
                  (eq-testable? (call-arg-val (cadr args))))
              (make-call spec args)
              call))))))

(define (spec-s-equal?) ;; Safe specialization for equal? and ##equal?
  (lambda (proc proc-name)
    (let ((spec (get-prim-info "##eq?")))
      (lambda (env call)
        (let ((args (call-args call)))
          (if (or (eq-testable? (call-arg-val (car args)))
                  (eq-testable? (call-arg-val (cadr args))))
              (make-call spec args)
              call))))))

(define (eq-testable? type)
  ((target-eq-testable? targ) type))

(define (def-dead-end name)
  (let ((proc (get-prim-info name)))
    (proc-obj-dead-end?-set! proc #t)))

(def-dead-end "##dead-end")

(def-spec "dead-end"           (spec-s "##dead-end"))

;; boolean

(def-spec "boolean?"           (spec-s "##boolean?"))
(def-spec "not"                (spec-s "##not"))

(def-spec "boolean=?"          (spec-u "##boolean=?"))

;; number

(def-spec "*"                  (spec-arith "fx*"       "fl*"       "##*"))
(def-spec "##*"                (spec-arith "##fx*"     "##fl*"))
(def-spec "+"                  (spec-arith "fx+"       "fl+"       "##+"))
(def-spec "##+"                (spec-arith "##fx+"     "##fl+"))
(def-spec "-"                  (spec-arith "fx-"       "fl-"       "##-"))
(def-spec "##-"                (spec-arith "##fx-"     "##fl-"))
(def-spec "/"                  (spec-arith #f          "fl/"       "##/"))
(def-spec "##/"                (spec-arith #f          "##fl/"))
(def-spec "<"                  (spec-arith "fx<"       "fl<"       "##<"))
(def-spec "##<"                (spec-arith "##fx<"     "##fl<"))
(def-spec "<="                 (spec-arith "fx<="      "fl<="      "##<="))
(def-spec "##<="               (spec-arith "##fx<="    "##fl<="))
(def-spec "="                  (spec-arith "fx="       "fl="       "##="))
(def-spec "##="                (spec-arith "##fx="     "##fl="))
(def-spec ">"                  (spec-arith "fx>"       "fl>"       "##>"))
(def-spec "##>"                (spec-arith "##fx>"     "##fl>"))
(def-spec ">="                 (spec-arith "fx>="      "fl>="      "##>="))
(def-spec "##>="               (spec-arith "##fx>="    "##fl>="))
(def-spec "abs"                (spec-arith "fxabs"     "flabs"     "##abs"))
(def-spec "##abs"              (spec-arith "##fxabs"   "##flabs"))
(def-spec "acos"               (spec-arith #f          "flacos"    "##acos"))
(def-spec "##acos"             (spec-arith #f          "##flacos"))
(def-spec "angle"              (spec-u "##angle"))
(def-spec "asin"               (spec-arith #f          "flasin"    "##asin"))
(def-spec "##asin"             (spec-arith #f          "##flasin"))
(def-spec "atan"               (spec-arith #f          "flatan"    "##atan"))
(def-spec "##atan"             (spec-arith #f          "##flatan"))
(def-spec "ceiling"            (spec-arith "##identity" "flceiling" "##ceiling"))
(def-spec "##ceiling"          (spec-arith "##identity" "##flceiling"))
(def-spec "complex?"           (spec-s "##complex?"))
(def-spec "cos"                (spec-arith #f          "flcos"     "##cos"))
(def-spec "##cos"              (spec-arith #f          "##flcos"))
(def-spec "denominator"        (spec-u "##denominator"))
(def-spec "even?"              (spec-arith "fxeven?"   "fleven?"   "##even?"))
(def-spec "##even?"            (spec-arith "##fxeven?" "##fleven?"))
(def-spec "exact->inexact"     (spec-u "##exact->inexact"))
(def-spec "exact?"             (spec-u "##exact?"))
(def-spec "exp"                (spec-arith #f          "flexp"     "##exp"))
(def-spec "##exp"              (spec-arith #f          "##flexp"))
(def-spec "expt"               (spec-arith #f          "flexpt"    "##expt"))
(def-spec "##expt"             (spec-arith #f          "##flexpt"))
(def-spec "floor"              (spec-arith "##identity" "flfloor"   "##floor"))
(def-spec "##floor"            (spec-arith "##identity" "##flfloor"))
(def-spec "gcd"                (spec-u "##gcd"))
(def-spec "imag-part"          (spec-u "##imag-part"))
(def-spec "inexact->exact"     (spec-u "##inexact->exact"))
(def-spec "inexact?"           (spec-u "##inexact?"))
(def-spec "integer?"           (spec-s "##integer?"))
(def-spec "lcm"                (spec-u "##lcm"))
(def-spec "log"                (spec-arith #f "fllog" "##log"))
(def-spec "##log"              (spec-arith #f "##fllog"))
(def-spec "magnitude"          (spec-u "##magnitude"))
(def-spec "make-polar"         (spec-u "##make-polar"))
(def-spec "make-rectangular"   (spec-u "##make-rectangular"))
(def-spec "max"                (spec-arith "fxmax"   "flmax" "##max"))
(def-spec "##max"              (spec-arith "##fxmax" "##flmax"))
(def-spec "min"                (spec-arith "fxmin"   "flmin" "##min"))
(def-spec "##min"              (spec-arith "##fxmin" "##flmin"))
(def-spec "modulo"             (spec-arith "fxmodulo"   #f "##modulo"))
(def-spec "##modulo"           (spec-arith "##fxmodulo"))
(def-spec "negative?"          (spec-arith "fxnegative?"   "flnegative?" "##negative?"))
(def-spec "##negative?"        (spec-arith "##fxnegative?" "##flnegative?"))
(def-spec "number->string"     (spec-u "##number->string"))
(def-spec "number?"            (spec-s "##number?"))
(def-spec "numerator"          (spec-u "##numerator"))
(def-spec "odd?"               (spec-arith "fxodd?"   "flodd?" "##odd?"))
(def-spec "##odd?"             (spec-arith "##fxodd?" "##flodd?"))
(def-spec "positive?"          (spec-arith "fxpositive?"   "flpositive?" "##positive?"))
(def-spec "##positive?"        (spec-arith "##fxpositive?" "##flpositive?"))
(def-spec "quotient"           (spec-arith "fxquotient"   #f "##quotient"))
(def-spec "##quotient"         (spec-arith "##fxquotient"))
(def-spec "rational?"          (spec-s "##rational?"))
(def-spec "rationalize"        (spec-u "##rationalize"))
(def-spec "real-part"          (spec-u "##real-part"))
(def-spec "real?"              (spec-s "##real?"))
(def-spec "remainder"          (spec-arith "fxremainder"   #f "##remainder"))
(def-spec "##remainder"        (spec-arith "##fxremainder"))
(def-spec "round"              (spec-arith "##identity" "flround" "##round"))
(def-spec "##round"            (spec-arith "##identity" "##flround"))
(def-spec "sin"                (spec-arith #f "flsin" "##sin"))
(def-spec "##sin"              (spec-arith #f "##flsin"))
(def-spec "sqrt"               (spec-arith #f "flsqrt" "##sqrt"))
(def-spec "##sqrt"             (spec-arith #f "##flsqrt"))
(def-spec "string->number"     (spec-u "##string->number"))
(def-spec "tan"                (spec-arith #f "fltan" "##tan"))
(def-spec "##tan"              (spec-arith #f "##fltan"))
(def-spec "truncate"           (spec-arith "##identity" "fltruncate" "##truncate"))
(def-spec "##truncate"         (spec-arith "##identity" "##fltruncate"))
(def-spec "zero?"              (spec-arith "fxzero?"   "flzero?" "##zero?"))
(def-spec "##zero?"            (spec-arith "##fxzero?" "##flzero?"))

(def-spec "bitwise-and"        (spec-arith "fxand"     #f "##bitwise-and"))
(def-spec "##bitwise-and"      (spec-arith "##fxand"))
(def-spec "bitwise-andc1"      (spec-arith "fxandc1"   #f "##bitwise-andc1"))
(def-spec "##bitwise-andc1"    (spec-arith "##fxandc1"))
(def-spec "bitwise-andc2"      (spec-arith "fxandc2"   #f "##bitwise-andc2"))
(def-spec "##bitwise-andc2"    (spec-arith "##fxandc2"))
(def-spec "bitwise-eqv"        (spec-arith "fxeqv"     #f "##bitwise-eqv"))
(def-spec "##bitwise-eqv"      (spec-arith "##fxeqv"))
(def-spec "bitwise-ior"        (spec-arith "fxior"     #f "##bitwise-ior"))
(def-spec "##bitwise-ior"      (spec-arith "##fxior"))
(def-spec "bitwise-nand"       (spec-arith "fxnand"    #f "##bitwise-nand"))
(def-spec "##bitwise-nand"     (spec-arith "##fxnand"))
(def-spec "bitwise-nor"        (spec-arith "fxnor"     #f "##bitwise-nor"))
(def-spec "##bitwise-nor"      (spec-arith "##fxnor"))
(def-spec "bitwise-not"        (spec-arith "fxnot"     #f "##bitwise-not"))
(def-spec "##bitwise-not"      (spec-arith "##fxnot"))
(def-spec "bitwise-orc1"       (spec-arith "fxorc1"    #f "##bitwise-orc1"))
(def-spec "##bitwise-orc1"     (spec-arith "##fxorc1"))
(def-spec "bitwise-orc2"       (spec-arith "fxorc2"    #f "##bitwise-orc2"))
(def-spec "##bitwise-orc2"     (spec-arith "##fxorc2"))
(def-spec "bitwise-xor"        (spec-arith "fxxor"     #f "##bitwise-xor"))
(def-spec "##bitwise-xor"      (spec-arith "##fxxor"))

(def-spec "exact-integer-sqrt" (spec-u "##exact-integer-sqrt"))
(def-spec "finite?"            (spec-arith #f "flfinite?" "##finite?"))
(def-spec "##finite?"          (spec-arith #f "##flfinite?"))
(def-spec "infinite?"          (spec-arith #f "flinfinite?" "##infinite?"))
(def-spec "##infinite?"        (spec-arith #f "##flinfinite?"))
(def-spec "nan?"               (spec-arith #f "flnan?" "##nan?"))
(def-spec "##nan?"             (spec-arith #f "##flnan?"))
(def-spec "inexact"            (spec-u "##inexact"))
(def-spec "exact"              (spec-u "##exact"))

(def-spec "exact-integer?"     (spec-s "##exact-integer?"))
(def-spec "floor-quotient"     (spec-u "##floor-quotient"))
(def-spec "floor-remainder"    (spec-u "##floor-remainder"))
(def-spec "floor/"             (spec-u "##floor/"))
(def-spec "square"             (spec-arith "fxsquare"   "flsquare" "##square"))
(def-spec "##square"           (spec-arith "##fxsquare" "##flsquare"))
(def-spec "truncate-quotient"  (spec-u "##truncate-quotient"))
(def-spec "truncate-remainder" (spec-u "##truncate-remainder"))
(def-spec "truncate/"          (spec-u "##truncate/"))

(def-spec "acosh"              (spec-arith #f "flacosh" "##acosh"))
(def-spec "##acosh"            (spec-arith #f "##flacosh"))
(def-spec "all-bits-set?"      (spec-u "##all-bits-set?"))
(def-spec "any-bits-set?"      (spec-u "##any-bits-set?"))
(def-spec "arithmetic-shift"   (spec-arith "fxarithmetic-shift"   #f "##arithmetic-shift"))
(def-spec "##arithmetic-shift" (spec-arith "##fxarithmetic-shift"))
(def-spec "asinh"              (spec-arith #f "flasinh" "##asinh"))
(def-spec "##asinh"            (spec-arith #f "##flasinh"))
(def-spec "atanh"              (spec-arith #f "flatanh" "##atanh"))
(def-spec "##atanh"            (spec-arith #f "##flatanh"))
(def-spec "bit-count"          (spec-u "##bit-count"))
(def-spec "bit-set?"           (spec-u "##bit-set?"))
(def-spec "bitwise-merge"      (spec-u "##bitwise-merge"))
(def-spec "clear-bit-field"    (spec-u "##clear-bit-field"))
(def-spec "conjugate"          (spec-u "##conjugate"))
(def-spec "copy-bit-field"     (spec-u "##copy-bit-field"))
(def-spec "cosh"               (spec-arith #f "flcosh" "##cosh"))
(def-spec "##cosh"             (spec-arith #f "##flcosh"))
(def-spec "extract-bit-field"  (spec-u "##extract-bit-field"))
(def-spec "first-set-bit"      (spec-u "##first-set-bit"))
(def-spec "integer-length"     (spec-u "##integer-length"))
(def-spec "integer-nth-root"   (spec-u "##integer-nth-root"))
(def-spec "integer-sqrt"       (spec-u "##integer-sqrt"))
(def-spec "replace-bit-field"  (spec-u "##replace-bit-field"))
(def-spec "sinh"               (spec-arith #f "flsinh" "##sinh"))
(def-spec "##sinh"             (spec-arith #f "##flsinh"))
(def-spec "tanh"               (spec-arith #f "fltanh" "##tanh"))
(def-spec "##tanh"             (spec-arith #f "##fltanh"))
(def-spec "test-bit-field?"    (spec-u "##test-bit-field?"))

#|
(def-spec "##*" (spec-nargs #f "##identity" "##*2"))
(def-spec "##+" (spec-nargs #f "##identity" "##+2"))
(def-spec "##-" (spec-nargs #f "##negate"   "##-2"))
(def-spec "##/" (spec-nargs #f "##inverse"  "##/2"))

(def-spec "##=" (spec-nargs #f #f "##=2"))
(def-spec "##<" (spec-nargs #f #f "##<2"))

(def-spec "##max" (spec-nargs #f "##identity" "##max2"))
(def-spec "##min" (spec-nargs #f "##identity" "##min2"))

(def-spec "##gcd" (spec-nargs #f "##identity" "##gcd2"))
(def-spec "##lcm" (spec-nargs #f "##identity" "##lcm2"))

(def-spec "##bitwise-ior" (spec-nargs #f "##identity" "##bitwise-ior2"))
(def-spec "##bitwise-xor" (spec-nargs #f "##identity" "##bitwise-xor2"))
(def-spec "##bitwise-and" (spec-nargs #f "##identity" "##bitwise-and2"))
|#

;; fixnum

(def-spec "fixnum?"            (spec-s "##fixnum?"))
(def-spec "fx*"                (spec-u "##fx*"))
(def-spec "fx+"                (spec-u "##fx+"))
(def-spec "fx-"                (spec-u "##fx-"))
(def-spec "fx<"                (spec-u "##fx<"))
(def-spec "fx<="               (spec-u "##fx<="))
(def-spec "fx="                (spec-u "##fx="))
(def-spec "fx>"                (spec-u "##fx>"))
(def-spec "fx>="               (spec-u "##fx>="))
(def-spec "fxand"              (spec-u "##fxand"))
(def-spec "fxandc1"            (spec-u "##fxandc1"))
(def-spec "fxandc2"            (spec-u "##fxandc2"))
(def-spec "fxarithmetic-shift" (spec-u "##fxarithmetic-shift"))
(def-spec "fxarithmetic-shift-left" (spec-u "##fxarithmetic-shift-left"))
(def-spec "fxarithmetic-shift-right" (spec-u "##fxarithmetic-shift-right"))
(def-spec "fxbit-count"        (spec-u "##fxbit-count"))
(def-spec "fxbit-set?"         (spec-u "##fxbit-set?"))
(def-spec "fxeqv"              (spec-u "##fxeqv"))
(def-spec "fxeven?"            (spec-u "##fxeven?"))
(def-spec "fxfirst-set-bit"    (spec-u "##fxfirst-set-bit"))
(def-spec "fxif"               (spec-u "##fxif"))
(def-spec "fxior"              (spec-u "##fxior"))
(def-spec "fxlength"           (spec-u "##fxlength"))
(def-spec "fxmax"              (spec-u "##fxmax"))
(def-spec "fxmin"              (spec-u "##fxmin"))
(def-spec "fxmodulo"           (spec-u "##fxmodulo"))
(def-spec "fxnegative?"        (spec-u "##fxnegative?"))
(def-spec "fxnand"             (spec-u "##fxnot"))
(def-spec "fxnor"              (spec-u "##fxnot"))
(def-spec "fxnot"              (spec-u "##fxnot"))
(def-spec "fxodd?"             (spec-u "##fxodd?"))
(def-spec "fxorc1"             (spec-u "##fxorc1"))
(def-spec "fxorc2"             (spec-u "##fxorc2"))
(def-spec "fxpositive?"        (spec-u "##fxpositive?"))
(def-spec "fxquotient"         (spec-u "##fxquotient"))
(def-spec "fxremainder"        (spec-u "##fxremainder"))
(def-spec "fxxor"              (spec-u "##fxxor"))
(def-spec "fxzero?"            (spec-u "##fxzero?"))

(def-spec "fxabs"              (spec-u "##fxabs"))
(def-spec "fxsquare"           (spec-u "##fxsquare"))
(def-spec "fxwrap*"            (spec-u "##fxwrap*"))
(def-spec "fxwrap+"            (spec-u "##fxwrap+"))
(def-spec "fxwrap-"            (spec-u "##fxwrap-"))
(def-spec "fxwrapabs"          (spec-u "##fxwrapabs"))
(def-spec "fxwraparithmetic-shift" (spec-u "##fxwraparithmetic-shift"))
(def-spec "fxwraparithmetic-shift-left" (spec-u "##fxwraparithmetic-shift-left"))
(def-spec "fxwraplogical-shift-right" (spec-u "##fxwraplogical-shift-right"))
(def-spec "fxwrapquotient"     (spec-u "##fxwrapquotient"))
(def-spec "fxwrapsquare"       (spec-u "##fxwrapsquare"))

(def-spec "##fx*?"                      (spec-arith-no-overflow "##fx*"))
(def-spec "##fx+?"                      (spec-arith-no-overflow "##fx+"))
(def-spec "##fx-?"                      (spec-arith-no-overflow "##fx-"))
(def-spec "##fxarithmetic-shift?"       (spec-arith-no-overflow "##fxarithmetic-shift"))
(def-spec "##fxarithmetic-shift-left?"  (spec-arith-no-overflow "##fxarithmetic-shift-left"))
(def-spec "##fxarithmetic-shift-right?" (spec-arith-no-overflow "##fxarithmetic-shift-right"))
(def-spec "##fxabs?"                    (spec-arith-no-overflow "##fxabs"))
(def-spec "##fxsquare?"                 (spec-arith-no-overflow "##fxsquare"))

;; flonum

(def-spec "fixnum->flonum"     (spec-u "##fixnum->flonum"))
(def-spec "fl*"                (spec-u "##fl*"))
(def-spec "fl+"                (spec-u "##fl+"))
(def-spec "fl-"                (spec-u "##fl-"))
(def-spec "fl/"                (spec-u "##fl/"))
(def-spec "fl<"                (spec-u "##fl<"))
(def-spec "fl<="               (spec-u "##fl<="))
(def-spec "fl="                (spec-u "##fl="))
(def-spec "fl>"                (spec-u "##fl>"))
(def-spec "fl>="               (spec-u "##fl>="))
(def-spec "flabs"              (spec-u "##flabs"))
(def-spec "flacos"             (spec-u "##flacos"))
(def-spec "flasin"             (spec-u "##flasin"))
(def-spec "flatan"             (spec-u "##flatan"))
(def-spec "flceiling"          (spec-u "##flceiling"))
(def-spec "flcos"              (spec-u "##flcos"))
(def-spec "fldenominator"      (spec-u "##fldenominator"))
(def-spec "fleven?"            (spec-u "##fleven?"))
(def-spec "flexp"              (spec-u "##flexp"))
(def-spec "flexpt"             (spec-u "##flexpt"))
(def-spec "flfinite?"          (spec-u "##flfinite?"))
(def-spec "flfloor"            (spec-u "##flfloor"))
(def-spec "flinfinite?"        (spec-u "##flinfinite?"))
(def-spec "flinteger?"         (spec-u "##flinteger?"))
(def-spec "fllog"              (spec-u "##fllog"))
(def-spec "flmax"              (spec-u "##flmax"))
(def-spec "flmin"              (spec-u "##flmin"))
(def-spec "flnan?"             (spec-u "##flnan?"))
(def-spec "flnegative?"        (spec-u "##flnegative?"))
(def-spec "flnumerator"        (spec-u "##flnumerator"))
(def-spec "flodd?"             (spec-u "##flodd?"))
(def-spec "flonum?"            (spec-s "##flonum?"))
(def-spec "flpositive?"        (spec-u "##flpositive?"))
(def-spec "flround"            (spec-u "##flround"))
(def-spec "flsin"              (spec-u "##flsin"))
(def-spec "flsqrt"             (spec-u "##flsqrt"))
(def-spec "fltan"              (spec-u "##fltan"))
(def-spec "fltruncate"         (spec-u "##fltruncate"))
(def-spec "flzero?"            (spec-u "##flzero?"))

(def-spec "flacosh"            (spec-u "##flacosh"))
(def-spec "flasinh"            (spec-u "##flasinh"))
(def-spec "flatanh"            (spec-u "##flatanh"))
(def-spec "flcosh"             (spec-u "##flcosh"))
(def-spec "flexpm1"            (spec-u "##flexpm1"))
(def-spec "flhypot"            (spec-u "##flhypot"))
(def-spec "flilogb"            (spec-u "##flilogb"))
(def-spec "fllog1p"            (spec-u "##fllog1p"))
(def-spec "flscalbn"           (spec-u "##flscalbn"))
(def-spec "flsinh"             (spec-u "##flsinh"))
(def-spec "flsquare"           (spec-u "##flsquare"))
(def-spec "fltanh"             (spec-u "##fltanh"))

;; list

(def-spec "append"             (spec-u "##append"))
(def-spec "assoc"              (spec-u "##assoc"))
(def-spec "assq"               (spec-u "##assq"))
(def-spec "assv"               (spec-u "##assv"))
(def-spec "caaaar"             (spec-u "##caaaar"))
(def-spec "caaadr"             (spec-u "##caaadr"))
(def-spec "caaar"              (spec-u "##caaar"))
(def-spec "caadar"             (spec-u "##caadar"))
(def-spec "caaddr"             (spec-u "##caaddr"))
(def-spec "caadr"              (spec-u "##caadr"))
(def-spec "caar"               (spec-u "##caar"))
(def-spec "cadaar"             (spec-u "##cadaar"))
(def-spec "cadadr"             (spec-u "##cadadr"))
(def-spec "cadar"              (spec-u "##cadar"))
(def-spec "caddar"             (spec-u "##caddar"))
(def-spec "cadddr"             (spec-u "##cadddr"))
(def-spec "caddr"              (spec-u "##caddr"))
(def-spec "cadr"               (spec-u "##cadr"))
(def-spec "car"                (spec-u "##car"))
(def-spec "cdaaar"             (spec-u "##cdaaar"))
(def-spec "cdaadr"             (spec-u "##cdaadr"))
(def-spec "cdaar"              (spec-u "##cdaar"))
(def-spec "cdadar"             (spec-u "##cdadar"))
(def-spec "cdaddr"             (spec-u "##cdaddr"))
(def-spec "cdadr"              (spec-u "##cdadr"))
(def-spec "cdar"               (spec-u "##cdar"))
(def-spec "cddaar"             (spec-u "##cddaar"))
(def-spec "cddadr"             (spec-u "##cddadr"))
(def-spec "cddar"              (spec-u "##cddar"))
(def-spec "cdddar"             (spec-u "##cdddar"))
(def-spec "cddddr"             (spec-u "##cddddr"))
(def-spec "cdddr"              (spec-u "##cdddr"))
(def-spec "cddr"               (spec-u "##cddr"))
(def-spec "cdr"                (spec-u "##cdr"))
(def-spec "cons"               (spec-s "##cons"))
(def-spec "length"             (spec-u "##length"))
(def-spec "list"               (spec-s "##list"))
(def-spec "list-ref"           (spec-u "##list-ref"))
(def-spec "list?"              (spec-s "##list?"))
(def-spec "member"             (spec-u "##member"))
(def-spec "memq"               (spec-u "##memq"))
(def-spec "memv"               (spec-u "##memv"))
(def-spec "null?"              (spec-s "##null?"))
(def-spec "pair?"              (spec-s "##pair?"))
(def-spec "reverse"            (spec-u "##reverse"))
(def-spec "set-car!"           (spec-u "##set-car!"))
(def-spec "set-cdr!"           (spec-u "##set-cdr!"))

(def-spec "list-tail"          (spec-u "##list-tail"))

(def-spec "make-list"          (spec-u "##make-list"))
(def-spec "list-copy"          (spec-u "##list-copy"))
(def-spec "list-set!"          (spec-u "##list-set!"))

(def-spec "circular-list"      (spec-s "##circular-list"))
(def-spec "cons*"              (spec-s "##cons*"))
(def-spec "drop"               (spec-u "##drop"))
(def-spec "fold"               (spec-u "##fold"))
(def-spec "fold-right"         (spec-u "##fold-right"))
(def-spec "iota"               (spec-u "##iota"))
(def-spec "last"               (spec-u "##last"))
(def-spec "last-pair"          (spec-u "##last-pair"))
(def-spec "list-set"           (spec-u "##list-set"))
(def-spec "list-tabulate"      (spec-u "##list-tabulate"))
(def-spec "reverse!"           (spec-u "##reverse!"))
(def-spec "take"               (spec-u "##take"))
(def-spec "xcons"              (spec-s "##xcons"))

;; char

(def-spec "char->integer"      (spec-u "##char->integer"))
(def-spec "char-alphabetic?"   (spec-u "##char-alphabetic?"))
(def-spec "char-ci<=?"         (spec-u "##char-ci<=?"))
(def-spec "char-ci<?"          (spec-u "##char-ci<?"))
(def-spec "char-ci=?"          (spec-u "##char-ci=?"))
(def-spec "char-ci>=?"         (spec-u "##char-ci>=?"))
(def-spec "char-ci>?"          (spec-u "##char-ci>?"))
(def-spec "char-downcase"      (spec-u "##char-downcase"))
(def-spec "char-lower-case?"   (spec-u "##char-lower-case?"))
(def-spec "char-numeric?"      (spec-u "##char-numeric?"))
(def-spec "char-upcase"        (spec-u "##char-upcase"))
(def-spec "char-upper-case?"   (spec-u "##char-upper-case?"))
(def-spec "char-whitespace?"   (spec-u "##char-whitespace?"))
(def-spec "char<=?"            (spec-u "##char<=?"))
(def-spec "char<?"             (spec-u "##char<?"))
(def-spec "char=?"             (spec-u "##char=?"))
(def-spec "char>=?"            (spec-u "##char>=?"))
(def-spec "char>?"             (spec-u "##char>?"))
(def-spec "char?"              (spec-s "##char?"))
(def-spec "integer->char"      (spec-u "##integer->char"))

(def-spec "char-foldcase"      (spec-u "##char-foldcase"))
(def-spec "digit-value"        (spec-u "##digit-value"))

;; string

(def-spec "list->string"       (spec-u "##list->string"))
(def-spec "make-string"        (spec-u "##make-string"))
(def-spec "substring"          (spec-u "##substring"))
(def-spec "string"             (spec-u "##string"))
(def-spec "string->list"       (spec-u "##string->list"))
(def-spec "string-append"      (spec-u "##string-append"))
(def-spec "string-copy"        (spec-u "##string-copy"))
(def-spec "string-fill!"       (spec-u "##string-fill!"))
(def-spec "string-length"      (spec-u "##string-length"))
(def-spec "string-ref"         (spec-u "##string-ref"))
(def-spec "string-set!"        (spec-u "##string-set!"))
(def-spec "string?"            (spec-s "##string?"))
(def-spec "string<=?"          (spec-u "##string<=?"))
(def-spec "string<?"           (spec-u "##string<?"))
(def-spec "string=?"           (spec-u "##string=?"))
(def-spec "string>=?"          (spec-u "##string>=?"))
(def-spec "string>?"           (spec-u "##string>?"))
(def-spec "string-ci<=?"       (spec-u "##string-ci<=?"))
(def-spec "string-ci<?"        (spec-u "##string-ci<?"))
(def-spec "string-ci=?"        (spec-u "##string-ci=?"))
(def-spec "string-ci>=?"       (spec-u "##string-ci>=?"))
(def-spec "string-ci>?"        (spec-u "##string-ci>?"))

(def-spec "string->utf8"       (spec-u "##string->utf8"))
(def-spec "string-copy!"       (spec-u "##string-copy!"))
(def-spec "string-foldcase"    (spec-u "##string-foldcase"))
(def-spec "utf8->string"       (spec-u "##utf8->string"))

(def-spec "string-concatenate" (spec-u "##string-concatenate"))
(def-spec "substring-fill!"    (spec-u "##substring-fill!"))
(def-spec "substring-move!"    (spec-u "##substring-move!"))
(def-spec "string-set"         (spec-u "##string-set"))
(def-spec "string-shrink!"     (spec-u "##string-shrink!"))

;; vector

(def-spec "list->vector"       (spec-u "##list->vector"))
(def-spec "make-vector"        (spec-u "##make-vector"))
(def-spec "vector"             (spec-s "##vector"))
(def-spec "vector->list"       (spec-u "##vector->list"))
(def-spec "vector-fill!"       (spec-u "##vector-fill!"))
(def-spec "vector-length"      (spec-u "##vector-length"))
(def-spec "vector-ref"         (spec-u "##vector-ref"))
(def-spec "vector-set!"        (spec-u "##vector-set!"))
(def-spec "vector?"            (spec-s "##vector?"))

(def-spec "vector-append"      (spec-u "##vector-append"))
(def-spec "vector-copy"        (spec-u "##vector-copy"))
(def-spec "vector-copy!"       (spec-u "##vector-copy!"))

(def-spec "vector-concatenate" (spec-u "##vector-concatenate"))
(def-spec "subvector"          (spec-u "##subvector"))
(def-spec "subvector-fill!"    (spec-u "##subvector-fill!"))
(def-spec "subvector-move!"    (spec-u "##subvector-move!"))
(def-spec "vector-cas!"        (spec-u "##vector-cas!"))
(def-spec "vector-inc!"        (spec-u "##vector-inc!"))
(def-spec "vector-set"         (spec-u "##vector-set"))
(def-spec "vector-shrink!"     (spec-u "##vector-shrink!"))

;; homogeneous vector

(def-spec "s8vector-concatenate"(spec-u "##s8vector-concatenate"))
(def-spec "list->s8vector"     (spec-u "##list->s8vector"))
(def-spec "make-s8vector"      (spec-u "##make-s8vector"))
(def-spec "subs8vector"        (spec-u "##subs8vector"))
(def-spec "subs8vector-fill!"  (spec-u "##subs8vector-fill!"))
(def-spec "subs8vector-move!"  (spec-u "##subs8vector-move!"))
(def-spec "s8vector"           (spec-u "##s8vector"))
(def-spec "s8vector->list"     (spec-u "##s8vector->list"))
(def-spec "s8vector-append"    (spec-u "##s8vector-append"))
(def-spec "s8vector-copy"      (spec-u "##s8vector-copy"))
(def-spec "s8vector-copy!"     (spec-u "##s8vector-copy!"))
(def-spec "s8vector-fill!"     (spec-u "##s8vector-fill!"))
(def-spec "s8vector-length"    (spec-u "##s8vector-length"))
(def-spec "s8vector-ref"       (spec-u "##s8vector-ref"))
(def-spec "s8vector-set"       (spec-u "##s8vector-set"))
(def-spec "s8vector-set!"      (spec-u "##s8vector-set!"))
(def-spec "s8vector-shrink!"   (spec-u "##s8vector-shrink!"))
(def-spec "s8vector?"          (spec-s "##s8vector?"))

(def-spec "u8vector-concatenate"(spec-u "##u8vector-concatenate"))
(def-spec "list->u8vector"     (spec-u "##list->u8vector"))
(def-spec "make-u8vector"      (spec-u "##make-u8vector"))
(def-spec "subu8vector"        (spec-u "##subu8vector"))
(def-spec "subu8vector-fill!"  (spec-u "##subu8vector-fill!"))
(def-spec "subu8vector-move!"  (spec-u "##subu8vector-move!"))
(def-spec "u8vector"           (spec-u "##u8vector"))
(def-spec "u8vector->list"     (spec-u "##u8vector->list"))
(def-spec "u8vector-append"    (spec-u "##u8vector-append"))
(def-spec "u8vector-copy"      (spec-u "##u8vector-copy"))
(def-spec "u8vector-copy!"     (spec-u "##u8vector-copy!"))
(def-spec "u8vector-fill!"     (spec-u "##u8vector-fill!"))
(def-spec "u8vector-length"    (spec-u "##u8vector-length"))
(def-spec "u8vector-ref"       (spec-u "##u8vector-ref"))
(def-spec "u8vector-set"       (spec-u "##u8vector-set"))
(def-spec "u8vector-set!"      (spec-u "##u8vector-set!"))
(def-spec "u8vector-shrink!"   (spec-u "##u8vector-shrink!"))
(def-spec "u8vector?"          (spec-s "##u8vector?"))

(def-spec "s16vector-concatenate"(spec-u "##s16vector-concatenate"))
(def-spec "list->s16vector"    (spec-u "##list->s16vector"))
(def-spec "make-s16vector"     (spec-u "##make-s16vector"))
(def-spec "subs16vector"       (spec-u "##subs16vector"))
(def-spec "subs16vector-fill!" (spec-u "##subs16vector-fill!"))
(def-spec "subs16vector-move!" (spec-u "##subs16vector-move!"))
(def-spec "s16vector"          (spec-u "##s16vector"))
(def-spec "s16vector->list"    (spec-u "##s16vector->list"))
(def-spec "s16vector-append"   (spec-u "##s16vector-append"))
(def-spec "s16vector-copy"     (spec-u "##s16vector-copy"))
(def-spec "s16vector-copy!"    (spec-u "##s16vector-copy!"))
(def-spec "s16vector-fill!"    (spec-u "##s16vector-fill!"))
(def-spec "s16vector-length"   (spec-u "##s16vector-length"))
(def-spec "s16vector-ref"      (spec-u "##s16vector-ref"))
(def-spec "s16vector-set"      (spec-u "##s16vector-set"))
(def-spec "s16vector-set!"     (spec-u "##s16vector-set!"))
(def-spec "s16vector-shrink!"  (spec-u "##s16vector-shrink!"))
(def-spec "s16vector?"         (spec-s "##s16vector?"))

(def-spec "u16vector-concatenate"(spec-u "##u16vector-concatenate"))
(def-spec "list->u16vector"    (spec-u "##list->u16vector"))
(def-spec "make-u16vector"     (spec-u "##make-u16vector"))
(def-spec "subu16vector"       (spec-u "##subu16vector"))
(def-spec "subu16vector-fill!" (spec-u "##subu16vector-fill!"))
(def-spec "subu16vector-move!" (spec-u "##subu16vector-move!"))
(def-spec "u16vector"          (spec-u "##u16vector"))
(def-spec "u16vector->list"    (spec-u "##u16vector->list"))
(def-spec "u16vector-append"   (spec-u "##u16vector-append"))
(def-spec "u16vector-copy"     (spec-u "##u16vector-copy"))
(def-spec "u16vector-copy!"    (spec-u "##u16vector-copy!"))
(def-spec "u16vector-fill!"    (spec-u "##u16vector-fill!"))
(def-spec "u16vector-length"   (spec-u "##u16vector-length"))
(def-spec "u16vector-ref"      (spec-u "##u16vector-ref"))
(def-spec "u16vector-set"      (spec-u "##u16vector-set"))
(def-spec "u16vector-set!"     (spec-u "##u16vector-set!"))
(def-spec "u16vector-shrink!"  (spec-u "##u16vector-shrink!"))
(def-spec "u16vector?"         (spec-s "##u16vector?"))

(def-spec "s32vector-concatenate"(spec-u "##s32vector-concatenate"))
(def-spec "list->s32vector"    (spec-u "##list->s32vector"))
(def-spec "make-s32vector"     (spec-u "##make-s32vector"))
(def-spec "subs32vector"       (spec-u "##subs32vector"))
(def-spec "subs32vector-fill!" (spec-u "##subs32vector-fill!"))
(def-spec "subs32vector-move!" (spec-u "##subs32vector-move!"))
(def-spec "s32vector"          (spec-u "##s32vector"))
(def-spec "s32vector->list"    (spec-u "##s32vector->list"))
(def-spec "s32vector-append"   (spec-u "##s32vector-append"))
(def-spec "s32vector-copy"     (spec-u "##s32vector-copy"))
(def-spec "s32vector-copy!"    (spec-u "##s32vector-copy!"))
(def-spec "s32vector-fill!"    (spec-u "##s32vector-fill!"))
(def-spec "s32vector-length"   (spec-u "##s32vector-length"))
(def-spec "s32vector-ref"      (spec-u "##s32vector-ref"))
(def-spec "s32vector-set"      (spec-u "##s32vector-set"))
(def-spec "s32vector-set!"     (spec-u "##s32vector-set!"))
(def-spec "s32vector-shrink!"  (spec-u "##s32vector-shrink!"))
(def-spec "s32vector?"         (spec-s "##s32vector?"))

(def-spec "u32vector-concatenate"(spec-u "##u32vector-concatenate"))
(def-spec "list->u32vector"    (spec-u "##list->u32vector"))
(def-spec "make-u32vector"     (spec-u "##make-u32vector"))
(def-spec "subu32vector"       (spec-u "##subu32vector"))
(def-spec "subu32vector-fill!" (spec-u "##subu32vector-fill!"))
(def-spec "subu32vector-move!" (spec-u "##subu32vector-move!"))
(def-spec "u32vector"          (spec-u "##u32vector"))
(def-spec "u32vector->list"    (spec-u "##u32vector->list"))
(def-spec "u32vector-append"   (spec-u "##u32vector-append"))
(def-spec "u32vector-copy"     (spec-u "##u32vector-copy"))
(def-spec "u32vector-copy!"    (spec-u "##u32vector-copy!"))
(def-spec "u32vector-fill!"    (spec-u "##u32vector-fill!"))
(def-spec "u32vector-length"   (spec-u "##u32vector-length"))
(def-spec "u32vector-ref"      (spec-u "##u32vector-ref"))
(def-spec "u32vector-set"      (spec-u "##u32vector-set"))
(def-spec "u32vector-set!"     (spec-u "##u32vector-set!"))
(def-spec "u32vector-shrink!"  (spec-u "##u32vector-shrink!"))
(def-spec "u32vector?"         (spec-s "##u32vector?"))

(def-spec "s64vector-concatenate"(spec-u "##s64vector-concatenate"))
(def-spec "list->s64vector"    (spec-u "##list->s64vector"))
(def-spec "make-s64vector"     (spec-u "##make-s64vector"))
(def-spec "subs64vector"       (spec-u "##subs64vector"))
(def-spec "subs64vector-fill!" (spec-u "##subs64vector-fill!"))
(def-spec "subs64vector-move!" (spec-u "##subs64vector-move!"))
(def-spec "s64vector"          (spec-u "##s64vector"))
(def-spec "s64vector->list"    (spec-u "##s64vector->list"))
(def-spec "s64vector-append"   (spec-u "##s64vector-append"))
(def-spec "s64vector-copy"     (spec-u "##s64vector-copy"))
(def-spec "s64vector-copy!"    (spec-u "##s64vector-copy!"))
(def-spec "s64vector-fill!"    (spec-u "##s64vector-fill!"))
(def-spec "s64vector-length"   (spec-u "##s64vector-length"))
(def-spec "s64vector-ref"      (spec-u "##s64vector-ref"))
(def-spec "s64vector-set"      (spec-u "##s64vector-set"))
(def-spec "s64vector-set!"     (spec-u "##s64vector-set!"))
(def-spec "s64vector-shrink!"  (spec-u "##s64vector-shrink!"))
(def-spec "s64vector?"         (spec-s "##s64vector?"))

(def-spec "u64vector-concatenate"(spec-u "##u64vector-concatenate"))
(def-spec "list->u64vector"    (spec-u "##list->u64vector"))
(def-spec "make-u64vector"     (spec-u "##make-u64vector"))
(def-spec "subu64vector"       (spec-u "##subu64vector"))
(def-spec "subu64vector-fill!" (spec-u "##subu64vector-fill!"))
(def-spec "subu64vector-move!" (spec-u "##subu64vector-move!"))
(def-spec "u64vector"          (spec-u "##u64vector"))
(def-spec "u64vector->list"    (spec-u "##u64vector->list"))
(def-spec "u64vector-append"   (spec-u "##u64vector-append"))
(def-spec "u64vector-copy"     (spec-u "##u64vector-copy"))
(def-spec "u64vector-copy!"    (spec-u "##u64vector-copy!"))
(def-spec "u64vector-fill!"    (spec-u "##u64vector-fill!"))
(def-spec "u64vector-length"   (spec-u "##u64vector-length"))
(def-spec "u64vector-ref"      (spec-u "##u64vector-ref"))
(def-spec "u64vector-set"      (spec-u "##u64vector-set"))
(def-spec "u64vector-set!"     (spec-u "##u64vector-set!"))
(def-spec "u64vector-shrink!"  (spec-u "##u64vector-shrink!"))
(def-spec "u64vector?"         (spec-s "##u64vector?"))

(def-spec "f32vector-concatenate"(spec-u "##f32vector-concatenate"))
(def-spec "list->f32vector"    (spec-u "##list->f32vector"))
(def-spec "make-f32vector"     (spec-u "##make-f32vector"))
(def-spec "subf32vector"       (spec-u "##subf32vector"))
(def-spec "subf32vector-fill!" (spec-u "##subf32vector-fill!"))
(def-spec "subf32vector-move!" (spec-u "##subf32vector-move!"))
(def-spec "f32vector"          (spec-u "##f32vector"))
(def-spec "f32vector->list"    (spec-u "##f32vector->list"))
(def-spec "f32vector-append"   (spec-u "##f32vector-append"))
(def-spec "f32vector-copy"     (spec-u "##f32vector-copy"))
(def-spec "f32vector-copy!"    (spec-u "##f32vector-copy!"))
(def-spec "f32vector-fill!"    (spec-u "##f32vector-fill!"))
(def-spec "f32vector-length"   (spec-u "##f32vector-length"))
(def-spec "f32vector-ref"      (spec-u "##f32vector-ref"))
(def-spec "f32vector-set"      (spec-u "##f32vector-set"))
(def-spec "f32vector-set!"     (spec-u "##f32vector-set!"))
(def-spec "f32vector-shrink!"  (spec-u "##f32vector-shrink!"))
(def-spec "f32vector?"         (spec-s "##f32vector?"))

(def-spec "f64vector-concatenate"(spec-u "##f64vector-concatenate"))
(def-spec "list->f64vector"    (spec-u "##list->f64vector"))
(def-spec "make-f64vector"     (spec-u "##make-f64vector"))
(def-spec "subf64vector"       (spec-u "##subf64vector"))
(def-spec "subf64vector-fill!" (spec-u "##subf64vector-fill!"))
(def-spec "subf64vector-move!" (spec-u "##subf64vector-move!"))
(def-spec "f64vector"          (spec-u "##f64vector"))
(def-spec "f64vector->list"    (spec-u "##f64vector->list"))
(def-spec "f64vector-append"   (spec-u "##f64vector-append"))
(def-spec "f64vector-copy"     (spec-u "##f64vector-copy"))
(def-spec "f64vector-copy!"    (spec-u "##f64vector-copy!"))
(def-spec "f64vector-fill!"    (spec-u "##f64vector-fill!"))
(def-spec "f64vector-length"   (spec-u "##f64vector-length"))
(def-spec "f64vector-ref"      (spec-u "##f64vector-ref"))
(def-spec "f64vector-set"      (spec-u "##f64vector-set"))
(def-spec "f64vector-set!"     (spec-u "##f64vector-set!"))
(def-spec "f64vector-shrink!"  (spec-u "##f64vector-shrink!"))
(def-spec "f64vector?"         (spec-s "##f64vector?"))

;; symbol

(def-spec "symbol?"            (spec-s "##symbol?"))
(def-spec "symbol->string"     (spec-u "##symbol->string"))
(def-spec "string->symbol"     (spec-u "##string->symbol"))

(def-spec "symbol=?"           (spec-u "##symbol=?"))

(def-spec "gensym"             (spec-u "##gensym"))
(def-spec "string->uninterned-symbol" (spec-u "##string->uninterned-symbol"))
(def-spec "symbol-hash"        (spec-u "##symbol-hash"))
(def-spec "uninterned-symbol?" (spec-u "##uninterned-symbol?"))

;; keyword

(def-spec "keyword->string"    (spec-u "##keyword->string"))
(def-spec "keyword-hash"       (spec-u "##keyword-hash"))
(def-spec "keyword?"           (spec-s "##keyword?"))
(def-spec "string->keyword"    (spec-u "##string->keyword"))
(def-spec "string->uninterned-keyword" (spec-u "##string->uninterned-keyword"))
(def-spec "uninterned-keyword?" (spec-u "##uninterned-keyword?"))

;; box

(def-spec "box?"               (spec-s "##box?"))
(def-spec "box"                (spec-s "##box"))
(def-spec "unbox"              (spec-u "##unbox"))
(def-spec "set-box!"           (spec-u "##set-box!"))

;; values

(def-spec "call-with-values"   (spec-u "##call-with-values"))
(def-spec "values"             (spec-s "##values"))

;; will

(def-spec "make-will"          (spec-u "##make-will"))
(def-spec "will-testator"      (spec-u "##will-testator"))
(def-spec "will?"              (spec-s "##will?"))

;; port

(def-spec "char-ready?"        (spec-u "##char-ready?"))
(def-spec "read"               (spec-u "##read"))
(def-spec "read-char"          (spec-u "##read-char"))
(def-spec "peek-char"          (spec-u "##peek-char"))
(def-spec "write"              (spec-u "##write"))
(def-spec "display"            (spec-u "##display"))
(def-spec "newline"            (spec-u "##newline"))
(def-spec "write-char"         (spec-u "##write-char"))

(def-spec "eof-object?"        (spec-s "##eof-object?"))
(def-spec "eof-object"         (spec-s "##eof-object"))

(def-spec "##char-ready?" (spec-nargs "##char-ready?0" "##char-ready?1"))
(def-spec "##read-char"   (spec-nargs "##read-char0"   "##read-char1"))
(def-spec "##peek-char"   (spec-nargs "##peek-char0"   "##peek-char1"))
(def-spec "##write-char"  (spec-nargs #f "##write-char1" "##write-char2"))
(def-spec "##newline"     (spec-nargs "##newline0"     "##newline1"))

;; procedure

(def-spec "procedure?"         (spec-s "##procedure?"))
(def-spec "apply"              (spec-u "##apply"))
(def-spec "map"                (spec-u "##map"))
(def-spec "for-each"           (spec-u "##for-each"))

;; control

(def-spec "call-with-current-continuation" (spec-u "##call-with-current-continuation"))
(def-spec "dynamic-wind"       (spec-u "##dynamic-wind"))

(def-spec "continuation?"      (spec-s "##continuation?"))
(def-spec "continuation-capture" (spec-u "##continuation-capture"))
(def-spec "continuation-graft" (spec-u "##continuation-graft"))
(def-spec "continuation-return" (spec-u "##continuation-return"))

(def-spec "call/cc"            (spec-u "##call-with-current-continuation"))

;; promise

(def-spec "force"              (spec-s "##force"))

(def-spec "promise?"           (spec-s "##promise?"))

(def-spec "touch"              (spec-s "##force"))

;; thread

(def-spec "current-thread"     (spec-s "##current-thread"))

;; miscellaneous

(def-spec "eq?"                (spec-s "##eq?"))
(def-spec "equal?"             (spec-s-equal?))
(def-spec "##equal?"           (spec-s-equal?))
(def-spec "eqv?"               (spec-s-eqv?))
(def-spec "##eqv?"             (spec-s-eqv?))

(def-spec "identity"           (spec-s "##identity"))

(def-spec "void"               (spec-s "##void"))

(def-spec "##structure-ref"  (spec-u "##unchecked-structure-ref"))
(def-spec "##structure-set!" (spec-u "##unchecked-structure-set!"))
(def-spec "##structure-cas!" (spec-u "##unchecked-structure-cas!"))

(def-spec "##direct-structure-ref"  (spec-u "##unchecked-structure-ref"))
(def-spec "##direct-structure-set!" (spec-u "##unchecked-structure-set!"))
(def-spec "##direct-structure-cas!" (spec-u "##unchecked-structure-cas!"))

)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure expanders

(define (setup-prim-expanders targ)

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

(define (def-exp name expander)
  (let ((proc (get-prim-info name)))
    (proc-obj-expandable?-set! proc (lambda (env) #t))
    (proc-obj-expand-set! proc expander)))

(define (def-exp2 name expander)
  (def-exp (string-append "##" name) expander)
  (def-exp name expander))

(define (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         succeed
         fail)
  (if check-run-time-binding
      (new-tst source env
        (check-run-time-binding)
        (succeed)
        (fail))
      (succeed)))

(define (gen-type-checks
         source
         env
         vars
         check-run-time-binding
         check-prims
         tail
         succeed
         fail)
  (let ((type-checks
         (and check-prims
              (gen-var-type-checks source env
                vars
                (map
                 (lambda (check-prim)
                   (lambda (var)
                     (gen-call-prim-vars-notsafe source env check-prim (list var))))
                 check-prims)
                tail))))
    (if (or type-checks
            check-run-time-binding)
      (new-tst source env
        (if type-checks
          (if check-run-time-binding
            (new-conj source env
              (check-run-time-binding)
              type-checks)
            type-checks)
          (check-run-time-binding))
        (succeed)
        (fail))
      (succeed))))

(define (gen-simple-case check-prims prim)
  (lambda (source
           env
           vars
           check-run-time-binding
           out-of-line
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prims
     #f
     (lambda ()
       (gen-call-prim-vars-notsafe source env prim vars))
     fail)))

(define (gen-validating-case check-prims gen)
  (lambda (source
           env
           vars
           check-run-time-binding
           out-of-line
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prims
     #f
     (lambda ()
       (gen source env vars out-of-line fail))
     fail)))

(define (make-simple-expander gen-case)
  (lambda (ptree oper args generate-call check-run-time-binding)
    (let* ((source
            (node-source ptree))
           (env
            (node-env ptree))
           (vars
            (gen-temp-vars source args)))
      (gen-prc source env
        vars
        (let ((generic-call
               (lambda ()
                 (generate-call vars #f))) ;; handle other possibly valid cases
              (dead-end-call
               (lambda ()
                 (generate-call vars #t)))) ;; handle failure
          (gen-case source env
            vars
            check-run-time-binding
            generic-call
            dead-end-call))))))

(define (make-0-or-1-args-expander gen0 gen1)
  (lambda (ptree oper args generate-call check-run-time-binding)
    (let* ((source
            (node-source ptree))
           (env
            (node-env ptree))
           (vars
            (gen-temp-vars source args))
           (generic-call
            (lambda ()
              (generate-call vars #f))) ;; handle other possibly valid cases
           (dead-end-call
            (lambda ()
              (generate-call vars #t))) ;; handle failure
           (gen
            (if (null? args)
                gen0
                gen1)))
      (gen-prc source env
        vars
        (gen source
             env
             vars
             check-run-time-binding
             generic-call
             dead-end-call)))))

(define (make-1-or-2-args-expander gen1 gen2)
  (lambda (ptree oper args generate-call check-run-time-binding)
    (let* ((source
            (node-source ptree))
           (env
            (node-env ptree))
           (vars
            (gen-temp-vars source args))
           (generic-call
            (lambda ()
              (generate-call vars #f))) ;; handle other possibly valid cases
           (dead-end-call
            (lambda ()
              (generate-call vars #t))) ;; handle failure
           (gen
            (if (and (pair? args) (null? (cdr args)))
                gen1
                gen2)))
      (gen-prc source env
        vars
        (gen source
             env
             vars
             check-run-time-binding
             generic-call
             dead-end-call)))))

(define (make-nary-generator zero one two-or-more)
  (lambda (source env vars out-of-line fail)
    (cond ((null? vars)
           (zero source env vars out-of-line fail))
          ((null? (cdr vars))
           (one source env vars out-of-line fail))
          (else
           (two-or-more source env vars out-of-line fail)))))

(define (gen-fold source env vars out-of-line fail op-sym)

  (define (fold result vars)
    (if (null? vars)
      result
      (fold (gen-call-prim-notsafe source env
              op-sym
              (list result
                    (new-ref source env
                      (car vars))))
            (cdr vars))))

  (fold (new-ref source env
          (car vars))
        (cdr vars)))

(define (make-fold-generator op-sym)
  (lambda (source env vars out-of-line fail)
    (gen-fold source env
      vars
      out-of-line
      fail
      op-sym)))

(define (gen-conditional-fold source env vars false gen-op)

  (define (conditional-fold result-var vars intermediate-result-vars)
    (if (null? vars)
      (new-ref source env
        result-var)
      (let ((var (car intermediate-result-vars)))
        (new-call source env
          (gen-prc source env
            (list var)
            (new-tst source env
              (new-ref source env
                var)
              (conditional-fold var
                                (cdr vars)
                                (cdr intermediate-result-vars))
              (false)))
          (list (gen-op source env result-var (car vars)))))))

  (conditional-fold (car vars)
                    (cdr vars)
                    (gen-temp-vars source (cdr vars))))

(define (make-conditional-fold-generator conditional-op-sym fail-on-false?)
  (lambda (source env vars out-of-line fail)
    (gen-conditional-fold source env
      vars
      (if fail-on-false? fail out-of-line)
      (lambda (source env var1 var2)
        (gen-call-prim-vars-notsafe source env
          conditional-op-sym
          (list var1 var2))))))

(define (make-conditional-fixed-arity-generator conditional-op-sym fail-on-false?)
  (lambda (source env vars out-of-line fail)
    (let ((var (car (gen-temp-vars source '(#f)))))
      (new-call source env
        (gen-prc source env
          (list var)
          (new-tst source env
            (new-ref source env
              var)
            (new-ref source env
              var)
            (if fail-on-false? (fail) (out-of-line))))
        (list (gen-call-prim-vars-notsafe source env
                conditional-op-sym
                vars))))))

(define (make-conditional-fast-path conditional-op-sym)
  (let ((gen (make-conditional-fixed-arity-generator conditional-op-sym #f)))
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-check-run-time-binding
       check-run-time-binding
       source
       env
       (lambda ()
         (gen source env vars out-of-line fail))
       fail))))

(define (setup-list-primitives)

  (define **null?-sym (string->canonical-symbol "##null?"))
  (define **pair?-sym (string->canonical-symbol "##pair?"))
  (define **mutable?-sym (string->canonical-symbol "##mutable?"))
  (define **cons-sym (string->canonical-symbol "##cons"))
  (define **car-sym (string->canonical-symbol "##car"))
  (define **cdr-sym (string->canonical-symbol "##cdr"))
  (define **set-car!-sym (string->canonical-symbol "##set-car!"))
  (define **set-cdr!-sym (string->canonical-symbol "##set-cdr!"))
  (define **procedure?-sym (string->canonical-symbol "##procedure?"))

  (define (setup-c...r-primitive pattern)

    (define (gen-name pattern)

      (define (ads pattern)
        (if (= pattern 1)
          ""
          (string-append (if (odd? pattern) "d" "a")
                         (ads (quotient pattern 2)))))

      (string-append "c" (ads pattern) "r"))

    (define (c...r pattern x)
      (if (= pattern 1)
          x
          (let ((y (c...r (quotient pattern 2) x)))
            (if (pair? y)
              (if (odd? pattern) (cdr y) (car y))
              #f))))

    (define (expander ptree oper args generate-call check-run-time-binding)
      (let ((source (node-source ptree))
            (env (node-env ptree)))

        (define (op-prim pattern)
          (if (odd? pattern) **cdr-sym **car-sym))

        (define (gen-tst-pair pattern var body check)
          (new-tst source env
            (let ((x (and check (check)))
                  (y (gen-call-prim-vars-notsafe source env **pair?-sym (list var))))
              (if x
                (new-conj source env x y)
                y))
            (gen-call-prim-vars-notsafe source env (op-prim pattern) (list var))
            body))

        (define (gen-c...r pattern var)
          (if (< pattern 4)
            (gen-tst-pair
             pattern
             var
             (new-cst source env
               #f)
             check-run-time-binding)
            (let ((vars (gen-temp-vars source '(#f))))
              (new-call source env
                (gen-prc source env
                  vars
                  (gen-tst-pair
                   pattern
                   (car vars)
                   (new-cst source env
                     #f)
                   #f))
                (list (gen-c...r (quotient pattern 2) var))))))

        (let* ((vars1
                (gen-temp-vars source '(#f)))
               (call
                (generate-call vars1
                               (not check-run-time-binding))))
          (gen-prc source env
            vars1
            (if (< pattern 4)
              (gen-tst-pair pattern (car vars1) call check-run-time-binding)
              (new-call source env
                (let ((vars2 (gen-temp-vars source '(#f))))
                  (gen-prc source env
                    vars2
                    (gen-tst-pair pattern (car vars2) call #f)))
                (list (gen-c...r (quotient pattern 2) (car vars1)))))))))

    (let ((name (gen-name pattern)))
      (def-exp name expander)))

  (define (setup-c...r-primitives)
    (let loop ((pattern 2))
      (if (< pattern 32)
          (begin
            (setup-c...r-primitive pattern)
            (loop (+ pattern 1))))))

  (define (setup-set-c...r!-primitive pattern)

    (define (gen-name pattern)
      (if (= pattern 0) "set-car!" "set-cdr!"))

    (define (expander ptree oper args generate-call check-run-time-binding)
      (let ((source (node-source ptree))
            (env (node-env ptree)))

        (define (op-prim pattern)
          (if (odd? pattern) **set-cdr!-sym **set-car!-sym))

        (let ((vars
               (gen-temp-vars source args)))
          (gen-prc source env
            vars
            (let ((type-check
                   (gen-call-prim-vars-notsafe source env
                     **pair?-sym
                     (list (car vars)))))
              (new-tst source env
                (new-conj source env
                  (if check-run-time-binding
                    (new-conj source env
                      (check-run-time-binding)
                      type-check)
                    type-check)
                  (gen-call-prim-vars-notsafe source env
                    **mutable?-sym
                    (list (car vars))))
                (new-seq source env
                  (gen-call-prim-vars-notsafe source env
                    (op-prim pattern)
                    vars)
                  (new-cst source env
                    void-object))
                (generate-call vars
                               (not check-run-time-binding))))))))

    (let ((name (gen-name pattern)))
      (def-exp name expander)))

  (define (setup-set-c...r!-primitives)
    (setup-set-c...r!-primitive 0)  ; set-car!
    (setup-set-c...r!-primitive 1)) ; set-cdr!

  (define (make-assq-memq-expander prim unsafe?)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (env2
              (add-proper-tail-calls env))
             (vars
              (gen-temp-vars source args))
             (obj-var
              (car vars))
             (lst-var
              (cadr vars))
             (loop-var
              (new-temp-variable source 'loop))
             (lst1-var
              (new-temp-variable source 'lst1))
             (x-var
              (new-temp-variable source 'x)))

        (define (gen-main-loop)
          (new-call source env2
            (new-prc source env
              #f
              #f
              (list loop-var)
              '()
              #f
              #f
              (new-call source env2
                (new-ref source env
                  loop-var)
                (list (new-ref source env
                        lst-var))))
            (list (new-prc source env
                    #f
                    #f
                    (list lst1-var)
                    '()
                    #f
                    #f
                    (new-tst source env
                      (gen-call-prim-vars-notsafe source env
                        **pair?-sym
                        (list lst1-var))
                      (new-call source env2
                        (new-prc source env
                          #f
                          #f
                          (list x-var)
                          '()
                          #f
                          #f
                          (if (memq prim '(assq assv))
                            (let ()

                              (define (gen-test)
                                (new-tst source env
                                  (gen-call-prim-notsafe source env
                                    (if (eq? prim 'assq)
                                        **eq?-sym
                                        **eqv?-sym)
                                    (list (new-ref source env
                                            obj-var)
                                          (gen-call-prim-vars-notsafe source env
                                            **car-sym
                                            (list x-var))))
                                  (new-ref source env
                                    x-var)
                                  (new-call source env2
                                    (new-ref source env
                                      loop-var)
                                    (list (gen-call-prim-vars-notsafe source env
                                            **cdr-sym
                                            (list lst1-var))))))

                              (if (and (not unsafe?) (safe? env))
                                (new-tst source env
                                  (gen-call-prim-vars-notsafe source env
                                    **pair?-sym
                                    (list x-var))
                                  (gen-test)
                                  (generate-call vars
                                                 (not check-run-time-binding)))
                                (gen-test)))
                            (new-tst source env
                              (gen-call-prim-notsafe source env
                                (if (eq? prim 'memq)
                                    **eq?-sym
                                    **eqv?-sym)
                                (list (new-ref source env
                                        obj-var)
                                      (new-ref source env
                                        x-var)))
                              (new-ref source env
                                lst1-var)
                              (new-call source env2
                                (new-ref source env
                                  loop-var)
                                (list (gen-call-prim-vars-notsafe source env
                                        **cdr-sym
                                        (list lst1-var)))))))
                        (list (gen-call-prim-vars-notsafe source env
                                **car-sym
                                (list lst1-var))))
                      (if (and (not unsafe?) (safe? env))
                        (new-tst source env
                          (gen-call-prim-vars-notsafe source env
                            **null?-sym
                            (list lst1-var))
                          (new-cst source env
                            false-object)
                          (generate-call vars
                                         (not check-run-time-binding)))
                        (new-cst source env
                          false-object)))))))

        (gen-prc source env
          vars
          (if check-run-time-binding
            (new-tst source env
              (check-run-time-binding)
              (gen-main-loop)
              (generate-call vars
                             (not check-run-time-binding)))
            (gen-main-loop))))))

  (define (make-map-for-each-expander prim unsafe?)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (env2
              (add-proper-tail-calls env))
             (vars
              (gen-temp-vars source args))
             (f-var
              (car vars))
             (lst-vars
              (cdr vars)))

        (define (gen-conj-call-prim-vars-notsafe source env prim vars)
          (if (pair? vars)
              (let ((code
                     (gen-call-prim-vars-notsafe source env
                       prim
                       (list (car vars)))))
                (if (null? (cdr vars))
                    code
                    (new-conj source env
                      code
                      (gen-conj-call-prim-vars-notsafe source env prim (cdr vars)))))
              (new-cst source env
                #t)))

        (define (gen-main-loop)
          (let* ((loop2-var
                  (new-temp-variable source 'loop2))
                 (lst2-vars
                  (gen-temp-vars source lst-vars))
                 (x-var
                  (new-temp-variable source 'x)))
            (new-call source env2
              (new-prc source env
                #f
                #f
                (list loop2-var)
                '()
                #f
                #f
                (new-call source env2
                  (new-ref source env
                    loop2-var)
                  (map (lambda (var)
                         (new-ref source env
                           var))
                       lst-vars)))
              (list (new-prc source env
                      #f
                      #f
                      lst2-vars
                      '()
                      #f
                      #f
                      (new-tst source env
                        (gen-conj-call-prim-vars-notsafe source env
                          **pair?-sym
                          lst2-vars
;;                          (if (and (not unsafe?) (safe? env)) ;; in case lists are truncated by other threads
;;                              lst2-vars
;;                              (list (car lst2-vars)))
                          )
                        (new-call source env2
                          (new-prc source env
                            #f
                            #f
                            (list x-var)
                            '()
                            #f
                            #f
                            (let ((rec-call
                                   (new-call source env2
                                     (new-ref source env
                                       loop2-var)
                                     (map (lambda (var)
                                            (gen-call-prim-vars-notsafe source env
                                              **cdr-sym
                                              (list var)))
                                          lst2-vars))))
                              (if (eq? prim 'map)
                                (gen-call-prim-notsafe source env
                                  **cons-sym
                                  (list (new-ref source env
                                          x-var)
                                        rec-call))
                                rec-call)))
                          (list (new-call source env
                                  (new-ref source env
                                    f-var)
                                  (map (lambda (var)
                                            (gen-call-prim-vars-notsafe source env
                                              **car-sym
                                              (list var)))
                                          lst2-vars))))
                        (new-cst source env
                          (if (eq? prim 'map)
                            '()
                            void-object))))))))

        (define (gen-check)
          (let* ((loop1-var
                  (new-temp-variable source 'loop1))
                 (lst1-vars
                  (gen-temp-vars source lst-vars)))
            (new-call source env
              (new-prc source env
                #f
                #f
                (list loop1-var)
                '()
                #f
                #f
                (new-call source env
                  (new-ref source env
                    loop1-var)
                  (map (lambda (var)
                         (new-ref source env
                           var))
                       lst-vars)))
              (list (new-prc source env
                      #f
                      #f
                      lst1-vars
                      '()
                      #f
                      #f
                      (new-tst source env
                        (gen-conj-call-prim-vars-notsafe source env
                          **pair?-sym
                          lst1-vars)
                        (new-call source env
                          (new-ref source env
                            loop1-var)
                          (map (lambda (var)
                                 (gen-call-prim-vars-notsafe source env
                                   **cdr-sym
                                   (list var)))
                               lst1-vars))
                        (new-tst source env
                          (gen-conj-call-prim-vars-notsafe source env
                            **null?-sym
                            lst1-vars)
                          (gen-main-loop)
                          (generate-call vars
                                         (not check-run-time-binding)))))))))

        (gen-prc source env
          vars
          (let ((check-proc
                 (and (and (not unsafe?) (safe? env))
                      (let ((f-arg (car args)))
                        (and (not (or (prc? f-arg)
                                      (and (cst? f-arg)
                                           (proc-obj? (cst-val f-arg)))))
                             (gen-call-prim-vars-notsafe source env
                               **procedure?-sym
                               (list f-var)))))))
            (if (or check-run-time-binding
                    check-proc)
              (new-tst source env
                (cond ((and check-run-time-binding
                            check-proc)
                       (new-conj source env
                         (check-run-time-binding)
                         check-proc))
                      (check-run-time-binding
                       (check-run-time-binding))
                      (else
                       check-proc))
                (if (and (not unsafe?) (safe? env))
                  (gen-check)
                  (gen-main-loop))
                (generate-call vars
                               (not check-run-time-binding)))
              (gen-main-loop)))))))

  (setup-c...r-primitives)
  (setup-set-c...r!-primitives)

  (def-exp "assq"       (make-assq-memq-expander 'assq #f))
  (def-exp "##assq"     (make-assq-memq-expander 'assq #t))
  (def-exp "assv"       (make-assq-memq-expander 'assv #f))
  (def-exp "##assv"     (make-assq-memq-expander 'assv #t))
  (def-exp "memq"       (make-assq-memq-expander 'memq #f))
  (def-exp "##memq"     (make-assq-memq-expander 'memq #t))
  (def-exp "memv"       (make-assq-memq-expander 'memv #f))
  (def-exp "##memv"     (make-assq-memq-expander 'memv #t))
  (def-exp "map"        (make-map-for-each-expander 'map #f))
  (def-exp "##map"      (make-map-for-each-expander 'map #t))
  (def-exp "for-each"   (make-map-for-each-expander 'for-each #f))
  (def-exp "##for-each" (make-map-for-each-expander 'for-each #t)))

(define (setup-numeric-primitives)

  (define **real?-sym     (string->canonical-symbol "##real?"))
  (define **rational?-sym (string->canonical-symbol "##rational?"))
  (define **integer?-sym  (string->canonical-symbol "##integer?"))
  (define **exact?-sym    (string->canonical-symbol "##exact?"))
  (define **inexact?-sym  (string->canonical-symbol "##inexact?"))
  (define exact?-sym      (string->canonical-symbol "exact?"))
  (define inexact?-sym    (string->canonical-symbol "inexact?"))

  (define **fixnum?-sym (string->canonical-symbol "##fixnum?"))

  (define **fx=-sym (string->canonical-symbol "##fx="))
  (define **fx<-sym (string->canonical-symbol "##fx<"))
  (define **fx>-sym (string->canonical-symbol "##fx>"))
  (define **fx<=-sym (string->canonical-symbol "##fx<="))
  (define **fx>=-sym (string->canonical-symbol "##fx>="))

  (define **fxzero?-sym (string->canonical-symbol "##fxzero?"))
  (define **fxpositive?-sym (string->canonical-symbol "##fxpositive?"))
  (define **fxnegative?-sym (string->canonical-symbol "##fxnegative?"))

  (define **fxodd?-sym (string->canonical-symbol "##fxodd?"))
  (define **fxeven?-sym (string->canonical-symbol "##fxeven?"))

  (define **fxmax-sym (string->canonical-symbol "##fxmax"))
  (define **fxmin-sym (string->canonical-symbol "##fxmin"))

  (define **fxwrap+-sym (string->canonical-symbol "##fxwrap+"))
  (define **fx+-sym (string->canonical-symbol "##fx+"))
  (define **fx+?-sym (string->canonical-symbol "##fx+?"))
  (define **fxwrap*-sym (string->canonical-symbol "##fxwrap*"))
  (define **fx*-sym (string->canonical-symbol "##fx*"))
  (define **fx*?-sym (string->canonical-symbol "##fx*?"))
  (define **fxwrap--sym (string->canonical-symbol "##fxwrap-"))
  (define **fx--sym (string->canonical-symbol "##fx-"))
  (define **fx-?-sym (string->canonical-symbol "##fx-?"))
  (define **fxwrapquotient-sym (string->canonical-symbol "##fxwrapquotient"))
  (define **fxquotient-sym (string->canonical-symbol "##fxquotient"))
  (define **fxremainder-sym (string->canonical-symbol "##fxremainder"))
  (define **fxmodulo-sym (string->canonical-symbol "##fxmodulo"))

  (define **fxwrapabs-sym (string->canonical-symbol "##fxwrapabs"))
  (define **fxabs-sym (string->canonical-symbol "##fxabs"))
  (define **fxabs?-sym (string->canonical-symbol "##fxabs?"))

  (define **fxwrapsquare-sym (string->canonical-symbol "##fxwrapsquare"))
  (define **fxsquare-sym (string->canonical-symbol "##fxsquare"))
  (define **fxsquare?-sym (string->canonical-symbol "##fxsquare?"))

  (define **fxand-sym   (string->canonical-symbol "##fxand"))
  (define **fxandc1-sym (string->canonical-symbol "##fxandc1"))
  (define **fxandc2-sym (string->canonical-symbol "##fxandc2"))
  (define **fxeqv-sym   (string->canonical-symbol "##fxeqv"))
  (define **fxior-sym   (string->canonical-symbol "##fxior"))
  (define **fxnand-sym  (string->canonical-symbol "##fxnand"))
  (define **fxnor-sym   (string->canonical-symbol "##fxnor"))
  (define **fxnot-sym   (string->canonical-symbol "##fxnot"))
  (define **fxorc1-sym  (string->canonical-symbol "##fxorc1"))
  (define **fxorc2-sym  (string->canonical-symbol "##fxorc2"))
  (define **fxxor-sym   (string->canonical-symbol "##fxxor"))

  (define bitwise-and-sym   (string->canonical-symbol "bitwise-and"))
  (define bitwise-andc1-sym (string->canonical-symbol "bitwise-andc1"))
  (define bitwise-andc2-sym (string->canonical-symbol "bitwise-andc2"))
  (define bitwise-eqv-sym   (string->canonical-symbol "bitwise-eqv"))
  (define bitwise-ior-sym   (string->canonical-symbol "bitwise-ior"))
  (define bitwise-nand-sym  (string->canonical-symbol "bitwise-nand"))
  (define bitwise-nor-sym   (string->canonical-symbol "bitwise-nor"))
  (define bitwise-not-sym   (string->canonical-symbol "bitwise-not"))
  (define bitwise-orc1-sym  (string->canonical-symbol "bitwise-orc1"))
  (define bitwise-orc2-sym  (string->canonical-symbol "bitwise-orc2"))
  (define bitwise-xor-sym   (string->canonical-symbol "bitwise-xor"))

  (define **fxwraparithmetic-shift-sym
    (string->canonical-symbol "##fxwraparithmetic-shift"))
  (define **fxwraparithmetic-shift?-sym
    (string->canonical-symbol "##fxwraparithmetic-shift?"))
  (define **fxarithmetic-shift?-sym
    (string->canonical-symbol "##fxarithmetic-shift?"))
  (define **fxwraparithmetic-shift-left-sym
    (string->canonical-symbol "##fxwraparithmetic-shift-left"))
  (define **fxwraparithmetic-shift-left?-sym
    (string->canonical-symbol "##fxwraparithmetic-shift-left?"))
  (define **fxarithmetic-shift-left?-sym
    (string->canonical-symbol "##fxarithmetic-shift-left?"))
  (define **fxarithmetic-shift-right?-sym
    (string->canonical-symbol "##fxarithmetic-shift-right?"))
  (define **fxwraplogical-shift-right?-sym
    (string->canonical-symbol "##fxwraplogical-shift-right?"))

  (define **flonum?-sym (string->canonical-symbol "##flonum?"))

  (define **fl=-sym (string->canonical-symbol "##fl="))
  (define **fl<-sym (string->canonical-symbol "##fl<"))
  (define **fl>-sym (string->canonical-symbol "##fl>"))
  (define **fl<=-sym (string->canonical-symbol "##fl<="))
  (define **fl>=-sym (string->canonical-symbol "##fl>="))

  (define **flinteger?-sym (string->canonical-symbol "##flinteger?"))
  (define **flzero?-sym (string->canonical-symbol "##flzero?"))
  (define **flpositive?-sym (string->canonical-symbol "##flpositive?"))
  (define **flnegative?-sym (string->canonical-symbol "##flnegative?"))
  (define **flodd?-sym (string->canonical-symbol "##flodd?"))
  (define **fleven?-sym (string->canonical-symbol "##fleven?"))
  (define **flfinite?-sym (string->canonical-symbol "##flfinite?"))
  (define **flinfinite?-sym (string->canonical-symbol "##flinfinite?"))
  (define **flnan?-sym (string->canonical-symbol "##flnan?"))

  (define **flmax-sym (string->canonical-symbol "##flmax"))
  (define **flmin-sym (string->canonical-symbol "##flmin"))

  (define **fl+-sym (string->canonical-symbol "##fl+"))
  (define **fl*-sym (string->canonical-symbol "##fl*"))
  (define **fl--sym (string->canonical-symbol "##fl-"))
  (define **fl/-sym (string->canonical-symbol "##fl/"))

  (define **flabs-sym (string->canonical-symbol "##flabs"))
  (define **flsquare-sym (string->canonical-symbol "##flsquare"))
  (define **flfloor-sym (string->canonical-symbol "##flfloor"))
  (define **flceiling-sym (string->canonical-symbol "##flceiling"))
  (define **fltruncate-sym (string->canonical-symbol "##fltruncate"))
  (define **flround-sym (string->canonical-symbol "##flround"))
  (define **flexp-sym (string->canonical-symbol "##flexp"))
  (define **fllog-sym (string->canonical-symbol "##fllog"))
  (define **flsin-sym (string->canonical-symbol "##flsin"))
  (define **flcos-sym (string->canonical-symbol "##flcos"))
  (define **fltan-sym (string->canonical-symbol "##fltan"))
  (define **flatan-sym (string->canonical-symbol "##flatan"))
  (define **flasin-sym (string->canonical-symbol "##flasin"))
  (define **flacos-sym (string->canonical-symbol "##flacos"))
  (define **flsinh-sym (string->canonical-symbol "##flsinh"))
  (define **flcosh-sym (string->canonical-symbol "##flcosh"))
  (define **fltanh-sym (string->canonical-symbol "##fltanh"))
  (define **flasinh-sym (string->canonical-symbol "##flasinh"))
  (define **flacosh-sym (string->canonical-symbol "##flacosh"))
  (define **flatanh-sym (string->canonical-symbol "##flatanh"))
  (define **flhypot-sym (string->canonical-symbol "##flhypot"))
  (define **flexpt-sym (string->canonical-symbol "##flexpt"))
  (define **flsqrt-sym (string->canonical-symbol "##flsqrt"))
  (define **flcopysign-sym (string->canonical-symbol "##flcopysign"))

  (define **fixnum->flonum-sym (string->canonical-symbol "##fixnum->flonum"))

  (define **mem-allocated?-sym (string->canonical-symbol "##mem-allocated?"))
  (define **subtyped?-sym (string->canonical-symbol "##subtyped?"))
  (define **subtype-sym (string->canonical-symbol "##subtype"))

  (define **ratnum?-sym (string->canonical-symbol "##ratnum?"))
  (define **ratnum-numerator-sym (string->canonical-symbol "##ratnum-numerator"))
  (define **ratnum-denominator-sym (string->canonical-symbol "##ratnum-denominator"))

  (define **cpxnum?-sym (string->canonical-symbol "##cpxnum?"))
  (define **cpxnum-real-sym (string->canonical-symbol "##cpxnum-real"))
  (define **cpxnum-imag-sym (string->canonical-symbol "##cpxnum-imag"))

  (define (gen-fixnum-case gen)
    (gen-validating-case (list **fixnum?-sym) gen))

  (define (gen-fixnum-division-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **fixnum?-sym)
       (gen-call-prim-notsafe source env
         **not-sym
         (list (gen-call-prim-notsafe source env
                 **eqv?-sym
                 (list (new-ref source env
                         (cadr vars))
                       (new-cst source env
                         0)))))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-flonum-case gen)
    (gen-validating-case (list **flonum?-sym) gen))

  (define (gen-log-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (new-disj source env
         (gen-call-prim-vars-notsafe source env
           **flnan?-sym
           vars)
         (gen-call-prim-notsafe source env
           **not-sym
           (list (gen-call-prim-notsafe source env
                   **flnegative?-sym
                   (list (gen-call-prim-notsafe source env
                           **flcopysign-sym
                           (list (new-cst source env
                                   (macro-inexact-+1))
                                 (new-ref source env
                                   (car vars)))))))))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-expt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (new-disj source env
         (gen-call-prim-notsafe source env
           **not-sym
           (list (gen-call-prim-vars-notsafe source env
                   **flnegative?-sym
                   (list (car vars)))))
         (gen-call-prim-vars-notsafe source env
           **flinteger?-sym
           (list (cadr vars))))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-sqrt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (gen-call-prim-notsafe source env
         **not-sym
         (list (gen-call-prim-vars-notsafe source env
                 **flnegative?-sym
                 vars)))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-finite-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (gen-call-prim-vars-notsafe source env
         **flfinite?-sym
         vars)
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-asin-acos-atanh-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (and (= (length vars) 1)
            (new-conj source env
              (gen-call-prim-notsafe source env
                **not-sym
                (list (gen-call-prim-notsafe source env
                        **fl<-sym
                        (list (new-cst source env
                                (macro-inexact-+1))
                              (new-ref source env
                                (car vars))))))
              (gen-call-prim-notsafe source env
                **not-sym
                (list (gen-call-prim-notsafe source env
                        **fl<-sym
                        (list (new-ref source env
                                (car vars))
                              (new-cst source env
                                (macro-inexact--1))))))))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-acosh-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (gen-call-prim-notsafe source env
         **not-sym
         (list (gen-call-prim-notsafe source env
                 **fl<-sym
                 (list (new-ref source env
                                (car vars))
                       (new-cst source env
                         (macro-inexact-+1))))))
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (gen-odd-even-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             out-of-line
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       (list **flonum?-sym)
       (gen-call-prim-vars-notsafe source env
         **flinteger?-sym
         vars)
       (lambda ()
         (gen source env vars out-of-line fail))
       fail)))

  (define (no-case source
                   env
                   vars
                   check-run-time-binding
                   out-of-line
                   fail)
    (fail))

  (define (make-fixflo-expander fixnum-case flonum-case)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (mostly-arith
              (mostly-arith-implementation (var-name (ref-var oper)) env))
             (cases
              (cond ((eq? mostly-arith mostly-fixnum-sym)
                     (cons fixnum-case no-case))
                    ((eq? mostly-arith mostly-flonum-sym)
                     (cons flonum-case no-case))
                    ((eq? mostly-arith mostly-fixnum-flonum-sym)
                     (cons fixnum-case flonum-case))
                    ((eq? mostly-arith mostly-flonum-fixnum-sym)
                     (cons flonum-case fixnum-case))
                    (else
                     (cons no-case no-case)))))
        (if (and (eq? (car cases) no-case)
                 (eq? (cdr cases) no-case))
          #f
          (let ((vars (gen-temp-vars source args)))
            (gen-prc source env
              vars
              (let* ((generic-call
                      (lambda ()
                        (generate-call vars #f))) ;; handle other cases
                     (cases-expansion
                      ((car cases) source env
                       vars
                       (and (eq? (cdr cases) no-case)
                            check-run-time-binding)
                       generic-call
                       (lambda ()
                         ((cdr cases) source env
                          vars
                          (and (eq? (car cases) no-case)
                               check-run-time-binding)
                          generic-call
                          generic-call)))))
                (if (and check-run-time-binding
                         (not (eq? (car cases) no-case))
                         (not (eq? (cdr cases) no-case)))
                  (new-tst source env
                    (check-run-time-binding)
                    cases-expansion
                    (generic-call))
                  cases-expansion))))))))

  (define (make-fixnum-division-expander gen-case)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (mostly-arith
              (mostly-arith-implementation (var-name (ref-var oper)) env)))
        (and (or (eq? mostly-arith mostly-fixnum-sym)
                 (eq? mostly-arith mostly-fixnum-flonum-sym)
                 (eq? mostly-arith mostly-flonum-fixnum-sym))
             (let ((vars
                    (gen-temp-vars source args)))
               (gen-prc source env
                 vars
                 (let ((generic-call
                        (lambda ()
                          (generate-call vars #f)))) ;; handle other possibly valid cases
                   (gen-case source env
                     vars
                     check-run-time-binding
                     generic-call
                     generic-call))))))))

  (define (make-prim-generator prim)
    (lambda (source env vars out-of-line fail)
      (gen-call-prim-vars-notsafe source env prim vars)))

  (define gen-fixnum-0
    (lambda (source env vars out-of-line fail)
      (new-cst source env
        0)))

  (define gen-fixnum-1
    (lambda (source env vars out-of-line fail)
      (new-cst source env
        1)))

  (define gen-flonum-0
    (lambda (source env vars out-of-line fail)
      (new-cst source env
        (macro-inexact-+0))))

  (define gen-flonum-1
    (lambda (source env vars out-of-line fail)
      (new-cst source env
        (macro-inexact-+1))))

  (define gen-first-arg
    (lambda (source env vars out-of-line fail)
      (new-ref source env
        (car vars))))

  (let ()

    (define case-fx=
      (gen-simple-case (list **fixnum?-sym) **fx=-sym))

    (define case-fx<
      (gen-simple-case (list **fixnum?-sym) **fx<-sym))

    (define case-fx>
      (gen-simple-case (list **fixnum?-sym) **fx>-sym))

    (define case-fx<=
      (gen-simple-case (list **fixnum?-sym) **fx<=-sym))

    (define case-fx>=
      (gen-simple-case (list **fixnum?-sym) **fx>=-sym))

    (define case-fxzero?
      (gen-simple-case (list **fixnum?-sym) **fxzero?-sym))

    (define case-fxpositive?
      (gen-simple-case (list **fixnum?-sym) **fxpositive?-sym))

    (define case-fxnegative?
      (gen-simple-case (list **fixnum?-sym) **fxnegative?-sym))

    (define case-fxodd?
      (gen-simple-case (list **fixnum?-sym) **fxodd?-sym))

    (define case-fxeven?
      (gen-simple-case (list **fixnum?-sym) **fxeven?-sym))

    (define case-fxmax
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmax-sym))))

    (define case-fxmin
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmin-sym))))

    (define case-fxwrap+
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-fold-generator **fxwrap+-sym))))

    (define case-fx+
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-conditional-fold-generator **fx+?-sym #t))))

    (define case-fxwrap*
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-1
        gen-first-arg
        (make-fold-generator **fxwrap*-sym))))

    (define case-fx*
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-1
        gen-first-arg
        (lambda (source env vars out-of-line fail)
          (new-tst source env
            (gen-disj-multi source env
              (map (lambda (var)
                     (gen-call-prim-notsafe source env
                       **eqv?-sym
                       (list (new-ref source env
                               var)
                             (new-cst source env
                               0))))
                   (reverse (cdr vars))))
            (new-cst source env
              0)
            (gen-conditional-fold source env
              vars
              fail
              (lambda (source env var1 var2)
                (new-tst source env
                  (gen-call-prim-notsafe source env
                    **eqv?-sym
                    (list (new-ref source env
                            var2)
                          (new-cst source env
                            -1)))
                  (gen-call-prim-vars-notsafe source env
                    **fx-?-sym
                    (list var1))
                  (gen-call-prim-vars-notsafe source env
                    **fx*?-sym
                    (list var1 var2))))))))))

    (define case-fxwrap-
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (make-prim-generator **fxwrap--sym)
        (make-fold-generator **fxwrap--sym))))

    (define case-fx-
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (make-conditional-fixed-arity-generator **fx-?-sym #t)
        (lambda (source env vars out-of-line fail)
          (gen-conditional-fold source env
            vars
            fail
            (lambda (source env var1 var2)
              (gen-call-prim-vars-notsafe source env
                **fx-?-sym
                (list var1 var2))))))))

    (define case-fxwrapquotient
      (gen-fixnum-division-case
       (lambda (source env vars out-of-line fail)
         (gen-call-prim-vars-notsafe source env
           **fxwrapquotient-sym
           vars))))

    (define case-fxquotient
      (gen-fixnum-division-case
       (lambda (source env vars out-of-line fail)
         (new-tst source env
           (gen-call-prim-notsafe source env
             **eqv?-sym
             (list (new-ref source env
                     (cadr vars))
                   (new-cst source env
                     -1)))
           (new-disj source env
             (gen-call-prim-vars-notsafe source env
               **fx-?-sym
               (list (car vars)))
             (fail))
           (gen-call-prim-vars-notsafe source env
             **fxquotient-sym
             vars)))))

    (define case-fixnum/
      (gen-fixnum-case
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (lambda (source env vars out-of-line fail)
          ;; call / to compute inverse
          (out-of-line))
        (lambda (source env vars out-of-line fail)
          (new-tst source env
            (gen-disj-multi source env
              (map (lambda (var)
                     (gen-call-prim-notsafe source env
                       **fx<=-sym
                       (list (new-cst source env
                               -1)
                             (new-ref source env
                               var)
                             (new-cst source env
                               0))))
                   (reverse (cdr vars))))
            (out-of-line)
            (let ()

              (define (fold-quotient accu-var rest-vars)
                (if (null? rest-vars)
                    (new-ref source env
                      accu-var)
                    (let* ((rest-var1 (car rest-vars))
                           (q-var (new-temp-variable source 'quotient))
                           (r-var (new-temp-variable source 'remainder)))
                      (new-call source env
                        (new-prc source env
                          #f
                          #f
                          (list q-var r-var)
                          '()
                          #f
                          #f
                          (new-tst source env
                            (gen-call-prim-notsafe source env
                              **fx=-sym
                              (list (new-ref source env
                                      r-var)
                                    (new-cst source env
                                      0)))
                            (fold-quotient q-var (cdr rest-vars))
                            (out-of-line)))
                        (list (gen-call-prim-notsafe source env
                                **fxquotient-sym
                                (list (new-ref source env
                                        accu-var)
                                      (new-ref source env
                                        rest-var1)))
                              (gen-call-prim-notsafe source env
                                **fxremainder-sym
                                (list (new-ref source env
                                        accu-var)
                                      (new-ref source env
                                        rest-var1))))))))

              (fold-quotient (car vars) (cdr vars))))))))

    (define case-fxremainder
      (gen-fixnum-division-case
       (make-prim-generator **fxremainder-sym)))

    (define case-fxmodulo
      (gen-fixnum-division-case
       (make-prim-generator **fxmodulo-sym)))

    (define case-fxwrapabs
      (gen-simple-case (list **fixnum?-sym) **fxwrapabs-sym))

    (define case-fxabs
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator **fxabs?-sym #t)))

    (define case-fxwrapsquare
      (gen-simple-case (list **fixnum?-sym) **fxwrapsquare-sym))

    (define case-fxsquare
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator **fxsquare?-sym #t)))

    (define case-fxand
      (gen-simple-case (list **fixnum?-sym) **fxand-sym))

    (define case-fxandc1
      (gen-simple-case (list **fixnum?-sym) **fxandc1-sym))

    (define case-fxandc2
      (gen-simple-case (list **fixnum?-sym) **fxandc2-sym))

    (define case-fxeqv
      (gen-simple-case (list **fixnum?-sym) **fxeqv-sym))

    (define case-fxior
      (gen-simple-case (list **fixnum?-sym) **fxior-sym))

    (define case-fxnand
      (gen-simple-case (list **fixnum?-sym) **fxnand-sym))

    (define case-fxnor
      (gen-simple-case (list **fixnum?-sym) **fxnor-sym))

    (define case-fxnot
      (gen-simple-case (list **fixnum?-sym) **fxnot-sym))

    (define case-fxorc1
      (gen-simple-case (list **fixnum?-sym) **fxorc1-sym))

    (define case-fxorc2
      (gen-simple-case (list **fixnum?-sym) **fxorc2-sym))

    (define case-fxxor
      (gen-simple-case (list **fixnum?-sym) **fxxor-sym))

    (define case-fxwraparithmetic-shift
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraparithmetic-shift?-sym
        #t)))

    (define case-fxarithmetic-shift
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift?-sym
        #t)))

    (define case-fxwraparithmetic-shift-left
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraparithmetic-shift-left?-sym
        #t)))

    (define case-fxarithmetic-shift-left
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift-left?-sym
        #t)))

    (define case-fxarithmetic-shift-right
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift-right?-sym
        #t)))

    (define case-fxwraplogical-shift-right
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraplogical-shift-right?-sym
        #t)))

    (define case-fixnum->flonum
      (gen-fixnum-case
       (make-prim-generator **fixnum->flonum-sym)))

    (define case-fixnum-exact->inexact
      (gen-fixnum-case
       (make-prim-generator **fixnum->flonum-sym)))

    (define case-fixnum-inexact->exact
      (gen-fixnum-case
       gen-first-arg))

    (define case-fl=
      (gen-simple-case (list **flonum?-sym) **fl=-sym))

    (define case-fl<
      (gen-simple-case (list **flonum?-sym) **fl<-sym))

    (define case-fl>
      (gen-simple-case (list **flonum?-sym) **fl>-sym))

    (define case-fl<=
      (gen-simple-case (list **flonum?-sym) **fl<=-sym))

    (define case-fl>=
      (gen-simple-case (list **flonum?-sym) **fl>=-sym))

    (define case-flinteger?
      (gen-simple-case (list **flonum?-sym) **flinteger?-sym))

    (define case-flzero?
      (gen-simple-case (list **flonum?-sym) **flzero?-sym))

    (define case-flpositive?
      (gen-simple-case (list **flonum?-sym) **flpositive?-sym))

    (define case-flnegative?
      (gen-simple-case (list **flonum?-sym) **flnegative?-sym))

    (define case-flodd?
      (gen-odd-even-flonum-case
       (make-prim-generator **flodd?-sym)))

    (define case-fleven?
      (gen-odd-even-flonum-case
       (make-prim-generator **fleven?-sym)))

    (define case-flfinite?
      (gen-simple-case (list **flonum?-sym) **flfinite?-sym))

    (define case-flinfinite?
      (gen-simple-case (list **flonum?-sym) **flinfinite?-sym))

    (define case-flnan?
      (gen-simple-case (list **flonum?-sym) **flnan?-sym))

    (define case-flmax
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmax-sym))))

    (define case-flmin
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmin-sym))))

    (define case-fl+
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-0
        gen-first-arg
        (make-fold-generator **fl+-sym))))

    (define case-fl*
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-1
        gen-first-arg
        (make-fold-generator **fl*-sym))))

    (define case-fl-
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl--sym)
        (make-fold-generator **fl--sym))))

    (define case-fl/
      (gen-flonum-case
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl/-sym)
        (make-fold-generator **fl/-sym))))

    (define case-flabs
      (gen-simple-case (list **flonum?-sym) **flabs-sym))

    (define case-flsquare
      (gen-simple-case (list **flonum?-sym) **flsquare-sym))

    (define case-flfloor
      (gen-finite-flonum-case
       (make-prim-generator **flfloor-sym)))

    (define case-flceiling
      (gen-finite-flonum-case
       (make-prim-generator **flceiling-sym)))

    (define case-fltruncate
      (gen-finite-flonum-case
       (make-prim-generator **fltruncate-sym)))

    (define case-flround
      (gen-finite-flonum-case
       (make-prim-generator **flround-sym)))

    (define case-flexp
      (gen-simple-case (list **flonum?-sym) **flexp-sym))

    (define case-fllog
      (gen-simple-case (list **flonum?-sym) **fllog-sym))

    (define case-log-flonum
      (gen-log-flonum-case
       (make-prim-generator **fllog-sym)))

    (define case-flsin
      (gen-simple-case (list **flonum?-sym) **flsin-sym))

    (define case-flcos
      (gen-simple-case (list **flonum?-sym) **flcos-sym))

    (define case-fltan
      (gen-simple-case (list **flonum?-sym) **fltan-sym))

    (define case-flasin
      (gen-simple-case (list **flonum?-sym) **flasin-sym))

    (define case-asin-flonum
      (gen-asin-acos-atanh-flonum-case
       (make-prim-generator **flasin-sym)))

    (define case-flacos
      (gen-simple-case (list **flonum?-sym) **flacos-sym))

    (define case-acos-flonum
      (gen-asin-acos-atanh-flonum-case
       (make-prim-generator **flacos-sym)))

    (define case-flatan
      (gen-simple-case (list **flonum?-sym) **flatan-sym))

    (define case-flsinh
      (gen-simple-case (list **flonum?-sym) **flsinh-sym))

    (define case-flcosh
      (gen-simple-case (list **flonum?-sym) **flcosh-sym))

    (define case-fltanh
      (gen-simple-case (list **flonum?-sym) **fltanh-sym))

    (define case-flasinh
      (gen-simple-case (list **flonum?-sym) **flasinh-sym))

    (define case-flacosh
      (gen-simple-case (list **flonum?-sym) **flacosh-sym))

    (define case-acosh-flonum
      (gen-acosh-flonum-case
       (make-prim-generator **flacosh-sym)))

    (define case-flatanh
      (gen-simple-case (list **flonum?-sym) **flatanh-sym))

    (define case-atanh-flonum
      (gen-asin-acos-atanh-flonum-case
       (make-prim-generator **flatanh-sym)))

    (define case-flhypot
      (gen-simple-case (list **flonum?-sym) **flhypot-sym))

    (define case-flexpt
      (gen-simple-case (list **flonum?-sym) **flexpt-sym))

    (define case-expt-flonum
      (gen-expt-flonum-case
       (make-prim-generator **flexpt-sym)))

    (define case-flsqrt
      (gen-simple-case (list **flonum?-sym) **flsqrt-sym))

    (define case-sqrt-flonum
      (gen-sqrt-flonum-case
       (make-prim-generator **flsqrt-sym)))

    (define case-flonum-exact->inexact
      (gen-flonum-case
       gen-first-arg))

    (define case-flonum-inexact->exact
      no-case)

    (define (case-eqv?-or-equal? prim)
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (let ((var1 (car vars))
                 (var2 (cadr vars)))
             (new-disj source env
               (gen-call-prim-notsafe source env
                 **eq?-sym
                 (list (new-ref source env
                         var1)
                       (new-ref source env
                         var2)))
               (new-conj source env
                 (gen-call-prim-notsafe source env
                   prim
                   (list (new-ref source env
                           var1)))
                 (new-conj source env
                   (gen-call-prim-notsafe source env
                     prim
                     (list (new-ref source env
                             var2)))
                   (new-conj source env
                     (gen-call-prim-notsafe source env
                       **fx=-sym
                       (list (gen-call-prim-notsafe source env
                               **subtype-sym
                               (list (new-ref source env
                                       var1)))
                             (gen-call-prim-notsafe source env
                               **subtype-sym
                               (list (new-ref source env
                                       var2)))))
                     (out-of-line)))))))
         fail)))

    (define case-real?
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars-notsafe source env **fixnum?-sym vars)
             (new-disj source env
               (gen-call-prim-vars-notsafe source env **flonum?-sym vars)
               (gen-call-prim-vars-notsafe source env **real?-sym vars))))
         fail)))

    (define case-rational?
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars-notsafe source env **fixnum?-sym vars)
             (new-tst source env
               (gen-call-prim-vars-notsafe source env **flonum?-sym vars)
               (gen-call-prim-vars-notsafe source env **flfinite?-sym vars)
               (gen-call-prim-vars-notsafe source env **rational?-sym vars))))
         fail)))

    (define case-integer?
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars-notsafe source env **fixnum?-sym vars)
             (gen-call-prim-vars-notsafe source env **integer?-sym vars)))
         fail)))

    (define (case-exact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars-notsafe source env **fixnum?-sym vars)
             (new-conj source env
               (gen-call-prim-notsafe source env
                 **not-sym
                 (list (gen-call-prim-vars-notsafe source env **flonum?-sym vars)))
               (gen-call-prim-vars source env fallback vars))))
         fail)))

    (define (case-inexact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               out-of-line
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-conj source env
             (gen-call-prim-notsafe source env
               **not-sym
               (list (gen-call-prim-vars-notsafe source env **fixnum?-sym vars)))
             (new-disj source env
               (gen-call-prim-vars-notsafe source env **flonum?-sym vars)
               (gen-call-prim-vars source env fallback vars))))
         fail)))

    (def-exp "##real?"     (make-simple-expander case-real?))
    (def-exp "##rational?" (make-simple-expander case-rational?))
    (def-exp "##integer?"  (make-simple-expander case-integer?))
    (def-exp "##exact?"    (make-simple-expander (case-exact? **exact?-sym)))
    (def-exp "##inexact?"  (make-simple-expander (case-inexact? **inexact?-sym)))

    (def-exp "exact?"      (make-simple-expander (case-exact? exact?-sym)))
    (def-exp "inexact?"    (make-simple-expander (case-inexact? inexact?-sym)))

    (def-exp "fx=" (make-simple-expander case-fx=))
    (def-exp "fl=" (make-simple-expander case-fl=))
    (def-exp2"="   (make-fixflo-expander case-fx= case-fl=))

    (def-exp "fx<" (make-simple-expander case-fx<))
    (def-exp "fl<" (make-simple-expander case-fl<))
    (def-exp2"<"   (make-fixflo-expander case-fx< case-fl<))

    (def-exp "fx>" (make-simple-expander case-fx>))
    (def-exp "fl>" (make-simple-expander case-fl>))
    (def-exp2">"   (make-fixflo-expander case-fx> case-fl>))

    (def-exp "fx<=" (make-simple-expander case-fx<=))
    (def-exp "fl<=" (make-simple-expander case-fl<=))
    (def-exp2"<="   (make-fixflo-expander case-fx<= case-fl<=))

    (def-exp "fx>=" (make-simple-expander case-fx>=))
    (def-exp "fl>=" (make-simple-expander case-fl>=))
    (def-exp2">="   (make-fixflo-expander case-fx>= case-fl>=))

    (def-exp "flinteger?" (make-simple-expander case-flinteger?))

    (def-exp "fxzero?" (make-simple-expander case-fxzero?))
    (def-exp "flzero?" (make-simple-expander case-flzero?))
    (def-exp2"zero?"   (make-fixflo-expander case-fxzero? case-flzero?))

    (def-exp "fxpositive?" (make-simple-expander case-fxpositive?))
    (def-exp "flpositive?" (make-simple-expander case-flpositive?))
    (def-exp2"positive?"   (make-fixflo-expander case-fxpositive? case-flpositive?))

    (def-exp "fxnegative?" (make-simple-expander case-fxnegative?))
    (def-exp "flnegative?" (make-simple-expander case-flnegative?))
    (def-exp2"negative?"   (make-fixflo-expander case-fxnegative? case-flnegative?))

    (def-exp "fxodd?" (make-simple-expander case-fxodd?))
    (def-exp "flodd?" (make-simple-expander case-flodd?))
    (def-exp2"odd?"   (make-fixflo-expander case-fxodd? case-flodd?))

    (def-exp "fxeven?" (make-simple-expander case-fxeven?))
    (def-exp "fleven?" (make-simple-expander case-fleven?))
    (def-exp2"even?"   (make-fixflo-expander case-fxeven? case-fleven?))

    (def-exp "flfinite?" (make-simple-expander case-flfinite?))
    (def-exp2"finite?"   (make-fixflo-expander no-case case-flfinite?))

    (def-exp "flinfinite?" (make-simple-expander case-flinfinite?))
    (def-exp2"infinite?"   (make-fixflo-expander no-case case-flinfinite?))

    (def-exp "flnan?" (make-simple-expander case-flnan?))
    (def-exp2"nan?"   (make-fixflo-expander no-case case-flnan?))

    (def-exp "fxmax" (make-simple-expander case-fxmax))
    (def-exp "flmax" (make-simple-expander case-flmax))
    (def-exp2"max"   (make-fixflo-expander case-fxmax case-flmax))

    (def-exp "fxmin" (make-simple-expander case-fxmin))
    (def-exp "flmin" (make-simple-expander case-flmin))
    (def-exp2"min"   (make-fixflo-expander case-fxmin case-flmin))

    (def-exp "fxwrap+" (make-simple-expander case-fxwrap+))
    (def-exp "fx+"     (make-simple-expander case-fx+))
    (def-exp "fl+"     (make-simple-expander case-fl+))
    (def-exp2"+"       (make-fixflo-expander
                         case-fx+
                         (gen-flonum-case
                          (make-nary-generator
                           gen-fixnum-0
                           gen-first-arg
                           (make-fold-generator **fl+-sym)))))

    (def-exp "fxwrap*" (make-simple-expander case-fxwrap*))
    (def-exp "fx*"     (make-simple-expander case-fx*))
    (def-exp "fl*"     (make-simple-expander case-fl*))
    (def-exp2"*"       (make-fixflo-expander
                         case-fx*
                         (gen-flonum-case
                          (make-nary-generator
                           gen-fixnum-1
                           gen-first-arg
                           (make-fold-generator **fl*-sym)))))

    (def-exp "fxwrap-" (make-simple-expander case-fxwrap-))
    (def-exp "fx-"     (make-simple-expander case-fx-))
    (def-exp "fl-"     (make-simple-expander case-fl-))
    (def-exp2"-"       (make-fixflo-expander case-fx- case-fl-))

    (def-exp "fl/"     (make-simple-expander case-fl/))
    (def-exp2"/"       (make-fixflo-expander case-fixnum/ case-fl/))

    (def-exp "fxwrapquotient" (make-simple-expander case-fxwrapquotient))
    (def-exp "fxquotient"     (make-simple-expander case-fxquotient))
    (def-exp2"quotient"       (make-fixnum-division-expander case-fxquotient))

    (def-exp "fxremainder" (make-simple-expander case-fxremainder))
    (def-exp2"remainder"   (make-fixnum-division-expander case-fxremainder))

    (def-exp "fxmodulo" (make-simple-expander case-fxmodulo))
    (def-exp2"modulo"   (make-fixnum-division-expander case-fxmodulo))

    (def-exp "fxand"   (make-simple-expander case-fxand))
    (def-exp "fxandc1" (make-simple-expander case-fxandc1))
    (def-exp "fxandc2" (make-simple-expander case-fxandc2))
    (def-exp "fxeqv"   (make-simple-expander case-fxeqv))
    (def-exp "fxior"   (make-simple-expander case-fxior))
    (def-exp "fxnand"  (make-simple-expander case-fxnand))
    (def-exp "fxnor"   (make-simple-expander case-fxnor))
    (def-exp "fxnot"   (make-simple-expander case-fxnot))
    (def-exp "fxorc1"  (make-simple-expander case-fxorc1))
    (def-exp "fxorc2"  (make-simple-expander case-fxorc2))
    (def-exp "fxxor"   (make-simple-expander case-fxxor))

    (def-exp2"bitwise-and"   (make-simple-expander case-fxand))
    (def-exp2"bitwise-andc1" (make-simple-expander case-fxandc1))
    (def-exp2"bitwise-andc2" (make-simple-expander case-fxandc2))
    (def-exp2"bitwise-eqv"   (make-simple-expander case-fxeqv))
    (def-exp2"bitwise-ior"   (make-simple-expander case-fxior))
    (def-exp2"bitwise-nand"  (make-simple-expander case-fxnand))
    (def-exp2"bitwise-nor"   (make-simple-expander case-fxnor))
    (def-exp2"bitwise-not"   (make-simple-expander case-fxnot))
    (def-exp2"bitwise-orc1"  (make-simple-expander case-fxorc1))
    (def-exp2"bitwise-orc2"  (make-simple-expander case-fxorc2))
    (def-exp2"bitwise-xor"   (make-simple-expander case-fxxor))

    (def-exp "fxwraparithmetic-shift"
      (make-simple-expander case-fxwraparithmetic-shift))
    (def-exp "fxarithmetic-shift"
      (make-simple-expander case-fxarithmetic-shift))
    (def-exp "fxwraparithmetic-shift-left"
      (make-simple-expander case-fxwraparithmetic-shift-left))
    (def-exp "fxarithmetic-shift-left"
      (make-simple-expander case-fxarithmetic-shift-left))
    (def-exp "fxarithmetic-shift-right"
      (make-simple-expander case-fxarithmetic-shift-right))
    (def-exp "fxwraplogical-shift-right"
      (make-simple-expander case-fxwraplogical-shift-right))

    (def-exp "fxwrapabs" (make-simple-expander case-fxwrapabs))
    (def-exp "fxabs" (make-simple-expander case-fxabs))
    (def-exp "flabs" (make-simple-expander case-flabs))
    (def-exp2"abs"   (make-fixflo-expander case-fxabs case-flabs))

    (def-exp "fxwrapsquare" (make-simple-expander case-fxwrapsquare))
    (def-exp "fxsquare" (make-simple-expander case-fxsquare))
    (def-exp "flsquare" (make-simple-expander case-flsquare))
    (def-exp2"square"   (make-fixflo-expander case-fxsquare case-flsquare))

    (def-exp "flfloor" (make-simple-expander case-flfloor))
    (def-exp2"floor"   (make-fixflo-expander no-case case-flfloor))

    (def-exp "flceiling" (make-simple-expander case-flceiling))
    (def-exp2"ceiling"   (make-fixflo-expander no-case case-flceiling))

    (def-exp "fltruncate" (make-simple-expander case-fltruncate))
    (def-exp2"truncate"   (make-fixflo-expander no-case case-fltruncate))

    (def-exp "flround" (make-simple-expander case-flround))
    (def-exp2"round"   (make-fixflo-expander no-case case-flround))

    (def-exp "flexp" (make-simple-expander case-flexp))
    (def-exp2"exp"   (make-fixflo-expander no-case case-flexp))

    (def-exp "fllog" (make-simple-expander case-fllog))
    (def-exp2"log"   (make-fixflo-expander no-case case-log-flonum))

    (def-exp "flsin" (make-simple-expander case-flsin))
    (def-exp2"sin"   (make-fixflo-expander no-case case-flsin))

    (def-exp "flcos" (make-simple-expander case-flcos))
    (def-exp2"cos"   (make-fixflo-expander no-case case-flcos))

    (def-exp "fltan" (make-simple-expander case-fltan))
    (def-exp2"tan"   (make-fixflo-expander no-case case-fltan))

    (def-exp "flasin" (make-simple-expander case-flasin))
    (def-exp2"asin"   (make-fixflo-expander no-case case-asin-flonum))

    (def-exp "flacos" (make-simple-expander case-flacos))
    (def-exp2"acos"   (make-fixflo-expander no-case case-acos-flonum))

    (def-exp "flatan" (make-simple-expander case-flatan))
    (def-exp2"atan"   (make-fixflo-expander no-case case-flatan))

    (def-exp "flsinh" (make-simple-expander case-flsinh))
    (def-exp2"sinh"   (make-fixflo-expander no-case case-flsinh))

    (def-exp "flcosh" (make-simple-expander case-flcosh))
    (def-exp2"cosh"   (make-fixflo-expander no-case case-flcosh))

    (def-exp "fltanh" (make-simple-expander case-fltanh))
    (def-exp2"tanh"   (make-fixflo-expander no-case case-fltanh))

    (def-exp "flasinh" (make-simple-expander case-flasinh))
    (def-exp2"asinh"   (make-fixflo-expander no-case case-flasinh))

    (def-exp "flacosh" (make-simple-expander case-flacosh))
    (def-exp2"acosh"   (make-fixflo-expander no-case case-acosh-flonum))

    (def-exp "flatanh" (make-simple-expander case-flatanh))
    (def-exp2"atanh"   (make-fixflo-expander no-case case-atanh-flonum))

    (def-exp "flhypot" (make-simple-expander case-flhypot))
    ;; There is no hypot function.

    (def-exp "flexpt" (make-simple-expander case-flexpt))
    (def-exp2"expt"   (make-fixflo-expander no-case case-expt-flonum))

    (def-exp "flsqrt" (make-simple-expander case-flsqrt))
    (def-exp2"sqrt"   (make-fixflo-expander no-case case-sqrt-flonum))

    (def-exp "fixnum->flonum" (make-simple-expander case-fixnum->flonum))

    (def-exp2
     "exact->inexact"
     (make-fixflo-expander
      case-fixnum-exact->inexact
      case-flonum-exact->inexact))

    (def-exp2
     "inexact->exact"
     (make-fixflo-expander
      case-fixnum-inexact->exact
      case-flonum-inexact->exact))

    (def-exp2
     "inexact"
     (make-fixflo-expander
      case-fixnum-exact->inexact
      case-flonum-exact->inexact))

    (def-exp2
     "exact"
     (make-fixflo-expander
      case-fixnum-inexact->exact
      case-flonum-inexact->exact))

    (def-exp2
     "numerator"
     (make-simple-expander
      (gen-simple-case (list **ratnum?-sym) **ratnum-numerator-sym)))

    (def-exp2
     "denominator"
     (make-simple-expander
      (gen-simple-case (list **ratnum?-sym) **ratnum-denominator-sym)))

    (def-exp2
     "real-part"
     (make-simple-expander
      (gen-simple-case (list **cpxnum?-sym) **cpxnum-real-sym)))

    (def-exp2
     "imag-part"
     (make-simple-expander
      (gen-simple-case (list **cpxnum?-sym) **cpxnum-imag-sym)))

    (if (eq? (target-name targ) 'C)
        (begin

          (def-exp2
            "eqv?"
            (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

          (def-exp
            "equal?"
            (make-simple-expander (case-eqv?-or-equal? **mem-allocated?-sym)))))
))

(define (setup-char-primitives)

  (define **char?-sym (string->canonical-symbol "##char?"))

  (define **char=?-sym (string->canonical-symbol "##char=?"))
  (define **char<?-sym (string->canonical-symbol "##char<?"))
  (define **char>?-sym (string->canonical-symbol "##char>?"))
  (define **char<=?-sym (string->canonical-symbol "##char<=?"))
  (define **char>=?-sym (string->canonical-symbol "##char>=?"))

;; Expanding the case independent versions isn't worth it...
;;
;;  (define **char-ci=?-sym (string->canonical-symbol "##char-ci=?"))
;;  (define **char-ci<?-sym (string->canonical-symbol "##char-ci<?"))
;;  (define **char-ci>?-sym (string->canonical-symbol "##char-ci>?"))
;;  (define **char-ci<=?-sym (string->canonical-symbol "##char-ci<=?"))
;;  (define **char-ci>=?-sym (string->canonical-symbol "##char-ci>=?"))

  (define case-char=?
    (gen-simple-case (list **char?-sym) **char=?-sym))

  (define case-char<?
    (gen-simple-case (list **char?-sym) **char<?-sym))

  (define case-char>?
    (gen-simple-case (list **char?-sym) **char>?-sym))

  (define case-char<=?
    (gen-simple-case (list **char?-sym) **char<=?-sym))

  (define case-char>=?
    (gen-simple-case (list **char?-sym) **char>=?-sym))

;;  (define case-char-ci=?
;;    (gen-simple-case (list **char?-sym) **char-ci=?-sym))
;;
;;  (define case-char-ci<?
;;    (gen-simple-case (list **char?-sym) **char-ci<?-sym))
;;
;;  (define case-char-ci>?
;;    (gen-simple-case (list **char?-sym) **char-ci>?-sym))
;;
;;  (define case-char-ci<=?
;;    (gen-simple-case (list **char?-sym) **char-ci<=?-sym))
;;
;;  (define case-char-ci>=?
;;    (gen-simple-case (list **char?-sym) **char-ci>=?-sym))

  (def-exp "char=?" (make-simple-expander case-char=?))
  (def-exp "char<?" (make-simple-expander case-char<?))
  (def-exp "char>?" (make-simple-expander case-char>?))
  (def-exp "char<=?" (make-simple-expander case-char<=?))
  (def-exp "char>=?" (make-simple-expander case-char>=?))

;;  (def-exp "char-ci=?" (make-simple-expander case-char-ci=?))
;;  (def-exp "char-ci<?" (make-simple-expander case-char-ci<?))
;;  (def-exp "char-ci>?" (make-simple-expander case-char-ci>?))
;;  (def-exp "char-ci<=?" (make-simple-expander case-char-ci<=?))
;;  (def-exp "char-ci>=?" (make-simple-expander case-char-ci>=?))
)

(define (setup-vector-primitives)

  (define **fixnum?-sym     (string->canonical-symbol "##fixnum?"))
  (define **flonum?-sym     (string->canonical-symbol "##flonum?"))
  (define **char?-sym       (string->canonical-symbol "##char?"))
  (define **fx<-sym         (string->canonical-symbol "##fx<"))
  (define **fx<=-sym        (string->canonical-symbol "##fx<="))
  (define **fxnegative?-sym (string->canonical-symbol "##fxnegative?"))
  (define **mutable?-sym    (string->canonical-symbol "##mutable?"))
  (define **not?-sym        (string->canonical-symbol "##not"))

  (define **string?-sym          (string->canonical-symbol "##string?"))
  (define **string-length-sym    (string->canonical-symbol "##string-length"))
  (define **string-ref-sym       (string->canonical-symbol "##string-ref"))
  (define **string-set!-sym      (string->canonical-symbol "##string-set!"))

  (define **vector?-sym          (string->canonical-symbol "##vector?"))
  (define **vector-length-sym    (string->canonical-symbol "##vector-length"))
  (define **vector-ref-sym       (string->canonical-symbol "##vector-ref"))
  (define **vector-set!-sym      (string->canonical-symbol "##vector-set!"))

  (define **s8vector?-sym        (string->canonical-symbol "##s8vector?"))
  (define **s8vector-length-sym  (string->canonical-symbol "##s8vector-length"))
  (define **s8vector-ref-sym     (string->canonical-symbol "##s8vector-ref"))
  (define **s8vector-set!-sym    (string->canonical-symbol "##s8vector-set!"))

  (define **u8vector?-sym        (string->canonical-symbol "##u8vector?"))
  (define **u8vector-length-sym  (string->canonical-symbol "##u8vector-length"))
  (define **u8vector-ref-sym     (string->canonical-symbol "##u8vector-ref"))
  (define **u8vector-set!-sym    (string->canonical-symbol "##u8vector-set!"))

  (define **s16vector?-sym       (string->canonical-symbol "##s16vector?"))
  (define **s16vector-length-sym (string->canonical-symbol "##s16vector-length"))
  (define **s16vector-ref-sym    (string->canonical-symbol "##s16vector-ref"))
  (define **s16vector-set!-sym   (string->canonical-symbol "##s16vector-set!"))

  (define **u16vector?-sym       (string->canonical-symbol "##u16vector?"))
  (define **u16vector-length-sym (string->canonical-symbol "##u16vector-length"))
  (define **u16vector-ref-sym    (string->canonical-symbol "##u16vector-ref"))
  (define **u16vector-set!-sym   (string->canonical-symbol "##u16vector-set!"))

  (define **s32vector?-sym       (string->canonical-symbol "##s32vector?"))
  (define **s32vector-length-sym (string->canonical-symbol "##s32vector-length"))
  (define **s32vector-ref-sym    (string->canonical-symbol "##s32vector-ref"))
  (define **s32vector-set!-sym   (string->canonical-symbol "##s32vector-set!"))

  (define **u32vector?-sym       (string->canonical-symbol "##u32vector?"))
  (define **u32vector-length-sym (string->canonical-symbol "##u32vector-length"))
  (define **u32vector-ref-sym    (string->canonical-symbol "##u32vector-ref"))
  (define **u32vector-set!-sym   (string->canonical-symbol "##u32vector-set!"))

  (define **s64vector?-sym       (string->canonical-symbol "##s64vector?"))
  (define **s64vector-length-sym (string->canonical-symbol "##s64vector-length"))
  (define **s64vector-ref-sym    (string->canonical-symbol "##s64vector-ref"))
  (define **s64vector-set!-sym   (string->canonical-symbol "##s64vector-set!"))

  (define **u64vector?-sym       (string->canonical-symbol "##u64vector?"))
  (define **u64vector-length-sym (string->canonical-symbol "##u64vector-length"))
  (define **u64vector-ref-sym    (string->canonical-symbol "##u64vector-ref"))
  (define **u64vector-set!-sym   (string->canonical-symbol "##u64vector-set!"))

  (define **f32vector?-sym       (string->canonical-symbol "##f32vector?"))
  (define **f32vector-length-sym (string->canonical-symbol "##f32vector-length"))
  (define **f32vector-ref-sym    (string->canonical-symbol "##f32vector-ref"))
  (define **f32vector-set!-sym   (string->canonical-symbol "##f32vector-set!"))

  (define **f64vector?-sym       (string->canonical-symbol "##f64vector?"))
  (define **f64vector-length-sym (string->canonical-symbol "##f64vector-length"))
  (define **f64vector-ref-sym    (string->canonical-symbol "##f64vector-ref"))
  (define **f64vector-set!-sym   (string->canonical-symbol "##f64vector-set!"))

  (define (make-fixnum-interval-checker lo hi)

    ;; assumes (integer-length hi) >= (integer-length lo)

    (let ((hi-type ((target-object-type targ) hi)))
      (lambda (source env var)
        (if (eq? hi-type 'bignum)

            (gen-call-prim-vars-notsafe source env
              **fixnum?-sym
              (list var))

            (let ((interval-check
                   (gen-fixnum-interval-check source env
                     var
                     (new-cst source env
                       lo)
                     (new-cst source env
                       hi)
                     #t)))
              (if (eq? hi-type 'fixnum)

                  interval-check

                  (new-conj source env
                    (gen-call-prim-notsafe source env
                      **fixnum?-sym
                      (list (new-cst source env
                              hi)))
                    interval-check)))))))

  (define (make-flonum-checker)
    (lambda (source env var)
      (gen-call-prim-vars-notsafe source env
        **flonum?-sym
        (list var))))

  (define (gen-fixnum-interval-check source env var lo hi incl?)
    (let* ((fixnum-check
            (gen-call-prim-vars-notsafe source env
              **fixnum?-sym
              (list var)))
           (interval-check
            (new-conj source env
              fixnum-check
              (new-conj source env
                (gen-call-prim-notsafe source env
                  **fx<=-sym
                  (list lo
                        (new-ref source env
                          var)))
                (gen-call-prim-notsafe source env
                  (if incl? **fx<=-sym **fx<-sym)
                  (list (new-ref source env
                          var)
                        hi))))))
      interval-check))

  (define (gen-fixnum-nonneg-check source env var)
    (let* ((fixnum-check
            (gen-call-prim-vars-notsafe source env
              **fixnum?-sym
              (list var)))
           (nonneg-check
            (gen-call-prim-notsafe source env
              **not-sym
              (list (gen-call-prim-vars-notsafe source env
                      **fxnegative?-sym
                      (list var)))))
           (fixnum-nonneg-check
            (new-conj source env
              fixnum-check
              nonneg-check)))
      fixnum-nonneg-check))

  (define (make-vector-expanders
           vect-kind
           default-init-val
           make-vect-str
           subvect-str
           vect-copy-str
           vect?-str
           vect-length-str
           vect-ref-str
           vect-set!-str
           vect-cas!-str
           vect-inc!-str
           **make-vect-str
           **make-vect-small-str
           **subvect-str
           **subvect-small-str
           **vect-copy-str
           **vect-copy-small-str
           **vect-insert-str
           **vect-insert-small-str
           **vect-delete-str
           **vect-delete-small-str
           **vect?-str
           **vect-length-str
           **vect-ref-str
           **vect-set!-str
           **vect-cas!-str
           **vect-inc!-str
           value-checker)
    (let ((make-vect-sym (string->canonical-symbol make-vect-str))
          (subvect-sym (string->canonical-symbol subvect-str))
          (vect-copy-sym (string->canonical-symbol vect-copy-str))
          (vect?-sym (string->canonical-symbol vect?-str))
          (vect-length-sym (string->canonical-symbol vect-length-str))
          (vect-ref-sym (string->canonical-symbol vect-ref-str))
          (vect-set!-sym (string->canonical-symbol vect-set!-str))
          (vect-cas!-sym (and vect-cas!-str (string->canonical-symbol vect-cas!-str)))
          (vect-inc!-sym (and vect-inc!-str (string->canonical-symbol vect-inc!-str)))
          (**make-vect-sym (string->canonical-symbol **make-vect-str))
          (**make-vect-small-sym (string->canonical-symbol **make-vect-small-str))
          (**subvect-sym (string->canonical-symbol **subvect-str))
          (**vect-copy-sym (string->canonical-symbol **vect-copy-str))
          (**vect?-sym (string->canonical-symbol **vect?-str))
          (**vect-length-sym (string->canonical-symbol **vect-length-str))
          (**vect-ref-sym (string->canonical-symbol **vect-ref-str))
          (**vect-set!-sym (string->canonical-symbol **vect-set!-str))
          (**vect-cas!-sym (and **vect-cas!-str (string->canonical-symbol **vect-cas!-str)))
          (**vect-inc!-sym (and **vect-inc!-str (string->canonical-symbol **vect-inc!-str))))

      (define (gen-vect-type-check source env vect-arg)
        (gen-call-prim-vars-notsafe source env
          **vect?-sym
          (list vect-arg)))

      (define (gen-size-check source env size-arg)
        (gen-fixnum-nonneg-check source env size-arg))

      (define (gen-mutability-check source env vect-arg)
        (gen-call-prim-vars-notsafe source env
          **mutable?-sym
          (list vect-arg)))

      (define (gen-index-check source env vect-arg index-arg)
        (gen-fixnum-interval-check source env
          index-arg
          (new-cst source env
            0)
          (gen-call-prim-vars-notsafe source env
            **vect-length-sym
            (list vect-arg))
          #f))

      (define (make-make-vect-expander type-check?)
        (lambda (ptree oper args generate-call check-run-time-binding)
          (let* ((source
                  (node-source ptree))
                 (env
                  (node-env ptree))
                 (vars
                  (gen-temp-vars source args))
                 (arg1
                  (car vars))
                 (size-check
                  (and type-check?
                       (gen-size-check source env arg1)))
                 (value-check
                  (and type-check?
                       value-checker
                       (pair? (cdr vars))
                       (value-checker source env (cadr vars))))
                 (size-value-check
                  (if (and size-check value-check)
                      (new-conj source env
                        size-check
                        value-check)
                      (or size-check value-check)))
                 (checks
                  (if check-run-time-binding
                      (let ((rtb-check (check-run-time-binding)))
                        (if size-value-check
                            (new-conj source env
                              rtb-check
                              size-value-check)
                            rtb-check))
                      size-value-check)))

            (define (call-make-vect small? env)
              (let ((prim (if small? **make-vect-small-sym **make-vect-sym)))
                (if (and (pair? vars)
                         (null? (cdr vars))
                         (safe? env)) ;; make sure there's an init in safe mode
                    (let ((env (add-not-safe env)))
                      (gen-call-prim source env
                        prim
                        (list (new-ref source env
                                (car vars))
                              (new-cst source env
                                default-init-val))))
                    (gen-call-prim-vars-notsafe source env
                     prim
                     vars))))

            (define (call-make-vect-possibly-small-alloc env)
              (let* ((limit
                      (allocation-limit env))
                     (max-small-alloc
                      (target-max-small-allocation targ))
                     (max-limit
                      (or (and max-small-alloc
                               (max-small-alloc vect-kind))
                          -1)))
                (cond ((or (< max-limit 0)
                           (eq? limit #f))
                       (call-make-vect #f env))
                      ((or (eq? limit #t)
                           (> limit max-limit))
                       (new-tst source env
                         (gen-call-prim-notsafe source env
                           **fx<=-sym
                           (list (new-ref source env
                                   arg1)
                                 (new-cst source env
                                   max-limit)))
                         (call-make-vect #t env)
                         (call-make-vect #f env)))
                      (else
                       (call-make-vect (<= limit max-limit) env)))))

            (gen-prc source env
              vars
              (if checks
                (new-tst source env
                  checks
                  (call-make-vect-possibly-small-alloc env)
                  (generate-call vars
                                 (not check-run-time-binding)))
                (call-make-vect-possibly-small-alloc env))))))

      (define (make-length-expander type-check?)
        (lambda (ptree oper args generate-call check-run-time-binding)
          (let* ((source
                  (node-source ptree))
                 (env
                  (node-env ptree))
                 (vars
                  (gen-temp-vars source args))
                 (arg1
                  (car vars))
                 (type-check
                  (and type-check?
                       (gen-vect-type-check source env arg1)))
                 (checks
                  (if check-run-time-binding
                    (let ((rtb-check (check-run-time-binding)))
                      (if type-check
                        (new-conj source env
                          rtb-check
                          type-check)
                        rtb-check))
                    type-check))
                 (call-prim
                  (gen-call-prim-vars-notsafe source env
                    **vect-length-sym
                    vars)))
            (gen-prc source env
              vars
              (if checks
                (new-tst source env
                  checks
                  call-prim
                  (generate-call vars
                                 (not check-run-time-binding)))
                call-prim)))))

      (define (make-ref-set!-cas!-inc!-expander type-check? kind)
        (lambda (ptree oper args generate-call check-run-time-binding)
          (let* ((source
                  (node-source ptree))
                 (env
                  (node-env ptree))
                 (vars
                  (gen-temp-vars source args))
                 (arg1
                  (car vars))
                 (arg2
                  (cadr vars))
                 (type-check
                  (and type-check?
                       (gen-vect-type-check source env arg1)))
                 (mutability-check
                  (and (not (eq? kind 'ref))
                       type-check
                       (gen-mutability-check source env arg1)))
                 (index-check
                  (and type-check?
                       (gen-index-check source env arg1 arg2)))
                 (value-check
                  (and value-checker
                       (not (eq? kind 'ref))
                       (value-checker source env (caddr vars))))
                 (index-value-check
                  (if (and index-check value-check)
                      (new-conj source env
                        index-check
                        value-check)
                      (or index-check value-check)))
                 (mutability-index-value-check
                  (if (and mutability-check index-value-check)
                      (new-conj source env
                        mutability-check
                        index-value-check)
                      (or mutability-check index-value-check)))
                 (type-mutability-index-value-check
                  (if (and type-check mutability-index-value-check)
                      (new-conj source env
                        type-check
                        mutability-index-value-check)
                      (or type-check mutability-index-value-check)))
                 (checks
                  (if check-run-time-binding
                      (let ((rtb-check (check-run-time-binding)))
                        (if type-mutability-index-value-check
                            (new-conj source env
                              rtb-check
                              type-mutability-index-value-check)
                            rtb-check))
                      type-mutability-index-value-check))
                 (call-prim
                  (gen-call-prim-vars-notsafe source env
                    (case kind
                      ((ref)  **vect-ref-sym)
                      ((set!) **vect-set!-sym)
                      ((cas!) **vect-cas!-sym)
                      (else   **vect-inc!-sym))
                    vars))
                 (value
                  (if (eq? kind 'set!)
                      (new-seq source env
                        call-prim
                        (new-cst source env
                          void-object))
                      call-prim)))
            (gen-prc source env
              vars
              (if checks
                  (new-tst source env
                    checks
                    value
                    (generate-call vars
                                   (not check-run-time-binding)))
                  call-prim)))))

      ;; inline make-vect and ##make-vect is target supports small allocations

      (if (target-max-small-allocation targ)
          (begin

           (def-exp
            make-vect-str
            (make-make-vect-expander #t))

           (def-exp
            **make-vect-str
            (make-make-vect-expander #f))))

      (def-exp
       vect-length-str
       (make-length-expander #t))

      (def-exp
       vect-ref-str
       (make-ref-set!-cas!-inc!-expander #t 'ref))

      (def-exp
       vect-set!-str
       (make-ref-set!-cas!-inc!-expander #t 'set!))

      (if vect-cas!-str
          (def-exp
            vect-cas!-str
            (make-ref-set!-cas!-inc!-expander #t 'cas!)))

      (if vect-inc!-str
          (def-exp
            vect-inc!-str
            (make-ref-set!-cas!-inc!-expander #t 'inc!)))))

  (make-vector-expanders
   'vector
   0
   "make-vector"
   "subvector"
   "vector-copy"
   "vector?"
   "vector-length"
   "vector-ref"
   "vector-set!"
   "vector-cas!"
   "vector-inc!"
   "##make-vector"
   "##make-vector-small"
   "##subvector"
   "##subvector-small"
   "##vector-copy"
   "##vector-copy-small"
   "##vector-insert"
   "##vector-insert-small"
   "##vector-delete"
   "##vector-delete-small"
   "##vector?"
   "##vector-length"
   "##vector-ref"
   "##vector-set!"
   "##vector-cas!"
   "##vector-inc!"
   #f)

  (make-vector-expanders
   'string
   (integer->char 0)
   "make-string"
   "substring"
   "string-copy"
   "string?"
   "string-length"
   "string-ref"
   "string-set!"
   #f
   #f
   "##make-string"
   "##make-string-small"
   "##substring"
   "##substring-small"
   "##string-copy"
   "##string-copy-small"
   "##string-insert"
   "##string-insert-small"
   "##string-delete"
   "##string-delete-small"
   "##string?"
   "##string-length"
   "##string-ref"
   "##string-set!"
   #f
   #f
   (lambda (source env var)
     (gen-call-prim-vars-notsafe source env
       **char?-sym
       (list var))))

  (make-vector-expanders
   's8vector
   0
   "make-s8vector"
   "subs8vector"
   "s8vector-copy"
   "s8vector?"
   "s8vector-length"
   "s8vector-ref"
   "s8vector-set!"
   #f
   #f
   "##make-s8vector"
   "##make-s8vector-small"
   "##subs8vector"
   "##subs8vector-small"
   "##s8vector-copy"
   "##s8vector-copy-small"
   "##s8vector-insert"
   "##s8vector-insert-small"
   "##s8vector-delete"
   "##s8vector-delete-small"
   "##s8vector?"
   "##s8vector-length"
   "##s8vector-ref"
   "##s8vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -128 127))

  (make-vector-expanders
   'u8vector
   0
   "make-u8vector"
   "subu8vector"
   "u8vector-copy"
   "u8vector?"
   "u8vector-length"
   "u8vector-ref"
   "u8vector-set!"
   #f
   #f
   "##make-u8vector"
   "##make-u8vector-small"
   "##subu8vector"
   "##subu8vector-small"
   "##u8vector-copy"
   "##u8vector-copy-small"
   "##u8vector-insert"
   "##u8vector-insert-small"
   "##u8vector-delete"
   "##u8vector-delete-small"
   "##u8vector?"
   "##u8vector-length"
   "##u8vector-ref"
   "##u8vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 255))

  (make-vector-expanders
   's16vector
   0
   "make-s16vector"
   "subs16vector"
   "s16vector-copy"
   "s16vector?"
   "s16vector-length"
   "s16vector-ref"
   "s16vector-set!"
   #f
   #f
   "##make-s16vector"
   "##make-s16vector-small"
   "##subs16vector"
   "##subs16vector-small"
   "##s16vector-copy"
   "##s16vector-copy-small"
   "##s16vector-insert"
   "##s16vector-insert-small"
   "##s16vector-delete"
   "##s16vector-delete-small"
   "##s16vector?"
   "##s16vector-length"
   "##s16vector-ref"
   "##s16vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -32768 32767))

  (make-vector-expanders
   'u16vector
   0
   "make-u16vector"
   "subu16vector"
   "u16vector-copy"
   "u16vector?"
   "u16vector-length"
   "u16vector-ref"
   "u16vector-set!"
   #f
   #f
   "##make-u16vector"
   "##make-u16vector-small"
   "##subu16vector"
   "##subu16vector-small"
   "##u16vector-copy"
   "##u16vector-copy-small"
   "##u16vector-insert"
   "##u16vector-insert-small"
   "##u16vector-delete"
   "##u16vector-delete-small"
   "##u16vector?"
   "##u16vector-length"
   "##u16vector-ref"
   "##u16vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 65535))

#;
  (make-vector-expanders
   's32vector
   0
   "make-s32vector"
   "subs32vector"
   "s32vector-copy"
   "s32vector?"
   "s32vector-length"
   "s32vector-ref"
   "s32vector-set!"
   #f
   #f
   "##make-s32vector"
   "##make-s32vector-small"
   "##subs32vector"
   "##subs32vector-small"
   "##s32vector-copy"
   "##s32vector-copy-small"
   "##s32vector-insert"
   "##s32vector-insert-small"
   "##s32vector-delete"
   "##s32vector-delete-small"
   "##s32vector?"
   "##s32vector-length"
   "##s32vector-ref"
   "##s32vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -2147483648 2147483647))

#;
  (make-vector-expanders
   'u32vector
   0
   "make-u32vector"
   "subu32vector"
   "u32vector-copy"
   "u32vector?"
   "u32vector-length"
   "u32vector-ref"
   "u32vector-set!"
   #f
   #f
   "##make-u32vector"
   "##make-u32vector-small"
   "##subu32vector"
   "##subu32vector-small"
   "##u32vector-copy"
   "##u32vector-copy-small"
   "##u32vector-insert"
   "##u32vector-insert-small"
   "##u32vector-delete"
   "##u32vector-delete-small"
   "##u32vector?"
   "##u32vector-length"
   "##u32vector-ref"
   "##u32vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 4294967295))

#;
  (make-vector-expanders
   's64vector
   0
   "make-s64vector"
   "subs64vector"
   "s64vector-copy"
   "s64vector?"
   "s64vector-length"
   "s64vector-ref"
   "s64vector-set!"
   #f
   #f
   "##make-s64vector"
   "##make-s64vector-small"
   "##subs64vector"
   "##subs64vector-small"
   "##s64vector-copy"
   "##s64vector-copy-small"
   "##s64vector-insert"
   "##s64vector-insert-small"
   "##s64vector-delete"
   "##s64vector-delete-small"
   "##s64vector?"
   "##s64vector-length"
   "##s64vector-ref"
   "##s64vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -9223372036854775808 9223372036854775807))

#;
  (make-vector-expanders
   'u64vector
   0
   "make-u64vector"
   "subu64vector"
   "u64vector-copy"
   "u64vector?"
   "u64vector-length"
   "u64vector-ref"
   "u64vector-set!"
   #f
   #f
   "##make-u64vector"
   "##make-u64vector-small"
   "##subu64vector"
   "##subu64vector-small"
   "##u64vector-copy"
   "##u64vector-copy-small"
   "##u64vector-insert"
   "##u64vector-insert-small"
   "##u64vector-delete"
   "##u64vector-delete-small"
   "##u64vector?"
   "##u64vector-length"
   "##u64vector-ref"
   "##u64vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 18446744073709551615))

  (make-vector-expanders
   'f32vector
   (macro-inexact-+0)
   "make-f32vector"
   "subf32vector"
   "f32vector-copy"
   "f32vector?"
   "f32vector-length"
   "f32vector-ref"
   "f32vector-set!"
   #f
   #f
   "##make-f32vector"
   "##make-f32vector-small"
   "##subf32vector"
   "##subf32vector-small"
   "##f32vector-copy"
   "##f32vector-copy-small"
   "##f32vector-insert"
   "##f32vector-insert-small"
   "##f32vector-delete"
   "##f32vector-delete-small"
   "##f32vector?"
   "##f32vector-length"
   "##f32vector-ref"
   "##f32vector-set!"
   #f
   #f
   (make-flonum-checker))

  (make-vector-expanders
   'f64vector
   (macro-inexact-+0)
   "make-f64vector"
   "subf64vector"
   "f64vector-copy"
   "f64vector?"
   "f64vector-length"
   "f64vector-ref"
   "f64vector-set!"
   #f
   #f
   "##make-f64vector"
   "##make-f64vector-small"
   "##subf64vector"
   "##subf64vector-small"
   "##f64vector-copy"
   "##f64vector-copy-small"
   "##f64vector-insert"
   "##f64vector-insert-small"
   "##f64vector-delete"
   "##f64vector-delete-small"
   "##f64vector?"
   "##f64vector-length"
   "##f64vector-ref"
   "##f64vector-set!"
   #f
   #f
   (make-flonum-checker))
)

(define (setup-structure-primitives)

  (define **structure-direct-instance-of?-sym
    (string->canonical-symbol "##structure-direct-instance-of?"))

  (define **type-id-sym
    (string->canonical-symbol "##type-id"))

  (define **unchecked-structure-ref-sym
    (string->canonical-symbol "##unchecked-structure-ref"))

  (define **unchecked-structure-set!-sym
    (string->canonical-symbol "##unchecked-structure-set!"))

  (define **unchecked-structure-cas!-sym
    (string->canonical-symbol "##unchecked-structure-cas!"))

  (define (gen-structure-type-check source env obj-arg type-arg)
    (gen-call-prim-notsafe source env
      **structure-direct-instance-of?-sym
      (list (new-ref source env
              obj-arg)
            (gen-call-prim-vars-notsafe source env
              **type-id-sym
              (list type-arg)))))

  (define (make-ref-set!-cas!-expander kind)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (vars
              (gen-temp-vars source args))
             (obj-var
              (list-ref vars 0))
             (type-var
              (list-ref vars (case kind ((ref) 2) ((set!) 3) (else 4))))
             (type-check
              (gen-structure-type-check source env obj-var type-var))
             (call-prim
              (gen-call-prim-vars-notsafe source env
                (case kind
                  ((ref)  **unchecked-structure-ref-sym)
                  ((set!) **unchecked-structure-set!-sym)
                  (else   **unchecked-structure-cas!-sym))
                vars)))
        (gen-prc source env
          vars
          (new-tst source env
            type-check
            call-prim
            (generate-call vars
                           (not check-run-time-binding)))))))

  (def-exp
   "##direct-structure-ref"
   (make-ref-set!-cas!-expander 'ref))

  (def-exp
   "##direct-structure-set!"
   (make-ref-set!-cas!-expander 'set!))

  (def-exp
   "##direct-structure-cas!"
   (make-ref-set!-cas!-expander 'cas!))
)

(define (setup-io-primitives)

  (define **peek-char0?-sym (string->canonical-symbol "##peek-char0?"))
  (define **peek-char1?-sym (string->canonical-symbol "##peek-char1?"))

  (define **read-char0?-sym (string->canonical-symbol "##read-char0?"))
  (define **read-char1?-sym (string->canonical-symbol "##read-char1?"))

  (define **write-char1?-sym (string->canonical-symbol "##write-char1?"))
  (define **write-char2?-sym (string->canonical-symbol "##write-char2?"))

  (define **char?-sym (string->canonical-symbol "##char?"))

  (define **char-input-port?-cached-sym (string->canonical-symbol "##char-input-port?-cached"))
  (define **char-output-port?-cached-sym (string->canonical-symbol "##char-output-port?-cached"))

  (def-exp "##peek-char0"
           (make-simple-expander
            (make-conditional-fast-path **peek-char0?-sym)))

  (def-exp "##peek-char1"
           (make-simple-expander
            (make-conditional-fast-path **peek-char1?-sym)))

  (def-exp "peek-char"
           (make-0-or-1-args-expander
            (gen-validating-case
             (list)
             (make-conditional-fixed-arity-generator
              **peek-char0?-sym
              #f))
            (gen-validating-case
             (list **char-input-port?-cached-sym)
             (make-conditional-fixed-arity-generator
              **peek-char1?-sym
              #f))))

  (def-exp "##read-char0"
           (make-simple-expander
            (make-conditional-fast-path **read-char0?-sym)))

  (def-exp "##read-char1"
           (make-simple-expander
            (make-conditional-fast-path **read-char1?-sym)))

  (def-exp "read-char"
           (make-0-or-1-args-expander
            (gen-validating-case
             (list)
             (make-conditional-fixed-arity-generator
              **read-char0?-sym
              #f))
            (gen-validating-case
             (list **char-input-port?-cached-sym)
             (make-conditional-fixed-arity-generator
              **read-char1?-sym
              #f))))

  (def-exp "##write-char1"
           (make-simple-expander
            (make-conditional-fast-path **write-char1?-sym)))

  (def-exp "##write-char2"
           (make-simple-expander
            (make-conditional-fast-path **write-char2?-sym)))

  (def-exp "write-char"
           (make-1-or-2-args-expander
            (gen-validating-case
             (list **char?-sym)
             (make-conditional-fixed-arity-generator
              **write-char1?-sym
              #f))
            (gen-validating-case
             (list **char?-sym **char-output-port?-cached-sym)
             (make-conditional-fixed-arity-generator
              **write-char2?-sym
              #f))))
)

(define (setup-misc-primitives)

  (define **symbol->string?-sym (string->canonical-symbol "##symbol->string?"))
  (define **symbol?-sym (string->canonical-symbol "##symbol?"))

  (def-exp "##symbol->string"
           (make-simple-expander
            (gen-validating-case
             #f
             (make-conditional-fixed-arity-generator
              **symbol->string?-sym
              #f))))

  (def-exp "symbol->string"
           (make-simple-expander
            (gen-validating-case
             (list **symbol?-sym)
             (make-conditional-fixed-arity-generator
              **symbol->string?-sym
              #f))))

)

(setup-list-primitives)
(setup-numeric-primitives)
(setup-char-primitives)
(setup-vector-primitives)
(setup-structure-primitives)
(setup-io-primitives)
(setup-misc-primitives)

)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure simplifiers

(define (setup-prim-simplifiers targ)

;; TODO: remove dependencies to C back-end

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

(define (def-simp name . folders)
  (let ((simp
         (lambda (ptree args)
           (let loop ((lst folders))
             (if (pair? lst)
                 (let ((folder (car lst)))
                   (or (folder ptree args)
                       (loop (cdr lst))))
                 #f)))))

    (define (simp-set name)
      (let ((proc (get-prim-info name)))
        (if proc (proc-obj-simplify-set! proc simp))))

    (simp-set name)
    (simp-set (string-append "##" name))))

(define (constant-folder op . type-patterns)
  (constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (new-cst (node-source ptree) (node-env ptree)
         result)))
   type-patterns))

(define (constant-folder-gen op . type-patterns)
  (apply constant-folder (cons op type-patterns)))

(define (constant-folder-fix op . type-patterns)
  (constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (and (or (not (number? result))
                (targ-fixnum32? result)) ;; TODO: remove dependency on C back-end
            (new-cst (node-source ptree) (node-env ptree)
              result))))
   type-patterns))

(define (constant-folder-flo op . type-patterns)
  (constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (and (or (not (number? result))
                (targ-flonum? result)) ;; TODO: remove dependency on C back-end
            (new-cst (node-source ptree) (node-env ptree)
              result))))
   type-patterns))

(define (constant-folder-with-ptree-maker ptree-maker type-patterns)
  (let ((type-patterns
         (if (null? type-patterns)
           (list (lambda (obj) #t))
           type-patterns)))
    (lambda (ptree args)

      (define (match? args type-pattern)
        (if (pair? args)
          (cond ((pair? type-pattern)
                 (and ((car type-pattern) (car args))
                      (match? (cdr args) (cdr type-pattern))))
                ((null? type-pattern)
                 #f)
                (else
                 (and (type-pattern (car args))
                      (match? (cdr args) type-pattern))))
          (not (pair? type-pattern))))

      (and (every? cst? args) ; are all arguments constants?
           (let ((arg-vals (map cst-val args)))
             (let loop ((type-pats type-patterns))
               (if (pair? type-pats)
                 (if (match? arg-vals (car type-pats))
                   (ptree-maker ptree arg-vals)
                   (loop (cdr type-pats)))
                 #f)))))))

(define (constant-folder-ref op get-length type?)
  (lambda (ptree args)
    (and (every? cst? args) ; are all arguments constants?
         (let* ((arg-vals (map cst-val args))
                (vect (car arg-vals))
                (index (cadr arg-vals)))
           (and (type? vect)
                (integer? index)
                (exact? index)
                (not (< index 0))
                (< index (get-length vect))
                (let ((result (op vect index)))
                  (new-cst (node-source ptree) (node-env ptree)
                    result)))))))

(define (num? obj) (targ-number? obj)) ;; TODO: remove dependency on C back-end
(define (nz-num? obj) (targ-nonzero-number? obj)) ;; TODO: remove dependency on C back-end

(define (int? obj) (targ-integer? obj)) ;; TODO: remove dependency on C back-end
(define (nz-int? obj) (targ-nonzero-integer? obj)) ;; TODO: remove dependency on C back-end

(define (flo? obj) (targ-flonum? obj)) ;; TODO: remove dependency on C back-end
(define (nz-flo? obj) (targ-nonzero-flonum? obj)) ;; TODO: remove dependency on C back-end
(define (int-flo? obj) (and (targ-flonum? obj) (targ-integer? obj))) ;; TODO: remove dependency on C back-end
(define (fin-flo? obj) (and (targ-flonum? obj) (targ-finite? obj))) ;; TODO: remove dependency on C back-end

(define (fix32? obj) (targ-fixnum32? obj)) ;; TODO: remove dependency on C back-end
(define (nz-fix32? obj) (targ-nonzero-fixnum32? obj)) ;; TODO: remove dependency on C back-end

(define (fin-real? obj) (and (real? obj) (targ-finite? obj))) ;; TODO: remove dependency on C back-end

(define (not-bigfix? obj)
  (not (and (targ-fixnum64? obj) (not (targ-fixnum32? obj))))) ;; TODO: remove dependency on C back-end

(define (mem-alloc? obj)
  (let ((type (targ-obj-type obj))) ;; TODO: remove dependency on C back-end
    (or (eq? type 'pair)
        (and (eq? type 'subtyped)
             (not-bigfix? obj)))))

(define (any obj) #t)

(define (alist? obj) (and (list? obj) (every? pair? obj)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-simp "not"              (constant-folder false-object?  ))
(def-simp "boolean?"         (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (eq? obj #t)))))
(def-simp "##false-or-null?" (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (null? obj)))))
(def-simp "##false-or-void?" (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (void-object? obj)))))
(def-simp "eqv?"             (constant-folder eqv?           ))
(def-simp "eq?"              (constant-folder eq?            ))
(def-simp "equal?"           (constant-folder equal?         ))
(def-simp "##mem-allocated?" (constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj) ;; TODO: remove dependency on C back-end
                                                        ((subtyped pair) #t)
                                                        (else            #f)))
                                                    not-bigfix?))
(def-simp "##subtyped?"      (constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj) ;; TODO: remove dependency on C back-end
                                                        ((subtyped) #t)
                                                        (else       #f)))
                                                    not-bigfix?))
(def-simp "##subtype"        (constant-folder targ-obj-subtype-integer ;; TODO: remove dependency on C back-end
                                                    mem-alloc?))
(def-simp "pair?"            (constant-folder pair?          ))
;(def-simp "cons"             (constant-folder cons           ))  ;; this would not preserve mutability and eq?-ness
(def-simp "car"              (constant-folder car            pair?))
(def-simp "cdr"              (constant-folder cdr            pair?))
;(def-simp "caar"             (constant-folder caar           ))
;(def-simp "cadr"             (constant-folder cadr           ))
;(def-simp "cdar"             (constant-folder cdar           ))
;(def-simp "cddr"             (constant-folder cddr           ))
;(def-simp "caaar"            (constant-folder caaar          ))
;(def-simp "caadr"            (constant-folder caadr          ))
;(def-simp "cadar"            (constant-folder cadar          ))
;(def-simp "caddr"            (constant-folder caddr          ))
;(def-simp "cdaar"            (constant-folder cdaar          ))
;(def-simp "cdadr"            (constant-folder cdadr          ))
;(def-simp "cddar"            (constant-folder cddar          ))
;(def-simp "cdddr"            (constant-folder cdddr          ))
;(def-simp "caaaar"           (constant-folder caaaar         ))
;(def-simp "caaadr"           (constant-folder caaadr         ))
;(def-simp "caadar"           (constant-folder caadar         ))
;(def-simp "caaddr"           (constant-folder caaddr         ))
;(def-simp "cadaar"           (constant-folder cadaar         ))
;(def-simp "cadadr"           (constant-folder cadadr         ))
;(def-simp "caddar"           (constant-folder caddar         ))
;(def-simp "cadddr"           (constant-folder cadddr         ))
;(def-simp "cdaaar"           (constant-folder cdaaar         ))
;(def-simp "cdaadr"           (constant-folder cdaadr         ))
;(def-simp "cdadar"           (constant-folder cdadar         ))
;(def-simp "cdaddr"           (constant-folder cdaddr         ))
;(def-simp "cddaar"           (constant-folder cddaar         ))
;(def-simp "cddadr"           (constant-folder cddadr         ))
;(def-simp "cdddar"           (constant-folder cdddar         ))
;(def-simp "cddddr"           (constant-folder cddddr         ))
(def-simp "null?"            (constant-folder null?          ))
(def-simp "list?"            (constant-folder list?          ))
;(def-simp "list"             (constant-folder list           ))  ;; this would not preserve mutability and eq?-ness
(def-simp "length"           (constant-folder length         list?))
;(def-simp "append"           (constant-folder append         list?))
;(def-simp "reverse"          (constant-folder reverse        list?))
(def-simp "list-ref"         (constant-folder-ref
                               list-ref
                               length
                               list?))
(def-simp "memq"             (constant-folder memq
                                                    (list any list?)))
(def-simp "memv"             (constant-folder memv
                                                    (list any list?)))
(def-simp "member"           (constant-folder member
                                                    (list any list?)))
(def-simp "assq"             (constant-folder assq
                                                    (list any alist?)))
(def-simp "assv"             (constant-folder assv
                                                    (list any alist?)))
(def-simp "assoc"            (constant-folder assoc
                                                    (list any alist?)))
(def-simp "symbol?"          (constant-folder symbol-object? ))
(def-simp "symbol->string"   (constant-folder symbol->string
                                              symbol-object?))
(def-simp "string->symbol"   (constant-folder string->symbol ))
(def-simp "number?"          (constant-folder number?        ))
(def-simp "complex?"         (constant-folder complex?       ))
(def-simp "real?"            (constant-folder real?          ))
(def-simp "rational?"        (constant-folder rational?      ))
(def-simp "integer?"         (constant-folder integer?       ))
(def-simp "exact?"           (constant-folder exact?         num?))
(def-simp "inexact?"         (constant-folder inexact?       num?))
(def-simp "exact-integer?"   (constant-folder (lambda (x) (and (integer? x) (exact? x)))))
(def-simp "="                (constant-folder =              num?))
(def-simp "fx="              (constant-folder =              fix32?))
(def-simp "fl="              (constant-folder =              flo?))
(def-simp "<"                (constant-folder <              real?))
(def-simp "fx<"              (constant-folder <              fix32?))
(def-simp "fl<"              (constant-folder <              flo?))
(def-simp ">"                (constant-folder >              real?))
(def-simp "fx>"              (constant-folder >              fix32?))
(def-simp "fl>"              (constant-folder >              flo?))
(def-simp "<="               (constant-folder <=             real?))
(def-simp "fx<="             (constant-folder <=             fix32?))
(def-simp "fl<="             (constant-folder <=             flo?))
(def-simp ">="               (constant-folder >=             real?))
(def-simp "fx>="             (constant-folder >=             fix32?))
(def-simp "fl>="             (constant-folder >=             flo?))
(def-simp "zero?"            (constant-folder zero?          num?))
(def-simp "fxzero?"          (constant-folder zero?          fix32?))
(def-simp "flzero?"          (constant-folder zero?          flo?))
(def-simp "positive?"        (constant-folder positive?     real?))
(def-simp "fxpositive?"      (constant-folder positive?     fix32?))
(def-simp "flpositive?"      (constant-folder positive?     flo?))
(def-simp "negative?"        (constant-folder negative?     real?))
(def-simp "fxnegative?"      (constant-folder negative?     fix32?))
(def-simp "flnegative?"      (constant-folder negative?     flo?))
(def-simp "odd?"             (constant-folder odd?           int?))
(def-simp "fxodd?"           (constant-folder odd?           fix32?))
(def-simp "flodd?"           (constant-folder odd?           int-flo?))
(def-simp "even?"            (constant-folder even?          int?))
(def-simp "fxeven?"          (constant-folder even?          fix32?))
(def-simp "fleven?"          (constant-folder even?          int-flo?))
(def-simp "max"              (constant-folder-gen max        real?))
(def-simp "fxmax"            (constant-folder-fix max        fix32?))
(def-simp "flmax"            (constant-folder-flo max        flo?))
(def-simp "min"              (constant-folder-gen min        real?))
(def-simp "fxmin"            (constant-folder-fix min        fix32?))
(def-simp "flmin"            (constant-folder-flo min        flo?))
(def-simp "+"                (constant-folder-gen +          num?))
(def-simp "fxwrap+"          (constant-folder-fix +          fix32?))
(def-simp "fx+"              (constant-folder-fix +          fix32?))
(def-simp "fx+?"             (constant-folder-fix +          fix32?))
(def-simp "fl+"              (constant-folder-flo +          flo?));;;;;;;;;;must return 0.0 when 0 args
(def-simp "*"                (constant-folder-gen *          num?))
(def-simp "fxwrap*"          (constant-folder-fix *          fix32?))
(def-simp "fx*"              (constant-folder-fix *          fix32?))
(def-simp "fx*?"             (constant-folder-fix *          fix32?))
(def-simp "fl*"              (constant-folder-flo *          flo?));;;;;;;;;;must return 1.0 when 0 args
(def-simp "-"                (constant-folder-gen -          num?))
(def-simp "fxwrap-"          (constant-folder-fix -          fix32?))
(def-simp "fx-"              (constant-folder-fix -          fix32?))
(def-simp "fx-?"             (constant-folder-fix -          fix32?))
(def-simp "fl-"              (constant-folder-flo -          flo?))
(def-simp "/"                (constant-folder-gen /
                                                  (list nz-num?)
                                                  (cons num?
                                                        (cons nz-num?
                                                              nz-num?))))
(def-simp "fl/"              (constant-folder-flo /          flo?))
(def-simp "abs"              (constant-folder-gen abs        num?))
(def-simp "fxwrapabs"        (constant-folder-fix abs        fix32?))
(def-simp "fxabs"            (constant-folder-fix abs        fix32?))
(def-simp "fxabs?"           (constant-folder-fix abs        fix32?))
(def-simp "flabs"            (constant-folder-flo abs        flo?))
(def-simp "square"           (constant-folder-gen square     num?))
(def-simp "fxwrapsquare"     (constant-folder-fix square     fix32?))
(def-simp "fxsquare"         (constant-folder-fix square     fix32?))
(def-simp "fxsquare?"        (constant-folder-fix square     fix32?))
(def-simp "flsquare"         (constant-folder-flo square     flo?))
(def-simp "quotient"         (constant-folder-gen quotient
                                                  (list int? nz-int?)))
(def-simp "fxwrapquotient"   (constant-folder-fix quotient
                                                  (list fix32? nz-fix32?)))
(def-simp "fxquotient"       (constant-folder-fix quotient
                                                  (list fix32? nz-fix32?)))
(def-simp "remainder"        (constant-folder-gen remainder
                                                  (list int? nz-int?)))
(def-simp "fxremainder"      (constant-folder-fix remainder
                                                  (list fix32? nz-fix32?)))
(def-simp "modulo"           (constant-folder-gen modulo
                                                  (list int? nz-int?)))
(def-simp "fxmodulo"         (constant-folder-fix modulo
                                                  (list fix32? nz-fix32?)))
(def-simp "gcd"              (constant-folder-gen gcd        int?))
(def-simp "lcm"              (constant-folder-gen lcm        int?))
(def-simp "numerator"        (constant-folder-gen numerator  rational?))
(def-simp "denominator"      (constant-folder-gen denominator rational?))
(def-simp "floor"            (constant-folder-gen floor      fin-real?))
(def-simp "flfloor"          (constant-folder-flo floor      fin-flo?))
(def-simp "ceiling"          (constant-folder-gen ceiling    fin-real?))
(def-simp "flceiling"        (constant-folder-flo ceiling    fin-flo?))
(def-simp "truncate"         (constant-folder-gen truncate   fin-real?))
(def-simp "fltruncate"       (constant-folder-flo truncate   fin-flo?))
(def-simp "round"            (constant-folder-gen round      fin-real?))
(def-simp "flround"          (constant-folder-flo round      fin-flo?))
(def-simp "rationalize"      (constant-folder-gen rationalize real?))
(def-simp "exp"              (constant-folder-gen exp        num?))
(def-simp "flexp"            (constant-folder-flo exp        flo?))
(def-simp "log"              (constant-folder-gen log        nz-num?))
(def-simp "fllog"            (constant-folder-flo log        nz-flo?))
(def-simp "sin"              (constant-folder-gen sin        num?))
(def-simp "flsin"            (constant-folder-flo sin        flo?))
(def-simp "cos"              (constant-folder-gen cos        num?))
(def-simp "flcos"            (constant-folder-flo cos        flo?))
(def-simp "tan"              (constant-folder-gen tan        num?))
(def-simp "fltan"            (constant-folder-flo tan        flo?))
(def-simp "asin"             (constant-folder-gen asin       num?))
(def-simp "flasin"           (constant-folder-flo asin       flo?))
(def-simp "acos"             (constant-folder-gen acos       num?))
(def-simp "flacos"           (constant-folder-flo acos       flo?))
(def-simp "atan"             (constant-folder-gen atan       num?))
(def-simp "flatan"           (constant-folder-flo atan       flo?))
(def-simp "flhypot"          (constant-folder-flo flhypot    flo?))
(def-simp "expt"             (constant-folder-gen expt       num?))
(def-simp "flexpt"           (constant-folder-flo expt       flo?))
(def-simp "sqrt"             (constant-folder-gen sqrt       num?))
(def-simp "flsqrt"           (constant-folder-flo sqrt       flo?))
(def-simp "expt"             (constant-folder-gen expt       num?))
(def-simp "sinh"             (constant-folder-gen sinh       num?))
(def-simp "flsinh"           (constant-folder-flo sinh       flo?))
(def-simp "cosh"             (constant-folder-gen cosh       num?))
(def-simp "flcosh"           (constant-folder-flo cosh       flo?))
(def-simp "tanh"             (constant-folder-gen tanh       num?))
(def-simp "fltanh"           (constant-folder-flo tanh       flo?))
(def-simp "asinh"            (constant-folder-gen asinh      num?))
(def-simp "flasinh"          (constant-folder-flo asinh      flo?))
(def-simp "acosh"            (constant-folder-gen acosh      num?))
(def-simp "flacosh"          (constant-folder-flo acosh      flo?))
;; (def-simp "atanh"            (constant-folder-gen atanh      num?)) ;; TODO: arg must not be +1 or -1
(def-simp "flatanh"          (constant-folder-flo atanh      flo?))
(def-simp "##flonum->fixnum" (constant-folder-fix inexact->exact flo?))
(def-simp "fixnum->flonum"   (constant-folder-flo exact->inexact fix32?))

(def-simp "fxand"            (constant-folder-fix fxand   fix32?))
(def-simp "fxandc1"          (constant-folder-fix fxandc1 fix32?))
(def-simp "fxandc2"          (constant-folder-fix fxandc2 fix32?))
(def-simp "fxeqv"            (constant-folder-fix fxeqv   fix32?))
(def-simp "fxior"            (constant-folder-fix fxior   fix32?))
(def-simp "fxnand"           (constant-folder-fix fxnand  fix32?))
(def-simp "fxnor"            (constant-folder-fix fxnor   fix32?))
(def-simp "fxnot"            (constant-folder-fix fxnot   fix32?))
(def-simp "fxorc1"           (constant-folder-fix fxorc1  fix32?))
(def-simp "fxorc2"           (constant-folder-fix fxorc2  fix32?))
(def-simp "fxxor"            (constant-folder-fix fxxor   fix32?))

(def-simp "bitwise-and"      (constant-folder-gen bitwise-and   int?))
(def-simp "bitwise-andc1"    (constant-folder-gen bitwise-andc1 int?))
(def-simp "bitwise-andc2"    (constant-folder-gen bitwise-andc2 int?))
(def-simp "bitwise-eqv"      (constant-folder-gen bitwise-eqv   int?))
(def-simp "bitwise-ior"      (constant-folder-gen bitwise-ior   int?))
(def-simp "bitwise-nand"     (constant-folder-gen bitwise-nand  int?))
(def-simp "bitwise-nor"      (constant-folder-gen bitwise-nor   int?))
(def-simp "bitwise-not"      (constant-folder-gen bitwise-not   int?))
(def-simp "bitwise-orc1"     (constant-folder-gen bitwise-orc1  int?))
(def-simp "bitwise-orc2"     (constant-folder-gen bitwise-orc2  int?))
(def-simp "bitwise-xor"      (constant-folder-gen bitwise-xor   int?))

(def-simp "make-rectangular" (constant-folder-gen make-rectangular real?))
(def-simp "make-polar"       (constant-folder-gen make-polar     real?))
(def-simp "real-part"        (constant-folder-gen real-part      num?))
(def-simp "imag-part"        (constant-folder-gen imag-part      num?))
(def-simp "magnitude"        (constant-folder-gen magnitude      num?))
(def-simp "angle"            (constant-folder-gen angle          num?))
(def-simp "exact->inexact"   (constant-folder-gen exact->inexact num?))
(def-simp "inexact->exact"   (constant-folder-gen inexact->exact num?))
;(def-simp "number->string"   (constant-folder number->string num?))
(def-simp "string->number"   (constant-folder string->number string?))

(def-simp "char?"            (constant-folder char?          ))
(def-simp "char=?"           (constant-folder char=?         char?))
(def-simp "char<?"           (constant-folder char<?         char?))
(def-simp "char>?"           (constant-folder char>?         char?))
(def-simp "char<=?"          (constant-folder char<=?        char?))
(def-simp "char>=?"          (constant-folder char>=?        char?))
(def-simp "char-ci=?"        (constant-folder char-ci=?      char?))
(def-simp "char-ci<?"        (constant-folder char-ci<?      char?))
(def-simp "char-ci>?"        (constant-folder char-ci>?      char?))
(def-simp "char-ci<=?"       (constant-folder char-ci<=?     char?))
(def-simp "char-ci>=?"       (constant-folder char-ci>=?     char?))
(def-simp "char-alphabetic?" (constant-folder char-alphabetic? char?))
(def-simp "char-numeric?"    (constant-folder char-numeric?  char?))
(def-simp "char-whitespace?" (constant-folder char-whitespace? char?))
(def-simp "char-upper-case?" (constant-folder char-upper-case? char?))
(def-simp "char-lower-case?" (constant-folder char-lower-case? char?))
(def-simp "char->integer"    (constant-folder char->integer  char?))
;(def-simp "integer->char"    (constant-folder integer->char  ))
(def-simp "char-upcase"      (constant-folder char-upcase    char?))
(def-simp "char-downcase"    (constant-folder char-downcase  char?))

(def-simp "string?"          (constant-folder string?        ))
;(def-simp "make-string"      (constant-folder make-string    ))
;(def-simp "string"           (constant-folder string         char?))
(def-simp "string-length"    (constant-folder string-length  string?))
(def-simp "string-ref"       (constant-folder-ref
                              string-ref
                              string-length
                              string?))
(def-simp "string=?"         (constant-folder string=?       string?))
(def-simp "string<?"         (constant-folder string<?       string?))
(def-simp "string>?"         (constant-folder string>?       string?))
(def-simp "string<=?"        (constant-folder string<=?      string?))
(def-simp "string>=?"        (constant-folder string>=?      string?))
(def-simp "string-ci=?"      (constant-folder string-ci=?    string?))
(def-simp "string-ci<?"      (constant-folder string-ci<?    string?))
(def-simp "string-ci>?"      (constant-folder string-ci>?    string?))
(def-simp "string-ci<=?"     (constant-folder string-ci<=?   string?))
(def-simp "string-ci>=?"     (constant-folder string-ci>=?   string?))
;(def-simp "substring"        (constant-folder substring      ))
;(def-simp "string-append"    (constant-folder string-append  string?))

(def-simp "vector?"          (constant-folder vector-object? ))
;(def-simp "make-vector"      (constant-folder make-vector    ))
;(def-simp "vector"           (constant-folder vector         ))
(def-simp "vector-length"    (constant-folder vector-length
                                              vector-object?))
(def-simp "vector-ref"       (constant-folder-ref
                              vector-ref
                              vector-length
                              vector-object?))

(def-simp "s8vector?"        (constant-folder s8vect? ))
;(def-simp "make-s8vector"    (constant-folder make-s8vect    ))
;(def-simp "s8vector"         (constant-folder s8vect         ))
(def-simp "s8vector-length"  (constant-folder s8vect-length
                                              s8vect?))
(def-simp "s8vector-ref"     (constant-folder-ref
                              s8vect-ref
                              s8vect-length
                              s8vect?))

(def-simp "u8vector?"        (constant-folder u8vect? ))
;(def-simp "make-u8vector"    (constant-folder make-u8vect    ))
;(def-simp "u8vector"         (constant-folder u8vect         ))
(def-simp "u8vector-length"  (constant-folder u8vect-length
                                              u8vect?))
(def-simp "u8vector-ref"     (constant-folder-ref
                              u8vect-ref
                              u8vect-length
                              u8vect?))

(def-simp "s16vector?"       (constant-folder s16vect? ))
;(def-simp "make-s16vector"   (constant-folder make-s16vect    ))
;(def-simp "s16vector"        (constant-folder s16vect         ))
(def-simp "s16vector-length" (constant-folder s16vect-length
                                              s16vect?))
(def-simp "s16vector-ref"    (constant-folder-ref
                              s16vect-ref
                              s16vect-length
                              s16vect?))

(def-simp "u16vector?"       (constant-folder u16vect? ))
;(def-simp "make-u16vector"   (constant-folder make-u16vect    ))
;(def-simp "u16vector"        (constant-folder u16vect         ))
(def-simp "u16vector-length" (constant-folder u16vect-length
                                              u16vect?))
(def-simp "u16vector-ref"    (constant-folder-ref
                              u16vect-ref
                              u16vect-length
                              u16vect?))

(def-simp "s32vector?"         (constant-folder s32vect? ))
;(def-simp "make-s32vector"     (constant-folder make-s32vect    ))
;(def-simp "s32vector"          (constant-folder s32vect         ))
(def-simp "s32vector-length"   (constant-folder s32vect-length
                                                s32vect?))
(def-simp "s32vector-ref"      (constant-folder-ref
                                s32vect-ref
                                s32vect-length
                                s32vect?))

(def-simp "u32vector?"         (constant-folder u32vect? ))
;(def-simp "make-u32vector"     (constant-folder make-u32vect    ))
;(def-simp "u32vector"          (constant-folder u32vect         ))
(def-simp "u32vector-length"   (constant-folder u32vect-length
                                                u32vect?))
(def-simp "u32vector-ref"      (constant-folder-ref
                                u32vect-ref
                                u32vect-length
                                u32vect?))

(def-simp "s64vector?"         (constant-folder s64vect? ))
;(def-simp "make-s64vector"     (constant-folder make-s64vect    ))
;(def-simp "s64vector"          (constant-folder s64vect         ))
(def-simp "s64vector-length"   (constant-folder s64vect-length
                                                s64vect?))
(def-simp "s64vector-ref"      (constant-folder-ref
                                s64vect-ref
                                s64vect-length
                                s64vect?))

(def-simp "u64vector?"         (constant-folder u64vect? ))
;(def-simp "make-u64vector"     (constant-folder make-u64vect    ))
;(def-simp "u64vector"          (constant-folder u64vect         ))
(def-simp "u64vector-length"   (constant-folder u64vect-length
                                                u64vect?))
(def-simp "u64vector-ref"      (constant-folder-ref
                                u64vect-ref
                                u64vect-length
                                u64vect?))

(def-simp "f32vector?"         (constant-folder f32vect? ))
;(def-simp "make-f32vector"     (constant-folder make-f32vect    ))
;(def-simp "f32vector"          (constant-folder f32vect         ))
(def-simp "f32vector-length"   (constant-folder f32vect-length
                                                f32vect?))
(def-simp "f32vector-ref"      (constant-folder-ref
                                f32vect-ref
                                f32vect-length
                                f32vect?))

(def-simp "f64vector?"         (constant-folder f64vect? ))
;(def-simp "make-f64vector"     (constant-folder make-f64vect    ))
;(def-simp "f64vector"          (constant-folder f64vect         ))
(def-simp "f64vector-length"   (constant-folder f64vect-length
                                                f64vect?))
(def-simp "f64vector-ref"      (constant-folder-ref
                                f64vect-ref
                                f64vect-length
                                f64vect?))

(def-simp "procedure?"       (constant-folder proc-obj?      ))
;(def-simp "apply"            (constant-folder apply          ))
(def-simp "input-port?"      (constant-folder input-port?    ))
(def-simp "output-port?"     (constant-folder output-port?   ))
(def-simp "eof-object?"      (constant-folder end-of-file-object?))
;(def-simp "list-tail"        (constant-folder list-tail      ))
;(def-simp "string->list"     (constant-folder string->list   string?))
;(def-simp "list->string"     (constant-folder list->string   ))
;(def-simp "string-copy"      (constant-folder string-copy    string?))
;(def-simp "vector->list"     (constant-folder vector->list
;;                                              vector-object?))
;(def-simp "list->vector"     (constant-folder list->vector   list?))
(def-simp "keyword?"         (constant-folder keyword-object?))
(def-simp "keyword->string"  (constant-folder keyword-object->string))
(def-simp "string->keyword"  (constant-folder string->keyword-object))
(def-simp "void"             (constant-folder (lambda () void-object)))
(def-simp "eof-object"       (constant-folder (lambda () end-of-file-object)))

(def-simp "fixnum?"          (constant-folder fix32?         not-bigfix?))
(def-simp "flonum?"          (constant-folder flo?           ))
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure typers

(define (setup-prim-typers targ)

;; TODO: remove dependencies to C back-end

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (type-infer-set! name infer)
  (let ((proc (get-prim-info name)))
    (if proc
        (proc-obj-type-infer-set!
         proc
         (lambda (tctx args)
           (or (and infer
                    (infer tctx args))
               (proc-type->type tctx (proc-obj-type proc)))))))) ;; fallback

(define (def-type-infer name infer)
  (type-infer-set! name infer)
  (type-infer-set! (string-append "##" name) infer))

(define (type-narrow-set! name narrow)
  (let ((proc (get-prim-info name)))
    (if proc
        (let ((type-narrow
               (lambda (tctx args)
                 (or (and narrow
                          (narrow tctx args))
                     (cons args args))))) ;; fallback
          (proc-obj-type-narrow-set! proc type-narrow)
          (if (not (proc-obj-type-infer proc))
              (proc-obj-type-infer-set!
               proc
               (lambda (tctx args)
                 (let ((x (type-narrow tctx args)))
                   (cond ((not (car x))
                          (make-type-singleton #f))
                         ((not (cdr x))
                          (make-type-singleton #t))
                         (else
                          type-boolean))))))))))

(define (def-type-narrow name narrow)
  (type-narrow-set! name narrow)
  (type-narrow-set! (string-append "##" name) narrow))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (def-fold name folder)
  (def-type-infer name folder))

(define (convert-result val)
  val) ;; TODO: handle false-object, etc

(define (constant-folder op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (tctx arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (make-type-singleton result)))
   type-patterns))

(define (constant-folder-gen op . type-patterns)
  (apply constant-folder (cons op type-patterns)))

(define (constant-folder-fix op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (tctx arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (and (or (not (number? result))
                (targ-fixnum32? result)) ;; TODO: remove dependency on C back-end
            (make-type-singleton result))))
   type-patterns))

(define (constant-folder-flo op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (tctx arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (and (or (not (number? result))
                (targ-flonum? result)) ;; TODO: remove dependency on C back-end
            (make-type-singleton result))))
   type-patterns))

(define (constant-folder-arg-type-check folder type-patterns)
  (let ((type-patterns
         (if (null? type-patterns)
             (list (lambda (val) #t))
             type-patterns)))
    (lambda (tctx args)

      (define (match? args type-pattern)
        (if (pair? args)
            (cond ((pair? type-pattern)
                   (and ((car type-pattern) (car args))
                        (match? (cdr args) (cdr type-pattern))))
                  ((null? type-pattern)
                   #f)
                  (else
                   (and (type-pattern (car args))
                        (match? (cdr args) type-pattern))))
            (not (pair? type-pattern))))

      (and (every? type-singleton? args) ;; are all arguments known values?
           (let ((arg-vals (map type-singleton-val args)))
             (let loop ((type-pats type-patterns))
               (and (pair? type-pats)
                    (if (match? arg-vals (car type-pats))
                        (folder tctx arg-vals)
                        (loop (cdr type-pats))))))))))

(define (constant-folder-ref op get-length vect-type?)
  (lambda (tctx args)
    (and (every? type-singleton? args) ;; are all arguments known values?
         (let* ((arg-vals (map type-singleton-val args))
                (vect (car arg-vals))
                (index (cadr arg-vals)))
           (and (vect-type? vect)
                (integer? index)
                (exact? index)
                (not (< index 0))
                (< index (get-length vect))
                (let ((result (op vect index)))
                  (make-type-singleton result)))))))

(define (num? obj) (targ-number? obj)) ;; TODO: remove dependency on C back-end
(define (nz-num? obj) (targ-nonzero-number? obj)) ;; TODO: remove dependency on C back-end

(define (int? obj) (targ-integer? obj)) ;; TODO: remove dependency on C back-end
(define (nz-int? obj) (targ-nonzero-integer? obj)) ;; TODO: remove dependency on C back-end

(define (flo? obj) (targ-flonum? obj)) ;; TODO: remove dependency on C back-end
(define (nz-flo? obj) (targ-nonzero-flonum? obj)) ;; TODO: remove dependency on C back-end
(define (int-flo? obj) (and (targ-flonum? obj) (targ-integer? obj))) ;; TODO: remove dependency on C back-end
(define (fin-flo? obj) (and (targ-flonum? obj) (targ-finite? obj))) ;; TODO: remove dependency on C back-end

(define (fix32? obj) (targ-fixnum32? obj)) ;; TODO: remove dependency on C back-end
(define (nz-fix32? obj) (targ-nonzero-fixnum32? obj)) ;; TODO: remove dependency on C back-end

(define (fin-real? obj) (and (real? obj) (targ-finite? obj))) ;; TODO: remove dependency on C back-end

(define (not-bigfix? obj)
  (not (and (targ-fixnum64? obj) (not (targ-fixnum32? obj))))) ;; TODO: remove dependency on C back-end

(define (mem-alloc? obj)
  (let ((type (targ-obj-type obj))) ;; TODO: remove dependency on C back-end
    (or (eq? type 'pair)
        (and (eq? type 'subtyped)
             (not-bigfix? obj)))))

(define (any obj) #t)

(define (alist? obj) (and (list? obj) (every? pair? obj)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;(def-fold "not"              (constant-folder false-object?  ))
;;(def-fold "boolean?"         (constant-folder (lambda (obj)
;;                                                      (or (false-object? obj)
;;                                                          (eq? obj #t)))))
(def-fold "##false-or-null?" (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (null? obj)))))
(def-fold "##false-or-void?" (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (void-object? obj)))))
(def-fold "eqv?"             (constant-folder eqv?           ))
(def-fold "eq?"              (constant-folder eq?            ))
(def-fold "equal?"           (constant-folder equal?         ))
(def-fold "##mem-allocated?" (constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj) ;; TODO: remove dependency on C back-end
                                                        ((subtyped pair) #t)
                                                        (else            #f)))
                                                    not-bigfix?))
(def-fold "##subtyped?"      (constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj) ;; TODO: remove dependency on C back-end
                                                        ((subtyped) #t)
                                                        (else       #f)))
                                                    not-bigfix?))
(def-fold "##subtype"        (constant-folder targ-obj-subtype-integer ;; TODO: remove dependency on C back-end
                                                    mem-alloc?))
;;(def-fold "pair?"            (constant-folder pair?          ))
;(def-fold "cons"             (constant-folder cons           ))  ;; this would not preserve mutability and eq?-ness
(def-fold "car"              (constant-folder car            pair?))
(def-fold "cdr"              (constant-folder cdr            pair?))
;(def-fold "caar"             (constant-folder caar           ))
;(def-fold "cadr"             (constant-folder cadr           ))
;(def-fold "cdar"             (constant-folder cdar           ))
;(def-fold "cddr"             (constant-folder cddr           ))
;(def-fold "caaar"            (constant-folder caaar          ))
;(def-fold "caadr"            (constant-folder caadr          ))
;(def-fold "cadar"            (constant-folder cadar          ))
;(def-fold "caddr"            (constant-folder caddr          ))
;(def-fold "cdaar"            (constant-folder cdaar          ))
;(def-fold "cdadr"            (constant-folder cdadr          ))
;(def-fold "cddar"            (constant-folder cddar          ))
;(def-fold "cdddr"            (constant-folder cdddr          ))
;(def-fold "caaaar"           (constant-folder caaaar         ))
;(def-fold "caaadr"           (constant-folder caaadr         ))
;(def-fold "caadar"           (constant-folder caadar         ))
;(def-fold "caaddr"           (constant-folder caaddr         ))
;(def-fold "cadaar"           (constant-folder cadaar         ))
;(def-fold "cadadr"           (constant-folder cadadr         ))
;(def-fold "caddar"           (constant-folder caddar         ))
;(def-fold "cadddr"           (constant-folder cadddr         ))
;(def-fold "cdaaar"           (constant-folder cdaaar         ))
;(def-fold "cdaadr"           (constant-folder cdaadr         ))
;(def-fold "cdadar"           (constant-folder cdadar         ))
;(def-fold "cdaddr"           (constant-folder cdaddr         ))
;(def-fold "cddaar"           (constant-folder cddaar         ))
;(def-fold "cddadr"           (constant-folder cddadr         ))
;(def-fold "cdddar"           (constant-folder cdddar         ))
;(def-fold "cddddr"           (constant-folder cddddr         ))
(def-fold "null?"            (constant-folder null?          ))
(def-fold "list?"            (constant-folder list?          ))
;(def-fold "list"             (constant-folder list           ))  ;; this would not preserve mutability and eq?-ness
(def-fold "length"           (constant-folder length         list?))
;(def-fold "append"           (constant-folder append         list?))
;(def-fold "reverse"          (constant-folder reverse        list?))
(def-fold "list-ref"         (constant-folder-ref
                               list-ref
                               length
                               list?))
(def-fold "memq"             (constant-folder memq
                                                    (list any list?)))
(def-fold "memv"             (constant-folder memv
                                                    (list any list?)))
(def-fold "member"           (constant-folder member
                                                    (list any list?)))
(def-fold "assq"             (constant-folder assq
                                                    (list any alist?)))
(def-fold "assv"             (constant-folder assv
                                                    (list any alist?)))
(def-fold "assoc"            (constant-folder assoc
                                                    (list any alist?)))
;;(def-fold "symbol?"          (constant-folder symbol-object? ))
(def-fold "symbol->string"   (constant-folder symbol->string
                                              symbol-object?))
(def-fold "string->symbol"   (constant-folder string->symbol ))
(def-fold "number?"          (constant-folder number?        ))
(def-fold "complex?"         (constant-folder complex?       ))
(def-fold "real?"            (constant-folder real?          ))
(def-fold "rational?"        (constant-folder rational?      ))
(def-fold "integer?"         (constant-folder integer?       ))
(def-fold "exact?"           (constant-folder exact?         num?))
(def-fold "inexact?"         (constant-folder inexact?       num?))
(def-fold "exact-integer?"   (constant-folder (lambda (x) (and (integer? x) (exact? x)))))
(def-fold "="                (constant-folder =              num?))
;;(def-fold "fx="              (constant-folder =              fix32?))
;;(def-fold "fl="              (constant-folder =              flo?))
(def-fold "<"                (constant-folder <              real?))
;;(def-fold "fx<"              (constant-folder <              fix32?))
;;(def-fold "fl<"              (constant-folder <              flo?))
(def-fold ">"                (constant-folder >              real?))
;;(def-fold "fx>"              (constant-folder >              fix32?))
;;(def-fold "fl>"              (constant-folder >              flo?))
(def-fold "<="               (constant-folder <=             real?))
;;(def-fold "fx<="             (constant-folder <=             fix32?))
;;(def-fold "fl<="             (constant-folder <=             flo?))
(def-fold ">="               (constant-folder >=             real?))
;;(def-fold "fx>="             (constant-folder >=             fix32?))
;;(def-fold "fl>="             (constant-folder >=             flo?))
(def-fold "zero?"            (constant-folder zero?          num?))
(def-fold "fxzero?"          (constant-folder zero?          fix32?))
(def-fold "flzero?"          (constant-folder zero?          flo?))
(def-fold "positive?"        (constant-folder positive?     real?))
(def-fold "fxpositive?"      (constant-folder positive?     fix32?))
(def-fold "flpositive?"      (constant-folder positive?     flo?))
(def-fold "negative?"        (constant-folder negative?     real?))
(def-fold "fxnegative?"      (constant-folder negative?     fix32?))
(def-fold "flnegative?"      (constant-folder negative?     flo?))
(def-fold "odd?"             (constant-folder odd?           int?))
(def-fold "fxodd?"           (constant-folder odd?           fix32?))
(def-fold "flodd?"           (constant-folder odd?           int-flo?))
(def-fold "even?"            (constant-folder even?          int?))
(def-fold "fxeven?"          (constant-folder even?          fix32?))
(def-fold "fleven?"          (constant-folder even?          int-flo?))
(def-fold "max"              (constant-folder-gen max        real?))
(def-fold "fxmax"            (constant-folder-fix max        fix32?))
(def-fold "flmax"            (constant-folder-flo max        flo?))
(def-fold "min"              (constant-folder-gen min        real?))
(def-fold "fxmin"            (constant-folder-fix min        fix32?))
(def-fold "flmin"            (constant-folder-flo min        flo?))
(def-fold "+"                (constant-folder-gen +          num?))
;;(def-fold "fxwrap+"          (constant-folder-fix +          fix32?))
;;(def-fold "fx+"              (constant-folder-fix +          fix32?))
;;(def-fold "fx+?"             (constant-folder-fix +          fix32?))
;;(def-fold "fl+"              (constant-folder-flo +          flo?));;;;;;;;;;must return 0.0 when 0 args
(def-fold "*"                (constant-folder-gen *          num?))
;;(def-fold "fxwrap*"          (constant-folder-fix *          fix32?))
;;(def-fold "fx*"              (constant-folder-fix *          fix32?))
;;(def-fold "fx*?"             (constant-folder-fix *          fix32?))
;;(def-fold "fl*"              (constant-folder-flo *          flo?));;;;;;;;;;must return 1.0 when 0 args
(def-fold "-"                (constant-folder-gen -          num?))
;;(def-fold "fxwrap-"          (constant-folder-fix -          fix32?))
;;(def-fold "fx-"              (constant-folder-fix -          fix32?))
;;(def-fold "fx-?"             (constant-folder-fix -          fix32?))
;;(def-fold "fl-"              (constant-folder-flo -          flo?))
(def-fold "/"                (constant-folder-gen /
                                                  (list nz-num?)
                                                  (cons num?
                                                        (cons nz-num?
                                                              nz-num?))))
(def-fold "fl/"              (constant-folder-flo /          flo?))
(def-fold "abs"              (constant-folder-gen abs        num?))
(def-fold "fxwrapabs"        (constant-folder-fix abs        fix32?))
(def-fold "fxabs"            (constant-folder-fix abs        fix32?))
(def-fold "fxabs?"           (constant-folder-fix abs        fix32?))
(def-fold "flabs"            (constant-folder-flo abs        flo?))
(def-fold "square"           (constant-folder-gen square     num?))
(def-fold "fxwrapsquare"     (constant-folder-fix square     fix32?))
(def-fold "fxsquare"         (constant-folder-fix square     fix32?))
(def-fold "fxsquare?"        (constant-folder-fix square     fix32?))
(def-fold "flsquare"         (constant-folder-flo square     flo?))
(def-fold "quotient"         (constant-folder-gen quotient
                                                  (list int? nz-int?)))
(def-fold "fxwrapquotient"   (constant-folder-fix quotient
                                                  (list fix32? nz-fix32?)))
(def-fold "fxquotient"       (constant-folder-fix quotient
                                                  (list fix32? nz-fix32?)))
(def-fold "remainder"        (constant-folder-gen remainder
                                                  (list int? nz-int?)))
(def-fold "fxremainder"      (constant-folder-fix remainder
                                                  (list fix32? nz-fix32?)))
(def-fold "modulo"           (constant-folder-gen modulo
                                                  (list int? nz-int?)))
(def-fold "fxmodulo"         (constant-folder-fix modulo
                                                  (list fix32? nz-fix32?)))
(def-fold "gcd"              (constant-folder-gen gcd        int?))
(def-fold "lcm"              (constant-folder-gen lcm        int?))
(def-fold "numerator"        (constant-folder-gen numerator  rational?))
(def-fold "denominator"      (constant-folder-gen denominator rational?))
(def-fold "floor"            (constant-folder-gen floor      fin-real?))
(def-fold "flfloor"          (constant-folder-flo floor      fin-flo?))
(def-fold "ceiling"          (constant-folder-gen ceiling    fin-real?))
(def-fold "flceiling"        (constant-folder-flo ceiling    fin-flo?))
(def-fold "truncate"         (constant-folder-gen truncate   fin-real?))
(def-fold "fltruncate"       (constant-folder-flo truncate   fin-flo?))
(def-fold "round"            (constant-folder-gen round      fin-real?))
(def-fold "flround"          (constant-folder-flo round      fin-flo?))
(def-fold "rationalize"      (constant-folder-gen rationalize real?))
(def-fold "exp"              (constant-folder-gen exp        num?))
(def-fold "flexp"            (constant-folder-flo exp        flo?))
(def-fold "log"              (constant-folder-gen log        nz-num?))
(def-fold "fllog"            (constant-folder-flo log        nz-flo?))
(def-fold "sin"              (constant-folder-gen sin        num?))
(def-fold "flsin"            (constant-folder-flo sin        flo?))
(def-fold "cos"              (constant-folder-gen cos        num?))
(def-fold "flcos"            (constant-folder-flo cos        flo?))
(def-fold "tan"              (constant-folder-gen tan        num?))
(def-fold "fltan"            (constant-folder-flo tan        flo?))
(def-fold "asin"             (constant-folder-gen asin       num?))
(def-fold "flasin"           (constant-folder-flo asin       flo?))
(def-fold "acos"             (constant-folder-gen acos       num?))
(def-fold "flacos"           (constant-folder-flo acos       flo?))
(def-fold "atan"             (constant-folder-gen atan       num?))
(def-fold "flatan"           (constant-folder-flo atan       flo?))
(def-fold "flhypot"          (constant-folder-flo flhypot    flo?))
(def-fold "expt"             (constant-folder-gen expt       num?))
(def-fold "flexpt"           (constant-folder-flo expt       flo?))
(def-fold "sqrt"             (constant-folder-gen sqrt       num?))
(def-fold "flsqrt"           (constant-folder-flo sqrt       flo?))
(def-fold "sinh"             (constant-folder-gen sinh       num?))
(def-fold "flsinh"           (constant-folder-flo sinh       flo?))
(def-fold "cosh"             (constant-folder-gen cosh       num?))
(def-fold "flcosh"           (constant-folder-flo cosh       flo?))
(def-fold "tanh"             (constant-folder-gen tanh       num?))
(def-fold "fltanh"           (constant-folder-flo tanh       flo?))
(def-fold "asinh"            (constant-folder-gen asinh      num?))
(def-fold "flasinh"          (constant-folder-flo asinh      flo?))
(def-fold "acosh"            (constant-folder-gen acosh      num?))
(def-fold "flacosh"          (constant-folder-flo acosh      flo?))
;; (def-fold "atanh"            (constant-folder-gen atanh      num?)) ;; TODO: arg must not be +1 or -1
(def-fold "flatanh"          (constant-folder-flo atanh      flo?))
(def-fold "##flonum->fixnum" (constant-folder-fix inexact->exact flo?))
(def-fold "fixnum->flonum"   (constant-folder-flo exact->inexact fix32?))

(def-fold "fxand"            (constant-folder-fix fxand   fix32?))
(def-fold "fxandc1"          (constant-folder-fix fxandc1 fix32?))
(def-fold "fxandc2"          (constant-folder-fix fxandc2 fix32?))
(def-fold "fxeqv"            (constant-folder-fix fxeqv   fix32?))
(def-fold "fxior"            (constant-folder-fix fxior   fix32?))
(def-fold "fxnand"           (constant-folder-fix fxnand  fix32?))
(def-fold "fxnor"            (constant-folder-fix fxnor   fix32?))
(def-fold "fxnot"            (constant-folder-fix fxnot   fix32?))
(def-fold "fxorc1"           (constant-folder-fix fxorc1  fix32?))
(def-fold "fxorc2"           (constant-folder-fix fxorc2  fix32?))
(def-fold "fxxor"            (constant-folder-fix fxxor   fix32?))

(def-fold "bitwise-and"      (constant-folder-gen bitwise-and   int?))
(def-fold "bitwise-andc1"    (constant-folder-gen bitwise-andc1 int?))
(def-fold "bitwise-andc2"    (constant-folder-gen bitwise-andc2 int?))
(def-fold "bitwise-eqv"      (constant-folder-gen bitwise-eqv   int?))
(def-fold "bitwise-ior"      (constant-folder-gen bitwise-ior   int?))
(def-fold "bitwise-nand"     (constant-folder-gen bitwise-nand  int?))
(def-fold "bitwise-nor"      (constant-folder-gen bitwise-nor   int?))
(def-fold "bitwise-not"      (constant-folder-gen bitwise-not   int?))
(def-fold "bitwise-orc1"     (constant-folder-gen bitwise-orc1  int?))
(def-fold "bitwise-orc2"     (constant-folder-gen bitwise-orc2  int?))
(def-fold "bitwise-xor"      (constant-folder-gen bitwise-xor   int?))

(def-fold "make-rectangular" (constant-folder-gen make-rectangular real?))
(def-fold "make-polar"       (constant-folder-gen make-polar     real?))
(def-fold "real-part"        (constant-folder-gen real-part      num?))
(def-fold "imag-part"        (constant-folder-gen imag-part      num?))
(def-fold "magnitude"        (constant-folder-gen magnitude      num?))
(def-fold "angle"            (constant-folder-gen angle          num?))
(def-fold "exact->inexact"   (constant-folder-gen exact->inexact num?))
(def-fold "inexact->exact"   (constant-folder-gen inexact->exact num?))
;(def-fold "number->string"   (constant-folder number->string num?))
(def-fold "string->number"   (constant-folder string->number string?))

;;(def-fold "char?"            (constant-folder char?          ))
(def-fold "char=?"           (constant-folder char=?         char?))
(def-fold "char<?"           (constant-folder char<?         char?))
(def-fold "char>?"           (constant-folder char>?         char?))
(def-fold "char<=?"          (constant-folder char<=?        char?))
(def-fold "char>=?"          (constant-folder char>=?        char?))
(def-fold "char-ci=?"        (constant-folder char-ci=?      char?))
(def-fold "char-ci<?"        (constant-folder char-ci<?      char?))
(def-fold "char-ci>?"        (constant-folder char-ci>?      char?))
(def-fold "char-ci<=?"       (constant-folder char-ci<=?     char?))
(def-fold "char-ci>=?"       (constant-folder char-ci>=?     char?))
(def-fold "char-alphabetic?" (constant-folder char-alphabetic? char?))
(def-fold "char-numeric?"    (constant-folder char-numeric?  char?))
(def-fold "char-whitespace?" (constant-folder char-whitespace? char?))
(def-fold "char-upper-case?" (constant-folder char-upper-case? char?))
(def-fold "char-lower-case?" (constant-folder char-lower-case? char?))
(def-fold "char->integer"    (constant-folder char->integer  char?))
;(def-fold "integer->char"    (constant-folder integer->char  ))
(def-fold "char-upcase"      (constant-folder char-upcase    char?))
(def-fold "char-downcase"    (constant-folder char-downcase  char?))

;;(def-fold "string?"          (constant-folder string?        ))
;(def-fold "make-string"      (constant-folder make-string    ))
;(def-fold "string"           (constant-folder string         char?))
(def-fold "string-length"    (constant-folder string-length  string?))
(def-fold "string-ref"       (constant-folder-ref
                              string-ref
                              string-length
                              string?))
(def-fold "string=?"         (constant-folder string=?       string?))
(def-fold "string<?"         (constant-folder string<?       string?))
(def-fold "string>?"         (constant-folder string>?       string?))
(def-fold "string<=?"        (constant-folder string<=?      string?))
(def-fold "string>=?"        (constant-folder string>=?      string?))
(def-fold "string-ci=?"      (constant-folder string-ci=?    string?))
(def-fold "string-ci<?"      (constant-folder string-ci<?    string?))
(def-fold "string-ci>?"      (constant-folder string-ci>?    string?))
(def-fold "string-ci<=?"     (constant-folder string-ci<=?   string?))
(def-fold "string-ci>=?"     (constant-folder string-ci>=?   string?))
;(def-fold "substring"        (constant-folder substring      ))
;(def-fold "string-append"    (constant-folder string-append  string?))

;;(def-fold "vector?"          (constant-folder vector-object? ))
;(def-fold "make-vector"      (constant-folder make-vector    ))
;(def-fold "vector"           (constant-folder vector         ))
(def-fold "vector-length"    (constant-folder vector-length
                                              vector-object?))
(def-fold "vector-ref"       (constant-folder-ref
                              vector-ref
                              vector-length
                              vector-object?))

(def-fold "s8vector?"        (constant-folder s8vect? ))
;(def-fold "make-s8vector"    (constant-folder make-s8vect    ))
;(def-fold "s8vector"         (constant-folder s8vect         ))
(def-fold "s8vector-length"  (constant-folder s8vect-length
                                              s8vect?))
(def-fold "s8vector-ref"     (constant-folder-ref
                              s8vect-ref
                              s8vect-length
                              s8vect?))

(def-fold "u8vector?"        (constant-folder u8vect? ))
;(def-fold "make-u8vector"    (constant-folder make-u8vect    ))
;(def-fold "u8vector"         (constant-folder u8vect         ))
(def-fold "u8vector-length"  (constant-folder u8vect-length
                                              u8vect?))
(def-fold "u8vector-ref"     (constant-folder-ref
                              u8vect-ref
                              u8vect-length
                              u8vect?))

(def-fold "s16vector?"       (constant-folder s16vect? ))
;(def-fold "make-s16vector"   (constant-folder make-s16vect    ))
;(def-fold "s16vector"        (constant-folder s16vect         ))
(def-fold "s16vector-length" (constant-folder s16vect-length
                                              s16vect?))
(def-fold "s16vector-ref"    (constant-folder-ref
                              s16vect-ref
                              s16vect-length
                              s16vect?))

(def-fold "u16vector?"       (constant-folder u16vect? ))
;(def-fold "make-u16vector"   (constant-folder make-u16vect    ))
;(def-fold "u16vector"        (constant-folder u16vect         ))
(def-fold "u16vector-length" (constant-folder u16vect-length
                                              u16vect?))
(def-fold "u16vector-ref"    (constant-folder-ref
                              u16vect-ref
                              u16vect-length
                              u16vect?))

(def-fold "s32vector?"         (constant-folder s32vect? ))
;(def-fold "make-s32vector"     (constant-folder make-s32vect    ))
;(def-fold "s32vector"          (constant-folder s32vect         ))
(def-fold "s32vector-length"   (constant-folder s32vect-length
                                                s32vect?))
(def-fold "s32vector-ref"      (constant-folder-ref
                                s32vect-ref
                                s32vect-length
                                s32vect?))

(def-fold "u32vector?"         (constant-folder u32vect? ))
;(def-fold "make-u32vector"     (constant-folder make-u32vect    ))
;(def-fold "u32vector"          (constant-folder u32vect         ))
(def-fold "u32vector-length"   (constant-folder u32vect-length
                                                u32vect?))
(def-fold "u32vector-ref"      (constant-folder-ref
                                u32vect-ref
                                u32vect-length
                                u32vect?))

(def-fold "s64vector?"         (constant-folder s64vect? ))
;(def-fold "make-s64vector"     (constant-folder make-s64vect    ))
;(def-fold "s64vector"          (constant-folder s64vect         ))
(def-fold "s64vector-length"   (constant-folder s64vect-length
                                                s64vect?))
(def-fold "s64vector-ref"      (constant-folder-ref
                                s64vect-ref
                                s64vect-length
                                s64vect?))

(def-fold "u64vector?"         (constant-folder u64vect? ))
;(def-fold "make-u64vector"     (constant-folder make-u64vect    ))
;(def-fold "u64vector"          (constant-folder u64vect         ))
(def-fold "u64vector-length"   (constant-folder u64vect-length
                                                u64vect?))
(def-fold "u64vector-ref"      (constant-folder-ref
                                u64vect-ref
                                u64vect-length
                                u64vect?))

(def-fold "f32vector?"         (constant-folder f32vect? ))
;(def-fold "make-f32vector"     (constant-folder make-f32vect    ))
;(def-fold "f32vector"          (constant-folder f32vect         ))
(def-fold "f32vector-length"   (constant-folder f32vect-length
                                                f32vect?))
(def-fold "f32vector-ref"      (constant-folder-ref
                                f32vect-ref
                                f32vect-length
                                f32vect?))

(def-fold "f64vector?"         (constant-folder f64vect? ))
;(def-fold "make-f64vector"     (constant-folder make-f64vect    ))
;(def-fold "f64vector"          (constant-folder f64vect         ))
(def-fold "f64vector-length"   (constant-folder f64vect-length
                                                f64vect?))
(def-fold "f64vector-ref"      (constant-folder-ref
                                f64vect-ref
                                f64vect-length
                                f64vect?))

;;(def-fold "procedure?"       (constant-folder proc-obj?      ))
;(def-fold "apply"            (constant-folder apply          ))
(def-fold "input-port?"      (constant-folder input-port?    ))
(def-fold "output-port?"     (constant-folder output-port?   ))
(def-fold "eof-object?"      (constant-folder end-of-file-object?))
;(def-fold "list-tail"        (constant-folder list-tail      ))
;(def-fold "string->list"     (constant-folder string->list   string?))
;(def-fold "list->string"     (constant-folder list->string   ))
;(def-fold "string-copy"      (constant-folder string-copy    string?))
;(def-fold "vector->list"     (constant-folder vector->list
;;                                              vector-object?))
;(def-fold "list->vector"     (constant-folder list->vector   list?))
;;(def-fold "keyword?"         (constant-folder keyword-object?))
(def-fold "keyword->string"  (constant-folder keyword-object->string))
(def-fold "string->keyword"  (constant-folder string->keyword-object))
(def-fold "void"             (constant-folder (lambda () void-object)))
(def-fold "eof-object"       (constant-folder (lambda () end-of-file-object)))

;;(def-fold "fixnum?"          (constant-folder fix32?         not-bigfix?))
;;(def-fold "flonum?"          (constant-folder flo?           ))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(let ()

(define (infer-fx+ overflow-normalize)
  (type-infer-fold
   (lambda (tctx)
     (make-type-singleton 0))
   (lambda (tctx type)
     type)
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx+ type1 type2)))))

(define (infer-fx- overflow-normalize)
  (type-infer-fold
   #f
   (lambda (tctx type)
     (overflow-normalize
      tctx
      (let ((zero (make-type-singleton 0)))
        (overflow-normalize
         tctx
         (type-infer-fixnum2 tctx type-infer-common-fx- zero type)))))
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx- type1 type2)))))

(define (infer-fx* overflow-normalize)
  (type-infer-fold
   (lambda (tctx)
     (make-type-singleton 1))
   (lambda (tctx type)
     type)
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx* type1 type2)))))

(define (infer-fxquotient overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxquotient type1 type2)))))

(define (infer-fxremainder overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxremainder type1 type2)))))

(define (infer-fxmodulo overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxmodulo type1 type2)))))

(def-type-infer "fx+?"    (infer-fx+ type-fixnum-overflow-normalize-false))
(def-type-infer "fx+"     (infer-fx+ type-fixnum-overflow-normalize-clamp))
(def-type-infer "fxwrap+" (infer-fx+ type-fixnum-overflow-normalize-wrap))

(def-type-infer "fx-?"    (infer-fx- type-fixnum-overflow-normalize-false))
(def-type-infer "fx-"     (infer-fx- type-fixnum-overflow-normalize-clamp))
(def-type-infer "fxwrap-" (infer-fx- type-fixnum-overflow-normalize-wrap))

(def-type-infer "fx*?"    (infer-fx* type-fixnum-overflow-normalize-false))
(def-type-infer "fx*"     (infer-fx* type-fixnum-overflow-normalize-clamp))
(def-type-infer "fxwrap*" (infer-fx* type-fixnum-overflow-normalize-wrap))

(def-type-infer "fxquotient"     (infer-fxquotient  type-fixnum-overflow-normalize-clamp))
(def-type-infer "fxwrapquotient" (infer-fxquotient  type-fixnum-overflow-normalize-wrap))
;;(def-type-infer "fxremainder"    (infer-fxremainder type-fixnum-overflow-normalize-clamp))
;;(def-type-infer "fxmodulo"       (infer-fxmodulo    type-fixnum-overflow-normalize-clamp))

(def-type-infer "fxior"   (infer-fxior))
(def-type-infer "fxxor"   (infer-fxxor))
(def-type-infer "fxand"   (infer-fxand))
(def-type-infer "fxandc1" (infer-fxandc1))
(def-type-infer "fxandc2" (infer-fxandc2))
(def-type-infer "fxorc1"  (infer-fxorc1))
(def-type-infer "fxorc2"  (infer-fxorc2))
(def-type-infer "fxnand"  (infer-fxnand))
(def-type-infer "fxnor"   (infer-fxnor))
(def-type-infer "fxeqv"   (infer-fxeqv))
(def-type-infer "fxnot"   (infer-fxnot))

(def-type-narrow "fx="  (type-narrow-fold type-narrow-fx=))
(def-type-narrow "fx<"  (type-narrow-fold type-narrow-fx<))
(def-type-narrow "fx<=" (type-narrow-fold type-narrow-fx<=))
(def-type-narrow "fx>"  (type-narrow-fold type-narrow-fx>))
(def-type-narrow "fx>=" (type-narrow-fold type-narrow-fx>=))

(def-type-infer "fl+"  (lambda (tctx args) type-flonum))
(def-type-infer "fl-"  (lambda (tctx args) type-flonum))
(def-type-infer "fl*"  (lambda (tctx args) type-flonum))

(def-type-narrow "fl="  #f)
(def-type-narrow "fl<"  (type-narrow-fold type-narrow-fl<))
(def-type-narrow "fl<=" (type-narrow-fold type-narrow-fl<=))
(def-type-narrow "fl>"  (type-narrow-fold type-narrow-fl>))
(def-type-narrow "fl>=" (type-narrow-fold type-narrow-fl>=))

(def-type-infer "identity"
  (lambda (tctx args)
    (let ((arg (car args)))
      arg)))

(def-type-narrow "identity"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-invert (type-narrow-false tctx arg)))))

(def-type-narrow "not"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-false tctx arg))))

(def-type-narrow "fixnum?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-fixnum arg))))

(type-narrow-set!
 "##bignum?"
 (lambda (tctx args)
   (let ((arg (car args)))
     (type-narrow-type-test tctx type-bignum arg))))

(type-narrow-set!
 "##ratnum?"
 (lambda (tctx args)
   (let ((arg (car args)))
     (type-narrow-type-test tctx type-ratnum arg))))

(def-type-narrow "flonum?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-flonum arg))))

(type-narrow-set!
 "##cpxnum?"
 (lambda (tctx args)
   (let ((arg (car args)))
     (type-narrow-type-test tctx type-cpxnum arg))))

(def-type-narrow "char?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-char arg))))

(def-type-narrow "symbol?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-symbol arg))))

(def-type-narrow "keyword?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-keyword arg))))

(def-type-narrow "string?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-string arg))))

(def-type-narrow "vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-vector arg))))

(def-type-narrow "u8vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-u8vector arg))))

(def-type-narrow "s8vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-s8vector arg))))

(def-type-narrow "u16vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-u16vector arg))))

(def-type-narrow "s16vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-s16vector arg))))

(def-type-narrow "u32vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-u32vector arg))))

(def-type-narrow "s32vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-s32vector arg))))

(def-type-narrow "u64vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-u64vector arg))))

(def-type-narrow "s64vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-s64vector arg))))

(def-type-narrow "f32vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-f32vector arg))))

(def-type-narrow "f64vector?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-f64vector arg))))

(def-type-narrow "pair?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-pair arg))))

(def-type-narrow "procedure?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-procedure arg))))

(def-type-narrow "boolean?"
  (lambda (tctx args)
    (let ((arg (car args)))
      (type-narrow-type-test tctx type-boolean arg))))

(def-type-infer "box" #f)

(def-type-infer "+"
  (lambda (tctx args)
    (case (length args)
      ((0)
       (make-type-singleton 0))
      ((1)
       (car args))
      (else
       (let loop ((args (cdr args)) (accum (car args)))
         (if (pair? args)
             (loop (cdr args)
                   (let ((arg (car args)))
                     (cond ((type-eqv? accum (make-type-singleton 0))
                            arg)
                           ((type-eqv? arg (make-type-singleton 0))
                            accum)
                           ((and (type-included? tctx accum type-fixnum)
                                 (type-included? tctx arg type-fixnum))
                            (type-fixnum-overflow-normalize-bignum
                             tctx
                             (type-infer-fixnum2 tctx type-infer-common-fx+ accum arg)))
                           ((and (type-included? tctx accum type-flonum)
                                 (type-included? tctx arg type-flonum))
                            type-flonum)
                           ((and (type-included? tctx accum type-exact-integer)
                                 (type-included? tctx arg type-exact-integer))
                            type-exact-integer)
                           ((and (type-included? tctx accum type-exact-rational)
                                 (type-included? tctx arg type-exact-rational))
                            type-exact-rational)
                           ((and (type-included? tctx accum type-real)
                                 (type-included? tctx arg type-real))
                            type-exact-rational)
                           (else
                            type-number))))
             accum))))))

(def-type-infer "-"
  (lambda (tctx args)
    (let ((args
           (if (= (length args) 1)
               (cons (make-type-singleton 0) args)
               args)))
       (let loop ((args (cdr args)) (accum (car args)))
         (if (pair? args)
             (loop (cdr args)
                   (let ((arg (car args)))
                     (cond ((type-eqv? arg (make-type-singleton 0))
                            accum)
                           ((and (type-included? tctx accum type-fixnum)
                                 (type-included? tctx arg type-fixnum))
                            (type-fixnum-overflow-normalize-bignum
                             tctx
                             (type-infer-fixnum2 tctx type-infer-common-fx+ accum arg)))
                           ((and (type-included? tctx accum type-flonum)
                                 (type-included? tctx arg type-flonum))
                            type-flonum)
                           ((and (type-included? tctx accum type-exact-integer)
                                 (type-included? tctx arg type-exact-integer))
                            type-exact-integer)
                           ((and (type-included? tctx accum type-exact-rational)
                                 (type-included? tctx arg type-exact-rational))
                            type-exact-rational)
                           ((and (type-included? tctx accum type-real)
                                 (type-included? tctx arg type-real))
                            type-exact-rational)
                           (else
                            type-number))))
             accum)))))

)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#;
(for-each
 (lambda (x)
   (let* ((name (car x))
          (proc (get-prim-info name)))
     (if proc
         (begin
           (if (not (proc-obj-type-infer proc))
               (type-infer-set! name #f))))))
 prim-procs)

#;
(let ()

(define (test-inference)

  (define tctx (make-tctx-test))

  (define infer-fl+ (proc-obj-type-infer (get-prim-info "fl+")))
  (define infer-fx+ (proc-obj-type-infer (get-prim-info "fx+")))
  (define infer-fx* (proc-obj-type-infer (get-prim-info "fx*")))
  (define infer-fx*? (proc-obj-type-infer (get-prim-info "##fx*?")))
  (define infer-dv (proc-obj-type-infer (get-prim-info "digit-value")))

#;
  (pp (infer-fx+ tctx
                 (list (make-type-singleton 2)
                       (make-type-singleton 1)))) ;; = (make-type-singleton 3)
#;
  (pp (infer-fx+ tctx
                 (list (make-type-fixnum -3 2)
                       (make-type-singleton 1)))) ;; = (make-type-fixnum -2 3)
#;
  (pp (infer-fx+ tctx
                 (list (make-type-fixnum -3 2)
                       (make-type-fixnum -3 2)))) ;; = (make-type-fixnum -6 4)

#;
  (pp (infer-fx+ tctx
                 (list (make-type-singleton 4)
                       (make-type-singleton 4))))
#;
  (pp (infer-fl+ tctx
                 (list (make-type-singleton 1.5)
                       (make-type-singleton 2.3))))
#;
  (pp (infer-fx* tctx
                 (list (make-type-fixnum 0 5)
                       (make-type-fixnum 0 5)))) ;; = (make-type-fixnum 0 '<=)
#;
  (pp (infer-fx*? tctx
                  (list (make-type-fixnum-bounded tctx 1 2)
                        (make-type-fixnum-bounded tctx -2 -2)))) ;; = (make-type-fixnum-or-false)
#;
  (pp (infer-dv tctx
                (list (make-type-singleton '#\5))))
#;
  (pp (infer-car tctx
                 (list (make-type-singleton '#(777)))))



#;
  (pp (type-narrow-fx< tctx
                       (make-type-fixnum 0 5)
                       (make-type-fixnum 1 3)))) ;; (((0 . 2) (1 . 3))
;;  .
;;  ((1 . 5) (1 . 3)))

(test-inference))


)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Type representation.

;;; The motley type representation represents a set of types (flonum,
;;; vector, pair, etc) using an integer bitset.  Moreover, for the
;;; fixnum type a lo..hi range of values is represented as follows:
;;;
;;; lo can be
;;;   an exact integer between smallest_min_fixnum+2 and smallest_max_fixnum-2
;;;   or '>= (value is >= largest_min_fixnum)
;;;   or '>  (value is >  largest_min_fixnum)
;;;   or #f  (no lower bound, i.e. value is >= minus infinity)
;;;
;;; hi can be
;;;   an exact integer between smallest_min_fixnum+2 and smallest_max_fixnum-2
;;;   or '<= (value is <= largest_max_fixnum)
;;;   or '<  (value is <  largest_max_fixnum)
;;;   or #f  (no upper bound, i.e. value is <= infinity)
;;;
;;; The #f case is not used in the normalized representation.  It is
;;; only used temporarily to indicate an overflow of the fixnum range.
;;; When the fixnum type is not in the set, lo = 0 and hi = -1.

(define (make-type-motley bitset lo hi) (vector bitset lo hi))
(define (type-motley? type)             (vector? type))
(define (type-motley-bitset type)       (vector-ref type 0))
(define (type-fixnum-lo type)           (vector-ref type 1))
(define (type-fixnum-hi type)           (vector-ref type 2))

(define type-false-bit              1) ;; (expt 2 0)   unique types first
(define type-true-bit               2) ;; (expt 2 1)
(define type-null-bit               4) ;; (expt 2 2)
(define type-void-bit               8) ;; (expt 2 3)
(define type-eof-bit               16) ;; (expt 2 4)
(define type-absent-bit            32) ;; (expt 2 5)

(define type-bignum-bit            64) ;; (expt 2 6)
(define type-ratnum-bit           128) ;; (expt 2 7)
(define type-flonum-bit           256) ;; (expt 2 8)
(define type-cpxnum-bit           512) ;; (expt 2 9)
(define type-char-bit            1024) ;; (expt 2 10)
(define type-symbol-bit          2048) ;; (expt 2 11)
(define type-keyword-bit         4096) ;; (expt 2 12)
(define type-string-bit          8192) ;; (expt 2 13)
(define type-vector-bit         16384) ;; (expt 2 14)
(define type-u8vector-bit       32768) ;; (expt 2 15)
(define type-s8vector-bit       65536) ;; (expt 2 16)
(define type-u16vector-bit     131072) ;; (expt 2 17)
(define type-s16vector-bit     262144) ;; (expt 2 18)
(define type-u32vector-bit     524288) ;; (expt 2 19)
(define type-s32vector-bit    1048576) ;; (expt 2 20)
(define type-u64vector-bit    2097152) ;; (expt 2 21)
(define type-s64vector-bit    4194304) ;; (expt 2 22)
(define type-f32vector-bit    8388608) ;; (expt 2 23)
(define type-f64vector-bit   16777216) ;; (expt 2 24)
(define type-pair-bit        33554432) ;; (expt 2 25)
(define type-procedure-bit   67108864) ;; (expt 2 26)
(define type-box-bit        134217728) ;; (expt 2 27)
(define type-promise-bit    268435456) ;; (expt 2 28)
(define type-other-bit     -536870912) ;; (- (expt 2 29))

(define all-motley-bits
  (list
    type-false-bit    
    type-true-bit     
    type-null-bit     
    type-void-bit     
    type-eof-bit      
    type-absent-bit   
    type-bignum-bit   
    type-ratnum-bit   
    type-flonum-bit   
    type-cpxnum-bit   
    type-char-bit     
    type-symbol-bit   
    type-keyword-bit  
    type-string-bit   
    type-vector-bit   
    type-u8vector-bit 
    type-s8vector-bit 
    type-u16vector-bit
    type-s16vector-bit
    type-u32vector-bit
    type-s32vector-bit
    type-u64vector-bit
    type-s64vector-bit
    type-f32vector-bit
    type-f64vector-bit
    type-pair-bit     
    type-procedure-bit
    type-box-bit      
    type-promise-bit  
    type-other-bit))

(define type-top-bitset -1) ;; sum of all type-XXX-bit
(define type-bot-bitset  0) ;; no bits on

(define (make-type-motley-non-fixnum bitset)
  (make-type-motley bitset 0 -1))

;;; top type (corresponds to the union of all values)

(define type-top
  (make-type-motley type-top-bitset '>= '<=)) ;; all types + entire fixnum range

(define (type-top? type)
  (and (type-motley? type)
       (eqv? (type-motley-bitset type) type-top-bitset)
       (eqv? (type-fixnum-lo type) '>=)
       (eqv? (type-fixnum-hi type) '<=)))

;;; bottom type (corresponds to no possible value)

(define type-bot
  (make-type-motley-non-fixnum type-bot-bitset)) ;; no types

(define (type-bot? type)
  (and (type-motley? type)
       (eqv? (type-motley-bitset type) type-bot-bitset)
       (eqv? (type-fixnum-lo type) 0)
       (eqv? (type-fixnum-hi type) -1)))

;;; fixnum type

(define (make-type-fixnum lo hi)
  (make-type-motley type-bot-bitset lo hi))

(define type-fixnum
  (make-type-fixnum '>= '<=))

(define (make-type-fixnum-or-false lo hi)
  (make-type-motley type-false-bit lo hi))

(define type-fixnum-or-false
  (make-type-fixnum-or-false '>= '<=))

(define (make-type-fixnum-bounded tctx lo hi)
  ;; lo is either an exact integer or '>= or '> or #f
  ;; hi is either an exact integer or '<= or '< or #f
  (make-type-fixnum
   (type-fixnum-bound-lo tctx lo)
   (type-fixnum-bound-hi tctx hi)))

(define (type-fixnum-bound-lo tctx lo)
  ;; lo is either an exact integer or '>= or '> or #f
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx)))
    (if (and (exact-integer? lo) (< lo min-fixnum))
        #f
        lo)))

(define (type-fixnum-bound-hi tctx hi)
  ;; hi is either an exact integer or '<= or '< or #f
  (let ((max-fixnum (tctx-smallest-max-fixnum tctx)))
    (if (and (exact-integer? hi) (> hi max-fixnum))
        #f
        hi)))

(define (type-motley-normalize tctx type)
  (let ((bitset (type-motley-bitset type))
        (lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))

    (define (make-type-motley-with-fixnum-range)
      (make-type-motley
       bitset
       (type-fixnum-normalize-lo tctx lo)
       (type-fixnum-normalize-hi tctx hi)))

    (if (and (exact-integer? lo)
             (exact-integer? hi))
        (cond ((> lo hi) ;; empty fixnum range?
               (if (= bitset type-bot-bitset)
                   type-bot
                   (or (make-type-singleton-from-bitset bitset)
                       (make-type-motley-non-fixnum bitset))))
              ((and (= bitset type-bot-bitset) (= lo hi)) ;; single value?
               (make-type-singleton lo))
              (else
               (make-type-motley-with-fixnum-range)))
        (make-type-motley-with-fixnum-range))))

(define (type-fixnum-normalize-lo tctx lo)
  ;; lo is either an exact integer or '>= or '> or #f
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (cond ((not (exact-integer? lo)) lo)
          ((<= lo min-fixnum)        '>=)
          ((= lo (+ min-fixnum 1))   '>)
          (else                      (min lo (- max-fixnum 2))))))

(define (type-fixnum-normalize-hi tctx hi)
  ;; hi is either an exact integer or '<= or '< or #f
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (cond ((not (exact-integer? hi)) hi)
          ((>= hi max-fixnum)        '<=)
          ((= hi (- max-fixnum 1))   '<)
          (else                      (max hi (+ min-fixnum 2))))))

(define (type-fixnum-overflow-normalize-clamp tctx type)
  (let* ((type (type-motley-force tctx type))
         (lo (type-fixnum-lo type))
         (hi (type-fixnum-hi type)))
    (type-motley-normalize
     tctx
     (make-type-fixnum-bounded tctx (or lo '>=) (or hi '<=)))))

(define (type-fixnum-overflow-normalize-wrap tctx type)
  (let* ((type (type-motley-force tctx type))
         (lo (type-fixnum-lo type))
         (hi (type-fixnum-hi type)))
    (if (or (not lo) (not hi))
        type-fixnum
        (type-motley-normalize tctx type))))

(define (type-fixnum-overflow-normalize-false tctx type)
  (let* ((type (type-motley-force tctx type))
         (lo (type-fixnum-lo type))
         (hi (type-fixnum-hi type)))
    (if (and lo hi)
        (type-motley-normalize tctx type)
        (make-type-fixnum-or-false
         (if lo
             (type-fixnum-normalize-lo tctx lo)
             '>=)
         (if hi
             (type-fixnum-normalize-hi tctx hi)
             '<=)))))

(define (type-fixnum-overflow-normalize-bignum tctx type)
  (let* ((type (type-motley-force tctx type))
         (lo (type-fixnum-lo type))
         (hi (type-fixnum-hi type)))
    (if (and lo hi)
        (type-motley-normalize tctx type)
        (type-union
         tctx
         (make-type-motley-non-fixnum type-bignum-bit)
         (make-type-fixnum
          (if lo
              (type-fixnum-normalize-lo tctx lo)
              '>=)
          (if hi
              (type-fixnum-normalize-hi tctx hi)
              '<=))
         #f))))

(define (type-fixnum-range tctx type)
  (let ((lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))
    (let ((lo (cond ((eq? lo '>=) (tctx-smallest-min-fixnum tctx))
                    ((eq? lo '>)  (+ (tctx-smallest-min-fixnum tctx) 1))
                    (else         lo)))
          (hi (cond ((eq? hi '<=) (tctx-smallest-max-fixnum tctx))
                    ((eq? hi '<)  (- (tctx-smallest-max-fixnum tctx) 1))
                    (else         hi))))
      (cons lo hi))))

(define (for-each-motley-bit tctx fun type #!optional fixnum-marker)
  (let ((range (type-fixnum-range tctx type))
        (bits (type-motley-bitset type)))
    (if (and fixnum-marker (<= (car range) (cdr range))) (fun fixnum-marker))
    (for-each
      (lambda (bit)
        (if (not (zero? (bitwise-and bit bits))) (fun bit)))
      all-motley-bits)))

;;; builtin types

(define type-bignum    (make-type-motley-non-fixnum type-bignum-bit))
(define type-ratnum    (make-type-motley-non-fixnum type-ratnum-bit))
(define type-flonum    (make-type-motley-non-fixnum type-flonum-bit))
(define type-cpxnum    (make-type-motley-non-fixnum type-cpxnum-bit))
(define type-motley-false  (make-type-motley-non-fixnum type-false-bit))
(define type-motley-true   (make-type-motley-non-fixnum type-true-bit))
(define type-motley-null   (make-type-motley-non-fixnum type-null-bit))
(define type-motley-void   (make-type-motley-non-fixnum type-void-bit))
(define type-motley-eof    (make-type-motley-non-fixnum type-eof-bit))
(define type-motley-absent (make-type-motley-non-fixnum type-absent-bit))
(define type-char      (make-type-motley-non-fixnum type-char-bit))
(define type-symbol    (make-type-motley-non-fixnum type-symbol-bit))
(define type-keyword   (make-type-motley-non-fixnum type-keyword-bit))
(define type-string    (make-type-motley-non-fixnum type-string-bit))
(define type-vector    (make-type-motley-non-fixnum type-vector-bit))
(define type-u8vector  (make-type-motley-non-fixnum type-u8vector-bit))
(define type-s8vector  (make-type-motley-non-fixnum type-s8vector-bit))
(define type-u16vector (make-type-motley-non-fixnum type-u16vector-bit))
(define type-s16vector (make-type-motley-non-fixnum type-s16vector-bit))
(define type-u32vector (make-type-motley-non-fixnum type-u32vector-bit))
(define type-s32vector (make-type-motley-non-fixnum type-s32vector-bit))
(define type-u64vector (make-type-motley-non-fixnum type-u64vector-bit))
(define type-s64vector (make-type-motley-non-fixnum type-s64vector-bit))
(define type-f32vector (make-type-motley-non-fixnum type-f32vector-bit))
(define type-f64vector (make-type-motley-non-fixnum type-f64vector-bit))
(define type-pair      (make-type-motley-non-fixnum type-pair-bit))
(define type-procedure (make-type-motley-non-fixnum type-procedure-bit))
(define type-box       (make-type-motley-non-fixnum type-box-bit))
(define type-promise   (make-type-motley-non-fixnum type-promise-bit))
(define type-other     (make-type-motley-non-fixnum type-other-bit))

(define type-boolean ;; union of type-false and type-true
  (make-type-motley-non-fixnum (+ type-false-bit type-true-bit)))

(define type-typically-eq-testable ;; union of typically eq? testable types
  (make-type-motley (+ type-false-bit
                       type-true-bit
                       type-null-bit
                       type-void-bit
                       type-eof-bit
                       type-absent-bit
                       type-char-bit
                       type-symbol-bit
                       type-keyword-bit
                       type-procedure-bit)
                    '>=
                    '<=))

(define type-number
  (make-type-motley (+ type-bignum-bit
                       type-ratnum-bit
                       type-flonum-bit
                       type-cpxnum-bit)
                    '>=
                    '<=))

(define type-real
  (make-type-motley (+ type-bignum-bit
                       type-ratnum-bit
                       type-flonum-bit)
                    '>=
                    '<=))

(define type-exact-rational
  (make-type-motley (+ type-bignum-bit
                       type-ratnum-bit)
                    '>=
                    '<=))

(define type-exact-integer
  (make-type-motley type-bignum-bit
                    '>=
                    '<=))

;;; singleton type (corresponds to a single value)

(define (make-type-singleton val)
  (cons val '()))

(define (type-singleton? type)
  (and (pair? type)
       (eq? (cdr type) '())))

(define (type-singleton-val type)
  (car type))

(define (type-singleton-eqv? type1 type2)
  (eqv? (type-singleton-val type1)
        (type-singleton-val type2)))

(define (type-singleton-of-type? tctx value-of-type? type)
  (and (type-singleton? type)
       (let ((val (type-singleton-val type)))
         (value-of-type? tctx val))))

;;; conversion to motley type representation

(define (make-type-motley-from-exact-integer tctx obj)
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (cond ((and (>= obj min-fixnum)
                (<= obj max-fixnum))
           ;; fixnum within certain range
           (make-type-motley
            type-bot-bitset
            (cond ((= obj min-fixnum)       '>=)
                  ((= obj (+ min-fixnum 1)) '>)
                  (else                     (min obj (- max-fixnum 2))))
            (cond ((= obj max-fixnum)       '<=)
                  ((= obj (- max-fixnum 1)) '<)
                  (else                     (max obj (+ min-fixnum 2))))))
          ((and (>= obj (tctx-largest-min-fixnum tctx))
                (<= obj (tctx-largest-max-fixnum tctx)))
           ;; either fixnum or bignum
           (make-type-motley type-bignum-bit '>= '<=))
          (else
           ;; certainly bignum and certainly not fixnum
           (make-type-motley-non-fixnum type-bignum-bit)))))

(define (make-type-singleton-from-bitset bitset)
  (cond ((= bitset type-false-bit)
         (make-type-singleton false-object))
        ((= bitset type-true-bit)
         (make-type-singleton #t))
        ((= bitset type-null-bit)
         (make-type-singleton '()))
        ((= bitset type-eof-bit)
         (make-type-singleton end-of-file-object))
        ((= bitset type-absent-bit)
         (make-type-singleton absent-object))
        (else
         #f))) ;; type is not for a unique object

;; uncomment to test as standalone file
;;(define (false-object? obj) (not obj))
;;(define (void-object? obj) (eq? obj #!void))
;;(define (end-of-file-object? obj) (eof-object? obj))
;;(define (absent-object? obj) (eq? obj ##absent-object))

(define (make-type-motley-for-unique-obj obj)
  (cond ((false-object? obj)
         type-motley-false)
        ((eq? obj #t)
         type-motley-true)
        ((null? obj)
         type-motley-null)
        ((void-object? obj)
         type-motley-void)
        ((end-of-file-object? obj)
         type-motley-eof)
        ((absent-object? obj)
         type-motley-absent)
        (else
         #f))) ;; obj does not have its own type

(define (make-type-motley-from-obj tctx obj)
  (cond ((make-type-motley-for-unique-obj obj)
         =>
         (lambda (type) type))
        ((number? obj)
         (cond ((exact-integer? obj)
                (make-type-motley-from-exact-integer tctx obj))
               ((real? obj)
                (if (exact? obj)
                    (make-type-motley-non-fixnum type-ratnum-bit)
                    (make-type-motley-non-fixnum type-flonum-bit)))
               (else
                (make-type-motley-non-fixnum type-cpxnum-bit))))
        ((char? obj)
         type-char)
        ((symbol-object? obj)
         type-symbol)
        ((keyword-object? obj)
         type-keyword)
        ((string? obj)
         type-string)
        ((vector-object? obj)
         type-vector)
        ((u8vect? obj)
         type-u8vector)
        ((s8vect? obj)
         type-s8vector)
        ((u16vect? obj)
         type-u16vector)
        ((s16vect? obj)
         type-s16vector)
        ((u32vect? obj)
         type-u32vector)
        ((s32vect? obj)
         type-s32vector)
        ((u64vect? obj)
         type-u64vector)
        ((s64vect? obj)
         type-s64vector)
        ((f32vect? obj)
         type-f32vector)
        ((f64vect? obj)
         type-f64vector)
        ((pair? obj)
         type-pair)
        ((proc-obj? obj)
         type-procedure)
        ((box-object? obj)
         type-box)
;;        ((promise-object? obj)
;;         type-promise)
        (else
         type-other)))

(define (type-motley-force tctx type)
  (cond ((type-singleton? type)
         (make-type-motley-from-obj tctx (type-singleton-val type)))
        (else
         type)))

;;; formatting of types (used by _gvm.scm)

(define (format-type type)
  (cond ((type-top? type)
         '("^"))
        ((type-bot? type)
         '("_"))
        ((type-singleton? type)
         (list (format-gvm-obj (type-singleton-val type) #t)))
        ((type-motley? type)
         (let* ((result
                 '())
                (bitset
                 (type-motley-bitset type))
                (show-pos?
                 (let* ((mask (bitwise-not type-other-bit))
                        (on (bitwise-and mask bitset))
                        (off (bitwise-and mask (bitwise-not bitset))))
                   (< (bit-count on) (bit-count off)))))

           (define (add lst)
             (set! result
               (append lst
                       (if (null? result)
                           result
                           (cons "|" ;; alternative: (if show-pos? "|" "&")
                                 result)))))

           (define (pos lst)
             (if show-pos? (add lst)))

           (define (neg lst)
             (if (not show-pos?) (add (cons "!" lst))))

           (define (element lst bit)
             (if (eqv? 0 (bitwise-and bitset bit))
                 (neg lst)
                 (pos lst)))

           (element '("()") type-null-bit)
           (element '("vd") type-void-bit)
           (element '("ef") type-eof-bit)
           (element '("ab") type-absent-bit)

           (let ((f (not (eqv? 0 (bitwise-and bitset type-false-bit))))
                 (t (not (eqv? 0 (bitwise-and bitset type-true-bit)))))
             (cond ((and f t)
                    (pos '("bl")))
                   (f
                    (pos '("#f"))
                    (neg '("#t")))
                   (t
                    (neg '("#f"))
                    (pos '("#t")))
                   (else
                    (neg '("bl")))))

           (let ((lo (type-fixnum-lo type))
                 (hi (type-fixnum-hi type)))
             (cond ((and (eqv? lo 0) (eqv? hi -1))
                    (neg '("fx")))
                   ((and (eq? lo '>=) (eq? hi '<=))
                    (pos '("fx")))
                   (else
                    (add `(,(cond ((eq? lo '>=) ">=")
                                  ((eq? lo '>)  ">")
                                  (else         (number->string lo)))
                           ".."
                           ,(cond ((eq? hi '<=) "<=")
                                  ((eq? hi '<)  "<")
                                  (else         (number->string hi))))))))

           (element '("bn")   type-bignum-bit)
           (element '("rn")   type-ratnum-bit)
           (element '("fl")   type-flonum-bit)
           (element '("cn")   type-cpxnum-bit)
           (element '("ch")   type-char-bit)
           (element '("sy")   type-symbol-bit)
           (element '("kw")   type-keyword-bit)
           (element '("st")   type-string-bit)
           (element '("vc")   type-vector-bit)
           (element '("u8v")  type-u8vector-bit)
           (element '("s8v")  type-s8vector-bit)
           (element '("u16v") type-u16vector-bit)
           (element '("s16v") type-s16vector-bit)
           (element '("u32v") type-u32vector-bit)
           (element '("s32v") type-s32vector-bit)
           (element '("u64v") type-u64vector-bit)
           (element '("s64v") type-s64vector-bit)
           (element '("f32v") type-f32vector-bit)
           (element '("f64v") type-f64vector-bit)
           (element '("pa")   type-pair-bit)
           (element '("pr")   type-procedure-bit)
           (element '("bx")   type-box-bit)
           (element '("pm")   type-promise-bit)
           (element '("ot")   type-other-bit)

           result))
        (else
         '("unknown"))))

;;; union of types

(define (type-motley-union tctx type1 type2 widen?)

  (declare (generic))

 (define (widen-down n)
   (if (<= n 3)
       n
       (expt 2 (expt 2 (- (integer-length (- (integer-length n) 1)) 1)))))

 (define (widen-up n)
   (if (<= n 3)
       n
       (let ((x (expt 2 (- (expt 2 (max 3 (integer-length (- (integer-length n) 1)))) 2))))
         (cond ((< n (- x 1)) (- x 2))
               ((< n x)       (- x 1))
               (else
                (let ((x (* x 2)))
                  (cond ((< n (- x 1)) (- x 2))
                        ((< n x)       (- x 1))
                        (else
                         (- (* x 2) 1)))))))))

  (define (widen-lo n)
    (if (>= n 0)
        (widen-down n)
        (- -1 (widen-up (- -1 n)))))

  (define (widen-hi n)
    (if (>= n 0)
        (widen-up n)
        (- (widen-down (- n)))))

  (let ((lo1 (type-fixnum-lo type1))
        (hi1 (type-fixnum-hi type1))
        (lo2 (type-fixnum-lo type2))
        (hi2 (type-fixnum-hi type2)))
    (make-type-motley
     (bitwise-ior (type-motley-bitset type1)
                  (type-motley-bitset type2))
     (cond ((or (not lo1) (not lo2))         #f)
           ((or (eq? lo1 '>=) (eq? lo2 '>=)) '>=)
           ((or (eq? lo1 '>)  (eq? lo2 '>))  '>)
           ((= lo1 lo2)                      lo1)
           (else
            (let ((lo (min lo1 lo2)))
              (if (or (not widen?) (= lo 0))
                  lo
                  (type-fixnum-normalize-lo
                   tctx
                   (if (< lo2 lo1)
                       (widen-lo lo2)
                       lo1))))))
     (cond ((or (not hi1) (not hi2))         #f)
           ((or (eq? hi1 '<=) (eq? hi2 '<=)) '<=)
           ((or (eq? hi1 '<)  (eq? hi2 '<))  '<)
           ((= hi1 hi2)                      hi1)
           (else
            (let ((hi (max hi1 hi2)))
              (if (or (not widen?) (= hi 0))
                  hi
                  (type-fixnum-normalize-hi
                   tctx
                   (if (> hi2 hi1)
                       (widen-hi hi2)
                       hi1)))))))))

(define (type-union tctx type1 type2 widen?)
  (cond ((type-bot? type1)
         type2)
        ((type-bot? type2)
         type1)
        ((and (type-singleton? type1)
              (type-singleton? type2)
              (type-singleton-eqv? type1 type2))
         type1)
        (else
         (type-motley-union
          tctx
          (type-motley-force tctx type1)
          (type-motley-force tctx type2)
          widen?))))

(define (type-motley-intersection type1 type2)
  (let* ((lo1 (type-fixnum-lo type1))
         (hi1 (type-fixnum-hi type1))
         (lo2 (type-fixnum-lo type2))
         (hi2 (type-fixnum-hi type2))
         (lo ;; max of lo1 and lo2
          (cond ((not lo1)     lo2)
                ((not lo2)     lo1)
                ((eq? lo1 '>=) lo2)
                ((eq? lo2 '>=) lo1)
                ((eq? lo1 '>)  lo2)
                ((eq? lo2 '>)  lo1)
                (else          (max lo1 lo2))))
         (hi ;; min of hi1 and hi2
          (cond ((not hi1)     hi2)
                ((not hi2)     hi1)
                ((eq? hi1 '<=) hi2)
                ((eq? hi2 '<=) hi1)
                ((eq? hi1 '<)  hi2)
                ((eq? hi2 '<)  hi1)
                (else          (min hi1 hi2))))
         (empty-range?
          (and (exact-integer? lo)
               (exact-integer? hi)
               (> lo hi))))
    (make-type-motley
     (bitwise-and (type-motley-bitset type1)
                  (type-motley-bitset type2))
     (if empty-range? 0 lo)
     (if empty-range? -1 hi))))

(define (type-intersection tctx type1 type2)
  (cond ((type-top? type1)
         type2)
        ((type-top? type2)
         type1)
        ((and (type-singleton? type1)
              (type-singleton? type2)
              (type-singleton-eqv? type1 type2))
         type1)
        (else
         (type-motley-normalize
          tctx
          (type-motley-intersection
           (type-motley-force tctx type1)
           (type-motley-force tctx type2))))))

(define (type-motley-difference type1 type2)
  (let ((lo1 (type-fixnum-lo type1))
        (hi1 (type-fixnum-hi type1))
        (lo2 (type-fixnum-lo type2))
        (hi2 (type-fixnum-hi type2)))

    (define (fixnum-range lo hi)
      (make-type-motley
       (bitwise-and (type-motley-bitset type1)
                    (bitwise-not (type-motley-bitset type2)))
       lo
       hi))

    (cond ((and (exact-integer? lo1)
                (exact-integer? hi1)
                (exact-integer? lo2)
                (exact-integer? hi2))
           (cond ((or (< hi2 lo1)
                      (> lo2 hi1))
                  (fixnum-range lo1 hi1)) ;; no effect on fixnum range
                 ((> lo2 lo1)             ;; and (>= hi2 lo1)
                  (if (< hi2 hi1)         ;; and (>= hi2 lo1)
                      (fixnum-range lo1 hi1) ;; no effect on fixnum range
                      (fixnum-range lo1 (- lo2 1))))
                 (else
                  (if (< hi2 hi1) ;; and (<= lo2 lo1)
                      (fixnum-range (+ hi2 1) hi1)
                      (fixnum-range 0 -1))))) ;; empty range
          ((and (eq? lo2 '>=) (eq? hi2 '<=))
           (fixnum-range 0 -1))
          (else
           (fixnum-range lo1 hi1)))))

(define (type-difference tctx type1 type2)
  (cond ((type-bot? type2)
         type1)
        ((type-top? type2)
         type-bot)
        (else
         (type-motley-normalize
          tctx
          (type-motley-difference
           (type-motley-force tctx type1)
           (type-motley-force tctx type2))))))

(define (type-fixnum-lo->= lo1 lo2) ;; compare lo limits of fixnum range
  (cond ((not lo2)     #t)
        ((not lo1)     #f)
        ((eq? lo2 '>=) #t)
        ((eq? lo1 '>=) #f)
        ((eq? lo1 '>)  #t)
        ((eq? lo2 '>)  #f)
        (else          (>= lo1 lo2))))

(define (type-fixnum-hi-<= hi1 hi2) ;; compare hi limits of fixnum range
  (cond ((not hi2)     #t)
        ((not hi1)     #f)
        ((eq? hi2 '<=) #t)
        ((eq? hi1 '<=) #f)
        ((eq? hi2 '<)  #t)
        ((eq? hi1 '<)  #f)
        (else          (<= hi1 hi2))))

(define (type-fixnum-<=-num lohi num)
  (cond ((eq? lohi '>=) #t)
        ((eq? lohi '>)  #t)
        ((eq? lohi '<)  #f)
        ((eq? lohi '<=) #f)
        (else           (<= lohi num))))

(define (type-fixnum->=-num lohi num)
  (cond ((eq? lohi '>=) #f)
        ((eq? lohi '>)  #f)
        ((eq? lohi '<)  #t)
        ((eq? lohi '<=) #t)
        (else           (>= lohi num))))

(define (type-fixnum-<= lohi1 lohi2)
  (cond ((eq? lohi1 '>=)
         #t)
        ((eq? lohi1 '>)
         (not (eq? lohi2 '>=)))
        ((exact-integer? lohi1)
         (cond ((eq? lohi2 '>=)        #f)
               ((eq? lohi2 '>)         #f)
               ((exact-integer? lohi2) (<= lohi1 lohi2))
               (else                   #t)))
        ((eq? lohi1 '<)
         (or (eq? lohi2 '<)
             (eq? lohi2 '<=)))
        ((eq? lohi1 '<=)
         (eq? lohi2 '<=))
        (else
         (error "(type-fixnum-<= lohi1 lohi2)"))))

(define (type-fixnum-< lohi1 lohi2)
  (cond ((eq? lohi1 '>=)
         (not (eq? lohi2 '>=)))
        ((eq? lohi1 '>)
         (not (or (eq? lohi2 '>=)
                  (eq? lohi2 '>))))
        ((exact-integer? lohi1)
         (cond ((eq? lohi2 '>=)        #f)
               ((eq? lohi2 '>)         #f)
               ((exact-integer? lohi2) (< lohi1 lohi2))
               (else                   #t)))
        ((eq? lohi1 '<)
         (eq? lohi2 '<=))
        ((eq? lohi1 '<=)
         #f)
        (else
         (error "(type-fixnum-< lohi1 lohi2)"))))

(define (type-fixnum->= lohi1 lohi2)
  (not (type-fixnum-< lohi1 lohi2)))

(define (type-fixnum-> lohi1 lohi2)
  (not (type-fixnum-<= lohi1 lohi2)))

(define (type-fixnum-inc-lo lo)
  (declare (generic))
  (if (or (eq? lo '>=) (eq? lo '>))
      '>
      (+ lo 1)))

(define (type-fixnum-dec-lo lo)
  (declare (generic))
  (if (or (eq? lo '>=) (eq? lo '>))
      '>=
      (- lo 1)))

(define (type-fixnum-inc-hi hi)
  (declare (generic))
  (if (or (eq? hi '<=) (eq? hi '<))
      '<=
      (+ hi 1)))

(define (type-fixnum-dec-hi hi)
  (declare (generic))
  (if (or (eq? hi '<=) (eq? hi '<))
      '<
      (- hi 1)))

(define (type-fixnum-min-hi x y)
  (if (type-fixnum-< x y) x y))

(define (type-fixnum-max-lo x y)
  (if (type-fixnum-< x y) y x))

(define (type-eqv? type1 type2) ;; is type1 equal to type2?
  (equal? type1 type2))

(define (type-memv type types)
  (if (null? types)
      #f
      (or (type-eqv? type (car types)) (type-memv type (cdr types)))))

(define (type-included? tctx type1 type2) ;; is type1 included in type2?
  (type-motley-included?
   (type-motley-force tctx type1)
   (type-motley-force tctx type2)))

(define (type-motley-included? type1 type2) ;; is type1 included in type2?
  (and (let ((bitset1 (type-motley-bitset type1))
             (bitset2 (type-motley-bitset type2)))
         (= (bitwise-and bitset1 bitset2) bitset1))
       (type-fixnum-lo->= (type-fixnum-lo type1) (type-fixnum-lo type2))
       (type-fixnum-hi-<= (type-fixnum-hi type1) (type-fixnum-hi type2))))

;;; type inference

(define (type-infer-fixnum1 tctx infer type)
  (if (not (type-included? tctx type type-fixnum))
      (make-type-fixnum #f #f) ;; TODO: is this correct
      (let* ((f (type-motley-force tctx type))
             (lo (type-fixnum-lo f))
             (hi (type-fixnum-hi f)))
        (infer tctx lo hi))))

(define (type-infer-fixnum2 tctx infer type1 type2)
  (if (or (not (type-included? tctx type1 type-fixnum))
          (not (type-included? tctx type2 type-fixnum)))
      (make-type-fixnum #f #f) ;; TODO: is this correct
      (let* ((f1 (type-motley-force tctx type1))
             (lo1 (type-fixnum-lo f1))
             (hi1 (type-fixnum-hi f1))
             (f2 (type-motley-force tctx type2))
             (lo2 (type-fixnum-lo f2))
             (hi2 (type-fixnum-hi f2)))
        (infer tctx lo1 hi1 lo2 hi2))))

(define (type-infer-fold infer0 infer1 infer2)
  (lambda (tctx args)
    (if (not (pair? args))
        (infer0 tctx)
        (let ((arg1 (car args))
              (rest (cdr args)))
          (if (not (pair? rest))
              (infer1 tctx arg1)
              (let loop ((result arg1) (lst rest))
                (if (pair? lst)
                    (loop (infer2 tctx result (car lst)) (cdr lst))
                    result)))))))

(define (type-infer-common-fx+ tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (<=? x val) (type-fixnum-<=-num x val))
  (define (>=? x val) (type-fixnum->=-num x val))
  (define (=? x val) (eqv? x val))

  (define (abstract-fx+ x y)

    (define (abstract-fx+-non-num x y) ;; x is non numeric, y can be numeric
      (cond ((eq? x '>=)  ;; x >= smallest_min_fixnum
             (cond ((>=? y 1)  '>)     ;; result >= smallest_min_fixnum + 1
                   ((=? y 0)   '>=)    ;; result >= smallest_min_fixnum
                   (else       #f)))   ;; overflow
            ((eq? x '>)   ;; x >= smallest_min_fixnum + 1
             (cond ((>=? y 0)  '>)     ;; result >= smallest_min_fixnum + 1
                   ((=? y -1)  '>=)    ;; result >= smallest_min_fixnum
                   (else       #f)))   ;; overflow
            ((eq? x '<)  ;; x <= smallest_max_fixnum - 1
             (cond ((<=? y 0)  '<)     ;; result <= smallest_max_fixnum - 1
                   ((=? y 1)   '<=)    ;; result <= smallest_max_fixnum
                   (else       #f)))   ;; overflow
            (else ;; (eq? x '<=) ;; x <= smallest_max_fixnum
             (cond ((<=? y -1) '<)     ;; result <= smallest_max_fixnum - 1
                   ((=? y 0)   '<=)    ;; result <= smallest_max_fixnum
                   (else       #f))))) ;; overflow

    (if (exact-integer? x)
        (if (exact-integer? y)
            (+ x y)
            (abstract-fx+-non-num y x))
        (abstract-fx+-non-num x y)))

  (make-type-fixnum-bounded
   tctx
   (abstract-fx+ lo1 lo2)
   (abstract-fx+ hi1 hi2)))

(define (type-infer-common-fx- tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (<=? x val) (type-fixnum-<=-num x val))
  (define (>=? x val) (type-fixnum->=-num x val))
  (define (=? x val) (eqv? x val))

  (define (abstract-fx- x y) ;; x and y are lo or hi limits of a fixnum range
    (cond ((eq? x '>=)  ;; x >= smallest_min_fixnum
           (cond ((<=? y -1)       '>)   ;; result >= smallest_min_fixnum + 1
                 ((=? y 0)         '>=)  ;; result >= smallest_min_fixnum
                 (else             #f))) ;; overflow
          ((eq? x '>)   ;; x >= smallest_min_fixnum + 1
           (cond ((<=? y 0)        '>)   ;; result >= smallest_min_fixnum + 1
                 ((=? y 1)         '>=)  ;; result >= smallest_min_fixnum
                 (else             #f))) ;; overflow
          ((eq? x '<)   ;; x <= smallest_max_fixnum - 1
           (cond ((>=? y 0)        '<)   ;; result <= smallest_max_fixnum - 1
                 ((=? y -1)        '<=)  ;; result <= smallest_max_fixnum
                 (else             #f))) ;; overflow
          ((eq? x '<=)  ;; x <= smallest_max_fixnum
           (cond ((>=? y 1)        '<)   ;; result <= smallest_max_fixnum - 1
                 ((=? y 0)         '<=)  ;; result <= smallest_max_fixnum
                 (else             #f))) ;; overflow
          (else         ;; x is a specific number
           (cond ((eq? y '>=)
                  (cond ((<= x -2) '<)    ;; result <= smallest_max_fixnum - 1
                        ((= x -1)  '<=)   ;; result <= smallest_max_fixnum
                        (else      #f)))  ;; overflow
                 ((eq? y '>)
                  (cond ((<= x -1) '<)    ;; result <= smallest_max_fixnum - 1
                        ((= x 0)   '<=)   ;; result <= smallest_max_fixnum
                        (else      #f)))  ;; overflow
                 ((eq? y '<)
                  (cond ((>= x -1) '>)    ;; result >= smallest_min_fixnum + 1
                        ((= x -2)  '>=)   ;; result >= smallest_min_fixnum
                        (else      #f)))  ;; overflow
                 ((eq? y '<=)
                  (cond ((>= x 0)  '>)    ;; result >= smallest_min_fixnum + 1
                        ((= x -1)  '>=)   ;; result >= smallest_min_fixnum
                        (else      #f)))  ;; overflow
                 (else
                  (- x y))))))

  (make-type-fixnum-bounded
   tctx
   (abstract-fx- lo1 hi2)
   (abstract-fx- hi1 lo2)))

(define (type-infer-common-fx* tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (nonneg? lo)
    (and (exact-integer? lo)
         (>= lo 0)))

  (define (neg? hi)
    (and (exact-integer? hi)
         (< hi 0)))

  (define (minus-to-plus-1? lo hi)
    (and (exact-integer? lo)
         (exact-integer? hi)
         (>= lo -1)
         (<= hi 1)))

  (define (minus-to-plus-1-case lo1 hi1 lo2 hi2)

    (define (zero)
      (make-type-fixnum 0 0))

    (define (one)
      (make-type-fixnum lo2 hi2))

    (define (minus-one)
      (type-infer-fixnum2 tctx type-infer-common-fx- (zero) (one)))

    (cond ((= hi1 -1)
           (minus-one)) ;; multiplying by -1
          ((= hi1 0)
           (if (= lo1 0)
               (zero)      ;; multiplying by 0
               (type-union ;; multiplying by -1 or 0
                tctx
                (minus-one)
                (zero)
                #f)))
          ((= lo1 1)
           (one)) ;; multiplying by 1
          ((= lo1 0)
           (type-union ;; multiplying by 0 or 1
            tctx
            (zero)
            (one)
            #f))
          (else
           (type-union ;; multiplying by -1, 0 or 1
            tctx
            (minus-one)
            (type-union
             tctx
             (zero)
             (one)
             #f)
            #f))))

  (cond ((minus-to-plus-1? lo1 hi1)
         (minus-to-plus-1-case lo1 hi1 lo2 hi2))
        ((minus-to-plus-1? lo2 hi2)
         (minus-to-plus-1-case lo2 hi2 lo1 hi1))
        ((and (exact-integer? lo1)
              (exact-integer? hi1)
              (exact-integer? lo2)
              (exact-integer? hi2))
         (let ((lo-lo (* lo1 lo2))
               (lo-hi (* lo1 hi2))
               (hi-lo (* hi1 lo2))
               (hi-hi (* hi1 hi2)))
           (make-type-fixnum-bounded
            tctx
            (min lo-lo lo-hi hi-lo hi-hi)
            (max lo-lo lo-hi hi-lo hi-hi))))
        ((nonneg? lo1)
         (cond ((nonneg? lo2)
                (make-type-fixnum-bounded
                 tctx
                 (* lo1 lo2)
                 #f)) ;; can overflow in the positives
               ((neg? hi2)
                (make-type-fixnum-bounded
                 tctx
                 #f ;; can overflow in the negatives
                 (* lo1 hi2)))
               (else
                (make-type-fixnum #f #f))))
        ((neg? hi1)
         (cond ((nonneg? lo2)
                (make-type-fixnum-bounded
                 tctx
                 #f ;; can overflow in the negatives
                 (* hi1 lo2)))
               ((neg? hi2)
                (make-type-fixnum-bounded
                 tctx
                 (* hi1 hi2)
                 #f)) ;; can overflow in the positives
               (else
                (make-type-fixnum #f #f))))
        (else
         (make-type-fixnum #f #f))))

(define (type-infer-common-fxquotient tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (<=? x val) (type-fixnum-<=-num x val))
  (define (>=? x val) (type-fixnum->=-num x val))

  (define (empty) type-bot)

  (define (clamp>= val bound)
    (if (>=? val bound)
        val
        bound))

  (define (clamp<= val bound)
    (if (<=? val bound)
        val
        bound))

  (define (quadrants-union . fixnums)
    (define (quadrants-union-aux fixnums)
      (cond
        ((null? fixnums)
          (empty))
        ((null? (cdr fixnums))
          (car fixnums))
        (else
          (type-union tctx (car fixnums) (quadrants-union-aux (cdr fixnums)) #f))))

    (quadrants-union-aux (filter (lambda (x) x) fixnums)))

  (define (fixnum-lo fixnum)
    (if (number? fixnum)
        fixnum
        (type-fixnum-lo fixnum)))

  (define (fixnum-hi fixnum)
    (if (number? fixnum)
        fixnum
        (type-fixnum-hi fixnum)))

  (define (fixnum-bound fixnum)
    (let* ((lo (type-fixnum-lo fixnum))
           (hi (type-fixnum-hi fixnum)))
      (make-type-fixnum-bounded tctx lo hi)))

  (define (abstract-pos-pos-fxquotient x y)
    ;; assume x >= 0 and y > 0
    (cond ((eq? x '<=)
           (make-type-fixnum 0 '<=))
          ((eq? x '<)
           (make-type-fixnum 0 '<))
          ;; dividend is a specific number
          ((eq? y '<)
           (make-type-fixnum 0 x))
          ((eq? y '<=)
           (make-type-fixnum 0 x))
          ;; divisor is a number as well
          (else
            (let ((result (quotient x y)))
              (make-type-fixnum result result)))))

  (define (abstract-pos-neg-fxquotient x y)
    ;; assume x >= 0 and y < 0
    (cond ((eq? x '<=)
           (make-type-fixnum '> 0))
          ((eq? x '<)
           (make-type-fixnum '> 0))
          ;; dividend is a specific number
          ((eq? y '>)
           (make-type-fixnum (- x) 0))
          ((eq? y '>=)
           (make-type-fixnum (- x) 0))
          ;; divisor is a number as well
          (else
            (let ((result (quotient x y)))
              (make-type-fixnum result result)))))

  (define (abstract-neg-pos-fxquotient x y)
    ;; assume x < 0 and y > 0
    (cond ((eq? x '>=)
           (make-type-fixnum '>= 0))
          ((eq? x '>)
           (make-type-fixnum '> 0))
          ;; dividend is a specific number
          ((eq? y '<)
           (make-type-fixnum x 0))
          ((eq? y '<=)
           (make-type-fixnum x 0))
          ;; divisor is a number as well
          (else
            (let ((result (quotient x y)))
              (make-type-fixnum result result)))))

  (define (abstract-neg-neg-fxquotient x y)
    ;; assume x < 0 and y < 0
    (cond ((eq? x '>=)
           (make-type-fixnum
             0
             (if (<=? y 2) '<= #f))) ;; overflow
          ((eq? x '>)
           (make-type-fixnum 0 '<=))
          ;; dividend is a specific number
          ((eq? y '>=)
           (make-type-fixnum 0 (- x))) ;; can overflow, must be bounded later
          ((eq? y '>)
           (make-type-fixnum 0 (- x))) ;; can overflow, must be bounded later
          ;; divisor is a number as well
          (else
            (let ((result (quotient x y))) ;; can overflow, must be bounded later
              (make-type-fixnum result result)))))

  (define (make-pos-pos-interval?)
    (and (>=? hi1 0)
         (>=? hi2 1)
         (make-type-fixnum
           ;; smaller bound takes min dividend and max divisor
           (fixnum-lo
             (abstract-pos-pos-fxquotient
               (clamp>= lo1 0)
               hi2))
           ;; higher bound takes max dividend and min divisor
           (fixnum-hi
             (abstract-pos-pos-fxquotient
               hi1
               (clamp>= lo2 1))))))

  (define (make-pos-neg-interval?)
    (and (>=? hi1 0)
         (<=? lo2 -1)
         (make-type-fixnum
           ;; smaller bound takes max dividend and min absolute divisor
           (fixnum-lo
             (abstract-pos-neg-fxquotient
               hi1
               (clamp<= hi2 -1)))
           ;; higher bound takes min dividend and max absolute divisor
           (fixnum-hi
             (abstract-pos-neg-fxquotient
               (clamp>= lo1 0)
               lo2)))))

  (define (make-neg-pos-interval?)
    (and (<=? lo1 -1)
         (>=? hi2 1)
         (make-type-fixnum
           ;; smaller bound takes max absolute dividend and min divisor
           (fixnum-lo
             (abstract-neg-pos-fxquotient
               lo1
               (clamp>= lo2 1)))
           ;; higher bound takes min absolute dividend and max divisor
           (fixnum-hi
             (abstract-neg-pos-fxquotient
               (clamp<= hi1 -1)
               hi2)))))

  (define (make-neg-neg-interval?)
    (and (<=? lo1 -1)
         (<=? lo2 -1)
         (make-type-fixnum
           ;; smaller bound takes min absolute dividend and max absolute divisor
           (fixnum-lo
             (abstract-neg-neg-fxquotient
               (clamp<= hi1 -1)
               lo2))
           ;; higher bound takes max absolute dividend and min absolute divisor
           (fixnum-hi
             (abstract-neg-neg-fxquotient
               lo1
               (clamp<= hi2 -1))))))

  (fixnum-bound
    (quadrants-union
      (make-pos-pos-interval?)
      (make-pos-neg-interval?)
      (make-neg-pos-interval?)
      (make-neg-neg-interval?))))


(define (type-infer-common-fxremainder tctx lo1 hi1 lo2 hi2)
  (make-type-fixnum 0 -1)) ;; TODO: implement!

(define (type-infer-common-fxmodulo tctx lo1 hi1 lo2 hi2)
  (make-type-fixnum 0 -1)) ;; TODO: implement!

(define-macro (case-signs args . body)
  (define sign-procedure-symbol (gensym 'get-sign))

  (define else-clause
    (let ((clause (assq 'else body)))
      (and clause (cadr clause))))

  (define (make-conds parent-signs args)
    (if (null? args)
      (let ((clause (assoc (reverse parent-signs) body)))
        (if clause (cadr clause) else-clause))
      (let ((sign-symbol (gensym 'sign)))
        `(let ((,sign-symbol (,sign-procedure-symbol ,(car args))))
           (cond
             ((eq? ,sign-symbol '+)
               ,(make-conds (cons '+ parent-signs) (cdr args)))
             ((eq? ,sign-symbol '-)
               ,(make-conds (cons '- parent-signs) (cdr args)))
             ((eq? ,sign-symbol '?)
               ,(make-conds (cons '? parent-signs) (cdr args))))))))

 `(let ((,sign-procedure-symbol
         (lambda (x)
           (cond
             ((not (number? x))
               '?)
             ((< x 0)
               '-)
             (else
               '+)))))
    ,(make-conds '() args)))

(define (get-limit-bit tctx)
  (* -2 (tctx-largest-min-fixnum tctx)))

(define (to-unsigned tctx n)
  (bitwise-and n (- (get-limit-bit tctx) 1)))

(define (to-signed tctx n)
  (if (< (tctx-largest-max-fixnum tctx) n)
      (+ n (* 2 (tctx-largest-min-fixnum tctx)))
      n))

(define (type-infer-common-fxior tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (min-ior-unsigned lo1 hi1 lo2 hi2)
    ;; Henry S. Warren, Hacker's Delight, 2003. p 59
    (let loop ((m (get-limit-bit tctx)))
      (cond
        ((= m 0) (bitwise-ior lo1 lo2))
        ((not
          (= 0
            (bitwise-and
              (bitwise-not lo1)
              lo2
              m)))
          (let ((temp (bitwise-and (bitwise-ior lo1 m) (- m))))
            (if (<= temp hi1)
                (bitwise-ior temp lo2)
                (loop (arithmetic-shift m -1)))))
        ((not
          (= 0
            (bitwise-and
              lo1
              (bitwise-not lo2)
              m)))
          (let ((temp (bitwise-and (bitwise-ior lo2 m) (- m))))
            (if (<= temp hi2)
                (bitwise-ior lo1 temp)
                (loop (arithmetic-shift m -1)))))
        (else
          (loop (arithmetic-shift m -1))))))

  (define (max-ior-unsigned lo1 hi1 lo2 hi2)
    ;; Henry S. Warren, Hacker's Delight, 2003. p 60
    (let loop ((m (get-limit-bit tctx)))
      (cond
        ((= m 0) (bitwise-ior hi1 hi2))
        ((not
          (= 0
            (bitwise-and
              hi1
              hi2
              m)))
          (let ((temp1 (bitwise-ior (- hi1 m) (- m 1)))
                (temp2 (bitwise-ior (- hi2 m) (- m 1))))
            (cond
              ((>= temp1 lo1)
                (bitwise-ior temp1 hi2))
              ((>= temp2 lo2)
                (bitwise-ior hi1 temp2))
              (else
                (loop (arithmetic-shift m -1))))))
        (else
          (loop (arithmetic-shift m -1))))))

  (define (min-ior lo1 hi1 lo2 hi2)
    (type-fixnum-normalize-lo
      tctx
      (to-signed
        tctx
        (min-ior-unsigned
          (to-unsigned tctx lo1) (to-unsigned tctx hi1) (to-unsigned tctx lo2) (to-unsigned tctx hi2)))))

  (define (max-ior lo1 hi1 lo2 hi2)
    (type-fixnum-normalize-hi
      tctx
      (to-signed
        tctx
        (max-ior-unsigned
          (to-unsigned tctx lo1) (to-unsigned tctx hi1) (to-unsigned tctx lo2) (to-unsigned tctx hi2)))))

  (case-signs (lo1 hi1 lo2 hi2)
    ;; NOTE: all values are provided as signed and will be converted to unsigned by min-ior and max-ior
    ((- - - -)
      (make-type-fixnum
        (min-ior lo1 hi1 lo2 hi2)
        (max-ior lo1 hi1 lo2 hi2)))
    ((- - - +)
      (make-type-fixnum lo1 -1))
    ((- - + +)
      (make-type-fixnum
        (min-ior lo1 hi1 lo2 hi2)
        (max-ior lo1 hi1 lo2 hi2)))
    ((- + - -)
      (make-type-fixnum lo2 -1))
    ((- + - +)
      (make-type-fixnum (min lo1 lo2) (max-ior 0 hi1 0 hi2)))
    ((- + + +)
      (make-type-fixnum
        (min-ior lo1 -1 lo2 hi2)
        (max-ior 0 hi1 lo2 hi2)))
    ((+ + - -)
      (make-type-fixnum
        (min-ior lo1 hi1 lo2 hi2)
        (max-ior lo1 hi1 lo2 hi2)))
    ((+ + - +)
      (make-type-fixnum
        (min-ior lo1 hi1 lo2 -1)
        (max-ior lo1 hi1 0 hi2)))
    ((+ + + +)
      (make-type-fixnum
        (min-ior lo1 hi1 lo2 hi2)
        (max-ior lo1 hi1 lo2 hi2)))
    ;; limit bounds >=, >, <, <= in which case we can sometime infer sign
    ((? - ? -)
      (make-type-fixnum '>= -1))
    ((+ ? + ?)
      (make-type-fixnum 0 '<=))
    (else
      (make-type-fixnum '>= '<=))))

(define (type-infer-common-fxxor tctx lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (min-xor-unsigned lo1 hi1 lo2 hi2)
    ;; Henry S. Warren, Hacker's Delight, 2003. p 59
    (let loop ((m (get-limit-bit tctx)))
      (cond
        ((= m 0) (bitwise-xor lo1 lo2))
        ((not
          (= 0
            (bitwise-and
              (bitwise-not lo1)
              lo2
              m)))
          (let ((temp (bitwise-and (bitwise-ior lo1 m) (- m))))
            (if (<= temp hi1) (set! lo1 temp))
            (loop (arithmetic-shift m -1))))
        ((not
          (= 0
            (bitwise-and
              lo1
              (bitwise-not lo2)
              m)))
          (let ((temp (bitwise-and (bitwise-ior lo2 m) (- m))))
            (if (<= temp hi2) (set! lo2 temp))
            (loop (arithmetic-shift m -1))))
        (else
          (loop (arithmetic-shift m -1))))))

  (define (max-xor-unsigned lo1 hi1 lo2 hi2)
    ;; Henry S. Warren, Hacker's Delight, 2003. p 60
    (let loop ((m (get-limit-bit tctx)))
      (cond
        ((= m 0) (bitwise-xor hi1 hi2))
        ((not
          (= 0
            (bitwise-and
              hi1
              hi2
              m)))
          (let ((temp1 (bitwise-ior (- hi1 m) (- m 1)))
                (temp2 (bitwise-ior (- hi2 m) (- m 1))))
            (cond
              ((>= temp1 lo1)
                (set! hi1 temp1))
              ((>= temp2 lo2)
                (set! hi2 temp2)))
            (loop (arithmetic-shift m -1))))
        (else
          (loop (arithmetic-shift m -1))))))

  (define (min-xor lo1 hi1 lo2 hi2)
    (type-fixnum-normalize-lo
      tctx
      (to-signed
        tctx
        (min-xor-unsigned
          (to-unsigned tctx lo1) (to-unsigned tctx hi1) (to-unsigned tctx lo2) (to-unsigned tctx hi2)))))

  (define (max-xor lo1 hi1 lo2 hi2)
    (type-fixnum-normalize-hi
      tctx
      (to-signed
        tctx
        (max-xor-unsigned
          (to-unsigned tctx lo1) (to-unsigned tctx hi1) (to-unsigned tctx lo2) (to-unsigned tctx hi2)))))

  (case-signs (lo1 hi1 lo2 hi2)
    ;; Adaptation of the ior table of Hacker's Delight to xor
    ;; NOTE: all values are provided as signed and will be converted to unsigned by min-xor and max-xor
    ((- - - -)
      (make-type-fixnum
        (min-xor lo1 hi1 lo2 hi2)
        (max-xor lo1 hi1 lo2 hi2)))
    ((- - - +)
      (make-type-fixnum
        (min-xor lo1 hi1 0 hi2)
        (max-xor lo1 hi1 lo2 -1)))
    ((- - + +)
      (make-type-fixnum
        (min-xor lo1 hi1 lo2 hi2)
        (max-xor lo1 hi1 lo2 hi2)))
    ((- + - -)
      (make-type-fixnum
        (min-xor 0 hi1 lo2 hi2)
        (max-xor lo1 -1 lo2 hi2)))
    ((- + - +)
      (make-type-fixnum
        (type-fixnum-min-hi
          (min-xor lo1 -1 0 hi2)
          (min-xor 0 hi1 lo2 -1))
        (type-fixnum-max-lo
          (max-xor 0 hi1 0 hi2)
          (max-xor lo1 -1 lo2 -1))))
    ((- + + +)
      (make-type-fixnum
        (min-xor lo1 -1 lo2 hi2)
        (max-xor 0 hi1 lo2 hi2)))
    ((+ + - -)
      (make-type-fixnum
        (min-xor lo1 hi1 lo2 hi2)
        (max-xor lo1 hi1 lo2 hi2)))
    ((+ + - +)
      (make-type-fixnum
        (min-xor lo1 hi1 lo2 -1)
        (max-xor lo1 hi1 0 hi2)))
    ((+ + + +)
      (make-type-fixnum
        (min-xor lo1 hi1 lo2 hi2)
        (max-xor lo1 hi1 lo2 hi2)))
    ;; limit bounds >=, >, <, <= in which case we can sometime infer sign
    ((? - ? -)
      (make-type-fixnum 0 '<=))
    ((+ ? + ?)
      (make-type-fixnum 0 '<=))
    (else
      (make-type-fixnum '>= '<=))))

(define (type-infer-common-fxnot tctx lo hi)
  (define (abstract-fxnot x)
    (case x
      ('<= '>=)
      ('<  '>)
      ('>  '<)
      ('>= '<=)
      (else
        (- -1 x))))

  (make-type-fixnum
    (abstract-fxnot hi)
    (abstract-fxnot lo)))

(define (type-infer-common-fxand tctx lo1 hi1 lo2 hi2)
  ;; Apply De Morgan
  (let* ((not-left (type-infer-common-fxnot tctx lo1 hi1))
         (not-right (type-infer-common-fxnot tctx lo2 hi2))
         (or-left-right
           (type-infer-common-fxior
             tctx
             (type-fixnum-lo not-left)
             (type-fixnum-hi not-left)
             (type-fixnum-lo not-right)
             (type-fixnum-hi not-right)))
         (not-result
           (type-infer-common-fxnot
             tctx
             (type-fixnum-lo or-left-right)
             (type-fixnum-hi or-left-right))))
    not-result))

(define (type-infer-common-fxandc1 tctx lo1 hi1 lo2 hi2)
  (let* ((not-left (type-infer-common-fxnot tctx lo1 hi1))
         (result
           (type-infer-common-fxand
             tctx
             (type-fixnum-lo not-left)
             (type-fixnum-hi not-left)
             lo2
             hi2)))
    result))

(define (type-infer-common-fxandc2 tctx lo1 hi1 lo2 hi2)
  (let* ((not-right (type-infer-common-fxnot tctx lo2 hi2))
         (result
           (type-infer-common-fxand
             tctx
             lo1
             hi1
             (type-fixnum-lo not-right)
             (type-fixnum-hi not-right))))
    result))

(define (type-infer-common-fxorc1 tctx lo1 hi1 lo2 hi2)
  (let* ((not-left (type-infer-common-fxnot tctx lo1 hi1))
         (result
           (type-infer-common-fxior
             tctx
             (type-fixnum-lo not-left)
             (type-fixnum-hi not-left)
             lo2
             hi2)))
    result))

(define (type-infer-common-fxorc2 tctx lo1 hi1 lo2 hi2)
  (let* ((not-right (type-infer-common-fxnot tctx lo2 hi2))
         (result
           (type-infer-common-fxior
             tctx
             lo1
             hi1
             (type-fixnum-lo not-right)
             (type-fixnum-hi not-right))))
    result))

(define (type-infer-common-fxnand tctx lo1 hi1 lo2 hi2)
  (let* ((not-left (type-infer-common-fxnot tctx lo1 hi1))
         (not-right (type-infer-common-fxnot tctx lo2 hi2))
         (not-and
           (type-infer-common-fxior
             tctx
             (type-fixnum-lo not-left)
             (type-fixnum-hi not-left)
             (type-fixnum-lo not-right)
             (type-fixnum-hi not-right))))
    not-and))

(define (type-infer-common-fxnor tctx lo1 hi1 lo2 hi2)
  (let* ((or-result
          (type-infer-common-fxior
            tctx
            lo1
            hi1
            lo2
            hi2))
         (not-or
          (type-infer-common-fxnot
            tctx
            (type-fixnum-lo or-result)
            (type-fixnum-hi or-result))))
    not-or))

(define (type-infer-common-fxeqv tctx lo1 hi1 lo2 hi2)
  ;; (fxeqv x y) = (fxnot (fxxor x y))
  (let* ((xor-result
          (type-infer-common-fxxor
            tctx
            lo1
            hi1
            lo2
            hi2))
         (not-xor
          (type-infer-common-fxnot
            tctx
            (type-fixnum-lo xor-result)
            (type-fixnum-hi xor-result))))
    not-xor))

(define (type-infer-common-fxif tctx lo1 hi1 lo2 hi2 lo3 hi3)
  ;; (fxif x y z) = (fxior (fxand x y) (fxand (fxnot x) z))
  ;; NOTE: this bound is not strict since x is not independant from (fxnot x)
  (let* ((not1 (type-infer-common-fxnot tctx lo1 hi1))
         (fxand-1-2 (type-infer-common-fxand tctx lo1 hi1 lo2 hi2))
         (fxand-not1-3
           (type-infer-common-fxand
             tctx
             (type-fixnum-lo not1)
             (type-fixnum-hi not1)
             lo2
             hi2))
         (result
           (type-infer-common-fxior
             tctx
             (type-fixnum-lo fxand-1-2)
             (type-fixnum-hi fxand-1-2)
             (type-fixnum-lo fxand-not1-3)
             (type-fixnum-hi fxand-not1-3))))
   result))

(define (infer-fx+ overflow-normalize)
  (type-infer-fold
   (lambda (tctx)
     (make-type-singleton 0))
   (lambda (tctx type)
     type)
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx+ type1 type2)))))

(define (infer-fx- overflow-normalize)
  (type-infer-fold
   #f
   (lambda (tctx type)
     (overflow-normalize
      tctx
      (let ((zero (make-type-singleton 0)))
        (type-infer-fixnum2 tctx type-infer-common-fx- zero type))))
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx- type1 type2)))))

(define (infer-fx* overflow-normalize)
  (type-infer-fold
   (lambda (tctx)
     (make-type-singleton 1))
   (lambda (tctx type)
     type)
   (lambda (tctx type1 type2)
     (overflow-normalize
      tctx
      (type-infer-fixnum2 tctx type-infer-common-fx* type1 type2)))))

(define (infer-fxquotient overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxquotient type1 type2)))))

(define (infer-fxremainder overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxremainder type1 type2)))))

(define (infer-fxmodulo overflow-normalize)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (overflow-normalize
       tctx
       (type-infer-fixnum2 tctx type-infer-common-fxmodulo type1 type2)))))

(define (infer-fxior)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxior type1 type2))))

(define (infer-fxxor)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxxor type1 type2))))

(define (infer-fxand)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxand type1 type2))))

(define (infer-fxandc1)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxandc1 type1 type2))))

(define (infer-fxandc2)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxandc2 type1 type2))))

(define (infer-fxorc1)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxorc1 type1 type2))))

(define (infer-fxorc2)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxorc2 type1 type2))))

(define (infer-fxnand)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxnand type1 type2))))

(define (infer-fxnor)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxnor type1 type2))))

(define (infer-fxeqv)
  (lambda (tctx args)
    (let ((type1 (car args))
          (type2 (cadr args)))
      (type-infer-fixnum2 tctx type-infer-common-fxeqv type1 type2))))

(define (infer-fxnot)
  (lambda (tctx args)
    (let ((type (car args)))
      (type-infer-fixnum1 tctx type-infer-common-fxnot type))))

;;; type narrowing

(define (type-narrow-fold narrow2)
  (lambda (tctx args)
    (if (not (pair? args))
        (cons args #f) ;; always true
        (let ((arg1 (car args))
              (rest (cdr args)))
          (if (not (pair? rest))
              (cons args #f) ;; always true
              (let* ((arg2 (car rest))
                     (x (narrow2 tctx arg1 arg2)))
                (if (not (pair? (cdr rest)))
                    x
                    (let ((true (car x))
                          (false (cdr x)))
                      (cond ((not true) ;; always false?
                             (cons #f args))
                            ((not false) ;; always true?
                             (cons args #f))
                            (else
                             (let ((arg1-false (car false)))
                               (let loop ((rev-result-true (list (car true)))
                                          (prev-true (cadr true))
                                          (arg2-false (cadr false))
                                          (i 2)
                                          (lst (cdr rest)))
                                 (if (not (pair? lst))
                                     (cons (reverse (cons prev-true
                                                          rev-result-true))
                                           (cons arg1-false
                                                 (cons arg2-false
                                                       (cdr rest))))
                                     (let* ((x (narrow2 tctx prev-true (car lst)))
                                            (true (car x))
                                            (false (cdr x)))
                                       (if (not true) ;; always false?
                                           (cons #f args)
                                           (loop (cons (car true)
                                                       rev-result-true)
                                                 (cadr true)
                                                 (if (and (= i 2) false)
                                                     (type-union
                                                      tctx
                                                      arg2-false
                                                      (car false)
                                                      #f)
                                                     arg2-false)
                                                 (+ i 1)
                                                 (cdr lst)))))))))))))))))

(define (type-narrow-fx= tctx type1 type2)
  (declare (generic))

  (define (pairwise-equal? . args)
    (define (pairwise-equal?-aux args)
      (if (or (null? args) (null? (cdr args)))
        #t
        (and (equal? (car args) (cadr args)) (pairwise-equal?-aux (cdr args)))))
    (pairwise-equal?-aux args))

  (let* ((f1 (type-motley-force tctx type1))
         (lo1 (type-fixnum-lo f1))
         (hi1 (type-fixnum-hi f1))
         (f2 (type-motley-force tctx type2))
         (lo2 (type-fixnum-lo f2))
         (hi2 (type-fixnum-hi f2))
         (result
          (cond
            ((pairwise-equal? lo1 lo2 hi1 hi2) ;; equal singletons
              (cons (list type1 type2) #f)) ;; always equal
            ((or (type-fixnum-< hi1 lo2)
                (type-fixnum-< hi2 lo1))
              (cons #f (list type1 type2))) ;; never equal
            (else
              (cons (list type1 type2)
                    (list type1 type2))))))
    result))

(define (type-narrow-fx< tctx type1 type2)

  ;; if x<y
  ;;
  ;;  x is in  x.lo .. min(x.hi,y.hi-1)
  ;;  y is in  max(y.lo,x.lo+1) .. y.hi
  ;;
  ;; if x>=y
  ;;
  ;;  x is in  max(x.lo,y.lo) .. x.hi
  ;;  y is in  y.lo .. min(y.hi,x.hi)

  (if (not (and (type-included? tctx type1 type-fixnum)
                (type-included? tctx type2 type-fixnum)))
      (cons (list type1 type2)
            (list type1 type2))
      (let* ((f1 (type-motley-force tctx type1))
             (lo1 (type-fixnum-lo f1))
             (hi1 (type-fixnum-hi f1))
             (f2 (type-motley-force tctx type2))
             (lo2 (type-fixnum-lo f2))
             (hi2 (type-fixnum-hi f2))
             (true-lo1 lo1)
             (true-hi1 (type-fixnum-min-hi hi1 (type-fixnum-dec-hi hi2)))
             (true-lo2 (type-fixnum-max-lo lo2 (type-fixnum-inc-lo lo1)))
             (true-hi2 hi2)
             (false-lo1 (type-fixnum-max-lo lo1 lo2))
             (false-hi1 hi1)
             (false-lo2 lo2)
             (false-hi2 (type-fixnum-min-hi hi2 hi1)))
        (cond ((or (type-fixnum-< true-hi1 true-lo1) ;; true case impossible?
                   (type-fixnum-< true-hi2 true-lo2))
               (cons #f
                     (list type1 type2)))
              ((or (type-fixnum-< false-hi1 false-lo1) ;; false case impossible?
                   (type-fixnum-< false-hi2 false-lo2))
               (cons (list type1 type2)
                     #f))
              (else
               (cons (list (type-motley-normalize
                            tctx
                            (make-type-fixnum-bounded
                             tctx
                             true-lo1
                             true-hi1))
                           (type-motley-normalize
                            tctx
                            (make-type-fixnum-bounded
                             tctx
                             true-lo2
                             true-hi2)))
                     (list (type-motley-normalize
                            tctx
                            (make-type-fixnum-bounded
                             tctx
                             false-lo1
                             false-hi1))
                           (type-motley-normalize
                            tctx
                            (make-type-fixnum-bounded
                             tctx
                             false-lo2
                             false-hi2)))))))))

(define (type-narrow-fx> tctx type1 type2)
  (type-narrow-swap-args
   (type-narrow-fx< tctx type2 type1)))

(define (type-narrow-fx>= tctx type1 type2)
  (type-narrow-invert
   (type-narrow-fx< tctx type1 type2)))

(define (type-narrow-fx<= tctx type1 type2)
  (type-narrow-invert
   (type-narrow-swap-args
    (type-narrow-fx< tctx type2 type1))))

(define (type-narrow-fl< tctx type1 type2)
  (cons (list type1 type2)
        (list type1 type2)))

(define (type-narrow-fl> tctx type1 type2)
  (type-narrow-swap-args
   (type-narrow-fl< tctx type2 type1)))

(define (type-narrow-fl>= tctx type1 type2)
  (type-narrow-invert
   (type-narrow-fl< tctx type1 type2)))

(define (type-narrow-fl<= tctx type1 type2)
  (type-narrow-invert
   (type-narrow-swap-args
    (type-narrow-fl< tctx type2 type1))))

(define (type-narrow-invert true-false)
  (let ((true  (car true-false))
        (false (cdr true-false)))
    (cons false true)))

(define (type-narrow-swap-args true-false)

  (define (swap lst)
    (and lst (list (cadr lst) (car lst))))

  (let ((true  (car true-false))
        (false (cdr true-false)))
    (cons (swap true) (swap false))))

(define (type-narrow-type-test tctx type arg)
  (let* ((a (type-motley-force tctx arg))
         (inter (type-motley-intersection type a)))
    (if (type-bot? inter) ;; arg does not intersect with type?
        (cons #f ;; true branch impossible because arg not in type
              (list arg))
        (cons (list (type-motley-normalize tctx inter))
              (let ((diff (type-motley-difference a type)))
                (if (type-bot? diff)
                    #f ;; false branch impossible because arg is in type
                    (list (type-motley-normalize tctx diff))))))))

(define (type-narrow-false tctx arg)
  (type-narrow-type-test tctx type-motley-false arg))

(define (proc-type->type tctx type)
  (case (type-name type)
    ((boolean)
     type-boolean)
    ((fixnum)
     type-fixnum)
    ((?fixnum)
     type-fixnum-or-false)
    ((fix>=0)
     (make-type-fixnum 0 '<=))
    ((?fix>=0)
     (make-type-fixnum-or-false 0 '<=))
    ((?fix>=0<=9)
     (make-type-fixnum-or-false 0 9))
    ((fix>=-1)
     (make-type-fixnum -1 '<=))
    ((flonum)
     type-flonum)
    ((char)
     type-char)
    ((symbol)
     type-symbol)
    ((keyword)
     type-keyword)
    ((string)
     type-string)
    ((vector)
     type-vector)
    ((pair)
     type-pair)
    ((procedure)
     type-procedure)
    ((box)
     type-box)
    ((u8)
     (make-type-fixnum 0 255))
    ((s8)
     (make-type-fixnum -128 127))
    ((u16)
     (make-type-fixnum 0 65535))
    ((s16)
     (make-type-fixnum -32768 32767))
    ((number)
     type-number)
    ((integer real)
     type-real)
    ((list port
           s8vector u8vector s16vector u16vector
           s32 s32vector u32 u32vector s64 s64vector u64 u64vector
           f32vector f64vector
           #f)
     type-top) ;;TODO: refine
    (else
     (compiler-internal-error
      "proc-type->type, unknown 'type':" type))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (make-tctx)
  (declare (generic))

  (define tag-bits 2)

  (define smallest-min-fixnum (- (expt 2 (- (- 32 tag-bits) 1))))
  (define smallest-max-fixnum (- (expt 2 (- (- 32 tag-bits) 1)) 1))

  (define largest-min-fixnum (- (expt 2 (- (- 64 tag-bits) 1))))
  (define largest-max-fixnum (- (expt 2 (- (- 64 tag-bits) 1)) 1))

  (vector smallest-min-fixnum
          smallest-max-fixnum
          largest-min-fixnum
          largest-max-fixnum))

(define (tctx-smallest-min-fixnum tctx) (vector-ref tctx 0))
(define (tctx-smallest-max-fixnum tctx) (vector-ref tctx 1))
(define (tctx-largest-min-fixnum tctx)  (vector-ref tctx 2))
(define (tctx-largest-max-fixnum tctx)  (vector-ref tctx 3))


;; obsolete?

(define (tctx-smallest-fixnum? tctx val)
  (and (exact-integer? val)
       (>= val (tctx-smallest-min-fixnum tctx))
       (<= val (tctx-smallest-max-fixnum tctx))))

(define (tctx-largest-fixnum? tctx val)
  (and (exact-integer? val)
       (>= val (tctx-largest-min-fixnum tctx))
       (<= val (tctx-largest-max-fixnum tctx))))

(define (tctx-false? tctx val)
  (false-object? val))

(define (tctx-fixnum? tctx val)
  (cond ((tctx-smallest-fixnum? tctx val)
         #t)
        ((tctx-largest-fixnum? tctx val)
         'maybe)
        (else
          #f)))

(define (tctx-flonum? tctx val)
  (flonum? val))

(define (tctx-char? tctx val)
  (char? val))

(define (tctx-symbol? tctx val)
  (symbol-object? val))

(define (tctx-keyword? tctx val)
  (keyword-object? val))

(define (tctx-string? tctx val)
  (string? val))

(define (tctx-vector? tctx val)
  (vector-object? val))

(define (tctx-pair? tctx val)
  (pair? val))

(define (tctx-procedure? tctx val)
  (proc-obj? val))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (setup-prims target)
  (setup-prim-specializers target)
  (setup-prim-expanders target)
  (setup-prim-simplifiers target)
  (setup-prim-typers target))

;;;============================================================================

;;; unit tests

(define (test-types)

(define prim-fx+?         (infer-fx+ type-fixnum-overflow-normalize-false))
(define prim-fx+          (infer-fx+ type-fixnum-overflow-normalize-clamp))
(define prim-fxwrap+      (infer-fx+ type-fixnum-overflow-normalize-wrap))

(define prim-fx-?         (infer-fx- type-fixnum-overflow-normalize-false))
(define prim-fx-          (infer-fx- type-fixnum-overflow-normalize-clamp))
(define prim-fxwrap-      (infer-fx- type-fixnum-overflow-normalize-wrap))

(define prim-fx*?         (infer-fx* type-fixnum-overflow-normalize-false))
(define prim-fx*          (infer-fx* type-fixnum-overflow-normalize-clamp))
(define prim-fxwrap*      (infer-fx* type-fixnum-overflow-normalize-wrap))

(define prim-fxquotient   (infer-fxquotient type-fixnum-overflow-normalize-clamp))
(define prim-fxremainder  (infer-fxremainder type-fixnum-overflow-normalize-clamp))
(define prim-fxmodulo     (infer-fxmodulo type-fixnum-overflow-normalize-clamp))

(define prim-fxior        (infer-fxior))
(define prim-fxxor        (infer-fxxor))
(define prim-fxand        (infer-fxand))
(define prim-fxandc1      (infer-fxandc1))
(define prim-fxandc2      (infer-fxandc2))
(define prim-fxorc1       (infer-fxorc1))
(define prim-fxorc2       (infer-fxorc2))
(define prim-fxnand       (infer-fxnand))
(define prim-fxnor        (infer-fxnor))
(define prim-fxeqv        (infer-fxeqv))
(define prim-fxnot        (infer-fxnot))

(define (ft type)
  (string-concatenate (format-type type)))

(define (make-tctx-test)

  ;; For testing, assume fixnums only have 4 bits

  (define smallest-min-fixnum -8)
  (define smallest-max-fixnum 7)

  (vector smallest-min-fixnum
          smallest-max-fixnum
          smallest-min-fixnum
          smallest-max-fixnum))

(define tctx (make-tctx-test))

(define (for-each-fixnum-range tctx proc)
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (let loop1 ((lo min-fixnum))
      (if (<= lo max-fixnum)
          (let loop2 ((hi (max lo (+ min-fixnum 2))))
            (if (<= hi max-fixnum)
                (let ((type
                       (type-motley-normalize
                        tctx
                        (make-type-fixnum
                         (type-fixnum-normalize-lo tctx lo)
                         (type-fixnum-normalize-hi tctx hi)))))
                  (proc type)
                  (loop2 (+ hi 1)))
                (loop1 (+ lo 1))))))))

(define (for-each-fixnum-range-pair tctx proc)
  (for-each-fixnum-range
   tctx
   (lambda (type1)
     (for-each-fixnum-range
      tctx
      (lambda (type2)
        (proc type1 type2))))))

(define (type-fixnum->list tctx type)
  (let ((range (type-fixnum-range tctx type)))
    (iota (+ 1 (- (cdr range) (car range))) (car range))))

(define (test-prim1 prim fn name)
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (for-each-fixnum-range
     tctx
     (lambda (type)
       (let* ((result
               (type-motley-force tctx (prim tctx (list type))))
              (result-range
               (type-fixnum-range tctx result))
              (lst
               (type-fixnum->list tctx (type-motley-force tctx type))))
         (for-each
          (lambda (n)
            (let ((r (fn tctx n)))
              (if (and (not (eq? r 'error))
                       (if (not r) ;; result = #f?
                           (= 0 (bitwise-and
                                 (type-motley-bitset result)
                                 type-false-bit))
                           (not (and (>= r (car result-range))
                                     (<= r (cdr result-range))))))
                  (let ()
                    (##namespace ("" pp))
                    (pp `((,name ,n) => ,r which is not in ,result))
                    (exit)))))
          lst))))))

(define (test-prim2 prim fn name)
  (let ((min-fixnum (tctx-smallest-min-fixnum tctx))
        (max-fixnum (tctx-smallest-max-fixnum tctx)))
    (for-each-fixnum-range-pair
     tctx
     (lambda (type1 type2)
       (let* ((result
               (type-motley-force tctx (prim tctx (list type1 type2))))
              (result-range
               (type-fixnum-range tctx result))
              (list1
               (type-fixnum->list tctx (type-motley-force tctx type1)))
              (list2
               (type-fixnum->list tctx (type-motley-force tctx type2))))
         (for-each
          (lambda (n1)
            (for-each
             (lambda (n2)
               (let ((r (fn tctx n1 n2)))
                 (if (and (not (eq? r 'error))
                          (if (not r) ;; result = #f?
                              (= 0 (bitwise-and
                                    (type-motley-bitset result)
                                    type-false-bit))
                              (not (and (>= r (car result-range))
                                        (<= r (cdr result-range))))))
                     (let ()
                       (##namespace ("" pp))
                       (pp `((,name ,n1 ,n2) => ,r which is not in ,result))
                       (exit)))))
             list2))
          list1))))))

(define (clamp fn #!optional no0?)
  (lambda (tctx val1 val2)
    (if (and (= val2 0) no0?)
        'error
        (let ((r (fn val1 val2)))
          (if (or (< r (tctx-smallest-min-fixnum tctx))
                  (> r (tctx-smallest-max-fixnum tctx)))
              'error ;; primitive raises an error on overflow
              r)))))

(define (clamp1 fn)
  (lambda (tctx val1)
      (let ((r (fn val1)))
        (if (or (< r (tctx-smallest-min-fixnum tctx))
                (> r (tctx-smallest-max-fixnum tctx)))
            'error ;; primitive raises an error on overflow
            r))))

(define (false fn #!optional no0?)
  (lambda (tctx val1 val2)
    (if (and (= val2 0) no0?)
        'error
        (let ((r (fn val1 val2)))
          (if (or (< r (tctx-smallest-min-fixnum tctx))
                  (> r (tctx-smallest-max-fixnum tctx)))
              #f ;; primitive returns #f on overflow
              r)))))

(define (wrap fn #!optional no0?)
  (lambda (tctx val1 val2)
    (if (and (= val2 0) no0?)
        'error
        (let ((r (fn val1 val2)))
          (if (or (< r (tctx-smallest-min-fixnum tctx))
                  (> r (tctx-smallest-max-fixnum tctx)))
              ;; primitive returns a wrapped result on overflow
              (+ (modulo (- r (tctx-smallest-min-fixnum tctx))
                         (+ 1 (- (tctx-smallest-max-fixnum tctx)
                                 (tctx-smallest-min-fixnum tctx))))
                 (tctx-smallest-min-fixnum tctx))
              r)))))

(define (clamp-no0 fn) (clamp fn #t))
(define (false-no0 fn) (false fn #t))
(define (wrap-no0 fn)  (wrap fn #t))


(test-prim2 prim-fx+     (clamp ##fx+)     'fx+)
(test-prim2 prim-fx+?    (false ##fx+?)    'fx+?)
(test-prim2 prim-fxwrap+ (wrap  ##fxwrap+) 'fxwrap+)

(test-prim2 prim-fx-     (clamp ##fx-)     'fx-)
(test-prim2 prim-fx-?    (false ##fx-?)    'fx-?)
(test-prim2 prim-fxwrap- (wrap  ##fxwrap-) 'fxwrap-)

(test-prim2 prim-fx*     (clamp ##fx*)     'fx*)
(test-prim2 prim-fx*?    (false ##fx*?)    'fx*?)
(test-prim2 prim-fxwrap* (wrap  ##fxwrap*) 'fxwrap*)

(test-prim2 prim-fxquotient     (clamp-no0 ##fxquotient)     'fxquotient)
;;(test-prim2 prim-fxremainder    (clamp-no0 ##fxremainder)    'fxremainder)
;;(test-prim2 prim-fxmodulo       (clamp-no0 ##fxmodulo)       'fxmodulo)

(test-prim2 prim-fxior   (clamp ##fxior)   'fxior)
(test-prim2 prim-fxxor   (clamp ##fxxor)   'fxxor)
(test-prim2 prim-fxand   (clamp ##fxand)   'fxand)
(test-prim2 prim-fxandc1 (clamp ##fxandc1) 'fxandc1)
(test-prim2 prim-fxandc2 (clamp ##fxandc2) 'fxandc2)
(test-prim2 prim-fxorc1  (clamp ##fxorc1)  'fxorc1)
(test-prim2 prim-fxorc2  (clamp ##fxorc2)  'fxorc2)
(test-prim2 prim-fxnand  (clamp ##fxnand)  'fxnand)
(test-prim2 prim-fxnor   (clamp ##fxnor)   'fxnor)
(test-prim2 prim-fxeqv   (clamp ##fxeqv)   'fxeqv)
(test-prim1 prim-fxnot   (clamp1 ##fxnot)  'fxnot)
)

(define (make-tctx-test)

  ;; For testing, assume fixnums only have 4 bits

  (define smallest-min-fixnum -8)
  (define smallest-max-fixnum 7)

  (vector smallest-min-fixnum
          smallest-max-fixnum
          smallest-min-fixnum
          smallest-max-fixnum))

;;(test-types)
