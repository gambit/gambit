;;;============================================================================

;;; File: "gambit/match/match-test.scm"

;;; Copyright (c) 2008-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##import gambit/match)
(##import gambit/test)

(define (f x)
  (match (* x x)
    (0 "zero")
    (1 "one")
    (2 "two")
    (3 "three")
    (4 "four")
    (else "other")))

(check-equal? (f 0) "zero")
(check-equal? (f 1) "one")
(check-equal? (f 2) "four")
(check-equal? (f 3) "other")

(define (g x y)
  (match (cons x y)
    ((5 ,a) 0)
    ((,b 5) b)
    ((,c ,d) (+ c d))
    (,other other)))

(check-equal? (g 1 '(2)) 3)
(check-equal? (g 1 '(2 3)) '(1 2 3))
(check-equal? (g 5 '(5)) 0)
(check-equal? (g 5 '(1)) 0)
(check-equal? (g 1 '(5)) 1)

(define (h x)
  (match x
    (() 0)
    (#f 1)
    (#t 2)
    (abc 3)
    ("abc" 4)
    (123 5)
    (#\x 6)
    ((1 2 3) 7)
    (else 8)))

(check-equal? (h '()) 0)
(check-equal? (h #f) 1)
(check-equal? (h #t) 2)
(check-equal? (h 'abc) 3)
(check-equal? (h "abc") 4)
(check-equal? (h 123) 5)
(check-equal? (h #\x) 6)
(check-equal? (h '(1 2 3)) 7)
(check-equal? (h '#()) 8)

(check-equal? (match #t) #f)

;;;============================================================================
