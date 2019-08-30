;;;============================================================================

;;; File: "syntaxrulesxform.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-rules ...)
;; form.

;;;----------------------------------------------------------------------------

(define (syn#syntax-rules->crules src)

  (include "syntaxboot.scm") ;; get bootstrap versions of syntax-case and syntax forms
  (syntax-case src ()

    ((_ (literal ...) (pattern template) ...)
     (let* ((literals
             (syntax->datum #'(literal ...)))
            (patterns
             (syntax->vector #'#(pattern ...)))
            (templates
             (syntax->vector #'#(template ...))))
       (let loop ((i 0)
                  (crules-rev '()))
         (if (< i (vector-length patterns))

             (let ((pattern (vector-ref patterns i))
                   (template (vector-ref templates i)))
               (syn#compile-pattern
                pattern
                literals
                (lambda (cpattern pvars)
                  (let ((ctemplate (syn#compile-template template pvars)))
                    (loop (+ i 1)
                          (cons (vector cpattern ctemplate) crules-rev))))))

             (reverse crules-rev)))))))

(define (syn#syntax-rules-form-transformer src)

  (include "syntaxboot.scm") ;; get bootstrap versions of syntax-case and syntax forms
  (include "withsyntaxboot.scm") ;; get bootstrap versions of with-syntax

  (let ((crules (syn#syntax-rules->crules src)))
    (with-syntax ((crules (datum->syntax src crules)))
      #'(##lambda (##src)
          (syn#apply-rules 'crules ##src)))))

;;;============================================================================
