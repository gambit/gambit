(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(call-with-values
 (lambda () (split-at lst1 0))
 (lambda (front back) (test-equal '() front) (test-equal '(11 22 33) back)))

(call-with-values
 (lambda () (split-at lst1 1))
 (lambda (front back) (test-equal '(11) front) (test-equal '(22 33) back)))

(call-with-values
 (lambda () (split-at lst1 2))
 (lambda (front back) (test-equal '(11 22) front) (test-equal '(33) back)))

(call-with-values
 (lambda () (split-at lst1 3))
 (lambda (front back) (test-equal '(11 22 33) front) (test-equal '() back)))

(call-with-values
 (lambda () (split-at lst2 0))
 (lambda (front back) (test-equal '() front) (test-equal '(11 22 33 44) back)))

(call-with-values
 (lambda () (split-at lst2 1))
 (lambda (front back) (test-equal '(11) front) (test-equal '(22 33 44) back)))

(call-with-values
 (lambda () (split-at lst2 2))
 (lambda (front back) (test-equal '(11 22) front) (test-equal '(33 44) back)))

(call-with-values
 (lambda () (split-at lst2 3))
 (lambda (front back) (test-equal '(11 22 33) front) (test-equal '(44) back)))

(call-with-values
 (lambda () (split-at lst2 4))
 (lambda (front back) (test-equal '(11 22 33 44) front) (test-equal '() back)))

(call-with-values
 (lambda () (split-at bool 0))
 (lambda (front back) (test-equal '() front) (test-equal bool back)))

(call-with-values
 (lambda () (split-at '(1 2 . 3) 2))
 (lambda (front back) (test-equal '(1 2) front) (test-equal 3 back)))

(test-error-tail range-exception? (split-at lst1 4))
(test-error-tail range-exception? (split-at lst1 -1))

(test-error-tail wrong-number-of-arguments-exception? (split-at))
(test-error-tail wrong-number-of-arguments-exception? (split-at lst1))
(test-error-tail wrong-number-of-arguments-exception? (split-at lst1 0 0))
