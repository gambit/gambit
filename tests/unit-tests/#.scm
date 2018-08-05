;;;============================================================================

;;; File: "#.scm"

;;; Copyright (c) 2013-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define epsilon 0)

(define ##failed-check? #f)

;; at exit, verify if any checks failed
(let ((##exit-old ##exit))
  (set! ##exit
        (lambda rest
          (if (pair? rest)
              (##exit-old (car rest))
              (##exit-with-err-code-no-cleanup
               (if ##failed-check? 2 1))))))

(define ##failed-check-absent '$$fake-absent-object$$)

(define (##failed-check msg #!optional (actual-result ##failed-check-absent))
  (println
   (call-with-output-string
    ""
    (lambda (port)
      (##display msg port)
      (if (##not (##eq? actual-result ##failed-check-absent))
          (begin
            (##display " GOT " port)
            (##write actual-result port))))))
  (set! ##failed-check? #t))

(define (##check-exn-proc exn? thunk msg tail-exn?)
  (##continuation-capture
   (lambda (return)
     (with-exception-handler
      (lambda (e)
        (##continuation-capture
         (lambda (cont)
           (##continuation-graft
            return
            (lambda ()
              (let ((creator (##continuation-creator cont)))
                (cond ((##not (exn? e))
                       (##failed-check msg e))
                      ((and tail-exn?
                            (##not (##eq? creator ##call-thunk)))
                       (##failed-check
                        msg
                        (##list 'nontail-exception-raised-in creator))))))))))
      (lambda ()
        (##failed-check msg (##call-thunk thunk)))))))

(define (##call-thunk thunk)
  ;; make sure continuation of thunk has ##call-thunk as creator
  (##first-argument (thunk)))

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

           (define (##expand-check-exn src tail-exn?)
             (##deconstruct-call
              src
              -3
              (lambda (exn? thunk #!optional comment)
                (let ((msg (##failed-check-msg src)))
                  (##sourcify
                   (list (##sourcify '##check-exn-proc src)
                         (##sourcify exn? src)
                         (##sourcify thunk src)
                         (##sourcify msg src)
                         (##sourcify tail-exn? src))
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
                      (##expand-check-exn src #f))
                     ((check-tail-exn)
                      (##expand-check-exn src #t))

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
(##define-syntax check-tail-exn   (lambda (src) (##expand-check src)))

(define (exit0-when-unimplemented-operation-os-exception thunk)
  (with-exception-catcher
   (lambda (e)
     (if (and (os-exception? e)
              (equal? (##os-err-code->string (os-exception-code e))
                      "Unimplemented operation"))
         (exit 0)
         (raise e)))
   thunk))

;;;============================================================================
