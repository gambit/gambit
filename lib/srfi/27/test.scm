;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 27, Sources of Random Bits

(import (srfi 27))
(import (_test))

;;;============================================================================

(check-eqv? (random-integer 1) 0)

(define rand-ints
  (map (lambda (i) (random-integer 1000)) (iota 1000)))

(check-true (>= (apply min rand-ints) 0))
(check-true (< (apply max rand-ints) 1000))

(define rand-reals
  (map (lambda (i) (random-real)) (iota 1000)))

(check-true (>= (apply min rand-reals) 0.0))
(check-true (< (apply max rand-reals) 1.0))

(check-true (random-source? default-random-source))
(check-true (random-source? (make-random-source)))


;;;============================================================================
