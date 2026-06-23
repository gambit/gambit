(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 '#(11 22))
(define vect3 '#(11 22 33))

(define (inc x) (+ x 1))
(define add +)

(test-equal #f (vector-any + vect0 vect2))
(test-equal 22 (vector-any + vect1 vect2))
(test-equal 22 (vector-any + vect3 vect2))

(test-error-tail type-exception? (vector-any #f vect0))
(test-error-tail type-exception? (vector-any inc #f))
(test-error-tail type-exception? (vector-any add '#(1 2) #f))
(test-error-tail type-exception? (vector-any add #f '#(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (vector-any))
(test-error-tail wrong-number-of-arguments-exception? (vector-any inc))

(set! ##allow-length-mismatch? #f)
(test-error-tail
 length-mismatch-exception?
 (vector-any add '#(1) '#(1 2) '#(1)))
