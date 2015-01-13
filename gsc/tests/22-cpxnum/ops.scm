(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##cpxnum-make 11 3))

(println (##cpxnum? 0)) ;; #f
(println (##cpxnum? a)) ;; #t

(println (##cpxnum-real a)) ;; 11
(println (##cpxnum-imag a)) ;; 3
