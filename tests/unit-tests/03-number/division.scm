(##include "#.scm")

(define-macro (make-error-tests)
  (let* ((base-name-strings
          (map symbol->string
               '(truncate floor ceiling round euclidean balanced)))
         (multiple-value-names
          (map (lambda (name) (string->symbol (string-append name "/")))
               base-name-strings))
         (single-value-names
          (apply append
                 '(quotient remainder modulo)
                 (map (lambda (name)
                        `(,(string->symbol (string-append name "-quotient"))
                          ,(string->symbol (string-append name "-remainder"))))
                      base-name-strings)))
         (all-names (append multiple-value-names single-value-names))
         (error-tests
          (apply append
                 (map (lambda (name)
                        (apply append
                               (map (lambda (x)
                                      `((test-error-tail
                                         type-exception?
                                         (,name ,x 1))
                                        (test-error-tail
                                         type-exception?
                                         (,name ,x 1.))
                                        (test-error-tail
                                         type-exception?
                                         (,name 1 ,x))
                                        (test-error-tail
                                         type-exception?
                                         (,name 1. ,x))))
                                    '('a 1/2 2.5 1+0.i))))
                      all-names)))
         (result (cons 'begin error-tests)))
    result))

(make-error-tests)

(for-each
 (lambda (operation)
   (test-error-tail divide-by-zero-exception? (operation 1 0))
   (test-error-tail divide-by-zero-exception? (operation 1 0.))
   (test-error-tail divide-by-zero-exception? (operation 0 0.)))
 (list truncate/ floor/ ceiling/ round/ euclidean/ balanced/))

;; exact tests

(let* ((big-arguments
        (map (lambda (inc) (+ ##bignum.-min-fixnum inc)) (iota 5 -2)))
       (really-big-arguments
        (apply append
               (map (lambda (x) (map (lambda (y) (* x y)) big-arguments))
                    big-arguments)))
       (positive-arguments
        (append big-arguments really-big-arguments (iota 8 1)))
       (nonzero-arguments
        (append positive-arguments (map - positive-arguments)))
       (all-arguments (cons 0 nonzero-arguments)))
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (balanced/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t
                 (and (= n (+ (* d quo) rem))
                      (<= (- (/ (abs d) 2)) rem)
                      (< rem (/ (abs d) 2)))))
           (test-eqv quo (balanced-quotient n d))
           (test-eqv rem (balanced-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (round/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t
                 (and (= n (+ (* d quo) rem))
                      (or (< (* 2 (abs rem)) (abs d))
                          (and (= (abs d) (* 2 (abs rem))) (even? quo))))))
           (test-eqv quo (round-quotient n d))
           (test-eqv rem (round-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (floor/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t
                 (and (= n (+ (* d quo) rem))
                      (< (abs rem) (abs d))
                      (or (= rem 0)
                          (and (eq? (negative? d) (negative? rem)))))))
           (test-eqv quo (floor-quotient n d))
           (test-eqv rem (floor-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (ceiling/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t
                 (and (= n (+ (* d quo) rem))
                      (< (abs rem) (abs d))
                      (or (= rem 0)
                          (and (eq? (negative? d) (positive? rem)))))))
           (test-eqv quo (ceiling-quotient n d))
           (test-eqv rem (ceiling-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (truncate/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t
                 (and (= n (+ (* d quo) rem))
                      (< (abs rem) (abs d))
                      (or (= rem 0)
                          (and (eq? (negative? n) (negative? rem)))))))
           (test-eqv quo (truncate-quotient n d))
           (test-eqv rem (truncate-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (call-with-values
         (lambda () (euclidean/ n d))
         (lambda (quo rem)
           (test-assert
            (eq? #t (and (= n (+ (* d quo) rem)) (< -1 rem (abs d)))))
           (test-eqv quo (euclidean-quotient n d))
           (test-eqv rem (euclidean-remainder n d)))))
      nonzero-arguments))
   all-arguments)
  (for-each
   (lambda (n)
     (for-each
      (lambda (d)
        (test-eqv (truncate-quotient n d) (quotient n d))
        (test-eqv (truncate-remainder n d) (remainder n d))
        (test-eqv (floor-remainder n d) (modulo n d)))
      nonzero-arguments))
   all-arguments))

;; inexact-tests

(let* ((positive-arguments (iota 8 1))
       (nonzero-arguments
        (append positive-arguments (map - positive-arguments)))
       (all-arguments (cons 0 nonzero-arguments))
       (operations
        (list truncate/ floor/ ceiling/ round/ euclidean/ balanced/)))
  (for-each
   (lambda (operation)
     (for-each
      (lambda (n)
        (for-each
         (lambda (d)
           (call-with-values
            (lambda () (operation n d))
            (lambda (exact-quo exact-rem)
              (call-with-values
               (lambda () (operation (inexact n) (inexact d)))
               (lambda (inexact-quo inexact-rem)
                 (test-approximate inexact-quo exact-quo 1e-12)
                 (test-approximate inexact-rem exact-rem 1e-12))))))
         nonzero-arguments))
      all-arguments))
   operations)
  (for-each
   (lambda (operation)
     ;; Check that we special case an exact zero dividend.
     (test-equal '(0 0) (call-with-values (lambda () (operation 0 1.)) list)))
   operations))
