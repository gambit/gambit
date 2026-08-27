(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#f32(-inf.0 +inf.0))

(define v2 (##f32vector -inf.0 -2.0 0.0 1.0 +inf.0))
(define v3 (##make-f32vector 2))
(define v4 (##make-f32vector 2 -inf.0))
(define v5 (##make-f32vector 2 +inf.0))

(define v6 (f32vector -inf.0 -2.0 0.0 1.0 +inf.0))
(define v7 (make-f32vector 2))
(define v8 (make-f32vector 2 -inf.0))
(define v9 (make-f32vector 2 +inf.0))

(test-assert (eq? #f (##f32vector? str)))
(test-assert (eq? #f (##f32vector? int)))
(test-assert (eq? #f (##f32vector? bool)))

(test-assert (eq? #t (##f32vector? v1)))
(test-assert (eq? #t (##f32vector? '#f32())))
(test-assert (eq? #t (##f32vector? '#f32(11.5))))
(test-assert (eq? #t (##f32vector? '#f32(11.5 22.5))))
(test-assert (eq? #t (##f32vector? '#f32(11.5 22.5 33.5))))
(test-assert (eq? #t (##f32vector? '#f32(11.5 22.5 33.5 44.5))))
(test-assert (eq? #t (##f32vector? '#f32(11.5 22.5 33.5 44.5 55.5))))

(test-assert (eq? #t (##f32vector? v2)))
(test-assert (eq? #t (##f32vector? (##f32vector))))
(test-assert (eq? #t (##f32vector? (##f32vector 11.5))))
(test-assert (eq? #t (##f32vector? (##f32vector 11.5 22.5))))
(test-assert (eq? #t (##f32vector? (##f32vector 11.5 22.5 33.5))))
(test-assert (eq? #t (##f32vector? (##f32vector 11.5 22.5 33.5 44.5))))
(test-assert (eq? #t (##f32vector? (##f32vector 11.5 22.5 33.5 44.5 55.5))))

(test-assert (eq? #t (##f32vector? v3)))
(test-assert (eq? #t (##f32vector? (##make-f32vector 0))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 1))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 10))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 100))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 1000))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 10000))))

(test-assert (eq? #t (##f32vector? v4)))
(test-assert (eq? #t (##f32vector? v5)))
(test-assert (eq? #t (##f32vector? (##make-f32vector 0 11.5))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 1 22.5))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 10 33.5))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 100 44.5))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 1000 55.5))))
(test-assert (eq? #t (##f32vector? (##make-f32vector 10000 66.5))))

(test-eqv 2 (##f32vector-length v1))
(test-eqv 0 (##f32vector-length '#f32()))
(test-eqv 1 (##f32vector-length '#f32(11.5)))
(test-eqv 2 (##f32vector-length '#f32(11.5 22.5)))
(test-eqv 3 (##f32vector-length '#f32(11.5 22.5 33.5)))
(test-eqv 4 (##f32vector-length '#f32(11.5 22.5 33.5 44.5)))
(test-eqv 5 (##f32vector-length '#f32(11.5 22.5 33.5 44.5 55.5)))

(test-eqv 5 (##f32vector-length v2))
(test-eqv 0 (##f32vector-length (##f32vector)))
(test-eqv 1 (##f32vector-length (##f32vector 11.5)))
(test-eqv 2 (##f32vector-length (##f32vector 11.5 22.5)))
(test-eqv 3 (##f32vector-length (##f32vector 11.5 22.5 33.5)))
(test-eqv 4 (##f32vector-length (##f32vector 11.5 22.5 33.5 44.5)))
(test-eqv 5 (##f32vector-length (##f32vector 11.5 22.5 33.5 44.5 55.5)))

(test-eqv 2 (##f32vector-length v3))
(test-eqv 0 (##f32vector-length (##make-f32vector 0)))
(test-eqv 1 (##f32vector-length (##make-f32vector 1)))
(test-eqv 10 (##f32vector-length (##make-f32vector 10)))
(test-eqv 100 (##f32vector-length (##make-f32vector 100)))
(test-eqv 1000 (##f32vector-length (##make-f32vector 1000)))
(test-eqv 10000 (##f32vector-length (##make-f32vector 10000)))

(test-eqv 2 (##f32vector-length v4))
(test-eqv 2 (##f32vector-length v5))
(test-eqv 0 (##f32vector-length (##make-f32vector 0 11.5)))
(test-eqv 1 (##f32vector-length (##make-f32vector 1 22.5)))
(test-eqv 10 (##f32vector-length (##make-f32vector 10 33.5)))
(test-eqv 100 (##f32vector-length (##make-f32vector 100 44.5)))
(test-eqv 1000 (##f32vector-length (##make-f32vector 1000 55.5)))
(test-eqv 10000 (##f32vector-length (##make-f32vector 10000 66.5)))

(test-eqv -inf.0 (##f32vector-ref v1 0))
(test-eqv +inf.0 (##f32vector-ref v1 1))

(test-eqv -inf.0 (##f32vector-ref v2 0))
(test-eqv -2.0 (##f32vector-ref v2 1))
(test-eqv 0.0 (##f32vector-ref v2 2))
(test-eqv 1.0 (##f32vector-ref v2 3))
(test-eqv +inf.0 (##f32vector-ref v2 4))

(test-eqv -inf.0 (##f32vector-ref v4 0))
(test-eqv -inf.0 (##f32vector-ref v4 1))

(test-eqv +inf.0 (##f32vector-ref v5 0))
(test-eqv +inf.0 (##f32vector-ref v5 1))

(test-equal
 '#f32(-inf.0 99.5 0.0 1.0 +inf.0)
 (##f32vector-set v2 1 99.5))
(test-equal '#f32(-inf.0 -2.0 0.0 1.0 +inf.0) v2)
(test-equal '#f32(-inf.0 99.5) (##f32vector-set v4 1 99.5))
(test-equal '#f32(+inf.0 99.5) (##f32vector-set v5 1 99.5))
(test-equal '#f32(99.5 22.5 33.5) (##f32vector-set '#f32(11.5 22.5 33.5) 0 99.5))

(test-eq v2 (##f32vector-set! v2 1 99.5))
(test-eq v3 (##f32vector-set! v3 1 99.5))
(test-eq v4 (##f32vector-set! v4 1 99.5))
(test-eq v5 (##f32vector-set! v5 1 99.5))

(test-eqv -inf.0 (##f32vector-ref v2 0))
(test-eqv 99.5 (##f32vector-ref v2 1))
(test-eqv 0.0 (##f32vector-ref v2 2))
(test-eqv 1.0 (##f32vector-ref v2 3))
(test-eqv +inf.0 (##f32vector-ref v2 4))

(test-eqv v2 (##f32vector-swap! v2 0 4))

(test-eqv +inf.0 (##f32vector-ref v2 0))
(test-eqv 99.5 (##f32vector-ref v2 1))
(test-eqv 0.0 (##f32vector-ref v2 2))
(test-eqv 1.0 (##f32vector-ref v2 3))
(test-eqv -inf.0 (##f32vector-ref v2 4))

(test-eqv 99.5 (##f32vector-ref v3 1))

(test-eqv -inf.0 (##f32vector-ref v4 0))
(test-eqv 99.5 (##f32vector-ref v4 1))

(test-eqv +inf.0 (##f32vector-ref v5 0))
(test-eqv 99.5 (##f32vector-ref v5 1))

(test-eq v2 (##f32vector-shrink! v2 3))
(test-eq v3 (##f32vector-shrink! v3 1))
(test-eq v4 (##f32vector-shrink! v4 0))
(test-eq v5 (##f32vector-shrink! v5 2))

(test-eqv 3 (##f32vector-length v2))
(test-eqv 1 (##f32vector-length v3))
(test-eqv 0 (##f32vector-length v4))
(test-eqv 2 (##f32vector-length v5))

(test-assert (eq? #t (f32vector? v1)))
(test-assert (eq? #t (f32vector? '#f32())))
(test-assert (eq? #t (f32vector? '#f32(11.5))))
(test-assert (eq? #t (f32vector? '#f32(11.5 22.5))))
(test-assert (eq? #t (f32vector? '#f32(11.5 22.5 33.5))))
(test-assert (eq? #t (f32vector? '#f32(11.5 22.5 33.5 44.5))))
(test-assert (eq? #t (f32vector? '#f32(11.5 22.5 33.5 44.5 55.5))))

(test-assert (eq? #t (f32vector? v6)))
(test-assert (eq? #t (f32vector? (f32vector))))
(test-assert (eq? #t (f32vector? (f32vector 11.5))))
(test-assert (eq? #t (f32vector? (f32vector 11.5 22.5))))
(test-assert (eq? #t (f32vector? (f32vector 11.5 22.5 33.5))))
(test-assert (eq? #t (f32vector? (f32vector 11.5 22.5 33.5 44.5))))
(test-assert (eq? #t (f32vector? (f32vector 11.5 22.5 33.5 44.5 55.5))))

(test-assert (eq? #t (f32vector? v7)))
(test-assert (eq? #t (f32vector? (make-f32vector 0))))
(test-assert (eq? #t (f32vector? (make-f32vector 1))))
(test-assert (eq? #t (f32vector? (make-f32vector 10))))
(test-assert (eq? #t (f32vector? (make-f32vector 100))))
(test-assert (eq? #t (f32vector? (make-f32vector 1000))))
(test-assert (eq? #t (f32vector? (make-f32vector 10000))))

(test-assert (eq? #t (f32vector? v8)))
(test-assert (eq? #t (f32vector? v9)))
(test-assert (eq? #t (f32vector? (make-f32vector 0 11.5))))
(test-assert (eq? #t (f32vector? (make-f32vector 1 22.5))))
(test-assert (eq? #t (f32vector? (make-f32vector 10 33.5))))
(test-assert (eq? #t (f32vector? (make-f32vector 100 44.5))))
(test-assert (eq? #t (f32vector? (make-f32vector 1000 55.5))))
(test-assert (eq? #t (f32vector? (make-f32vector 10000 66.5))))

(test-eqv 2 (f32vector-length v1))
(test-eqv 0 (f32vector-length '#f32()))
(test-eqv 1 (f32vector-length '#f32(11.5)))
(test-eqv 2 (f32vector-length '#f32(11.5 22.5)))
(test-eqv 3 (f32vector-length '#f32(11.5 22.5 33.5)))
(test-eqv 4 (f32vector-length '#f32(11.5 22.5 33.5 44.5)))
(test-eqv 5 (f32vector-length '#f32(11.5 22.5 33.5 44.5 55.5)))

(test-eqv 5 (f32vector-length v6))
(test-eqv 0 (f32vector-length (f32vector)))
(test-eqv 1 (f32vector-length (f32vector 11.5)))
(test-eqv 2 (f32vector-length (f32vector 11.5 22.5)))
(test-eqv 3 (f32vector-length (f32vector 11.5 22.5 33.5)))
(test-eqv 4 (f32vector-length (f32vector 11.5 22.5 33.5 44.5)))
(test-eqv 5 (f32vector-length (f32vector 11.5 22.5 33.5 44.5 55.5)))

(test-eqv 2 (f32vector-length v7))
(test-eqv 0 (f32vector-length (make-f32vector 0)))
(test-eqv 1 (f32vector-length (make-f32vector 1)))
(test-eqv 10 (f32vector-length (make-f32vector 10)))
(test-eqv 100 (f32vector-length (make-f32vector 100)))
(test-eqv 1000 (f32vector-length (make-f32vector 1000)))
(test-eqv 10000 (f32vector-length (make-f32vector 10000)))

(test-eqv 2 (f32vector-length v8))
(test-eqv 2 (f32vector-length v9))
(test-eqv 0 (f32vector-length (make-f32vector 0 11.5)))
(test-eqv 1 (f32vector-length (make-f32vector 1 22.5)))
(test-eqv 10 (f32vector-length (make-f32vector 10 33.5)))
(test-eqv 100 (f32vector-length (make-f32vector 100 44.5)))
(test-eqv 1000 (f32vector-length (make-f32vector 1000 55.5)))
(test-eqv 10000 (f32vector-length (make-f32vector 10000 66.5)))

(test-equal '() (f32vector->list '#f32()))
(test-equal
 '(-inf.0 -2.0 0.0 1.0 +inf.0)
 (f32vector->list v6))
(test-equal
 '(-inf.0 -2.0 0.0 1.0 +inf.0)
 (f32vector->list v6 0))
(test-equal '(0.0 1.0 +inf.0) (f32vector->list v6 2))
(test-equal '(0.0 1.0) (f32vector->list v6 2 4))
(test-equal
 '(-inf.0 -2.0 0.0 1.0 +inf.0)
 (f32vector->list v6 0 5))
(test-equal '(0.0 0.0) (f32vector->list v7))

(test-equal '#f32() (list->f32vector '()))
(test-equal
 v6
 (list->f32vector '(-inf.0 -2.0 0.0 1.0 +inf.0)))
(test-equal v7 (list->f32vector '(0.0 0.0)))

(test-equal '#f32() (f32vector-append))
(test-equal v6 (f32vector-append v6))
(test-equal
 v6
 (f32vector-append
  '#f32(-inf.0 -2.0)
  '#f32(0.0 1.0 +inf.0)))
(test-equal
 '#f32(-inf.0
       -2.0
       0.0
       1.0
       +inf.0
       0.0
       0.0
       -inf.0
       -2.0
       0.0
       1.0
       +inf.0)
 (f32vector-append v6 v7 v6))

(test-equal
 '#f32(-inf.0
       -2.0
       0.0
       1.0
       +inf.0
       0.0
       0.0
       -inf.0
       -2.0
       0.0
       1.0
       +inf.0)
 (f32vector-concatenate (list v6 v7 v6)))
(test-equal
 '#f32(-inf.0
       -2.0
       0.0
       1.0
       +inf.0
       1.0
       1.0
       1.0
       0.0
       0.0
       1.0
       1.0
       1.0
       -inf.0
       -2.0
       0.0
       1.0
       +inf.0)
 (f32vector-concatenate (list v6 v7 v6) '#f32(1.0 1.0 1.0)))

(test-equal '#f32() (f32vector-copy '#f32()))
(test-equal v6 (f32vector-copy v6))
(test-equal v6 (f32vector-copy v6 0))
(test-equal '#f32(0.0 1.0 +inf.0) (f32vector-copy v6 2))
(test-equal '#f32() (f32vector-copy v6 0 0))
(test-equal '#f32() (f32vector-copy v6 4 4))
(test-equal '#f32(-inf.0 -2.0) (f32vector-copy v6 0 2))
(test-equal '#f32(0.0 1.0) (f32vector-copy v6 2 4))
(test-equal '#f32(+inf.0) (f32vector-copy v6 4 5))
(test-equal v6 (f32vector-copy v6 0 5))

(test-equal '#f32() (subf32vector v6 0 0))
(test-equal '#f32() (subf32vector v6 4 4))
(test-equal '#f32(-inf.0 -2.0) (subf32vector v6 0 2))
(test-equal '#f32(0.0 1.0) (subf32vector v6 2 4))
(test-equal '#f32(+inf.0) (subf32vector v6 4 5))
(test-equal v6 (subf32vector v6 0 5))

(test-eqv -inf.0 (f32vector-ref v1 0))
(test-eqv +inf.0 (f32vector-ref v1 1))

(test-eqv -inf.0 (f32vector-ref v6 0))
(test-eqv -2.0 (f32vector-ref v6 1))
(test-eqv 0.0 (f32vector-ref v6 2))
(test-eqv 1.0 (f32vector-ref v6 3))
(test-eqv +inf.0 (f32vector-ref v6 4))

(test-eqv 0.0 (f32vector-ref v7 0))
(test-eqv 0.0 (f32vector-ref v7 1))

(test-eqv -inf.0 (f32vector-ref v8 0))
(test-eqv -inf.0 (f32vector-ref v8 1))

(test-eqv +inf.0 (f32vector-ref v9 0))
(test-eqv +inf.0 (f32vector-ref v9 1))

(test-equal
 '#f32(-inf.0 99.5 0.0 1.0 +inf.0)
 (f32vector-set v6 1 99.5))
(test-equal '#f32(-inf.0 -2.0 0.0 1.0 +inf.0) v6)
(test-equal '#f32(-inf.0 99.5) (f32vector-set v8 1 99.5))
(test-equal '#f32(+inf.0 99.5) (f32vector-set v9 1 99.5))
(test-equal '#f32(99.5 22.5 33.5) (f32vector-set '#f32(11.5 22.5 33.5) 0 99.5))

(test-eq (void) (f32vector-set! v6 1 99.5))
(test-eq (void) (f32vector-set! v7 1 99.5))
(test-eq (void) (f32vector-set! v8 1 99.5))
(test-eq (void) (f32vector-set! v9 1 99.5))

(test-eqv -inf.0 (f32vector-ref v6 0))
(test-eqv 99.5 (f32vector-ref v6 1))
(test-eqv 0.0 (f32vector-ref v6 2))
(test-eqv 1.0 (f32vector-ref v6 3))
(test-eqv +inf.0 (f32vector-ref v6 4))

(test-eq (void) (f32vector-swap! v6 0 4))

(test-eqv +inf.0 (f32vector-ref v6 0))
(test-eqv 99.5 (f32vector-ref v6 1))
(test-eqv 0.0 (f32vector-ref v6 2))
(test-eqv 1.0 (f32vector-ref v6 3))
(test-eqv -inf.0 (f32vector-ref v6 4))

(test-eqv 0.0 (f32vector-ref v7 0))
(test-eqv 99.5 (f32vector-ref v7 1))

(test-eqv -inf.0 (f32vector-ref v8 0))
(test-eqv 99.5 (f32vector-ref v8 1))

(test-eqv +inf.0 (f32vector-ref v9 0))
(test-eqv 99.5 (f32vector-ref v9 1))

(test-eq (void) (f32vector-shrink! v6 3))
(test-eq (void) (f32vector-shrink! v7 1))
(test-eq (void) (f32vector-shrink! v8 0))
(test-eq (void) (f32vector-shrink! v9 2))

(test-eqv 3 (f32vector-length v6))
(test-eqv 1 (f32vector-length v7))
(test-eqv 0 (f32vector-length v8))
(test-eqv 2 (f32vector-length v9))

(test-eq (void) (f32vector-fill! v6 -inf.0))
(test-equal
 '#f32(-inf.0 -inf.0 -inf.0)
 v6)

(test-eq (void) (f32vector-fill! v6 +inf.0))
(test-equal
 '#f32(+inf.0 +inf.0 +inf.0)
 v6)

(test-eq (void) (f32vector-fill! v6 3.0 1))
(test-equal '#f32(+inf.0 3.0 3.0) v6)

(test-eq (void) (f32vector-fill! v6 99.5 0 2))
(test-equal '#f32(99.5 99.5 3.0) v6)

(test-eq (void) (subf32vector-fill! v6 0 3 9.0))
(test-equal '#f32(9.0 9.0 9.0) v6)

(test-eq (void) (subf32vector-fill! v6 1 2 -inf.0))
(test-equal '#f32(9.0 -inf.0 9.0) v6)

(test-eq (void) (subf32vector-fill! v6 1 3 +inf.0))
(test-equal '#f32(9.0 +inf.0 +inf.0) v6)

(test-eq (void) (subf32vector-move! v9 0 2 v6 0))
(test-equal '#f32(+inf.0 99.5 +inf.0) v6)

(test-eq (void) (subf32vector-move! v9 0 2 v6 1))
(test-equal '#f32(+inf.0 +inf.0 99.5) v6)

(test-eq (void) (f32vector-copy! v6 0 '#f32(11.5 22.5 33.5)))
(test-equal '#f32(11.5 22.5 33.5) v6)

(test-eq (void) (f32vector-copy! v6 2 '#f32(33.5 44.5) 1))
(test-equal '#f32(11.5 22.5 44.5) v6)

(test-eq (void) (f32vector-copy! v6 1 '#f32(55.5 66.5 77.5 88.5) 0 2))
(test-equal '#f32(11.5 55.5 66.5) v6)

(test-error-tail type-exception? (f32vector 11.5 bool 22.5))
;; homovect only
(test-error-tail type-exception? (f32vector 11.5 -9223372036854775809 22.5))
;; homovect only
(test-error-tail type-exception? (f32vector 11.5 9223372036854775808 22.5))
;; homovect only

(test-error-tail type-exception? (make-f32vector bool))
(test-error-tail type-exception? (make-f32vector bool 11.5))
(test-error-tail type-exception? (make-f32vector 11.5 bool))
;; homovect only
(test-error-tail type-exception? (make-f32vector 11.5 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (make-f32vector 11.5 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (make-f32vector -1 0))

(test-error-tail type-exception? (f32vector-length bool))

(test-error-tail type-exception? (f32vector->list bool))

(test-error-tail type-exception? (list->f32vector bool))

(test-error-tail type-exception? (f32vector-append bool))
(test-error-tail type-exception? (f32vector-append bool v9))
(test-error-tail type-exception? (f32vector-append v9 bool))

(test-error-tail type-exception? (f32vector-concatenate bool))
(test-error-tail type-exception? (f32vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (f32vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (f32vector-copy bool))
(test-error-tail type-exception? (f32vector-copy v9 bool))
(test-error-tail type-exception? (f32vector-copy v9 0 bool))

(test-error-tail type-exception? (subf32vector bool 0 0))
(test-error-tail type-exception? (subf32vector v9 bool 0))
(test-error-tail type-exception? (subf32vector v9 0 bool))
(test-error-tail range-exception? (subf32vector v9 -1 0))
(test-error-tail range-exception? (subf32vector v9 3 0))
(test-error-tail range-exception? (subf32vector v9 0 -1))
(test-error-tail range-exception? (subf32vector v9 0 3))

(test-error-tail type-exception? (f32vector-ref bool 0))
(test-error-tail type-exception? (f32vector-ref v5 bool))
(test-error-tail range-exception? (f32vector-ref v5 -1))
(test-error-tail range-exception? (f32vector-ref v5 2))

(test-error-tail type-exception? (f32vector-set bool 0 11.5))
(test-error-tail type-exception? (f32vector-set v5 bool 11.5))
(test-error-tail type-exception? (f32vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (f32vector-set v5 0 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (f32vector-set v5 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (f32vector-set v5 -1 0))
(test-error-tail range-exception? (f32vector-set v5 2 0))

(test-error-tail type-exception? (f32vector-set! bool 0 11.5))
(test-error-tail type-exception? (f32vector-set! v5 bool 11.5))
(test-error-tail type-exception? (f32vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (f32vector-set! v5 0 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (f32vector-set! v5 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (f32vector-set! v5 -1 0))
(test-error-tail range-exception? (f32vector-set! v5 2 0))

(test-error-tail type-exception? (f32vector-swap! bool 0 11.5))
(test-error-tail type-exception? (f32vector-swap! v5 bool 11.5))
(test-error-tail type-exception? (f32vector-swap! v5 0 bool))
(test-error-tail range-exception? (f32vector-swap! v5 -1 0))
(test-error-tail range-exception? (f32vector-swap! v5 10 0))

(test-error-tail type-exception? (f32vector-shrink! bool 0))
(test-error-tail type-exception? (f32vector-shrink! v5 bool))
(test-error-tail range-exception? (f32vector-shrink! v5 3))

(test-error-tail type-exception? (f32vector-fill! bool 0))
(test-error-tail type-exception? (f32vector-fill! v5 0 bool))
(test-error-tail type-exception? (f32vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (f32vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (f32vector-fill! v5 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (f32vector-fill! v5 9223372036854775808))
;; homovect only

(test-error-tail type-exception? (subf32vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subf32vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subf32vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subf32vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail
 type-exception?
 (subf32vector-fill! v5 0 0 -9223372036854775809))
;; homovect only
(test-error-tail
 type-exception?
 (subf32vector-fill! v5 0 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (subf32vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subf32vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subf32vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subf32vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subf32vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subf32vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subf32vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subf32vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subf32vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subf32vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subf32vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subf32vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subf32vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subf32vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subf32vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (f32vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (f32vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (f32vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (f32vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (f32vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (f32vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (f32vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (f32vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (f32vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (f32vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (f32vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-f32vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (make-f32vector 11.5 22.5 33.5))

(test-error-tail wrong-number-of-arguments-exception? (f32vector?))
(test-error-tail wrong-number-of-arguments-exception? (f32vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (f32vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->f32vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (list->f32vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-copy))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subf32vector))
(test-error-tail wrong-number-of-arguments-exception? (subf32vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subf32vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subf32vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-set! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subf32vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subf32vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subf32vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subf32vector-move! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subf32vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (f32vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (f32vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (f32vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-f32vector (expt 2 64)))
