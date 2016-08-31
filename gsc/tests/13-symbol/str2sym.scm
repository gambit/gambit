(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 'hello)
(define s2 '||)
(define s3 '|a b c|)

(define (test x)
  (let ((s (##string->symbol x)))
    (println s)
    (println (##symbol? s))
    (println (##eq? s s1))
    (println (##eq? s s2))
    (println (##eq? s s3))))

(test "hello")
(test "")
(test "a b c")
