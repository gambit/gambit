;;;============================================================================

;;; File: "gambit/match/match-expand.scm"

;;; Copyright (c) 2008-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Pattern-matching 'match' special form expander.

(##supply-module gambit/match/match-expand)

(##namespace ("gambit/match/match-expand#")) ;; in gambit/match/match-expand#
(##include "~~lib/_prim#.scm")               ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")             ;; for macro-check-procedure,
                                             ;; macro-absent-obj, etc

(##include "match-expand#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(define (match-expand src use-question-mark-prefix-pattern-variables?)

  (define expansion-debug? #f)

  (define (pattern-variable? x)
    (if use-question-mark-prefix-pattern-variables?

        ;; ?var syntax for pattern variables
        (and (symbol? x)
             (let* ((str (symbol->string x))
                    (len (string-length str)))
               (and (>= len 0)
                    (char=? #\? (string-ref str 0))
                    (string->symbol (substring str 1 len)))))

        ;; ,var syntax for pattern variables
        (and (pair? x)
             (pair? (cdr x))
             (null? (cddr x))
             (eq? (source-code (car x)) 'unquote)
             (symbol? (source-code (cadr x)))
             (cadr x))))

  (define (source-code src)
    (if (##source? src)
        (##source-code src)
        src))

  (define gensym ;; a version of gensym useful for debugging
    (let ((count 0))
      (lambda ()
        (set! count (+ count 1))
        (string->symbol (string-append "$g" (number->string count))))))

  (define (expand subject . clauses)

    (define (if-equal? var pattern-src yes no)
      (let ((pattern (source-code pattern-src)))
        (cond ((pattern-variable? pattern)
               =>
               (lambda (pattern-var)
                 `(##let ((,pattern-var ,var))
                    ,yes)))
              ((null? pattern)
               `(##if (##null? ,var) ,yes ,no))
              ((symbol? pattern)
               `(##if (##eq? ,var ',pattern) ,yes ,no))
              ((boolean? pattern)
               `(##if (##eq? ,var ,pattern) ,yes ,no))
              ((or (number? pattern)
                   (char? pattern))
               `(##if (##eqv? ,var ,pattern) ,yes ,no))
              ((string? pattern)
               `(##if (##equal? ,var ,pattern) ,yes ,no))
              ((pair? pattern)
               (let ((carvar (gensym))
                     (cdrvar (gensym)))
                 `(##if (##pair? ,var)
                        (##let ((,carvar (##car ,var)))
                          ,(if-equal?
                            carvar
                            (car pattern)
                            `(##let ((,cdrvar (##cdr ,var)))
                                    ,(if-equal?
                                      cdrvar
                                      (cdr pattern)
                                      yes
                                      no))
                            no))
                        ,no)))
              (else
               (error "unknown match pattern")))))

    (let* ((var
            (gensym))
           (fns
            (map (lambda (x) (gensym))
                 clauses))
           (default
             (gensym)))

      (let ((expansion
             `(##let ((,var ,subject))
                ,@(map (lambda (fn1 fn2 clause)
                         (let ((sc (source-code clause)))
                           (if (not (pair? sc))
                               (error "clause must be a list")
                               `(##define (,fn1)
                                  ,(if (eq? (source-code (car sc)) 'else)
                                       `(##begin ,@(cdr sc))
                                       (if-equal?
                                        var
                                        (car sc)
                                        (if (and (eq? (source-code (cadr sc))
                                                      'when)
                                                 (pair? (cddr sc)))
                                            `(##if ,(caddr sc)
                                                   (##begin ,@(cdddr sc))
                                                   (,fn2))
                                            `(##begin ,@(cdr sc)))
                                        `(,fn2)))))))
                            fns
                            (append (cdr fns) (list default))
                            clauses)

                     (##define (,default)
                       ;; (error "match failed" ,var)
                       #f)

                     (,(car fns)))))
        (if expansion-debug? (pretty-print expansion))
        expansion)))

  (##deconstruct-call src -2 expand))

;;;============================================================================
