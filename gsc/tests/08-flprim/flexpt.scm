(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b c)
  (let* ((x (##flexpt a b))
         (c-small (##fl* 0.9999999999999 c))
         (c-large (##fl* 1.0000000000001 c))
         (lo (##flmin c-small c-large))
         (hi (##flmax c-small c-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.0 9.3 0.0)
(test 0.5 2.0 0.25)
(test 5.0 5.2 4311.655192066298)

(test 0.1 2.0 -9.999)
