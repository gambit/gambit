(include "#.scm")

;;; Test special values

(check-eqv? (atanh 0) 0)

;;; Test branch cuts

(check-= (atanh 2)      (test-atanh 2))
(check-= (atanh 2+0.i)  (test-atanh 2+0.i))
(check-= (atanh 2-0.i)  (test-atanh 2-0.i))
(check-= (atanh -2)     (test-atanh -2))
(check-= (atanh -2+0.i) (test-atanh -2+0.i))
(check-= (atanh -2-0.i) (test-atanh -2-0.i))

;;; Test for accuracy near 0

(check-eqv? (atanh 1e-30+1e-40i) 1e-30+1e-40i)
