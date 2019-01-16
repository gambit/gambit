(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u8(0 255))

(define v2 (##u8vector 0 255 0 1 255))
(define v3 (##make-u8vector 2))
(define v4 (##make-u8vector 2 0))
(define v5 (##make-u8vector 2 255))

(define v6 (u8vector 0 255 0 1 255))
(define v7 (make-u8vector 2))
(define v8 (make-u8vector 2 0))
(define v9 (make-u8vector 2 255))

(check-false (##u8vector? str))
(check-false (##u8vector? int))
(check-false (##u8vector? bool))

(check-true (##u8vector? v1))
(check-true (##u8vector? '#u8()))
(check-true (##u8vector? '#u8(11)))
(check-true (##u8vector? '#u8(11 22)))
(check-true (##u8vector? '#u8(11 22 33)))
(check-true (##u8vector? '#u8(11 22 33 44)))
(check-true (##u8vector? '#u8(11 22 33 44 55)))

(check-true (##u8vector? v2))
(check-true (##u8vector? (##u8vector)))
(check-true (##u8vector? (##u8vector 11)))
(check-true (##u8vector? (##u8vector 11 22)))
(check-true (##u8vector? (##u8vector 11 22 33)))
(check-true (##u8vector? (##u8vector 11 22 33 44)))
(check-true (##u8vector? (##u8vector 11 22 33 44 55)))

(check-true (##u8vector? v3))
(check-true (##u8vector? (##make-u8vector 0)))
(check-true (##u8vector? (##make-u8vector 1)))
(check-true (##u8vector? (##make-u8vector 10)))
(check-true (##u8vector? (##make-u8vector 100)))
(check-true (##u8vector? (##make-u8vector 1000)))
(check-true (##u8vector? (##make-u8vector 10000)))

(check-true (##u8vector? v4))
(check-true (##u8vector? v5))
(check-true (##u8vector? (##make-u8vector 0 11)))
(check-true (##u8vector? (##make-u8vector 1 22)))
(check-true (##u8vector? (##make-u8vector 10 33)))
(check-true (##u8vector? (##make-u8vector 100 44)))
(check-true (##u8vector? (##make-u8vector 1000 55)))
(check-true (##u8vector? (##make-u8vector 10000 66)))

(check-eqv? (##u8vector-length v1) 2)
(check-eqv? (##u8vector-length '#u8()) 0)
(check-eqv? (##u8vector-length '#u8(11)) 1)
(check-eqv? (##u8vector-length '#u8(11 22)) 2)
(check-eqv? (##u8vector-length '#u8(11 22 33)) 3)
(check-eqv? (##u8vector-length '#u8(11 22 33 44)) 4)
(check-eqv? (##u8vector-length '#u8(11 22 33 44 55)) 5)

(check-eqv? (##u8vector-length v2) 5)
(check-eqv? (##u8vector-length (##u8vector)) 0)
(check-eqv? (##u8vector-length (##u8vector 11)) 1)
(check-eqv? (##u8vector-length (##u8vector 11 22)) 2)
(check-eqv? (##u8vector-length (##u8vector 11 22 33)) 3)
(check-eqv? (##u8vector-length (##u8vector 11 22 33 44)) 4)
(check-eqv? (##u8vector-length (##u8vector 11 22 33 44 55)) 5)

(check-eqv? (##u8vector-length v3) 2)
(check-eqv? (##u8vector-length (##make-u8vector 0)) 0)
(check-eqv? (##u8vector-length (##make-u8vector 1)) 1)
(check-eqv? (##u8vector-length (##make-u8vector 10)) 10)
(check-eqv? (##u8vector-length (##make-u8vector 100)) 100)
(check-eqv? (##u8vector-length (##make-u8vector 1000)) 1000)
(check-eqv? (##u8vector-length (##make-u8vector 10000)) 10000)

(check-eqv? (##u8vector-length v4) 2)
(check-eqv? (##u8vector-length v5) 2)
(check-eqv? (##u8vector-length (##make-u8vector 0 11)) 0)
(check-eqv? (##u8vector-length (##make-u8vector 1 22)) 1)
(check-eqv? (##u8vector-length (##make-u8vector 10 33)) 10)
(check-eqv? (##u8vector-length (##make-u8vector 100 44)) 100)
(check-eqv? (##u8vector-length (##make-u8vector 1000 55)) 1000)
(check-eqv? (##u8vector-length (##make-u8vector 10000 66)) 10000)

(check-eqv? (##u8vector-ref v1 0) 0)
(check-eqv? (##u8vector-ref v1 1) 255)

(check-eqv? (##u8vector-ref v2 0) 0)
(check-eqv? (##u8vector-ref v2 1) 255)
(check-eqv? (##u8vector-ref v2 2) 0)
(check-eqv? (##u8vector-ref v2 3) 1)
(check-eqv? (##u8vector-ref v2 4) 255)

(check-eqv? (##u8vector-ref v4 0) 0)
(check-eqv? (##u8vector-ref v4 1) 0)

(check-eqv? (##u8vector-ref v5 0) 255)
(check-eqv? (##u8vector-ref v5 1) 255)

(check-equal? (##u8vector-set v2 1 99) '#u8(0 99 0 1 255))
(check-equal? v2 '#u8(0 255 0 1 255))
(check-equal? (##u8vector-set v4 1 99) '#u8(0 99))
(check-equal? (##u8vector-set v5 1 99) '#u8(255 99))
(check-equal? (##u8vector-set '#u8(11 22 33) 0 99) '#u8(99 22 33))

(check-eq? (##u8vector-set! v2 1 99) v2)
(check-eq? (##u8vector-set! v3 1 99) v3)
(check-eq? (##u8vector-set! v4 1 99) v4)
(check-eq? (##u8vector-set! v5 1 99) v5)

(check-eqv? (##u8vector-ref v2 0) 0)
(check-eqv? (##u8vector-ref v2 1) 99)
(check-eqv? (##u8vector-ref v2 2) 0)
(check-eqv? (##u8vector-ref v2 3) 1)
(check-eqv? (##u8vector-ref v2 4) 255)

(check-eqv? (##u8vector-ref v3 1) 99)

(check-eqv? (##u8vector-ref v4 0) 0)
(check-eqv? (##u8vector-ref v4 1) 99)

(check-eqv? (##u8vector-ref v5 0) 255)
(check-eqv? (##u8vector-ref v5 1) 99)

(check-eq? (##u8vector-shrink! v2 3) v2)
(check-eq? (##u8vector-shrink! v3 1) v3)
(check-eq? (##u8vector-shrink! v4 0) v4)
(check-eq? (##u8vector-shrink! v5 2) v5)

(check-eqv? (##u8vector-length v2) 3)
(check-eqv? (##u8vector-length v3) 1)
(check-eqv? (##u8vector-length v4) 0)
(check-eqv? (##u8vector-length v5) 2)

(check-true (u8vector? v1))
(check-true (u8vector? '#u8()))
(check-true (u8vector? '#u8(11)))
(check-true (u8vector? '#u8(11 22)))
(check-true (u8vector? '#u8(11 22 33)))
(check-true (u8vector? '#u8(11 22 33 44)))
(check-true (u8vector? '#u8(11 22 33 44 55)))

(check-true (u8vector? v6))
(check-true (u8vector? (u8vector)))
(check-true (u8vector? (u8vector 11)))
(check-true (u8vector? (u8vector 11 22)))
(check-true (u8vector? (u8vector 11 22 33)))
(check-true (u8vector? (u8vector 11 22 33 44)))
(check-true (u8vector? (u8vector 11 22 33 44 55)))

(check-true (u8vector? v7))
(check-true (u8vector? (make-u8vector 0)))
(check-true (u8vector? (make-u8vector 1)))
(check-true (u8vector? (make-u8vector 10)))
(check-true (u8vector? (make-u8vector 100)))
(check-true (u8vector? (make-u8vector 1000)))
(check-true (u8vector? (make-u8vector 10000)))

(check-true (u8vector? v8))
(check-true (u8vector? v9))
(check-true (u8vector? (make-u8vector 0 11)))
(check-true (u8vector? (make-u8vector 1 22)))
(check-true (u8vector? (make-u8vector 10 33)))
(check-true (u8vector? (make-u8vector 100 44)))
(check-true (u8vector? (make-u8vector 1000 55)))
(check-true (u8vector? (make-u8vector 10000 66)))

(check-eqv? (u8vector-length v1) 2)
(check-eqv? (u8vector-length '#u8()) 0)
(check-eqv? (u8vector-length '#u8(11)) 1)
(check-eqv? (u8vector-length '#u8(11 22)) 2)
(check-eqv? (u8vector-length '#u8(11 22 33)) 3)
(check-eqv? (u8vector-length '#u8(11 22 33 44)) 4)
(check-eqv? (u8vector-length '#u8(11 22 33 44 55)) 5)

(check-eqv? (u8vector-length v6) 5)
(check-eqv? (u8vector-length (u8vector)) 0)
(check-eqv? (u8vector-length (u8vector 11)) 1)
(check-eqv? (u8vector-length (u8vector 11 22)) 2)
(check-eqv? (u8vector-length (u8vector 11 22 33)) 3)
(check-eqv? (u8vector-length (u8vector 11 22 33 44)) 4)
(check-eqv? (u8vector-length (u8vector 11 22 33 44 55)) 5)

(check-eqv? (u8vector-length v7) 2)
(check-eqv? (u8vector-length (make-u8vector 0)) 0)
(check-eqv? (u8vector-length (make-u8vector 1)) 1)
(check-eqv? (u8vector-length (make-u8vector 10)) 10)
(check-eqv? (u8vector-length (make-u8vector 100)) 100)
(check-eqv? (u8vector-length (make-u8vector 1000)) 1000)
(check-eqv? (u8vector-length (make-u8vector 10000)) 10000)

(check-eqv? (u8vector-length v8) 2)
(check-eqv? (u8vector-length v9) 2)
(check-eqv? (u8vector-length (make-u8vector 0 11)) 0)
(check-eqv? (u8vector-length (make-u8vector 1 22)) 1)
(check-eqv? (u8vector-length (make-u8vector 10 33)) 10)
(check-eqv? (u8vector-length (make-u8vector 100 44)) 100)
(check-eqv? (u8vector-length (make-u8vector 1000 55)) 1000)
(check-eqv? (u8vector-length (make-u8vector 10000 66)) 10000)

(check-equal? (u8vector->list '#u8()) '())
(check-equal? (u8vector->list v6) '(0 255 0 1 255))
(check-equal? (u8vector->list v6 0) '(0 255 0 1 255))
(check-equal? (u8vector->list v6 2) '(0 1 255))
(check-equal? (u8vector->list v6 2 4) '(0 1))
(check-equal? (u8vector->list v6 0 5) '(0 255 0 1 255))
(check-equal? (u8vector->list v7) '(0 0))

(check-equal? (list->u8vector '()) '#u8())
(check-equal? (list->u8vector '(0 255 0 1 255)) v6)
(check-equal? (list->u8vector '(0 0)) v7)

(check-equal? (u8vector-append) '#u8())
(check-equal? (u8vector-append v6) v6)
(check-equal? (u8vector-append '#u8(0 255) '#u8(0 1 255)) v6)
(check-equal? (u8vector-append v6 v7 v6) '#u8(0 255 0 1 255 0 0 0 255 0 1 255))

(check-equal? (append-u8vectors (list v6 v7 v6)) '#u8(0 255 0 1 255 0 0 0 255 0 1 255))

(check-equal? (u8vector-copy '#u8()) '#u8())
(check-equal? (u8vector-copy v6) v6)
(check-equal? (u8vector-copy v6 0) v6)
(check-equal? (u8vector-copy v6 2) '#u8(0 1 255))
(check-equal? (u8vector-copy v6 0 0) '#u8())
(check-equal? (u8vector-copy v6 4 4) '#u8())
(check-equal? (u8vector-copy v6 0 2) '#u8(0 255))
(check-equal? (u8vector-copy v6 2 4) '#u8(0 1))
(check-equal? (u8vector-copy v6 4 5) '#u8(255))
(check-equal? (u8vector-copy v6 0 5) v6)

(check-equal? (subu8vector v6 0 0) '#u8())
(check-equal? (subu8vector v6 4 4) '#u8())
(check-equal? (subu8vector v6 0 2) '#u8(0 255))
(check-equal? (subu8vector v6 2 4) '#u8(0 1))
(check-equal? (subu8vector v6 4 5) '#u8(255))
(check-equal? (subu8vector v6 0 5) v6)

(check-eqv? (u8vector-ref v1 0) 0)
(check-eqv? (u8vector-ref v1 1) 255)

(check-eqv? (u8vector-ref v6 0) 0)
(check-eqv? (u8vector-ref v6 1) 255)
(check-eqv? (u8vector-ref v6 2) 0)
(check-eqv? (u8vector-ref v6 3) 1)
(check-eqv? (u8vector-ref v6 4) 255)

(check-eqv? (u8vector-ref v7 0) 0)
(check-eqv? (u8vector-ref v7 1) 0)

(check-eqv? (u8vector-ref v8 0) 0)
(check-eqv? (u8vector-ref v8 1) 0)

(check-eqv? (u8vector-ref v9 0) 255)
(check-eqv? (u8vector-ref v9 1) 255)

(check-equal? (u8vector-set v6 1 99) '#u8(0 99 0 1 255))
(check-equal? v6 '#u8(0 255 0 1 255))
(check-equal? (u8vector-set v8 1 99) '#u8(0 99))
(check-equal? (u8vector-set v9 1 99) '#u8(255 99))
(check-equal? (u8vector-set '#u8(11 22 33) 0 99) '#u8(99 22 33))

(check-eq? (u8vector-set! v6 1 99) (void))
(check-eq? (u8vector-set! v7 1 99) (void))
(check-eq? (u8vector-set! v8 1 99) (void))
(check-eq? (u8vector-set! v9 1 99) (void))

(check-eqv? (u8vector-ref v6 0) 0)
(check-eqv? (u8vector-ref v6 1) 99)
(check-eqv? (u8vector-ref v6 2) 0)
(check-eqv? (u8vector-ref v6 3) 1)
(check-eqv? (u8vector-ref v6 4) 255)

(check-eqv? (u8vector-ref v7 0) 0)
(check-eqv? (u8vector-ref v7 1) 99)

(check-eqv? (u8vector-ref v8 0) 0)
(check-eqv? (u8vector-ref v8 1) 99)

(check-eqv? (u8vector-ref v9 0) 255)
(check-eqv? (u8vector-ref v9 1) 99)

(check-eq? (u8vector-shrink! v6 3) (void))
(check-eq? (u8vector-shrink! v7 1) (void))
(check-eq? (u8vector-shrink! v8 0) (void))
(check-eq? (u8vector-shrink! v9 2) (void))

(check-eqv? (u8vector-length v6) 3)
(check-eqv? (u8vector-length v7) 1)
(check-eqv? (u8vector-length v8) 0)
(check-eqv? (u8vector-length v9) 2)

(check-eq? (u8vector-fill! v6 0) (void))
(check-equal? v6 '#u8(0 0 0))

(check-eq? (u8vector-fill! v6 255) (void))
(check-equal? v6 '#u8(255 255 255))

(check-eq? (u8vector-fill! v6 3 1) (void))
(check-equal? v6 '#u8(255 3 3))

(check-eq? (u8vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#u8(99 99 3))

(check-eq? (subu8vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#u8(9 9 9))

(check-eq? (subu8vector-fill! v6 1 2 0) (void))
(check-equal? v6 '#u8(9 0 9))

(check-eq? (subu8vector-fill! v6 1 3 255) (void))
(check-equal? v6 '#u8(9 255 255))

(check-eq? (subu8vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#u8(255 99 255))

(check-eq? (subu8vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#u8(255 255 99))

(check-eq? (u8vector-copy! v6 0 '#u8(11 22 33)) (void))
(check-equal? v6 '#u8(11 22 33))

(check-eq? (u8vector-copy! v6 2 '#u8(33 44) 1) (void))
(check-equal? v6 '#u8(11 22 44))

(check-eq? (u8vector-copy! v6 1 '#u8(55 66 77 88) 0 2) (void))
(check-equal? v6 '#u8(11 55 66))

(check-tail-exn type-exception? (lambda () (u8vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector 11 -1 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector 11 256 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-u8vector bool)))
(check-tail-exn type-exception? (lambda () (make-u8vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u8vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u8vector 11 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-u8vector 11 256))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-u8vector -1 0)))

(check-tail-exn type-exception? (lambda () (u8vector-length bool)))

(check-tail-exn type-exception? (lambda () (u8vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u8vector bool)))

(check-tail-exn type-exception? (lambda () (u8vector-append bool)))
(check-tail-exn type-exception? (lambda () (u8vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (u8vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-u8vectors bool)))
(check-tail-exn type-exception? (lambda () (append-u8vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (u8vector-copy bool)))
(check-tail-exn type-exception? (lambda () (u8vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (u8vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subu8vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu8vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subu8vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subu8vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subu8vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subu8vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subu8vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (u8vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u8vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (u8vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (u8vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (u8vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-set v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-set v5 0 256))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u8vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u8vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (u8vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u8vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-set! v5 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-set! v5 0 256))) ;; homovect only
(check-tail-exn range-exception? (lambda () (u8vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u8vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (u8vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (u8vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (u8vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (u8vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (u8vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (u8vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (u8vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-fill! v5 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (u8vector-fill! v5 256))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subu8vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu8vector-fill! v5 0 0 -1))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subu8vector-fill! v5 0 0 256))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subu8vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subu8vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu8vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subu8vector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (u8vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (u8vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (u8vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (u8vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (u8vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (u8vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u8vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u8vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u8vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u8vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu8vector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u8vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-u8vector (expt 2 64))))
