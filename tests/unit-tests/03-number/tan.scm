(include "#.scm")

;;; Test special values

(check-eqv? (tan 0) 0)

;;; Test for accuracy near 0

(check-eqv? (tan 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test derived from https://github.com/racket/racket/issues/3324

(check-false (zero? (real-part (tan 20+300i))))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (tan 'a)))

