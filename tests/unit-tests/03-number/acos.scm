(include "#.scm")

;;; Test special values

(test-eqv 0 (acos 1))

;;; Test branch cuts

(test-approximate (test-acos 2) (acos 2) 1e-12)
(test-approximate (test-acos 2+0.i) (acos 2+0.i) 1e-12)
(test-approximate (test-acos 2-0.i) (acos 2-0.i) 1e-12)
(test-approximate (test-acos -2) (acos -2) 1e-12)
(test-approximate (test-acos -2+0.i) (acos -2+0.i) 1e-12)
(test-approximate (test-acos -2-0.i) (acos -2-0.i) 1e-12)

;;; Not all implementations agree on these.

;;; The vagaries of complex multiplication and signed zeros make
;;; the " naive " test-acos give an incorrect answer.

;; (check-= (acos 1234000000.+0.i) (test-acos 1234000000.+0.i))
(test-approximate (test-acos -1234000000.-0.i) (acos -1234000000.-0.i) 1e-12)

;;; Test exceptions

(test-error-tail type-exception? (acos 'a))

