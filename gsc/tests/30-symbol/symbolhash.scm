(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (quote symbol2))
(define c (##make-uninterned-symbol "uninterned" 80))

(define (test s)

  ;; Ensures ##symbol-hash returns a fixnum.
  ;; We probably want symbol-hash to box the result instead of ##symbol-hash.
  ; (println (##fixnum? (##symbol-hash s)))

  ;; Ensures ##symbol-hash is only equal for the same symbols. 
  (println (##fx= (##symbol-hash a) (##symbol-hash s))) 
  (println (##fx= (##symbol-hash b) (##symbol-hash s)))
  (println (##fx= (##symbol-hash c) (##symbol-hash s)))
  (println (##fx= 80 (##symbol-hash s))))


(test a)
(test b)
(test c)
(test 'symbol2)

