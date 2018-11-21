(include "#.scm")

(define bool #f)

(define str0 "")
(define str1 "1")
(define str2 (string #\1 #\2))

(define res '())

(define (one x) (set! res (cons x res)))
(define (two x y) (set! res (cons (list x y) res)))
(define (three x y z) (set! res (cons (list x y z) res)))

(set! res '())
(check-eq? (string-for-each one str0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each one str1) (void))
(check-equal? res '(#\1))

(set! res '())
(check-eq? (string-for-each one str2) (void))
(check-equal? res '(#\2 #\1))

(set! res '())
(check-eq? (string-for-each two str0 str0) (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each two str1 "A") (void))
(check-equal? res '((#\1 #\A)))

(set! res '())
(check-eq? (string-for-each two str2 "AB") (void))
(check-equal? res '((#\2 #\B) (#\1 #\A)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (string-for-each two str2 "A") (void))
(check-equal? res '((#\1 #\A)))

(set! res '())
(check-eq? (string-for-each two "A" str2) (void))
(check-equal? res '((#\A #\1)))

(set! res '())
(check-eq? (string-for-each two str2 "") (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each two "" str2) (void))
(check-equal? res '())


(set! res '())
(check-eq? (string-for-each three str0 str0 "") (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each three str1 str1 "A") (void))
(check-equal? res '((#\1 #\1 #\A)))

(set! res '())
(check-eq? (string-for-each three str2 str2 "AB") (void))
(check-equal? res '((#\2 #\2 #\B) (#\1 #\1 #\A)))


;; these checks verify that lists of different lengths can be used

(set! res '())
(check-eq? (string-for-each three str2 str2 "A") (void))
(check-equal? res '((#\1 #\1 #\A)))

(set! res '())
(check-eq? (string-for-each three str2 "A" str2) (void))
(check-equal? res '((#\1 #\A #\1)))

(set! res '())
(check-eq? (string-for-each three "A" str2 str2) (void))
(check-equal? res '((#\A #\1 #\1)))

(set! res '())
(check-eq? (string-for-each three str2 str2 "") (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each three str2 "" str2) (void))
(check-equal? res '())

(set! res '())
(check-eq? (string-for-each three "" str2 str2) (void))
(check-equal? res '())


(check-tail-exn type-exception? (lambda () (string-for-each #f str0)))
(check-tail-exn type-exception? (lambda () (string-for-each one #f)))
(check-tail-exn type-exception? (lambda () (string-for-each two "AB" #f)))
(check-tail-exn type-exception? (lambda () (string-for-each two #f "AB")))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-for-each)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-for-each one)))
