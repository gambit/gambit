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
    (##fx> (##vector-length src-tag) 0)
    (##eq? (##vector-ref src-tag 0)
           'syntax)))

(define-prim (##make-syntax-source-tag src-tag)
  (##vector 'syntax src-tag))

(define-prim (##source-object->syntax-source-object-tag! obj source-tag)
  ; create a syntaxic-tag from a source-tag
  ; or keep the syntaxic-tag unchanged
  (cond
    ((##syntax-source-tag? source-tag)
     source-tag)
    ((##source-tag? source-tag)
     (##make-syntax-source-tag source-tag))
    (else
      (error "Cannot convert source object's tag: the object is not a tag"))))

(define-prim (##syntax-source-object->source-object-tag! obj stx-tag)
  ; get the source-tag representation 
  ; back from a syntax-tag
  ; or keep the source-tag unchanged
  (cond
    ((##syntax-source-tag? stx-tag)
     (##vector-ref stx-tag 1))
    ((##source-tag? stx-tag)
     stx-tag)
    (else
     (error "Cannot convert syntax-source object's tag: the object is not a tag"))))

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

(define-primitive (syntax-source? obj)
  (and (##vector? obj)
       (##fx> (##vector-length obj) 0)
       (##syntax-source-tag? (##vector-ref obj 0))))

(##set-source?! 
  (let ((proc ##source?))
    (lambda (obj) 
      (or (proc obj) 
          (##syntax-source? obj)))))

(define-check-type syntax (type-vector)
  ##syntax-source?)

(define (##fail-check-syntax arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void
   proc
   args))

(define-primitive (syntax-source-clone (stx-src syntax))
  (##source-clone stx-src))

(define-primitive (syntax-source-code (stx-src syntax))
  (##source-code stx-src))

(define-primitive (syntax-source-code-set! (stx-src syntax) code)
  (##source-code-set! stx-src code))

(define-primitive (syntax-source-code-set (stx-src syntax) code)
  (let ((stx-src (##syntax-source-clone stx-src)))
    (##syntax-source-code-set! stx-src code)
    stx-src))

(define-primitive (syntax-source-code-update! (stx-src syntax) (proc procedure))
  (##source-code-update! stx-src proc))

(define-primitive (syntax-source-code-update (stx-src syntax) (proc procedure))
  (let ((stx-src (##syntax-source-clone stx-src)))
    (##syntax-source-code-update! stx-src proc)
    stx-src))

(define-primitive (syntax-source-scopes (stx-src syntax))
  (let ((scopes (##source-scopes stx-src)))
    (or scopes (error "Cannot retrieves scopes: the object is not a syntax object"))))

(define-primitive (syntax-source-scopes-set! (stx-src syntax) (proc procedure))
  (##source-scopes-set! stx-src proc))

(define-primitive (syntax-source-scopes-set (stx-src syntax) (proc procedure))
  (##source-scopes-set stx-src proc))

(define-primitive (syntax-source-scopes-update! (stx-src syntax) (proc procedure))
  (##source-scopes-update! stx-src proc))

(define-primitive (syntax-source-scopes-update (stx-src syntax) (proc procedure))
  (##source-scopes-update stx-src proc))

;;;----------------------------------------------------------------------------

(define-prim (##source-object->syntax-source-object! src #!optional (stx (macro-absent-obj)))

  (if (not 
        (or (##source? src)
            (##syntax-source? src)))
      (##error "Cannot convert to syntax: object is not a source object"))

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
     (##vector-set! src 0 (##source-object->syntax-source-object-tag! src (##vector-ref src 0)))))

  ; adjust scopes
  (cond
    ((##source? src)
     (##source-scopes-set! src
                           (if (##syntax-source? stx)
                               (##syntax-source-scopes stx)
                               (##make-scopes)))))
  src)

(define-prim (##source-object->syntax-source-object src #!optional (stx (macro-absent-obj)))
  (let ((src (##vector-copy src)))
    (##source-object->syntax-source-object! src stx)
    src))

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

(define-prim (##syntax-source-object->source-object! src)
  (cond
    ((##syntax-source? src)
     (##vector-set! src 0 (##syntax-source-object->source-object-tag! src (##vector-ref src 0)))
     (##source-scopes-set! src #f)
     src)
    ((##source? src)
     src)
    (else
     (##error "Cannot convert to source: object not a source or syntax object"))))

(define-prim (##syntax-source-object->source-object src)
  (if (##vector? src)
      (let ((v (##vector-copy src)))
        (##syntax-source-object->source-object! v)
        v)
      (##error "Cannot convert to source: object not a source or syntax object")))

;;;----------------------------------------------------------------------------

(define-primitive (make-syntax-source code locat)
  (let ((src (##make-source code locat)))
    (##source-object->syntax-source-object! src)
    src))

(define-primitive (make-core-syntax-source code locat)
  (let ((stx (##make-syntax-source code locat)))
    (##add-scope! stx ##core-scope)
    stx))

;;;----------------------------------------------------------------------------

; TODO: fix define-primitive to allow for optional parameters

(define-prim (##source->syntax-source datum #!optional (stx (macro-absent-obj)))

  (define (##source->syntax-source-elem code)
    (if (equal? stx (macro-absent-obj))
        (##source->syntax-source code)
        (##source->syntax-source code stx)))

  (define (##source->syntax-source-pair code)
    (cond
      ((pair? code)
       (cons (##source->syntax-source-elem (car code))
             (##source->syntax-source-pair (cdr code))))
      ((null? code)
       code)
      (else
       (##source->syntax-source-elem code))))

  (define (##source->syntax-source-vector code)
    (let* ((n   (##vector-length code))
           (new (##make-vector n #f)))
      (let loop ((i 0))
        (if (##fx< i n)
            (begin
              (##vector-set! new i
                (##source->syntax-source-elem (##vector-ref code i)))
              (loop (##fx+ i 1)))
            new))))

  (cond
    ((##syntax-source? datum)
     datum)
    ((##source? datum)
     (##source-object->syntax-source-object
       (##source-code-update datum
        (lambda (code)
          (cond
            ((pair? code)
             (##source->syntax-source-pair code))
            ((vector? code)
             (##source->syntax-source-vector code))
            (else
              code))))
       stx))
    (else
      (##source-object->syntax-source-object (##make-source datum #f) stx))))

;;;---------------------------------------

(define-prim (##syntax-source->source! stx)

  (define (pair->datum! code)
    (cond
      ((pair? code)
       (##syntax-source->source! (car code))
       (pair->datum! (cdr code)))
      ((##null? code)
       code)
      (else
       (##syntax-source->source! code))))

  (define (vector->datum! code)
    (let ((n (##vector-length code)))
      (let loop ((i 0))
        (if (##fx< i n)
            (begin
              (##syntax-source->source! (##vector-ref code i))
              (loop (##fx+ i 1)))
            code))))

  (cond
    ((##syntax-source? stx)
     (let ((code (##source-code stx)))
       (cond
         ((##pair? code)
          (##syntax-source-object->source-object! stx)
          (pair->datum! code))
         ((##vector? code)
          (##syntax-source-object->source-object! stx)
          (vector->datum! code))
         (else
          (##syntax-source-object->source-object! stx)))))
    (else
     "cannot convert non-syntax to datum")))

(define-prim (##syntax-source->source stx)

  (define (pair->datum code)
    (cond
      ((pair? code)
       (cons (##syntax-source->source (car code))
             (pair->datum (cdr code))))
      ((##null? code)
       code)
      (else
       (##syntax-source->source code))))

  (define (vector->datum code)
    (let* ((n   (##vector-length code))
           (new (##make-vector n #f)))
      (let loop ((i 0))
        (if (##fx< i n)
            (let ((elem (##vector-ref code i)))
              (##vector-set! new i
                (if (##syntax-source? elem)
                    (##syntax-source->source elem)
                    elem))
              (loop (##fx+ i 1)))
            new))))

  (cond
    ((##syntax-source? stx)
     (let ((code (##source-code stx)))
       (cond
         ((##pair? code)
          (##syntax-source-object->source-object
            (##syntax-source-code-update stx pair->datum)))
         ((##vector? code)
          (##syntax-source-object->source-object
            (##syntax-source-code-update stx vector->datum)))
         (else
          (##syntax-source-object->source-object stx)))))
    (else
     "cannot convert non-syntax to datum")))

;;;----------------------------------------------------------------------------

(define-prim (##datum->syntax-ref? x)
  (or (##syntax-source? x) (##source? x)))

(define-prim (##datum->syntax-aux datum stx)
  (let ((stx (let ref->stx ((stx stx))
               (cond
                 ((##syntax-source? stx)
                  stx)
                 ((##source? stx)
                  (##source->syntax-source stx))
                 ((pair? stx)
                  (ref->stx (car stx)))
                 ((or (null? stx) (##equal? stx (macro-absent-obj)))
                  (##make-syntax-source #f #f))
                 (else
                   (##error "Cannot convert to source: unknown object used as source reference" stx))))))

  (define (pair->syntax datum)
    (cond
      ((pair? datum)
       (cons (##datum->syntax-aux (car datum) stx)
             (pair->syntax (cdr datum))))
      ((null? datum)
       datum)
      (else
       (##datum->syntax-aux datum stx))))

  (define (vec->syntax datum)
    (let* ((len (##vector-length datum))
           (new (##make-vector len #f)))
      (let loop ((i 0))
        (if (##fx< i len)
            (begin
              (##vector-set! new i (##datum->syntax-aux (##vector-ref datum i) stx))
              (loop (##fx+ i 1)))
            new))))

 (cond
   ((##syntax-source? datum)
    datum)
   ((##source? datum)
    (##source->syntax-source datum stx))
   ((pair? datum)
    ; The algorithm doesn't require pairs and list to carry scoping
    ; information but, it is usefull for debbuging purposes.
    ; Could interfere with GC by keeping useless scopes in memory.
    (##source-code-set stx (pair->syntax datum)))
   ((##vector? datum)
    (##source-code-set stx (vec->syntax datum)))
   (else
    (##source-code-set stx datum)))))

(define-prim (##datum->syntax a #!optional (b (macro-absent-obj)))
  (cond
    ((##equal? b (macro-absent-obj))
     (##datum->syntax-aux a (##make-syntax-source #f #f)))
    ((and (##datum->syntax-ref? a)
          (not (##datum->syntax-ref? b)))
     (##datum->syntax-aux b a))
    (else
     (##datum->syntax-aux a b))))

(define-prim (datum->syntax datum #!optional (stx (macro-absent-obj)))
  (if (##equal? stx (macro-absent-obj))
      (##datum->syntax datum)
      (##datum->syntax datum stx)))

;;;---------------------------------------

(define-prim (##datum->core-syntax datum #!optional (stx (macro-absent-obj)))
  (##add-scope
    (if (##equal? stx (macro-absent-obj))
        (##datum->syntax datum)
        (##datum->syntax datum stx))
    ##core-scope))

;;;---------------------------------------

;override _syntax-common
(define-prim&proc (syntax->datum stx)
  (cond
    ((##syntax-source? stx)
     (syntax->datum (##syntax-source-code stx)))
    ((##source? stx)
     (syntax->datum (##source-code stx)))
    ((pair? stx)
     (cons (syntax->datum (car stx))
           (syntax->datum (cdr stx))))
    ((##vector? stx)
     (let* ((len (##vector-length stx))
            (new (##make-vector len #f)))
       (let loop ((i 0))
         (if (##fx< i len)
             (begin
               (##vector-set! new i (syntax->datum (##vector-ref stx i)))
               (loop (##fx+ i 1)))
             new))))
    (else
     stx)))
     
;override _syntax-common
(define-prim&proc (syntax->list stx)
  ;; original syntax->list drops the improper list tail
  (let loop ((code (##source-code stx)))
    (if (##pair? code)
        (##cons (##car code) (loop (##cdr code)))
        '())))

;override _syntax-common
(define-prim&proc (syntax->vector stx)
  (let* ((code (##source-code stx))
         (len (##vector-length code))
         (new (##make-vector len #f)))
    (let loop ((i 0))
      (if (##fx< i len)
          (begin
            (##vector-set! new i (##vector-ref code i))
            (loop (##fx+ i 1)))
          new))))

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
      ((vector? code)
       (let ((n (##vector-length code)))
         (let loop ((i 0))
           (if (##fx< i n)
               (let ((elem (##vector-ref code i)))
                 (if (##syntax-source? elem)
                     (##update-scope! elem proc!))
                 (loop (##fx+ i 1)))
               #!void))))
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
     (##update-scope code proc))))

(define-prim (##update-scope-vector code proc)
  (let* ((n   (##vector-length code))
         (new (##make-vector n #f)))
    (let loop ((i 0))
      (if (##fx< i n)
          (let ((elem (##vector-ref code i)))
            (##vector-set! new i
              (if (##syntax-source? elem)
                  (##update-scope elem proc)
                  elem))
            (loop (##fx+ i 1)))
          new))))

(define-prim (##update-scope stx proc)
  (let ((code (##syntax-source-code stx)))
    (cond
      ((pair? code)
       (##syntax-source-code-set stx
         (##update-scope-pair code proc)))
      ((vector? code)
       (##syntax-source-code-set stx
         (##update-scope-vector code proc)))
      ((null? code)
       stx)
      (else
        (##syntax-source-scopes-update stx proc)))))

(define-primitive (add-scope! (stx syntax) (scp scope))
  (##update-scope! stx (lambda (scopes) (##scopes-insert scopes scp))))

(define-primitive (flip-scope! (stx syntax) (scp scope))
  (##update-scope! stx (lambda (scopes) (##scopes-xor scopes scp))))

(define-primitive (add-scope stx (scp scope))
  ((if (or (pair? stx)
           (null? stx))
      ##update-scope-pair
      ##update-scope)
   stx 
   (lambda (scopes) 
     (##scopes-insert scopes scp))))

(define-primitive (flip-scope stx (scp scope))
  ((if (or (pair? stx)
           (null? stx))
      ##update-scope-pair
      ##update-scope)
   stx 
   (lambda (scopes) 
     (##scopes-xor scopes scp))))

(define-primitive (add-scopes stx scps)
  (##fold (lambda (scp stx) 
            (##add-scope stx scp))
          stx
          scps))

;;;----------------------------------------------------------------------------

(define-macro (##define-syntax-source-proc proc)
  (let ((obj  (gensym 'obj))
        (name (string->symbol (string-append "syntax-source-" (symbol->string proc)))))
    `(define-primitive (,name ,obj)
       (and (##syntax-source? ,obj)
            (,proc (##syntax-source-code ,obj))))))

(##define-syntax-source-proc pair?)
(##define-syntax-source-proc null?)
(##define-syntax-source-proc list?)

;;;============================================================================
