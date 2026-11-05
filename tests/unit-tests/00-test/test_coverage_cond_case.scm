(include "#.scm")

;; These forms used to fail expansion when GAMBIT_COVERAGE=yes because
;; the collector called eq? with one argument on cond clauses and
;; took cdr of the case key.

(test-equal 7 (cond ((number? 7) 7) (else 0)))

(test-equal
 7
 (cond ((number? 7) (abs -7))
       (else (sqrt 9))))

(test-equal
 7
 (cond ((assv 'x '((x . 7))) => (lambda (pair) (cdr pair)))
       (else (abs -1))))

(test-equal 4 (cond (else (sqrt 16))))

(test-equal
 3
 (case (string-length "ab")
   ((2) 3)
   (else 0)))

(test-equal
 1
 (case 'selector
   ((selector) 1)
   (else 0)))

(test-equal
 1
 (case (abs -1)
   ((1) 1)
   (else 0)))

(test-equal #t (cond ((positive? 1))))

(test-equal
 7
 (case (string-length "ab")
   ((2) (cond ((number? 7) (abs -7))
              (else (sqrt 9))))
   (else 0)))
