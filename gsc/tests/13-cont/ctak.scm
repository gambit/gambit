(declare (extended-bindings) (not constant-fold) (not safe))

(define (ctak x y z)
  (##continuation-capture
   (lambda (k) (ctak-aux k x y z))))

(define (ctak-aux k x y z)
  (if (##not (##fx< y x))
      (##continuation-return-no-winding k z)
      (ctak-aux
       k
       (##continuation-capture
        (lambda (k) (ctak-aux k (##fx- x 1) y z)))
       (##continuation-capture
        (lambda (k) (ctak-aux k (##fx- y 1) z x)))
       (##continuation-capture
        (lambda (k) (ctak-aux k (##fx- z 1) x y))))))

(println (ctak 18 12 6)) ;; should print 7
