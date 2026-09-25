(include "#.scm")

(define-values (a b) (values 1 2))
(test-equal 3 (+ a b))

(define-values (c d e) (values 1 2 3))
(test-equal 6 (+ c d e))

(define-values (f . rest) (values 1 2 3))
(test-equal 1 f)
(test-equal '(2 3) rest)
