;;;============================================================================

;;; File: "_syntax-source.scm"

;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================
;;;
;;; syntax-source object
;;;
;;;============================================================================
;;;
;;;----------------------------------------------------------------------------
;;; syntax-source's tag
;;;

(define-prim (##syntax-source-tag? src-tag)
  (and
    (##vector? src-tag)
    (##equal? (##vector-ref src-tag 0)
              'syntax)))

(define-prim (##make-syntax-source-tag src-tag)
  (##vector 'syntax src-tag))

(define-prim (##source->syntax-tag! obj source-tag)
  ; create a syntaxic-tag from a source-tag
  ; or keep the syntaxic-tag unchanged
  (cond
    ((##syntax-source-tag? source-tag)
     source-tag)
    ((##source-tag? source-tag)
     (##make-syntax-source-tag source-tag))
    (else
      (error "invalid source/syntax-source tag during conversion"))))

(define-prim (##syntax->source-tag! obj stx-tag)
  ; get the source-tag representation 
  ; back from a syntax-tag
  ; or keep the source-tag unchanged
  (cond
    ((##syntax-source-tag? stx-tag)
     (##vector-ref stx-tag 1))
    ((##source-tag? stx-tag)
     stx-tag)
    (else
     (error "invalid source/syntax-source tag during conversion"))))

;;;----------------------------------------------------------------------------
;;; source type check

(define-check-type source ()
  ##source?)

(define (##fail-check-type arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void
   proc
   args))

;;;----------------------------------------------------------------------------
;;; syntax-source

(define-prim&proc (syntax-source? obj)
  (and (##vector? obj)
       (##syntax-source-tag? (##vector-ref obj 0))))

(##set-source?! 
  (let ((proc ##source?))
    (lambda (obj) 
      (or (proc obj) 
          (##syntax-source? obj)))))

(define-check-type syntax (type-vector)
  syntax-source?)

(define (##fail-check-syntax arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void
   proc
   args))

(define-prim&proc (syntax-source-clone (stx-src syntax))
  (##source-clone stx-src))

(define-prim&proc (syntax-source-code (stx-src syntax))
  (##source-code stx-src))

(define-prim&proc (syntax-source-code-set! (stx-src syntax) code)
  (##source-code-set! stx-src code))

(define-prim&proc (syntax-source-code-set (stx-src syntax) code)
  (let ((stx-src (##syntax-source-clone stx-src)))
    (##syntax-source-code-set! stx-src code)
    stx-src))

(define-prim&proc (syntax-source-code-update! (stx-src syntax) (proc procedure))
  (##source-code-update! stx-src proc))

(define-prim&proc (syntax-source-code-update (stx-src syntax) (proc procedure))
  (let ((stx-src (##syntax-source-clone stx-src)))
    (##syntax-source-code-update! stx-src proc)
    stx-src))

(define-prim&proc (syntax-source-scopes (stx-src syntax))
  ; "safe" version of source-scopes                  
  (let ((scopes (##source-scopes stx-src)))
    (or scopes (error "Cannot retrieves scopes for non-syntaxic source"))))

(define-prim&proc (syntax-source-scopes-set! (stx-src syntax) (proc procedure))
  (##source-scopes-set! stx-src proc))

(define-prim&proc (syntax-source-scopes-set (stx-src syntax) (proc procedure))
  (##source-scopes-set stx-src proc))

(define-prim&proc (syntax-source-scopes-update! (stx-src syntax) (proc procedure))
  (##source-scopes-update! stx-src proc))

(define-prim&proc (syntax-source-scopes-update (stx-src syntax) (proc procedure))
  (##source-scopes-update stx-src proc))

;;;----------------------------------------------------------------------------

(define-prim (##source->syntax! src #!optional (stx (macro-absent-obj)))

  (if (not 
        (or (##source? src)
            (##syntax-source? src)))
      (##error "non-source conversion"))

  ; adjust location
  (cond
   ((and (not (##source-locat src))
         (or (##syntax-source? stx)
             (##source? stx)))
    (##vector-set! src 2 (##vector-ref stx 2))
    (##vector-set! src 3 (##vector-ref stx 3))
    (if (= (##vector-length src) 6)
        (##vector-set! src 4 (and (= (##vector-length stx) 6)
                                  (##vector-ref stx 4))))))

  ; adjust tag
  (cond
    ((##source? src)
     (##vector-set! src 0 (##source->syntax-tag! src (##vector-ref src 0)))))

  ; adjust scopes
  (cond
    ((##source? src)
     (##source-scopes-set! src
                           (if (##syntax-source? stx)
                               (##syntax-source-scopes stx)
                               (##make-scopes)))))
  src)

(define-prim (source->syntax! src #!optional (stx (macro-absent-obj)))
  (##source->syntax! src stx))

(define-prim (##source->syntax src #!optional (stx (macro-absent-obj)))
  (let ((src (##vector-copy src)))
    (##source->syntax! src stx)
    src))

(define-prim (source->syntax src #!optional (stx (macro-absent-obj)))
  (##source->syntax src stx))

;;;---------------------------------------

(define-prim (##syntax-set-locats stx ref)
  (let ((code (##syntax-source-code stx)))
    (cond
      ((pair? code)
       (let ((stx (##syntax-source-code-set stx
                   (let ##syntax-set-locats-pair ((code code))
                     (cond 
                       ((pair? code)
                        (cons (##syntax-set-locats (car code) ref)
                              (##syntax-set-locats-pair (cdr code))))
                       ((null? code)
                        code)
                       (else
                         (##syntax-set-locats code ref)))))))
          (##vector-set! stx 2 (##vector-ref ref 2))
          (##vector-set! stx 3 (##vector-ref ref 3))
          stx))
      (else
        (let ((stx (##vector-copy stx)))
          (##vector-set! stx 2 (##vector-ref ref 2))
          (##vector-set! stx 3 (##vector-ref ref 3))
          stx)))))

;;;---------------------------------------

(define-prim (##syntax->source! src)
  (cond
    ((##syntax-source? src)
     (##vector-set! src 0 (##syntax->source-tag! src (##vector-ref src 0)))
     (##source-scopes-set! src #f)
     src)
    ((##source? src)
     src)
    (else
     (##error-expansion ##syntax->source! src "cannot convert non-syntax to source"))))

;;;----------------------------------------------------------------------------

(define-prim&proc (make-syntax-source code locat)
  (let ((src (##make-source code locat)))
    (##source->syntax! src)
    src))

(define-prim&proc (make-core-syntax-source code locat)
  (let ((stx (##make-syntax-source code locat)))
    (add-scope! stx ##core-scope)
    stx))

;;;----------------------------------------------------------------------------

; TODO: datum->syntax must be renamed source->syntax 
;       and plain-datum->syntax should be renamed datum->syntax
; TODO: fix define-prim&proc to allow for optional parameters

(define-prim (##datum->syntax datum #!optional (stx (macro-absent-obj)))

  (define (##datum->syntax-pair code)
    (cond
      ((pair? code)
       (cons (if (equal? stx (macro-absent-obj))
                 (##datum->syntax (car code))
                 (##datum->syntax (car code) stx))
             (##datum->syntax-pair (cdr code))))
      ((null? code)
       code)
      (else
       (##datum->syntax code))))

  (cond
    ((syntax-source? datum)
     datum)
    ((##source? datum)
     (##source->syntax
       (##source-code-update datum
        (lambda (code)
          (cond
            ((pair? code)
             (##datum->syntax-pair code))
            (else
              code))))
       stx))
    (else
      (error "ill formed source" datum))))

(define-prim (datum->syntax src #!optional (stx (##make-syntax-source #f #f)))
  (##datum->syntax src stx))

;;;---------------------------------------

(define-prim (##syntax->datum! stx)

  (define (pair->datum! code)
    (cond 
      ((pair? code)
       (##syntax->datum! (car code))
       (pair->datum! (cdr code)))
      ((##null? code)
       code)
      (else
       (##syntax->datum! code))))

  (cond
    ((##syntax-source? stx)
     (let ((code (##source-code stx)))
       (cond 
         ((##pair? code)
          (##syntax->source! stx)
          (pair->datum! code))
         (else
          (##syntax->source! stx)))))
    (else
     "cannot convert non-syntax to datum")))

(define (syntax->datum! stx)
  (##syntax->datum! stx))

;;;----------------------------------------------------------------------------

(define-prim (##plain-datum->syntax datum #!optional (stx (##make-syntax-source #f #f)))

  (let ((stx (cond
               ((##syntax-source? stx)
                stx)
               ((##source? stx)
                (##datum->syntax stx))
               (else
                 (##error "Unknown object used as source reference")))))

  (define (pair->syntax datum)
    (cond
      ((pair? datum)
       (cons (##plain-datum->syntax (car datum) stx)
             (pair->syntax (cdr datum))))
      ((null? datum)
       datum)
      (else
       (##plain-datum->syntax datum stx))))

 (cond
   ((syntax-source? datum)
    datum)
   ((##source? datum)
    (##datum->syntax datum))
   ((pair? datum)
    ; The algorithm doesn't require pairs and list to carry scoping
    ; information but, it is usefull for debbuging purposes. 
    ; Could interfere with GC by keeping useless scopes in memory.
    (##source-code-set stx (pair->syntax datum)))
   (else
    (##source-code-set stx datum)))))

(define-prim (plain-datum->syntax datum #!optional (stx (macro-absent-obj)))
  (if (##equal? stx (macro-absent-obj))
      (##plain-datum->syntax datum)
      (##plain-datum->syntax datum stx)))

;;;---------------------------------------

(define-prim (##plain-datum->core-syntax datum #!optional (stx (macro-absent-obj)))
  (add-scope (##plain-datum->syntax datum stx) core-scope))

(define-prim (plain-datum->core-syntax datum #!optional (stx (macro-absent-obj)))
  (##plain-datum->core-syntax datum stx))

;;;---------------------------------------

(define-prim&proc (syntax->plain-datum stx)
  (cond
    ((not (syntax-source? stx))
     stx)
    ((syntax-source? stx)
     (let ((code (##syntax-source-code stx)))
       (cond
         ((pair? code)
          (let loop ((code code))
            (cond
              ((pair? code)
               (cons (syntax->plain-datum (car code))
                     (loop                (cdr code))))
              ((null? code)
               code)
              (else
               (syntax->plain-datum code)))))
         (else
           code))))))
     
;;;----------------------------------------------------------------------------
  
(define-prim (##update-scope! stx proc!)
  (let ((code (##syntax-source-code stx)))
    (cond
      ((pair? code)
       (let loop ((code code))
         (cond
           ((pair? code)
            (##update-scope! (car code) proc!)
            (loop (cdr code)))
           ((null? code) 
            #!void)
           (else
            (##update-scope! code proc!)))))
      ((null? code)
       code)
      (else
        (##syntax-source-scopes-update! stx proc!)))))

(define-prim (##update-scope-pair code proc)
  (cond
    ((pair? code)
     (cons (##update-scope (car code) proc)
           (##update-scope-pair (cdr code) proc)))
    ((null? code)
     code)
    (else
     (##syntax-source-scopes-update code proc))))

(define-prim (##update-scope stx proc)
  (let ((code (##syntax-source-code stx)))
    (cond
      ((pair? code)
       (##syntax-source-code-set stx
         (##update-scope-pair code proc)))
      ((null? code)
       stx)
      (else
        (##syntax-source-scopes-update stx proc)))))

(define-prim&proc (add-scope! (stx syntax) (scp scope))
  (##update-scope! stx (lambda (scopes) (scopes-insert scopes scp))))

(define-prim&proc (flip-scope! (stx syntax) (scp scope))
  (##update-scope! stx (lambda (scopes) (scopes-xor scopes scp))))

(define-prim&proc (add-scope stx (scp scope))
  ((if (or (pair? stx)
           (null? stx))
      ##update-scope-pair
      ##update-scope)
   stx 
   (lambda (scopes) 
     (##scopes-insert scopes scp))))

(define-prim&proc (flip-scope stx (scp scope))
  ((if (or (pair? stx)
           (null? stx))
      ##update-scope-pair
      ##update-scope)
   stx 
   (lambda (scopes) 
     (##scopes-xor scopes scp))))

(define-prim&proc (add-scopes stx scps)
  (##fold (lambda (scp stx) 
            (##add-scope stx scp))
          stx
          scps))

;;;----------------------------------------------------------------------------

(define-macro (define-syntax-source-proc proc)
  (let ((obj  (gensym 'obj))
        (name (string->symbol (string-append "syntax-source-" (symbol->string proc)))))
    `(define-prim&proc (,name ,obj)
       (and (##syntax-source? ,obj)
            (,proc (##syntax-source-code ,obj))))))

(define-syntax-source-proc pair?)
(define-syntax-source-proc null?)
(define-syntax-source-proc list?)

;;;----------------------------------------------------------------------------

(define-prim&proc (keyword->identifier stx)                  
  (##syntax-source-code-update stx
    (lambda (sym)
      (if (keyword? sym)
          (string->symbol (keyword->string sym))
          sym))))

(define-prim&proc (identifier->keyword stx)
  (##syntax-source-code-update stx
    (lambda (sym)
      (string->keyword (symbol->string sym)))))

;;;============================================================================
