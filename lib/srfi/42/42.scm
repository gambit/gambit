;;;============================================================================

;;; File: "42.scm"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 42, Eager Comprehensions

(##supply-module srfi/42)

(##namespace ("srfi/42#"))                ;; in srfi/42#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "42#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

(define (ec-:vector-filter vecs)
  (if (null? vecs)
      '()
      (if (zero? (vector-length (car vecs)))
          (ec-:vector-filter (cdr vecs))
          (cons (car vecs) (ec-:vector-filter (cdr vecs))) )))

(define (dispatch-union d1 d2)
  (lambda (args)
    (let ((g1 (d1 args)) (g2 (d2 args)))
      (if g1
          (if g2 
              (if (null? args)
                  (append (if (list? g1) g1 (list g1)) 
                          (if (list? g2) g2 (list g2)) )
                  (error "dispatching conflict" args (d1 '()) (d2 '())) )
              g1 )
          (if g2 g2 #f) ))))

(define (make-initial-:-dispatch)
  (lambda (args)
    (case (length args)
      ((0) 'SRFI42)
      ((1) (let ((a1 (car args)))
             (cond
              ((list? a1)
               (:generator-proc (:list a1)) )
              ((string? a1)
               (:generator-proc (:string a1)) )
              ((vector? a1)
               (:generator-proc (:vector a1)) )
              ((and (integer? a1) (exact? a1))
               (:generator-proc (:range a1)) )
              ((real? a1)
               (:generator-proc (:real-range a1)) )
              ((input-port? a1)
               (:generator-proc (:port a1)) )
              (else
               #f ))))
      ((2) (let ((a1 (car args)) (a2 (cadr args)))
             (cond
              ((and (list? a1) (list? a2))
               (:generator-proc (:list a1 a2)) )
              ((and (string? a1) (string? a1))
               (:generator-proc (:string a1 a2)) )
              ((and (vector? a1) (vector? a2))
               (:generator-proc (:vector a1 a2)) )
              ((and (integer? a1) (exact? a1) (integer? a2) (exact? a2))
               (:generator-proc (:range a1 a2)) )
              ((and (real? a1) (real? a2))
               (:generator-proc (:real-range a1 a2)) )
              ((and (char? a1) (char? a2))
               (:generator-proc (:char-range a1 a2)) )
              ((and (input-port? a1) (procedure? a2))
               (:generator-proc (:port a1 a2)) )
              (else
               #f ))))
      ((3) (let ((a1 (car args)) (a2 (cadr args)) (a3 (caddr args)))
             (cond
              ((and (list? a1) (list? a2) (list? a3))
               (:generator-proc (:list a1 a2 a3)) )
              ((and (string? a1) (string? a1) (string? a3))
               (:generator-proc (:string a1 a2 a3)) )
              ((and (vector? a1) (vector? a2) (vector? a3))
               (:generator-proc (:vector a1 a2 a3)) )
              ((and (integer? a1) (exact? a1) 
                    (integer? a2) (exact? a2)
                    (integer? a3) (exact? a3))
               (:generator-proc (:range a1 a2 a3)) )
              ((and (real? a1) (real? a2) (real? a3))
               (:generator-proc (:real-range a1 a2 a3)) )
              (else
               #f ))))
      (else
       (letrec ((every? 
                 (lambda (pred args)
                   (if (null? args)
                       #t
                       (and (pred (car args))
                            (every? pred (cdr args)) )))))
         (cond
          ((every? list? args)
           (:generator-proc (:list (apply append args))) )
          ((every? string? args)
           (:generator-proc (:string (apply string-append args))) )
          ((every? vector? args)
           (:generator-proc (:list (apply append (map vector->list args)))) )
          (else
           #f )))))))

(define :-dispatch
  (make-initial-:-dispatch) )

(define (:-dispatch-ref)
  :-dispatch )

(define (:-dispatch-set! dispatch)
  (if (not (procedure? dispatch))
      (error "not a procedure" dispatch) )
  (set! :-dispatch dispatch) )

;;;============================================================================
