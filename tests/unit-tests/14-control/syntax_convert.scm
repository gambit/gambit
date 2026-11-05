(include "#.scm")

(define syn-list (##make-source '(a b c) #f))
(define syn-vec (##make-source '#(a b) #f))
(define syn-tmpl (##make-source #f #f))

(test-assert (procedure? syntax->datum))
(test-assert (procedure? datum->syntax))
(test-assert (procedure? syntax->list))
(test-assert (procedure? syntax->vector))

(test-equal '(a b c) (syntax->datum syn-list))
(test-equal '(a b c) (map syntax->datum (syntax->list syn-list)))
(test-assert (vector? (syntax->vector syn-vec)))
(test-equal '(x y) (syntax->datum (datum->syntax syn-tmpl '(x y))))
