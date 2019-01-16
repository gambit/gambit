(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#s32(-2147483648 2147483647))

(define v2 (##s32vector -2147483648 -2 0 1 2147483647))
(define v3 (##make-s32vector 2))
(define v4 (##make-s32vector 2 -2147483648))
(define v5 (##make-s32vector 2 2147483647))

(define v6 (s32vector -2147483648 -2 0 1 2147483647))
(define v7 (make-s32vector 2))
(define v8 (make-s32vector 2 -2147483648))
(define v9 (make-s32vector 2 2147483647))

(check-false (##s32vector? str))
(check-false (##s32vector? int))
(check-false (##s32vector? bool))

(check-true (##s32vector? v1))
(check-true (##s32vector? '#s32()))
(check-true (##s32vector? '#s32(11)))
(check-true (##s32vector? '#s32(11 22)))
(check-true (##s32vector? '#s32(11 22 33)))
(check-true (##s32vector? '#s32(11 22 33 44)))
(check-true (##s32vector? '#s32(11 22 33 44 55)))

(check-true (##s32vector? v2))
(check-true (##s32vector? (##s32vector)))
(check-true (##s32vector? (##s32vector 11)))
(check-true (##s32vector? (##s32vector 11 22)))
(check-true (##s32vector? (##s32vector 11 22 33)))
(check-true (##s32vector? (##s32vector 11 22 33 44)))
(check-true (##s32vector? (##s32vector 11 22 33 44 55)))

(check-true (##s32vector? v3))
(check-true (##s32vector? (##make-s32vector 0)))
(check-true (##s32vector? (##make-s32vector 1)))
(check-true (##s32vector? (##make-s32vector 10)))
(check-true (##s32vector? (##make-s32vector 100)))
(check-true (##s32vector? (##make-s32vector 1000)))
(check-true (##s32vector? (##make-s32vector 10000)))

(check-true (##s32vector? v4))
(check-true (##s32vector? v5))
(check-true (##s32vector? (##make-s32vector 0 11)))
(check-true (##s32vector? (##make-s32vector 1 22)))
(check-true (##s32vector? (##make-s32vector 10 33)))
(check-true (##s32vector? (##make-s32vector 100 44)))
(check-true (##s32vector? (##make-s32vector 1000 55)))
(check-true (##s32vector? (##make-s32vector 10000 66)))

(check-eqv? (##s32vector-length v1) 2)
(check-eqv? (##s32vector-length '#s32()) 0)
(check-eqv? (##s32vector-length '#s32(11)) 1)
(check-eqv? (##s32vector-length '#s32(11 22)) 2)
(check-eqv? (##s32vector-length '#s32(11 22 33)) 3)
(check-eqv? (##s32vector-length '#s32(11 22 33 44)) 4)
(check-eqv? (##s32vector-length '#s32(11 22 33 44 55)) 5)

(check-eqv? (##s32vector-length v2) 5)
(check-eqv? (##s32vector-length (##s32vector)) 0)
(check-eqv? (##s32vector-length (##s32vector 11)) 1)
(check-eqv? (##s32vector-length (##s32vector 11 22)) 2)
(check-eqv? (##s32vector-length (##s32vector 11 22 33)) 3)
(check-eqv? (##s32vector-length (##s32vector 11 22 33 44)) 4)
(check-eqv? (##s32vector-length (##s32vector 11 22 33 44 55)) 5)

(check-eqv? (##s32vector-length v3) 2)
(check-eqv? (##s32vector-length (##make-s32vector 0)) 0)
(check-eqv? (##s32vector-length (##make-s32vector 1)) 1)
(check-eqv? (##s32vector-length (##make-s32vector 10)) 10)
(check-eqv? (##s32vector-length (##make-s32vector 100)) 100)
(check-eqv? (##s32vector-length (##make-s32vector 1000)) 1000)
(check-eqv? (##s32vector-length (##make-s32vector 10000)) 10000)

(check-eqv? (##s32vector-length v4) 2)
(check-eqv? (##s32vector-length v5) 2)
(check-eqv? (##s32vector-length (##make-s32vector 0 11)) 0)
(check-eqv? (##s32vector-length (##make-s32vector 1 22)) 1)
(check-eqv? (##s32vector-length (##make-s32vector 10 33)) 10)
(check-eqv? (##s32vector-length (##make-s32vector 100 44)) 100)
(check-eqv? (##s32vector-length (##make-s32vector 1000 55)) 1000)
(check-eqv? (##s32vector-length (##make-s32vector 10000 66)) 10000)

(check-eqv? (##s32vector-ref v1 0) -2147483648)
(check-eqv? (##s32vector-ref v1 1) 2147483647)

(check-eqv? (##s32vector-ref v2 0) -2147483648)
(check-eqv? (##s32vector-ref v2 1) -2)
(check-eqv? (##s32vector-ref v2 2) 0)
(check-eqv? (##s32vector-ref v2 3) 1)
(check-eqv? (##s32vector-ref v2 4) 2147483647)

(check-eqv? (##s32vector-ref v4 0) -2147483648)
(check-eqv? (##s32vector-ref v4 1) -2147483648)

(check-eqv? (##s32vector-ref v5 0) 2147483647)
(check-eqv? (##s32vector-ref v5 1) 2147483647)

(check-equal? (##s32vector-set v2 1 99) '#s32(-2147483648 99 0 1 2147483647))
(check-equal? v2 '#s32(-2147483648 -2 0 1 2147483647))
(check-equal? (##s32vector-set v4 1 99) '#s32(-2147483648 99))
(check-equal? (##s32vector-set v5 1 99) '#s32(2147483647 99))
(check-equal? (##s32vector-set '#s32(11 22 33) 0 99) '#s32(99 22 33))

(check-eq? (##s32vector-set! v2 1 99) v2)
(check-eq? (##s32vector-set! v3 1 99) v3)
(check-eq? (##s32vector-set! v4 1 99) v4)
(check-eq? (##s32vector-set! v5 1 99) v5)

(check-eqv? (##s32vector-ref v2 0) -2147483648)
(check-eqv? (##s32vector-ref v2 1) 99)
(check-eqv? (##s32vector-ref v2 2) 0)
(check-eqv? (##s32vector-ref v2 3) 1)
(check-eqv? (##s32vector-ref v2 4) 2147483647)

(check-eqv? (##s32vector-ref v3 1) 99)

(check-eqv? (##s32vector-ref v4 0) -2147483648)
(check-eqv? (##s32vector-ref v4 1) 99)

(check-eqv? (##s32vector-ref v5 0) 2147483647)
(check-eqv? (##s32vector-ref v5 1) 99)

(check-eq? (##s32vector-shrink! v2 3) v2)
(check-eq? (##s32vector-shrink! v3 1) v3)
(check-eq? (##s32vector-shrink! v4 0) v4)
(check-eq? (##s32vector-shrink! v5 2) v5)

(check-eqv? (##s32vector-length v2) 3)
(check-eqv? (##s32vector-length v3) 1)
(check-eqv? (##s32vector-length v4) 0)
(check-eqv? (##s32vector-length v5) 2)

(check-true (s32vector? v1))
(check-true (s32vector? '#s32()))
(check-true (s32vector? '#s32(11)))
(check-true (s32vector? '#s32(11 22)))
(check-true (s32vector? '#s32(11 22 33)))
(check-true (s32vector? '#s32(11 22 33 44)))
(check-true (s32vector? '#s32(11 22 33 44 55)))

(check-true (s32vector? v6))
(check-true (s32vector? (s32vector)))
(check-true (s32vector? (s32vector 11)))
(check-true (s32vector? (s32vector 11 22)))
(check-true (s32vector? (s32vector 11 22 33)))
(check-true (s32vector? (s32vector 11 22 33 44)))
(check-true (s32vector? (s32vector 11 22 33 44 55)))

(check-true (s32vector? v7))
(check-true (s32vector? (make-s32vector 0)))
(check-true (s32vector? (make-s32vector 1)))
(check-true (s32vector? (make-s32vector 10)))
(check-true (s32vector? (make-s32vector 100)))
(check-true (s32vector? (make-s32vector 1000)))
(check-true (s32vector? (make-s32vector 10000)))

(check-true (s32vector? v8))
(check-true (s32vector? v9))
(check-true (s32vector? (make-s32vector 0 11)))
(check-true (s32vector? (make-s32vector 1 22)))
(check-true (s32vector? (make-s32vector 10 33)))
(check-true (s32vector? (make-s32vector 100 44)))
(check-true (s32vector? (make-s32vector 1000 55)))
(check-true (s32vector? (make-s32vector 10000 66)))

(check-eqv? (s32vector-length v1) 2)
(check-eqv? (s32vector-length '#s32()) 0)
(check-eqv? (s32vector-length '#s32(11)) 1)
(check-eqv? (s32vector-length '#s32(11 22)) 2)
(check-eqv? (s32vector-length '#s32(11 22 33)) 3)
(check-eqv? (s32vector-length '#s32(11 22 33 44)) 4)
(check-eqv? (s32vector-length '#s32(11 22 33 44 55)) 5)

(check-eqv? (s32vector-length v6) 5)
(check-eqv? (s32vector-length (s32vector)) 0)
(check-eqv? (s32vector-length (s32vector 11)) 1)
(check-eqv? (s32vector-length (s32vector 11 22)) 2)
(check-eqv? (s32vector-length (s32vector 11 22 33)) 3)
(check-eqv? (s32vector-length (s32vector 11 22 33 44)) 4)
(check-eqv? (s32vector-length (s32vector 11 22 33 44 55)) 5)

(check-eqv? (s32vector-length v7) 2)
(check-eqv? (s32vector-length (make-s32vector 0)) 0)
(check-eqv? (s32vector-length (make-s32vector 1)) 1)
(check-eqv? (s32vector-length (make-s32vector 10)) 10)
(check-eqv? (s32vector-length (make-s32vector 100)) 100)
(check-eqv? (s32vector-length (make-s32vector 1000)) 1000)
(check-eqv? (s32vector-length (make-s32vector 10000)) 10000)

(check-eqv? (s32vector-length v8) 2)
(check-eqv? (s32vector-length v9) 2)
(check-eqv? (s32vector-length (make-s32vector 0 11)) 0)
(check-eqv? (s32vector-length (make-s32vector 1 22)) 1)
(check-eqv? (s32vector-length (make-s32vector 10 33)) 10)
(check-eqv? (s32vector-length (make-s32vector 100 44)) 100)
(check-eqv? (s32vector-length (make-s32vector 1000 55)) 1000)
(check-eqv? (s32vector-length (make-s32vector 10000 66)) 10000)

(check-equal? (s32vector->list '#s32()) '())
(check-equal? (s32vector->list v6) '(-2147483648 -2 0 1 2147483647))
(check-equal? (s32vector->list v6 0) '(-2147483648 -2 0 1 2147483647))
(check-equal? (s32vector->list v6 2) '(0 1 2147483647))
(check-equal? (s32vector->list v6 2 4) '(0 1))
(check-equal? (s32vector->list v6 0 5) '(-2147483648 -2 0 1 2147483647))
(check-equal? (s32vector->list v7) '(0 0))

(check-equal? (list->s32vector '()) '#s32())
(check-equal? (list->s32vector '(-2147483648 -2 0 1 2147483647)) v6)
(check-equal? (list->s32vector '(0 0)) v7)

(check-equal? (s32vector-append) '#s32())
(check-equal? (s32vector-append v6) v6)
(check-equal? (s32vector-append '#s32(-2147483648 -2) '#s32(0 1 2147483647)) v6)
(check-equal? (s32vector-append v6 v7 v6) '#s32(-2147483648 -2 0 1 2147483647 0 0 -2147483648 -2 0 1 2147483647))

(check-equal? (append-s32vectors (list v6 v7 v6)) '#s32(-2147483648 -2 0 1 2147483647 0 0 -2147483648 -2 0 1 2147483647))

(check-equal? (s32vector-copy '#s32()) '#s32())
(check-equal? (s32vector-copy v6) v6)
(check-equal? (s32vector-copy v6 0) v6)
(check-equal? (s32vector-copy v6 2) '#s32(0 1 2147483647))
(check-equal? (s32vector-copy v6 0 0) '#s32())
(check-equal? (s32vector-copy v6 4 4) '#s32())
(check-equal? (s32vector-copy v6 0 2) '#s32(-2147483648 -2))
(check-equal? (s32vector-copy v6 2 4) '#s32(0 1))
(check-equal? (s32vector-copy v6 4 5) '#s32(2147483647))
(check-equal? (s32vector-copy v6 0 5) v6)

(check-equal? (subs32vector v6 0 0) '#s32())
(check-equal? (subs32vector v6 4 4) '#s32())
(check-equal? (subs32vector v6 0 2) '#s32(-2147483648 -2))
(check-equal? (subs32vector v6 2 4) '#s32(0 1))
(check-equal? (subs32vector v6 4 5) '#s32(2147483647))
(check-equal? (subs32vector v6 0 5) v6)

(check-eqv? (s32vector-ref v1 0) -2147483648)
(check-eqv? (s32vector-ref v1 1) 2147483647)

(check-eqv? (s32vector-ref v6 0) -2147483648)
(check-eqv? (s32vector-ref v6 1) -2)
(check-eqv? (s32vector-ref v6 2) 0)
(check-eqv? (s32vector-ref v6 3) 1)
(check-eqv? (s32vector-ref v6 4) 2147483647)

(check-eqv? (s32vector-ref v7 0) 0)
(check-eqv? (s32vector-ref v7 1) 0)

(check-eqv? (s32vector-ref v8 0) -2147483648)
(check-eqv? (s32vector-ref v8 1) -2147483648)

(check-eqv? (s32vector-ref v9 0) 2147483647)
(check-eqv? (s32vector-ref v9 1) 2147483647)

(check-equal? (s32vector-set v6 1 99) '#s32(-2147483648 99 0 1 2147483647))
(check-equal? v6 '#s32(-2147483648 -2 0 1 2147483647))
(check-equal? (s32vector-set v8 1 99) '#s32(-2147483648 99))
(check-equal? (s32vector-set v9 1 99) '#s32(2147483647 99))
(check-equal? (s32vector-set '#s32(11 22 33) 0 99) '#s32(99 22 33))

(check-eq? (s32vector-set! v6 1 99) (void))
(check-eq? (s32vector-set! v7 1 99) (void))
(check-eq? (s32vector-set! v8 1 99) (void))
(check-eq? (s32vector-set! v9 1 99) (void))

(check-eqv? (s32vector-ref v6 0) -2147483648)
(check-eqv? (s32vector-ref v6 1) 99)
(check-eqv? (s32vector-ref v6 2) 0)
(check-eqv? (s32vector-ref v6 3) 1)
(check-eqv? (s32vector-ref v6 4) 2147483647)

(check-eqv? (s32vector-ref v7 0) 0)
(check-eqv? (s32vector-ref v7 1) 99)

(check-eqv? (s32vector-ref v8 0) -2147483648)
(check-eqv? (s32vector-ref v8 1) 99)

(check-eqv? (s32vector-ref v9 0) 2147483647)
(check-eqv? (s32vector-ref v9 1) 99)

(check-eq? (s32vector-shrink! v6 3) (void))
(check-eq? (s32vector-shrink! v7 1) (void))
(check-eq? (s32vector-shrink! v8 0) (void))
(check-eq? (s32vector-shrink! v9 2) (void))

(check-eqv? (s32vector-length v6) 3)
(check-eqv? (s32vector-length v7) 1)
(check-eqv? (s32vector-length v8) 0)
(check-eqv? (s32vector-length v9) 2)

(check-eq? (s32vector-fill! v6 -2147483648) (void))
(check-equal? v6 '#s32(-2147483648 -2147483648 -2147483648))

(check-eq? (s32vector-fill! v6 2147483647) (void))
(check-equal? v6 '#s32(2147483647 2147483647 2147483647))

(check-eq? (s32vector-fill! v6 3 1) (void))
(check-equal? v6 '#s32(2147483647 3 3))

(check-eq? (s32vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#s32(99 99 3))

(check-eq? (subs32vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#s32(9 9 9))

(check-eq? (subs32vector-fill! v6 1 2 -2147483648) (void))
(check-equal? v6 '#s32(9 -2147483648 9))

(check-eq? (subs32vector-fill! v6 1 3 2147483647) (void))
(check-equal? v6 '#s32(9 2147483647 2147483647))

(check-eq? (subs32vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#s32(2147483647 99 2147483647))

(check-eq? (subs32vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#s32(2147483647 2147483647 99))

(check-eq? (s32vector-copy! v6 0 '#s32(11 22 33)) (void))
(check-equal? v6 '#s32(11 22 33))

(check-eq? (s32vector-copy! v6 2 '#s32(33 44) 1) (void))
(check-equal? v6 '#s32(11 22 44))

(check-eq? (s32vector-copy! v6 1 '#s32(55 66 77 88) 0 2) (void))
(check-equal? v6 '#s32(11 55 66))

(check-tail-exn type-exception? (lambda () (s32vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector 11 -2147483649 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector 11 2147483648 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-s32vector bool)))
(check-tail-exn type-exception? (lambda () (make-s32vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s32vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s32vector 11 -2147483649))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s32vector 11 2147483648))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-s32vector -1 0)))

(check-tail-exn type-exception? (lambda () (s32vector-length bool)))

(check-tail-exn type-exception? (lambda () (s32vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s32vector bool)))

(check-tail-exn type-exception? (lambda () (s32vector-append bool)))
(check-tail-exn type-exception? (lambda () (s32vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (s32vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-s32vectors bool)))
(check-tail-exn type-exception? (lambda () (append-s32vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (s32vector-copy bool)))
(check-tail-exn type-exception? (lambda () (s32vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (s32vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subs32vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs32vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subs32vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subs32vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subs32vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subs32vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subs32vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (s32vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s32vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (s32vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (s32vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (s32vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-set v5 0 -2147483649))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-set v5 0 2147483648))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s32vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s32vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (s32vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s32vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-set! v5 0 -2147483649))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-set! v5 0 2147483648))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s32vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s32vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (s32vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (s32vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (s32vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (s32vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (s32vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s32vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (s32vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-fill! v5 -2147483649))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s32vector-fill! v5 2147483648))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subs32vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs32vector-fill! v5 0 0 -2147483649))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs32vector-fill! v5 0 0 2147483648))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subs32vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subs32vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs32vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subs32vector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (s32vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (s32vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (s32vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s32vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (s32vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (s32vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s32vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s32vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s32vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s32vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs32vector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s32vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s32vector (expt 2 64))))
