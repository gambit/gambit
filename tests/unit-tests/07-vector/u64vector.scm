(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u64(0 18446744073709551615))

(define v2 (##u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define v3 (##make-u64vector 2))
(define v4 (##make-u64vector 2 0))
(define v5 (##make-u64vector 2 18446744073709551615))

(define v6 (u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define v7 (make-u64vector 2))
(define v8 (make-u64vector 2 0))
(define v9 (make-u64vector 2 18446744073709551615))

(check-false (##u64vector? str))
(check-false (##u64vector? int))
(check-false (##u64vector? bool))

(check-true (##u64vector? v1))
(check-true (##u64vector? '#u64()))
(check-true (##u64vector? '#u64(11)))
(check-true (##u64vector? '#u64(11 22)))
(check-true (##u64vector? '#u64(11 22 33)))
(check-true (##u64vector? '#u64(11 22 33 44)))
(check-true (##u64vector? '#u64(11 22 33 44 55)))

(check-true (##u64vector? v2))
(check-true (##u64vector? (##u64vector)))
(check-true (##u64vector? (##u64vector 11)))
(check-true (##u64vector? (##u64vector 11 22)))
(check-true (##u64vector? (##u64vector 11 22 33)))
(check-true (##u64vector? (##u64vector 11 22 33 44)))
(check-true (##u64vector? (##u64vector 11 22 33 44 55)))

(check-true (##u64vector? v3))
(check-true (##u64vector? (##make-u64vector 0)))
(check-true (##u64vector? (##make-u64vector 1)))
(check-true (##u64vector? (##make-u64vector 10)))
(check-true (##u64vector? (##make-u64vector 100)))
(check-true (##u64vector? (##make-u64vector 1000)))
(check-true (##u64vector? (##make-u64vector 10000)))

(check-true (##u64vector? v4))
(check-true (##u64vector? v5))
(check-true (##u64vector? (##make-u64vector 0 11)))
(check-true (##u64vector? (##make-u64vector 1 22)))
(check-true (##u64vector? (##make-u64vector 10 33)))
(check-true (##u64vector? (##make-u64vector 100 44)))
(check-true (##u64vector? (##make-u64vector 1000 55)))
(check-true (##u64vector? (##make-u64vector 10000 66)))

(check-eqv? (##u64vector-length v1) 2)
(check-eqv? (##u64vector-length '#u64()) 0)
(check-eqv? (##u64vector-length '#u64(11)) 1)
(check-eqv? (##u64vector-length '#u64(11 22)) 2)
(check-eqv? (##u64vector-length '#u64(11 22 33)) 3)
(check-eqv? (##u64vector-length '#u64(11 22 33 44)) 4)
(check-eqv? (##u64vector-length '#u64(11 22 33 44 55)) 5)

(check-eqv? (##u64vector-length v2) 5)
(check-eqv? (##u64vector-length (##u64vector)) 0)
(check-eqv? (##u64vector-length (##u64vector 11)) 1)
(check-eqv? (##u64vector-length (##u64vector 11 22)) 2)
(check-eqv? (##u64vector-length (##u64vector 11 22 33)) 3)
(check-eqv? (##u64vector-length (##u64vector 11 22 33 44)) 4)
(check-eqv? (##u64vector-length (##u64vector 11 22 33 44 55)) 5)

(check-eqv? (##u64vector-length v3) 2)
(check-eqv? (##u64vector-length (##make-u64vector 0)) 0)
(check-eqv? (##u64vector-length (##make-u64vector 1)) 1)
(check-eqv? (##u64vector-length (##make-u64vector 10)) 10)
(check-eqv? (##u64vector-length (##make-u64vector 100)) 100)
(check-eqv? (##u64vector-length (##make-u64vector 1000)) 1000)
(check-eqv? (##u64vector-length (##make-u64vector 10000)) 10000)

(check-eqv? (##u64vector-length v4) 2)
(check-eqv? (##u64vector-length v5) 2)
(check-eqv? (##u64vector-length (##make-u64vector 0 11)) 0)
(check-eqv? (##u64vector-length (##make-u64vector 1 22)) 1)
(check-eqv? (##u64vector-length (##make-u64vector 10 33)) 10)
(check-eqv? (##u64vector-length (##make-u64vector 100 44)) 100)
(check-eqv? (##u64vector-length (##make-u64vector 1000 55)) 1000)
(check-eqv? (##u64vector-length (##make-u64vector 10000 66)) 10000)

(check-eqv? (##u64vector-ref v1 0) 0)
(check-eqv? (##u64vector-ref v1 1) 18446744073709551615)

(check-eqv? (##u64vector-ref v2 0) 0)
(check-eqv? (##u64vector-ref v2 1) 18446744073709551615)
(check-eqv? (##u64vector-ref v2 2) 0)
(check-eqv? (##u64vector-ref v2 3) 1)
(check-eqv? (##u64vector-ref v2 4) 18446744073709551615)

(check-eqv? (##u64vector-ref v4 0) 0)
(check-eqv? (##u64vector-ref v4 1) 0)

(check-eqv? (##u64vector-ref v5 0) 18446744073709551615)
(check-eqv? (##u64vector-ref v5 1) 18446744073709551615)

(check-equal? (##u64vector-set v2 1 99) '#u64(0 99 0 1 18446744073709551615))
(check-equal? v2 '#u64(0 18446744073709551615 0 1 18446744073709551615))
(check-equal? (##u64vector-set v4 1 99) '#u64(0 99))
(check-equal? (##u64vector-set v5 1 99) '#u64(18446744073709551615 99))
(check-equal? (##u64vector-set '#u64(11 22 33) 0 99) '#u64(99 22 33))

(check-eq? (##u64vector-set! v2 1 99) v2)
(check-eq? (##u64vector-set! v3 1 99) v3)
(check-eq? (##u64vector-set! v4 1 99) v4)
(check-eq? (##u64vector-set! v5 1 99) v5)

(check-eqv? (##u64vector-ref v2 0) 0)
(check-eqv? (##u64vector-ref v2 1) 99)
(check-eqv? (##u64vector-ref v2 2) 0)
(check-eqv? (##u64vector-ref v2 3) 1)
(check-eqv? (##u64vector-ref v2 4) 18446744073709551615)

(check-eqv? (##u64vector-ref v3 1) 99)

(check-eqv? (##u64vector-ref v4 0) 0)
(check-eqv? (##u64vector-ref v4 1) 99)

(check-eqv? (##u64vector-ref v5 0) 18446744073709551615)
(check-eqv? (##u64vector-ref v5 1) 99)

(check-eq? (##u64vector-shrink! v2 3) v2)
(check-eq? (##u64vector-shrink! v3 1) v3)
(check-eq? (##u64vector-shrink! v4 0) v4)
(check-eq? (##u64vector-shrink! v5 2) v5)

(check-eqv? (##u64vector-length v2) 3)
(check-eqv? (##u64vector-length v3) 1)
(check-eqv? (##u64vector-length v4) 0)
(check-eqv? (##u64vector-length v5) 2)

(check-true (u64vector? v1))
(check-true (u64vector? '#u64()))
(check-true (u64vector? '#u64(11)))
(check-true (u64vector? '#u64(11 22)))
(check-true (u64vector? '#u64(11 22 33)))
(check-true (u64vector? '#u64(11 22 33 44)))
(check-true (u64vector? '#u64(11 22 33 44 55)))

(check-true (u64vector? v6))
(check-true (u64vector? (u64vector)))
(check-true (u64vector? (u64vector 11)))
(check-true (u64vector? (u64vector 11 22)))
(check-true (u64vector? (u64vector 11 22 33)))
(check-true (u64vector? (u64vector 11 22 33 44)))
(check-true (u64vector? (u64vector 11 22 33 44 55)))

(check-true (u64vector? v7))
(check-true (u64vector? (make-u64vector 0)))
(check-true (u64vector? (make-u64vector 1)))
(check-true (u64vector? (make-u64vector 10)))
(check-true (u64vector? (make-u64vector 100)))
(check-true (u64vector? (make-u64vector 1000)))
(check-true (u64vector? (make-u64vector 10000)))

(check-true (u64vector? v8))
(check-true (u64vector? v9))
(check-true (u64vector? (make-u64vector 0 11)))
(check-true (u64vector? (make-u64vector 1 22)))
(check-true (u64vector? (make-u64vector 10 33)))
(check-true (u64vector? (make-u64vector 100 44)))
(check-true (u64vector? (make-u64vector 1000 55)))
(check-true (u64vector? (make-u64vector 10000 66)))

(check-eqv? (u64vector-length v1) 2)
(check-eqv? (u64vector-length '#u64()) 0)
(check-eqv? (u64vector-length '#u64(11)) 1)
(check-eqv? (u64vector-length '#u64(11 22)) 2)
(check-eqv? (u64vector-length '#u64(11 22 33)) 3)
(check-eqv? (u64vector-length '#u64(11 22 33 44)) 4)
(check-eqv? (u64vector-length '#u64(11 22 33 44 55)) 5)

(check-eqv? (u64vector-length v6) 5)
(check-eqv? (u64vector-length (u64vector)) 0)
(check-eqv? (u64vector-length (u64vector 11)) 1)
(check-eqv? (u64vector-length (u64vector 11 22)) 2)
(check-eqv? (u64vector-length (u64vector 11 22 33)) 3)
(check-eqv? (u64vector-length (u64vector 11 22 33 44)) 4)
(check-eqv? (u64vector-length (u64vector 11 22 33 44 55)) 5)

(check-eqv? (u64vector-length v7) 2)
(check-eqv? (u64vector-length (make-u64vector 0)) 0)
(check-eqv? (u64vector-length (make-u64vector 1)) 1)
(check-eqv? (u64vector-length (make-u64vector 10)) 10)
(check-eqv? (u64vector-length (make-u64vector 100)) 100)
(check-eqv? (u64vector-length (make-u64vector 1000)) 1000)
(check-eqv? (u64vector-length (make-u64vector 10000)) 10000)

(check-eqv? (u64vector-length v8) 2)
(check-eqv? (u64vector-length v9) 2)
(check-eqv? (u64vector-length (make-u64vector 0 11)) 0)
(check-eqv? (u64vector-length (make-u64vector 1 22)) 1)
(check-eqv? (u64vector-length (make-u64vector 10 33)) 10)
(check-eqv? (u64vector-length (make-u64vector 100 44)) 100)
(check-eqv? (u64vector-length (make-u64vector 1000 55)) 1000)
(check-eqv? (u64vector-length (make-u64vector 10000 66)) 10000)

(check-equal? (u64vector->list '#u64()) '())
(check-equal? (u64vector->list v6) '(0 18446744073709551615 0 1 18446744073709551615))
(check-equal? (u64vector->list v7) '(0 0))

(check-equal? (list->u64vector '()) '#u64())
(check-equal? (list->u64vector '(0 18446744073709551615 0 1 18446744073709551615)) v6)
(check-equal? (list->u64vector '(0 0)) v7)

(check-equal? (u64vector-append) '#u64())
(check-equal? (u64vector-append v6) v6)
(check-equal? (u64vector-append '#u64(0 18446744073709551615) '#u64(0 1 18446744073709551615)) v6)
(check-equal? (u64vector-append v6 v7 v6) '#u64(0 18446744073709551615 0 1 18446744073709551615 0 0 0 18446744073709551615 0 1 18446744073709551615))

(check-equal? (append-u64vectors (list v6 v7 v6)) '#u64(0 18446744073709551615 0 1 18446744073709551615 0 0 0 18446744073709551615 0 1 18446744073709551615))

(check-equal? (u64vector-copy '#u64()) '#u64())
(check-equal? (u64vector-copy v6) v6)

(check-equal? (subu64vector v6 0 0) '#u64())
(check-equal? (subu64vector v6 4 4) '#u64())
(check-equal? (subu64vector v6 0 2) '#u64(0 18446744073709551615))
(check-equal? (subu64vector v6 2 4) '#u64(0 1))
(check-equal? (subu64vector v6 4 5) '#u64(18446744073709551615))
(check-equal? (subu64vector v6 0 5) v6)

(check-eqv? (u64vector-ref v1 0) 0)
(check-eqv? (u64vector-ref v1 1) 18446744073709551615)

(check-eqv? (u64vector-ref v6 0) 0)
(check-eqv? (u64vector-ref v6 1) 18446744073709551615)
(check-eqv? (u64vector-ref v6 2) 0)
(check-eqv? (u64vector-ref v6 3) 1)
(check-eqv? (u64vector-ref v6 4) 18446744073709551615)

(check-eqv? (u64vector-ref v7 0) 0)
(check-eqv? (u64vector-ref v7 1) 0)

(check-eqv? (u64vector-ref v8 0) 0)
(check-eqv? (u64vector-ref v8 1) 0)

(check-eqv? (u64vector-ref v9 0) 18446744073709551615)
(check-eqv? (u64vector-ref v9 1) 18446744073709551615)

(check-equal? (u64vector-set v6 1 99) '#u64(0 99 0 1 18446744073709551615))
(check-equal? v6 '#u64(0 18446744073709551615 0 1 18446744073709551615))
(check-equal? (u64vector-set v8 1 99) '#u64(0 99))
(check-equal? (u64vector-set v9 1 99) '#u64(18446744073709551615 99))
(check-equal? (u64vector-set '#u64(11 22 33) 0 99) '#u64(99 22 33))

(check-eq? (u64vector-set! v6 1 99) (void))
(check-eq? (u64vector-set! v7 1 99) (void))
(check-eq? (u64vector-set! v8 1 99) (void))
(check-eq? (u64vector-set! v9 1 99) (void))

(check-eqv? (u64vector-ref v6 0) 0)
(check-eqv? (u64vector-ref v6 1) 99)
(check-eqv? (u64vector-ref v6 2) 0)
(check-eqv? (u64vector-ref v6 3) 1)
(check-eqv? (u64vector-ref v6 4) 18446744073709551615)

(check-eqv? (u64vector-ref v7 0) 0)
(check-eqv? (u64vector-ref v7 1) 99)

(check-eqv? (u64vector-ref v8 0) 0)
(check-eqv? (u64vector-ref v8 1) 99)

(check-eqv? (u64vector-ref v9 0) 18446744073709551615)
(check-eqv? (u64vector-ref v9 1) 99)

(check-eq? (u64vector-shrink! v6 3) (void))
(check-eq? (u64vector-shrink! v7 1) (void))
(check-eq? (u64vector-shrink! v8 0) (void))
(check-eq? (u64vector-shrink! v9 2) (void))

(check-eqv? (u64vector-length v6) 3)
(check-eqv? (u64vector-length v7) 1)
(check-eqv? (u64vector-length v8) 0)
(check-eqv? (u64vector-length v9) 2)

(check-eq? (u64vector-fill! v6 0) (void))
(check-equal? v6 '#u64(0 0 0))

(check-eq? (u64vector-fill! v6 18446744073709551615) (void))
(check-equal? v6 '#u64(18446744073709551615 18446744073709551615 18446744073709551615))

(check-eq? (subu64vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#u64(9 9 9))

(check-eq? (subu64vector-fill! v6 1 2 0) (void))
(check-equal? v6 '#u64(9 0 9))

(check-eq? (subu64vector-fill! v6 1 3 18446744073709551615) (void))
(check-equal? v6 '#u64(9 18446744073709551615 18446744073709551615))

(check-eq? (subu64vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#u64(18446744073709551615 99 18446744073709551615))

(check-eq? (subu64vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#u64(18446744073709551615 18446744073709551615 99))

(check-tail-exn type-exception? (lambda () (u64vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector 11 -1 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector 11 18446744073709551616 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-u64vector bool)))
(check-tail-exn type-exception? (lambda () (make-u64vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u64vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u64vector 11 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u64vector 11 18446744073709551616))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-u64vector -1 0)))

(check-tail-exn type-exception? (lambda () (u64vector-length bool)))

(check-tail-exn type-exception? (lambda () (u64vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u64vector bool)))

(check-tail-exn type-exception? (lambda () (u64vector-append bool)))
(check-tail-exn type-exception? (lambda () (u64vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (u64vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-u64vectors bool)))
(check-tail-exn type-exception? (lambda () (append-u64vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (u64vector-copy bool)))

(check-tail-exn type-exception? (lambda () (subu64vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu64vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subu64vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subu64vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subu64vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subu64vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subu64vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (u64vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u64vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (u64vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (u64vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (u64vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-set v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-set v5 0 18446744073709551616))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u64vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u64vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (u64vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u64vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-set! v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-set! v5 0 18446744073709551616))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u64vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u64vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (u64vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (u64vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (u64vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (u64vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (u64vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-fill! v5 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u64vector-fill! v5 18446744073709551616))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subu64vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu64vector-fill! v5 0 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu64vector-fill! v5 0 0 18446744073709551616))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subu64vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subu64vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu64vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subu64vector-move! v5 0 0 v5 3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u64vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector->list v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u64vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u64vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u64vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-copy v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u64vector-fill! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu64vector-move! v9 0 0 v9 0 0)))

(check-tail-exn range-exception? (lambda () (make-u64vector (expt 2 64))))
