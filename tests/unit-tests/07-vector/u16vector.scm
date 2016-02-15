(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u16(0 65535))

(define v2 (##u16vector 0 65535 0 1 65535))
(define v3 (##make-u16vector 2))
(define v4 (##make-u16vector 2 0))
(define v5 (##make-u16vector 2 65535))

(define v6 (u16vector 0 65535 0 1 65535))
(define v7 (make-u16vector 2))
(define v8 (make-u16vector 2 0))
(define v9 (make-u16vector 2 65535))

(check-false (##u16vector? str))
(check-false (##u16vector? int))
(check-false (##u16vector? bool))

(check-true (##u16vector? v1))
(check-true (##u16vector? '#u16()))
(check-true (##u16vector? '#u16(11)))
(check-true (##u16vector? '#u16(11 22)))
(check-true (##u16vector? '#u16(11 22 33)))
(check-true (##u16vector? '#u16(11 22 33 44)))
(check-true (##u16vector? '#u16(11 22 33 44 55)))

(check-true (##u16vector? v2))
(check-true (##u16vector? (##u16vector)))
(check-true (##u16vector? (##u16vector 11)))
(check-true (##u16vector? (##u16vector 11 22)))
(check-true (##u16vector? (##u16vector 11 22 33)))
(check-true (##u16vector? (##u16vector 11 22 33 44)))
(check-true (##u16vector? (##u16vector 11 22 33 44 55)))

(check-true (##u16vector? v3))
(check-true (##u16vector? (##make-u16vector 0)))
(check-true (##u16vector? (##make-u16vector 1)))
(check-true (##u16vector? (##make-u16vector 10)))
(check-true (##u16vector? (##make-u16vector 100)))
(check-true (##u16vector? (##make-u16vector 1000)))
(check-true (##u16vector? (##make-u16vector 10000)))

(check-true (##u16vector? v4))
(check-true (##u16vector? v5))
(check-true (##u16vector? (##make-u16vector 0 11)))
(check-true (##u16vector? (##make-u16vector 1 22)))
(check-true (##u16vector? (##make-u16vector 10 33)))
(check-true (##u16vector? (##make-u16vector 100 44)))
(check-true (##u16vector? (##make-u16vector 1000 55)))
(check-true (##u16vector? (##make-u16vector 10000 66)))

(check-eqv? (##u16vector-length v1) 2)
(check-eqv? (##u16vector-length '#u16()) 0)
(check-eqv? (##u16vector-length '#u16(11)) 1)
(check-eqv? (##u16vector-length '#u16(11 22)) 2)
(check-eqv? (##u16vector-length '#u16(11 22 33)) 3)
(check-eqv? (##u16vector-length '#u16(11 22 33 44)) 4)
(check-eqv? (##u16vector-length '#u16(11 22 33 44 55)) 5)

(check-eqv? (##u16vector-length v2) 5)
(check-eqv? (##u16vector-length (##u16vector)) 0)
(check-eqv? (##u16vector-length (##u16vector 11)) 1)
(check-eqv? (##u16vector-length (##u16vector 11 22)) 2)
(check-eqv? (##u16vector-length (##u16vector 11 22 33)) 3)
(check-eqv? (##u16vector-length (##u16vector 11 22 33 44)) 4)
(check-eqv? (##u16vector-length (##u16vector 11 22 33 44 55)) 5)

(check-eqv? (##u16vector-length v3) 2)
(check-eqv? (##u16vector-length (##make-u16vector 0)) 0)
(check-eqv? (##u16vector-length (##make-u16vector 1)) 1)
(check-eqv? (##u16vector-length (##make-u16vector 10)) 10)
(check-eqv? (##u16vector-length (##make-u16vector 100)) 100)
(check-eqv? (##u16vector-length (##make-u16vector 1000)) 1000)
(check-eqv? (##u16vector-length (##make-u16vector 10000)) 10000)

(check-eqv? (##u16vector-length v4) 2)
(check-eqv? (##u16vector-length v5) 2)
(check-eqv? (##u16vector-length (##make-u16vector 0 11)) 0)
(check-eqv? (##u16vector-length (##make-u16vector 1 22)) 1)
(check-eqv? (##u16vector-length (##make-u16vector 10 33)) 10)
(check-eqv? (##u16vector-length (##make-u16vector 100 44)) 100)
(check-eqv? (##u16vector-length (##make-u16vector 1000 55)) 1000)
(check-eqv? (##u16vector-length (##make-u16vector 10000 66)) 10000)

(check-eqv? (##u16vector-ref v1 0) 0)
(check-eqv? (##u16vector-ref v1 1) 65535)

(check-eqv? (##u16vector-ref v2 0) 0)
(check-eqv? (##u16vector-ref v2 1) 65535)
(check-eqv? (##u16vector-ref v2 2) 0)
(check-eqv? (##u16vector-ref v2 3) 1)
(check-eqv? (##u16vector-ref v2 4) 65535)

(check-eqv? (##u16vector-ref v4 0) 0)
(check-eqv? (##u16vector-ref v4 1) 0)

(check-eqv? (##u16vector-ref v5 0) 65535)
(check-eqv? (##u16vector-ref v5 1) 65535)

(check-eq? (##u16vector-set! v2 1 99) v2)
(check-eq? (##u16vector-set! v3 1 99) v3)
(check-eq? (##u16vector-set! v4 1 99) v4)
(check-eq? (##u16vector-set! v5 1 99) v5)

(check-eqv? (##u16vector-ref v2 0) 0)
(check-eqv? (##u16vector-ref v2 1) 99)
(check-eqv? (##u16vector-ref v2 2) 0)
(check-eqv? (##u16vector-ref v2 3) 1)
(check-eqv? (##u16vector-ref v2 4) 65535)

(check-eqv? (##u16vector-ref v3 1) 99)

(check-eqv? (##u16vector-ref v4 0) 0)
(check-eqv? (##u16vector-ref v4 1) 99)

(check-eqv? (##u16vector-ref v5 0) 65535)
(check-eqv? (##u16vector-ref v5 1) 99)

(check-eq? (##u16vector-shrink! v2 3) v2)
(check-eq? (##u16vector-shrink! v3 1) v3)
(check-eq? (##u16vector-shrink! v4 0) v4)
(check-eq? (##u16vector-shrink! v5 2) v5)

(check-eqv? (##u16vector-length v2) 3)
(check-eqv? (##u16vector-length v3) 1)
(check-eqv? (##u16vector-length v4) 0)
(check-eqv? (##u16vector-length v5) 2)

(check-true (u16vector? v1))
(check-true (u16vector? '#u16()))
(check-true (u16vector? '#u16(11)))
(check-true (u16vector? '#u16(11 22)))
(check-true (u16vector? '#u16(11 22 33)))
(check-true (u16vector? '#u16(11 22 33 44)))
(check-true (u16vector? '#u16(11 22 33 44 55)))

(check-true (u16vector? v6))
(check-true (u16vector? (u16vector)))
(check-true (u16vector? (u16vector 11)))
(check-true (u16vector? (u16vector 11 22)))
(check-true (u16vector? (u16vector 11 22 33)))
(check-true (u16vector? (u16vector 11 22 33 44)))
(check-true (u16vector? (u16vector 11 22 33 44 55)))

(check-true (u16vector? v7))
(check-true (u16vector? (make-u16vector 0)))
(check-true (u16vector? (make-u16vector 1)))
(check-true (u16vector? (make-u16vector 10)))
(check-true (u16vector? (make-u16vector 100)))
(check-true (u16vector? (make-u16vector 1000)))
(check-true (u16vector? (make-u16vector 10000)))

(check-true (u16vector? v8))
(check-true (u16vector? v9))
(check-true (u16vector? (make-u16vector 0 11)))
(check-true (u16vector? (make-u16vector 1 22)))
(check-true (u16vector? (make-u16vector 10 33)))
(check-true (u16vector? (make-u16vector 100 44)))
(check-true (u16vector? (make-u16vector 1000 55)))
(check-true (u16vector? (make-u16vector 10000 66)))

(check-eqv? (u16vector-length v1) 2)
(check-eqv? (u16vector-length '#u16()) 0)
(check-eqv? (u16vector-length '#u16(11)) 1)
(check-eqv? (u16vector-length '#u16(11 22)) 2)
(check-eqv? (u16vector-length '#u16(11 22 33)) 3)
(check-eqv? (u16vector-length '#u16(11 22 33 44)) 4)
(check-eqv? (u16vector-length '#u16(11 22 33 44 55)) 5)

(check-eqv? (u16vector-length v6) 5)
(check-eqv? (u16vector-length (u16vector)) 0)
(check-eqv? (u16vector-length (u16vector 11)) 1)
(check-eqv? (u16vector-length (u16vector 11 22)) 2)
(check-eqv? (u16vector-length (u16vector 11 22 33)) 3)
(check-eqv? (u16vector-length (u16vector 11 22 33 44)) 4)
(check-eqv? (u16vector-length (u16vector 11 22 33 44 55)) 5)

(check-eqv? (u16vector-length v7) 2)
(check-eqv? (u16vector-length (make-u16vector 0)) 0)
(check-eqv? (u16vector-length (make-u16vector 1)) 1)
(check-eqv? (u16vector-length (make-u16vector 10)) 10)
(check-eqv? (u16vector-length (make-u16vector 100)) 100)
(check-eqv? (u16vector-length (make-u16vector 1000)) 1000)
(check-eqv? (u16vector-length (make-u16vector 10000)) 10000)

(check-eqv? (u16vector-length v8) 2)
(check-eqv? (u16vector-length v9) 2)
(check-eqv? (u16vector-length (make-u16vector 0 11)) 0)
(check-eqv? (u16vector-length (make-u16vector 1 22)) 1)
(check-eqv? (u16vector-length (make-u16vector 10 33)) 10)
(check-eqv? (u16vector-length (make-u16vector 100 44)) 100)
(check-eqv? (u16vector-length (make-u16vector 1000 55)) 1000)
(check-eqv? (u16vector-length (make-u16vector 10000 66)) 10000)

(check-equal? (u16vector->list '#u16()) '())
(check-equal? (u16vector->list v6) '(0 65535 0 1 65535))
(check-equal? (u16vector->list v7) '(0 0))

(check-equal? (list->u16vector '()) '#u16())
(check-equal? (list->u16vector '(0 65535 0 1 65535)) v6)
(check-equal? (list->u16vector '(0 0)) v7)

(check-equal? (u16vector-append) '#u16())
(check-equal? (u16vector-append v6) v6)
(check-equal? (u16vector-append '#u16(0 65535) '#u16(0 1 65535)) v6)
(check-equal? (u16vector-append v6 v7 v6) '#u16(0 65535 0 1 65535 0 0 0 65535 0 1 65535))

(check-equal? (append-u16vectors (list v6 v7 v6)) '#u16(0 65535 0 1 65535 0 0 0 65535 0 1 65535))

(check-equal? (u16vector-copy '#u16()) '#u16())
(check-equal? (u16vector-copy v6) v6)

(check-equal? (subu16vector v6 0 0) '#u16())
(check-equal? (subu16vector v6 4 4) '#u16())
(check-equal? (subu16vector v6 0 2) '#u16(0 65535))
(check-equal? (subu16vector v6 2 4) '#u16(0 1))
(check-equal? (subu16vector v6 4 5) '#u16(65535))
(check-equal? (subu16vector v6 0 5) v6)

(check-eqv? (u16vector-ref v1 0) 0)
(check-eqv? (u16vector-ref v1 1) 65535)

(check-eqv? (u16vector-ref v6 0) 0)
(check-eqv? (u16vector-ref v6 1) 65535)
(check-eqv? (u16vector-ref v6 2) 0)
(check-eqv? (u16vector-ref v6 3) 1)
(check-eqv? (u16vector-ref v6 4) 65535)

(check-eqv? (u16vector-ref v7 0) 0)
(check-eqv? (u16vector-ref v7 1) 0)

(check-eqv? (u16vector-ref v8 0) 0)
(check-eqv? (u16vector-ref v8 1) 0)

(check-eqv? (u16vector-ref v9 0) 65535)
(check-eqv? (u16vector-ref v9 1) 65535)

(check-eq? (u16vector-set! v6 1 99) (void))
(check-eq? (u16vector-set! v7 1 99) (void))
(check-eq? (u16vector-set! v8 1 99) (void))
(check-eq? (u16vector-set! v9 1 99) (void))

(check-eqv? (u16vector-ref v6 0) 0)
(check-eqv? (u16vector-ref v6 1) 99)
(check-eqv? (u16vector-ref v6 2) 0)
(check-eqv? (u16vector-ref v6 3) 1)
(check-eqv? (u16vector-ref v6 4) 65535)

(check-eqv? (u16vector-ref v7 0) 0)
(check-eqv? (u16vector-ref v7 1) 99)

(check-eqv? (u16vector-ref v8 0) 0)
(check-eqv? (u16vector-ref v8 1) 99)

(check-eqv? (u16vector-ref v9 0) 65535)
(check-eqv? (u16vector-ref v9 1) 99)

(check-eq? (u16vector-shrink! v6 3) (void))
(check-eq? (u16vector-shrink! v7 1) (void))
(check-eq? (u16vector-shrink! v8 0) (void))
(check-eq? (u16vector-shrink! v9 2) (void))

(check-eqv? (u16vector-length v6) 3)
(check-eqv? (u16vector-length v7) 1)
(check-eqv? (u16vector-length v8) 0)
(check-eqv? (u16vector-length v9) 2)

(check-eq? (u16vector-fill! v6 0) (void))
(check-equal? v6 '#u16(0 0 0))

(check-eq? (u16vector-fill! v6 65535) (void))
(check-equal? v6 '#u16(65535 65535 65535))

(check-eq? (subu16vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#u16(9 9 9))

(check-eq? (subu16vector-fill! v6 1 2 0) (void))
(check-equal? v6 '#u16(9 0 9))

(check-eq? (subu16vector-fill! v6 1 3 65535) (void))
(check-equal? v6 '#u16(9 65535 65535))

(check-eq? (subu16vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#u16(65535 99 65535))

(check-eq? (subu16vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#u16(65535 65535 99))

(check-tail-exn type-exception? (lambda () (u16vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (u16vector 11 -1 22)))
(check-tail-exn type-exception? (lambda () (u16vector 11 65536 22)))

(check-tail-exn type-exception? (lambda () (make-u16vector bool)))
(check-tail-exn type-exception? (lambda () (make-u16vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 -1)))
(check-tail-exn type-exception? (lambda () (make-u16vector 11 65536)))
(check-tail-exn range-exception? (lambda () (make-u16vector -1 0)))

(check-tail-exn type-exception? (lambda () (u16vector-length bool)))

(check-tail-exn type-exception? (lambda () (u16vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->u16vector bool)))

(check-tail-exn type-exception? (lambda () (u16vector-append bool)))
(check-tail-exn type-exception? (lambda () (u16vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (u16vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-u16vectors bool)))
(check-tail-exn type-exception? (lambda () (append-u16vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (u16vector-copy bool)))

(check-tail-exn type-exception? (lambda () (subu16vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu16vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subu16vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subu16vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subu16vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subu16vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subu16vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (u16vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (u16vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (u16vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (u16vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (u16vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (u16vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (u16vector-set! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (u16vector-set! v5 0 -1)))
(check-tail-exn type-exception? (lambda () (u16vector-set! v5 0 65536)))
(check-tail-exn range-exception? (lambda () (u16vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (u16vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (u16vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (u16vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (u16vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (u16vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (u16vector-fill! v5 bool)))
(check-tail-exn type-exception? (lambda () (u16vector-fill! v5 -1)))
(check-tail-exn type-exception? (lambda () (u16vector-fill! v5 65536)))

(check-tail-exn type-exception? (lambda () (subu16vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (subu16vector-fill! v5 0 0 -1)))
(check-tail-exn type-exception? (lambda () (subu16vector-fill! v5 0 0 65536)))
(check-tail-exn range-exception? (lambda () (subu16vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subu16vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subu16vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subu16vector-move! v5 0 0 v5 3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-u16vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector->list v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->u16vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u16vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-u16vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-copy v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (u16vector-fill! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subu16vector-move! v9 0 0 v9 0 0)))
