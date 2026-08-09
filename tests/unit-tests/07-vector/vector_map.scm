(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 (vector 11 22))

(define (inc x) (+ x 1))
(define add +)

(test-equal '#() (vector-map inc vect0))
(test-equal '#(12) (vector-map inc vect1))
(test-equal '#(12 23) (vector-map inc vect2))

(test-equal '#() (vector-map add vect0 '#()))
(test-equal '#(12) (vector-map add vect1 '#(1)))
(test-equal '#(12 24) (vector-map add vect2 '#(1 2)))

;; these checks verify that vectors of different lengths can be used
(test-equal '#(12) (vector-map add vect2 '#(1)))
(test-equal '#(12) (vector-map add '#(1) vect2))
(test-equal '#() (vector-map add vect2 '#()))
(test-equal '#() (vector-map add '#() vect2))

(test-equal '#() (vector-map list vect0 vect0 '#()))
(test-equal '#((11 11 1)) (vector-map list vect1 vect1 '#(1)))
(test-equal '#((11 11 1) (22 22 2)) (vector-map list vect2 vect2 '#(1 2)))

;; these checks verify that vectors of different lengths can be used
(test-equal '#((11 11 1)) (vector-map list vect2 vect2 '#(1)))
(test-equal '#((11 1 11)) (vector-map list vect2 '#(1) vect2))
(test-equal '#((1 11 11)) (vector-map list '#(1) vect2 vect2))
(test-equal '#() (vector-map list vect2 vect2 '#()))
(test-equal '#() (vector-map list vect2 '#() vect2))
(test-equal '#() (vector-map list '#() vect2 vect2))

(test-error-tail type-exception? (vector-map #f vect0))
(test-error-tail type-exception? (vector-map inc #f))
(test-error-tail type-exception? (vector-map add '#(1 2) #f))
(test-error-tail type-exception? (vector-map add #f '#(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (vector-map))
(test-error-tail wrong-number-of-arguments-exception? (vector-map inc))

(set! ##allow-length-mismatch? #f)
(test-error-tail
 length-mismatch-exception?
 (vector-map add '#(1) '#(1 2) '#(1)))
