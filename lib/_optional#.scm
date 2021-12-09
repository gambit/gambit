;;;============================================================================

;;; File: "_optional#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Implementation of :optional and let-optionals* special forms that
;; are used in some SRFIs.

(define-syntax :optional
  (syntax-rules ()

    ((_ rest default-exp)
     (let ((%rest rest))
       (if (pair? %rest)
           (if (null? (cdr %rest))
               (car %rest)
               (error "too many optional arguments" %rest))
           default-exp)))

    ((_ rest default-exp arg-test)
     (let ((%rest rest))
       (if (pair? %rest)
           (if (null? (cdr %rest))
               (let ((%val (car %rest)))
                 (if (arg-test %val)
                     %val
                      (error "optional argument failed test" 'arg-test %val)))
               (error "too many optional arguments" %rest))
           default-exp)))))

(define-syntax let-optionals*
  (syntax-rules ()
    ((_ args (clause ...) body ...)
     (let ((%args args))
       (%let-optionals* %args (clause ...) body ...)))))

(define-syntax let-optionals
  (syntax-rules ()
    ((_ args (clause ...) body ...)
     (let ((%args args))
       (%let-optionals* %args (clause ...) body ...)))))

(define-syntax %let-optionals*
  (syntax-rules ()

    ((_ args (((var ...) external-arg-parser) clause ...) body ...)
     (call-with-values
         (lambda () (external-arg-parser args))
       (lambda (args var ...)
         (%let-optionals* args (clause ...) body ...))))

    ((_ args ((var default) clause ...) body ...)
     (let* ((%supplied? (pair? args))
            (var (if %supplied? (car args) default))
            (args (if %supplied? (cdr args) args)))
       (%let-optionals* args (clause ...) body ...)))

    ((_ args ((var default arg-test) clause ...) body ...)
     (let* ((%supplied? (pair? args))
            (var (if %supplied? (car args) default)))
       (if (or (not %supplied?) arg-test)
           (let ((args (if %supplied? (cdr args) args)))
             (%let-optionals* args (clause ...) body ...))
           (error "let-optionals* failed test" 'arg-test))))

    ((_ args ((var default arg-test supplied?) clause ...) body ...)
     (let* ((%supplied? (pair? args))
            (var (if %supplied? (car args) default)))
       (if (or (not %supplied?) arg-test)
           (let* ((args (if %supplied? (cdr args) args))
                  (supplied? %supplied?))
             (%let-optionals* args (clause ...) body ...))
           (error "let-optionals* failed test" 'arg-test))))

    ((_ args (rest) body ...)
     (let ((rest args)) body ...))

    ((_ args () body ...)
     (if (null? args)
         (begin body ...)
         (error "let-optionals* received too many arguments:" args)))))

;;;============================================================================
