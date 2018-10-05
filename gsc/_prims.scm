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
("length"                             (1)   #f 0     0    integer ieee)
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
("string-length"                      (1)   #f 0     0    integer ieee)
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
("vector-length"                      (1)   #f 0     0    integer ieee)
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
("s8vector"                           0     #f 0     0    #f      gambit)
("make-s8vector"                      (1 2) #f 0     0    #f      gambit)
("s8vector-length"                    (1)   #f 0     0    integer gambit)
("s8vector-ref"                       (2)   #f 0     0    integer gambit)
("s8vector-set!"                      (3)   #t 0     0    #f      gambit)
("s8vector->list"                     (1)   #f 0     0    list    gambit)
("list->s8vector"                     (1)   #f 0     0    #f      gambit)

("u8vector?"                          (1)   #f 0     0    boolean gambit)
("u8vector"                           0     #f 0     0    #f      gambit)
("make-u8vector"                      (1 2) #f 0     0    #f      gambit)
("u8vector-length"                    (1)   #f 0     0    integer gambit)
("u8vector-ref"                       (2)   #f 0     0    integer gambit)
("u8vector-set!"                      (3)   #t 0     0    #f      gambit)
("u8vector->list"                     (1)   #f 0     0    list    gambit)
("list->u8vector"                     (1)   #f 0     0    #f      gambit)

("s16vector?"                         (1)   #f 0     0    boolean gambit)
("s16vector"                          0     #f 0     0    #f      gambit)
("make-s16vector"                     (1 2) #f 0     0    #f      gambit)
("s16vector-length"                   (1)   #f 0     0    integer gambit)
("s16vector-ref"                      (2)   #f 0     0    integer gambit)
("s16vector-set!"                     (3)   #t 0     0    #f      gambit)
("s16vector->list"                    (1)   #f 0     0    list    gambit)
("list->s16vector"                    (1)   #f 0     0    #f      gambit)

("u16vector?"                         (1)   #f 0     0    boolean gambit)
("u16vector"                          0     #f 0     0    #f      gambit)
("make-u16vector"                     (1 2) #f 0     0    #f      gambit)
("u16vector-length"                   (1)   #f 0     0    integer gambit)
("u16vector-ref"                      (2)   #f 0     0    integer gambit)
("u16vector-set!"                     (3)   #t 0     0    #f      gambit)
("u16vector->list"                    (1)   #f 0     0    list    gambit)
("list->u16vector"                    (1)   #f 0     0    #f      gambit)

("s32vector?"                         (1)   #f 0     0    boolean gambit)
("s32vector"                          0     #f 0     0    #f      gambit)
("make-s32vector"                     (1 2) #f 0     0    #f      gambit)
("s32vector-length"                   (1)   #f 0     0    integer gambit)
("s32vector-ref"                      (2)   #f 0     0    integer gambit)
("s32vector-set!"                     (3)   #t 0     0    #f      gambit)
("s32vector->list"                    (1)   #f 0     0    list    gambit)
("list->s32vector"                    (1)   #f 0     0    #f      gambit)

("u32vector?"                         (1)   #f 0     0    boolean gambit)
("u32vector"                          0     #f 0     0    #f      gambit)
("make-u32vector"                     (1 2) #f 0     0    #f      gambit)
("u32vector-length"                   (1)   #f 0     0    integer gambit)
("u32vector-ref"                      (2)   #f 0     0    integer gambit)
("u32vector-set!"                     (3)   #t 0     0    #f      gambit)
("u32vector->list"                    (1)   #f 0     0    list    gambit)
("list->u32vector"                    (1)   #f 0     0    #f      gambit)

("s64vector?"                         (1)   #f 0     0    boolean gambit)
("s64vector"                          0     #f 0     0    #f      gambit)
("make-s64vector"                     (1 2) #f 0     0    #f      gambit)
("s64vector-length"                   (1)   #f 0     0    integer gambit)
("s64vector-ref"                      (2)   #f 0     0    integer gambit)
("s64vector-set!"                     (3)   #t 0     0    #f      gambit)
("s64vector->list"                    (1)   #f 0     0    list    gambit)
("list->s64vector"                    (1)   #f 0     0    #f      gambit)

("u64vector?"                         (1)   #f 0     0    boolean gambit)
("u64vector"                          0     #f 0     0    #f      gambit)
("make-u64vector"                     (1 2) #f 0     0    #f      gambit)
("u64vector-length"                   (1)   #f 0     0    integer gambit)
("u64vector-ref"                      (2)   #f 0     0    integer gambit)
("u64vector-set!"                     (3)   #t 0     0    #f      gambit)
("u64vector->list"                    (1)   #f 0     0    list    gambit)
("list->u64vector"                    (1)   #f 0     0    #f      gambit)

("f32vector?"                         (1)   #f 0     0    boolean gambit)
("f32vector"                          0     #f 0     0    #f      gambit)
("make-f32vector"                     (1 2) #f 0     0    #f      gambit)
("f32vector-length"                   (1)   #f 0     0    integer gambit)
("f32vector-ref"                      (2)   #f 0     0    real    gambit)
("f32vector-set!"                     (3)   #t 0     0    #f      gambit)
("f32vector->list"                    (1)   #f 0     0    list    gambit)
("list->f32vector"                    (1)   #f 0     0    #f      gambit)

("f64vector?"                         (1)   #f 0     0    boolean gambit)
("f64vector"                          0     #f 0     0    #f      gambit)
("make-f64vector"                     (1 2) #f 0     0    #f      gambit)
("f64vector-length"                   (1)   #f 0     0    integer gambit)
("f64vector-ref"                      (2)   #f 0     0    real    gambit)
("f64vector-set!"                     (3)   #t 0     0    #f      gambit)
("f64vector->list"                    (1)   #f 0     0    list    gambit)
("list->f64vector"                    (1)   #f 0     0    #f      gambit)

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
("##fx+?"                        (2)   #f ()    0    #f      extended)
("##fxwrap*"                     0     #f ()    0    fixnum  extended)
("##fx*"                         0     #f ()    0    fixnum  extended)
("##fx*?"                        (2)   #f ()    0    #f      extended)
("##fxwrap-"                     1     #f ()    0    fixnum  extended)
("##fx-"                         1     #f ()    0    fixnum  extended)
("##fx-?"                        (1 2) #f ()    0    #f      extended)
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
("##fxwraparithmetic-shift?"     (2)   #f ()    0    #f      extended)
("##fxarithmetic-shift"          (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift?"         (2)   #f ()    0    #f      extended)
("##fxwraparithmetic-shift-left" (2)   #f ()    0    fixnum  extended)
("##fxwraparithmetic-shift-left?"(2)   #f ()    0    #f      extended)
("##fxarithmetic-shift-left"     (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-left?"    (2)   #f ()    0    #f      extended)
("##fxarithmetic-shift-right"    (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-right?"   (2)   #f ()    0    #f      extended)
("##fxwraplogical-shift-right"   (2)   #f ()    0    fixnum  extended)
("##fxwraplogical-shift-right?"  (2)   #f ()    0    #f      extended)
("##fxwrapabs"                   (1)   #f ()    0    fixnum  extended)
("##fxabs"                       (1)   #f ()    0    fixnum  extended)
("##fxabs?"                      (1)   #f ()    0    #f      extended)
("##fxwrapsquare"                (1)   #f ()    0    fixnum  extended)
("##fxsquare"                    (1)   #f ()    0    fixnum  extended)
("##fxsquare?"                   (1)   #f ()    0    #f      extended)
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
("##fixnum->flonum"              (1)   #f ()    0    real    extended)
("##fixnum->flonum-exact?"       (1)   #f ()    0    boolean extended)
("##flonum->string-host"         (1)   #f ()    0    string  extended)

("##flmax"                       1     #f ()    0    real    extended)
("##flmin"                       1     #f ()    0    real    extended)
("##fl+"                         0     #f ()    0    real    extended)
("##fl*"                         0     #f ()    0    real    extended)
("##fl-"                         1     #f ()    0    real    extended)
("##fl/"                         1     #f ()    0    real    extended)
("##flabs"                       (1)   #f ()    0    real    extended)
("##flfloor"                     (1)   #f ()    0    real    extended)
("##flceiling"                   (1)   #f ()    0    real    extended)
("##fltruncate"                  (1)   #f ()    0    real    extended)
("##flround"                     (1)   #f ()    0    real    extended)
("##flscalbn"                    (2)   #f 0     0    real    extended)
("##flilogb"                     (1)   #f 0     0    real    extended)
("##flexp"                       (1)   #f ()    0    real    extended)
("##flexpm1"                     (1)   #f ()    0    real    extended)
("##fllog"                       (1)   #f ()    0    real    extended)
("##fllog1p"                     (1)   #f ()    0    real    extended)
("##flsin"                       (1)   #f ()    0    real    extended)
("##flcos"                       (1)   #f ()    0    real    extended)
("##fltan"                       (1)   #f ()    0    real    extended)
("##flasin"                      (1)   #f ()    0    real    extended)
("##flacos"                      (1)   #f ()    0    real    extended)
("##flatan"                      (1 2) #f ()    0    real    extended)
("##flsinh"                      (1)   #f ()    0    real    extended)
("##flcosh"                      (1)   #f ()    0    real    extended)
("##fltanh"                      (1)   #f ()    0    real    extended)
("##flasinh"                     (1)   #f ()    0    real    extended)
("##flacosh"                     (1)   #f ()    0    real    extended)
("##flatanh"                     (1)   #f ()    0    real    extended)
("##flexpt"                      (2)   #f ()    0    real    extended)
("##flsqrt"                      (1)   #f ()    0    real    extended)
("##flsquare"                    (1)   #f ()    0    real    extended)
("##flcopysign"                  (2)   #f ()    0    real    extended)
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
("##values-length"                    (1)   #f ()    0    fixnum  extended)
("##values-ref"                       (2)   #f ()    0    (#f)    extended)
("##values-set!"                      (3)   #t ()    0    (#f)    extended)

("##vector"                           0     #f ()    0    vector  extended)
("##make-vector"                      (1 2) #f ()    0    vector  extended)
("##vector-length"                    (1)   #f ()    0    fixnum  extended)
("##vector-ref"                       (2)   #f ()    0    (#f)    extended)
("##vector-set!"                      (3)   #t ()    0    vector  extended)
("##vector-shrink!"                   (2)   #t ()    0    vector  extended)
("##vector-cas!"                      (4)   #t ()    0    (#f)    extended)
("##vector-inc!"                      (2 3) #t ()    0    fixnum  extended)

("##string"                           0     #f ()    0    string  extended)
("##make-string"                      (1 2) #f ()    0    string  extended)
("##string-length"                    (1)   #f ()    0    fixnum  extended)
("##string-ref"                       (2)   #f ()    0    char    extended)
("##string-set!"                      (3)   #t ()    0    string  extended)
("##string-shrink!"                   (2)   #t ()    0    string  extended)

("##s8vector"                         0     #f ()    0    #f      extended)
("##make-s8vector"                    (1 2) #f ()    0    #f      extended)
("##s8vector-length"                  (1)   #f ()    0    fixnum  extended)
("##s8vector-ref"                     (2)   #f ()    0    fixnum  extended)
("##s8vector-set!"                    (3)   #t ()    0    #f      extended)
("##s8vector-shrink!"                 (2)   #t ()    0    #f      extended)

("##u8vector"                         0     #f ()    0    #f      extended)
("##make-u8vector"                    (1 2) #f ()    0    #f      extended)
("##u8vector-length"                  (1)   #f ()    0    fixnum  extended)
("##u8vector-ref"                     (2)   #f ()    0    fixnum  extended)
("##u8vector-set!"                    (3)   #t ()    0    #f      extended)
("##u8vector-shrink!"                 (2)   #t ()    0    #f      extended)

("##s16vector"                        0     #f ()    0    #f      extended)
("##make-s16vector"                   (1 2) #f ()    0    #f      extended)
("##s16vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s16vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s16vector-set!"                   (3)   #t ()    0    #f      extended)
("##s16vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u16vector"                        0     #f ()    0    #f      extended)
("##make-u16vector"                   (1 2) #f ()    0    #f      extended)
("##u16vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u16vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u16vector-set!"                   (3)   #t ()    0    #f      extended)
("##u16vector-shrink!"                (2)   #t ()    0    #f      extended)

("##s32vector"                        0     #f ()    0    #f      extended)
("##make-s32vector"                   (1 2) #f ()    0    #f      extended)
("##s32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s32vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s32vector-set!"                   (3)   #t ()    0    #f      extended)
("##s32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u32vector"                        0     #f ()    0    #f      extended)
("##make-u32vector"                   (1 2) #f ()    0    #f      extended)
("##u32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u32vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u32vector-set!"                   (3)   #t ()    0    #f      extended)
("##u32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##s64vector"                        0     #f ()    0    #f      extended)
("##make-s64vector"                   (1 2) #f ()    0    #f      extended)
("##s64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s64vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s64vector-set!"                   (3)   #t ()    0    #f      extended)
("##s64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u64vector"                        0     #f ()    0    #f      extended)
("##make-u64vector"                   (1 2) #f ()    0    #f      extended)
("##u64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u64vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u64vector-set!"                   (3)   #t ()    0    #f      extended)
("##u64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##f32vector"                        0     #f ()    0    #f      extended)
("##make-f32vector"                   (1 2) #f ()    0    #f      extended)
("##f32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##f32vector-ref"                    (2)   #f ()    0    real    extended)
("##f32vector-set!"                   (3)   #t ()    0    #f      extended)
("##f32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##f64vector"                        0     #f ()    0    #f      extended)
("##make-f64vector"                   (1 2) #f ()    0    #f      extended)
("##f64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##f64vector-ref"                    (2)   #f ()    0    real    extended)
("##f64vector-set!"                   (3)   #t ()    0    #f      extended)
("##f64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##ratnum-make"                      (2)   #f ()    0    number  extended)
("##ratnum-numerator"                 (1)   #f ()    0    integer extended)
("##ratnum-denominator"               (1)   #f ()    0    integer extended)
("##numerator"                        (1)   #f ()    0    integer extended)
("##denominator"                      (1)   #f ()    0    integer extended)

("##cpxnum-make"                      (2)   #f ()    0    number  extended)
("##cpxnum-real"                      (1)   #f ()    0    number  extended)
("##cpxnum-imag"                      (1)   #f ()    0    number  extended)
("##real-part"                        (1)   #f ()    0    real    extended)
("##imag-part"                        (1)   #f ()    0    real    extended)

("##structure-direct-instance-of?"    (2)   #f ()    0    boolean extended)
("##structure-instance-of?"           (2)   #f ()    0    boolean extended)
("##structure-type"                   (1)   #f ()    0    (#f)    extended)
("##structure-type-set!"              (2)   #t ()    0    (#f)    extended)
("##structure"                        1     #f ()    0    (#f)    extended)
("##make-structure"                   (2)   #f ()    0    (#f)    extended)
("##structure-length"                 (1)   #f ()    0    fixnum  extended)
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
("##closure-length"                   (1)   #f ()    0    fixnum  extended)
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
("##bignum.adigit-length"             (1)   #f ()    0    integer extended)
("##bignum.adigit-inc!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-dec!"               (2)   #t ()    0    integer extended)
("##bignum.adigit-add!"               (5)   #t ()    0    integer extended)
("##bignum.adigit-sub!"               (5)   #t ()    0    integer extended)
("##bignum.mdigit-length"             (1)   #f ()    0    integer extended)
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

("##bignum.fdigit-length"             (1)   #f ()    0    integer extended)
("##bignum.fdigit-ref"                (2)   #f ()    0    integer extended)
("##bignum.fdigit-set!"               (3)   #t ()    0    #f      extended)

("##eof-object?"                      (1)   #f ()    0    boolean extended)
("##char-ready?"                      (0 1) #f ()    0    boolean extended)
("##char-ready?0"                     (0)   #f ()    0    boolean extended)
("##char-ready?1"                     (1)   #f ()    0    boolean extended)
("##read"                             (0 1) #t ()    0    #f      extended)
("##read-char"                        (0 1) #t ()    0    #f      extended)
("##read-char0"                       (0)   #t ()    0    #f      extended)
("##read-char1"                       (1)   #t ()    0    #f      extended)
("##read-char0?"                      (0)   #t ()    0    #f      extended)
("##read-char1?"                      (1)   #t ()    0    #f      extended)
("##peek-char"                        (0 1) #t ()    0    #f      extended)
("##peek-char0"                       (0)   #t ()    0    #f      extended)
("##peek-char1"                       (1)   #t ()    0    #f      extended)
("##peek-char0?"                      (0)   #t ()    0    #f      extended)
("##peek-char1?"                      (1)   #t ()    0    #f      extended)
("##write"                            (1 2) #t ()    0    #f      extended)
("##display"                          (1 2) #t ()    0    #f      extended)
("##newline"                          (0 1) #t ()    0    #f      extended)
("##newline0"                         (0)   #t ()    0    #f      extended)
("##newline1"                         (1)   #t ()    0    #f      extended)
("##write-char"                       (1 2) #t ()    0    #f      extended)
("##write-char1"                      (1)   #t ()    0    #f      extended)
("##write-char2"                      (2)   #t ()    0    #f      extended)
("##write-char1?"                     (1)   #t ()    0    #f      extended)
("##write-char2?"                     (2)   #t ()    0    #f      extended)

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

(define (spec-nargs . names) ;; Argument count specialization
  (lambda (proc proc-name)
    (let ((specs (map (lambda (n) (and n (get-prim-info n))) names)))
      (lambda (env args)
        (let* ((nargs (length args))
               (s (and (< nargs (length specs))
                       (list-ref specs nargs))))
          (or s
              proc))))))

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

(define (eq-testable-object? obj)
  (and (not (void-object? obj)) ;; the void-object denotes a non-constant
       (testable-with-eq? obj)))

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

(def-spec "numerator"   (spec-s "##numerator"))
(def-spec "denominator" (spec-s "##denominator"))

(def-spec "real-part"   (spec-s "##real-part"))
(def-spec "imag-part"   (spec-s "##imag-part"))

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

(def-spec "char-ready?" (spec-u "##char-ready?"))
(def-spec "read-char"   (spec-u "##read-char"))
(def-spec "peek-char"   (spec-u "##peek-char"))
(def-spec "write-char"  (spec-u "##write-char"))
(def-spec "newline"     (spec-u "##newline"))

(def-spec "##char-ready?" (spec-nargs "##char-ready?0" "##char-ready?1"))
(def-spec "##read-char"   (spec-nargs "##read-char0"   "##read-char1"))
(def-spec "##peek-char"   (spec-nargs "##peek-char0"   "##peek-char1"))
(def-spec "##write-char"  (spec-nargs #f "##write-char1" "##write-char2"))
(def-spec "##newline"     (spec-nargs "##newline0"     "##newline1"))

(def-spec "symbol->string" (spec-u "##symbol->string"))

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

    (def-exp
     "##numerator"
     (make-simple-expander
      (gen-simple-case **ratnum?-sym **ratnum-numerator-sym)))

    (def-exp
     "##denominator"
     (make-simple-expander
      (gen-simple-case **ratnum?-sym **ratnum-denominator-sym)))

    (def-exp
     "##real-part"
     (make-simple-expander
      (gen-simple-case **cpxnum?-sym **cpxnum-real-sym)))

    (def-exp
     "##imag-part"
     (make-simple-expander
      (gen-simple-case **cpxnum?-sym **cpxnum-imag-sym)))

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
    (gen-simple-case **char?-sym **char=?-sym))

  (define case-char<?
    (gen-simple-case **char?-sym **char<?-sym))

  (define case-char>?
    (gen-simple-case **char?-sym **char>?-sym))

  (define case-char<=?
    (gen-simple-case **char?-sym **char<=?-sym))

  (define case-char>=?
    (gen-simple-case **char?-sym **char>=?-sym))

;;  (define case-char-ci=?
;;    (gen-simple-case **char?-sym **char-ci=?-sym))
;;
;;  (define case-char-ci<?
;;    (gen-simple-case **char?-sym **char-ci<?-sym))
;;
;;  (define case-char-ci>?
;;    (gen-simple-case **char?-sym **char-ci>?-sym))
;;
;;  (define case-char-ci<=?
;;    (gen-simple-case **char?-sym **char-ci<=?-sym))
;;
;;  (define case-char-ci>=?
;;    (gen-simple-case **char?-sym **char-ci>=?-sym))

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

(define (setup-io-primitives)

  (define **peek-char0?-sym (string->canonical-symbol "##peek-char0?"))
  (define **peek-char1?-sym (string->canonical-symbol "##peek-char1?"))

  (define **read-char0?-sym (string->canonical-symbol "##read-char0?"))
  (define **read-char1?-sym (string->canonical-symbol "##read-char1?"))

  (define **write-char1?-sym (string->canonical-symbol "##write-char1?"))
  (define **write-char2?-sym (string->canonical-symbol "##write-char2?"))

  (define (fast-path sym)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (new-disj source env
        (gen-call-prim-vars source env
          sym
          vars)
        (invalid))))

  (def-exp "##peek-char0"
           (make-simple-expander (fast-path **peek-char0?-sym)))

  (def-exp "##peek-char1"
           (make-simple-expander (fast-path **peek-char1?-sym)))

  (def-exp "##read-char0"
           (make-simple-expander (fast-path **read-char0?-sym)))

  (def-exp "##read-char1"
           (make-simple-expander (fast-path **read-char1?-sym)))

  (def-exp "##write-char1"
           (make-simple-expander (fast-path **write-char1?-sym)))

  (def-exp "##write-char2"
           (make-simple-expander (fast-path **write-char2?-sym)))

)

(define (setup-misc-primitives)

  (define **symbol->string-sym (string->canonical-symbol "##symbol->string"))
  (define **symbol-name-sym (string->canonical-symbol "##symbol-name"))
  (define **string?-sym (string->canonical-symbol "##string?"))

  (def-exp "##symbol->string"
           (make-simple-expander
            (lambda (source
                     env
                     vars
                     check-run-time-binding
                     invalid
                     fail)
              (new-call source env
                (let ((vars2 (gen-temp-vars source '(#f))))
                  (gen-prc source env
                    vars2
                    (new-tst source env
                      (gen-call-prim source env
                        **string?-sym
                        (list (new-ref source env
                                (car vars2))))
                      (new-ref source env
                        (car vars2))
                      (fail))))
                (list (gen-call-prim-vars source env
                        **symbol-name-sym
                        vars))))))

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
(def-simp "fl/"              (constant-folder-flo /
                                                  (list nz-flo?)
                                                        (cons flo?
                                                              (cons nz-flo?
                                                                    nz-flo?))))
(def-simp "abs"              (constant-folder-gen abs          num?))
(def-simp "fxwrapabs"        (constant-folder-fix abs          fix32?))
(def-simp "fxabs"            (constant-folder-fix abs          fix32?))
(def-simp "fxabs?"           (constant-folder-fix abs          fix32?))
(def-simp "flabs"            (constant-folder-flo abs          flo?))
(def-simp "square"           (constant-folder-gen square       num?))
(def-simp "fxwrapsquare"     (constant-folder-fix square       fix32?))
(def-simp "fxsquare"         (constant-folder-fix square       fix32?))
(def-simp "fxsquare?"        (constant-folder-fix square       fix32?))
(def-simp "flsquare"         (constant-folder-flo square       flo?))
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
(def-simp "expt"             (constant-folder-gen expt       num?))
(def-simp "flexpt"           (constant-folder-flo expt       flo?))
(def-simp "sqrt"             (constant-folder-gen sqrt       num?))
(def-simp "flsqrt"           (constant-folder-flo sqrt       flo?))
(def-simp "expt"             (constant-folder-gen expt       num?))
(def-simp "##flonum->fixnum" (constant-folder-fix inexact->exact flo?))

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

(def-simp "fixnum?"          (constant-folder fix32?         not-bigfix?))
(def-simp "flonum?"          (constant-folder flo?           ))
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (setup-prims target)
  (setup-prim-specializers target)
  (setup-prim-expanders target)
  (setup-prim-simplifiers target))

;;;============================================================================
