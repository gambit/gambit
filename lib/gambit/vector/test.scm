;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================


(import (_test))
;(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)
(define proc (lambda () #f))

(define v1 '#(0 255))

(define v2 (##vector 0 255 0 1 255))
(define v3 (##make-vector 2))
(define v4 (##make-vector 2 0))
(define v5 (##make-vector 2 255))

(define v6 (vector 0 255 0 1 255))
(define v7 (make-vector 2))
(define v8 (make-vector 2 0))
(define v9 (make-vector 2 255))
(define v10 (vector 0 0 0 0))

(test-assert (not  (##vector? str)))
(test-assert (not  (##vector? int)))
(test-assert (not  (##vector? bool)))

(test-assert (##vector? v1))
(test-assert (##vector? '#()))
(test-assert (##vector? '#(11)))
(test-assert (##vector? '#(11 22)))
(test-assert (##vector? '#(11 22 33)))
(test-assert (##vector? '#(11 22 33 44)))
(test-assert (##vector? '#(11 22 33 44 55)))

(test-assert (##vector? v2))
(test-assert (##vector? (##vector)))
(test-assert (##vector? (##vector 11)))
(test-assert (##vector? (##vector 11 22)))
(test-assert (##vector? (##vector 11 22 33)))
(test-assert (##vector? (##vector 11 22 33 44)))
(test-assert (##vector? (##vector 11 22 33 44 55)))

(test-assert (##vector? v3))
(test-assert (##vector? (##make-vector 0)))
(test-assert (##vector? (##make-vector 1)))
(test-assert (##vector? (##make-vector 10)))
(test-assert (##vector? (##make-vector 100)))
(test-assert (##vector? (##make-vector 1000)))
(test-assert (##vector? (##make-vector 10000)))

(test-assert (##vector? v4))
(test-assert (##vector? v5))
(test-assert (##vector? (##make-vector 0 11)))
(test-assert (##vector? (##make-vector 1 22)))
(test-assert (##vector? (##make-vector 10 33)))
(test-assert (##vector? (##make-vector 100 44)))
(test-assert (##vector? (##make-vector 1000 55)))
(test-assert (##vector? (##make-vector 10000 66)))

(test-assert (eqv? (##vector-length v1) 2))
(test-assert (eqv? (##vector-length '#()) 0))
(test-assert (eqv? (##vector-length '#(11)) 1))
(test-assert (eqv? (##vector-length '#(11 22)) 2))
(test-assert (eqv? (##vector-length '#(11 22 33)) 3))
(test-assert (eqv? (##vector-length '#(11 22 33 44)) 4))
(test-assert (eqv? (##vector-length '#(11 22 33 44 55)) 5))

(test-assert (eqv? (##vector-length v2) 5))
(test-assert (eqv? (##vector-length (##vector)) 0))
(test-assert (eqv? (##vector-length (##vector 11)) 1))
(test-assert (eqv? (##vector-length (##vector 11 22)) 2))
(test-assert (eqv? (##vector-length (##vector 11 22 33)) 3))
(test-assert (eqv? (##vector-length (##vector 11 22 33 44)) 4))
(test-assert (eqv? (##vector-length (##vector 11 22 33 44 55)) 5))

(test-assert (eqv? (##vector-length v3) 2))
(test-assert (eqv? (##vector-length (##make-vector 0)) 0))
(test-assert (eqv? (##vector-length (##make-vector 1)) 1))
(test-assert (eqv? (##vector-length (##make-vector 10)) 10))
(test-assert (eqv? (##vector-length (##make-vector 100)) 100))
(test-assert (eqv? (##vector-length (##make-vector 1000)) 1000))
(test-assert (eqv? (##vector-length (##make-vector 10000)) 10000))

(test-assert (eqv? (##vector-length v4) 2))
(test-assert (eqv? (##vector-length v5) 2))
(test-assert (eqv? (##vector-length (##make-vector 0 11)) 0))
(test-assert (eqv? (##vector-length (##make-vector 1 22)) 1))
(test-assert (eqv? (##vector-length (##make-vector 10 33)) 10))
(test-assert (eqv? (##vector-length (##make-vector 100 44)) 100))
(test-assert (eqv? (##vector-length (##make-vector 1000 55)) 1000))
(test-assert (eqv? (##vector-length (##make-vector 10000 66)) 10000))

(test-assert (eqv? (##vector-ref v1 0) 0))
(test-assert (eqv? (##vector-ref v1 1) 255))

(test-assert (eqv? (##vector-ref v2 0) 0))
(test-assert (eqv? (##vector-ref v2 1) 255))
(test-assert (eqv? (##vector-ref v2 2) 0))
(test-assert (eqv? (##vector-ref v2 3) 1))
(test-assert (eqv? (##vector-ref v2 4) 255))

(test-assert (eqv? (##vector-ref v4 0) 0))
(test-assert (eqv? (##vector-ref v4 1) 0))

(test-assert (eqv? (##vector-ref v5 0) 255))
(test-assert (eqv? (##vector-ref v5 1) 255))

(test-assert (equal? (##vector-set v2 1 99) '#(0 99 0 1 255)))
(test-assert (equal? v2 '#(0 255 0 1 255)))
(test-assert (equal? (##vector-set v4 1 99) '#(0 99)))
(test-assert (equal? (##vector-set v5 1 99) '#(255 99)))
(test-assert (equal? (##vector-set '#(11 22 33) 0 99) '#(99 22 33)))

(test-assert (eq? (##vector-set! v2 1 99) v2))
(test-assert (eq? (##vector-set! v3 1 99) v3))
(test-assert (eq? (##vector-set! v4 1 99) v4))
(test-assert (eq? (##vector-set! v5 1 99) v5))

(test-assert (eqv? (##vector-ref v2 0) 0))
(test-assert (eqv? (##vector-ref v2 1) 99))
(test-assert (eqv? (##vector-ref v2 2) 0))
(test-assert (eqv? (##vector-ref v2 3) 1))
(test-assert (eqv? (##vector-ref v2 4) 255))

(test-assert (eqv? (##vector-ref v3 1) 99))

(test-assert (eqv? (##vector-ref v4 0) 0))
(test-assert (eqv? (##vector-ref v4 1) 99))

(test-assert (eqv? (##vector-ref v5 0) 255))
(test-assert (eqv? (##vector-ref v5 1) 99))

(test-assert (eq? (##vector-shrink! v2 3) v2))
(test-assert (eq? (##vector-shrink! v3 1) v3))
(test-assert (eq? (##vector-shrink! v4 0) v4))
(test-assert (eq? (##vector-shrink! v5 2) v5))

(test-assert (eqv? (##vector-length v2) 3))
(test-assert (eqv? (##vector-length v3) 1))
(test-assert (eqv? (##vector-length v4) 0))
(test-assert (eqv? (##vector-length v5) 2))

(test-assert (vector? v1))
(test-assert (vector? '#()))
(test-assert (vector? '#(11)))
(test-assert (vector? '#(11 22)))
(test-assert (vector? '#(11 22 33)))
(test-assert (vector? '#(11 22 33 44)))
(test-assert (vector? '#(11 22 33 44 55)))

(test-assert (vector? v6))
(test-assert (vector? (vector)))
(test-assert (vector? (vector 11)))
(test-assert (vector? (vector 11 22)))
(test-assert (vector? (vector 11 22 33)))
(test-assert (vector? (vector 11 22 33 44)))
(test-assert (vector? (vector 11 22 33 44 55)))

(test-assert (vector? v7))
(test-assert (vector? (make-vector 0)))
(test-assert (vector? (make-vector 1)))
(test-assert (vector? (make-vector 10)))
(test-assert (vector? (make-vector 100)))
(test-assert (vector? (make-vector 1000)))
(test-assert (vector? (make-vector 10000)))

(test-assert (vector? v8))
(test-assert (vector? v9))
(test-assert (vector? (make-vector 0 11)))
(test-assert (vector? (make-vector 1 22)))
(test-assert (vector? (make-vector 10 33)))
(test-assert (vector? (make-vector 100 44)))
(test-assert (vector? (make-vector 1000 55)))
(test-assert (vector? (make-vector 10000 66)))

(test-assert (eqv? (vector-length v1) 2))
(test-assert (eqv? (vector-length '#()) 0))
(test-assert (eqv? (vector-length '#(11)) 1))
(test-assert (eqv? (vector-length '#(11 22)) 2))
(test-assert (eqv? (vector-length '#(11 22 33)) 3))
(test-assert (eqv? (vector-length '#(11 22 33 44)) 4))
(test-assert (eqv? (vector-length '#(11 22 33 44 55)) 5))

(test-assert (eqv? (vector-length v6) 5))
(test-assert (eqv? (vector-length (vector)) 0))
(test-assert (eqv? (vector-length (vector 11)) 1))
(test-assert (eqv? (vector-length (vector 11 22)) 2))
(test-assert (eqv? (vector-length (vector 11 22 33)) 3))
(test-assert (eqv? (vector-length (vector 11 22 33 44)) 4))
(test-assert (eqv? (vector-length (vector 11 22 33 44 55)) 5))

(test-assert (eqv? (vector-length v7) 2))
(test-assert (eqv? (vector-length (make-vector 0)) 0))
(test-assert (eqv? (vector-length (make-vector 1)) 1))
(test-assert (eqv? (vector-length (make-vector 10)) 10))
(test-assert (eqv? (vector-length (make-vector 100)) 100))
(test-assert (eqv? (vector-length (make-vector 1000)) 1000))
(test-assert (eqv? (vector-length (make-vector 10000)) 10000))

(test-assert (eqv? (vector-length v8) 2))
(test-assert (eqv? (vector-length v9) 2))
(test-assert (eqv? (vector-length (make-vector 0 11)) 0))
(test-assert (eqv? (vector-length (make-vector 1 22)) 1))
(test-assert (eqv? (vector-length (make-vector 10 33)) 10))
(test-assert (eqv? (vector-length (make-vector 100 44)) 100))
(test-assert (eqv? (vector-length (make-vector 1000 55)) 1000))
(test-assert (eqv? (vector-length (make-vector 10000 66)) 10000))

(test-assert (equal? (vector->list '#()) '()))
(test-assert (equal? (vector->list v6) '(0 255 0 1 255)))
(test-assert (equal? (vector->list v6 0) '(0 255 0 1 255)))
(test-assert (equal? (vector->list v6 2) '(0 1 255)))
(test-assert (equal? (vector->list v6 2 4) '(0 1)))
(test-assert (equal? (vector->list v6 0 5) '(0 255 0 1 255)))
(test-assert (equal? (vector->list v7) '(0 0)))

(test-assert (equal? (list->vector '()) '#()))
(test-assert (equal? (list->vector '(0 255 0 1 255)) v6))
(test-assert (equal? (list->vector '(0 0)) v7))

(test-assert (equal? (vector-append) '#()))
(test-assert (equal? (vector-append v6) v6))
(test-assert (equal? (vector-append '#(0 255) '#(0 1 255)) v6))
(test-assert (equal? (vector-append v6 v7 v6) '#(0 255 0 1 255 0 0 0 255 0 1 255)))

(test-assert (equal? (append-vectors (list v6 v7 v6)) '#(0 255 0 1 255 0 0 0 255 0 1 255)))
(test-assert (equal? (append-vectors (list v6 v7 v6) '#(1 1 1)) '#(0 255 0 1 255 1 1 1 0 0 1 1 1 0 255 0 1 255)))

(test-assert (equal? (vector-copy '#()) '#()))
(test-assert (equal? (vector-copy v6) v6))
(test-assert (equal? (vector-copy v6 0) v6))
(test-assert (equal? (vector-copy v6 2) '#(0 1 255)))
(test-assert (equal? (vector-copy v6 0 0) '#()))
(test-assert (equal? (vector-copy v6 4 4) '#()))
(test-assert (equal? (vector-copy v6 0 2) '#(0 255)))
(test-assert (equal? (vector-copy v6 2 4) '#(0 1)))
(test-assert (equal? (vector-copy v6 4 5) '#(255)))
(test-assert (equal? (vector-copy v6 0 5) v6))

(test-assert (equal? (subvector v6 0 0) '#()))
(test-assert (equal? (subvector v6 4 4) '#()))
(test-assert (equal? (subvector v6 0 2) '#(0 255)))
(test-assert (equal? (subvector v6 2 4) '#(0 1)))
(test-assert (equal? (subvector v6 4 5) '#(255)))
(test-assert (equal? (subvector v6 0 5) v6))

(test-assert (eqv? (vector-ref v1 0) 0))
(test-assert (eqv? (vector-ref v1 1) 255))

(test-assert (eqv? (vector-ref v6 0) 0))
(test-assert (eqv? (vector-ref v6 1) 255))
(test-assert (eqv? (vector-ref v6 2) 0))
(test-assert (eqv? (vector-ref v6 3) 1))
(test-assert (eqv? (vector-ref v6 4) 255))

(test-assert (eqv? (vector-ref v7 0) 0))
(test-assert (eqv? (vector-ref v7 1) 0))

(test-assert (eqv? (vector-ref v8 0) 0))
(test-assert (eqv? (vector-ref v8 1) 0))

(test-assert (eqv? (vector-ref v9 0) 255))
(test-assert (eqv? (vector-ref v9 1) 255))

(test-assert (equal? (vector-set v6 1 99) '#(0 99 0 1 255)))
(test-assert (equal? v6 '#(0 255 0 1 255)))
(test-assert (equal? (vector-set v8 1 99) '#(0 99)))
(test-assert (equal? (vector-set v9 1 99) '#(255 99)))
(test-assert (equal? (vector-set '#(11 22 33) 0 99) '#(99 22 33)))

(test-assert (eq? (vector-set! v6 1 99) (void)))
(test-assert (eq? (vector-set! v7 1 99) (void)))
(test-assert (eq? (vector-set! v8 1 99) (void)))
(test-assert (eq? (vector-set! v9 1 99) (void)))

(test-assert (eqv? (vector-ref v6 0) 0))
(test-assert (eqv? (vector-ref v6 1) 99))
(test-assert (eqv? (vector-ref v6 2) 0))
(test-assert (eqv? (vector-ref v6 3) 1))
(test-assert (eqv? (vector-ref v6 4) 255))

(test-assert (eqv? (vector-ref v7 0) 0))
(test-assert (eqv? (vector-ref v7 1) 99))

(test-assert (eqv? (vector-ref v8 0) 0))
(test-assert (eqv? (vector-ref v8 1) 99))

(test-assert (eqv? (vector-ref v9 0) 255))
(test-assert (eqv? (vector-ref v9 1) 99))

(test-assert (eq? (vector-shrink! v6 3) (void)))
(test-assert (eq? (vector-shrink! v7 1) (void)))
(test-assert (eq? (vector-shrink! v8 0) (void)))
(test-assert (eq? (vector-shrink! v9 2) (void)))

(test-assert (eqv? (vector-length v6) 3))
(test-assert (eqv? (vector-length v7) 1))
(test-assert (eqv? (vector-length v8) 0))
(test-assert (eqv? (vector-length v9) 2))

(test-assert (eq? (vector-fill! v6 0) (void)))
(test-assert (equal? v6 '#(0 0 0)))

(test-assert (eq? (vector-fill! v6 255) (void)))
(test-assert (equal? v6 '#(255 255 255)))

(test-assert (eq? (vector-fill! v6 3 1) (void)))
(test-assert (equal? v6 '#(255 3 3)))

(test-assert (eq? (vector-fill! v6 99 0 2) (void)))
(test-assert (equal? v6 '#(99 99 3)))

(test-assert (eq? (subvector-fill! v6 0 3 9) (void)))
(test-assert (equal? v6 '#(9 9 9)))

(test-assert (eq? (subvector-fill! v6 1 2 0) (void)))
(test-assert (equal? v6 '#(9 0 9)))

(test-assert (eq? (subvector-fill! v6 1 3 255) (void)))
(test-assert (equal? v6 '#(9 255 255)))

(test-assert (eq? (subvector-move! v9 0 2 v6 0) (void)))
(test-assert (equal? v6 '#(255 99 255)))

(test-assert (eq? (subvector-move! v9 0 2 v6 1) (void)))
(test-assert (equal? v6 '#(255 255 99)))

(test-assert (eq? (vector-copy! v6 0 '#(11 22 33)) (void)))
(test-assert (equal? v6 '#(11 22 33)))

(test-assert (eq? (vector-copy! v6 2 '#(33 44) 1) (void)))
(test-assert (equal? v6 '#(11 22 44)))

(test-assert (eq? (vector-copy! v6 1 '#(55 66 77 88) 0 2) (void)))
(test-assert (equal? v6 '#(11 55 66)))

(test-assert (equal? (vector-copy v6) v6))
(test-assert (equal? (vector-copy v6 1) '#(55 66)))
(test-assert (equal? (vector-copy v6 1 2) '#(55)))

(test-assert (equal? (vector-reverse-copy v6) '#(66 55 11)))
(test-assert (equal? (vector-reverse-copy v6 1) '#(66 55)))
(test-assert (equal? (vector-reverse-copy v6 1 2) '#(55)))

(test-assert (not  (vector-empty? '#(0 1 2))))
(test-assert (vector-empty? '#()))

; NEWS

(test-assert (eq? (vector-unfold! (lambda (i) i) v10 0 4) (void))
(test-assert (equal? v10 #(0 1 2 3))))

(test-assert (eq? (vector-unfold! (lambda (i x y) (values (* x y) (+ 1 x) (+ 1 y))) v10 0 4 0 0) (void))
(test-assert (equal? v10 #(0 1 4 9))))

(test-assert (eq? (vector-unfold-right! (lambda (i) i) v10 0 4) (void))
(test-assert (equal? v10 #(0 1 2 3))))

(test-assert (eq? (vector-unfold-right! (lambda (i x y) (values (* x y) (+ 1 x) (+ 1 y))) v10 0 4 0 0) (void))
(test-assert (equal? v10 #(9 4 1 0))))

(test-assert (equal? (vector-unfold values 3) #(0 1 2)))
(test-assert (equal? (vector-unfold (lambda (i x) (values x (- x 1))) 5 0) #(0 -1 -2 -3 -4)))
(test-assert (equal? (vector-unfold (lambda (i a b) (values (+ i a b) (- a 1) (+ b 1))) 5 10 0) #(10 11 12 13 14)))

(test-assert (equal? (vector-unfold-right (lambda (i) i) 4) #(0 1 2 3)))
(test-assert (equal? (vector-unfold-right (lambda (i x) (values (vector-ref #(0 1 2) x) (+ x 1))) 3 0) #(2 1 0)))
(test-assert (equal? (vector-unfold-right (lambda (i a b c)(values (* a b c) (+ a 1) (+ b 1) (+ c 1))) 4 1 1 1) #(64 27 8 1)))

(test-assert (equal? (vector-reverse-copy v10) #(0 1 4 9)))
(test-assert (equal? (vector-reverse-copy v10 2) #(0 1)))
(test-assert (equal? (vector-reverse-copy v10 1 3) #(1 4)))

(test-assert (vector-empty? #()))
(test-assert (not (vector-empty? #(0))))
(test-assert (not (vector-empty? #(0 1 2))))

(test-assert (vector= = #(0)))
(test-assert (vector= = #() #()))
(test-assert (vector= = #(0 1 2) #(0 1 2)))
(test-assert (not (vector= = #(0 1 2) #(0 2 2))))
(test-assert (vector= (lambda expr (apply vector= = expr)) #(#(0 1 2) #(2 3 4)) #(#(0 1 2) #(2 3 4)) #(#(0 1 2) #(2 3 4))))

(test-assert (= (vector-fold (lambda (state x) (+ (* state 2) x)) 0 #(1 2 3)) 11))
(test-assert (= (vector-fold (lambda (state v p) (+ state (* v p))) 0 #(1 2 3) #(.25 .5 .25)) 2.))

(test-assert (equal? (vector-map (lambda (x) (* x x)) #(1 2 3)) #(1 4 9)))
(test-assert (equal? (vector-map (lambda (x y) (* x y)) #(1 2 3) #(1 2 3)) #(1 4 9)))

(test-assert (equal? (vector-map! (lambda (x) (* x x)) v10) #(81 16 1 0)))
(test-assert (equal? v10 #(81 16 1 0)))

(test-assert (equal? (vector-map! (lambda (x y) (round (/ x y))) v10 #(3 2 1 1)) #(27 8 1 0)))
(test-assert (equal? v10 #(27 8 1 0)))

(test-assert (eq? (vector-for-each (lambda (x y) (vector-set! v9 (modulo y 2) x)) v10 #(0 1 2 3)) (void)))
(test-assert (equal? v9 #(1 0)))

(test-assert (eq? (vector-for-each (lambda (x) (if (= x 8) (set! bool #t))) v10) (void)))
(test-assert (eq? bool #t))

(test-assert (= (vector-count (lambda (x) (even? x)) #()) 0))
(test-assert (= (vector-count (lambda (x) (even? x)) #(0 1 2 3 4 5)) 3))
(test-assert (= (vector-count (lambda (x y) (= (* 2 x) y)) #(0 1 2 3) #(0 1 2 3)) 1))

;(test-assert (= (vector-index even? #(1 2 3 4)) 1))
;(test-assert (eq? (vector-index even? #(1 3 5 7)) #f))

(test-assert (= (vector-index-right even? #(1 2 3 4)) 3))
(test-assert (eq? (vector-index-right even? #(1 3 5 7)) #f))

(test-assert (= (vector-skip odd? #(1 2 3 4)) 1))
(test-assert (eq? (vector-skip odd? #(1 3 5 7)) #f))

(test-assert (= (vector-skip-right odd? #(1 2 3 4)) 3))
(test-assert (eq? (vector-skip-right odd? #(1 3 5 7)) #f))

(test-assert (= (vector-binary-search #(1 2 3 4) 1 (lambda (x y) (cond ((= x y) 0) ((< x y) -1) (else 1)))) 0))
(test-assert (not (vector-binary-search #(1 2 3 4) 1 (lambda (x y) (cond ((= x y) 0) ((< x y) -1) (else 1))) 2)))
(test-assert (not (vector-binary-search #(1 2 3 4) 4 (lambda (x y) (cond ((= x y) 0) ((< x y) -1) (else 1))) 2 3)))

(test-assert (= (vector-binary-search #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16) 16 (lambda (x y) (set! int (+ int 1)) (cond ((= x y) 0) ((< x y) -1) (else 1))))) 15)
(test-assert (<= int 15)) ; (11 + 4)

(test-assert (vector-any even? #(1 3 5 2 7)))
(test-assert (not (vector-any eq? #(1 3 5) #(2 4 6))))
(test-assert (vector-any eq? #(1 3 #f 5) #(2 4 #f 6)))

(test-assert (vector-every odd? #(1 3 5 7)))
(test-assert (vector-every eq? #(1 3 5) #(1 3 5)))
(test-assert (not (vector-every eq? #(1 3 #f 5) #(2 4 #f 6))))

(test-assert (equal? (vector-swap! v10 0 1) #(8 27 1 0)))
(test-assert (equal? v10 #(8 27 1 0)))
(test-assert (equal? (vector-swap! v10 2 2) #(8 27 1 0)))
(test-assert (equal? v10 #(8 27 1 0)))

(test-assert (eq? (vector-reverse! v10) (void)))
(test-assert (equal? v10 #(0 1 27 8)))
(test-assert (eq? (vector-reverse! v10 1) (void)))
(test-assert (equal? v10 #(0 8 27 1)))
(test-assert (eq? (vector-reverse! v10 0 0) (void)))
(test-assert (equal? v10 #(0 8 27 1)))

(test-assert (eq? (vector-copy! v10 0 #(11 22 33 44)) (void)))
(test-assert (equal? v10 #(11 22 33 44)))

(test-assert (eq? (vector-copy! v10 0 #(1 2 3 4) 1) (void)))
(test-assert (equal? v10 #(2 3 4 44)))

(test-assert (eq? (vector-copy! v10 1 #(111 222 333 444) 1 3) (void)))
(test-assert (equal? v10 #(2 222 333 44)))

(test-assert (eq? (vector-reverse-copy! v10 0 #(0 1 2 3)) (void)))
(test-assert (equal? v10 #(3 2 1 0)))

(test-assert (eq? (vector-reverse-copy! v10 0 #(11 22 33 44) 1) (void)))
(test-assert (equal? v10 #(44 33 22 0)))

(test-assert (eq? (vector-reverse-copy! v10 1 #(111 222 333 444) 1 3) (void)))
(test-assert (equal? v10 #(44 333 222 0)))

(test-assert (equal? '(0 1 2 3) (vector->list #(0 1 2 3))))
(test-assert (equal? '(1 2) (vector->list #(0 1 2 3) 1 3)))

(test-assert (equal? '(0 1 2) (reverse-vector->list #(2 1 0))))
(test-assert (equal? '(1 2) (reverse-vector->list #(3 2 1 0) 1 3)))

(test-assert (equal? (list->vector '()) #()))
(test-assert (equal? (list->vector '(0 1)) #(0 1)))

(test-assert (equal? (reverse-list->vector '()) #()))
(test-assert (equal? (reverse-list->vector '(0 1 2)) #(2 1 0)))

(test-assert (equal? (vector-cumulate + 0 #(1 1 1 1)) #(1 2 3 4)))

(test-assert (equal? (vector-cumulate (lambda (a x) (if (even? a) (/ a 2) (+ (* 3 a) 1))) 5 #(0 0 0 0 0)) #(16 8 4 2 1)))

(receive (pvect i) (vector-partition even? #()) 
  (test-assert (equal? pvect #())) 
  (test-assert (= i 0)))

(receive (pvect i) (vector-partition even? #(0 1 2 3 4 5 6))
  (test-assert (equal? pvect #(0 2 4 6 1 3 5)))
  (test-assert (= i 4)))

(receive (pvect i) (vector-partition (lambda (x) #f) #(0 1 2 3 4 5 6))
  (test-assert (equal? pvect #(0 1 2 3 4 5 6)))
  (test-assert (= i 0)))

(receive (pvect i) (vector-partition (lambda (x) #t) #(0 1 2 3 4 5 6))
  (test-assert (equal? pvect #(0 1 2 3 4 5 6)))
  (test-assert (= i (vector-length #(0 1 2 3 4 5 6)))))

(test-assert (equal? (vector->string #(#\a #\b #\c #\d)) "abcd"))
(test-assert (equal? (vector->string #(#\a #\b #\c #\d) 1) "bcd"))
(test-assert (equal? (vector->string #(#\a #\b #\c #\d) 1 3) "bc"))

(test-assert (equal? (string->vector "abcd") #(#\a #\b #\c #\d)))
(test-assert (equal? (string->vector "abcd" 1) #(#\b #\c #\d)))
(test-assert (equal? (string->vector "abcd" 1 3) #(#\b #\c)))


(test-error type-exception? (make-vector bool))
(test-error type-exception? (make-vector bool 11))
(test-error range-exception? (make-vector -1 0))
(test-error range-exception? (make-vector (expt 2 64)))

(test-error type-exception? (vector-length bool))

(test-error type-exception? (vector->list bool))

(test-error type-exception? (list->vector bool))

(test-error type-exception? (vector-append bool))
(test-error type-exception? (vector-append bool v9))
(test-error type-exception? (vector-append v9 bool))

(test-error type-exception? (append-vectors bool))
(test-error type-exception? (append-vectors '(1 2 3)))
(test-error type-exception? (append-vectors (list v9 v9) bool))

(test-error type-exception? (vector-copy bool))
(test-error type-exception? (vector-copy v9 bool))
(test-error type-exception? (vector-copy v9 0 bool))

(test-error type-exception? (subvector bool 0 0))
(test-error type-exception? (subvector v9 bool 0))
(test-error type-exception? (subvector v9 0 bool))
(test-error range-exception? (subvector v9 -1 0))
(test-error range-exception? (subvector v9 3 0))
(test-error range-exception? (subvector v9 0 -1))
(test-error range-exception? (subvector v9 0 3))

(test-error type-exception? (vector-ref bool 0))
(test-error type-exception? (vector-ref v5 bool))
(test-error range-exception? (vector-ref v5 -1))
(test-error range-exception? (vector-ref v5 2))

(test-error type-exception? (vector-set bool 0 11))
(test-error type-exception? (vector-set v5 bool 11))
(test-error range-exception? (vector-set v5 -1 0))
(test-error range-exception? (vector-set v5 2 0))

(test-error type-exception? (vector-set! bool 0 11))
(test-error type-exception? (vector-set! v5 bool 11))
(test-error range-exception? (vector-set! v5 -1 0))
(test-error range-exception? (vector-set! v5 2 0))

(test-error type-exception? (vector-shrink! bool 0))
(test-error type-exception? (vector-shrink! v5 bool))
(test-error range-exception? (vector-shrink! v5 3))

(test-error type-exception? (vector-fill! bool 0))
(test-error type-exception? (vector-fill! v5 0 bool))
(test-error type-exception? (vector-fill! v5 0 0 bool))

(test-error type-exception? (subvector-fill! bool 0 0 0))
(test-error type-exception? (subvector-fill! v5 bool 0 0))
(test-error type-exception? (subvector-fill! v5 0 bool 0))

(test-error range-exception? (subvector-fill! v5 -1 0 0))
(test-error range-exception? (subvector-fill! v5 3 0 0))
(test-error range-exception? (subvector-fill! v5 0 -1 0))
(test-error range-exception? (subvector-fill! v5 0 3 0))

(test-error type-exception? (subvector-move! bool 0 0 v5 0))
(test-error type-exception? (subvector-move! v5 bool 0 v5 0))
(test-error type-exception? (subvector-move! v5 0 bool v5 0))
(test-error type-exception? (subvector-move! v5 0 0 bool 0))
(test-error type-exception? (subvector-move! v5 0 0 v5 bool))
(test-error range-exception? (subvector-move! v5 -1 0 v5 0))
(test-error range-exception? (subvector-move! v5 3 0 v5 0))
(test-error range-exception? (subvector-move! v5 0 -1 v5 0))
(test-error range-exception? (subvector-move! v5 0 3 v5 0))
(test-error range-exception? (subvector-move! v5 0 0 v5 -1))
(test-error range-exception? (subvector-move! v5 0 0 v5 3))

(test-error type-exception? (vector-copy! v5 0 bool 0 0))
(test-error type-exception? (vector-copy! v5 0 v5 bool 0))
(test-error type-exception? (vector-copy! v5 0 v5 0 bool))
(test-error type-exception? (vector-copy! bool 0 v5 0 0))
(test-error type-exception? (vector-copy! v5 bool v5 0 0))
(test-error range-exception? (vector-copy! v5 0 v5 -1 0))
(test-error range-exception? (vector-copy! v5 0 v5 3 0))
(test-error range-exception? (vector-copy! v5 0 v5 0 -1))
(test-error range-exception? (vector-copy! v5 0 v5 0 3))
(test-error range-exception? (vector-copy! v5 -1 v5 0 0))
(test-error range-exception? (vector-copy! v5 3 v5 0 0))

(test-error type-exception? (vector-cas! 0 0 0 0))
(test-error type-exception? (vector-cas! #(0) #f 0 0))
(test-error range-exception? (vector-cas! #(0 1) -1 0 0))
(test-error range-exception? (vector-cas! #(0 1) 3 0 0))

(test-error type-exception? (vector-inc! 0 0))
(test-error type-exception? (vector-inc! #(0) #f))
(test-error range-exception? (vector-inc! #(0 1) -1))
(test-error range-exception? (vector-inc! #(0 1) 3))

(test-error type-exception? (vector-unfold! 0 #() 0 1))
(test-error type-exception? (vector-unfold! + 0 0 1))
(test-error type-exception? (vector-unfold! + #() #f 1))
(test-error type-exception? (vector-unfold! + #() 0 #f))
(test-error range-exception? (vector-unfold! + #(0 1) -1 1))
(test-error range-exception? (vector-unfold! + #(0 1) 1 0))

(test-error type-exception? (vector-unfold-right! 0 #() 0 1))
(test-error type-exception? (vector-unfold-right! + 0 0 1))
(test-error type-exception? (vector-unfold-right! + #() #f 1))
(test-error type-exception? (vector-unfold-right! + #() 0 #f))
(test-error range-exception? (vector-unfold-right! + #(0 1) -1 1))
(test-error range-exception? (vector-unfold-right! + #(0 1) 1 0))

(test-error type-exception? (vector-unfold 0 0 0))
(test-error type-exception? (vector-unfold + #f 0))

(test-error type-exception? (vector-unfold-right 0 0))
(test-error type-exception? (vector-unfold-right + #f 0))

(test-error type-exception? (vector-reverse-copy 0))
(test-error type-exception? (vector-reverse-copy #(0) #f))
(test-error type-exception? (vector-reverse-copy #(0) 0 #f))

(test-error type-exception? (vector-empty? 0))

(test-error type-exception? (vector= 0))
(test-error type-exception? (vector= + 0))
(test-error type-exception? (vector= + #() 0))

(test-error type-exception? (vector-fold 0 0 #()))
(test-error type-exception? (vector-fold + 0 0))
(test-error type-exception? (vector-fold + 0 #() 0))

(test-error type-exception? (vector-map 0 #()))
(test-error type-exception? (vector-map + 0))
(test-error type-exception? (vector-map + #() 0))

(test-error type-exception? (vector-map! 0 #()))
(test-error type-exception? (vector-map! + 0))
(test-error type-exception? (vector-map! + #() 0))

(test-error type-exception? (vector-for-each 0 #()))
(test-error type-exception? (vector-for-each + 0))
(test-error type-exception? (vector-for-each + #() 0))

(test-error type-exception? (vector-count 0 #()))
(test-error type-exception? (vector-count + 0))
(test-error type-exception? (vector-count + #() 0))

(test-error type-exception? (vector-index 0 #()))
(test-error type-exception? (vector-index + 0))
(test-error type-exception? (vector-index + #() 0))

(test-error type-exception? (vector-index-right 0 #()))
(test-error type-exception? (vector-index-right + 0))
(test-error type-exception? (vector-index-right + #() 0))

(test-error type-exception? (vector-skip 0 #()))
(test-error type-exception? (vector-skip + 0))
(test-error type-exception? (vector-skip + #() 0))

(test-error type-exception? (vector-skip-right 0 #()))
(test-error type-exception? (vector-skip-right + 0))
(test-error type-exception? (vector-skip-right + #() 0))

(test-error type-exception? (vector-binary-search 0 0 +))
(test-error type-exception? (vector-binary-search #() 0 0))

(test-error type-exception? (vector-any 0 #()))
(test-error type-exception? (vector-any + 0))
(test-error type-exception? (vector-any + #() 0))

(test-error type-exception? (vector-every 0 #()))
(test-error type-exception? (vector-every + 0))
(test-error type-exception? (vector-every + #() 0))

(test-error type-exception? (vector-swap! 0 0 0))
(test-error type-exception? (vector-swap! + #f 0))
(test-error type-exception? (vector-swap! + 0 #f))
(test-error range-exception? (vector-swap! #() -1 0))
(test-error range-exception? (vector-swap! #() 0 -1))
(test-error range-exception? (vector-swap! #(0) 2 0))
(test-error range-exception? (vector-swap! #(0) 0 2))

(test-error type-exception? (vector-reverse! 0))
(test-error type-exception? (vector-reverse! #() #f))
(test-error type-exception? (vector-reverse! #() 0 #f))
(test-error range-exception? (vector-reverse! #(0 1) -1 0))
(test-error range-exception? (vector-reverse! #(0 1) 0 -1))
(test-error range-exception? (vector-reverse! #(0 1) 3 0))
(test-error range-exception? (vector-reverse! #(0 1) 0 3))
(test-error range-exception? (vector-reverse! #(0 1) 1 0))

(test-error type-exception? (vector-copy! 0 0 #()))
(test-error type-exception? (vector-copy! #() #f #()))
(test-error type-exception? (vector-copy! #() 0 0))
(test-error type-exception? (vector-copy! #() 0 #() #f))
(test-error type-exception? (vector-copy! #() 0 #() 0 #f))
(test-error range-exception? (vector-copy! #(0 1) 1 #(0 1)))
(test-error range-exception? (vector-copy! #(0 1) 0 #(0 1) 1 3))
(test-error range-exception? (vector-copy! #(0 1) 0 #(0 1) 3 4))
(test-error range-exception? (vector-copy! #(0 1) 0 #(0 1) 1 0))

(test-error type-exception? (vector-reverse-copy! 0 0 #()))
(test-error type-exception? (vector-reverse-copy! #() #f #()))
(test-error type-exception? (vector-reverse-copy! #() 0 0))
(test-error type-exception? (vector-reverse-copy! #() 0 #() #f))
(test-error type-exception? (vector-reverse-copy! #() 0 #() 0 #f))
(test-error range-exception? (vector-reverse-copy! #(0 1) -1 #(0 1)))
(test-error range-exception? (vector-reverse-copy! #(0 1) 3 #(0 1)))
(test-error range-exception? (vector-reverse-copy! #(0 1) 0 #(0 1) 1 3))
(test-error range-exception? (vector-reverse-copy! #(0 1) 0 #(0 1) 3 4))
(test-error range-exception? (vector-reverse-copy! #(0 1) 0 #(0 1) 1 0))

(test-error type-exception? (vector->list 0))
(test-error type-exception? (vector->list #() #f))
(test-error type-exception? (vector->list #() 0 #f))
(test-error range-exception? (vector->list #(0 1) -1))
(test-error range-exception? (vector->list #(0 1) 0 -1))
(test-error range-exception? (vector->list #(0) 2 2))
(test-error range-exception? (vector->list #(0) 0 2))
(test-error range-exception? (vector->list #(0 1 3) 2 1))

(test-error type-exception? (reverse-vector->list 0))
(test-error type-exception? (reverse-vector->list #() #f))
(test-error type-exception? (reverse-vector->list #() 0 #f))
(test-error range-exception? (reverse-vector->list #(0 1) -1))
(test-error range-exception? (reverse-vector->list #(0 1) 0 -1))
(test-error range-exception? (reverse-vector->list #(0 1) 3))
(test-error range-exception? (reverse-vector->list #(0 1 2) 2 1))
(test-error range-exception? (reverse-vector->list #(0 1 3) 2 1))

(test-error type-exception? (list->vector 0))

(test-error type-exception? (reverse-list->vector 0))

(test-error type-exception? (vector-cumulate 0 0 #()))

(test-error type-exception? (vector-partition 0 #()))
(test-error type-exception? (vector-partition + 0))

(test-error type-exception? (vector->string 0))
(test-error type-exception? (vector->string #() #f))
(test-error type-exception? (vector->string #() 0 #f))
(test-error range-exception? (vector->string #(#\a #\b #\c) -1 1)) 
(test-error range-exception? (vector->string #(#\a #\b #\c) 2 1))

(test-error type-exception? (string->vector 0))
(test-error type-exception? (string->vector "" #f))
(test-error type-exception? (string->vector "" 0 #f))
(test-error range-exception? (string->vector "abc" -1 1))
(test-error range-exception? (string->vector "abc" 2 1))


(test-error-tail wrong-number-of-arguments-exception? (make-vector))
(test-error-tail wrong-number-of-arguments-exception? (make-vector 11 22 33))

(test-error-tail wrong-number-of-arguments-exception? (vector?))
(test-error-tail wrong-number-of-arguments-exception? (vector? bool bool))

(test-error-tail wrong-number-of-arguments-exception? (vector-length))
(test-error-tail wrong-number-of-arguments-exception? (vector-length bool bool))

(test-error-tail wrong-number-of-arguments-exception? (vector->list))
(test-error-tail wrong-number-of-arguments-exception? (vector->list v1 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (list->vector))
(test-error-tail wrong-number-of-arguments-exception? (list->vector '() '()))

(test-error-tail wrong-number-of-arguments-exception? (append-vectors))
(test-error-tail wrong-number-of-arguments-exception? (append-vectors '() '() '()))

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

(test-error-tail wrong-number-of-arguments-exception? (vector-shrink!))
(test-error-tail wrong-number-of-arguments-exception? (vector-shrink! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-shrink! v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (vector-fill! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subvector-fill!))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9 0 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-fill! v9 0 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (subvector-move!))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0 0))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0 0 v9))
(test-error-tail wrong-number-of-arguments-exception? (subvector-move! v9 0 0 v9 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-copy!))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! v9))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! v9 0))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! v9 0 v9 0 0 0))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold! 1 2 3))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold-right! 1 2 3))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold-right 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-reverse-copy))
(test-error-tail wrong-number-of-arguments-exception? (vector-reverse-copy 1 2 3 4 5))

(test-error-tail wrong-number-of-arguments-exception? (vector-empty?))
(test-error-tail wrong-number-of-arguments-exception? (vector-empty? 1 2))

(test-error-tail wrong-number-of-arguments-exception? (vector=))

(test-error-tail wrong-number-of-arguments-exception? (vector-fold 1 2))

(test-error-tail wrong-number-of-arguments-exception? (vector-map 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-map! 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-for-each 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-count 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-index 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-index-right 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-skip 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-skip-right 1))
                                       
(test-error-tail wrong-number-of-arguments-exception? (vector-binary-search 1 2))
(test-error-tail wrong-number-of-arguments-exception? (vector-binary-search 1 2 3 4 5 6))
(test-error-tail wrong-number-of-arguments-exception? (vector-any 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-every 1))

(test-error-tail wrong-number-of-arguments-exception? (vector-swap! 1 2))

(test-error-tail wrong-number-of-arguments-exception? (vector-reverse!))
(test-error-tail wrong-number-of-arguments-exception? (vector-reverse!))
(test-error-tail wrong-number-of-arguments-exception? (vector-reverse! 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (vector-copy! 1 2))
(test-error-tail wrong-number-of-arguments-exception? (vector-copy! 1 2 3 4 5 6))

(test-error-tail wrong-number-of-arguments-exception? (vector-reverse-copy! 1 2))
(test-error-tail wrong-number-of-arguments-exception? (vector-reverse-copy! 1 2 3 4 5 6))

(test-error-tail wrong-number-of-arguments-exception? (vector->list))
(test-error-tail wrong-number-of-arguments-exception? (vector->list 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (reverse-vector->list))
(test-error-tail wrong-number-of-arguments-exception? (reverse-vector->list 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (list->vector))
(test-error-tail wrong-number-of-arguments-exception? (list->vector 1 2))

(test-error-tail wrong-number-of-arguments-exception? (reverse-list->vector))
(test-error-tail wrong-number-of-arguments-exception? (reverse-list->vector 1 2))

(test-error-tail wrong-number-of-arguments-exception? (vector-cumulate 1 2))
(test-error-tail wrong-number-of-arguments-exception? (vector-cumulate 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (vector-partition 1))
(test-error-tail wrong-number-of-arguments-exception? (vector-partition 1 2 3))

(test-error-tail wrong-number-of-arguments-exception? (vector->string))
(test-error-tail wrong-number-of-arguments-exception? (vector->string 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (string->vector))
(test-error-tail wrong-number-of-arguments-exception? (string->vector 1 2 3 4))

;;;;============================================================================
