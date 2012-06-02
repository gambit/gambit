(declare (extended-bindings))

(define str "")
(define fl0 0.0)
(define fl1 1.0)

(define (test x)
  (println (##not x))
  (println (if (##not x) "yes" "no")))

(test #t)
(test #f)
(test 0)
(test 1)
(test str)
(test fl0)
(test fl1)
