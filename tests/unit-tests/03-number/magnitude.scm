(include "#.scm")

;;; Test special values

(test-eq #t (isnan? (magnitude (make-rectangular +nan.0 (expt 2 5000)))))
(test-eq #t (isnan? (magnitude (make-rectangular (expt 2 5000) +nan.0))))
(test-approximate +inf.0 (magnitude (make-rectangular +nan.0 +inf.0)) 1e-12)
(test-approximate +inf.0 (magnitude (make-rectangular +inf.0 +nan.0)) 1e-12)

;;; Test exceptions

(test-error-tail type-exception? (magnitude 'a))

