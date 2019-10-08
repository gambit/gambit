;;;============================================================================

;;; File: "_syntax-xform.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements the (syntax ...) form.

;;;----------------------------------------------------------------------------

(define (syn#syntax-form-transformer src inherited-pvars)

                                          ;; get bootstrap versions of
  (include "~~lib/_syntax-boot.scm")      ;; syntax-case and syntax forms
  (include "~~lib/_with-syntax-boot.scm") ;; with-syntax

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
;#|TODO: remove semicolon after bootstrap to remove redundant dynamic test
               (if (##unbound? (##global-var-ref
                                (##make-global-var 'syn#syntax-form-transformer)))
                   (##eval '(lambda (src)
                              (##include "~~lib/_syntax-xform.scm")
                              (syn#syntax-form-transformer src 'new-pvars)))
                   (lambda (src) (syn#syntax-form-transformer src 'new-pvars)))
;|#            (lambda (src) (syn#syntax-form-transformer src 'new-pvars))
             )

             #;
             (##define-syntax syntax
               (##lambda (##src)
                 (##include "~~lib/_syntax-xform.scm")
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
