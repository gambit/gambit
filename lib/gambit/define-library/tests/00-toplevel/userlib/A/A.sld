
(define-library (A)
  (export main)

  (import (testing-env))
  (begin
    (define (main)
      (display "[A] main\n"))))
