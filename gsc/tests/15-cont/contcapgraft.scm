(declare (extended-bindings) (not constant-fold) (not safe))

(define (f0)           100000)
(define (f1 a)         (##fx+ 100000 a))
(define (f2 a b)       (##fx+ 100000 (##fx+ a b)))
(define (f3 a b c)     (##fx+ 100000 (##fx+ a (##fx+ b c))))
(define (f4 a b c d)   (##fx+ 100000 (##fx+ a (##fx+ b (##fx+ c d)))))
(define (f5 a b c d e) (##fx+ 100000 (##fx+ a (##fx+ b (##fx+ c (##fx+ d e))))))

(println
 (##continuation-capture
  (lambda (k)
    (##fx* 2
           (##continuation-graft-no-winding k f0)))))

(println
 (##continuation-capture
  (lambda (k a)
    (##fx* 2
           (##continuation-graft-no-winding k f1 a)))
  1))

(println
 (##continuation-capture
  (lambda (k a b)
    (##fx* 2
           (##continuation-graft-no-winding k f2 a b)))
  1
  20))

(println
 (##continuation-capture
  (lambda (k a b c)
    (##fx* 2
           (##continuation-graft-no-winding k f3 a b c)))
  1
  20
  300))

#|

(println
 (##continuation-capture
  (lambda (k a b c d)
    (##fx* 2
           (##continuation-graft-no-winding k f4 a b c d)))
  1
  20
  300
  4000))

(println
 (##continuation-capture
  (lambda (k a b c d e)
    (##fx* 2
           (##continuation-graft-no-winding k f5 a b c d e)))
  1
  20
  300
  4000
  50000))

|#
