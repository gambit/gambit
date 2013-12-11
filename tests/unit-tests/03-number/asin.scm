(include "#.scm")

;;; Test special values

(check-eqv? (asin 0) 0)

;;; Test branch cuts

(check-= (asin 2)      (test-asin 2))
(check-= (asin 2+0.i)  (test-asin 2+0.i))
(check-= (asin 2-0.i)  (test-asin 2-0.i))
(check-= (asin -2)     (test-asin -2))
(check-= (asin -2+0.i) (test-asin -2+0.i))
(check-= (asin -2-0.i) (test-asin -2-0.i))

;;; Test for accuracy near 0

(check-eqv? (asin 1e-30+1e-40i) 1e-30+1e-40i)
