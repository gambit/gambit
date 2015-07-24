
;;
;; (##values-ref values-object index)
;; Returns the value inside the values object at the specified index.
;;


(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##values #\a #\b))
(define s2 (##make-values 10 #\!))

(define (test s i)
  (println (##values-ref s i)))

(test s1 0)
(test s1 1)
(test s2 9)
