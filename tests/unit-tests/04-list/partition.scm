(include "#.scm")

(call-with-values
    (lambda ()
      (partition even? '()))
  (lambda (in out)
    (check-equal? in '())
    (check-equal? out '())))

(let ((nums (iota 20)))
  (call-with-values
      (lambda ()
        (partition even? nums))
    (lambda (in out)
      (check-equal? in  '(0 2 4 6 8 10 12 14 16 18))
      (check-equal? out '(1 3 5 7 9 11 13 15 17 19))
      (check-equal? nums (iota 20)))))

(let ((nums (iota 20)))
  (call-with-values
      (lambda ()
        (partition (lambda (j) (< j 10)) nums))
    (lambda (in out)
      (check-eq? out (list-tail nums 10)))))

(let ((nums (iota 20)))
  (call-with-values
      (lambda ()
        (partition integer? nums))
    (lambda (in out)
      (check-eq? in nums))))


(check-tail-exn wrong-number-of-arguments-exception? (lambda () (partition)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (partition 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (partition 1 2 3)))
(check-tail-exn type-exception? (lambda () (partition odd? '(1 . 2))))
