(include "#.scm")

;;; Test branch cuts

(check-eqv? (sqrt -1) +i)
(check-= (sqrt -1+0.i) +i)
(check-= (sqrt -1-0.i) -i)

;;; Test some exact values

(check-eqv? (sqrt -1) +i)
(check-eqv? (sqrt +2i) 1+i)
(check-eqv? (sqrt -2i) 1-i)

;;; Test that we avoid double rounding in rational sqrt

(check-eqv? (sqrt 1/7) .37796447300922725)
(check-eqv? (sqrt 3/7) .6546536707079772)
(check-eqv? (sqrt 4/7) .7559289460184545)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (sqrt #\c)))

