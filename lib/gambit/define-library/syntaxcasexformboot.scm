;;;============================================================================

;;; File: "syntaxcasexformboot.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; form that is used for bootstrapping.

;;;----------------------------------------------------------------------------

(define (syn#syntax-case-form-transformer src)

  (define-macro (syntax-case-cpattern)

    (include "syntaxpattern.scm") ;; get definition of syn#compile-pattern

    (syn#compile-pattern
     (##make-source '(_ input (literal ...) (pattern guard expr ...) ...) #f)
     '()
     (lambda (cpattern pvars)
       `',cpattern)))

  (include "syntaxpattern.scm") ;; get definitions of syn#match-pattern, etc
  (include "syntaxcommon.scm") ;; get definition of syn#pvar-id

  (let ((bs (syn#match-pattern (syntax-case-cpattern) src)))
    (if (syn#match-success? bs)
        (let* ((input (vector-ref bs 0))
               (literals (map ##source-code (vector->list (vector-ref bs 1))))
               (patterns (vector-ref bs 2))
               (guards (vector-ref bs 3))
               (exprss (vector-ref bs 4))
               (fn-names
                (list->vector
                 (map (lambda (x) (gensym 'case))
                      (cons 'dummy (vector->list patterns)))))
               (len (vector-length patterns)))
          (let loop ((i
                      (- len 1))
                     (fns
                      `((,(vector-ref fn-names len)
                         (##lambda (##failures)
                           (error "syntax error" ##failures))))))
            (if (< i 0)

                `(##let ((##src ,input))
                   (##letrec ,fns
                     (,(vector-ref fn-names 0) '())))

                (let ((pattern (vector-ref patterns i))
                      (guard (vector-ref guards i))
                      (exprs (vector-ref exprss i)))
                  (syn#compile-pattern
                   (##sourcify pattern src)
                   literals
                   (lambda (cpattern pvars)

                     (define (bind-pattern-variables vals)
                       `(##let ,(map (lambda (pvar val)
                                       (list (syn#pvar-id pvar) val))
                                     pvars
                                     vals)
                          (syntax
                           ##let-pattern-variables
                           ,pvars
                           ,(if (= 0 (vector-length exprs))
                                guard
                                `(##if ,guard
                                       (##let ()
                                         ,@(vector->list exprs))
                                       (,(vector-ref fn-names (+ i 1))
                                        ##failures))))))

                     (loop (- i 1)
                           (cons `(,(vector-ref fn-names i)
                                   (##lambda (##failures)
                                     ,(if (syn#pattern-pvar? cpattern)

                                          ;; optimize for pattern = single var
                                          (bind-pattern-variables
                                           '(##src))

                                          ;; general case uses syn#match-pattern
                                          `(##let ((##bs (syn#match-pattern ',cpattern ##src)))
                                             (##if (syn#match-success? ##bs)
                                                   ,(bind-pattern-variables
                                                     (map (lambda (pvar)
                                                            `(##vector-ref
                                                              ##bs
                                                              ,(cadr pvar)))
                                                          pvars))
                                                   (,(vector-ref fn-names (+ i 1))
                                                    (##cons ##bs ##failures)))))))
                                 fns))))))))
        (error "illformed syntax-case"))))

;;;============================================================================
