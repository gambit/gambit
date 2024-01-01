(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define (inc x) (+ x 1))
(define (add x y) (+ x y))

(check-equal? (map inc lst0) '())
(check-equal? (map inc lst1) '(12))
(check-equal? (map inc lst2) '(12 23))

(check-equal? (map add lst0 '()) '())
(check-equal? (map add lst1 '(1)) '(12))
(check-equal? (map add lst2 '(1 2)) '(12 24))

;; these checks verify that lists of different lengths can be used
(check-equal? (map add lst2 '(1)) '(12))
(check-equal? (map add '(1) lst2) '(12))
(check-equal? (map add lst2 '()) '())
(check-equal? (map add '() lst2) '())

(check-equal? (map list lst0 lst0 '()) '())
(check-equal? (map list lst1 lst1 '(1)) '((11 11 1)))
(check-equal? (map list lst2 lst2 '(1 2)) '((11 11 1) (22 22 2)))
(check-equal? (map list lst2 lst2 '(1 2)) '((11 11 1) (22 22 2)))

;; these checks verify that lists of different lengths can be used
(check-equal? (map list lst2 lst2 '(1)) '((11 11 1)))
(check-equal? (map list lst2 '(1) lst2) '((11 1 11)))
(check-equal? (map list '(1) lst2 lst2) '((1 11 11)))
(check-equal? (map list lst2 lst2 '()) '())
(check-equal? (map list lst2 '() lst2) '())
(check-equal? (map list '() lst2 lst2) '())

(let* ((nums (iota 20))
       (counter 0)
       (cont list)
       (proc
        (lambda (x)
          (call-with-current-continuation
           (lambda (c)
             (set! counter (+ counter 1))
             (if (= counter 5) (set! cont c))))
          (* x x))))
  (let ((x (map proc nums)))
    (check-equal? x '(0 1 4 9 16 25 36 49 64 81 100 121 144 169 196 225 256 289 324 361))
    (if (< counter 30) (cont #f))))

(check-tail-exn type-exception? (lambda () (map #f lst0)))
(check-tail-exn type-exception? (lambda () (map inc #f)))
(check-tail-exn type-exception? (lambda () (map inc '(1 2 . #f))))
(check-tail-exn type-exception? (lambda () (map add '(1 2) #f)))
(check-tail-exn type-exception? (lambda () (map add '(1 2) '(3 4 . #f))))
(check-tail-exn type-exception? (lambda () (map add #f '(1 2))))
(check-tail-exn type-exception? (lambda () (map add '(3 4 . #f) '(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (map)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (map inc)))
