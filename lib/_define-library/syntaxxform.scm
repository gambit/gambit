;;;============================================================================

;;; File: "syntaxxform.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements the (syntax ...) form.

;;;----------------------------------------------------------------------------

(define (syn#syntax-form-transformer src inherited-pvars)

  (include "syntaxboot.scm") ;; get bootstrap versions of syntax-case and syntax forms
  (include "withsyntaxboot.scm") ;; get bootstrap version of with-syntax

  (syntax-case src (##let-pattern-variables)

    ((_ ##let-pattern-variables pvars expr)
     (let* ((pvars
             (syntax->datum #'pvars))
            (n
             (length pvars))
            (new-pvars
             (append pvars
                     (map (lambda (x)
                            (let* ((id (car x))
                                   (index (cadr x))
                                   (rank (cddr x)))
                              (cons id
                                    (cons (+ index n) rank))))
                          inherited-pvars))))
       (with-syntax ((new-pvars
                      (datum->syntax src new-pvars)))
         #'(##let ()

             (##define-syntax syntax
               (##lambda (##src)
                 (##include "syntaxxform.scm")
                 (syn#syntax-form-transformer ##src 'new-pvars)))

             expr))))

    ((_ template)
     (let ((ctemplate (syn#compile-template #'template inherited-pvars)))
       (let ((pvar-index (syn#template-pvar? ctemplate)))
         (if pvar-index

             ;; optimize when template is a single pattern variable
             (let ((id (syn#pvar-id (list-ref inherited-pvars pvar-index))))
               (datum->syntax src id))

             ;; general case uses syn#expand-template
             (with-syntax ((ctemplate
                            (datum->syntax src ctemplate)))
               (with-syntax (((vars ...)
                              (datum->syntax src (map syn#pvar-id inherited-pvars))))
                 #'(syn#expand-template 'ctemplate (##vector vars ...))))))))))

;;;============================================================================
