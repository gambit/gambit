(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define v1 '#u64(0 18446744073709551615))

(define v2 (##u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define v3 (##make-u64vector 2))
(define v4 (##make-u64vector 2 0))
(define v5 (##make-u64vector 2 18446744073709551615))

(define v6 (u64vector 0 18446744073709551615 0 1 18446744073709551615))
(define v7 (make-u64vector 2))
(define v8 (make-u64vector 2 0))
(define v9 (make-u64vector 2 18446744073709551615))

(test-assert (eq? #f (##u64vector? str)))
(test-assert (eq? #f (##u64vector? int)))
(test-assert (eq? #f (##u64vector? bool)))

(test-assert (eq? #t (##u64vector? v1)))
(test-assert (eq? #t (##u64vector? '#u64())))
(test-assert (eq? #t (##u64vector? '#u64(11))))
(test-assert (eq? #t (##u64vector? '#u64(11 22))))
(test-assert (eq? #t (##u64vector? '#u64(11 22 33))))
(test-assert (eq? #t (##u64vector? '#u64(11 22 33 44))))
(test-assert (eq? #t (##u64vector? '#u64(11 22 33 44 55))))

(test-assert (eq? #t (##u64vector? v2)))
(test-assert (eq? #t (##u64vector? (##u64vector))))
(test-assert (eq? #t (##u64vector? (##u64vector 11))))
(test-assert (eq? #t (##u64vector? (##u64vector 11 22))))
(test-assert (eq? #t (##u64vector? (##u64vector 11 22 33))))
(test-assert (eq? #t (##u64vector? (##u64vector 11 22 33 44))))
(test-assert (eq? #t (##u64vector? (##u64vector 11 22 33 44 55))))

(test-assert (eq? #t (##u64vector? v3)))
(test-assert (eq? #t (##u64vector? (##make-u64vector 0))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 1))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 10))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 100))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 1000))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 10000))))

(test-assert (eq? #t (##u64vector? v4)))
(test-assert (eq? #t (##u64vector? v5)))
(test-assert (eq? #t (##u64vector? (##make-u64vector 0 11))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 1 22))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 10 33))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 100 44))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 1000 55))))
(test-assert (eq? #t (##u64vector? (##make-u64vector 10000 66))))

(test-eqv 2 (##u64vector-length v1))
(test-eqv 0 (##u64vector-length '#u64()))
(test-eqv 1 (##u64vector-length '#u64(11)))
(test-eqv 2 (##u64vector-length '#u64(11 22)))
(test-eqv 3 (##u64vector-length '#u64(11 22 33)))
(test-eqv 4 (##u64vector-length '#u64(11 22 33 44)))
(test-eqv 5 (##u64vector-length '#u64(11 22 33 44 55)))

(test-eqv 5 (##u64vector-length v2))
(test-eqv 0 (##u64vector-length (##u64vector)))
(test-eqv 1 (##u64vector-length (##u64vector 11)))
(test-eqv 2 (##u64vector-length (##u64vector 11 22)))
(test-eqv 3 (##u64vector-length (##u64vector 11 22 33)))
(test-eqv 4 (##u64vector-length (##u64vector 11 22 33 44)))
(test-eqv 5 (##u64vector-length (##u64vector 11 22 33 44 55)))

(test-eqv 2 (##u64vector-length v3))
(test-eqv 0 (##u64vector-length (##make-u64vector 0)))
(test-eqv 1 (##u64vector-length (##make-u64vector 1)))
(test-eqv 10 (##u64vector-length (##make-u64vector 10)))
(test-eqv 100 (##u64vector-length (##make-u64vector 100)))
(test-eqv 1000 (##u64vector-length (##make-u64vector 1000)))
(test-eqv 10000 (##u64vector-length (##make-u64vector 10000)))

(test-eqv 2 (##u64vector-length v4))
(test-eqv 2 (##u64vector-length v5))
(test-eqv 0 (##u64vector-length (##make-u64vector 0 11)))
(test-eqv 1 (##u64vector-length (##make-u64vector 1 22)))
(test-eqv 10 (##u64vector-length (##make-u64vector 10 33)))
(test-eqv 100 (##u64vector-length (##make-u64vector 100 44)))
(test-eqv 1000 (##u64vector-length (##make-u64vector 1000 55)))
(test-eqv 10000 (##u64vector-length (##make-u64vector 10000 66)))

(test-eqv 0 (##u64vector-ref v1 0))
(test-eqv 18446744073709551615 (##u64vector-ref v1 1))

(test-eqv 0 (##u64vector-ref v2 0))
(test-eqv 18446744073709551615 (##u64vector-ref v2 1))
(test-eqv 0 (##u64vector-ref v2 2))
(test-eqv 1 (##u64vector-ref v2 3))
(test-eqv 18446744073709551615 (##u64vector-ref v2 4))

(test-eqv 0 (##u64vector-ref v4 0))
(test-eqv 0 (##u64vector-ref v4 1))

(test-eqv 18446744073709551615 (##u64vector-ref v5 0))
(test-eqv 18446744073709551615 (##u64vector-ref v5 1))

(test-equal '#u64(0 99 0 1 18446744073709551615) (##u64vector-set v2 1 99))
(test-equal '#u64(0 18446744073709551615 0 1 18446744073709551615) v2)
(test-equal '#u64(0 99) (##u64vector-set v4 1 99))
(test-equal '#u64(18446744073709551615 99) (##u64vector-set v5 1 99))
(test-equal '#u64(99 22 33) (##u64vector-set '#u64(11 22 33) 0 99))

(test-eq v2 (##u64vector-set! v2 1 99))
(test-eq v3 (##u64vector-set! v3 1 99))
(test-eq v4 (##u64vector-set! v4 1 99))
(test-eq v5 (##u64vector-set! v5 1 99))

(test-eqv 0 (##u64vector-ref v2 0))
(test-eqv 99 (##u64vector-ref v2 1))
(test-eqv 0 (##u64vector-ref v2 2))
(test-eqv 1 (##u64vector-ref v2 3))
(test-eqv 18446744073709551615 (##u64vector-ref v2 4))

(test-eqv v2 (##u64vector-swap! v2 0 4))

(test-eqv 18446744073709551615 (##u64vector-ref v2 0))
(test-eqv 99 (##u64vector-ref v2 1))
(test-eqv 0 (##u64vector-ref v2 2))
(test-eqv 1 (##u64vector-ref v2 3))
(test-eqv 0 (##u64vector-ref v2 4))

(test-eqv 99 (##u64vector-ref v3 1))

(test-eqv 0 (##u64vector-ref v4 0))
(test-eqv 99 (##u64vector-ref v4 1))

(test-eqv 18446744073709551615 (##u64vector-ref v5 0))
(test-eqv 99 (##u64vector-ref v5 1))

(test-eq v2 (##u64vector-shrink! v2 3))
(test-eq v3 (##u64vector-shrink! v3 1))
(test-eq v4 (##u64vector-shrink! v4 0))
(test-eq v5 (##u64vector-shrink! v5 2))

(test-eqv 3 (##u64vector-length v2))
(test-eqv 1 (##u64vector-length v3))
(test-eqv 0 (##u64vector-length v4))
(test-eqv 2 (##u64vector-length v5))

(test-assert (eq? #t (u64vector? v1)))
(test-assert (eq? #t (u64vector? '#u64())))
(test-assert (eq? #t (u64vector? '#u64(11))))
(test-assert (eq? #t (u64vector? '#u64(11 22))))
(test-assert (eq? #t (u64vector? '#u64(11 22 33))))
(test-assert (eq? #t (u64vector? '#u64(11 22 33 44))))
(test-assert (eq? #t (u64vector? '#u64(11 22 33 44 55))))

(test-assert (eq? #t (u64vector? v6)))
(test-assert (eq? #t (u64vector? (u64vector))))
(test-assert (eq? #t (u64vector? (u64vector 11))))
(test-assert (eq? #t (u64vector? (u64vector 11 22))))
(test-assert (eq? #t (u64vector? (u64vector 11 22 33))))
(test-assert (eq? #t (u64vector? (u64vector 11 22 33 44))))
(test-assert (eq? #t (u64vector? (u64vector 11 22 33 44 55))))

(test-assert (eq? #t (u64vector? v7)))
(test-assert (eq? #t (u64vector? (make-u64vector 0))))
(test-assert (eq? #t (u64vector? (make-u64vector 1))))
(test-assert (eq? #t (u64vector? (make-u64vector 10))))
(test-assert (eq? #t (u64vector? (make-u64vector 100))))
(test-assert (eq? #t (u64vector? (make-u64vector 1000))))
(test-assert (eq? #t (u64vector? (make-u64vector 10000))))

(test-assert (eq? #t (u64vector? v8)))
(test-assert (eq? #t (u64vector? v9)))
(test-assert (eq? #t (u64vector? (make-u64vector 0 11))))
(test-assert (eq? #t (u64vector? (make-u64vector 1 22))))
(test-assert (eq? #t (u64vector? (make-u64vector 10 33))))
(test-assert (eq? #t (u64vector? (make-u64vector 100 44))))
(test-assert (eq? #t (u64vector? (make-u64vector 1000 55))))
(test-assert (eq? #t (u64vector? (make-u64vector 10000 66))))

(test-eqv 2 (u64vector-length v1))
(test-eqv 0 (u64vector-length '#u64()))
(test-eqv 1 (u64vector-length '#u64(11)))
(test-eqv 2 (u64vector-length '#u64(11 22)))
(test-eqv 3 (u64vector-length '#u64(11 22 33)))
(test-eqv 4 (u64vector-length '#u64(11 22 33 44)))
(test-eqv 5 (u64vector-length '#u64(11 22 33 44 55)))

(test-eqv 5 (u64vector-length v6))
(test-eqv 0 (u64vector-length (u64vector)))
(test-eqv 1 (u64vector-length (u64vector 11)))
(test-eqv 2 (u64vector-length (u64vector 11 22)))
(test-eqv 3 (u64vector-length (u64vector 11 22 33)))
(test-eqv 4 (u64vector-length (u64vector 11 22 33 44)))
(test-eqv 5 (u64vector-length (u64vector 11 22 33 44 55)))

(test-eqv 2 (u64vector-length v7))
(test-eqv 0 (u64vector-length (make-u64vector 0)))
(test-eqv 1 (u64vector-length (make-u64vector 1)))
(test-eqv 10 (u64vector-length (make-u64vector 10)))
(test-eqv 100 (u64vector-length (make-u64vector 100)))
(test-eqv 1000 (u64vector-length (make-u64vector 1000)))
(test-eqv 10000 (u64vector-length (make-u64vector 10000)))

(test-eqv 2 (u64vector-length v8))
(test-eqv 2 (u64vector-length v9))
(test-eqv 0 (u64vector-length (make-u64vector 0 11)))
(test-eqv 1 (u64vector-length (make-u64vector 1 22)))
(test-eqv 10 (u64vector-length (make-u64vector 10 33)))
(test-eqv 100 (u64vector-length (make-u64vector 100 44)))
(test-eqv 1000 (u64vector-length (make-u64vector 1000 55)))
(test-eqv 10000 (u64vector-length (make-u64vector 10000 66)))

(test-equal '() (u64vector->list '#u64()))
(test-equal
 '(0 18446744073709551615 0 1 18446744073709551615)
 (u64vector->list v6))
(test-equal
 '(0 18446744073709551615 0 1 18446744073709551615)
 (u64vector->list v6 0))
(test-equal '(0 1 18446744073709551615) (u64vector->list v6 2))
(test-equal '(0 1) (u64vector->list v6 2 4))
(test-equal
 '(0 18446744073709551615 0 1 18446744073709551615)
 (u64vector->list v6 0 5))
(test-equal '(0 0) (u64vector->list v7))

(test-equal '#u64() (list->u64vector '()))
(test-equal
 v6
 (list->u64vector '(0 18446744073709551615 0 1 18446744073709551615)))
(test-equal v7 (list->u64vector '(0 0)))

(test-equal '#u64() (u64vector-append))
(test-equal v6 (u64vector-append v6))
(test-equal
 v6
 (u64vector-append
  '#u64(0 18446744073709551615)
  '#u64(0 1 18446744073709551615)))
(test-equal
 '#u64(0
       18446744073709551615
       0
       1
       18446744073709551615
       0
       0
       0
       18446744073709551615
       0
       1
       18446744073709551615)
 (u64vector-append v6 v7 v6))

(test-equal
 '#u64(0
       18446744073709551615
       0
       1
       18446744073709551615
       0
       0
       0
       18446744073709551615
       0
       1
       18446744073709551615)
 (u64vector-concatenate (list v6 v7 v6)))
(test-equal
 '#u64(0
       18446744073709551615
       0
       1
       18446744073709551615
       1
       1
       1
       0
       0
       1
       1
       1
       0
       18446744073709551615
       0
       1
       18446744073709551615)
 (u64vector-concatenate (list v6 v7 v6) '#u64(1 1 1)))

(test-equal '#u64() (u64vector-copy '#u64()))
(test-equal v6 (u64vector-copy v6))
(test-equal v6 (u64vector-copy v6 0))
(test-equal '#u64(0 1 18446744073709551615) (u64vector-copy v6 2))
(test-equal '#u64() (u64vector-copy v6 0 0))
(test-equal '#u64() (u64vector-copy v6 4 4))
(test-equal '#u64(0 18446744073709551615) (u64vector-copy v6 0 2))
(test-equal '#u64(0 1) (u64vector-copy v6 2 4))
(test-equal '#u64(18446744073709551615) (u64vector-copy v6 4 5))
(test-equal v6 (u64vector-copy v6 0 5))

(test-equal '#u64() (subu64vector v6 0 0))
(test-equal '#u64() (subu64vector v6 4 4))
(test-equal '#u64(0 18446744073709551615) (subu64vector v6 0 2))
(test-equal '#u64(0 1) (subu64vector v6 2 4))
(test-equal '#u64(18446744073709551615) (subu64vector v6 4 5))
(test-equal v6 (subu64vector v6 0 5))

(test-eqv 0 (u64vector-ref v1 0))
(test-eqv 18446744073709551615 (u64vector-ref v1 1))

(test-eqv 0 (u64vector-ref v6 0))
(test-eqv 18446744073709551615 (u64vector-ref v6 1))
(test-eqv 0 (u64vector-ref v6 2))
(test-eqv 1 (u64vector-ref v6 3))
(test-eqv 18446744073709551615 (u64vector-ref v6 4))

(test-eqv 0 (u64vector-ref v7 0))
(test-eqv 0 (u64vector-ref v7 1))

(test-eqv 0 (u64vector-ref v8 0))
(test-eqv 0 (u64vector-ref v8 1))

(test-eqv 18446744073709551615 (u64vector-ref v9 0))
(test-eqv 18446744073709551615 (u64vector-ref v9 1))

(test-equal '#u64(0 99 0 1 18446744073709551615) (u64vector-set v6 1 99))
(test-equal '#u64(0 18446744073709551615 0 1 18446744073709551615) v6)
(test-equal '#u64(0 99) (u64vector-set v8 1 99))
(test-equal '#u64(18446744073709551615 99) (u64vector-set v9 1 99))
(test-equal '#u64(99 22 33) (u64vector-set '#u64(11 22 33) 0 99))

(test-eq (void) (u64vector-set! v6 1 99))
(test-eq (void) (u64vector-set! v7 1 99))
(test-eq (void) (u64vector-set! v8 1 99))
(test-eq (void) (u64vector-set! v9 1 99))

(test-eqv 0 (u64vector-ref v6 0))
(test-eqv 99 (u64vector-ref v6 1))
(test-eqv 0 (u64vector-ref v6 2))
(test-eqv 1 (u64vector-ref v6 3))
(test-eqv 18446744073709551615 (u64vector-ref v6 4))

(test-eq (void) (u64vector-swap! v6 0 4))

(test-eqv 18446744073709551615 (u64vector-ref v6 0))
(test-eqv 99 (u64vector-ref v6 1))
(test-eqv 0 (u64vector-ref v6 2))
(test-eqv 1 (u64vector-ref v6 3))
(test-eqv 0 (u64vector-ref v6 4))

(test-eqv 0 (u64vector-ref v7 0))
(test-eqv 99 (u64vector-ref v7 1))

(test-eqv 0 (u64vector-ref v8 0))
(test-eqv 99 (u64vector-ref v8 1))

(test-eqv 18446744073709551615 (u64vector-ref v9 0))
(test-eqv 99 (u64vector-ref v9 1))

(test-eq (void) (u64vector-shrink! v6 3))
(test-eq (void) (u64vector-shrink! v7 1))
(test-eq (void) (u64vector-shrink! v8 0))
(test-eq (void) (u64vector-shrink! v9 2))

(test-eqv 3 (u64vector-length v6))
(test-eqv 1 (u64vector-length v7))
(test-eqv 0 (u64vector-length v8))
(test-eqv 2 (u64vector-length v9))

(test-eq (void) (u64vector-fill! v6 0))
(test-equal '#u64(0 0 0) v6)

(test-eq (void) (u64vector-fill! v6 18446744073709551615))
(test-equal
 '#u64(18446744073709551615 18446744073709551615 18446744073709551615)
 v6)

(test-eq (void) (u64vector-fill! v6 3 1))
(test-equal '#u64(18446744073709551615 3 3) v6)

(test-eq (void) (u64vector-fill! v6 99 0 2))
(test-equal '#u64(99 99 3) v6)

(test-eq (void) (subu64vector-fill! v6 0 3 9))
(test-equal '#u64(9 9 9) v6)

(test-eq (void) (subu64vector-fill! v6 1 2 0))
(test-equal '#u64(9 0 9) v6)

(test-eq (void) (subu64vector-fill! v6 1 3 18446744073709551615))
(test-equal '#u64(9 18446744073709551615 18446744073709551615) v6)

(test-eq (void) (subu64vector-move! v9 0 2 v6 0))
(test-equal '#u64(18446744073709551615 99 18446744073709551615) v6)

(test-eq (void) (subu64vector-move! v9 0 2 v6 1))
(test-equal '#u64(18446744073709551615 18446744073709551615 99) v6)

(test-eq (void) (u64vector-copy! v6 0 '#u64(11 22 33)))
(test-equal '#u64(11 22 33) v6)

(test-eq (void) (u64vector-copy! v6 2 '#u64(33 44) 1))
(test-equal '#u64(11 22 44) v6)

(test-eq (void) (u64vector-copy! v6 1 '#u64(55 66 77 88) 0 2))
(test-equal '#u64(11 55 66) v6)

(test-error-tail type-exception? (u64vector 11 bool 22))
;; homovect only
(test-error-tail type-exception? (u64vector 11 -1 22))
;; homovect only
(test-error-tail type-exception? (u64vector 11 18446744073709551616 22))
;; homovect only

(test-error-tail type-exception? (make-u64vector bool))
(test-error-tail type-exception? (make-u64vector bool 11))
(test-error-tail type-exception? (make-u64vector 11 bool))
;; homovect only
(test-error-tail type-exception? (make-u64vector 11 -1))
;; homovect only
(test-error-tail type-exception? (make-u64vector 11 18446744073709551616))
;; homovect only
(test-error-tail range-exception? (make-u64vector -1 0))

(test-error-tail type-exception? (u64vector-length bool))

(test-error-tail type-exception? (u64vector->list bool))

(test-error-tail type-exception? (list->u64vector bool))

(test-error-tail type-exception? (u64vector-append bool))
(test-error-tail type-exception? (u64vector-append bool v9))
(test-error-tail type-exception? (u64vector-append v9 bool))

(test-error-tail type-exception? (u64vector-concatenate bool))
(test-error-tail type-exception? (u64vector-concatenate '(1 2 3)))
(test-error-tail type-exception? (u64vector-concatenate (list v9 v9) bool))

(test-error-tail type-exception? (u64vector-copy bool))
(test-error-tail type-exception? (u64vector-copy v9 bool))
(test-error-tail type-exception? (u64vector-copy v9 0 bool))

(test-error-tail type-exception? (subu64vector bool 0 0))
(test-error-tail type-exception? (subu64vector v9 bool 0))
(test-error-tail type-exception? (subu64vector v9 0 bool))
(test-error-tail range-exception? (subu64vector v9 -1 0))
(test-error-tail range-exception? (subu64vector v9 3 0))
(test-error-tail range-exception? (subu64vector v9 0 -1))
(test-error-tail range-exception? (subu64vector v9 0 3))

(test-error-tail type-exception? (u64vector-ref bool 0))
(test-error-tail type-exception? (u64vector-ref v5 bool))
(test-error-tail range-exception? (u64vector-ref v5 -1))
(test-error-tail range-exception? (u64vector-ref v5 2))

(test-error-tail type-exception? (u64vector-set bool 0 11))
(test-error-tail type-exception? (u64vector-set v5 bool 11))
(test-error-tail type-exception? (u64vector-set v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u64vector-set v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u64vector-set v5 0 18446744073709551616))
;; homovect only
(test-error-tail range-exception? (u64vector-set v5 -1 0))
(test-error-tail range-exception? (u64vector-set v5 2 0))

(test-error-tail type-exception? (u64vector-set! bool 0 11))
(test-error-tail type-exception? (u64vector-set! v5 bool 11))
(test-error-tail type-exception? (u64vector-set! v5 0 bool))
;; homovect only
(test-error-tail type-exception? (u64vector-set! v5 0 -1))
;; homovect only
(test-error-tail type-exception? (u64vector-set! v5 0 18446744073709551616))
;; homovect only
(test-error-tail range-exception? (u64vector-set! v5 -1 0))
(test-error-tail range-exception? (u64vector-set! v5 2 0))

(test-error-tail type-exception? (u64vector-swap! bool 0 11))
(test-error-tail type-exception? (u64vector-swap! v5 bool 11))
(test-error-tail type-exception? (u64vector-swap! v5 0 bool))
(test-error-tail range-exception? (u64vector-swap! v5 -1 0))
(test-error-tail range-exception? (u64vector-swap! v5 10 0))

(test-error-tail type-exception? (u64vector-shrink! bool 0))
(test-error-tail type-exception? (u64vector-shrink! v5 bool))
(test-error-tail range-exception? (u64vector-shrink! v5 3))

(test-error-tail type-exception? (u64vector-fill! bool 0))
(test-error-tail type-exception? (u64vector-fill! v5 0 bool))
(test-error-tail type-exception? (u64vector-fill! v5 0 0 bool))
(test-error-tail type-exception? (u64vector-fill! v5 bool))
;; homovect only
(test-error-tail type-exception? (u64vector-fill! v5 -1))
;; homovect only
(test-error-tail type-exception? (u64vector-fill! v5 18446744073709551616))
;; homovect only

(test-error-tail type-exception? (subu64vector-fill! bool 0 0 0))
(test-error-tail type-exception? (subu64vector-fill! v5 bool 0 0))
(test-error-tail type-exception? (subu64vector-fill! v5 0 bool 0))
(test-error-tail type-exception? (subu64vector-fill! v5 0 0 bool))
;; homovect only
(test-error-tail type-exception? (subu64vector-fill! v5 0 0 -1))
;; homovect only
(test-error-tail
 type-exception?
 (subu64vector-fill! v5 0 0 18446744073709551616))
;; homovect only
(test-error-tail range-exception? (subu64vector-fill! v5 -1 0 0))
(test-error-tail range-exception? (subu64vector-fill! v5 3 0 0))
(test-error-tail range-exception? (subu64vector-fill! v5 0 -1 0))
(test-error-tail range-exception? (subu64vector-fill! v5 0 3 0))

(test-error-tail type-exception? (subu64vector-move! bool 0 0 v5 0))
(test-error-tail type-exception? (subu64vector-move! v5 bool 0 v5 0))
(test-error-tail type-exception? (subu64vector-move! v5 0 bool v5 0))
(test-error-tail type-exception? (subu64vector-move! v5 0 0 bool 0))
(test-error-tail type-exception? (subu64vector-move! v5 0 0 v5 bool))
(test-error-tail range-exception? (subu64vector-move! v5 -1 0 v5 0))
(test-error-tail range-exception? (subu64vector-move! v5 3 0 v5 0))
(test-error-tail range-exception? (subu64vector-move! v5 0 -1 v5 0))
(test-error-tail range-exception? (subu64vector-move! v5 0 3 v5 0))
(test-error-tail range-exception? (subu64vector-move! v5 0 0 v5 -1))
(test-error-tail range-exception? (subu64vector-move! v5 0 0 v5 3))

(test-error-tail type-exception? (u64vector-copy! v5 0 bool 0 0))
(test-error-tail type-exception? (u64vector-copy! v5 0 v5 bool 0))
(test-error-tail type-exception? (u64vector-copy! v5 0 v5 0 bool))
(test-error-tail type-exception? (u64vector-copy! bool 0 v5 0 0))
(test-error-tail type-exception? (u64vector-copy! v5 bool v5 0 0))
(test-error-tail range-exception? (u64vector-copy! v5 0 v5 -1 0))
(test-error-tail range-exception? (u64vector-copy! v5 0 v5 3 0))
(test-error-tail range-exception? (u64vector-copy! v5 0 v5 0 -1))
(test-error-tail range-exception? (u64vector-copy! v5 0 v5 0 3))
(test-error-tail range-exception? (u64vector-copy! v5 -1 v5 0 0))
(test-error-tail range-exception? (u64vector-copy! v5 3 v5 0 0))

(test-error-tail wrong-number-of-arguments-exception? (make-u64vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (make-u64vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (u64vector?))
(test-error-tail wrong-number-of-arguments-exception? (u64vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-length))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (u64vector->list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->u64vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (list->u64vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-concatenate))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-concatenate '() '() '()))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-copy))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-copy v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu64vector))
(test-error-tail wrong-number-of-arguments-exception? (subu64vector v1))
(test-error-tail wrong-number-of-arguments-exception? (subu64vector v1 0))
(test-error-tail wrong-number-of-arguments-exception? (subu64vector v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref v1))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-ref v1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-set!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-set! v9))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-set! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-set! v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-swap!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-swap! v9))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-swap! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-swap! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-shrink! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu64vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subu64vector-fill! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-fill! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-fill! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subu64vector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subu64vector-move! v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-move! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-move! v9 0 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-move! v9 0 0 v9))
(test-error-tail
 wrong-number-of-arguments-exception?
 (subu64vector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (u64vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (u64vector-copy! v9 0))
(test-error-tail
 wrong-number-of-arguments-exception?
 (u64vector-copy! v9 0 v9 0 0 0))

(test-error-tail range-exception? (make-u64vector (expt 2 64)))
