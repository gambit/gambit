;;;============================================================================

;;; File: "_syntax.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; and (syntax ...) forms.

;;;----------------------------------------------------------------------------

;; needed by expansion of syntax-case and syntax forms
(include "~~lib/_syntax-pattern.scm")
(include "~~lib/_syntax-template.scm")
(include "~~lib/_syntax-common.scm")

;;;----------------------------------------------------------------------------

(##define-syntax define-syntax
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source '##define-syntax locat)
               (##cdr (##source-code src)))
       locat))))

;;;----------------------------------------------------------------------------

(##define-syntax syntax-case
;#|TODO: remove semicolon after bootstrap to remove redundant dynamic test
  (if (##unbound? (##global-var-ref
                   (##make-global-var 'syn#syntax-case-form-transformer)))
      (##eval '(lambda (src)
                 (##include "~~lib/_syntax-case-xform.scm")
                 (syn#syntax-case-form-transformer src)))
      syn#syntax-case-form-transformer)
;|# syn#syntax-case-form-transformer
    )

(##define-syntax syntax
;#|TODO: remove semicolon after bootstrap to remove redundant dynamic test
  (if (##unbound? (##global-var-ref
                   (##make-global-var 'syn#syntax-form-transformer)))
      (##eval '(lambda (src)
                 (##include "~~lib/_syntax-xform.scm")
                 (syn#syntax-form-transformer src '())))
      (lambda (src) (syn#syntax-form-transformer src '())))
;|# (lambda (src) (syn#syntax-form-transformer src '())))
)

;;;----------------------------------------------------------------------------

(##define-syntax syntax-rules
;#|TODO: remove semicolon after bootstrap to remove redundant dynamic test
  (if (##unbound? (##global-var-ref
                   (##make-global-var 'syn#syntax-rules-form-transformer)))
      (##eval '(lambda (src)
                 (##include "~~lib/_syntax-rules-xform.scm")
                 (syn#syntax-rules-form-transformer src)))
      syn#syntax-rules-form-transformer)
;|# syn#syntax-rules-form-transformer
)

(define (syn#apply-rules crules src)
  (let loop ((crules crules) (failures '()))
    (if (not (pair? crules))

        (error "syntax error" failures)

        (let* ((crule (car crules))
               (cpattern (vector-ref crule 0))
               (ctemplate (vector-ref crule 1))
               (bindings (syn#match-pattern cpattern src)))
          (if (syn#match-success? bindings)
              (syn#expand-template ctemplate bindings)
              (loop (cdr crules)
                    (cons bindings failures)))))))

;;;============================================================================
