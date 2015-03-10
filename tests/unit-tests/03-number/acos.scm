(include "#.scm")

;;; Test special values

(check-eqv? (acos 1) 0)

;;; Test branch cuts

(check-= (acos 2)      (test-acos 2))
(check-= (acos 2+0.i)  (test-acos 2+0.i))
(check-= (acos 2-0.i)  (test-acos 2-0.i))
(check-= (acos -2)     (test-acos -2))
(check-= (acos -2+0.i) (test-acos -2+0.i))
(check-= (acos -2-0.i) (test-acos -2-0.i))

;;; Not all implementations agree on these.

;;; The vagaries of complex multiplication and signed zeros make
;;; the "naive" test-acos give an incorrect answer.

;; (check-= (acos 1234000000.+0.i) (test-acos 1234000000.+0.i))
(check-= (acos -1234000000.-0.i) (test-acos -1234000000.-0.i))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (acos 'a)))

