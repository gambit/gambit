;;;============================================================================

;;; File: "#.scm"

;;; Copyright (c) 2013-2026 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define ##failed-test? #f)

(define (##failed-test msg #!optional (actual-result ##failed-test-absent))
  (println
   (call-with-output-string
    ""
    (lambda (port)
      (##display msg port)
      (if (##not (##eq? actual-result ##failed-test-absent))
          (begin
            (##display " GOT " port)
            (##write actual-result port))))))
  (set! ##failed-test? #t))

(define ##failed-test-absent '$$fake-absent-object$$)

(define (##test-error-proc error-type test-expr-thunk msg tail-exn?)
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
                (cond ((and (##procedure? error-type)
                            (##not (error-type e)))
                       (##failed-test msg e))
                      ((and tail-exn?
                            (##not (##eq? creator ##call-thunk)))
                       (##failed-test
                        msg
                        (##list 'nontail-exception-raised-in creator))))))))))
      (lambda ()
        (##failed-test msg (##call-thunk test-expr-thunk)))))))

(define (##call-thunk thunk)
  ;; make sure continuation of thunk has ##call-thunk as creator
  (##first-argument (thunk)))

(define (##test-approximate-proc expected test-expr-value error msg)

  (define (isnan? x)
    (##not (##= x x)))

  (define (similar? x y)
    (or (and (isnan? x)
             (isnan? y))
        (and (##infinite? x)
             (##infinite? y)
             (##= x y))
        (and (##finite? x)
             (##finite? y)
             (##<= (##abs (##- x y)) error))))

  (if (##not (and (##number? expected)
                  (##number? test-expr-value)
                  (similar? (##real-part expected)
                            (##real-part test-expr-value))
                  (similar? (##imag-part expected)
                            (##imag-part test-expr-value))))
      (begin
        #; (pp (list expected test-expr-value))  ;; for debugging purposes
        (##failed-test msg test-expr-value))))

(##define-macro (##setup-test)

  (define tested-procs (cons #f '()))

  (eval `(##begin

           (define ##enable-tests?
             (make-parameter #t))

           (define ##tested-procs-tbl
             (##make-table 'test: ##eq?))

           (define ##tested-procs ',tested-procs)

           (define (##determine-tested-procedures src)

             (define (walk expr)
               ;; This parses a subset of Scheme expressions that
               ;; probably covers all the forms of expressions that might
               ;; occur in test expressions. Extend as needed.
               (if (pair? expr)
                   (case (car expr)
                     ((quote)
                      #f)
                     ((lambda set!)
                      (for-each walk (cddr expr)))
                     ((if and or begin)
                      (for-each walk (cdr expr)))
                     ((let let* letrec letrec*)
                      (for-each walk (map cadr (cadr expr)))
                      (for-each walk (cddr expr)))
                     ((cond)
                      (for-each
                       (lambda (clause)
                         (if (not (eq? (car clause)) 'else)
                             (walk (car clause)))
                         (if (pair? (cdr clause))
                             (begin
                               (if (not (eq? (cadr clause)) '=>)
                                   (walk (cadr clause)))
                               (for-each walk (cddr clause)))))
                       (cdr expr)))
                     ((case)
                      (for-each
                       (lambda (clause)
                         (walk (cdr clause)))
                       (cdr expr)))
                     (else
                      (let ((first (car expr)))
                        (if (symbol? first)
                            (if (not (table-ref ##tested-procs-tbl first #f))
                                (begin
                                  (set-cdr! ##tested-procs
                                            (cons first (cdr ##tested-procs)))
                                  (table-set! ##tested-procs-tbl first #t))))
                        (for-each walk expr))))))

             (if (not (getenv "GAMBIT_COVERAGE" #f))
                 (walk (##desourcify src))))

           (define (##expand-test-relation src positive? relation)
             (##deconstruct-call
              src
              -2
              (lambda (a #!optional (b '$absent$) (c '$absent$))
                (let ((test-name
                       (if (eq? c '$absent$) #f a))
                      (expected
                       (if (eq? c '$absent$) (if (eq? b '$absent$) #t a) b))
                      (test-expr
                       (if (eq? c '$absent$) (if (eq? b '$absent$) a b) c)))
                  (##determine-tested-procedures test-expr)
                  (let ((report (##failed-test-gen src '$actual-result$)))
                    `(let (($expected-result$ ,(##sourcify expected src))
                           ($actual-result$ ,(##sourcify test-expr src)))
                       (if (,relation $expected-result$ $actual-result$)
                           ,(if positive? #f report)
                           ,(if positive? report #f))))))))

           (define (##expand-test-assert src positive?)
             (##deconstruct-call
              src
              -1
              (lambda (a #!optional (b '$absent$))
                (let ((test-name
                       (if (eq? b '$absent$) #f a))
                      (expression
                       (if (eq? b '$absent$) a b)))
                  (##determine-tested-procedures expression)
                  (let ((report (##failed-test-gen src #f)))
                    `(if (##not ,expression)
                         ,report
                         #f))))))

           (define (##expand-test-error src tail-exn?)
             (##deconstruct-call
              src
              -2
              (lambda (a #!optional (b '$absent$) (c '$absent$))
                (let ((test-name
                       (if (eq? c '$absent$) #f a))
                      (error-type
                       (if (eq? c '$absent$) (if (eq? b '$absent$) #t a) b))
                      (test-expr
                       (if (eq? c '$absent$) (if (eq? b '$absent$) a b) c)))
                  (##determine-tested-procedures test-expr)
                  (let ((msg (##failed-test-msg src)))
                    (##sourcify
                     (list (##sourcify '##test-error-proc src)
                           (##sourcify error-type src)
                           (##sourcify `(lambda () ,test-expr) src)
                           (##sourcify msg src)
                           (##sourcify tail-exn? src))
                     src))))))

           (define (##expand-test-approximate src)
             (##deconstruct-call
              src
              -3
              (lambda (a b c #!optional (d '$absent$))
                (let ((test-name
                       (if (eq? d '$absent$) #f a))
                      (expected
                       (if (eq? d '$absent$) a b))
                      (test-expr
                       (if (eq? d '$absent$) b c))
                      (error
                       (if (eq? d '$absent$) c d)))
                  (##determine-tested-procedures test-expr)
                  (let ((msg (##failed-test-msg src)))
                    (##sourcify
                     (list (##sourcify '##test-approximate-proc src)
                           (##sourcify expected src)
                           (##sourcify test-expr src)
                           (##sourcify error src)
                           (##sourcify msg src))
                     src))))))

           (define (##expand-test src)
             (if (not (##enable-tests?))
                 '(##begin)
                 (let ((form (##source-strip src)))
                   (case (##source-strip (car form))

                     ((test-assert)
                      (##expand-test-assert src #t))
                     ((test-equal)
                      (##expand-test-relation src #t '##equal?))
                     ((test-eqv)
                      (##expand-test-relation src #t '##eqv?))
                     ((test-eq)
                      (##expand-test-relation src #t '##eq?))

                     ((test-approximate)
                      (##expand-test-approximate src))

                     ((test-error)
                      (##expand-test-error src #f))
                     ((test-error-tail)
                      (##expand-test-error src #t))

                     (else
                      (##raise-expression-parsing-exception
                       'ill-formed-special-form
                       src))))))

           (define (##failed-test-msg src)
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

           (define (##failed-test-gen src actual-result)
             (##sourcify
              (list (##sourcify '##failed-test src)
                    (##sourcify (##failed-test-msg src) src)
                    (##sourcify actual-result src))
              src))
           ))

  `(define ##tested-procs (##cdr ',tested-procs)))

(##setup-test)

;; SRFI 64 compatible forms:

(##define-syntax test-assert      (lambda (src) (##expand-test src)))
(##define-syntax test-equal       (lambda (src) (##expand-test src)))
(##define-syntax test-eqv         (lambda (src) (##expand-test src)))
(##define-syntax test-eq          (lambda (src) (##expand-test src)))
(##define-syntax test-approximate (lambda (src) (##expand-test src)))
(##define-syntax test-error       (lambda (src) (##expand-test src)))

;; SRFI 64 extension:

(##define-syntax test-error-tail  (lambda (src) (##expand-test src)))








(define epsilon 0)

(define ##failed-check? #f)

;; at exit, verify if any checks failed
(let ((##exit-old ##exit))
  (set! ##exit
        (lambda rest
          (if (pair? rest)
              (##exit-old (car rest))
              (begin

                (if (##getenv "GAMBIT_COVERAGE" #f)
                    (let ((coverage (##make-table 'test: ##eq?)))
                      (##for-each
                       (lambda (proc)
                         (##table-set! coverage proc #t))
                       (if (##file-exists? "gambit-coverage")
                           (##with-input-from-file "gambit-coverage" read-all)
                           '()))
                      (##for-each
                       (lambda (proc)
                         (##table-set! coverage proc #t))
                       ##tested-procs)
                      (##with-output-to-file
                          "gambit-coverage"
                        (lambda ()
                          (##for-each
                           (lambda (proc)
                             (##pretty-print proc))
                           (##list-sort
                            (lambda (x y)
                              (##string<=? (##symbol->string x)
                                           (##symbol->string y)))
                            (##map ##car (##table->list coverage))))))))

                (##exit-cleanup)
                (##exit-with-err-code-no-cleanup
                 (if (or ##failed-test? ##failed-check?) 2 1)))))))

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

#;
(define (##call-thunk thunk)
  ;; make sure continuation of thunk has ##call-thunk as creator
  (##first-argument (thunk)))

(define (##check-=-proc n1 n2 tolerance msg)

  (define (isnan? x)
    (##not (##= x x)))

  (define (similar? x y)
    (or (and (isnan? x)
             (isnan? y))
        (and (##infinite? x)
             (##infinite? y)
             (##= x y))
        (and (##finite? x)
             (##finite? y)
             (##<= (##abs (##- x y)) tolerance))))

  (if (##not (and (##number? n1)
                  (##number? n2)
                  (similar? (##real-part n1) (##real-part n2))
                  (similar? (##imag-part n1) (##imag-part n2))))
      (begin
        #; (pp (list n1 n2))  ;; for debugging purposes
        (##failed-check msg n1))))

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
               (##determine-tested-procedures expr1)
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
                  (##determine-tested-procedures expr1)
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
                  (##determine-tested-procedures thunk)
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

;;;============================================================================
