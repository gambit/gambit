;;;============================================================================

;;; File: "43.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 43, Vector library.

(##supply-module srfi/43)

(##include "~~lib/_gambit#.scm") ;; define-procedure

;;;============================================================================
;; make-vector

;; make-vector is predefined!

;;============================================================================
;; vector

;; vector is predefined!

;;============================================================================

;; vector-unfold

(define-macro (macro-check-object 
               obj 
               arg-id 
               callee 
               body)

  `,body)

(define-procedure (vector-unfold 
                   (f   procedure)
                   (len (index-range-incl
                          0 (macro-max-fixnum32)))
                   . seeds)
  (letrec ((tabulate! 
             (lambda (f vec i len)  ;; zero seed case
               (if (< i len)
                   (begin
                     (vector-set! vec i (f i))
                     (tabulate! f vec (+ i 1) len)))))

            (unfold1! 
              (lambda (f vec i len seeds)
                (if (< i len)
                    (receive (elt new-seed)
                             (f i seeds)
                      (begin
                        (vector-set! vec i elt)
                        (unfold1! f vec (+ i 1)
                                        len new-seed))))))

            (unfold2+! 
              (lambda (f vec i len seeds)
                (if (< i len)
                    (receive (elt . new-seeds)
                             (apply f i seeds)
                    (begin
                      (vector-set! vec i elt)
                      (unfold2+! f vec (+ i 1) len new-seeds)))))))
      (let ((vec (make-vector len)))
        (cond ((null? seeds)
               (tabulate! f vec 0 len))
              ((null? (cdr seeds))
               (unfold1! f vec 0 len (car seeds)))
              (else
                (unfold2+! f vec 0 len seeds)))
        vec)))

;;============================================================================
;; vector-unfold-right

(define-procedure (vector-unfold-right 
                   (f   procedure)
                   (len (index-range-incl
                          0 (macro-max-fixnum32)))
                   . seeds)
  (%vector-unfold-right f len seeds))


(define (%vector-unfold-right f len seeds)
  (letrec ((tabulate! (lambda (f vec i)  ;; zero seed case
            (if (>= i 0)
                (begin 
                  (vector-set! vec i (f i))
                  (tabulate! f vec (- i 1))))))

           (unfold1! (lambda (f vec i seeds)  ;; unique seed optimisation
             (if (>= i 0)
                 (receive (elt new-seed)
                          (f i seeds)
                 (begin
                   (vector-set! vec i elt)
                   (unfold1! f vec (- i 1) new-seed))))))

           (unfold2+! (lambda (f vec i seeds)
             (if (>= i 0)
                 (receive (elt . new-seeds)
                          (apply f i seeds)
                 (begin
                   (vector-set! vec i elt)
                   (unfold2+! f vec (- i 1) new-seeds)))))))

      (let ((vec (make-vector len))
            (i   (- len 1)))
        (cond ((null? seeds)
               (tabulate! f vec i))
              ((null? (cdr seeds))
               (unfold1! f vec i (car seeds)))
              (else
               (unfold2+! f vec i seeds)))
        vec)))

;;============================================================================
;; vector-copy

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
;; vector-reverse-copy

(define-procedure (vector-reverse-copy 
                   (vec vector)
                   (start (index-range-incl 
                            0 (macro-max-fixnum32))
                          0)
                   (end   (index-range-incl
                            start (macro-max-fixnum32))
                          (vector-length vec)))

  (let ((new-vec (make-vector (- end start))))
    (%vector-reverse-copy! new-vec 0 vec start end)
    new-vec))

;;============================================================================
;; vector-append

;; vector-append is predefined!

;;============================================================================
;; vector-concatenate

(define vector-concatenate  append-vectors)
    
;;;============================================================================
;;; Predicates
;;;============================================================================
;;============================================================================
;; vector?

;; vector? is predefined!

;;============================================================================
;; vector-empty?

(define-procedure (vector-empty? (vec vector))
  (zero? (vector-length vec)))

;;============================================================================
;; vector=

(define-procedure (vector= (elt= procedure) . vecs)
  (cond ((null? vecs)
         #t)
        ((null? (cdr vecs))
         (macro-check-vector
           (car vecs) 1 (vector= elt= . vecs)
         #t))
        (else
          (let loop ((vecs vecs)
                     (id   0))
            (let ((vec (car vecs))
                  (vec-rest (cdr vecs)))
              (macro-check-vector
                (car vecs) id (vector= elt= . vecs)
              (or (null? vec-rest)
                  (and (binary-vector= elt= vec (car vec-rest))
                       (loop vec-rest (+ id 1))))))))))

(define (binary-vector= elt= vec1 vec2)
  (or (eq? vec1 vec2)
      (let ((len1 (vector-length vec1))
            (len2 (vector-length vec2)))
        (letrec ((loop (lambda (i)
                         (or (= i len1)
                             (and (< i len2)
                                  (test (vector-ref vec1 i)
                                        (vector-ref vec2 i)
                                        i)))))
                 (test (lambda (elt1 elt2 i)
                         (and (or (eq? elt1 elt2)
                                  (elt= elt1 elt2))
                              (loop (+ i 1))))))
          (and (= len1 len2)
               (loop 0))))))
;;;============================================================================
;;; Selectors
;;;============================================================================
;;============================================================================
;; vector-ref

;; vector-ref is predefined!

;;============================================================================
;; vector-length

;; vector-length is predefined!

;;;============================================================================
;;; Iteration
;;;============================================================================
;;============================================================================
;; vector-fold

(define-procedure (vector-fold 
                   (kons procedure)
                   knil
                   (vec  vector)
                   . vecs)
  (if (null? vecs)
      (%vector-fold1 kons knil (vector-length vec) vec)
      (%vector-fold2+ kons knil (%smallest-length 
                                  vecs
                                  (vector-length vec)
                                  3
                                  `(vector-fold ,kons ,knil ,vec ,vecs))
                                (cons vec vecs))))

;;============================================================================
;; vector-map

;; vector-map is predefined!

;;============================================================================
;; vector-map!

(define-procedure (vector-map! 
                   (f    procedure)
                   (vec vector)
                   . vecs)
  (letrec ((vector-map1!
             (lambda (f target vec i)
               (if (zero? i)
                   target
                   (let ((j (- i 1)))
                     (vector-set! target j
                                  (f j (vector-ref vec j)))
                     (vector-map1! f target vec j)))))
           (vector-map2+!
             (lambda (f target vecs i)
               (if (zero? i)
                   target
                   (let ((j (- i 1)))
                     (vector-set! target j
                                  (apply f j (map 
                                               (lambda (vec)
                                                 (vector-ref vec j))
                                               vecs)))
                     (vector-map2+! f target vecs j))))))
    (begin
      (if (null? vecs)
          (vector-map1!  f vec vec (vector-length vec))
          (vector-map2+! f vec (cons vec vecs)
            (%smallest-length vecs
                              (vector-length vec)
                              3
                              `(vector-map! ,f ,vec . ,vecs))))
      #!void)))

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
                        (%smallest-length 
                          vecs
                          (vector-length vec)
                          2
                          `(vector-for-each ,f ,vec . vecs))))))

;;============================================================================
;; vector-count

(define-procedure (vector-count 
                   (pred? procedure)
                   (vec   vector)
                   . vecs)

  (if (null? vecs)
      (%vector-fold1 (lambda (index count elt)
                       (if (pred? index elt)
                           (+ count 1)
                           count))
                     0
                     (vector-length vec)
                     vec)
      (%vector-fold2+ (lambda (index count . elts)
                        (if (apply pred? index elts)
                            (+ count 1)
                            count))
                      0
                      (%smallest-length vecs
                                        (vector-length vec)
                                        3
                                        `(vector-count
                                           ,pred? ,vec . ,vecs))
                      (cons vec vecs))))

;;;============================================================================
;;; Searching
;;;============================================================================
;;============================================================================
;; vector-index && vector-skip

(define-procedure (vector-index 
                   (pred? procedure)
                   (vec   vector)
                   . vecs)

  (vector-index/skip pred? 
                     vec vecs 
                    `(vector-index ,vec . ,vecs)))

(define-procedure (vector-skip
                   (pred? procedure)
                   (vec   vector)
                   . vecs)
  (vector-index/skip (lambda elts (not (apply pred? elts)))
                      vec vecs
                      `(vector-skip ,vec . ,vecs)))

(define vector-index/skip
  (letrec ((loop1 (lambda (pred? vec len i)
             (cond ((= i len) 
                    #f)
                   ((pred? (vector-ref vec i)) 
                    i)
                   (else 
                    (loop1 pred? vec len (+ i 1))))))

           (loop2+ (lambda (pred? vecs len i)
             (cond ((= i len)    #f)
                   ((apply pred? (%vectors-ref vecs i)) i)
                   (else         (loop2+ pred? vecs 
                                               len
                                               (+ i 1)))))))
    (lambda (pred? vec vecs callee)
      (if (null? vecs)
          (loop1 pred? vec (vector-length vec) 0)
          (loop2+ pred? (cons vec vecs)
                        (%smallest-length 
                          vecs
                          (vector-length vec)
                          3
                          callee)
                        0)))))
  
;;============================================================================
;; vector-index-right && vector-skip-right

(define-procedure (vector-index-right 
                   (pred? procedure)
                   (vec   vector)
                   . vecs)

  (vector-index/skip-right pred? 
                           vec vecs 
                          `(vector-index-right
                             ,pred?
                             ,vec . ,vecs)))

(define-procedure (vector-skip-right 
                   (pred? procedure) 
                   (vec   vector)
                   . vecs)
  (vector-index/skip-right (lambda elts (not (apply pred? elts)))
                           vec vecs
                          `(vector-skip-right
                             ,pred?
                             ,vec . ,vecs)))


(define vector-index/skip-right
  (letrec ((loop1 (lambda (pred? vec i)
             (cond ((negative? i) #f)
                   ((pred?        (vector-ref vec i)) i)
                   (else          (loop1 pred? vec (- i 1))))))

          (loop2+ (lambda (pred? vecs i)
            (cond ((negative? i) 
                   #f)
                  ((apply pred? (%vectors-ref vecs i))
                   i)
                  (else 
                   (loop2+ pred? vecs (- i 1)))))))

  (lambda (pred? vec vecs callee)
    (if (null? vecs)
        (loop1 pred? vec (- (vector-length vec) 1))
        (loop2+ pred? (cons vec vecs)
                      (- (%smallest-length vecs
                                           (vector-length vec)
                                           3
                                           callee)
                         1))))))

;;============================================================================
;; vector-binary-search

(define-procedure (vector-binary-search 
                   (vec vector) 
                   value 
                   (cmp procedure)
                   (start (index-range-incl
                            0 (macro-max-fixnum32))
                          0)
                   (end   (index-range-incl
                            start (vector-length vec))
                          (vector-length vec)))

  (let loop ((start start) 
             (end end) 
             (j #f))
    (let ((i (quotient (+ start end) 2)))
      (if (or (= start end) 
              (and j 
                   (= i j)))
          #f
          (let ((comparison (cmp (vector-ref vec i) value)))
            (macro-check-fixnum
              comparison 0 (vector-binary-search vec value cmp start end)
            (cond ((zero?     comparison) i)
                  ((positive? comparison) (loop start i i))
                  (else                   (loop i end i)))))))))

;;============================================================================
;; vector-any

(define-procedure (vector-any 
                   (pred? procedure)
                   (vec   vector)
                   . vecs)

  (letrec ((loop1 (lambda (pred? vec i len len-1)
             (and (not (= i len))
                  (if (= i len-1)
                      (pred? (vector-ref vec i))
                      (or (pred? (vector-ref vec i))
                          (loop1 pred? vec (+ i 1)
                                           len len-1))))))
           (loop2+ (lambda (pred? vecs i len len-1)
             (and (not (= i len))
                  (if (= i len-1)
                      (apply pred? (%vectors-ref vecs i))
                      (or (apply pred? 
                                 (%vectors-ref vecs i))
                          (loop2+ pred? vecs (+ i 1)
                                             len len-1)))))))
        (if (null? vecs)
            (let ((len (vector-length vec)))
              (loop1 pred? vec 0 len (- len 1)))
            (let ((len (%smallest-length vecs
                                         (vector-length vec)
                                         2
                                         `(vector-any ,pred?
                                                      ,vec . ,vecs))))
              (loop2+ pred? (cons vec vecs) 0 len (- len 1))))))
  
;;============================================================================
;; vector-every

(define-procedure (vector-every 
                   (pred? procedure)
                   (vec   vector)
                   . vecs)

  (letrec ((loop1 (lambda (pred? vec i len len-1)
             (or (= i len)
                 (if (= i len-1)
                     (pred? (vector-ref vec i))
                     (and (pred? (vector-ref vec i))
                          (loop1 pred? vec (+ i 1)
                                           len len-1))))))
           (loop2+ (lambda (pred? vecs i len len-1)
             (or (= i len)
                 (if (= i len-1)
                     (apply pred? (%vectors-ref vecs i))
                     (and (apply pred? (%vectors-ref vecs i))
                          (loop2+ pred? vecs (+ i 1)
                                             len len-1)))))))
      (if (null? vecs)
          (let ((len (vector-length vec)))
            (loop1 pred? vec 0 len (- len 1)))
          (let ((len (%smallest-length vecs
                                       (vector-length vec)
                                       3
                                       `(vector-every ,pred? 
                                                      ,vec . ,vecs))))
            (loop2+ pred? (cons vec vecs) 0 len (- len 1))))))

;;;============================================================================
;;; Mutators
;;;============================================================================
;;============================================================================
;; vector-set!

;; vector-set! is predefined!

;;============================================================================
;; vector-swap!

(define-procedure (vector-swap! 
                   (vec vector)
                   (i   (index-range-incl
                          0 (##vector-length vec)))
                   (j   (index-range-incl
                          0 (##vector-length vec))))

  (let ((temp (vector-ref vec i)))
    (vector-set! vec i (vector-ref vec j))
    (vector-set! vec j temp)))

;;============================================================================
;; vector-fill!

(define-procedure (vector-fill!
                   (vec vector)
                   fill
                   (start (index-range-incl
                            0 (vector-length vec))
                          0)
                   (end   (index-range-incl
                            start (vector-length vec))
                          (vector-length vec)))

  (subvector-fill! vec start end fill))
    
;;============================================================================
;; vector-reverse!

(define-procedure (vector-reverse! 
                   (vec vector)
                   (start (index-range-incl
                            0     (##vector-length vec))
                          0)
                   (end   (index-range-incl
                            start (##vector-length vec))
                          (##vector-length vec)))

  (let loop ((vec vec)
             (i start)
             (j (- end 1)))
    (if (<= i j)
        (let ((v (vector-ref vec i)))
          (vector-set! vec i (vector-ref vec j))
          (vector-set! vec j v)
          (loop vec (+ i 1) (- j 1))))))

;;============================================================================
;; vector-copy!

;; vector-copy! is predefined!

;;============================================================================
;; vector-reverse-copy!

(define-procedure  (vector-reverse-copy!
                    (target vector)
                    (tstart (index-range-incl
                              0 (vector-length target)))
                    (source vector)
                    (sstart (index-range-incl
                              0 (vector-length source))
                            0)
                    (send   (index-range-incl
                              sstart (vector-length source))
                            (vector-length source)))

  (%vector-reverse-copy! target tstart source sstart send))

;;;============================================================================
;;; Conversion
;;;============================================================================
;;============================================================================
;; vector->list

;; vector->list is predefined!

;;============================================================================
;; reverse-vector->list

(define-procedure (reverse-vector->list 
                   (vec vector)
                   (start (index-range-incl
                            0 (macro-max-fixnum32))
                          0)
                   (end   (index-range-incl
                            start (vector-length vec))
                          (vector-length vec)))

  (let loop ((i   start)
             (res '()))
    (if (= i end)
        res
        (loop (+ i 1) (cons (vector-ref vec i)
                            res)))))

;;============================================================================
;; list->vector

;; list->vector is predefined!

;;============================================================================
;; reverse-list->vector

(define (reverse-list->vector lst)
  (macro-force-vars (lst)
    (if (or (null? lst)
            (pair? lst))
        (%vector-unfold-right (lambda (i l)
                                (values (car l)
                                        (cdr l)))
                              (length lst)
                              (list lst))
        (##raise-type-exception 1 'list 'reverse-list->vector 'lst))))

;;;============================================================================
;;;============================================================================
;;; Utility primitive
;;;============================================================================

;; %vector-reverse-copy!
;; no type check

(define %vector-reverse-copy!
  (letrec ((loop 
             (lambda (target source sstart i j)
               (if (>= i sstart)
                   (begin
                     (vector-set! target j
                                  (vector-ref source i))
                     (loop target source sstart
                           (- i 1)
                           (+ j 1)))))))
    (lambda (target tstart source sstart send)
      (loop target source sstart
            (- send 1)
            tstart))))

;; %vector-fold1

(define %vector-fold1
  (letrec ((loop (lambda (kons knil len vec i)
                   (if (= i len)
                       knil
                       (loop kons
                             (kons i knil (vector-ref vec i))
                             len vec (+ i 1))))))
     (lambda (kons knil len vec)
       (loop kons knil len vec 0))))

;; %vector-fold2+

(define %vector-fold2+
  (letrec ((loop (lambda (kons knil len vecs i)
                   (if (= i len)
                       knil
                       (loop kons
                             (apply kons i knil 
                                    (%vectors-ref vecs i))
                             len vecs (+ i 1))))))
     (lambda (kons knil len vecs)
       (loop kons knil len vecs 0))))

;; %smallest-length
;; type-checked

(define (%smallest-length vector-list len i callee)
  (if (null? vector-list)
      len
      (let* ((vec (car vector-list))
             (vlen (vector-length vec)))
        (if (##vector? vec)
            (%smallest-length (cdr vector-list)
                              (if (< vlen len)
                                  vlen
                                  len)
                              (+ i 1)
                              callee)
            (apply  ##raise-type-exception i 
                                          'vector 
                                          callee)))))

;; %vectors-ref
;; no type-check

(define (%vectors-ref vecs i)
  (map (lambda (x)
         (vector-ref x i))
       vecs))
                                    
;;;============================================================================
