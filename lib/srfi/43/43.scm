;;;============================================================================

;;; File: "43.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 43, Vector library.

(##supply-module srfi/43)

(##include "~~lib/_gambit#.scm") ;; define-procedure

;;;============================================================================
;;
;; Built-in:
;;   make-vector
;;   vector
;;   vector-unfold
;;   vector-unfold-right
;;   vector-reverse-copy
;;   vector-append
;;   vector?
;;   vector-empty?
;;   vector=
;;   vector-ref
;;   vector-length
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
;;   vector-copy!
;;   list->vector
;;   vector->list
;;   vector-reverse!
;;   vector-reverse-copy!
;;   reverse-vector->list
;;   reverse-list->vector
;;
;;;============================================================================

;; %vectors-ref
;; no type-check

(define-macro (%vectors-ref vecs i)
  `(map (lambda (x)
           (vector-ref x ,i))
        ,vecs))

(define (smallest-length vects len arg-id callee)
  (if (null? vects)
      len
      (let ((vect (car vects)))
        (if (vector? vect)
            (let* ((vlen (vector-length vect))
                   (slen (if (< vlen len) vlen len)))
              (smallest-length (cdr vects) slen (+ arg-id 1) callee))
            (##raise-type-exception arg-id 'vector (car callee) (cdr callee))))))
              
;;============================================================================
;; vector-copy
;; fill argument
(define-procedure (vector-copy 
                   (vec vector)
                   (start (index-range-incl
                            0 (macro-max-fixnum32))
                          0)
                   (end   (index-range-incl
                            start (macro-max-fixnum32))
                          (vector-length vec))
                   (fill object #!void))

  (let ((new-vector (make-vector (- end start) fill))
        (len (vector-length vec)))
    (##vector-copy! new-vector 0 vec start
                   (if (> end len)
                       len
                       end))
    new-vector))

;;============================================================================
;; vector-concatenate

(define vector-concatenate  append-vectors)
    
;;;============================================================================
;; vector-fold

(define-procedure (vector-fold
                   (kons procedure)
                   knil
                   (vect vector)
                   . vects)

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-fold1-loop ((knil knil)
                               (i 0))
         (if (= i len)
             knil
             (vector-fold1-loop (kons i knil (vector-ref vect i))
                                (+ i 1)))))
      (else
       (let* ((len (smallest-length vects
                                    len
                                    4
                                   `(vector-fold ,kons ,knil ,vect ,@vects)))
              (vects (cons vect vects)))
         (let vector-fold2+-loop ((knil knil)
                                  (i 0))
           (if (= i len)
               knil
               (vector-fold2+-loop (apply kons i 
                                               knil 
                                               (%vectors-ref vects i))
                                               (+ i 1)))))))))

;;============================================================================
;; vector-map

(define-procedure (vector-map
                   (f   procedure)
                   (vect vector)
                   . vects)

  (let* ((len (vector-length vect))
         (target (make-vector len)))
    (cond 
      ((null? vects)
       (let vector-map1!-loop ((i len))
         (if (= i 0)
             target
             (let ((j (- i 1)))
               (vector-set! target j (f i (vector-ref vect j)))
               (vector-map1!-loop j)))))
       (else 
        (let* ((len (smallest-length vects
                                      len
                                      3
                                     `(vector-map! ,f ,vect ,@vects)))
               (vects (cons vect vects)))
          (let vector-map2+!-loop ((i len))
            (if (= i 0)
                target
                (let ((j (- i 1)))
                  (vector-set! target
                               j
                               (apply f 
                                      i 
                                      (%vectors-ref vects j)))
                  (vector-map2+!-loop j)))))))))

;;============================================================================
;; vector-map!

(define-procedure (vector-map!
                   (f   procedure)
                   (vect vector)
                   . vects)
  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-map1!-loop ((i len))
         (if (= i 0)
             vect
             (let ((j (- i 1)))
               (vector-set! vect j (f i (vector-ref vect j)))
               (vector-map1!-loop j)))))
       (else 
        (let* ((len (smallest-length vects
                                      len
                                      3
                                     `(vector-map! ,f ,vect ,@vects)))
               (vects (cons vect vects)))
          (let vector-map2+!-loop ((i len))
            (if (= i 0)
                vect
                (let ((j (- i 1)))
                  (vector-set! vect 
                               j
                               (apply f 
                                      j 
                                      (%vectors-ref vects j)))
                  (vector-map2+!-loop j)))))))))

;;============================================================================
;; vector-for-each

(define-procedure (vector-for-each 
                   (f procedure)
                   (vec vector)
                   . vecs)

  (letrec ((for-each1
             (lambda (f vec i len)
               (if (< i len)
                   (begin
                     (f i (vector-ref vec i))
                     (for-each1 f vec (+ i 1) len)))))
           (for-each2+
             (lambda (f vecs i len)
               (if (< i len)
                   (begin
                     (apply f i (map (lambda (vec)
                                       (vector-ref vec i))
                                     vecs))
                     (for-each2+ f vecs (+ i 1) len))))))
        (if (null? vecs)
            (for-each1 f vec 0 (vector-length vec))
            (for-each2+ f (cons vec vecs) 0
                        (smallest-length 
                          vecs
                          (vector-length vec)
                          2
                          `(vector-for-each ,f ,vec . vecs))))))

;;============================================================================
;; vector-count

(define-procedure (vector-count 
                   (pred? procedure)
                   (vect   vector)
                   . vects)
  (if (null? vects)
      (let ((len (vector-length vect)))
        (let vector-count1-loop ((count 0)
                                 (i     0))
          (if (= i len)
              count
              (let ((count (if (pred? index (vector-ref vect i))
                               (+ count 1)
                               count)))
                (vector-count1-loop count
                                    (+ i 1))))))
      (let* ((len (smallest-length vects
                                    (vector-length vect)
                                    3
                                   `(vector-count ,pred? ,vect ,@vects)))
             (vects (cons vect vects)))
        (let vector-count2+-loop ((count 0)
                                  (i     0))
          (if (= i len)
              count
              (let ((count (if (apply pred? i (%vectors-ref vects i))
                               (+ count 1)
                               count)))
                (vector-count2+-loop count (+ i 1))))))))

;;;============================================================================
