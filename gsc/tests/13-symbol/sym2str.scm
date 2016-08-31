(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 'hello)
(define s2 '||)
(define s3 '|a b c|)

(define (test x)
  (let ((s (##symbol->string x)))
    (println s)
    (println (##string? s))))

(test s1)
(test s2)
(test s3)
