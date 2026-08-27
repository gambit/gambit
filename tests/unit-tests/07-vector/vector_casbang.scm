(include "#.scm")

(define vect1 (vector 11 22 33))
(define vect2 (vector 11 22 33))

(test-equal 11 (##vector-cas! vect1 0 99 111))
(test-equal 11 (##vector-ref vect1 0))
(test-equal 11 (##vector-cas! vect1 0 99 11))
(test-equal 99 (##vector-ref vect1 0))

(test-equal 33 (##vector-cas! vect1 2 99 111))
(test-equal 33 (##vector-ref vect1 2))
(test-equal 33 (##vector-cas! vect1 2 99 33))
(test-equal 99 (##vector-ref vect1 2))

(test-equal 11 (vector-cas! vect2 0 99 111))
(test-equal 11 (vector-ref vect2 0))
(test-equal 11 (vector-cas! vect2 0 99 11))
(test-equal 99 (vector-ref vect2 0))

(test-equal 33 (vector-cas! vect2 2 99 111))
(test-equal 33 (vector-ref vect2 2))
(test-equal 33 (vector-cas! vect2 2 99 33))
(test-equal 99 (vector-ref vect2 2))

(test-error-tail type-exception? (vector-cas! #f 0 0 0))
(test-error-tail type-exception? (vector-cas! vect1 #f 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-cas!))
(test-error-tail wrong-number-of-arguments-exception? (vector-cas! vect1))
(test-error-tail wrong-number-of-arguments-exception? (vector-cas! vect1 0))
(test-error-tail wrong-number-of-arguments-exception? (vector-cas! vect1 0 0))
(test-error-tail wrong-number-of-arguments-exception? (vector-cas! vect1 0 0 0 0))
