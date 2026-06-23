(include "#.scm")

(test-assert (not (eq? #f #t)))
(test-assert (not (eq? #f (+ 3 -3))))
