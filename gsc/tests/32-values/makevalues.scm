
;;
;; (##make-values default-value size)
;; Returns a values object of the specified size and default value.
;;
;; (##values? values-object)
;; Returns #t for values-object and false otherwise
;; 

(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")
(define x 1.5)
(define y (##make-vector 2 999))
(define w (##make-values 2 999))
(define z (##list 1 2 3))

(define (test x)
  (println (##values? x))
  (println (if (##values? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
(test x)
(test y)
(test z)
(test w)
(test (##cdr z))

(println (##values-ref w 0))
(println (##values-ref w 1))
(##values-set! w 1 888)
(println (##values-ref w 1))
