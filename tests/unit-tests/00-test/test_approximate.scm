(include "#.scm")

(test-approximate 0 0 1e-12)
(test-approximate 0. 0 1e-12)
(test-approximate -0. 0 1e-12)
(test-approximate 1/2 .5 1e-12)
(test-approximate 1.+2.i 1+2i 1e-12)
(test-approximate
 12345678901234567891234567890
 12345678901234567891234567890
 1e-12)
