(include "#.scm")

(define bool #f)

(define str0 "")
(define str1 "1")
(define str2 (string #\1 #\2))

(define (inc x) (integer->char (+ (char->integer x) 1)))
(define (add x y) (integer->char (+ (char->integer x) (char->integer y))))
(define (f x y z) y)

(check-equal? (string-map inc str0) "")
(check-equal? (string-map inc str1) "2")
(check-equal? (string-map inc str2) "23")

(check-equal? (string-map add str0 "") "")
(check-equal? (string-map add str1 "A") "r")
(check-equal? (string-map add str2 "AB") "rt")

;; these checks verify that strings of different lengths can be used
(check-equal? (string-map add str2 "A") "r")
(check-equal? (string-map add "A" str2) "r")
(check-equal? (string-map add str2 "") "")
(check-equal? (string-map add "" str2) "")

(check-equal? (string-map f str0 str0 "") "")
(check-equal? (string-map f str1 str1 "A") "1")
(check-equal? (string-map f str2 str2 "AB") "12")

;; these checks verify that strings of different lengths can be used
(check-equal? (string-map f str2 str2 "A") "1")
(check-equal? (string-map f str2 "A" str2) "A")
(check-equal? (string-map f "A" str2 str2) "1")
(check-equal? (string-map f str2 str2 "") "")
(check-equal? (string-map f str2 "" str2) "")
(check-equal? (string-map f "" str2 str2) "")

(check-tail-exn type-exception? (lambda () (string-map #f str0)))
(check-tail-exn type-exception? (lambda () (string-map inc #f)))
(check-tail-exn type-exception? (lambda () (string-map add "AB" #f)))
(check-tail-exn type-exception? (lambda () (string-map add #f "AB")))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-map)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-map inc)))
