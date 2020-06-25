;;;============================================================================

;;; File: "vector.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;;; Vector operations.

(##include "vector#.scm")

;;;----------------------------------------------------------------------------

(define-prim-vector-procedures
  vector
  0
  macro-no-force
  macro-no-check
  macro-no-check
  #f
  #f
  define-map-and-for-each
  ##equal?)

(define-prim-vector-procedures
  s8vector
  0
  macro-force-vars
  macro-check-exact-signed-int8
  macro-check-exact-signed-int8-list
  macro-test-exact-signed-int8
  ##fail-check-exact-signed-int8
  #f
  ##fx=)

(define-prim-vector-procedures
  u8vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list
  macro-test-exact-unsigned-int8
  ##fail-check-exact-unsigned-int8
  #f
  ##fx=)

(define-prim-vector-procedures
  s16vector
  0
  macro-force-vars
  macro-check-exact-signed-int16
  macro-check-exact-signed-int16-list
  macro-test-exact-signed-int16
  ##fail-check-exact-signed-int16
  #f
  ##fx=)

(define-prim-vector-procedures
  u16vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int16
  macro-check-exact-unsigned-int16-list
  macro-test-exact-unsigned-int16
  ##fail-check-exact-unsigned-int16
  #f
  ##fx=)

(define-prim-vector-procedures
  s32vector
  0
  macro-force-vars
  macro-check-exact-signed-int32
  macro-check-exact-signed-int32-list
  macro-test-exact-signed-int32
  ##fail-check-exact-signed-int32
  #f
  ##eqv?)

(define-prim-vector-procedures
  u32vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int32
  macro-check-exact-unsigned-int32-list
  macro-test-exact-unsigned-int32
  ##fail-check-exact-unsigned-int32
  #f
  ##eqv?)

(define-prim-vector-procedures
  s64vector
  0
  macro-force-vars
  macro-check-exact-signed-int64
  macro-check-exact-signed-int64-list
  macro-test-exact-signed-int64
  ##fail-check-exact-signed-int64
  #f
  ##eqv?)

(define-prim-vector-procedures
  u64vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int64
  macro-check-exact-unsigned-int64-list
  macro-test-exact-unsigned-int64
  ##fail-check-exact-unsigned-int64
  #f
  ##eqv?)

(define-prim-vector-procedures
  f32vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

(define-prim-vector-procedures
  f64vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

;;----------------------------------------------------------------------------
(define-prim&proc (vector-cas! 
                   (vect vector)
                   (k    (index-range-incl 0 (vector-length vect)))
                   val
                   oldval)
  ;;TODO: remove after bootstrap
  (include "~~/lib/gambit/prim/prim#.scm")
  (declare (not interrupts-enabled))
  (let ((result (vector-ref vect k)))
    (if (eq? result oldval)
        (vector-set! vect k val))
    result))

(define-procedure (vector-inc! 
                   (vect vector)
                   (k    (index-range-incl 0 (vector-length vect)))
                   (val  fixnum 1))
  (##vector-inc! vect k val))

(define-prim (##vector-inc! vect k #!optional (val 1))
 ;;TODO: remove after bootstrap
  (include "~~/lib/gambit/prim/prim#.scm")
  (declare (not interrupts-enabled))
  (let ((result (vector-ref vect k)))
    (vector-set! vect k (fxwrap+ result val))
    result))

(define bytevector?        u8vector?)
(define make-bytevector    make-u8vector)
(define bytevector         u8vector)
(define bytevector-length  u8vector-length)
(define bytevector-u8-ref  u8vector-ref)
(define bytevector-u8-set! u8vector-set!)
(define bytevector-copy    u8vector-copy)
(define bytevector-copy!   u8vector-copy!)
(define bytevector-append  u8vector-append)

;;----------------------------------------------------------------------------
;; %vectors-ref
(define-macro (%vectors-ref vects i)
  `(map (lambda (vect) (vector-ref vect ,i)) ,vects))


;; vector-empty?
;;
(define-prim&proc (vector-empty? (vect vector))
  (include "~~/lib/gambit/prim/prim#.scm")
  (declare (not interrupts-enabled))
  (fx= (vector-length vect) 0))

;; vector-unfold!
;;
(define-prim (##vector-unfold! f vect start end . seeds)

  (define (tabulate! f vect i len) 
    (if (fx< i len)
        (begin
          (vector-set! vect i (f i))
          (tabulate! f vect (fx+ i 1) len))))

  (define (unfold1! f vect i len seeds)
    (if (fx< i len)
        (receive (elt new-seed)
                   (f i seeds)
                   (begin
                     (vector-set! vect i elt)
                     (unfold1! f 
                               vect 
                               (fx+ i 1)
                               len 
                               new-seed)))))

  (define (unfold2+! f vect i len seeds)
    (if (fx< i len)
        (receive (elt . new-seeds)
                   (apply f i seeds)
                   (begin
                     (vector-set! vect i elt)
                     (unfold2+! f 
                                vect 
                                (fx+ i 1) 
                                len 
                                new-seeds)))))

  (include "~~/lib/gambit/prim/prim#.scm")
  (begin
    (cond ((null? seeds)
           (tabulate! f vect start end))
          ((null? (cdr seeds))
           (unfold1! f vect start end (car seeds)))
          (else
           (unfold2+! f vect start end seeds)))
    vect))

(define-procedure (vector-unfold!
                   (f     procedure)
                   (vect  vector)
                   (start (index-range-incl 0 ##max-fixnum))
                   (end   (index-range-incl start (vector-length vect)))
                   . seeds)
  (apply ##vector-unfold! f vect start end seeds))

;; vector-unfold
;;
(define-prim (##vector-unfold f len . seeds)
  (let ((vect (make-vector len)))
    (apply vector-unfold! f vect 0 len seeds)
    vect))

(define-procedure (vector-unfold 
                   (f   procedure)
                   (len (index-range-incl 0 ##max-fixnum))
                   . seeds)
  (apply ##vector-unfold f len seeds))

;; vector-unfold-right!
;;
(define-prim (##vector-unfold-right! f vect start end . seeds)

  (define (tabulate! f vect i end)  ;; seed less case
    (if (fx>= i end)
        (begin
          (vector-set! vect i (f i))
          (tabulate! f vect (fx- i 1) end))))

  (define (unfold1! f vect i end seeds)
    (if (fx>= i end)
        (receive (elt new-seed)
                   (f i seeds)
                   (begin
                     (vector-set! vect i elt)
                     (unfold1! f 
                               vect 
                               (fx- i 1)
                               end
                               new-seed)))))

  (define (unfold2+! f vect i end seeds)
    (if (fx>= i end)
        (receive (elt . new-seeds)
                   (apply f i seeds)
                   (begin
                     (vector-set! vect i elt)
                     (unfold2+! f 
                                vect 
                                (fx- i 1) 
                                end
                                new-seeds)))))

  (include "~~/lib/gambit/prim/prim#.scm")
  (begin
    (cond ((null? seeds)
           (tabulate! f vect (fx- end 1) start))
          ((null? (cdr seeds))
           (unfold1! f vect (fx- end 1) start (car seeds)))
          (else
           (unfold2+! f vect (fx- end 1) start seeds)))
    vect))

(define-procedure (vector-unfold-right!
                   (f     procedure)
                   (vect  vector)
                   (start (index-range-incl 0 ##max-fixnum))
                   (end   (index-range-incl start (vector-length vect)))
                   . seeds)
  (apply ##vector-unfold-right! f vect start end seeds))

;; vector-unfold-right 
;;
(define-prim (##vector-unfold-right f len . seeds)
  (let ((vect (make-vector len)))
    (apply ##vector-unfold-right! f vect 0 len seeds)))


(define-procedure (vector-unfold-right
                   (f   procedure)
                   (len (index-range-incl 0 ##max-fixnum))
                   . seeds)
  (apply ##vector-unfold-right f len seeds))


;; vector-reverse-copy!
(define-procedure (vector-reverse-copy!
                   (target vector)
                   (tstart (index-range-incl 0 (vector-length target)))
                   (source vector)
                   (sstart (index-range-incl 0 ##max-fixnum) 
                           0)
                   (send   (index-range-incl sstart (vector-length source))
                           (vector-length source)))

  (##vector-reverse-copy! target tstart source sstart send))


(define-prim (##vector-reverse-copy! 
              target 
              tstart 
              source 
              #!optional 
              (sstart 0) 
              (send (vector-length source)))
  (include "~~/lib/gambit/prim/prim#.scm")
  (let vector-reverse-copy!-loop ((i (fx- send 1))
                                  (j tstart))
    (cond ((fx>= i sstart)
           (vector-set! target j (vector-ref source i))
           (vector-reverse-copy!-loop (fx- i 1)
                                      (fx+ j 1))))))

; vector-reverse-copy
;;
(define-prim (##vector-reverse-copy 
              vect 
              #!optional 
              (start 0) 
              (end (vector-length vect)))

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((new-vect (make-vector (fx- end start))))
    (vector-reverse-copy! new-vect
                          0
                          vect
                          start
                          end)
    new-vect))

(define-procedure (vector-reverse-copy
                   (vect  vector)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end   (index-range-incl start (vector-length vect))
                          (vector-length vect)))
  (##vector-reverse-copy vect start end))


;; vector=
;;

(define-prim&proc (binary-vector= 
                   (elt=  procedure) 
                   (vect1 vector) 
                   (vect2 vector))
  (include "~~/lib/gambit/prim/prim#.scm")
  (or (eq? vect1 vect2)
      (let ((len1 (vector-length vect1))
            (len2 (vector-length vect2)))
        (and (fx= len1 len2)
             (let binary-vector=-loop ((i 0))
               (or (fx= i len1)
                   (and (fx< i len2)
                        (let ((elt1 (vector-ref vect1 i))
                              (elt2 (vector-ref vect2 i)))
                          (and (or (eq? elt1 elt2)
                                   (elt= elt1 elt2))
                               (binary-vector=-loop (fx+ i 1)))))))))))

(define-prim (##vector= elt= . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (if (or (null? vects)
          (null? (cdr vects)))
      #t
      (let vector=-loop ((vect      (car vects))
                         (vect-rest (cdr vects)))
        (or (null? vect-rest)
            (let ((new-vect (car vect-rest)))
              (and (##binary-vector= elt= vect new-vect)
                   (vector=-loop new-vect
                                 (cdr vect-rest))))))))


(define-procedure (vector= (elt= procedure) . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (cond 
    ((null? vects)
     #t)
    ((null? (cdr vects))
     (let ((vect (car vects)))
         (macro-check-vector vect
                             2
                             (vector= elt= . vects)
           #t)))
    (else
     (let ((vect (car vects)))
       (let vector=-loop ((vect (macro-check-vector 
                                  vect 2 (vector= elt= . vects) 
                                  vect))
                        (vect-rest (cdr vects))
                        (id        2))
         (or (null? vect-rest)
             (let ((new-vect (car vect-rest)))
               (macro-check-vector new-vect id (vector= elt= . vects)
                 (and (##binary-vector= elt= vect new-vect)
                      (vector=-loop new-vect
                                    (cdr vect-rest)
                                    (fx+ id 1)))))))))))

;; vector-fold
;;
(define-prim (##vector-fold kons knil vect . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-fold1-loop ((knil knil)
                               (i 0))
         (if (fx= i len)
             knil
             (vector-fold1-loop (kons knil (vector-ref vect i))
                                (fx+ i 1)))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
         (let vector-fold2+-loop ((knil knil)
                                  (i 0))
           (if (fx= i len)
               knil
               (vector-fold2+-loop (apply kons knil 
                                               (%vectors-ref vects i))
                                               (fx+ i 1)))))))))


(define-procedure (vector-fold
                   (kons procedure)
                   knil
                   (vect vector)
                   . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-fold1-loop ((knil knil)
                               (i 0))
         (if (fx= i len)
             knil
             (vector-fold1-loop (kons knil (vector-ref vect i))
                                (fx+ i 1)))))
      (else
       (let ((len (%smallest-length vects
                                    len
                                    4
                                   `(vector-fold ,kons ,knil ,vect . ,vects)))
             (vects (cons vect vects)))
         (let vector-fold2+-loop ((knil knil)
                                  (i 0))
           (if (fx= i len)
               knil
               (vector-fold2+-loop (apply kons knil 
                                               (%vectors-ref vects i))
                                               (fx+ i 1)))))))))

;; vector-map!
;;
(define-prim (vector-map! f vect . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-map1!-loop ((i len))
         (if (fx= i 0)
             vect
            (let ((i (fx- i 1)))
              (vector-set! vect i (f (vector-ref vect i)))
              (vector-map1!-loop i)))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
         (let vector-map2+!-loop ((i len))
           (if (fx= i 0)
               vect
               (let ((i (fx- i 1)))
                 (vector-set! vect i (apply f (%vectors-ref vects i)))
                 (vector-map2+!-loop i)))))))))
 

(define-procedure (vector-map!
                   (f    procedure)
                   (vect vector)
                   . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-map1!-loop ((i len))
         (if (fx= i 0)
             vect
            (let ((i (fx- i 1)))
              (vector-set! vect i (f (vector-ref vect i)))
              (vector-map1!-loop i)))))
      (else
       (let* ((len (%smallest-length vects
                                     len
                                     3
                                    `(vector-map! ,f ,vect . ,vects)))
              (vects (cons vect vects)))
         (let vector-map2+!-loop ((i len))
           (if (fx= i 0)
               vect
               (let ((i (fx- i 1)))
                 (vector-set! vect i (apply f (%vectors-ref vects i)))
                 (vector-map2+!-loop i)))))))))
                         

;; vector-count
;;
(define-prim (vector-count pred? vect . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-count1-loop ((count 0)
                                (i     0))
         (if (fx= i len)
             count
             (let ((count (if (pred? (vector-ref vect i))
                              (fx+ count 1)
                              count)))
               (vector-count1-loop count
                                   (fx+ i 1))))))
      (else       
       (let* ((len (##smallest-vector-length vects
                                     (vector-length vect)))
              (vects (cons vect vects)))
         (let vector-count2+-loop ((count 0)
                                   (i     0))
           (if (fx= i len)
               count
               (let ((count (if (apply pred? (%vectors-ref vects i))
                                (fx+ count 1)
                                count)))
                 (vector-count2+-loop count (fx+ i 1))))))))))


(define-procedure (vector-count 
                   (pred? procedure)
                   (vect  vector)
                   . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
       (let vector-count1-loop ((count 0)
                                (i     0))
         (if (fx= i len)
             count
             (let ((count (if (pred? (vector-ref vect i))
                              (fx+ count 1)
                              count)))
               (vector-count1-loop count
                                   (fx+ i 1))))))
      (else       
       (let* ((len (%smallest-length vects
                                     (vector-length vect)
                                     3
                                    `(vector-count ,pred? ,vect . ,vects)))
              (vects (cons vect vects)))
         (let vector-count2+-loop ((count 0)
                                   (i     0))
           (if (fx= i len)
               count
               (let ((count (if (apply pred? (%vectors-ref vects i))
                                (fx+ count 1)
                                count)))
                 (vector-count2+-loop count (fx+ i 1))))))))))


;; vector-index
;;
(define-prim (##vector-index pred? vect . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-index1-loop ((i 0))
         (cond ((fx= i len) #f)
               ((pred? (vector-ref vect i)) i)
               (else (vector-index1-loop (fx+ i 1))))))
      (else 
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
          (let vector-index2+-loop ((i 0))
            (cond ((fx= i len) #f)
                  ((apply pred? (%vectors-ref vects i)) i)
                  (else (vector-index2+-loop (fx+ i 1))))))))))

(define-procedure (vector-index
                   (pred? procedure)
                   (vect  vector)
                   . vects )
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-index1-loop ((i 0))
         (cond ((fx= i len) #f)
               ((pred? (vector-ref vect i)) i)
               (else (vector-index1-loop (fx+ i 1))))))
      (else 
       (let* ((len (%smallest-length vects 
                                     len 
                                     3
                                    `(vector-index ,pred? ,vect ,@vects)))
             (vects (cons vect vects)))
          (let vector-index2+-loop ((i 0))
            (cond ((fx= i len) #f)
                  ((apply pred? (%vectors-ref vects i)) i)
                  (else (vector-index2+-loop (fx+ i 1))))))))))


;; vector-skip
;;
(define-prim (##vector-skip pred? vect . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-skip1-loop ((i 0))
         (cond ((fx= i len)
                #f)
               ((pred? (vector-ref vect i))
                (vector-skip1-loop (fx+ i 1)))
               (else
                i))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
         (let vector-skip2+-loop ((i 0))
           (cond ((fx= i len)
                  #f)
                 ((apply pred? (%vectors-ref vects i))
                  (vector-skip2+-loop (fx+ i 1)))
                 (else
                  i))))))))


(define-procedure (vector-skip
                   (pred? procedure)
                   (vect  vector)
                   . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-skip1-loop ((i 0))
         (cond ((fx= i len)
                #f)
               ((pred? (vector-ref vect i))
                (vector-skip1-loop (fx+ i 1)))
               (else
                i))))
      (else
       (let* ((len (%smallest-length vects 
                                     len 
                                     3
                                    `(vector-skip ,pred? ,vect . ,vects)))
             (vects (cons vect vects)))
         (let vector-skip2+-loop ((i 0))
           (cond ((fx= i len)
                  #f)
                 ((apply pred? (%vectors-ref vects i))
                  (vector-skip2+-loop (fx+ i 1)))
                 (else
                  i))))))))


;; vector-index-right
;;
(define-prim (##vector-index-right pred? vect . vects)
  (include "~~/lib/gambit/prim/prim#.scm")
  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
        (let vector-index-right1-loop ((i (fx- len 1)))
          (cond ((fx< i 0) #f)
                ((pred? (vector-ref vect i)) i)
                (else (vector-index-right1-loop (fx- i 1))))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
          (let vector-index-right2+-loop ((i (fx- len 1)))
            (cond ((fx< i 0) #f)
                  ((apply pred? (%vectors-ref vects i)) i)
                  (else (vector-index-right2+-loop (fx- i 1))))))))))


(define-procedure (vector-index-right
                   (pred? procedure)
                   (vect  vector)
                   . vects )

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
        (let vector-index-right1-loop ((i (fx- len 1)))
          (cond ((fx< i 0) #f)
                ((pred? (vector-ref vect i)) i)
                (else (vector-index-right1-loop (fx- i 1))))))
      (else
       (let* ((len (%smallest-length vects 
                                     len 
                                     3
                                    `(vector-index-right ,pred? ,vect . ,vects)))
              (vects (cons vect vects)))
          (let vector-index-right2+-loop ((i (fx- len 1)))
            (cond ((fx< i 0) #f)
                  ((apply pred? (%vectors-ref vects i)) i)
                  (else (vector-index-right2+-loop (fx- i 1))))))))))


;; vector-skip-right
;;
(define-prim (##vector-skip-right pred? vect . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-skip-right1-loop ((i (fx- len 1)))
         (cond ((fx< i 0)
                #f)
               ((pred? (vector-ref vect i))
                i)
               (else
                 (vector-skip-right1-loop (fx- i 1))))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (vects (cons vect vects)))
         (let vector-skip-right2+-loop ((i (fx- len 1)))
            (cond ((fx< i 0)
                   #f)
                  ((apply pred? (%vectors-ref vects i))
                   (vector-skip-right2+-loop (fx- i 1)))
                  (else
                   i))))))))


(define-procedure (vector-skip-right
                   (pred? procedure)
                   (vect  vector)
                   . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let vector-skip-right1-loop ((i (fx- len 1)))
         (cond ((fx< i 0)
                #f)
               ((pred? (vector-ref vect i))
                 (vector-skip-right1-loop (fx- i 1)))
               (else
                i))))
      (else
       (let* ((len (%smallest-length vects 
                                     len 
                                     3
                                    `(vector-skip-right ,pred?
                                                        ,vect 
                                                        . ,vects)))
             (vects (cons vect vects)))
         (let vector-skip-right2+-loop ((i (fx- len 1)))
            (cond ((fx< i 0)
                   #f)
                  ((apply pred? (%vectors-ref vects i))
                   (vector-skip-right2+-loop (fx- i 1)))
                  (else
                   i))))))))


;; vector-binary-search
;;
(define-prim (##vector-binary-search 
              vect 
              value 
              cmp 
              #!optional 
              (start 0) 
              (end (vector-length vect)))

  (include "~~/lib/gambit/prim/prim#.scm")

  (let vector-binary-search-loop ((start start) 
                                  (end end) 
                                  (j #f))
    (let ((i (quotient (+ start end) 2)))
      (if (or (fx= start end) 
              (and j 
                   (fx= i j)))
          #f
          (let ((comparison (cmp (vector-ref vect i) value)))
            (macro-check-fixnum
              comparison 0 (vector-binary-search vect value cmp start end)
            (cond ((fx=  comparison 0) 
                   i)
                  ((fx>= comparison 0) 
                   (vector-binary-search-loop start i i))
                  (else                   
                   (vector-binary-search-loop i end i)))))))))

(define-procedure (vector-binary-search 
                   (vect   vector) 
                   value 
                   (cmp   procedure)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end   (index-range-incl start (vector-length vect))
                          (vector-length vect)))
  (##vector-binary-search vect value cmp start end))


;; vector-any
;;
(define-prim (##vector-any pred? vect . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
        (let ((len-1 (fx- len 1)))
          (let vector-any1-loop ((i 0))
            (and (not (fx= i len))
                 (or (pred? (vector-ref vect i))
                     (if (= i len-1)
                         #f
                         (vector-any1-loop (fx+ i 1))))))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (len-1 (fx- len 1))
              (vects (cons vect vects)))
        (let vector-any2+-loop ((i 0))
          (and (not (fx= i len))
               (or (apply pred? (%vectors-ref vects i))
                   (if (= i len-1)
                       #f
                       (vector-any2+-loop (fx+ i 1)))))))))))

(define-procedure (vector-any 
                   (pred? procedure)
                   (vect  vector)
                   . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond 
      ((null? vects)
        (let ((len-1 (fx- len 1)))
          (let vector-any1-loop ((i 0))
            (and (not (fx= i len))
                 (or (pred? (vector-ref vect i))
                     (if (= i len-1)
                         #f
                         (vector-any1-loop (fx+ i 1))))))))
      (else
       (let* ((len (%smallest-length vects 
                                     len
                                     3 
                                    `(vector-any ,pred? ,vect . ,vects)))
              (len-1 (fx- len 1))
              (vects (cons vect vects)))
        (let vector-any2+-loop ((i 0))
          (and (not (fx= i len))
               (or (apply pred? (%vectors-ref vects i))
                   (if (= i len-1)
                       #f
                       (vector-any2+-loop (fx+ i 1)))))))))))


;; vector-every
;;

(define-prim (##vector-every pred? vect . vects)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let ((len-1 (fx- len 1)))
         (let vector-every1-loop ((i 0))
           (or (= i len)
               (and (pred? (vector-ref vect i))
                    (if (= i len-1)
                        #t
                        (vector-every1-loop (fx+ i 1))))))))
      (else
       (let* ((len (##smallest-vector-length vects len))
              (len-1 (fx- len 1))
              (vects (cons vect vects)))
         (let vector-every2+-loop ((i 0))
           (or (= i len)
               (and (apply pred? (%vectors-ref vects i))
                    (if (= i len-1)
                        #t
                        (vector-every2+-loop (fx- len 1)))))))))))

(define-procedure (vector-every 
                   (pred? procedure)
                   (vect  vector)
                   . vects)

  ;(include "~~/lib/gambit/prim/prim#.scm")

  (let ((len (vector-length vect)))
    (cond
      ((null? vects)
       (let ((len-1 (fx- len 1)))
         (let vector-every1-loop ((i 0))
           (or (= i len)
               (and (pred? (vector-ref vect i))
                    (if (= i len-1)
                        #t
                        (vector-every1-loop (fx+ i 1))))))))
      (else
       (let* ((len (%smallest-length vects 
                                     len 
                                     3 
                                    `(vector-every ,pred? ,vect . ,vects)))
              (len-1 (fx- len 1))
              (vects (cons vect vects)))
         (let vector-every2+-loop ((i 0))
           (or (= i len)
               (and (apply pred? (%vectors-ref vects i))
                    (if (= i len-1)
                        #t
                        (vector-every2+-loop (fx- len 1)))))))))))

;; vector-swap!
;;
(define-prim&proc (vector-swap! 
                   (vect vector)
                   (i    (index-range-incl 0 (vector-length vect)))
                   (j    (index-range-incl 0 (vector-length vect))))

  (include "~~/lib/gambit/prim/prim#.scm")
  (declare (not interrupts-enabled))
  (let ((temp (vector-ref vect i)))
    (vector-set! vect i (vector-ref vect j))
    (vector-set! vect j temp)))


;; vector-reverse!
;;

(define-prim (##vector-reverse! 
              vect 
              #!optional 
              (start 0) 
              (end (vector-length vect)))
  (include "~~/lib/gambit/prim/prim#.scm")

  (let vector-reverse!-loop ((vect vect)
             (i start)
             (j (fx- end 1)))
    (if (fx<= i j)
        (let ((v (vector-ref vect i)))
          (vector-set! vect i (vector-ref vect j))
          (vector-set! vect j v)
          (vector-reverse!-loop vect (fx+ i 1) (fx- j 1))))))

(define-procedure (vector-reverse! 
                   (vect  vector)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end   (index-range-incl start (vector-length vect))
                          (vector-length vect)))
  (##vector-reverse! vect start end))


;; vector-reverse-copy!
;;
(define-prim (vector-reverse-copy! 
              target 
              tstart 
              source 
              #!optional 
              (sstart 0)
              (send (vector-length source)))
  (include "~~/lib/gambit/prim/prim#.scm")

  (let vector-reverse-copy!-loop ((i (- send 1))
                                  (j tstart))
    (if (fx>= i sstart)
        (begin
          (vector-set! target j (vector-ref source i))
          (vector-reverse-copy!-loop target source sstart (fx- i 1) (fx+ j 1))))))

(define-procedure  (vector-reverse-copy!
                    (target vector)
                    (tstart (index-range-incl 0 (vector-length target)))
                    (source vector)
                    (sstart (index-range-incl 0 ##max-fixnum)
                            0)
                    (send   (index-range-incl sstart (vector-length source))
                            (vector-length source)))
  (##vector-reverse-copy! target tstart source sstart send))


;; reverse-vector->list
;;

(define-prim (##reverse-vector->list
              vect
              #!optional
              (start 0)
              (end (vector-length vect)))

  (include "~~/lib/gambit/prim/prim#.scm")
  (let reverse-vector->list-loop ((i   start)
                                  (res '()))
    (if (= i end)
        res
        (reverse-vector->list-loop (+ i 1) (cons (vector-ref vect i)
                                                 res)))))

(define-procedure (reverse-vector->list 
                   (vect  vector)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end   (index-range-incl start (vector-length vect))
                          (vector-length vect)))
  (##reverse-vector->list vect start end))


;; reverse-list->vector
;;
(define-prim (##reverse-list->vector lst)
  (let* ((len (length lst))
         (vect (make-vector len)))
    (let reverse-list->vector-loop ((lst lst)
                                    (i   (- len 1)))
      (if (fx>= i 0)
          (begin
            (vector-set! vect i (car lst))
            (reverse-list->vector-loop (cdr lst) (fx- i 1)))))
    vect))

(define (reverse-list->vector lst)
  (macro-force-vars (lst)
    (if (or (null? lst)
            (pair? lst))
        (##reverse-list->vector lst)
        (##raise-type-exception 1 'list 'reverse-list->vector '(,lst)))))

;; vector-cumulate
;;

(define-prim (##vector-cumulate f knil vect)
  
  (include "~~/lib/gambit/prim/prim#.scm")

  (let* ((len (vector-length vect))
         (result (make-vector len)))
    (let vector-cumulate-loop ((i 0) (left knil))
      (if (fx= i len)
        result
        (let* ((right (vector-ref vect i))
               (res (f left right)))
          (vector-set! result i res)
          (vector-cumulate-loop (fx+ i 1) res))))))

(define-procedure (vector-cumulate
                   (f procedure)
                   knil
                   (vect vector))
  (##vector-cumulate f knil vect))


;; vector-partition
;; 

(define-prim (##vector-partition pred? vect)

  (include "~~/lib/gambit/prim/prim#.scm")

  (let* ((len (vector-length vect))
         (cnt (vector-count pred? vect))
         (result (make-vector len)))
    (let vector-partition-loop ((i 0)
                                (yes 0)
                                (no cnt))
      (if (= i len)
        (values result cnt)
        (let ((elem (vector-ref vect i)))
          (if (pred? elem)
              (begin
                (vector-set! result yes elem)
                (vector-partition-loop (fx+ i 1)
                                       (fx+ yes 1)
                                       no))
              (begin
                (vector-set! result no elem)
                (vector-partition-loop (fx+ i 1)
                                       yes
                                       (fx+ no 1)))))))))

(define-procedure (vector-partition (pred? procedure) (vect vector))
  (##vector-partition pred? vect))

;; vector->string
;;

(define-prim (##vector->string 
              vect 
              #!optional 
              (start 0)
              (end (vector-length vect)))

  (let* ((len    (vector-length vect))
         (size   (fx- end start))
         (result (make-string size)))
    (let string->vector-loop ((at 0)
                              (i start))
      (if (fx= i end)
          result
          (begin
            (string-set! result at (vector-ref vect i))
            (string->vector-loop (fx+ at 1) (fx+ i 1)))))))

(define-procedure (vector->string 
                   (vect vector)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end   (index-range-incl start (vector-length vect))
                          (vector-length vect)))
  (##vector->string vect start end))

;; string->vector
;;

(define-prim (##string->vector
              str
              #!optional
              (start 0)
              (end (string-length str)))

  (include "~~/lib/gambit/prim/prim#.scm")

  (let* ((len (string-length str))
         (size (fx- end start))
         (result (make-vector size)))
    (let string->vector-loop ((at 0)
                              (i  start))
      (if (fx= i end)
          result
          (begin
            (vector-set! result at (string-ref str i))
            (string->vector-loop (fx+ at 1) (fx+ i 1)))))))

(define-procedure (string->vector 
                   (str string)
                   (start (index-range-incl 0 ##max-fixnum)
                          0)
                   (end (index-range-incl start (string-length str))
                        (string-length str)))
  (##string->vector str start end))


;; %smallest-length
;;
(define (%smallest-length vector-list len arg-id callee)
  (if (null? vector-list)
      len
      (let ((vect (car vector-list)))
        (if (vector? vect)
            (let ((vlen (vector-length vect)))
              (%smallest-length (cdr vector-list)
                                (if (##fx< vlen len)
                                    vlen
                                    len)
                                (##fx+ arg-id 1)
                                callee))
            (##raise-type-exception arg-id 'vector (car callee) (cdr callee))))))

(define-prim (##smallest-vector-length vector-list len)
  (include "~~/lib/gambit/prim/prim#.scm")
  (if (null? vector-list)
      len
      (let ((vlen (vector-length (car vector-list))))
        (##smallest-vector-length (cdr vector-list)
                              (if (< vlen len)
                                  vlen
                                  len)))))
  
;;;============================================================================
