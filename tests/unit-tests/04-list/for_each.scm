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
(test-eq (void) (for-each one lst0))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each one lst1))
(test-equal '(11) res)

(set! res '())
(test-eq (void) (for-each one lst2))
(test-equal '(22 11) res)

(set! res '())
(test-eq (void) (for-each two lst0 lst0))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each two lst1 '(1)))
(test-equal '((11 1)) res)

(set! res '())
(test-eq (void) (for-each two lst2 '(1 2)))
(test-equal '((22 2) (11 1)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (for-each two lst2 '(1)))
(test-equal '((11 1)) res)

(set! res '())
(test-eq (void) (for-each two '(1) lst2))
(test-equal '((1 11)) res)

(set! res '())
(test-eq (void) (for-each two lst2 '()))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each two '() lst2))
(test-equal '() res)


(set! res '())
(test-eq (void) (for-each three lst0 lst0 '()))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each three lst1 lst1 '(1)))
(test-equal '((11 11 1)) res)

(set! res '())
(test-eq (void) (for-each three lst2 lst2 '(1 2)))
(test-equal '((22 22 2) (11 11 1)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (for-each three lst2 lst2 '(1)))
(test-equal '((11 11 1)) res)

(set! res '())
(test-eq (void) (for-each three lst2 '(1) lst2))
(test-equal '((11 1 11)) res)

(set! res '())
(test-eq (void) (for-each three '(1) lst2 lst2))
(test-equal '((1 11 11)) res)

(set! res '())
(test-eq (void) (for-each three lst2 lst2 '()))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each three lst2 '() lst2))
(test-equal '() res)

(set! res '())
(test-eq (void) (for-each three '() lst2 lst2))
(test-equal '() res)


(test-error-tail type-exception? (for-each #f lst0))
(test-error-tail type-exception? (for-each one #f))
(test-error-tail type-exception? (for-each one '(1 2 . #f)))
(test-error-tail type-exception? (for-each two '(1 2) #f))
(test-error-tail type-exception? (for-each two '(1 2) '(3 4 . #f)))
(test-error-tail type-exception? (for-each two #f '(1 2)))
(test-error-tail type-exception? (for-each two '(3 4 . #f) '(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (for-each))
(test-error-tail wrong-number-of-arguments-exception? (for-each one))
