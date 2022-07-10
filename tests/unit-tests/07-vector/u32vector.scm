(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u32(0 4294967295))

(define v2 (##u32vector 0 4294967295 0 1 4294967295))
(define v3 (##make-u32vector 2))
(define v4 (##make-u32vector 2 0))
(define v5 (##make-u32vector 2 4294967295))

(define v6 (u32vector 0 4294967295 0 1 4294967295))
(define v7 (make-u32vector 2))
(define v8 (make-u32vector 2 0))
(define v9 (make-u32vector 2 4294967295))

(check-false (##u32vector? str))
(check-false (##u32vector? int))
(check-false (##u32vector? bool))

(check-true (##u32vector? v1))
(check-true (##u32vector? '#u32()))
(check-true (##u32vector? '#u32(11)))
(check-true (##u32vector? '#u32(11 22)))
(check-true (##u32vector? '#u32(11 22 33)))
(check-true (##u32vector? '#u32(11 22 33 44)))
(check-true (##u32vector? '#u32(11 22 33 44 55)))

(check-true (##u32vector? v2))
(check-true (##u32vector? (##u32vector)))
(check-true (##u32vector? (##u32vector 11)))
(check-true (##u32vector? (##u32vector 11 22)))
(check-true (##u32vector? (##u32vector 11 22 33)))
(check-true (##u32vector? (##u32vector 11 22 33 44)))
(check-true (##u32vector? (##u32vector 11 22 33 44 55)))

(check-true (##u32vector? v3))
(check-true (##u32vector? (##make-u32vector 0)))
(check-true (##u32vector? (##make-u32vector 1)))
(check-true (##u32vector? (##make-u32vector 10)))
(check-true (##u32vector? (##make-u32vector 100)))
(check-true (##u32vector? (##make-u32vector 1000)))
(check-true (##u32vector? (##make-u32vector 10000)))

(check-true (##u32vector? v4))
(check-true (##u32vector? v5))
(check-true (##u32vector? (##make-u32vector 0 11)))
(check-true (##u32vector? (##make-u32vector 1 22)))
(check-true (##u32vector? (##make-u32vector 10 33)))
(check-true (##u32vector? (##make-u32vector 100 44)))
(check-true (##u32vector? (##make-u32vector 1000 55)))
(check-true (##u32vector? (##make-u32vector 10000 66)))

(check-eqv? (##u32vector-length v1) 2)
(check-eqv? (##u32vector-length '#u32()) 0)
(check-eqv? (##u32vector-length '#u32(11)) 1)
(check-eqv? (##u32vector-length '#u32(11 22)) 2)
(check-eqv? (##u32vector-length '#u32(11 22 33)) 3)
(check-eqv? (##u32vector-length '#u32(11 22 33 44)) 4)
(check-eqv? (##u32vector-length '#u32(11 22 33 44 55)) 5)

(check-eqv? (##u32vector-length v2) 5)
(check-eqv? (##u32vector-length (##u32vector)) 0)
(check-eqv? (##u32vector-length (##u32vector 11)) 1)
(check-eqv? (##u32vector-length (##u32vector 11 22)) 2)
(check-eqv? (##u32vector-length (##u32vector 11 22 33)) 3)
(check-eqv? (##u32vector-length (##u32vector 11 22 33 44)) 4)
(check-eqv? (##u32vector-length (##u32vector 11 22 33 44 55)) 5)

(check-eqv? (##u32vector-length v3) 2)
(check-eqv? (##u32vector-length (##make-u32vector 0)) 0)
(check-eqv? (##u32vector-length (##make-u32vector 1)) 1)
(check-eqv? (##u32vector-length (##make-u32vector 10)) 10)
(check-eqv? (##u32vector-length (##make-u32vector 100)) 100)
(check-eqv? (##u32vector-length (##make-u32vector 1000)) 1000)
(check-eqv? (##u32vector-length (##make-u32vector 10000)) 10000)

(check-eqv? (##u32vector-length v4) 2)
(check-eqv? (##u32vector-length v5) 2)
(check-eqv? (##u32vector-length (##make-u32vector 0 11)) 0)
(check-eqv? (##u32vector-length (##make-u32vector 1 22)) 1)
(check-eqv? (##u32vector-length (##make-u32vector 10 33)) 10)
(check-eqv? (##u32vector-length (##make-u32vector 100 44)) 100)
(check-eqv? (##u32vector-length (##make-u32vector 1000 55)) 1000)
(check-eqv? (##u32vector-length (##make-u32vector 10000 66)) 10000)

(check-eqv? (##u32vector-ref v1 0) 0)
(check-eqv? (##u32vector-ref v1 1) 4294967295)

(check-eqv? (##u32vector-ref v2 0) 0)
(check-eqv? (##u32vector-ref v2 1) 4294967295)
(check-eqv? (##u32vector-ref v2 2) 0)
(check-eqv? (##u32vector-ref v2 3) 1)
(check-eqv? (##u32vector-ref v2 4) 4294967295)

(check-eqv? (##u32vector-ref v4 0) 0)
(check-eqv? (##u32vector-ref v4 1) 0)

(check-eqv? (##u32vector-ref v5 0) 4294967295)
(check-eqv? (##u32vector-ref v5 1) 4294967295)

(check-equal? (##u32vector-set v2 1 99) '#u32(0 99 0 1 4294967295))
(check-equal? v2 '#u32(0 4294967295 0 1 4294967295))
(check-equal? (##u32vector-set v4 1 99) '#u32(0 99))
(check-equal? (##u32vector-set v5 1 99) '#u32(4294967295 99))
(check-equal? (##u32vector-set '#u32(11 22 33) 0 99) '#u32(99 22 33))

(check-eq? (##u32vector-set! v2 1 99) v2)
(check-eq? (##u32vector-set! v3 1 99) v3)
(check-eq? (##u32vector-set! v4 1 99) v4)
(check-eq? (##u32vector-set! v5 1 99) v5)

(check-eqv? (##u32vector-ref v2 0) 0)
(check-eqv? (##u32vector-ref v2 1) 99)
(check-eqv? (##u32vector-ref v2 2) 0)
(check-eqv? (##u32vector-ref v2 3) 1)
(check-eqv? (##u32vector-ref v2 4) 4294967295)

(check-eqv? (##u32vector-ref v3 1) 99)

(check-eqv? (##u32vector-ref v4 0) 0)
(check-eqv? (##u32vector-ref v4 1) 99)

(check-eqv? (##u32vector-ref v5 0) 4294967295)
(check-eqv? (##u32vector-ref v5 1) 99)

(check-eq? (##u32vector-shrink! v2 3) v2)
(check-eq? (##u32vector-shrink! v3 1) v3)
(check-eq? (##u32vector-shrink! v4 0) v4)
(check-eq? (##u32vector-shrink! v5 2) v5)

(check-eqv? (##u32vector-length v2) 3)
(check-eqv? (##u32vector-length v3) 1)
(check-eqv? (##u32vector-length v4) 0)
(check-eqv? (##u32vector-length v5) 2)

(check-true (u32vector? v1))
(check-true (u32vector? '#u32()))
(check-true (u32vector? '#u32(11)))
(check-true (u32vector? '#u32(11 22)))
(check-true (u32vector? '#u32(11 22 33)))
(check-true (u32vector? '#u32(11 22 33 44)))
(check-true (u32vector? '#u32(11 22 33 44 55)))

(check-true (u32vector? v6))
(check-true (u32vector? (u32vector)))
(check-true (u32vector? (u32vector 11)))
(check-true (u32vector? (u32vector 11 22)))
(check-true (u32vector? (u32vector 11 22 33)))
(check-true (u32vector? (u32vector 11 22 33 44)))
(check-true (u32vector? (u32vector 11 22 33 44 55)))

(check-true (u32vector? v7))
(check-true (u32vector? (make-u32vector 0)))
(check-true (u32vector? (make-u32vector 1)))
(check-true (u32vector? (make-u32vector 10)))
(check-true (u32vector? (make-u32vector 100)))
(check-true (u32vector? (make-u32vector 1000)))
(check-true (u32vector? (make-u32vector 10000)))

(check-true (u32vector? v8))
(check-true (u32vector? v9))
(check-true (u32vector? (make-u32vector 0 11)))
(check-true (u32vector? (make-u32vector 1 22)))
(check-true (u32vector? (make-u32vector 10 33)))
(check-true (u32vector? (make-u32vector 100 44)))
(check-true (u32vector? (make-u32vector 1000 55)))
(check-true (u32vector? (make-u32vector 10000 66)))

(check-eqv? (u32vector-length v1) 2)
(check-eqv? (u32vector-length '#u32()) 0)
(check-eqv? (u32vector-length '#u32(11)) 1)
(check-eqv? (u32vector-length '#u32(11 22)) 2)
(check-eqv? (u32vector-length '#u32(11 22 33)) 3)
(check-eqv? (u32vector-length '#u32(11 22 33 44)) 4)
(check-eqv? (u32vector-length '#u32(11 22 33 44 55)) 5)

(check-eqv? (u32vector-length v6) 5)
(check-eqv? (u32vector-length (u32vector)) 0)
(check-eqv? (u32vector-length (u32vector 11)) 1)
(check-eqv? (u32vector-length (u32vector 11 22)) 2)
(check-eqv? (u32vector-length (u32vector 11 22 33)) 3)
(check-eqv? (u32vector-length (u32vector 11 22 33 44)) 4)
(check-eqv? (u32vector-length (u32vector 11 22 33 44 55)) 5)

(check-eqv? (u32vector-length v7) 2)
(check-eqv? (u32vector-length (make-u32vector 0)) 0)
(check-eqv? (u32vector-length (make-u32vector 1)) 1)
(check-eqv? (u32vector-length (make-u32vector 10)) 10)
(check-eqv? (u32vector-length (make-u32vector 100)) 100)
(check-eqv? (u32vector-length (make-u32vector 1000)) 1000)
(check-eqv? (u32vector-length (make-u32vector 10000)) 10000)

(check-eqv? (u32vector-length v8) 2)
(check-eqv? (u32vector-length v9) 2)
(check-eqv? (u32vector-length (make-u32vector 0 11)) 0)
(check-eqv? (u32vector-length (make-u32vector 1 22)) 1)
(check-eqv? (u32vector-length (make-u32vector 10 33)) 10)
(check-eqv? (u32vector-length (make-u32vector 100 44)) 100)
(check-eqv? (u32vector-length (make-u32vector 1000 55)) 1000)
(check-eqv? (u32vector-length (make-u32vector 10000 66)) 10000)

(check-equal? (u32vector->list '#u32()) '())
(check-equal? (u32vector->list v6) '(0 4294967295 0 1 4294967295))
(check-equal? (u32vector->list v6 0) '(0 4294967295 0 1 4294967295))
(check-equal? (u32vector->list v6 2) '(0 1 4294967295))
(check-equal? (u32vector->list v6 2 4) '(0 1))
(check-equal? (u32vector->list v6 0 5) '(0 4294967295 0 1 4294967295))
(check-equal? (u32vector->list v7) '(0 0))

(check-equal? (list->u32vector '()) '#u32())
(check-equal? (list->u32vector '(0 4294967295 0 1 4294967295)) v6)
(check-equal? (list->u32vector '(0 0)) v7)

(check-equal? (u32vector-append) '#u32())
(check-equal? (u32vector-append v6) v6)
(check-equal? (u32vector-append '#u32(0 4294967295) '#u32(0 1 4294967295)) v6)
(check-equal? (u32vector-append v6 v7 v6) '#u32(0 4294967295 0 1 4294967295 0 0 0 4294967295 0 1 4294967295))

(check-equal? (u32vector-concatenate (list v6 v7 v6)) '#u32(0 4294967295 0 1 4294967295 0 0 0 4294967295 0 1 4294967295))
(check-equal? (u32vector-concatenate (list v6 v7 v6) '#u32(1 1 1)) '#u32(0 4294967295 0 1 4294967295 1 1 1 0 0 1 1 1 0 4294967295 0 1 4294967295))

(check-equal? (u32vector-copy '#u32()) '#u32())
(check-equal? (u32vector-copy v6) v6)
(check-equal? (u32vector-copy v6 0) v6)
(check-equal? (u32vector-copy v6 2) '#u32(0 1 4294967295))
(check-equal? (u32vector-copy v6 0 0) '#u32())
(check-equal? (u32vector-copy v6 4 4) '#u32())
(check-equal? (u32vector-copy v6 0 2) '#u32(0 4294967295))
(check-equal? (u32vector-copy v6 2 4) '#u32(0 1))
(check-equal? (u32vector-copy v6 4 5) '#u32(4294967295))
(check-equal? (u32vector-copy v6 0 5) v6)

(check-equal? (subu32vector v6 0 0) '#u32())
(check-equal? (subu32vector v6 4 4) '#u32())
(check-equal? (subu32vector v6 0 2) '#u32(0 4294967295))
(check-equal? (subu32vector v6 2 4) '#u32(0 1))
(check-equal? (subu32vector v6 4 5) '#u32(4294967295))
(check-equal? (subu32vector v6 0 5) v6)

(check-eqv? (u32vector-ref v1 0) 0)
(check-eqv? (u32vector-ref v1 1) 4294967295)

(check-eqv? (u32vector-ref v6 0) 0)
(check-eqv? (u32vector-ref v6 1) 4294967295)
(check-eqv? (u32vector-ref v6 2) 0)
(check-eqv? (u32vector-ref v6 3) 1)
(check-eqv? (u32vector-ref v6 4) 4294967295)

(check-eqv? (u32vector-ref v7 0) 0)
(check-eqv? (u32vector-ref v7 1) 0)

(check-eqv? (u32vector-ref v8 0) 0)
(check-eqv? (u32vector-ref v8 1) 0)

(check-eqv? (u32vector-ref v9 0) 4294967295)
(check-eqv? (u32vector-ref v9 1) 4294967295)

(check-equal? (u32vector-set v6 1 99) '#u32(0 99 0 1 4294967295))
(check-equal? v6 '#u32(0 4294967295 0 1 4294967295))
(check-equal? (u32vector-set v8 1 99) '#u32(0 99))
(check-equal? (u32vector-set v9 1 99) '#u32(4294967295 99))
(check-equal? (u32vector-set '#u32(11 22 33) 0 99) '#u32(99 22 33))

(check-eq? (u32vector-set! v6 1 99) (void))
(check-eq? (u32vector-set! v7 1 99) (void))
(check-eq? (u32vector-set! v8 1 99) (void))
(check-eq? (u32vector-set! v9 1 99) (void))

(check-eqv? (u32vector-ref v6 0) 0)
(check-eqv? (u32vector-ref v6 1) 99)
(check-eqv? (u32vector-ref v6 2) 0)
(check-eqv? (u32vector-ref v6 3) 1)
(check-eqv? (u32vector-ref v6 4) 4294967295)

(check-eqv? (u32vector-ref v7 0) 0)
(check-eqv? (u32vector-ref v7 1) 99)

(check-eqv? (u32vector-ref v8 0) 0)
(check-eqv? (u32vector-ref v8 1) 99)

(check-eqv? (u32vector-ref v9 0) 4294967295)
(check-eqv? (u32vector-ref v9 1) 99)

(check-eq? (u32vector-shrink! v6 3) (void))
(check-eq? (u32vector-shrink! v7 1) (void))
(check-eq? (u32vector-shrink! v8 0) (void))
(check-eq? (u32vector-shrink! v9 2) (void))

(check-eqv? (u32vector-length v6) 3)
(check-eqv? (u32vector-length v7) 1)
(check-eqv? (u32vector-length v8) 0)
(check-eqv? (u32vector-length v9) 2)

(check-eq? (u32vector-fill! v6 0) (void))
(check-equal? v6 '#u32(0 0 0))

(check-eq? (u32vector-fill! v6 4294967295) (void))
(check-equal? v6 '#u32(4294967295 4294967295 4294967295))

(check-eq? (u32vector-fill! v6 3 1) (void))
(check-equal? v6 '#u32(4294967295 3 3))

(check-eq? (u32vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#u32(99 99 3))

(check-eq? (subu32vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#u32(9 9 9))

(check-eq? (subu32vector-fill! v6 1 2 0) (void))
(check-equal? v6 '#u32(9 0 9))

(check-eq? (subu32vector-fill! v6 1 3 4294967295) (void))
(check-equal? v6 '#u32(9 4294967295 4294967295))

(check-eq? (subu32vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#u32(4294967295 99 4294967295))

(check-eq? (subu32vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#u32(4294967295 4294967295 99))

(check-eq? (u32vector-copy! v6 0 '#u32(11 22 33)) (void))
(check-equal? v6 '#u32(11 22 33))

(check-eq? (u32vector-copy! v6 2 '#u32(33 44) 1) (void))
(check-equal? v6 '#u32(11 22 44))

(check-eq? (u32vector-copy! v6 1 '#u32(55 66 77 88) 0 2) (void))
(check-equal? v6 '#u32(11 55 66))

(check-tail-exn type-exception? (lambda () (u32vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector 11 -1 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector 11 4294967296 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-u32vector bool)))
(check-tail-exn type-exception? (lambda () (make-u32vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u32vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u32vector 11 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u32vector 11 4294967296))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-u32vector -1 0)))

(check-tail-exn type-exception? (lambda () (u32vector-length bool)))

(check-tail-exn type-exception? (lambda () (u32vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u32vector bool)))

(check-tail-exn type-exception? (lambda () (u32vector-append bool)))
(check-tail-exn type-exception? (lambda () (u32vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (u32vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (u32vector-concatenate bool)))
(check-tail-exn type-exception? (lambda () (u32vector-concatenate '(1 2 3))))
(check-tail-exn type-exception? (lambda () (u32vector-concatenate (list v9 v9) bool)))

(check-tail-exn type-exception? (lambda () (u32vector-copy bool)))
(check-tail-exn type-exception? (lambda () (u32vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (u32vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subu32vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu32vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subu32vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subu32vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subu32vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subu32vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subu32vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (u32vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u32vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (u32vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (u32vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (u32vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-set v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-set v5 0 4294967296))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u32vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u32vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (u32vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u32vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-set! v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-set! v5 0 4294967296))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u32vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u32vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (u32vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (u32vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (u32vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (u32vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (u32vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (u32vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (u32vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-fill! v5 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u32vector-fill! v5 4294967296))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subu32vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu32vector-fill! v5 0 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu32vector-fill! v5 0 0 4294967296))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subu32vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subu32vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu32vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subu32vector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (u32vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (u32vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (u32vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (u32vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (u32vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (u32vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u32vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u32vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-concatenate)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-concatenate '() '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu32vector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u32vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u32vector (expt 2 64))))
