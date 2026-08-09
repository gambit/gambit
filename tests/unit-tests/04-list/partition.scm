(include "#.scm")

(call-with-values
 (lambda () (partition even? '()))
 (lambda (in out) (test-equal '() in) (test-equal '() out)))

(let ((nums (iota 20)))
  (call-with-values
   (lambda () (partition even? nums))
   (lambda (in out)
     (test-equal '(0 2 4 6 8 10 12 14 16 18) in)
     (test-equal '(1 3 5 7 9 11 13 15 17 19) out)
     (test-equal (iota 20) nums))))

(let ((nums (iota 20)))
  (call-with-values
   (lambda () (partition (lambda (j) (< j 10)) nums))
   (lambda (in out) (test-equal (list-tail nums 10) out))))

(let ((nums (iota 20)))
  (call-with-values
   (lambda () (partition integer? nums))
   (lambda (in out) (test-equal nums in))))

(let* ((nums (iota 20))
       (counter 0)
       (cont list)
       (pred (lambda (x)
               (call-with-current-continuation
                (lambda (c)
                  (set! counter (+ counter 1))
                  (if (= counter 5) (set! cont c))))
               (odd? x))))
  (call-with-values
   (lambda () (partition pred nums))
   (lambda (in out)
     (test-equal '(1 3 5 7 9 11 13 15 17 19) in)
     (test-equal '(0 2 4 6 8 10 12 14 16 18) out)
     (if (< counter 30) (cont #f)))))


(test-error-tail wrong-number-of-arguments-exception? (partition))
(test-error-tail wrong-number-of-arguments-exception? (partition 1))
(test-error-tail wrong-number-of-arguments-exception? (partition 1 2 3))
(test-error-tail type-exception? (partition odd? '(1 . 2)))
