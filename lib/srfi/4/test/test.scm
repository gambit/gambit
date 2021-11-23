;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 4, Homogeneous numeric vector datatypes

(import (srfi 4))
(import (_test))

;;;============================================================================

(define str "foo")
(define int 11)
(define bool #f)

;;;----------------------------------------------------------------------------

;;; s8vectors

(define s8v1 '#s8(-128 127))
(define s8v2 (s8vector -128 -2 00000 00001 127))
(define s8v3 (make-s8vector 2))
(define s8v4 (make-s8vector 2 -128))
(define s8v5 (make-s8vector 2 127))

(test-assert (s8vector? s8v1))
(test-assert (s8vector? '#s8()))
(test-assert (s8vector? '#s8(11)))
(test-assert (s8vector? '#s8(11 22)))
(test-assert (s8vector? '#s8(11 22 33)))
(test-assert (s8vector? '#s8(11 22 33 44)))
(test-assert (s8vector? '#s8(11 22 33 44 55)))

(test-assert (s8vector? s8v2))
(test-assert (s8vector? (s8vector)))
(test-assert (s8vector? (s8vector 11)))
(test-assert (s8vector? (s8vector 11 22)))
(test-assert (s8vector? (s8vector 11 22 33)))
(test-assert (s8vector? (s8vector 11 22 33 44)))
(test-assert (s8vector? (s8vector 11 22 33 44 55)))

(test-assert (s8vector? s8v3))
(test-assert (s8vector? (make-s8vector 0)))
(test-assert (s8vector? (make-s8vector 1)))
(test-assert (s8vector? (make-s8vector 10)))
(test-assert (s8vector? (make-s8vector 100)))
(test-assert (s8vector? (make-s8vector 1000)))
(test-assert (s8vector? (make-s8vector 10000)))

(test-assert (s8vector? s8v4))
(test-assert (s8vector? s8v5))
(test-assert (s8vector? (make-s8vector 0 11)))
(test-assert (s8vector? (make-s8vector 1 22)))
(test-assert (s8vector? (make-s8vector 10 33)))
(test-assert (s8vector? (make-s8vector 100 44)))
(test-assert (s8vector? (make-s8vector 1000 55)))
(test-assert (s8vector? (make-s8vector 10000 66)))

(test-eqv 2 (s8vector-length s8v1))
(test-eqv 0 (s8vector-length '#s8()))
(test-eqv 1 (s8vector-length '#s8(11)))
(test-eqv 2 (s8vector-length '#s8(11 22)))
(test-eqv 3 (s8vector-length '#s8(11 22 33)))
(test-eqv 4 (s8vector-length '#s8(11 22 33 44)))
(test-eqv 5 (s8vector-length '#s8(11 22 33 44 55)))

(test-eqv 5 (s8vector-length s8v2))
(test-eqv 0 (s8vector-length (s8vector)))
(test-eqv 1 (s8vector-length (s8vector 11)))
(test-eqv 2 (s8vector-length (s8vector 11 22)))
(test-eqv 3 (s8vector-length (s8vector 11 22 33)))
(test-eqv 4 (s8vector-length (s8vector 11 22 33 44)))
(test-eqv 5 (s8vector-length (s8vector 11 22 33 44 55)))

(test-eqv 2 (s8vector-length s8v3))
(test-eqv 0 (s8vector-length (make-s8vector 0)))
(test-eqv 1 (s8vector-length (make-s8vector 1)))
(test-eqv 10 (s8vector-length (make-s8vector 10)))
(test-eqv 100 (s8vector-length (make-s8vector 100)))
(test-eqv 1000 (s8vector-length (make-s8vector 1000)))
(test-eqv 10000 (s8vector-length (make-s8vector 10000)))

(test-eqv 2 (s8vector-length s8v4))
(test-eqv 2 (s8vector-length s8v5))
(test-eqv 0 (s8vector-length (make-s8vector 0 11)))
(test-eqv 1 (s8vector-length (make-s8vector 1 22)))
(test-eqv 10 (s8vector-length (make-s8vector 10 33)))
(test-eqv 100 (s8vector-length (make-s8vector 100 44)))
(test-eqv 1000 (s8vector-length (make-s8vector 1000 55)))
(test-eqv 10000 (s8vector-length (make-s8vector 10000 66)))

(test-equal '() (s8vector->list '#s8()))
(test-equal '(-128 -2 00000 00001 127) (s8vector->list s8v2))
(test-equal '(00000 00000) (s8vector->list s8v3))

(test-equal '#s8() (list->s8vector '()))
(test-equal s8v2 (list->s8vector '(-128 -2 00000 00001 127)))
(test-equal s8v3 (list->s8vector '(00000 00000)))

(test-eqv -128 (s8vector-ref s8v1 0))
(test-eqv 127 (s8vector-ref s8v1 1))

(test-eqv -128 (s8vector-ref s8v2 0))
(test-eqv -2 (s8vector-ref s8v2 1))
(test-eqv 00000 (s8vector-ref s8v2 2))
(test-eqv 00001 (s8vector-ref s8v2 3))
(test-eqv 127 (s8vector-ref s8v2 4))

(test-eqv 00000 (s8vector-ref s8v3 0))
(test-eqv 00000 (s8vector-ref s8v3 1))

(test-eqv -128 (s8vector-ref s8v4 0))
(test-eqv -128 (s8vector-ref s8v4 1))

(test-eqv 127 (s8vector-ref s8v5 0))
(test-eqv 127 (s8vector-ref s8v5 1))

(s8vector-set! s8v2 1 99)
(s8vector-set! s8v3 1 99)
(s8vector-set! s8v4 1 99)
(s8vector-set! s8v5 1 99)

(test-eqv -128 (s8vector-ref s8v2 0))
(test-eqv 99 (s8vector-ref s8v2 1))
(test-eqv 00000 (s8vector-ref s8v2 2))
(test-eqv 00001 (s8vector-ref s8v2 3))
(test-eqv 127 (s8vector-ref s8v2 4))

(test-eqv 00000 (s8vector-ref s8v3 0))
(test-eqv 99 (s8vector-ref s8v3 1))

(test-eqv -128 (s8vector-ref s8v4 0))
(test-eqv 99 (s8vector-ref s8v4 1))

(test-eqv 127 (s8vector-ref s8v5 0))
(test-eqv 99 (s8vector-ref s8v5 1))

(test-eqv 5 (s8vector-length s8v2))
(test-eqv 2 (s8vector-length s8v3))
(test-eqv 2 (s8vector-length s8v4))
(test-eqv 2 (s8vector-length s8v5))

(test-error-tail type-exception? (s8vector 11 bool 22))
(test-error-tail type-exception? (s8vector 11 -129 22))
(test-error-tail type-exception? (s8vector 11 128 22))

(test-error-tail type-exception? (make-s8vector bool))
(test-error-tail type-exception? (make-s8vector bool 11))
(test-error-tail type-exception? (make-s8vector 11 bool))
(test-error-tail type-exception? (make-s8vector 11 -129))
(test-error-tail type-exception? (make-s8vector 11 128))
(test-error-tail range-exception? (make-s8vector -1 00000))

(test-error-tail type-exception? (s8vector-length bool))

(test-error-tail type-exception? (s8vector->list bool))

(test-error-tail type-exception? (list->s8vector bool))

(test-error-tail type-exception? (s8vector-ref bool 0))
(test-error-tail type-exception? (s8vector-ref s8v2 bool))
(test-error-tail range-exception? (s8vector-ref s8v2 -1))
(test-error-tail range-exception? (s8vector-ref s8v2 5))

(test-error-tail type-exception? (s8vector-set! bool 00000 11))
(test-error-tail type-exception? (s8vector-set! s8v2 bool 11))
(test-error-tail type-exception? (s8vector-set! s8v2 00000 bool))
(test-error-tail type-exception? (s8vector-set! s8v2 00000 -129))
(test-error-tail type-exception? (s8vector-set! s8v2 00000 128))
(test-error-tail range-exception? (s8vector-set! s8v2 -1 00000))
(test-error-tail range-exception? (s8vector-set! s8v2 5 00000))

(test-error-tail wrong-number-of-arguments-exception? (make-s8vector))
(test-error-tail wrong-number-of-arguments-exception? (make-s8vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s8vector?))
(test-error-tail wrong-number-of-arguments-exception? (s8vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-length))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s8vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (s8vector->list s8v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (s8vector->list s8v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (s8vector->list s8v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s8vector))
(test-error-tail wrong-number-of-arguments-exception? (list->s8vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref s8v1))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref s8v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! s8v5))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! s8v5 0))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! s8v5 0 00000 0))

(test-error-tail range-exception? (make-s8vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; u8vectors

(define u8v1 '#u8(0 255))
(define u8v2 (u8vector 0 255 0 1 255))
(define u8v3 (make-u8vector 2))
(define u8v4 (make-u8vector 2 0))
(define u8v5 (make-u8vector 2 255))

(test-assert (u8vector? u8v1))
(test-assert (u8vector? '#u8()))
(test-assert (u8vector? '#u8(11)))
(test-assert (u8vector? '#u8(11 22)))
(test-assert (u8vector? '#u8(11 22 33)))
(test-assert (u8vector? '#u8(11 22 33 44)))
(test-assert (u8vector? '#u8(11 22 33 44 55)))

(test-assert (u8vector? u8v2))
(test-assert (u8vector? (u8vector)))
(test-assert (u8vector? (u8vector 11)))
(test-assert (u8vector? (u8vector 11 22)))
(test-assert (u8vector? (u8vector 11 22 33)))
(test-assert (u8vector? (u8vector 11 22 33 44)))
(test-assert (u8vector? (u8vector 11 22 33 44 55)))

(test-assert (u8vector? u8v3))
(test-assert (u8vector? (make-u8vector 0)))
(test-assert (u8vector? (make-u8vector 1)))
(test-assert (u8vector? (make-u8vector 10)))
(test-assert (u8vector? (make-u8vector 100)))
(test-assert (u8vector? (make-u8vector 1000)))
(test-assert (u8vector? (make-u8vector 10000)))

(test-assert (u8vector? u8v4))
(test-assert (u8vector? u8v5))
(test-assert (u8vector? (make-u8vector 0 11)))
(test-assert (u8vector? (make-u8vector 1 22)))
(test-assert (u8vector? (make-u8vector 10 33)))
(test-assert (u8vector? (make-u8vector 100 44)))
(test-assert (u8vector? (make-u8vector 1000 55)))
(test-assert (u8vector? (make-u8vector 10000 66)))

(test-eqv 2 (u8vector-length u8v1))
(test-eqv 0 (u8vector-length '#u8()))
(test-eqv 1 (u8vector-length '#u8(11)))
(test-eqv 2 (u8vector-length '#u8(11 22)))
(test-eqv 3 (u8vector-length '#u8(11 22 33)))
(test-eqv 4 (u8vector-length '#u8(11 22 33 44)))
(test-eqv 5 (u8vector-length '#u8(11 22 33 44 55)))

(test-eqv 5 (u8vector-length u8v2))
(test-eqv 0 (u8vector-length (u8vector)))
(test-eqv 1 (u8vector-length (u8vector 11)))
(test-eqv 2 (u8vector-length (u8vector 11 22)))
(test-eqv 3 (u8vector-length (u8vector 11 22 33)))
(test-eqv 4 (u8vector-length (u8vector 11 22 33 44)))
(test-eqv 5 (u8vector-length (u8vector 11 22 33 44 55)))

(test-eqv 2 (u8vector-length u8v3))
(test-eqv 0 (u8vector-length (make-u8vector 0)))
(test-eqv 1 (u8vector-length (make-u8vector 1)))
(test-eqv 10 (u8vector-length (make-u8vector 10)))
(test-eqv 100 (u8vector-length (make-u8vector 100)))
(test-eqv 1000 (u8vector-length (make-u8vector 1000)))
(test-eqv 10000 (u8vector-length (make-u8vector 10000)))

(test-eqv 2 (u8vector-length u8v4))
(test-eqv 2 (u8vector-length u8v5))
(test-eqv 0 (u8vector-length (make-u8vector 0 11)))
(test-eqv 1 (u8vector-length (make-u8vector 1 22)))
(test-eqv 10 (u8vector-length (make-u8vector 10 33)))
(test-eqv 100 (u8vector-length (make-u8vector 100 44)))
(test-eqv 1000 (u8vector-length (make-u8vector 1000 55)))
(test-eqv 10000 (u8vector-length (make-u8vector 10000 66)))

(test-equal '() (u8vector->list '#u8()))
(test-equal '(0 255 0 1 255) (u8vector->list u8v2))
(test-equal '(0 0) (u8vector->list u8v3))

(test-equal '#u8() (list->u8vector '()))
(test-equal u8v2 (list->u8vector '(0 255 0 1 255)))
(test-equal u8v3 (list->u8vector '(0 0)))

(test-eqv 0 (u8vector-ref u8v1 0))
(test-eqv 255 (u8vector-ref u8v1 1))

(test-eqv 0 (u8vector-ref u8v2 0))
(test-eqv 255 (u8vector-ref u8v2 1))
(test-eqv 0 (u8vector-ref u8v2 2))
(test-eqv 1 (u8vector-ref u8v2 3))
(test-eqv 255 (u8vector-ref u8v2 4))

(test-eqv 0 (u8vector-ref u8v3 0))
(test-eqv 0 (u8vector-ref u8v3 1))

(test-eqv 0 (u8vector-ref u8v4 0))
(test-eqv 0 (u8vector-ref u8v4 1))

(test-eqv 255 (u8vector-ref u8v5 0))
(test-eqv 255 (u8vector-ref u8v5 1))

(u8vector-set! u8v2 1 99)
(u8vector-set! u8v3 1 99)
(u8vector-set! u8v4 1 99)
(u8vector-set! u8v5 1 99)

(test-eqv 0 (u8vector-ref u8v2 0))
(test-eqv 99 (u8vector-ref u8v2 1))
(test-eqv 0 (u8vector-ref u8v2 2))
(test-eqv 1 (u8vector-ref u8v2 3))
(test-eqv 255 (u8vector-ref u8v2 4))

(test-eqv 0 (u8vector-ref u8v3 0))
(test-eqv 99 (u8vector-ref u8v3 1))

(test-eqv 0 (u8vector-ref u8v4 0))
(test-eqv 99 (u8vector-ref u8v4 1))

(test-eqv 255 (u8vector-ref u8v5 0))
(test-eqv 99 (u8vector-ref u8v5 1))

(test-eqv 5 (u8vector-length u8v2))
(test-eqv 2 (u8vector-length u8v3))
(test-eqv 2 (u8vector-length u8v4))
(test-eqv 2 (u8vector-length u8v5))

(test-error-tail type-exception? (u8vector 11 bool 22))
(test-error-tail type-exception? (u8vector 11 -1 22))
(test-error-tail type-exception? (u8vector 11 256 22))

(test-error-tail type-exception? (make-u8vector bool))
(test-error-tail type-exception? (make-u8vector bool 11))
(test-error-tail type-exception? (make-u8vector 11 bool))
(test-error-tail type-exception? (make-u8vector 11 -1))
(test-error-tail type-exception? (make-u8vector 11 256))
(test-error-tail range-exception? (make-u8vector -1 0))

(test-error-tail type-exception? (u8vector-length bool))

(test-error-tail type-exception? (u8vector->list bool))

(test-error-tail type-exception? (list->u8vector bool))

(test-error-tail type-exception? (u8vector-ref bool 0))
(test-error-tail type-exception? (u8vector-ref u8v2 bool))
(test-error-tail range-exception? (u8vector-ref u8v2 -1))
(test-error-tail range-exception? (u8vector-ref u8v2 5))

(test-error-tail type-exception? (u8vector-set! bool 0 11))
(test-error-tail type-exception? (u8vector-set! u8v2 bool 11))
(test-error-tail type-exception? (u8vector-set! u8v2 0 bool))
(test-error-tail type-exception? (u8vector-set! u8v2 0 -1))
(test-error-tail type-exception? (u8vector-set! u8v2 0 256))
(test-error-tail range-exception? (u8vector-set! u8v2 -1 0))
(test-error-tail range-exception? (u8vector-set! u8v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u8vector))
(test-error-tail wrong-number-of-arguments-exception? (make-u8vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u8vector?))
(test-error-tail wrong-number-of-arguments-exception? (u8vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-length))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u8vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (u8vector->list u8v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (u8vector->list u8v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (u8vector->list u8v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u8vector))
(test-error-tail wrong-number-of-arguments-exception? (list->u8vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref u8v1))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref u8v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! u8v5))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! u8v5 0))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! u8v5 0 0 0))

(test-error-tail range-exception? (make-u8vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; s16vectors

(define s16v1 '#s16(-32768 32767))
(define s16v2 (s16vector -32768 -2 0 1 32767))
(define s16v3 (make-s16vector 2))
(define s16v4 (make-s16vector 2 -32768))
(define s16v5 (make-s16vector 2 32767))

(test-assert (s16vector? s16v1))
(test-assert (s16vector? '#s16()))
(test-assert (s16vector? '#s16(11)))
(test-assert (s16vector? '#s16(11 22)))
(test-assert (s16vector? '#s16(11 22 33)))
(test-assert (s16vector? '#s16(11 22 33 44)))
(test-assert (s16vector? '#s16(11 22 33 44 55)))

(test-assert (s16vector? s16v2))
(test-assert (s16vector? (s16vector)))
(test-assert (s16vector? (s16vector 11)))
(test-assert (s16vector? (s16vector 11 22)))
(test-assert (s16vector? (s16vector 11 22 33)))
(test-assert (s16vector? (s16vector 11 22 33 44)))
(test-assert (s16vector? (s16vector 11 22 33 44 55)))

(test-assert (s16vector? s16v3))
(test-assert (s16vector? (make-s16vector 0)))
(test-assert (s16vector? (make-s16vector 1)))
(test-assert (s16vector? (make-s16vector 10)))
(test-assert (s16vector? (make-s16vector 100)))
(test-assert (s16vector? (make-s16vector 1000)))
(test-assert (s16vector? (make-s16vector 10000)))

(test-assert (s16vector? s16v4))
(test-assert (s16vector? s16v5))
(test-assert (s16vector? (make-s16vector 0 11)))
(test-assert (s16vector? (make-s16vector 1 22)))
(test-assert (s16vector? (make-s16vector 10 33)))
(test-assert (s16vector? (make-s16vector 100 44)))
(test-assert (s16vector? (make-s16vector 1000 55)))
(test-assert (s16vector? (make-s16vector 10000 66)))

(test-eqv 2 (s16vector-length s16v1))
(test-eqv 0 (s16vector-length '#s16()))
(test-eqv 1 (s16vector-length '#s16(11)))
(test-eqv 2 (s16vector-length '#s16(11 22)))
(test-eqv 3 (s16vector-length '#s16(11 22 33)))
(test-eqv 4 (s16vector-length '#s16(11 22 33 44)))
(test-eqv 5 (s16vector-length '#s16(11 22 33 44 55)))

(test-eqv 5 (s16vector-length s16v2))
(test-eqv 0 (s16vector-length (s16vector)))
(test-eqv 1 (s16vector-length (s16vector 11)))
(test-eqv 2 (s16vector-length (s16vector 11 22)))
(test-eqv 3 (s16vector-length (s16vector 11 22 33)))
(test-eqv 4 (s16vector-length (s16vector 11 22 33 44)))
(test-eqv 5 (s16vector-length (s16vector 11 22 33 44 55)))

(test-eqv 2 (s16vector-length s16v3))
(test-eqv 0 (s16vector-length (make-s16vector 0)))
(test-eqv 1 (s16vector-length (make-s16vector 1)))
(test-eqv 10 (s16vector-length (make-s16vector 10)))
(test-eqv 100 (s16vector-length (make-s16vector 100)))
(test-eqv 1000 (s16vector-length (make-s16vector 1000)))
(test-eqv 10000 (s16vector-length (make-s16vector 10000)))

(test-eqv 2 (s16vector-length s16v4))
(test-eqv 2 (s16vector-length s16v5))
(test-eqv 0 (s16vector-length (make-s16vector 0 11)))
(test-eqv 1 (s16vector-length (make-s16vector 1 22)))
(test-eqv 10 (s16vector-length (make-s16vector 10 33)))
(test-eqv 100 (s16vector-length (make-s16vector 100 44)))
(test-eqv 1000 (s16vector-length (make-s16vector 1000 55)))
(test-eqv 10000 (s16vector-length (make-s16vector 10000 66)))

(test-equal '() (s16vector->list '#s16()))
(test-equal '(-32768 -2 0 1 32767) (s16vector->list s16v2))
(test-equal '(0 0) (s16vector->list s16v3))

(test-equal '#s16() (list->s16vector '()))
(test-equal s16v2 (list->s16vector '(-32768 -2 0 1 32767)))
(test-equal s16v3 (list->s16vector '(0 0)))

(test-eqv -32768 (s16vector-ref s16v1 0))
(test-eqv 32767 (s16vector-ref s16v1 1))

(test-eqv -32768 (s16vector-ref s16v2 0))
(test-eqv -2 (s16vector-ref s16v2 1))
(test-eqv 0 (s16vector-ref s16v2 2))
(test-eqv 1 (s16vector-ref s16v2 3))
(test-eqv 32767 (s16vector-ref s16v2 4))

(test-eqv 0 (s16vector-ref s16v3 0))
(test-eqv 0 (s16vector-ref s16v3 1))

(test-eqv -32768 (s16vector-ref s16v4 0))
(test-eqv -32768 (s16vector-ref s16v4 1))

(test-eqv 32767 (s16vector-ref s16v5 0))
(test-eqv 32767 (s16vector-ref s16v5 1))

(s16vector-set! s16v2 1 99)
(s16vector-set! s16v3 1 99)
(s16vector-set! s16v4 1 99)
(s16vector-set! s16v5 1 99)

(test-eqv -32768 (s16vector-ref s16v2 0))
(test-eqv 99 (s16vector-ref s16v2 1))
(test-eqv 0 (s16vector-ref s16v2 2))
(test-eqv 1 (s16vector-ref s16v2 3))
(test-eqv 32767 (s16vector-ref s16v2 4))

(test-eqv 0 (s16vector-ref s16v3 0))
(test-eqv 99 (s16vector-ref s16v3 1))

(test-eqv -32768 (s16vector-ref s16v4 0))
(test-eqv 99 (s16vector-ref s16v4 1))

(test-eqv 32767 (s16vector-ref s16v5 0))
(test-eqv 99 (s16vector-ref s16v5 1))

(test-eqv 5 (s16vector-length s16v2))
(test-eqv 2 (s16vector-length s16v3))
(test-eqv 2 (s16vector-length s16v4))
(test-eqv 2 (s16vector-length s16v5))

(test-error-tail type-exception? (s16vector 11 bool 22))
(test-error-tail type-exception? (s16vector 11 -32769 22))
(test-error-tail type-exception? (s16vector 11 32768 22))

(test-error-tail type-exception? (make-s16vector bool))
(test-error-tail type-exception? (make-s16vector bool 11))
(test-error-tail type-exception? (make-s16vector 11 bool))
(test-error-tail type-exception? (make-s16vector 11 -32769))
(test-error-tail type-exception? (make-s16vector 11 32768))
(test-error-tail range-exception? (make-s16vector -1 0))

(test-error-tail type-exception? (s16vector-length bool))

(test-error-tail type-exception? (s16vector->list bool))

(test-error-tail type-exception? (list->s16vector bool))

(test-error-tail type-exception? (s16vector-ref bool 0))
(test-error-tail type-exception? (s16vector-ref s16v2 bool))
(test-error-tail range-exception? (s16vector-ref s16v2 -1))
(test-error-tail range-exception? (s16vector-ref s16v2 5))

(test-error-tail type-exception? (s16vector-set! bool 0 11))
(test-error-tail type-exception? (s16vector-set! s16v2 bool 11))
(test-error-tail type-exception? (s16vector-set! s16v2 0 bool))
(test-error-tail type-exception? (s16vector-set! s16v2 0 -32769))
(test-error-tail type-exception? (s16vector-set! s16v2 0 32768))
(test-error-tail range-exception? (s16vector-set! s16v2 -1 0))
(test-error-tail range-exception? (s16vector-set! s16v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s16vector))
(test-error-tail wrong-number-of-arguments-exception? (make-s16vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s16vector?))
(test-error-tail wrong-number-of-arguments-exception? (s16vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-length))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s16vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (s16vector->list s16v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (s16vector->list s16v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (s16vector->list s16v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s16vector))
(test-error-tail wrong-number-of-arguments-exception? (list->s16vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref s16v1))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref s16v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-set! s16v5))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-set! s16v5 0))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-set! s16v5 0 0 0))

(test-error-tail range-exception? (make-s16vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; u16vectors

(define u16v1 '#u16(0 65535))
(define u16v2 (u16vector 0 65535 0 1 65535))
(define u16v3 (make-u16vector 2))
(define u16v4 (make-u16vector 2 0))
(define u16v5 (make-u16vector 2 65535))

(test-assert (u16vector? u16v1))
(test-assert (u16vector? '#u16()))
(test-assert (u16vector? '#u16(11)))
(test-assert (u16vector? '#u16(11 22)))
(test-assert (u16vector? '#u16(11 22 33)))
(test-assert (u16vector? '#u16(11 22 33 44)))
(test-assert (u16vector? '#u16(11 22 33 44 55)))

(test-assert (u16vector? u16v2))
(test-assert (u16vector? (u16vector)))
(test-assert (u16vector? (u16vector 11)))
(test-assert (u16vector? (u16vector 11 22)))
(test-assert (u16vector? (u16vector 11 22 33)))
(test-assert (u16vector? (u16vector 11 22 33 44)))
(test-assert (u16vector? (u16vector 11 22 33 44 55)))

(test-assert (u16vector? u16v3))
(test-assert (u16vector? (make-u16vector 0)))
(test-assert (u16vector? (make-u16vector 1)))
(test-assert (u16vector? (make-u16vector 10)))
(test-assert (u16vector? (make-u16vector 100)))
(test-assert (u16vector? (make-u16vector 1000)))
(test-assert (u16vector? (make-u16vector 10000)))

(test-assert (u16vector? u16v4))
(test-assert (u16vector? u16v5))
(test-assert (u16vector? (make-u16vector 0 11)))
(test-assert (u16vector? (make-u16vector 1 22)))
(test-assert (u16vector? (make-u16vector 10 33)))
(test-assert (u16vector? (make-u16vector 100 44)))
(test-assert (u16vector? (make-u16vector 1000 55)))
(test-assert (u16vector? (make-u16vector 10000 66)))

(test-eqv 2 (u16vector-length u16v1))
(test-eqv 0 (u16vector-length '#u16()))
(test-eqv 1 (u16vector-length '#u16(11)))
(test-eqv 2 (u16vector-length '#u16(11 22)))
(test-eqv 3 (u16vector-length '#u16(11 22 33)))
(test-eqv 4 (u16vector-length '#u16(11 22 33 44)))
(test-eqv 5 (u16vector-length '#u16(11 22 33 44 55)))

(test-eqv 5 (u16vector-length u16v2))
(test-eqv 0 (u16vector-length (u16vector)))
(test-eqv 1 (u16vector-length (u16vector 11)))
(test-eqv 2 (u16vector-length (u16vector 11 22)))
(test-eqv 3 (u16vector-length (u16vector 11 22 33)))
(test-eqv 4 (u16vector-length (u16vector 11 22 33 44)))
(test-eqv 5 (u16vector-length (u16vector 11 22 33 44 55)))

(test-eqv 2 (u16vector-length u16v3))
(test-eqv 0 (u16vector-length (make-u16vector 0)))
(test-eqv 1 (u16vector-length (make-u16vector 1)))
(test-eqv 10 (u16vector-length (make-u16vector 10)))
(test-eqv 100 (u16vector-length (make-u16vector 100)))
(test-eqv 1000 (u16vector-length (make-u16vector 1000)))
(test-eqv 10000 (u16vector-length (make-u16vector 10000)))

(test-eqv 2 (u16vector-length u16v4))
(test-eqv 2 (u16vector-length u16v5))
(test-eqv 0 (u16vector-length (make-u16vector 0 11)))
(test-eqv 1 (u16vector-length (make-u16vector 1 22)))
(test-eqv 10 (u16vector-length (make-u16vector 10 33)))
(test-eqv 100 (u16vector-length (make-u16vector 100 44)))
(test-eqv 1000 (u16vector-length (make-u16vector 1000 55)))
(test-eqv 10000 (u16vector-length (make-u16vector 10000 66)))

(test-equal '() (u16vector->list '#u16()))
(test-equal '(0 65535 0 1 65535) (u16vector->list u16v2))
(test-equal '(0 0) (u16vector->list u16v3))

(test-equal '#u16() (list->u16vector '()))
(test-equal u16v2 (list->u16vector '(0 65535 0 1 65535)))
(test-equal u16v3 (list->u16vector '(0 0)))

(test-eqv 0 (u16vector-ref u16v1 0))
(test-eqv 65535 (u16vector-ref u16v1 1))

(test-eqv 0 (u16vector-ref u16v2 0))
(test-eqv 65535 (u16vector-ref u16v2 1))
(test-eqv 0 (u16vector-ref u16v2 2))
(test-eqv 1 (u16vector-ref u16v2 3))
(test-eqv 65535 (u16vector-ref u16v2 4))

(test-eqv 0 (u16vector-ref u16v3 0))
(test-eqv 0 (u16vector-ref u16v3 1))

(test-eqv 0 (u16vector-ref u16v4 0))
(test-eqv 0 (u16vector-ref u16v4 1))

(test-eqv 65535 (u16vector-ref u16v5 0))
(test-eqv 65535 (u16vector-ref u16v5 1))

(u16vector-set! u16v2 1 99)
(u16vector-set! u16v3 1 99)
(u16vector-set! u16v4 1 99)
(u16vector-set! u16v5 1 99)

(test-eqv 0 (u16vector-ref u16v2 0))
(test-eqv 99 (u16vector-ref u16v2 1))
(test-eqv 0 (u16vector-ref u16v2 2))
(test-eqv 1 (u16vector-ref u16v2 3))
(test-eqv 65535 (u16vector-ref u16v2 4))

(test-eqv 0 (u16vector-ref u16v3 0))
(test-eqv 99 (u16vector-ref u16v3 1))

(test-eqv 0 (u16vector-ref u16v4 0))
(test-eqv 99 (u16vector-ref u16v4 1))

(test-eqv 65535 (u16vector-ref u16v5 0))
(test-eqv 99 (u16vector-ref u16v5 1))

(test-eqv 5 (u16vector-length u16v2))
(test-eqv 2 (u16vector-length u16v3))
(test-eqv 2 (u16vector-length u16v4))
(test-eqv 2 (u16vector-length u16v5))

(test-error-tail type-exception? (u16vector 11 bool 22))
(test-error-tail type-exception? (u16vector 11 -1 22))
(test-error-tail type-exception? (u16vector 11 65536 22))

(test-error-tail type-exception? (make-u16vector bool))
(test-error-tail type-exception? (make-u16vector bool 11))
(test-error-tail type-exception? (make-u16vector 11 bool))
(test-error-tail type-exception? (make-u16vector 11 -1))
(test-error-tail type-exception? (make-u16vector 11 65536))
(test-error-tail range-exception? (make-u16vector -1 0))

(test-error-tail type-exception? (u16vector-length bool))

(test-error-tail type-exception? (u16vector->list bool))

(test-error-tail type-exception? (list->u16vector bool))

(test-error-tail type-exception? (u16vector-ref bool 0))
(test-error-tail type-exception? (u16vector-ref u16v2 bool))
(test-error-tail range-exception? (u16vector-ref u16v2 -1))
(test-error-tail range-exception? (u16vector-ref u16v2 5))

(test-error-tail type-exception? (u16vector-set! bool 0 11))
(test-error-tail type-exception? (u16vector-set! u16v2 bool 11))
(test-error-tail type-exception? (u16vector-set! u16v2 0 bool))
(test-error-tail type-exception? (u16vector-set! u16v2 0 -1))
(test-error-tail type-exception? (u16vector-set! u16v2 0 65536))
(test-error-tail range-exception? (u16vector-set! u16v2 -1 0))
(test-error-tail range-exception? (u16vector-set! u16v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u16vector))
(test-error-tail wrong-number-of-arguments-exception? (make-u16vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u16vector?))
(test-error-tail wrong-number-of-arguments-exception? (u16vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u16vector-length))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u16vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (u16vector->list u16v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (u16vector->list u16v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (u16vector->list u16v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u16vector))
(test-error-tail wrong-number-of-arguments-exception? (list->u16vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u16vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-ref u16v1))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-ref u16v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u16vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-set! u16v5))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-set! u16v5 0))
(test-error-tail wrong-number-of-arguments-exception? (u16vector-set! u16v5 0 0 0))

(test-error-tail range-exception? (make-u16vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; s32vectors

(define s32v1 '#s32(-2147483648 2147483647))
(define s32v2 (s32vector -2147483648 -2 0 1 2147483647))
(define s32v3 (make-s32vector 2))
(define s32v4 (make-s32vector 2 -2147483648))
(define s32v5 (make-s32vector 2 2147483647))

(test-assert (s32vector? s32v1))
(test-assert (s32vector? '#s32()))
(test-assert (s32vector? '#s32(11)))
(test-assert (s32vector? '#s32(11 22)))
(test-assert (s32vector? '#s32(11 22 33)))
(test-assert (s32vector? '#s32(11 22 33 44)))
(test-assert (s32vector? '#s32(11 22 33 44 55)))

(test-assert (s32vector? s32v2))
(test-assert (s32vector? (s32vector)))
(test-assert (s32vector? (s32vector 11)))
(test-assert (s32vector? (s32vector 11 22)))
(test-assert (s32vector? (s32vector 11 22 33)))
(test-assert (s32vector? (s32vector 11 22 33 44)))
(test-assert (s32vector? (s32vector 11 22 33 44 55)))

(test-assert (s32vector? s32v3))
(test-assert (s32vector? (make-s32vector 0)))
(test-assert (s32vector? (make-s32vector 1)))
(test-assert (s32vector? (make-s32vector 10)))
(test-assert (s32vector? (make-s32vector 100)))
(test-assert (s32vector? (make-s32vector 1000)))
(test-assert (s32vector? (make-s32vector 10000)))

(test-assert (s32vector? s32v4))
(test-assert (s32vector? s32v5))
(test-assert (s32vector? (make-s32vector 0 11)))
(test-assert (s32vector? (make-s32vector 1 22)))
(test-assert (s32vector? (make-s32vector 10 33)))
(test-assert (s32vector? (make-s32vector 100 44)))
(test-assert (s32vector? (make-s32vector 1000 55)))
(test-assert (s32vector? (make-s32vector 10000 66)))

(test-eqv 2 (s32vector-length s32v1))
(test-eqv 0 (s32vector-length '#s32()))
(test-eqv 1 (s32vector-length '#s32(11)))
(test-eqv 2 (s32vector-length '#s32(11 22)))
(test-eqv 3 (s32vector-length '#s32(11 22 33)))
(test-eqv 4 (s32vector-length '#s32(11 22 33 44)))
(test-eqv 5 (s32vector-length '#s32(11 22 33 44 55)))

(test-eqv 5 (s32vector-length s32v2))
(test-eqv 0 (s32vector-length (s32vector)))
(test-eqv 1 (s32vector-length (s32vector 11)))
(test-eqv 2 (s32vector-length (s32vector 11 22)))
(test-eqv 3 (s32vector-length (s32vector 11 22 33)))
(test-eqv 4 (s32vector-length (s32vector 11 22 33 44)))
(test-eqv 5 (s32vector-length (s32vector 11 22 33 44 55)))

(test-eqv 2 (s32vector-length s32v3))
(test-eqv 0 (s32vector-length (make-s32vector 0)))
(test-eqv 1 (s32vector-length (make-s32vector 1)))
(test-eqv 10 (s32vector-length (make-s32vector 10)))
(test-eqv 100 (s32vector-length (make-s32vector 100)))
(test-eqv 1000 (s32vector-length (make-s32vector 1000)))
(test-eqv 10000 (s32vector-length (make-s32vector 10000)))

(test-eqv 2 (s32vector-length s32v4))
(test-eqv 2 (s32vector-length s32v5))
(test-eqv 0 (s32vector-length (make-s32vector 0 11)))
(test-eqv 1 (s32vector-length (make-s32vector 1 22)))
(test-eqv 10 (s32vector-length (make-s32vector 10 33)))
(test-eqv 100 (s32vector-length (make-s32vector 100 44)))
(test-eqv 1000 (s32vector-length (make-s32vector 1000 55)))
(test-eqv 10000 (s32vector-length (make-s32vector 10000 66)))

(test-equal '() (s32vector->list '#s32()))
(test-equal '(-2147483648 -2 0 1 2147483647) (s32vector->list s32v2))
(test-equal '(0 0) (s32vector->list s32v3))

(test-equal '#s32() (list->s32vector '()))
(test-equal s32v2 (list->s32vector '(-2147483648 -2 0 1 2147483647)))
(test-equal s32v3 (list->s32vector '(0 0)))

(test-eqv -2147483648 (s32vector-ref s32v1 0))
(test-eqv 2147483647 (s32vector-ref s32v1 1))

(test-eqv -2147483648 (s32vector-ref s32v2 0))
(test-eqv -2 (s32vector-ref s32v2 1))
(test-eqv 0 (s32vector-ref s32v2 2))
(test-eqv 1 (s32vector-ref s32v2 3))
(test-eqv 2147483647 (s32vector-ref s32v2 4))

(test-eqv 0 (s32vector-ref s32v3 0))
(test-eqv 0 (s32vector-ref s32v3 1))

(test-eqv -2147483648 (s32vector-ref s32v4 0))
(test-eqv -2147483648 (s32vector-ref s32v4 1))

(test-eqv 2147483647 (s32vector-ref s32v5 0))
(test-eqv 2147483647 (s32vector-ref s32v5 1))

(s32vector-set! s32v2 1 99)
(s32vector-set! s32v3 1 99)
(s32vector-set! s32v4 1 99)
(s32vector-set! s32v5 1 99)

(test-eqv -2147483648 (s32vector-ref s32v2 0))
(test-eqv 99 (s32vector-ref s32v2 1))
(test-eqv 0 (s32vector-ref s32v2 2))
(test-eqv 1 (s32vector-ref s32v2 3))
(test-eqv 2147483647 (s32vector-ref s32v2 4))

(test-eqv 0 (s32vector-ref s32v3 0))
(test-eqv 99 (s32vector-ref s32v3 1))

(test-eqv -2147483648 (s32vector-ref s32v4 0))
(test-eqv 99 (s32vector-ref s32v4 1))

(test-eqv 2147483647 (s32vector-ref s32v5 0))
(test-eqv 99 (s32vector-ref s32v5 1))

(test-eqv 5 (s32vector-length s32v2))
(test-eqv 2 (s32vector-length s32v3))
(test-eqv 2 (s32vector-length s32v4))
(test-eqv 2 (s32vector-length s32v5))

(test-error-tail type-exception? (s32vector 11 bool 22))
(test-error-tail type-exception? (s32vector 11 -2147483649 22))
(test-error-tail type-exception? (s32vector 11 2147483648 22))

(test-error-tail type-exception? (make-s32vector bool))
(test-error-tail type-exception? (make-s32vector bool 11))
(test-error-tail type-exception? (make-s32vector 11 bool))
(test-error-tail type-exception? (make-s32vector 11 -2147483649))
(test-error-tail type-exception? (make-s32vector 11 2147483648))
(test-error-tail range-exception? (make-s32vector -1 0))

(test-error-tail type-exception? (s32vector-length bool))

(test-error-tail type-exception? (s32vector->list bool))

(test-error-tail type-exception? (list->s32vector bool))

(test-error-tail type-exception? (s32vector-ref bool 0))
(test-error-tail type-exception? (s32vector-ref s32v2 bool))
(test-error-tail range-exception? (s32vector-ref s32v2 -1))
(test-error-tail range-exception? (s32vector-ref s32v2 5))

(test-error-tail type-exception? (s32vector-set! bool 0 11))
(test-error-tail type-exception? (s32vector-set! s32v2 bool 11))
(test-error-tail type-exception? (s32vector-set! s32v2 0 bool))
(test-error-tail type-exception? (s32vector-set! s32v2 0 -2147483649))
(test-error-tail type-exception? (s32vector-set! s32v2 0 2147483648))
(test-error-tail range-exception? (s32vector-set! s32v2 -1 0))
(test-error-tail range-exception? (s32vector-set! s32v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s32vector))
(test-error-tail wrong-number-of-arguments-exception? (make-s32vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s32vector?))
(test-error-tail wrong-number-of-arguments-exception? (s32vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s32vector-length))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s32vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (s32vector->list s32v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (s32vector->list s32v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (s32vector->list s32v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s32vector))
(test-error-tail wrong-number-of-arguments-exception? (list->s32vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s32vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-ref s32v1))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-ref s32v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s32vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-set! s32v5))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-set! s32v5 0))
(test-error-tail wrong-number-of-arguments-exception? (s32vector-set! s32v5 0 0 0))

(test-error-tail range-exception? (make-s32vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; u32vectors

(define u32v1 '#u32(0 4294967295))
(define u32v2 (u32vector 0 4294967295 0 1 4294967295))
(define u32v3 (make-u32vector 2))
(define u32v4 (make-u32vector 2 0))
(define u32v5 (make-u32vector 2 4294967295))

(test-assert (u32vector? u32v1))
(test-assert (u32vector? '#u32()))
(test-assert (u32vector? '#u32(11)))
(test-assert (u32vector? '#u32(11 22)))
(test-assert (u32vector? '#u32(11 22 33)))
(test-assert (u32vector? '#u32(11 22 33 44)))
(test-assert (u32vector? '#u32(11 22 33 44 55)))

(test-assert (u32vector? u32v2))
(test-assert (u32vector? (u32vector)))
(test-assert (u32vector? (u32vector 11)))
(test-assert (u32vector? (u32vector 11 22)))
(test-assert (u32vector? (u32vector 11 22 33)))
(test-assert (u32vector? (u32vector 11 22 33 44)))
(test-assert (u32vector? (u32vector 11 22 33 44 55)))

(test-assert (u32vector? u32v3))
(test-assert (u32vector? (make-u32vector 0)))
(test-assert (u32vector? (make-u32vector 1)))
(test-assert (u32vector? (make-u32vector 10)))
(test-assert (u32vector? (make-u32vector 100)))
(test-assert (u32vector? (make-u32vector 1000)))
(test-assert (u32vector? (make-u32vector 10000)))

(test-assert (u32vector? u32v4))
(test-assert (u32vector? u32v5))
(test-assert (u32vector? (make-u32vector 0 11)))
(test-assert (u32vector? (make-u32vector 1 22)))
(test-assert (u32vector? (make-u32vector 10 33)))
(test-assert (u32vector? (make-u32vector 100 44)))
(test-assert (u32vector? (make-u32vector 1000 55)))
(test-assert (u32vector? (make-u32vector 10000 66)))

(test-eqv 2 (u32vector-length u32v1))
(test-eqv 0 (u32vector-length '#u32()))
(test-eqv 1 (u32vector-length '#u32(11)))
(test-eqv 2 (u32vector-length '#u32(11 22)))
(test-eqv 3 (u32vector-length '#u32(11 22 33)))
(test-eqv 4 (u32vector-length '#u32(11 22 33 44)))
(test-eqv 5 (u32vector-length '#u32(11 22 33 44 55)))

(test-eqv 5 (u32vector-length u32v2))
(test-eqv 0 (u32vector-length (u32vector)))
(test-eqv 1 (u32vector-length (u32vector 11)))
(test-eqv 2 (u32vector-length (u32vector 11 22)))
(test-eqv 3 (u32vector-length (u32vector 11 22 33)))
(test-eqv 4 (u32vector-length (u32vector 11 22 33 44)))
(test-eqv 5 (u32vector-length (u32vector 11 22 33 44 55)))

(test-eqv 2 (u32vector-length u32v3))
(test-eqv 0 (u32vector-length (make-u32vector 0)))
(test-eqv 1 (u32vector-length (make-u32vector 1)))
(test-eqv 10 (u32vector-length (make-u32vector 10)))
(test-eqv 100 (u32vector-length (make-u32vector 100)))
(test-eqv 1000 (u32vector-length (make-u32vector 1000)))
(test-eqv 10000 (u32vector-length (make-u32vector 10000)))

(test-eqv 2 (u32vector-length u32v4))
(test-eqv 2 (u32vector-length u32v5))
(test-eqv 0 (u32vector-length (make-u32vector 0 11)))
(test-eqv 1 (u32vector-length (make-u32vector 1 22)))
(test-eqv 10 (u32vector-length (make-u32vector 10 33)))
(test-eqv 100 (u32vector-length (make-u32vector 100 44)))
(test-eqv 1000 (u32vector-length (make-u32vector 1000 55)))
(test-eqv 10000 (u32vector-length (make-u32vector 10000 66)))

(test-equal '() (u32vector->list '#u32()))
(test-equal '(0 4294967295 0 1 4294967295) (u32vector->list u32v2))
(test-equal '(0 0) (u32vector->list u32v3))

(test-equal '#u32() (list->u32vector '()))
(test-equal u32v2 (list->u32vector '(0 4294967295 0 1 4294967295)))
(test-equal u32v3 (list->u32vector '(0 0)))

(test-eqv 0 (u32vector-ref u32v1 0))
(test-eqv 4294967295 (u32vector-ref u32v1 1))

(test-eqv 0 (u32vector-ref u32v2 0))
(test-eqv 4294967295 (u32vector-ref u32v2 1))
(test-eqv 0 (u32vector-ref u32v2 2))
(test-eqv 1 (u32vector-ref u32v2 3))
(test-eqv 4294967295 (u32vector-ref u32v2 4))

(test-eqv 0 (u32vector-ref u32v3 0))
(test-eqv 0 (u32vector-ref u32v3 1))

(test-eqv 0 (u32vector-ref u32v4 0))
(test-eqv 0 (u32vector-ref u32v4 1))

(test-eqv 4294967295 (u32vector-ref u32v5 0))
(test-eqv 4294967295 (u32vector-ref u32v5 1))

(u32vector-set! u32v2 1 99)
(u32vector-set! u32v3 1 99)
(u32vector-set! u32v4 1 99)
(u32vector-set! u32v5 1 99)

(test-eqv 0 (u32vector-ref u32v2 0))
(test-eqv 99 (u32vector-ref u32v2 1))
(test-eqv 0 (u32vector-ref u32v2 2))
(test-eqv 1 (u32vector-ref u32v2 3))
(test-eqv 4294967295 (u32vector-ref u32v2 4))

(test-eqv 0 (u32vector-ref u32v3 0))
(test-eqv 99 (u32vector-ref u32v3 1))

(test-eqv 0 (u32vector-ref u32v4 0))
(test-eqv 99 (u32vector-ref u32v4 1))

(test-eqv 4294967295 (u32vector-ref u32v5 0))
(test-eqv 99 (u32vector-ref u32v5 1))

(test-eqv 5 (u32vector-length u32v2))
(test-eqv 2 (u32vector-length u32v3))
(test-eqv 2 (u32vector-length u32v4))
(test-eqv 2 (u32vector-length u32v5))

(test-error-tail type-exception? (u32vector 11 bool 22))
(test-error-tail type-exception? (u32vector 11 -1 22))
(test-error-tail type-exception? (u32vector 11 4294967296 22))

(test-error-tail type-exception? (make-u32vector bool))
(test-error-tail type-exception? (make-u32vector bool 11))
(test-error-tail type-exception? (make-u32vector 11 bool))
(test-error-tail type-exception? (make-u32vector 11 -1))
(test-error-tail type-exception? (make-u32vector 11 4294967296))
(test-error-tail range-exception? (make-u32vector -1 0))

(test-error-tail type-exception? (u32vector-length bool))

(test-error-tail type-exception? (u32vector->list bool))

(test-error-tail type-exception? (list->u32vector bool))

(test-error-tail type-exception? (u32vector-ref bool 0))
(test-error-tail type-exception? (u32vector-ref u32v2 bool))
(test-error-tail range-exception? (u32vector-ref u32v2 -1))
(test-error-tail range-exception? (u32vector-ref u32v2 5))

(test-error-tail type-exception? (u32vector-set! bool 0 11))
(test-error-tail type-exception? (u32vector-set! u32v2 bool 11))
(test-error-tail type-exception? (u32vector-set! u32v2 0 bool))
(test-error-tail type-exception? (u32vector-set! u32v2 0 -1))
(test-error-tail type-exception? (u32vector-set! u32v2 0 4294967296))
(test-error-tail range-exception? (u32vector-set! u32v2 -1 0))
(test-error-tail range-exception? (u32vector-set! u32v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u32vector))
(test-error-tail wrong-number-of-arguments-exception? (make-u32vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u32vector?))
(test-error-tail wrong-number-of-arguments-exception? (u32vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-length))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u32vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (u32vector->list u32v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (u32vector->list u32v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (u32vector->list u32v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u32vector))
(test-error-tail wrong-number-of-arguments-exception? (list->u32vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref u32v1))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref u32v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-set! u32v5))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-set! u32v5 0))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-set! u32v5 0 0 0))

(test-error-tail range-exception? (make-u32vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; s64vectors

(define s64v1 '#s64(-9223372036854775808 9223372036854775807))
(define s64v2 (s64vector -9223372036854775808 -2 0 1 9223372036854775807))
(define s64v3 (make-s64vector 2))
(define s64v4 (make-s64vector 2 -9223372036854775808))
(define s64v5 (make-s64vector 2 9223372036854775807))

(test-assert (s64vector? s64v1))
(test-assert (s64vector? '#s64()))
(test-assert (s64vector? '#s64(11)))
(test-assert (s64vector? '#s64(11 22)))
(test-assert (s64vector? '#s64(11 22 33)))
(test-assert (s64vector? '#s64(11 22 33 44)))
(test-assert (s64vector? '#s64(11 22 33 44 55)))

(test-assert (s64vector? s64v2))
(test-assert (s64vector? (s64vector)))
(test-assert (s64vector? (s64vector 11)))
(test-assert (s64vector? (s64vector 11 22)))
(test-assert (s64vector? (s64vector 11 22 33)))
(test-assert (s64vector? (s64vector 11 22 33 44)))
(test-assert (s64vector? (s64vector 11 22 33 44 55)))

(test-assert (s64vector? s64v3))
(test-assert (s64vector? (make-s64vector 0)))
(test-assert (s64vector? (make-s64vector 1)))
(test-assert (s64vector? (make-s64vector 10)))
(test-assert (s64vector? (make-s64vector 100)))
(test-assert (s64vector? (make-s64vector 1000)))
(test-assert (s64vector? (make-s64vector 10000)))

(test-assert (s64vector? s64v4))
(test-assert (s64vector? s64v5))
(test-assert (s64vector? (make-s64vector 0 11)))
(test-assert (s64vector? (make-s64vector 1 22)))
(test-assert (s64vector? (make-s64vector 10 33)))
(test-assert (s64vector? (make-s64vector 100 44)))
(test-assert (s64vector? (make-s64vector 1000 55)))
(test-assert (s64vector? (make-s64vector 10000 66)))

(test-eqv 2 (s64vector-length s64v1))
(test-eqv 0 (s64vector-length '#s64()))
(test-eqv 1 (s64vector-length '#s64(11)))
(test-eqv 2 (s64vector-length '#s64(11 22)))
(test-eqv 3 (s64vector-length '#s64(11 22 33)))
(test-eqv 4 (s64vector-length '#s64(11 22 33 44)))
(test-eqv 5 (s64vector-length '#s64(11 22 33 44 55)))

(test-eqv 5 (s64vector-length s64v2))
(test-eqv 0 (s64vector-length (s64vector)))
(test-eqv 1 (s64vector-length (s64vector 11)))
(test-eqv 2 (s64vector-length (s64vector 11 22)))
(test-eqv 3 (s64vector-length (s64vector 11 22 33)))
(test-eqv 4 (s64vector-length (s64vector 11 22 33 44)))
(test-eqv 5 (s64vector-length (s64vector 11 22 33 44 55)))

(test-eqv 2 (s64vector-length s64v3))
(test-eqv 0 (s64vector-length (make-s64vector 0)))
(test-eqv 1 (s64vector-length (make-s64vector 1)))
(test-eqv 10 (s64vector-length (make-s64vector 10)))
(test-eqv 100 (s64vector-length (make-s64vector 100)))
(test-eqv 1000 (s64vector-length (make-s64vector 1000)))
(test-eqv 10000 (s64vector-length (make-s64vector 10000)))

(test-eqv 2 (s64vector-length s64v4))
(test-eqv 2 (s64vector-length s64v5))
(test-eqv 0 (s64vector-length (make-s64vector 0 11)))
(test-eqv 1 (s64vector-length (make-s64vector 1 22)))
(test-eqv 10 (s64vector-length (make-s64vector 10 33)))
(test-eqv 100 (s64vector-length (make-s64vector 100 44)))
(test-eqv 1000 (s64vector-length (make-s64vector 1000 55)))
(test-eqv 10000 (s64vector-length (make-s64vector 10000 66)))

(test-equal '() (s64vector->list '#s64()))
(test-equal '(-9223372036854775808 -2 0 1 9223372036854775807) (s64vector->list s64v2))
(test-equal '(0 0) (s64vector->list s64v3))

(test-equal '#s64() (list->s64vector '()))
(test-equal s64v2 (list->s64vector '(-9223372036854775808 -2 0 1 9223372036854775807)))
(test-equal s64v3 (list->s64vector '(0 0)))

(test-eqv -9223372036854775808 (s64vector-ref s64v1 0))
(test-eqv 9223372036854775807 (s64vector-ref s64v1 1))

(test-eqv -9223372036854775808 (s64vector-ref s64v2 0))
(test-eqv -2 (s64vector-ref s64v2 1))
(test-eqv 0 (s64vector-ref s64v2 2))
(test-eqv 1 (s64vector-ref s64v2 3))
(test-eqv 9223372036854775807 (s64vector-ref s64v2 4))

(test-eqv 0 (s64vector-ref s64v3 0))
(test-eqv 0 (s64vector-ref s64v3 1))

(test-eqv -9223372036854775808 (s64vector-ref s64v4 0))
(test-eqv -9223372036854775808 (s64vector-ref s64v4 1))

(test-eqv 9223372036854775807 (s64vector-ref s64v5 0))
(test-eqv 9223372036854775807 (s64vector-ref s64v5 1))

(s64vector-set! s64v2 1 99)
(s64vector-set! s64v3 1 99)
(s64vector-set! s64v4 1 99)
(s64vector-set! s64v5 1 99)

(test-eqv -9223372036854775808 (s64vector-ref s64v2 0))
(test-eqv 99 (s64vector-ref s64v2 1))
(test-eqv 0 (s64vector-ref s64v2 2))
(test-eqv 1 (s64vector-ref s64v2 3))
(test-eqv 9223372036854775807 (s64vector-ref s64v2 4))

(test-eqv 0 (s64vector-ref s64v3 0))
(test-eqv 99 (s64vector-ref s64v3 1))

(test-eqv -9223372036854775808 (s64vector-ref s64v4 0))
(test-eqv 99 (s64vector-ref s64v4 1))

(test-eqv 9223372036854775807 (s64vector-ref s64v5 0))
(test-eqv 99 (s64vector-ref s64v5 1))

(test-eqv 5 (s64vector-length s64v2))
(test-eqv 2 (s64vector-length s64v3))
(test-eqv 2 (s64vector-length s64v4))
(test-eqv 2 (s64vector-length s64v5))

(test-error-tail type-exception? (s64vector 11 bool 22))
(test-error-tail type-exception? (s64vector 11 -9223372036854775809 22))
(test-error-tail type-exception? (s64vector 11 9223372036854775808 22))

(test-error-tail type-exception? (make-s64vector bool))
(test-error-tail type-exception? (make-s64vector bool 11))
(test-error-tail type-exception? (make-s64vector 11 bool))
(test-error-tail type-exception? (make-s64vector 11 -9223372036854775809))
(test-error-tail type-exception? (make-s64vector 11 9223372036854775808))
(test-error-tail range-exception? (make-s64vector -1 0))

(test-error-tail type-exception? (s64vector-length bool))

(test-error-tail type-exception? (s64vector->list bool))

(test-error-tail type-exception? (list->s64vector bool))

(test-error-tail type-exception? (s64vector-ref bool 0))
(test-error-tail type-exception? (s64vector-ref s64v2 bool))
(test-error-tail range-exception? (s64vector-ref s64v2 -1))
(test-error-tail range-exception? (s64vector-ref s64v2 5))

(test-error-tail type-exception? (s64vector-set! bool 0 11))
(test-error-tail type-exception? (s64vector-set! s64v2 bool 11))
(test-error-tail type-exception? (s64vector-set! s64v2 0 bool))
(test-error-tail type-exception? (s64vector-set! s64v2 0 -9223372036854775809))
(test-error-tail type-exception? (s64vector-set! s64v2 0 9223372036854775808))
(test-error-tail range-exception? (s64vector-set! s64v2 -1 0))
(test-error-tail range-exception? (s64vector-set! s64v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s64vector))
(test-error-tail wrong-number-of-arguments-exception? (make-s64vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s64vector?))
(test-error-tail wrong-number-of-arguments-exception? (s64vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-length))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s64vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (s64vector->list s64v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (s64vector->list s64v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (s64vector->list s64v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s64vector))
(test-error-tail wrong-number-of-arguments-exception? (list->s64vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref s64v1))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref s64v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-set! s64v5))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-set! s64v5 0))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-set! s64v5 0 0 0))

(test-error-tail range-exception? (make-s64vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; u64vectors

(define u64v1 '#u64(0 18446744073709551615))
(define u64v2 (u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define u64v3 (make-u64vector 2))
(define u64v4 (make-u64vector 2 0))
(define u64v5 (make-u64vector 2 18446744073709551615))

(test-assert (u64vector? u64v1))
(test-assert (u64vector? '#u64()))
(test-assert (u64vector? '#u64(11)))
(test-assert (u64vector? '#u64(11 22)))
(test-assert (u64vector? '#u64(11 22 33)))
(test-assert (u64vector? '#u64(11 22 33 44)))
(test-assert (u64vector? '#u64(11 22 33 44 55)))

(test-assert (u64vector? u64v2))
(test-assert (u64vector? (u64vector)))
(test-assert (u64vector? (u64vector 11)))
(test-assert (u64vector? (u64vector 11 22)))
(test-assert (u64vector? (u64vector 11 22 33)))
(test-assert (u64vector? (u64vector 11 22 33 44)))
(test-assert (u64vector? (u64vector 11 22 33 44 55)))

(test-assert (u64vector? u64v3))
(test-assert (u64vector? (make-u64vector 0)))
(test-assert (u64vector? (make-u64vector 1)))
(test-assert (u64vector? (make-u64vector 10)))
(test-assert (u64vector? (make-u64vector 100)))
(test-assert (u64vector? (make-u64vector 1000)))
(test-assert (u64vector? (make-u64vector 10000)))

(test-assert (u64vector? u64v4))
(test-assert (u64vector? u64v5))
(test-assert (u64vector? (make-u64vector 0 11)))
(test-assert (u64vector? (make-u64vector 1 22)))
(test-assert (u64vector? (make-u64vector 10 33)))
(test-assert (u64vector? (make-u64vector 100 44)))
(test-assert (u64vector? (make-u64vector 1000 55)))
(test-assert (u64vector? (make-u64vector 10000 66)))

(test-eqv 2 (u64vector-length u64v1))
(test-eqv 0 (u64vector-length '#u64()))
(test-eqv 1 (u64vector-length '#u64(11)))
(test-eqv 2 (u64vector-length '#u64(11 22)))
(test-eqv 3 (u64vector-length '#u64(11 22 33)))
(test-eqv 4 (u64vector-length '#u64(11 22 33 44)))
(test-eqv 5 (u64vector-length '#u64(11 22 33 44 55)))

(test-eqv 5 (u64vector-length u64v2))
(test-eqv 0 (u64vector-length (u64vector)))
(test-eqv 1 (u64vector-length (u64vector 11)))
(test-eqv 2 (u64vector-length (u64vector 11 22)))
(test-eqv 3 (u64vector-length (u64vector 11 22 33)))
(test-eqv 4 (u64vector-length (u64vector 11 22 33 44)))
(test-eqv 5 (u64vector-length (u64vector 11 22 33 44 55)))

(test-eqv 2 (u64vector-length u64v3))
(test-eqv 0 (u64vector-length (make-u64vector 0)))
(test-eqv 1 (u64vector-length (make-u64vector 1)))
(test-eqv 10 (u64vector-length (make-u64vector 10)))
(test-eqv 100 (u64vector-length (make-u64vector 100)))
(test-eqv 1000 (u64vector-length (make-u64vector 1000)))
(test-eqv 10000 (u64vector-length (make-u64vector 10000)))

(test-eqv 2 (u64vector-length u64v4))
(test-eqv 2 (u64vector-length u64v5))
(test-eqv 0 (u64vector-length (make-u64vector 0 11)))
(test-eqv 1 (u64vector-length (make-u64vector 1 22)))
(test-eqv 10 (u64vector-length (make-u64vector 10 33)))
(test-eqv 100 (u64vector-length (make-u64vector 100 44)))
(test-eqv 1000 (u64vector-length (make-u64vector 1000 55)))
(test-eqv 10000 (u64vector-length (make-u64vector 10000 66)))

(test-equal '() (u64vector->list '#u64()))
(test-equal '(0 18446744073709551615 0 1 18446744073709551615) (u64vector->list u64v2))
(test-equal '(0 0) (u64vector->list u64v3))

(test-equal '#u64() (list->u64vector '()))
(test-equal u64v2 (list->u64vector '(0 18446744073709551615 0 1 18446744073709551615)))
(test-equal u64v3 (list->u64vector '(0 0)))

(test-eqv 0 (u64vector-ref u64v1 0))
(test-eqv 18446744073709551615 (u64vector-ref u64v1 1))

(test-eqv 0 (u64vector-ref u64v2 0))
(test-eqv 18446744073709551615 (u64vector-ref u64v2 1))
(test-eqv 0 (u64vector-ref u64v2 2))
(test-eqv 1 (u64vector-ref u64v2 3))
(test-eqv 18446744073709551615 (u64vector-ref u64v2 4))

(test-eqv 0 (u64vector-ref u64v3 0))
(test-eqv 0 (u64vector-ref u64v3 1))

(test-eqv 0 (u64vector-ref u64v4 0))
(test-eqv 0 (u64vector-ref u64v4 1))

(test-eqv 18446744073709551615 (u64vector-ref u64v5 0))
(test-eqv 18446744073709551615 (u64vector-ref u64v5 1))

(u64vector-set! u64v2 1 99)
(u64vector-set! u64v3 1 99)
(u64vector-set! u64v4 1 99)
(u64vector-set! u64v5 1 99)

(test-eqv 0 (u64vector-ref u64v2 0))
(test-eqv 99 (u64vector-ref u64v2 1))
(test-eqv 0 (u64vector-ref u64v2 2))
(test-eqv 1 (u64vector-ref u64v2 3))
(test-eqv 18446744073709551615 (u64vector-ref u64v2 4))

(test-eqv 0 (u64vector-ref u64v3 0))
(test-eqv 99 (u64vector-ref u64v3 1))

(test-eqv 0 (u64vector-ref u64v4 0))
(test-eqv 99 (u64vector-ref u64v4 1))

(test-eqv 18446744073709551615 (u64vector-ref u64v5 0))
(test-eqv 99 (u64vector-ref u64v5 1))

(test-eqv 5 (u64vector-length u64v2))
(test-eqv 2 (u64vector-length u64v3))
(test-eqv 2 (u64vector-length u64v4))
(test-eqv 2 (u64vector-length u64v5))

(test-error-tail type-exception? (u64vector 11 bool 22))
(test-error-tail type-exception? (u64vector 11 -1 22))
(test-error-tail type-exception? (u64vector 11 18446744073709551616 22))

(test-error-tail type-exception? (make-u64vector bool))
(test-error-tail type-exception? (make-u64vector bool 11))
(test-error-tail type-exception? (make-u64vector 11 bool))
(test-error-tail type-exception? (make-u64vector 11 -1))
(test-error-tail type-exception? (make-u64vector 11 18446744073709551616))
(test-error-tail range-exception? (make-u64vector -1 0))

(test-error-tail type-exception? (u64vector-length bool))

(test-error-tail type-exception? (u64vector->list bool))

(test-error-tail type-exception? (list->u64vector bool))

(test-error-tail type-exception? (u64vector-ref bool 0))
(test-error-tail type-exception? (u64vector-ref u64v2 bool))
(test-error-tail range-exception? (u64vector-ref u64v2 -1))
(test-error-tail range-exception? (u64vector-ref u64v2 5))

(test-error-tail type-exception? (u64vector-set! bool 0 11))
(test-error-tail type-exception? (u64vector-set! u64v2 bool 11))
(test-error-tail type-exception? (u64vector-set! u64v2 0 bool))
(test-error-tail type-exception? (u64vector-set! u64v2 0 -1))
(test-error-tail type-exception? (u64vector-set! u64v2 0 18446744073709551616))
(test-error-tail range-exception? (u64vector-set! u64v2 -1 0))
(test-error-tail range-exception? (u64vector-set! u64v2 5 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u64vector))
(test-error-tail wrong-number-of-arguments-exception? (make-u64vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u64vector?))
(test-error-tail wrong-number-of-arguments-exception? (u64vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-length))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u64vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (u64vector->list u64v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (u64vector->list u64v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (u64vector->list u64v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u64vector))
(test-error-tail wrong-number-of-arguments-exception? (list->u64vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref u64v1))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref u64v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-set! u64v5))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-set! u64v5 0))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-set! u64v5 0 0 0))

(test-error-tail range-exception? (make-u64vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; f32vectors

(define f32v1 '#f32(-inf.0 +inf.0))
(define f32v2 (f32vector -inf.0 -0.0 +0.0 1.0 +inf.0))
(define f32v3 (make-f32vector 2))
(define f32v4 (make-f32vector 2 -inf.0))
(define f32v5 (make-f32vector 2 +inf.0))

(test-assert (f32vector? f32v1))
(test-assert (f32vector? '#f32()))
(test-assert (f32vector? '#f32(11.0)))
(test-assert (f32vector? '#f32(11.0 22.0)))
(test-assert (f32vector? '#f32(11.0 22.0 33.0)))
(test-assert (f32vector? '#f32(11.0 22.0 33.0 44.0)))
(test-assert (f32vector? '#f32(11.0 22.0 33.0 44.0 55.0)))

(test-assert (f32vector? f32v2))
(test-assert (f32vector? (f32vector)))
(test-assert (f32vector? (f32vector 11.0)))
(test-assert (f32vector? (f32vector 11.0 22.0)))
(test-assert (f32vector? (f32vector 11.0 22.0 33.0)))
(test-assert (f32vector? (f32vector 11.0 22.0 33.0 44.0)))
(test-assert (f32vector? (f32vector 11.0 22.0 33.0 44.0 55.0)))

(test-assert (f32vector? f32v3))
(test-assert (f32vector? (make-f32vector 0)))
(test-assert (f32vector? (make-f32vector 1)))
(test-assert (f32vector? (make-f32vector 10)))
(test-assert (f32vector? (make-f32vector 100)))
(test-assert (f32vector? (make-f32vector 1000)))
(test-assert (f32vector? (make-f32vector 10000)))

(test-assert (f32vector? f32v4))
(test-assert (f32vector? f32v5))
(test-assert (f32vector? (make-f32vector 0 11.0)))
(test-assert (f32vector? (make-f32vector 1 22.0)))
(test-assert (f32vector? (make-f32vector 10 33.0)))
(test-assert (f32vector? (make-f32vector 100 44.0)))
(test-assert (f32vector? (make-f32vector 1000 55.0)))
(test-assert (f32vector? (make-f32vector 10000 66.0)))

(test-eqv 2 (f32vector-length f32v1))
(test-eqv 0 (f32vector-length '#f32()))
(test-eqv 1 (f32vector-length '#f32(11.0)))
(test-eqv 2 (f32vector-length '#f32(11.0 22.0)))
(test-eqv 3 (f32vector-length '#f32(11.0 22.0 33.0)))
(test-eqv 4 (f32vector-length '#f32(11.0 22.0 33.0 44.0)))
(test-eqv 5 (f32vector-length '#f32(11.0 22.0 33.0 44.0 55.0)))

(test-eqv 5 (f32vector-length f32v2))
(test-eqv 0 (f32vector-length (f32vector)))
(test-eqv 1 (f32vector-length (f32vector 11.0)))
(test-eqv 2 (f32vector-length (f32vector 11.0 22.0)))
(test-eqv 3 (f32vector-length (f32vector 11.0 22.0 33.0)))
(test-eqv 4 (f32vector-length (f32vector 11.0 22.0 33.0 44.0)))
(test-eqv 5 (f32vector-length (f32vector 11.0 22.0 33.0 44.0 55.0)))

(test-eqv 2 (f32vector-length f32v3))
(test-eqv 0 (f32vector-length (make-f32vector 0)))
(test-eqv 1 (f32vector-length (make-f32vector 1)))
(test-eqv 10 (f32vector-length (make-f32vector 10)))
(test-eqv 100 (f32vector-length (make-f32vector 100)))
(test-eqv 1000 (f32vector-length (make-f32vector 1000)))
(test-eqv 10000 (f32vector-length (make-f32vector 10000)))

(test-eqv 2 (f32vector-length f32v4))
(test-eqv 2 (f32vector-length f32v5))
(test-eqv 0 (f32vector-length (make-f32vector 0 11.0)))
(test-eqv 1 (f32vector-length (make-f32vector 1 22.0)))
(test-eqv 10 (f32vector-length (make-f32vector 10 33.0)))
(test-eqv 100 (f32vector-length (make-f32vector 100 44.0)))
(test-eqv 1000 (f32vector-length (make-f32vector 1000 55.0)))
(test-eqv 10000 (f32vector-length (make-f32vector 10000 66.0)))

(test-equal '() (f32vector->list '#f32()))
(test-equal '(-inf.0 -0.0 +0.0 1.0 +inf.0) (f32vector->list f32v2))
(test-equal '(+0.0 +0.0) (f32vector->list f32v3))

(test-equal '#f32() (list->f32vector '()))
(test-equal f32v2 (list->f32vector '(-inf.0 -0.0 +0.0 1.0 +inf.0)))
(test-equal f32v3 (list->f32vector '(+0.0 +0.0)))

(test-eqv -inf.0 (f32vector-ref f32v1 0))
(test-eqv +inf.0 (f32vector-ref f32v1 1))

(test-eqv -inf.0 (f32vector-ref f32v2 0))
(test-eqv -0.0 (f32vector-ref f32v2 1))
(test-eqv +0.0 (f32vector-ref f32v2 2))
(test-eqv 1.0 (f32vector-ref f32v2 3))
(test-eqv +inf.0 (f32vector-ref f32v2 4))

(test-eqv +0.0 (f32vector-ref f32v3 0))
(test-eqv +0.0 (f32vector-ref f32v3 1))

(test-eqv -inf.0 (f32vector-ref f32v4 0))
(test-eqv -inf.0 (f32vector-ref f32v4 1))

(test-eqv +inf.0 (f32vector-ref f32v5 0))
(test-eqv +inf.0 (f32vector-ref f32v5 1))

(f32vector-set! f32v2 1 99.0)
(f32vector-set! f32v3 1 99.0)
(f32vector-set! f32v4 1 99.0)
(f32vector-set! f32v5 1 99.0)

(test-eqv -inf.0 (f32vector-ref f32v2 0))
(test-eqv 99.0 (f32vector-ref f32v2 1))
(test-eqv +0.0 (f32vector-ref f32v2 2))
(test-eqv 1.0 (f32vector-ref f32v2 3))
(test-eqv +inf.0 (f32vector-ref f32v2 4))

(test-eqv +0.0 (f32vector-ref f32v3 0))
(test-eqv 99.0 (f32vector-ref f32v3 1))

(test-eqv -inf.0 (f32vector-ref f32v4 0))
(test-eqv 99.0 (f32vector-ref f32v4 1))

(test-eqv +inf.0 (f32vector-ref f32v5 0))
(test-eqv 99.0 (f32vector-ref f32v5 1))

(test-eqv 5 (f32vector-length f32v2))
(test-eqv 2 (f32vector-length f32v3))
(test-eqv 2 (f32vector-length f32v4))
(test-eqv 2 (f32vector-length f32v5))

(test-error-tail type-exception? (f32vector 11.0 bool 22.0))
(test-error-tail type-exception? (f32vector 11.0 -1.0-2.0i 22.0))
(test-error-tail type-exception? (f32vector 11.0 1.0+2.0i 22.0))

(test-error-tail type-exception? (make-f32vector bool))
(test-error-tail type-exception? (make-f32vector bool 11.0))
(test-error-tail type-exception? (make-f32vector 11.0 bool))
(test-error-tail type-exception? (make-f32vector 11.0 -1.0-2.0i))
(test-error-tail type-exception? (make-f32vector 11.0 1.0+2.0i))
(test-error-tail range-exception? (make-f32vector -1 +0.0))

(test-error-tail type-exception? (f32vector-length bool))

(test-error-tail type-exception? (f32vector->list bool))

(test-error-tail type-exception? (list->f32vector bool))

(test-error-tail type-exception? (f32vector-ref bool 0))
(test-error-tail type-exception? (f32vector-ref f32v2 bool))
(test-error-tail range-exception? (f32vector-ref f32v2 -1))
(test-error-tail range-exception? (f32vector-ref f32v2 5))

(test-error-tail type-exception? (f32vector-set! bool +0.0 11.0))
(test-error-tail type-exception? (f32vector-set! f32v2 bool 11.0))
(test-error-tail type-exception? (f32vector-set! f32v2 +0.0 bool))
(test-error-tail type-exception? (f32vector-set! f32v2 +0.0 -1.0-2.0i))
(test-error-tail type-exception? (f32vector-set! f32v2 +0.0 1.0+2.0i))
(test-error-tail range-exception? (f32vector-set! f32v2 -1 +0.0))
(test-error-tail range-exception? (f32vector-set! f32v2 5 +0.0))

(test-error-tail wrong-number-of-arguments-exception? (make-f32vector))
(test-error-tail wrong-number-of-arguments-exception? (make-f32vector 11.0 22.0 33.0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector?))
(test-error-tail wrong-number-of-arguments-exception? (f32vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-length))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f32vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (f32vector->list f32v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (f32vector->list f32v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (f32vector->list f32v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->f32vector))
(test-error-tail wrong-number-of-arguments-exception? (list->f32vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref f32v1))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref f32v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-set! f32v5))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-set! f32v5 0))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-set! f32v5 0 +0.0 0))

(test-error-tail range-exception? (make-f32vector (expt 2 64)))

;;;----------------------------------------------------------------------------

;;; f64vectors

(define f64v1 '#f64(-inf.0 +inf.0))
(define f64v2 (f64vector -inf.0 -0.0 +0.0 1.0 +inf.0))
(define f64v3 (make-f64vector 2))
(define f64v4 (make-f64vector 2 -inf.0))
(define f64v5 (make-f64vector 2 +inf.0))

(test-assert (f64vector? f64v1))
(test-assert (f64vector? '#f64()))
(test-assert (f64vector? '#f64(11.0)))
(test-assert (f64vector? '#f64(11.0 22.0)))
(test-assert (f64vector? '#f64(11.0 22.0 33.0)))
(test-assert (f64vector? '#f64(11.0 22.0 33.0 44.0)))
(test-assert (f64vector? '#f64(11.0 22.0 33.0 44.0 55.0)))

(test-assert (f64vector? f64v2))
(test-assert (f64vector? (f64vector)))
(test-assert (f64vector? (f64vector 11.0)))
(test-assert (f64vector? (f64vector 11.0 22.0)))
(test-assert (f64vector? (f64vector 11.0 22.0 33.0)))
(test-assert (f64vector? (f64vector 11.0 22.0 33.0 44.0)))
(test-assert (f64vector? (f64vector 11.0 22.0 33.0 44.0 55.0)))

(test-assert (f64vector? f64v3))
(test-assert (f64vector? (make-f64vector 0)))
(test-assert (f64vector? (make-f64vector 1)))
(test-assert (f64vector? (make-f64vector 10)))
(test-assert (f64vector? (make-f64vector 100)))
(test-assert (f64vector? (make-f64vector 1000)))
(test-assert (f64vector? (make-f64vector 10000)))

(test-assert (f64vector? f64v4))
(test-assert (f64vector? f64v5))
(test-assert (f64vector? (make-f64vector 0 11.0)))
(test-assert (f64vector? (make-f64vector 1 22.0)))
(test-assert (f64vector? (make-f64vector 10 33.0)))
(test-assert (f64vector? (make-f64vector 100 44.0)))
(test-assert (f64vector? (make-f64vector 1000 55.0)))
(test-assert (f64vector? (make-f64vector 10000 66.0)))

(test-eqv 2 (f64vector-length f64v1))
(test-eqv 0 (f64vector-length '#f64()))
(test-eqv 1 (f64vector-length '#f64(11.0)))
(test-eqv 2 (f64vector-length '#f64(11.0 22.0)))
(test-eqv 3 (f64vector-length '#f64(11.0 22.0 33.0)))
(test-eqv 4 (f64vector-length '#f64(11.0 22.0 33.0 44.0)))
(test-eqv 5 (f64vector-length '#f64(11.0 22.0 33.0 44.0 55.0)))

(test-eqv 5 (f64vector-length f64v2))
(test-eqv 0 (f64vector-length (f64vector)))
(test-eqv 1 (f64vector-length (f64vector 11.0)))
(test-eqv 2 (f64vector-length (f64vector 11.0 22.0)))
(test-eqv 3 (f64vector-length (f64vector 11.0 22.0 33.0)))
(test-eqv 4 (f64vector-length (f64vector 11.0 22.0 33.0 44.0)))
(test-eqv 5 (f64vector-length (f64vector 11.0 22.0 33.0 44.0 55.0)))

(test-eqv 2 (f64vector-length f64v3))
(test-eqv 0 (f64vector-length (make-f64vector 0)))
(test-eqv 1 (f64vector-length (make-f64vector 1)))
(test-eqv 10 (f64vector-length (make-f64vector 10)))
(test-eqv 100 (f64vector-length (make-f64vector 100)))
(test-eqv 1000 (f64vector-length (make-f64vector 1000)))
(test-eqv 10000 (f64vector-length (make-f64vector 10000)))

(test-eqv 2 (f64vector-length f64v4))
(test-eqv 2 (f64vector-length f64v5))
(test-eqv 0 (f64vector-length (make-f64vector 0 11.0)))
(test-eqv 1 (f64vector-length (make-f64vector 1 22.0)))
(test-eqv 10 (f64vector-length (make-f64vector 10 33.0)))
(test-eqv 100 (f64vector-length (make-f64vector 100 44.0)))
(test-eqv 1000 (f64vector-length (make-f64vector 1000 55.0)))
(test-eqv 10000 (f64vector-length (make-f64vector 10000 66.0)))

(test-equal '() (f64vector->list '#f64()))
(test-equal '(-inf.0 -0.0 +0.0 1.0 +inf.0) (f64vector->list f64v2))
(test-equal '(+0.0 +0.0) (f64vector->list f64v3))

(test-equal '#f64() (list->f64vector '()))
(test-equal f64v2 (list->f64vector '(-inf.0 -0.0 +0.0 1.0 +inf.0)))
(test-equal f64v3 (list->f64vector '(+0.0 +0.0)))

(test-eqv -inf.0 (f64vector-ref f64v1 0))
(test-eqv +inf.0 (f64vector-ref f64v1 1))

(test-eqv -inf.0 (f64vector-ref f64v2 0))
(test-eqv -0.0 (f64vector-ref f64v2 1))
(test-eqv +0.0 (f64vector-ref f64v2 2))
(test-eqv 1.0 (f64vector-ref f64v2 3))
(test-eqv +inf.0 (f64vector-ref f64v2 4))

(test-eqv +0.0 (f64vector-ref f64v3 0))
(test-eqv +0.0 (f64vector-ref f64v3 1))

(test-eqv -inf.0 (f64vector-ref f64v4 0))
(test-eqv -inf.0 (f64vector-ref f64v4 1))

(test-eqv +inf.0 (f64vector-ref f64v5 0))
(test-eqv +inf.0 (f64vector-ref f64v5 1))

(f64vector-set! f64v2 1 99.0)
(f64vector-set! f64v3 1 99.0)
(f64vector-set! f64v4 1 99.0)
(f64vector-set! f64v5 1 99.0)

(test-eqv -inf.0 (f64vector-ref f64v2 0))
(test-eqv 99.0 (f64vector-ref f64v2 1))
(test-eqv +0.0 (f64vector-ref f64v2 2))
(test-eqv 1.0 (f64vector-ref f64v2 3))
(test-eqv +inf.0 (f64vector-ref f64v2 4))

(test-eqv +0.0 (f64vector-ref f64v3 0))
(test-eqv 99.0 (f64vector-ref f64v3 1))

(test-eqv -inf.0 (f64vector-ref f64v4 0))
(test-eqv 99.0 (f64vector-ref f64v4 1))

(test-eqv +inf.0 (f64vector-ref f64v5 0))
(test-eqv 99.0 (f64vector-ref f64v5 1))

(test-eqv 5 (f64vector-length f64v2))
(test-eqv 2 (f64vector-length f64v3))
(test-eqv 2 (f64vector-length f64v4))
(test-eqv 2 (f64vector-length f64v5))

(test-error-tail type-exception? (f64vector 11.0 bool 22.0))
(test-error-tail type-exception? (f64vector 11.0 -1.0-2.0i 22.0))
(test-error-tail type-exception? (f64vector 11.0 1.0+2.0i 22.0))

(test-error-tail type-exception? (make-f64vector bool))
(test-error-tail type-exception? (make-f64vector bool 11.0))
(test-error-tail type-exception? (make-f64vector 11.0 bool))
(test-error-tail type-exception? (make-f64vector 11.0 -1.0-2.0i))
(test-error-tail type-exception? (make-f64vector 11.0 1.0+2.0i))
(test-error-tail range-exception? (make-f64vector -1 +0.0))

(test-error-tail type-exception? (f64vector-length bool))

(test-error-tail type-exception? (f64vector->list bool))

(test-error-tail type-exception? (list->f64vector bool))

(test-error-tail type-exception? (f64vector-ref bool 0))
(test-error-tail type-exception? (f64vector-ref f64v2 bool))
(test-error-tail range-exception? (f64vector-ref f64v2 -1))
(test-error-tail range-exception? (f64vector-ref f64v2 5))

(test-error-tail type-exception? (f64vector-set! bool +0.0 11.0))
(test-error-tail type-exception? (f64vector-set! f64v2 bool 11.0))
(test-error-tail type-exception? (f64vector-set! f64v2 +0.0 bool))
(test-error-tail type-exception? (f64vector-set! f64v2 +0.0 -1.0-2.0i))
(test-error-tail type-exception? (f64vector-set! f64v2 +0.0 1.0+2.0i))
(test-error-tail range-exception? (f64vector-set! f64v2 -1 +0.0))
(test-error-tail range-exception? (f64vector-set! f64v2 5 +0.0))

(test-error-tail wrong-number-of-arguments-exception? (make-f64vector))
(test-error-tail wrong-number-of-arguments-exception? (make-f64vector 11.0 22.0 33.0))

(test-error-tail wrong-number-of-arguments-exception? (f64vector?))
(test-error-tail wrong-number-of-arguments-exception? (f64vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f64vector-length))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f64vector->list))
;;Gambit accepts 2 and 3 arguments...
;;(test-error-tail wrong-number-of-arguments-exception? (f64vector->list f64v1 0))
;;(test-error-tail wrong-number-of-arguments-exception? (f64vector->list f64v1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (f64vector->list f64v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->f64vector))
(test-error-tail wrong-number-of-arguments-exception? (list->f64vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (f64vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-ref f64v1))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-ref f64v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f64vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-set! f64v5))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-set! f64v5 0))
(test-error-tail wrong-number-of-arguments-exception? (f64vector-set! f64v5 0 +0.0 0))

(test-error-tail range-exception? (make-f64vector (expt 2 64)))

;;;----------------------------------------------------------------------------

#|

the tests for the different types of homogeneous vectors were
generated with this script:

#! /bin/sh

# Generate u8vector, s16vector, u16vector, etc unit-tests from s8vect.scm

sed -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > s8vector.scm

sed -e "s/s8/u8/g" -e "s/-129/-1/g" -e "s/-128/0/g" -e "s/ -2/ 255/g" -e "s/127/255/g" -e "s/128/256/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > u8vector.scm

#-------------------------

sed -e "s/s8/s16/g" -e "s/-129/-32769/g" -e "s/128/32768/g" -e "s/127/32767/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > s16vector.scm

sed -e "s/s8/u16/g" -e "s/-129/-1/g" -e "s/-128/0/g" -e "s/ -2/ 65535/g" -e "s/127/65535/g" -e "s/128/65536/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > u16vector.scm

#-------------------------

sed -e "s/s8/s32/g" -e "s/-129/-2147483649/g" -e "s/128/2147483648/g" -e "s/127/2147483647/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > s32vector.scm

sed -e "s/s8/u32/g" -e "s/-129/-1/g" -e "s/-128/0/g" -e "s/ -2/ 4294967295/g" -e "s/127/4294967295/g" -e "s/128/4294967296/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > u32vector.scm

#-------------------------

sed -e "s/s8/s64/g" -e "s/-129/-9223372036854775809/g" -e "s/128/9223372036854775808/g" -e "s/127/9223372036854775807/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > s64vector.scm

sed -e "s/s8/u64/g" -e "s/-129/-1/g" -e "s/-128/0/g" -e "s/ -2/ 18446744073709551615/g" -e "s/127/18446744073709551615/g" -e "s/128/18446744073709551616/g" -e "s/00001/1/g" -e "s/00000/0/g" < s8vect.scm > u64vector.scm

#-------------------------

sed -e "s/s8/f32/g" -e "s/-128/-inf.0/g" -e "s/127/+inf.0/g" -e "s/11/11.0/g" -e "s/22/22.0/g" -e "s/33/33.0/g" -e "s/44/44.0/g" -e "s/55/55.0/g" -e "s/66/66.0/g" -e "s/99/99.0/g" -e "s/-2/-0.0/g" -e "s/00001/1.0/g" -e "s/00000/+0.0/g" -e "s/-129/-1.0-2.0i/g" -e "s/128/1.0+2.0i/g" < s8vect.scm > f32vector.scm

sed -e "s/s8/f64/g" -e "s/-128/-inf.0/g" -e "s/127/+inf.0/g" -e "s/11/11.0/g" -e "s/22/22.0/g" -e "s/33/33.0/g" -e "s/44/44.0/g" -e "s/55/55.0/g" -e "s/66/66.0/g" -e "s/99/99.0/g" -e "s/-2/-0.0/g" -e "s/00001/1.0/g" -e "s/00000/+0.0/g" -e "s/-129/-1.0-2.0i/g" -e "s/128/1.0+2.0i/g" < s8vect.scm > f64vector.scm

#-------------------------

|#

;;;============================================================================
