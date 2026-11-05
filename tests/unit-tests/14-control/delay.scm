(include "#.scm")

(test-equal 1 (force (delay 1)))
(test-equal 3 (force (delay (+ 1 2))))
(test-equal 2 (force (delay-force (delay 2))))
(test-equal 3 (force (delay-force (delay (+ 1 2)))))

(define p (delay 9))
(test-assert (promise? p))
(test-equal 9 (force p))
(test-equal 9 (force p))
(test-assert (eq? #f (promise? 9)))

(test-eq #f (force #f))
(test-error-tail wrong-number-of-arguments-exception? (promise?))
(test-error-tail wrong-number-of-arguments-exception? (force))
(test-error-tail wrong-number-of-arguments-exception? (force 1 2))
