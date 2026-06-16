;;(##define-syntax check-equal?     (lambda (src) 
;;                                    (##expand-check src)))
;;(##define-syntax check-not-equal? (lambda (src) (##expand-check src)))
;;(##define-syntax check-eqv?       (lambda (src)
;;                                    (pp (##expand-check src))))
;;(##define-syntax check-not-eqv?   (lambda (src) (##expand-check src)))
;;(##define-syntax check-eq?        (lambda (src) (##expand-check src)))
;;(##define-syntax check-not-eq?    (lambda (src) (##expand-check src)))
;;
;;(##define-syntax check-=          (lambda (src) (##expand-check src)))
;;
;;(##define-syntax check-true       (lambda (src) (##expand-check src)))
;;(##define-syntax check-false      (lambda (src) (##expand-check src)))
;;(##define-syntax check-not-false  (lambda (src) (##expand-check src)))
;;
;;(##define-syntax check-exn        (lambda (src) (##expand-check src)))
;;(##define-syntax check-tail-exn   (lambda (src) (##expand-check src)))

(define (in x li equality?)
  (cond
    ((null? li) #f)
    ((equality? x (car li)) #t)
    (else (in x (cdr li)))))

(define (show x)
  (if (symbol? x) (pp x (current-error-port)) #f))

(define-macro
   (equality-check . names)
   `(begin
      ,@(map
          (lambda (x) 
            `(define-macro (,x a b . rest)
                (define (show x)
                  (if (symbol? x) (pp x (current-error-port)) #f))
                (cond 
                  ((pair? a)
                     (show (car a)))
                  (else    (show a)))
                #f))
          names)))

(equality-check check-equal? check-not-eq? check-not-equal? check-eqv? check-eq? check-not-eqv? check-=)

(define epsilon 0)

(define-macro
  (boolean-checks . names)
   `(begin
      ,@(map
          (lambda (x) 
            `(define-macro (,x a . rest)
                (define (show x)
                  (if (symbol? x) (pp x (current-error-port)) #f))
                (cond 
                  ((pair? a)
                     (show (car a)))
                  (else    (show a)))
                #f))
          names)))

(boolean-checks check-true check-false check-not-false)

(define-macro
  (check-tail-exn a b)
    (define (show x)
      (if (symbol? x) (pp x (current-error-port)) #f))
  (show (caaddr b))
  #f)

(define-macro
  (check-exn a b)
    (define (show x)
      (if (symbol? x) (pp x (current-error-port)) #f))
  (show (caaddr b))
  #f)

(define (exception-description-string e)
  (##with-input-from-string
    (##call-with-output-string
      (lambda (port) (##display-exception e port)))
    ##read-line))

(define (os-unimplemented-exception-string e)
  (and (os-exception? e)
       (let ((err-string (##os-err-code->string (os-exception-code e))))
         (and (string=? err-string "Unimplemented operation")
              err-string))))

(define (exit0-when-unimplemented-operation-os-exception thunk)
  (with-exception-catcher
   (lambda (e)
     (if (os-unimplemented-exception-string e)
         (exit 0)
         (raise e)))
   thunk))

