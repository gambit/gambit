(declare (extended-bindings) (not constant-fold) (not safe))

(define a 0)
(define b 536870911)
(define c -536870912)
(define d 1)
(define e -1)
(define f 357913941)

(define (test x)
  (println (##fxlength x)))

(test a)
(test b)
(test c)
(test d)
(test e)
(test f)
