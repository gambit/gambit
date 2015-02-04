;;;============================================================================

;;; File: "_syntax-pattern.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements basic pattern matching functionnality that is
;; used in the implementation of syntax definition forms (both
;; syntax-rules and syntax-case).  It implements:
;;
;; - a compiler for syntax patterns
;; - a syntax pattern matcher

;; This file is typically used inside a macro definition body using an
;; (include "~~lib/_syntax-pattern.scm") so the toplevel definitions
;; in this file are actually local definitions of the enclosing macro
;; definition.  Nevertheless, all toplevel definitions define identifiers
;; that are prefixed with the "syn#" namespace.

;;;----------------------------------------------------------------------------

;; Define encoding of compiled patterns.

(define-macro (syn#pattern-var)            0)
(define-macro (syn#pattern-underscore)    -1)
(define-macro (syn#pattern-fixed-list)    -2)
(define-macro (syn#pattern-fixed-vect)    -3)
(define-macro (syn#pattern-tail-list)     -4)
(define-macro (syn#pattern-tail-vect)     -5)
(define-macro (syn#pattern-improper-list) -6)

;;;----------------------------------------------------------------------------

;; Syntax pattern compilation.

;; Compiled patterns are represented as follows:
;;
;; Pattern             Compiled pattern
;; <pattern variable>  #((syn#pattern-var))
;; _                   #((syn#pattern-underscore))
;; (P1 P2 P3)          #((syn#pattern-fixed-list) CP1 CP2 CP3)
;; #(P1 P2 P3)         #((syn#pattern-fixed-vect) CP1 CP2 CP3)
;; (P1 P2 P3 ...)      #((syn#pattern-tail-list) CP1 CP2 CP3)
;; #(P1 P2 P3 ...)     #((syn#pattern-tail-vect) CP1 CP2 CP3)
;; (P1 P2 . P3)        #((syn#pattern-improper-list) CP1 CP2 CP3)
;; <other>             <other>    note: can't be a list or vector

(define (syn#pattern-pvar? cpattern)
  (and (vector? cpattern)
       (let ((tag (vector-ref cpattern 0)))
         (= tag (syn#pattern-var)))))

(define (syn#pattern-ellipsis? src)
  (let ((code (##source-code src)))
    (eq? code '...)))

(define (syn#cp-list pattern code literals pattern-vars rank tag-offs cont)
  (let loop ((lst code)
             (rev-cpattern '())
             (new-pattern-vars pattern-vars))

    (cond ((pair? lst)
           (let ((first (##sourcify (car lst) pattern))
                 (rest (cdr lst)))
             (if (and (pair? rest)
                      (null? (cdr rest))
                      (syn#pattern-ellipsis? (##sourcify (car rest) pattern)))
                 (syn#cp
                  first
                  literals
                  new-pattern-vars
                  (+ rank 1)
                  (lambda (cpattern pvars)
                    (cont (list->vector
                           (cons (+ (syn#pattern-tail-list) tag-offs)
                                 (reverse (cons cpattern rev-cpattern))))
                          pvars)))
                 (syn#cp
                  first
                  literals
                  new-pattern-vars
                  rank
                  (lambda (cpattern pvars)
                    (loop rest
                          (cons cpattern rev-cpattern)
                          pvars))))))

          ((null? lst)
           (cont (list->vector
                  (cons (+ (syn#pattern-fixed-list) tag-offs)
                        (reverse rev-cpattern)))
                 new-pattern-vars))

          (else
           (syn#cp
            (##sourcify lst pattern)
            literals
            new-pattern-vars
            rank
            (lambda (cpattern pvars)
              (cont (list->vector
                     (cons (syn#pattern-improper-list)
                           (reverse (cons cpattern rev-cpattern))))
                    pvars)))))))

(define (syn#cp pattern literals pattern-vars rank cont)
  (let ((code (##source-code pattern)))

    (define (handle-symbol sym)
      (cond ((memq sym literals)
             (handle-constant sym))
            ((eq? sym '_)
             (cont (vector (syn#pattern-underscore))
                   pattern-vars))
            (else
             (let ((x (assq sym pattern-vars)))
               (if x
                   (error "duplicate pattern variable")
                   (let ((index (length pattern-vars)))
                     (cont (vector (syn#pattern-var)) ;; TODO: replace with '#(0) to allow sharing?
                           (cons (cons sym (cons index rank))
                                 pattern-vars))))))))

    (define (handle-constant const)
      (cont const ; const is not structured so desourcify not needed
            pattern-vars))

    (cond ((pair? code)
           (if (and (syn#pattern-ellipsis? (##sourcify (car code) pattern))
                    (let ((rest (cdr code)))
                      (and (pair? rest)
                           (syn#pattern-ellipsis? (##sourcify (car rest) pattern))
                           (null? (cdr rest)))))
               (handle-symbol '...)
               (syn#cp-list
                pattern
                code
                literals
                pattern-vars
                rank
                0
                cont)))

          ((vector? code)
           (syn#cp-list
            pattern
            (vector->list code)
            literals
            pattern-vars
            rank
            -1
            cont))

          ((symbol? code)
           (if (eq? code '...)
               (error "improperly placed ellipsis in pattern")
               (handle-symbol code)))

          (else
           (handle-constant code)))))

(define (syn#compile-pattern pattern literals cont)
  (syn#cp
   pattern
   literals
   '()
   0
   (lambda (cpattern pvars)
     (cont cpattern
           (reverse pvars)))))

;;;----------------------------------------------------------------------------

;; Syntax pattern matching.

(define (syn#match-success? x) ;; external representation of success is vector
  (vector? x))

(define (syn#fail? x) ;; internal representation of failure is vector
  (vector? x))

(define (syn#match-fail input msg . args)
  (list->vector (cons input (cons msg args))))

(define (syn#mp-list cpattern input code bindings)
  (let loop1 ((i 1)
              (lst code)
              (bs bindings))

    (define (match-empty cpattern bindings)
      (if (vector? cpattern)

          ;; all the pattern variables in cpattern must get bound to
          ;; the empty sequence

          (let ((tag (vector-ref cpattern 0)))
            (if (< tag (syn#pattern-underscore))
                (let loop ((i 1)
                           (bs bindings))
                  (if (< i (vector-length cpattern))
                      (loop (+ i 1)
                            (match-empty (vector-ref cpattern i) bs))
                      bs))
                (cons '#() bindings)))

          bindings))

    (define (match-next)
      (if (not (pair? lst))
          (syn#match-fail input "form is too short")
          (let* ((sub-cpattern
                  (vector-ref cpattern i))
                 (next
                  (##sourcify (car lst) input))
                 (new-bs
                  (syn#mp
                   sub-cpattern
                   next
                   bs)))
            (if (syn#fail? new-bs)
                new-bs
                (loop1 (+ i 1)
                       (cdr lst)
                       new-bs)))))

    (if (< i (- (vector-length cpattern) 1))
        (match-next)
        (let ((tag (vector-ref cpattern 0)))
          (if (< (syn#pattern-tail-list) tag)

              ;; list or vector pattern with no ellipsis or tail pattern

              (if (< i (vector-length cpattern))
                  (match-next)
                  (if (not (null? lst))
                      (syn#match-fail input "form is too long")
                      bs))

              (let ((sub-cpattern (vector-ref cpattern i)))
                (if (< (syn#pattern-improper-list) tag)

                    ;; list or vector pattern with ellipsis

                    (if (null? lst) ;; repetition factor is zero?

                        (match-empty sub-cpattern bs)

                        (let loop2 ((lst lst)
                                    (local-bs '()))

                          (define (spread lst1 lst2)
                            (if (pair? lst1)
                                (if (pair? lst2)
                                    (cons (cons (car lst1) (car lst2))
                                          (spread (cdr lst1) (cdr lst2)))
                                    (cons (list (car lst1))
                                          (spread (cdr lst1) lst2)))
                                '()))

                          (define (combine lst1 lst2)
                            (if (pair? lst1)
                                (cons (list->vector (reverse (car lst1)))
                                      (combine (cdr lst1) lst2))
                                lst2))

                          (cond ((pair? lst)
                                 (let ((x
                                        (syn#mp
                                         sub-cpattern
                                         (##sourcify (car lst) input)
                                         '())))
                                   (if (syn#fail? x)
                                       x
                                       (loop2 (cdr lst)
                                              (spread x local-bs)))))
                                ((null? lst)
                                 (combine local-bs bs))
                                (else
                                 #f))))

                    ;; tail pattern of a list pattern

                    (syn#mp
                     sub-cpattern
                     (let () ;; TODO: remove this local def at next release (needed for bootstrap)
                       (define (##sourcify-aux1 code src)
                         (##vector ##source1-marker
                                   code
                                   (##vector-ref src 2)
                                   (##vector-ref src 3)))
                       (if (##source? lst)
                           lst
                           (##sourcify-aux1 lst input)))
                     bs))))))))

(define (syn#mp cpattern input bindings)
  (let ((code (##source-code input)))
    (if (not (vector? cpattern))

        (if (not (equal? cpattern ;; cpattern is not a list or vector so
                         code))   ;; desourcify not needed
            (syn#match-fail input "expected:" cpattern)
            bindings)

        (let ((tag (vector-ref cpattern 0)))

          (cond ((or (= tag (syn#pattern-fixed-vect))
                     (= tag (syn#pattern-tail-vect)))
                 ;; input has to be a vector
                 (if (not (vector? code))
                     (syn#match-fail input "vector expected")
                     (syn#mp-list
                      cpattern
                      input
                      (vector->list code)
                      bindings)))

                ((< tag (syn#pattern-underscore))
                 ;; input has to be a list
                 (if (not (or (pair? code)
                              (null? code)))
                     (syn#match-fail input "list expected")
                     (syn#mp-list
                      cpattern
                      input
                      code
                      bindings)))

                ((= tag (syn#pattern-underscore))
                 ;; input can be anything
                 bindings)

                (else
                 (cons input bindings)))))))

(define (syn#match-pattern cpattern input)
  (let ((bindings (syn#mp cpattern input '())))
    (if (syn#fail? bindings)
        (vector->list bindings)
        (list->vector (reverse bindings)))))

;;;============================================================================
