;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 27, Sources of Random Bits

(import (srfi 27))
(import (_test))

;;;============================================================================

(test-eqv 0 (random-integer 1))

(define rand-ints
  (map (lambda (i) (random-integer 1000)) (iota 1000)))

(test-assert (>= (apply min rand-ints) 0))
(test-assert (< (apply max rand-ints) 1000))

(define rand-reals
  (map (lambda (i) (random-real)) (iota 1000)))

(test-assert (>= (apply min rand-reals) 0.0))
(test-assert (< (apply max rand-reals) 1.0))

(test-assert (random-source? default-random-source))
(test-assert (random-source? (make-random-source)))


;;;============================================================================
