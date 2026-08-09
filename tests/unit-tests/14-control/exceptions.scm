(include "#.scm")

(define param (make-parameter "top"))

(define (simple-handler exc) 111)
(define (reflect-handler exc)
  (list 111 (if (or (string? exc) (number? exc)) exc "other")))

;; current-exception-handler

(test-assert (eq? #t (procedure? (current-exception-handler))))

(let ((old (current-exception-handler)))
  (current-exception-handler simple-handler)
  (test-eqv simple-handler (current-exception-handler))
  (current-exception-handler old))

(test-error type-exception? (current-exception-handler #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (current-exception-handler list #f))

;; with-exception-handler

(define (with-exception-handler-test1)
  (with-exception-handler
   simple-handler
   (lambda () (current-exception-handler))))

(test-eqv simple-handler (with-exception-handler-test1))

(define (with-exception-handler-test2 n)
  
  (define (handler exc)
    (list (if (divide-by-zero-exception? exc)
              (raise 999)
              (list 222 (if (or (string? exc) (number? exc)) exc "other")))
          (eqv? (current-exception-handler) handler)))
  
  (with-exception-handler
   reflect-handler
   (lambda ()
     (with-exception-handler handler (lambda () (list 11 (quotient 100 n)))))))

(test-equal '(11 50) (with-exception-handler-test2 2))
(test-equal '(11 (((222 999) #t) #t)) (with-exception-handler-test2 0))
(test-equal '(11 ((222 "other") #t)) (with-exception-handler-test2 #f))

(test-error-tail type-exception? (with-exception-handler #f list))

(test-error-tail type-exception? (with-exception-handler #f list))
(test-error-tail type-exception? (with-exception-handler list #f))

(test-error-tail wrong-number-of-arguments-exception? (with-exception-handler))
(test-error-tail
 wrong-number-of-arguments-exception?
 (with-exception-handler list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (with-exception-handler list list #f))

;; r7rs-with-exception-handler

(define (r7rs-with-exception-handler-test1)
  (r7rs-with-exception-handler
   simple-handler
   (lambda () (current-exception-handler))))

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
      (lambda () (list 11 (quotient 100 n)))))))

(test-equal '(11 50) (r7rs-with-exception-handler-test2 2))
(test-equal '(11 ((111 999) #f)) (r7rs-with-exception-handler-test2 0))
(test-equal '(11 ((222 "other") #f)) (r7rs-with-exception-handler-test2 #f))

(test-error-tail type-exception? (r7rs-with-exception-handler #f list))
(test-error-tail type-exception? (r7rs-with-exception-handler list #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (r7rs-with-exception-handler))
(test-error-tail
 wrong-number-of-arguments-exception?
 (r7rs-with-exception-handler list))
(test-error-tail
 wrong-number-of-arguments-exception?
 (r7rs-with-exception-handler list list #f))

;; guard

(define (guard-test1)
  (guard (exc ((string? exc) (list 88 exc)) (else (list 99 exc))) (list 11)))

(test-equal '(11) (guard-test1))

(define (guard-test2)
  (guard (exc ((string? exc) (list 88 exc)) (else (list 99 exc)))
    (list 11 (raise "foo") 22)))

(test-equal '(88 "foo") (guard-test2))

(define (guard-test3)
  (guard (exc ((string? exc) (list 88 exc)) (else (list 99 exc)))
    (list 11 (raise 22) 33)))

(test-equal '(99 22) (guard-test3))

(define (guard-test4)
  (with-exception-handler
   reflect-handler
   (lambda ()
     (list 0
           (guard (exc ((string? exc)
                        (list 88
                              exc
                              (eqv? (current-exception-handler)
                                    reflect-handler)))
                       (else (list 99
                                   exc
                                   (eqv? (current-exception-handler)
                                         reflect-handler))))
             (list 11 (raise 22) 33))))))

(test-equal '(0 (99 22 #t)) (guard-test4))

(define (guard-test5 n)
  (parameterize ((param "out"))
    (with-exception-handler
     (lambda (exc) (list exc (param)))
     (lambda ()
       (list 0
             (guard (exc ((string? exc) (list 88 exc (param)))
                         ((number? exc) (list 99 (param) (raise "foo"))))
               (parameterize ((param "in")) (list 11 (raise n) 33))))))))

(test-equal '(0 (99 "out" ("foo" "out"))) (guard-test5 22))
(test-equal '(0 (#f "out")) (guard-test5 #f))

;; r7rs-guard

(define (r7rs-guard-test1)
  (r7rs-guard
   (exc ((string? exc) (list 88 exc)) (else (list 99 exc)))
   (list 11)))

(test-equal '(11) (r7rs-guard-test1))

(define (r7rs-guard-test2)
  (r7rs-guard
   (exc ((string? exc) (list 88 exc)) (else (list 99 exc)))
   (list 11 (r7rs-raise-continuable "foo") 22)))

(test-equal '(88 "foo") (r7rs-guard-test2))

(define (r7rs-guard-test3)
  (r7rs-guard
   (exc ((string? exc) (list 88 exc)) (else (list 99 exc)))
   (list 11 (r7rs-raise-continuable 22) 33)))

(test-equal '(99 22) (r7rs-guard-test3))

(define (r7rs-guard-test4)
  (r7rs-with-exception-handler
   reflect-handler
   (lambda ()
     (list 0
           (r7rs-guard
            (exc ((string? exc)
                  (list 88
                        exc
                        (eqv? (current-exception-handler) reflect-handler)))
                 (else (list 99
                             exc
                             (eqv? (current-exception-handler)
                                   reflect-handler))))
            (list 11 (r7rs-raise-continuable 22) 33))))))

(test-equal '(0 (99 22 #f)) (r7rs-guard-test4))

(define (r7rs-guard-test5 n)
  (parameterize ((param "out"))
    (r7rs-with-exception-handler
     (lambda (exc) (list exc (param)))
     (lambda ()
       (list 0
             (r7rs-guard
              (exc ((string? exc) (list 88 exc (param)))
                   ((number? exc)
                    (list 99 (param) (r7rs-raise-continuable "foo"))))
              (parameterize ((param "in"))
                (list 11 (r7rs-raise-continuable n) 33))))))))

(test-equal '(0 (99 "out" ("foo" "out"))) (r7rs-guard-test5 22))
(test-equal '(0 (11 (#f "in") 33)) (r7rs-guard-test5 #f))
