(declare (extended-bindings) (not constant-fold) (not safe))

(define a 0.0)
(define b 1.5)
(define c -1.5)

(define (test x)
  (println (##flinfinite? x))
  (println (if (##flinfinite? x) 11 22)))

(test a)
(test b)
(test c)

(test (##fl/ b a)) ;; +inf.0
(test (##fl/ c a)) ;; -inf.0
(test (##fl/ a a)) ;; +nan.0

;; more nans:
(test (##fl+ (##fl/ a a) b))
(test (##fl- (##fl/ a a) b))
(test (##fl* (##fl/ a a) b))
(test (##fl/ (##fl/ a a) b))
(test (##fl+ (##fl/ b a) (##fl/ c a)))
(test (##fl+ (##fl/ b 0.0) (##fl/ b -0.0)))
(test (##fl- (##fl/ b 0.0) (##fl/ b 0.0)))
(test (##fl* (##fl/ b 0.0) a))
