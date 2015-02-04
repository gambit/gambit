;;;============================================================================

;;; File: "_syntax-template.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements basic template expansion functionnality that is
;; used in the implementation of syntax definition forms (both
;; syntax-rules and syntax-case).  It implements:
;;
;; - a compiler for syntax templates
;; - a syntax template expander

;; This file is typically used inside a macro definition body using an
;; (include "~~lib/_syntax-template.scm") so the toplevel definitions
;; in this file are actually local definitions of the enclosing macro
;; definition.  Nevertheless, all toplevel definitions define identifiers
;; that are prefixed with the "syn#" namespace.

;;;----------------------------------------------------------------------------

;; Define encoding of compiled templates.

(define-macro (syn#template-list)          -1)
(define-macro (syn#template-vect)          -2)
(define-macro (syn#template-improper-list) -3)
(define-macro (syn#template-other)         -4)
(define-macro (syn#template-repetition)    -5)

;;;----------------------------------------------------------------------------

;; Syntax template compilation.

;; Compiled templates are represented as follows:
;;
;; Template            Compiled template
;; <pattern variable>  #(INDEX RANK)              INDEX and RANK >= 0
;; (T1 T2 T3)          #((syn#template-list) LOC CT1 CT2 CT3)
;; #(T1 T2 T3)         #((syn#template-vect) LOC CT1 CT2 CT3)
;; (T1 T2 . T3)        #((syn#template-improper-list) LOC CT1 CT2 CT3)
;; <other>             #((syn#template-other) LOC <other>)
;; T ...               #((syn#template-repetition) CT INDEX1 RANK1 INDEX2 RANK2 INDEX3 RANK3)

(define (syn#template-pvar? ctemplate)
  (and (vector? ctemplate)
       (let ((index (vector-ref ctemplate 0)))
         (and (>= index 0) index))))

(define (syn#template-ellipsis? src)
  (let ((code (##source-code src)))
    (eq? code '...)))

(define (syn#ct-list template code pvars loop-nests tag-offs)
  (let loop ((lst code)
             (rev-ctemplate '()))
    (cond ((pair? lst)
           (let ((first (##sourcify (car lst) template))
                 (rest (cdr lst)))
             (if (and (pair? rest)
                      (syn#template-ellipsis? (##sourcify (car rest) template)))
                 (let* ((loop-control
                         (vector '()))
                        (ctemplate
                         (syn#ct
                          first
                          pvars
                          (cons loop-control loop-nests)))
                        (x
                         (vector-ref loop-control 0)))
                   (if (null? x) ; is this loop nest unconstrained?
                       (error "iterated template is unconstrained")
                       (loop (cdr rest)
                             (cons (list->vector
                                    (cons (syn#template-repetition) (cons ctemplate x)))
                                   rev-ctemplate))))
                 (let ((ctemplate
                        (syn#ct
                         first
                         pvars
                         loop-nests)))
                   (loop rest
                         (cons ctemplate rev-ctemplate))))))
          ((null? lst)
           (list->vector
            (cons (+ (syn#template-list) tag-offs)
                  (cons (##source-locat template)
                        (reverse rev-ctemplate)))))
          (else
           (let ((ctemplate
                  (syn#ct
                   (##sourcify lst template)
                   pvars
                   loop-nests)))
             (list->vector
              (cons (syn#template-improper-list)
                    (cons (##source-locat template)
                          (reverse (cons ctemplate rev-ctemplate))))))))))

(define (syn#ct template pvars loop-nests)
  (let ((code (##source-code template)))

    (define (add-constraints! var-index n nests)
      (cond ((= n 0))
            ((pair? nests)
             (vector-set! (car nests) 0
               (cons var-index
                     (cons (- n 1)
                           (vector-ref (car nests) 0))))
             (add-constraints! var-index (- n 1) (cdr nests)))
            (else
             (error "insufficient nesting of pattern variable in template"))))

    (define (handle-symbol sym)
      (let ((x (assq sym pvars)))
        (if x
            (let ((var-index (cadr x))
                  (var-rank (cddr x)))
              (add-constraints! var-index var-rank loop-nests)
              (vector var-index
                      var-rank))
            (handle-constant sym))))

    (define (handle-constant const)
      (vector (syn#template-other) ; const is not structured so desourcify not needed
              (##source-locat template)
              const))

    (cond ((pair? code)
           (if (and (syn#template-ellipsis? (##sourcify (car code) template))
                    (let ((rest (cdr code)))
                      (and (pair? rest)
                           (syn#template-ellipsis? (##sourcify (car rest) template))
                           (null? (cdr rest)))))
               (handle-symbol '...)
               (syn#ct-list
                template
                code
                pvars
                loop-nests
                0)))

          ((vector? code)
           (syn#ct-list
            template
            (vector->list code)
            pvars
            loop-nests
            -1))

          ((symbol? code)
           (if (eq? code '...)
               (error "improperly placed ellipsis in pattern")
               (handle-symbol code)))

          (else
           (handle-constant code)))))

(define (syn#compile-template template pattern-vars)
  (syn#ct
   template
   pattern-vars
   '()))

;;;----------------------------------------------------------------------------

;; Syntax template expansion.

(define (syn#et ctemplate bindings loop-nests tail)

  (define (fetch rank nests binding)
    (if (= rank 0)
        binding
        (vector-ref (fetch (- rank 1) (cdr nests) binding)
                    (car nests))))

  (define (size i)
    (vector-length
     (fetch (vector-ref ctemplate (- i 1))
            loop-nests
            (vector-ref bindings (vector-ref ctemplate (- i 2))))))

  (define (build-list i t)
    (if (< i 2)
        t
        (build-list (- i 1)
                    (syn#et
                     (vector-ref ctemplate i)
                     bindings
                     loop-nests
                     t))))

  (let ((tag (vector-ref ctemplate 0))
        (len (vector-length ctemplate)))

    (cond ((= tag (syn#template-list))
           (cons (##make-source
                  (build-list (- len 1) '())
                  (vector-ref ctemplate 1))
                 tail))

          ((= tag (syn#template-vect))
           (cons (##make-source
                  (list->vector (build-list (- len 1) '()))
                  (vector-ref ctemplate 1))
                 tail))

          ((= tag (syn#template-improper-list))
           (cons (##make-source
                  (build-list (- len 2)
                              (let ((t (car (syn#et
                                             (vector-ref ctemplate (- len 1))
                                             bindings
                                             loop-nests
                                             '()))))
                                (if (##source? t)
                                    (##source-code t)
                                    t)))
                  (vector-ref ctemplate 1))
                 tail))

          ((= tag (syn#template-other))
           (cons (##make-source
                  (vector-ref ctemplate 2)
                  (vector-ref ctemplate 1))
                 tail))

          ((= tag (syn#template-repetition))
           (let ((n (size len)))
             (let loop1 ((i (- len 2)))
               (if (< i 3)
                   (let loop2 ((j (- n 1))
                               (t tail))
                     (if (< j 0)
                         t
                         (loop2 (- j 1)
                                (syn#et
                                 (vector-ref ctemplate 1)
                                 bindings
                                 (cons j loop-nests)
                                 t))))
                   (if (= n (size i))
                       (loop1 (- i 2))
                       (error "inconsistent loop"))))))

          (else
           ;; template is a pattern variable
           (let ((var-index tag)
                 (var-rank (vector-ref ctemplate 1)))
             (cons (fetch var-rank
                          loop-nests
                          (vector-ref bindings var-index))
                   tail))))))

(define (syn#expand-template ctemplate bindings)
  (car (syn#et
        ctemplate
        bindings
        '()
        '())))

;;;============================================================================
