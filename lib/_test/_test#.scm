;;;============================================================================

;;; File: "_test#.scm"

;;; Copyright (c) 2013-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Testing framework.

(##namespace ("_test#"

check-equal?
check-not-equal?
check-eqv?
check-not-eqv?
check-eq?
check-not-eq?

check-=

check-true
check-false
check-not-false

check-exn
check-tail-exn

$expand-check$

))

;;;----------------------------------------------------------------------------

(##define-syntax check-equal?     (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-not-equal? (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-eqv?       (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-not-eqv?   (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-eq?        (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-not-eq?    (lambda (src) `($expand-check$ ,src)))

(##define-syntax check-=          (lambda (src) `($expand-check$ ,src)))

(##define-syntax check-true       (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-false      (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-not-false  (lambda (src) `($expand-check$ ,src)))

(##define-syntax check-exn        (lambda (src) `($expand-check$ ,src)))
(##define-syntax check-tail-exn   (lambda (src) `($expand-check$ ,src)))

(##define-syntax $expand-check$
  (lambda (src)

    (define (expand-check src)
      (if #f ;; for now checks are always enabled
          '(##begin)
          (expand-check* src)))

    (define (expand-check* src)
      (let ((form (##source-strip src)))
        (case (##source-strip (car form))

          ((check-equal?)
           (expand-check-relation src #t '##equal?))
          ((check-not-equal?)
           (expand-check-relation src #f '##equal?))
          ((check-eqv?)
           (expand-check-relation src #t '##eqv?))
          ((check-not-eqv?)
           (expand-check-relation src #f '##eqv?))
          ((check-eq?)
           (expand-check-relation src #t '##eq?))
          ((check-not-eq?)
           (expand-check-relation src #f '##eq?))

          ((check-=)
           (expand-check-= src))

          ((check-true)
           (expand-check-value src #t '##eq? #t))
          ((check-false)
           (expand-check-value src #t '##eq? #f))
          ((check-not-false)
           (expand-check-value src #f '##eq? #f))

          ((check-exn)
           (expand-check-exn src #f))
          ((check-tail-exn)
           (expand-check-exn src #t))

          (else
           (##raise-expression-parsing-exception
            'ill-formed-special-form
            src)))))

    (define (expand-check-relation src positive? relation)
      (##deconstruct-call
       src
       -3
       (lambda (expr1 expr2 #!optional comment)
         (expand-check-rel src positive? relation expr1 expr2))))

    (define (expand-check-value src positive? relation val)
      (##deconstruct-call
       src
       -2
       (lambda (expr1 #!optional comment)
         (expand-check-rel src positive? relation expr1 val))))

    (define (expand-check-rel src positive? relation expr1 expr2)
      (let ((report (failed-check-generate src '$actual-result$)))
        `(##let (($actual-result$ ,(##sourcify expr1 src))
                 ($expected-result$ ,(##sourcify expr2 src)))
           (##if (,relation $actual-result$ $expected-result$)
                 ,(if positive? #f report)
                 ,(if positive? report #f)))))

    (define (expand-check-= src)
      (##deconstruct-call
       src
       -3
       (lambda (expr1 expr2 #!optional (tolerance '_test#epsilon) comment)
         (let ((msg (failed-check-message src)))
           (##sourcify
            (list (##sourcify '_test#check-=-proc src)
                  (##sourcify expr1 src)
                  (##sourcify expr2 src)
                  (##sourcify tolerance src)
                  (##sourcify msg src))
            src)))))

    (define (expand-check-exn src tail-exn?)
      (##deconstruct-call
       src
       -3
       (lambda (exn? thunk #!optional comment)
         (let ((msg (failed-check-message src)))
           (##sourcify
            (list (##sourcify '_test#check-exn-proc src)
                  (##sourcify exn? src)
                  (##sourcify thunk src)
                  (##sourcify msg src)
                  (##sourcify tail-exn? src))
            src)))))

    (define (failed-check-message src)
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

    (define (failed-check-generate src actual-result)
      (##sourcify
       (list (##sourcify '_test#failed-check src)
             (##sourcify (failed-check-message src) src)
             (##sourcify actual-result src))
       src))

    (##deconstruct-call src 2 expand-check)))

;;;============================================================================
