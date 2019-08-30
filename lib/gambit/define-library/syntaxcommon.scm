;;;============================================================================

;;; File: "syntaxcommon.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define (syn#pvar-id pvar)
  (let ((sym (car pvar)))
    (string->symbol (string-append "##~" (symbol->string sym)))))

;;;----------------------------------------------------------------------------

(define (datum->syntax src datum)
  (##sourcify datum src))

(define (syntax->datum src)
  (##desourcify src))

(define (syntax->list src)
  (cond ((##source? src)
         (let ((code (##source-code src)))
           (if (or (null? code) (pair? code))
               (##map (lambda (x) (##sourcify x src))
                      code)
               (error "list expected"))))
        (else
         (error "source object expected"))))

(define (syntax->vector src)
  (cond ((##source? src)
         (let ((code (##source-code src)))
           (if (vector? code)
               (list->vector
                (##map (lambda (x) (##sourcify x src))
                       (vector->list code)))
               (error "vector expected"))))
        (else
         (error "source object expected"))))

;;;============================================================================
