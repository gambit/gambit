(declare (extended-bindings) (not constant-fold) (not safe))

(define a keyword1:)
(define b keyword2:)
(define c (##make-uninterned-keyword "uninterned" 80))

(define (test s)

  ;; Ensures ##keyword-hash returns a fixnum.
  ;; We probably want keyword-hash to box the result instead of ##keyword-hash.
  ; (println (##fixnum? (##keyword-hash s)))

  ;; Ensures ##keyword-hash is only equal for the same keywords. 
  (println (##fx= (##keyword-hash a) (##keyword-hash s))) 
  (println (##fx= (##keyword-hash b) (##keyword-hash s)))
  (println (##fx= (##keyword-hash c) (##keyword-hash s)))
  (println (##fx= 80 (##keyword-hash s))))


(test a)
(test b)
(test c)
(test keyword1:)

