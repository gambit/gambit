;;;============================================================================

;;; File: "extra.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Define fib here for testing speed of compiled code.

(declare (standard-bindings) (block))

(define (fib x)
  (if (< x 2)
      x
      (+ (fib (- x 1)) (fib (- x 2)))))
