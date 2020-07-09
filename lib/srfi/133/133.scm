;;;============================================================================

;;; File: "133.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 133, Vector library.

(##supply-module srfi/133)

(##include "~~lib/_gambit#.scm") ;; define-procedure

;;;============================================================================
;;
;; built-in:
;;
;;   make-vector
;;   vector
;;   vector-unfold
;;   vector-unfold-right
;;   vector-copy
;;   vector-reverse-copy
;;   vector-append
;;   vector-concatenate
;;   vector?
;;   vector-empty?
;;   vector=
;;   vector-ref
;;   vector-length
;;   vector-fold
;;   vector-fold-right
;;   vector-map
;;   vector-map!
;;   vector-for-each
;;   vector-count
;;   vector-index
;;   vector-index-right
;;   vector-skip
;;   vector-skip-right
;;   vector-binary-search
;;   vector-any
;;   vector-every
;;   vector-set!
;;   vector-swap!
;;   vector-fill!
;;   vector-reverse
;;   vector-copy!
;;   vector-reverse-copy!
;;   vector->list
;;   reverse-vector->list
;;   list->vector
;;   reverse-list->vector
;;   vector-cumulate
;;   vector-partition
;;   vector->string
;;   string->vector
;;
;;============================================================================
;; vector-concatenate

(define vector-concatenate  append-vectors)

;;============================================================================
;; vector-append-subvectors
;

(define-procedure (vector-append-subvectors . args)
  (define (gather-args args)
    (let loop ((args args) 
               (vects  '()) 
               (starts '()) 
               (ends   '())
               (arg-id 1))
      (if (null? args)
          (values (reverse vects) (reverse starts) (reverse ends))
          (let* ((vect (car args))
                 (start (cadr args))
                 (end   (caddr args)))
            (macro-check-vector
              vect arg-id (vector-append-subvectors . args)
              (macro-check-index-range-incl
                start 
                (fx+ arg-id 1) 
                0 
                (macro-max-fixnum32)
                (vector-append-subvectors . args)
                (macro-check-index-range-incl
                  end
                  (fx+ arg-id 2)
                  start
                  (##vector-length vect)
                  (vector-append-subvectors . args)
                  (loop (cdddr args)
                        (cons vect vects) 
                        (cons start starts) 
                        (cons end   ends)
                        (fx+ arg-id 3)))))))))

  (define (total-length starts ends)
    (let loop ((count 0)
               (starts starts)
               (ends ends))
      (if (null? starts)
          count
          (let ((start (car starts)) 
                (end (car ends)))
            (loop (fx+ count (fx- end start))
                  (cdr starts)
                  (cdr ends))))))

  (define (copy-each! result vects starts ends)
    (let loop ((at 0)
               (vects vects)
               (starts starts)
               (ends ends))
      (if (null? vects)
          result
          (let ((vec (car vects))
                (start (car starts))
                (end (car ends)))
            (##vector-copy! result at vec start end)
            (loop (fx+ at (fx- end start))
                  (cdr vects)
                  (cdr starts)
                  (cdr ends))))))
  (let ((args-len (length args)))
    (if (and (not (fx= 0 args-len))
             (fx= (modulo args-len 3) 0))
        (receive (vects starts ends) 
                 (gather-args args)
          (let ((result (make-vector (total-length starts ends))))
            (copy-each! result vects starts ends)))
        (##raise-wrong-number-of-arguments-exception 
           'vector-append-subvectors
           args))))

;;;============================================================================
