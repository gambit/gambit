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
(test-eq (void) (string-for-each one str0))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each one str1))
(test-equal '(#\1) res)

(set! res '())
(test-eq (void) (string-for-each one str2))
(test-equal '(#\2 #\1) res)

(set! res '())
(test-eq (void) (string-for-each two str0 str0))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each two str1 "A"))
(test-equal '((#\1 #\A)) res)

(set! res '())
(test-eq (void) (string-for-each two str2 "AB"))
(test-equal '((#\2 #\B) (#\1 #\A)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (string-for-each two str2 "A"))
(test-equal '((#\1 #\A)) res)

(set! res '())
(test-eq (void) (string-for-each two "A" str2))
(test-equal '((#\A #\1)) res)

(set! res '())
(test-eq (void) (string-for-each two str2 ""))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each two "" str2))
(test-equal '() res)


(set! res '())
(test-eq (void) (string-for-each three str0 str0 ""))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each three str1 str1 "A"))
(test-equal '((#\1 #\1 #\A)) res)

(set! res '())
(test-eq (void) (string-for-each three str2 str2 "AB"))
(test-equal '((#\2 #\2 #\B) (#\1 #\1 #\A)) res)


;; these checks verify that lists of different lengths can be used

(set! res '())
(test-eq (void) (string-for-each three str2 str2 "A"))
(test-equal '((#\1 #\1 #\A)) res)

(set! res '())
(test-eq (void) (string-for-each three str2 "A" str2))
(test-equal '((#\1 #\A #\1)) res)

(set! res '())
(test-eq (void) (string-for-each three "A" str2 str2))
(test-equal '((#\A #\1 #\1)) res)

(set! res '())
(test-eq (void) (string-for-each three str2 str2 ""))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each three str2 "" str2))
(test-equal '() res)

(set! res '())
(test-eq (void) (string-for-each three "" str2 str2))
(test-equal '() res)


(test-error-tail type-exception? (string-for-each #f str0))
(test-error-tail type-exception? (string-for-each one #f))
(test-error-tail type-exception? (string-for-each two "AB" #f))
(test-error-tail type-exception? (string-for-each two #f "AB"))

(test-error-tail wrong-number-of-arguments-exception? (string-for-each))
(test-error-tail wrong-number-of-arguments-exception? (string-for-each one))
