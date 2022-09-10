;;;============================================================================

;;; File: "_parms.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

;;;----------------------------------------------------------------------------

;; Compiler parameters module
;; --------------------------

;; This module contains definitions that parameterize the behavior of
;; the compiler.

;;;----------------------------------------------------------------------------

;; Specific symbols needed by the compiler.

(define **quote-sym            (string->canonical-symbol "##quote"))
(define **quasiquote-sym       (string->canonical-symbol "##quasiquote"))
(define **set!-sym             (string->canonical-symbol "##set!"))
(define **lambda-sym           (string->canonical-symbol "##lambda"))
(define **if-sym               (string->canonical-symbol "##if"))
(define **cond-sym             (string->canonical-symbol "##cond"))
(define **and-sym              (string->canonical-symbol "##and"))
(define **or-sym               (string->canonical-symbol "##or"))
(define **case-sym             (string->canonical-symbol "##case"))
(define **let-sym              (string->canonical-symbol "##let"))
(define **let*-sym             (string->canonical-symbol "##let*"))
(define **letrec-sym           (string->canonical-symbol "##letrec"))
(define **letrec*-sym          (string->canonical-symbol "##letrec*"))
(define **let-values-sym       (string->canonical-symbol "##let-values"))
(define **let*-values-sym      (string->canonical-symbol "##let*-values"))
(define **letrec-values-sym    (string->canonical-symbol "##letrec-values"))
(define **letrec*-values-sym   (string->canonical-symbol "##letrec*-values"))
(define **do-sym               (string->canonical-symbol "##do"))
(define **guard-sym            (string->canonical-symbol "##guard"))
(define **r7rs-guard-sym       (string->canonical-symbol "##r7rs-guard"))
(define **delay-sym            (string->canonical-symbol "##delay"))
(define **future-sym           (string->canonical-symbol "##future"))
(define **c-define-type-sym    (string->canonical-symbol "##c-define-type"))
(define **c-declare-sym        (string->canonical-symbol "##c-declare"))
(define **c-initialize-sym     (string->canonical-symbol "##c-initialize"))
(define **c-lambda-sym         (string->canonical-symbol "##c-lambda"))
(define **c-define-sym         (string->canonical-symbol "##c-define"))

(define **begin-sym            (string->canonical-symbol "##begin"))
(define **define-sym           (string->canonical-symbol "##define"))
(define **define-macro-sym     (string->canonical-symbol "##define-macro"))
(define **define-syntax-sym    (string->canonical-symbol "##define-syntax"))
(define **include-sym          (string->canonical-symbol "##include"))
(define **declare-sym          (string->canonical-symbol "##declare"))
(define **namespace-sym        (string->canonical-symbol "##namespace"))
(define **this-source-file-sym (string->canonical-symbol "##this-source-file"))

(define **declare-scope-sym    (string->canonical-symbol "##declare-scope"))
(define **namespace-scope-sym  (string->canonical-symbol "##namespace-scope"))
(define **macro-scope-sym      (string->canonical-symbol "##macro-scope"))

(define quote-sym              (string->canonical-symbol "quote"))
(define set!-sym               (string->canonical-symbol "set!"))
(define define-sym             (string->canonical-symbol "define"))
(define if-sym                 (string->canonical-symbol "if"))
(define and-sym                (string->canonical-symbol "and"))
(define or-sym                 (string->canonical-symbol "or"))
(define lambda-sym             (string->canonical-symbol "lambda"))
(define let-sym                (string->canonical-symbol "let"))
(define letrec-sym             (string->canonical-symbol "letrec"))
(define letrec*-sym            (string->canonical-symbol "letrec*"))
(define future-sym             (string->canonical-symbol "future"))
(define begin-sym              (string->canonical-symbol "begin"))

(define =>-sym                 (string->canonical-symbol "=>"))
(define else-sym               (string->canonical-symbol "else"))
(define not-sym                (string->canonical-symbol "not"))
(define quasiquote-sym         (string->canonical-symbol "quasiquote"))
(define unquote-sym            (string->canonical-symbol "unquote"))
(define unquote-splicing-sym   (string->canonical-symbol "unquote-splicing"))

(define **dead-end-sym         (string->canonical-symbol "##dead-end"))
(define **identity-sym         (string->canonical-symbol "##identity"))
(define **not-sym              (string->canonical-symbol "##not"))
(define **eq?-sym              (string->canonical-symbol "##eq?"))
(define **eqv?-sym             (string->canonical-symbol "##eqv?"))
(define **quasi-append-sym     (string->canonical-symbol "##quasi-append"))
(define **quasi-list-sym       (string->canonical-symbol "##quasi-list"))
(define **quasi-cons-sym       (string->canonical-symbol "##quasi-cons"))
(define **quasi-list->vector-sym (string->canonical-symbol "##quasi-list->vector"))
(define **quasi-vector-sym     (string->canonical-symbol "##quasi-vector"))
(define **case-memv-sym        (string->canonical-symbol "##case-memv"))
(define **box-sym              (string->canonical-symbol "##box"))
(define **unbox-sym            (string->canonical-symbol "##unbox"))
(define **set-box!-sym         (string->canonical-symbol "##set-box!"))
(define **make-delay-promise-sym (string->canonical-symbol "##make-delay-promise"))
(define **with-exception-catcher-sym (string->canonical-symbol "##with-exception-catcher"))
(define **raise-sym            (string->canonical-symbol "##raise"))
(define **r7rs-with-exception-catcher-sym (string->canonical-symbol "##r7rs-with-exception-catcher"))
(define **r7rs-reraise-sym     (string->canonical-symbol "##r7rs-reraise"))

(define ieee-scheme-sym        (string->canonical-symbol "ieee-scheme"))
(define r4rs-scheme-sym        (string->canonical-symbol "r4rs-scheme"))
(define r5rs-scheme-sym        (string->canonical-symbol "r5rs-scheme"))
(define gambit-scheme-sym      (string->canonical-symbol "gambit-scheme"))
(define multilisp-sym          (string->canonical-symbol "multilisp"))

(define constant-fold-sym      (string->canonical-symbol "constant-fold"))

(define lambda-lift-sym        (string->canonical-symbol "lambda-lift"))

(define inline-sym             (string->canonical-symbol "inline"))
(define inline-primitives-sym  (string->canonical-symbol "inline-primitives"))
(define inlining-limit-sym     (string->canonical-symbol "inlining-limit"))

(define block-sym              (string->canonical-symbol "block"))
(define separate-sym           (string->canonical-symbol "separate"))

(define core-sym               (string->canonical-symbol "core"))

(define standard-bindings-sym  (string->canonical-symbol "standard-bindings"))
(define extended-bindings-sym  (string->canonical-symbol "extended-bindings"))
(define run-time-bindings-sym  (string->canonical-symbol "run-time-bindings"))

(define safe-sym               (string->canonical-symbol "safe"))

(define warnings-sym           (string->canonical-symbol "warnings"))

(define interrupts-enabled-sym (string->canonical-symbol "interrupts-enabled"))
(define poll-on-return-sym     (string->canonical-symbol "poll-on-return"))

(define debug-sym              (string->canonical-symbol "debug"))
(define debug-location-sym     (string->canonical-symbol "debug-location"))
(define debug-source-sym       (string->canonical-symbol "debug-source"))
(define debug-environments-sym (string->canonical-symbol "debug-environments"))

(define environment-map-sym    (string->canonical-symbol "environment-map")) ;; deprecated: use debug-environments

(define proper-tail-calls-sym  (string->canonical-symbol "proper-tail-calls"))

(define generative-lambda-sym  (string->canonical-symbol "generative-lambda"))

(define optimize-dead-local-variables-sym (string->canonical-symbol "optimize-dead-local-variables"))

(define optimize-dead-definitions-sym (string->canonical-symbol "optimize-dead-definitions"))

(define generic-sym            (string->canonical-symbol "generic"))
(define fixnum-sym             (string->canonical-symbol "fixnum"))
(define flonum-sym             (string->canonical-symbol "flonum"))

(define mostly-generic-sym     (string->canonical-symbol "mostly-generic"))
(define mostly-fixnum-sym      (string->canonical-symbol "mostly-fixnum"))
(define mostly-flonum-sym      (string->canonical-symbol "mostly-flonum"))
(define mostly-fixnum-flonum-sym (string->canonical-symbol "mostly-fixnum-flonum"))
(define mostly-flonum-fixnum-sym (string->canonical-symbol "mostly-flonum-fixnum"))

(define allocation-limit-sym   (string->canonical-symbol "allocation-limit"))

(define int8-sym               (string->canonical-symbol "int8"))
(define unsigned-int8-sym      (string->canonical-symbol "unsigned-int8"))
(define int16-sym              (string->canonical-symbol "int16"))
(define unsigned-int16-sym     (string->canonical-symbol "unsigned-int16"))
(define int32-sym              (string->canonical-symbol "int32"))
(define unsigned-int32-sym     (string->canonical-symbol "unsigned-int32"))
(define int64-sym              (string->canonical-symbol "int64"))
(define unsigned-int64-sym     (string->canonical-symbol "unsigned-int64"))
(define float32-sym            (string->canonical-symbol "float32"))
(define float64-sym            (string->canonical-symbol "float64"))
(define void-sym               (string->canonical-symbol "void"))
(define char-sym               (string->canonical-symbol "char"))
(define signed-char-sym        (string->canonical-symbol "signed-char"))
(define unsigned-char-sym      (string->canonical-symbol "unsigned-char"))
(define ISO-8859-1-sym         (string->canonical-symbol "ISO-8859-1"))
(define UCS-2-sym              (string->canonical-symbol "UCS-2"))
(define UCS-4-sym              (string->canonical-symbol "UCS-4"))
(define wchar_t-sym            (string->canonical-symbol "wchar_t"))
(define size_t-sym             (string->canonical-symbol "size_t"))
(define ssize_t-sym            (string->canonical-symbol "ssize_t"))
(define ptrdiff_t-sym          (string->canonical-symbol "ptrdiff_t"))
(define short-sym              (string->canonical-symbol "short"))
(define unsigned-short-sym     (string->canonical-symbol "unsigned-short"))
(define int-sym                (string->canonical-symbol "int"))
(define unsigned-int-sym       (string->canonical-symbol "unsigned-int"))
(define long-sym               (string->canonical-symbol "long"))
(define unsigned-long-sym      (string->canonical-symbol "unsigned-long"))
(define long-long-sym          (string->canonical-symbol "long-long"))
(define unsigned-long-long-sym (string->canonical-symbol "unsigned-long-long"))
(define float-sym              (string->canonical-symbol "float"))
(define double-sym             (string->canonical-symbol "double"))
(define struct-sym             (string->canonical-symbol "struct"))
(define union-sym              (string->canonical-symbol "union"))
(define type-sym               (string->canonical-symbol "type"))
(define pointer-sym            (string->canonical-symbol "pointer"))
(define nonnull-pointer-sym    (string->canonical-symbol "nonnull-pointer"))
(define function-sym           (string->canonical-symbol "function"))
(define nonnull-function-sym   (string->canonical-symbol "nonnull-function"))
(define bool-sym               (string->canonical-symbol "bool"))
(define char-string-sym        (string->canonical-symbol "char-string"))
(define nonnull-char-string-sym(string->canonical-symbol "nonnull-char-string"))
(define nonnull-char-string-list-sym(string->canonical-symbol "nonnull-char-string-list"))
(define ISO-8859-1-string-sym   (string->canonical-symbol "ISO-8859-1-string"))
(define nonnull-ISO-8859-1-string-sym(string->canonical-symbol "nonnull-ISO-8859-1-string"))
(define nonnull-ISO-8859-1-string-list-sym(string->canonical-symbol "nonnull-ISO-8859-1-string-list"))
(define UTF-8-string-sym       (string->canonical-symbol "UTF-8-string"))
(define nonnull-UTF-8-string-sym(string->canonical-symbol "nonnull-UTF-8-string"))
(define nonnull-UTF-8-string-list-sym(string->canonical-symbol "nonnull-UTF-8-string-list"))
(define UTF-16-string-sym      (string->canonical-symbol "UTF-16-string"))
(define nonnull-UTF-16-string-sym(string->canonical-symbol "nonnull-UTF-16-string"))
(define nonnull-UTF-16-string-list-sym(string->canonical-symbol "nonnull-UTF-16-string-list"))
(define UCS-2-string-sym       (string->canonical-symbol "UCS-2-string"))
(define nonnull-UCS-2-string-sym(string->canonical-symbol "nonnull-UCS-2-string"))
(define nonnull-UCS-2-string-list-sym(string->canonical-symbol "nonnull-UCS-2-string-list"))
(define UCS-4-string-sym       (string->canonical-symbol "UCS-4-string"))
(define nonnull-UCS-4-string-sym(string->canonical-symbol "nonnull-UCS-4-string"))
(define nonnull-UCS-4-string-list-sym(string->canonical-symbol "nonnull-UCS-4-string-list"))
(define wchar_t-string-sym     (string->canonical-symbol "wchar_t-string"))
(define nonnull-wchar_t-string-sym(string->canonical-symbol "nonnull-wchar_t-string"))
(define nonnull-wchar_t-string-list-sym(string->canonical-symbol "nonnull-wchar_t-string-list"))
(define VARIANT-sym            (string->symbol "VARIANT"))
(define scheme-object-sym      (string->canonical-symbol "scheme-object"))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Note: the C id prefix must match the definition in the "gambit.h" header file.

(define c-id-prefix "___") ;; Identifier prefix for C identifiers generated by
                           ;; the C-interface and the C back-end.


;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; C types available to the C-interface.

(define scheme-to-c-notation
  (list
    (cons void-sym        ;; Scheme name
          (vector 'c-type
                  "void"  ;; C type
                  #f      ;; C to Scheme converter
                  #f      ;; Scheme to C converter
                  #f))    ;; cleanup needed on Scheme->C conversion
    (cons int8-sym
          (vector 'c-type
                  (string-append c-id-prefix "S8")
                  "S8_TO_SCMOBJ"
                  "SCMOBJ_TO_S8"
                  #f))
    (cons unsigned-int8-sym
          (vector 'c-type
                  (string-append c-id-prefix "U8")
                  "U8_TO_SCMOBJ"
                  "SCMOBJ_TO_U8"
                  #f))
    (cons int16-sym
          (vector 'c-type
                  (string-append c-id-prefix "S16")
                  "S16_TO_SCMOBJ"
                  "SCMOBJ_TO_S16"
                  #f))
    (cons unsigned-int16-sym
          (vector 'c-type
                  (string-append c-id-prefix "U16")
                  "U16_TO_SCMOBJ"
                  "SCMOBJ_TO_U16"
                  #f))
    (cons int32-sym
          (vector 'c-type
                  (string-append c-id-prefix "S32")
                  "S32_TO_SCMOBJ"
                  "SCMOBJ_TO_S32"
                  #f))
    (cons unsigned-int32-sym
          (vector 'c-type
                  (string-append c-id-prefix "U32")
                  "U32_TO_SCMOBJ"
                  "SCMOBJ_TO_U32"
                  #f))
    (cons int64-sym
          (vector 'c-type
                  (string-append c-id-prefix "S64")
                  "S64_TO_SCMOBJ"
                  "SCMOBJ_TO_S64"
                  #f))
    (cons unsigned-int64-sym
          (vector 'c-type
                  (string-append c-id-prefix "U64")
                  "U64_TO_SCMOBJ"
                  "SCMOBJ_TO_U64"
                  #f))
    (cons float32-sym
          (vector 'c-type
                  (string-append c-id-prefix "F32")
                  "F32_TO_SCMOBJ"
                  "SCMOBJ_TO_F32"
                  #f))
    (cons float64-sym
          (vector 'c-type
                  (string-append c-id-prefix "F64")
                  "F64_TO_SCMOBJ"
                  "SCMOBJ_TO_F64"
                  #f))
    (cons char-sym
          (vector 'c-type
                  "char"
                  "CHAR_TO_SCMOBJ"
                  "SCMOBJ_TO_CHAR"
                  #f))
    (cons signed-char-sym
          (vector 'c-type
                  (string-append c-id-prefix "SCHAR")
                  "SCHAR_TO_SCMOBJ"
                  "SCMOBJ_TO_SCHAR"
                  #f))
    (cons unsigned-char-sym
          (vector 'c-type
                  "unsigned char"
                  "UCHAR_TO_SCMOBJ"
                  "SCMOBJ_TO_UCHAR"
                  #f))
    (cons ISO-8859-1-sym
          (vector 'c-type
                  (string-append c-id-prefix "ISO_8859_1")
                  "ISO_8859_1_TO_SCMOBJ"
                  "SCMOBJ_TO_ISO_8859_1"
                  #f))
    (cons UCS-2-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_2")
                  "UCS_2_TO_SCMOBJ"
                  "SCMOBJ_TO_UCS_2"
                  #f))
    (cons UCS-4-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_4")
                  "UCS_4_TO_SCMOBJ"
                  "SCMOBJ_TO_UCS_4"
                  #f))
    (cons wchar_t-sym
          (vector 'c-type
                  (string-append c-id-prefix "WCHAR")
                  "WCHAR_TO_SCMOBJ"
                  "SCMOBJ_TO_WCHAR"
                  #f))
    (cons size_t-sym
          (vector 'c-type
                  (string-append c-id-prefix "SIZE_T")
                  "SIZE_T_TO_SCMOBJ"
                  "SCMOBJ_TO_SIZE_T"
                  #f))
    (cons ssize_t-sym
          (vector 'c-type
                  (string-append c-id-prefix "SSIZE_T")
                  "SSIZE_T_TO_SCMOBJ"
                  "SCMOBJ_TO_SSIZE_T"
                  #f))
    (cons ptrdiff_t-sym
          (vector 'c-type
                  (string-append c-id-prefix "PTRDIFF_T")
                  "PTRDIFF_T_TO_SCMOBJ"
                  "SCMOBJ_TO_PTRDIFF_T"
                  #f))
    (cons short-sym
          (vector 'c-type
                  "short"
                  "SHORT_TO_SCMOBJ"
                  "SCMOBJ_TO_SHORT"
                  #f))
    (cons unsigned-short-sym
          (vector 'c-type
                  "unsigned short"
                  "USHORT_TO_SCMOBJ"
                  "SCMOBJ_TO_USHORT"
                  #f))
    (cons int-sym
          (vector 'c-type
                  "int"
                  "INT_TO_SCMOBJ"
                  "SCMOBJ_TO_INT"
                  #f))
    (cons unsigned-int-sym
          (vector 'c-type
                  "unsigned int"
                  "UINT_TO_SCMOBJ"
                  "SCMOBJ_TO_UINT"
                  #f))
    (cons long-sym
          (vector 'c-type
                  "long"
                  "LONG_TO_SCMOBJ"
                  "SCMOBJ_TO_LONG"
                  #f))
    (cons unsigned-long-sym
          (vector 'c-type
                  "unsigned long"
                  "ULONG_TO_SCMOBJ"
                  "SCMOBJ_TO_ULONG"
                  #f))
    (cons long-long-sym
          (vector 'c-type
                  (string-append c-id-prefix "LONGLONG")
                  "LONGLONG_TO_SCMOBJ"
                  "SCMOBJ_TO_LONGLONG"
                  #f))
    (cons unsigned-long-long-sym
          (vector 'c-type
                  (string-append c-id-prefix "ULONGLONG")
                  "ULONGLONG_TO_SCMOBJ"
                  "SCMOBJ_TO_ULONGLONG"
                  #f))
    (cons float-sym
          (vector 'c-type
                  "float"
                  "FLOAT_TO_SCMOBJ"
                  "SCMOBJ_TO_FLOAT"
                  #f))
    (cons double-sym
          (vector 'c-type
                  "double"
                  "DOUBLE_TO_SCMOBJ"
                  "SCMOBJ_TO_DOUBLE"
                  #f))
    (cons bool-sym
          (vector 'c-type
                  (string-append c-id-prefix "BOOL")
                  "BOOL_TO_SCMOBJ"
                  "SCMOBJ_TO_BOOL"
                  #f))
    (cons char-string-sym
          (vector 'c-type
                  "char*"
                  "CHARSTRING_TO_SCMOBJ"
                  "SCMOBJ_TO_CHARSTRING"
                  #t))
    (cons nonnull-char-string-sym
          (vector 'c-type
                  "char*"
                  "NONNULLCHARSTRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLCHARSTRING"
                  #t))
    (cons nonnull-char-string-list-sym
          (vector 'c-type
                  "char**"
                  "NONNULLCHARSTRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLCHARSTRINGLIST"
                  #t))
    (cons ISO-8859-1-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "ISO_8859_1STRING")
                  "ISO_8859_1STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_ISO_8859_1STRING"
                  #t))
    (cons nonnull-ISO-8859-1-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "ISO_8859_1STRING")
                  "NONNULLISO_8859_1STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_ISO_8859_1STRING"
                  #t))
    (cons nonnull-ISO-8859-1-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "ISO_8859_1STRING*")
                  "NONNULLISO_8859_1STRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLISO_8859_1STRINGLIST"
                  #t))
    (cons UTF-8-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_8STRING")
                  "UTF_8STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_UTF_8STRING"
                  #t))
    (cons nonnull-UTF-8-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_8STRING")
                  "NONNULLUTF_8STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUTF_8STRING"
                  #t))
    (cons nonnull-UTF-8-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_8STRING*")
                  "NONNULLUTF_8STRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUTF_8STRINGLIST"
                  #t))
    (cons UTF-16-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_16STRING")
                  "UTF_16STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_UTF_16STRING"
                  #t))
    (cons nonnull-UTF-16-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_16STRING")
                  "NONNULLUTF_16STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUTF_16STRING"
                  #t))
    (cons nonnull-UTF-16-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "UTF_16STRING*")
                  "NONNULLUTF_16STRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUTF_16STRINGLIST"
                  #t))
    (cons UCS-2-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_2STRING")
                  "UCS_2STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_UCS_2STRING"
                  #t))
    (cons nonnull-UCS-2-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_2STRING")
                  "NONNULLUCS_2STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUCS_2STRING"
                  #t))
    (cons nonnull-UCS-2-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_2STRING*")
                  "NONNULLUCS_2STRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUCS_2STRINGLIST"
                  #t))
    (cons UCS-4-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_4STRING")
                  "UCS_4STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_UCS_4STRING"
                  #t))
    (cons nonnull-UCS-4-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_4STRING")
                  "NONNULLUCS_4STRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUCS_4STRING"
                  #t))
    (cons nonnull-UCS-4-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "UCS_4STRING*")
                  "NONNULLUCS_4STRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLUCS_4STRINGLIST"
                  #t))
    (cons wchar_t-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "WCHARSTRING")
                  "WCHARSTRING_TO_SCMOBJ"
                  "SCMOBJ_TO_WCHARSTRING"
                  #t))
    (cons nonnull-wchar_t-string-sym
          (vector 'c-type
                  (string-append c-id-prefix "WCHARSTRING")
                  "NONNULLWCHARSTRING_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLWCHARSTRING"
                  #t))
    (cons nonnull-wchar_t-string-list-sym
          (vector 'c-type
                  (string-append c-id-prefix "WCHARSTRING*")
                  "NONNULLWCHARSTRINGLIST_TO_SCMOBJ"
                  "SCMOBJ_TO_NONNULLWCHARSTRINGLIST"
                  #t))
    (cons VARIANT-sym
          (vector 'c-type
                  (string-append c-id-prefix "VARIANT")
                  "VARIANT_TO_SCMOBJ"
                  "SCMOBJ_TO_VARIANT"
                  #t))
    (cons scheme-object-sym
          (vector 'c-type
                  (string-append c-id-prefix "SCMOBJ")
                  "SCMOBJ_TO_SCMOBJ"
                  "SCMOBJ_TO_SCMOBJ"
                  #f))))


;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Gambit system version numbers.

(define (compiler-version) 409004) ;; 100000*major + 1000*minor + revision

(define compiler-version-string-prefix "v")
(define compiler-version-string-suffix "")

(define (compiler-version-string)
  (let* ((version
          (compiler-version))
         (major
          (quotient version 100000))
         (minor
          (modulo (quotient version 1000) 100))
         (build
          (modulo version 1000)))
    (string-append
     compiler-version-string-prefix
     (number->string major)
     "."
     (number->string minor)
     "."
     (number->string build)
     compiler-version-string-suffix)))


;;;============================================================================
