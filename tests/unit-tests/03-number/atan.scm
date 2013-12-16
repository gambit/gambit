(include "#.scm")

;;; Test special values

(check-eqv? (atan 0) 0)

;;; Test branch cuts

(check-= (atan -2i)    (test-atan -2i))
(check-= (atan +0.-2i) (test-atan 0.-2i))
(check-= (atan -0.-2i) (test-atan -0.-2i))
(check-= (atan +2i)    (test-atan +2i))
(check-= (atan +0.+2i) (test-atan 0.+2i))
(check-= (atan -0.+2i) (test-atan -0.+2i))

;;; Test for accuracy near 0

(check-eqv? (atan 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (atan 'a)))

(check-tail-exn range-exception? (lambda () (atan -i)))
(check-tail-exn range-exception? (lambda () (atan +i)))

(check-tail-exn type-exception? (lambda () (atan 'a 2)))
(check-tail-exn type-exception? (lambda () (atan 2 'a)))
(check-tail-exn type-exception? (lambda () (atan 2 +i)))
(check-tail-exn type-exception? (lambda () (atan +i 2)))

