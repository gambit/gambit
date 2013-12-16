(include "#.scm")

;;; Test special values

(check-eqv? (asinh 0) 0)

;;; Test branch cuts

(check-= (asinh -2i)    (test-asinh -2i))
(check-= (asinh +0.-2i) (test-asinh 0.-2i))
(check-= (asinh -0.-2i) (test-asinh -0.-2i))
(check-= (asinh +2i)    (test-asinh +2i))
(check-= (asinh +0.+2i) (test-asinh 0.+2i))
(check-= (asinh -0.+2i) (test-asinh -0.+2i))

;;; Test for accuracy near 0

(check-eqv? (asinh 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (asinh 'a)))

