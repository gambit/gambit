(include "#.scm")

(define param (make-parameter "top"))

(define (simple-handler exc) 111)
(define (reflect-handler exc)
  (list 111 (if (or (string? exc) (number? exc)) exc "other")))

;; current-exception-handler

(check-true (procedure? (current-exception-handler)))

(let ((old (current-exception-handler)))
  (current-exception-handler simple-handler)
  (check-eqv? (current-exception-handler) simple-handler)
  (current-exception-handler old))

(check-exn type-exception? (lambda () (current-exception-handler #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (current-exception-handler list #f)))

;; with-exception-handler

(define (with-exception-handler-test1)
  (with-exception-handler
      simple-handler
    (lambda ()
      (current-exception-handler))))

(check-eqv? (with-exception-handler-test1) simple-handler)

(define (with-exception-handler-test2 n)

  (define (handler exc)
    (list (if (divide-by-zero-exception? exc)
              (raise 999)
              (list 222 (if (or (string? exc) (number? exc)) exc "other")))
          (eqv? (current-exception-handler) handler)))

  (with-exception-handler
      reflect-handler
    (lambda ()
      (with-exception-handler
          handler
        (lambda ()
          (list 11 (quotient 100 n)))))))

(check-equal? (with-exception-handler-test2 2) '(11 50))
(check-equal? (with-exception-handler-test2 0) '(11 (((222 999) #t) #t)))
(check-equal? (with-exception-handler-test2 #f) '(11 ((222 "other") #t)))

(check-tail-exn type-exception? (lambda () (with-exception-handler #f list)))

(check-tail-exn type-exception? (lambda () (with-exception-handler #f list)))
(check-tail-exn type-exception? (lambda () (with-exception-handler list #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (with-exception-handler)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (with-exception-handler list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (with-exception-handler list list #f)))

;; r7rs-with-exception-handler

(define (r7rs-with-exception-handler-test1)
  (r7rs-with-exception-handler
      simple-handler
    (lambda ()
      (current-exception-handler))))

(define (r7rs-with-exception-handler-test2 n)

  (define (handler exc)
    (list (if (divide-by-zero-exception? exc)
              (raise 999)
              (list 222 (if (or (string? exc) (number? exc)) exc "other")))
          (eqv? (current-exception-handler) handler)))

  (r7rs-with-exception-handler
      reflect-handler
    (lambda ()
      (r7rs-with-exception-handler
          handler
        (lambda ()
          (list 11 (quotient 100 n)))))))

(check-equal? (r7rs-with-exception-handler-test2 2) '(11 50))
(check-equal? (r7rs-with-exception-handler-test2 0) '(11 ((111 999) #f)))
(check-equal? (r7rs-with-exception-handler-test2 #f) '(11 ((222 "other") #f)))

(check-tail-exn type-exception? (lambda () (r7rs-with-exception-handler #f list)))
(check-tail-exn type-exception? (lambda () (r7rs-with-exception-handler list #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (r7rs-with-exception-handler)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (r7rs-with-exception-handler list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (r7rs-with-exception-handler list list #f)))

;; guard

(define (guard-test1)
  (guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11)))

(check-equal? (guard-test1) '(11))

(define (guard-test2)
  (guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11 (raise "foo") 22)))

(check-equal? (guard-test2) '(88 "foo"))

(define (guard-test3)
  (guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11 (raise 22) 33)))

(check-equal? (guard-test3) '(99 22))

(define (guard-test4)
  (with-exception-handler
      reflect-handler
    (lambda ()
      (list
       0
       (guard
           (exc
            ((string? exc)
             (list 88 exc (eqv? (current-exception-handler) reflect-handler)))
            (else
             (list 99 exc (eqv? (current-exception-handler) reflect-handler))))
         (list 11 (raise 22) 33))))))

(check-equal? (guard-test4) '(0 (99 22 #t)))

(define (guard-test5 n)
  (parameterize ((param "out"))
    (with-exception-handler
     (lambda (exc)
       (list exc (param)))
     (lambda ()
       (list
        0
        (guard
         (exc
          ((string? exc)
           (list 88 exc (param)))
          ((number? exc)
           (list 99 (param) (raise "foo"))))
         (parameterize ((param "in"))
           (list 11 (raise n) 33))))))))

(check-equal? (guard-test5 22) '(0 (99 "out" ("foo" "out"))))
(check-equal? (guard-test5 #f) '(0 (#f "out")))

;; r7rs-guard

(define (r7rs-guard-test1)
  (r7rs-guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11)))

(check-equal? (r7rs-guard-test1) '(11))

(define (r7rs-guard-test2)
  (r7rs-guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11 (r7rs-raise-continuable "foo") 22)))

(check-equal? (r7rs-guard-test2) '(88 "foo"))

(define (r7rs-guard-test3)
  (r7rs-guard
      (exc
       ((string? exc)
        (list 88 exc))
       (else
        (list 99 exc)))
    (list 11 (r7rs-raise-continuable 22) 33)))

(check-equal? (r7rs-guard-test3) '(99 22))

(define (r7rs-guard-test4)
  (r7rs-with-exception-handler
      reflect-handler
    (lambda ()
      (list
       0
       (r7rs-guard
           (exc
            ((string? exc)
             (list 88 exc (eqv? (current-exception-handler) reflect-handler)))
            (else
             (list 99 exc (eqv? (current-exception-handler) reflect-handler))))
         (list 11 (r7rs-raise-continuable 22) 33))))))

(check-equal? (r7rs-guard-test4) '(0 (99 22 #f)))

(define (r7rs-guard-test5 n)
  (parameterize ((param "out"))
    (r7rs-with-exception-handler
     (lambda (exc)
       (list exc (param)))
     (lambda ()
       (list
        0
        (r7rs-guard
         (exc
          ((string? exc)
           (list 88 exc (param)))
          ((number? exc)
           (list 99 (param) (r7rs-raise-continuable "foo"))))
         (parameterize ((param "in"))
           (list 11 (r7rs-raise-continuable n) 33))))))))

(check-equal? (r7rs-guard-test5 22) '(0 (99 "out" ("foo" "out"))))
(check-equal? (r7rs-guard-test5 #f) '(0 (11 (#f "in") 33)))
