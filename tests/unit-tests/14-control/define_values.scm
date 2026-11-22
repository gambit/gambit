(include "#.scm")

(define a 1)
(define b 2)
(define c 3)
(define d 4)
(define e 5)

;;-----------------------------------------------------------------------------

;; test valid cases for global define-values

(define-values () (values))

(define-values (c1) (+ a b))
(test-equal 3 c1)

(define-values (c2 d2) (values (+ a b) (- a b)))
(test-equal 3 c2)
(test-equal -1 d2)

(define-values c3 (values))
(test-equal '() c3)

(define-values c4 (+ a b))
(test-equal '(3) c4)

(define-values c5 (values (+ a b) (- a b)))
(test-equal '(3 -1) c5)

(define-values (c6 . d6) (+ a b))
(test-equal 3 c6)
(test-equal '() d6)

(define-values (c7 . d7) (values (+ a b) (- a b)))
(test-equal 3 c7)
(test-equal '(-1) d7)

(define-values (c8 . d8) (values (+ a b) (- a b) (vector a b)))
(test-equal 3 c8)
(test-equal '(-1 #(1 2)) d8)

(define-values (c9 d9 . e9) (values (+ a b) (- a b)))
(test-equal 3 c9)
(test-equal -1 d9)
(test-equal '() e9)

(define-values (c10 d10 . e10) (values (+ a b) (- a b) (vector a b)))
(test-equal 3 c10)
(test-equal -1 d10)
(test-equal '(#(1 2)) e10)

(define-values (c11 d11 . e11) (values (+ a b) (- a b) (vector a b) (cons a b)))
(test-equal 3 c11)
(test-equal -1 d11)
(test-equal '(#(1 2) (1 . 2)) e11)

(define-values (a12 b12 c12)
  (values 11 (lambda (n) (if (< n 0) n (+ a12 f12 (e12 (- n 1))))) 22))
(define-values (d12 e12 f12)
  (values 111 (lambda (n) (if (< n 0) n (* d12 c12 (b12 (- n 1))))) 222))
(test-equal 11 a12)
(test-equal 22 c12)
(test-equal 111 d12)
(test-equal 222 f12)
(test-equal -2209 (b12 1))
(test-equal 566544 (e12 1))

;; can't test global define-values that raise wrong-number-of-values exception

;;-----------------------------------------------------------------------------

;; test valid cases for internal define-values

(let ()
  (define-values () (values))
  #f)

(let ()
  (define-values (c1) (+ a b))
  (test-equal 3 c1))

(let ()
  (define-values (c2 d2) (values (+ a b) (- a b)))
  (test-equal 3 c2)
  (test-equal -1 d2))

(let ()
  (define-values c3 (values))
  (test-equal '() c3))

(let ()
  (define-values c4 (+ a b))
  (test-equal '(3) c4))

(let ()
  (define-values c5 (values (+ a b) (- a b)))
  (test-equal '(3 -1) c5))

(let ()
  (define-values (c6 . d6) (+ a b))
  (test-equal 3 c6)
  (test-equal '() d6))

(let ()
  (define-values (c7 . d7) (values (+ a b) (- a b)))
  (test-equal 3 c7)
  (test-equal '(-1) d7))

(let ()
  (define-values (c8 . d8) (values (+ a b) (- a b) (vector a b)))
  (test-equal 3 c8)
  (test-equal '(-1 #(1 2)) d8))

(let ()
  (define-values (c9 d9 . e9) (values (+ a b) (- a b)))
  (test-equal 3 c9)
  (test-equal -1 d9)
  (test-equal '() e9))

(let ()
  (define-values (c10 d10 . e10) (values (+ a b) (- a b) (vector a b)))
  (test-equal 3 c10)
  (test-equal -1 d10)
  (test-equal '(#(1 2)) e10))

(let ()
  (define-values (c11 d11 . e11) (values (+ a b) (- a b) (vector a b) (cons a b)))
  (test-equal 3 c11)
  (test-equal -1 d11)
  (test-equal '(#(1 2) (1 . 2)) e11))

(let ()
  (define-values (a12 b12 c12)
    (values 11 (lambda (n) (if (< n 0) n (+ a12 f12 (e12 (- n 1))))) 22))
  (define-values (d12 e12 f12)
    (values 111 (lambda (n) (if (< n 0) n (* d12 c12 (b12 (- n 1))))) 222))
  (test-equal 11 a12)
  (test-equal 22 c12)
  (test-equal 111 d12)
  (test-equal 222 f12)
  (test-equal -2209 (b12 1))
  (test-equal 566544 (e12 1)))

(let ()
  (define-values (a b c)
    (values 11 (lambda () (+ a c)) 22))
  (test-equal 11 a)
  (test-equal 33 (b))
  (test-equal 22 c))

;; tests that raise wrong-number-of-values exception

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values () 1111)
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values () (values 1111 2222))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c) (values))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c) (values 1111 2222))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c d) (values))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c d) 1111)
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c d) (values 1111 2222 3333))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c . d) (values))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c d . e) (values))
   #f))

(test-error
 wrong-number-of-values-exception?
 (let ()
   (define-values (c d . e) 1111)
   #f))

;;-----------------------------------------------------------------------------
