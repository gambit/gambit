(include "#.scm")

(define bool #f)

(test-assert (eq? #t (list= eq?)))
(test-assert (eq? #t (list= eq? '(a))))
(test-assert (eq? #t (list= eq? '(a) '(a))))
(test-assert (eq? #t (list= eq? '(a b) '(a b) '(a b))))
(test-assert (eq? #f (list= eq? '(a) '(b))))
(test-assert (eq? #f (list= = '(1 2) '(1 2 3))))
(test-assert (eq? #f (list= = '(1 2 3) '(1 2))))
(test-assert (eq? #t (list= = '(1 2) '(1 2))))
(test-assert (eq? #t (list= = '() '())))
(test-assert (eq? #f (list= = '(1) '())))

(test-error-tail type-exception? (list= bool))
(test-error-tail type-exception? (list= eq? '(a) bool))
