(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#s64(-9223372036854775808 9223372036854775807))

(define v2 (##s64vector -9223372036854775808 -2 0 1 9223372036854775807))
(define v3 (##make-s64vector 2))
(define v4 (##make-s64vector 2 -9223372036854775808))
(define v5 (##make-s64vector 2 9223372036854775807))

(define v6 (s64vector -9223372036854775808 -2 0 1 9223372036854775807))
(define v7 (make-s64vector 2))
(define v8 (make-s64vector 2 -9223372036854775808))
(define v9 (make-s64vector 2 9223372036854775807))

(check-false (##s64vector? str))
(check-false (##s64vector? int))
(check-false (##s64vector? bool))

(check-true (##s64vector? v1))
(check-true (##s64vector? '#s64()))
(check-true (##s64vector? '#s64(11)))
(check-true (##s64vector? '#s64(11 22)))
(check-true (##s64vector? '#s64(11 22 33)))
(check-true (##s64vector? '#s64(11 22 33 44)))
(check-true (##s64vector? '#s64(11 22 33 44 55)))

(check-true (##s64vector? v2))
(check-true (##s64vector? (##s64vector)))
(check-true (##s64vector? (##s64vector 11)))
(check-true (##s64vector? (##s64vector 11 22)))
(check-true (##s64vector? (##s64vector 11 22 33)))
(check-true (##s64vector? (##s64vector 11 22 33 44)))
(check-true (##s64vector? (##s64vector 11 22 33 44 55)))

(check-true (##s64vector? v3))
(check-true (##s64vector? (##make-s64vector 0)))
(check-true (##s64vector? (##make-s64vector 1)))
(check-true (##s64vector? (##make-s64vector 10)))
(check-true (##s64vector? (##make-s64vector 100)))
(check-true (##s64vector? (##make-s64vector 1000)))
(check-true (##s64vector? (##make-s64vector 10000)))

(check-true (##s64vector? v4))
(check-true (##s64vector? v5))
(check-true (##s64vector? (##make-s64vector 0 11)))
(check-true (##s64vector? (##make-s64vector 1 22)))
(check-true (##s64vector? (##make-s64vector 10 33)))
(check-true (##s64vector? (##make-s64vector 100 44)))
(check-true (##s64vector? (##make-s64vector 1000 55)))
(check-true (##s64vector? (##make-s64vector 10000 66)))

(check-eqv? (##s64vector-length v1) 2)
(check-eqv? (##s64vector-length '#s64()) 0)
(check-eqv? (##s64vector-length '#s64(11)) 1)
(check-eqv? (##s64vector-length '#s64(11 22)) 2)
(check-eqv? (##s64vector-length '#s64(11 22 33)) 3)
(check-eqv? (##s64vector-length '#s64(11 22 33 44)) 4)
(check-eqv? (##s64vector-length '#s64(11 22 33 44 55)) 5)

(check-eqv? (##s64vector-length v2) 5)
(check-eqv? (##s64vector-length (##s64vector)) 0)
(check-eqv? (##s64vector-length (##s64vector 11)) 1)
(check-eqv? (##s64vector-length (##s64vector 11 22)) 2)
(check-eqv? (##s64vector-length (##s64vector 11 22 33)) 3)
(check-eqv? (##s64vector-length (##s64vector 11 22 33 44)) 4)
(check-eqv? (##s64vector-length (##s64vector 11 22 33 44 55)) 5)

(check-eqv? (##s64vector-length v3) 2)
(check-eqv? (##s64vector-length (##make-s64vector 0)) 0)
(check-eqv? (##s64vector-length (##make-s64vector 1)) 1)
(check-eqv? (##s64vector-length (##make-s64vector 10)) 10)
(check-eqv? (##s64vector-length (##make-s64vector 100)) 100)
(check-eqv? (##s64vector-length (##make-s64vector 1000)) 1000)
(check-eqv? (##s64vector-length (##make-s64vector 10000)) 10000)

(check-eqv? (##s64vector-length v4) 2)
(check-eqv? (##s64vector-length v5) 2)
(check-eqv? (##s64vector-length (##make-s64vector 0 11)) 0)
(check-eqv? (##s64vector-length (##make-s64vector 1 22)) 1)
(check-eqv? (##s64vector-length (##make-s64vector 10 33)) 10)
(check-eqv? (##s64vector-length (##make-s64vector 100 44)) 100)
(check-eqv? (##s64vector-length (##make-s64vector 1000 55)) 1000)
(check-eqv? (##s64vector-length (##make-s64vector 10000 66)) 10000)

(check-eqv? (##s64vector-ref v1 0) -9223372036854775808)
(check-eqv? (##s64vector-ref v1 1) 9223372036854775807)

(check-eqv? (##s64vector-ref v2 0) -9223372036854775808)
(check-eqv? (##s64vector-ref v2 1) -2)
(check-eqv? (##s64vector-ref v2 2) 0)
(check-eqv? (##s64vector-ref v2 3) 1)
(check-eqv? (##s64vector-ref v2 4) 9223372036854775807)

(check-eqv? (##s64vector-ref v4 0) -9223372036854775808)
(check-eqv? (##s64vector-ref v4 1) -9223372036854775808)

(check-eqv? (##s64vector-ref v5 0) 9223372036854775807)
(check-eqv? (##s64vector-ref v5 1) 9223372036854775807)

(check-equal? (##s64vector-set v2 1 99) '#s64(-9223372036854775808 99 0 1 9223372036854775807))
(check-equal? v2 '#s64(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (##s64vector-set v4 1 99) '#s64(-9223372036854775808 99))
(check-equal? (##s64vector-set v5 1 99) '#s64(9223372036854775807 99))
(check-equal? (##s64vector-set '#s64(11 22 33) 0 99) '#s64(99 22 33))

(check-eq? (##s64vector-set! v2 1 99) v2)
(check-eq? (##s64vector-set! v3 1 99) v3)
(check-eq? (##s64vector-set! v4 1 99) v4)
(check-eq? (##s64vector-set! v5 1 99) v5)

(check-eqv? (##s64vector-ref v2 0) -9223372036854775808)
(check-eqv? (##s64vector-ref v2 1) 99)
(check-eqv? (##s64vector-ref v2 2) 0)
(check-eqv? (##s64vector-ref v2 3) 1)
(check-eqv? (##s64vector-ref v2 4) 9223372036854775807)

(check-eqv? (##s64vector-ref v3 1) 99)

(check-eqv? (##s64vector-ref v4 0) -9223372036854775808)
(check-eqv? (##s64vector-ref v4 1) 99)

(check-eqv? (##s64vector-ref v5 0) 9223372036854775807)
(check-eqv? (##s64vector-ref v5 1) 99)

(check-eq? (##s64vector-shrink! v2 3) v2)
(check-eq? (##s64vector-shrink! v3 1) v3)
(check-eq? (##s64vector-shrink! v4 0) v4)
(check-eq? (##s64vector-shrink! v5 2) v5)

(check-eqv? (##s64vector-length v2) 3)
(check-eqv? (##s64vector-length v3) 1)
(check-eqv? (##s64vector-length v4) 0)
(check-eqv? (##s64vector-length v5) 2)

(check-true (s64vector? v1))
(check-true (s64vector? '#s64()))
(check-true (s64vector? '#s64(11)))
(check-true (s64vector? '#s64(11 22)))
(check-true (s64vector? '#s64(11 22 33)))
(check-true (s64vector? '#s64(11 22 33 44)))
(check-true (s64vector? '#s64(11 22 33 44 55)))

(check-true (s64vector? v6))
(check-true (s64vector? (s64vector)))
(check-true (s64vector? (s64vector 11)))
(check-true (s64vector? (s64vector 11 22)))
(check-true (s64vector? (s64vector 11 22 33)))
(check-true (s64vector? (s64vector 11 22 33 44)))
(check-true (s64vector? (s64vector 11 22 33 44 55)))

(check-true (s64vector? v7))
(check-true (s64vector? (make-s64vector 0)))
(check-true (s64vector? (make-s64vector 1)))
(check-true (s64vector? (make-s64vector 10)))
(check-true (s64vector? (make-s64vector 100)))
(check-true (s64vector? (make-s64vector 1000)))
(check-true (s64vector? (make-s64vector 10000)))

(check-true (s64vector? v8))
(check-true (s64vector? v9))
(check-true (s64vector? (make-s64vector 0 11)))
(check-true (s64vector? (make-s64vector 1 22)))
(check-true (s64vector? (make-s64vector 10 33)))
(check-true (s64vector? (make-s64vector 100 44)))
(check-true (s64vector? (make-s64vector 1000 55)))
(check-true (s64vector? (make-s64vector 10000 66)))

(check-eqv? (s64vector-length v1) 2)
(check-eqv? (s64vector-length '#s64()) 0)
(check-eqv? (s64vector-length '#s64(11)) 1)
(check-eqv? (s64vector-length '#s64(11 22)) 2)
(check-eqv? (s64vector-length '#s64(11 22 33)) 3)
(check-eqv? (s64vector-length '#s64(11 22 33 44)) 4)
(check-eqv? (s64vector-length '#s64(11 22 33 44 55)) 5)

(check-eqv? (s64vector-length v6) 5)
(check-eqv? (s64vector-length (s64vector)) 0)
(check-eqv? (s64vector-length (s64vector 11)) 1)
(check-eqv? (s64vector-length (s64vector 11 22)) 2)
(check-eqv? (s64vector-length (s64vector 11 22 33)) 3)
(check-eqv? (s64vector-length (s64vector 11 22 33 44)) 4)
(check-eqv? (s64vector-length (s64vector 11 22 33 44 55)) 5)

(check-eqv? (s64vector-length v7) 2)
(check-eqv? (s64vector-length (make-s64vector 0)) 0)
(check-eqv? (s64vector-length (make-s64vector 1)) 1)
(check-eqv? (s64vector-length (make-s64vector 10)) 10)
(check-eqv? (s64vector-length (make-s64vector 100)) 100)
(check-eqv? (s64vector-length (make-s64vector 1000)) 1000)
(check-eqv? (s64vector-length (make-s64vector 10000)) 10000)

(check-eqv? (s64vector-length v8) 2)
(check-eqv? (s64vector-length v9) 2)
(check-eqv? (s64vector-length (make-s64vector 0 11)) 0)
(check-eqv? (s64vector-length (make-s64vector 1 22)) 1)
(check-eqv? (s64vector-length (make-s64vector 10 33)) 10)
(check-eqv? (s64vector-length (make-s64vector 100 44)) 100)
(check-eqv? (s64vector-length (make-s64vector 1000 55)) 1000)
(check-eqv? (s64vector-length (make-s64vector 10000 66)) 10000)

(check-equal? (s64vector->list '#s64()) '())
(check-equal? (s64vector->list v6) '(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (s64vector->list v6 0) '(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (s64vector->list v6 2) '(0 1 9223372036854775807))
(check-equal? (s64vector->list v6 2 4) '(0 1))
(check-equal? (s64vector->list v6 0 5) '(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (s64vector->list v7) '(0 0))

(check-equal? (list->s64vector '()) '#s64())
(check-equal? (list->s64vector '(-9223372036854775808 -2 0 1 9223372036854775807)) v6)
(check-equal? (list->s64vector '(0 0)) v7)

(check-equal? (s64vector-append) '#s64())
(check-equal? (s64vector-append v6) v6)
(check-equal? (s64vector-append '#s64(-9223372036854775808 -2) '#s64(0 1 9223372036854775807)) v6)
(check-equal? (s64vector-append v6 v7 v6) '#s64(-9223372036854775808 -2 0 1 9223372036854775807 0 0 -9223372036854775808 -2 0 1 9223372036854775807))

(check-equal? (append-s64vectors (list v6 v7 v6)) '#s64(-9223372036854775808 -2 0 1 9223372036854775807 0 0 -9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (append-s64vectors (list v6 v7 v6) '#s64(1 1 1)) '#s64(-9223372036854775808 -2 0 1 9223372036854775807 1 1 1 0 0 1 1 1 -9223372036854775808 -2 0 1 9223372036854775807))

(check-equal? (s64vector-copy '#s64()) '#s64())
(check-equal? (s64vector-copy v6) v6)
(check-equal? (s64vector-copy v6 0) v6)
(check-equal? (s64vector-copy v6 2) '#s64(0 1 9223372036854775807))
(check-equal? (s64vector-copy v6 0 0) '#s64())
(check-equal? (s64vector-copy v6 4 4) '#s64())
(check-equal? (s64vector-copy v6 0 2) '#s64(-9223372036854775808 -2))
(check-equal? (s64vector-copy v6 2 4) '#s64(0 1))
(check-equal? (s64vector-copy v6 4 5) '#s64(9223372036854775807))
(check-equal? (s64vector-copy v6 0 5) v6)

(check-equal? (subs64vector v6 0 0) '#s64())
(check-equal? (subs64vector v6 4 4) '#s64())
(check-equal? (subs64vector v6 0 2) '#s64(-9223372036854775808 -2))
(check-equal? (subs64vector v6 2 4) '#s64(0 1))
(check-equal? (subs64vector v6 4 5) '#s64(9223372036854775807))
(check-equal? (subs64vector v6 0 5) v6)

(check-eqv? (s64vector-ref v1 0) -9223372036854775808)
(check-eqv? (s64vector-ref v1 1) 9223372036854775807)

(check-eqv? (s64vector-ref v6 0) -9223372036854775808)
(check-eqv? (s64vector-ref v6 1) -2)
(check-eqv? (s64vector-ref v6 2) 0)
(check-eqv? (s64vector-ref v6 3) 1)
(check-eqv? (s64vector-ref v6 4) 9223372036854775807)

(check-eqv? (s64vector-ref v7 0) 0)
(check-eqv? (s64vector-ref v7 1) 0)

(check-eqv? (s64vector-ref v8 0) -9223372036854775808)
(check-eqv? (s64vector-ref v8 1) -9223372036854775808)

(check-eqv? (s64vector-ref v9 0) 9223372036854775807)
(check-eqv? (s64vector-ref v9 1) 9223372036854775807)

(check-equal? (s64vector-set v6 1 99) '#s64(-9223372036854775808 99 0 1 9223372036854775807))
(check-equal? v6 '#s64(-9223372036854775808 -2 0 1 9223372036854775807))
(check-equal? (s64vector-set v8 1 99) '#s64(-9223372036854775808 99))
(check-equal? (s64vector-set v9 1 99) '#s64(9223372036854775807 99))
(check-equal? (s64vector-set '#s64(11 22 33) 0 99) '#s64(99 22 33))

(check-eq? (s64vector-set! v6 1 99) (void))
(check-eq? (s64vector-set! v7 1 99) (void))
(check-eq? (s64vector-set! v8 1 99) (void))
(check-eq? (s64vector-set! v9 1 99) (void))

(check-eqv? (s64vector-ref v6 0) -9223372036854775808)
(check-eqv? (s64vector-ref v6 1) 99)
(check-eqv? (s64vector-ref v6 2) 0)
(check-eqv? (s64vector-ref v6 3) 1)
(check-eqv? (s64vector-ref v6 4) 9223372036854775807)

(check-eqv? (s64vector-ref v7 0) 0)
(check-eqv? (s64vector-ref v7 1) 99)

(check-eqv? (s64vector-ref v8 0) -9223372036854775808)
(check-eqv? (s64vector-ref v8 1) 99)

(check-eqv? (s64vector-ref v9 0) 9223372036854775807)
(check-eqv? (s64vector-ref v9 1) 99)

(check-eq? (s64vector-shrink! v6 3) (void))
(check-eq? (s64vector-shrink! v7 1) (void))
(check-eq? (s64vector-shrink! v8 0) (void))
(check-eq? (s64vector-shrink! v9 2) (void))

(check-eqv? (s64vector-length v6) 3)
(check-eqv? (s64vector-length v7) 1)
(check-eqv? (s64vector-length v8) 0)
(check-eqv? (s64vector-length v9) 2)

(check-eq? (s64vector-fill! v6 -9223372036854775808) (void))
(check-equal? v6 '#s64(-9223372036854775808 -9223372036854775808 -9223372036854775808))

(check-eq? (s64vector-fill! v6 9223372036854775807) (void))
(check-equal? v6 '#s64(9223372036854775807 9223372036854775807 9223372036854775807))

(check-eq? (s64vector-fill! v6 3 1) (void))
(check-equal? v6 '#s64(9223372036854775807 3 3))

(check-eq? (s64vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#s64(99 99 3))

(check-eq? (subs64vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#s64(9 9 9))

(check-eq? (subs64vector-fill! v6 1 2 -9223372036854775808) (void))
(check-equal? v6 '#s64(9 -9223372036854775808 9))

(check-eq? (subs64vector-fill! v6 1 3 9223372036854775807) (void))
(check-equal? v6 '#s64(9 9223372036854775807 9223372036854775807))

(check-eq? (subs64vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#s64(9223372036854775807 99 9223372036854775807))

(check-eq? (subs64vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#s64(9223372036854775807 9223372036854775807 99))

(check-eq? (s64vector-copy! v6 0 '#s64(11 22 33)) (void))
(check-equal? v6 '#s64(11 22 33))

(check-eq? (s64vector-copy! v6 2 '#s64(33 44) 1) (void))
(check-equal? v6 '#s64(11 22 44))

(check-eq? (s64vector-copy! v6 1 '#s64(55 66 77 88) 0 2) (void))
(check-equal? v6 '#s64(11 55 66))

(check-tail-exn type-exception? (lambda () (s64vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector 11 -9223372036854775809 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector 11 9223372036854775808 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-s64vector bool)))
(check-tail-exn type-exception? (lambda () (make-s64vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s64vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s64vector 11 -9223372036854775809))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s64vector 11 9223372036854775808))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-s64vector -1 0)))

(check-tail-exn type-exception? (lambda () (s64vector-length bool)))

(check-tail-exn type-exception? (lambda () (s64vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s64vector bool)))

(check-tail-exn type-exception? (lambda () (s64vector-append bool)))
(check-tail-exn type-exception? (lambda () (s64vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (s64vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-s64vectors bool)))
(check-tail-exn type-exception? (lambda () (append-s64vectors '(1 2 3))))
(check-tail-exn type-exception? (lambda () (append-s64vectors (list v9 v9) bool)))

(check-tail-exn type-exception? (lambda () (s64vector-copy bool)))
(check-tail-exn type-exception? (lambda () (s64vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (s64vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subs64vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs64vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subs64vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subs64vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subs64vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subs64vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subs64vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (s64vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s64vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (s64vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (s64vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (s64vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-set v5 0 -9223372036854775809))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-set v5 0 9223372036854775808))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s64vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s64vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (s64vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s64vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-set! v5 0 -9223372036854775809))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-set! v5 0 9223372036854775808))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s64vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s64vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (s64vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (s64vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (s64vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (s64vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (s64vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s64vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (s64vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-fill! v5 -9223372036854775809))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s64vector-fill! v5 9223372036854775808))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subs64vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs64vector-fill! v5 0 0 -9223372036854775809))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs64vector-fill! v5 0 0 9223372036854775808))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subs64vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subs64vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs64vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subs64vector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (s64vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (s64vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (s64vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s64vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (s64vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (s64vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s64vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s64vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s64vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s64vectors '() '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs64vector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s64vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s64vector (expt 2 64))))
