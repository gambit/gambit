;;;============================================================================

;;; File: "_syntax.scm"

;;; Copyright (c) 2000-2026 by Marc Feeley, All Rights Reserved.

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
  syn#syntax-case-form-transformer)

(##define-syntax syntax
  (lambda (src) (syn#syntax-form-transformer src '())))

;;;----------------------------------------------------------------------------

(##define-syntax syntax-rules
  syn#syntax-rules-form-transformer)

(define (syn#apply-rules crules src)
  (let loop ((crules crules) (failures '()))
    (if (not (pair? crules))

        (error "syntax error" failures)

        (let* ((crule (car crules))
               (cpattern (vector-ref crule 0))
               (ctemplate (vector-ref crule 1))
               (src (if (##source? src) src (##make-source src #f)))
               (bindings (syn#match-pattern cpattern src)))
          (if (syn#match-success? bindings)
              (syn#expand-template ctemplate bindings)
              (loop (cdr crules)
                    (cons bindings failures)))))))

;;;============================================================================
