;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2008-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _match)
(import _test)

(define (f x)
  (match (* x x)
    (0 "zero")
    (1 "one")
    (2 "two")
    (3 "three")
    (4 "four")
    (,other "other")))

(test-equal "zero" (f 0))
(test-equal "one" (f 1))
(test-equal "four" (f 2))
(test-equal "other" (f 3))

(define (g x y)
  (match (cons x y)
    ((5 ,a) 0)
    ((a: 5) 9)
    ((,b 5) b)
    ((,c ,d) (+ c d))
    (,other other)))

(test-equal 3 (g 1 '(2)))
(test-equal 9 (g a: '(5)))
(test-equal '(1 2 3) (g 1 '(2 3)))
(test-equal 0 (g 5 '(5)))
(test-equal 0 (g 5 '(1)))
(test-equal 1 (g 1 '(5)))

(define (h x)
  (match x
    (() 0)
    (#f 1)
    (#t 2)
    (abc 3)
    (abc: 9)
    ("abc" 4)
    (123 5)
    (#\x 6)
    ((1 2 3) 7)
    (else 8))) ;; this must match the symbol "else"

(test-equal 0 (h '()))
(test-equal 1 (h #f))
(test-equal 2 (h #t))
(test-equal 3 (h 'abc))
(test-equal 9 (h abc:))
(test-equal 4 (h "abc"))
(test-equal 5 (h 123))
(test-equal 6 (h #\x))
(test-equal 7 (h '(1 2 3)))
(test-error-tail error-exception? (h '#()))

(test-error-tail error-exception? (match #t))

;;;============================================================================
