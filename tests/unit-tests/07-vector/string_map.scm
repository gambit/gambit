(include "#.scm")

(define bool #f)

(define str0 "")
(define str1 "1")
(define str2 (string #\1 #\2))

(define (inc x) (integer->char (+ (char->integer x) 1)))
(define (add x y) (integer->char (+ (char->integer x) (char->integer y))))
(define (f x y z) y)

(test-equal "" (string-map inc str0))
(test-equal "2" (string-map inc str1))
(test-equal "23" (string-map inc str2))

(test-equal "" (string-map add str0 ""))
(test-equal "r" (string-map add str1 "A"))
(test-equal "rt" (string-map add str2 "AB"))

;; these checks verify that strings of different lengths can be used
(test-equal "r" (string-map add str2 "A"))
(test-equal "r" (string-map add "A" str2))
(test-equal "" (string-map add str2 ""))
(test-equal "" (string-map add "" str2))

(test-equal "" (string-map f str0 str0 ""))
(test-equal "1" (string-map f str1 str1 "A"))
(test-equal "12" (string-map f str2 str2 "AB"))

;; these checks verify that strings of different lengths can be used
(test-equal "1" (string-map f str2 str2 "A"))
(test-equal "A" (string-map f str2 "A" str2))
(test-equal "1" (string-map f "A" str2 str2))
(test-equal "" (string-map f str2 str2 ""))
(test-equal "" (string-map f str2 "" str2))
(test-equal "" (string-map f "" str2 str2))

(test-error-tail type-exception? (string-map #f str0))
(test-error-tail type-exception? (string-map inc #f))
(test-error-tail type-exception? (string-map add "AB" #f))
(test-error-tail type-exception? (string-map add #f "AB"))

(test-error-tail wrong-number-of-arguments-exception? (string-map))
(test-error-tail wrong-number-of-arguments-exception? (string-map inc))
