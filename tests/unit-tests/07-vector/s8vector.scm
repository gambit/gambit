(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#s8(-128 127))

(define v2 (##s8vector -128 -2 0 1 127))
(define v3 (##make-s8vector 2))
(define v4 (##make-s8vector 2 -128))
(define v5 (##make-s8vector 2 127))

(define v6 (s8vector -128 -2 0 1 127))
(define v7 (make-s8vector 2))
(define v8 (make-s8vector 2 -128))
(define v9 (make-s8vector 2 127))

(check-false (##s8vector? str))
(check-false (##s8vector? int))
(check-false (##s8vector? bool))

(check-true (##s8vector? v1))
(check-true (##s8vector? '#s8()))
(check-true (##s8vector? '#s8(11)))
(check-true (##s8vector? '#s8(11 22)))
(check-true (##s8vector? '#s8(11 22 33)))
(check-true (##s8vector? '#s8(11 22 33 44)))
(check-true (##s8vector? '#s8(11 22 33 44 55)))

(check-true (##s8vector? v2))
(check-true (##s8vector? (##s8vector)))
(check-true (##s8vector? (##s8vector 11)))
(check-true (##s8vector? (##s8vector 11 22)))
(check-true (##s8vector? (##s8vector 11 22 33)))
(check-true (##s8vector? (##s8vector 11 22 33 44)))
(check-true (##s8vector? (##s8vector 11 22 33 44 55)))

(check-true (##s8vector? v3))
(check-true (##s8vector? (##make-s8vector 0)))
(check-true (##s8vector? (##make-s8vector 1)))
(check-true (##s8vector? (##make-s8vector 10)))
(check-true (##s8vector? (##make-s8vector 100)))
(check-true (##s8vector? (##make-s8vector 1000)))
(check-true (##s8vector? (##make-s8vector 10000)))

(check-true (##s8vector? v4))
(check-true (##s8vector? v5))
(check-true (##s8vector? (##make-s8vector 0 11)))
(check-true (##s8vector? (##make-s8vector 1 22)))
(check-true (##s8vector? (##make-s8vector 10 33)))
(check-true (##s8vector? (##make-s8vector 100 44)))
(check-true (##s8vector? (##make-s8vector 1000 55)))
(check-true (##s8vector? (##make-s8vector 10000 66)))

(check-eqv? (##s8vector-length v1) 2)
(check-eqv? (##s8vector-length '#s8()) 0)
(check-eqv? (##s8vector-length '#s8(11)) 1)
(check-eqv? (##s8vector-length '#s8(11 22)) 2)
(check-eqv? (##s8vector-length '#s8(11 22 33)) 3)
(check-eqv? (##s8vector-length '#s8(11 22 33 44)) 4)
(check-eqv? (##s8vector-length '#s8(11 22 33 44 55)) 5)

(check-eqv? (##s8vector-length v2) 5)
(check-eqv? (##s8vector-length (##s8vector)) 0)
(check-eqv? (##s8vector-length (##s8vector 11)) 1)
(check-eqv? (##s8vector-length (##s8vector 11 22)) 2)
(check-eqv? (##s8vector-length (##s8vector 11 22 33)) 3)
(check-eqv? (##s8vector-length (##s8vector 11 22 33 44)) 4)
(check-eqv? (##s8vector-length (##s8vector 11 22 33 44 55)) 5)

(check-eqv? (##s8vector-length v3) 2)
(check-eqv? (##s8vector-length (##make-s8vector 0)) 0)
(check-eqv? (##s8vector-length (##make-s8vector 1)) 1)
(check-eqv? (##s8vector-length (##make-s8vector 10)) 10)
(check-eqv? (##s8vector-length (##make-s8vector 100)) 100)
(check-eqv? (##s8vector-length (##make-s8vector 1000)) 1000)
(check-eqv? (##s8vector-length (##make-s8vector 10000)) 10000)

(check-eqv? (##s8vector-length v4) 2)
(check-eqv? (##s8vector-length v5) 2)
(check-eqv? (##s8vector-length (##make-s8vector 0 11)) 0)
(check-eqv? (##s8vector-length (##make-s8vector 1 22)) 1)
(check-eqv? (##s8vector-length (##make-s8vector 10 33)) 10)
(check-eqv? (##s8vector-length (##make-s8vector 100 44)) 100)
(check-eqv? (##s8vector-length (##make-s8vector 1000 55)) 1000)
(check-eqv? (##s8vector-length (##make-s8vector 10000 66)) 10000)

(check-eqv? (##s8vector-ref v1 0) -128)
(check-eqv? (##s8vector-ref v1 1) 127)

(check-eqv? (##s8vector-ref v2 0) -128)
(check-eqv? (##s8vector-ref v2 1) -2)
(check-eqv? (##s8vector-ref v2 2) 0)
(check-eqv? (##s8vector-ref v2 3) 1)
(check-eqv? (##s8vector-ref v2 4) 127)

(check-eqv? (##s8vector-ref v4 0) -128)
(check-eqv? (##s8vector-ref v4 1) -128)

(check-eqv? (##s8vector-ref v5 0) 127)
(check-eqv? (##s8vector-ref v5 1) 127)

(check-eq? (##s8vector-set! v2 1 99) v2)
(check-eq? (##s8vector-set! v3 1 99) v3)
(check-eq? (##s8vector-set! v4 1 99) v4)
(check-eq? (##s8vector-set! v5 1 99) v5)

(check-eqv? (##s8vector-ref v2 0) -128)
(check-eqv? (##s8vector-ref v2 1) 99)
(check-eqv? (##s8vector-ref v2 2) 0)
(check-eqv? (##s8vector-ref v2 3) 1)
(check-eqv? (##s8vector-ref v2 4) 127)

(check-eqv? (##s8vector-ref v3 1) 99)

(check-eqv? (##s8vector-ref v4 0) -128)
(check-eqv? (##s8vector-ref v4 1) 99)

(check-eqv? (##s8vector-ref v5 0) 127)
(check-eqv? (##s8vector-ref v5 1) 99)

(check-eq? (##s8vector-shrink! v2 3) v2)
(check-eq? (##s8vector-shrink! v3 1) v3)
(check-eq? (##s8vector-shrink! v4 0) v4)
(check-eq? (##s8vector-shrink! v5 2) v5)

(check-eqv? (##s8vector-length v2) 3)
(check-eqv? (##s8vector-length v3) 1)
(check-eqv? (##s8vector-length v4) 0)
(check-eqv? (##s8vector-length v5) 2)

(check-true (s8vector? v1))
(check-true (s8vector? '#s8()))
(check-true (s8vector? '#s8(11)))
(check-true (s8vector? '#s8(11 22)))
(check-true (s8vector? '#s8(11 22 33)))
(check-true (s8vector? '#s8(11 22 33 44)))
(check-true (s8vector? '#s8(11 22 33 44 55)))

(check-true (s8vector? v6))
(check-true (s8vector? (s8vector)))
(check-true (s8vector? (s8vector 11)))
(check-true (s8vector? (s8vector 11 22)))
(check-true (s8vector? (s8vector 11 22 33)))
(check-true (s8vector? (s8vector 11 22 33 44)))
(check-true (s8vector? (s8vector 11 22 33 44 55)))

(check-true (s8vector? v7))
(check-true (s8vector? (make-s8vector 0)))
(check-true (s8vector? (make-s8vector 1)))
(check-true (s8vector? (make-s8vector 10)))
(check-true (s8vector? (make-s8vector 100)))
(check-true (s8vector? (make-s8vector 1000)))
(check-true (s8vector? (make-s8vector 10000)))

(check-true (s8vector? v8))
(check-true (s8vector? v9))
(check-true (s8vector? (make-s8vector 0 11)))
(check-true (s8vector? (make-s8vector 1 22)))
(check-true (s8vector? (make-s8vector 10 33)))
(check-true (s8vector? (make-s8vector 100 44)))
(check-true (s8vector? (make-s8vector 1000 55)))
(check-true (s8vector? (make-s8vector 10000 66)))

(check-eqv? (s8vector-length v1) 2)
(check-eqv? (s8vector-length '#s8()) 0)
(check-eqv? (s8vector-length '#s8(11)) 1)
(check-eqv? (s8vector-length '#s8(11 22)) 2)
(check-eqv? (s8vector-length '#s8(11 22 33)) 3)
(check-eqv? (s8vector-length '#s8(11 22 33 44)) 4)
(check-eqv? (s8vector-length '#s8(11 22 33 44 55)) 5)

(check-eqv? (s8vector-length v6) 5)
(check-eqv? (s8vector-length (s8vector)) 0)
(check-eqv? (s8vector-length (s8vector 11)) 1)
(check-eqv? (s8vector-length (s8vector 11 22)) 2)
(check-eqv? (s8vector-length (s8vector 11 22 33)) 3)
(check-eqv? (s8vector-length (s8vector 11 22 33 44)) 4)
(check-eqv? (s8vector-length (s8vector 11 22 33 44 55)) 5)

(check-eqv? (s8vector-length v7) 2)
(check-eqv? (s8vector-length (make-s8vector 0)) 0)
(check-eqv? (s8vector-length (make-s8vector 1)) 1)
(check-eqv? (s8vector-length (make-s8vector 10)) 10)
(check-eqv? (s8vector-length (make-s8vector 100)) 100)
(check-eqv? (s8vector-length (make-s8vector 1000)) 1000)
(check-eqv? (s8vector-length (make-s8vector 10000)) 10000)

(check-eqv? (s8vector-length v8) 2)
(check-eqv? (s8vector-length v9) 2)
(check-eqv? (s8vector-length (make-s8vector 0 11)) 0)
(check-eqv? (s8vector-length (make-s8vector 1 22)) 1)
(check-eqv? (s8vector-length (make-s8vector 10 33)) 10)
(check-eqv? (s8vector-length (make-s8vector 100 44)) 100)
(check-eqv? (s8vector-length (make-s8vector 1000 55)) 1000)
(check-eqv? (s8vector-length (make-s8vector 10000 66)) 10000)

(check-equal? (s8vector->list '#s8()) '())
(check-equal? (s8vector->list v6) '(-128 -2 0 1 127))
(check-equal? (s8vector->list v7) '(0 0))

(check-equal? (list->s8vector '()) '#s8())
(check-equal? (list->s8vector '(-128 -2 0 1 127)) v6)
(check-equal? (list->s8vector '(0 0)) v7)

(check-equal? (s8vector-append) '#s8())
(check-equal? (s8vector-append v6) v6)
(check-equal? (s8vector-append '#s8(-128 -2) '#s8(0 1 127)) v6)
(check-equal? (s8vector-append v6 v7 v6) '#s8(-128 -2 0 1 127 0 0 -128 -2 0 1 127))

(check-equal? (append-s8vectors (list v6 v7 v6)) '#s8(-128 -2 0 1 127 0 0 -128 -2 0 1 127))

(check-equal? (s8vector-copy '#s8()) '#s8())
(check-equal? (s8vector-copy v6) v6)

(check-equal? (subs8vector v6 0 0) '#s8())
(check-equal? (subs8vector v6 4 4) '#s8())
(check-equal? (subs8vector v6 0 2) '#s8(-128 -2))
(check-equal? (subs8vector v6 2 4) '#s8(0 1))
(check-equal? (subs8vector v6 4 5) '#s8(127))
(check-equal? (subs8vector v6 0 5) v6)

(check-eqv? (s8vector-ref v1 0) -128)
(check-eqv? (s8vector-ref v1 1) 127)

(check-eqv? (s8vector-ref v6 0) -128)
(check-eqv? (s8vector-ref v6 1) -2)
(check-eqv? (s8vector-ref v6 2) 0)
(check-eqv? (s8vector-ref v6 3) 1)
(check-eqv? (s8vector-ref v6 4) 127)

(check-eqv? (s8vector-ref v7 0) 0)
(check-eqv? (s8vector-ref v7 1) 0)

(check-eqv? (s8vector-ref v8 0) -128)
(check-eqv? (s8vector-ref v8 1) -128)

(check-eqv? (s8vector-ref v9 0) 127)
(check-eqv? (s8vector-ref v9 1) 127)

(check-eq? (s8vector-set! v6 1 99) (void))
(check-eq? (s8vector-set! v7 1 99) (void))
(check-eq? (s8vector-set! v8 1 99) (void))
(check-eq? (s8vector-set! v9 1 99) (void))

(check-eqv? (s8vector-ref v6 0) -128)
(check-eqv? (s8vector-ref v6 1) 99)
(check-eqv? (s8vector-ref v6 2) 0)
(check-eqv? (s8vector-ref v6 3) 1)
(check-eqv? (s8vector-ref v6 4) 127)

(check-eqv? (s8vector-ref v7 0) 0)
(check-eqv? (s8vector-ref v7 1) 99)

(check-eqv? (s8vector-ref v8 0) -128)
(check-eqv? (s8vector-ref v8 1) 99)

(check-eqv? (s8vector-ref v9 0) 127)
(check-eqv? (s8vector-ref v9 1) 99)

(check-eq? (s8vector-shrink! v6 3) (void))
(check-eq? (s8vector-shrink! v7 1) (void))
(check-eq? (s8vector-shrink! v8 0) (void))
(check-eq? (s8vector-shrink! v9 2) (void))

(check-eqv? (s8vector-length v6) 3)
(check-eqv? (s8vector-length v7) 1)
(check-eqv? (s8vector-length v8) 0)
(check-eqv? (s8vector-length v9) 2)

(check-eq? (s8vector-fill! v6 -128) (void))
(check-equal? v6 '#s8(-128 -128 -128))

(check-eq? (s8vector-fill! v6 127) (void))
(check-equal? v6 '#s8(127 127 127))

(check-eq? (subs8vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#s8(9 9 9))

(check-eq? (subs8vector-fill! v6 1 2 -128) (void))
(check-equal? v6 '#s8(9 -128 9))

(check-eq? (subs8vector-fill! v6 1 3 127) (void))
(check-equal? v6 '#s8(9 127 127))

(check-eq? (subs8vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#s8(127 99 127))

(check-eq? (subs8vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#s8(127 127 99))

(check-tail-exn type-exception? (lambda () (s8vector 11 bool 22)))
(check-tail-exn type-exception? (lambda () (s8vector 11 -129 22)))
(check-tail-exn type-exception? (lambda () (s8vector 11 128 22)))

(check-tail-exn type-exception? (lambda () (make-s8vector bool)))
(check-tail-exn type-exception? (lambda () (make-s8vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 bool)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 -129)))
(check-tail-exn type-exception? (lambda () (make-s8vector 11 128)))
(check-tail-exn range-exception? (lambda () (make-s8vector -1 0)))

(check-tail-exn type-exception? (lambda () (s8vector-length bool)))

(check-tail-exn type-exception? (lambda () (s8vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s8vector bool)))

(check-tail-exn type-exception? (lambda () (s8vector-append bool)))
(check-tail-exn type-exception? (lambda () (s8vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (s8vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-s8vectors bool)))
(check-tail-exn type-exception? (lambda () (append-s8vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (s8vector-copy bool)))

(check-tail-exn type-exception? (lambda () (subs8vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs8vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subs8vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subs8vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subs8vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subs8vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subs8vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (s8vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s8vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (s8vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (s8vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (s8vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s8vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s8vector-set! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s8vector-set! v5 0 -129)))
(check-tail-exn type-exception? (lambda () (s8vector-set! v5 0 128)))
(check-tail-exn range-exception? (lambda () (s8vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s8vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (s8vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (s8vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (s8vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (s8vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (s8vector-fill! v5 bool)))
(check-tail-exn type-exception? (lambda () (s8vector-fill! v5 -129)))
(check-tail-exn type-exception? (lambda () (s8vector-fill! v5 128)))

(check-tail-exn type-exception? (lambda () (subs8vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (subs8vector-fill! v5 0 0 -129)))
(check-tail-exn type-exception? (lambda () (subs8vector-fill! v5 0 0 128)))
(check-tail-exn range-exception? (lambda () (subs8vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subs8vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs8vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subs8vector-move! v5 0 0 v5 3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s8vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector->list v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s8vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s8vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s8vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-copy v1 v1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s8vector-fill! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs8vector-move! v9 0 0 v9 0 0)))

(check-tail-exn range-exception? (lambda () (make-s8vector (expt 2 64))))
