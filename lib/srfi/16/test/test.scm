;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2026 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 16, Syntax for procedures of variable arity

(import (srfi 16))
(import (_test))

;;;============================================================================

(define f
  (case-lambda
    ((a b) (list 1 a 2 b))
    ((a b c d) (list 1 a 2 b 3 c 4 d))))

(define g
  (case-lambda
    ((a b) (list 1 a 2 b))
    (rest (list 'rest= rest))))

(test-equal '(1 11 2 22) (f 11 22))
(test-equal '(1 11 2 22 3 33 4 44) (f 11 22 33 44))

(test-error-tail wrong-number-of-arguments-exception? (f))
(test-error-tail wrong-number-of-arguments-exception? (f 11))
(test-error-tail wrong-number-of-arguments-exception? (f 11 22 33))
(test-error-tail wrong-number-of-arguments-exception? (f 11 22 33 44 55))
(test-error-tail wrong-number-of-arguments-exception? (f 11 22 33 44 55 66))

(test-equal '(rest= ()) (g))
(test-equal '(rest= (11)) (g 11))
(test-equal '(1 11 2 22) (g 11 22))
(test-equal '(rest= (11 22 33)) (g 11 22 33))
(test-equal '(rest= (11 22 33 44)) (g 11 22 33 44))

;;;============================================================================
