(include "#.scm")

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (make-polar 'a 2)))
(check-tail-exn type-exception? (lambda () (make-polar 2 'a)))
(check-tail-exn type-exception? (lambda () (make-polar 2 +i)))
(check-tail-exn type-exception? (lambda () (make-polar +i 2)))

