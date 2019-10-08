;;;============================================================================

;;; File: "_syntax-common.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define (syn#pvar-id pvar)
  (let ((sym (car pvar)))
    (string->symbol (string-append "##~" (symbol->string sym)))))

;;;----------------------------------------------------------------------------

(define (datum->syntax src datum)
  (cond ((##source? src)
         (##sourcify datum src))
        (else
         (error "source object expected"))))

(define (syntax->datum src)
  (cond ((##source? src)
         (##desourcify src))
        (else
         (error "source object expected"))))

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
