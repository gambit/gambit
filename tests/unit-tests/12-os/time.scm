(include "#.scm")

(check-true (number? (current-second)))
(check-true (number? (current-jiffy)))
(check-true (number? (jiffies-per-second)))

(check-true (> (current-second) 0))
(check-true (> (current-jiffy) 0))
(check-true (> (jiffies-per-second) 0))

;;; Test exceptions

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (current-second #f)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (current-jiffy #f)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (jiffies-per-second #f)))
