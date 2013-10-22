(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##string #\a #\b #\c))
(define s2 (##make-string 10 #\!))

(define (test s n)
  (println (##eq? s (##string-shrink! s n)))
  (println (##string-length s)))

(test s1 1)
(test s2 5)
