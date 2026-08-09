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

(test-assert (eq? #f (##vector? str)))
(test-assert (eq? #f (##vector? int)))
(test-assert (eq? #f (##vector? bool)))

(test-assert (eq? #t (##vector? v1)))
(test-assert (eq? #t (##vector? '#())))
(test-assert (eq? #t (##vector? '#(11))))
(test-assert (eq? #t (##vector? '#(11 22))))
(test-assert (eq? #t (##vector? '#(11 22 33))))
(test-assert (eq? #t (##vector? '#(11 22 33 44))))
(test-assert (eq? #t (##vector? '#(11 22 33 44 55))))

(test-assert (eq? #t (##vector? v2)))
(test-assert (eq? #t (##vector? (##vector))))
(test-assert (eq? #t (##vector? (##vector 11))))
(test-assert (eq? #t (##vector? (##vector 11 22))))
(test-assert (eq? #t (##vector? (##vector 11 22 33))))
(test-assert (eq? #t (##vector? (##vector 11 22 33 44))))
(test-assert (eq? #t (##vector? (##vector 11 22 33 44 55))))

(test-assert (eq? #t (##vector? v3)))
(test-assert (eq? #t (##vector? (##make-vector 0))))
(test-assert (eq? #t (##vector? (##make-vector 1))))
(test-assert (eq? #t (##vector? (##make-vector 10))))
(test-assert (eq? #t (##vector? (##make-vector 100))))
(test-assert (eq? #t (##vector? (##make-vector 1000))))
(test-assert (eq? #t (##vector? (##make-vector 10000))))

(test-assert (eq? #t (##vector? v4)))
(test-assert (eq? #t (##vector? v5)))
(test-assert (eq? #t (##vector? (##make-vector 0 11))))
(test-assert (eq? #t (##vector? (##make-vector 1 22))))
(test-assert (eq? #t (##vector? (##make-vector 10 33))))
(test-assert (eq? #t (##vector? (##make-vector 100 44))))
(test-assert (eq? #t (##vector? (##make-vector 1000 55))))
(test-assert (eq? #t (##vector? (##make-vector 10000 66))))

(test-eqv 2 (##vector-length v1))
(test-eqv 0 (##vector-length '#()))
(test-eqv 1 (##vector-length '#(11)))
(test-eqv 2 (##vector-length '#(11 22)))
(test-eqv 3 (##vector-length '#(11 22 33)))
(test-eqv 4 (##vector-length '#(11 22 33 44)))
(test-eqv 5 (##vector-length '#(11 22 33 44 55)))

(test-eqv 5 (##vector-length v2))
(test-eqv 0 (##vector-length (##vector)))
(test-eqv 1 (##vector-length (##vector 11)))
(test-eqv 2 (##vector-length (##vector 11 22)))
(test-eqv 3 (##vector-length (##vector 11 22 33)))
(test-eqv 4 (##vector-length (##vector 11 22 33 44)))
(test-eqv 5 (##vector-length (##vector 11 22 33 44 55)))

(test-eqv 2 (##vector-length v3))
(test-eqv 0 (##vector-length (##make-vector 0)))
(test-eqv 1 (##vector-length (##make-vector 1)))
(test-eqv 10 (##vector-length (##make-vector 10)))
(test-eqv 100 (##vector-length (##make-vector 100)))
(test-eqv 1000 (##vector-length (##make-vector 1000)))
(test-eqv 10000 (##vector-length (##make-vector 10000)))

(test-eqv 2 (##vector-length v4))
(test-eqv 2 (##vector-length v5))
(test-eqv 0 (##vector-length (##make-vector 0 11)))
(test-eqv 1 (##vector-length (##make-vector 1 22)))
(test-eqv 10 (##vector-length (##make-vector 10 33)))
(test-eqv 100 (##vector-length (##make-vector 100 44)))
(test-eqv 1000 (##vector-length (##make-vector 1000 55)))
(test-eqv 10000 (##vector-length (##make-vector 10000 66)))

(test-eqv 0 (##vector-ref v1 0))
(test-eqv 255 (##vector-ref v1 1))

(test-eqv 0 (##vector-ref v2 0))
(test-eqv 255 (##vector-ref v2 1))
(test-eqv 0 (##vector-ref v2 2))
(test-eqv 1 (##vector-ref v2 3))
(test-eqv 255 (##vector-ref v2 4))

(test-eqv 0 (##vector-ref v4 0))
(test-eqv 0 (##vector-ref v4 1))

(test-eqv 255 (##vector-ref v5 0))
(test-eqv 255 (##vector-ref v5 1))

(test-equal '#(0 99 0 1 255) (##vector-set v2 1 99))
(test-equal '#(0 255 0 1 255) v2)
(test-equal '#(0 99) (##vector-set v4 1 99))
(test-equal '#(255 99) (##vector-set v5 1 99))
(test-equal '#(99 22 33) (##vector-set '#(11 22 33) 0 99))

(test-eq v2 (##vector-set! v2 1 99))
(test-eq v3 (##vector-set! v3 1 99))
(test-eq v4 (##vector-set! v4 1 99))
(test-eq v5 (##vector-set! v5 1 99))

(test-eqv 0 (##vector-ref v2 0))
(test-eqv 99 (##vector-ref v2 1))
(test-eqv 0 (##vector-ref v2 2))
(test-eqv 1 (##vector-ref v2 3))
(test-eqv 255 (##vector-ref v2 4))

(test-eqv v2 (##vector-swap! v2 0 4))

(test-eqv 255 (##vector-ref v2 0))
(test-eqv 99 (##vector-ref v2 1))
(test-eqv 0 (##vector-ref v2 2))
(test-eqv 1 (##vector-ref v2 3))
(test-eqv 0 (##vector-ref v2 4))

(test-eqv 99 (##vector-ref v3 1))

(test-eqv 0 (##vector-ref v4 0))
(test-eqv 99 (##vector-ref v4 1))

(test-eqv 255 (##vector-ref v5 0))
(test-eqv 99 (##vector-ref v5 1))

(test-eq v2 (##vector-shrink! v2 3))
(test-eq v3 (##vector-shrink! v3 1))
(test-eq v4 (##vector-shrink! v4 0))
(test-eq v5 (##vector-shrink! v5 2))

(test-eqv 3 (##vector-length v2))
(test-eqv 1 (##vector-length v3))
(test-eqv 0 (##vector-length v4))
(test-eqv 2 (##vector-length v5))

(test-assert (eq? #t (vector? v1)))
(test-assert (eq? #t (vector? '#())))
(test-assert (eq? #t (vector? '#(11))))
(test-assert (eq? #t (vector? '#(11 22))))
(test-assert (eq? #t (vector? '#(11 22 33))))
(test-assert (eq? #t (vector? '#(11 22 33 44))))
(test-assert (eq? #t (vector? '#(11 22 33 44 55))))

(test-assert (eq? #t (vector? v6)))
(test-assert (eq? #t (vector? (vector))))
(test-assert (eq? #t (vector? (vector 11))))
(test-assert (eq? #t (vector? (vector 11 22))))
(test-assert (eq? #t (vector? (vector 11 22 33))))
(test-assert (eq? #t (vector? (vector 11 22 33 44))))
(test-assert (eq? #t (vector? (vector 11 22 33 44 55))))

(test-assert (eq? #t (vector? v7)))
(test-assert (eq? #t (vector? (make-vector 0))))
(test-assert (eq? #t (vector? (make-vector 1))))
(test-assert (eq? #t (vector? (make-vector 10))))
(test-assert (eq? #t (vector? (make-vector 100))))
(test-assert (eq? #t (vector? (make-vector 1000))))
(test-assert (eq? #t (vector? (make-vector 10000))))

(test-assert (eq? #t (vector? v8)))
(test-assert (eq? #t (vector? v9)))
(test-assert (eq? #t (vector? (make-vector 0 11))))
(test-assert (eq? #t (vector? (make-vector 1 22))))
(test-assert (eq? #t (vector? (make-vector 10 33))))
(test-assert (eq? #t (vector? (make-vector 100 44))))
(test-assert (eq? #t (vector? (make-vector 1000 55))))
(test-assert (eq? #t (vector? (make-vector 10000 66))))

(test-eqv 2 (vector-length v1))
(test-eqv 0 (vector-length '#()))
(test-eqv 1 (vector-length '#(11)))
(test-eqv 2 (vector-length '#(11 22)))
(test-eqv 3 (vector-length '#(11 22 33)))
(test-eqv 4 (vector-length '#(11 22 33 44)))
(test-eqv 5 (vector-length '#(11 22 33 44 55)))

(test-eqv 5 (vector-length v6))
(test-eqv 0 (vector-length (vector)))
(test-eqv 1 (vector-length (vector 11)))
(test-eqv 2 (vector-length (vector 11 22)))
(test-eqv 3 (vector-length (vector 11 22 33)))
(test-eqv 4 (vector-length (vector 11 22 33 44)))
(test-eqv 5 (vector-length (vector 11 22 33 44 55)))

(test-eqv 2 (vector-length v7))
(test-eqv 0 (vector-length (make-vector 0)))
(test-eqv 1 (vector-length (make-vector 1)))
(test-eqv 10 (vector-length (make-vector 10)))
(test-eqv 100 (vector-length (make-vector 100)))
(test-eqv 1000 (vector-length (make-vector 1000)))
(test-eqv 10000 (vector-length (make-vector 10000)))

(test-eqv 2 (vector-length v8))
(test-eqv 2 (vector-length v9))
(test-eqv 0 (vector-length (make-vector 0 11)))
(test-eqv 1 (vector-length (make-vector 1 22)))
(test-eqv 10 (vector-length (make-vector 10 33)))
(test-eqv 100 (vector-length (make-vector 100 44)))
(test-eqv 1000 (vector-length (make-vector 1000 55)))
(test-eqv 10000 (vector-length (make-vector 10000 66)))

(test-equal '() (vector->list '#()))
(test-equal '(0 255 0 1 255) (vector->list v6))
(test-equal '(0 255 0 1 255) (vector->list v6 0))
(test-equal '(0 1 255) (vector->list v6 2))
(test-equal '(0 1) (vector->list v6 2 4))
(test-equal '(0 255 0 1 255) (vector->list v6 0 5))
(test-equal '(0 0) (vector->list v7))

(test-equal '#() (list->vector '()))
(test-equal v6 (list->vector '(0 255 0 1 255)))
(test-equal v7 (list->vector '(0 0)))

(test-equal '#() (vector-append))
(test-equal v6 (vector-append v6))
(test-equal v6 (vector-append '#(0 255) '#(0 1 255)))
(test-equal '#(0 255 0 1 255 0 0 0 255 0 1 255) (vector-append v6 v7 v6))

(test-equal
 '#(0 255 0 1 255 0 0 0 255 0 1 255)
 (vector-concatenate (list v6 v7 v6)))
(test-equal
 '#(0 255 0 1 255 1 1 1 0 0 1 1 1 0 255 0 1 255)
 (vector-concatenate (list v6 v7 v6) '#(1 1 1)))

(test-equal '#() (vector-copy '#()))
(test-equal v6 (vector-copy v6))
(test-equal v6 (vector-copy v6 0))
(test-equal '#(0 1 255) (vector-copy v6 2))
(test-equal '#() (vector-copy v6 0 0))
(test-equal '#() (vector-copy v6 4 4))
(test-equal '#(0 255) (vector-copy v6 0 2))
(test-equal '#(0 1) (vector-copy v6 2 4))
(test-equal '#(255) (vector-copy v6 4 5))
(test-equal v6 (vector-copy v6 0 5))

(test-equal '#() (subvector v6 0 0))
(test-equal '#() (subvector v6 4 4))
(test-equal '#(0 255) (subvector v6 0 2))
(test-equal '#(0 1) (subvector v6 2 4))
(test-equal '#(255) (subvector v6 4 5))
(test-equal v6 (subvector v6 0 5))

(test-eqv 0 (vector-ref v1 0))
(test-eqv 255 (vector-ref v1 1))

(test-eqv 0 (vector-ref v6 0))
(test-eqv 255 (vector-ref v6 1))
(test-eqv 0 (vector-ref v6 2))
(test-eqv 1 (vector-ref v6 3))
(test-eqv 255 (vector-ref v6 4))

(test-eqv 0 (vector-ref v7 0))
(test-eqv 0 (vector-ref v7 1))

(test-eqv 0 (vector-ref v8 0))
(test-eqv 0 (vector-ref v8 1))

(test-eqv 255 (vector-ref v9 0))
(test-eqv 255 (vector-ref v9 1))

(test-equal '#(0 99 0 1 255) (vector-set v6 1 99))
(test-equal '#(0 255 0 1 255) v6)
(test-equal '#(0 99) (vector-set v8 1 99))
(test-equal '#(255 99) (vector-set v9 1 99))
(test-equal '#(99 22 33) (vector-set '#(11 22 33) 0 99))

(test-eq (void) (vector-set! v6 1 99))
(test-eq (void) (vector-set! v7 1 99))
(test-eq (void) (vector-set! v8 1 99))
(test-eq (void) (vector-set! v9 1 99))

(test-eqv 0 (vector-ref v6 0))
(test-eqv 99 (vector-ref v6 1))
(test-eqv 0 (vector-ref v6 2))
(test-eqv 1 (vector-ref v6 3))
(test-eqv 255 (vector-ref v6 4))

(test-eq (void) (vector-swap! v6 0 4))

(test-eqv 255 (vector-ref v6 0))
(test-eqv 99 (vector-ref v6 1))
(test-eqv 0 (vector-ref v6 2))
(test-eqv 1 (vector-ref v6 3))
(test-eqv 0 (vector-ref v6 4))

(test-eqv 0 (vector-ref v7 0))
(test-eqv 99 (vector-ref v7 1))

(test-eqv 0 (vector-ref v8 0))
(test-eqv 99 (vector-ref v8 1))

(test-eqv 255 (vector-ref v9 0))
(test-eqv 99 (vector-ref v9 1))

(test-eq (void) (vector-shrink! v6 3))
(test-eq (void) (vector-shrink! v7 1))
(test-eq (void) (vector-shrink! v8 0))
(test-eq (void) (vector-shrink! v9 2))

(test-eqv 3 (vector-length v6))
(test-eqv 1 (vector-length v7))
(test-eqv 0 (vector-length v8))
(test-eqv 2 (vector-length v9))

(test-eq (void) (vector-fill! v6 0))
(test-equal '#(0 0 0) v6)

(test-eq (void) (vector-fill! v6 255))
(test-equal '#(255 255 255) v6)

(test-eq (void) (vector-fill! v6 3 1))
(test-equal '#(255 3 3) v6)

(test-eq (void) (vector-fill! v6 99 0 2))
(test-equal '#(99 99 3) v6)

(test-eq (void) (subvector-fill! v6 0 3 9))
(test-equal '#(9 9 9) v6)

(test-eq (void) (subvector-fill! v6 1 2 0))
(test-equal '#(9 0 9) v6)

(test-eq (void) (subvector-fill! v6 1 3 255))
(test-equal '#(9 255 255) v6)

(test-eq (void) (subvector-move! v9 0 2 v6 0))
(test-equal '#(255 99 255) v6)

(test-eq (void) (subvector-move! v9 0 2 v6 1))
(test-equal '#(255 255 99) v6)

(test-eq (void) (vector-copy! v6 0 '#(11 22 33)))
(test-equal '#(11 22 33) v6)

(test-eq (void) (vector-copy! v6 2 '#(33 44) 1))
(test-equal '#(11 22 44) v6)

(test-eq (void) (vector-copy! v6 1 '#(55 66 77 88) 0 2))
(test-equal '#(11 55 66) v6)





(test-error-tail type-exception? (make-vector bool))
(test-error-tail type-exception? (make-vector bool 11))



(test-error-tail range-exception? (make-vector -1 0))

(test-error-tail type-exception? (vector-length bool))

(test-error-tail type-exception? (vector->list bool))

(test-error-tail type-exception? (list->vector bool))

(test-error-tail type-exception? (vector-append bool))
(test-error-tail type-exception? (vector-append bool v9))
(test-error-tail type-exception? (vector-append v9 bool))

(test-error-tail type-exception? (vector-concatenate bool))
(test-error-tail type-exception? (vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (vector-copy bool))
(test-error-tail type-exception? (vector-copy v9 bool))
(test-error-tail type-exception? (vector-copy v9 0 bool))

(test-error-tail type-exception? (subvector bool 0 0))
(test-error-tail type-exception? (subvector v9 bool 0))
(test-error-tail type-exception? (subvector v9 0 bool))
(test-error-tail range-exception? (subvector v9 -1 0))
(test-error-tail range-exception? (subvector v9 3 0))
(test-error-tail range-exception? (subvector v9 0 -1))
(test-error-tail range-exception? (subvector v9 0 3))

(test-error-tail type-exception? (vector-ref bool 0))
(test-error-tail type-exception? (vector-ref v5 bool))
(test-error-tail range-exception? (vector-ref v5 -1))
(test-error-tail range-exception? (vector-ref v5 2))

(test-error-tail type-exception? (vector-set bool 0 11))
(test-error-tail type-exception? (vector-set v5 bool 11))



(test-error-tail range-exception? (vector-set v5 -1 0))
(test-error-tail range-exception? (vector-set v5 2 0))

(test-error-tail type-exception? (vector-set! bool 0 11))
(test-error-tail type-exception? (vector-set! v5 bool 11))



(test-error-tail range-exception? (vector-set! v5 -1 0))
(test-error-tail range-exception? (vector-set! v5 2 0))

(test-error-tail type-exception? (vector-swap! bool 0 11))
(test-error-tail type-exception? (vector-swap! v5 bool 11))
(test-error-tail type-exception? (vector-swap! v5 0 bool))
(test-error-tail range-exception? (vector-swap! v5 -1 0))
(test-error-tail range-exception? (vector-swap! v5 10 0))

(test-error-tail type-exception? (vector-shrink! bool 0))
(test-error-tail type-exception? (vector-shrink! v5 bool))
(test-error-tail range-exception? (vector-shrink! v5 3))

(test-error-tail type-exception? (vector-fill! bool 0))
(test-error-tail type-exception? (vector-fill! v5 0 bool))
(test-error-tail type-exception? (vector-fill! v5 0 0 bool))




(test-error-tail type-exception? (subvector-fill! bool 0 0 0))
(test-error-tail type-exception? (subvector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subvector-fill! v5 0 bool 0))



(test-error-tail range-exception? (subvector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subvector-fill! v5 3 0 0))
(test-error-tail range-exception? (subvector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subvector-fill! v5 0 3 0))

(test-error-tail type-exception? (subvector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subvector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subvector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subvector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subvector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subvector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subvector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subvector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subvector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subvector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subvector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-vector))
(test-error-tail wrong-number-of-arguments-exception? (make-vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (vector?))
(test-error-tail wrong-number-of-arguments-exception? (vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (vector->list))
(test-error-tail wrong-number-of-arguments-exception? (vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->vector))
(test-error-tail wrong-number-of-arguments-exception? (list->vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (vector-copy))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subvector))
(test-error-tail wrong-number-of-arguments-exception? (subvector v1))
(test-error-tail wrong-number-of-arguments-exception? (subvector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-set! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (vector-shrink! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subvector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subvector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subvector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subvector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subvector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-vector (expt 2 64)))
