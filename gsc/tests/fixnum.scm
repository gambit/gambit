(declare (extended-bindings))

(define (test x)
  (println (##fixnum? x))
  (println (if (##fixnum? x) "yes" "no")))

(test #t)
(test #f)
(test 0)
(test 1)
(test "")
