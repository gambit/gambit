;;;============================================================================

;;; File: "#.scm"

;;; Copyright (c) 2013-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define epsilon 0)

(define ##failed-check? #f)
(define ##excluded-procedures '())
(define (##excluded-procedures-set! lst)
  (set! ##excluded-procedures lst))

;; at exit, verify if any checks failed
(let ((##exit-old ##exit))
  (set! ##exit
        (lambda rest
          (if (##pair? rest)
              (##exit-old (car rest))
              (begin
                (when ##enable-trace?
                  (let ((procedures-called-list (##table->list ##procedures-called)))
                    (##write (cons '%GAMBIT-COVERAGE% (##filter
                                                       (lambda (proc-nbcalls)
                                                         (##not (##memq (car proc-nbcalls) ##excluded-procedures)))
                                                       procedures-called-list))
                     ##stdout-port)))

                (when ##enable-syntactic-check?
                  (##write (cons '%GAMBIT-ANALYSE% ##procedures-list) ##stdout-port))

                (##exit-cleanup)
                (##exit-with-err-code-no-cleanup
                 (if ##failed-check? 2 1)))))))

(define ##failed-check-absent '$$fake-absent-object$$)

(define (##failed-check msg #!optional (actual-result ##failed-check-absent))
  (##println
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


(define (##record-procedure! code env)
  (##import _match)
  (match code
    ((lambda ,params ,e1 . ,rest)
     (for-each (lambda (expr)
                 (##record-procedure! expr env))
               (cons e1 rest)))

    ((if ,condition ,e1)
     (##record-procedure! condition env)
     (##record-procedure! e1 env))

    ((if ,condition ,e1 ,e2)
     (##record-procedure! condition env)
     (##record-procedure! e1 env)
     (##record-procedure! e2 env))

    ((begin . ,rest)
     (for-each (lambda (expr)
                 (##record-procedure! expr env))
               rest))

    ((,form-let ,bindings ,e1 . ,rest) when (memq form-let '(let let* letrec letrec* let-values))
     (begin
       (for-each
         (lambda (binding)
           (and (pair? binding)
                (pair? (cdr binding))
                (let ((expr (cadr binding)))
                  (##record-procedure! expr env))))
         bindings)

       (for-each
         (lambda (expr)
           (##record-procedure! expr env))
         (cons e1 rest))))

    ((,e1 . ,rest)
     (cond
       ((and (symbol? e1)
             (not (##primitive-namespace? e1))
             (not (memq e1 env)))
        (let ((proc (##global-var-ref (##make-global-var e1))))
          (if (##procedure? proc)
            (let ((code (##decompile proc)))
              (if (eq? proc code)
                (##add-to-procedures-list! e1)
                (##record-procedure! code (cons e1 env)))
              (for-each
                (lambda (arg)
                  (##record-procedure! arg (cons e1 env)))
                rest)))))
       ((pair? e1)
        (##record-procedure! e1 env))))

    (,sym when (symbol? sym)
     (if (not (memq sym env))
       (let ((val (##global-var-primitive-ref (##make-global-var sym))))
         (if (##procedure? val)
           (##add-to-procedures-list! sym)))))

    (,other
     (void))))

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
                  ,(if ##enable-syntactic-check?
                     `(let (($e1-code ',(##sourcify expr1 src))
                            ($e2-code ',(##sourcify expr2 src)))
                        (##record-procedure! $e1-code '())
                        (##record-procedure! $e2-code '())))
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

(define (##primitive-namespace? sym)
  (##string-prefix? "##" (##symbol->string sym)))

(define ##procedures-list '())
(define ##add-to-procedures-list!
  (lambda (sym)
    ;; Exclude primitive procedure
    (or (##primitive-namespace? sym)
        (##memq sym ##procedures-list)
        (set! ##procedures-list (##cons sym ##procedures-list)))))

(define ##procedures-called (make-table))
(define ##procedures-called-mutex (make-mutex))

(define-macro (##setup-trace)
  (eval '(begin
           (define ##enable-trace?
             (let ((ret (##global-var-ref (##make-global-var '##enable-trace?))))
               (and (not (##unbound? ret))
                    (##boolean? ret)
                    ret)))
           (define ##enable-syntactic-check?
             (let ((ret (##global-var-ref (##make-global-var '##enable-syntactic-check?))))
               (and (not (##unbound? ret))
                    (##boolean? ret)
                    ret)))))

  (if (not ##enable-trace?)
    '(##begin)
    '(let* ((stepper (##current-stepper))
            (stepper-copy (vector-copy stepper)))
       (vector-set!
         stepper
         1 ;; index of call handler in stepper
         (parameterize ((##current-stepper stepper-copy))

           ;; need to create this call handler in the context of a new
           ;; stepper so that the calls it executes will not invoke the call handler

           (eval '(let ((primitive-namespace? (lambda (proc-name)
                                                (##string-prefix? "##" (##symbol->string proc-name))))
                        (symbol->primitive (lambda (proc-name)
                                             (##global-var-primitive-ref (##make-global-var proc-name)))))

                    (lambda (leapable? $code rte execute-body . other)
                      (let* ((proc (car other))
                             (proc-name (##procedure-friendly-name proc))) ;; procedure being called
                        (when (and (symbol? proc-name)
                                   (not (primitive-namespace? proc-name))
                                   (eq? proc (symbol->primitive proc-name)))
                          (mutex-lock! ##procedures-called-mutex)
                          (table-set! ##procedures-called
                                      proc-name
                                      (+ 1 (table-ref ##procedures-called proc-name 0)))
                          (mutex-unlock! ##procedures-called-mutex))
                        (apply execute-body (cons $code (cons rte other))))))))))))

(##setup-trace)

;;;============================================================================
