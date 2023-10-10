(##include "#.scm")

(define-macro (make-error-tests)
  
  (let* ((base-name-strings
          (map symbol->string '(truncate floor ceiling round euclidean balanced)))
         (multiple-value-names
          (map (lambda (name)
                 (string->symbol (string-append name "/")))
               base-name-strings))
         (single-value-names
          (apply append
                 '(quotient remainder modulo)
                 (map (lambda (name)
                        `(,(string->symbol (string-append name "-quotient"))
                          ,(string->symbol (string-append name "-remainder"))))
                      base-name-strings)))
         (all-names
          (append multiple-value-names single-value-names))
         (error-tests
          (apply append
                 (map (lambda (name)
                        (apply append
                               (map (lambda (x)
                                      `((check-tail-exn type-exception? (lambda () (,name ,x 1)))
                                        (check-tail-exn type-exception? (lambda () (,name ,x 1.)))
                                        (check-tail-exn type-exception? (lambda () (,name 1 ,x)))
                                        (check-tail-exn type-exception? (lambda () (,name 1. ,x)))))
                                    '('a 1/2 2.5 1+0.0i))))
                      all-names)))
         (result (cons 'begin error-tests)))
    result))

(make-error-tests)

(for-each (lambda (operation)
            (check-tail-exn divide-by-zero-exception? (lambda () (operation 1 0)))
            (check-tail-exn divide-by-zero-exception? (lambda () (operation 1 0.)))
            (check-tail-exn divide-by-zero-exception? (lambda () (operation 0 0.))))
          (list truncate/ floor/ ceiling/ round/ euclidean/ balanced/))

;; exact tests

(let* ((big-arguments
        (map (lambda (inc) (+ ##bignum.-min-fixnum inc)) (iota 5 -2)))
       (really-big-arguments
        (apply append
               (map (lambda (x)
                      (map (lambda (y)
                             (* x y))
                           big-arguments))
                    big-arguments)))
       (positive-arguments
        (append big-arguments really-big-arguments (iota 8 1)))
       (nonzero-arguments
        (append positive-arguments
                (map - positive-arguments)))
       (all-arguments
        (cons 0 nonzero-arguments)))
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (balanced/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (<= (- (/ (abs d) 2) rem))
                                               (< rem (/ (abs d) 2))))
                              (check-eqv? (balanced-quotient n d) quo)
                              (check-eqv? (balanced-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (round/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (or (< (* 2 (abs rem)) (abs d))
                                                   (and (= (abs d) (* 2 (abs rem)))
                                                        (even? quo)))))
                              (check-eqv? (round-quotient n d) quo)
                              (check-eqv? (round-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (floor/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (< (abs rem) (abs d))
                                               (or (= rem 0)
                                                   (and (eq? (negative? d) (negative? rem))))))
                              (check-eqv? (floor-quotient n d) quo)
                              (check-eqv? (floor-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (ceiling/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (< (abs rem) (abs d))
                                               (or (= rem 0)
                                                   (and (eq? (negative? d) (positive? rem))))))
                              (check-eqv? (ceiling-quotient n d) quo)
                              (check-eqv? (ceiling-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (truncate/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (< (abs rem) (abs d))
                                               (or (= rem 0)
                                                   (and (eq? (negative? n) (negative? rem))))))
                              (check-eqv? (truncate-quotient n d) quo)
                              (check-eqv? (truncate-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (call-with-values
                              (lambda ()
                                (euclidean/ n d))
                            (lambda (quo rem)
                              (check-true (and (= n (+ (* d quo) rem))
                                               (< -1 rem (abs d))))
                              (check-eqv? (euclidean-quotient n d) quo)
                              (check-eqv? (euclidean-remainder n d) rem))))
                        nonzero-arguments))
            all-arguments)
  (for-each (lambda (n)
              (for-each (lambda (d)
                          (check-eqv? (quotient n d) (truncate-quotient n d))
                          (check-eqv? (remainder n d) (truncate-remainder n d))
                          (check-eqv? (modulo n d) (floor-remainder n d)))
                        nonzero-arguments))
            all-arguments))

;; inexact-tests

(let* ((positive-arguments
        (iota 8 1))
       (nonzero-arguments
        (append positive-arguments
                (map - positive-arguments)))
       (all-arguments
        (cons 0 nonzero-arguments))
       (operations
        (list truncate/ floor/ ceiling/ round/ euclidean/ balanced/)))
  (for-each (lambda (operation)
              (for-each (lambda (n)
                          (for-each (lambda (d)
                                      (call-with-values
                                          (lambda ()
                                            (operation n d))
                                        (lambda (exact-quo exact-rem)
                                          (call-with-values
                                              (lambda ()
                                                (operation (inexact n) (inexact d)))
                                            (lambda (inexact-quo inexact-rem)
                                              (check-= exact-quo inexact-quo 0)
                                              (check-= exact-rem inexact-rem 0))))))
                                    nonzero-arguments))
                        all-arguments))
            operations)
  (for-each (lambda (operation)
              ;; Check that we special case an exact zero dividend.
              (check-equal? (call-with-values
                                (lambda ()
                                  (operation 0 1.))
                              list)
                            '(0 0)))
            operations))
