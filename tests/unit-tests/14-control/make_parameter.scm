(include "#.scm")

(test-eq 7 ((make-parameter 7)))
(test-equal "top" ((make-parameter "top")))
(define p (make-parameter 1))
(test-eq 1 (p))
(p 2)
(test-eq 2 (p))
