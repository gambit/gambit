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
(check-eq? (vector-for-each one vect0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each one vect1) (void))
(check-equal? res '(11))

(set! res '())
(check-eq? (vector-for-each one vect2) (void))
(check-equal? res '(22 11))

(set! res '())
(check-eq? (vector-for-each two vect0 vect0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each two vect1 '#(1)) (void))
(check-equal? res '((11 1)))

(set! res '())
(check-eq? (vector-for-each two vect2 '#(1 2)) (void))
(check-equal? res '((22 2) (11 1)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (vector-for-each two vect2 '#(1)) (void))
(check-equal? res '((11 1)))

(set! res '())
(check-eq? (vector-for-each two '#(1) vect2) (void))
(check-equal? res '((1 11)))

(set! res '())
(check-eq? (vector-for-each two vect2 '#()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each two '#() vect2) (void))
(check-equal? res '())


(set! res '())
(check-eq? (vector-for-each three vect0 vect0 '#()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each three vect1 vect1 '#(1)) (void))
(check-equal? res '((11 11 1)))

(set! res '())
(check-eq? (vector-for-each three vect2 vect2 '#(1 2)) (void))
(check-equal? res '((22 22 2) (11 11 1)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (vector-for-each three vect2 vect2 '#(1)) (void))
(check-equal? res '((11 11 1)))

(set! res '())
(check-eq? (vector-for-each three vect2 '#(1) vect2) (void))
(check-equal? res '((11 1 11)))

(set! res '())
(check-eq? (vector-for-each three '#(1) vect2 vect2) (void))
(check-equal? res '((1 11 11)))

(set! res '())
(check-eq? (vector-for-each three vect2 vect2 '#()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each three vect2 '#() vect2) (void))
(check-equal? res '())

(set! res '())
(check-eq? (vector-for-each three '#() vect2 vect2) (void))
(check-equal? res '())


(check-tail-exn type-exception? (lambda () (vector-for-each #f vect0)))
(check-tail-exn type-exception? (lambda () (vector-for-each one #f)))
(check-tail-exn type-exception? (lambda () (vector-for-each two '#(1 2) #f)))
(check-tail-exn type-exception? (lambda () (vector-for-each two #f '#(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-for-each)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-for-each one)))
