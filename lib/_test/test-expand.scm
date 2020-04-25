;;;============================================================================

;;; File: "_test-expand.scm"

;;; Copyright (c) 2013-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Testing forms expander.

(##supply-module _test/test-expand)

(##namespace ("_test-expand#"))

(##include "test-expand#.scm")

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##include "~~lib/gambit/prim/prim#.scm")

;;;============================================================================

(define (test-expand src name)

  (define (absent) #f) ;; to identify absent parameters

  (define (expand-test src name)
    (if #f ;; for now tests are always enabled
        '(##begin)
        (expand-test* src name)))

  (define (expand-test* src name)
    (case name

      ((test-assert)
       (expand-test-pred src #f '##not))

      ((test-equal)
       (expand-test-rel src #t '##equal?))
      ((test-eqv)
       (expand-test-rel src #t '##eqv?))
      ((test-eq)
       (expand-test-rel src #t '##eq?))

      ((test-approximate)
       (expand-test-approx src #t))

      ((test-error)
       (expand-test-err src #f))
      ((test-error-tail)
       (expand-test-err src #t))

      ((test-begin)
       (expand-test-begin src))
      ((test-end)
       (expand-test-end src))
      ((test-group)
       (expand-test-group src))

      (else
       (##raise-expression-parsing-exception
        'ill-formed-special-form
        src
        name))))

  (define (expand-test-pred src positive? predicate)
    (##deconstruct-call
     src
     -2
     (lambda (test-name #!optional (expression absent))
       (cond ((eq? expression absent)
              (expand-test-predicate src
                                     positive?
                                     predicate
                                     #f
                                     test-name))
             (else
              (expand-test-predicate src
                                     positive?
                                     predicate
                                     test-name
                                     expression))))))

  (define (expand-test-predicate src
                                 positive?
                                 predicate
                                 test-name
                                 expression)
    (test-generate
     `(%test-predicate ,test-name
                       (lambda () ,expression)
                       ,positive?
                       ,predicate
                       ,(test-location-generate src)
                       ,(test-expression-generate src))))

  (define (expand-test-rel src positive? relation)
    (##deconstruct-call
     src
     -3
     (lambda (test-name expected #!optional (test-expr absent))
       (cond ((eq? test-expr absent)
              (expand-test-relation src
                                    positive?
                                    relation
                                    #f
                                    test-name
                                    expected))
             (else
              (expand-test-relation src
                                    positive?
                                    relation
                                    test-name
                                    expected
                                    test-expr))))))

  (define (expand-test-relation src
                                positive?
                                relation
                                test-name
                                expected
                                test-expr)
    (test-generate
     `(%test-relation ,test-name
                      (lambda () ,expected)
                      (lambda () ,test-expr)
                      ,positive?
                      ,relation
                      ,(test-location-generate src)
                      ,(test-expression-generate src))))

  (define (expand-test-approx src positive?)
    (##deconstruct-call
     src
     -4
     (lambda (test-name expected test-expr #!optional (error absent))
       (cond ((eq? error absent)
              (expand-test-approximate src
                                       positive?
                                       #f
                                       test-name
                                       expected
                                       test-expr))
             (else
              (expand-test-approximate src
                                       positive?
                                       test-name
                                       expected
                                       test-expr
                                       error))))))

  (define (expand-test-approximate src
                                   positive?
                                   test-name
                                   expected
                                   test-expr
                                   error)
    (test-generate
     `(%test-approximate ,test-name
                         (lambda () ,expected)
                         (lambda () ,test-expr)
                         ,error
                         ,positive?
                         ,(test-location-generate src)
                         ,(test-expression-generate src))))

  (define (expand-test-err src tail?)
    (##deconstruct-call
     src
     -2
     (lambda (test-name #!optional (error-type absent) (test-expr absent))
       (cond ((eq? error-type absent)
              (expand-test-error src
                                 tail?
                                 #f
                                 #f
                                 test-name))
             ((eq? test-expr absent)
              (expand-test-error src
                                 tail?
                                 #f
                                 test-name
                                 error-type))
             (else
              (expand-test-error src
                                 tail?
                                 test-name
                                 error-type
                                 test-expr))))))

  (define (expand-test-error src
                             tail?
                             test-name
                             error-type
                             test-expr)
    (test-generate
     `(%test-error ,test-name
                   ,error-type
                   (lambda () ,test-expr)
                   ,tail?
                   ,(test-location-generate src)
                   ,(test-expression-generate src))))

  (define (expand-test-begin src)
    (##deconstruct-call
     src
     -2
     (lambda (suite-name #!optional (count #f))
       (test-generate
        `(%test-begin ,suite-name
                      ,count)))))

  (define (expand-test-end src)
    (##deconstruct-call
     src
     -1
     (lambda (#!optional (suite-name #f))
       (test-generate
        `(%test-end ,suite-name)))))

  (define (expand-test-group src)
    (##deconstruct-call
     src
     -3
     (lambda (suite-name . decl-or-exprs)
       (test-generate
        `(%test-group ,suite-name
                      (lambda () ,@decl-or-exprs))))))

  (define (test-generate expr)
    expr)

  (define (test-location-generate src)
    (call-with-output-string
      ""
      (lambda (port)
        (let ((locat (##source-locat src)))
          (if locat
              (begin
                (##display-locat locat #t port)
                (display ": " port)))))))

  (define (test-expression-generate src)
    (call-with-output-string
      ""
      (lambda (port)
        (write (##desourcify src) port))))

  (expand-test src name))

;;;============================================================================
