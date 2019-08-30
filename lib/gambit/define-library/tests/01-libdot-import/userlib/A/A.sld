
(define-library (A)
  (export main)

  (import (testing-env)
          (prefix (. C) A/C-))

  (begin
    (define (main)
      (A/C-main)
      (display "[A] main\n"))))
