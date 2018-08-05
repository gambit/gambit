;;;============================================================================

;;; File: "_prims.scm"

;;; Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved.

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
("not"                                (1)   #f 0     0    boolean ieee)
("boolean?"                           (1)   #f 0     0    boolean ieee)
("eqv?"                               (2)   #f 0     0    boolean ieee)
("eq?"                                (2)   #f 0     0    boolean ieee)
("equal?"                             (2)   #f 0     0    boolean ieee)
("pair?"                              (1)   #f 0     0    boolean ieee)
("cons"                               (2)   #f ()    0    pair    ieee)
("car"                                (1)   #f 0     0    (#f)    ieee)
("cdr"                                (1)   #f 0     0    (#f)    ieee)
("set-car!"                           (2)   #t (1)   0    pair    ieee)
("set-cdr!"                           (2)   #t (1)   0    pair    ieee)
("caar"                               (1)   #f 0     0    (#f)    ieee)
("cadr"                               (1)   #f 0     0    (#f)    ieee)
("cdar"                               (1)   #f 0     0    (#f)    ieee)
("cddr"                               (1)   #f 0     0    (#f)    ieee)
("caaar"                              (1)   #f 0     0    (#f)    ieee)
("caadr"                              (1)   #f 0     0    (#f)    ieee)
("cadar"                              (1)   #f 0     0    (#f)    ieee)
("caddr"                              (1)   #f 0     0    (#f)    ieee)
("cdaar"                              (1)   #f 0     0    (#f)    ieee)
("cdadr"                              (1)   #f 0     0    (#f)    ieee)
("cddar"                              (1)   #f 0     0    (#f)    ieee)
("cdddr"                              (1)   #f 0     0    (#f)    ieee)
("caaaar"                             (1)   #f 0     0    (#f)    ieee)
("caaadr"                             (1)   #f 0     0    (#f)    ieee)
("caadar"                             (1)   #f 0     0    (#f)    ieee)
("caaddr"                             (1)   #f 0     0    (#f)    ieee)
("cadaar"                             (1)   #f 0     0    (#f)    ieee)
("cadadr"                             (1)   #f 0     0    (#f)    ieee)
("caddar"                             (1)   #f 0     0    (#f)    ieee)
("cadddr"                             (1)   #f 0     0    (#f)    ieee)
("cdaaar"                             (1)   #f 0     0    (#f)    ieee)
("cdaadr"                             (1)   #f 0     0    (#f)    ieee)
("cdadar"                             (1)   #f 0     0    (#f)    ieee)
("cdaddr"                             (1)   #f 0     0    (#f)    ieee)
("cddaar"                             (1)   #f 0     0    (#f)    ieee)
("cddadr"                             (1)   #f 0     0    (#f)    ieee)
("cdddar"                             (1)   #f 0     0    (#f)    ieee)
("cddddr"                             (1)   #f 0     0    (#f)    ieee)
("null?"                              (1)   #f 0     0    boolean ieee)
("list?"                              (1)   #f 0     0    boolean ieee)
("list"                               0     #f ()    0    list    ieee)
("length"                             (1)   #f 0     0    fixnonneg ieee)
("append"                             0     #f 0     0    list    ieee)
("reverse"                            (1)   #f 0     0    list    ieee)
("list-ref"                           (2)   #f 0     0    (#f)    ieee)
("memq"                               (2)   #f 0     0    list    ieee)
("memv"                               (2)   #f 0     0    list    ieee)
("member"                             (2)   #f 0     0    list    ieee)
("assq"                               (2)   #f 0     0    #f      ieee)
("assv"                               (2)   #f 0     0    #f      ieee)
("assoc"                              (2)   #f 0     0    #f      ieee)
("symbol?"                            (1)   #f 0     0    boolean ieee)
("symbol->string"                     (1)   #f 0     0    string  ieee)
("string->symbol"                     (1)   #f 0     0    symbol  ieee)
("number?"                            (1)   #f 0     0    boolean ieee)
("complex?"                           (1)   #f 0     0    boolean ieee)
("real?"                              (1)   #f 0     0    boolean ieee)
("rational?"                          (1)   #f 0     0    boolean ieee)
("integer?"                           (1)   #f 0     0    boolean ieee)
("exact?"                             (1)   #f 0     0    boolean ieee)
("inexact?"                           (1)   #f 0     0    boolean ieee)
("="                                  0     #f 0     0    boolean ieee)
("<"                                  0     #f 0     0    boolean ieee)
(">"                                  0     #f 0     0    boolean ieee)
("<="                                 0     #f 0     0    boolean ieee)
(">="                                 0     #f 0     0    boolean ieee)
("zero?"                              (1)   #f 0     0    boolean ieee)
("positive?"                          (1)   #f 0     0    boolean ieee)
("negative?"                          (1)   #f 0     0    boolean ieee)
("odd?"                               (1)   #f 0     0    boolean ieee)
("even?"                              (1)   #f 0     0    boolean ieee)
("max"                                1     #f 0     0    number  ieee)
("min"                                1     #f 0     0    number  ieee)
("+"                                  0     #f 0     0    number  ieee)
("*"                                  0     #f 0     0    number  ieee)
("-"                                  1     #f 0     0    number  ieee)
("/"                                  1     #f 0     0    number  ieee)
("abs"                                (1)   #f 0     0    number  ieee)
("quotient"                           (2)   #f 0     0    integer ieee)
("remainder"                          (2)   #f 0     0    integer ieee)
("modulo"                             (2)   #f 0     0    integer ieee)
("gcd"                                1     #f 0     0    integer ieee)
("lcm"                                1     #f 0     0    integer ieee)
("numerator"                          (1)   #f 0     0    integer ieee)
("denominator"                        (1)   #f 0     0    integer ieee)
("floor"                              (1)   #f 0     0    integer ieee)
("ceiling"                            (1)   #f 0     0    integer ieee)
("truncate"                           (1)   #f 0     0    integer ieee)
("round"                              (1)   #f 0     0    integer ieee)
("rationalize"                        (2)   #f 0     0    number  ieee)
("exp"                                (1)   #f 0     0    number  ieee)
("log"                                (1)   #f 0     0    number  ieee)
("sin"                                (1)   #f 0     0    number  ieee)
("cos"                                (1)   #f 0     0    number  ieee)
("tan"                                (1)   #f 0     0    number  ieee)
("asin"                               (1)   #f 0     0    number  ieee)
("acos"                               (1)   #f 0     0    number  ieee)
("atan"                               (1 2) #f 0     0    number  ieee)
("expt"                               (2)   #f 0     0    number  ieee)
("sqrt"                               (1)   #f 0     0    number  ieee)
("make-rectangular"                   (2)   #f 0     0    number  ieee)
("make-polar"                         (2)   #f 0     0    number  ieee)
("real-part"                          (1)   #f 0     0    real    ieee)
("imag-part"                          (1)   #f 0     0    real    ieee)
("magnitude"                          (1)   #f 0     0    real    ieee)
("angle"                              (1)   #f 0     0    real    ieee)
("exact->inexact"                     (1)   #f 0     0    number  ieee)
("inexact->exact"                     (1)   #f 0     0    number  ieee)
("number->string"                     (1 2) #f 0     0    string  ieee)
("string->number"                     (1 2) #f 0     0    number  ieee)
("char?"                              (1)   #f 0     0    boolean ieee)
("char=?"                             0     #f 0     0    boolean ieee)
("char<?"                             0     #f 0     0    boolean ieee)
("char>?"                             0     #f 0     0    boolean ieee)
("char<=?"                            0     #f 0     0    boolean ieee)
("char>=?"                            0     #f 0     0    boolean ieee)
("char-ci=?"                          0     #f 0     0    boolean ieee)
("char-ci<?"                          0     #f 0     0    boolean ieee)
("char-ci>?"                          0     #f 0     0    boolean ieee)
("char-ci<=?"                         0     #f 0     0    boolean ieee)
("char-ci>=?"                         0     #f 0     0    boolean ieee)
("char-alphabetic?"                   (1)   #f 0     0    boolean ieee)
("char-numeric?"                      (1)   #f 0     0    boolean ieee)
("char-whitespace?"                   (1)   #f 0     0    boolean ieee)
("char-upper-case?"                   (1)   #f 0     0    boolean ieee)
("char-lower-case?"                   (1)   #f 0     0    boolean ieee)
("char->integer"                      (1)   #f 0     0    integer ieee)
("integer->char"                      (1)   #f 0     0    char    ieee)
("char-upcase"                        (1)   #f 0     0    char    ieee)
("char-downcase"                      (1)   #f 0     0    char    ieee)
("string?"                            (1)   #f 0     0    boolean ieee)
("make-string"                        (1 2) #f 0     0    string  ieee)
("string"                             0     #f 0     0    string  ieee)
("string-length"                      (1)   #f 0     0    fixnonneg ieee)
("string-ref"                         (2)   #f 0     0    char    ieee)
("string-set!"                        (3)   #t 0     0    string  ieee)
("string=?"                           0     #f 0     0    boolean ieee)
("string<?"                           0     #f 0     0    boolean ieee)
("string>?"                           0     #f 0     0    boolean ieee)
("string<=?"                          0     #f 0     0    boolean ieee)
("string>=?"                          0     #f 0     0    boolean ieee)
("string-ci=?"                        0     #f 0     0    boolean ieee)
("string-ci<?"                        0     #f 0     0    boolean ieee)
("string-ci>?"                        0     #f 0     0    boolean ieee)
("string-ci<=?"                       0     #f 0     0    boolean ieee)
("string-ci>=?"                       0     #f 0     0    boolean ieee)
("substring"                          (3)   #f 0     0    string  ieee)
("string-append"                      0     #f 0     0    string  ieee)
("vector?"                            (1)   #f 0     0    boolean ieee)
("make-vector"                        (1 2) #f (1)   0    vector  ieee)
("vector"                             0     #f ()    0    vector  ieee)
("vector-length"                      (1)   #f 0     0    fixnonneg ieee)
("vector-ref"                         (2)   #f 0     0    (#f)    ieee)
("vector-set!"                        (3)   #t (1 2) 0    vector  ieee)
("procedure?"                         (1)   #f 0     0    boolean ieee)
("apply"                              2     #t 0     0    (#f)    ieee)
("map"                                2     #t 0     0    list    ieee)
("for-each"                           2     #t 0     0    #f      ieee)
("call-with-current-continuation"     1     #t 0     1113 (#f)    ieee)
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
("eof-object?"                        (1)   #f 0     0    boolean ieee)
("read"                               (0 1) #t 0     0    #f      ieee)
("read-char"                          (0 1) #t 0     0    #f      ieee)
("peek-char"                          (0 1) #t 0     0    #f      ieee)
("write"                              (1 2) #t 0     0    #f      ieee)
("display"                            (1 2) #t 0     0    #f      ieee)
("newline"                            (0 1) #t 0     0    #f      ieee)
("write-char"                         (1 2) #t 0     0    #f      ieee)

;; for R4RS Scheme

("list-tail"                          (2)   #f 0     0    (#f)    r4rs)
("string->list"                       (1)   #f 0     0    list    r4rs)
("list->string"                       (1)   #f 0     0    string  r4rs)
("string-copy"                        (1)   #f 0     0    string  r4rs)
("string-fill!"                       (2)   #t 0     0    string  r4rs)
("vector->list"                       (1)   #f 0     0    list    r4rs)
("list->vector"                       (1)   #f 0     0    vector  r4rs)
("vector-fill!"                       (2)   #t 0     0    vector  r4rs)
("force"                              (1)   #t 0     0    #f      r4rs)
("with-input-from-file"               (2)   #t 0     0    (#f)    r4rs)
("with-output-to-file"                (2)   #t 0     0    (#f)    r4rs)
("char-ready?"                        (0 1) #f 0     0    boolean r4rs)
("load"                               (1)   #t 0     0    (#f)    r4rs)
("transcript-on"                      (1)   #t 0     0    #f      r4rs)
("transcript-off"                     (0)   #t 0     0    #f      r4rs)

;; for R5RS Scheme

("values"                             0     #f ()    0    (#f)    r5rs)
("call-with-values"                   (2)   #t 0     0    (#f)    r5rs)
("dynamic-wind"                       (3)   #t 0     0    (#f)    r5rs)
("eval"                               (1 2) #t 0     0    (#f)    r5rs)
("interaction-environment"            (0)   #f 0     0    #f      r5rs)
("null-environment"                   (0)   #f 0     0    #f      r5rs)
("scheme-report-environment"          (1)   #f 0     0    #f      r5rs)

;; for R6RS Scheme

("fixnum?"                            (1)   #f 0     0    boolean r6rs)
("fx="                                0     #f 0     0    boolean r6rs)
("fx<"                                0     #f 0     0    boolean r6rs)
("fx>"                                0     #f 0     0    boolean r6rs)
("fx<="                               0     #f 0     0    boolean r6rs)
("fx>="                               0     #f 0     0    boolean r6rs)
("fxzero?"                            (1)   #f 0     0    boolean r6rs)
("fxpositive?"                        (1)   #f 0     0    boolean r6rs)
("fxnegative?"                        (1)   #f 0     0    boolean r6rs)
("fxodd?"                             (1)   #f 0     0    boolean r6rs)
("fxeven?"                            (1)   #f 0     0    boolean r6rs)
("fxmax"                              1     #f 0     0    fixnum  r6rs)
("fxmin"                              1     #f 0     0    fixnum  r6rs)
("fxwrap+"                            0     #f 0     0    fixnum  r6rs)
("fx+"                                0     #f 0     0    fixnum  r6rs)
("fxwrap*"                            0     #f 0     0    fixnum  r6rs)
("fx*"                                0     #f 0     0    fixnum  r6rs)
("fxwrap-"                            1     #f 0     0    fixnum  r6rs)
("fx-"                                1     #f 0     0    fixnum  r6rs)
("fxwrapquotient"                     (2)   #f 0     0    fixnum  r6rs)
("fxquotient"                         (2)   #f 0     0    fixnum  r6rs)
("fxremainder"                        (2)   #f 0     0    fixnum  r6rs)
("fxmodulo"                           (2)   #f 0     0    fixnum  r6rs)
("fxnot"                              (1)   #f 0     0    fixnum  r6rs)
("fxand"                              0     #f 0     0    fixnum  r6rs)
("fxior"                              0     #f 0     0    fixnum  r6rs)
("fxxor"                              0     #f 0     0    fixnum  r6rs)
("fxif"                               (3)   #f 0     0    fixnum  r6rs)
("fxbit-count"                        (1)   #f 0     0    fixnum  r6rs)
("fxlength"                           (1)   #f 0     0    fixnum  r6rs)
("fxfirst-bit-set"                    (1)   #f 0     0    fixnum  r6rs)
("fxbit-set?"                         (2)   #f 0     0    fixnum  r6rs)
("fxwraparithmetic-shift"             (2)   #f 0     0    fixnum  r6rs)
("fxarithmetic-shift"                 (2)   #f 0     0    fixnum  r6rs)
("fxwraparithmetic-shift-left"        (2)   #f 0     0    fixnum  r6rs)
("fxarithmetic-shift-left"            (2)   #f 0     0    fixnum  r6rs)
("fxarithmetic-shift-right"           (2)   #f 0     0    fixnum  r6rs)
("fxwraplogical-shift-right"          (2)   #f 0     0    fixnum  r6rs)
("fxwrapabs"                          (1)   #f 0     0    fixnum  gambit)
("fxabs"                              (1)   #f 0     0    fixnum  gambit)
("fxwrapsquare"                       (1)   #f 0     0    fixnum  gambit)
("fxsquare"                           (1)   #f 0     0    fixnum  gambit)
("flonum?"                            (1)   #f 0     0    boolean r6rs)
("fl="                                0     #f 0     0    boolean r6rs)
("fl<"                                0     #f 0     0    boolean r6rs)
("fl>"                                0     #f 0     0    boolean r6rs)
("fl<="                               0     #f 0     0    boolean r6rs)
("fl>="                               0     #f 0     0    boolean r6rs)
("flinteger?"                         (1)   #f 0     0    boolean r6rs)
("flzero?"                            (1)   #f 0     0    boolean r6rs)
("flpositive?"                        (1)   #f 0     0    boolean r6rs)
("flnegative?"                        (1)   #f 0     0    boolean r6rs)
("flodd?"                             (1)   #f 0     0    boolean r6rs)
("fleven?"                            (1)   #f 0     0    boolean r6rs)
("flfinite?"                          (1)   #f 0     0    boolean r6rs)
("flinfinite?"                        (1)   #f 0     0    boolean r6rs)
("flnan?"                             (1)   #f 0     0    boolean r6rs)
("flmax"                              1     #f 0     0    flonum  r6rs)
("flmin"                              1     #f 0     0    flonum  r6rs)
("fl+"                                0     #f 0     0    flonum  r6rs)
("fl*"                                0     #f 0     0    flonum  r6rs)
("fl-"                                1     #f 0     0    flonum  r6rs)
("fl/"                                1     #f 0     0    flonum  r6rs)
("flabs"                              (1)   #f 0     0    flonum  r6rs)
("flnumerator"                        (1)   #f 0     0    flonum  r6rs)
("fldenominator"                      (1)   #f 0     0    flonum  r6rs)
("flfloor"                            (1)   #f 0     0    flonum  r6rs)
("flceiling"                          (1)   #f 0     0    flonum  r6rs)
("fltruncate"                         (1)   #f 0     0    flonum  r6rs)
("flround"                            (1)   #f 0     0    flonum  r6rs)
("flscalbn"                           (2)   #f 0     0    flonum  gambit)
("flilogb"                            (1)   #f 0     0    fixnum  gambit)
("flexp"                              (1)   #f 0     0    flonum  r6rs)
("flexpm1"                            (1)   #f 0     0    flonum  gambit)
;("expm1"                              (1)   #f 0     0    number  gambit)
("fllog"                              (1)   #f 0     0    flonum  r6rs)
("fllog1p"                            (1)   #f 0     0    flonum  gambit)
;("log1p"                              (1)   #f 0     0    number  gambit)
("flsin"                              (1)   #f 0     0    flonum  r6rs)
("flcos"                              (1)   #f 0     0    flonum  r6rs)
("fltan"                              (1)   #f 0     0    flonum  r6rs)
("flasin"                             (1)   #f 0     0    flonum  r6rs)
("flacos"                             (1)   #f 0     0    flonum  r6rs)
("flatan"                             (1 2) #f 0     0    flonum  r6rs)
("flsinh"                             (1)   #f 0     0    flonum  gambit)
("sinh"                               (1)   #f 0     0    number  gambit)
("flcosh"                             (1)   #f 0     0    flonum  gambit)
("cosh"                               (1)   #f 0     0    number  gambit)
("fltanh"                             (1)   #f 0     0    flonum  gambit)
("tanh"                               (1)   #f 0     0    number  gambit)
("flasinh"                            (1)   #f 0     0    flonum  gambit)
("asinh"                              (1)   #f 0     0    number  gambit)
("flacosh"                            (1)   #f 0     0    flonum  gambit)
("acosh"                              (1)   #f 0     0    number  gambit)
("flatanh"                            (1)   #f 0     0    flonum  gambit)
("atanh"                              (1)   #f 0     0    number  gambit)
("flexpt"                             (2)   #f 0     0    flonum  r6rs)
("flsqrt"                             (1)   #f 0     0    flonum  r6rs)
("flsquare"                           (1)   #f 0     0    flonum  gambit)
("square"                             (1)   #f 0     0    number  gambit)
("fixnum->flonum"                     (1)   #f 0     0    flonum  r6rs)

("finite?"                            (1)   #f 0     0    boolean r6rs)
("infinite?"                          (1)   #f 0     0    boolean r6rs)
("nan?"                               (1)   #f 0     0    boolean r6rs)

;; for Multilisp

("touch"                              (1)   #t 0     0    #f      multilisp)

;; for DSSSL

("keyword?"                           (1)   #f 0     0    boolean gambit)
("keyword->string"                    (1)   #f 0     0    string  gambit)
("string->keyword"                    (1)   #f 0     0    keyword gambit)

;; other

("identity"                           (1)   #f 0     0    (#f)    gambit)

("void"                               (0)   #f 0     0    #f      gambit)

("will?"                              (1)   #f 0     0    boolean gambit)
("make-will"                          (2)   #t (2)   0    #f      gambit)
("will-testator"                      (1)   #f 0     0    (#f)    gambit)

("box?"                               (1)   #f 0     0    boolean gambit)
("box"                                (1)   #f ()    0    #f      gambit)
("unbox"                              (1)   #f 0     0    (#f)    gambit)
("set-box!"                           (2)   #t (1)   0    #f      gambit)

("vector-cas!"                        (4)   #t (1 2 4) 0  (#f)    gambit)
("vector-inc!"                        (2 3) #t 0     0    fixnum  gambit)

("s8vector?"                          (1)   #f 0     0    boolean gambit)
("s8vector"                           0     #f 0     0    s8vector gambit)
("make-s8vector"                      (1 2) #f 0     0    s8vector gambit)
("s8vector-length"                    (1)   #f 0     0    fixnonneg gambit)
("s8vector-ref"                       (2)   #f 0     0    s8      gambit)
("s8vector-set!"                      (3)   #t 0     0    #f      gambit)
("s8vector->list"                     (1)   #f 0     0    list    gambit)
("list->s8vector"                     (1)   #f 0     0    s8vector gambit)

("u8vector?"                          (1)   #f 0     0    boolean gambit)
("u8vector"                           0     #f 0     0    u8vector gambit)
("make-u8vector"                      (1 2) #f 0     0    u8vector gambit)
("u8vector-length"                    (1)   #f 0     0    fixnonneg gambit)
("u8vector-ref"                       (2)   #f 0     0    u8      gambit)
("u8vector-set!"                      (3)   #t 0     0    #f      gambit)
("u8vector->list"                     (1)   #f 0     0    list    gambit)
("list->u8vector"                     (1)   #f 0     0    u8vector gambit)

("s16vector?"                         (1)   #f 0     0    boolean gambit)
("s16vector"                          0     #f 0     0    s16vector gambit)
("make-s16vector"                     (1 2) #f 0     0    s16vector gambit)
("s16vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("s16vector-ref"                      (2)   #f 0     0    s16     gambit)
("s16vector-set!"                     (3)   #t 0     0    #f      gambit)
("s16vector->list"                    (1)   #f 0     0    list    gambit)
("list->s16vector"                    (1)   #f 0     0    s16vector gambit)

("u16vector?"                         (1)   #f 0     0    boolean gambit)
("u16vector"                          0     #f 0     0    u16vector gambit)
("make-u16vector"                     (1 2) #f 0     0    u16vector gambit)
("u16vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("u16vector-ref"                      (2)   #f 0     0    u16     gambit)
("u16vector-set!"                     (3)   #t 0     0    #f      gambit)
("u16vector->list"                    (1)   #f 0     0    list    gambit)
("list->u16vector"                    (1)   #f 0     0    u16vector gambit)

("s32vector?"                         (1)   #f 0     0    boolean gambit)
("s32vector"                          0     #f 0     0    s32vector gambit)
("make-s32vector"                     (1 2) #f 0     0    s32vector gambit)
("s32vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("s32vector-ref"                      (2)   #f 0     0    s32     gambit)
("s32vector-set!"                     (3)   #t 0     0    #f      gambit)
("s32vector->list"                    (1)   #f 0     0    list    gambit)
("list->s32vector"                    (1)   #f 0     0    s32vector gambit)

("u32vector?"                         (1)   #f 0     0    boolean gambit)
("u32vector"                          0     #f 0     0    u32vector gambit)
("make-u32vector"                     (1 2) #f 0     0    u32vector gambit)
("u32vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("u32vector-ref"                      (2)   #f 0     0    u32     gambit)
("u32vector-set!"                     (3)   #t 0     0    #f      gambit)
("u32vector->list"                    (1)   #f 0     0    list    gambit)
("list->u32vector"                    (1)   #f 0     0    u32vector gambit)

("s64vector?"                         (1)   #f 0     0    boolean gambit)
("s64vector"                          0     #f 0     0    s64vector gambit)
("make-s64vector"                     (1 2) #f 0     0    s64vector gambit)
("s64vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("s64vector-ref"                      (2)   #f 0     0    s64     gambit)
("s64vector-set!"                     (3)   #t 0     0    #f      gambit)
("s64vector->list"                    (1)   #f 0     0    list    gambit)
("list->s64vector"                    (1)   #f 0     0    s64vector gambit)

("u64vector?"                         (1)   #f 0     0    boolean gambit)
("u64vector"                          0     #f 0     0    u64vector gambit)
("make-u64vector"                     (1 2) #f 0     0    u64vector gambit)
("u64vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("u64vector-ref"                      (2)   #f 0     0    u64     gambit)
("u64vector-set!"                     (3)   #t 0     0    #f      gambit)
("u64vector->list"                    (1)   #f 0     0    list    gambit)
("list->u64vector"                    (1)   #f 0     0    u64vector gambit)

("f32vector?"                         (1)   #f 0     0    boolean gambit)
("f32vector"                          0     #f 0     0    f32vector gambit)
("make-f32vector"                     (1 2) #f 0     0    f32vector gambit)
("f32vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("f32vector-ref"                      (2)   #f 0     0    flonum  gambit)
("f32vector-set!"                     (3)   #t 0     0    #f      gambit)
("f32vector->list"                    (1)   #f 0     0    list    gambit)
("list->f32vector"                    (1)   #f 0     0    f32vector gambit)

("f64vector?"                         (1)   #f 0     0    boolean gambit)
("f64vector"                          0     #f 0     0    f64vector gambit)
("make-f64vector"                     (1 2) #f 0     0    f64vector gambit)
("f64vector-length"                   (1)   #f 0     0    fixnonneg gambit)
("f64vector-ref"                      (2)   #f 0     0    flonum  gambit)
("f64vector-set!"                     (3)   #t 0     0    #f      gambit)
("f64vector->list"                    (1)   #f 0     0    list    gambit)
("list->f64vector"                    (1)   #f 0     0    f64vector gambit)

("bitwise-ior"                        0     #f 0     0    integer gambit)
("bitwise-xor"                        0     #f 0     0    integer gambit)
("bitwise-and"                        0     #f 0     0    integer gambit)
("bitwise-not"                        (1)   #f 0     0    integer gambit)
("arithmetic-shift"                   (2)   #f 0     0    integer gambit)

("call/cc"                            1     #t 0     1113 (#f)    gambit)

("continuation?"                      (1)   #f 0     0    boolean gambit)
("continuation-capture"               1     #t 0     1113 (#f)    gambit)
("continuation-graft"                 2     #t 0     2203 #f      gambit)
("continuation-return"                (2)   #t 0     0    #f      gambit)

;; for system interface

("##type"                             (1)   #f ()    0    integer extended)
("##type-cast"                        (2)   #f ()    0    (#f)    extended)
("##subtype"                          (1)   #f ()    0    integer extended)
("##subtype-set!"                     (2)   #t ()    0    #f      extended)

("##not"                              (1)   #f ()    0    boolean extended)
("##boolean?"                         (1)   #f ()    0    boolean extended)
("##null?"                            (1)   #f ()    0    boolean extended)
("##false-or-null?"                   (1)   #f ()    0    boolean extended)
("##false-or-void?"                   (1)   #f ()    0    boolean extended)
("##unbound?"                         (1)   #f ()    0    boolean extended)
("##eq?"                              (2)   #f ()    0    boolean extended)
("##eqv?"                             (2)   #f ()    0    boolean extended)
("##equal?"                           (2)   #f ()    0    boolean extended)
("##eof-object?"                      (1)   #f ()    0    boolean extended)

("##fixnum?"                          (1)   #f ()    0    boolean extended)
("##pair?"                            (1)   #f ()    0    boolean extended)
("##vector?"                          (1)   #f ()    0    boolean extended)
("##ratnum?"                          (1)   #f ()    0    boolean extended)
("##cpxnum?"                          (1)   #f ()    0    boolean extended)
("##structure?"                       (1)   #f ()    0    boolean extended)
("##box?"                             (1)   #f ()    0    boolean extended)
("##values?"                          (1)   #f ()    0    boolean extended)
("##symbol?"                          (1)   #f ()    0    boolean extended)
("##keyword?"                         (1)   #f ()    0    boolean extended)
("##frame?"                           (1)   #f ()    0    boolean extended)
("##continuation?"                    (1)   #f ()    0    boolean extended)
("##promise?"                         (1)   #f ()    0    boolean extended)
("##will?"                            (1)   #f ()    0    boolean extended)
("##procedure?"                       (1)   #f ()    0    boolean extended)
("##subprocedure?"                    (1)   #f ()    0    boolean extended)
("##closure?"                         (1)   #f ()    0    boolean extended)
("##return?"                          (1)   #f ()    0    boolean extended)
("##foreign?"                         (1)   #f ()    0    boolean extended)
("##string?"                          (1)   #f ()    0    boolean extended)
("##s8vector?"                        (1)   #f ()    0    boolean extended)
("##u8vector?"                        (1)   #f ()    0    boolean extended)
("##s16vector?"                       (1)   #f ()    0    boolean extended)
("##u16vector?"                       (1)   #f ()    0    boolean extended)
("##s32vector?"                       (1)   #f ()    0    boolean extended)
("##u32vector?"                       (1)   #f ()    0    boolean extended)
("##s64vector?"                       (1)   #f ()    0    boolean extended)
("##u64vector?"                       (1)   #f ()    0    boolean extended)
("##f32vector?"                       (1)   #f ()    0    boolean extended)
("##f64vector?"                       (1)   #f ()    0    boolean extended)
("##flonum?"                          (1)   #f ()    0    boolean extended)
("##bignum?"                          (1)   #f ()    0    boolean extended)
("##char?"                            (1)   #f ()    0    boolean extended)
("##number?"                          (1)   #f ()    0    boolean extended)
("##complex?"                         (1)   #f ()    0    boolean extended)
("##real?"                            (1)   #f ()    0    boolean extended)
("##rational?"                        (1)   #f ()    0    boolean extended)
("##integer?"                         (1)   #f ()    0    boolean extended)
("##exact?"                           (1)   #f ()    0    boolean extended)
("##inexact?"                         (1)   #f ()    0    boolean extended)
("##mutable?"                         (1)   #f ()    0    boolean extended)

("##special?"                         (1)   #f ()    0    boolean extended)
("##meroon?"                          (1)   #f ()    0    boolean extended)
("##jazz?"                            (1)   #f ()    0    boolean extended)
("##gc-hash-table?"                   (1)   #f ()    0    boolean extended)
("##mem-allocated?"                   (1)   #f ()    0    boolean extended)
("##subtyped?"                        (1)   #f ()    0    boolean extended)
("##subtyped.vector?"                 (1)   #f ()    0    boolean extended)
("##subtyped.symbol?"                 (1)   #f ()    0    boolean extended)
("##subtyped.flonum?"                 (1)   #f ()    0    boolean extended)
("##subtyped.bignum?"                 (1)   #f ()    0    boolean extended)

("##fxmax"                       1     #f ()    0    fixnum  extended)
("##fxmin"                       1     #f ()    0    fixnum  extended)
("##fxwrap+"                     0     #f ()    0    fixnum  extended)
("##fx+"                         0     #f ()    0    fixnum  extended)
("##fx+?"                        (2)   #f ()    0    ?fixnum extended)
("##fxwrap*"                     0     #f ()    0    fixnum  extended)
("##fx*"                         0     #f ()    0    fixnum  extended)
("##fx*?"                        (2)   #f ()    0    ?fixnum extended)
("##fxwrap-"                     1     #f ()    0    fixnum  extended)
("##fx-"                         1     #f ()    0    fixnum  extended)
("##fx-?"                        (1 2) #f ()    0    ?fixnum extended)
("##fxwrapquotient"              (2)   #f ()    0    fixnum  extended)
("##fxquotient"                  (2)   #f ()    0    fixnum  extended)
("##fxremainder"                 (2)   #f ()    0    fixnum  extended)
("##fxmodulo"                    (2)   #f ()    0    fixnum  extended)
("##fxnot"                       (1)   #f ()    0    fixnum  extended)
("##fxand"                       0     #f ()    0    fixnum  extended)
("##fxior"                       0     #f ()    0    fixnum  extended)
("##fxxor"                       0     #f ()    0    fixnum  extended)
("##fxif"                        (3)   #f ()    0    fixnum  extended)
("##fxbit-count"                 (1)   #f ()    0    fixnum  extended)
("##fxlength"                    (1)   #f ()    0    fixnum  extended)
("##fxfirst-bit-set"             (1)   #f ()    0    fixnum  extended)
("##fxbit-set?"                  (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift"      (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift?"     (2)   #f ()    0    ?fixnum extended)
("##fxarithmetic-shift"          (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift?"         (2)   #f ()    0    ?fixnum extended)
("##fxwraparithmetic-shift-left" (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift-left?"(2)   #f ()    0    ?fixnum extended)
("##fxarithmetic-shift-left"     (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-left?"    (2)   #f ()    0    ?fixnum extended)
("##fxarithmetic-shift-right"    (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-right?"   (2)   #f ()    0    ?fixnum extended)
("##fxwraplogical-shift-right"   (2)   #f ()    0    fixnum  extended)
("##fxwraplogical-shift-right?"  (2)   #f ()    0    ?fixnum extended)
("##fxwrapabs"                   (1)   #f ()    0    fixnum  extended)
("##fxabs"                       (1)   #f ()    0    fixnum  extended)
("##fxabs?"                      (1)   #f ()    0    ?fixnum extended)
("##fxwrapsquare"                (1)   #f ()    0    fixnum  extended)
("##fxsquare"                    (1)   #f ()    0    fixnum  extended)
("##fxsquare?"                   (1)   #f ()    0    ?fixnum extended)
("##fxzero?"                     (1)   #f ()    0    boolean extended)
("##fxpositive?"                 (1)   #f ()    0    boolean extended)
("##fxnegative?"                 (1)   #f ()    0    boolean extended)
("##fxodd?"                      (1)   #f ()    0    boolean extended)
("##fxeven?"                     (1)   #f ()    0    boolean extended)
("##fx="                         0     #f ()    0    boolean extended)
("##fx<"                         0     #f ()    0    boolean extended)
("##fx>"                         0     #f ()    0    boolean extended)
("##fx<="                        0     #f ()    0    boolean extended)
("##fx>="                        0     #f ()    0    boolean extended)

("##integer->char"               (1)   #f ()    0    char    extended)
("##char->integer"               (1)   #f ()    0    fixnum  extended)
("##flonum->fixnum"              (1)   #f ()    0    fixnum  extended)
("##fixnum->flonum"              (1)   #f ()    0    flonum  extended)
("##fixnum->flonum-exact?"       (1)   #f ()    0    boolean extended)
("##flonum->string-host"         (1)   #f ()    0    string  extended)

("##flmax"                       1     #f ()    0    flonum  extended)
("##flmin"                       1     #f ()    0    flonum  extended)
("##fl+"                         0     #f ()    0    flonum  extended)
("##fl*"                         0     #f ()    0    flonum  extended)
("##fl-"                         1     #f ()    0    flonum  extended)
("##fl/"                         1     #f ()    0    flonum  extended)
("##flabs"                       (1)   #f ()    0    flonum  extended)
("##flfloor"                     (1)   #f ()    0    flonum  extended)
("##flceiling"                   (1)   #f ()    0    flonum  extended)
("##fltruncate"                  (1)   #f ()    0    flonum  extended)
("##flround"                     (1)   #f ()    0    flonum  extended)
("##flscalbn"                    (2)   #f 0     0    flonum  extended)
("##flilogb"                     (1)   #f 0     0    fixnum  extended)
("##flexp"                       (1)   #f ()    0    flonum  extended)
("##flexpm1"                     (1)   #f ()    0    flonum  extended)
("##fllog"                       (1)   #f ()    0    flonum  extended)
("##fllog1p"                     (1)   #f ()    0    flonum  extended)
("##flsin"                       (1)   #f ()    0    flonum  extended)
("##flcos"                       (1)   #f ()    0    flonum  extended)
("##fltan"                       (1)   #f ()    0    flonum  extended)
("##flasin"                      (1)   #f ()    0    flonum  extended)
("##flacos"                      (1)   #f ()    0    flonum  extended)
("##flatan"                      (1 2) #f ()    0    flonum  extended)
("##flsinh"                      (1)   #f ()    0    flonum  extended)
("##flcosh"                      (1)   #f ()    0    flonum  extended)
("##fltanh"                      (1)   #f ()    0    flonum  extended)
("##flasinh"                     (1)   #f ()    0    flonum  extended)
("##flacosh"                     (1)   #f ()    0    flonum  extended)
("##flatanh"                     (1)   #f ()    0    flonum  extended)
("##flexpt"                      (2)   #f ()    0    flonum  extended)
("##flsqrt"                      (1)   #f ()    0    flonum  extended)
("##flsquare"                    (1)   #f ()    0    flonum  extended)
("##flcopysign"                  (2)   #f ()    0    flonum  extended)
("##flinteger?"                  (1)   #f ()    0    boolean extended)
("##flzero?"                     (1)   #f ()    0    boolean extended)
("##flpositive?"                 (1)   #f ()    0    boolean extended)
("##flnegative?"                 (1)   #f ()    0    boolean extended)
("##flodd?"                      (1)   #f ()    0    boolean extended)
("##fleven?"                     (1)   #f ()    0    boolean extended)
("##flfinite?"                   (1)   #f ()    0    boolean extended)
("##flinfinite?"                 (1)   #f ()    0    boolean extended)
("##flnan?"                      (1)   #f ()    0    boolean extended)
("##fl="                         0     #f ()    0    boolean extended)
("##fl<"                         0     #f ()    0    boolean extended)
("##fl>"                         0     #f ()    0    boolean extended)
("##fl<="                        0     #f ()    0    boolean extended)
("##fl>="                        0     #f ()    0    boolean extended)
("##fleqv?"                      (2)   #f ()    0    boolean extended)

("##char=?"                           0     #f ()    0    boolean extended)
("##char<?"                           0     #f ()    0    boolean extended)
("##char>?"                           0     #f ()    0    boolean extended)
("##char<=?"                          0     #f ()    0    boolean extended)
("##char>=?"                          0     #f ()    0    boolean extended)
("##char-alphabetic?"                 (1)   #f ()    0    boolean extended)
("##char-numeric?"                    (1)   #f ()    0    boolean extended)
("##char-whitespace?"                 (1)   #f ()    0    boolean extended)
("##char-upper-case?"                 (1)   #f ()    0    boolean extended)
("##char-lower-case?"                 (1)   #f ()    0    boolean extended)
("##char-upcase"                      (1)   #f ()    0    char    extended)
("##char-downcase"                    (1)   #f ()    0    char    extended)

("##cons"                             (2)   #f ()    0    pair    extended)
("##set-car!"                         (2)   #t ()    0    pair    extended)
("##set-cdr!"                         (2)   #t ()    0    pair    extended)
("##car"                              (1)   #f ()    0    (#f)    extended)
("##cdr"                              (1)   #f ()    0    (#f)    extended)
("##caar"                             (1)   #f ()    0    (#f)    extended)
("##cadr"                             (1)   #f ()    0    (#f)    extended)
("##cdar"                             (1)   #f ()    0    (#f)    extended)
("##cddr"                             (1)   #f ()    0    (#f)    extended)
("##caaar"                            (1)   #f ()    0    (#f)    extended)
("##caadr"                            (1)   #f ()    0    (#f)    extended)
("##cadar"                            (1)   #f ()    0    (#f)    extended)
("##caddr"                            (1)   #f ()    0    (#f)    extended)
("##cdaar"                            (1)   #f ()    0    (#f)    extended)
("##cdadr"                            (1)   #f ()    0    (#f)    extended)
("##cddar"                            (1)   #f ()    0    (#f)    extended)
("##cdddr"                            (1)   #f ()    0    (#f)    extended)
("##caaaar"                           (1)   #f ()    0    (#f)    extended)
("##caaadr"                           (1)   #f ()    0    (#f)    extended)
("##caadar"                           (1)   #f ()    0    (#f)    extended)
("##caaddr"                           (1)   #f ()    0    (#f)    extended)
("##cadaar"                           (1)   #f ()    0    (#f)    extended)
("##cadadr"                           (1)   #f ()    0    (#f)    extended)
("##caddar"                           (1)   #f ()    0    (#f)    extended)
("##cadddr"                           (1)   #f ()    0    (#f)    extended)
("##cdaaar"                           (1)   #f ()    0    (#f)    extended)
("##cdaadr"                           (1)   #f ()    0    (#f)    extended)
("##cdadar"                           (1)   #f ()    0    (#f)    extended)
("##cdaddr"                           (1)   #f ()    0    (#f)    extended)
("##cddaar"                           (1)   #f ()    0    (#f)    extended)
("##cddadr"                           (1)   #f ()    0    (#f)    extended)
("##cdddar"                           (1)   #f ()    0    (#f)    extended)
("##cddddr"                           (1)   #f ()    0    (#f)    extended)

("##list"                             0     #f ()    0    list    extended)

("##make-will"                        (2)   #t ()    0    #f      extended)
("##will-testator"                    (1)   #f ()    0    (#f)    extended)
("##will-testator-set!"               (2)   #t ()    0    #f      extended)
("##will-action"                      (1)   #f ()    0    (#f)    extended)
("##will-action-set!"                 (2)   #t ()    0    #f      extended)

("##foreign-address"                  (1)   #f ()    0    #f      extended)
("##foreign-tags"                     (1)   #f ()    0    #f      extended)
("##foreign-release!"                 (1)   #t ()    0    #f      extended)
("##foreign-released?"                (1)   #f ()    0    boolean extended)

("##gc-hash-table-ref"                (2)   #f ()    0    (#f)    extended)
("##gc-hash-table-set!"               (3)   #t ()    0    (#f)    extended)
("##gc-hash-table-rehash!"            (2)   #t ()    0    (#f)    extended)

("##box"                              (1)   #f ()    0    #f      extended)
("##unbox"                            (1)   #f ()    0    (#f)    extended)
("##set-box!"                         (2)   #t ()    0    #f      extended)

("##values"                           0     #f ()    0    (#f)    extended)
("##make-values"                      (1 2) #f ()    0    (#f)    extended)
("##values-length"                    (1)   #f ()    0    fixnonneg extended)
("##values-ref"                       (2)   #f ()    0    (#f)    extended)
("##values-set!"                      (3)   #t ()    0    (#f)    extended)

("##vector"                           0     #f ()    0    vector  extended)
("##make-vector"                      (1 2) #f ()    0    vector  extended)
("##vector-length"                    (1)   #f ()    0    fixnonneg extended)
("##vector-ref"                       (2)   #f ()    0    (#f)    extended)
("##vector-set!"                      (3)   #t ()    0    vector  extended)
("##vector-shrink!"                   (2)   #t ()    0    vector  extended)
("##vector-cas!"                      (4)   #t ()    0    (#f)    extended)
("##vector-inc!"                      (2 3) #t ()    0    fixnum  extended)

("##string"                           0     #f ()    0    string  extended)
("##make-string"                      (1 2) #f ()    0    string  extended)
("##string-length"                    (1)   #f ()    0    fixnonneg extended)
("##string-ref"                       (2)   #f ()    0    char    extended)
("##string-set!"                      (3)   #t ()    0    string  extended)
("##string-shrink!"                   (2)   #t ()    0    string  extended)

("##s8vector"                         0     #f ()    0    s8vector extended)
("##make-s8vector"                    (1 2) #f ()    0    s8vector extended)
("##s8vector-length"                  (1)   #f ()    0    fixnonneg extended)
("##s8vector-ref"                     (2)   #f ()    0    s8       extended)
("##s8vector-set!"                    (3)   #t ()    0    s8vector extended)
("##s8vector-shrink!"                 (2)   #t ()    0    s8vector extended)

("##u8vector"                         0     #f ()    0    u8vector extended)
("##make-u8vector"                    (1 2) #f ()    0    u8vector extended)
("##u8vector-length"                  (1)   #f ()    0    fixnonneg extended)
("##u8vector-ref"                     (2)   #f ()    0    u8      extended)
("##u8vector-set!"                    (3)   #t ()    0    u8vector extended)
("##u8vector-shrink!"                 (2)   #t ()    0    u8vector extended)

("##s16vector"                        0     #f ()    0    s16vector extended)
("##make-s16vector"                   (1 2) #f ()    0    s16vector extended)
("##s16vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##s16vector-ref"                    (2)   #f ()    0    s16     extended)
("##s16vector-set!"                   (3)   #t ()    0    s16vector extended)
("##s16vector-shrink!"                (2)   #t ()    0    s16vector extended)

("##u16vector"                        0     #f ()    0    u16vector extended)
("##make-u16vector"                   (1 2) #f ()    0    u16vector extended)
("##u16vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##u16vector-ref"                    (2)   #f ()    0    u16     extended)
("##u16vector-set!"                   (3)   #t ()    0    u16vector extended)
("##u16vector-shrink!"                (2)   #t ()    0    u16vector extended)

("##s32vector"                        0     #f ()    0    s32vector extended)
("##make-s32vector"                   (1 2) #f ()    0    s32vector extended)
("##s32vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##s32vector-ref"                    (2)   #f ()    0    s32     extended)
("##s32vector-set!"                   (3)   #t ()    0    s32vector extended)
("##s32vector-shrink!"                (2)   #t ()    0    s32vector extended)

("##u32vector"                        0     #f ()    0    u32vector extended)
("##make-u32vector"                   (1 2) #f ()    0    u32vector extended)
("##u32vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##u32vector-ref"                    (2)   #f ()    0    u32     extended)
("##u32vector-set!"                   (3)   #t ()    0    u32vector extended)
("##u32vector-shrink!"                (2)   #t ()    0    u32vector extended)

("##s64vector"                        0     #f ()    0    s64vector extended)
("##make-s64vector"                   (1 2) #f ()    0    s64vector extended)
("##s64vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##s64vector-ref"                    (2)   #f ()    0    s64     extended)
("##s64vector-set!"                   (3)   #t ()    0    s64vector extended)
("##s64vector-shrink!"                (2)   #t ()    0    s64vector extended)

("##u64vector"                        0     #f ()    0    u64vector extended)
("##make-u64vector"                   (1 2) #f ()    0    u64vector extended)
("##u64vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##u64vector-ref"                    (2)   #f ()    0    u64     extended)
("##u64vector-set!"                   (3)   #t ()    0    u64vector extended)
("##u64vector-shrink!"                (2)   #t ()    0    u64vector extended)

("##f32vector"                        0     #f ()    0    f32vector extended)
("##make-f32vector"                   (1 2) #f ()    0    f32vector extended)
("##f32vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##f32vector-ref"                    (2)   #f ()    0    flonum  extended)
("##f32vector-set!"                   (3)   #t ()    0    f32vector extended)
("##f32vector-shrink!"                (2)   #t ()    0    f32vector extended)

("##f64vector"                        0     #f ()    0    f64vector extended)
("##make-f64vector"                   (1 2) #f ()    0    f64vector extended)
("##f64vector-length"                 (1)   #f ()    0    fixnonneg extended)
("##f64vector-ref"                    (2)   #f ()    0    flonum  extended)
("##f64vector-set!"                   (3)   #t ()    0    f64vector extended)
("##f64vector-shrink!"                (2)   #t ()    0    f64vector extended)

("##ratnum-make"                      (2)   #f ()    0    number  extended)
("##ratnum-numerator"                 (1)   #f ()    0    integer extended)
("##ratnum-denominator"               (1)   #f ()    0    integer extended)

("##cpxnum-make"                      (2)   #f ()    0    number  extended)
("##cpxnum-real"                      (1)   #f ()    0    number  extended)
("##cpxnum-imag"                      (1)   #f ()    0    number  extended)

("##structure-direct-instance-of?"    (2)   #f ()    0    boolean extended)
("##structure-instance-of?"           (2)   #f ()    0    boolean extended)
("##structure-type"                   (1)   #f ()    0    (#f)    extended)
("##structure-type-set!"              (2)   #t ()    0    (#f)    extended)
("##structure"                        1     #f ()    0    (#f)    extended)
("##make-structure"                   (2)   #f ()    0    (#f)    extended)
("##structure-length"                 (1)   #f ()    0    fixnonneg extended)
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

("##symbol->string"                   (1)   #f ()    0    string  extended)
("##string->symbol"                   (1)   #f ()    0    symbol  extended)
("##string->uninterned-symbol"        (1 2) #f ()    0    symbol  extended)
("##make-uninterned-symbol"           (2)   #f ()    0    symbol  extended)
("##symbol-name"                      (1)   #f ()    0    string  extended)
("##symbol-name-set!"                 (2)   #t ()    0    #f      extended)
("##symbol-hash"                      (1)   #f ()    0    fixnum  extended)
("##symbol-hash-set!"                 (2)   #t ()    0    #f      extended)
("##symbol-interned?"                 (1)   #f ()    0    #f      extended)

("##keyword->string"                  (1)   #f ()    0    string  extended)
("##string->keyword"                  (1)   #f ()    0    keyword extended)
("##string->uninterned-keyword"       (1 2) #f ()    0    keyword extended)
("##make-uninterned-keyword"          (2)   #f ()    0    keyword extended)
("##keyword-name"                     (1)   #f ()    0    string  extended)
("##keyword-name-set!"                (2)   #t ()    0    #f      extended)
("##keyword-hash"                     (1)   #f ()    0    fixnum  extended)
("##keyword-hash-set!"                (2)   #t ()    0    #f      extended)
("##keyword-interned?"                (1)   #f ()    0    #f      extended)

("##make-closure"                     (2)   #f ()    0    #f      extended)
("##closure-length"                   (1)   #f ()    0    fixnonneg extended)
("##closure-code"                     (1)   #f ()    0    #f      extended)
("##closure-ref"                      (2)   #f ()    0    (#f)    extended)
("##closure-set!"                     (3)   #t ()    0    #f      extended)

("##make-subprocedure"                (2)   #f ()    0    #f      extended)
("##subprocedure-id"                  (1)   #f ()    0    #f      extended)
("##subprocedure-nb-parameters"       (1)   #f ()    0    #f      extended)
("##subprocedure-nb-closed"           (1)   #f ()    0    #f      extended)
("##subprocedure-parent"              (1)   #f ()    0    #f      extended)
("##subprocedure-parent-name"         (1)   #f ()    0    #f      extended)
("##subprocedure-parent-info"         (1)   #f ()    0    #f      extended)

("##make-promise"                     (1)   #f 0     0    (#f)    extended)
("##promise-thunk"                    (1)   #f ()    0    #f      extended)
("##promise-thunk-set!"               (2)   #t ()    0    #f      extended)
("##promise-result"                   (1)   #f ()    0    #f      extended)
("##promise-result-set!"              (2)   #t ()    0    #f      extended)

("##force"                            (1)   #t 0     0    #f      extended)

("##identity"                         (1)   #f ()    0    (#f)    extended)

("##void"                             (0)   #f ()    0    #f      extended)

("current-thread"                     (0)   #f ()    0    #f      extended)
("##current-thread"                   (0)   #f ()    0    #f      extended)
("##current-processor"                (0)   #f ()    0    #f      extended)
("##current-processor-id"             (0)   #f ()    0    fixnum  extended)
("##processor"                        (1)   #f ()    0    #f      extended)
("##current-vm"                       (0)   #f ()    0    #f      extended)

("##thread-save!"                     1     #t ()    1113 (#f)    extended)
("##thread-restore!"                  2     #t ()    2203 #f      extended)

("##primitive-lock!"                  (3)   #t ()    0    #f      extended)
("##primitive-trylock!"               (3)   #t ()    0    #f      extended)
("##primitive-unlock!"                (3)   #t ()    0    #f      extended)

("##object-before?"                   (2)   #t ()    0    boolean extended)

("##continuation-capture"             1     #t ()    1113 (#f)    extended)
("##continuation-graft"               2     #t ()    2203 #f      extended)
("##continuation-graft-no-winding"    2     #t ()    2203 #f      extended)
("##continuation-return"              (2)   #t ()    0    #f      extended)
("##continuation-return-no-winding"   (2)   #t ()    0    #f      extended)

("##make-continuation"                (2)   #f ()    0    #f      extended)
("##continuation-frame"               (1)   #f ()    0    #f      extended)
("##continuation-frame-set!"          (2)   #t ()    0    #f      extended)
("##continuation-denv"                (1)   #f ()    0    #f      extended)
("##continuation-denv-set!"           (2)   #t ()    0    #f      extended)
("##continuation-next"                (1)   #f ()    0    #f      extended)
("##continuation-ret"                 (1)   #f ()    0    #f      extended)
("##continuation-fs"                  (1)   #f ()    0    fixnum  extended)
("##continuation-link"                (1)   #f ()    0    #f      extended)
("##continuation-ref"                 (2)   #f ()    0    (#f)    extended)
("##continuation-set!"                (3)   #t ()    0    #f      extended)
("##continuation-slot-live?"          (2)   #f ()    0    boolean extended)

("##make-frame"                       (1)   #f ()    0    #f      extended)
("##frame-ret"                        (1)   #f ()    0    #f      extended)
("##frame-fs"                         (1)   #f ()    0    fixnum  extended)
("##frame-link"                       (1)   #f ()    0    #f      extended)
("##frame-ref"                        (2)   #f ()    0    (#f)    extended)
("##frame-set!"                       (3)   #t ()    0    #f      extended)
("##frame-slot-live?"                 (2)   #f ()    0    boolean extended)

("##return-fs"                        (1)   #f ()    0    fixnum  extended)

("##apply"                            (2)   #t ()    0    (#f)    extended)
("##call-with-current-continuation"   1     #t ()    1113 (#f)    extended)
("##make-global-var"                  (1)   #t ()    0    #f      extended)
("##global-var?"                      (1)   #f ()    0    #f      extended)
("##global-var-ref"                   (1)   #f ()    0    (#f)    extended)
("##global-var-primitive-ref"         (1)   #f ()    0    (#f)    extended)
("##global-var-set!"                  (2)   #t ()    0    #f      extended)
("##global-var-primitive-set!"        (2)   #t ()    0    #f      extended)

("##first-argument"                   1     #f ()    0    (#f)    extended)
("##check-heap-limit"                 (0)   #t ()    0    (#f)    extended)

;; for front end

("##quasi-append"                     0     #f 0     0    list    extended)
("##quasi-list"                       0     #f ()    0    list    extended)
("##quasi-cons"                       (2)   #f ()    0    pair    extended)
("##quasi-list->vector"               (1)   #f 0     0    vector  extended)
("##quasi-vector"                     0     #f ()    0    vector  extended)
("##case-memv"                        (2)   #f 0     0    list    extended)

("##bignum.negative?"                 (1)   #f ()    0    boolean extended)
("##bignum.adigit-length"             (1)   #f ()    0    fixnonneg extended)
("##bignum.adigit-inc!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-dec!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-add!"               (5)   #t ()    0    integer extended)
("##bignum.adigit-sub!"               (5)   #t ()    0    integer extended)
("##bignum.mdigit-length"             (1)   #f ()    0    fixnonneg extended)
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
("##bignum.adigit-bitwise-ior!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-xor!"       (4)   #t ()    0    #f      extended)
("##bignum.adigit-bitwise-not!"       (2)   #t ()    0    #f      extended)

("##bignum.fdigit-length"             (1)   #f ()    0    fixnonneg extended)
("##bignum.fdigit-ref"                (2)   #f ()    0    integer extended)
("##bignum.fdigit-set!"               (3)   #t ()    0    #f      extended)

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
      (lambda (env args) spec))))

(define (spec-u name) ;; Unsafe specialization
  (lambda (proc proc-name)
    (let ((spec (get-prim-info name)))
      (lambda (env args) (if (not (safe? env)) spec proc)))))

(define (spec-arith fix-name flo-name) ;; Arithmetic specialization
  (lambda (proc proc-name)
    (let ((fix-spec (if fix-name (get-prim-info fix-name) proc))
          (flo-spec (if flo-name (get-prim-info flo-name) proc)))
      (lambda (env args)
        (let ((arith (arith-implementation proc-name env)))
          (cond ((eq? arith fixnum-sym)
                 fix-spec)
                ((eq? arith flonum-sym)
                 flo-spec)
                (else
                 proc)))))))

(define (spec-s-eqv?) ;; Safe specialization for eqv? and ##eqv?
  (lambda (proc proc-name)
    (let ((spec (get-prim-info "##eq?")))
      (lambda (env args)
        (if (and (= (length args) 2)
                 (or (eq? (arith-implementation proc-name env) fixnum-sym)
                     (eq-testable-object? (car args))
                     (eq-testable-object? (cadr args))))
          spec
          proc)))))

(define (spec-s-equal?) ;; Safe specialization for equal? and ##equal?
  (lambda (proc proc-name)
    (let ((spec (get-prim-info "##eq?")))
      (lambda (env args)
        (if (and (= (length args) 2)
                 (or (eq-testable-object? (car args))
                     (eq-testable-object? (cadr args))))
          spec
          proc)))))

(define (eq-testable-object? type)
  (and (type-singleton? type)
       (testable-with-eq? (type-singleton-val type))))

(define (testable-with-eq? obj)
  (or (symbol-object? obj)
      (keyword-object? obj)
      (memq (targ-obj-type obj) ;; TODO: remove dependency on C back-end
            '(boolean null absent unused deleted void eof optional
              key rest
              fixnum char))))

(def-spec "not"         (spec-s "##not"))
(def-spec "boolean?"    (spec-s "##boolean?"))
(def-spec "null?"       (spec-s "##null?"))
(def-spec "eq?"         (spec-s "##eq?"))
(def-spec "eof-object?" (spec-s "##eof-object?"))

(def-spec "pair?"       (spec-s "##pair?"))
(def-spec "procedure?"  (spec-s "##procedure?"))
(def-spec "vector?"     (spec-s "##vector?"))
(def-spec "symbol?"     (spec-s "##symbol?"))
(def-spec "keyword?"    (spec-s "##keyword?"))
(def-spec "string?"     (spec-s "##string?"))
(def-spec "char?"       (spec-s "##char?"))

(def-spec "fixnum?"     (spec-s "##fixnum?"))
(def-spec "flonum?"     (spec-s "##flonum?"))

(def-spec "number?"     (spec-s "##number?"))
(def-spec "complex?"    (spec-s "##complex?"))
(def-spec "real?"       (spec-s "##real?"))
(def-spec "rational?"   (spec-s "##rational?"))
(def-spec "integer?"    (spec-s "##integer?"))

;;the following primitives must check that their parameter is a number:
;;(def-spec "exact?"      (spec-s "##exact?"))
;;(def-spec "inexact?"    (spec-s "##inexact?"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "fx=" (spec-u "##fx="))
(def-spec "fl=" (spec-u "##fl="))
(def-spec "="   (spec-arith "fx=" "fl="))

(def-spec "fx<" (spec-u "##fx<"))
(def-spec "fl<" (spec-u "##fl<"))
(def-spec "<"   (spec-arith "fx<" "fl<"))

(def-spec "fx>" (spec-u "##fx>"))
(def-spec "fl>" (spec-u "##fl>"))
(def-spec ">"   (spec-arith "fx>" "fl>"))

(def-spec "fx<=" (spec-u "##fx<="))
(def-spec "fl<=" (spec-u "##fl<="))
(def-spec "<="   (spec-arith "fx<=" "fl<="))

(def-spec "fx>=" (spec-u "##fx>="))
(def-spec "fl>=" (spec-u "##fl>="))
(def-spec ">="   (spec-arith "fx>=" "fl>="))

(def-spec "flinteger?" (spec-u "##flinteger?"))

(def-spec "fxzero?" (spec-u "##fxzero?"))
(def-spec "flzero?" (spec-u "##flzero?"))
(def-spec "zero?"   (spec-arith "fxzero?" "flzero?"))

(def-spec "fxpositive?" (spec-u "##fxpositive?"))
(def-spec "flpositive?" (spec-u "##flpositive?"))
(def-spec "positive?"   (spec-arith "fxpositive?" "flpositive?"))

(def-spec "fxnegative?" (spec-u "##fxnegative?"))
(def-spec "flnegative?" (spec-u "##flnegative?"))
(def-spec "negative?"   (spec-arith "fxnegative?" "flnegative?"))

(def-spec "fxodd?" (spec-u "##fxodd?"))
(def-spec "flodd?" (spec-u "##flodd?"))
(def-spec "odd?"   (spec-arith "fxodd?" "flodd?"))

(def-spec "fxeven?" (spec-u "##fxeven?"))
(def-spec "fleven?" (spec-u "##fleven?"))
(def-spec "even?"   (spec-arith "fxeven?" "fleven?"))

(def-spec "flfinite?" (spec-u "##flfinite?"))
(def-spec "finite?"   (spec-arith #f "flfinite?"))

(def-spec "flinfinite?" (spec-u "##flinfinite?"))
(def-spec "infinite?"   (spec-arith #f "flinfinite?"))

(def-spec "flnan?" (spec-u "##flnan?"))
(def-spec "nan?"   (spec-arith #f "flnan?"))

(def-spec "fxmax" (spec-u "##fxmax"))
(def-spec "flmax" (spec-u "##flmax"))
(def-spec "max"   (spec-arith "fxmax" "flmax"))

(def-spec "fxmin" (spec-u "##fxmin"))
(def-spec "flmin" (spec-u "##flmin"))
(def-spec "min"   (spec-arith "fxmin" "flmin"))

(def-spec "fxwrap+" (spec-u "##fxwrap+"))
(def-spec "fx+"     (spec-u "##fx+"))
(def-spec "fl+"     (spec-u "##fl+"))
(def-spec "+"       (spec-arith "fx+" "fl+"))

(def-spec "fxwrap*" (spec-u "##fxwrap*"))
(def-spec "fx*"     (spec-u "##fx*"))
(def-spec "fl*"     (spec-u "##fl*"))
(def-spec "*"       (spec-arith "fx*" "fl*"))

(def-spec "fxwrap-" (spec-u "##fxwrap-"))
(def-spec "fx-"     (spec-u "##fx-"))
(def-spec "fl-"     (spec-u "##fl-"))
(def-spec "-"       (spec-arith "fx-" "fl-"))

(def-spec "fl/"     (spec-u "##fl/"))
(def-spec "/"       (spec-arith #f "fl/"))

(def-spec "fxwrapquotient" (spec-u "##fxwrapquotient"))
(def-spec "fxquotient"     (spec-u "##fxquotient"))
(def-spec "quotient"       (spec-arith "fxquotient" #f))

(def-spec "fxremainder" (spec-u "##fxremainder"))
(def-spec "remainder"   (spec-arith "fxremainder" #f))

(def-spec "fxmodulo" (spec-u "##fxmodulo"))
(def-spec "modulo"   (spec-arith "fxmodulo" #f))

(def-spec "fxnot" (spec-u "##fxnot"))
(def-spec "bitwise-not" (spec-arith "fxnot" #f))

(def-spec "fxand" (spec-u "##fxand"))
(def-spec "bitwise-and" (spec-arith "fxand" #f))

(def-spec "fxior" (spec-u "##fxior"))
(def-spec "bitwise-ior" (spec-arith "fxior" #f))

(def-spec "fxxor" (spec-u "##fxxor"))
(def-spec "bitwise-xor" (spec-arith "fxxor" #f))

(def-spec "fxif" (spec-u "##fxif"))

(def-spec "fxbit-count" (spec-u "##fxbit-count"))

(def-spec "fxlength" (spec-u "##fxlength"))

(def-spec "fxfirst-bit-set" (spec-u "##fxfirst-bit-set"))

(def-spec "fxbit-set?" (spec-u "##fxbit-set?"))

(def-spec "fxwraparithmetic-shift" (spec-u "##fxwraparithmetic-shift"))
(def-spec "fxarithmetic-shift"     (spec-u "##fxarithmetic-shift"))
(def-spec "arithmetic-shift"       (spec-arith "fxarithmetic-shift" #f))

(def-spec "fxwraparithmetic-shift-left" (spec-u "##fxwraparithmetic-shift-left"))
(def-spec "fxarithmetic-shift-left"   (spec-u "##fxarithmetic-shift-left"))
(def-spec "fxarithmetic-shift-right"  (spec-u "##fxarithmetic-shift-right"))
(def-spec "fxwraplogical-shift-right" (spec-u "##fxwraplogical-shift-right"))

(def-spec "fxwrapabs"    (spec-u "##fxwrapabs"))
(def-spec "fxabs"        (spec-u "##fxabs"))
(def-spec "flabs"        (spec-u "##flabs"))
(def-spec "abs"          (spec-arith "fxabs" "flabs"))

(def-spec "fxwrapsquare" (spec-u "##fxwrapsquare"))
(def-spec "fxsquare"     (spec-u "##fxsquare"))
(def-spec "flsquare"     (spec-u "##flsquare"))
(def-spec "square"       (spec-arith "fxsquare" "flsquare"))

(def-spec "flfloor" (spec-u "##flfloor"))
(def-spec "floor"   (spec-arith #f "flfloor"))

(def-spec "flceiling" (spec-u "##flceiling"))
(def-spec "ceiling"   (spec-arith #f "flceiling"))

(def-spec "fltruncate" (spec-u "##fltruncate"))
(def-spec "truncate"   (spec-arith #f "fltruncate"))

(def-spec "flround" (spec-u "##flround"))
(def-spec "round"   (spec-arith #f "flround"))

(def-spec "flexp" (spec-u "##flexp"))
(def-spec "exp"   (spec-arith #f "flexp"))

(def-spec "flexpm1" (spec-u "##flexpm1"))
;(def-spec "expm1"   (spec-arith #f "flexpm1"))

(def-spec "fllog" (spec-u "##fllog"))
(def-spec "log"   (spec-arith #f "fllog"))

(def-spec "fllog1p" (spec-u "##fllog1p"))
;(def-spec "log1p"   (spec-arith #f "fllog1p"))

(def-spec "flsin" (spec-u "##flsin"))
(def-spec "sin"   (spec-arith #f "flsin"))

(def-spec "flcos" (spec-u "##flcos"))
(def-spec "cos"   (spec-arith #f "flcos"))

(def-spec "fltan" (spec-u "##fltan"))
(def-spec "tan"   (spec-arith #f "fltan"))

(def-spec "flasin" (spec-u "##flasin"))
(def-spec "asin"   (spec-arith #f "flasin"))

(def-spec "flacos" (spec-u "##flacos"))
(def-spec "acos"   (spec-arith #f "flacos"))

(def-spec "flatan" (spec-u "##flatan"))
(def-spec "atan"   (spec-arith #f "flatan"))

(def-spec "flsinh" (spec-u "##flsinh"))
(def-spec "sinh"   (spec-arith #f "flsinh"))

(def-spec "flcosh" (spec-u "##flcosh"))
(def-spec "cosh"   (spec-arith #f "flcosh"))

(def-spec "fltanh" (spec-u "##fltanh"))
(def-spec "tanh"   (spec-arith #f "fltanh"))

(def-spec "flasinh" (spec-u "##flasinh"))
(def-spec "asinh"   (spec-arith #f "flasinh"))

(def-spec "flacosh" (spec-u "##flacosh"))
(def-spec "acosh"   (spec-arith #f "flacosh"))

(def-spec "flatanh" (spec-u "##flatanh"))
(def-spec "atanh"   (spec-arith #f "flatanh"))

(def-spec "flexpt" (spec-u "##flexpt"))
(def-spec "expt"   (spec-arith #f "flexpt"))

(def-spec "flsqrt" (spec-u "##flsqrt"))
(def-spec "sqrt"   (spec-arith #f "flsqrt"))

(def-spec "flsquare" (spec-u "##flsquare"))

(def-spec "fixnum->flonum" (spec-u "##fixnum->flonum"))

;(def-spec "exact->inexact" (spec-arith "##fixnum->flonum" #f))
;(def-spec "inexact->exact" (spec-arith "##flonum->fixnum" #f))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "char=?"     (spec-u "##char=?"))
(def-spec "char<?"     (spec-u "##char<?"))
(def-spec "char>?"     (spec-u "##char>?"))
(def-spec "char<=?"    (spec-u "##char<=?"))
(def-spec "char>=?"    (spec-u "##char>=?"))

(def-spec "char-alphabetic?" (spec-u "##char-alphabetic?"))
(def-spec "char-numeric?"    (spec-u "##char-numeric?"))
(def-spec "char-whitespace?" (spec-u "##char-whitespace?"))
(def-spec "char-upper-case?" (spec-u "##char-upper-case?"))
(def-spec "char-lower-case?" (spec-u "##char-lower-case?"))
(def-spec "char->integer"    (spec-u "##char->integer"))
(def-spec "integer->char"    (spec-u "##integer->char"))
(def-spec "char-upcase"      (spec-u "##char-upcase"))
(def-spec "char-downcase"    (spec-u "##char-downcase"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "cons"       (spec-s "##cons"))
(def-spec "set-car!"   (spec-u "##set-car!"))
(def-spec "set-cdr!"   (spec-u "##set-cdr!"))
(def-spec "car"        (spec-u "##car"))
(def-spec "cdr"        (spec-u "##cdr"))
(def-spec "caar"       (spec-u "##caar"))
(def-spec "cadr"       (spec-u "##cadr"))
(def-spec "cdar"       (spec-u "##cdar"))
(def-spec "cddr"       (spec-u "##cddr"))
(def-spec "caaar"      (spec-u "##caaar"))
(def-spec "caadr"      (spec-u "##caadr"))
(def-spec "cadar"      (spec-u "##cadar"))
(def-spec "caddr"      (spec-u "##caddr"))
(def-spec "cdaar"      (spec-u "##cdaar"))
(def-spec "cdadr"      (spec-u "##cdadr"))
(def-spec "cddar"      (spec-u "##cddar"))
(def-spec "cdddr"      (spec-u "##cdddr"))
(def-spec "caaaar"     (spec-u "##caaaar"))
(def-spec "caaadr"     (spec-u "##caaadr"))
(def-spec "caadar"     (spec-u "##caadar"))
(def-spec "caaddr"     (spec-u "##caaddr"))
(def-spec "cadaar"     (spec-u "##cadaar"))
(def-spec "cadadr"     (spec-u "##cadadr"))
(def-spec "caddar"     (spec-u "##caddar"))
(def-spec "cadddr"     (spec-u "##cadddr"))
(def-spec "cdaaar"     (spec-u "##cdaaar"))
(def-spec "cdaadr"     (spec-u "##cdaadr"))
(def-spec "cdadar"     (spec-u "##cdadar"))
(def-spec "cdaddr"     (spec-u "##cdaddr"))
(def-spec "cddaar"     (spec-u "##cddaar"))
(def-spec "cddadr"     (spec-u "##cddadr"))
(def-spec "cdddar"     (spec-u "##cdddar"))
(def-spec "cddddr"     (spec-u "##cddddr"))

(def-spec "list"       (spec-s "##list"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "will?"          (spec-s "##will?"))
(def-spec "make-will"      (spec-s "##make-will"))
(def-spec "will-testator"  (spec-u "##will-testator"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "box?"           (spec-s "##box?"))
(def-spec "box"            (spec-s "##box"))
(def-spec "unbox"          (spec-u "##unbox"))
(def-spec "set-box!"       (spec-u "##set-box!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "values"         (spec-s "##values"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "string"         (spec-u "##string"))
(def-spec "string-length"  (spec-u "##string-length"))
(def-spec "string-ref"     (spec-u "##string-ref"))
(def-spec "string-set!"    (spec-u "##string-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "vector"         (spec-s "##vector"))
(def-spec "vector-length"  (spec-u "##vector-length"))
(def-spec "vector-ref"     (spec-u "##vector-ref"))
(def-spec "vector-set!"    (spec-u "##vector-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "s8vector?"        (spec-s "##s8vector?"))
(def-spec "s8vector"         (spec-u "##s8vector"))
(def-spec "s8vector-length"  (spec-u "##s8vector-length"))
(def-spec "s8vector-ref"     (spec-u "##s8vector-ref"))
(def-spec "s8vector-set!"    (spec-u "##s8vector-set!"))

(def-spec "u8vector?"        (spec-s "##u8vector?"))
(def-spec "u8vector"         (spec-u "##u8vector"))
(def-spec "u8vector-length"  (spec-u "##u8vector-length"))
(def-spec "u8vector-ref"     (spec-u "##u8vector-ref"))
(def-spec "u8vector-set!"    (spec-u "##u8vector-set!"))

(def-spec "s16vector?"       (spec-s "##s16vector?"))
(def-spec "s16vector"        (spec-u "##s16vector"))
(def-spec "s16vector-length" (spec-u "##s16vector-length"))
(def-spec "s16vector-ref"    (spec-u "##s16vector-ref"))
(def-spec "s16vector-set!"   (spec-u "##s16vector-set!"))

(def-spec "u16vector?"       (spec-s "##u16vector?"))
(def-spec "u16vector"        (spec-u "##u16vector"))
(def-spec "u16vector-length" (spec-u "##u16vector-length"))
(def-spec "u16vector-ref"    (spec-u "##u16vector-ref"))
(def-spec "u16vector-set!"   (spec-u "##u16vector-set!"))

(def-spec "s32vector?"       (spec-s "##s32vector?"))
(def-spec "s32vector"        (spec-u "##s32vector"))
(def-spec "s32vector-length" (spec-u "##s32vector-length"))
(def-spec "s32vector-ref"    (spec-u "##s32vector-ref"))
(def-spec "s32vector-set!"   (spec-u "##s32vector-set!"))

(def-spec "u32vector?"       (spec-s "##u32vector?"))
(def-spec "u32vector"        (spec-u "##u32vector"))
(def-spec "u32vector-length" (spec-u "##u32vector-length"))
(def-spec "u32vector-ref"    (spec-u "##u32vector-ref"))
(def-spec "u32vector-set!"   (spec-u "##u32vector-set!"))

(def-spec "s64vector?"       (spec-s "##s64vector?"))
(def-spec "s64vector"        (spec-u "##s64vector"))
(def-spec "s64vector-length" (spec-u "##s64vector-length"))
(def-spec "s64vector-ref"    (spec-u "##s64vector-ref"))
(def-spec "s64vector-set!"   (spec-u "##s64vector-set!"))

(def-spec "u64vector?"       (spec-s "##u64vector?"))
(def-spec "u64vector"        (spec-u "##u64vector"))
(def-spec "u64vector-length" (spec-u "##u64vector-length"))
(def-spec "u64vector-ref"    (spec-u "##u64vector-ref"))
(def-spec "u64vector-set!"   (spec-u "##u64vector-set!"))

(def-spec "f32vector?"       (spec-s "##f32vector?"))
(def-spec "f32vector"        (spec-u "##f32vector"))
(def-spec "f32vector-length" (spec-u "##f32vector-length"))
(def-spec "f32vector-ref"    (spec-u "##f32vector-ref"))
(def-spec "f32vector-set!"   (spec-u "##f32vector-set!"))

(def-spec "f64vector?"       (spec-s "##f64vector?"))
(def-spec "f64vector"        (spec-u "##f64vector"))
(def-spec "f64vector-length" (spec-u "##f64vector-length"))
(def-spec "f64vector-ref"    (spec-u "##f64vector-ref"))
(def-spec "f64vector-set!"   (spec-u "##f64vector-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "##structure-ref"  (spec-u "##unchecked-structure-ref"))
(def-spec "##structure-set!" (spec-u "##unchecked-structure-set!"))
(def-spec "##structure-cas!" (spec-u "##unchecked-structure-cas!"))

(def-spec "##direct-structure-ref"  (spec-u "##unchecked-structure-ref"))
(def-spec "##direct-structure-set!" (spec-u "##unchecked-structure-set!"))
(def-spec "##direct-structure-cas!" (spec-u "##unchecked-structure-cas!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(def-spec "touch"            (spec-s "##force"))
(def-spec "force"            (spec-s "##force"))
(def-spec "identity"         (spec-s "##identity"))
(def-spec "void"             (spec-s "##void"))

(def-spec "eqv?"             (spec-s-eqv?))
(def-spec "##eqv?"           (spec-s-eqv?))
(def-spec "equal?"           (spec-s-equal?))
(def-spec "##equal?"         (spec-s-equal?))

(def-spec "call/cc"          (spec-s "##call-with-current-continuation"))
(def-spec "call-with-current-continuation"
                              (spec-s "##call-with-current-continuation"))

(def-spec "continuation?"        (spec-s "##continuation?"))
(def-spec "continuation-capture" (spec-s "##continuation-capture"))
(def-spec "continuation-graft"   (spec-s "##continuation-graft"))
(def-spec "continuation-return"  (spec-s "##continuation-return"))

(def-spec "current-thread"   (spec-s "##current-thread"))
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
         check-prim
         tail
         succeed
         fail)
  (let ((type-checks
         (gen-uniform-type-checks source env
           vars
           (lambda (var)
             (gen-call-prim-vars source env check-prim (list var)))
           tail)))
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

(define (gen-simple-case check-prim prim)
  (lambda (source
           env
           vars
           check-run-time-binding
           invalid
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prim
     #f
     (lambda ()
       (gen-call-prim-vars source env prim vars))
     fail)))

(define (gen-validating-case check-prim gen)
  (lambda (source
           env
           vars
           check-run-time-binding
           invalid
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prim
     #f
     (lambda ()
       (gen source env vars invalid))
     fail)))

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
                  (y (gen-call-prim-vars source env **pair?-sym (list var))))
              (if x
                (new-conj source env x y)
                y))
            (gen-call-prim-vars source env (op-prim pattern) (list var))
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
                   (gen-call-prim-vars source env
                     **pair?-sym
                     (list (car vars)))))
              (new-tst source env
                (new-conj source env
                  (if check-run-time-binding
                    (new-conj source env
                      (check-run-time-binding)
                      type-check)
                    type-check)
                  (gen-call-prim-vars source env
                    **mutable?-sym
                    (list (car vars))))
                (gen-call-prim-vars source env
                  (op-prim pattern)
                  vars)
                (generate-call vars
                               (not check-run-time-binding))))))))

    (let ((name (gen-name pattern)))
      (def-exp name expander)))

  (define (setup-set-c...r!-primitives)
    (setup-set-c...r!-primitive 0)  ; set-car!
    (setup-set-c...r!-primitive 1)) ; set-cdr!

  (define (make-assq-memq-expander prim)
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
                      (gen-call-prim-vars source env
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
                                  (gen-call-prim source env
                                    (if (eq? prim 'assq)
                                        **eq?-sym
                                        **eqv?-sym)
                                    (list (new-ref source env
                                            obj-var)
                                          (gen-call-prim-vars source env
                                            **car-sym
                                            (list x-var))))
                                  (new-ref source env
                                    x-var)
                                  (new-call source env2
                                    (new-ref source env
                                      loop-var)
                                    (list (gen-call-prim-vars source env
                                            **cdr-sym
                                            (list lst1-var))))))

                              (if (safe? env)
                                (new-tst source env
                                  (gen-call-prim-vars source env
                                    **pair?-sym
                                    (list x-var))
                                  (gen-test)
                                  (generate-call vars
                                                 (not check-run-time-binding)))
                                (gen-test)))
                            (new-tst source env
                              (gen-call-prim source env
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
                                (list (gen-call-prim-vars source env
                                        **cdr-sym
                                        (list lst1-var)))))))
                        (list (gen-call-prim-vars source env
                                **car-sym
                                (list lst1-var))))
                      (if (safe? env)
                        (new-tst source env
                          (gen-call-prim-vars source env
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

  (define (make-map-for-each-expander prim)
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

        (define (gen-conj-call-prim-vars source env prim vars)
          (if (pair? vars)
              (let ((code
                     (gen-call-prim-vars source env
                       prim
                       (list (car vars)))))
                (if (null? (cdr vars))
                    code
                    (new-conj source env
                      code
                      (gen-conj-call-prim-vars source env prim (cdr vars)))))
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
                        (gen-conj-call-prim-vars source env
                          **pair?-sym
                          (if (safe? env) ;; in case lists are truncated by other threads
                              lst2-vars
                              (list (car lst2-vars))))
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
                                            (gen-call-prim-vars source env
                                              **cdr-sym
                                              (list var)))
                                          lst2-vars))))
                              (if (eq? prim 'map)
                                (gen-call-prim source env
                                  **cons-sym
                                  (list (new-ref source env
                                          x-var)
                                        rec-call))
                                rec-call)))
                          (list (new-call source env
                                  (new-ref source env
                                    f-var)
                                  (map (lambda (var)
                                            (gen-call-prim-vars source env
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
                        (gen-conj-call-prim-vars source env
                          **pair?-sym
                          lst1-vars)
                        (new-call source env
                          (new-ref source env
                            loop1-var)
                          (map (lambda (var)
                                 (gen-call-prim-vars source env
                                   **cdr-sym
                                   (list var)))
                               lst1-vars))
                        (new-tst source env
                          (gen-conj-call-prim-vars source env
                            **null?-sym
                            lst1-vars)
                          (gen-main-loop)
                          (generate-call vars
                                         (not check-run-time-binding)))))))))

        (gen-prc source env
          vars
          (let ((check-proc
                 (and (safe? env)
                      (let ((f-arg (car args)))
                        (and (not (or (prc? f-arg)
                                      (and (cst? f-arg)
                                           (proc-obj? (cst-val f-arg)))))
                             (gen-call-prim-vars source env
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
                (if (safe? env)
                  (gen-check)
                  (gen-main-loop))
                (generate-call vars
                               (not check-run-time-binding)))
              (gen-main-loop)))))))

  (setup-c...r-primitives)
  (setup-set-c...r!-primitives)

  (def-exp "assq" (make-assq-memq-expander 'assq))
  (def-exp "assv" (make-assq-memq-expander 'assv))
  (def-exp "memq" (make-assq-memq-expander 'memq))
  (def-exp "memv" (make-assq-memq-expander 'memv))
  (def-exp "map" (make-map-for-each-expander 'map))
  (def-exp "for-each" (make-map-for-each-expander 'for-each)))

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

  (define **fxnot-sym (string->canonical-symbol "##fxnot"))
  (define **fxand-sym (string->canonical-symbol "##fxand"))
  (define **fxior-sym (string->canonical-symbol "##fxior"))
  (define **fxxor-sym (string->canonical-symbol "##fxxor"))

  (define bitwise-not-sym (string->canonical-symbol "bitwise-not"))
  (define bitwise-and-sym (string->canonical-symbol "bitwise-and"))
  (define bitwise-ior-sym (string->canonical-symbol "bitwise-ior"))
  (define bitwise-xor-sym (string->canonical-symbol "bitwise-xor"))

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
  (define **flasin-sym (string->canonical-symbol "##flasin"))
  (define **flacos-sym (string->canonical-symbol "##flacos"))
  (define **flatan-sym (string->canonical-symbol "##flatan"))
  (define **flexpt-sym (string->canonical-symbol "##flexpt"))
  (define **flsqrt-sym (string->canonical-symbol "##flsqrt"))
  (define **flcopysign-sym (string->canonical-symbol "##flcopysign"))

  (define **fixnum->flonum-sym (string->canonical-symbol "##fixnum->flonum"))

  (define **char?-sym (string->canonical-symbol "##char?"))

  (define **char=?-sym (string->canonical-symbol "##char=?"))
  (define **char<?-sym (string->canonical-symbol "##char<?"))
  (define **char>?-sym (string->canonical-symbol "##char>?"))
  (define **char<=?-sym (string->canonical-symbol "##char<=?"))
  (define **char>=?-sym (string->canonical-symbol "##char>=?"))

  (define **char-ci=?-sym (string->canonical-symbol "##char-ci=?"))
  (define **char-ci<?-sym (string->canonical-symbol "##char-ci<?"))
  (define **char-ci>?-sym (string->canonical-symbol "##char-ci>?"))
  (define **char-ci<=?-sym (string->canonical-symbol "##char-ci<=?"))
  (define **char-ci>=?-sym (string->canonical-symbol "##char-ci>=?"))

  (define **mem-allocated?-sym (string->canonical-symbol "##mem-allocated?"))
  (define **subtyped?-sym (string->canonical-symbol "##subtyped?"))
  (define **subtype-sym (string->canonical-symbol "##subtype"))

  (define (gen-fixnum-case gen)
    (gen-validating-case **fixnum?-sym gen))

  (define (gen-fixnum-division-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **fixnum?-sym
       (gen-call-prim source env
         **not-sym
         (list (gen-call-prim source env
                 **eqv?-sym
                 (list (new-ref source env
                         (cadr vars))
                       (new-cst source env
                         0)))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-flonum-case gen)
    (gen-validating-case **flonum?-sym gen))

  (define (gen-log-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (new-disj source env
         (gen-call-prim-vars source env
           **flnan?-sym
           vars)
         (gen-call-prim source env
           **not-sym
           (list (gen-call-prim source env
                   **flnegative?-sym
                   (list (gen-call-prim source env
                           **flcopysign-sym
                           (list (new-cst source env
                                   (macro-inexact-+1))
                                 (new-ref source env
                                   (car vars)))))))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-expt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (new-disj source env
         (gen-call-prim source env
           **not-sym
           (list (gen-call-prim-vars source env
                   **flnegative?-sym
                   (list (car vars)))))
         (gen-call-prim-vars source env
           **flinteger?-sym
           (list (cadr vars))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-sqrt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (gen-call-prim source env
         **not-sym
         (list (gen-call-prim-vars source env
                 **flnegative?-sym
                 vars)))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-finite-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (gen-call-prim-vars source env
         **flfinite?-sym
         vars)
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-asin-acos-atan-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (and (= (length vars) 1)
            (new-conj source env
              (gen-call-prim source env
                **not-sym
                (list (gen-call-prim source env
                        **fl<-sym
                        (list (new-cst source env
                                (macro-inexact-+1))
                              (new-ref source env
                                (car vars))))))
              (gen-call-prim source env
                **not-sym
                (list (gen-call-prim source env
                        **fl<-sym
                        (list (new-ref source env
                                (car vars))
                              (new-cst source env
                                (macro-inexact--1))))))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (no-case source
                   env
                   vars
                   check-run-time-binding
                   invalid
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
                   (generate-call vars #f)))) ;; handle other cases
            (gen-case source env
              vars
              check-run-time-binding
              generic-call
              generic-call))))))

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
                          (generate-call vars #f)))) ;; handle other cases
                   (gen-case source env
                     vars
                     check-run-time-binding
                     generic-call
                     generic-call))))))))

  (define (make-prim-generator prim)
    (lambda (source env vars invalid)
      (gen-call-prim-vars source env prim vars)))

  (define gen-fixnum-0
    (lambda (source env vars invalid)
      (new-cst source env
        0)))

  (define gen-fixnum-1
    (lambda (source env vars invalid)
      (new-cst source env
        1)))

  (define gen-flonum-0
    (lambda (source env vars invalid)
      (new-cst source env
        (macro-inexact-+0))))

  (define gen-flonum-1
    (lambda (source env vars invalid)
      (new-cst source env
        (macro-inexact-+1))))

  (define gen-first-arg
    (lambda (source env vars invalid)
      (new-ref source env
        (car vars))))

  (define (make-nary-generator zero one two-or-more)
    (lambda (source env vars invalid)
      (cond ((null? vars)
             (zero source env vars invalid))
            ((null? (cdr vars))
             (one source env vars invalid))
            (else
             (two-or-more source env vars invalid)))))

  (define (gen-fold source env vars invalid op-sym)

    (define (fold result vars)
      (if (null? vars)
        result
        (fold (gen-call-prim source env
                op-sym
                (list result
                      (new-ref source env
                        (car vars))))
              (cdr vars))))

    (fold (new-ref source env
            (car vars))
          (cdr vars)))

  (define (make-fold-generator op-sym)
    (lambda (source env vars invalid)
      (gen-fold source env
        vars
        invalid
        op-sym)))

  (define (gen-conditional-fold source env vars invalid gen-op)

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
                (invalid)))
            (list (gen-op source env result-var (car vars)))))))

    (conditional-fold (car vars)
                      (cdr vars)
                      (gen-temp-vars source (cdr vars))))

  (define (make-conditional-fold-generator conditional-op-sym)
    (lambda (source env vars invalid)
      (gen-conditional-fold source env
        vars
        invalid
        (lambda (source env var1 var2)
          (gen-call-prim-vars source env
            conditional-op-sym
            (list var1 var2))))))

  (define (make-conditional-fixed-arity-generator conditional-op-sym)
    (lambda (source env vars invalid)
      (let ((var (car (gen-temp-vars source '(#f)))))
        (new-call source env
          (gen-prc source env
            (list var)
            (new-tst source env
              (new-ref source env
                var)
              (new-ref source env
                var)
              (invalid)))
          (list (gen-call-prim-vars source env
                  conditional-op-sym
                  vars))))))

  (let ()

    (define case-fx=
      (gen-simple-case **fixnum?-sym **fx=-sym))

    (define case-fx<
      (gen-simple-case **fixnum?-sym **fx<-sym))

    (define case-fx>
      (gen-simple-case **fixnum?-sym **fx>-sym))

    (define case-fx<=
      (gen-simple-case **fixnum?-sym **fx<=-sym))

    (define case-fx>=
      (gen-simple-case **fixnum?-sym **fx>=-sym))

    (define case-fxzero?
      (gen-simple-case **fixnum?-sym **fxzero?-sym))

    (define case-fxpositive?
      (gen-simple-case **fixnum?-sym **fxpositive?-sym))

    (define case-fxnegative?
      (gen-simple-case **fixnum?-sym **fxnegative?-sym))

    (define case-fxodd?
      (gen-simple-case **fixnum?-sym **fxodd?-sym))

    (define case-fxeven?
      (gen-simple-case **fixnum?-sym **fxeven?-sym))

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
        (make-conditional-fold-generator **fx+?-sym))))

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
        (lambda (source env vars invalid)
          (new-tst source env
            (gen-disj-multi source env
              (map (lambda (var)
                     (gen-call-prim source env
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
              invalid
              (lambda (source env var1 var2)
                (new-tst source env
                  (gen-call-prim source env
                    **eqv?-sym
                    (list (new-ref source env
                            var2)
                          (new-cst source env
                            -1)))
                  (gen-call-prim-vars source env
                    **fx-?-sym
                    (list var1))
                  (gen-call-prim-vars source env
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
        (make-conditional-fixed-arity-generator **fx-?-sym)
        (lambda (source env vars invalid)
          (gen-conditional-fold source env
            vars
            invalid
            (lambda (source env var1 var2)
              (gen-call-prim-vars source env
                **fx-?-sym
                (list var1 var2))))))))

    (define case-fxwrapquotient
      (gen-fixnum-division-case
       (lambda (source env vars invalid)
         (gen-call-prim-vars source env
           **fxwrapquotient-sym
           vars))))

    (define case-fxquotient
      (gen-fixnum-division-case
       (lambda (source env vars invalid)
         (new-tst source env
           (gen-call-prim source env
             **eqv?-sym
             (list (new-ref source env
                     (cadr vars))
                   (new-cst source env
                     -1)))
           (new-disj source env
             (gen-call-prim-vars source env
               **fx-?-sym
               (list (car vars)))
             (invalid))
           (gen-call-prim-vars source env
             **fxquotient-sym
             vars)))))

    (define case-fxremainder
      (gen-fixnum-division-case
       (make-prim-generator **fxremainder-sym)))

    (define case-fxmodulo
      (gen-fixnum-division-case
       (make-prim-generator **fxmodulo-sym)))

    (define case-fxwrapabs
      (gen-simple-case **fixnum?-sym **fxwrapabs-sym))

    (define case-fxabs
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator **fxabs?-sym)))

    (define case-fxwrapsquare
      (gen-simple-case **fixnum?-sym **fxwrapsquare-sym))

    (define case-fxsquare
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator **fxsquare?-sym)))

    (define case-fxnot
      (gen-simple-case **fixnum?-sym **fxnot-sym))

    (define case-fxand
      (gen-simple-case **fixnum?-sym **fxand-sym))

    (define case-fxior
      (gen-simple-case **fixnum?-sym **fxior-sym))

    (define case-fxxor
      (gen-simple-case **fixnum?-sym **fxxor-sym))

    (define case-bitwise-not
      (gen-simple-case **fixnum?-sym **fxnot-sym))

    (define case-bitwise-and
      (gen-simple-case **fixnum?-sym **fxand-sym))

    (define case-bitwise-ior
      (gen-simple-case **fixnum?-sym **fxior-sym))

    (define case-bitwise-xor
      (gen-simple-case **fixnum?-sym **fxxor-sym))

    (define case-fxwraparithmetic-shift
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraparithmetic-shift?-sym)))

    (define case-fxarithmetic-shift
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift?-sym)))

    (define case-fxwraparithmetic-shift-left
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraparithmetic-shift-left?-sym)))

    (define case-fxarithmetic-shift-left
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift-left?-sym)))

    (define case-fxarithmetic-shift-right
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxarithmetic-shift-right?-sym)))

    (define case-fxwraplogical-shift-right
      (gen-fixnum-case
       (make-conditional-fixed-arity-generator
        **fxwraplogical-shift-right?-sym)))

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
      (gen-simple-case **flonum?-sym **fl=-sym))

    (define case-fl<
      (gen-simple-case **flonum?-sym **fl<-sym))

    (define case-fl>
      (gen-simple-case **flonum?-sym **fl>-sym))

    (define case-fl<=
      (gen-simple-case **flonum?-sym **fl<=-sym))

    (define case-fl>=
      (gen-simple-case **flonum?-sym **fl>=-sym))

    (define case-flinteger?
      (gen-simple-case **flonum?-sym **flinteger?-sym))

    (define case-flzero?
      (gen-simple-case **flonum?-sym **flzero?-sym))

    (define case-flpositive?
      (gen-simple-case **flonum?-sym **flpositive?-sym))

    (define case-flnegative?
      (gen-simple-case **flonum?-sym **flnegative?-sym))

    (define case-flodd?
      (gen-simple-case **flonum?-sym **flodd?-sym))

    (define case-fleven?
      (gen-simple-case **flonum?-sym **fleven?-sym))

    (define case-flfinite?
      (gen-simple-case **flonum?-sym **flfinite?-sym))

    (define case-flinfinite?
      (gen-simple-case **flonum?-sym **flinfinite?-sym))

    (define case-flnan?
      (gen-simple-case **flonum?-sym **flnan?-sym))

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
      (gen-simple-case **flonum?-sym **flabs-sym))

    (define case-flsquare
      (gen-simple-case **flonum?-sym **flsquare-sym))

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
      (gen-simple-case **flonum?-sym **flexp-sym))

    (define case-fllog
      (gen-log-flonum-case
       (make-prim-generator **fllog-sym)))

    (define case-flsin
      (gen-simple-case **flonum?-sym **flsin-sym))

    (define case-flcos
      (gen-simple-case **flonum?-sym **flcos-sym))

    (define case-fltan
      (gen-simple-case **flonum?-sym **fltan-sym))

    (define case-flasin
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flasin-sym)))

    (define case-flacos
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flacos-sym)))

    (define case-flatan
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flatan-sym)))

    (define case-flexpt
      (gen-expt-flonum-case
       (make-prim-generator **flexpt-sym)))

    (define case-flsqrt
      (gen-sqrt-flonum-case
       (make-prim-generator **flsqrt-sym)))

    (define case-flonum-exact->inexact
      (gen-flonum-case
       gen-first-arg))

    (define case-flonum-inexact->exact
      no-case)

    (define case-char=?
      (gen-simple-case **char?-sym **char=?-sym))

    (define case-char<?
      (gen-simple-case **char?-sym **char<?-sym))

    (define case-char>?
      (gen-simple-case **char?-sym **char>?-sym))

    (define case-char<=?
      (gen-simple-case **char?-sym **char<=?-sym))

    (define case-char>=?
      (gen-simple-case **char?-sym **char>=?-sym))

    (define (case-eqv?-or-equal? prim)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (let ((var1 (car vars))
                 (var2 (cadr vars)))
             (new-disj source env
               (gen-call-prim source env
                 **eq?-sym
                 (list (new-ref source env
                         var1)
                       (new-ref source env
                         var2)))
               (new-conj source env
                 (gen-call-prim source env
                   prim
                   (list (new-ref source env
                           var1)))
                 (new-conj source env
                   (gen-call-prim source env
                     prim
                     (list (new-ref source env
                             var2)))
                   (new-conj source env
                     (gen-call-prim source env
                       **fx=-sym
                       (list (gen-call-prim source env
                               **subtype-sym
                               (list (new-ref source env
                                       var1)))
                             (gen-call-prim source env
                               **subtype-sym
                               (list (new-ref source env
                                       var2)))))
                     (invalid)))))))
         fail)))

    (define case-real?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-disj source env
               (gen-call-prim-vars source env **flonum?-sym vars)
               (gen-call-prim-vars source env **real?-sym vars))))
         fail)))

    (define case-rational?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-tst source env
               (gen-call-prim-vars source env **flonum?-sym vars)
               (gen-call-prim-vars source env **flfinite?-sym vars)
               (gen-call-prim-vars source env **rational?-sym vars))))
         fail)))

    (define case-integer?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (gen-call-prim-vars source env **integer?-sym vars)))
         fail)))

    (define (case-exact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-conj source env
               (gen-call-prim source env
                 **not-sym
                 (list (gen-call-prim-vars source env **flonum?-sym vars)))
               (gen-call-prim-vars source env fallback vars))))
         fail)))

    (define (case-inexact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-conj source env
             (gen-call-prim source env
               **not-sym
               (list (gen-call-prim-vars source env **fixnum?-sym vars)))
             (new-disj source env
               (gen-call-prim-vars source env **flonum?-sym vars)
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
    (def-exp "="   (make-fixflo-expander case-fx= case-fl=))

    (def-exp "fx<" (make-simple-expander case-fx<))
    (def-exp "fl<" (make-simple-expander case-fl<))
    (def-exp "<"   (make-fixflo-expander case-fx< case-fl<))

    (def-exp "fx>" (make-simple-expander case-fx>))
    (def-exp "fl>" (make-simple-expander case-fl>))
    (def-exp ">"   (make-fixflo-expander case-fx> case-fl>))

    (def-exp "fx<=" (make-simple-expander case-fx<=))
    (def-exp "fl<=" (make-simple-expander case-fl<=))
    (def-exp "<="   (make-fixflo-expander case-fx<= case-fl<=))

    (def-exp "fx>=" (make-simple-expander case-fx>=))
    (def-exp "fl>=" (make-simple-expander case-fl>=))
    (def-exp ">="   (make-fixflo-expander case-fx>= case-fl>=))

    (def-exp "flinteger?" (make-simple-expander case-flinteger?))

    (def-exp "fxzero?" (make-simple-expander case-fxzero?))
    (def-exp "flzero?" (make-simple-expander case-flzero?))
    (def-exp "zero?"   (make-fixflo-expander case-fxzero? case-flzero?))

    (def-exp "fxpositive?" (make-simple-expander case-fxpositive?))
    (def-exp "flpositive?" (make-simple-expander case-flpositive?))
    (def-exp "positive?"   (make-fixflo-expander case-fxpositive? case-flpositive?))

    (def-exp "fxnegative?" (make-simple-expander case-fxnegative?))
    (def-exp "flnegative?" (make-simple-expander case-flnegative?))
    (def-exp "negative?"   (make-fixflo-expander case-fxnegative? case-flnegative?))

    (def-exp "fxodd?" (make-simple-expander case-fxodd?))
    (def-exp "flodd?" (make-simple-expander case-flodd?))
    (def-exp "odd?"   (make-fixflo-expander case-fxodd? case-flodd?))

    (def-exp "fxeven?" (make-simple-expander case-fxeven?))
    (def-exp "fleven?" (make-simple-expander case-fleven?))
    (def-exp "even?"   (make-fixflo-expander case-fxeven? case-fleven?))

    (def-exp "flfinite?" (make-simple-expander case-flfinite?))
    (def-exp "finite?"   (make-fixflo-expander no-case case-flfinite?))

    (def-exp "flinfinite?" (make-simple-expander case-flinfinite?))
    (def-exp "infinite?"   (make-fixflo-expander no-case case-flinfinite?))

    (def-exp "flnan?" (make-simple-expander case-flnan?))
    (def-exp "nan?"   (make-fixflo-expander no-case case-flnan?))

    (def-exp "fxmax" (make-simple-expander case-fxmax))
    (def-exp "flmax" (make-simple-expander case-flmax))
    (def-exp "max"   (make-fixflo-expander case-fxmax case-flmax))

    (def-exp "fxmin" (make-simple-expander case-fxmin))
    (def-exp "flmin" (make-simple-expander case-flmin))
    (def-exp "min"   (make-fixflo-expander case-fxmin case-flmin))

    (def-exp "fxwrap+" (make-simple-expander case-fxwrap+))
    (def-exp "fx+"     (make-simple-expander case-fx+))
    (def-exp "fl+"     (make-simple-expander case-fl+))
    (def-exp "+"       (make-fixflo-expander
                         case-fx+
                         (gen-flonum-case
                          (make-nary-generator
                           gen-fixnum-0
                           gen-first-arg
                           (make-fold-generator **fl+-sym)))))

    (def-exp "fxwrap*" (make-simple-expander case-fxwrap*))
    (def-exp "fx*"     (make-simple-expander case-fx*))
    (def-exp "fl*"     (make-simple-expander case-fl*))
    (def-exp "*"       (make-fixflo-expander
                         case-fx*
                         (gen-flonum-case
                          (make-nary-generator
                           gen-fixnum-1
                           gen-first-arg
                           (make-fold-generator **fl*-sym)))))

    (def-exp "fxwrap-" (make-simple-expander case-fxwrap-))
    (def-exp "fx-"     (make-simple-expander case-fx-))
    (def-exp "fl-"     (make-simple-expander case-fl-))
    (def-exp "-"       (make-fixflo-expander case-fx- case-fl-))

    (def-exp "fl/"     (make-simple-expander case-fl/))
    (def-exp "/"       (make-fixflo-expander no-case case-fl/))

    (def-exp "fxwrapquotient" (make-simple-expander case-fxwrapquotient))
    (def-exp "fxquotient"     (make-simple-expander case-fxquotient))
    (def-exp "quotient"       (make-fixnum-division-expander case-fxquotient))

    (def-exp "fxremainder" (make-simple-expander case-fxremainder))
    (def-exp "remainder"   (make-fixnum-division-expander case-fxremainder))

    (def-exp "fxmodulo" (make-simple-expander case-fxmodulo))
    (def-exp "modulo"   (make-fixnum-division-expander case-fxmodulo))

    (def-exp "fxnot" (make-simple-expander case-fxnot))

    (def-exp "fxand" (make-simple-expander case-fxand))

    (def-exp "fxior" (make-simple-expander case-fxior))

    (def-exp "fxxor" (make-simple-expander case-fxxor))

    (def-exp "bitwise-not" (make-simple-expander case-bitwise-not))

    (def-exp "bitwise-and" (make-simple-expander case-bitwise-and))

    (def-exp "bitwise-ior" (make-simple-expander case-bitwise-ior))

    (def-exp "bitwise-xor" (make-simple-expander case-bitwise-xor))

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
    (def-exp "abs"   (make-fixflo-expander case-fxabs case-flabs))

    (def-exp "fxwrapsquare" (make-simple-expander case-fxwrapsquare))
    (def-exp "fxsquare" (make-simple-expander case-fxsquare))
    (def-exp "flsquare" (make-simple-expander case-flsquare))
    (def-exp "square"   (make-fixflo-expander case-fxsquare case-flsquare))

    (def-exp "flfloor" (make-simple-expander case-flfloor))
    (def-exp "floor"   (make-fixflo-expander no-case case-flfloor))

    (def-exp "flceiling" (make-simple-expander case-flceiling))
    (def-exp "ceiling"   (make-fixflo-expander no-case case-flceiling))

    (def-exp "fltruncate" (make-simple-expander case-fltruncate))
    (def-exp "truncate"   (make-fixflo-expander no-case case-fltruncate))

    (def-exp "flround" (make-simple-expander case-flround))
    (def-exp "round"   (make-fixflo-expander no-case case-flround))

    (def-exp "flexp" (make-simple-expander case-flexp))
    (def-exp "exp"   (make-fixflo-expander no-case case-flexp))

    (def-exp "fllog" (make-simple-expander case-fllog))
    (def-exp "log"   (make-fixflo-expander no-case case-fllog))

    (def-exp "flsin" (make-simple-expander case-flsin))
    (def-exp "sin"   (make-fixflo-expander no-case case-flsin))

    (def-exp "flcos" (make-simple-expander case-flcos))
    (def-exp "cos"   (make-fixflo-expander no-case case-flcos))

    (def-exp "fltan" (make-simple-expander case-fltan))
    (def-exp "tan"   (make-fixflo-expander no-case case-fltan))

    (def-exp "flasin" (make-simple-expander case-flasin))
    (def-exp "asin"   (make-fixflo-expander no-case case-flasin))

    (def-exp "flacos" (make-simple-expander case-flacos))
    (def-exp "acos"   (make-fixflo-expander no-case case-flacos))

    (def-exp "flatan" (make-simple-expander case-flatan))
    (def-exp "atan"   (make-fixflo-expander no-case case-flatan))

    (def-exp "flexpt" (make-simple-expander case-flexpt))
    (def-exp "expt"   (make-fixflo-expander no-case case-flexpt))

    (def-exp "flsqrt" (make-simple-expander case-flsqrt))
    (def-exp "sqrt"   (make-fixflo-expander no-case case-flsqrt))

    (def-exp "fixnum->flonum" (make-simple-expander case-fixnum->flonum))

    (def-exp
     "exact->inexact"
     (make-fixflo-expander
      case-fixnum-exact->inexact
      case-flonum-exact->inexact))

    (def-exp
     "inexact->exact"
     (make-fixflo-expander
      case-fixnum-inexact->exact
      case-flonum-inexact->exact))

    (def-exp "char=?" (make-simple-expander case-char=?))
    (def-exp "char<?" (make-simple-expander case-char<?))
    (def-exp "char>?" (make-simple-expander case-char>?))
    (def-exp "char<=?" (make-simple-expander case-char<=?))
    (def-exp "char>=?" (make-simple-expander case-char>=?))

    (if (eq? (target-name targ) 'C)
        (begin

          (def-exp
            "eqv?"
            (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

          (def-exp
            "##eqv?"
            (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

          (def-exp
            "equal?"
            (make-simple-expander (case-eqv?-or-equal? **mem-allocated?-sym)))))
))

(define (setup-vector-primitives)

  (define **fixnum?-sym (string->canonical-symbol "##fixnum?"))
  (define **flonum?-sym (string->canonical-symbol "##flonum?"))
  (define **char?-sym   (string->canonical-symbol "##char?"))
  (define **fx<-sym     (string->canonical-symbol "##fx<"))
  (define **fx<=-sym    (string->canonical-symbol "##fx<="))
  (define **mutable?-sym (string->canonical-symbol "##mutable?"))

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

            (gen-call-prim-vars source env
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
                    (gen-call-prim source env
                      **fixnum?-sym
                      (list (new-cst source env
                              hi)))
                    interval-check)))))))

  (define (make-flonum-checker)
    (lambda (source env var)
      (gen-call-prim-vars source env
        **flonum?-sym
        (list var))))

  (define (gen-fixnum-interval-check source env var lo hi incl?)
    (let* ((fixnum-check
            (gen-call-prim-vars source env
              **fixnum?-sym
              (list var)))
           (interval-check
            (new-conj source env
              fixnum-check
              (new-conj source env
                (gen-call-prim source env
                  **fx<=-sym
                  (list lo
                        (new-ref source env
                          var)))
                (gen-call-prim source env
                  (if incl? **fx<=-sym **fx<-sym)
                  (list (new-ref source env
                          var)
                        hi))))))
      interval-check))

  (define (make-vector-expanders
           vect?-str
           vect-length-str
           vect-ref-str
           vect-set!-str
           vect-cas!-str
           vect-inc!-str
           **vect?-str
           **vect-length-str
           **vect-ref-str
           **vect-set!-str
           **vect-cas!-str
           **vect-inc!-str
           value-checker)
    (let ((vect?-sym (string->canonical-symbol vect?-str))
          (vect-length-sym (string->canonical-symbol vect-length-str))
          (vect-ref-sym (string->canonical-symbol vect-ref-str))
          (vect-set!-sym (string->canonical-symbol vect-set!-str))
          (vect-cas!-sym (and vect-cas!-str (string->canonical-symbol vect-cas!-str)))
          (vect-inc!-sym (and vect-inc!-str (string->canonical-symbol vect-inc!-str)))
          (**vect?-sym (string->canonical-symbol **vect?-str))
          (**vect-length-sym (string->canonical-symbol **vect-length-str))
          (**vect-ref-sym (string->canonical-symbol **vect-ref-str))
          (**vect-set!-sym (string->canonical-symbol **vect-set!-str))
          (**vect-cas!-sym (and **vect-cas!-str (string->canonical-symbol **vect-cas!-str)))
          (**vect-inc!-sym (and **vect-inc!-str (string->canonical-symbol **vect-inc!-str))))

      (define (gen-type-check source env vect-arg)
        (gen-call-prim-vars source env
          **vect?-sym
          (list vect-arg)))

      (define (gen-mutability-check source env vect-arg)
        (gen-call-prim-vars source env
          **mutable?-sym
          (list vect-arg)))

      (define (gen-index-check source env vect-arg index-arg)
        (gen-fixnum-interval-check source env
          index-arg
          (new-cst source env
            0)
          (gen-call-prim-vars source env
            **vect-length-sym
            (list vect-arg))
          #f))

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
                       (gen-type-check source env arg1)))
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
                  (gen-call-prim-vars source env
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
                       (gen-type-check source env arg1)))
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
                  (gen-call-prim-vars source env
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
   "vector?"
   "vector-length"
   "vector-ref"
   "vector-set!"
   "vector-cas!"
   "vector-inc!"
   "##vector?"
   "##vector-length"
   "##vector-ref"
   "##vector-set!"
   "##vector-cas!"
   "##vector-inc!"
   #f)

  (make-vector-expanders
   "string?"
   "string-length"
   "string-ref"
   "string-set!"
   #f
   #f
   "##string?"
   "##string-length"
   "##string-ref"
   "##string-set!"
   #f
   #f
   (lambda (source env var)
     (gen-call-prim-vars source env
       **char?-sym
       (list var))))

  (make-vector-expanders
   "s8vector?"
   "s8vector-length"
   "s8vector-ref"
   "s8vector-set!"
   #f
   #f
   "##s8vector?"
   "##s8vector-length"
   "##s8vector-ref"
   "##s8vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -128 127))

  (make-vector-expanders
   "u8vector?"
   "u8vector-length"
   "u8vector-ref"
   "u8vector-set!"
   #f
   #f
   "##u8vector?"
   "##u8vector-length"
   "##u8vector-ref"
   "##u8vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 255))

  (make-vector-expanders
   "s16vector?"
   "s16vector-length"
   "s16vector-ref"
   "s16vector-set!"
   #f
   #f
   "##s16vector?"
   "##s16vector-length"
   "##s16vector-ref"
   "##s16vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -32768 32767))

  (make-vector-expanders
   "u16vector?"
   "u16vector-length"
   "u16vector-ref"
   "u16vector-set!"
   #f
   #f
   "##u16vector?"
   "##u16vector-length"
   "##u16vector-ref"
   "##u16vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 65535))

#;
  (make-vector-expanders
   "s32vector?"
   "s32vector-length"
   "s32vector-ref"
   "s32vector-set!"
   #f
   #f
   "##s32vector?"
   "##s32vector-length"
   "##s32vector-ref"
   "##s32vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -2147483648 2147483647))

#;
  (make-vector-expanders
   "u32vector?"
   "u32vector-length"
   "u32vector-ref"
   "u32vector-set!"
   #f
   #f
   "##u32vector?"
   "##u32vector-length"
   "##u32vector-ref"
   "##u32vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 4294967295))

#;
  (make-vector-expanders
   "s64vector?"
   "s64vector-length"
   "s64vector-ref"
   "s64vector-set!"
   #f
   #f
   "##s64vector?"
   "##s64vector-length"
   "##s64vector-ref"
   "##s64vector-set!"
   #f
   #f
   (make-fixnum-interval-checker -9223372036854775808 9223372036854775807))

#;
  (make-vector-expanders
   "u64vector?"
   "u64vector-length"
   "u64vector-ref"
   "u64vector-set!"
   #f
   #f
   "##u64vector?"
   "##u64vector-length"
   "##u64vector-ref"
   "##u64vector-set!"
   #f
   #f
   (make-fixnum-interval-checker 0 18446744073709551615))

  (make-vector-expanders
   "f32vector?"
   "f32vector-length"
   "f32vector-ref"
   "f32vector-set!"
   #f
   #f
   "##f32vector?"
   "##f32vector-length"
   "##f32vector-ref"
   "##f32vector-set!"
   #f
   #f
   (make-flonum-checker))

  (make-vector-expanders
   "f64vector?"
   "f64vector-length"
   "f64vector-ref"
   "f64vector-set!"
   #f
   #f
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

  (define (gen-type-check source env obj-arg type-arg)
    (gen-call-prim source env
      **structure-direct-instance-of?-sym
      (list (new-ref source env
              obj-arg)
            (gen-call-prim-vars source env
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
              (gen-type-check source env obj-var type-var))
             (call-prim
              (gen-call-prim-vars source env
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

(setup-list-primitives)
(setup-numeric-primitives)
(setup-vector-primitives)
(setup-structure-primitives)

)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure constant folders

(define (setup-prim-constant-folders targ)

;; TODO: remove dependencies to C back-end

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

(define (def-fold name . folders)
  (let ((fold
         (lambda (args)
           (let loop ((lst folders))
             (if (pair? lst)
                 (let* ((folder (car lst))
                        (result (folder args)))
                   (if (type-universal? result)
                       (loop (cdr lst))
                       result))
                 (make-type-universal))))))

    (define (fold-set name)
      (let ((proc (get-prim-info name)))
        (if proc (proc-obj-constant-fold-set! proc fold))))

    (fold-set name)
    (fold-set (string-append "##" name))))

(define (convert-result val)
  val) ;; TODO: handle false-object, etc

(define (constant-folder op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (make-type-singleton result)))
   type-patterns))

(define (constant-folder-gen op . type-patterns)
  (apply constant-folder (cons op type-patterns)))

(define (constant-folder-fix op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (or (and (or (not (number? result))
                    (targ-fixnum32? result)) ;; TODO: remove dependency on C back-end
                (make-type-singleton result))
           (make-type-universal))))
   type-patterns))

(define (constant-folder-flo op . type-patterns)
  (constant-folder-arg-type-check
   (lambda (arg-vals)
     (let ((result (convert-result (apply op arg-vals))))
       (or (and (or (not (number? result))
                    (targ-flonum? result)) ;; TODO: remove dependency on C back-end
                (make-type-singleton result))
           (make-type-universal))))
   type-patterns))

(define (constant-folder-arg-type-check folder type-patterns)
  (let ((type-patterns
         (if (null? type-patterns)
           (list (lambda (val) #t))
           type-patterns)))
    (lambda (args)

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

      (or (and (every? type-singleton? args) ;; are all arguments known values?
               (let ((arg-vals (map type-singleton-val args)))
                 (let loop ((type-pats type-patterns))
                   (if (pair? type-pats)
                       (if (match? arg-vals (car type-pats))
                           (folder arg-vals)
                           (loop (cdr type-pats)))
                       (make-type-universal)))))
          (make-type-universal)))))

(define (constant-folder-ref op get-length vect-type?)
  (lambda (args)
    (and (every? type-singleton? args) ;; are all arguments known values?
         (let* ((arg-vals (map type-singleton-val args))
                (vect (car arg-vals))
                (index (cadr arg-vals)))
           (or (and (vect-type? vect)
                    (integer? index)
                    (exact? index)
                    (not (< index 0))
                    (< index (get-length vect))
                    (let ((result (op vect index)))
                      (make-type-singleton result)))
               (make-type-universal))))))

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

(def-fold "not"              (constant-folder false-object?  ))
(def-fold "boolean?"         (constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (eq? obj #t)))))
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
(def-fold "pair?"            (constant-folder pair?          ))
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
(def-fold "symbol?"          (constant-folder symbol-object? ))
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
(def-fold "="                (constant-folder =              num?))
(def-fold "fx="              (constant-folder =              fix32?))
(def-fold "fl="              (constant-folder =              flo?))
(def-fold "<"                (constant-folder <              real?))
(def-fold "fx<"              (constant-folder <              fix32?))
(def-fold "fl<"              (constant-folder <              flo?))
(def-fold ">"                (constant-folder >              real?))
(def-fold "fx>"              (constant-folder >              fix32?))
(def-fold "fl>"              (constant-folder >              flo?))
(def-fold "<="               (constant-folder <=             real?))
(def-fold "fx<="             (constant-folder <=             fix32?))
(def-fold "fl<="             (constant-folder <=             flo?))
(def-fold ">="               (constant-folder >=             real?))
(def-fold "fx>="             (constant-folder >=             fix32?))
(def-fold "fl>="             (constant-folder >=             flo?))
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
(def-fold "fxwrap+"          (constant-folder-fix +          fix32?))
(def-fold "fx+"              (constant-folder-fix +          fix32?))
(def-fold "fx+?"             (constant-folder-fix +          fix32?))
(def-fold "fl+"              (constant-folder-flo +          flo?));;TODO: must return 0.0 when 0 args
(def-fold "*"                (constant-folder-gen *          num?))
(def-fold "fxwrap*"          (constant-folder-fix *          fix32?))
(def-fold "fx*"              (constant-folder-fix *          fix32?))
(def-fold "fx*?"             (constant-folder-fix *          fix32?))
(def-fold "fl*"              (constant-folder-flo *          flo?));;TODO: must return 1.0 when 0 args
(def-fold "-"                (constant-folder-gen -          num?))
(def-fold "fxwrap-"          (constant-folder-fix -          fix32?))
(def-fold "fx-"              (constant-folder-fix -          fix32?))
(def-fold "fx-?"             (constant-folder-fix -          fix32?))
(def-fold "fl-"              (constant-folder-flo -          flo?))
(def-fold "/"                (constant-folder-gen /
                                                  (list nz-num?)
                                                  (cons num?
                                                        (cons nz-num?
                                                              nz-num?))))
(def-fold "fl/"              (constant-folder-flo /
                                                  (list nz-flo?)
                                                        (cons flo?
                                                              (cons nz-flo?
                                                                    nz-flo?))))
(def-fold "abs"              (constant-folder-gen abs          num?))
(def-fold "fxwrapabs"        (constant-folder-fix abs          fix32?))
(def-fold "fxabs"            (constant-folder-fix abs          fix32?))
(def-fold "fxabs?"           (constant-folder-fix abs          fix32?))
(def-fold "flabs"            (constant-folder-flo abs          flo?))
(def-fold "square"           (constant-folder-gen square       num?))
(def-fold "fxwrapsquare"     (constant-folder-fix square       fix32?))
(def-fold "fxsquare"         (constant-folder-fix square       fix32?))
(def-fold "fxsquare?"        (constant-folder-fix square       fix32?))
(def-fold "flsquare"         (constant-folder-flo square       flo?))
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
(def-fold "expt"             (constant-folder-gen expt       num?))
(def-fold "flexpt"           (constant-folder-flo expt       flo?))
(def-fold "sqrt"             (constant-folder-gen sqrt       num?))
(def-fold "flsqrt"           (constant-folder-flo sqrt       flo?))
(def-fold "expt"             (constant-folder-gen expt       num?))
(def-fold "##flonum->fixnum" (constant-folder-fix inexact->exact flo?))

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

(def-fold "char?"            (constant-folder char?          ))
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

(def-fold "string?"          (constant-folder string?        ))
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

(def-fold "vector?"          (constant-folder vector-object? ))
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

(def-fold "procedure?"       (constant-folder proc-obj?      ))
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
(def-fold "keyword?"         (constant-folder keyword-object?))
(def-fold "keyword->string"  (constant-folder keyword-object->string))
(def-fold "string->keyword"  (constant-folder string->keyword-object))
(def-fold "void"             (constant-folder (lambda () void-object)))

(def-fold "fixnum?"          (constant-folder fix32?         not-bigfix?))
(def-fold "flonum?"          (constant-folder flo?           ))
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Type representation.

;; TODO: remove dependency on C back-end

;; There is a representation for the types boolean, fixnum, flonum,
;; char, symbol, keyword, string, vector and pair, and also the type
;; fixnum-or-false that contains all the fixnum and #f (useful for the
;; overflow checking fixnum primitives).  If use-complement-types? is
;; #t, there is also a representation for the complement of the types
;; boolean, fixnum, flonum, char, symbol, keyword, string, vector and
;; pair.  Finally there is a singleton type that contains a single
;; value.
;;
;;            fixnum-or-false
;;            +--------------------------------------+
;;            |                                      |
;;   boolean  |       fixnum                         |  flonum
;;   +--------|----+  +---------------------------+  |  +-------------+
;;   |   #t   | #f |  | ...  -2  -1  0  1  2  ... |  |  | ... 1.3 ... |
;;   +--------|----+  +---------------------------+  |  +-------------+
;;            |                                      |
;;            +--------------------------------------+
;;
;;   etc.
;;
;; not-boolean is the complement of boolean
;; not-fixnum is the complement of fixnum
;; not-flonum is the complement of flonum
;; not-char is the complement of char
;; not-symbol is the complement of symbol
;; not-keyword is the complement of keyword
;; not-string is the complement of string
;; not-vector is the complement of vector
;; not-pair is the complement of pair

(define use-complement-types? #f)
(set! use-complement-types? #f)

(define (type-specific? type)
  (or (type-boolean? type)
      (type-fixnum? type)
      (type-flonum? type)
      (type-char? type)
      (type-symbol? type)
      (type-keyword? type)
      (type-string? type)
      (type-vector? type)
      (type-pair? type)))

(define (type-specific-complement? type)
  (and use-complement-types?
       (or (type-not-boolean? type)
           (type-not-fixnum? type)
           (type-not-flonum? type)
           (type-not-char? type)
           (type-not-symbol? type)
           (type-not-keyword? type)
           (type-not-string? type)
           (type-not-vector? type)
           (type-not-pair? type))))

(define (type-specific-complement-except? not-of-type? type)
  (and (type-specific-complement? type)
       (not (not-of-type? type))))

(define (type-complement of-type? singleton-of-type? not-of-type? type)
  (cond ((not-of-type? type)
         #t)
        ((or (type-specific-complement? type)
             (of-type? type)
             (and (type-singleton? type)
                  (not (singleton-of-type? type)))) ;; handles 'maybe
         #f)
        (else
         #t)))

;;; singleton type

(define (make-type-singleton val)
  (cons val '()))

(define (type-singleton? type)
  (and (pair? type)
       (let ((x (cdr type)))
         (eq? x '()))))

(define (type-singleton-val type)
  (car type))

(define (type-singleton-of-type? value-of-type? type)
  (and (type-singleton? type)
       (let ((val (type-singleton-val type)))
         (value-of-type? val))))

;;; boolean type

(define (make-type-boolean)
  'boolean)

(define (type-boolean? type)
  (eq? type (make-type-boolean)))

(define (isa-boolean? type)
  (or (type-boolean? type)
      (type-singleton-boolean? type)))

(define (type-singleton-boolean? type)
  (type-singleton-of-type? type-value-boolean? type))

(define (type-value-boolean? val)
  (or (type-value-false? val)
      (eq? val #t)))

(define (type-singleton-false? type)
  (type-singleton-of-type? type-value-false? type))

(define (type-value-false? val)
  (false-object? val))

;;; not-boolean type

(define type-not-boolean-tag
  '!boolean)

(define (make-type-not-boolean)
  (if use-complement-types?
      type-not-boolean-tag
      (make-type-universal)))

(define (type-not-boolean? type)
  (eq? type type-not-boolean-tag))

(define (isa-not-boolean? type)
  (and (not (type-universal? type))
       (not (type-fixnum-or-false? type))
       (type-complement type-boolean?
                        type-singleton-boolean?
                        type-not-boolean?
                        type)))

;;; fixnum type

(define (make-type-fixnum lo hi)
  ;; lo can be an int or >= (min fixnum) or > (min fixnum + 1) or #f (overflow)
  ;; hi can be an int or <= (max fixnum) or < (max fixnum - 1) or #f (overflow)
  (cons lo hi))

(define (type-fixnum? type)
  (and (pair? type)
       (let ((x (cdr type)))
         (and (not (eq? x '()))
              (not (eq? x 'delay))))))

(define (type-fixnum-lo type)
  (car type))

(define (type-fixnum-hi type)
  (cdr type))

(define (type-fixnum-range-size type)
  (declare (generic))
  (let* ((t (type-fixnum-from-possibly-singleton type))
         (lo (type-fixnum-lo t))
         (lo-num (cond ((eq? lo '>=) targ-min-fixnum32)
                       ((eq? lo '>)  (+ targ-min-fixnum32 1))
                       (else         lo)))
         (hi (type-fixnum-hi t))
         (hi-num (cond ((eq? hi '<=) targ-max-fixnum32)
                       ((eq? hi '<)  (- targ-max-fixnum32 1))
                       (else         hi))))
    (+ (- hi-num lo-num) 1)))

(define (type-fixnum-from-possibly-singleton type)
  (if (type-singleton? type)
      (let ((val (type-singleton-val type)))
        (make-type-fixnum-bounded val val))
      type))

(define (make-type-fixnum-bounded lo hi)
  (make-type-fixnum
   (cond ((not (number? lo))             lo)
         ((< lo targ-min-fixnum32)       #f)
         ((= lo targ-min-fixnum32)       '>=)
         ((= lo (+ targ-min-fixnum32 1)) '>)
         (else                           lo))
   (cond ((not (number? hi))             hi)
         ((> hi targ-max-fixnum32)       #f)
         ((= hi targ-max-fixnum32)       '<=)
         ((= hi (- targ-max-fixnum32 1)) '<)
         (else                           hi))))

(define (type-fixnum-normalize type)
  (let ((lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))
    (if (and (number? lo) (number? hi) (= lo hi))
        (make-type-singleton lo)
        type)))

(define (type-fixnum-normalize-clamp type)
  (let ((lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))
    (if (or (not lo) (not hi))
        (make-type-fixnum (or lo '>=) (or hi '<=))
        (type-fixnum-normalize type))))

(define (type-fixnum-normalize-wrap type)
  (let ((lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))
    (if (or (not lo) (not hi))
        (make-type-fixnum '>= '<=)
        (type-fixnum-normalize type))))

(define (type-fixnum-normalize-false type)
  (let ((lo (type-fixnum-lo type))
        (hi (type-fixnum-hi type)))
    (if (or (not lo) (not hi))
        (make-type-fixnum-or-false)
        (type-fixnum-normalize type))))

(define (isa-fixnum? type)
  (or (type-fixnum? type)
      (eq? #t (type-singleton-fixnum? type)))) ;; exclude 'maybe

(define (type-singleton-fixnum? type) ;; returns #f, #t or 'maybe
  (type-singleton-of-type? type-value-fixnum? type))

(define (type-value-fixnum? val)
  (cond ((targ-fixnum32? val)
         #t)
        ((targ-fixnum64? val)
         'maybe)
        (else
         #f)))

;;; not-fixnum type

(define type-not-fixnum-tag
  '!fixnum)

(define (make-type-not-fixnum)
  (if use-complement-types?
      type-not-fixnum-tag
      (make-type-universal)))

(define (type-not-fixnum? type)
  (eq? type type-not-fixnum-tag))

(define (isa-not-fixnum? type)
  (and (not (type-universal? type))
       (not (type-fixnum-or-false? type))
       (type-complement type-fixnum?
                        type-singleton-fixnum?
                        type-not-fixnum?
                        type)))

;;; fixnum-or-false type

(define (make-type-fixnum-or-false)
  '?fixnum)

(define (type-fixnum-or-false? type)
  (eq? type (make-type-fixnum-or-false)))

(define (isa-fixnum-or-false? type)
  (or (type-fixnum-or-false? type)
      (type-fixnum? type)
      (type-singleton-fixnum-or-false? type)))

(define (type-singleton-fixnum-or-false? type)
  (type-singleton-of-type? type-value-fixnum-or-false? type))

(define (type-value-fixnum-or-false? val)
  (or (type-value-false? val)
      (type-value-fixnum? val)))

(define (type-not-boolean-or-not-fixnum? type)
  (or (type-not-boolean? type)
      (type-not-fixnum? type)))

;;; flonum type

(define (make-type-flonum)
  'flonum)

(define (type-flonum? type)
  (eq? type (make-type-flonum)))

(define (isa-flonum? type)
  (or (type-flonum? type)
      (type-singleton-flonum? type)))

(define (type-singleton-flonum? type)
  (type-singleton-of-type? type-value-flonum? type))

(define (type-value-flonum? val)
  (targ-flonum? val))

;;; not-flonum type

(define type-not-flonum-tag
  '!flonum)

(define (make-type-not-flonum)
  (if use-complement-types?
      type-not-flonum-tag
      (make-type-universal)))

(define (type-not-flonum? type)
  (eq? type type-not-flonum-tag))

(define (isa-not-flonum? type)
  (and (not (type-universal? type))
       (type-complement type-flonum?
                        type-singleton-flonum?
                        type-not-flonum?
                        type)))

;;; char type

(define (make-type-char)
  'char)

(define (type-char? type)
  (eq? type (make-type-char)))

(define (isa-char? type)
  (or (type-char? type)
      (type-singleton-char? type)))

(define (type-singleton-char? type)
  (type-singleton-of-type? type-value-char? type))

(define (type-value-char? val)
  (char? val))

;;; not-char type

(define type-not-char-tag
  '!char)

(define (make-type-not-char)
  (if use-complement-types?
      type-not-char-tag
      (make-type-universal)))

(define (type-not-char? type)
  (eq? type type-not-char-tag))

(define (isa-not-char? type)
  (and (not (type-universal? type))
       (type-complement type-char?
                        type-singleton-char?
                        type-not-char?
                        type)))

;;; symbol type

(define (make-type-symbol)
  'symbol)

(define (type-symbol? type)
  (eq? type (make-type-symbol)))

(define (isa-symbol? type)
  (or (type-symbol? type)
      (type-singleton-symbol? type)))

(define (type-singleton-symbol? type)
  (type-singleton-of-type? type-value-symbol? type))

(define (type-value-symbol? val)
  (symbol-object? val))

;;; not-symbol type

(define type-not-symbol-tag
  '!symbol)

(define (make-type-not-symbol)
  (if use-complement-types?
      type-not-symbol-tag
      (make-type-universal)))

(define (type-not-symbol? type)
  (eq? type type-not-symbol-tag))

(define (isa-not-symbol? type)
  (and (not (type-universal? type))
       (type-complement type-symbol?
                        type-singleton-symbol?
                        type-not-symbol?
                        type)))

;;; keyword type

(define (make-type-keyword)
  'keyword)

(define (type-keyword? type)
  (eq? type (make-type-keyword)))

(define (isa-keyword? type)
  (or (type-keyword? type)
      (type-singleton-keyword? type)))

(define (type-singleton-keyword? type)
  (type-singleton-of-type? type-value-keyword? type))

(define (type-value-keyword? val)
  (keyword-object? val))

;;; not-keyword type

(define type-not-keyword-tag
  '!keyword)

(define (make-type-not-keyword)
  (if use-complement-types?
      type-not-keyword-tag
      (make-type-universal)))

(define (type-not-keyword? type)
  (eq? type type-not-keyword-tag))

(define (isa-not-keyword? type)
  (and (not (type-universal? type))
       (type-complement type-keyword?
                        type-singleton-keyword?
                        type-not-keyword?
                        type)))

;;; string type

(define (make-type-string)
  'string)

(define (type-string? type)
  (eq? type (make-type-string)))

(define (isa-string? type)
  (or (type-string? type)
      (type-singleton-string? type)))

(define (type-singleton-string? type)
  (type-singleton-of-type? type-value-string? type))

(define (type-value-string? val)
  (string? val))

;;; not-string type

(define type-not-string-tag
  '!string)

(define (make-type-not-string)
  (if use-complement-types?
      type-not-string-tag
      (make-type-universal)))

(define (type-not-string? type)
  (eq? type type-not-string-tag))

(define (isa-not-string? type)
  (and (not (type-universal? type))
       (type-complement type-string?
                        type-singleton-string?
                        type-not-string?
                        type)))

;;; vector type

(define (make-type-vector)
  'vector)

(define (type-vector? type)
  (eq? type (make-type-vector)))

(define (isa-vector? type)
  (or (type-vector? type)
      (type-singleton-vector? type)))

(define (type-singleton-vector? type)
  (type-singleton-of-type? type-value-vector? type))

(define (type-value-vector? val)
  (vector-object? val))

;;; not-vector type

(define type-not-vector-tag
  '!vector)

(define (make-type-not-vector)
  (if use-complement-types?
      type-not-vector-tag
      (make-type-universal)))

(define (type-not-vector? type)
  (eq? type type-not-vector-tag))

(define (isa-not-vector? type)
  (and (not (type-universal? type))
       (type-complement type-vector?
                        type-singleton-vector?
                        type-not-vector?
                        type)))

;;; pair type

(define (make-type-pair)
  'pair)

(define (type-pair? type)
  (eq? type (make-type-pair)))

(define (isa-pair? type)
  (or (type-pair? type)
      (type-singleton-pair? type)))

(define (type-singleton-pair? type)
  (type-singleton-of-type? type-value-pair? type))

(define (type-value-pair? val)
  (pair? val))

;;; not-pair type

(define type-not-pair-tag
  '!pair)

(define (make-type-not-pair)
  (if use-complement-types?
      type-not-pair-tag
      (make-type-universal)))

(define (type-not-pair? type)
  (eq? type type-not-pair-tag))

(define (isa-not-pair? type)
  (and (not (type-universal? type))
       (type-complement type-pair?
                        type-singleton-pair?
                        type-not-pair?
                        type)))

;;; universal type

(define (make-type-universal)
  'any)

(define (type-universal? type)
  (eq? type (make-type-universal)))

;;; empty type

(define (make-type-empty)
  '())

(define (type-empty? type)
  (eq? type (make-type-empty)))

;;; operations on types

(define (type-compare type1 type2)

  (define (invert x)
    (and x (- x)))

  (define (compare-singleton type1 type2)
    (if (type-singleton? type2)
        (if (eqv? (type-singleton-val type1)
                  (type-singleton-val type2))
            0   ;; equal
            #f) ;; not comparable
        (let ((val (type-singleton-val type1)))
          (if (eq? (type-value-fixnum? val) #t) ;; exclude 'maybe
              (cond ((type-fixnum-or-false? type2)
                     -1) ;; less than
                    ((type-fixnum? type2)
                     (type-fixnum-compare type1 type2))
                    (else
                     #f)) ;; not comparable
              (if (cond ((type-value-boolean? val)
                         (or (type-boolean? type2)
                             (and (type-value-false? val)
                                  (type-fixnum-or-false? type2))))
                        ((type-value-flonum? val)
                         (type-flonum? type2))
                        ((type-value-char? val)
                         (type-char? type2))
                        ((type-value-symbol? val)
                         (type-symbol? type2))
                        ((type-value-keyword? val)
                         (type-keyword? type2))
                        ((type-value-string? val)
                         (type-string? type2))
                        ((type-value-vector? val)
                         (type-vector? type2))
                        ((type-value-pair? val)
                         (type-pair? type2))
                        (else
                         #f))
                  -1      ;; less than
                  #f))))) ;; not comparable

  (define (compare-boolean type1 type2)
    (cond ((type-boolean? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-boolean? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-fixnum type1 type2)
    (cond ((type-fixnum? type2)
           (type-fixnum-compare type1 type2))
          ((or (type-fixnum-or-false? type2)
               (type-specific-complement-except? type-not-fixnum? type2))
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-fixnum-or-false type1 type2)
    (if (type-specific-complement-except?
         type-not-boolean-or-not-fixnum?
         type2)
        -1   ;; less than
        #f)) ;; not comparable

  (define (compare-flonum type1 type2)
    (cond ((type-flonum? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-flonum? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-char type1 type2)
    (cond ((type-char? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-char? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-symbol type1 type2)
    (cond ((type-symbol? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-symbol? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-keyword type1 type2)
    (cond ((type-keyword? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-keyword? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-string type1 type2)
    (cond ((type-string? type2)
           0)    ;; equal
          ((type-specific-complement-except? type-not-string? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (define (compare-vector type1 type2)
    (cond ((type-vector? type2)
           0)   ;; equal
          ((type-specific-complement-except? type-not-vector? type2)
           -1)   ;; less than
          (else
           #f))) ;; not comparable

  (cond ((eq? type1 type2)
         0) ;; equal

        ((type-universal? type1)
         1)  ;; greater than
        ((type-universal? type2)
         -1) ;; less than

        ((type-empty? type1)
         -1) ;; less than
        ((type-empty? type2)
         1)  ;; greater than

        ((type-singleton? type1)
         (compare-singleton type1 type2))
        ((type-singleton? type2)
         (invert (compare-singleton type2 type1)))

        ((type-boolean? type1)
         (compare-boolean type1 type2))
        ((type-boolean? type2)
         (invert (compare-boolean type2 type1)))

        ((type-fixnum? type1)
         (compare-fixnum type1 type2))
        ((type-fixnum? type2)
         (invert (compare-fixnum type2 type1)))

        ((type-fixnum-or-false? type1)
         (compare-fixnum-or-false type1 type2))
        ((type-fixnum-or-false? type2)
         (invert (compare-fixnum-or-false type2 type1)))

        ((type-flonum? type1)
         (compare-flonum type1 type2))
        ((type-flonum? type2)
         (invert (compare-flonum type2 type1)))

        ((type-char? type1)
         (compare-char type1 type2))
        ((type-char? type2)
         (invert (compare-char type2 type1)))

        ((type-symbol? type1)
         (compare-symbol type1 type2))
        ((type-symbol? type2)
         (invert (compare-symbol type2 type1)))

        ((type-keyword? type1)
         (compare-keyword type1 type2))
        ((type-keyword? type2)
         (invert (compare-keyword type2 type1)))

        ((type-string? type1)
         (compare-string type1 type2))
        ((type-string? type2)
         (invert (compare-string type2 type1)))

        ((type-vector? type1)
         (compare-vector type1 type2))
        ((type-vector? type2)
         (invert (compare-vector type2 type1)))

        (else
         #f))) ;; not comparable

(define (type-includes? type1 type2)
  (let ((comp (type-compare type1 type2)))
    (and comp (>= comp 0))))

(define (type-union type1 type2)

  (define (union-singleton-false type)
    ;; type can't be singleton #f
    (if (isa-fixnum-or-false? type)
        (make-type-fixnum-or-false)
        (union-boolean type)))

  (define (union-boolean type)
    ;; type can't be singleton #f but may be singleton #t or other type
    (if (isa-boolean? type)
        (make-type-boolean)
        (union-specific-complement-except
         type-not-boolean?
         type)))

  (define (union-fixnum type1 type2)
    (if (isa-fixnum? type2)
        (let* ((f1 (type-fixnum-from-possibly-singleton type1))
               (lo1 (type-fixnum-lo f1))
               (hi1 (type-fixnum-hi f1))
               (f2 (type-fixnum-from-possibly-singleton type2))
               (lo2 (type-fixnum-lo f2))
               (hi2 (type-fixnum-hi f2)))
          (make-type-fixnum
           (cond ((or (not lo1) (not lo2))         #f)
                 ((or (eq? lo1 '>=) (eq? lo2 '>=)) '>=)
                 ((or (eq? lo1 '>)  (eq? lo2 '>))  '>)
                 (else                             (min lo1 lo2)))
           (cond ((or (not hi1) (not hi2))         #f)
                 ((or (eq? hi1 '<=) (eq? hi2 '<=)) '<=)
                 ((or (eq? hi1 '<)  (eq? hi2 '<))  '<)
                 (else                             (max hi1 hi2)))))
        (if (type-fixnum-or-false? type2)
            type2
            (union-specific-complement-except
             type-not-fixnum?
             type2))))

  (define (union-fixnum-or-false type)
    ;; singleton #f, singleton fixnum and the fixnum type have been
    ;; handled before
    (if (type-fixnum-or-false? type)
        type
        (union-specific-complement-except
         type-not-boolean-or-not-fixnum?
         type)))

  (define (union-flonum type)
    (if (isa-flonum? type)
        (make-type-flonum) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-flonum?
         type)))

  (define (union-char type)
    (if (isa-char? type)
        (make-type-char) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-char?
         type)))

  (define (union-symbol type)
    (if (isa-symbol? type)
        (make-type-symbol) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-symbol?
         type)))

  (define (union-keyword type)
    (if (isa-keyword? type)
        (make-type-keyword) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-keyword?
         type)))

  (define (union-string type)
    (if (isa-string? type)
        (make-type-string) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-string?
         type)))

  (define (union-vector type)
    (if (isa-vector? type)
        (make-type-vector) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-vector?
         type)))

  (define (union-pair type)
    (if (isa-pair? type)
        (make-type-pair) ;; can't be the same singleton value
        (union-specific-complement-except
         type-not-pair?
         type)))

  (define (union-specific-complement-except not-of-type? type)
    (if (type-specific-complement-except? not-of-type? type)
        type
        (make-type-universal)))

  (cond ((eq? type1 type2)
         type1)

        ((and (type-singleton? type1)
              (type-singleton? type2)
              (eqv? (type-singleton-val type1)
                    (type-singleton-val type2)))
         type1)

        ;; from this point on, the case of two identical singleton types
        ;; is impossible

        ((type-singleton-false? type1)
         (union-singleton-false type2))
        ((type-singleton-false? type2)
         (union-singleton-false type1))

        ;; from this point on, neither type1 nor type2 can be singleton #f

        ((isa-boolean? type1) ;; catches singleton #t
         (union-boolean type2))
        ((isa-boolean? type2) ;; catches singleton #t
         (union-boolean type1))

        ((isa-fixnum? type1) ;; catches singleton fixnum
         (union-fixnum type1 type2))
        ((isa-fixnum? type2) ;; catches singleton fixnum
         (union-fixnum type2 type1))

        ((type-fixnum-or-false? type1)
         (union-fixnum-or-false type2))
        ((type-fixnum-or-false? type2)
         (union-fixnum-or-false type1))

        ((isa-flonum? type1) ;; catches singleton flonum
         (union-flonum type2))
        ((isa-flonum? type2) ;; catches singleton flonum
         (union-flonum type1))

        ((isa-char? type1) ;; catches singleton char
         (union-char type2))
        ((isa-char? type2) ;; catches singleton char
         (union-char type1))

        ((isa-symbol? type1) ;; catches singleton symbol
         (union-symbol type2))
        ((isa-symbol? type2) ;; catches singleton symbol
         (union-symbol type1))

        ((isa-keyword? type1) ;; catches singleton keyword
         (union-keyword type2))
        ((isa-keyword? type2) ;; catches singleton keyword
         (union-keyword type1))

        ((isa-string? type1) ;; catches singleton string
         (union-string type2))
        ((isa-string? type2) ;; catches singleton string
         (union-string type1))

        ((isa-vector? type1) ;; catches singleton vector
         (union-vector type2))
        ((isa-vector? type2) ;; catches singleton vector
         (union-vector type1))

        ((isa-pair? type1) ;; catches singleton pair
         (union-pair type2))
        ((isa-pair? type2) ;; catches singleton pair
         (union-pair type1))

        (else
         (make-type-universal))))

(define (type-fixnum-<=-num x num)
  (cond ((eq? x '>=) #t)
        ((eq? x '>)  #t)
        ((eq? x '<)  #f)
        ((eq? x '<=) #f)
        (else        (<= x num))))

(define (type-fixnum->=-num x num)
  (cond ((eq? x '>=) #f)
        ((eq? x '>)  #f)
        ((eq? x '<)  #t)
        ((eq? x '<=) #t)
        (else        (>= x num))))

(define (type-fixnum-<= x y)
  (cond ((eq? x '>=)
         #t)
        ((eq? x '>)
         (not (eq? y '>=)))
        ((number? x)
         (cond ((eq? y '>=) #f)
               ((eq? y '>)  #f)
               ((number? y) (<= x y))
               (else        #t)))
        ((eq? x '<)
         (or (eq? y '<)
             (eq? y '<=)))
        ((eq? x '<=)
         (eq? y '<=))
        (else
         (error "(type-fixnum-<= x y)"))))

(define (type-fixnum-< x y)
  (cond ((eq? x '>=)
         (not (eq? y '>=)))
        ((eq? x '>)
         (not (or (eq? y '>=)
                  (eq? y '>))))
        ((number? x)
         (cond ((eq? y '>=) #f)
               ((eq? y '>)  #f)
               ((number? y) (< x y))
               (else        #t)))
        ((eq? x '<)
         (eq? y '<=))
        ((eq? x '<=)
         #f)
        (else
         (error "(type-fixnum-< x y)"))))

(define (type-fixnum-compare type1 type2)
  (let* ((f1 (type-fixnum-from-possibly-singleton type1))
         (lo1 (type-fixnum-lo f1))
         (hi1 (type-fixnum-hi f1))
         (f2 (type-fixnum-from-possibly-singleton type2))
         (lo2 (type-fixnum-lo f2))
         (hi2 (type-fixnum-hi f2))
         (included-1-in-2
          (and (type-fixnum-<= lo2 lo1) (type-fixnum-<= hi1 hi2)))
         (included-2-in-1
          (and (type-fixnum-<= lo1 lo2) (type-fixnum-<= hi2 hi1))))
    (cond (included-1-in-2
           (if included-2-in-1
               0    ;; equal
               -1)) ;; less than
          (included-2-in-1
           1) ;; greater than
          (else
           #f)))) ;; not comparable

(define (type-fixnum-lo-inc x)
  (cond ((eq? x '>=)
         '>)
        ((eq? x '>)
         '>)
        (else
         (+ x 1))))

(define (type-fixnum-hi-dec x)
  (cond ((eq? x '<=)
         '<)
        ((eq? x '<)
         '<)
        (else
         (- x 1))))

(define (type-fixnum-min x y)
  (if (type-fixnum-< x y) x y))

(define (type-fixnum-max x y)
  (if (type-fixnum-< x y) y x))

(define (type-fixnum-union type1 type2)
  (let* ((f1 (type-fixnum-from-possibly-singleton type1))
         (lo1 (type-fixnum-lo f1))
         (hi1 (type-fixnum-hi f1))
         (f2 (type-fixnum-from-possibly-singleton type2))
         (lo2 (type-fixnum-lo f2))
         (hi2 (type-fixnum-hi f2)))
    (make-type-fixnum
     (type-fixnum-min lo1 lo2)
     (type-fixnum-max hi1 hi2))))

(define (type-infer-fixnum1 infer type)
  (if (not (isa-fixnum? type))
      (make-type-fixnum #f #f)
      (let* ((f (type-fixnum-from-possibly-singleton type))
             (lo (type-fixnum-lo f))
             (hi (type-fixnum-hi f)))
        (infer lo hi))))

(define (type-infer-fixnum2 infer type1 type2)
  (if (or (not (isa-fixnum? type1))
          (not (isa-fixnum? type2)))
      (make-type-fixnum #f #f)
      (let* ((f1 (type-fixnum-from-possibly-singleton type1))
             (lo1 (type-fixnum-lo f1))
             (hi1 (type-fixnum-hi f1))
             (f2 (type-fixnum-from-possibly-singleton type2))
             (lo2 (type-fixnum-lo f2))
             (hi2 (type-fixnum-hi f2)))
        (infer lo1 hi1 lo2 hi2))))

(define (type-infer-fold infer0 infer1 infer2)
  (lambda (args)
    (if (not (pair? args))
        (infer0)
        (let ((arg1 (car args))
              (rest (cdr args)))
          (if (not (pair? rest))
              (infer1 arg1)
              (let loop ((result arg1) (lst rest))
                (if (pair? lst)
                    (loop (infer2 result (car lst)) (cdr lst))
                    result)))))))

(define (type-infer-common-fx+ lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (leq? x val) (type-fixnum-<=-num x val))
  (define (geq? x val) (type-fixnum->=-num x val))

  (define (abstract-fx+ x y)

    (define (abstract-fx+-non-num x y)
      (cond ((eq? x '>=) ;; x >= min-fixnum
             (cond ((geq? y 1) '>)     ;; result >= min-fixnum + 1
                   ((eqv? y 0) '>=)    ;; result >= min-fixnum
                   (else       #f)))   ;; overflow
            ((eq? x '>) ;; x >= min-fixnum + 1
             (cond ((geq? y 0)  '>)    ;; result >= min-fixnum + 1
                   ((eqv? y -1) '>=)   ;; result >= min-fixnum
                   (else        #f)))  ;; overflow
            ((eq? x '<) ;; x <= max-fixnum - 1
             (cond ((leq? y 0)  '<)    ;; result <= max-fixnum - 1
                   ((eqv? y 1)  '<=)   ;; result <= max-fixnum
                   (else        #f)))  ;; overflow
            (else ;; (eq? x '<=) ;; x <= max-fixnum
             (cond ((leq? y -1) '<)    ;; result <= max-fixnum - 1
                   ((eqv? y 0)  '<=)   ;; result <= max-fixnum
                   (else        #f)))));; overflow

    (if (number? x)
        (if (number? y)
            (+ x y)
            (abstract-fx+-non-num y x))
        (abstract-fx+-non-num x y)))

  (make-type-fixnum-bounded
   (abstract-fx+ lo1 lo2)
   (abstract-fx+ hi1 hi2)))

(define (type-infer-fx+ type1 type2)
  (type-fixnum-normalize-clamp
   (type-infer-fixnum2 type-infer-common-fx+ type1 type2)))

(define (type-infer-fxwrap+ type1 type2)
  (type-fixnum-normalize-wrap
   (type-infer-fixnum2 type-infer-common-fx+ type1 type2)))

(define (type-infer-fx+? type1 type2)
  (type-fixnum-normalize-false
   (type-infer-fixnum2 type-infer-common-fx+ type1 type2)))

(define (type-infer-common-fx- lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (leq? x val) (type-fixnum-<=-num x val))
  (define (geq? x val) (type-fixnum->=-num x val))

  (define (abstract-fx- x y)
    (cond ((eq? x '>=) ;; x >= min-fixnum
           (cond ((leq? y -1) '>)     ;; result >= min-fixnum + 1
                 ((eqv? y 0)  '>=)    ;; result >= min-fixnum
                 (else        #f)))   ;; overflow
          ((eq? x '>) ;; x >= min-fixnum + 1
           (cond ((leq? y 0)  '>)    ;; result >= min-fixnum + 1
                 ((eqv? y 1)  '>=)   ;; result >= min-fixnum
                 (else        #f)))  ;; overflow
          ((eq? x '<) ;; x <= max-fixnum - 1
           (cond ((geq? y 0)  '<)    ;; result <= max-fixnum - 1
                 ((eqv? y -1) '<=)   ;; result <= max-fixnum
                 (else        #f)))  ;; overflow
          ((eq? x '<=) ;; x <= max-fixnum
           (cond ((geq? y 1)  '<)    ;; result <= max-fixnum - 1
                 ((eqv? y 0)  '<=)   ;; result <= max-fixnum
                 (else        #f)))  ;; overflow
          (else ;; x is a specific number
           (cond ((eq? y '>=)
                  (cond ((<= x -2) '<)   ;; result <= max-fixnum - 1
                        ((= x -1)  '<=)  ;; result <= max-fixnum
                        (else      #f))) ;; overflow
                 ((eq? y '>)
                  (cond ((<= x -1) '<)   ;; result <= max-fixnum - 1
                        ((= x 0)   '<=)  ;; result <= max-fixnum
                        (else      #f))) ;; overflow
                 ((eq? y '<)
                  (cond ((>= x -1) '>)   ;; result >= min-fixnum + 1
                        ((= x -2)  '>=)  ;; result >= min-fixnum
                        (else      #f))) ;; overflow
                 ((eq? y '<=)
                  (cond ((>= x 0)  '>)   ;; result >= min-fixnum + 1
                        ((= x -1)  '>=)  ;; result >= min-fixnum
                        (else      #f))) ;; overflow
                 (else
                  (- x y))))))

  (make-type-fixnum-bounded
   (abstract-fx- lo1 hi2)
   (abstract-fx- hi1 lo2)))

(define (type-infer-fx- type1 type2)
  (type-fixnum-normalize-clamp
   (type-infer-fixnum2 type-infer-common-fx- type1 type2)))

(define (type-infer-fxwrap- type1 type2)
  (type-fixnum-normalize-wrap
   (type-infer-fixnum2 type-infer-common-fx- type1 type2)))

(define (type-infer-fx-? type1 type2)
  (type-fixnum-normalize-false
   (type-infer-fixnum2 type-infer-common-fx- type1 type2)))

(define (type-infer-common-fx* lo1 hi1 lo2 hi2)

  (declare (generic))

  (define (minus-to-plus-1? lo hi)
    (and (number? lo)
         (number? hi)
         (>= lo -1)
         (<= hi 1)))

  (define (minus-to-plus-1-case lo1 hi1 lo2 hi2)

    (define (zero)
      (make-type-fixnum 0 0))

    (define (one)
      (make-type-fixnum lo2 hi2))

    (define (minus-one)
      (type-infer-fixnum2 type-infer-common-fx- (zero) (one)))

    (cond ((= hi1 -1)
           (minus-one)) ;; multiplying by -1
          ((= hi1 0)
           (if (= lo1 0)
               (zero) ;; multiplying by 0
               (type-union (minus-one) (zero)))) ;; multiplying by -1 or 0
          ((= lo1 1)
           (one)) ;; multiplying by 1
          ((= lo1 0)
           (type-union (zero) (one))) ;; multiplying by 0 or 1
          (else
           (type-union (minus-one) (type-union (zero) (one)))))) ;; multiplying by -1, 0 or 1

  (cond ((minus-to-plus-1? lo1 hi1)
         (minus-to-plus-1-case lo1 hi1 lo2 hi2))
        ((minus-to-plus-1? lo2 hi2)
         (minus-to-plus-1-case lo2 hi2 lo1 hi1))
        ((and (number? lo1)
              (number? hi1)
              (number? lo2)
              (number? hi2))
         (let ((lo-lo (* lo1 lo2))
               (lo-hi (* lo1 hi2))
               (hi-lo (* hi1 lo2))
               (hi-hi (* hi1 hi2)))
           (make-type-fixnum-bounded
            (min lo-lo lo-hi hi-lo hi-hi)
            (max lo-lo lo-hi hi-lo hi-hi))))
        (else
         (make-type-fixnum #f #f))))

(define (type-infer-fx* type1 type2)
  (type-fixnum-normalize-clamp
   (type-infer-fixnum2 type-infer-common-fx* type1 type2)))

(define (type-infer-fxwrap* type1 type2)
  (type-fixnum-normalize-wrap
   (type-infer-fixnum2 type-infer-common-fx* type1 type2)))

(define (type-infer-fx*? type1 type2)
  (type-fixnum-normalize-false
   (type-infer-fixnum2 type-infer-common-fx* type1 type2)))

(define (type-narrow-fold narrow2)
  (lambda (args)
    (if (not (pair? args))
        (cons args #f) ;; always true
        (let ((arg1 (car args))
              (rest (cdr args)))
          (if (not (pair? rest))
              (cons args #f) ;; always true
              (let* ((arg2 (car rest))
                     (x (narrow2 arg1 arg2)))
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
                                     (let* ((x (narrow2 prev-true (car lst)))
                                            (true (car x))
                                            (false (cdr x)))
                                       (if (not true) ;; always false?
                                           (cons #f args)
                                           (loop (cons (car true)
                                                       rev-result-true)
                                                 (cadr true)
                                                 (if (and (= i 2) false)
                                                     (type-fixnum-union
                                                      arg2-false
                                                      (car false))
                                                     arg2-false)
                                                 (+ i 1)
                                                 (cdr lst)))))))))))))))))

(define (type-narrow-fx< type1 type2)

  ;; if x<y
  ;;
  ;;  x is in  x.lo .. min(x.hi,y.hi-1)
  ;;  y is in  max(y.lo,x.lo+1) .. y.hi
  ;;
  ;; if x>=y
  ;;
  ;;  x is in  max(x.lo,y.lo) .. x.hi
  ;;  y is in  y.lo .. min(y.hi,x.hi)

  (if (not (and (isa-fixnum? type1)
                (isa-fixnum? type2)))
      (cons (list type1 type2)
            (list type1 type2))
      (let* ((f1 (type-fixnum-from-possibly-singleton type1))
             (lo1 (type-fixnum-lo f1))
             (hi1 (type-fixnum-hi f1))
             (f2 (type-fixnum-from-possibly-singleton type2))
             (lo2 (type-fixnum-lo f2))
             (hi2 (type-fixnum-hi f2))
             (true-lo1 lo1)
             (true-hi1 (type-fixnum-min hi1 (type-fixnum-hi-dec hi2)))
             (true-lo2 (type-fixnum-max lo2 (type-fixnum-lo-inc lo1)))
             (true-hi2 hi2)
             (false-lo1 (type-fixnum-max lo1 lo2))
             (false-hi1 hi1)
             (false-lo2 lo2)
             (false-hi2 (type-fixnum-min hi2 hi1)))
        (cond ((or (type-fixnum-< true-hi1 true-lo1) ;; true case impossible?
                   (type-fixnum-< true-hi2 true-lo2))
               (cons #f
                     (list type1 type2)))
              ((or (type-fixnum-< false-hi1 false-lo1) ;; false case impossible?
                   (type-fixnum-< false-hi2 false-lo2))
               (cons (list type1 type2)
                     #f))
              (else
               (cons (list (type-fixnum-normalize
                            (make-type-fixnum-bounded true-lo1 true-hi1))
                           (type-fixnum-normalize
                            (make-type-fixnum-bounded true-lo2 true-hi2)))
                     (list (type-fixnum-normalize
                            (make-type-fixnum-bounded false-lo1 false-hi1))
                           (type-fixnum-normalize
                            (make-type-fixnum-bounded false-lo2 false-hi2)))))))))

(define (type-narrow-fx> type1 type2)
  (type-narrow-swap
   (type-narrow-fx< type2 type1)))

(define (type-narrow-fx>= type1 type2)
  (type-narrow-invert
   (type-narrow-fx< type1 type2)))

(define (type-narrow-fx<= type1 type2)
  (type-narrow-invert
   (type-narrow-swap
    (type-narrow-fx< type2 type1))))

(define (type-narrow-fl< type1 type2)
  (cons (list type1 type2)
        (list type1 type2)))

(define (type-narrow-fl> type1 type2)
  (type-narrow-swap
   (type-narrow-fl< type2 type1)))

(define (type-narrow-fl>= type1 type2)
  (type-narrow-invert
   (type-narrow-fl< type1 type2)))

(define (type-narrow-fl<= type1 type2)
  (type-narrow-invert
   (type-narrow-swap
    (type-narrow-fl< type2 type1))))

(define (type-narrow-invert x)
  (let ((true (car x))
        (false (cdr x)))
    (cons false true)))

(define (type-narrow-swap x)

  (define (swap lst)
    (and lst (list (cadr lst) (car lst))))

  (let ((true (car x))
        (false (cdr x)))
    (cons (swap true) (swap false))))

(define (proc-type->type type)
  (case (type-name type)
    ((boolean)
     (make-type-boolean))
    ((fixnum)
     (make-type-fixnum '>= '<=))
    ((?fixnum)
     (make-type-fixnum-or-false))
    ((fixnonneg)
     (make-type-fixnum 0 '<=))
    ((flonum)
     (make-type-flonum))
    ((char)
     (make-type-char))
    ((symbol)
     (make-type-symbol))
    ((keyword)
     (make-type-keyword))
    ((string)
     (make-type-string))
    ((vector)
     (make-type-vector))
    ((pair)
     (make-type-pair))
    ((s8)
     (make-type-fixnum -128 127))
    ((u8)
     (make-type-fixnum 0 255))
    ((s16)
     (make-type-fixnum -32768 32767))
    ((u16)
     (make-type-fixnum 0 65535))
    ((list number integer real port
      s8vector u8vector s16vector u16vector
      s32 s32vector u32 u32vector s64 s64vector u64 u64vector
      f32vector f64vector
      #f)
     (make-type-universal)) ;;TODO: refine
    (else
     (compiler-internal-error
      "proc-type->type, unknown 'type':" type))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Table of primitive procedure typers

(define (setup-prim-typers targ)

;; TODO: remove dependencies to C back-end

(define (get-prim-info name)
  ((target-prim-info targ) (string->canonical-symbol name)))

(define (type-infer-set! name infer)
  (let ((proc (get-prim-info name)))
    (if proc
        (let ((default-type
                (proc-type->type (proc-obj-type proc)))
              (constant-fold
               (proc-obj-constant-fold proc)))
          (proc-obj-type-infer-set!
           proc
           (lambda (args)

             ;; try constant folding first in case it is possible,
             ;; then the type inference procedure, then default
             ;; procedure result type

             (let ((folding-result
                    (if constant-fold
                        (constant-fold args)
                        (make-type-universal))))
               (if (type-singleton? folding-result)
                   folding-result
                   (let ((infer-result
                          (if infer
                              (infer args)
                              (make-type-universal))))
                     (if (not (type-universal? infer-result))
                         infer-result
                         default-type))))))))))

(define (def-type-infer name infer)
  (type-infer-set! name infer)
  (type-infer-set! (string-append "##" name) infer))

(define (type-narrow-set! name narrow)
  (let ((proc (get-prim-info name)))
    (if proc
        (let ((constant-fold
               (proc-obj-constant-fold proc)))
          (proc-obj-type-narrow-set!
           proc
           (lambda (args)

             ;; try constant folding first in case it is possible,
             ;; then the narrow procedure

             (let ((folding-result
                    (if constant-fold
                        (constant-fold args)
                        (make-type-universal))))
               (if (type-singleton? folding-result)
                   (if (false-object? (type-singleton-val folding-result))
                       (cons #f args)
                       (cons args #f))
                   (if narrow
                       (narrow args)
                       (cons args args))))))))))

(define (def-type-narrow name narrow)
  (type-narrow-set! name narrow)
  (type-narrow-set! (string-append "##" name) narrow))

(define (infer-fx+ normalize)
  (type-infer-fold
   (lambda ()
     (make-type-singleton 0))
   (lambda (type)
     type)
   (lambda (type1 type2)
     (normalize
      (type-infer-fixnum2 type-infer-common-fx+ type1 type2)))))

(define (infer-fx- normalize)
  (type-infer-fold
   #f
   (lambda (type)
     (normalize
      (let ((zero (make-type-singleton 0)))
        (type-infer-fixnum2 type-infer-common-fx- zero type))))
   (lambda (type1 type2)
     (normalize
      (type-infer-fixnum2 type-infer-common-fx- type1 type2)))))

(define (infer-fx* normalize)
  (type-infer-fold
   (lambda ()
     (make-type-singleton 1))
   (lambda (type)
     type)
   (lambda (type1 type2)
     (normalize
      (type-infer-fixnum2 type-infer-common-fx* type1 type2)))))

(type-infer-set! "##fx+?" (infer-fx+ type-fixnum-normalize-false))
(def-type-infer "fx+"     (infer-fx+ type-fixnum-normalize-clamp))
(def-type-infer "fxwrap+" (infer-fx+ type-fixnum-normalize-wrap))

(type-infer-set! "##fx-?" (infer-fx- type-fixnum-normalize-false))
(def-type-infer "fx-"     (infer-fx- type-fixnum-normalize-clamp))
(def-type-infer "fxwrap-" (infer-fx- type-fixnum-normalize-wrap))

(type-infer-set! "##fx*?" (infer-fx* type-fixnum-normalize-false))
(def-type-infer "fx*"     (infer-fx* type-fixnum-normalize-clamp))
(def-type-infer "fxwrap*" (infer-fx* type-fixnum-normalize-wrap))

(def-type-narrow "fx="  #f)
(def-type-narrow "fx<"  (type-narrow-fold type-narrow-fx<))
(def-type-narrow "fx<=" (type-narrow-fold type-narrow-fx<=))
(def-type-narrow "fx>"  (type-narrow-fold type-narrow-fx>))
(def-type-narrow "fx>=" (type-narrow-fold type-narrow-fx>=))

(def-type-infer
  "fl+"
  (lambda (args)
    (make-type-flonum)))

(def-type-infer
  "fl-"
  (lambda (args)
    (make-type-flonum)))

(def-type-infer
  "fl*"
  (lambda (args)
    (make-type-flonum)))

(def-type-narrow "fl="  #f)
(def-type-narrow "fl<"  (type-narrow-fold type-narrow-fl<))
(def-type-narrow "fl<=" (type-narrow-fold type-narrow-fl<=))
(def-type-narrow "fl>"  (type-narrow-fold type-narrow-fl>))
(def-type-narrow "fl>=" (type-narrow-fold type-narrow-fl>=))

(def-type-narrow "identity"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((type-singleton? arg)
             (if (false-object? (type-singleton-val arg))
                 (cons #f args)
                 (cons args #f)))
            ((type-fixnum-or-false? arg)
             (cons (list (make-type-fixnum '>= '<=))
                   (list (make-type-singleton false-object))))
            ((or (type-not-boolean? arg)
                 (and (not (type-boolean? arg))
                      (type-specific? arg)))
             (cons args #f))
            (else
             (cons args args))))))

(def-type-narrow "not"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((type-singleton? arg)
             (if (false-object? (type-singleton-val arg))
                 (cons args #f)
                 (cons #f args)))
            ((type-fixnum-or-false? arg)
             (cons (list (make-type-singleton false-object))
                   (list (make-type-fixnum '>= '<=))))
            ((or (type-not-boolean? arg)
                 (and (not (type-boolean? arg))
                      (type-specific? arg)))
             (cons #f args))
            (else
             (cons args args))))))

(def-type-narrow "boolean?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-boolean? arg)
             (cons args #f))
            ((isa-not-boolean? arg)
             (cons #f args))
            (else
             (cons (list (make-type-boolean))
                   (list (make-type-not-boolean))))))))

(def-type-narrow "fixnum?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((type-fixnum-or-false? arg)
             (cons (list (make-type-fixnum '>= '<=))
                   (list (make-type-singleton false-object))))
            ((isa-fixnum? arg)
             (cons args #f))
            ((isa-not-fixnum? arg)
             (cons #f args))
            (else
             (cons (list (make-type-fixnum '>= '<=))
                   (list (make-type-not-fixnum))))))))

(def-type-narrow "flonum?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-flonum? arg)
             (cons args #f))
            ((isa-not-flonum? arg)
             (cons #f args))
            (else
             (cons (list (make-type-flonum))
                   (list (make-type-not-flonum))))))))

(def-type-narrow "char?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-char? arg)
             (cons args #f))
            ((isa-not-char? arg)
             (cons #f args))
            (else
             (cons (list (make-type-char))
                   (list (make-type-not-char))))))))

(def-type-narrow "symbol?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-symbol? arg)
             (cons args #f))
            ((isa-not-symbol? arg)
             (cons #f args))
            (else
             (cons (list (make-type-symbol))
                   (list (make-type-not-symbol))))))))

(def-type-narrow "keyword?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-keyword? arg)
             (cons args #f))
            ((isa-not-keyword? arg)
             (cons #f args))
            (else
             (cons (list (make-type-keyword))
                   (list (make-type-not-keyword))))))))

(def-type-narrow "string?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-string? arg)
             (cons args #f))
            ((isa-not-string? arg)
             (cons #f args))
            (else
             (cons (list (make-type-string))
                   (list (make-type-not-string))))))))

(def-type-narrow "vector?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-vector? arg)
             (cons args #f))
            ((isa-not-vector? arg)
             (cons #f args))
            (else
             (cons (list (make-type-vector))
                   (list (make-type-not-vector))))))))

(def-type-narrow "pair?"
  (lambda (args)
    (let ((arg (car args)))
      (cond ((isa-pair? arg)
             (cons args #f))
            ((isa-not-pair? arg)
             (cons #f args))
            (else
             (cons (list (make-type-pair))
                   (list (make-type-not-pair))))))))

(for-each
 (lambda (x)
   (let* ((name (car x))
          (proc (get-prim-info name)))
     (if proc
         (begin
           (if (not (proc-obj-type-infer proc))
               (type-infer-set! name #f))))))
 prim-procs)

)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (setup-prims target)
  (setup-prim-specializers target)
  (setup-prim-expanders target)
  (setup-prim-constant-folders target)
  (setup-prim-typers target))

;;;============================================================================
