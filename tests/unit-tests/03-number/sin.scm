(include "#.scm")

;;; Test special values

(check-eqv? (sin 0) 0)

;;; Test for accuracy near 0

(check-eqv? (sin 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (sin 'a)))

