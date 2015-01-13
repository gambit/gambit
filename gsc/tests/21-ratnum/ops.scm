(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##ratnum-make 11 3))

(println (##ratnum? 0)) ;; #f
(println (##ratnum? a)) ;; #t

(println (##ratnum-numerator a)) ;; 11
(println (##ratnum-denominator a)) ;; 3
