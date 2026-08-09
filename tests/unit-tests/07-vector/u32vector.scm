(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u32(0 4294967295))

(define v2 (##u32vector 0 4294967295 0 1 4294967295))
(define v3 (##make-u32vector 2))
(define v4 (##make-u32vector 2 0))
(define v5 (##make-u32vector 2 4294967295))

(define v6 (u32vector 0 4294967295 0 1 4294967295))
(define v7 (make-u32vector 2))
(define v8 (make-u32vector 2 0))
(define v9 (make-u32vector 2 4294967295))

(test-assert (eq? #f (##u32vector? str)))
(test-assert (eq? #f (##u32vector? int)))
(test-assert (eq? #f (##u32vector? bool)))

(test-assert (eq? #t (##u32vector? v1)))
(test-assert (eq? #t (##u32vector? '#u32())))
(test-assert (eq? #t (##u32vector? '#u32(11))))
(test-assert (eq? #t (##u32vector? '#u32(11 22))))
(test-assert (eq? #t (##u32vector? '#u32(11 22 33))))
(test-assert (eq? #t (##u32vector? '#u32(11 22 33 44))))
(test-assert (eq? #t (##u32vector? '#u32(11 22 33 44 55))))

(test-assert (eq? #t (##u32vector? v2)))
(test-assert (eq? #t (##u32vector? (##u32vector))))
(test-assert (eq? #t (##u32vector? (##u32vector 11))))
(test-assert (eq? #t (##u32vector? (##u32vector 11 22))))
(test-assert (eq? #t (##u32vector? (##u32vector 11 22 33))))
(test-assert (eq? #t (##u32vector? (##u32vector 11 22 33 44))))
(test-assert (eq? #t (##u32vector? (##u32vector 11 22 33 44 55))))

(test-assert (eq? #t (##u32vector? v3)))
(test-assert (eq? #t (##u32vector? (##make-u32vector 0))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 1))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 10))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 100))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 1000))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 10000))))

(test-assert (eq? #t (##u32vector? v4)))
(test-assert (eq? #t (##u32vector? v5)))
(test-assert (eq? #t (##u32vector? (##make-u32vector 0 11))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 1 22))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 10 33))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 100 44))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 1000 55))))
(test-assert (eq? #t (##u32vector? (##make-u32vector 10000 66))))

(test-eqv 2 (##u32vector-length v1))
(test-eqv 0 (##u32vector-length '#u32()))
(test-eqv 1 (##u32vector-length '#u32(11)))
(test-eqv 2 (##u32vector-length '#u32(11 22)))
(test-eqv 3 (##u32vector-length '#u32(11 22 33)))
(test-eqv 4 (##u32vector-length '#u32(11 22 33 44)))
(test-eqv 5 (##u32vector-length '#u32(11 22 33 44 55)))

(test-eqv 5 (##u32vector-length v2))
(test-eqv 0 (##u32vector-length (##u32vector)))
(test-eqv 1 (##u32vector-length (##u32vector 11)))
(test-eqv 2 (##u32vector-length (##u32vector 11 22)))
(test-eqv 3 (##u32vector-length (##u32vector 11 22 33)))
(test-eqv 4 (##u32vector-length (##u32vector 11 22 33 44)))
(test-eqv 5 (##u32vector-length (##u32vector 11 22 33 44 55)))

(test-eqv 2 (##u32vector-length v3))
(test-eqv 0 (##u32vector-length (##make-u32vector 0)))
(test-eqv 1 (##u32vector-length (##make-u32vector 1)))
(test-eqv 10 (##u32vector-length (##make-u32vector 10)))
(test-eqv 100 (##u32vector-length (##make-u32vector 100)))
(test-eqv 1000 (##u32vector-length (##make-u32vector 1000)))
(test-eqv 10000 (##u32vector-length (##make-u32vector 10000)))

(test-eqv 2 (##u32vector-length v4))
(test-eqv 2 (##u32vector-length v5))
(test-eqv 0 (##u32vector-length (##make-u32vector 0 11)))
(test-eqv 1 (##u32vector-length (##make-u32vector 1 22)))
(test-eqv 10 (##u32vector-length (##make-u32vector 10 33)))
(test-eqv 100 (##u32vector-length (##make-u32vector 100 44)))
(test-eqv 1000 (##u32vector-length (##make-u32vector 1000 55)))
(test-eqv 10000 (##u32vector-length (##make-u32vector 10000 66)))

(test-eqv 0 (##u32vector-ref v1 0))
(test-eqv 4294967295 (##u32vector-ref v1 1))

(test-eqv 0 (##u32vector-ref v2 0))
(test-eqv 4294967295 (##u32vector-ref v2 1))
(test-eqv 0 (##u32vector-ref v2 2))
(test-eqv 1 (##u32vector-ref v2 3))
(test-eqv 4294967295 (##u32vector-ref v2 4))

(test-eqv 0 (##u32vector-ref v4 0))
(test-eqv 0 (##u32vector-ref v4 1))

(test-eqv 4294967295 (##u32vector-ref v5 0))
(test-eqv 4294967295 (##u32vector-ref v5 1))

(test-equal '#u32(0 99 0 1 4294967295) (##u32vector-set v2 1 99))
(test-equal '#u32(0 4294967295 0 1 4294967295) v2)
(test-equal '#u32(0 99) (##u32vector-set v4 1 99))
(test-equal '#u32(4294967295 99) (##u32vector-set v5 1 99))
(test-equal '#u32(99 22 33) (##u32vector-set '#u32(11 22 33) 0 99))

(test-eq v2 (##u32vector-set! v2 1 99))
(test-eq v3 (##u32vector-set! v3 1 99))
(test-eq v4 (##u32vector-set! v4 1 99))
(test-eq v5 (##u32vector-set! v5 1 99))

(test-eqv 0 (##u32vector-ref v2 0))
(test-eqv 99 (##u32vector-ref v2 1))
(test-eqv 0 (##u32vector-ref v2 2))
(test-eqv 1 (##u32vector-ref v2 3))
(test-eqv 4294967295 (##u32vector-ref v2 4))

(test-eqv v2 (##u32vector-swap! v2 0 4))

(test-eqv 4294967295 (##u32vector-ref v2 0))
(test-eqv 99 (##u32vector-ref v2 1))
(test-eqv 0 (##u32vector-ref v2 2))
(test-eqv 1 (##u32vector-ref v2 3))
(test-eqv 0 (##u32vector-ref v2 4))

(test-eqv 99 (##u32vector-ref v3 1))

(test-eqv 0 (##u32vector-ref v4 0))
(test-eqv 99 (##u32vector-ref v4 1))

(test-eqv 4294967295 (##u32vector-ref v5 0))
(test-eqv 99 (##u32vector-ref v5 1))

(test-eq v2 (##u32vector-shrink! v2 3))
(test-eq v3 (##u32vector-shrink! v3 1))
(test-eq v4 (##u32vector-shrink! v4 0))
(test-eq v5 (##u32vector-shrink! v5 2))

(test-eqv 3 (##u32vector-length v2))
(test-eqv 1 (##u32vector-length v3))
(test-eqv 0 (##u32vector-length v4))
(test-eqv 2 (##u32vector-length v5))

(test-assert (eq? #t (u32vector? v1)))
(test-assert (eq? #t (u32vector? '#u32())))
(test-assert (eq? #t (u32vector? '#u32(11))))
(test-assert (eq? #t (u32vector? '#u32(11 22))))
(test-assert (eq? #t (u32vector? '#u32(11 22 33))))
(test-assert (eq? #t (u32vector? '#u32(11 22 33 44))))
(test-assert (eq? #t (u32vector? '#u32(11 22 33 44 55))))

(test-assert (eq? #t (u32vector? v6)))
(test-assert (eq? #t (u32vector? (u32vector))))
(test-assert (eq? #t (u32vector? (u32vector 11))))
(test-assert (eq? #t (u32vector? (u32vector 11 22))))
(test-assert (eq? #t (u32vector? (u32vector 11 22 33))))
(test-assert (eq? #t (u32vector? (u32vector 11 22 33 44))))
(test-assert (eq? #t (u32vector? (u32vector 11 22 33 44 55))))

(test-assert (eq? #t (u32vector? v7)))
(test-assert (eq? #t (u32vector? (make-u32vector 0))))
(test-assert (eq? #t (u32vector? (make-u32vector 1))))
(test-assert (eq? #t (u32vector? (make-u32vector 10))))
(test-assert (eq? #t (u32vector? (make-u32vector 100))))
(test-assert (eq? #t (u32vector? (make-u32vector 1000))))
(test-assert (eq? #t (u32vector? (make-u32vector 10000))))

(test-assert (eq? #t (u32vector? v8)))
(test-assert (eq? #t (u32vector? v9)))
(test-assert (eq? #t (u32vector? (make-u32vector 0 11))))
(test-assert (eq? #t (u32vector? (make-u32vector 1 22))))
(test-assert (eq? #t (u32vector? (make-u32vector 10 33))))
(test-assert (eq? #t (u32vector? (make-u32vector 100 44))))
(test-assert (eq? #t (u32vector? (make-u32vector 1000 55))))
(test-assert (eq? #t (u32vector? (make-u32vector 10000 66))))

(test-eqv 2 (u32vector-length v1))
(test-eqv 0 (u32vector-length '#u32()))
(test-eqv 1 (u32vector-length '#u32(11)))
(test-eqv 2 (u32vector-length '#u32(11 22)))
(test-eqv 3 (u32vector-length '#u32(11 22 33)))
(test-eqv 4 (u32vector-length '#u32(11 22 33 44)))
(test-eqv 5 (u32vector-length '#u32(11 22 33 44 55)))

(test-eqv 5 (u32vector-length v6))
(test-eqv 0 (u32vector-length (u32vector)))
(test-eqv 1 (u32vector-length (u32vector 11)))
(test-eqv 2 (u32vector-length (u32vector 11 22)))
(test-eqv 3 (u32vector-length (u32vector 11 22 33)))
(test-eqv 4 (u32vector-length (u32vector 11 22 33 44)))
(test-eqv 5 (u32vector-length (u32vector 11 22 33 44 55)))

(test-eqv 2 (u32vector-length v7))
(test-eqv 0 (u32vector-length (make-u32vector 0)))
(test-eqv 1 (u32vector-length (make-u32vector 1)))
(test-eqv 10 (u32vector-length (make-u32vector 10)))
(test-eqv 100 (u32vector-length (make-u32vector 100)))
(test-eqv 1000 (u32vector-length (make-u32vector 1000)))
(test-eqv 10000 (u32vector-length (make-u32vector 10000)))

(test-eqv 2 (u32vector-length v8))
(test-eqv 2 (u32vector-length v9))
(test-eqv 0 (u32vector-length (make-u32vector 0 11)))
(test-eqv 1 (u32vector-length (make-u32vector 1 22)))
(test-eqv 10 (u32vector-length (make-u32vector 10 33)))
(test-eqv 100 (u32vector-length (make-u32vector 100 44)))
(test-eqv 1000 (u32vector-length (make-u32vector 1000 55)))
(test-eqv 10000 (u32vector-length (make-u32vector 10000 66)))

(test-equal '() (u32vector->list '#u32()))
(test-equal '(0 4294967295 0 1 4294967295) (u32vector->list v6))
(test-equal '(0 4294967295 0 1 4294967295) (u32vector->list v6 0))
(test-equal '(0 1 4294967295) (u32vector->list v6 2))
(test-equal '(0 1) (u32vector->list v6 2 4))
(test-equal '(0 4294967295 0 1 4294967295) (u32vector->list v6 0 5))
(test-equal '(0 0) (u32vector->list v7))

(test-equal '#u32() (list->u32vector '()))
(test-equal v6 (list->u32vector '(0 4294967295 0 1 4294967295)))
(test-equal v7 (list->u32vector '(0 0)))

(test-equal '#u32() (u32vector-append))
(test-equal v6 (u32vector-append v6))
(test-equal v6 (u32vector-append '#u32(0 4294967295) '#u32(0 1 4294967295)))
(test-equal
 '#u32(0 4294967295 0 1 4294967295 0 0 0 4294967295 0 1 4294967295)
 (u32vector-append v6 v7 v6))

(test-equal
 '#u32(0 4294967295 0 1 4294967295 0 0 0 4294967295 0 1 4294967295)
 (u32vector-concatenate (list v6 v7 v6)))
(test-equal
 '#u32(0 4294967295 0 1 4294967295 1 1 1 0 0 1 1 1 0 4294967295 0 1 4294967295)
 (u32vector-concatenate (list v6 v7 v6) '#u32(1 1 1)))

(test-equal '#u32() (u32vector-copy '#u32()))
(test-equal v6 (u32vector-copy v6))
(test-equal v6 (u32vector-copy v6 0))
(test-equal '#u32(0 1 4294967295) (u32vector-copy v6 2))
(test-equal '#u32() (u32vector-copy v6 0 0))
(test-equal '#u32() (u32vector-copy v6 4 4))
(test-equal '#u32(0 4294967295) (u32vector-copy v6 0 2))
(test-equal '#u32(0 1) (u32vector-copy v6 2 4))
(test-equal '#u32(4294967295) (u32vector-copy v6 4 5))
(test-equal v6 (u32vector-copy v6 0 5))

(test-equal '#u32() (subu32vector v6 0 0))
(test-equal '#u32() (subu32vector v6 4 4))
(test-equal '#u32(0 4294967295) (subu32vector v6 0 2))
(test-equal '#u32(0 1) (subu32vector v6 2 4))
(test-equal '#u32(4294967295) (subu32vector v6 4 5))
(test-equal v6 (subu32vector v6 0 5))

(test-eqv 0 (u32vector-ref v1 0))
(test-eqv 4294967295 (u32vector-ref v1 1))

(test-eqv 0 (u32vector-ref v6 0))
(test-eqv 4294967295 (u32vector-ref v6 1))
(test-eqv 0 (u32vector-ref v6 2))
(test-eqv 1 (u32vector-ref v6 3))
(test-eqv 4294967295 (u32vector-ref v6 4))

(test-eqv 0 (u32vector-ref v7 0))
(test-eqv 0 (u32vector-ref v7 1))

(test-eqv 0 (u32vector-ref v8 0))
(test-eqv 0 (u32vector-ref v8 1))

(test-eqv 4294967295 (u32vector-ref v9 0))
(test-eqv 4294967295 (u32vector-ref v9 1))

(test-equal '#u32(0 99 0 1 4294967295) (u32vector-set v6 1 99))
(test-equal '#u32(0 4294967295 0 1 4294967295) v6)
(test-equal '#u32(0 99) (u32vector-set v8 1 99))
(test-equal '#u32(4294967295 99) (u32vector-set v9 1 99))
(test-equal '#u32(99 22 33) (u32vector-set '#u32(11 22 33) 0 99))

(test-eq (void) (u32vector-set! v6 1 99))
(test-eq (void) (u32vector-set! v7 1 99))
(test-eq (void) (u32vector-set! v8 1 99))
(test-eq (void) (u32vector-set! v9 1 99))

(test-eqv 0 (u32vector-ref v6 0))
(test-eqv 99 (u32vector-ref v6 1))
(test-eqv 0 (u32vector-ref v6 2))
(test-eqv 1 (u32vector-ref v6 3))
(test-eqv 4294967295 (u32vector-ref v6 4))

(test-eq (void) (u32vector-swap! v6 0 4))

(test-eqv 4294967295 (u32vector-ref v6 0))
(test-eqv 99 (u32vector-ref v6 1))
(test-eqv 0 (u32vector-ref v6 2))
(test-eqv 1 (u32vector-ref v6 3))
(test-eqv 0 (u32vector-ref v6 4))

(test-eqv 0 (u32vector-ref v7 0))
(test-eqv 99 (u32vector-ref v7 1))

(test-eqv 0 (u32vector-ref v8 0))
(test-eqv 99 (u32vector-ref v8 1))

(test-eqv 4294967295 (u32vector-ref v9 0))
(test-eqv 99 (u32vector-ref v9 1))

(test-eq (void) (u32vector-shrink! v6 3))
(test-eq (void) (u32vector-shrink! v7 1))
(test-eq (void) (u32vector-shrink! v8 0))
(test-eq (void) (u32vector-shrink! v9 2))

(test-eqv 3 (u32vector-length v6))
(test-eqv 1 (u32vector-length v7))
(test-eqv 0 (u32vector-length v8))
(test-eqv 2 (u32vector-length v9))

(test-eq (void) (u32vector-fill! v6 0))
(test-equal '#u32(0 0 0) v6)

(test-eq (void) (u32vector-fill! v6 4294967295))
(test-equal '#u32(4294967295 4294967295 4294967295) v6)

(test-eq (void) (u32vector-fill! v6 3 1))
(test-equal '#u32(4294967295 3 3) v6)

(test-eq (void) (u32vector-fill! v6 99 0 2))
(test-equal '#u32(99 99 3) v6)

(test-eq (void) (subu32vector-fill! v6 0 3 9))
(test-equal '#u32(9 9 9) v6)

(test-eq (void) (subu32vector-fill! v6 1 2 0))
(test-equal '#u32(9 0 9) v6)

(test-eq (void) (subu32vector-fill! v6 1 3 4294967295))
(test-equal '#u32(9 4294967295 4294967295) v6)

(test-eq (void) (subu32vector-move! v9 0 2 v6 0))
(test-equal '#u32(4294967295 99 4294967295) v6)

(test-eq (void) (subu32vector-move! v9 0 2 v6 1))
(test-equal '#u32(4294967295 4294967295 99) v6)

(test-eq (void) (u32vector-copy! v6 0 '#u32(11 22 33)))
(test-equal '#u32(11 22 33) v6)

(test-eq (void) (u32vector-copy! v6 2 '#u32(33 44) 1))
(test-equal '#u32(11 22 44) v6)

(test-eq (void) (u32vector-copy! v6 1 '#u32(55 66 77 88) 0 2))
(test-equal '#u32(11 55 66) v6)

(test-error-tail type-exception? (u32vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (u32vector 11 -1 22))
;; homovect only
(test-error-tail type-exception? (u32vector 11 4294967296 22))
;; homovect only

(test-error-tail type-exception? (make-u32vector bool))
(test-error-tail type-exception? (make-u32vector bool 11))
(test-error-tail type-exception? (make-u32vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-u32vector 11 -1))
;; homovect only
(test-error-tail type-exception? (make-u32vector 11 4294967296))
;; homovect only
(test-error-tail range-exception? (make-u32vector -1 0))

(test-error-tail type-exception? (u32vector-length bool))

(test-error-tail type-exception? (u32vector->list bool))

(test-error-tail type-exception? (list->u32vector bool))

(test-error-tail type-exception? (u32vector-append bool))
(test-error-tail type-exception? (u32vector-append bool v9))
(test-error-tail type-exception? (u32vector-append v9 bool))

(test-error-tail type-exception? (u32vector-concatenate bool))
(test-error-tail type-exception? (u32vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (u32vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (u32vector-copy bool))
(test-error-tail type-exception? (u32vector-copy v9 bool))
(test-error-tail type-exception? (u32vector-copy v9 0 bool))

(test-error-tail type-exception? (subu32vector bool 0 0))
(test-error-tail type-exception? (subu32vector v9 bool 0))
(test-error-tail type-exception? (subu32vector v9 0 bool))
(test-error-tail range-exception? (subu32vector v9 -1 0))
(test-error-tail range-exception? (subu32vector v9 3 0))
(test-error-tail range-exception? (subu32vector v9 0 -1))
(test-error-tail range-exception? (subu32vector v9 0 3))

(test-error-tail type-exception? (u32vector-ref bool 0))
(test-error-tail type-exception? (u32vector-ref v5 bool))
(test-error-tail range-exception? (u32vector-ref v5 -1))
(test-error-tail range-exception? (u32vector-ref v5 2))

(test-error-tail type-exception? (u32vector-set bool 0 11))
(test-error-tail type-exception? (u32vector-set v5 bool 11))
(test-error-tail type-exception? (u32vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u32vector-set v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u32vector-set v5 0 4294967296))
;; homovect only
(test-error-tail range-exception? (u32vector-set v5 -1 0))
(test-error-tail range-exception? (u32vector-set v5 2 0))

(test-error-tail type-exception? (u32vector-set! bool 0 11))
(test-error-tail type-exception? (u32vector-set! v5 bool 11))
(test-error-tail type-exception? (u32vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u32vector-set! v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u32vector-set! v5 0 4294967296))
;; homovect only
(test-error-tail range-exception? (u32vector-set! v5 -1 0))
(test-error-tail range-exception? (u32vector-set! v5 2 0))

(test-error-tail type-exception? (u32vector-swap! bool 0 11))
(test-error-tail type-exception? (u32vector-swap! v5 bool 11))
(test-error-tail type-exception? (u32vector-swap! v5 0 bool))
(test-error-tail range-exception? (u32vector-swap! v5 -1 0))
(test-error-tail range-exception? (u32vector-swap! v5 10 0))

(test-error-tail type-exception? (u32vector-shrink! bool 0))
(test-error-tail type-exception? (u32vector-shrink! v5 bool))
(test-error-tail range-exception? (u32vector-shrink! v5 3))

(test-error-tail type-exception? (u32vector-fill! bool 0))
(test-error-tail type-exception? (u32vector-fill! v5 0 bool))
(test-error-tail type-exception? (u32vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (u32vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (u32vector-fill! v5 -1))
;; homovect only
(test-error-tail type-exception? (u32vector-fill! v5 4294967296))
;; homovect only

(test-error-tail type-exception? (subu32vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subu32vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subu32vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subu32vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail type-exception? (subu32vector-fill! v5 0 0 -1))
;; homovect only
(test-error-tail type-exception? (subu32vector-fill! v5 0 0 4294967296))
;; homovect only
(test-error-tail range-exception? (subu32vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subu32vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subu32vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subu32vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subu32vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subu32vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subu32vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subu32vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subu32vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subu32vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subu32vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subu32vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subu32vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subu32vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subu32vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (u32vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (u32vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (u32vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (u32vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (u32vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (u32vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (u32vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (u32vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (u32vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (u32vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (u32vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u32vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (make-u32vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u32vector?))
(test-error-tail wrong-number-of-arguments-exception? (u32vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u32vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u32vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (list->u32vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-copy))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu32vector))
(test-error-tail wrong-number-of-arguments-exception? (subu32vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subu32vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subu32vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-set! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu32vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subu32vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu32vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subu32vector-move! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu32vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u32vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (u32vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u32vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-u32vector (expt 2 64)))
