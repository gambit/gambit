(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#(0 255))

(define v2 (##vector 0 255 0 1 255))
(define v3 (##make-vector 2))
(define v4 (##make-vector 2 0))
(define v5 (##make-vector 2 255))

(define v6 (vector 0 255 0 1 255))
(define v7 (make-vector 2))
(define v8 (make-vector 2 0))
(define v9 (make-vector 2 255))

(check-false (##vector? str))
(check-false (##vector? int))
(check-false (##vector? bool))

(check-true (##vector? v1))
(check-true (##vector? '#()))
(check-true (##vector? '#(11)))
(check-true (##vector? '#(11 22)))
(check-true (##vector? '#(11 22 33)))
(check-true (##vector? '#(11 22 33 44)))
(check-true (##vector? '#(11 22 33 44 55)))

(check-true (##vector? v2))
(check-true (##vector? (##vector)))
(check-true (##vector? (##vector 11)))
(check-true (##vector? (##vector 11 22)))
(check-true (##vector? (##vector 11 22 33)))
(check-true (##vector? (##vector 11 22 33 44)))
(check-true (##vector? (##vector 11 22 33 44 55)))

(check-true (##vector? v3))
(check-true (##vector? (##make-vector 0)))
(check-true (##vector? (##make-vector 1)))
(check-true (##vector? (##make-vector 10)))
(check-true (##vector? (##make-vector 100)))
(check-true (##vector? (##make-vector 1000)))
(check-true (##vector? (##make-vector 10000)))

(check-true (##vector? v4))
(check-true (##vector? v5))
(check-true (##vector? (##make-vector 0 11)))
(check-true (##vector? (##make-vector 1 22)))
(check-true (##vector? (##make-vector 10 33)))
(check-true (##vector? (##make-vector 100 44)))
(check-true (##vector? (##make-vector 1000 55)))
(check-true (##vector? (##make-vector 10000 66)))

(check-eqv? (##vector-length v1) 2)
(check-eqv? (##vector-length '#()) 0)
(check-eqv? (##vector-length '#(11)) 1)
(check-eqv? (##vector-length '#(11 22)) 2)
(check-eqv? (##vector-length '#(11 22 33)) 3)
(check-eqv? (##vector-length '#(11 22 33 44)) 4)
(check-eqv? (##vector-length '#(11 22 33 44 55)) 5)

(check-eqv? (##vector-length v2) 5)
(check-eqv? (##vector-length (##vector)) 0)
(check-eqv? (##vector-length (##vector 11)) 1)
(check-eqv? (##vector-length (##vector 11 22)) 2)
(check-eqv? (##vector-length (##vector 11 22 33)) 3)
(check-eqv? (##vector-length (##vector 11 22 33 44)) 4)
(check-eqv? (##vector-length (##vector 11 22 33 44 55)) 5)

(check-eqv? (##vector-length v3) 2)
(check-eqv? (##vector-length (##make-vector 0)) 0)
(check-eqv? (##vector-length (##make-vector 1)) 1)
(check-eqv? (##vector-length (##make-vector 10)) 10)
(check-eqv? (##vector-length (##make-vector 100)) 100)
(check-eqv? (##vector-length (##make-vector 1000)) 1000)
(check-eqv? (##vector-length (##make-vector 10000)) 10000)

(check-eqv? (##vector-length v4) 2)
(check-eqv? (##vector-length v5) 2)
(check-eqv? (##vector-length (##make-vector 0 11)) 0)
(check-eqv? (##vector-length (##make-vector 1 22)) 1)
(check-eqv? (##vector-length (##make-vector 10 33)) 10)
(check-eqv? (##vector-length (##make-vector 100 44)) 100)
(check-eqv? (##vector-length (##make-vector 1000 55)) 1000)
(check-eqv? (##vector-length (##make-vector 10000 66)) 10000)

(check-eqv? (##vector-ref v1 0) 0)
(check-eqv? (##vector-ref v1 1) 255)

(check-eqv? (##vector-ref v2 0) 0)
(check-eqv? (##vector-ref v2 1) 255)
(check-eqv? (##vector-ref v2 2) 0)
(check-eqv? (##vector-ref v2 3) 1)
(check-eqv? (##vector-ref v2 4) 255)

(check-eqv? (##vector-ref v4 0) 0)
(check-eqv? (##vector-ref v4 1) 0)

(check-eqv? (##vector-ref v5 0) 255)
(check-eqv? (##vector-ref v5 1) 255)

(check-equal? (##vector-set v2 1 99) '#(0 99 0 1 255))
(check-equal? v2 '#(0 255 0 1 255))
(check-equal? (##vector-set v4 1 99) '#(0 99))
(check-equal? (##vector-set v5 1 99) '#(255 99))
(check-equal? (##vector-set '#(11 22 33) 0 99) '#(99 22 33))

(check-eq? (##vector-set! v2 1 99) v2)
(check-eq? (##vector-set! v3 1 99) v3)
(check-eq? (##vector-set! v4 1 99) v4)
(check-eq? (##vector-set! v5 1 99) v5)

(check-eqv? (##vector-ref v2 0) 0)
(check-eqv? (##vector-ref v2 1) 99)
(check-eqv? (##vector-ref v2 2) 0)
(check-eqv? (##vector-ref v2 3) 1)
(check-eqv? (##vector-ref v2 4) 255)

(check-eqv? (##vector-ref v3 1) 99)

(check-eqv? (##vector-ref v4 0) 0)
(check-eqv? (##vector-ref v4 1) 99)

(check-eqv? (##vector-ref v5 0) 255)
(check-eqv? (##vector-ref v5 1) 99)

(check-eq? (##vector-shrink! v2 3) v2)
(check-eq? (##vector-shrink! v3 1) v3)
(check-eq? (##vector-shrink! v4 0) v4)
(check-eq? (##vector-shrink! v5 2) v5)

(check-eqv? (##vector-length v2) 3)
(check-eqv? (##vector-length v3) 1)
(check-eqv? (##vector-length v4) 0)
(check-eqv? (##vector-length v5) 2)

(check-true (vector? v1))
(check-true (vector? '#()))
(check-true (vector? '#(11)))
(check-true (vector? '#(11 22)))
(check-true (vector? '#(11 22 33)))
(check-true (vector? '#(11 22 33 44)))
(check-true (vector? '#(11 22 33 44 55)))

(check-true (vector? v6))
(check-true (vector? (vector)))
(check-true (vector? (vector 11)))
(check-true (vector? (vector 11 22)))
(check-true (vector? (vector 11 22 33)))
(check-true (vector? (vector 11 22 33 44)))
(check-true (vector? (vector 11 22 33 44 55)))

(check-true (vector? v7))
(check-true (vector? (make-vector 0)))
(check-true (vector? (make-vector 1)))
(check-true (vector? (make-vector 10)))
(check-true (vector? (make-vector 100)))
(check-true (vector? (make-vector 1000)))
(check-true (vector? (make-vector 10000)))

(check-true (vector? v8))
(check-true (vector? v9))
(check-true (vector? (make-vector 0 11)))
(check-true (vector? (make-vector 1 22)))
(check-true (vector? (make-vector 10 33)))
(check-true (vector? (make-vector 100 44)))
(check-true (vector? (make-vector 1000 55)))
(check-true (vector? (make-vector 10000 66)))

(check-eqv? (vector-length v1) 2)
(check-eqv? (vector-length '#()) 0)
(check-eqv? (vector-length '#(11)) 1)
(check-eqv? (vector-length '#(11 22)) 2)
(check-eqv? (vector-length '#(11 22 33)) 3)
(check-eqv? (vector-length '#(11 22 33 44)) 4)
(check-eqv? (vector-length '#(11 22 33 44 55)) 5)

(check-eqv? (vector-length v6) 5)
(check-eqv? (vector-length (vector)) 0)
(check-eqv? (vector-length (vector 11)) 1)
(check-eqv? (vector-length (vector 11 22)) 2)
(check-eqv? (vector-length (vector 11 22 33)) 3)
(check-eqv? (vector-length (vector 11 22 33 44)) 4)
(check-eqv? (vector-length (vector 11 22 33 44 55)) 5)

(check-eqv? (vector-length v7) 2)
(check-eqv? (vector-length (make-vector 0)) 0)
(check-eqv? (vector-length (make-vector 1)) 1)
(check-eqv? (vector-length (make-vector 10)) 10)
(check-eqv? (vector-length (make-vector 100)) 100)
(check-eqv? (vector-length (make-vector 1000)) 1000)
(check-eqv? (vector-length (make-vector 10000)) 10000)

(check-eqv? (vector-length v8) 2)
(check-eqv? (vector-length v9) 2)
(check-eqv? (vector-length (make-vector 0 11)) 0)
(check-eqv? (vector-length (make-vector 1 22)) 1)
(check-eqv? (vector-length (make-vector 10 33)) 10)
(check-eqv? (vector-length (make-vector 100 44)) 100)
(check-eqv? (vector-length (make-vector 1000 55)) 1000)
(check-eqv? (vector-length (make-vector 10000 66)) 10000)

(check-equal? (vector->list '#()) '())
(check-equal? (vector->list v6) '(0 255 0 1 255))
(check-equal? (vector->list v6 0) '(0 255 0 1 255))
(check-equal? (vector->list v6 2) '(0 1 255))
(check-equal? (vector->list v6 2 4) '(0 1))
(check-equal? (vector->list v6 0 5) '(0 255 0 1 255))
(check-equal? (vector->list v7) '(0 0))

(check-equal? (list->vector '()) '#())
(check-equal? (list->vector '(0 255 0 1 255)) v6)
(check-equal? (list->vector '(0 0)) v7)

(check-equal? (vector-append) '#())
(check-equal? (vector-append v6) v6)
(check-equal? (vector-append '#(0 255) '#(0 1 255)) v6)
(check-equal? (vector-append v6 v7 v6) '#(0 255 0 1 255 0 0 0 255 0 1 255))

(check-equal? (append-vectors (list v6 v7 v6)) '#(0 255 0 1 255 0 0 0 255 0 1 255))

(check-equal? (vector-copy '#()) '#())
(check-equal? (vector-copy v6) v6)
(check-equal? (vector-copy v6 0) v6)
(check-equal? (vector-copy v6 2) '#(0 1 255))
(check-equal? (vector-copy v6 0 0) '#())
(check-equal? (vector-copy v6 4 4) '#())
(check-equal? (vector-copy v6 0 2) '#(0 255))
(check-equal? (vector-copy v6 2 4) '#(0 1))
(check-equal? (vector-copy v6 4 5) '#(255))
(check-equal? (vector-copy v6 0 5) v6)

(check-equal? (subvector v6 0 0) '#())
(check-equal? (subvector v6 4 4) '#())
(check-equal? (subvector v6 0 2) '#(0 255))
(check-equal? (subvector v6 2 4) '#(0 1))
(check-equal? (subvector v6 4 5) '#(255))
(check-equal? (subvector v6 0 5) v6)

(check-eqv? (vector-ref v1 0) 0)
(check-eqv? (vector-ref v1 1) 255)

(check-eqv? (vector-ref v6 0) 0)
(check-eqv? (vector-ref v6 1) 255)
(check-eqv? (vector-ref v6 2) 0)
(check-eqv? (vector-ref v6 3) 1)
(check-eqv? (vector-ref v6 4) 255)

(check-eqv? (vector-ref v7 0) 0)
(check-eqv? (vector-ref v7 1) 0)

(check-eqv? (vector-ref v8 0) 0)
(check-eqv? (vector-ref v8 1) 0)

(check-eqv? (vector-ref v9 0) 255)
(check-eqv? (vector-ref v9 1) 255)

(check-equal? (vector-set v6 1 99) '#(0 99 0 1 255))
(check-equal? v6 '#(0 255 0 1 255))
(check-equal? (vector-set v8 1 99) '#(0 99))
(check-equal? (vector-set v9 1 99) '#(255 99))
(check-equal? (vector-set '#(11 22 33) 0 99) '#(99 22 33))

(check-eq? (vector-set! v6 1 99) (void))
(check-eq? (vector-set! v7 1 99) (void))
(check-eq? (vector-set! v8 1 99) (void))
(check-eq? (vector-set! v9 1 99) (void))

(check-eqv? (vector-ref v6 0) 0)
(check-eqv? (vector-ref v6 1) 99)
(check-eqv? (vector-ref v6 2) 0)
(check-eqv? (vector-ref v6 3) 1)
(check-eqv? (vector-ref v6 4) 255)

(check-eqv? (vector-ref v7 0) 0)
(check-eqv? (vector-ref v7 1) 99)

(check-eqv? (vector-ref v8 0) 0)
(check-eqv? (vector-ref v8 1) 99)

(check-eqv? (vector-ref v9 0) 255)
(check-eqv? (vector-ref v9 1) 99)

(check-eq? (vector-shrink! v6 3) (void))
(check-eq? (vector-shrink! v7 1) (void))
(check-eq? (vector-shrink! v8 0) (void))
(check-eq? (vector-shrink! v9 2) (void))

(check-eqv? (vector-length v6) 3)
(check-eqv? (vector-length v7) 1)
(check-eqv? (vector-length v8) 0)
(check-eqv? (vector-length v9) 2)

(check-eq? (vector-fill! v6 0) (void))
(check-equal? v6 '#(0 0 0))

(check-eq? (vector-fill! v6 255) (void))
(check-equal? v6 '#(255 255 255))

(check-eq? (vector-fill! v6 3 1) (void))
(check-equal? v6 '#(255 3 3))

(check-eq? (vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#(99 99 3))

(check-eq? (subvector-fill! v6 0 3 9) (void))
(check-equal? v6 '#(9 9 9))

(check-eq? (subvector-fill! v6 1 2 0) (void))
(check-equal? v6 '#(9 0 9))

(check-eq? (subvector-fill! v6 1 3 255) (void))
(check-equal? v6 '#(9 255 255))

(check-eq? (subvector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#(255 99 255))

(check-eq? (subvector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#(255 255 99))

(check-eq? (vector-copy! v6 0 '#(11 22 33)) (void))
(check-equal? v6 '#(11 22 33))

(check-eq? (vector-copy! v6 2 '#(33 44) 1) (void))
(check-equal? v6 '#(11 22 44))

(check-eq? (vector-copy! v6 1 '#(55 66 77 88) 0 2) (void))
(check-equal? v6 '#(11 55 66))





(check-tail-exn type-exception? (lambda () (make-vector bool)))
(check-tail-exn type-exception? (lambda () (make-vector bool 11)))



(check-tail-exn range-exception? (lambda () (make-vector -1 0)))

(check-tail-exn type-exception? (lambda () (vector-length bool)))

(check-tail-exn type-exception? (lambda () (vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->vector bool)))

(check-tail-exn type-exception? (lambda () (vector-append bool)))
(check-tail-exn type-exception? (lambda () (vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-vectors bool)))
(check-tail-exn type-exception? (lambda () (append-vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (vector-copy bool)))
(check-tail-exn type-exception? (lambda () (vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subvector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subvector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subvector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subvector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subvector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subvector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subvector v9 0 3)))

(check-tail-exn type-exception? (lambda () (vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (vector-set v5 bool 11)))



(check-tail-exn range-exception? (lambda () (vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (vector-set! v5 bool 11)))



(check-tail-exn range-exception? (lambda () (vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (vector-fill! v5 0 0 bool)))




(check-tail-exn type-exception? (lambda () (subvector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subvector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subvector-fill! v5 0 bool 0)))



(check-tail-exn range-exception? (lambda () (subvector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subvector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subvector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subvector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subvector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subvector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subvector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subvector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subvector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subvector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subvector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-vector (expt 2 64))))
