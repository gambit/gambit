(include "#.scm")


(check-false (##flonum? 0))
(check-true  (##flonum? 0.5))
(check-false (##flonum? 1+2i))

(check-true  (##flonum? +inf.0))
(check-true  (##flonum? -inf.0))
(check-true  (##flonum? +nan.0))


(check-false (##flonum? "test"))
(check-false (##flonum? #\a))
(check-false (##flonum? #!eof))
(check-false (##flonum? #t))
(check-false (##flonum? #f))
(check-false (##flonum? #!void))
(check-false (##flonum? '()))


(check-false (##flonum? (lambda () #f)))
(check-false (##flonum? '(1 . 2)))
(check-false (##flonum? '#(1)))
(check-false (##flonum? 'test))
(check-false (##flonum? (box 1)))



(check-false (flonum? 0))
(check-true  (flonum? 0.5))
(check-false (flonum? 1+2i))

(check-true  (flonum? +inf.0))
(check-true  (flonum? -inf.0))
(check-true  (flonum? +nan.0))



(check-false (flonum? "test"))
(check-false (flonum? #\a))
(check-false (flonum? #!eof))
(check-false (flonum? #t))
(check-false (flonum? #f))
(check-false (flonum? #!void))
(check-false (flonum? '()))


(check-false (flonum? (lambda () #f)))
(check-false (flonum? '(1 . 2)))
(check-false (flonum? '#(1)))
(check-false (flonum? 'test))
(check-false (flonum? (box 1)))
