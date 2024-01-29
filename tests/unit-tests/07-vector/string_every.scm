(include "#.scm")

(define bool #f)

(define s0 "")
(define s1 "a")
(define s2 "ab")
(define s3 "abc")

(define S1 "A")
(define S2 "AB")
(define S3 "ABC")

(define (test c1 c2) (and (char<? c1 c2) c2))

(check-equal? (string-every char=? s0 S2) #t)
(check-equal? (string-every char-ci=? s1 S2) #t)
(check-equal? (string-every char=? s1) #t)

(check-equal? (string-every test S2 s2) #\b)
(check-equal? (string-every test s2 S2) #f)

(check-tail-exn type-exception? (lambda () (string-every #f s0)))
(check-tail-exn type-exception? (lambda () (string-every test #f)))
(check-tail-exn type-exception? (lambda () (string-every test "ab" #f)))
(check-tail-exn type-exception? (lambda () (string-every test #f "ab")))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-every)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-every test)))
