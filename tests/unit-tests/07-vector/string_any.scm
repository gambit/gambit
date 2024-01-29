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

(check-equal? (string-any char=? s0 S2) #f)
(check-equal? (string-any char-ci=? s1 S2) #t)
(check-equal? (string-any char=? s1) #t)

(check-equal? (string-any test S2 s2) #\a)
(check-equal? (string-any test s2 S2) #f)

(check-tail-exn type-exception? (lambda () (string-any #f s0)))
(check-tail-exn type-exception? (lambda () (string-any test #f)))
(check-tail-exn type-exception? (lambda () (string-any test "ab" #f)))
(check-tail-exn type-exception? (lambda () (string-any test #f "ab")))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-any)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-any test)))
