(include "#.scm")

(test-eqv (test-complex-+ 1.+2.i 6.4+8.2i) (+ 1.+2.i 6.4+8.2i))
(test-eqv (test-complex-- 1.+2.i 6.4+8.2i) (- 1.+2.i 6.4+8.2i))
(test-eqv (test-complex-* 1.+2.i 64.+82.i) (* 1.+2.i 64.+82.i))

(test-eqv (test-complex-+ 1+2i 64+82i) (+ 1+2i 64+82i))
(test-eqv (test-complex-- 1+2i 64+82i) (- 1+2i 64+82i))
(test-eqv (test-complex-* 1+2i 64+82i) (* 1+2i 64+82i))
