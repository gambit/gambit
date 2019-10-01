;;;============================================================================

;;; File: "srfi/4/4-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 4, Homogeneous numeric vector datatypes

(import (srfi 4))
(import (gambit test))

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

(check-true (s8vector? s8v1))
(check-true (s8vector? '#s8()))
(check-true (s8vector? '#s8(11)))
(check-true (s8vector? '#s8(11 22)))
(check-true (s8vector? '#s8(11 22 33)))
(check-true (s8vector? '#s8(11 22 33 44)))
(check-true (s8vector? '#s8(11 22 33 44 55)))

(check-true (s8vector? s8v2))
(check-true (s8vector? (s8vector)))
(check-true (s8vector? (s8vector 11)))
(check-true (s8vector? (s8vector 11 22)))
(check-true (s8vector? (s8vector 11 22 33)))
(check-true (s8vector? (s8vector 11 22 33 44)))
(check-true (s8vector? (s8vector 11 22 33 44 55)))

(check-true (s8vector? s8v3))
(check-true (s8vector? (make-s8vector 0)))
(check-true (s8vector? (make-s8vector 1)))
(check-true (s8vector? (make-s8vector 10)))
(check-true (s8vector? (make-s8vector 100)))
(check-true (s8vector? (make-s8vector 1000)))
(check-true (s8vector? (make-s8vector 10000)))

(check-true (s8vector? s8v4))
(check-true (s8vector? s8v5))
(check-true (s8vector? (make-s8vector 0 11)))
(check-true (s8vector? (make-s8vector 1 22)))
(check-true (s8vector? (make-s8vector 10 33)))
(check-true (s8vector? (make-s8vector 100 44)))
(check-true (s8vector? (make-s8vector 1000 55)))
(check-true (s8vector? (make-s8vector 10000 66)))

(check-eqv? (s8vector-length s8v1) 2)
(check-eqv? (s8vector-length '#s8()) 0)
(check-eqv? (s8vector-length '#s8(11)) 1)
(check-eqv? (s8vector-length '#s8(11 22)) 2)
(check-eqv? (s8vector-length '#s8(11 22 33)) 3)
(check-eqv? (s8vector-length '#s8(11 22 33 44)) 4)
(check-eqv? (s8vector-length '#s8(11 22 33 44 55)) 5)

(check-eqv? (s8vector-length s8v2) 5)
(check-eqv? (s8vector-length (s8vector)) 0)
(check-eqv? (s8vector-length (s8vector 11)) 1)
(check-eqv? (s8vector-length (s8vector 11 22)) 2)
(check-eqv? (s8vector-length (s8vector 11 22 33)) 3)
(check-eqv? (s8vector-length (s8vector 11 22 33 44)) 4)
(check-eqv? (s8vector-length (s8vector 11 22 33 44 55)) 5)

(check-eqv? (s8vector-length s8v3) 2)
(check-eqv? (s8vector-length (make-s8vector 0)) 0)
(check-eqv? (s8vector-length (make-s8vector 1)) 1)
(check-eqv? (s8vector-length (make-s8vector 10)) 10)
(check-eqv? (s8vector-length (make-s8vector 100)) 100)
(check-eqv? (s8vector-length (make-s8vector 1000)) 1000)
(check-eqv? (s8vector-length (make-s8vector 10000)) 10000)

(check-eqv? (s8vector-length s8v4) 2)
(check-eqv? (s8vector-length s8v5) 2)
(check-eqv? (s8vector-length (make-s8vector 0 11)) 0)
(check-eqv? (s8vector-length (make-s8vector 1 22)) 1)
(check-eqv? (s8vector-length (make-s8vector 10 33)) 10)
(check-eqv? (s8vector-length (make-s8vector 100 44)) 100)
(check-eqv? (s8vector-length (make-s8vector 1000 55)) 1000)
(check-eqv? (s8vector-length (make-s8vector 10000 66)) 10000)

(check-equal? (s8vector->list '#s8()) '())
(check-equal? (s8vector->list s8v2) '(-128 -2 00000 00001 127))
(check-equal? (s8vector->list s8v3) '(00000 00000))

(check-equal? (list->s8vector '()) '#s8())
(check-equal? (list->s8vector '(-128 -2 00000 00001 127)) s8v2)
(check-equal? (list->s8vector '(00000 00000)) s8v3)

(check-eqv? (s8vector-ref s8v1 0) -128)
(check-eqv? (s8vector-ref s8v1 1) 127)

(check-eqv? (s8vector-ref s8v2 0) -128)
(check-eqv? (s8vector-ref s8v2 1) -2)
(check-eqv? (s8vector-ref s8v2 2) 00000)
(check-eqv? (s8vector-ref s8v2 3) 00001)
(check-eqv? (s8vector-ref s8v2 4) 127)

(check-eqv? (s8vector-ref s8v3 0) 00000)
(check-eqv? (s8vector-ref s8v3 1) 00000)

(check-eqv? (s8vector-ref s8v4 0) -128)
(check-eqv? (s8vector-ref s8v4 1) -128)

(check-eqv? (s8vector-ref s8v5 0) 127)
(check-eqv? (s8vector-ref s8v5 1) 127)

(s8vector-set! s8v2 1 99)
(s8vector-set! s8v3 1 99)
(s8vector-set! s8v4 1 99)
(s8vector-set! s8v5 1 99)

(check-eqv? (s8vector-ref s8v2 0) -128)
(check-eqv? (s8vector-ref s8v2 1) 99)
(check-eqv? (s8vector-ref s8v2 2) 00000)
(check-eqv? (s8vector-ref s8v2 3) 00001)
(check-eqv? (s8vector-ref s8v2 4) 127)

(check-eqv? (s8vector-ref s8v3 0) 00000)
(check-eqv? (s8vector-ref s8v3 1) 99)

(check-eqv? (s8vector-ref s8v4 0) -128)
(check-eqv? (s8vector-ref s8v4 1) 99)

(check-eqv? (s8vector-ref s8v5 0) 127)
(check-eqv? (s8vector-ref s8v5 1) 99)

(check-eqv? (s8vector-length s8v2) 5)
(check-eqv? (s8vector-length s8v3) 2)
(check-eqv? (s8vector-length s8v4) 2)
(check-eqv? (s8vector-length s8v5) 2)

(check-tail-exn type-exception? (lambda () (s8vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (s8vector 11 -129 22)))
(check-tail-exn type-exception? (lambda () (s8vector 11 128 22)))

(check-tail-exn type-exception? (lambda () (make-s8vector bool)))
(check-tail-exn type-exception? (lambda () (make-s8vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 -129)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 128)))
(check-tail-exn range-exception? (lambda () (make-s8vector -1 00000)))

(check-tail-exn type-exception? (lambda () (s8vector-length bool)))

(check-tail-exn type-exception? (lambda () (s8vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s8vector bool)))

(check-tail-exn type-exception? (lambda () (s8vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s8vector-ref s8v2 bool)))
(check-tail-exn range-exception? (lambda () (s8vector-ref s8v2 -1)))
(check-tail-exn range-exception? (lambda () (s8vector-ref s8v2 5)))

(check-tail-exn type-exception? (lambda () (s8vector-set! bool 00000 11)))
(check-tail-exn type-exception? (lambda () (s8vector-set! s8v2 bool 11)))
(check-tail-exn type-exception? (lambda () (s8vector-set! s8v2 00000 bool)))
(check-tail-exn type-exception? (lambda () (s8vector-set! s8v2 00000 -129)))
(check-tail-exn type-exception? (lambda () (s8vector-set! s8v2 00000 128)))
(check-tail-exn range-exception? (lambda () (s8vector-set! s8v2 -1 00000)))
(check-tail-exn range-exception? (lambda () (s8vector-set! s8v2 5 00000)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s8vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list s8v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list s8v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list s8v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s8vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref s8v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref s8v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! s8v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! s8v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! s8v5 0 00000 0)))

(check-tail-exn range-exception? (lambda () (make-s8vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; u8vectors

(define u8v1 '#u8(0 255))
(define u8v2 (u8vector 0 255 0 1 255))
(define u8v3 (make-u8vector 2))
(define u8v4 (make-u8vector 2 0))
(define u8v5 (make-u8vector 2 255))

(check-true (u8vector? u8v1))
(check-true (u8vector? '#u8()))
(check-true (u8vector? '#u8(11)))
(check-true (u8vector? '#u8(11 22)))
(check-true (u8vector? '#u8(11 22 33)))
(check-true (u8vector? '#u8(11 22 33 44)))
(check-true (u8vector? '#u8(11 22 33 44 55)))

(check-true (u8vector? u8v2))
(check-true (u8vector? (u8vector)))
(check-true (u8vector? (u8vector 11)))
(check-true (u8vector? (u8vector 11 22)))
(check-true (u8vector? (u8vector 11 22 33)))
(check-true (u8vector? (u8vector 11 22 33 44)))
(check-true (u8vector? (u8vector 11 22 33 44 55)))

(check-true (u8vector? u8v3))
(check-true (u8vector? (make-u8vector 0)))
(check-true (u8vector? (make-u8vector 1)))
(check-true (u8vector? (make-u8vector 10)))
(check-true (u8vector? (make-u8vector 100)))
(check-true (u8vector? (make-u8vector 1000)))
(check-true (u8vector? (make-u8vector 10000)))

(check-true (u8vector? u8v4))
(check-true (u8vector? u8v5))
(check-true (u8vector? (make-u8vector 0 11)))
(check-true (u8vector? (make-u8vector 1 22)))
(check-true (u8vector? (make-u8vector 10 33)))
(check-true (u8vector? (make-u8vector 100 44)))
(check-true (u8vector? (make-u8vector 1000 55)))
(check-true (u8vector? (make-u8vector 10000 66)))

(check-eqv? (u8vector-length u8v1) 2)
(check-eqv? (u8vector-length '#u8()) 0)
(check-eqv? (u8vector-length '#u8(11)) 1)
(check-eqv? (u8vector-length '#u8(11 22)) 2)
(check-eqv? (u8vector-length '#u8(11 22 33)) 3)
(check-eqv? (u8vector-length '#u8(11 22 33 44)) 4)
(check-eqv? (u8vector-length '#u8(11 22 33 44 55)) 5)

(check-eqv? (u8vector-length u8v2) 5)
(check-eqv? (u8vector-length (u8vector)) 0)
(check-eqv? (u8vector-length (u8vector 11)) 1)
(check-eqv? (u8vector-length (u8vector 11 22)) 2)
(check-eqv? (u8vector-length (u8vector 11 22 33)) 3)
(check-eqv? (u8vector-length (u8vector 11 22 33 44)) 4)
(check-eqv? (u8vector-length (u8vector 11 22 33 44 55)) 5)

(check-eqv? (u8vector-length u8v3) 2)
(check-eqv? (u8vector-length (make-u8vector 0)) 0)
(check-eqv? (u8vector-length (make-u8vector 1)) 1)
(check-eqv? (u8vector-length (make-u8vector 10)) 10)
(check-eqv? (u8vector-length (make-u8vector 100)) 100)
(check-eqv? (u8vector-length (make-u8vector 1000)) 1000)
(check-eqv? (u8vector-length (make-u8vector 10000)) 10000)

(check-eqv? (u8vector-length u8v4) 2)
(check-eqv? (u8vector-length u8v5) 2)
(check-eqv? (u8vector-length (make-u8vector 0 11)) 0)
(check-eqv? (u8vector-length (make-u8vector 1 22)) 1)
(check-eqv? (u8vector-length (make-u8vector 10 33)) 10)
(check-eqv? (u8vector-length (make-u8vector 100 44)) 100)
(check-eqv? (u8vector-length (make-u8vector 1000 55)) 1000)
(check-eqv? (u8vector-length (make-u8vector 10000 66)) 10000)

(check-equal? (u8vector->list '#u8()) '())
(check-equal? (u8vector->list u8v2) '(0 255 0 1 255))
(check-equal? (u8vector->list u8v3) '(0 0))

(check-equal? (list->u8vector '()) '#u8())
(check-equal? (list->u8vector '(0 255 0 1 255)) u8v2)
(check-equal? (list->u8vector '(0 0)) u8v3)

(check-eqv? (u8vector-ref u8v1 0) 0)
(check-eqv? (u8vector-ref u8v1 1) 255)

(check-eqv? (u8vector-ref u8v2 0) 0)
(check-eqv? (u8vector-ref u8v2 1) 255)
(check-eqv? (u8vector-ref u8v2 2) 0)
(check-eqv? (u8vector-ref u8v2 3) 1)
(check-eqv? (u8vector-ref u8v2 4) 255)

(check-eqv? (u8vector-ref u8v3 0) 0)
(check-eqv? (u8vector-ref u8v3 1) 0)

(check-eqv? (u8vector-ref u8v4 0) 0)
(check-eqv? (u8vector-ref u8v4 1) 0)

(check-eqv? (u8vector-ref u8v5 0) 255)
(check-eqv? (u8vector-ref u8v5 1) 255)

(u8vector-set! u8v2 1 99)
(u8vector-set! u8v3 1 99)
(u8vector-set! u8v4 1 99)
(u8vector-set! u8v5 1 99)

(check-eqv? (u8vector-ref u8v2 0) 0)
(check-eqv? (u8vector-ref u8v2 1) 99)
(check-eqv? (u8vector-ref u8v2 2) 0)
(check-eqv? (u8vector-ref u8v2 3) 1)
(check-eqv? (u8vector-ref u8v2 4) 255)

(check-eqv? (u8vector-ref u8v3 0) 0)
(check-eqv? (u8vector-ref u8v3 1) 99)

(check-eqv? (u8vector-ref u8v4 0) 0)
(check-eqv? (u8vector-ref u8v4 1) 99)

(check-eqv? (u8vector-ref u8v5 0) 255)
(check-eqv? (u8vector-ref u8v5 1) 99)

(check-eqv? (u8vector-length u8v2) 5)
(check-eqv? (u8vector-length u8v3) 2)
(check-eqv? (u8vector-length u8v4) 2)
(check-eqv? (u8vector-length u8v5) 2)

(check-tail-exn type-exception? (lambda () (u8vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (u8vector 11 -1 22)))
(check-tail-exn type-exception? (lambda () (u8vector 11 256 22)))

(check-tail-exn type-exception? (lambda () (make-u8vector bool)))
(check-tail-exn type-exception? (lambda () (make-u8vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u8vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-u8vector 11 -1)))
(check-tail-exn type-exception? (lambda () (make-u8vector 11 256)))
(check-tail-exn range-exception? (lambda () (make-u8vector -1 0)))

(check-tail-exn type-exception? (lambda () (u8vector-length bool)))

(check-tail-exn type-exception? (lambda () (u8vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u8vector bool)))

(check-tail-exn type-exception? (lambda () (u8vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u8vector-ref u8v2 bool)))
(check-tail-exn range-exception? (lambda () (u8vector-ref u8v2 -1)))
(check-tail-exn range-exception? (lambda () (u8vector-ref u8v2 5)))

(check-tail-exn type-exception? (lambda () (u8vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set! u8v2 bool 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set! u8v2 0 bool)))
(check-tail-exn type-exception? (lambda () (u8vector-set! u8v2 0 -1)))
(check-tail-exn type-exception? (lambda () (u8vector-set! u8v2 0 256)))
(check-tail-exn range-exception? (lambda () (u8vector-set! u8v2 -1 0)))
(check-tail-exn range-exception? (lambda () (u8vector-set! u8v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u8vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list u8v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list u8v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list u8v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u8vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref u8v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref u8v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! u8v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! u8v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! u8v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u8vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; s16vectors

(define s16v1 '#s16(-32768 32767))
(define s16v2 (s16vector -32768 -2 0 1 32767))
(define s16v3 (make-s16vector 2))
(define s16v4 (make-s16vector 2 -32768))
(define s16v5 (make-s16vector 2 32767))

(check-true (s16vector? s16v1))
(check-true (s16vector? '#s16()))
(check-true (s16vector? '#s16(11)))
(check-true (s16vector? '#s16(11 22)))
(check-true (s16vector? '#s16(11 22 33)))
(check-true (s16vector? '#s16(11 22 33 44)))
(check-true (s16vector? '#s16(11 22 33 44 55)))

(check-true (s16vector? s16v2))
(check-true (s16vector? (s16vector)))
(check-true (s16vector? (s16vector 11)))
(check-true (s16vector? (s16vector 11 22)))
(check-true (s16vector? (s16vector 11 22 33)))
(check-true (s16vector? (s16vector 11 22 33 44)))
(check-true (s16vector? (s16vector 11 22 33 44 55)))

(check-true (s16vector? s16v3))
(check-true (s16vector? (make-s16vector 0)))
(check-true (s16vector? (make-s16vector 1)))
(check-true (s16vector? (make-s16vector 10)))
(check-true (s16vector? (make-s16vector 100)))
(check-true (s16vector? (make-s16vector 1000)))
(check-true (s16vector? (make-s16vector 10000)))

(check-true (s16vector? s16v4))
(check-true (s16vector? s16v5))
(check-true (s16vector? (make-s16vector 0 11)))
(check-true (s16vector? (make-s16vector 1 22)))
(check-true (s16vector? (make-s16vector 10 33)))
(check-true (s16vector? (make-s16vector 100 44)))
(check-true (s16vector? (make-s16vector 1000 55)))
(check-true (s16vector? (make-s16vector 10000 66)))

(check-eqv? (s16vector-length s16v1) 2)
(check-eqv? (s16vector-length '#s16()) 0)
(check-eqv? (s16vector-length '#s16(11)) 1)
(check-eqv? (s16vector-length '#s16(11 22)) 2)
(check-eqv? (s16vector-length '#s16(11 22 33)) 3)
(check-eqv? (s16vector-length '#s16(11 22 33 44)) 4)
(check-eqv? (s16vector-length '#s16(11 22 33 44 55)) 5)

(check-eqv? (s16vector-length s16v2) 5)
(check-eqv? (s16vector-length (s16vector)) 0)
(check-eqv? (s16vector-length (s16vector 11)) 1)
(check-eqv? (s16vector-length (s16vector 11 22)) 2)
(check-eqv? (s16vector-length (s16vector 11 22 33)) 3)
(check-eqv? (s16vector-length (s16vector 11 22 33 44)) 4)
(check-eqv? (s16vector-length (s16vector 11 22 33 44 55)) 5)

(check-eqv? (s16vector-length s16v3) 2)
(check-eqv? (s16vector-length (make-s16vector 0)) 0)
(check-eqv? (s16vector-length (make-s16vector 1)) 1)
(check-eqv? (s16vector-length (make-s16vector 10)) 10)
(check-eqv? (s16vector-length (make-s16vector 100)) 100)
(check-eqv? (s16vector-length (make-s16vector 1000)) 1000)
(check-eqv? (s16vector-length (make-s16vector 10000)) 10000)

(check-eqv? (s16vector-length s16v4) 2)
(check-eqv? (s16vector-length s16v5) 2)
(check-eqv? (s16vector-length (make-s16vector 0 11)) 0)
(check-eqv? (s16vector-length (make-s16vector 1 22)) 1)
(check-eqv? (s16vector-length (make-s16vector 10 33)) 10)
(check-eqv? (s16vector-length (make-s16vector 100 44)) 100)
(check-eqv? (s16vector-length (make-s16vector 1000 55)) 1000)
(check-eqv? (s16vector-length (make-s16vector 10000 66)) 10000)

(check-equal? (s16vector->list '#s16()) '())
(check-equal? (s16vector->list s16v2) '(-32768 -2 0 1 32767))
(check-equal? (s16vector->list s16v3) '(0 0))

(check-equal? (list->s16vector '()) '#s16())
(check-equal? (list->s16vector '(-32768 -2 0 1 32767)) s16v2)
(check-equal? (list->s16vector '(0 0)) s16v3)

(check-eqv? (s16vector-ref s16v1 0) -32768)
(check-eqv? (s16vector-ref s16v1 1) 32767)

(check-eqv? (s16vector-ref s16v2 0) -32768)
(check-eqv? (s16vector-ref s16v2 1) -2)
(check-eqv? (s16vector-ref s16v2 2) 0)
(check-eqv? (s16vector-ref s16v2 3) 1)
(check-eqv? (s16vector-ref s16v2 4) 32767)

(check-eqv? (s16vector-ref s16v3 0) 0)
(check-eqv? (s16vector-ref s16v3 1) 0)

(check-eqv? (s16vector-ref s16v4 0) -32768)
(check-eqv? (s16vector-ref s16v4 1) -32768)

(check-eqv? (s16vector-ref s16v5 0) 32767)
(check-eqv? (s16vector-ref s16v5 1) 32767)

(s16vector-set! s16v2 1 99)
(s16vector-set! s16v3 1 99)
(s16vector-set! s16v4 1 99)
(s16vector-set! s16v5 1 99)

(check-eqv? (s16vector-ref s16v2 0) -32768)
(check-eqv? (s16vector-ref s16v2 1) 99)
(check-eqv? (s16vector-ref s16v2 2) 0)
(check-eqv? (s16vector-ref s16v2 3) 1)
(check-eqv? (s16vector-ref s16v2 4) 32767)

(check-eqv? (s16vector-ref s16v3 0) 0)
(check-eqv? (s16vector-ref s16v3 1) 99)

(check-eqv? (s16vector-ref s16v4 0) -32768)
(check-eqv? (s16vector-ref s16v4 1) 99)

(check-eqv? (s16vector-ref s16v5 0) 32767)
(check-eqv? (s16vector-ref s16v5 1) 99)

(check-eqv? (s16vector-length s16v2) 5)
(check-eqv? (s16vector-length s16v3) 2)
(check-eqv? (s16vector-length s16v4) 2)
(check-eqv? (s16vector-length s16v5) 2)

(check-tail-exn type-exception? (lambda () (s16vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (s16vector 11 -32769 22)))
(check-tail-exn type-exception? (lambda () (s16vector 11 32768 22)))

(check-tail-exn type-exception? (lambda () (make-s16vector bool)))
(check-tail-exn type-exception? (lambda () (make-s16vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s16vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-s16vector 11 -32769)))
(check-tail-exn type-exception? (lambda () (make-s16vector 11 32768)))
(check-tail-exn range-exception? (lambda () (make-s16vector -1 0)))

(check-tail-exn type-exception? (lambda () (s16vector-length bool)))

(check-tail-exn type-exception? (lambda () (s16vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s16vector bool)))

(check-tail-exn type-exception? (lambda () (s16vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s16vector-ref s16v2 bool)))
(check-tail-exn range-exception? (lambda () (s16vector-ref s16v2 -1)))
(check-tail-exn range-exception? (lambda () (s16vector-ref s16v2 5)))

(check-tail-exn type-exception? (lambda () (s16vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set! s16v2 bool 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set! s16v2 0 bool)))
(check-tail-exn type-exception? (lambda () (s16vector-set! s16v2 0 -32769)))
(check-tail-exn type-exception? (lambda () (s16vector-set! s16v2 0 32768)))
(check-tail-exn range-exception? (lambda () (s16vector-set! s16v2 -1 0)))
(check-tail-exn range-exception? (lambda () (s16vector-set! s16v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s16vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list s16v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list s16v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list s16v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s16vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref s16v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref s16v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! s16v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! s16v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! s16v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s16vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; u16vectors

(define u16v1 '#u16(0 65535))
(define u16v2 (u16vector 0 65535 0 1 65535))
(define u16v3 (make-u16vector 2))
(define u16v4 (make-u16vector 2 0))
(define u16v5 (make-u16vector 2 65535))

(check-true (u16vector? u16v1))
(check-true (u16vector? '#u16()))
(check-true (u16vector? '#u16(11)))
(check-true (u16vector? '#u16(11 22)))
(check-true (u16vector? '#u16(11 22 33)))
(check-true (u16vector? '#u16(11 22 33 44)))
(check-true (u16vector? '#u16(11 22 33 44 55)))

(check-true (u16vector? u16v2))
(check-true (u16vector? (u16vector)))
(check-true (u16vector? (u16vector 11)))
(check-true (u16vector? (u16vector 11 22)))
(check-true (u16vector? (u16vector 11 22 33)))
(check-true (u16vector? (u16vector 11 22 33 44)))
(check-true (u16vector? (u16vector 11 22 33 44 55)))

(check-true (u16vector? u16v3))
(check-true (u16vector? (make-u16vector 0)))
(check-true (u16vector? (make-u16vector 1)))
(check-true (u16vector? (make-u16vector 10)))
(check-true (u16vector? (make-u16vector 100)))
(check-true (u16vector? (make-u16vector 1000)))
(check-true (u16vector? (make-u16vector 10000)))

(check-true (u16vector? u16v4))
(check-true (u16vector? u16v5))
(check-true (u16vector? (make-u16vector 0 11)))
(check-true (u16vector? (make-u16vector 1 22)))
(check-true (u16vector? (make-u16vector 10 33)))
(check-true (u16vector? (make-u16vector 100 44)))
(check-true (u16vector? (make-u16vector 1000 55)))
(check-true (u16vector? (make-u16vector 10000 66)))

(check-eqv? (u16vector-length u16v1) 2)
(check-eqv? (u16vector-length '#u16()) 0)
(check-eqv? (u16vector-length '#u16(11)) 1)
(check-eqv? (u16vector-length '#u16(11 22)) 2)
(check-eqv? (u16vector-length '#u16(11 22 33)) 3)
(check-eqv? (u16vector-length '#u16(11 22 33 44)) 4)
(check-eqv? (u16vector-length '#u16(11 22 33 44 55)) 5)

(check-eqv? (u16vector-length u16v2) 5)
(check-eqv? (u16vector-length (u16vector)) 0)
(check-eqv? (u16vector-length (u16vector 11)) 1)
(check-eqv? (u16vector-length (u16vector 11 22)) 2)
(check-eqv? (u16vector-length (u16vector 11 22 33)) 3)
(check-eqv? (u16vector-length (u16vector 11 22 33 44)) 4)
(check-eqv? (u16vector-length (u16vector 11 22 33 44 55)) 5)

(check-eqv? (u16vector-length u16v3) 2)
(check-eqv? (u16vector-length (make-u16vector 0)) 0)
(check-eqv? (u16vector-length (make-u16vector 1)) 1)
(check-eqv? (u16vector-length (make-u16vector 10)) 10)
(check-eqv? (u16vector-length (make-u16vector 100)) 100)
(check-eqv? (u16vector-length (make-u16vector 1000)) 1000)
(check-eqv? (u16vector-length (make-u16vector 10000)) 10000)

(check-eqv? (u16vector-length u16v4) 2)
(check-eqv? (u16vector-length u16v5) 2)
(check-eqv? (u16vector-length (make-u16vector 0 11)) 0)
(check-eqv? (u16vector-length (make-u16vector 1 22)) 1)
(check-eqv? (u16vector-length (make-u16vector 10 33)) 10)
(check-eqv? (u16vector-length (make-u16vector 100 44)) 100)
(check-eqv? (u16vector-length (make-u16vector 1000 55)) 1000)
(check-eqv? (u16vector-length (make-u16vector 10000 66)) 10000)

(check-equal? (u16vector->list '#u16()) '())
(check-equal? (u16vector->list u16v2) '(0 65535 0 1 65535))
(check-equal? (u16vector->list u16v3) '(0 0))

(check-equal? (list->u16vector '()) '#u16())
(check-equal? (list->u16vector '(0 65535 0 1 65535)) u16v2)
(check-equal? (list->u16vector '(0 0)) u16v3)

(check-eqv? (u16vector-ref u16v1 0) 0)
(check-eqv? (u16vector-ref u16v1 1) 65535)

(check-eqv? (u16vector-ref u16v2 0) 0)
(check-eqv? (u16vector-ref u16v2 1) 65535)
(check-eqv? (u16vector-ref u16v2 2) 0)
(check-eqv? (u16vector-ref u16v2 3) 1)
(check-eqv? (u16vector-ref u16v2 4) 65535)

(check-eqv? (u16vector-ref u16v3 0) 0)
(check-eqv? (u16vector-ref u16v3 1) 0)

(check-eqv? (u16vector-ref u16v4 0) 0)
(check-eqv? (u16vector-ref u16v4 1) 0)

(check-eqv? (u16vector-ref u16v5 0) 65535)
(check-eqv? (u16vector-ref u16v5 1) 65535)

(u16vector-set! u16v2 1 99)
(u16vector-set! u16v3 1 99)
(u16vector-set! u16v4 1 99)
(u16vector-set! u16v5 1 99)

(check-eqv? (u16vector-ref u16v2 0) 0)
(check-eqv? (u16vector-ref u16v2 1) 99)
(check-eqv? (u16vector-ref u16v2 2) 0)
(check-eqv? (u16vector-ref u16v2 3) 1)
(check-eqv? (u16vector-ref u16v2 4) 65535)

(check-eqv? (u16vector-ref u16v3 0) 0)
(check-eqv? (u16vector-ref u16v3 1) 99)

(check-eqv? (u16vector-ref u16v4 0) 0)
(check-eqv? (u16vector-ref u16v4 1) 99)

(check-eqv? (u16vector-ref u16v5 0) 65535)
(check-eqv? (u16vector-ref u16v5 1) 99)

(check-eqv? (u16vector-length u16v2) 5)
(check-eqv? (u16vector-length u16v3) 2)
(check-eqv? (u16vector-length u16v4) 2)
(check-eqv? (u16vector-length u16v5) 2)

(check-tail-exn type-exception? (lambda () (u16vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (u16vector 11 -1 22)))
(check-tail-exn type-exception? (lambda () (u16vector 11 65536 22)))

(check-tail-exn type-exception? (lambda () (make-u16vector bool)))
(check-tail-exn type-exception? (lambda () (make-u16vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 -1)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 65536)))
(check-tail-exn range-exception? (lambda () (make-u16vector -1 0)))

(check-tail-exn type-exception? (lambda () (u16vector-length bool)))

(check-tail-exn type-exception? (lambda () (u16vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u16vector bool)))

(check-tail-exn type-exception? (lambda () (u16vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u16vector-ref u16v2 bool)))
(check-tail-exn range-exception? (lambda () (u16vector-ref u16v2 -1)))
(check-tail-exn range-exception? (lambda () (u16vector-ref u16v2 5)))

(check-tail-exn type-exception? (lambda () (u16vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u16vector-set! u16v2 bool 11)))
(check-tail-exn type-exception? (lambda () (u16vector-set! u16v2 0 bool)))
(check-tail-exn type-exception? (lambda () (u16vector-set! u16v2 0 -1)))
(check-tail-exn type-exception? (lambda () (u16vector-set! u16v2 0 65536)))
(check-tail-exn range-exception? (lambda () (u16vector-set! u16v2 -1 0)))
(check-tail-exn range-exception? (lambda () (u16vector-set! u16v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u16vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list u16v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list u16v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list u16v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u16vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref u16v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref u16v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! u16v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! u16v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! u16v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u16vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; s32vectors

(define s32v1 '#s32(-2147483648 2147483647))
(define s32v2 (s32vector -2147483648 -2 0 1 2147483647))
(define s32v3 (make-s32vector 2))
(define s32v4 (make-s32vector 2 -2147483648))
(define s32v5 (make-s32vector 2 2147483647))

(check-true (s32vector? s32v1))
(check-true (s32vector? '#s32()))
(check-true (s32vector? '#s32(11)))
(check-true (s32vector? '#s32(11 22)))
(check-true (s32vector? '#s32(11 22 33)))
(check-true (s32vector? '#s32(11 22 33 44)))
(check-true (s32vector? '#s32(11 22 33 44 55)))

(check-true (s32vector? s32v2))
(check-true (s32vector? (s32vector)))
(check-true (s32vector? (s32vector 11)))
(check-true (s32vector? (s32vector 11 22)))
(check-true (s32vector? (s32vector 11 22 33)))
(check-true (s32vector? (s32vector 11 22 33 44)))
(check-true (s32vector? (s32vector 11 22 33 44 55)))

(check-true (s32vector? s32v3))
(check-true (s32vector? (make-s32vector 0)))
(check-true (s32vector? (make-s32vector 1)))
(check-true (s32vector? (make-s32vector 10)))
(check-true (s32vector? (make-s32vector 100)))
(check-true (s32vector? (make-s32vector 1000)))
(check-true (s32vector? (make-s32vector 10000)))

(check-true (s32vector? s32v4))
(check-true (s32vector? s32v5))
(check-true (s32vector? (make-s32vector 0 11)))
(check-true (s32vector? (make-s32vector 1 22)))
(check-true (s32vector? (make-s32vector 10 33)))
(check-true (s32vector? (make-s32vector 100 44)))
(check-true (s32vector? (make-s32vector 1000 55)))
(check-true (s32vector? (make-s32vector 10000 66)))

(check-eqv? (s32vector-length s32v1) 2)
(check-eqv? (s32vector-length '#s32()) 0)
(check-eqv? (s32vector-length '#s32(11)) 1)
(check-eqv? (s32vector-length '#s32(11 22)) 2)
(check-eqv? (s32vector-length '#s32(11 22 33)) 3)
(check-eqv? (s32vector-length '#s32(11 22 33 44)) 4)
(check-eqv? (s32vector-length '#s32(11 22 33 44 55)) 5)

(check-eqv? (s32vector-length s32v2) 5)
(check-eqv? (s32vector-length (s32vector)) 0)
(check-eqv? (s32vector-length (s32vector 11)) 1)
(check-eqv? (s32vector-length (s32vector 11 22)) 2)
(check-eqv? (s32vector-length (s32vector 11 22 33)) 3)
(check-eqv? (s32vector-length (s32vector 11 22 33 44)) 4)
(check-eqv? (s32vector-length (s32vector 11 22 33 44 55)) 5)

(check-eqv? (s32vector-length s32v3) 2)
(check-eqv? (s32vector-length (make-s32vector 0)) 0)
(check-eqv? (s32vector-length (make-s32vector 1)) 1)
(check-eqv? (s32vector-length (make-s32vector 10)) 10)
(check-eqv? (s32vector-length (make-s32vector 100)) 100)
(check-eqv? (s32vector-length (make-s32vector 1000)) 1000)
(check-eqv? (s32vector-length (make-s32vector 10000)) 10000)

(check-eqv? (s32vector-length s32v4) 2)
(check-eqv? (s32vector-length s32v5) 2)
(check-eqv? (s32vector-length (make-s32vector 0 11)) 0)
(check-eqv? (s32vector-length (make-s32vector 1 22)) 1)
(check-eqv? (s32vector-length (make-s32vector 10 33)) 10)
(check-eqv? (s32vector-length (make-s32vector 100 44)) 100)
(check-eqv? (s32vector-length (make-s32vector 1000 55)) 1000)
(check-eqv? (s32vector-length (make-s32vector 10000 66)) 10000)

(check-equal? (s32vector->list '#s32()) '())
(check-equal? (s32vector->list s32v2) '(-2147483648 -2 0 1 2147483647))
(check-equal? (s32vector->list s32v3) '(0 0))

(check-equal? (list->s32vector '()) '#s32())
(check-equal? (list->s32vector '(-2147483648 -2 0 1 2147483647)) s32v2)
(check-equal? (list->s32vector '(0 0)) s32v3)

(check-eqv? (s32vector-ref s32v1 0) -2147483648)
(check-eqv? (s32vector-ref s32v1 1) 2147483647)

(check-eqv? (s32vector-ref s32v2 0) -2147483648)
(check-eqv? (s32vector-ref s32v2 1) -2)
(check-eqv? (s32vector-ref s32v2 2) 0)
(check-eqv? (s32vector-ref s32v2 3) 1)
(check-eqv? (s32vector-ref s32v2 4) 2147483647)

(check-eqv? (s32vector-ref s32v3 0) 0)
(check-eqv? (s32vector-ref s32v3 1) 0)

(check-eqv? (s32vector-ref s32v4 0) -2147483648)
(check-eqv? (s32vector-ref s32v4 1) -2147483648)

(check-eqv? (s32vector-ref s32v5 0) 2147483647)
(check-eqv? (s32vector-ref s32v5 1) 2147483647)

(s32vector-set! s32v2 1 99)
(s32vector-set! s32v3 1 99)
(s32vector-set! s32v4 1 99)
(s32vector-set! s32v5 1 99)

(check-eqv? (s32vector-ref s32v2 0) -2147483648)
(check-eqv? (s32vector-ref s32v2 1) 99)
(check-eqv? (s32vector-ref s32v2 2) 0)
(check-eqv? (s32vector-ref s32v2 3) 1)
(check-eqv? (s32vector-ref s32v2 4) 2147483647)

(check-eqv? (s32vector-ref s32v3 0) 0)
(check-eqv? (s32vector-ref s32v3 1) 99)

(check-eqv? (s32vector-ref s32v4 0) -2147483648)
(check-eqv? (s32vector-ref s32v4 1) 99)

(check-eqv? (s32vector-ref s32v5 0) 2147483647)
(check-eqv? (s32vector-ref s32v5 1) 99)

(check-eqv? (s32vector-length s32v2) 5)
(check-eqv? (s32vector-length s32v3) 2)
(check-eqv? (s32vector-length s32v4) 2)
(check-eqv? (s32vector-length s32v5) 2)

(check-tail-exn type-exception? (lambda () (s32vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (s32vector 11 -2147483649 22)))
(check-tail-exn type-exception? (lambda () (s32vector 11 2147483648 22)))

(check-tail-exn type-exception? (lambda () (make-s32vector bool)))
(check-tail-exn type-exception? (lambda () (make-s32vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s32vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-s32vector 11 -2147483649)))
(check-tail-exn type-exception? (lambda () (make-s32vector 11 2147483648)))
(check-tail-exn range-exception? (lambda () (make-s32vector -1 0)))

(check-tail-exn type-exception? (lambda () (s32vector-length bool)))

(check-tail-exn type-exception? (lambda () (s32vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s32vector bool)))

(check-tail-exn type-exception? (lambda () (s32vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s32vector-ref s32v2 bool)))
(check-tail-exn range-exception? (lambda () (s32vector-ref s32v2 -1)))
(check-tail-exn range-exception? (lambda () (s32vector-ref s32v2 5)))

(check-tail-exn type-exception? (lambda () (s32vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set! s32v2 bool 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set! s32v2 0 bool)))
(check-tail-exn type-exception? (lambda () (s32vector-set! s32v2 0 -2147483649)))
(check-tail-exn type-exception? (lambda () (s32vector-set! s32v2 0 2147483648)))
(check-tail-exn range-exception? (lambda () (s32vector-set! s32v2 -1 0)))
(check-tail-exn range-exception? (lambda () (s32vector-set! s32v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s32vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list s32v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list s32v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list s32v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s32vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref s32v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref s32v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! s32v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! s32v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! s32v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s32vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; u32vectors

(define u32v1 '#u32(0 4294967295))
(define u32v2 (u32vector 0 4294967295 0 1 4294967295))
(define u32v3 (make-u32vector 2))
(define u32v4 (make-u32vector 2 0))
(define u32v5 (make-u32vector 2 4294967295))

(check-true (u32vector? u32v1))
(check-true (u32vector? '#u32()))
(check-true (u32vector? '#u32(11)))
(check-true (u32vector? '#u32(11 22)))
(check-true (u32vector? '#u32(11 22 33)))
(check-true (u32vector? '#u32(11 22 33 44)))
(check-true (u32vector? '#u32(11 22 33 44 55)))

(check-true (u32vector? u32v2))
(check-true (u32vector? (u32vector)))
(check-true (u32vector? (u32vector 11)))
(check-true (u32vector? (u32vector 11 22)))
(check-true (u32vector? (u32vector 11 22 33)))
(check-true (u32vector? (u32vector 11 22 33 44)))
(check-true (u32vector? (u32vector 11 22 33 44 55)))

(check-true (u32vector? u32v3))
(check-true (u32vector? (make-u32vector 0)))
(check-true (u32vector? (make-u32vector 1)))
(check-true (u32vector? (make-u32vector 10)))
(check-true (u32vector? (make-u32vector 100)))
(check-true (u32vector? (make-u32vector 1000)))
(check-true (u32vector? (make-u32vector 10000)))

(check-true (u32vector? u32v4))
(check-true (u32vector? u32v5))
(check-true (u32vector? (make-u32vector 0 11)))
(check-true (u32vector? (make-u32vector 1 22)))
(check-true (u32vector? (make-u32vector 10 33)))
(check-true (u32vector? (make-u32vector 100 44)))
(check-true (u32vector? (make-u32vector 1000 55)))
(check-true (u32vector? (make-u32vector 10000 66)))

(check-eqv? (u32vector-length u32v1) 2)
(check-eqv? (u32vector-length '#u32()) 0)
(check-eqv? (u32vector-length '#u32(11)) 1)
(check-eqv? (u32vector-length '#u32(11 22)) 2)
(check-eqv? (u32vector-length '#u32(11 22 33)) 3)
(check-eqv? (u32vector-length '#u32(11 22 33 44)) 4)
(check-eqv? (u32vector-length '#u32(11 22 33 44 55)) 5)

(check-eqv? (u32vector-length u32v2) 5)
(check-eqv? (u32vector-length (u32vector)) 0)
(check-eqv? (u32vector-length (u32vector 11)) 1)
(check-eqv? (u32vector-length (u32vector 11 22)) 2)
(check-eqv? (u32vector-length (u32vector 11 22 33)) 3)
(check-eqv? (u32vector-length (u32vector 11 22 33 44)) 4)
(check-eqv? (u32vector-length (u32vector 11 22 33 44 55)) 5)

(check-eqv? (u32vector-length u32v3) 2)
(check-eqv? (u32vector-length (make-u32vector 0)) 0)
(check-eqv? (u32vector-length (make-u32vector 1)) 1)
(check-eqv? (u32vector-length (make-u32vector 10)) 10)
(check-eqv? (u32vector-length (make-u32vector 100)) 100)
(check-eqv? (u32vector-length (make-u32vector 1000)) 1000)
(check-eqv? (u32vector-length (make-u32vector 10000)) 10000)

(check-eqv? (u32vector-length u32v4) 2)
(check-eqv? (u32vector-length u32v5) 2)
(check-eqv? (u32vector-length (make-u32vector 0 11)) 0)
(check-eqv? (u32vector-length (make-u32vector 1 22)) 1)
(check-eqv? (u32vector-length (make-u32vector 10 33)) 10)
(check-eqv? (u32vector-length (make-u32vector 100 44)) 100)
(check-eqv? (u32vector-length (make-u32vector 1000 55)) 1000)
(check-eqv? (u32vector-length (make-u32vector 10000 66)) 10000)

(check-equal? (u32vector->list '#u32()) '())
(check-equal? (u32vector->list u32v2) '(0 4294967295 0 1 4294967295))
(check-equal? (u32vector->list u32v3) '(0 0))

(check-equal? (list->u32vector '()) '#u32())
(check-equal? (list->u32vector '(0 4294967295 0 1 4294967295)) u32v2)
(check-equal? (list->u32vector '(0 0)) u32v3)

(check-eqv? (u32vector-ref u32v1 0) 0)
(check-eqv? (u32vector-ref u32v1 1) 4294967295)

(check-eqv? (u32vector-ref u32v2 0) 0)
(check-eqv? (u32vector-ref u32v2 1) 4294967295)
(check-eqv? (u32vector-ref u32v2 2) 0)
(check-eqv? (u32vector-ref u32v2 3) 1)
(check-eqv? (u32vector-ref u32v2 4) 4294967295)

(check-eqv? (u32vector-ref u32v3 0) 0)
(check-eqv? (u32vector-ref u32v3 1) 0)

(check-eqv? (u32vector-ref u32v4 0) 0)
(check-eqv? (u32vector-ref u32v4 1) 0)

(check-eqv? (u32vector-ref u32v5 0) 4294967295)
(check-eqv? (u32vector-ref u32v5 1) 4294967295)

(u32vector-set! u32v2 1 99)
(u32vector-set! u32v3 1 99)
(u32vector-set! u32v4 1 99)
(u32vector-set! u32v5 1 99)

(check-eqv? (u32vector-ref u32v2 0) 0)
(check-eqv? (u32vector-ref u32v2 1) 99)
(check-eqv? (u32vector-ref u32v2 2) 0)
(check-eqv? (u32vector-ref u32v2 3) 1)
(check-eqv? (u32vector-ref u32v2 4) 4294967295)

(check-eqv? (u32vector-ref u32v3 0) 0)
(check-eqv? (u32vector-ref u32v3 1) 99)

(check-eqv? (u32vector-ref u32v4 0) 0)
(check-eqv? (u32vector-ref u32v4 1) 99)

(check-eqv? (u32vector-ref u32v5 0) 4294967295)
(check-eqv? (u32vector-ref u32v5 1) 99)

(check-eqv? (u32vector-length u32v2) 5)
(check-eqv? (u32vector-length u32v3) 2)
(check-eqv? (u32vector-length u32v4) 2)
(check-eqv? (u32vector-length u32v5) 2)

(check-tail-exn type-exception? (lambda () (u32vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (u32vector 11 -1 22)))
(check-tail-exn type-exception? (lambda () (u32vector 11 4294967296 22)))

(check-tail-exn type-exception? (lambda () (make-u32vector bool)))
(check-tail-exn type-exception? (lambda () (make-u32vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u32vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-u32vector 11 -1)))
(check-tail-exn type-exception? (lambda () (make-u32vector 11 4294967296)))
(check-tail-exn range-exception? (lambda () (make-u32vector -1 0)))

(check-tail-exn type-exception? (lambda () (u32vector-length bool)))

(check-tail-exn type-exception? (lambda () (u32vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u32vector bool)))

(check-tail-exn type-exception? (lambda () (u32vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u32vector-ref u32v2 bool)))
(check-tail-exn range-exception? (lambda () (u32vector-ref u32v2 -1)))
(check-tail-exn range-exception? (lambda () (u32vector-ref u32v2 5)))

(check-tail-exn type-exception? (lambda () (u32vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set! u32v2 bool 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set! u32v2 0 bool)))
(check-tail-exn type-exception? (lambda () (u32vector-set! u32v2 0 -1)))
(check-tail-exn type-exception? (lambda () (u32vector-set! u32v2 0 4294967296)))
(check-tail-exn range-exception? (lambda () (u32vector-set! u32v2 -1 0)))
(check-tail-exn range-exception? (lambda () (u32vector-set! u32v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u32vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list u32v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list u32v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list u32v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u32vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref u32v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref u32v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! u32v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! u32v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! u32v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u32vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; s64vectors

(define s64v1 '#s64(-9223372036854775808 9223372036854775807))
(define s64v2 (s64vector -9223372036854775808 -2 0 1 9223372036854775807))
(define s64v3 (make-s64vector 2))
(define s64v4 (make-s64vector 2 -9223372036854775808))
(define s64v5 (make-s64vector 2 9223372036854775807))

(check-true (s64vector? s64v1))
(check-true (s64vector? '#s64()))
(check-true (s64vector? '#s64(11)))
(check-true (s64vector? '#s64(11 22)))
(check-true (s64vector? '#s64(11 22 33)))
(check-true (s64vector? '#s64(11 22 33 44)))
(check-true (s64vector? '#s64(11 22 33 44 55)))

(check-true (s64vector? s64v2))
(check-true (s64vector? (s64vector)))
(check-true (s64vector? (s64vector 11)))
(check-true (s64vector? (s64vector 11 22)))
(check-true (s64vector? (s64vector 11 22 33)))
(check-true (s64vector? (s64vector 11 22 33 44)))
(check-true (s64vector? (s64vector 11 22 33 44 55)))

(check-true (s64vector? s64v3))
(check-true (s64vector? (make-s64vector 0)))
(check-true (s64vector? (make-s64vector 1)))
(check-true (s64vector? (make-s64vector 10)))
(check-true (s64vector? (make-s64vector 100)))
(check-true (s64vector? (make-s64vector 1000)))
(check-true (s64vector? (make-s64vector 10000)))

(check-true (s64vector? s64v4))
(check-true (s64vector? s64v5))
(check-true (s64vector? (make-s64vector 0 11)))
(check-true (s64vector? (make-s64vector 1 22)))
(check-true (s64vector? (make-s64vector 10 33)))
(check-true (s64vector? (make-s64vector 100 44)))
(check-true (s64vector? (make-s64vector 1000 55)))
(check-true (s64vector? (make-s64vector 10000 66)))

(check-eqv? (s64vector-length s64v1) 2)
(check-eqv? (s64vector-length '#s64()) 0)
(check-eqv? (s64vector-length '#s64(11)) 1)
(check-eqv? (s64vector-length '#s64(11 22)) 2)
(check-eqv? (s64vector-length '#s64(11 22 33)) 3)
(check-eqv? (s64vector-length '#s64(11 22 33 44)) 4)
(check-eqv? (s64vector-length '#s64(11 22 33 44 55)) 5)

(check-eqv? (s64vector-length s64v2) 5)
(check-eqv? (s64vector-length (s64vector)) 0)
(check-eqv? (s64vector-length (s64vector 11)) 1)
(check-eqv? (s64vector-length (s64vector 11 22)) 2)
(check-eqv? (s64vector-length (s64vector 11 22 33)) 3)
(check-eqv? (s64vector-length (s64vector 11 22 33 44)) 4)
(check-eqv? (s64vector-length (s64vector 11 22 33 44 55)) 5)

(check-eqv? (s64vector-length s64v3) 2)
(check-eqv? (s64vector-length (make-s64vector 0)) 0)
(check-eqv? (s64vector-length (make-s64vector 1)) 1)
(check-eqv? (s64vector-length (make-s64vector 10)) 10)
(check-eqv? (s64vector-length (make-s64vector 100)) 100)
(check-eqv? (s64vector-length (make-s64vector 1000)) 1000)
(check-eqv? (s64vector-length (make-s64vector 10000)) 10000)

(check-eqv? (s64vector-length s64v4) 2)
(check-eqv? (s64vector-length s64v5) 2)
(check-eqv? (s64vector-length (make-s64vector 0 11)) 0)
(check-eqv? (s64vector-length (make-s64vector 1 22)) 1)
(check-eqv? (s64vector-length (make-s64vector 10 33)) 10)
(check-eqv? (s64vector-length (make-s64vector 100 44)) 100)
(check-eqv? (s64vector-length (make-s64vector 1000 55)) 1000)
(check-eqv? (s64vector-length (make-s64vector 10000 66)) 10000)

(check-equal? (s64vector->list '#s64()) '())
(check-equal? (s64vector->list s64v2) '(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (s64vector->list s64v3) '(0 0))

(check-equal? (list->s64vector '()) '#s64())
(check-equal? (list->s64vector '(-9223372036854775808 -2 0 1 9223372036854775807)) s64v2)
(check-equal? (list->s64vector '(0 0)) s64v3)

(check-eqv? (s64vector-ref s64v1 0) -9223372036854775808)
(check-eqv? (s64vector-ref s64v1 1) 9223372036854775807)

(check-eqv? (s64vector-ref s64v2 0) -9223372036854775808)
(check-eqv? (s64vector-ref s64v2 1) -2)
(check-eqv? (s64vector-ref s64v2 2) 0)
(check-eqv? (s64vector-ref s64v2 3) 1)
(check-eqv? (s64vector-ref s64v2 4) 9223372036854775807)

(check-eqv? (s64vector-ref s64v3 0) 0)
(check-eqv? (s64vector-ref s64v3 1) 0)

(check-eqv? (s64vector-ref s64v4 0) -9223372036854775808)
(check-eqv? (s64vector-ref s64v4 1) -9223372036854775808)

(check-eqv? (s64vector-ref s64v5 0) 9223372036854775807)
(check-eqv? (s64vector-ref s64v5 1) 9223372036854775807)

(s64vector-set! s64v2 1 99)
(s64vector-set! s64v3 1 99)
(s64vector-set! s64v4 1 99)
(s64vector-set! s64v5 1 99)

(check-eqv? (s64vector-ref s64v2 0) -9223372036854775808)
(check-eqv? (s64vector-ref s64v2 1) 99)
(check-eqv? (s64vector-ref s64v2 2) 0)
(check-eqv? (s64vector-ref s64v2 3) 1)
(check-eqv? (s64vector-ref s64v2 4) 9223372036854775807)

(check-eqv? (s64vector-ref s64v3 0) 0)
(check-eqv? (s64vector-ref s64v3 1) 99)

(check-eqv? (s64vector-ref s64v4 0) -9223372036854775808)
(check-eqv? (s64vector-ref s64v4 1) 99)

(check-eqv? (s64vector-ref s64v5 0) 9223372036854775807)
(check-eqv? (s64vector-ref s64v5 1) 99)

(check-eqv? (s64vector-length s64v2) 5)
(check-eqv? (s64vector-length s64v3) 2)
(check-eqv? (s64vector-length s64v4) 2)
(check-eqv? (s64vector-length s64v5) 2)

(check-tail-exn type-exception? (lambda () (s64vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (s64vector 11 -9223372036854775809 22)))
(check-tail-exn type-exception? (lambda () (s64vector 11 9223372036854775808 22)))

(check-tail-exn type-exception? (lambda () (make-s64vector bool)))
(check-tail-exn type-exception? (lambda () (make-s64vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s64vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-s64vector 11 -9223372036854775809)))
(check-tail-exn type-exception? (lambda () (make-s64vector 11 9223372036854775808)))
(check-tail-exn range-exception? (lambda () (make-s64vector -1 0)))

(check-tail-exn type-exception? (lambda () (s64vector-length bool)))

(check-tail-exn type-exception? (lambda () (s64vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s64vector bool)))

(check-tail-exn type-exception? (lambda () (s64vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s64vector-ref s64v2 bool)))
(check-tail-exn range-exception? (lambda () (s64vector-ref s64v2 -1)))
(check-tail-exn range-exception? (lambda () (s64vector-ref s64v2 5)))

(check-tail-exn type-exception? (lambda () (s64vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set! s64v2 bool 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set! s64v2 0 bool)))
(check-tail-exn type-exception? (lambda () (s64vector-set! s64v2 0 -9223372036854775809)))
(check-tail-exn type-exception? (lambda () (s64vector-set! s64v2 0 9223372036854775808)))
(check-tail-exn range-exception? (lambda () (s64vector-set! s64v2 -1 0)))
(check-tail-exn range-exception? (lambda () (s64vector-set! s64v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s64vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list s64v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list s64v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list s64v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s64vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref s64v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref s64v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! s64v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! s64v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! s64v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s64vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; u64vectors

(define u64v1 '#u64(0 18446744073709551615))
(define u64v2 (u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define u64v3 (make-u64vector 2))
(define u64v4 (make-u64vector 2 0))
(define u64v5 (make-u64vector 2 18446744073709551615))

(check-true (u64vector? u64v1))
(check-true (u64vector? '#u64()))
(check-true (u64vector? '#u64(11)))
(check-true (u64vector? '#u64(11 22)))
(check-true (u64vector? '#u64(11 22 33)))
(check-true (u64vector? '#u64(11 22 33 44)))
(check-true (u64vector? '#u64(11 22 33 44 55)))

(check-true (u64vector? u64v2))
(check-true (u64vector? (u64vector)))
(check-true (u64vector? (u64vector 11)))
(check-true (u64vector? (u64vector 11 22)))
(check-true (u64vector? (u64vector 11 22 33)))
(check-true (u64vector? (u64vector 11 22 33 44)))
(check-true (u64vector? (u64vector 11 22 33 44 55)))

(check-true (u64vector? u64v3))
(check-true (u64vector? (make-u64vector 0)))
(check-true (u64vector? (make-u64vector 1)))
(check-true (u64vector? (make-u64vector 10)))
(check-true (u64vector? (make-u64vector 100)))
(check-true (u64vector? (make-u64vector 1000)))
(check-true (u64vector? (make-u64vector 10000)))

(check-true (u64vector? u64v4))
(check-true (u64vector? u64v5))
(check-true (u64vector? (make-u64vector 0 11)))
(check-true (u64vector? (make-u64vector 1 22)))
(check-true (u64vector? (make-u64vector 10 33)))
(check-true (u64vector? (make-u64vector 100 44)))
(check-true (u64vector? (make-u64vector 1000 55)))
(check-true (u64vector? (make-u64vector 10000 66)))

(check-eqv? (u64vector-length u64v1) 2)
(check-eqv? (u64vector-length '#u64()) 0)
(check-eqv? (u64vector-length '#u64(11)) 1)
(check-eqv? (u64vector-length '#u64(11 22)) 2)
(check-eqv? (u64vector-length '#u64(11 22 33)) 3)
(check-eqv? (u64vector-length '#u64(11 22 33 44)) 4)
(check-eqv? (u64vector-length '#u64(11 22 33 44 55)) 5)

(check-eqv? (u64vector-length u64v2) 5)
(check-eqv? (u64vector-length (u64vector)) 0)
(check-eqv? (u64vector-length (u64vector 11)) 1)
(check-eqv? (u64vector-length (u64vector 11 22)) 2)
(check-eqv? (u64vector-length (u64vector 11 22 33)) 3)
(check-eqv? (u64vector-length (u64vector 11 22 33 44)) 4)
(check-eqv? (u64vector-length (u64vector 11 22 33 44 55)) 5)

(check-eqv? (u64vector-length u64v3) 2)
(check-eqv? (u64vector-length (make-u64vector 0)) 0)
(check-eqv? (u64vector-length (make-u64vector 1)) 1)
(check-eqv? (u64vector-length (make-u64vector 10)) 10)
(check-eqv? (u64vector-length (make-u64vector 100)) 100)
(check-eqv? (u64vector-length (make-u64vector 1000)) 1000)
(check-eqv? (u64vector-length (make-u64vector 10000)) 10000)

(check-eqv? (u64vector-length u64v4) 2)
(check-eqv? (u64vector-length u64v5) 2)
(check-eqv? (u64vector-length (make-u64vector 0 11)) 0)
(check-eqv? (u64vector-length (make-u64vector 1 22)) 1)
(check-eqv? (u64vector-length (make-u64vector 10 33)) 10)
(check-eqv? (u64vector-length (make-u64vector 100 44)) 100)
(check-eqv? (u64vector-length (make-u64vector 1000 55)) 1000)
(check-eqv? (u64vector-length (make-u64vector 10000 66)) 10000)

(check-equal? (u64vector->list '#u64()) '())
(check-equal? (u64vector->list u64v2) '(0 18446744073709551615 0 1 18446744073709551615))
(check-equal? (u64vector->list u64v3) '(0 0))

(check-equal? (list->u64vector '()) '#u64())
(check-equal? (list->u64vector '(0 18446744073709551615 0 1 18446744073709551615)) u64v2)
(check-equal? (list->u64vector '(0 0)) u64v3)

(check-eqv? (u64vector-ref u64v1 0) 0)
(check-eqv? (u64vector-ref u64v1 1) 18446744073709551615)

(check-eqv? (u64vector-ref u64v2 0) 0)
(check-eqv? (u64vector-ref u64v2 1) 18446744073709551615)
(check-eqv? (u64vector-ref u64v2 2) 0)
(check-eqv? (u64vector-ref u64v2 3) 1)
(check-eqv? (u64vector-ref u64v2 4) 18446744073709551615)

(check-eqv? (u64vector-ref u64v3 0) 0)
(check-eqv? (u64vector-ref u64v3 1) 0)

(check-eqv? (u64vector-ref u64v4 0) 0)
(check-eqv? (u64vector-ref u64v4 1) 0)

(check-eqv? (u64vector-ref u64v5 0) 18446744073709551615)
(check-eqv? (u64vector-ref u64v5 1) 18446744073709551615)

(u64vector-set! u64v2 1 99)
(u64vector-set! u64v3 1 99)
(u64vector-set! u64v4 1 99)
(u64vector-set! u64v5 1 99)

(check-eqv? (u64vector-ref u64v2 0) 0)
(check-eqv? (u64vector-ref u64v2 1) 99)
(check-eqv? (u64vector-ref u64v2 2) 0)
(check-eqv? (u64vector-ref u64v2 3) 1)
(check-eqv? (u64vector-ref u64v2 4) 18446744073709551615)

(check-eqv? (u64vector-ref u64v3 0) 0)
(check-eqv? (u64vector-ref u64v3 1) 99)

(check-eqv? (u64vector-ref u64v4 0) 0)
(check-eqv? (u64vector-ref u64v4 1) 99)

(check-eqv? (u64vector-ref u64v5 0) 18446744073709551615)
(check-eqv? (u64vector-ref u64v5 1) 99)

(check-eqv? (u64vector-length u64v2) 5)
(check-eqv? (u64vector-length u64v3) 2)
(check-eqv? (u64vector-length u64v4) 2)
(check-eqv? (u64vector-length u64v5) 2)

(check-tail-exn type-exception? (lambda () (u64vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (u64vector 11 -1 22)))
(check-tail-exn type-exception? (lambda () (u64vector 11 18446744073709551616 22)))

(check-tail-exn type-exception? (lambda () (make-u64vector bool)))
(check-tail-exn type-exception? (lambda () (make-u64vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u64vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-u64vector 11 -1)))
(check-tail-exn type-exception? (lambda () (make-u64vector 11 18446744073709551616)))
(check-tail-exn range-exception? (lambda () (make-u64vector -1 0)))

(check-tail-exn type-exception? (lambda () (u64vector-length bool)))

(check-tail-exn type-exception? (lambda () (u64vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u64vector bool)))

(check-tail-exn type-exception? (lambda () (u64vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u64vector-ref u64v2 bool)))
(check-tail-exn range-exception? (lambda () (u64vector-ref u64v2 -1)))
(check-tail-exn range-exception? (lambda () (u64vector-ref u64v2 5)))

(check-tail-exn type-exception? (lambda () (u64vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set! u64v2 bool 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set! u64v2 0 bool)))
(check-tail-exn type-exception? (lambda () (u64vector-set! u64v2 0 -1)))
(check-tail-exn type-exception? (lambda () (u64vector-set! u64v2 0 18446744073709551616)))
(check-tail-exn range-exception? (lambda () (u64vector-set! u64v2 -1 0)))
(check-tail-exn range-exception? (lambda () (u64vector-set! u64v2 5 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u64vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list u64v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list u64v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list u64v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u64vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref u64v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref u64v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! u64v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! u64v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! u64v5 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u64vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; f32vectors

(define f32v1 '#f32(-inf.0 +inf.0))
(define f32v2 (f32vector -inf.0 -0.0 +0.0 1.0 +inf.0))
(define f32v3 (make-f32vector 2))
(define f32v4 (make-f32vector 2 -inf.0))
(define f32v5 (make-f32vector 2 +inf.0))

(check-true (f32vector? f32v1))
(check-true (f32vector? '#f32()))
(check-true (f32vector? '#f32(11.0)))
(check-true (f32vector? '#f32(11.0 22.0)))
(check-true (f32vector? '#f32(11.0 22.0 33.0)))
(check-true (f32vector? '#f32(11.0 22.0 33.0 44.0)))
(check-true (f32vector? '#f32(11.0 22.0 33.0 44.0 55.0)))

(check-true (f32vector? f32v2))
(check-true (f32vector? (f32vector)))
(check-true (f32vector? (f32vector 11.0)))
(check-true (f32vector? (f32vector 11.0 22.0)))
(check-true (f32vector? (f32vector 11.0 22.0 33.0)))
(check-true (f32vector? (f32vector 11.0 22.0 33.0 44.0)))
(check-true (f32vector? (f32vector 11.0 22.0 33.0 44.0 55.0)))

(check-true (f32vector? f32v3))
(check-true (f32vector? (make-f32vector 0)))
(check-true (f32vector? (make-f32vector 1)))
(check-true (f32vector? (make-f32vector 10)))
(check-true (f32vector? (make-f32vector 100)))
(check-true (f32vector? (make-f32vector 1000)))
(check-true (f32vector? (make-f32vector 10000)))

(check-true (f32vector? f32v4))
(check-true (f32vector? f32v5))
(check-true (f32vector? (make-f32vector 0 11.0)))
(check-true (f32vector? (make-f32vector 1 22.0)))
(check-true (f32vector? (make-f32vector 10 33.0)))
(check-true (f32vector? (make-f32vector 100 44.0)))
(check-true (f32vector? (make-f32vector 1000 55.0)))
(check-true (f32vector? (make-f32vector 10000 66.0)))

(check-eqv? (f32vector-length f32v1) 2)
(check-eqv? (f32vector-length '#f32()) 0)
(check-eqv? (f32vector-length '#f32(11.0)) 1)
(check-eqv? (f32vector-length '#f32(11.0 22.0)) 2)
(check-eqv? (f32vector-length '#f32(11.0 22.0 33.0)) 3)
(check-eqv? (f32vector-length '#f32(11.0 22.0 33.0 44.0)) 4)
(check-eqv? (f32vector-length '#f32(11.0 22.0 33.0 44.0 55.0)) 5)

(check-eqv? (f32vector-length f32v2) 5)
(check-eqv? (f32vector-length (f32vector)) 0)
(check-eqv? (f32vector-length (f32vector 11.0)) 1)
(check-eqv? (f32vector-length (f32vector 11.0 22.0)) 2)
(check-eqv? (f32vector-length (f32vector 11.0 22.0 33.0)) 3)
(check-eqv? (f32vector-length (f32vector 11.0 22.0 33.0 44.0)) 4)
(check-eqv? (f32vector-length (f32vector 11.0 22.0 33.0 44.0 55.0)) 5)

(check-eqv? (f32vector-length f32v3) 2)
(check-eqv? (f32vector-length (make-f32vector 0)) 0)
(check-eqv? (f32vector-length (make-f32vector 1)) 1)
(check-eqv? (f32vector-length (make-f32vector 10)) 10)
(check-eqv? (f32vector-length (make-f32vector 100)) 100)
(check-eqv? (f32vector-length (make-f32vector 1000)) 1000)
(check-eqv? (f32vector-length (make-f32vector 10000)) 10000)

(check-eqv? (f32vector-length f32v4) 2)
(check-eqv? (f32vector-length f32v5) 2)
(check-eqv? (f32vector-length (make-f32vector 0 11.0)) 0)
(check-eqv? (f32vector-length (make-f32vector 1 22.0)) 1)
(check-eqv? (f32vector-length (make-f32vector 10 33.0)) 10)
(check-eqv? (f32vector-length (make-f32vector 100 44.0)) 100)
(check-eqv? (f32vector-length (make-f32vector 1000 55.0)) 1000)
(check-eqv? (f32vector-length (make-f32vector 10000 66.0)) 10000)

(check-equal? (f32vector->list '#f32()) '())
(check-equal? (f32vector->list f32v2) '(-inf.0 -0.0 +0.0 1.0 +inf.0))
(check-equal? (f32vector->list f32v3) '(+0.0 +0.0))

(check-equal? (list->f32vector '()) '#f32())
(check-equal? (list->f32vector '(-inf.0 -0.0 +0.0 1.0 +inf.0)) f32v2)
(check-equal? (list->f32vector '(+0.0 +0.0)) f32v3)

(check-eqv? (f32vector-ref f32v1 0) -inf.0)
(check-eqv? (f32vector-ref f32v1 1) +inf.0)

(check-eqv? (f32vector-ref f32v2 0) -inf.0)
(check-eqv? (f32vector-ref f32v2 1) -0.0)
(check-eqv? (f32vector-ref f32v2 2) +0.0)
(check-eqv? (f32vector-ref f32v2 3) 1.0)
(check-eqv? (f32vector-ref f32v2 4) +inf.0)

(check-eqv? (f32vector-ref f32v3 0) +0.0)
(check-eqv? (f32vector-ref f32v3 1) +0.0)

(check-eqv? (f32vector-ref f32v4 0) -inf.0)
(check-eqv? (f32vector-ref f32v4 1) -inf.0)

(check-eqv? (f32vector-ref f32v5 0) +inf.0)
(check-eqv? (f32vector-ref f32v5 1) +inf.0)

(f32vector-set! f32v2 1 99.0)
(f32vector-set! f32v3 1 99.0)
(f32vector-set! f32v4 1 99.0)
(f32vector-set! f32v5 1 99.0)

(check-eqv? (f32vector-ref f32v2 0) -inf.0)
(check-eqv? (f32vector-ref f32v2 1) 99.0)
(check-eqv? (f32vector-ref f32v2 2) +0.0)
(check-eqv? (f32vector-ref f32v2 3) 1.0)
(check-eqv? (f32vector-ref f32v2 4) +inf.0)

(check-eqv? (f32vector-ref f32v3 0) +0.0)
(check-eqv? (f32vector-ref f32v3 1) 99.0)

(check-eqv? (f32vector-ref f32v4 0) -inf.0)
(check-eqv? (f32vector-ref f32v4 1) 99.0)

(check-eqv? (f32vector-ref f32v5 0) +inf.0)
(check-eqv? (f32vector-ref f32v5 1) 99.0)

(check-eqv? (f32vector-length f32v2) 5)
(check-eqv? (f32vector-length f32v3) 2)
(check-eqv? (f32vector-length f32v4) 2)
(check-eqv? (f32vector-length f32v5) 2)

(check-tail-exn type-exception? (lambda () (f32vector 11.0 bool 22.0)))
(check-tail-exn type-exception? (lambda () (f32vector 11.0 -1.0-2.0i 22.0)))
(check-tail-exn type-exception? (lambda () (f32vector 11.0 1.0+2.0i 22.0)))

(check-tail-exn type-exception? (lambda () (make-f32vector bool)))
(check-tail-exn type-exception? (lambda () (make-f32vector bool 11.0)))
(check-tail-exn type-exception? (lambda () (make-f32vector 11.0 bool)))
(check-tail-exn type-exception? (lambda () (make-f32vector 11.0 -1.0-2.0i)))
(check-tail-exn type-exception? (lambda () (make-f32vector 11.0 1.0+2.0i)))
(check-tail-exn range-exception? (lambda () (make-f32vector -1 +0.0)))

(check-tail-exn type-exception? (lambda () (f32vector-length bool)))

(check-tail-exn type-exception? (lambda () (f32vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->f32vector bool)))

(check-tail-exn type-exception? (lambda () (f32vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (f32vector-ref f32v2 bool)))
(check-tail-exn range-exception? (lambda () (f32vector-ref f32v2 -1)))
(check-tail-exn range-exception? (lambda () (f32vector-ref f32v2 5)))

(check-tail-exn type-exception? (lambda () (f32vector-set! bool +0.0 11.0)))
(check-tail-exn type-exception? (lambda () (f32vector-set! f32v2 bool 11.0)))
(check-tail-exn type-exception? (lambda () (f32vector-set! f32v2 +0.0 bool)))
(check-tail-exn type-exception? (lambda () (f32vector-set! f32v2 +0.0 -1.0-2.0i)))
(check-tail-exn type-exception? (lambda () (f32vector-set! f32v2 +0.0 1.0+2.0i)))
(check-tail-exn range-exception? (lambda () (f32vector-set! f32v2 -1 +0.0)))
(check-tail-exn range-exception? (lambda () (f32vector-set! f32v2 5 +0.0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-f32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-f32vector 11.0 22.0 33.0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector->list f32v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector->list f32v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector->list f32v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->f32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->f32vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-ref f32v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-ref f32v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-set! f32v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-set! f32v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f32vector-set! f32v5 0 +0.0 0)))

(check-tail-exn range-exception? (lambda () (make-f32vector (expt 2 64))))

;;;----------------------------------------------------------------------------

;;; f64vectors

(define f64v1 '#f64(-inf.0 +inf.0))
(define f64v2 (f64vector -inf.0 -0.0 +0.0 1.0 +inf.0))
(define f64v3 (make-f64vector 2))
(define f64v4 (make-f64vector 2 -inf.0))
(define f64v5 (make-f64vector 2 +inf.0))

(check-true (f64vector? f64v1))
(check-true (f64vector? '#f64()))
(check-true (f64vector? '#f64(11.0)))
(check-true (f64vector? '#f64(11.0 22.0)))
(check-true (f64vector? '#f64(11.0 22.0 33.0)))
(check-true (f64vector? '#f64(11.0 22.0 33.0 44.0)))
(check-true (f64vector? '#f64(11.0 22.0 33.0 44.0 55.0)))

(check-true (f64vector? f64v2))
(check-true (f64vector? (f64vector)))
(check-true (f64vector? (f64vector 11.0)))
(check-true (f64vector? (f64vector 11.0 22.0)))
(check-true (f64vector? (f64vector 11.0 22.0 33.0)))
(check-true (f64vector? (f64vector 11.0 22.0 33.0 44.0)))
(check-true (f64vector? (f64vector 11.0 22.0 33.0 44.0 55.0)))

(check-true (f64vector? f64v3))
(check-true (f64vector? (make-f64vector 0)))
(check-true (f64vector? (make-f64vector 1)))
(check-true (f64vector? (make-f64vector 10)))
(check-true (f64vector? (make-f64vector 100)))
(check-true (f64vector? (make-f64vector 1000)))
(check-true (f64vector? (make-f64vector 10000)))

(check-true (f64vector? f64v4))
(check-true (f64vector? f64v5))
(check-true (f64vector? (make-f64vector 0 11.0)))
(check-true (f64vector? (make-f64vector 1 22.0)))
(check-true (f64vector? (make-f64vector 10 33.0)))
(check-true (f64vector? (make-f64vector 100 44.0)))
(check-true (f64vector? (make-f64vector 1000 55.0)))
(check-true (f64vector? (make-f64vector 10000 66.0)))

(check-eqv? (f64vector-length f64v1) 2)
(check-eqv? (f64vector-length '#f64()) 0)
(check-eqv? (f64vector-length '#f64(11.0)) 1)
(check-eqv? (f64vector-length '#f64(11.0 22.0)) 2)
(check-eqv? (f64vector-length '#f64(11.0 22.0 33.0)) 3)
(check-eqv? (f64vector-length '#f64(11.0 22.0 33.0 44.0)) 4)
(check-eqv? (f64vector-length '#f64(11.0 22.0 33.0 44.0 55.0)) 5)

(check-eqv? (f64vector-length f64v2) 5)
(check-eqv? (f64vector-length (f64vector)) 0)
(check-eqv? (f64vector-length (f64vector 11.0)) 1)
(check-eqv? (f64vector-length (f64vector 11.0 22.0)) 2)
(check-eqv? (f64vector-length (f64vector 11.0 22.0 33.0)) 3)
(check-eqv? (f64vector-length (f64vector 11.0 22.0 33.0 44.0)) 4)
(check-eqv? (f64vector-length (f64vector 11.0 22.0 33.0 44.0 55.0)) 5)

(check-eqv? (f64vector-length f64v3) 2)
(check-eqv? (f64vector-length (make-f64vector 0)) 0)
(check-eqv? (f64vector-length (make-f64vector 1)) 1)
(check-eqv? (f64vector-length (make-f64vector 10)) 10)
(check-eqv? (f64vector-length (make-f64vector 100)) 100)
(check-eqv? (f64vector-length (make-f64vector 1000)) 1000)
(check-eqv? (f64vector-length (make-f64vector 10000)) 10000)

(check-eqv? (f64vector-length f64v4) 2)
(check-eqv? (f64vector-length f64v5) 2)
(check-eqv? (f64vector-length (make-f64vector 0 11.0)) 0)
(check-eqv? (f64vector-length (make-f64vector 1 22.0)) 1)
(check-eqv? (f64vector-length (make-f64vector 10 33.0)) 10)
(check-eqv? (f64vector-length (make-f64vector 100 44.0)) 100)
(check-eqv? (f64vector-length (make-f64vector 1000 55.0)) 1000)
(check-eqv? (f64vector-length (make-f64vector 10000 66.0)) 10000)

(check-equal? (f64vector->list '#f64()) '())
(check-equal? (f64vector->list f64v2) '(-inf.0 -0.0 +0.0 1.0 +inf.0))
(check-equal? (f64vector->list f64v3) '(+0.0 +0.0))

(check-equal? (list->f64vector '()) '#f64())
(check-equal? (list->f64vector '(-inf.0 -0.0 +0.0 1.0 +inf.0)) f64v2)
(check-equal? (list->f64vector '(+0.0 +0.0)) f64v3)

(check-eqv? (f64vector-ref f64v1 0) -inf.0)
(check-eqv? (f64vector-ref f64v1 1) +inf.0)

(check-eqv? (f64vector-ref f64v2 0) -inf.0)
(check-eqv? (f64vector-ref f64v2 1) -0.0)
(check-eqv? (f64vector-ref f64v2 2) +0.0)
(check-eqv? (f64vector-ref f64v2 3) 1.0)
(check-eqv? (f64vector-ref f64v2 4) +inf.0)

(check-eqv? (f64vector-ref f64v3 0) +0.0)
(check-eqv? (f64vector-ref f64v3 1) +0.0)

(check-eqv? (f64vector-ref f64v4 0) -inf.0)
(check-eqv? (f64vector-ref f64v4 1) -inf.0)

(check-eqv? (f64vector-ref f64v5 0) +inf.0)
(check-eqv? (f64vector-ref f64v5 1) +inf.0)

(f64vector-set! f64v2 1 99.0)
(f64vector-set! f64v3 1 99.0)
(f64vector-set! f64v4 1 99.0)
(f64vector-set! f64v5 1 99.0)

(check-eqv? (f64vector-ref f64v2 0) -inf.0)
(check-eqv? (f64vector-ref f64v2 1) 99.0)
(check-eqv? (f64vector-ref f64v2 2) +0.0)
(check-eqv? (f64vector-ref f64v2 3) 1.0)
(check-eqv? (f64vector-ref f64v2 4) +inf.0)

(check-eqv? (f64vector-ref f64v3 0) +0.0)
(check-eqv? (f64vector-ref f64v3 1) 99.0)

(check-eqv? (f64vector-ref f64v4 0) -inf.0)
(check-eqv? (f64vector-ref f64v4 1) 99.0)

(check-eqv? (f64vector-ref f64v5 0) +inf.0)
(check-eqv? (f64vector-ref f64v5 1) 99.0)

(check-eqv? (f64vector-length f64v2) 5)
(check-eqv? (f64vector-length f64v3) 2)
(check-eqv? (f64vector-length f64v4) 2)
(check-eqv? (f64vector-length f64v5) 2)

(check-tail-exn type-exception? (lambda () (f64vector 11.0 bool 22.0)))
(check-tail-exn type-exception? (lambda () (f64vector 11.0 -1.0-2.0i 22.0)))
(check-tail-exn type-exception? (lambda () (f64vector 11.0 1.0+2.0i 22.0)))

(check-tail-exn type-exception? (lambda () (make-f64vector bool)))
(check-tail-exn type-exception? (lambda () (make-f64vector bool 11.0)))
(check-tail-exn type-exception? (lambda () (make-f64vector 11.0 bool)))
(check-tail-exn type-exception? (lambda () (make-f64vector 11.0 -1.0-2.0i)))
(check-tail-exn type-exception? (lambda () (make-f64vector 11.0 1.0+2.0i)))
(check-tail-exn range-exception? (lambda () (make-f64vector -1 +0.0)))

(check-tail-exn type-exception? (lambda () (f64vector-length bool)))

(check-tail-exn type-exception? (lambda () (f64vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->f64vector bool)))

(check-tail-exn type-exception? (lambda () (f64vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (f64vector-ref f64v2 bool)))
(check-tail-exn range-exception? (lambda () (f64vector-ref f64v2 -1)))
(check-tail-exn range-exception? (lambda () (f64vector-ref f64v2 5)))

(check-tail-exn type-exception? (lambda () (f64vector-set! bool +0.0 11.0)))
(check-tail-exn type-exception? (lambda () (f64vector-set! f64v2 bool 11.0)))
(check-tail-exn type-exception? (lambda () (f64vector-set! f64v2 +0.0 bool)))
(check-tail-exn type-exception? (lambda () (f64vector-set! f64v2 +0.0 -1.0-2.0i)))
(check-tail-exn type-exception? (lambda () (f64vector-set! f64v2 +0.0 1.0+2.0i)))
(check-tail-exn range-exception? (lambda () (f64vector-set! f64v2 -1 +0.0)))
(check-tail-exn range-exception? (lambda () (f64vector-set! f64v2 5 +0.0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-f64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-f64vector 11.0 22.0 33.0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector->list)))
;;Gambit accepts 2 and 3 arguments...
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector->list f64v1 0)))
;;(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector->list f64v1 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector->list f64v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->f64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->f64vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-ref f64v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-ref f64v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-set! f64v5)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-set! f64v5 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (f64vector-set! f64v5 0 +0.0 0)))

(check-tail-exn range-exception? (lambda () (make-f64vector (expt 2 64))))

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
