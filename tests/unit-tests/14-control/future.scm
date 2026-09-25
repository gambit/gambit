(include "#.scm")

(test-equal 1 (touch (future 1)))
(test-equal 3 (touch (future (+ 1 2))))

(define f (future 9))
(test-equal 9 (touch f))
(test-equal 9 (touch f))

(test-error-tail wrong-number-of-arguments-exception? (touch))
(test-error-tail wrong-number-of-arguments-exception? (touch 1 2))
