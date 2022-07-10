(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(call-with-values
    (lambda ()
      (split-at lst1 0))
  (lambda (front back)
    (check-equal? front '())
    (check-equal? back '(11 22 33))))

(call-with-values
    (lambda ()
      (split-at lst1 1))
  (lambda (front back)
    (check-equal? front '(11))
    (check-equal? back '(22 33))))

(call-with-values
    (lambda ()
      (split-at lst1 2))
  (lambda (front back)
    (check-equal? front '(11 22))
    (check-equal? back '(33))))

(call-with-values
    (lambda ()
      (split-at lst1 3))
  (lambda (front back)
    (check-equal? front '(11 22 33))
    (check-equal? back '())))

(call-with-values
    (lambda ()
      (split-at lst2 0))
  (lambda (front back)
    (check-equal? front '())
    (check-equal? back '(11 22 33 44))))

(call-with-values
    (lambda ()
      (split-at lst2 1))
  (lambda (front back)
    (check-equal? front '(11))
    (check-equal? back '(22 33 44))))

(call-with-values
    (lambda ()
      (split-at lst2 2))
  (lambda (front back)
    (check-equal? front '(11 22))
    (check-equal? back '(33 44))))

(call-with-values
    (lambda ()
      (split-at lst2 3))
  (lambda (front back)
    (check-equal? front '(11 22 33))
    (check-equal? back '(44))))

(call-with-values
    (lambda ()
      (split-at lst2 4))
  (lambda (front back)
    (check-equal? front '(11 22 33 44))
    (check-equal? back '())))

(call-with-values
    (lambda ()
      (split-at bool 0))
  (lambda (front back)
    (check-equal? front '())
    (check-equal? back bool)))

(call-with-values
    (lambda ()
      (split-at '(1 2 . 3) 2))
  (lambda (front back)
    (check-equal? front '(1 2))
    (check-equal? back 3)))

(check-tail-exn range-exception? (lambda () (split-at lst1 4)))
(check-tail-exn range-exception? (lambda () (split-at lst1 -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (split-at)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (split-at lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (split-at lst1 0 0)))
