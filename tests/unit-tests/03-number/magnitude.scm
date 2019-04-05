(include "#.scm")

;;; Test special values

(check-eq? (isnan? (magnitude (make-rectangular +nan.0 (expt 2 5000)))) #t)
(check-eq? (isnan? (magnitude (make-rectangular (expt 2 5000) +nan.0))) #t)
(check-= (magnitude (make-rectangular +nan.0 +inf.0)) +inf.0)
(check-= (magnitude (make-rectangular +inf.0 +nan.0)) +inf.0)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (magnitude 'a)))

