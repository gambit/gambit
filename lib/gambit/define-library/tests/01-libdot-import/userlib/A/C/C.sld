
(define-library (A C)
  (export main)

  (import (testing-env)
          (rename (.. B1)
                  (main A/B1:main))
          (prefix (.. B2)
                  A/B2-))

  (begin
    (define (main)
      (A/B1:main)
      (A/B2-main)
      (display "[A/C] main\n"))))

