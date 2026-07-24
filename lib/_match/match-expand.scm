;;;============================================================================

;;; File: "match-expand.scm"

;;; Copyright (c) 2008-2025 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Pattern-matching 'match' and 'match-syntax' special forms expander.

(##supply-module _match/match-expand)

(##namespace ("_match/match-expand#"))    ;; in _match/match-expand#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "match-expand#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(define (match-expand
         src
         use-question-mark-prefix-pattern-variables?
         use-exhaustive-cases?
         use-else?
         allow-source?)

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
             (eq? (source-strip (car x)) 'unquote)
             (symbol? (source-strip (cadr x)))
             (cadr x))))

  (define (source-strip x)
    (##source-strip x))

  (define (gen-source-strip var)
    (if allow-source?
        `(##source-strip ,var)
        var))

  (define gensym ;; a version of gensym useful for debugging
    (let ((count 0))
      (lambda ()
        (set! count (+ count 1))
        (string->symbol (string-append "$g" (number->string count))))))

  (define (expand subject . clauses)

    (define (if-equal? var pattern-src yes no)
      (let ((pattern (source-strip pattern-src)))
        (cond ((pattern-variable? pattern)
               =>
               (lambda (pattern-var)
                 `(##let ((,pattern-var ,var))
                    ,yes)))
              ((null? pattern)
               `(##if (##null? ,(gen-source-strip var)) ,yes ,(no)))
              ((symbol? pattern)
               `(##if (##eq? ,(gen-source-strip var) ',pattern) ,yes ,(no)))
              ((keyword? pattern)
               `(##if (##eq? ,(gen-source-strip var) ',pattern) ,yes ,(no)))
              ((boolean? pattern)
               `(##if (##eq? ,(gen-source-strip var) ,pattern) ,yes ,(no)))
              ((or (number? pattern)
                   (char? pattern))
               `(##if (##eqv? ,(gen-source-strip var) ,pattern) ,yes ,(no)))
              ((string? pattern)
               `(##if (##equal? ,(gen-source-strip var) ,pattern) ,yes ,(no)))
              ((pair? pattern)
               (let ((carvar (gensym))
                     (cdrvar (gensym)))
                 `(##if (##pair? ,(gen-source-strip var))
                        (##let ((,carvar (##car ,(gen-source-strip var))))
                          ,(if-equal?
                            carvar
                            (car pattern)
                            `(##let ((,cdrvar (##cdr ,(gen-source-strip var))))
                               ,(if-equal?
                                 cdrvar
                                 (cdr pattern)
                                 yes
                                 no))
                            no))
                        ,(no))))
              (else
               (error "unknown match pattern")))))

    (define (else-clause? sc)
      (and use-else?
           (eq? (source-strip (car sc)) 'else)))

    (let* ((var
            (gensym))
           (default
             (gensym))
           (clauses*
            (let loop ((lst (reverse clauses))
                       (last default)
                       (clauses* (list (cons default (cons #f #t)))))
              (if (pair? lst)
                  (let* ((name (gensym))
                         (clause (car lst))
                         (sc (source-strip clause)))
                    (cond ((not (pair? sc))
                           (error "clause must be a list"))
                          ((and (else-clause? sc)
                                (not (eq? last default)))
                           (error "else clause must be last")))
                    (loop (cdr lst)
                          name
                          (cons (cons name (cons last clause)) clauses*)))
                  clauses*)))
           (defs
            '()))

      (define (call-clause-fn name)
        (let* ((x (assq name clauses*))
               (next (cadr x))
               (clause (cddr x)))

          (define (no)
            (call-clause-fn next))

          (if clause
              (begin
                (set-cdr! (cdr x) #f) ;; generate once
                (set! defs
                  (cons `(##define (,name)
                           ,(if next
                                (let ((sc (source-strip clause)))
                                  (if (else-clause? sc)
                                      `(##let () ,@(cdr sc))
                                      (if-equal?
                                       var
                                       (car sc)
                                       (if (and (pair? (cdr sc))
                                                (eq? (source-strip (cadr sc))
                                                     'when)
                                                (pair? (cddr sc)))
                                           `(##if ,(caddr sc)
                                                  (##let () ,@(cdddr sc))
                                                  ,(no))
                                           `(##let () ,@(cdr sc)))
                                       no)))
                                (if use-exhaustive-cases?
                                    `(##error "match failed" ,var)
                                    `#f)))
                        defs))))

          `(,name)))

      (let* ((body
              (call-clause-fn (car (car clauses*))))
             (expansion
              `(##let ((,var ,subject))
                 ,@defs
                 ,body)))
        (if expansion-debug? (pretty-print expansion))
        expansion)))

  (##deconstruct-call src -2 expand))

;;;============================================================================
