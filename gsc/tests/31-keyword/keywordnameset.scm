(declare (extended-bindings) (not constant-fold) (not safe))

(define a keyword1:)
(define b keyword2:)
(define c (##make-uninterned-keyword "uninterned" 80))

(define (test x name)
  (println (##keyword-name x))
  (##keyword-name-set! x name)
  (println (##keyword-name x)))

(test a "keyworda")
(test b "keywordb")
(test c "keywordc")
