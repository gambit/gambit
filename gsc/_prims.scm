;;;============================================================================

;;; File: "_prims.scm"

;;; Copyright (c) 1994-2012 by Marc Feeley, All Rights Reserved.

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
("write"                              (0 1) #t 0     0    #f      ieee)
("display"                            (0 1) #t 0     0    #f      ieee)
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
("flexp"                              (1)   #f 0     0    flonum  r6rs)
("fllog"                              (1)   #f 0     0    flonum  r6rs)
("flsin"                              (1)   #f 0     0    flonum  r6rs)
("flcos"                              (1)   #f 0     0    flonum  r6rs)
("fltan"                              (1)   #f 0     0    flonum  r6rs)
("flasin"                             (1)   #f 0     0    flonum  r6rs)
("flacos"                             (1)   #f 0     0    flonum  r6rs)
("flatan"                             (1 2) #f 0     0    flonum  r6rs)
("flexpt"                             (2)   #f 0     0    flonum  r6rs)
("flsqrt"                             (1)   #f 0     0    flonum  r6rs)
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

("void"                               (0)   #f 0     0    #f      gambit)

("will?"                              (1)   #f 0     0    boolean gambit)
("make-will"                          (2)   #t (2)   0    #f      gambit)
("will-testator"                      (1)   #f 0     0    (#f)    gambit)

("box?"                               (1)   #f 0     0    boolean gambit)
("box"                                (1)   #f ()    0    #f      gambit)
("unbox"                              (1)   #f 0     0    (#f)    gambit)
("set-box!"                           (2)   #t (1)   0    #f      gambit)

("s8vector?"                          (1)   #f 0     0    boolean gambit)
("s8vector"                           0     #f 0     0    #f      gambit)
("make-s8vector"                      (2)   #f 0     0    #f      gambit)
("s8vector-length"                    (1)   #f 0     0    integer gambit)
("s8vector-ref"                       (2)   #f 0     0    integer gambit)
("s8vector-set!"                      (3)   #t 0     0    #f      gambit)
("s8vector->list"                     (1)   #f 0     0    list    gambit)
("list->s8vector"                     (1)   #f 0     0    #f      gambit)

("u8vector?"                          (1)   #f 0     0    boolean gambit)
("u8vector"                           0     #f 0     0    #f      gambit)
("make-u8vector"                      (2)   #f 0     0    #f      gambit)
("u8vector-length"                    (1)   #f 0     0    integer gambit)
("u8vector-ref"                       (2)   #f 0     0    integer gambit)
("u8vector-set!"                      (3)   #t 0     0    #f      gambit)
("u8vector->list"                     (1)   #f 0     0    list    gambit)
("list->u8vector"                     (1)   #f 0     0    #f      gambit)

("s16vector?"                         (1)   #f 0     0    boolean gambit)
("s16vector"                          0     #f 0     0    #f      gambit)
("make-s16vector"                     (2)   #f 0     0    #f      gambit)
("s16vector-length"                   (1)   #f 0     0    integer gambit)
("s16vector-ref"                      (2)   #f 0     0    integer gambit)
("s16vector-set!"                     (3)   #t 0     0    #f      gambit)
("s16vector->list"                    (1)   #f 0     0    list    gambit)
("list->s16vector"                    (1)   #f 0     0    #f      gambit)

("u16vector?"                         (1)   #f 0     0    boolean gambit)
("u16vector"                          0     #f 0     0    #f      gambit)
("make-u16vector"                     (2)   #f 0     0    #f      gambit)
("u16vector-length"                   (1)   #f 0     0    integer gambit)
("u16vector-ref"                      (2)   #f 0     0    integer gambit)
("u16vector-set!"                     (3)   #t 0     0    #f      gambit)
("u16vector->list"                    (1)   #f 0     0    list    gambit)
("list->u16vector"                    (1)   #f 0     0    #f      gambit)

("s32vector?"                         (1)   #f 0     0    boolean gambit)
("s32vector"                          0     #f 0     0    #f      gambit)
("make-s32vector"                     (2)   #f 0     0    #f      gambit)
("s32vector-length"                   (1)   #f 0     0    integer gambit)
("s32vector-ref"                      (2)   #f 0     0    integer gambit)
("s32vector-set!"                     (3)   #t 0     0    #f      gambit)
("s32vector->list"                    (1)   #f 0     0    list    gambit)
("list->s32vector"                    (1)   #f 0     0    #f      gambit)

("u32vector?"                         (1)   #f 0     0    boolean gambit)
("u32vector"                          0     #f 0     0    #f      gambit)
("make-u32vector"                     (2)   #f 0     0    #f      gambit)
("u32vector-length"                   (1)   #f 0     0    integer gambit)
("u32vector-ref"                      (2)   #f 0     0    integer gambit)
("u32vector-set!"                     (3)   #t 0     0    #f      gambit)
("u32vector->list"                    (1)   #f 0     0    list    gambit)
("list->u32vector"                    (1)   #f 0     0    #f      gambit)

("s64vector?"                         (1)   #f 0     0    boolean gambit)
("s64vector"                          0     #f 0     0    #f      gambit)
("make-s64vector"                     (2)   #f 0     0    #f      gambit)
("s64vector-length"                   (1)   #f 0     0    integer gambit)
("s64vector-ref"                      (2)   #f 0     0    integer gambit)
("s64vector-set!"                     (3)   #t 0     0    #f      gambit)
("s64vector->list"                    (1)   #f 0     0    list    gambit)
("list->s64vector"                    (1)   #f 0     0    #f      gambit)

("u64vector?"                         (1)   #f 0     0    boolean gambit)
("u64vector"                          0     #f 0     0    #f      gambit)
("make-u64vector"                     (2)   #f 0     0    #f      gambit)
("u64vector-length"                   (1)   #f 0     0    integer gambit)
("u64vector-ref"                      (2)   #f 0     0    integer gambit)
("u64vector-set!"                     (3)   #t 0     0    #f      gambit)
("u64vector->list"                    (1)   #f 0     0    list    gambit)
("list->u64vector"                    (1)   #f 0     0    #f      gambit)

("f32vector?"                         (1)   #f 0     0    boolean gambit)
("f32vector"                          0     #f 0     0    #f      gambit)
("make-f32vector"                     (2)   #f 0     0    #f      gambit)
("f32vector-length"                   (1)   #f 0     0    integer gambit)
("f32vector-ref"                      (2)   #f 0     0    real    gambit)
("f32vector-set!"                     (3)   #t 0     0    #f      gambit)
("f32vector->list"                    (1)   #f 0     0    list    gambit)
("list->f32vector"                    (1)   #f 0     0    #f      gambit)

("f64vector?"                         (1)   #f 0     0    boolean gambit)
("f64vector"                          0     #f 0     0    #f      gambit)
("make-f64vector"                     (2)   #f 0     0    #f      gambit)
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
("##unbound?"                         (1)   #f ()    0    boolean extended)
("##eq?"                              (2)   #f ()    0    boolean extended)
("##eqv?"                             (2)   #f ()    0    boolean extended)
("##equal?"                           (2)   #f ()    0    boolean extended)
("##eof-object?"                      (1)   #f ()    0    boolean extended)

("##fixnum?"                          (1)   #f ()    0    boolean extended)
("##special?"                         (1)   #f ()    0    boolean extended)
("##pair?"                            (1)   #f ()    0    boolean extended)
("##pair-mutable?"                    (1)   #f ()    0    boolean extended)
("##subtyped?"                        (1)   #f ()    0    boolean extended)
("##subtyped-mutable?"                (1)   #f ()    0    boolean extended)
("##subtyped.vector?"                 (1)   #f ()    0    boolean extended)
("##subtyped.symbol?"                 (1)   #f ()    0    boolean extended)
("##subtyped.flonum?"                 (1)   #f ()    0    boolean extended)
("##subtyped.bignum?"                 (1)   #f ()    0    boolean extended)
("##vector?"                          (1)   #f ()    0    boolean extended)
("##ratnum?"                          (1)   #f ()    0    boolean extended)
("##cpxnum?"                          (1)   #f ()    0    boolean extended)
("##structure?"                       (1)   #f ()    0    boolean extended)
("##box?"                             (1)   #f ()    0    boolean extended)
("##values?"                          (1)   #f ()    0    boolean extended)
("##meroon?"                          (1)   #f ()    0    boolean extended)
("##jazz?"                            (1)   #f ()    0    boolean extended)
("##symbol?"                          (1)   #f ()    0    boolean extended)
("##keyword?"                         (1)   #f ()    0    boolean extended)
("##frame?"                           (1)   #f ()    0    boolean extended)
("##continuation?"                    (1)   #f ()    0    boolean extended)
("##promise?"                         (1)   #f ()    0    boolean extended)
("##will?"                            (1)   #f ()    0    boolean extended)
("##gc-hash-table?"                   (1)   #f ()    0    boolean extended)
("##mem-allocated?"                   (1)   #f ()    0    boolean extended)
("##procedure?"                       (1)   #f ()    0    boolean extended)
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
("##closure?"                         (1)   #f ()    0    boolean extended)
("##subprocedure?"                    (1)   #f ()    0    boolean extended)
("##return-dynamic-env-bind?"         (1)   #f ()    0    boolean extended)
("##number?"                          (1)   #f ()    0    boolean extended)
("##complex?"                         (1)   #f ()    0    boolean extended)
("##real?"                            (1)   #f ()    0    boolean extended)
("##rational?"                        (1)   #f ()    0    boolean extended)
("##integer?"                         (1)   #f ()    0    boolean extended)
("##exact?"                           (1)   #f ()    0    boolean extended)
("##inexact?"                         (1)   #f ()    0    boolean extended)

;; old fixnum/flonum procedures

("##fixnum.max"                       1     #f ()    0    fixnum  extended)
("##fixnum.min"                       1     #f ()    0    fixnum  extended)
("##fixnum.wrap+"                     0     #f ()    0    fixnum  extended)
("##fixnum.+"                         0     #f ()    0    fixnum  extended)
("##fixnum.+?"                        (2)   #f ()    0    #f      extended)
("##fixnum.wrap*"                     0     #f ()    0    fixnum  extended)
("##fixnum.*"                         0     #f ()    0    fixnum  extended)
("##fixnum.*?"                        (2)   #f ()    0    #f      extended)
("##fixnum.wrap-"                     1     #f ()    0    fixnum  extended)
("##fixnum.-"                         1     #f ()    0    fixnum  extended)
("##fixnum.-?"                        (1 2) #f ()    0    #f      extended)
("##fixnum.wrapquotient"              (2)   #f ()    0    fixnum  extended)
("##fixnum.quotient"                  (2)   #f ()    0    fixnum  extended)
("##fixnum.remainder"                 (2)   #f ()    0    fixnum  extended)
("##fixnum.modulo"                    (2)   #f ()    0    fixnum  extended)
("##fixnum.bitwise-ior"               0     #f ()    0    fixnum  extended)
("##fixnum.bitwise-xor"               0     #f ()    0    fixnum  extended)
("##fixnum.bitwise-and"               0     #f ()    0    fixnum  extended)
("##fixnum.bitwise-not"               (1)   #f ()    0    fixnum  extended)
("##fixnum.wraparithmetic-shift"      (2)   #f ()    0    fixnum  extended)
("##fixnum.arithmetic-shift"          (2)   #f ()    0    fixnum  extended)
("##fixnum.arithmetic-shift?"         (2)   #f ()    0    #f      extended)
("##fixnum.wraparithmetic-shift-left" (2)   #f ()    0    fixnum  extended)
("##fixnum.arithmetic-shift-left"     (2)   #f ()    0    fixnum  extended)
("##fixnum.arithmetic-shift-left?"    (2)   #f ()    0    #f      extended)
("##fixnum.arithmetic-shift-right"    (2)   #f ()    0    fixnum  extended)
("##fixnum.arithmetic-shift-right?"   (2)   #f ()    0    #f extended)
("##fixnum.wraplogical-shift-right"   (2)   #f ()    0    fixnum  extended)
("##fixnum.wraplogical-shift-right?"  (2)   #f ()    0    #f      extended)
("##fixnum.wrapabs"                   (1)   #f ()    0    fixnum  extended)
("##fixnum.abs"                       (1)   #f ()    0    fixnum  extended)
("##fixnum.abs?"                      (1)   #f ()    0    #f      extended)
("##fixnum.zero?"                     (1)   #f ()    0    boolean extended)
("##fixnum.positive?"                 (1)   #f ()    0    boolean extended)
("##fixnum.negative?"                 (1)   #f ()    0    boolean extended)
("##fixnum.odd?"                      (1)   #f ()    0    boolean extended)
("##fixnum.even?"                     (1)   #f ()    0    boolean extended)
("##fixnum.="                         0     #f ()    0    boolean extended)
("##fixnum.<"                         0     #f ()    0    boolean extended)
("##fixnum.>"                         0     #f ()    0    boolean extended)
("##fixnum.<="                        0     #f ()    0    boolean extended)
("##fixnum.>="                        0     #f ()    0    boolean extended)
("##fixnum.->char"                    (1)   #f ()    0    char    extended)
("##fixnum.<-char"                    (1)   #f ()    0    fixnum  extended)

("##flonum.->fixnum"                  (1)   #f ()    0    fixnum  extended)
("##flonum.<-fixnum"                  (1)   #f ()    0    real    extended)
("##flonum.max"                       1     #f ()    0    real    extended)
("##flonum.min"                       1     #f ()    0    real    extended)
("##flonum.+"                         0     #f ()    0    real    extended)
("##flonum.*"                         0     #f ()    0    real    extended)
("##flonum.-"                         1     #f ()    0    real    extended)
("##flonum./"                         1     #f ()    0    real    extended)
("##flonum.abs"                       (1)   #f ()    0    real    extended)
("##flonum.floor"                     (1)   #f ()    0    real    extended)
("##flonum.ceiling"                   (1)   #f ()    0    real    extended)
("##flonum.truncate"                  (1)   #f ()    0    real    extended)
("##flonum.round"                     (1)   #f ()    0    real    extended)
("##flonum.exp"                       (1)   #f ()    0    real    extended)
("##flonum.log"                       (1)   #f ()    0    real    extended)
("##flonum.sin"                       (1)   #f ()    0    real    extended)
("##flonum.cos"                       (1)   #f ()    0    real    extended)
("##flonum.tan"                       (1)   #f ()    0    real    extended)
("##flonum.asin"                      (1)   #f ()    0    real    extended)
("##flonum.acos"                      (1)   #f ()    0    real    extended)
("##flonum.atan"                      (1 2) #f ()    0    real    extended)
("##flonum.expt"                      (2)   #f ()    0    real    extended)
("##flonum.sqrt"                      (1)   #f ()    0    real    extended)
("##flonum.copysign"                  (2)   #f ()    0    real    extended)
("##flonum.integer?"                  (1)   #f ()    0    boolean extended)
("##flonum.zero?"                     (1)   #f ()    0    boolean extended)
("##flonum.positive?"                 (1)   #f ()    0    boolean extended)
("##flonum.negative?"                 (1)   #f ()    0    boolean extended)
("##flonum.odd?"                      (1)   #f ()    0    boolean extended)
("##flonum.even?"                     (1)   #f ()    0    boolean extended)
("##flonum.finite?"                   (1)   #f ()    0    boolean extended)
("##flonum.infinite?"                 (1)   #f ()    0    boolean extended)
("##flonum.nan?"                      (1)   #f ()    0    boolean extended)
("##flonum.<-fixnum-exact?"           (1)   #f ()    0    boolean extended)
("##flonum.="                         0     #f ()    0    boolean extended)
("##flonum.<"                         0     #f ()    0    boolean extended)
("##flonum.>"                         0     #f ()    0    boolean extended)
("##flonum.<="                        0     #f ()    0    boolean extended)
("##flonum.>="                        0     #f ()    0    boolean extended)


;; new fixnum/flonum procedures

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
("##fxarithmetic-shift"          (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift?"         (2)   #f ()    0    #f      extended)
("##fxwraparithmetic-shift-left" (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-left"     (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-left?"    (2)   #f ()    0    #f      extended)
("##fxarithmetic-shift-right"    (2)   #f ()    0    fixnum  extended)
("##fxarithmetic-shift-right?"   (2)   #f ()    0    #f      extended)
("##fxwraplogical-shift-right"   (2)   #f ()    0    fixnum  extended)
("##fxwraplogical-shift-right?"  (2)   #f ()    0    #f      extended)
("##fxwrapabs"                   (1)   #f ()    0    fixnum  extended)
("##fxabs"                       (1)   #f ()    0    fixnum  extended)
("##fxabs?"                      (1)   #f ()    0    #f      extended)
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
("##fx->char"                    (1)   #f ()    0    char    extended)
("##fx<-char"                    (1)   #f ()    0    fixnum  extended)

("##fixnum->char"                (1)   #f ()    0    char    extended)
("##char->fixnum"                (1)   #f ()    0    fixnum  extended)
("##flonum->fixnum"              (1)   #f ()    0    fixnum  extended)
("##fixnum->flonum"              (1)   #f ()    0    real    extended)
("##fixnum->flonum-exact?"       (1)   #f ()    0    boolean extended)

("##fl->fx"                      (1)   #f ()    0    fixnum  extended)
("##fl<-fx"                      (1)   #f ()    0    real    extended)
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
("##flexp"                       (1)   #f ()    0    real    extended)
("##fllog"                       (1)   #f ()    0    real    extended)
("##flsin"                       (1)   #f ()    0    real    extended)
("##flcos"                       (1)   #f ()    0    real    extended)
("##fltan"                       (1)   #f ()    0    real    extended)
("##flasin"                      (1)   #f ()    0    real    extended)
("##flacos"                      (1)   #f ()    0    real    extended)
("##flatan"                      (1 2) #f ()    0    real    extended)
("##flexpt"                      (2)   #f ()    0    real    extended)
("##flsqrt"                      (1)   #f ()    0    real    extended)
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
("##fl<-fx-exact?"               (1)   #f ()    0    boolean extended)
("##fl="                         0     #f ()    0    boolean extended)
("##fl<"                         0     #f ()    0    boolean extended)
("##fl>"                         0     #f ()    0    boolean extended)
("##fl<="                        0     #f ()    0    boolean extended)
("##fl>="                        0     #f ()    0    boolean extended)




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

("##box"                              (1)   #f ()    0    #f      extended)
("##unbox"                            (1)   #f ()    0    (#f)    extended)
("##set-box!"                         (2)   #t ()    0    #f      extended)

("##make-will"                        (2)   #t ()    0    #f      extended)
("##will-testator"                    (1)   #f ()    0    (#f)    extended)

("##gc-hash-table-ref"                (2)   #f ()    0    (#f)    extended)
("##gc-hash-table-set!"               (3)   #t ()    0    (#f)    extended)
("##gc-hash-table-rehash!"            (2)   #t ()    0    (#f)    extended)

("##values"                           0     #f ()    0    (#f)    extended)

("##vector"                           0     #f ()    0    vector  extended)
("##make-vector"                      (2)   #f ()    0    vector  extended)
("##vector-length"                    (1)   #f ()    0    fixnum  extended)
("##vector-ref"                       (2)   #f ()    0    (#f)    extended)
("##vector-set!"                      (3)   #t ()    0    vector  extended)
("##vector-shrink!"                   (2)   #t ()    0    vector  extended)

("##string"                           0     #f ()    0    string  extended)
("##make-string"                      (2)   #f ()    0    string  extended)
("##string-length"                    (1)   #f ()    0    fixnum  extended)
("##string-ref"                       (2)   #f ()    0    char    extended)
("##string-set!"                      (3)   #t ()    0    string  extended)
("##string-shrink!"                   (2)   #t ()    0    string  extended)

("##s8vector"                         0     #f ()    0    #f      extended)
("##make-s8vector"                    (2)   #f ()    0    #f      extended)
("##s8vector-length"                  (1)   #f ()    0    fixnum  extended)
("##s8vector-ref"                     (2)   #f ()    0    fixnum  extended)
("##s8vector-set!"                    (3)   #t ()    0    #f      extended)
("##s8vector-shrink!"                 (2)   #t ()    0    #f      extended)

("##u8vector"                         0     #f ()    0    #f      extended)
("##make-u8vector"                    (2)   #f ()    0    #f      extended)
("##u8vector-length"                  (1)   #f ()    0    fixnum  extended)
("##u8vector-ref"                     (2)   #f ()    0    fixnum  extended)
("##u8vector-set!"                    (3)   #t ()    0    #f      extended)
("##u8vector-shrink!"                 (2)   #t ()    0    #f      extended)

("##s16vector"                        0     #f ()    0    #f      extended)
("##make-s16vector"                   (2)   #f ()    0    #f      extended)
("##s16vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s16vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s16vector-set!"                   (3)   #t ()    0    #f      extended)
("##s16vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u16vector"                        0     #f ()    0    #f      extended)
("##make-u16vector"                   (2)   #f ()    0    #f      extended)
("##u16vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u16vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u16vector-set!"                   (3)   #t ()    0    #f      extended)
("##u16vector-shrink!"                (2)   #t ()    0    #f      extended)

("##s32vector"                        0     #f ()    0    #f      extended)
("##make-s32vector"                   (2)   #f ()    0    #f      extended)
("##s32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s32vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s32vector-set!"                   (3)   #t ()    0    #f      extended)
("##s32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u32vector"                        0     #f ()    0    #f      extended)
("##make-u32vector"                   (2)   #f ()    0    #f      extended)
("##u32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u32vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u32vector-set!"                   (3)   #t ()    0    #f      extended)
("##u32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##s64vector"                        0     #f ()    0    #f      extended)
("##make-s64vector"                   (2)   #f ()    0    #f      extended)
("##s64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##s64vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##s64vector-set!"                   (3)   #t ()    0    #f      extended)
("##s64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##u64vector"                        0     #f ()    0    #f      extended)
("##make-u64vector"                   (2)   #f ()    0    #f      extended)
("##u64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##u64vector-ref"                    (2)   #f ()    0    fixnum  extended)
("##u64vector-set!"                   (3)   #t ()    0    #f      extended)
("##u64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##f32vector"                        0     #f ()    0    #f      extended)
("##make-f32vector"                   (2)   #f ()    0    #f      extended)
("##f32vector-length"                 (1)   #f ()    0    fixnum  extended)
("##f32vector-ref"                    (2)   #f ()    0    real    extended)
("##f32vector-set!"                   (3)   #t ()    0    #f      extended)
("##f32vector-shrink!"                (2)   #t ()    0    #f      extended)

("##f64vector"                        0     #f ()    0    #f      extended)
("##make-f64vector"                   (2)   #f ()    0    #f      extended)
("##f64vector-length"                 (1)   #f ()    0    fixnum  extended)
("##f64vector-ref"                    (2)   #f ()    0    real    extended)
("##f64vector-set!"                   (3)   #t ()    0    #f      extended)
("##f64vector-shrink!"                (2)   #t ()    0    #f      extended)

("##structure-direct-instance-of?"    (2)   #f ()    0    boolean extended)
("##structure-instance-of?"           (2)   #f ()    0    boolean extended)
("##structure-type"                   (1)   #f ()    0    (#f)    extended)
("##structure-type-set!"              (2)   #t ()    0    (#f)    extended)
("##structure"                        1     #f ()    0    (#f)    extended)
("##structure-ref"                    (4)   #f ()    0    (#f)    extended)
("##structure-set!"                   (5)   #t ()    0    (#f)    extended)
("##direct-structure-ref"             (4)   #f ()    0    (#f)    extended)
("##direct-structure-set!"            (5)   #t ()    0    (#f)    extended)
("##unchecked-structure-ref"          (4)   #f ()    0    (#f)    extended)
("##unchecked-structure-set!"         (5)   #t ()    0    (#f)    extended)

("##type-id"                          (1)   #f ()    0    #f      extended)
("##type-name"                        (1)   #f ()    0    #f      extended)
("##type-flags"                       (1)   #f ()    0    #f      extended)
("##type-super"                       (1)   #f ()    0    #f      extended)
("##type-fields"                      (1)   #f ()    0    #f      extended)

("##symbol->string"                   (1)   #f ()    0    string  extended)

("##keyword->string"                  (1)   #f ()    0    string  extended)

("##closure-length"                   (1)   #f ()    0    fixnum  extended)
("##closure-code"                     (1)   #f ()    0    #f      extended)
("##closure-ref"                      (2)   #f ()    0    (#f)    extended)
("##closure-set!"                     (3)   #t ()    0    #f      extended)

("##subprocedure-id"                  (1)   #f ()    0    #f      extended)
("##subprocedure-parent"              (1)   #f ()    0    #f      extended)

("##procedure-info"                   (1)   #f ()    0    #f      extended)

("##make-promise"                     (1)   #f 0     0    (#f)    extended)
("##force"                            (1)   #t 0     0    #f      extended)

("##void"                             (0)   #f ()    0    #f      extended)

("current-thread"                     (0)   #f ()    0    #f      extended)
("##current-thread"                   (0)   #f ()    0    #f      extended)
("##run-queue"                        (0)   #f ()    0    #f      extended)

("##thread-save!"                     1     #t ()    1113 (#f)    extended)
("##thread-restore!"                  2     #t ()    2203 #f      extended)

("##continuation-capture"             1     #t ()    1113 (#f)    extended)
("##continuation-graft"               2     #t ()    2203 #f      extended)
("##continuation-graft-no-winding"    2     #t ()    2203 #f      extended)
("##continuation-return"              (2)   #t ()    0    #f      extended)
("##continuation-return-no-winding"   (2)   #t ()    0    #f      extended)

("##apply"                            (2)   #t ()    0    (#f)    extended)
("##call-with-current-continuation"   1     #t ()    1113 (#f)    extended)
("##make-global-var"                  (1)   #t ()    0    #f      extended)
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
("##bignum.->fixnum"                  (1)   #f ()    0    integer extended)
("##bignum.<-fixnum"                  (1)   #f ()    0    integer extended)
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

)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (setup-prim-expanders targ)

(define (def-exp name expander)
  (let ((proc ((target-prim-info targ) (string->canonical-symbol name))))
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
  (define **pair-mutable?-sym (string->canonical-symbol "##pair-mutable?"))
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
                (generate-call vars1)))
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
                    **pair-mutable?-sym
                    (list (car vars))))
                (gen-call-prim-vars source env
                  (op-prim pattern)
                  vars)
                (generate-call vars)))))))

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
                      (gen-call-prim-vars source env **pair?-sym (list lst1-var))
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
                                  (generate-call vars))
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
                          (gen-call-prim-vars source env **null?-sym (list lst1-var))
                          (new-cst source env
                            false-object)
                          (generate-call vars))
                        (new-cst source env
                          false-object)))))))

        (gen-prc source env
          vars
          (if check-run-time-binding
            (new-tst source env
              (check-run-time-binding)
              (gen-main-loop)
              (generate-call vars))
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
                          (generate-call vars))))))))

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
                (generate-call vars))
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

  (define **fxnot-sym (string->canonical-symbol "##fxnot"))
  (define **fxand-sym (string->canonical-symbol "##fxand"))
  (define **fxior-sym (string->canonical-symbol "##fxior"))
  (define **fxxor-sym (string->canonical-symbol "##fxxor"))

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

  (define **fl<-fx-sym (string->canonical-symbol "##fl<-fx"))

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
       #f
       (lambda ()
         (gen source env vars invalid))
       fail)))

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
       #f
       (lambda ()
         (gen source env vars invalid))
       fail)))

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
                        (generate-call vars)))
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
                   (generate-call vars))))
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
                          (generate-call vars))))
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
        targ-inexact-+0))) ;; TODO: remove this dependency on C backend

  (define gen-flonum-1
    (lambda (source env vars invalid)
      (new-cst source env
        targ-inexact-+1))) ;; TODO: remove this dependency on C backend

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

  (let ()

    (define case-fxmax
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmax-sym))))

    (define case-fxmin
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmin-sym))))

    (define case-fxwrap+
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-fold-generator **fxwrap+-sym))))

    (define case-fx+
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-conditional-fold-generator **fx+?-sym))))

    (define case-fxwrap*
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-1
        gen-first-arg
        (make-fold-generator **fxwrap*-sym))))

    (define case-fx*
      (gen-validating-case
       **fixnum?-sym
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
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (make-prim-generator **fxwrap--sym)
        (make-fold-generator **fxwrap--sym))))

    (define case-fx-
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
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
                      **fx-?-sym
                      vars)))))
        (lambda (source env vars invalid)
          (gen-conditional-fold source env
            vars
            invalid
            (lambda (source env var1 var2)
              (gen-call-prim-vars source env
                **fx-?-sym
                (list var1 var2))))))))

    (define case-fxwrapquotient
      (gen-simple-case **fixnum?-sym **fxwrapquotient-sym))

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
                    **fxabs?-sym
                    vars)))))))

    (define case-fxnot
      (gen-simple-case **fixnum?-sym **fxnot-sym))

    (define case-fxand
      (gen-simple-case **fixnum?-sym **fxand-sym))

    (define case-fxior
      (gen-simple-case **fixnum?-sym **fxior-sym))

    (define case-fxxor
      (gen-simple-case **fixnum?-sym **fxxor-sym))

    ; fxwraparithmetic-shift
    ; fxarithmetic-shift
    ; fxwraparithmetic-shift-left
    ; fxarithmetic-shift-left
    ; fxarithmetic-shift-right
    ; fxwraplogical-shift-right

    (define case-fixnum->flonum
      (gen-fixnum-case
       (make-prim-generator **fl<-fx-sym)))

    (define case-fixnum-exact->inexact
      (gen-fixnum-case
       (make-prim-generator **fl<-fx-sym)))

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
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmax-sym))))

    (define case-flmin
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmin-sym))))

    (define case-fl+
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0
        gen-first-arg
        (make-fold-generator **fl+-sym))))

    (define case-fl*
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-1
        gen-first-arg
        (make-fold-generator **fl*-sym))))

    (define case-fl-
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl--sym)
        (make-fold-generator **fl--sym))))

    (define case-fl/
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl/-sym)
        (make-fold-generator **fl/-sym))))

    (define case-flabs
      (gen-simple-case **flonum?-sym **flabs-sym))

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
               (gen-call-prim-vars source (add-not-inline-primitives env)
                 **real?-sym
                 vars))))
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
               (gen-call-prim-vars source (add-not-inline-primitives env)
                 **rational?-sym
                 vars))))
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
             (gen-call-prim-vars source (add-not-inline-primitives env)
               **integer?-sym
               vars)))
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
               (gen-call-prim-vars source (add-not-inline-primitives env)
                 fallback
                 vars))))
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
               (gen-call-prim-vars source (add-not-inline-primitives env)
                 fallback
                 vars))))
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
                         (gen-validating-case
                          **flonum?-sym
                          (make-nary-generator
                           gen-fixnum-0
                           gen-first-arg
                           (make-fold-generator **fl+-sym)))))

    (def-exp "fxwrap*" (make-simple-expander case-fxwrap*))
    (def-exp "fx*"     (make-simple-expander case-fx*))
    (def-exp "fl*"     (make-simple-expander case-fl*))
    (def-exp "*"       (make-fixflo-expander
                         case-fx*
                         (gen-validating-case
                          **flonum?-sym
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

;;  (def-exp "fxwraparithmetic-shift" (make-simple-expander case-fxwraparithmetic-shift))
;;  (def-exp "fxarithmetic-shift" (make-simple-expander case-fxarithmetic-shift))

;;  (def-exp "fxwraparithmetic-shift-left" (make-simple-expander case-fxwraparithmetic-shift-left))
;;  (def-exp "fxarithmetic-shift-left" (make-simple-expander case-fxarithmetic-shift-left))

;;  (def-exp "fxarithmetic-shift-right" (make-simple-expander case-fxarithmetic-shift-right))
;;  (def-exp "fxwraplogical-shift-right" (make-simple-expander case-fxwraplogical-shift-right))

    (def-exp "fxwrapabs" (make-simple-expander case-fxwrapabs))
    (def-exp "fxabs" (make-simple-expander case-fxabs))
    (def-exp "flabs" (make-simple-expander case-flabs))
    (def-exp "abs"   (make-fixflo-expander case-fxabs case-flabs))

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

    (def-exp
     "eqv?"
     (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

    (def-exp
     "##eqv?"
     (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

    (def-exp
     "equal?"
     (make-simple-expander (case-eqv?-or-equal? **mem-allocated?-sym)))
))

(define (setup-vector-primitives)

  (define **fixnum?-sym (string->canonical-symbol "##fixnum?"))
  (define **flonum?-sym (string->canonical-symbol "##flonum?"))
  (define **char?-sym   (string->canonical-symbol "##char?"))
  (define **fx<-sym     (string->canonical-symbol "##fx<"))
  (define **fx<=-sym    (string->canonical-symbol "##fx<="))
  (define **subtyped-mutable?-sym (string->canonical-symbol "##subtyped-mutable?"))

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
    ; assumes (integer-length hi) >= (integer-length lo)
    (lambda (source env var)
      (if (targ-fixnum64? hi) ;; TODO: remove this dependency on C backend
        (let ((interval-check
               (gen-fixnum-interval-check source env
                 var
                 (new-cst source env
                   lo)
                 (new-cst source env
                   hi)
                 #t)))
          (if (targ-fixnum32? hi) ;; TODO: remove this dependency on C backend
            interval-check
            (new-conj source env
              (gen-call-prim source env
                **fixnum?-sym
                (list (new-cst source env
                        hi)))
              interval-check)))
        (gen-call-prim-vars source env
          **fixnum?-sym
          (list var)))))

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
           **vect?-str
           **vect-length-str
           **vect-ref-str
           **vect-set!-str
           value-checker)
    (let ((vect?-sym (string->canonical-symbol vect?-str))
          (vect-length-sym (string->canonical-symbol vect-length-str))
          (vect-ref-sym (string->canonical-symbol vect-ref-str))
          (vect-set!-sym (string->canonical-symbol vect-set!-str))
          (**vect?-sym (string->canonical-symbol **vect?-str))
          (**vect-length-sym (string->canonical-symbol **vect-length-str))
          (**vect-ref-sym (string->canonical-symbol **vect-ref-str))
          (**vect-set!-sym (string->canonical-symbol **vect-set!-str)))

      (define (gen-type-check source env vect-arg)
        (gen-call-prim-vars source env
          **vect?-sym
          (list vect-arg)))

      (define (gen-mutability-check source env vect-arg)
        (gen-call-prim-vars source env
          **subtyped-mutable?-sym
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
                  (generate-call vars))
                call-prim)))))

      (define (make-ref-set!-expander type-check? set!?)
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
                       (let ((check
                              (gen-type-check source env arg1)))
                         (if set!?
                           (new-conj source env
                             check
                             (gen-mutability-check source env arg1))
                           check))))
                 (index-check
                  (gen-index-check source env arg1 arg2))
                 (index-value-check
                  (if (and value-checker set!?)
                    (let ((val-check (value-checker source env (caddr vars))))
                      (new-conj source env
                        index-check
                        val-check))
                    index-check))
                 (type-index-value-check
                  (if type-check
                    (new-conj source env
                      type-check
                      index-value-check)
                    index-value-check))
                 (checks
                  (if check-run-time-binding
                    (let ((rtb-check (check-run-time-binding)))
                      (if type-index-value-check
                        (new-conj source env
                          rtb-check
                          type-index-value-check)
                        rtb-check))
                    type-index-value-check))
                 (call-prim
                  (gen-call-prim-vars source env
                    (if set!? **vect-set!-sym **vect-ref-sym)
                    vars)))
            (gen-prc source env
              vars
              (if checks
                (new-tst source env
                  checks
                  call-prim
                  (generate-call vars))
                call-prim)))))

      (def-exp
       vect-length-str
       (make-length-expander #t))

      (def-exp
       vect-ref-str
       (make-ref-set!-expander #t #f))

      (def-exp
       vect-set!-str
       (make-ref-set!-expander #t #t))))
          
  (make-vector-expanders
   "vector?"
   "vector-length"
   "vector-ref"
   "vector-set!"
   "##vector?"
   "##vector-length"
   "##vector-ref"
   "##vector-set!"
   #f)

  (make-vector-expanders
   "string?"
   "string-length"
   "string-ref"
   "string-set!"
   "##string?"
   "##string-length"
   "##string-ref"
   "##string-set!"
   (lambda (source env var)
     (gen-call-prim-vars source env
       **char?-sym
       (list var))))

  (make-vector-expanders
   "s8vector?"
   "s8vector-length"
   "s8vector-ref"
   "s8vector-set!"
   "##s8vector?"
   "##s8vector-length"
   "##s8vector-ref"
   "##s8vector-set!"
   (make-fixnum-interval-checker -128 127))

  (make-vector-expanders
   "u8vector?"
   "u8vector-length"
   "u8vector-ref"
   "u8vector-set!"
   "##u8vector?"
   "##u8vector-length"
   "##u8vector-ref"
   "##u8vector-set!"
   (make-fixnum-interval-checker 0 255))

  (make-vector-expanders
   "s16vector?"
   "s16vector-length"
   "s16vector-ref"
   "s16vector-set!"
   "##s16vector?"
   "##s16vector-length"
   "##s16vector-ref"
   "##s16vector-set!"
   (make-fixnum-interval-checker -32768 32767))

  (make-vector-expanders
   "u16vector?"
   "u16vector-length"
   "u16vector-ref"
   "u16vector-set!"
   "##u16vector?"
   "##u16vector-length"
   "##u16vector-ref"
   "##u16vector-set!"
   (make-fixnum-interval-checker 0 65535))

#;
  (make-vector-expanders
   "s32vector?"
   "s32vector-length"
   "s32vector-ref"
   "s32vector-set!"
   "##s32vector?"
   "##s32vector-length"
   "##s32vector-ref"
   "##s32vector-set!"
   (make-fixnum-interval-checker -2147483648 2147483647))

#;
  (make-vector-expanders
   "u32vector?"
   "u32vector-length"
   "u32vector-ref"
   "u32vector-set!"
   "##u32vector?"
   "##u32vector-length"
   "##u32vector-ref"
   "##u32vector-set!"
   (make-fixnum-interval-checker 0 4294967295))

#;
  (make-vector-expanders
   "s64vector?"
   "s64vector-length"
   "s64vector-ref"
   "s64vector-set!"
   "##s64vector?"
   "##s64vector-length"
   "##s64vector-ref"
   "##s64vector-set!"
   (make-fixnum-interval-checker -9223372036854775808 9223372036854775807))

#;
  (make-vector-expanders
   "u64vector?"
   "u64vector-length"
   "u64vector-ref"
   "u64vector-set!"
   "##u64vector?"
   "##u64vector-length"
   "##u64vector-ref"
   "##u64vector-set!"
   (make-fixnum-interval-checker 0 18446744073709551615))

  (make-vector-expanders
   "f32vector?"
   "f32vector-length"
   "f32vector-ref"
   "f32vector-set!"
   "##f32vector?"
   "##f32vector-length"
   "##f32vector-ref"
   "##f32vector-set!"
   (make-flonum-checker))

  (make-vector-expanders
   "f64vector?"
   "f64vector-length"
   "f64vector-ref"
   "f64vector-set!"
   "##f64vector?"
   "##f64vector-length"
   "##f64vector-ref"
   "##f64vector-set!"
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

  (define (gen-type-check source env obj-arg type-arg)
    (gen-call-prim source env
      **structure-direct-instance-of?-sym
      (list (new-ref source env
              obj-arg)
            (gen-call-prim-vars source env
              **type-id-sym
              (list type-arg)))))

  (define (make-ref-set!-expander set!?)
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
              (list-ref vars (if set!? 3 2)))
             (type-check
              (gen-type-check source env obj-var type-var))
             (call-prim
              (gen-call-prim-vars source env
                (if set!?
                  **unchecked-structure-set!-sym
                  **unchecked-structure-ref-sym)
                vars)))
        (gen-prc source env
          vars
          (new-tst source env
            type-check
            call-prim
            (generate-call vars))))))

  (def-exp
   "##direct-structure-ref"
   (make-ref-set!-expander #f))

  (def-exp
   "##direct-structure-set!"
   (make-ref-set!-expander #t))
)

(setup-list-primitives)
(setup-numeric-primitives)
(setup-vector-primitives)
(setup-structure-primitives)

)

;;;============================================================================
