(declare (extended-bindings) (not constant-fold) (not safe))

(println
 (##continuation-capture
  (lambda (k)
    (##fx* 2
           (##continuation-return-no-winding
            k
            100000)))))

(println
 (##continuation-capture
  (lambda (k a)
    (##fx* 2
           (##continuation-return-no-winding
            k
            (##fx+ 100000 a))))
  1))

(println
 (##continuation-capture
  (lambda (k a b)
    (##fx* 2
           (##continuation-return-no-winding
            k
            (##fx+ 100000 (##fx+ a b)))))
  1
  20))

(println
 (##continuation-capture
  (lambda (k a b c)
    (##fx* 2
           (##continuation-return-no-winding
            k
            (##fx+ 100000 (##fx+ a (##fx+ b c))))))
  1
  20
  300))

#|

(println
 (##continuation-capture
  (lambda (k a b c d)
    (##fx* 2
           (##continuation-return-no-winding
            k
            (##fx+ 100000 (##fx+ a (##fx+ b (##fx+ c d)))))))
  1
  20
  300
  4000))

(println
 (##continuation-capture
  (lambda (k a b c d e)
    (##fx* 2
           (##continuation-return-no-winding
            k
            (##fx+ 100000 (##fx+ a (##fx+ b (##fx+ c (##fx+ d e))))))))
  1
  20
  300
  4000
  50000))

|#
