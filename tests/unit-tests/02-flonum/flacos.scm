(include "#.scm")

(test-eqv 0.0 (##flacos 1.))
(test-approximate .7853981633974483 (##flacos .7071067811865476) 1e-12) ;; pi/4
(test-approximate .5235987755982988 (##flacos .8660254037844386) 1e-12) ;; pi/6

(test-eqv 0.0 (flacos 1.))
(test-approximate .7853981633974483 (flacos .7071067811865476) 1e-12) ;; pi/4
(test-approximate .5235987755982988 (flacos .8660254037844386) 1e-12) ;; pi/6

(test-error-tail wrong-number-of-arguments-exception? (flacos))
(test-error-tail wrong-number-of-arguments-exception? (flacos 1.0 2.0))

(test-error-tail type-exception? (flacos 1))
(test-error-tail type-exception? (flacos 1/2))
(test-error-tail type-exception? (flacos 'a))
