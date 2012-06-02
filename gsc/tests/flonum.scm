(declare (extended-bindings))

(define (test x)
  (println (##flonum? x))
  (println (if (##flonum? x) "yes" "no")))

(test #t)
(test #f)
(test 0)
(test 1)
(test "")
