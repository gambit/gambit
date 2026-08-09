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

(test-assert (eq? #f (##s16vector? str)))
(test-assert (eq? #f (##s16vector? int)))
(test-assert (eq? #f (##s16vector? bool)))

(test-assert (eq? #t (##s16vector? v1)))
(test-assert (eq? #t (##s16vector? '#s16())))
(test-assert (eq? #t (##s16vector? '#s16(11))))
(test-assert (eq? #t (##s16vector? '#s16(11 22))))
(test-assert (eq? #t (##s16vector? '#s16(11 22 33))))
(test-assert (eq? #t (##s16vector? '#s16(11 22 33 44))))
(test-assert (eq? #t (##s16vector? '#s16(11 22 33 44 55))))

(test-assert (eq? #t (##s16vector? v2)))
(test-assert (eq? #t (##s16vector? (##s16vector))))
(test-assert (eq? #t (##s16vector? (##s16vector 11))))
(test-assert (eq? #t (##s16vector? (##s16vector 11 22))))
(test-assert (eq? #t (##s16vector? (##s16vector 11 22 33))))
(test-assert (eq? #t (##s16vector? (##s16vector 11 22 33 44))))
(test-assert (eq? #t (##s16vector? (##s16vector 11 22 33 44 55))))

(test-assert (eq? #t (##s16vector? v3)))
(test-assert (eq? #t (##s16vector? (##make-s16vector 0))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 1))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 10))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 100))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 1000))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 10000))))

(test-assert (eq? #t (##s16vector? v4)))
(test-assert (eq? #t (##s16vector? v5)))
(test-assert (eq? #t (##s16vector? (##make-s16vector 0 11))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 1 22))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 10 33))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 100 44))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 1000 55))))
(test-assert (eq? #t (##s16vector? (##make-s16vector 10000 66))))

(test-eqv 2 (##s16vector-length v1))
(test-eqv 0 (##s16vector-length '#s16()))
(test-eqv 1 (##s16vector-length '#s16(11)))
(test-eqv 2 (##s16vector-length '#s16(11 22)))
(test-eqv 3 (##s16vector-length '#s16(11 22 33)))
(test-eqv 4 (##s16vector-length '#s16(11 22 33 44)))
(test-eqv 5 (##s16vector-length '#s16(11 22 33 44 55)))

(test-eqv 5 (##s16vector-length v2))
(test-eqv 0 (##s16vector-length (##s16vector)))
(test-eqv 1 (##s16vector-length (##s16vector 11)))
(test-eqv 2 (##s16vector-length (##s16vector 11 22)))
(test-eqv 3 (##s16vector-length (##s16vector 11 22 33)))
(test-eqv 4 (##s16vector-length (##s16vector 11 22 33 44)))
(test-eqv 5 (##s16vector-length (##s16vector 11 22 33 44 55)))

(test-eqv 2 (##s16vector-length v3))
(test-eqv 0 (##s16vector-length (##make-s16vector 0)))
(test-eqv 1 (##s16vector-length (##make-s16vector 1)))
(test-eqv 10 (##s16vector-length (##make-s16vector 10)))
(test-eqv 100 (##s16vector-length (##make-s16vector 100)))
(test-eqv 1000 (##s16vector-length (##make-s16vector 1000)))
(test-eqv 10000 (##s16vector-length (##make-s16vector 10000)))

(test-eqv 2 (##s16vector-length v4))
(test-eqv 2 (##s16vector-length v5))
(test-eqv 0 (##s16vector-length (##make-s16vector 0 11)))
(test-eqv 1 (##s16vector-length (##make-s16vector 1 22)))
(test-eqv 10 (##s16vector-length (##make-s16vector 10 33)))
(test-eqv 100 (##s16vector-length (##make-s16vector 100 44)))
(test-eqv 1000 (##s16vector-length (##make-s16vector 1000 55)))
(test-eqv 10000 (##s16vector-length (##make-s16vector 10000 66)))

(test-eqv -32768 (##s16vector-ref v1 0))
(test-eqv 32767 (##s16vector-ref v1 1))

(test-eqv -32768 (##s16vector-ref v2 0))
(test-eqv -2 (##s16vector-ref v2 1))
(test-eqv 0 (##s16vector-ref v2 2))
(test-eqv 1 (##s16vector-ref v2 3))
(test-eqv 32767 (##s16vector-ref v2 4))

(test-eqv -32768 (##s16vector-ref v4 0))
(test-eqv -32768 (##s16vector-ref v4 1))

(test-eqv 32767 (##s16vector-ref v5 0))
(test-eqv 32767 (##s16vector-ref v5 1))

(test-equal '#s16(-32768 99 0 1 32767) (##s16vector-set v2 1 99))
(test-equal '#s16(-32768 -2 0 1 32767) v2)
(test-equal '#s16(-32768 99) (##s16vector-set v4 1 99))
(test-equal '#s16(32767 99) (##s16vector-set v5 1 99))
(test-equal '#s16(99 22 33) (##s16vector-set '#s16(11 22 33) 0 99))

(test-eq v2 (##s16vector-set! v2 1 99))
(test-eq v3 (##s16vector-set! v3 1 99))
(test-eq v4 (##s16vector-set! v4 1 99))
(test-eq v5 (##s16vector-set! v5 1 99))

(test-eqv -32768 (##s16vector-ref v2 0))
(test-eqv 99 (##s16vector-ref v2 1))
(test-eqv 0 (##s16vector-ref v2 2))
(test-eqv 1 (##s16vector-ref v2 3))
(test-eqv 32767 (##s16vector-ref v2 4))

(test-eqv v2 (##s16vector-swap! v2 0 4))

(test-eqv 32767 (##s16vector-ref v2 0))
(test-eqv 99 (##s16vector-ref v2 1))
(test-eqv 0 (##s16vector-ref v2 2))
(test-eqv 1 (##s16vector-ref v2 3))
(test-eqv -32768 (##s16vector-ref v2 4))

(test-eqv 99 (##s16vector-ref v3 1))

(test-eqv -32768 (##s16vector-ref v4 0))
(test-eqv 99 (##s16vector-ref v4 1))

(test-eqv 32767 (##s16vector-ref v5 0))
(test-eqv 99 (##s16vector-ref v5 1))

(test-eq v2 (##s16vector-shrink! v2 3))
(test-eq v3 (##s16vector-shrink! v3 1))
(test-eq v4 (##s16vector-shrink! v4 0))
(test-eq v5 (##s16vector-shrink! v5 2))

(test-eqv 3 (##s16vector-length v2))
(test-eqv 1 (##s16vector-length v3))
(test-eqv 0 (##s16vector-length v4))
(test-eqv 2 (##s16vector-length v5))

(test-assert (eq? #t (s16vector? v1)))
(test-assert (eq? #t (s16vector? '#s16())))
(test-assert (eq? #t (s16vector? '#s16(11))))
(test-assert (eq? #t (s16vector? '#s16(11 22))))
(test-assert (eq? #t (s16vector? '#s16(11 22 33))))
(test-assert (eq? #t (s16vector? '#s16(11 22 33 44))))
(test-assert (eq? #t (s16vector? '#s16(11 22 33 44 55))))

(test-assert (eq? #t (s16vector? v6)))
(test-assert (eq? #t (s16vector? (s16vector))))
(test-assert (eq? #t (s16vector? (s16vector 11))))
(test-assert (eq? #t (s16vector? (s16vector 11 22))))
(test-assert (eq? #t (s16vector? (s16vector 11 22 33))))
(test-assert (eq? #t (s16vector? (s16vector 11 22 33 44))))
(test-assert (eq? #t (s16vector? (s16vector 11 22 33 44 55))))

(test-assert (eq? #t (s16vector? v7)))
(test-assert (eq? #t (s16vector? (make-s16vector 0))))
(test-assert (eq? #t (s16vector? (make-s16vector 1))))
(test-assert (eq? #t (s16vector? (make-s16vector 10))))
(test-assert (eq? #t (s16vector? (make-s16vector 100))))
(test-assert (eq? #t (s16vector? (make-s16vector 1000))))
(test-assert (eq? #t (s16vector? (make-s16vector 10000))))

(test-assert (eq? #t (s16vector? v8)))
(test-assert (eq? #t (s16vector? v9)))
(test-assert (eq? #t (s16vector? (make-s16vector 0 11))))
(test-assert (eq? #t (s16vector? (make-s16vector 1 22))))
(test-assert (eq? #t (s16vector? (make-s16vector 10 33))))
(test-assert (eq? #t (s16vector? (make-s16vector 100 44))))
(test-assert (eq? #t (s16vector? (make-s16vector 1000 55))))
(test-assert (eq? #t (s16vector? (make-s16vector 10000 66))))

(test-eqv 2 (s16vector-length v1))
(test-eqv 0 (s16vector-length '#s16()))
(test-eqv 1 (s16vector-length '#s16(11)))
(test-eqv 2 (s16vector-length '#s16(11 22)))
(test-eqv 3 (s16vector-length '#s16(11 22 33)))
(test-eqv 4 (s16vector-length '#s16(11 22 33 44)))
(test-eqv 5 (s16vector-length '#s16(11 22 33 44 55)))

(test-eqv 5 (s16vector-length v6))
(test-eqv 0 (s16vector-length (s16vector)))
(test-eqv 1 (s16vector-length (s16vector 11)))
(test-eqv 2 (s16vector-length (s16vector 11 22)))
(test-eqv 3 (s16vector-length (s16vector 11 22 33)))
(test-eqv 4 (s16vector-length (s16vector 11 22 33 44)))
(test-eqv 5 (s16vector-length (s16vector 11 22 33 44 55)))

(test-eqv 2 (s16vector-length v7))
(test-eqv 0 (s16vector-length (make-s16vector 0)))
(test-eqv 1 (s16vector-length (make-s16vector 1)))
(test-eqv 10 (s16vector-length (make-s16vector 10)))
(test-eqv 100 (s16vector-length (make-s16vector 100)))
(test-eqv 1000 (s16vector-length (make-s16vector 1000)))
(test-eqv 10000 (s16vector-length (make-s16vector 10000)))

(test-eqv 2 (s16vector-length v8))
(test-eqv 2 (s16vector-length v9))
(test-eqv 0 (s16vector-length (make-s16vector 0 11)))
(test-eqv 1 (s16vector-length (make-s16vector 1 22)))
(test-eqv 10 (s16vector-length (make-s16vector 10 33)))
(test-eqv 100 (s16vector-length (make-s16vector 100 44)))
(test-eqv 1000 (s16vector-length (make-s16vector 1000 55)))
(test-eqv 10000 (s16vector-length (make-s16vector 10000 66)))

(test-equal '() (s16vector->list '#s16()))
(test-equal '(-32768 -2 0 1 32767) (s16vector->list v6))
(test-equal '(-32768 -2 0 1 32767) (s16vector->list v6 0))
(test-equal '(0 1 32767) (s16vector->list v6 2))
(test-equal '(0 1) (s16vector->list v6 2 4))
(test-equal '(-32768 -2 0 1 32767) (s16vector->list v6 0 5))
(test-equal '(0 0) (s16vector->list v7))

(test-equal '#s16() (list->s16vector '()))
(test-equal v6 (list->s16vector '(-32768 -2 0 1 32767)))
(test-equal v7 (list->s16vector '(0 0)))

(test-equal '#s16() (s16vector-append))
(test-equal v6 (s16vector-append v6))
(test-equal v6 (s16vector-append '#s16(-32768 -2) '#s16(0 1 32767)))
(test-equal
 '#s16(-32768 -2 0 1 32767 0 0 -32768 -2 0 1 32767)
 (s16vector-append v6 v7 v6))

(test-equal
 '#s16(-32768 -2 0 1 32767 0 0 -32768 -2 0 1 32767)
 (s16vector-concatenate (list v6 v7 v6)))
(test-equal
 '#s16(-32768 -2 0 1 32767 1 1 1 0 0 1 1 1 -32768 -2 0 1 32767)
 (s16vector-concatenate (list v6 v7 v6) '#s16(1 1 1)))

(test-equal '#s16() (s16vector-copy '#s16()))
(test-equal v6 (s16vector-copy v6))
(test-equal v6 (s16vector-copy v6 0))
(test-equal '#s16(0 1 32767) (s16vector-copy v6 2))
(test-equal '#s16() (s16vector-copy v6 0 0))
(test-equal '#s16() (s16vector-copy v6 4 4))
(test-equal '#s16(-32768 -2) (s16vector-copy v6 0 2))
(test-equal '#s16(0 1) (s16vector-copy v6 2 4))
(test-equal '#s16(32767) (s16vector-copy v6 4 5))
(test-equal v6 (s16vector-copy v6 0 5))

(test-equal '#s16() (subs16vector v6 0 0))
(test-equal '#s16() (subs16vector v6 4 4))
(test-equal '#s16(-32768 -2) (subs16vector v6 0 2))
(test-equal '#s16(0 1) (subs16vector v6 2 4))
(test-equal '#s16(32767) (subs16vector v6 4 5))
(test-equal v6 (subs16vector v6 0 5))

(test-eqv -32768 (s16vector-ref v1 0))
(test-eqv 32767 (s16vector-ref v1 1))

(test-eqv -32768 (s16vector-ref v6 0))
(test-eqv -2 (s16vector-ref v6 1))
(test-eqv 0 (s16vector-ref v6 2))
(test-eqv 1 (s16vector-ref v6 3))
(test-eqv 32767 (s16vector-ref v6 4))

(test-eqv 0 (s16vector-ref v7 0))
(test-eqv 0 (s16vector-ref v7 1))

(test-eqv -32768 (s16vector-ref v8 0))
(test-eqv -32768 (s16vector-ref v8 1))

(test-eqv 32767 (s16vector-ref v9 0))
(test-eqv 32767 (s16vector-ref v9 1))

(test-equal '#s16(-32768 99 0 1 32767) (s16vector-set v6 1 99))
(test-equal '#s16(-32768 -2 0 1 32767) v6)
(test-equal '#s16(-32768 99) (s16vector-set v8 1 99))
(test-equal '#s16(32767 99) (s16vector-set v9 1 99))
(test-equal '#s16(99 22 33) (s16vector-set '#s16(11 22 33) 0 99))

(test-eq (void) (s16vector-set! v6 1 99))
(test-eq (void) (s16vector-set! v7 1 99))
(test-eq (void) (s16vector-set! v8 1 99))
(test-eq (void) (s16vector-set! v9 1 99))

(test-eqv -32768 (s16vector-ref v6 0))
(test-eqv 99 (s16vector-ref v6 1))
(test-eqv 0 (s16vector-ref v6 2))
(test-eqv 1 (s16vector-ref v6 3))
(test-eqv 32767 (s16vector-ref v6 4))

(test-eq (void) (s16vector-swap! v6 0 4))

(test-eqv 32767 (s16vector-ref v6 0))
(test-eqv 99 (s16vector-ref v6 1))
(test-eqv 0 (s16vector-ref v6 2))
(test-eqv 1 (s16vector-ref v6 3))
(test-eqv -32768 (s16vector-ref v6 4))

(test-eqv 0 (s16vector-ref v7 0))
(test-eqv 99 (s16vector-ref v7 1))

(test-eqv -32768 (s16vector-ref v8 0))
(test-eqv 99 (s16vector-ref v8 1))

(test-eqv 32767 (s16vector-ref v9 0))
(test-eqv 99 (s16vector-ref v9 1))

(test-eq (void) (s16vector-shrink! v6 3))
(test-eq (void) (s16vector-shrink! v7 1))
(test-eq (void) (s16vector-shrink! v8 0))
(test-eq (void) (s16vector-shrink! v9 2))

(test-eqv 3 (s16vector-length v6))
(test-eqv 1 (s16vector-length v7))
(test-eqv 0 (s16vector-length v8))
(test-eqv 2 (s16vector-length v9))

(test-eq (void) (s16vector-fill! v6 -32768))
(test-equal '#s16(-32768 -32768 -32768) v6)

(test-eq (void) (s16vector-fill! v6 32767))
(test-equal '#s16(32767 32767 32767) v6)

(test-eq (void) (s16vector-fill! v6 3 1))
(test-equal '#s16(32767 3 3) v6)

(test-eq (void) (s16vector-fill! v6 99 0 2))
(test-equal '#s16(99 99 3) v6)

(test-eq (void) (subs16vector-fill! v6 0 3 9))
(test-equal '#s16(9 9 9) v6)

(test-eq (void) (subs16vector-fill! v6 1 2 -32768))
(test-equal '#s16(9 -32768 9) v6)

(test-eq (void) (subs16vector-fill! v6 1 3 32767))
(test-equal '#s16(9 32767 32767) v6)

(test-eq (void) (subs16vector-move! v9 0 2 v6 0))
(test-equal '#s16(32767 99 32767) v6)

(test-eq (void) (subs16vector-move! v9 0 2 v6 1))
(test-equal '#s16(32767 32767 99) v6)

(test-eq (void) (s16vector-copy! v6 0 '#s16(11 22 33)))
(test-equal '#s16(11 22 33) v6)

(test-eq (void) (s16vector-copy! v6 2 '#s16(33 44) 1))
(test-equal '#s16(11 22 44) v6)

(test-eq (void) (s16vector-copy! v6 1 '#s16(55 66 77 88) 0 2))
(test-equal '#s16(11 55 66) v6)

(test-error-tail type-exception? (s16vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (s16vector 11 -32769 22))
;; homovect only
(test-error-tail type-exception? (s16vector 11 32768 22))
;; homovect only

(test-error-tail type-exception? (make-s16vector bool))
(test-error-tail type-exception? (make-s16vector bool 11))
(test-error-tail type-exception? (make-s16vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-s16vector 11 -32769))
;; homovect only
(test-error-tail type-exception? (make-s16vector 11 32768))
;; homovect only
(test-error-tail range-exception? (make-s16vector -1 0))

(test-error-tail type-exception? (s16vector-length bool))

(test-error-tail type-exception? (s16vector->list bool))

(test-error-tail type-exception? (list->s16vector bool))

(test-error-tail type-exception? (s16vector-append bool))
(test-error-tail type-exception? (s16vector-append bool v9))
(test-error-tail type-exception? (s16vector-append v9 bool))

(test-error-tail type-exception? (s16vector-concatenate bool))
(test-error-tail type-exception? (s16vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (s16vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (s16vector-copy bool))
(test-error-tail type-exception? (s16vector-copy v9 bool))
(test-error-tail type-exception? (s16vector-copy v9 0 bool))

(test-error-tail type-exception? (subs16vector bool 0 0))
(test-error-tail type-exception? (subs16vector v9 bool 0))
(test-error-tail type-exception? (subs16vector v9 0 bool))
(test-error-tail range-exception? (subs16vector v9 -1 0))
(test-error-tail range-exception? (subs16vector v9 3 0))
(test-error-tail range-exception? (subs16vector v9 0 -1))
(test-error-tail range-exception? (subs16vector v9 0 3))

(test-error-tail type-exception? (s16vector-ref bool 0))
(test-error-tail type-exception? (s16vector-ref v5 bool))
(test-error-tail range-exception? (s16vector-ref v5 -1))
(test-error-tail range-exception? (s16vector-ref v5 2))

(test-error-tail type-exception? (s16vector-set bool 0 11))
(test-error-tail type-exception? (s16vector-set v5 bool 11))
(test-error-tail type-exception? (s16vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s16vector-set v5 0 -32769))
;; homovect only
(test-error-tail type-exception? (s16vector-set v5 0 32768))
;; homovect only
(test-error-tail range-exception? (s16vector-set v5 -1 0))
(test-error-tail range-exception? (s16vector-set v5 2 0))

(test-error-tail type-exception? (s16vector-set! bool 0 11))
(test-error-tail type-exception? (s16vector-set! v5 bool 11))
(test-error-tail type-exception? (s16vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s16vector-set! v5 0 -32769))
;; homovect only
(test-error-tail type-exception? (s16vector-set! v5 0 32768))
;; homovect only
(test-error-tail range-exception? (s16vector-set! v5 -1 0))
(test-error-tail range-exception? (s16vector-set! v5 2 0))

(test-error-tail type-exception? (s16vector-swap! bool 0 11))
(test-error-tail type-exception? (s16vector-swap! v5 bool 11))
(test-error-tail type-exception? (s16vector-swap! v5 0 bool))
(test-error-tail range-exception? (s16vector-swap! v5 -1 0))
(test-error-tail range-exception? (s16vector-swap! v5 10 0))

(test-error-tail type-exception? (s16vector-shrink! bool 0))
(test-error-tail type-exception? (s16vector-shrink! v5 bool))
(test-error-tail range-exception? (s16vector-shrink! v5 3))

(test-error-tail type-exception? (s16vector-fill! bool 0))
(test-error-tail type-exception? (s16vector-fill! v5 0 bool))
(test-error-tail type-exception? (s16vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (s16vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (s16vector-fill! v5 -32769))
;; homovect only
(test-error-tail type-exception? (s16vector-fill! v5 32768))
;; homovect only

(test-error-tail type-exception? (subs16vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subs16vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subs16vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subs16vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail type-exception? (subs16vector-fill! v5 0 0 -32769))
;; homovect only
(test-error-tail type-exception? (subs16vector-fill! v5 0 0 32768))
;; homovect only
(test-error-tail range-exception? (subs16vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subs16vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subs16vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subs16vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subs16vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subs16vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subs16vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subs16vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subs16vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subs16vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subs16vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subs16vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subs16vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subs16vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subs16vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (s16vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (s16vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (s16vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (s16vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (s16vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (s16vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (s16vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (s16vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (s16vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (s16vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (s16vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s16vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (make-s16vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s16vector?))
(test-error-tail wrong-number-of-arguments-exception? (s16vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s16vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s16vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (list->s16vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-copy))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs16vector))
(test-error-tail wrong-number-of-arguments-exception? (subs16vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subs16vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subs16vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-set! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs16vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subs16vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs16vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subs16vector-move! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs16vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s16vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (s16vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s16vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-s16vector (expt 2 64)))
