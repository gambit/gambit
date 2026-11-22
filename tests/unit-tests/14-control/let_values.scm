(include "#.scm")

(define a 1)
(define b 2)
(define c 3)
(define d 4)
(define e 5)

;;-----------------------------------------------------------------------------

;; test valid cases

(test-equal
 '(1 2)
 (let-values ()
   (list a b)))

(test-equal
 '(1 2)
 (let-values ((()        (values)))
   (list a b)))
(test-equal
 '(3 2)
 (let-values (((a)       (+ a b)))
   (list a b)))

(test-equal
 '(11 22)
 (let-values (((a b)     (values 11 22)))
   (list a b)))

(test-equal
 '(11 22 1 (2))
 (let-values (((a b)     (values 11 22))
              (()        (values))
              ((x y)     (values a (list b))))
   (list a b x y)))

(test-equal
 '(11 22 3 1 (2 3))
 (let-values (((a b)     (values 11 22))
              ((c)       (+ a b))
              ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 3 -1 1 (2 3 4))
 (let-values (((a b)     (values 11 22))
              ((c d)     (values (+ a b) (- a b)))
              ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 () 1 (2 3))
 (let-values (((a b)     (values 11 22))
              (c         (values))
              ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 (3) 1 (2 3))
 (let-values (((a b)     (values 11 22))
              (c         (+ a b))
              ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 (3 -1) 1 (2 3))
 (let-values (((a b)     (values 11 22))
              (c         (values (+ a b) (- a b)))
              ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 3 () 1 (2 3 4))
 (let-values (((a b)     (values 11 22))
              ((c . d)   (+ a b))
              ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 3 (-1) 1 (2 3 4))
 (let-values (((a b)     (values 11 22))
              ((c . d)   (values (+ a b) (- a b)))
              ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 3 (-1 #(1 2)) 1 (2 3 4))
 (let-values (((a b)     (values 11 22))
              ((c . d)   (values (+ a b) (- a b) (vector a b)))
              ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 3 -1 () 1 (2 3 4 5))
 (let-values (((a b)     (values 11 22))
              ((c d . e) (values (+ a b) (- a b)))
              ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

(test-equal
 '(11 22 3 -1 (#(1 2)) 1 (2 3 4 5))
 (let-values (((a b)     (values 11 22))
              ((c d . e) (values (+ a b) (- a b) (vector a b)))
              ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

(test-equal
 '(11 22 3 -1 (#(1 2) (1 . 2)) 1 (2 3 4 5))
 (let-values (((a b)     (values 11 22))
              ((c d . e) (values (+ a b) (- a b) (vector a b) (cons a b)))
              ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

;; tests that raise wrong-number-of-values exception

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              (()        1111)
              ((x y)     (values 88 99)))
   (list a b x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              (()        (values 1111 2222))
              ((x y)     (values 88 99)))
   (list a b x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c)       (values))
              ((x y)     (values 88 99)))
   (list a b c x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c)       (values 1111 2222))
              ((x y)     (values 88 99)))
   (list a b c x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c d)     (values))
              ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c d)     1111)
              ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c d)     (values 1111 2222 3333))
              ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c . d)   (values))
              ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c d . e) (values))
              ((x y)     (values 88 99)))
   (list a b c d e x y)))

(test-error
 wrong-number-of-values-exception?
 (let-values (((a b)     (values 11 22))
              ((c d . e) 1111)
              ((x y)     (values 88 99)))
   (list a b c d e x y)))

;;-----------------------------------------------------------------------------

;; test valid cases

(test-equal
 '(1 2)
 (let*-values ()
   (list a b)))

(test-equal
 '(1 2)
 (let*-values ((()        (values)))
   (list a b)))

(test-equal
 '(3 2)
 (let*-values (((a)       (+ a b)))
   (list a b)))

(test-equal
 '(11 22)
 (let*-values (((a b)     (values 11 22)))
   (list a b)))

(test-equal
 '(11 22 11 (22))
 (let*-values (((a b)     (values 11 22))
               (()        (values))
               ((x y)     (values a (list b))))
   (list a b x y)))

(test-equal
 '(11 22 33 11 (22 33))
 (let*-values (((a b)     (values 11 22))
               ((c)       (+ a b))
               ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 33 -11 11 (22 33 -11))
 (let*-values (((a b)     (values 11 22))
               ((c d)     (values (+ a b) (- a b)))
               ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 () 11 (22 ()))
 (let*-values (((a b)     (values 11 22))
               (c         (values))
               ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 (33) 11 (22 (33)))
 (let*-values (((a b)     (values 11 22))
               (c         (+ a b))
               ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 (33 -11) 11 (22 (33 -11)))
 (let*-values (((a b)     (values 11 22))
               (c         (values (+ a b) (- a b)))
               ((x y)     (values a (list b c))))
   (list a b c x y)))

(test-equal
 '(11 22 33 () 11 (22 33 ()))
 (let*-values (((a b)     (values 11 22))
               ((c . d)   (+ a b))
               ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 33 (-11) 11 (22 33 (-11)))
 (let*-values (((a b)     (values 11 22))
               ((c . d)   (values (+ a b) (- a b)))
               ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 33 (-11 #(11 22)) 11 (22 33 (-11 #(11 22))))
 (let*-values (((a b)     (values 11 22))
               ((c . d)   (values (+ a b) (- a b) (vector a b)))
               ((x y)     (values a (list b c d))))
   (list a b c d x y)))

(test-equal
 '(11 22 33 -11 () 11 (22 33 -11 ()))
 (let*-values (((a b)     (values 11 22))
               ((c d . e) (values (+ a b) (- a b)))
               ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

(test-equal
 '(11 22 33 -11 (#(11 22)) 11 (22 33 -11 (#(11 22))))
 (let*-values (((a b)     (values 11 22))
               ((c d . e) (values (+ a b) (- a b) (vector a b)))
               ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

(test-equal
 '(11 22 33 -11 (#(11 22) (11 . 22)) 11 (22 33 -11 (#(11 22) (11 . 22))))
 (let*-values (((a b)     (values 11 22))
               ((c d . e) (values (+ a b) (- a b) (vector a b) (cons a b)))
               ((x y)     (values a (list b c d e))))
   (list a b c d e x y)))

;; tests that raise wrong-number-of-values exception

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               (()        1111)
               ((x y)     (values 88 99)))
   (list a b x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               (()        (values 1111 2222))
               ((x y)     (values 88 99)))
   (list a b x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c)       (values))
               ((x y)     (values 88 99)))
   (list a b c x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c)       (values 1111 2222))
               ((x y)     (values 88 99)))
   (list a b c x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c d)     (values))
               ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c d)     1111)
               ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c d)     (values 1111 2222 3333))
               ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c . d)   (values))
               ((x y)     (values 88 99)))
   (list a b c d x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c d . e) (values))
               ((x y)     (values 88 99)))
   (list a b c d e x y)))

(test-error
 wrong-number-of-values-exception?
 (let*-values (((a b)     (values 11 22))
               ((c d . e) 1111)
               ((x y)     (values 88 99)))
   (list a b c d e x y)))

;;-----------------------------------------------------------------------------
