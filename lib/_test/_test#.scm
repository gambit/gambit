;;;============================================================================

;;; File: "_test#.scm"

;;; Copyright (c) 2013-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Testing framework.

(##namespace ("_test#"

test-assert
test-equal
test-eqv
test-eq
test-approximate
test-error
test-error-tail
test-begin
test-end
test-group

test-all?-set!
test-quiet?-set!
test-verbose?-set!

test-predicate-proc
test-relation-proc
test-approximate-proc
test-error-proc
test-begin-proc
test-end-proc
test-group-proc

$expand-test$

))

;;;----------------------------------------------------------------------------

(##define-syntax test-assert      (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-equal       (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-eqv         (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-eq          (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-approximate (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-error       (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-error-tail  (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-begin       (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-end         (lambda (src) `($expand-test$ ,src)))
(##define-syntax test-group       (lambda (src) `($expand-test$ ,src)))

(##define-syntax $expand-test$
  (lambda (src)

    (define (absent) #f) ;; to identify absent parameters

    (define (expand-test src)
      (if #f ;; for now tests are always enabled
          '(##begin)
          (expand-test* src)))

    (define (expand-test* src)
      (let ((form (##source-strip src)))
        (case (##source-strip (car form))

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
            src)))))

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
       `(_test#test-predicate-proc ,test-name
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
       `(_test#test-relation-proc ,test-name
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
       `(_test#test-approximate-proc ,test-name
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
       `(_test#test-error-proc ,test-name
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
          `(_test#test-begin-proc ,suite-name
                                  ,count)))))

    (define (expand-test-end src)
      (##deconstruct-call
       src
       -1
       (lambda (#!optional (suite-name #f))
         (test-generate
          `(_test#test-end-proc ,suite-name)))))

    (define (expand-test-group src)
      (##deconstruct-call
       src
       -3
       (lambda (suite-name . decl-or-exprs)
         (test-generate
          `(_test#test-group-proc ,suite-name
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

    (##deconstruct-call src 2 expand-test)))

;;;============================================================================
