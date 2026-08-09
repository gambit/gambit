(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define (inc x) (+ x 1))
(define (add x y) (+ x y))

(test-equal '() (map inc lst0))
(test-equal '(12) (map inc lst1))
(test-equal '(12 23) (map inc lst2))

(test-equal '() (map add lst0 '()))
(test-equal '(12) (map add lst1 '(1)))
(test-equal '(12 24) (map add lst2 '(1 2)))

;; these checks verify that lists of different lengths can be used
(test-equal '(12) (map add lst2 '(1)))
(test-equal '(12) (map add '(1) lst2))
(test-equal '() (map add lst2 '()))
(test-equal '() (map add '() lst2))

(test-equal '() (map list lst0 lst0 '()))
(test-equal '((11 11 1)) (map list lst1 lst1 '(1)))
(test-equal '((11 11 1) (22 22 2)) (map list lst2 lst2 '(1 2)))
(test-equal '((11 11 1) (22 22 2)) (map list lst2 lst2 '(1 2)))

;; these checks verify that lists of different lengths can be used
(test-equal '((11 11 1)) (map list lst2 lst2 '(1)))
(test-equal '((11 1 11)) (map list lst2 '(1) lst2))
(test-equal '((1 11 11)) (map list '(1) lst2 lst2))
(test-equal '() (map list lst2 lst2 '()))
(test-equal '() (map list lst2 '() lst2))
(test-equal '() (map list '() lst2 lst2))

(let* ((nums (iota 20))
       (counter 0)
       (cont list)
       (proc (lambda (x)
               (call-with-current-continuation
                (lambda (c)
                  (set! counter (+ counter 1))
                  (if (= counter 5) (set! cont c))))
               (* x x))))
  (let ((x (map proc nums)))
    (test-equal
     '(0 1 4 9 16 25 36 49 64 81 100 121 144 169 196 225 256 289 324 361)
     x)
    (if (< counter 30) (cont #f))))

(test-error-tail type-exception? (map #f lst0))
(test-error-tail type-exception? (map inc #f))
(test-error-tail type-exception? (map inc '(1 2 . #f)))
(test-error-tail type-exception? (map add '(1 2) #f))
(test-error-tail type-exception? (map add '(1 2) '(3 4 . #f)))
(test-error-tail type-exception? (map add #f '(1 2)))
(test-error-tail type-exception? (map add '(3 4 . #f) '(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (map))
(test-error-tail wrong-number-of-arguments-exception? (map inc))
