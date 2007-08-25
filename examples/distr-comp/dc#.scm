;==============================================================================

; File: "dc#.scm", Time-stamp: <2007-04-04 14:25:51 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("dc#"

; special forms

spawn
recv

; procedures

self
pid?
make-tag
!
?
!?
make-tcp-node
goto
on

spawn-thread
current-node
current-node-id
current-node-name
become-tcp-node
default-tcp-node-port-number
default-tcp-node-name

))

;------------------------------------------------------------------------------

; Implementation of the basic Termite special forms:
;
;   (spawn X)   returns a reference to a newly created process which
;               evaluates X
;
;   (recv ...)  retrieves oldest message from the mailbox that matches
;               a pattern

(##define-macro (spawn . body)
  `(spawn-thread (lambda () ,@body)))

(##define-macro (recv . clauses)

  (define (parse-clauses clauses rev-pattern-clauses cont)
    (cond ((null? clauses)
           (cont (reverse rev-pattern-clauses)
                 #f))
          ((and (pair? (car clauses))
                (eq? (car (car clauses)) 'after:))
           (cond ((not (null? (cdr clauses)))
                  (error "after clause must be last"))
                 ((not (>= (length (car clauses)) 2))
                  (error "after clause must specify timeout"))
                 (else
                  (cont (reverse rev-pattern-clauses)
                        (car clauses)))))
          (else
           (parse-clauses (cdr clauses)
                          (cons (car clauses) rev-pattern-clauses)
                          cont))))

  (define (gen-clauses subject clauses gen-fail)
    (if (null? clauses)
        (gen-fail)
        (gen-fail-binding subject
                          (cdr clauses)
                          (lambda (gen-fail)
                            (gen-clause subject
                                        (car clauses)
                                        gen-fail))
                          gen-fail)))

  (define (gen-fail-binding subject clauses gen-body gen-fail)
    (if (null? clauses)
        (gen-body gen-fail)
        (let ((fail-var (gensym)))
          `(let ((,fail-var
                  (lambda ()
                    ,(gen-clauses subject clauses gen-fail))))
             ,(gen-body (lambda () `(,fail-var)))))))

  (define (gen-complete exprs)
    (gen-begin (cons `(thread-mailbox-extract-and-rewind) exprs)))

  (define (gen-clause subject clause gen-fail)
    (let ((pattern (car clause)))
      (gen-match subject
                 pattern
                 (lambda ()
                   (let ((second (cadr clause)))
                     (if (eq? second 'with:)
                         `(if ,(caddr clause)
                              ,(gen-complete (cdddr clause))
                              ,(gen-fail))
                         (gen-complete (cdr clause)))))
                 gen-fail)))

  (define (gen-matches subject-and-patterns gen-success gen-fail)
    (if (null? subject-and-patterns)
        (gen-success)
        (let ((subj-and-pat (car subject-and-patterns)))
          (gen-match (car subj-and-pat)
                     (cdr subj-and-pat)
                     (lambda ()
                       (gen-matches (cdr subject-and-patterns)
                                    gen-success
                                    gen-fail))
                     gen-fail))))

  (define (gen-match subject pattern gen-success gen-fail)
    (cond ((eq? pattern '_)
           (gen-success))
          ((symbol? pattern)
           `(let ((,pattern ,subject))
              ,(gen-success)))
          ((or (number? pattern)
               (boolean? pattern)
               (string? pattern)
               (char? pattern)
               (keyword? pattern))
           (gen-match-literal subject pattern gen-success gen-fail))
          ((and (pair? pattern)
                (pair? (cdr pattern))
                (null? (cddr pattern))
                (eq? (car pattern) 'quote))
           (gen-match-literal subject (cadr pattern) gen-success gen-fail))
          ((and (pair? pattern)
                (pair? (cdr pattern))
                (null? (cddr pattern))
                (eq? (car pattern) 'unquote))
           (gen-match-expression subject (cadr pattern) gen-success gen-fail))
          ((pair? pattern)
           (gen-match-pair subject pattern gen-success gen-fail))
          ((null? pattern)
           `(if (null? ,subject)
                ,(gen-success)
                ,(gen-fail)))
          ((vector? pattern)
           (gen-match-vector subject pattern gen-success gen-fail))
          (else
           (error "gen-match encountered an unknown pattern" pattern))))

  (define (gen-match-literal subject pattern gen-success gen-fail)
    `(if (equal? ,subject ',pattern)
         ,(gen-success)
         ,(gen-fail)))

  (define (gen-match-expression subject pattern gen-success gen-fail)
    `(if (equal? ,subject ,pattern)
         ,(gen-success)
         ,(gen-fail)))

  (define (gen-match-pair subject pattern gen-success gen-fail)
    (force-var
     subject
     (lambda (subject-var)
       `(if (pair? ,subject-var)
            ,(gen-matches (list (cons `(car ,subject-var) (car pattern))
                                (cons `(cdr ,subject-var) (cdr pattern)))
                          gen-success
                          gen-fail)
            ,(gen-fail)))))

  (define (gen-match-vector subject pattern gen-success gen-fail)
    (force-var
     subject
     (lambda (subject-var)
       (let ((len (vector-length pattern)))
         `(if (and (vector? ,subject-var)
                   (= (vector-length ,subject-var) ,len))
              ,(gen-matches (map (lambda (i)
                                   (cons `(vector-ref ,subject-var ,i)
                                         (vector-ref pattern i)))
                                 (iota len))
                            gen-success
                            gen-fail)
              ,(gen-fail))))))

  (define (force-var subject proc)
    (if (symbol? subject)
        (proc subject)
        (let ((var (gensym)))
          `(let ((,var ,subject))
             ,(proc var)))))

  (define (gen-begin exprs)
    (cond ((null? exprs)
           `(void))
          ((null? (cdr exprs))
           (car exprs))
          (else
           `(begin ,@exprs))))

  (define (iota n)

    (define (iot n lst)
      (if (= n 0)
          lst
          (iot (- n 1) (cons (- n 1) lst))))

    (iot n '()))

  (parse-clauses
   clauses
   '()
   (lambda (pattern-clauses after-clause)
     (let* ((subject-var
             (gensym))
            (loop-var
             (gensym))
            (body
             (gen-clauses subject-var
                          pattern-clauses
                          (lambda ()
                            `(,loop-var)))))
       (if after-clause
           (let ((timeout-var (gensym)))
             `(let ((,timeout-var (timeout->time ,(cadr after-clause))))
                (let ,loop-var ()
                  (let ((,subject-var
                         (thread-mailbox-next ,timeout-var #!void)))
                    (if (eq? ,subject-var #!void)
                        ,(gen-begin (cddr after-clause))
                        ,body)))))
           `(let ,loop-var ()
              (let ((,subject-var
                     (thread-mailbox-next)))
                ,body)))))))

;==============================================================================
