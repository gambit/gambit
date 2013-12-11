;;;============================================================================

;;; File: "#.scm"

;;; Copyright (c) 2013 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define epsilon 0)

(define (##failed-check msg #!optional (actual-result (##type-cast -6 2)))
  (let ((port (##repl-output-port)))
    (##display msg port)
    (if (##not (##eq? actual-result (##type-cast -6 2)))
        (begin
          (##display " GOT " port)
          (##write actual-result port)))
    (##newline port))
  (##add-exit-job! (lambda () (##exit-with-err-code-no-cleanup 2))))

(define (##check-exc-proc exn? thunk msg)
  (##with-exception-catcher
   (lambda (e)
     (if (##not (exn? e))
         (##failed-check msg e)))
   (lambda ()
     (##failed-check msg (thunk)))))

(define (##check-=-proc n1 n2 tolerance msg)
  (if (or (##not (##number? n1))
          (##not (##number? n2))
          (##< tolerance (##magnitude (##- n1 n2))))
      (##failed-check msg n1)))
                  
(##define-macro (##setup-check)

  (eval '(##begin

           (define ##enable-checks?
             (make-parameter #t))

           (define (##expand-check-relation src positive? relation)
             (##deconstruct-call
              src
              -3
              (lambda (expr1 expr2 #!optional comment)
                (##expand-check-rel src positive? relation expr1 expr2))))

           (define (##expand-check-value src positive? relation val)
             (##deconstruct-call
              src
              -2
              (lambda (expr1 #!optional comment)
                (##expand-check-rel src positive? relation expr1 val))))

           (define (##expand-check-rel src positive? relation expr1 expr2)
             (let ((report (##failed-check-gen src '$actual-result$)))
               `(let (($actual-result$ ,(##sourcify expr1 src))
                      ($expected-result$ ,(##sourcify expr2 src)))
                  (if (,relation $actual-result$ $expected-result$)
                      ,(if positive? #f report)
                      ,(if positive? report #f)))))

           (define (##expand-check-= src)
             (##deconstruct-call
              src
              -3
              (lambda (expr1 expr2 #!optional (tolerance 'epsilon) comment)
                (let ((msg (##failed-check-msg src)))
                  (##sourcify
                   (list (##sourcify '##check-=-proc src)
                         (##sourcify expr1 src)
                         (##sourcify expr2 src)
                         (##sourcify tolerance src)
                         (##sourcify msg src))
                   src)))))

           (define (##expand-check-exc src)
             (##deconstruct-call
              src
              -3
              (lambda (exn? thunk #!optional comment)
                (let ((msg (##failed-check-msg src)))
                  (##sourcify
                   (list (##sourcify '##check-exc-proc src)
                         (##sourcify exn? src)
                         (##sourcify thunk src)
                         (##sourcify msg src))
                   src)))))

           (define (##expand-check src)
             (if (not (##enable-checks?))
                 '(##begin)
                 (let ((form (##source-strip src)))
                   (case (##source-strip (car form))

                     ((check-equal?)
                      (##expand-check-relation src #t '##equal?))
                     ((check-not-equal?)
                      (##expand-check-relation src #f '##equal?))
                     ((check-eqv?)
                      (##expand-check-relation src #t '##eqv?))
                     ((check-not-eqv?)
                      (##expand-check-relation src #f '##eqv?))
                     ((check-eq?)
                      (##expand-check-relation src #t '##eq?))
                     ((check-not-eq?)
                      (##expand-check-relation src #f '##eq?))

                     ((check-=)
                      (##expand-check-= src))

                     ((check-true)
                      (##expand-check-value src #t '##eq? #t))
                     ((check-false)
                      (##expand-check-value src #t '##eq? #f))
                     ((check-not-false)
                      (##expand-check-value src #f '##eq? #f))

                     ((check-exn)
                      (##expand-check-exc src))

                     (else
                      (##raise-expression-parsing-exception
                       'ill-formed-special-form
                       src))))))

           (define (##failed-check-msg src)
             (call-with-output-string
              ""
              (lambda (port)
                (let ((locat (##source-locat src)))
                  (if locat
                      (begin
                        (##display-locat locat #t port)
                        (display ": " port))))
                (display "FAILED " port)
                (write (##desourcify src) port))))

           (define (##failed-check-gen src actual-result)
             (##sourcify
              (list (##sourcify '##failed-check src)
                    (##sourcify (##failed-check-msg src) src)
                    (##sourcify actual-result src))
              src))
           ))

  '(##begin))

(##setup-check)

(##define-syntax check-equal?     (lambda (src) (##expand-check src)))
(##define-syntax check-not-equal? (lambda (src) (##expand-check src)))
(##define-syntax check-eqv?       (lambda (src) (##expand-check src)))
(##define-syntax check-not-eqv?   (lambda (src) (##expand-check src)))
(##define-syntax check-eq?        (lambda (src) (##expand-check src)))
(##define-syntax check-not-eq?    (lambda (src) (##expand-check src)))

(##define-syntax check-=          (lambda (src) (##expand-check src)))

(##define-syntax check-true       (lambda (src) (##expand-check src)))
(##define-syntax check-false      (lambda (src) (##expand-check src)))
(##define-syntax check-not-false  (lambda (src) (##expand-check src)))

(##define-syntax check-exn        (lambda (src) (##expand-check src)))

;;;============================================================================
