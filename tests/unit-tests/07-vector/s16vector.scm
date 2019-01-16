(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#s16(-32768 32767))

(define v2 (##s16vector -32768 -2 0 1 32767))
(define v3 (##make-s16vector 2))
(define v4 (##make-s16vector 2 -32768))
(define v5 (##make-s16vector 2 32767))

(define v6 (s16vector -32768 -2 0 1 32767))
(define v7 (make-s16vector 2))
(define v8 (make-s16vector 2 -32768))
(define v9 (make-s16vector 2 32767))

(check-false (##s16vector? str))
(check-false (##s16vector? int))
(check-false (##s16vector? bool))

(check-true (##s16vector? v1))
(check-true (##s16vector? '#s16()))
(check-true (##s16vector? '#s16(11)))
(check-true (##s16vector? '#s16(11 22)))
(check-true (##s16vector? '#s16(11 22 33)))
(check-true (##s16vector? '#s16(11 22 33 44)))
(check-true (##s16vector? '#s16(11 22 33 44 55)))

(check-true (##s16vector? v2))
(check-true (##s16vector? (##s16vector)))
(check-true (##s16vector? (##s16vector 11)))
(check-true (##s16vector? (##s16vector 11 22)))
(check-true (##s16vector? (##s16vector 11 22 33)))
(check-true (##s16vector? (##s16vector 11 22 33 44)))
(check-true (##s16vector? (##s16vector 11 22 33 44 55)))

(check-true (##s16vector? v3))
(check-true (##s16vector? (##make-s16vector 0)))
(check-true (##s16vector? (##make-s16vector 1)))
(check-true (##s16vector? (##make-s16vector 10)))
(check-true (##s16vector? (##make-s16vector 100)))
(check-true (##s16vector? (##make-s16vector 1000)))
(check-true (##s16vector? (##make-s16vector 10000)))

(check-true (##s16vector? v4))
(check-true (##s16vector? v5))
(check-true (##s16vector? (##make-s16vector 0 11)))
(check-true (##s16vector? (##make-s16vector 1 22)))
(check-true (##s16vector? (##make-s16vector 10 33)))
(check-true (##s16vector? (##make-s16vector 100 44)))
(check-true (##s16vector? (##make-s16vector 1000 55)))
(check-true (##s16vector? (##make-s16vector 10000 66)))

(check-eqv? (##s16vector-length v1) 2)
(check-eqv? (##s16vector-length '#s16()) 0)
(check-eqv? (##s16vector-length '#s16(11)) 1)
(check-eqv? (##s16vector-length '#s16(11 22)) 2)
(check-eqv? (##s16vector-length '#s16(11 22 33)) 3)
(check-eqv? (##s16vector-length '#s16(11 22 33 44)) 4)
(check-eqv? (##s16vector-length '#s16(11 22 33 44 55)) 5)

(check-eqv? (##s16vector-length v2) 5)
(check-eqv? (##s16vector-length (##s16vector)) 0)
(check-eqv? (##s16vector-length (##s16vector 11)) 1)
(check-eqv? (##s16vector-length (##s16vector 11 22)) 2)
(check-eqv? (##s16vector-length (##s16vector 11 22 33)) 3)
(check-eqv? (##s16vector-length (##s16vector 11 22 33 44)) 4)
(check-eqv? (##s16vector-length (##s16vector 11 22 33 44 55)) 5)

(check-eqv? (##s16vector-length v3) 2)
(check-eqv? (##s16vector-length (##make-s16vector 0)) 0)
(check-eqv? (##s16vector-length (##make-s16vector 1)) 1)
(check-eqv? (##s16vector-length (##make-s16vector 10)) 10)
(check-eqv? (##s16vector-length (##make-s16vector 100)) 100)
(check-eqv? (##s16vector-length (##make-s16vector 1000)) 1000)
(check-eqv? (##s16vector-length (##make-s16vector 10000)) 10000)

(check-eqv? (##s16vector-length v4) 2)
(check-eqv? (##s16vector-length v5) 2)
(check-eqv? (##s16vector-length (##make-s16vector 0 11)) 0)
(check-eqv? (##s16vector-length (##make-s16vector 1 22)) 1)
(check-eqv? (##s16vector-length (##make-s16vector 10 33)) 10)
(check-eqv? (##s16vector-length (##make-s16vector 100 44)) 100)
(check-eqv? (##s16vector-length (##make-s16vector 1000 55)) 1000)
(check-eqv? (##s16vector-length (##make-s16vector 10000 66)) 10000)

(check-eqv? (##s16vector-ref v1 0) -32768)
(check-eqv? (##s16vector-ref v1 1) 32767)

(check-eqv? (##s16vector-ref v2 0) -32768)
(check-eqv? (##s16vector-ref v2 1) -2)
(check-eqv? (##s16vector-ref v2 2) 0)
(check-eqv? (##s16vector-ref v2 3) 1)
(check-eqv? (##s16vector-ref v2 4) 32767)

(check-eqv? (##s16vector-ref v4 0) -32768)
(check-eqv? (##s16vector-ref v4 1) -32768)

(check-eqv? (##s16vector-ref v5 0) 32767)
(check-eqv? (##s16vector-ref v5 1) 32767)

(check-equal? (##s16vector-set v2 1 99) '#s16(-32768 99 0 1 32767))
(check-equal? v2 '#s16(-32768 -2 0 1 32767))
(check-equal? (##s16vector-set v4 1 99) '#s16(-32768 99))
(check-equal? (##s16vector-set v5 1 99) '#s16(32767 99))
(check-equal? (##s16vector-set '#s16(11 22 33) 0 99) '#s16(99 22 33))

(check-eq? (##s16vector-set! v2 1 99) v2)
(check-eq? (##s16vector-set! v3 1 99) v3)
(check-eq? (##s16vector-set! v4 1 99) v4)
(check-eq? (##s16vector-set! v5 1 99) v5)

(check-eqv? (##s16vector-ref v2 0) -32768)
(check-eqv? (##s16vector-ref v2 1) 99)
(check-eqv? (##s16vector-ref v2 2) 0)
(check-eqv? (##s16vector-ref v2 3) 1)
(check-eqv? (##s16vector-ref v2 4) 32767)

(check-eqv? (##s16vector-ref v3 1) 99)

(check-eqv? (##s16vector-ref v4 0) -32768)
(check-eqv? (##s16vector-ref v4 1) 99)

(check-eqv? (##s16vector-ref v5 0) 32767)
(check-eqv? (##s16vector-ref v5 1) 99)

(check-eq? (##s16vector-shrink! v2 3) v2)
(check-eq? (##s16vector-shrink! v3 1) v3)
(check-eq? (##s16vector-shrink! v4 0) v4)
(check-eq? (##s16vector-shrink! v5 2) v5)

(check-eqv? (##s16vector-length v2) 3)
(check-eqv? (##s16vector-length v3) 1)
(check-eqv? (##s16vector-length v4) 0)
(check-eqv? (##s16vector-length v5) 2)

(check-true (s16vector? v1))
(check-true (s16vector? '#s16()))
(check-true (s16vector? '#s16(11)))
(check-true (s16vector? '#s16(11 22)))
(check-true (s16vector? '#s16(11 22 33)))
(check-true (s16vector? '#s16(11 22 33 44)))
(check-true (s16vector? '#s16(11 22 33 44 55)))

(check-true (s16vector? v6))
(check-true (s16vector? (s16vector)))
(check-true (s16vector? (s16vector 11)))
(check-true (s16vector? (s16vector 11 22)))
(check-true (s16vector? (s16vector 11 22 33)))
(check-true (s16vector? (s16vector 11 22 33 44)))
(check-true (s16vector? (s16vector 11 22 33 44 55)))

(check-true (s16vector? v7))
(check-true (s16vector? (make-s16vector 0)))
(check-true (s16vector? (make-s16vector 1)))
(check-true (s16vector? (make-s16vector 10)))
(check-true (s16vector? (make-s16vector 100)))
(check-true (s16vector? (make-s16vector 1000)))
(check-true (s16vector? (make-s16vector 10000)))

(check-true (s16vector? v8))
(check-true (s16vector? v9))
(check-true (s16vector? (make-s16vector 0 11)))
(check-true (s16vector? (make-s16vector 1 22)))
(check-true (s16vector? (make-s16vector 10 33)))
(check-true (s16vector? (make-s16vector 100 44)))
(check-true (s16vector? (make-s16vector 1000 55)))
(check-true (s16vector? (make-s16vector 10000 66)))

(check-eqv? (s16vector-length v1) 2)
(check-eqv? (s16vector-length '#s16()) 0)
(check-eqv? (s16vector-length '#s16(11)) 1)
(check-eqv? (s16vector-length '#s16(11 22)) 2)
(check-eqv? (s16vector-length '#s16(11 22 33)) 3)
(check-eqv? (s16vector-length '#s16(11 22 33 44)) 4)
(check-eqv? (s16vector-length '#s16(11 22 33 44 55)) 5)

(check-eqv? (s16vector-length v6) 5)
(check-eqv? (s16vector-length (s16vector)) 0)
(check-eqv? (s16vector-length (s16vector 11)) 1)
(check-eqv? (s16vector-length (s16vector 11 22)) 2)
(check-eqv? (s16vector-length (s16vector 11 22 33)) 3)
(check-eqv? (s16vector-length (s16vector 11 22 33 44)) 4)
(check-eqv? (s16vector-length (s16vector 11 22 33 44 55)) 5)

(check-eqv? (s16vector-length v7) 2)
(check-eqv? (s16vector-length (make-s16vector 0)) 0)
(check-eqv? (s16vector-length (make-s16vector 1)) 1)
(check-eqv? (s16vector-length (make-s16vector 10)) 10)
(check-eqv? (s16vector-length (make-s16vector 100)) 100)
(check-eqv? (s16vector-length (make-s16vector 1000)) 1000)
(check-eqv? (s16vector-length (make-s16vector 10000)) 10000)

(check-eqv? (s16vector-length v8) 2)
(check-eqv? (s16vector-length v9) 2)
(check-eqv? (s16vector-length (make-s16vector 0 11)) 0)
(check-eqv? (s16vector-length (make-s16vector 1 22)) 1)
(check-eqv? (s16vector-length (make-s16vector 10 33)) 10)
(check-eqv? (s16vector-length (make-s16vector 100 44)) 100)
(check-eqv? (s16vector-length (make-s16vector 1000 55)) 1000)
(check-eqv? (s16vector-length (make-s16vector 10000 66)) 10000)

(check-equal? (s16vector->list '#s16()) '())
(check-equal? (s16vector->list v6) '(-32768 -2 0 1 32767))
(check-equal? (s16vector->list v6 0) '(-32768 -2 0 1 32767))
(check-equal? (s16vector->list v6 2) '(0 1 32767))
(check-equal? (s16vector->list v6 2 4) '(0 1))
(check-equal? (s16vector->list v6 0 5) '(-32768 -2 0 1 32767))
(check-equal? (s16vector->list v7) '(0 0))

(check-equal? (list->s16vector '()) '#s16())
(check-equal? (list->s16vector '(-32768 -2 0 1 32767)) v6)
(check-equal? (list->s16vector '(0 0)) v7)

(check-equal? (s16vector-append) '#s16())
(check-equal? (s16vector-append v6) v6)
(check-equal? (s16vector-append '#s16(-32768 -2) '#s16(0 1 32767)) v6)
(check-equal? (s16vector-append v6 v7 v6) '#s16(-32768 -2 0 1 32767 0 0 -32768 -2 0 1 32767))

(check-equal? (append-s16vectors (list v6 v7 v6)) '#s16(-32768 -2 0 1 32767 0 0 -32768 -2 0 1 32767))

(check-equal? (s16vector-copy '#s16()) '#s16())
(check-equal? (s16vector-copy v6) v6)
(check-equal? (s16vector-copy v6 0) v6)
(check-equal? (s16vector-copy v6 2) '#s16(0 1 32767))
(check-equal? (s16vector-copy v6 0 0) '#s16())
(check-equal? (s16vector-copy v6 4 4) '#s16())
(check-equal? (s16vector-copy v6 0 2) '#s16(-32768 -2))
(check-equal? (s16vector-copy v6 2 4) '#s16(0 1))
(check-equal? (s16vector-copy v6 4 5) '#s16(32767))
(check-equal? (s16vector-copy v6 0 5) v6)

(check-equal? (subs16vector v6 0 0) '#s16())
(check-equal? (subs16vector v6 4 4) '#s16())
(check-equal? (subs16vector v6 0 2) '#s16(-32768 -2))
(check-equal? (subs16vector v6 2 4) '#s16(0 1))
(check-equal? (subs16vector v6 4 5) '#s16(32767))
(check-equal? (subs16vector v6 0 5) v6)

(check-eqv? (s16vector-ref v1 0) -32768)
(check-eqv? (s16vector-ref v1 1) 32767)

(check-eqv? (s16vector-ref v6 0) -32768)
(check-eqv? (s16vector-ref v6 1) -2)
(check-eqv? (s16vector-ref v6 2) 0)
(check-eqv? (s16vector-ref v6 3) 1)
(check-eqv? (s16vector-ref v6 4) 32767)

(check-eqv? (s16vector-ref v7 0) 0)
(check-eqv? (s16vector-ref v7 1) 0)

(check-eqv? (s16vector-ref v8 0) -32768)
(check-eqv? (s16vector-ref v8 1) -32768)

(check-eqv? (s16vector-ref v9 0) 32767)
(check-eqv? (s16vector-ref v9 1) 32767)

(check-equal? (s16vector-set v6 1 99) '#s16(-32768 99 0 1 32767))
(check-equal? v6 '#s16(-32768 -2 0 1 32767))
(check-equal? (s16vector-set v8 1 99) '#s16(-32768 99))
(check-equal? (s16vector-set v9 1 99) '#s16(32767 99))
(check-equal? (s16vector-set '#s16(11 22 33) 0 99) '#s16(99 22 33))

(check-eq? (s16vector-set! v6 1 99) (void))
(check-eq? (s16vector-set! v7 1 99) (void))
(check-eq? (s16vector-set! v8 1 99) (void))
(check-eq? (s16vector-set! v9 1 99) (void))

(check-eqv? (s16vector-ref v6 0) -32768)
(check-eqv? (s16vector-ref v6 1) 99)
(check-eqv? (s16vector-ref v6 2) 0)
(check-eqv? (s16vector-ref v6 3) 1)
(check-eqv? (s16vector-ref v6 4) 32767)

(check-eqv? (s16vector-ref v7 0) 0)
(check-eqv? (s16vector-ref v7 1) 99)

(check-eqv? (s16vector-ref v8 0) -32768)
(check-eqv? (s16vector-ref v8 1) 99)

(check-eqv? (s16vector-ref v9 0) 32767)
(check-eqv? (s16vector-ref v9 1) 99)

(check-eq? (s16vector-shrink! v6 3) (void))
(check-eq? (s16vector-shrink! v7 1) (void))
(check-eq? (s16vector-shrink! v8 0) (void))
(check-eq? (s16vector-shrink! v9 2) (void))

(check-eqv? (s16vector-length v6) 3)
(check-eqv? (s16vector-length v7) 1)
(check-eqv? (s16vector-length v8) 0)
(check-eqv? (s16vector-length v9) 2)

(check-eq? (s16vector-fill! v6 -32768) (void))
(check-equal? v6 '#s16(-32768 -32768 -32768))

(check-eq? (s16vector-fill! v6 32767) (void))
(check-equal? v6 '#s16(32767 32767 32767))

(check-eq? (s16vector-fill! v6 3 1) (void))
(check-equal? v6 '#s16(32767 3 3))

(check-eq? (s16vector-fill! v6 99 0 2) (void))
(check-equal? v6 '#s16(99 99 3))

(check-eq? (subs16vector-fill! v6 0 3 9) (void))
(check-equal? v6 '#s16(9 9 9))

(check-eq? (subs16vector-fill! v6 1 2 -32768) (void))
(check-equal? v6 '#s16(9 -32768 9))

(check-eq? (subs16vector-fill! v6 1 3 32767) (void))
(check-equal? v6 '#s16(9 32767 32767))

(check-eq? (subs16vector-move! v9 0 2 v6 0) (void))
(check-equal? v6 '#s16(32767 99 32767))

(check-eq? (subs16vector-move! v9 0 2 v6 1) (void))
(check-equal? v6 '#s16(32767 32767 99))

(check-eq? (s16vector-copy! v6 0 '#s16(11 22 33)) (void))
(check-equal? v6 '#s16(11 22 33))

(check-eq? (s16vector-copy! v6 2 '#s16(33 44) 1) (void))
(check-equal? v6 '#s16(11 22 44))

(check-eq? (s16vector-copy! v6 1 '#s16(55 66 77 88) 0 2) (void))
(check-equal? v6 '#s16(11 55 66))

(check-tail-exn type-exception? (lambda () (s16vector 11 bool 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector 11 -32769 22))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector 11 32768 22))) ;; homovect only

(check-tail-exn type-exception? (lambda () (make-s16vector bool)))
(check-tail-exn type-exception? (lambda () (make-s16vector bool 11)))
(check-tail-exn type-exception? (lambda () (make-s16vector 11 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s16vector 11 -32769))) ;; homovect only
(check-tail-exn type-exception? (lambda () (make-s16vector 11 32768))) ;; homovect only
(check-tail-exn range-exception? (lambda () (make-s16vector -1 0)))

(check-tail-exn type-exception? (lambda () (s16vector-length bool)))

(check-tail-exn type-exception? (lambda () (s16vector->list bool)))

(check-tail-exn type-exception? (lambda () (list->s16vector bool)))

(check-tail-exn type-exception? (lambda () (s16vector-append bool)))
(check-tail-exn type-exception? (lambda () (s16vector-append bool v9)))
(check-tail-exn type-exception? (lambda () (s16vector-append v9 bool)))

(check-tail-exn type-exception? (lambda () (append-s16vectors bool)))
(check-tail-exn type-exception? (lambda () (append-s16vectors '(1 2 3))))

(check-tail-exn type-exception? (lambda () (s16vector-copy bool)))
(check-tail-exn type-exception? (lambda () (s16vector-copy v9 bool)))
(check-tail-exn type-exception? (lambda () (s16vector-copy v9 0 bool)))

(check-tail-exn type-exception? (lambda () (subs16vector bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs16vector v9 bool 0)))
(check-tail-exn type-exception? (lambda () (subs16vector v9 0 bool)))
(check-tail-exn range-exception? (lambda () (subs16vector v9 -1 0)))
(check-tail-exn range-exception? (lambda () (subs16vector v9 3 0)))
(check-tail-exn range-exception? (lambda () (subs16vector v9 0 -1)))
(check-tail-exn range-exception? (lambda () (subs16vector v9 0 3)))

(check-tail-exn type-exception? (lambda () (s16vector-ref bool 0)))
(check-tail-exn type-exception? (lambda () (s16vector-ref v5 bool)))
(check-tail-exn range-exception? (lambda () (s16vector-ref v5 -1)))
(check-tail-exn range-exception? (lambda () (s16vector-ref v5 2)))

(check-tail-exn type-exception? (lambda () (s16vector-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-set v5 0 -32769))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-set v5 0 32768))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s16vector-set v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s16vector-set v5 2 0)))

(check-tail-exn type-exception? (lambda () (s16vector-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set! v5 bool 11)))
(check-tail-exn type-exception? (lambda () (s16vector-set! v5 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-set! v5 0 -32769))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-set! v5 0 32768))) ;; homovect only
(check-tail-exn range-exception? (lambda () (s16vector-set! v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s16vector-set! v5 2 0)))

(check-tail-exn type-exception? (lambda () (s16vector-shrink! bool 0)))
(check-tail-exn type-exception? (lambda () (s16vector-shrink! v5 bool)))
(check-tail-exn range-exception? (lambda () (s16vector-shrink! v5 3)))

(check-tail-exn type-exception? (lambda () (s16vector-fill! bool 0)))
(check-tail-exn type-exception? (lambda () (s16vector-fill! v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s16vector-fill! v5 0 0 bool)))
(check-tail-exn type-exception? (lambda () (s16vector-fill! v5 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-fill! v5 -32769))) ;; homovect only
(check-tail-exn type-exception? (lambda () (s16vector-fill! v5 32768))) ;; homovect only

(check-tail-exn type-exception? (lambda () (subs16vector-fill! bool 0 0 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-fill! v5 bool 0 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-fill! v5 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-fill! v5 0 0 bool))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs16vector-fill! v5 0 0 -32769))) ;; homovect only
(check-tail-exn type-exception? (lambda () (subs16vector-fill! v5 0 0 32768))) ;; homovect only
(check-tail-exn range-exception? (lambda () (subs16vector-fill! v5 -1 0 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-fill! v5 3 0 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-fill! v5 0 -1 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-fill! v5 0 3 0)))

(check-tail-exn type-exception? (lambda () (subs16vector-move! bool 0 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-move! v5 bool 0 v5 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-move! v5 0 bool v5 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-move! v5 0 0 bool 0)))
(check-tail-exn type-exception? (lambda () (subs16vector-move! v5 0 0 v5 bool)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 -1 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 3 0 v5 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 0 -1 v5 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 0 3 v5 0)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 0 0 v5 -1)))
(check-tail-exn range-exception? (lambda () (subs16vector-move! v5 0 0 v5 3)))

(check-tail-exn type-exception? (lambda () (s16vector-copy! v5 0 bool 0 0)))
(check-tail-exn type-exception? (lambda () (s16vector-copy! v5 0 v5 bool 0)))
(check-tail-exn type-exception? (lambda () (s16vector-copy! v5 0 v5 0 bool)))
(check-tail-exn type-exception? (lambda () (s16vector-copy! bool 0 v5 0 0)))
(check-tail-exn type-exception? (lambda () (s16vector-copy! v5 bool v5 0 0)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 0 v5 -1 0)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 0 v5 3 0)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 0 v5 0 -1)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 0 v5 0 3)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 -1 v5 0 0)))
(check-tail-exn range-exception? (lambda () (s16vector-copy! v5 3 v5 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-s16vector 11 22 33)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector? bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-length bool bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector->list v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list->s16vector '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s16vectors)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-s16vectors '() '())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector v1 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector v1 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref v1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-ref v1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-set! v9 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-shrink!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-shrink! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-shrink! v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-fill! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-fill! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-fill! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-fill! v9 0 0 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move! v9 0 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move! v9 0 0 v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (subs16vector-move! v9 0 0 v9 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy! v9)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy! v9 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (s16vector-copy! v9 0 v9 0 0 0)))

(check-tail-exn range-exception? (lambda () (make-s16vector (expt 2 64))))
