(include "#.scm")

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (make-rectangular 'a 2)))
(check-tail-exn type-exception? (lambda () (make-rectangular 2 'a)))
(check-tail-exn type-exception? (lambda () (make-rectangular 2 +i)))
(check-tail-exn type-exception? (lambda () (make-rectangular +i 2)))

