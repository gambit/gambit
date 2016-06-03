(include "#.scm")

(check-eqv? (+ 1.0+2.0i 6.4+8.2i) (test-complex-+ 1.0+2.0i 6.4+8.2i))
(check-eqv? (- 1.0+2.0i 6.4+8.2i) (test-complex-- 1.0+2.0i 6.4+8.2i))
(check-eqv? (* 1.0+2.0i 64.+82.i) (test-complex-* 1.0+2.0i 64.+82.i))

(check-eqv? (+ 1+2i 64+82i) (test-complex-+ 1+2i 64+82i))
(check-eqv? (- 1+2i 64+82i) (test-complex-- 1+2i 64+82i))
(check-eqv? (* 1+2i 64+82i) (test-complex-* 1+2i 64+82i))
