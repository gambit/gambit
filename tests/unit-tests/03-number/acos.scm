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
