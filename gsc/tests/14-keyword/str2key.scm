(declare (extended-bindings) (not constant-fold) (not safe))

(define k1 'hello:)
(define k2 '||:)
(define k3 '|a b c|:)

(define (test x)
  (let ((k (##string->keyword x)))
    (println k)
    (println (##keyword? k))
    (println (##eq? k k1))
    (println (##eq? k k2))
    (println (##eq? k k3))))

(test "hello")
(test "")
(test "a b c")
