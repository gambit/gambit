(include "#.scm")

(test-assert (eq? #f (processor? 0)))
(test-assert (eq? #f (processor? #f)))
(test-assert (eq? #f (processor? "hello")))

(test-assert (eq? #t (processor? (current-processor))))

(test-error-tail wrong-number-of-arguments-exception? (processor?))
(test-error-tail wrong-number-of-arguments-exception? (processor? #f #f))
