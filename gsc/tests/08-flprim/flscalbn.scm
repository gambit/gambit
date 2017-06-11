(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a exp b)
  (let* ((x (##flscalbn a exp))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test  0.0  0   0.0)
(test  1.0  0   1.0)
(test -1.0  0  -1.0)
(test  1.0  1   2.0)
(test  1.0  2   4.0)

(test  10.0 10  10240.0)
(test -10.0 10 -10240.0)

(test 1e-100 60 1.152921504606847e-82)

(let ((max-f64 (##fl* (##flexpt 2.0 1023.0) (##fl- 2.0 (##flexpt 2.0 -52.0))))
      (min-positive-f64 (##flexpt 2.0 -1074.0)))
  (test max-f64 0 max-f64)
  (test max-f64 -1 8.988465674311579e307)
  (println (##fleqv? (##flscalbn max-f64 60) +inf.0))

  (test min-positive-f64 0 min-positive-f64)
  (test min-positive-f64 1 1e-323)
  (println (##fleqv? (##flscalbn min-positive-f64 -1) 0.0))
  (println (##fleqv? (##flscalbn min-positive-f64 1074) 1.0)))

(println (##fleqv? (##flscalbn  0.0 0)  0.0))
(println (##fleqv? (##flscalbn -0.0 0) -0.0))
