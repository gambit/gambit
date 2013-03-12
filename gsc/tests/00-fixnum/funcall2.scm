(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b c d e f g h i j)
  (test2 a c e g i))

(define (test2 a b c d e)
  (println a)
  (println b)
  (println c)
  (println d)
  (println e))


(test 1 2 3 4 5 6 7 8 9 10)
