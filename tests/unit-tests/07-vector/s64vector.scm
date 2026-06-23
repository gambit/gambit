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

(test-assert (eq? #f (##s64vector? str)))
(test-assert (eq? #f (##s64vector? int)))
(test-assert (eq? #f (##s64vector? bool)))

(test-assert (eq? #t (##s64vector? v1)))
(test-assert (eq? #t (##s64vector? '#s64())))
(test-assert (eq? #t (##s64vector? '#s64(11))))
(test-assert (eq? #t (##s64vector? '#s64(11 22))))
(test-assert (eq? #t (##s64vector? '#s64(11 22 33))))
(test-assert (eq? #t (##s64vector? '#s64(11 22 33 44))))
(test-assert (eq? #t (##s64vector? '#s64(11 22 33 44 55))))

(test-assert (eq? #t (##s64vector? v2)))
(test-assert (eq? #t (##s64vector? (##s64vector))))
(test-assert (eq? #t (##s64vector? (##s64vector 11))))
(test-assert (eq? #t (##s64vector? (##s64vector 11 22))))
(test-assert (eq? #t (##s64vector? (##s64vector 11 22 33))))
(test-assert (eq? #t (##s64vector? (##s64vector 11 22 33 44))))
(test-assert (eq? #t (##s64vector? (##s64vector 11 22 33 44 55))))

(test-assert (eq? #t (##s64vector? v3)))
(test-assert (eq? #t (##s64vector? (##make-s64vector 0))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 1))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 10))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 100))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 1000))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 10000))))

(test-assert (eq? #t (##s64vector? v4)))
(test-assert (eq? #t (##s64vector? v5)))
(test-assert (eq? #t (##s64vector? (##make-s64vector 0 11))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 1 22))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 10 33))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 100 44))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 1000 55))))
(test-assert (eq? #t (##s64vector? (##make-s64vector 10000 66))))

(test-eqv 2 (##s64vector-length v1))
(test-eqv 0 (##s64vector-length '#s64()))
(test-eqv 1 (##s64vector-length '#s64(11)))
(test-eqv 2 (##s64vector-length '#s64(11 22)))
(test-eqv 3 (##s64vector-length '#s64(11 22 33)))
(test-eqv 4 (##s64vector-length '#s64(11 22 33 44)))
(test-eqv 5 (##s64vector-length '#s64(11 22 33 44 55)))

(test-eqv 5 (##s64vector-length v2))
(test-eqv 0 (##s64vector-length (##s64vector)))
(test-eqv 1 (##s64vector-length (##s64vector 11)))
(test-eqv 2 (##s64vector-length (##s64vector 11 22)))
(test-eqv 3 (##s64vector-length (##s64vector 11 22 33)))
(test-eqv 4 (##s64vector-length (##s64vector 11 22 33 44)))
(test-eqv 5 (##s64vector-length (##s64vector 11 22 33 44 55)))

(test-eqv 2 (##s64vector-length v3))
(test-eqv 0 (##s64vector-length (##make-s64vector 0)))
(test-eqv 1 (##s64vector-length (##make-s64vector 1)))
(test-eqv 10 (##s64vector-length (##make-s64vector 10)))
(test-eqv 100 (##s64vector-length (##make-s64vector 100)))
(test-eqv 1000 (##s64vector-length (##make-s64vector 1000)))
(test-eqv 10000 (##s64vector-length (##make-s64vector 10000)))

(test-eqv 2 (##s64vector-length v4))
(test-eqv 2 (##s64vector-length v5))
(test-eqv 0 (##s64vector-length (##make-s64vector 0 11)))
(test-eqv 1 (##s64vector-length (##make-s64vector 1 22)))
(test-eqv 10 (##s64vector-length (##make-s64vector 10 33)))
(test-eqv 100 (##s64vector-length (##make-s64vector 100 44)))
(test-eqv 1000 (##s64vector-length (##make-s64vector 1000 55)))
(test-eqv 10000 (##s64vector-length (##make-s64vector 10000 66)))

(test-eqv -9223372036854775808 (##s64vector-ref v1 0))
(test-eqv 9223372036854775807 (##s64vector-ref v1 1))

(test-eqv -9223372036854775808 (##s64vector-ref v2 0))
(test-eqv -2 (##s64vector-ref v2 1))
(test-eqv 0 (##s64vector-ref v2 2))
(test-eqv 1 (##s64vector-ref v2 3))
(test-eqv 9223372036854775807 (##s64vector-ref v2 4))

(test-eqv -9223372036854775808 (##s64vector-ref v4 0))
(test-eqv -9223372036854775808 (##s64vector-ref v4 1))

(test-eqv 9223372036854775807 (##s64vector-ref v5 0))
(test-eqv 9223372036854775807 (##s64vector-ref v5 1))

(test-equal
 '#s64(-9223372036854775808 99 0 1 9223372036854775807)
 (##s64vector-set v2 1 99))
(test-equal '#s64(-9223372036854775808 -2 0 1 9223372036854775807) v2)
(test-equal '#s64(-9223372036854775808 99) (##s64vector-set v4 1 99))
(test-equal '#s64(9223372036854775807 99) (##s64vector-set v5 1 99))
(test-equal '#s64(99 22 33) (##s64vector-set '#s64(11 22 33) 0 99))

(test-eq v2 (##s64vector-set! v2 1 99))
(test-eq v3 (##s64vector-set! v3 1 99))
(test-eq v4 (##s64vector-set! v4 1 99))
(test-eq v5 (##s64vector-set! v5 1 99))

(test-eqv -9223372036854775808 (##s64vector-ref v2 0))
(test-eqv 99 (##s64vector-ref v2 1))
(test-eqv 0 (##s64vector-ref v2 2))
(test-eqv 1 (##s64vector-ref v2 3))
(test-eqv 9223372036854775807 (##s64vector-ref v2 4))

(test-eqv v2 (##s64vector-swap! v2 0 4))

(test-eqv 9223372036854775807 (##s64vector-ref v2 0))
(test-eqv 99 (##s64vector-ref v2 1))
(test-eqv 0 (##s64vector-ref v2 2))
(test-eqv 1 (##s64vector-ref v2 3))
(test-eqv -9223372036854775808 (##s64vector-ref v2 4))

(test-eqv 99 (##s64vector-ref v3 1))

(test-eqv -9223372036854775808 (##s64vector-ref v4 0))
(test-eqv 99 (##s64vector-ref v4 1))

(test-eqv 9223372036854775807 (##s64vector-ref v5 0))
(test-eqv 99 (##s64vector-ref v5 1))

(test-eq v2 (##s64vector-shrink! v2 3))
(test-eq v3 (##s64vector-shrink! v3 1))
(test-eq v4 (##s64vector-shrink! v4 0))
(test-eq v5 (##s64vector-shrink! v5 2))

(test-eqv 3 (##s64vector-length v2))
(test-eqv 1 (##s64vector-length v3))
(test-eqv 0 (##s64vector-length v4))
(test-eqv 2 (##s64vector-length v5))

(test-assert (eq? #t (s64vector? v1)))
(test-assert (eq? #t (s64vector? '#s64())))
(test-assert (eq? #t (s64vector? '#s64(11))))
(test-assert (eq? #t (s64vector? '#s64(11 22))))
(test-assert (eq? #t (s64vector? '#s64(11 22 33))))
(test-assert (eq? #t (s64vector? '#s64(11 22 33 44))))
(test-assert (eq? #t (s64vector? '#s64(11 22 33 44 55))))

(test-assert (eq? #t (s64vector? v6)))
(test-assert (eq? #t (s64vector? (s64vector))))
(test-assert (eq? #t (s64vector? (s64vector 11))))
(test-assert (eq? #t (s64vector? (s64vector 11 22))))
(test-assert (eq? #t (s64vector? (s64vector 11 22 33))))
(test-assert (eq? #t (s64vector? (s64vector 11 22 33 44))))
(test-assert (eq? #t (s64vector? (s64vector 11 22 33 44 55))))

(test-assert (eq? #t (s64vector? v7)))
(test-assert (eq? #t (s64vector? (make-s64vector 0))))
(test-assert (eq? #t (s64vector? (make-s64vector 1))))
(test-assert (eq? #t (s64vector? (make-s64vector 10))))
(test-assert (eq? #t (s64vector? (make-s64vector 100))))
(test-assert (eq? #t (s64vector? (make-s64vector 1000))))
(test-assert (eq? #t (s64vector? (make-s64vector 10000))))

(test-assert (eq? #t (s64vector? v8)))
(test-assert (eq? #t (s64vector? v9)))
(test-assert (eq? #t (s64vector? (make-s64vector 0 11))))
(test-assert (eq? #t (s64vector? (make-s64vector 1 22))))
(test-assert (eq? #t (s64vector? (make-s64vector 10 33))))
(test-assert (eq? #t (s64vector? (make-s64vector 100 44))))
(test-assert (eq? #t (s64vector? (make-s64vector 1000 55))))
(test-assert (eq? #t (s64vector? (make-s64vector 10000 66))))

(test-eqv 2 (s64vector-length v1))
(test-eqv 0 (s64vector-length '#s64()))
(test-eqv 1 (s64vector-length '#s64(11)))
(test-eqv 2 (s64vector-length '#s64(11 22)))
(test-eqv 3 (s64vector-length '#s64(11 22 33)))
(test-eqv 4 (s64vector-length '#s64(11 22 33 44)))
(test-eqv 5 (s64vector-length '#s64(11 22 33 44 55)))

(test-eqv 5 (s64vector-length v6))
(test-eqv 0 (s64vector-length (s64vector)))
(test-eqv 1 (s64vector-length (s64vector 11)))
(test-eqv 2 (s64vector-length (s64vector 11 22)))
(test-eqv 3 (s64vector-length (s64vector 11 22 33)))
(test-eqv 4 (s64vector-length (s64vector 11 22 33 44)))
(test-eqv 5 (s64vector-length (s64vector 11 22 33 44 55)))

(test-eqv 2 (s64vector-length v7))
(test-eqv 0 (s64vector-length (make-s64vector 0)))
(test-eqv 1 (s64vector-length (make-s64vector 1)))
(test-eqv 10 (s64vector-length (make-s64vector 10)))
(test-eqv 100 (s64vector-length (make-s64vector 100)))
(test-eqv 1000 (s64vector-length (make-s64vector 1000)))
(test-eqv 10000 (s64vector-length (make-s64vector 10000)))

(test-eqv 2 (s64vector-length v8))
(test-eqv 2 (s64vector-length v9))
(test-eqv 0 (s64vector-length (make-s64vector 0 11)))
(test-eqv 1 (s64vector-length (make-s64vector 1 22)))
(test-eqv 10 (s64vector-length (make-s64vector 10 33)))
(test-eqv 100 (s64vector-length (make-s64vector 100 44)))
(test-eqv 1000 (s64vector-length (make-s64vector 1000 55)))
(test-eqv 10000 (s64vector-length (make-s64vector 10000 66)))

(test-equal '() (s64vector->list '#s64()))
(test-equal
 '(-9223372036854775808 -2 0 1 9223372036854775807)
 (s64vector->list v6))
(test-equal
 '(-9223372036854775808 -2 0 1 9223372036854775807)
 (s64vector->list v6 0))
(test-equal '(0 1 9223372036854775807) (s64vector->list v6 2))
(test-equal '(0 1) (s64vector->list v6 2 4))
(test-equal
 '(-9223372036854775808 -2 0 1 9223372036854775807)
 (s64vector->list v6 0 5))
(test-equal '(0 0) (s64vector->list v7))

(test-equal '#s64() (list->s64vector '()))
(test-equal
 v6
 (list->s64vector '(-9223372036854775808 -2 0 1 9223372036854775807)))
(test-equal v7 (list->s64vector '(0 0)))

(test-equal '#s64() (s64vector-append))
(test-equal v6 (s64vector-append v6))
(test-equal
 v6
 (s64vector-append
  '#s64(-9223372036854775808 -2)
  '#s64(0 1 9223372036854775807)))
(test-equal
 '#s64(-9223372036854775808
       -2
       0
       1
       9223372036854775807
       0
       0
       -9223372036854775808
       -2
       0
       1
       9223372036854775807)
 (s64vector-append v6 v7 v6))

(test-equal
 '#s64(-9223372036854775808
       -2
       0
       1
       9223372036854775807
       0
       0
       -9223372036854775808
       -2
       0
       1
       9223372036854775807)
 (s64vector-concatenate (list v6 v7 v6)))
(test-equal
 '#s64(-9223372036854775808
       -2
       0
       1
       9223372036854775807
       1
       1
       1
       0
       0
       1
       1
       1
       -9223372036854775808
       -2
       0
       1
       9223372036854775807)
 (s64vector-concatenate (list v6 v7 v6) '#s64(1 1 1)))

(test-equal '#s64() (s64vector-copy '#s64()))
(test-equal v6 (s64vector-copy v6))
(test-equal v6 (s64vector-copy v6 0))
(test-equal '#s64(0 1 9223372036854775807) (s64vector-copy v6 2))
(test-equal '#s64() (s64vector-copy v6 0 0))
(test-equal '#s64() (s64vector-copy v6 4 4))
(test-equal '#s64(-9223372036854775808 -2) (s64vector-copy v6 0 2))
(test-equal '#s64(0 1) (s64vector-copy v6 2 4))
(test-equal '#s64(9223372036854775807) (s64vector-copy v6 4 5))
(test-equal v6 (s64vector-copy v6 0 5))

(test-equal '#s64() (subs64vector v6 0 0))
(test-equal '#s64() (subs64vector v6 4 4))
(test-equal '#s64(-9223372036854775808 -2) (subs64vector v6 0 2))
(test-equal '#s64(0 1) (subs64vector v6 2 4))
(test-equal '#s64(9223372036854775807) (subs64vector v6 4 5))
(test-equal v6 (subs64vector v6 0 5))

(test-eqv -9223372036854775808 (s64vector-ref v1 0))
(test-eqv 9223372036854775807 (s64vector-ref v1 1))

(test-eqv -9223372036854775808 (s64vector-ref v6 0))
(test-eqv -2 (s64vector-ref v6 1))
(test-eqv 0 (s64vector-ref v6 2))
(test-eqv 1 (s64vector-ref v6 3))
(test-eqv 9223372036854775807 (s64vector-ref v6 4))

(test-eqv 0 (s64vector-ref v7 0))
(test-eqv 0 (s64vector-ref v7 1))

(test-eqv -9223372036854775808 (s64vector-ref v8 0))
(test-eqv -9223372036854775808 (s64vector-ref v8 1))

(test-eqv 9223372036854775807 (s64vector-ref v9 0))
(test-eqv 9223372036854775807 (s64vector-ref v9 1))

(test-equal
 '#s64(-9223372036854775808 99 0 1 9223372036854775807)
 (s64vector-set v6 1 99))
(test-equal '#s64(-9223372036854775808 -2 0 1 9223372036854775807) v6)
(test-equal '#s64(-9223372036854775808 99) (s64vector-set v8 1 99))
(test-equal '#s64(9223372036854775807 99) (s64vector-set v9 1 99))
(test-equal '#s64(99 22 33) (s64vector-set '#s64(11 22 33) 0 99))

(test-eq (void) (s64vector-set! v6 1 99))
(test-eq (void) (s64vector-set! v7 1 99))
(test-eq (void) (s64vector-set! v8 1 99))
(test-eq (void) (s64vector-set! v9 1 99))

(test-eqv -9223372036854775808 (s64vector-ref v6 0))
(test-eqv 99 (s64vector-ref v6 1))
(test-eqv 0 (s64vector-ref v6 2))
(test-eqv 1 (s64vector-ref v6 3))
(test-eqv 9223372036854775807 (s64vector-ref v6 4))

(test-eq (void) (s64vector-swap! v6 0 4))

(test-eqv 9223372036854775807 (s64vector-ref v6 0))
(test-eqv 99 (s64vector-ref v6 1))
(test-eqv 0 (s64vector-ref v6 2))
(test-eqv 1 (s64vector-ref v6 3))
(test-eqv -9223372036854775808 (s64vector-ref v6 4))

(test-eqv 0 (s64vector-ref v7 0))
(test-eqv 99 (s64vector-ref v7 1))

(test-eqv -9223372036854775808 (s64vector-ref v8 0))
(test-eqv 99 (s64vector-ref v8 1))

(test-eqv 9223372036854775807 (s64vector-ref v9 0))
(test-eqv 99 (s64vector-ref v9 1))

(test-eq (void) (s64vector-shrink! v6 3))
(test-eq (void) (s64vector-shrink! v7 1))
(test-eq (void) (s64vector-shrink! v8 0))
(test-eq (void) (s64vector-shrink! v9 2))

(test-eqv 3 (s64vector-length v6))
(test-eqv 1 (s64vector-length v7))
(test-eqv 0 (s64vector-length v8))
(test-eqv 2 (s64vector-length v9))

(test-eq (void) (s64vector-fill! v6 -9223372036854775808))
(test-equal
 '#s64(-9223372036854775808 -9223372036854775808 -9223372036854775808)
 v6)

(test-eq (void) (s64vector-fill! v6 9223372036854775807))
(test-equal
 '#s64(9223372036854775807 9223372036854775807 9223372036854775807)
 v6)

(test-eq (void) (s64vector-fill! v6 3 1))
(test-equal '#s64(9223372036854775807 3 3) v6)

(test-eq (void) (s64vector-fill! v6 99 0 2))
(test-equal '#s64(99 99 3) v6)

(test-eq (void) (subs64vector-fill! v6 0 3 9))
(test-equal '#s64(9 9 9) v6)

(test-eq (void) (subs64vector-fill! v6 1 2 -9223372036854775808))
(test-equal '#s64(9 -9223372036854775808 9) v6)

(test-eq (void) (subs64vector-fill! v6 1 3 9223372036854775807))
(test-equal '#s64(9 9223372036854775807 9223372036854775807) v6)

(test-eq (void) (subs64vector-move! v9 0 2 v6 0))
(test-equal '#s64(9223372036854775807 99 9223372036854775807) v6)

(test-eq (void) (subs64vector-move! v9 0 2 v6 1))
(test-equal '#s64(9223372036854775807 9223372036854775807 99) v6)

(test-eq (void) (s64vector-copy! v6 0 '#s64(11 22 33)))
(test-equal '#s64(11 22 33) v6)

(test-eq (void) (s64vector-copy! v6 2 '#s64(33 44) 1))
(test-equal '#s64(11 22 44) v6)

(test-eq (void) (s64vector-copy! v6 1 '#s64(55 66 77 88) 0 2))
(test-equal '#s64(11 55 66) v6)

(test-error-tail type-exception? (s64vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (s64vector 11 -9223372036854775809 22))
;; homovect only
(test-error-tail type-exception? (s64vector 11 9223372036854775808 22))
;; homovect only

(test-error-tail type-exception? (make-s64vector bool))
(test-error-tail type-exception? (make-s64vector bool 11))
(test-error-tail type-exception? (make-s64vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-s64vector 11 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (make-s64vector 11 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (make-s64vector -1 0))

(test-error-tail type-exception? (s64vector-length bool))

(test-error-tail type-exception? (s64vector->list bool))

(test-error-tail type-exception? (list->s64vector bool))

(test-error-tail type-exception? (s64vector-append bool))
(test-error-tail type-exception? (s64vector-append bool v9))
(test-error-tail type-exception? (s64vector-append v9 bool))

(test-error-tail type-exception? (s64vector-concatenate bool))
(test-error-tail type-exception? (s64vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (s64vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (s64vector-copy bool))
(test-error-tail type-exception? (s64vector-copy v9 bool))
(test-error-tail type-exception? (s64vector-copy v9 0 bool))

(test-error-tail type-exception? (subs64vector bool 0 0))
(test-error-tail type-exception? (subs64vector v9 bool 0))
(test-error-tail type-exception? (subs64vector v9 0 bool))
(test-error-tail range-exception? (subs64vector v9 -1 0))
(test-error-tail range-exception? (subs64vector v9 3 0))
(test-error-tail range-exception? (subs64vector v9 0 -1))
(test-error-tail range-exception? (subs64vector v9 0 3))

(test-error-tail type-exception? (s64vector-ref bool 0))
(test-error-tail type-exception? (s64vector-ref v5 bool))
(test-error-tail range-exception? (s64vector-ref v5 -1))
(test-error-tail range-exception? (s64vector-ref v5 2))

(test-error-tail type-exception? (s64vector-set bool 0 11))
(test-error-tail type-exception? (s64vector-set v5 bool 11))
(test-error-tail type-exception? (s64vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s64vector-set v5 0 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (s64vector-set v5 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (s64vector-set v5 -1 0))
(test-error-tail range-exception? (s64vector-set v5 2 0))

(test-error-tail type-exception? (s64vector-set! bool 0 11))
(test-error-tail type-exception? (s64vector-set! v5 bool 11))
(test-error-tail type-exception? (s64vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s64vector-set! v5 0 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (s64vector-set! v5 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (s64vector-set! v5 -1 0))
(test-error-tail range-exception? (s64vector-set! v5 2 0))

(test-error-tail type-exception? (s64vector-swap! bool 0 11))
(test-error-tail type-exception? (s64vector-swap! v5 bool 11))
(test-error-tail type-exception? (s64vector-swap! v5 0 bool))
(test-error-tail range-exception? (s64vector-swap! v5 -1 0))
(test-error-tail range-exception? (s64vector-swap! v5 10 0))

(test-error-tail type-exception? (s64vector-shrink! bool 0))
(test-error-tail type-exception? (s64vector-shrink! v5 bool))
(test-error-tail range-exception? (s64vector-shrink! v5 3))

(test-error-tail type-exception? (s64vector-fill! bool 0))
(test-error-tail type-exception? (s64vector-fill! v5 0 bool))
(test-error-tail type-exception? (s64vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (s64vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (s64vector-fill! v5 -9223372036854775809))
;; homovect only
(test-error-tail type-exception? (s64vector-fill! v5 9223372036854775808))
;; homovect only

(test-error-tail type-exception? (subs64vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subs64vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subs64vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subs64vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail
 type-exception?
 (subs64vector-fill! v5 0 0 -9223372036854775809))
;; homovect only
(test-error-tail
 type-exception?
 (subs64vector-fill! v5 0 0 9223372036854775808))
;; homovect only
(test-error-tail range-exception? (subs64vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subs64vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subs64vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subs64vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subs64vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subs64vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subs64vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subs64vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subs64vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subs64vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subs64vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subs64vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subs64vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subs64vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subs64vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (s64vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (s64vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (s64vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (s64vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (s64vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (s64vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (s64vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (s64vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (s64vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (s64vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (s64vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s64vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (make-s64vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s64vector?))
(test-error-tail wrong-number-of-arguments-exception? (s64vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s64vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s64vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (list->s64vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-copy))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs64vector))
(test-error-tail wrong-number-of-arguments-exception? (subs64vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subs64vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subs64vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-set! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs64vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subs64vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs64vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subs64vector-move! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs64vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s64vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (s64vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s64vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-s64vector (expt 2 64)))
