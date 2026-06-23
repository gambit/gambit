(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 (vector 11 22))

(define res '())

(define (one x) (set! res (cons x res)))
(define (two x y) (set! res (cons (list x y) res)))
(define (three x y z) (set! res (cons (list x y z) res)))

(set! res '())
(test-eq (void) (vector-for-each one vect0))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each one vect1))
(test-equal '(11) res)

(set! res '())
(test-eq (void) (vector-for-each one vect2))
(test-equal '(22 11) res)

(set! res '())
(test-eq (void) (vector-for-each two vect0 vect0))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each two vect1 '#(1)))
(test-equal '((11 1)) res)

(set! res '())
(test-eq (void) (vector-for-each two vect2 '#(1 2)))
(test-equal '((22 2) (11 1)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (vector-for-each two vect2 '#(1)))
(test-equal '((11 1)) res)

(set! res '())
(test-eq (void) (vector-for-each two '#(1) vect2))
(test-equal '((1 11)) res)

(set! res '())
(test-eq (void) (vector-for-each two vect2 '#()))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each two '#() vect2))
(test-equal '() res)


(set! res '())
(test-eq (void) (vector-for-each three vect0 vect0 '#()))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each three vect1 vect1 '#(1)))
(test-equal '((11 11 1)) res)

(set! res '())
(test-eq (void) (vector-for-each three vect2 vect2 '#(1 2)))
(test-equal '((22 22 2) (11 11 1)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (vector-for-each three vect2 vect2 '#(1)))
(test-equal '((11 11 1)) res)

(set! res '())
(test-eq (void) (vector-for-each three vect2 '#(1) vect2))
(test-equal '((11 1 11)) res)

(set! res '())
(test-eq (void) (vector-for-each three '#(1) vect2 vect2))
(test-equal '((1 11 11)) res)

(set! res '())
(test-eq (void) (vector-for-each three vect2 vect2 '#()))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each three vect2 '#() vect2))
(test-equal '() res)

(set! res '())
(test-eq (void) (vector-for-each three '#() vect2 vect2))
(test-equal '() res)


(test-error-tail type-exception? (vector-for-each #f vect0))
(test-error-tail type-exception? (vector-for-each one #f))
(test-error-tail type-exception? (vector-for-each two '#(1 2) #f))
(test-error-tail type-exception? (vector-for-each two #f '#(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (vector-for-each))
(test-error-tail wrong-number-of-arguments-exception? (vector-for-each one))

(set! ##allow-length-mismatch? #f)
(test-error-tail
 length-mismatch-exception?
 (vector-for-each one '#(1) '#(1 2) '#(1)))
