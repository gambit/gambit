
;;
;; (##values-length values-object)
;; Returns the number of elements in the values object.
;; Number is not necessarily a fixnum (should be boxed correctly by the
;; definition of values-length).
;; 

(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##values 1 2 3 4 5))
(define s2 (##make-values 20 "values"))
(define s3 (##values))

(define (test v)
  (println (##values-length v)))

(test s1)
(test s2)
(test s3)
