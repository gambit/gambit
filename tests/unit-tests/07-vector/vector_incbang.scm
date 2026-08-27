(include "#.scm")

(define vect1 (vector 11 22 33))
(define vect2 (vector 11 22 33))

(test-equal 11 (##vector-inc! vect1 0 1))
(test-equal 12 (##vector-ref vect1 0))

(test-equal 22 (##vector-inc! vect1 1 10))
(test-equal 32 (##vector-ref vect1 1))

(test-equal 33 (##vector-inc! vect1 2 -5))
(test-equal 28 (##vector-ref vect1 2))

(test-equal 11 (vector-inc! vect2 0))
(test-equal 12 (vector-ref vect2 0))

(test-equal 22 (vector-inc! vect2 1 10))
(test-equal 32 (vector-ref vect2 1))

(test-equal 33 (vector-inc! vect2 2 -5))
(test-equal 28 (vector-ref vect2 2))

(test-error-tail type-exception? (vector-inc! #f 0))
(test-error-tail type-exception? (vector-inc! vect1 #f))
(test-error-tail type-exception? (vector-inc! vect1 0 #f))

(test-error-tail wrong-number-of-arguments-exception? (vector-inc!))
(test-error-tail wrong-number-of-arguments-exception? (vector-inc! vect1))
(test-error-tail wrong-number-of-arguments-exception? (vector-inc! vect1 0 0 0))
