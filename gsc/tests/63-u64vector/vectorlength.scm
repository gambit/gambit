(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##u64vector 111 18446744073709551615))
(define b (##make-u64vector 10 99))
(define c '#u64(1 2 3 4))

(define (test v)
  (println (##u64vector-length v)))

(test a)
(test b)
(test c)
