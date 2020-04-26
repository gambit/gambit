;;;============================================================================

;;; File: "char.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(##include "char#.scm")

;;;----------------------------------------------------------------------------

(macro-implement-unicode-tables)

;;;----------------------------------------------------------------------------

(define-fail-check-type char 'char)
(define-fail-check-type char-list 'char-list)
(define-fail-check-type char-vector 'char-vector)

(define-prim (##char? obj))

(define-prim (char? obj)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (macro-force-vars (obj)
    (char? obj)))

(define-prim-nary-bool (##char=? x y)
  #t
  #t
  (##char=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char=? x y)
  #t
  #t
  (##char=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<? x y)
  #t
  #t
  (##char<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<? x y)
  #t
  #t
  (##char<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>? x y)
  #t
  #t
  (##char<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>? x y)
  #t
  #t
  (##char<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-force-vars
  macro-check-char)

(##define-macro (macro-char-ci=? x y)
  `(##char=? (##char-foldcase ,x) (##char-foldcase ,y)))

(##define-macro (macro-char-ci<? x y)
  `(##char<? (##char-foldcase ,x) (##char-foldcase ,y)))

(define-prim-nary-bool (##char-ci=? x y)
  #t
  #t
  (macro-char-ci=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci=? x y)
  #t
  #t
  (macro-char-ci=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<? x y)
  #t
  #t
  (macro-char-ci<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<? x y)
  #t
  #t
  (macro-char-ci<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>? x y)
  #t
  #t
  (macro-char-ci<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>? x y)
  #t
  #t
  (macro-char-ci<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<=? x y)
  #t
  #t
  (##not (macro-char-ci<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<=? x y)
  #t
  #t
  (##not (macro-char-ci<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>=? x y)
  #t
  #t
  (##not (macro-char-ci<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>=? x y)
  #t
  #t
  (##not (macro-char-ci<? x y))
  macro-force-vars
  macro-check-char)

(define-prim (##char-alphabetic? c)
  (macro-char-alphabetic? c))

(define-prim (char-alphabetic? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-alphabetic? c)
      (##char-alphabetic? c))))

(define-prim (##char-numeric? c)
  (macro-char-numeric? c))

(define-prim (char-numeric? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-numeric? c)
      (##char-numeric? c))))

(define-prim (##char-whitespace? c)
  (macro-char-whitespace? c))

(define-prim (char-whitespace? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-whitespace? c)
      (##char-whitespace? c))))

(define-prim (##char-upper-case? c)
  (macro-char-upper-case? c))

(define-prim (char-upper-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upper-case? c)
      (##char-upper-case? c))))

(define-prim (##char-lower-case? c)
  (macro-char-lower-case? c))

(define-prim (char-lower-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-lower-case? c)
      (##char-lower-case? c))))

(define-prim (char->integer c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char->integer c)
      (##char->integer c))))

(define-prim (integer->char n)
  (macro-force-vars (n)
    (macro-check-fixnum-range-incl n 1 0 ##max-char (integer->char n)
      (if (or (##fx< n #xd800)
              (##fx< #xdfff n))
          (##integer->char n)
          (##raise-range-exception 1 integer->char n)))))

(define-prim (##char-upcase c)
  (macro-char-upcase c))

(define-prim (char-upcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upcase c)
      (##char-upcase c))))

(define-prim (##char-downcase c)
  (macro-char-downcase c))

(define-prim (char-downcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-downcase c)
      (##char-downcase c))))

(define-prim (##char-foldcase c)
  (macro-char-foldcase c))

(define-prim (char-foldcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-foldcase c)
      (##char-foldcase c))))

(define-prim (##digit-value c)
  (macro-digit-value c))

(define-prim (digit-value c)
  (macro-force-vars (c)
    (macro-check-char c 1 (digit-value c)
      (##digit-value c))))

;;;============================================================================
