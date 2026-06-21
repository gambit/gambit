(include "#.scm")


(test-eqv #f (##flonum? 0))
(test-eqv #t (##flonum? 0.5))
(test-eqv #f (##flonum? 1+2i))

(test-eqv #t (##flonum? +inf.0))
(test-eqv #t (##flonum? -inf.0))
(test-eqv #t (##flonum? +nan.0))


(test-eqv #f (##flonum? "test"))
(test-eqv #f (##flonum? #\a))
(test-eqv #f (##flonum? #!eof))
(test-eqv #f (##flonum? #t))
(test-eqv #f (##flonum? #f))
(test-eqv #f (##flonum? #!void))
(test-eqv #f (##flonum? '()))


(test-eqv #f (##flonum? (lambda () #f)))
(test-eqv #f (##flonum? '(1 . 2)))
(test-eqv #f (##flonum? '#(1)))
(test-eqv #f (##flonum? 'test))
(test-eqv #f (##flonum? (box 1)))



(test-eqv #f (flonum? 0))
(test-eqv #t (flonum? 0.5))
(test-eqv #f (flonum? 1+2i))

(test-eqv #t (flonum? +inf.0))
(test-eqv #t (flonum? -inf.0))
(test-eqv #t (flonum? +nan.0))



(test-eqv #f (flonum? "test"))
(test-eqv #f (flonum? #\a))
(test-eqv #f (flonum? #!eof))
(test-eqv #f (flonum? #t))
(test-eqv #f (flonum? #f))
(test-eqv #f (flonum? #!void))
(test-eqv #f (flonum? '()))


(test-eqv #f (flonum? (lambda () #f)))
(test-eqv #f (flonum? '(1 . 2)))
(test-eqv #f (flonum? '#(1)))
(test-eqv #f (flonum? 'test))
(test-eqv #f (flonum? (box 1)))

(test-error-tail wrong-number-of-arguments-exception? (flonum?))
(test-error-tail wrong-number-of-arguments-exception? (flonum? 1.0 2.0))
