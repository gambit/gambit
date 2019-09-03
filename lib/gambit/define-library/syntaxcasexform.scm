;;;============================================================================

;;; File: "syntaxcasexform.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; form.

;;;----------------------------------------------------------------------------

(define (syn#syntax-case-form-transformer src)

  (include "syntaxboot.scm") ;; get bootstrap versions of syntax-case and syntax forms
  (include "withsyntaxboot.scm") ;; get bootstrap versions of with-syntax

  (syntax-case src ()

    ((_ input (literal ...) (pattern guard expr ...) ...)
     (let* ((literals
             (syntax->datum #'(literal ...)))
            (guards
             (syntax->vector #'#(guard ...)))
            (patterns
             (syntax->vector #'#(pattern ...)))
            (exprss
             (syntax->vector #'#((expr ...) ...)))
            (fn-names
             (list->vector
              (map (lambda (x) (gensym 'case))
                   (cons 'dummy (vector->list patterns)))))
            (len
             (vector-length patterns)))
          (let loop ((i
                      (- len 1))
                     (fns
                      (with-syntax ((error-fn
                                     (datum->syntax
                                      src
                                      (vector-ref fn-names len))))
                        (list #'(error-fn
                                 (##lambda (##failures)
                                   (error "syntax error" ##failures)))))))
            (if (< i 0)

                (with-syntax ((start-fn
                               (datum->syntax
                                src
                                (vector-ref fn-names 0))))
                  (with-syntax ((fns
                                 (datum->syntax
                                  src
                                  fns)))
                    #'(##let ((##src input))
                        (##letrec fns
                          (start-fn '())))))

                (let ((pattern (vector-ref patterns i))
                      (guard (vector-ref guards i))
                      (exprs (vector-ref exprss i)))
                  (syn#compile-pattern
                   pattern
                   literals
                   (lambda (cpattern pvars)

                     (define (bind-pattern-variables vals)
                       (with-syntax ((pvars
                                      (datum->syntax src pvars)))
                         (with-syntax ((guard
                                        (datum->syntax src guard)))
                           (with-syntax ((bindings
                                          (datum->syntax
                                           src
                                           (map (lambda (pvar val)
                                                  (list (syn#pvar-id pvar) val))
                                                pvars
                                                vals))))
                             #'(##let bindings
                                 (syntax
                                  ##let-pattern-variables
                                  pvars
                                  guard))))))

                     (define (fn-def)
                       (with-syntax ((fn-name
                                      (datum->syntax
                                       src
                                       (vector-ref fn-names i))))
                         (with-syntax ((next-fn-name
                                        (datum->syntax
                                         src
                                         (vector-ref fn-names (+ i 1)))))
                           (with-syntax ((cpattern
                                          (datum->syntax
                                           src
                                           cpattern)))
                             (if (syn#pattern-pvar? cpattern)

                                 ;; optimize for pattern = single var
                                 (with-syntax ((bind-pvars
                                                (bind-pattern-variables
                                                 '(##src))))
                                   #'(fn-name
                                      (##lambda (##failures)
                                        bind-pvars)))

                                 ;; general case uses syn#match-pattern
                                 (with-syntax ((bind-pvars
                                                (bind-pattern-variables
                                                 (map (lambda (pvar)
                                                        `(##vector-ref
                                                          ##bs
                                                          ,(cadr pvar)))
                                                      pvars))))
                                   #'(fn-name
                                      (##lambda (##failures)
                                        (##let ((##bs (syn#match-pattern 'cpattern ##src)))
                                          (##if (syn#match-success? ##bs)
                                                bind-pvars
                                                (next-fn-name
                                                 (##cons ##bs
                                                         ##failures))))))))))))

                     (loop (- i 1)
                           (cons (fn-def) fns)))))))))))

;;;============================================================================
