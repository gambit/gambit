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

(test-assert (eq? #f (##u8vector? str)))
(test-assert (eq? #f (##u8vector? int)))
(test-assert (eq? #f (##u8vector? bool)))

(test-assert (eq? #t (##u8vector? v1)))
(test-assert (eq? #t (##u8vector? '#u8())))
(test-assert (eq? #t (##u8vector? '#u8(11))))
(test-assert (eq? #t (##u8vector? '#u8(11 22))))
(test-assert (eq? #t (##u8vector? '#u8(11 22 33))))
(test-assert (eq? #t (##u8vector? '#u8(11 22 33 44))))
(test-assert (eq? #t (##u8vector? '#u8(11 22 33 44 55))))

(test-assert (eq? #t (##u8vector? v2)))
(test-assert (eq? #t (##u8vector? (##u8vector))))
(test-assert (eq? #t (##u8vector? (##u8vector 11))))
(test-assert (eq? #t (##u8vector? (##u8vector 11 22))))
(test-assert (eq? #t (##u8vector? (##u8vector 11 22 33))))
(test-assert (eq? #t (##u8vector? (##u8vector 11 22 33 44))))
(test-assert (eq? #t (##u8vector? (##u8vector 11 22 33 44 55))))

(test-assert (eq? #t (##u8vector? v3)))
(test-assert (eq? #t (##u8vector? (##make-u8vector 0))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 1))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 10))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 100))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 1000))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 10000))))

(test-assert (eq? #t (##u8vector? v4)))
(test-assert (eq? #t (##u8vector? v5)))
(test-assert (eq? #t (##u8vector? (##make-u8vector 0 11))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 1 22))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 10 33))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 100 44))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 1000 55))))
(test-assert (eq? #t (##u8vector? (##make-u8vector 10000 66))))

(test-eqv 2 (##u8vector-length v1))
(test-eqv 0 (##u8vector-length '#u8()))
(test-eqv 1 (##u8vector-length '#u8(11)))
(test-eqv 2 (##u8vector-length '#u8(11 22)))
(test-eqv 3 (##u8vector-length '#u8(11 22 33)))
(test-eqv 4 (##u8vector-length '#u8(11 22 33 44)))
(test-eqv 5 (##u8vector-length '#u8(11 22 33 44 55)))

(test-eqv 5 (##u8vector-length v2))
(test-eqv 0 (##u8vector-length (##u8vector)))
(test-eqv 1 (##u8vector-length (##u8vector 11)))
(test-eqv 2 (##u8vector-length (##u8vector 11 22)))
(test-eqv 3 (##u8vector-length (##u8vector 11 22 33)))
(test-eqv 4 (##u8vector-length (##u8vector 11 22 33 44)))
(test-eqv 5 (##u8vector-length (##u8vector 11 22 33 44 55)))

(test-eqv 2 (##u8vector-length v3))
(test-eqv 0 (##u8vector-length (##make-u8vector 0)))
(test-eqv 1 (##u8vector-length (##make-u8vector 1)))
(test-eqv 10 (##u8vector-length (##make-u8vector 10)))
(test-eqv 100 (##u8vector-length (##make-u8vector 100)))
(test-eqv 1000 (##u8vector-length (##make-u8vector 1000)))
(test-eqv 10000 (##u8vector-length (##make-u8vector 10000)))

(test-eqv 2 (##u8vector-length v4))
(test-eqv 2 (##u8vector-length v5))
(test-eqv 0 (##u8vector-length (##make-u8vector 0 11)))
(test-eqv 1 (##u8vector-length (##make-u8vector 1 22)))
(test-eqv 10 (##u8vector-length (##make-u8vector 10 33)))
(test-eqv 100 (##u8vector-length (##make-u8vector 100 44)))
(test-eqv 1000 (##u8vector-length (##make-u8vector 1000 55)))
(test-eqv 10000 (##u8vector-length (##make-u8vector 10000 66)))

(test-eqv 0 (##u8vector-ref v1 0))
(test-eqv 255 (##u8vector-ref v1 1))

(test-eqv 0 (##u8vector-ref v2 0))
(test-eqv 255 (##u8vector-ref v2 1))
(test-eqv 0 (##u8vector-ref v2 2))
(test-eqv 1 (##u8vector-ref v2 3))
(test-eqv 255 (##u8vector-ref v2 4))

(test-eqv 0 (##u8vector-ref v4 0))
(test-eqv 0 (##u8vector-ref v4 1))

(test-eqv 255 (##u8vector-ref v5 0))
(test-eqv 255 (##u8vector-ref v5 1))

(test-equal '#u8(0 99 0 1 255) (##u8vector-set v2 1 99))
(test-equal '#u8(0 255 0 1 255) v2)
(test-equal '#u8(0 99) (##u8vector-set v4 1 99))
(test-equal '#u8(255 99) (##u8vector-set v5 1 99))
(test-equal '#u8(99 22 33) (##u8vector-set '#u8(11 22 33) 0 99))

(test-eq v2 (##u8vector-set! v2 1 99))
(test-eq v3 (##u8vector-set! v3 1 99))
(test-eq v4 (##u8vector-set! v4 1 99))
(test-eq v5 (##u8vector-set! v5 1 99))

(test-eqv 0 (##u8vector-ref v2 0))
(test-eqv 99 (##u8vector-ref v2 1))
(test-eqv 0 (##u8vector-ref v2 2))
(test-eqv 1 (##u8vector-ref v2 3))
(test-eqv 255 (##u8vector-ref v2 4))

(test-eqv v2 (##u8vector-swap! v2 0 4))

(test-eqv 255 (##u8vector-ref v2 0))
(test-eqv 99 (##u8vector-ref v2 1))
(test-eqv 0 (##u8vector-ref v2 2))
(test-eqv 1 (##u8vector-ref v2 3))
(test-eqv 0 (##u8vector-ref v2 4))

(test-eqv 99 (##u8vector-ref v3 1))

(test-eqv 0 (##u8vector-ref v4 0))
(test-eqv 99 (##u8vector-ref v4 1))

(test-eqv 255 (##u8vector-ref v5 0))
(test-eqv 99 (##u8vector-ref v5 1))

(test-eq v2 (##u8vector-shrink! v2 3))
(test-eq v3 (##u8vector-shrink! v3 1))
(test-eq v4 (##u8vector-shrink! v4 0))
(test-eq v5 (##u8vector-shrink! v5 2))

(test-eqv 3 (##u8vector-length v2))
(test-eqv 1 (##u8vector-length v3))
(test-eqv 0 (##u8vector-length v4))
(test-eqv 2 (##u8vector-length v5))

(test-assert (eq? #t (u8vector? v1)))
(test-assert (eq? #t (u8vector? '#u8())))
(test-assert (eq? #t (u8vector? '#u8(11))))
(test-assert (eq? #t (u8vector? '#u8(11 22))))
(test-assert (eq? #t (u8vector? '#u8(11 22 33))))
(test-assert (eq? #t (u8vector? '#u8(11 22 33 44))))
(test-assert (eq? #t (u8vector? '#u8(11 22 33 44 55))))

(test-assert (eq? #t (u8vector? v6)))
(test-assert (eq? #t (u8vector? (u8vector))))
(test-assert (eq? #t (u8vector? (u8vector 11))))
(test-assert (eq? #t (u8vector? (u8vector 11 22))))
(test-assert (eq? #t (u8vector? (u8vector 11 22 33))))
(test-assert (eq? #t (u8vector? (u8vector 11 22 33 44))))
(test-assert (eq? #t (u8vector? (u8vector 11 22 33 44 55))))

(test-assert (eq? #t (u8vector? v7)))
(test-assert (eq? #t (u8vector? (make-u8vector 0))))
(test-assert (eq? #t (u8vector? (make-u8vector 1))))
(test-assert (eq? #t (u8vector? (make-u8vector 10))))
(test-assert (eq? #t (u8vector? (make-u8vector 100))))
(test-assert (eq? #t (u8vector? (make-u8vector 1000))))
(test-assert (eq? #t (u8vector? (make-u8vector 10000))))

(test-assert (eq? #t (u8vector? v8)))
(test-assert (eq? #t (u8vector? v9)))
(test-assert (eq? #t (u8vector? (make-u8vector 0 11))))
(test-assert (eq? #t (u8vector? (make-u8vector 1 22))))
(test-assert (eq? #t (u8vector? (make-u8vector 10 33))))
(test-assert (eq? #t (u8vector? (make-u8vector 100 44))))
(test-assert (eq? #t (u8vector? (make-u8vector 1000 55))))
(test-assert (eq? #t (u8vector? (make-u8vector 10000 66))))

(test-eqv 2 (u8vector-length v1))
(test-eqv 0 (u8vector-length '#u8()))
(test-eqv 1 (u8vector-length '#u8(11)))
(test-eqv 2 (u8vector-length '#u8(11 22)))
(test-eqv 3 (u8vector-length '#u8(11 22 33)))
(test-eqv 4 (u8vector-length '#u8(11 22 33 44)))
(test-eqv 5 (u8vector-length '#u8(11 22 33 44 55)))

(test-eqv 5 (u8vector-length v6))
(test-eqv 0 (u8vector-length (u8vector)))
(test-eqv 1 (u8vector-length (u8vector 11)))
(test-eqv 2 (u8vector-length (u8vector 11 22)))
(test-eqv 3 (u8vector-length (u8vector 11 22 33)))
(test-eqv 4 (u8vector-length (u8vector 11 22 33 44)))
(test-eqv 5 (u8vector-length (u8vector 11 22 33 44 55)))

(test-eqv 2 (u8vector-length v7))
(test-eqv 0 (u8vector-length (make-u8vector 0)))
(test-eqv 1 (u8vector-length (make-u8vector 1)))
(test-eqv 10 (u8vector-length (make-u8vector 10)))
(test-eqv 100 (u8vector-length (make-u8vector 100)))
(test-eqv 1000 (u8vector-length (make-u8vector 1000)))
(test-eqv 10000 (u8vector-length (make-u8vector 10000)))

(test-eqv 2 (u8vector-length v8))
(test-eqv 2 (u8vector-length v9))
(test-eqv 0 (u8vector-length (make-u8vector 0 11)))
(test-eqv 1 (u8vector-length (make-u8vector 1 22)))
(test-eqv 10 (u8vector-length (make-u8vector 10 33)))
(test-eqv 100 (u8vector-length (make-u8vector 100 44)))
(test-eqv 1000 (u8vector-length (make-u8vector 1000 55)))
(test-eqv 10000 (u8vector-length (make-u8vector 10000 66)))

(test-equal '() (u8vector->list '#u8()))
(test-equal '(0 255 0 1 255) (u8vector->list v6))
(test-equal '(0 255 0 1 255) (u8vector->list v6 0))
(test-equal '(0 1 255) (u8vector->list v6 2))
(test-equal '(0 1) (u8vector->list v6 2 4))
(test-equal '(0 255 0 1 255) (u8vector->list v6 0 5))
(test-equal '(0 0) (u8vector->list v7))

(test-equal '#u8() (list->u8vector '()))
(test-equal v6 (list->u8vector '(0 255 0 1 255)))
(test-equal v7 (list->u8vector '(0 0)))

(test-equal '#u8() (u8vector-append))
(test-equal v6 (u8vector-append v6))
(test-equal v6 (u8vector-append '#u8(0 255) '#u8(0 1 255)))
(test-equal '#u8(0 255 0 1 255 0 0 0 255 0 1 255) (u8vector-append v6 v7 v6))

(test-equal
 '#u8(0 255 0 1 255 0 0 0 255 0 1 255)
 (u8vector-concatenate (list v6 v7 v6)))
(test-equal
 '#u8(0 255 0 1 255 1 1 1 0 0 1 1 1 0 255 0 1 255)
 (u8vector-concatenate (list v6 v7 v6) '#u8(1 1 1)))

(test-equal '#u8() (u8vector-copy '#u8()))
(test-equal v6 (u8vector-copy v6))
(test-equal v6 (u8vector-copy v6 0))
(test-equal '#u8(0 1 255) (u8vector-copy v6 2))
(test-equal '#u8() (u8vector-copy v6 0 0))
(test-equal '#u8() (u8vector-copy v6 4 4))
(test-equal '#u8(0 255) (u8vector-copy v6 0 2))
(test-equal '#u8(0 1) (u8vector-copy v6 2 4))
(test-equal '#u8(255) (u8vector-copy v6 4 5))
(test-equal v6 (u8vector-copy v6 0 5))

(test-equal '#u8() (subu8vector v6 0 0))
(test-equal '#u8() (subu8vector v6 4 4))
(test-equal '#u8(0 255) (subu8vector v6 0 2))
(test-equal '#u8(0 1) (subu8vector v6 2 4))
(test-equal '#u8(255) (subu8vector v6 4 5))
(test-equal v6 (subu8vector v6 0 5))

(test-eqv 0 (u8vector-ref v1 0))
(test-eqv 255 (u8vector-ref v1 1))

(test-eqv 0 (u8vector-ref v6 0))
(test-eqv 255 (u8vector-ref v6 1))
(test-eqv 0 (u8vector-ref v6 2))
(test-eqv 1 (u8vector-ref v6 3))
(test-eqv 255 (u8vector-ref v6 4))

(test-eqv 0 (u8vector-ref v7 0))
(test-eqv 0 (u8vector-ref v7 1))

(test-eqv 0 (u8vector-ref v8 0))
(test-eqv 0 (u8vector-ref v8 1))

(test-eqv 255 (u8vector-ref v9 0))
(test-eqv 255 (u8vector-ref v9 1))

(test-equal '#u8(0 99 0 1 255) (u8vector-set v6 1 99))
(test-equal '#u8(0 255 0 1 255) v6)
(test-equal '#u8(0 99) (u8vector-set v8 1 99))
(test-equal '#u8(255 99) (u8vector-set v9 1 99))
(test-equal '#u8(99 22 33) (u8vector-set '#u8(11 22 33) 0 99))

(test-eq (void) (u8vector-set! v6 1 99))
(test-eq (void) (u8vector-set! v7 1 99))
(test-eq (void) (u8vector-set! v8 1 99))
(test-eq (void) (u8vector-set! v9 1 99))

(test-eqv 0 (u8vector-ref v6 0))
(test-eqv 99 (u8vector-ref v6 1))
(test-eqv 0 (u8vector-ref v6 2))
(test-eqv 1 (u8vector-ref v6 3))
(test-eqv 255 (u8vector-ref v6 4))

(test-eq (void) (u8vector-swap! v6 0 4))

(test-eqv 255 (u8vector-ref v6 0))
(test-eqv 99 (u8vector-ref v6 1))
(test-eqv 0 (u8vector-ref v6 2))
(test-eqv 1 (u8vector-ref v6 3))
(test-eqv 0 (u8vector-ref v6 4))

(test-eqv 0 (u8vector-ref v7 0))
(test-eqv 99 (u8vector-ref v7 1))

(test-eqv 0 (u8vector-ref v8 0))
(test-eqv 99 (u8vector-ref v8 1))

(test-eqv 255 (u8vector-ref v9 0))
(test-eqv 99 (u8vector-ref v9 1))

(test-eq (void) (u8vector-shrink! v6 3))
(test-eq (void) (u8vector-shrink! v7 1))
(test-eq (void) (u8vector-shrink! v8 0))
(test-eq (void) (u8vector-shrink! v9 2))

(test-eqv 3 (u8vector-length v6))
(test-eqv 1 (u8vector-length v7))
(test-eqv 0 (u8vector-length v8))
(test-eqv 2 (u8vector-length v9))

(test-eq (void) (u8vector-fill! v6 0))
(test-equal '#u8(0 0 0) v6)

(test-eq (void) (u8vector-fill! v6 255))
(test-equal '#u8(255 255 255) v6)

(test-eq (void) (u8vector-fill! v6 3 1))
(test-equal '#u8(255 3 3) v6)

(test-eq (void) (u8vector-fill! v6 99 0 2))
(test-equal '#u8(99 99 3) v6)

(test-eq (void) (subu8vector-fill! v6 0 3 9))
(test-equal '#u8(9 9 9) v6)

(test-eq (void) (subu8vector-fill! v6 1 2 0))
(test-equal '#u8(9 0 9) v6)

(test-eq (void) (subu8vector-fill! v6 1 3 255))
(test-equal '#u8(9 255 255) v6)

(test-eq (void) (subu8vector-move! v9 0 2 v6 0))
(test-equal '#u8(255 99 255) v6)

(test-eq (void) (subu8vector-move! v9 0 2 v6 1))
(test-equal '#u8(255 255 99) v6)

(test-eq (void) (u8vector-copy! v6 0 '#u8(11 22 33)))
(test-equal '#u8(11 22 33) v6)

(test-eq (void) (u8vector-copy! v6 2 '#u8(33 44) 1))
(test-equal '#u8(11 22 44) v6)

(test-eq (void) (u8vector-copy! v6 1 '#u8(55 66 77 88) 0 2))
(test-equal '#u8(11 55 66) v6)

(test-error-tail type-exception? (u8vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (u8vector 11 -1 22))
;; homovect only
(test-error-tail type-exception? (u8vector 11 256 22))
;; homovect only

(test-error-tail type-exception? (make-u8vector bool))
(test-error-tail type-exception? (make-u8vector bool 11))
(test-error-tail type-exception? (make-u8vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-u8vector 11 -1))
;; homovect only
(test-error-tail type-exception? (make-u8vector 11 256))
;; homovect only
(test-error-tail range-exception? (make-u8vector -1 0))

(test-error-tail type-exception? (u8vector-length bool))

(test-error-tail type-exception? (u8vector->list bool))

(test-error-tail type-exception? (list->u8vector bool))

(test-error-tail type-exception? (u8vector-append bool))
(test-error-tail type-exception? (u8vector-append bool v9))
(test-error-tail type-exception? (u8vector-append v9 bool))

(test-error-tail type-exception? (u8vector-concatenate bool))
(test-error-tail type-exception? (u8vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (u8vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (u8vector-copy bool))
(test-error-tail type-exception? (u8vector-copy v9 bool))
(test-error-tail type-exception? (u8vector-copy v9 0 bool))

(test-error-tail type-exception? (subu8vector bool 0 0))
(test-error-tail type-exception? (subu8vector v9 bool 0))
(test-error-tail type-exception? (subu8vector v9 0 bool))
(test-error-tail range-exception? (subu8vector v9 -1 0))
(test-error-tail range-exception? (subu8vector v9 3 0))
(test-error-tail range-exception? (subu8vector v9 0 -1))
(test-error-tail range-exception? (subu8vector v9 0 3))

(test-error-tail type-exception? (u8vector-ref bool 0))
(test-error-tail type-exception? (u8vector-ref v5 bool))
(test-error-tail range-exception? (u8vector-ref v5 -1))
(test-error-tail range-exception? (u8vector-ref v5 2))

(test-error-tail type-exception? (u8vector-set bool 0 11))
(test-error-tail type-exception? (u8vector-set v5 bool 11))
(test-error-tail type-exception? (u8vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u8vector-set v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u8vector-set v5 0 256))
;; homovect only
(test-error-tail range-exception? (u8vector-set v5 -1 0))
(test-error-tail range-exception? (u8vector-set v5 2 0))

(test-error-tail type-exception? (u8vector-set! bool 0 11))
(test-error-tail type-exception? (u8vector-set! v5 bool 11))
(test-error-tail type-exception? (u8vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u8vector-set! v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u8vector-set! v5 0 256))
;; homovect only
(test-error-tail range-exception? (u8vector-set! v5 -1 0))
(test-error-tail range-exception? (u8vector-set! v5 2 0))

(test-error-tail type-exception? (u8vector-swap! bool 0 11))
(test-error-tail type-exception? (u8vector-swap! v5 bool 11))
(test-error-tail type-exception? (u8vector-swap! v5 0 bool))
(test-error-tail range-exception? (u8vector-swap! v5 -1 0))
(test-error-tail range-exception? (u8vector-swap! v5 10 0))

(test-error-tail type-exception? (u8vector-shrink! bool 0))
(test-error-tail type-exception? (u8vector-shrink! v5 bool))
(test-error-tail range-exception? (u8vector-shrink! v5 3))

(test-error-tail type-exception? (u8vector-fill! bool 0))
(test-error-tail type-exception? (u8vector-fill! v5 0 bool))
(test-error-tail type-exception? (u8vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (u8vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (u8vector-fill! v5 -1))
;; homovect only
(test-error-tail type-exception? (u8vector-fill! v5 256))
;; homovect only

(test-error-tail type-exception? (subu8vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subu8vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subu8vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subu8vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail type-exception? (subu8vector-fill! v5 0 0 -1))
;; homovect only
(test-error-tail type-exception? (subu8vector-fill! v5 0 0 256))
;; homovect only
(test-error-tail range-exception? (subu8vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subu8vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subu8vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subu8vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subu8vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subu8vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subu8vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subu8vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subu8vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subu8vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subu8vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subu8vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subu8vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subu8vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subu8vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (u8vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (u8vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (u8vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (u8vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (u8vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (u8vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (u8vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (u8vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (u8vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (u8vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (u8vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u8vector))
(test-error-tail wrong-number-of-arguments-exception? (make-u8vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u8vector?))
(test-error-tail wrong-number-of-arguments-exception? (u8vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u8vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u8vector))
(test-error-tail wrong-number-of-arguments-exception? (list->u8vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-copy))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu8vector))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu8vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector-fill! v9))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu8vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu8vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu8vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector-move! v9))
(test-error-tail wrong-number-of-arguments-exception? (subu8vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu8vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu8vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu8vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u8vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (u8vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u8vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-u8vector (expt 2 64)))
