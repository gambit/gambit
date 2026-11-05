(include "#.scm")

(test-assert (eq? #t (number? (current-second))))
(test-assert (eq? #t (number? (current-jiffy))))
(test-assert (eq? #t (number? (jiffies-per-second))))

(test-assert (eq? #t (> (current-second) 0)))
(test-assert (eq? #t (> (current-jiffy) 0)))
(test-assert (eq? #t (> (jiffies-per-second) 0)))

;; current-time is a distinct OS time object (not cpu-time / real-time).
(test-assert (time? (current-time)))
(test-assert (number? (time->seconds (current-time))))
(test-assert (> (time->seconds (current-time)) 0))

;;; Test exceptions

(test-error-tail wrong-number-of-arguments-exception? (current-second #f))
(test-error-tail wrong-number-of-arguments-exception? (current-jiffy #f))
(test-error-tail wrong-number-of-arguments-exception? (jiffies-per-second #f))
(test-error-tail wrong-number-of-arguments-exception? (current-time #f))
