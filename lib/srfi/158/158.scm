;; TODO force vars

;;;============================================================================

;;; File: "158.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 158, Generators and Accumulators.

(##supply-module srfi/158)

(##include "~~lib/_gambit#.scm")

;;============================================================================

(define-macro
  (macro-check-procedures lst arg-id call rest)
    `(begin
       (fold (lambda (p id)
               (macro-check-procedure
                 p id (,@call) (+ id 1)))
             ,arg-id ,lst)
       ,rest))

(define
  (any pred? lst)
    (if (null? lst)
        #f
        (if (pred? (car lst))
            #t
           (any pred? (cdr lst)))))

  (define (every-eof-obj?-and-generate lst acc)
    (if (null? lst)
        (reverse acc)
        (let ((v ((car lst))))
          (if (eof-object? v)
              #f
              (every-eof-obj?-and-generate (cdr lst) (cons v acc))))))

;;;============================================================================
;; generator
;;   Create a finite generator that
;;   generate each of its argument sequentially.

(define (generator . args)
  (lambda ()
    (if (null? args)
        #!eof
        (let ((next (car args)))
          (set! args (cdr args))
          next))))

;;============================================================================
;; circular-generator
;;   Create an infinite generator
;;   that generate each of its argument
;;   in turn, forever.

(define (circular-generator arg . args)
  (let ((args (cons arg args)))
    (let ((base-args args))
      (lambda ()
        (when (null? args)
          (set! args base-args))
        (let ((next (car args)))
          (set! args (cdr args))
          next)))))
          
;;============================================================================
;; make-iota-generator

(define-procedure 
  (make-iota-generator (count (index-range-incl 0 (macro-max-fixnum32)))
                       (start number 0)
                       (step  number 1))
    (let ((start (if (inexact? step)
                     (inexact start)
                     start)))
      (lambda ()
        (if (<= count 0)
            #!eof
            (let ((result start))
              (set! count (- count 1))
              (set! start (+ start step))
              result)))))

;;============================================================================
;; make-range-generator

(define
  (make-range-generator start #!optional (end (macro-absent-obj))
                                         (step 1))
    (macro-force-vars (start)
      (macro-check-number
        start 1 (make-range-generator start end step)
      (if (eq? end
              (macro-absent-obj))
          (lambda ()                    ;; infinite generator
            (let ((result start))
              (set! start (+ start 1))
              result))
          (macro-force-vars (end step)
            (macro-check-number
              end 2 (make-range-generator start end step)
            (macro-check-number
              step 3 (make-range-generator start end step)
            (let ((start (if (inexact? step)
                             (inexact start)
                             start)))
              (lambda () 
                (if (< start end)
                    (let ((v start))
                      (set! start (+ start step))
                      v)
                    #!eof))))))))))

;;============================================================================
;; make-coroutine-generator
;;  Ex.: (make-coroutine-generator
;;         (lambda (yield)
;;           (let loop ((i 0))
;;             (when (< i 3)
;;                   (yield i)
;;                   (loop (+ i 1))))))

(define
  (make-coroutine-generator proc)
    (define return #f)
    (define resume #f)
    (define (yield v)
    (call/cc (lambda (r)
               (set! resume r)
               (return v))))
    (macro-force-vars (proc)
      (macro-check-procedure
        proc 1 (make-coroutine-generator proc)
      (lambda ()
        (call/cc (lambda (cc) 
                   (set! return cc)
                   (if resume
                     (resume (if #f #f))
                     (begin 
                       (proc yield)
                       (set! resume (lambda (v)
                                      (return #!eof)))
                       (return #!eof)))))))))

;;============================================================================
;; list->generator

(define (list->generator lst)
  (if (or (pair? lst)
          (null? lst))
      (lambda ()
        (if (null? lst)
            #!eof
            (let ((next (car lst)))
              (set! lst (cdr lst))
              next)))
      (##raise-type-exception
       1
       'list
       list->generator lst)))

;;============================================================================
;; vector->generator

(define-procedure
  (vector->generator (vec   vector)
                     (start (index-range-incl 0
                              (vector-length vec))
                            0)
                     (end   (index-range-incl 
                              start
                              (vector-length vec))
                            (vector-length vec)))
    (lambda ()
      (if (>= start end)
          #!eof
          (let ((next (vector-ref vec start)))
            (set! start (+ start 1))
            next))))

;;============================================================================
;; reverse-vector->generator

(define-procedure
  (reverse-vector->generator (vec   vector)
                             (start (index-range-incl 0
                                      (vector-length vec))
                                    0)
                             (end   (index-range-incl 0 
                                      (vector-length vec))
                                    (vector-length vec)))
    (lambda ()
      (if (>= start end)
          #!eof
          (let ((next (vector-ref vec (- end 1))))
            (set! end (- end 1))
            next))))

;;============================================================================
;; string->generator

(define-procedure
  (string->generator (str   string)
                     (start (index-range-incl 0
                              (string-length str))
                            0)
                     (end   (index-range-incl start
                              (string-length str))
                            (string-length str)))
    (lambda () 
      (if (>= start end)
          #!eof
          (let ((next (string-ref str start)))
            (set! start (+ start 1))
            next))))

;;============================================================================
;;bytevector->generator

(define-procedure
  (bytevector->generator (str   u8vector)
                     (start (index-range-incl 0
                              (u8vector-length str))
                            0)
                     (end   (index-range-incl start
                              (u8vector-length str))
                            (u8vector-length str)))
    (lambda () 
      (if (>= start end)
          #!eof
          (let ((next (u8vector-ref str start)))
            (set! start (+ start 1))
            next))))

;;============================================================================
;; make-for-each-generator
;; TODO
(define-procedure
  (make-for-each-generator (for-each procedure)
                           obj)
  (make-coroutine-generator
    (lambda (yield)
      (for-each yield obj))))

;;============================================================================
;; make-unfold-generator
(define-procedure 
  (make-unfold-generator (stop?     procedure)
                         (mapper    procedure)
                         (successor procedure)
                         seed)
    (make-coroutine-generator
      (lambda (yield)
        (let loop ((s seed))
          (if (stop? s)
            (if #f #f)
            (begin 
              (yield (mapper s))
              (loop  (successor s))))))))

;;============================================================================
;;============================================================================
;; Generator operations
;;============================================================================
;; gcons*

(define (gcons* arg1 . args)
  (let ((args (cons arg1 args)))
    (lambda ()
      (if (null? args)
          #!eof
          (if (eq? (cdr args) '())
              (let ((gen (car args)))
                (macro-check-procedure  ; runtime error
                gen (- (length args) 1) (gcons* . args)
                ((car args))))
              (let ((v (car args)))
                (set! args (cdr args))
              v))))))

;;============================================================================
;; gappend
;; run-time checked

(define (gappend . args)
  (macro-force-vars (args)
    (macro-check-procedures
      args 1 (gappend . args)
    (lambda ()
      (if (null? args)
          #!eof
          (let loop ((v ((car args))))
            (if (eof-object? v)
                (begin
                  (set! args (cdr args))
                  (if (null? args)
                      #!eof
                      (loop ((car args)))))
                v)))))))

;;============================================================================
;;gflatten

(define-procedure
  (gflatten (gen procedure))
    (let ((state '()))
      (lambda ()
        (if (null? state) (set! state (gen)))
        (if (eof-object? state)
            state
            (let ((obj (car state)))
              (set! state (cdr state))
              obj)))))

;;============================================================================
;; ggroup

(define-macro 
  (simple-ggroup gen k)
    `(let ((gen ,gen))
      (lambda ()
       (let loop ((item (gen)) 
                  (result '()) 
                  (count (- ,k 1)))
         (if (eof-object? item)
             (if (null? result) item (reverse result))
             (if (= count 0)
                 (reverse (cons item result))
                 (loop (gen) 
                       (cons item result) 
                       (- count 1))))))))
      
(define-macro 
  (padded-ggroup gen k padding)
    `(let ((gen ,gen))
       (lambda ()
         (let ((item (gen)))
           (if (eof-object? item)
               item
               (let ((len (length item)))
                 (if (= len ,k)
                     item
                     (append item (make-list (- ,k len) ,padding)))))))))


(define
  (ggroup gen k #!optional (pad (macro-absent-obj)))
    (macro-force-vars (gen k)
      (macro-check-procedure
        gen 1 (ggroup gen k pad)
      (macro-check-index-range-incl
        k 2 0 (macro-max-fixnum32)
              (ggroup gen k pad)
      (if (eq? pad (macro-absent-obj))
          (simple-ggroup gen k)
          (padded-ggroup
            (simple-ggroup gen k)
            k 
            pad))))))

;;============================================================================
;; gmerge
;; XXX

(define (gmerge < gen . gens)
  (define (gmerge < . gens)
    (cond ((null? (cdr gens))
           (car gens))
          ((null? (cddr gens))
           (let* ((genright (cadr gens))
                  (genleft  (car gens))
                  (left (genleft))
                  (right (genright)))
             (lambda ()
               (let ((eof-left  (eof-object? left))
                     (eof-right (eof-object? right)))
                 (cond ((and eof-left
                             eof-right)
                        left)
                       (eof-left
                         (let ((obj right))
                           (set! right (genright))
                           obj))
                       (eof-right
                         (let ((obj left))
                           (set! left (genleft))
                           obj))
                       ((< right left)
                         (let ((obj right))
                           (set! right (genright))
                            obj))
                       (else
                        (let ((obj left))
                          (set! left (genleft))
                          obj)))))))
          (else
           (apply
             gmerge <
             (let loop ((gens (cons genleft gens))
                        (gs '()))
               (cond ((null? gens)
                      (reverse gs))
                 ((null? cdr gens)
                  (reverse (cons (car gens) gs)))
                 (else
                  (loop (cddr gens)
                        (cons (gmerge < (car gens) (cadr gens))
                              gs)))))))))

    (macro-force-vars (< gen . gens)
      (macro-check-procedure
        < 1 (gmerge < gen . gens)
      (macro-check-procedure
        gen 2 (gmerge < gen . gens)
      (macro-check-procedures
        gens 3 (gmerge < gen . gens)
      (apply gmerge < (cons gen gens)))))))

;;============================================================================
;; gmap

(define (gmap proc gen . gens)
  (define (gmap proc gen)
    (lambda ()
      (let ((item (gen)))
        (if (eof-object? item)
            item
            (proc item)))))

  (macro-force-vars (proc)
    (macro-check-procedure
      proc 1 (gmap proc gen . gens)
    (macro-check-procedure
      gen 2 (gmap proc gen . gens)
    (macro-check-procedures
      gens 3 (gmap proc gen . gens)
    (if (null? gens)
        (gmap proc gen)
        (let ((gens (cons gen gens)))
          (lambda ()
            (let ((items (every-eof-obj?-and-generate gens '())))
              (if items
                  (apply proc items)
                  #!eof))))))))))

;;============================================================================
;; gcombine

(define (gcombine proc seed gen . gens)
  (macro-force-vars (proc gen . gens)
    (macro-check-procedure
      proc 1 (gcombine proc seed gen . gens)
    (macro-check-procedure
      gen  3 (gcombine proc seed gen . gens)
    (macro-check-procedures
      gens 4 (gcombine proc seed gen . gens)
    (let ((gens (cons gen gens)))
      (lambda ()
        (let ((items (every-eof-obj?-and-generate gens '())))
          (if items
              (receive (value newseed)
                       (apply proc (append items (list seed)))
                (begin
                  (set! seed newseed)
                  value))
              #!eof)))))))))

;;============================================================================
;;gfilter

(define-procedure
  (gfilter (pred procedure)
           (gen  procedure))
    (lambda ()
      (let loop ()
        (let ((next (gen)))
          (if (or (eof-object? next)
                  (pred next))
            next
            (loop))))))

;;============================================================================
;; gremove

(define-procedure 
  (gremove (pred procedure )
           (gen  procedure))
    (lambda ()
      (let loop ()
        (let ((next (gen)))
          (if (or (eof-object? next)
                  (not (pred next)))
              next
              (loop))))))

;;============================================================================
;; gstate-filter

(define-procedure
  (gstate-filter (proc procedure)
                 seed
                 (gen  procedure))
  (let ((state seed))
    (lambda ()
      (let loop ((item (gen)))
        (if (eof-object? item)
            #!eof
            (receive (yes newstate)
                     (proc item state)
              (begin
                (set! state newstate)
                (if yes
                    item
                    (loop (gen))))))))))

;;============================================================================
;; gtake

(define
  (gtake gen k #!optional (padding #!eof))
    (macro-force-vars (gen k)
      (macro-check-procedure
        gen 1 (gtake gen k padding)
      (macro-check-index-range-incl
        k 2 0 (macro-max-fixnum32) 
              (gtake gen k padding)
      (make-coroutine-generator
        (lambda (yield)
          (if (> k 0)
            (let loop ((i 0) (v (gen)))
              (begin
                (if (eof-object? v)
                    (yield padding)
                    (yield v))
                (if (< (+ 1 i) k)
                  (loop (+ 1 i)
                        (gen))
                  #!eof)))
            #!eof)))))))

;;============================================================================
;; gdrop

(define-procedure
  (gdrop (gen procedure) 
         (k   (index-range-incl 0 (macro-max-fixnum32))))
  (lambda ()
    (do () ((<= k 0)) (set! k (- k 1)) (gen))
    (gen)))

;;============================================================================
;; gdrop-while

(define-procedure
  (gdrop-while (pred procedure)
               (gen  procedure))
    (define found #f)
    (lambda ()
      (let loop ()
        (let ((val (gen)))
          (cond (found val)
                ((and (not (eof-object? val))
                      (pred val))
                 (loop))
                (else (set found #t) val))))))

;;============================================================================
;; gtake-while

(define-procedure
  (gtake-while (pred procedure)
               (gen  procedure))
  (lambda ()
    (let loop ((next (gen)))
      (if (eof-object? next)
          #!eof
          (if (pred next)
              next
              (loop (gen)))))))

;;============================================================================
;; gdelete

(define-procedure
  (gdelete item
           (gen procedure)
           (==  procedure equal?))
    (lambda () 
      (let loop ((v (gen)))
        (if (or (eof-object? v)
                (not (== item v)))
            v
            (loop (gen))))))

;;============================================================================
;; gdelete-neighbor-dups

(define-procedure
  (gdelete-neighbor-dups (gen procedure)
                         (==  procedure))
  (define prev (macro-absent-obj))
  (lambda ()
    (if (eq? prev (macro-absent-obj))
        (begin
          (set! prev (gen))
          prev)
        (let loop ((v (gen)))
          (cond ((eof-object? v)
                 #!eof)
                ((== prev v)
                 (loop (gen)))
                (else
                  (set! prev v)
                  v))))))

;;============================================================================
;; gindex

(define-procedure
  (gindex (value-gen procedure)
          (index-gen procedure))
    (let ((count 0)
          (prec  -1))
      (lambda ()
        (if count
            (let ((index (index-gen)))
              (if (eof-object? index)
                  (begin
                    (set! count #f)
                    #!eof)
                  (macro-check-index-range-incl
                    index 2 (+ prec 1) (macro-max-fixnum32)
                                       (gindex value-gen 
                                               index-gen)
                  (begin
                    (set! prec index)
                    (let loop ((value (value-gen)))
                      (cond ((eof-object? value)
                             (set! count #f)
                             #!eof)
                            ((= index count)
                             (set! count (+ count 1))
                             value)
                            (else
                              (set! count (+ count 1))
                              (loop (value-gen)))))))))
            #!eof))))

;;============================================================================
;; gselect

(define-procedure
  (gselect (value-gen procedure)
           (truth-gen procedure))
    (let ((done? #f))
      (lambda ()
        (if done?
            #!eof
            (let loop ((value (value-gen))
                       (truth (truth-gen)))
              (cond
                ((or (eof-object? value)
                     (eof-object? truth))
                 (set! done? #t)
                 #!eof)
                (truth
                  value)
                (else
                  (loop (value-gen)
                        (truth-gen)))))))))

;;============================================================================
;; generator-fold

(define (generator-fold f seed g . gs)
  (macro-force-vars (f g . gs)
    (macro-check-procedure
      f 1 (generator-fold f seed g . gs)
    (macro-check-procedure
      g 1 (generator-fold f seed g . gs)
    (macro-check-procedures
      gs 3 (generator-fold f seed g . gs)
    (let ((gs (cons g gs)))
      (let loop ((seed seed))
        (let ((vs (every-eof-obj?-and-generate gs '())))
          (if vs
              (loop
                (apply f (append vs
                                 (list seed))))
              seed)))))))))

;;============================================================================
;; generator->list

(define
  (generator->list gen #!optional (n (macro-absent-obj)))
    (macro-force-vars (gen)
      (macro-check-procedure
        gen 1 (generator->list gen n)
      (reverse
        (if (eq? n (macro-absent-obj))
            (generator-fold cons '() gen)
            (generator-fold cons '() (gtake gen n)))))))

;;============================================================================
;; generator->reverse-list

(define
  (generator->reverse-list gen #!optional (n (macro-absent-obj)))
    (macro-force-vars (gen)
      (macro-check-procedure
        gen 1 (generator->reverse-list gen n)
      (if (eq? n (macro-absent-obj))
          (generator-fold cons '() gen)
          (generator-fold cons '() (gtake gen n))))))

;;============================================================================
;; generator->vector

(define
  (generator->vector gen #!optional (n (macro-absent-obj)))
  (macro-force-vars (gen)
    (macro-check-procedure
      gen 1 (generator->vector gen n)
    (list->vector
      (if (eq? n (macro-absent-obj))
          (generator->list gen)
          (generator->list gen n))))))

;;============================================================================
;; generator->vector!

(define-procedure
  (generator->vector! (vec vector)
                      (at  (index-range-incl 0 
                                             (- (vector-length vec)
                                                1)))
                      (gen procedure))
    (let loop ((value (gen))
               (count 0)
               (at    at))
      (if (or (eof-object? value)
              (>= at (vector-length vec)))
          count
          (begin
            (vector-set! vec at value)
            (loop (gen) (+ count 1) (+ at 1))))))

;;============================================================================
;; generator->string

(define
  (generator->string gen #!optional (n (macro-absent-obj)))
  (macro-force-vars (gen)
    (macro-check-procedure
      gen 1 (generator->string gen n)
    (list->string
      (if (eq? n (macro-absent-obj))
          (generator->list gen)
          (generator->list gen n))))))

;;============================================================================
;; generator-for-each

(define (generator-for-each f gen . gens)
  (macro-force-vars (f gen .gens)
    (macro-check-procedure
      f 1 (generator-for-each f . gens)
    (macro-check-procedure
      gen 2 (generator-for-each f . gens)
    (macro-check-procedures
      gens 3 (generator-for-each f . gens)
    (let ((gens (cons gen gens)))
      (let loop ()
        (let ((vs (every-eof-obj?-and-generate gens '())))
          (if vs
              (begin (apply f vs)
                     (loop))
              (if #f #f))))))))))

;;============================================================================
;; generator-map->list

(define (generator-map->list f g . gs)
  (macro-force-vars (f g . gs)
    (macro-check-procedure
      f 1 (generator-map->list f g . gs)
    (macro-check-procedure
      g 2 (generator-map->list f g . gs)
    (macro-check-procedures
      gs 3 (generator-map->list f g . gs)
    (let ((gens (cons g gs)))
      (let loop ((result '()))
        (let ((vs (every-eof-obj?-and-generate gens '())))
          (if vs
              (loop (cons (apply f vs) result))
              (reverse result))))))))))

;;============================================================================
;; generator-find

(define-procedure
  (generator-find (pred procedure)
                  (g    procedure))
    (let loop ((v (g)))
      (if (or (pred v)
              (eof-object? v))
          v
          (loop (g)))))

;;============================================================================
;; generator-count

(define-procedure
  (generator-count (pred procedure)
                   (gen  procedure))
    (generator-fold
      (lambda (v n)
        (if (pred v)
            (+ 1 n)
            n))
      0 gen))

;;============================================================================
;; generator-any

(define-procedure
  (generator-any (pred procedure)
                 (gen  procedure))
    (let loop ((v (gen)))
      (if (eof-object? v)
          #f
          (if (pred v)
              #t
              (loop (gen))))))

;;============================================================================
;; generator-every

(define-procedure
  (generator-every (pred procedure)
                   (gen  procedure))
    (let loop ((v (gen)))
      (if (eof-object? v)
        #t
        (if (pred v)
            (loop (gen))
            #f))))

;;============================================================================
;; generator-unfold

(define (generator-unfold g unfold . args)
  (macro-force-vars (g unfold)
    (macro-check-procedure
      g 1 (generator-unfold g unfold . args)
    (macro-check-procedure
      unfold 2 (generator-unfold g unfold . args)
        (apply unfold 
               eof-object?
               identity
               (lambda (x) (g))
               (g)
               args)))))

;;;============================================================================
;; Accumulators
;;;============================================================================
;; make-accumulator

(define-procedure
  (make-accumulator (kons     procedure)
                    knil
                    (finalize procedure))
    (let ((state knil))
      (lambda (obj)
        (if (eof-object? obj)
            (finalize state)
            (set! state (kons obj state))))))

;;============================================================================
;; count-accumulator

(define (count-accumulator)
  (make-accumulator
    (lambda (obj state)
      (+ 1 state))
    0 
    identity))


;;============================================================================
;; list-accumulator

(define (list-accumulator)
  (make-accumulator cons '() reverse))

;;============================================================================
;; reverse-list-accumulator

(define (reverse-list-accumulator)
  (make-accumulator cons '() identity))

;;============================================================================
;; vector-accumulator

(define (vector-accumulator)
  (make-accumulator 
    cons 
    '() 
    (lambda (x) 
      (list->vector (reverse x)))))

;;============================================================================
;; reverse-vector-accumulator

(define (reverse-vector-accumulator)
  (make-accumulator cons '() list->vector))

;;============================================================================
;;vector-accumulator!

(define-procedure
  (vector-accumulator! (vec vector)
                       (at  (index-range-incl
                              0 (vector-length vec))))
    (lambda (obj)
      (if (eof-object? obj)
          vec
          (begin
            (vector-set! vec at obj)
            (set! at (+ at 1))))))

;;============================================================================
;; bytevector-accumulator

(define (bytevector-accumulator)
  (make-accumulator
    cons 
    '()
    (lambda (x)
      (list->u8vector (reverse x)))))

;;============================================================================
;; bytevector-accumulator!

(define-procedure 
  (bytevector-accumulator! (str u8vector)
                           (at  (index-range-incl
                                  0 (u8vector-length str))))
    (lambda (obj)
      (if (eof-object? obj)
          str
          (begin
            (u8vector-set! str at obj)
            (set! at (+ at 1))))))

;;============================================================================
;; string-accumulator

(define (string-accumulator)
  (make-accumulator 
    cons
    '()
    (lambda (lst)
      (list->string (reverse lst)))))

;;============================================================================
;; sum-accumulator

(define (sum-accumulator)
  (make-accumulator + 0 identity))

;;============================================================================
;; product-accumulator

(define (product-accumulator)
  (make-accumulator * 1 identity))

;;;============================================================================
