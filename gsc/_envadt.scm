;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;;; Environment manipulation

;; structure that represents variables:

(define (make-var

         name   ;; symbol that denotes the variable
         bound  ;; procedure node that binds the variable (#f if global)
         refs   ;; nodes that reference this variable
         sets   ;; nodes that assign a value to this variable
         source ;; source where variable is first encountered
         temp?) ;; is the variable introduced by the compiler?

  (vector var-tag name bound refs sets source #f #f (next-var-stamp) #f #f temp?))

(define (var? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) var-tag)))

(define var-tag (list 'var-tag))

(define (var-name x)            (vector-ref x 1))
(define (var-bound x)           (vector-ref x 2))
(define (var-refs x)            (vector-ref x 3))
(define (var-sets x)            (vector-ref x 4))
(define (var-source x)          (vector-ref x 5))
(define (var-boxed? x)          (vector-ref x 6))
(define (var-info x)            (vector-ref x 7))
(define (var-stamp x)           (vector-ref x 8))
(define (var-constant x)        (vector-ref x 9))
(define (var-clone x)           (vector-ref x 10))
(define (var-temp? x)           (vector-ref x 11))
(define (var-name-set! x y)     (vector-set! x 1 y))
(define (var-bound-set! x y)    (vector-set! x 2 y))
(define (var-refs-set! x y)     (vector-set! x 3 y))
(define (var-sets-set! x y)     (vector-set! x 4 y))
(define (var-source-set! x y)   (vector-set! x 5 y))
(define (var-boxed?-set! x y)   (vector-set! x 6 y))
(define (var-info-set! x y)     (vector-set! x 7 y))
(define (var-stamp-set! x y)    (vector-set! x 8 y))
(define (var-constant-set! x y) (vector-set! x 9 y))
(define (var-clone-set! x y)    (vector-set! x 10 y))
(define (var-temp?-set! x y)    (vector-set! x 11 y))
