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

(test-assert (eq? #f (##s8vector? str)))
(test-assert (eq? #f (##s8vector? int)))
(test-assert (eq? #f (##s8vector? bool)))

(test-assert (eq? #t (##s8vector? v1)))
(test-assert (eq? #t (##s8vector? '#s8())))
(test-assert (eq? #t (##s8vector? '#s8(11))))
(test-assert (eq? #t (##s8vector? '#s8(11 22))))
(test-assert (eq? #t (##s8vector? '#s8(11 22 33))))
(test-assert (eq? #t (##s8vector? '#s8(11 22 33 44))))
(test-assert (eq? #t (##s8vector? '#s8(11 22 33 44 55))))

(test-assert (eq? #t (##s8vector? v2)))
(test-assert (eq? #t (##s8vector? (##s8vector))))
(test-assert (eq? #t (##s8vector? (##s8vector 11))))
(test-assert (eq? #t (##s8vector? (##s8vector 11 22))))
(test-assert (eq? #t (##s8vector? (##s8vector 11 22 33))))
(test-assert (eq? #t (##s8vector? (##s8vector 11 22 33 44))))
(test-assert (eq? #t (##s8vector? (##s8vector 11 22 33 44 55))))

(test-assert (eq? #t (##s8vector? v3)))
(test-assert (eq? #t (##s8vector? (##make-s8vector 0))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 1))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 10))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 100))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 1000))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 10000))))

(test-assert (eq? #t (##s8vector? v4)))
(test-assert (eq? #t (##s8vector? v5)))
(test-assert (eq? #t (##s8vector? (##make-s8vector 0 11))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 1 22))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 10 33))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 100 44))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 1000 55))))
(test-assert (eq? #t (##s8vector? (##make-s8vector 10000 66))))

(test-eqv 2 (##s8vector-length v1))
(test-eqv 0 (##s8vector-length '#s8()))
(test-eqv 1 (##s8vector-length '#s8(11)))
(test-eqv 2 (##s8vector-length '#s8(11 22)))
(test-eqv 3 (##s8vector-length '#s8(11 22 33)))
(test-eqv 4 (##s8vector-length '#s8(11 22 33 44)))
(test-eqv 5 (##s8vector-length '#s8(11 22 33 44 55)))

(test-eqv 5 (##s8vector-length v2))
(test-eqv 0 (##s8vector-length (##s8vector)))
(test-eqv 1 (##s8vector-length (##s8vector 11)))
(test-eqv 2 (##s8vector-length (##s8vector 11 22)))
(test-eqv 3 (##s8vector-length (##s8vector 11 22 33)))
(test-eqv 4 (##s8vector-length (##s8vector 11 22 33 44)))
(test-eqv 5 (##s8vector-length (##s8vector 11 22 33 44 55)))

(test-eqv 2 (##s8vector-length v3))
(test-eqv 0 (##s8vector-length (##make-s8vector 0)))
(test-eqv 1 (##s8vector-length (##make-s8vector 1)))
(test-eqv 10 (##s8vector-length (##make-s8vector 10)))
(test-eqv 100 (##s8vector-length (##make-s8vector 100)))
(test-eqv 1000 (##s8vector-length (##make-s8vector 1000)))
(test-eqv 10000 (##s8vector-length (##make-s8vector 10000)))

(test-eqv 2 (##s8vector-length v4))
(test-eqv 2 (##s8vector-length v5))
(test-eqv 0 (##s8vector-length (##make-s8vector 0 11)))
(test-eqv 1 (##s8vector-length (##make-s8vector 1 22)))
(test-eqv 10 (##s8vector-length (##make-s8vector 10 33)))
(test-eqv 100 (##s8vector-length (##make-s8vector 100 44)))
(test-eqv 1000 (##s8vector-length (##make-s8vector 1000 55)))
(test-eqv 10000 (##s8vector-length (##make-s8vector 10000 66)))

(test-eqv -128 (##s8vector-ref v1 0))
(test-eqv 127 (##s8vector-ref v1 1))

(test-eqv -128 (##s8vector-ref v2 0))
(test-eqv -2 (##s8vector-ref v2 1))
(test-eqv 0 (##s8vector-ref v2 2))
(test-eqv 1 (##s8vector-ref v2 3))
(test-eqv 127 (##s8vector-ref v2 4))

(test-eqv -128 (##s8vector-ref v4 0))
(test-eqv -128 (##s8vector-ref v4 1))

(test-eqv 127 (##s8vector-ref v5 0))
(test-eqv 127 (##s8vector-ref v5 1))

(test-equal '#s8(-128 99 0 1 127) (##s8vector-set v2 1 99))
(test-equal '#s8(-128 -2 0 1 127) v2)
(test-equal '#s8(-128 99) (##s8vector-set v4 1 99))
(test-equal '#s8(127 99) (##s8vector-set v5 1 99))
(test-equal '#s8(99 22 33) (##s8vector-set '#s8(11 22 33) 0 99))

(test-eq v2 (##s8vector-set! v2 1 99))
(test-eq v3 (##s8vector-set! v3 1 99))
(test-eq v4 (##s8vector-set! v4 1 99))
(test-eq v5 (##s8vector-set! v5 1 99))

(test-eqv -128 (##s8vector-ref v2 0))
(test-eqv 99 (##s8vector-ref v2 1))
(test-eqv 0 (##s8vector-ref v2 2))
(test-eqv 1 (##s8vector-ref v2 3))
(test-eqv 127 (##s8vector-ref v2 4))

(test-eqv v2 (##s8vector-swap! v2 0 4))

(test-eqv 127 (##s8vector-ref v2 0))
(test-eqv 99 (##s8vector-ref v2 1))
(test-eqv 0 (##s8vector-ref v2 2))
(test-eqv 1 (##s8vector-ref v2 3))
(test-eqv -128 (##s8vector-ref v2 4))

(test-eqv 99 (##s8vector-ref v3 1))

(test-eqv -128 (##s8vector-ref v4 0))
(test-eqv 99 (##s8vector-ref v4 1))

(test-eqv 127 (##s8vector-ref v5 0))
(test-eqv 99 (##s8vector-ref v5 1))

(test-eq v2 (##s8vector-shrink! v2 3))
(test-eq v3 (##s8vector-shrink! v3 1))
(test-eq v4 (##s8vector-shrink! v4 0))
(test-eq v5 (##s8vector-shrink! v5 2))

(test-eqv 3 (##s8vector-length v2))
(test-eqv 1 (##s8vector-length v3))
(test-eqv 0 (##s8vector-length v4))
(test-eqv 2 (##s8vector-length v5))

(test-assert (eq? #t (s8vector? v1)))
(test-assert (eq? #t (s8vector? '#s8())))
(test-assert (eq? #t (s8vector? '#s8(11))))
(test-assert (eq? #t (s8vector? '#s8(11 22))))
(test-assert (eq? #t (s8vector? '#s8(11 22 33))))
(test-assert (eq? #t (s8vector? '#s8(11 22 33 44))))
(test-assert (eq? #t (s8vector? '#s8(11 22 33 44 55))))

(test-assert (eq? #t (s8vector? v6)))
(test-assert (eq? #t (s8vector? (s8vector))))
(test-assert (eq? #t (s8vector? (s8vector 11))))
(test-assert (eq? #t (s8vector? (s8vector 11 22))))
(test-assert (eq? #t (s8vector? (s8vector 11 22 33))))
(test-assert (eq? #t (s8vector? (s8vector 11 22 33 44))))
(test-assert (eq? #t (s8vector? (s8vector 11 22 33 44 55))))

(test-assert (eq? #t (s8vector? v7)))
(test-assert (eq? #t (s8vector? (make-s8vector 0))))
(test-assert (eq? #t (s8vector? (make-s8vector 1))))
(test-assert (eq? #t (s8vector? (make-s8vector 10))))
(test-assert (eq? #t (s8vector? (make-s8vector 100))))
(test-assert (eq? #t (s8vector? (make-s8vector 1000))))
(test-assert (eq? #t (s8vector? (make-s8vector 10000))))

(test-assert (eq? #t (s8vector? v8)))
(test-assert (eq? #t (s8vector? v9)))
(test-assert (eq? #t (s8vector? (make-s8vector 0 11))))
(test-assert (eq? #t (s8vector? (make-s8vector 1 22))))
(test-assert (eq? #t (s8vector? (make-s8vector 10 33))))
(test-assert (eq? #t (s8vector? (make-s8vector 100 44))))
(test-assert (eq? #t (s8vector? (make-s8vector 1000 55))))
(test-assert (eq? #t (s8vector? (make-s8vector 10000 66))))

(test-eqv 2 (s8vector-length v1))
(test-eqv 0 (s8vector-length '#s8()))
(test-eqv 1 (s8vector-length '#s8(11)))
(test-eqv 2 (s8vector-length '#s8(11 22)))
(test-eqv 3 (s8vector-length '#s8(11 22 33)))
(test-eqv 4 (s8vector-length '#s8(11 22 33 44)))
(test-eqv 5 (s8vector-length '#s8(11 22 33 44 55)))

(test-eqv 5 (s8vector-length v6))
(test-eqv 0 (s8vector-length (s8vector)))
(test-eqv 1 (s8vector-length (s8vector 11)))
(test-eqv 2 (s8vector-length (s8vector 11 22)))
(test-eqv 3 (s8vector-length (s8vector 11 22 33)))
(test-eqv 4 (s8vector-length (s8vector 11 22 33 44)))
(test-eqv 5 (s8vector-length (s8vector 11 22 33 44 55)))

(test-eqv 2 (s8vector-length v7))
(test-eqv 0 (s8vector-length (make-s8vector 0)))
(test-eqv 1 (s8vector-length (make-s8vector 1)))
(test-eqv 10 (s8vector-length (make-s8vector 10)))
(test-eqv 100 (s8vector-length (make-s8vector 100)))
(test-eqv 1000 (s8vector-length (make-s8vector 1000)))
(test-eqv 10000 (s8vector-length (make-s8vector 10000)))

(test-eqv 2 (s8vector-length v8))
(test-eqv 2 (s8vector-length v9))
(test-eqv 0 (s8vector-length (make-s8vector 0 11)))
(test-eqv 1 (s8vector-length (make-s8vector 1 22)))
(test-eqv 10 (s8vector-length (make-s8vector 10 33)))
(test-eqv 100 (s8vector-length (make-s8vector 100 44)))
(test-eqv 1000 (s8vector-length (make-s8vector 1000 55)))
(test-eqv 10000 (s8vector-length (make-s8vector 10000 66)))

(test-equal '() (s8vector->list '#s8()))
(test-equal '(-128 -2 0 1 127) (s8vector->list v6))
(test-equal '(-128 -2 0 1 127) (s8vector->list v6 0))
(test-equal '(0 1 127) (s8vector->list v6 2))
(test-equal '(0 1) (s8vector->list v6 2 4))
(test-equal '(-128 -2 0 1 127) (s8vector->list v6 0 5))
(test-equal '(0 0) (s8vector->list v7))

(test-equal '#s8() (list->s8vector '()))
(test-equal v6 (list->s8vector '(-128 -2 0 1 127)))
(test-equal v7 (list->s8vector '(0 0)))

(test-equal '#s8() (s8vector-append))
(test-equal v6 (s8vector-append v6))
(test-equal v6 (s8vector-append '#s8(-128 -2) '#s8(0 1 127)))
(test-equal
 '#s8(-128 -2 0 1 127 0 0 -128 -2 0 1 127)
 (s8vector-append v6 v7 v6))

(test-equal
 '#s8(-128 -2 0 1 127 0 0 -128 -2 0 1 127)
 (s8vector-concatenate (list v6 v7 v6)))
(test-equal
 '#s8(-128 -2 0 1 127 1 1 1 0 0 1 1 1 -128 -2 0 1 127)
 (s8vector-concatenate (list v6 v7 v6) '#s8(1 1 1)))

(test-equal '#s8() (s8vector-copy '#s8()))
(test-equal v6 (s8vector-copy v6))
(test-equal v6 (s8vector-copy v6 0))
(test-equal '#s8(0 1 127) (s8vector-copy v6 2))
(test-equal '#s8() (s8vector-copy v6 0 0))
(test-equal '#s8() (s8vector-copy v6 4 4))
(test-equal '#s8(-128 -2) (s8vector-copy v6 0 2))
(test-equal '#s8(0 1) (s8vector-copy v6 2 4))
(test-equal '#s8(127) (s8vector-copy v6 4 5))
(test-equal v6 (s8vector-copy v6 0 5))

(test-equal '#s8() (subs8vector v6 0 0))
(test-equal '#s8() (subs8vector v6 4 4))
(test-equal '#s8(-128 -2) (subs8vector v6 0 2))
(test-equal '#s8(0 1) (subs8vector v6 2 4))
(test-equal '#s8(127) (subs8vector v6 4 5))
(test-equal v6 (subs8vector v6 0 5))

(test-eqv -128 (s8vector-ref v1 0))
(test-eqv 127 (s8vector-ref v1 1))

(test-eqv -128 (s8vector-ref v6 0))
(test-eqv -2 (s8vector-ref v6 1))
(test-eqv 0 (s8vector-ref v6 2))
(test-eqv 1 (s8vector-ref v6 3))
(test-eqv 127 (s8vector-ref v6 4))

(test-eqv 0 (s8vector-ref v7 0))
(test-eqv 0 (s8vector-ref v7 1))

(test-eqv -128 (s8vector-ref v8 0))
(test-eqv -128 (s8vector-ref v8 1))

(test-eqv 127 (s8vector-ref v9 0))
(test-eqv 127 (s8vector-ref v9 1))

(test-equal '#s8(-128 99 0 1 127) (s8vector-set v6 1 99))
(test-equal '#s8(-128 -2 0 1 127) v6)
(test-equal '#s8(-128 99) (s8vector-set v8 1 99))
(test-equal '#s8(127 99) (s8vector-set v9 1 99))
(test-equal '#s8(99 22 33) (s8vector-set '#s8(11 22 33) 0 99))

(test-eq (void) (s8vector-set! v6 1 99))
(test-eq (void) (s8vector-set! v7 1 99))
(test-eq (void) (s8vector-set! v8 1 99))
(test-eq (void) (s8vector-set! v9 1 99))

(test-eqv -128 (s8vector-ref v6 0))
(test-eqv 99 (s8vector-ref v6 1))
(test-eqv 0 (s8vector-ref v6 2))
(test-eqv 1 (s8vector-ref v6 3))
(test-eqv 127 (s8vector-ref v6 4))

(test-eq (void) (s8vector-swap! v6 0 4))

(test-eqv 127 (s8vector-ref v6 0))
(test-eqv 99 (s8vector-ref v6 1))
(test-eqv 0 (s8vector-ref v6 2))
(test-eqv 1 (s8vector-ref v6 3))
(test-eqv -128 (s8vector-ref v6 4))

(test-eqv 0 (s8vector-ref v7 0))
(test-eqv 99 (s8vector-ref v7 1))

(test-eqv -128 (s8vector-ref v8 0))
(test-eqv 99 (s8vector-ref v8 1))

(test-eqv 127 (s8vector-ref v9 0))
(test-eqv 99 (s8vector-ref v9 1))

(test-eq (void) (s8vector-shrink! v6 3))
(test-eq (void) (s8vector-shrink! v7 1))
(test-eq (void) (s8vector-shrink! v8 0))
(test-eq (void) (s8vector-shrink! v9 2))

(test-eqv 3 (s8vector-length v6))
(test-eqv 1 (s8vector-length v7))
(test-eqv 0 (s8vector-length v8))
(test-eqv 2 (s8vector-length v9))

(test-eq (void) (s8vector-fill! v6 -128))
(test-equal '#s8(-128 -128 -128) v6)

(test-eq (void) (s8vector-fill! v6 127))
(test-equal '#s8(127 127 127) v6)

(test-eq (void) (s8vector-fill! v6 3 1))
(test-equal '#s8(127 3 3) v6)

(test-eq (void) (s8vector-fill! v6 99 0 2))
(test-equal '#s8(99 99 3) v6)

(test-eq (void) (subs8vector-fill! v6 0 3 9))
(test-equal '#s8(9 9 9) v6)

(test-eq (void) (subs8vector-fill! v6 1 2 -128))
(test-equal '#s8(9 -128 9) v6)

(test-eq (void) (subs8vector-fill! v6 1 3 127))
(test-equal '#s8(9 127 127) v6)

(test-eq (void) (subs8vector-move! v9 0 2 v6 0))
(test-equal '#s8(127 99 127) v6)

(test-eq (void) (subs8vector-move! v9 0 2 v6 1))
(test-equal '#s8(127 127 99) v6)

(test-eq (void) (s8vector-copy! v6 0 '#s8(11 22 33)))
(test-equal '#s8(11 22 33) v6)

(test-eq (void) (s8vector-copy! v6 2 '#s8(33 44) 1))
(test-equal '#s8(11 22 44) v6)

(test-eq (void) (s8vector-copy! v6 1 '#s8(55 66 77 88) 0 2))
(test-equal '#s8(11 55 66) v6)

(test-error-tail type-exception? (s8vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (s8vector 11 -129 22))
;; homovect only
(test-error-tail type-exception? (s8vector 11 128 22))
;; homovect only

(test-error-tail type-exception? (make-s8vector bool))
(test-error-tail type-exception? (make-s8vector bool 11))
(test-error-tail type-exception? (make-s8vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-s8vector 11 -129))
;; homovect only
(test-error-tail type-exception? (make-s8vector 11 128))
;; homovect only
(test-error-tail range-exception? (make-s8vector -1 0))

(test-error-tail type-exception? (s8vector-length bool))

(test-error-tail type-exception? (s8vector->list bool))

(test-error-tail type-exception? (list->s8vector bool))

(test-error-tail type-exception? (s8vector-append bool))
(test-error-tail type-exception? (s8vector-append bool v9))
(test-error-tail type-exception? (s8vector-append v9 bool))

(test-error-tail type-exception? (s8vector-concatenate bool))
(test-error-tail type-exception? (s8vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (s8vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (s8vector-copy bool))
(test-error-tail type-exception? (s8vector-copy v9 bool))
(test-error-tail type-exception? (s8vector-copy v9 0 bool))

(test-error-tail type-exception? (subs8vector bool 0 0))
(test-error-tail type-exception? (subs8vector v9 bool 0))
(test-error-tail type-exception? (subs8vector v9 0 bool))
(test-error-tail range-exception? (subs8vector v9 -1 0))
(test-error-tail range-exception? (subs8vector v9 3 0))
(test-error-tail range-exception? (subs8vector v9 0 -1))
(test-error-tail range-exception? (subs8vector v9 0 3))

(test-error-tail type-exception? (s8vector-ref bool 0))
(test-error-tail type-exception? (s8vector-ref v5 bool))
(test-error-tail range-exception? (s8vector-ref v5 -1))
(test-error-tail range-exception? (s8vector-ref v5 2))

(test-error-tail type-exception? (s8vector-set bool 0 11))
(test-error-tail type-exception? (s8vector-set v5 bool 11))
(test-error-tail type-exception? (s8vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s8vector-set v5 0 -129))
;; homovect only
(test-error-tail type-exception? (s8vector-set v5 0 128))
;; homovect only
(test-error-tail range-exception? (s8vector-set v5 -1 0))
(test-error-tail range-exception? (s8vector-set v5 2 0))

(test-error-tail type-exception? (s8vector-set! bool 0 11))
(test-error-tail type-exception? (s8vector-set! v5 bool 11))
(test-error-tail type-exception? (s8vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (s8vector-set! v5 0 -129))
;; homovect only
(test-error-tail type-exception? (s8vector-set! v5 0 128))
;; homovect only
(test-error-tail range-exception? (s8vector-set! v5 -1 0))
(test-error-tail range-exception? (s8vector-set! v5 2 0))

(test-error-tail type-exception? (s8vector-swap! bool 0 11))
(test-error-tail type-exception? (s8vector-swap! v5 bool 11))
(test-error-tail type-exception? (s8vector-swap! v5 0 bool))
(test-error-tail range-exception? (s8vector-swap! v5 -1 0))
(test-error-tail range-exception? (s8vector-swap! v5 10 0))

(test-error-tail type-exception? (s8vector-shrink! bool 0))
(test-error-tail type-exception? (s8vector-shrink! v5 bool))
(test-error-tail range-exception? (s8vector-shrink! v5 3))

(test-error-tail type-exception? (s8vector-fill! bool 0))
(test-error-tail type-exception? (s8vector-fill! v5 0 bool))
(test-error-tail type-exception? (s8vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (s8vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (s8vector-fill! v5 -129))
;; homovect only
(test-error-tail type-exception? (s8vector-fill! v5 128))
;; homovect only

(test-error-tail type-exception? (subs8vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subs8vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subs8vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subs8vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail type-exception? (subs8vector-fill! v5 0 0 -129))
;; homovect only
(test-error-tail type-exception? (subs8vector-fill! v5 0 0 128))
;; homovect only
(test-error-tail range-exception? (subs8vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subs8vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subs8vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subs8vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subs8vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subs8vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subs8vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subs8vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subs8vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subs8vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subs8vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subs8vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subs8vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subs8vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subs8vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (s8vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (s8vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (s8vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (s8vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (s8vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (s8vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (s8vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (s8vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (s8vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (s8vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (s8vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-s8vector))
(test-error-tail wrong-number-of-arguments-exception? (make-s8vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (s8vector?))
(test-error-tail wrong-number-of-arguments-exception? (s8vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (s8vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->s8vector))
(test-error-tail wrong-number-of-arguments-exception? (list->s8vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-copy))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs8vector))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs8vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector-fill! v9))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs8vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs8vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subs8vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector-move! v9))
(test-error-tail wrong-number-of-arguments-exception? (subs8vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs8vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs8vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subs8vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (s8vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (s8vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (s8vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-s8vector (expt 2 64)))
