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

(check-eqv? (sqrt 1705056691889483/8551613288065582) .4465245948075691)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (sqrt #\c)))

