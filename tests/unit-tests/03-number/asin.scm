(include "#.scm")

;;; Test special values

(test-eqv 0 (asin 0))

;;; Test branch cuts

(test-approximate (test-asin 2) (asin 2) 1e-12)
(test-approximate (test-asin 2+0.i) (asin 2+0.i) 1e-12)
(test-approximate (test-asin 2-0.i) (asin 2-0.i) 1e-12)
(test-approximate (test-asin -2) (asin -2) 1e-12)
(test-approximate (test-asin -2+0.i) (asin -2+0.i) 1e-12)
(test-approximate (test-asin -2-0.i) (asin -2-0.i) 1e-12)

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (asin 1e-30+1e-40i))

;;; Not all implementations agree on these.

;;; The vagaries of complex multiplication and signed zeros make
;;; the " naive " test-asin give an incorrect answer.

;; (check-= (asin 1234000000.+0.i) (test-asin 1234000000.+0.i))
(test-approximate (test-asin -1234000000.-0.i) (asin -1234000000.-0.i) 1e-12)

;;; Test exceptions

(test-error-tail type-exception? (asin 'a))

