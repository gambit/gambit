
;;
;; (##values-set! values-object index val)
;; Set the value at specified index of the values object to val.
;;


(declare (extended-bindings) (not constant-fold) (not safe))

(define s (##values 1 2 3 4 5 6))
(define t (##make-values 10 "values"))

(define (test v i s)
  (##values-set! v i s)
  (println (##eq? s (##values-ref v i)))
  (println (##values-ref v i)))

(test s 0 -6)
(test s 5 40)
(test t 0 -6)
(test t 9 9)
