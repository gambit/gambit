(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define res '())

(define (one x) (set! res (cons x res)))
(define (two x y) (set! res (cons (list x y) res)))
(define (three x y z) (set! res (cons (list x y z) res)))

(set! res '())
(check-eq? (for-each one lst0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each one lst1) (void))
(check-equal? res '(11))

(set! res '())
(check-eq? (for-each one lst2) (void))
(check-equal? res '(22 11))

(set! res '())
(check-eq? (for-each two lst0 lst0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each two lst1 '(1)) (void))
(check-equal? res '((11 1)))

(set! res '())
(check-eq? (for-each two lst2 '(1 2)) (void))
(check-equal? res '((22 2) (11 1)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (for-each two lst2 '(1)) (void))
(check-equal? res '((11 1)))

(set! res '())
(check-eq? (for-each two '(1) lst2) (void))
(check-equal? res '((1 11)))

(set! res '())
(check-eq? (for-each two lst2 '()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each two '() lst2) (void))
(check-equal? res '())


(set! res '())
(check-eq? (for-each three lst0 lst0 '()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each three lst1 lst1 '(1)) (void))
(check-equal? res '((11 11 1)))

(set! res '())
(check-eq? (for-each three lst2 lst2 '(1 2)) (void))
(check-equal? res '((22 22 2) (11 11 1)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (for-each three lst2 lst2 '(1)) (void))
(check-equal? res '((11 11 1)))

(set! res '())
(check-eq? (for-each three lst2 '(1) lst2) (void))
(check-equal? res '((11 1 11)))

(set! res '())
(check-eq? (for-each three '(1) lst2 lst2) (void))
(check-equal? res '((1 11 11)))

(set! res '())
(check-eq? (for-each three lst2 lst2 '()) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each three lst2 '() lst2) (void))
(check-equal? res '())

(set! res '())
(check-eq? (for-each three '() lst2 lst2) (void))
(check-equal? res '())


(check-tail-exn type-exception? (lambda () (for-each #f lst0)))
(check-tail-exn type-exception? (lambda () (for-each one #f)))
(check-tail-exn type-exception? (lambda () (for-each one '(1 2 . #f))))
(check-tail-exn type-exception? (lambda () (for-each two '(1 2) #f)))
(check-tail-exn type-exception? (lambda () (for-each two '(1 2) '(3 4 . #f))))
(check-tail-exn type-exception? (lambda () (for-each two #f '(1 2))))
(check-tail-exn type-exception? (lambda () (for-each two '(3 4 . #f) '(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (for-each)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (for-each one)))
