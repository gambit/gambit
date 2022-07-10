;;;============================================================================

;;; File: "14#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 14, Character-set Library

(##supply-module srfi/14)

(##namespace ("srfi/14#"))                ;; in srfi/14#
;;(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/gambit#.scm")           ;; for define, declare, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "~~lib/_optional#.scm")        ;; for :optional and let-optionals*

(##include "14#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
;;(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

(define %latin1->char integer->char)
(define %char->latin1 char->integer)

(define (check-arg pred val proc)
  (if (pred val) val (error "Bad arg" val pred proc)))

;;;============================================================================

;; The rest of this file is the (untabified) file srfi-14.scm found at
;;
;; https://github.com/srfi-explorations/final-srfis/tree/master/010/srfi-14

;;;============================================================================

;;; SRFI-14 character-sets library                              -*- Scheme -*-
;;;
;;; - Ported from MIT Scheme runtime by Brian D. Carlstrom.
;;; - Massively rehacked & extended by Olin Shivers 6/98.
;;; - Massively redesigned and rehacked 5/2000 during SRFI process.
;;; At this point, the code bears the following relationship to the
;;; MIT Scheme code: "This is my grandfather's axe. My father replaced
;;; the head, and I have replaced the handle." Nonetheless, we preserve
;;; the MIT Scheme copyright:
;;;     Copyright (c) 1988-1995 Massachusetts Institute of Technology
;;; The MIT Scheme license is a "free software" license. See the end of
;;; this file for the tedious details. 

;;; Exports:
;;; char-set? char-set= char-set<=
;;; char-set-hash 
;;; char-set-cursor char-set-ref char-set-cursor-next end-of-char-set?
;;; char-set-fold char-set-unfold char-set-unfold!
;;; char-set-for-each char-set-map
;;; char-set-copy char-set
;;;
;;; list->char-set  string->char-set 
;;; list->char-set! string->char-set! 
;;;
;;; filterchar-set  ucs-range->char-set  ->char-set
;;; filterchar-set! ucs-range->char-set!
;;;
;;; char-set->list char-set->string
;;;
;;; char-set-size char-set-count char-set-contains?
;;; char-set-every char-set-any
;;;
;;; char-set-adjoin  char-set-delete 
;;; char-set-adjoin! char-set-delete!
;;; 

;;; char-set-complement  char-set-union  char-set-intersection  
;;; char-set-complement! char-set-union! char-set-intersection! 
;;;
;;; char-set-difference  char-set-xor  char-set-diff+intersection
;;; char-set-difference! char-set-xor! char-set-diff+intersection!
;;;
;;; char-set:lower-case         char-set:upper-case     char-set:title-case
;;; char-set:letter             char-set:digit          char-set:letter+digit
;;; char-set:graphic            char-set:printing       char-set:whitespace
;;; char-set:iso-control        char-set:punctuation    char-set:symbol
;;; char-set:hex-digit          char-set:blank          char-set:ascii
;;; char-set:empty              char-set:full

;;; Imports
;;; This code has the following non-R5RS dependencies:
;;; - ERROR
;;; - %LATIN1->CHAR %CHAR->LATIN1
;;; - LET-OPTIONALS* and :OPTIONAL macros for parsing, checking & defaulting
;;;   optional arguments from rest lists.
;;; - BITWISE-AND for CHAR-SET-HASH
;;; - The SRFI-19 DEFINE-RECORD-TYPE record macro
;;; - A simple CHECK-ARG procedure: 
;;;   (lambda (pred val caller) (if (not (pred val)) (error val caller)))

;;; This is simple code, not great code. Char sets are represented as 256-char
;;; strings. If char I is ASCII/Latin-1 0, then it isn't in the set; if char I
;;; is ASCII/Latin-1 1, then it is in the set.
;;; - Should be rewritten to use bit strings or byte vecs.
;;; - Is Latin-1 specific. Would certainly have to be rewritten for Unicode.

;;; See the end of the file for porting and performance-tuning notes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-record-type :char-set
  (make-char-set s)
  char-set?
  (s char-set:s))


(define (%string-copy s) (substring s 0 (string-length s)))

;;; Parse, type-check & default a final optional BASE-CS parameter from
;;; a rest argument. Return a *fresh copy* of the underlying string.
;;; The default is the empty set. The PROC argument is to help us
;;; generate informative error exceptions.

(define (%default-base maybe-base proc)
  (if (pair? maybe-base)
      (let ((bcs  (car maybe-base))
            (tail (cdr maybe-base)))
        (if (null? tail)
            (if (char-set? bcs) (%string-copy (char-set:s bcs))
                (error "BASE-CS parameter not a char-set" proc bcs))
            (error "Expected final base char set -- too many parameters"
                   proc maybe-base)))
      (make-string 256 (%latin1->char 0))))

;;; If CS is really a char-set, do CHAR-SET:S, otw report an error msg on
;;; behalf of our caller, PROC. This procedure exists basically to provide
;;; explicit error-checking & reporting.

(define (%char-set:s/check cs proc)
  (let lp ((cs cs))
    (if (char-set? cs) (char-set:s cs)
        (lp (error "Not a char-set" cs proc)))))



;;; These internal functions hide a lot of the dependency on the
;;; underlying string representation of char sets. They should be
;;; inlined if possible.

(define (si=0? s i) (zero? (%char->latin1 (string-ref s i))))
(define (si=1? s i) (not (si=0? s i)))
(define c0 (%latin1->char 0))
(define c1 (%latin1->char 1))
(define (si s i) (%char->latin1 (string-ref s i)))
(define (%set0! s i) (string-set! s i c0))
(define (%set1! s i) (string-set! s i c1))

;;; These do various "s[i] := s[i] op val" operations -- see 
;;; %CHAR-SET-ALGEBRA. They are used to implement the various
;;; set-algebra procedures.
(define (setv!   s i v) (string-set! s i (%latin1->char v))) ; SET to a Value.
(define (%not!   s i v) (setv! s i (- 1 v)))
(define (%and!   s i v) (if (zero? v) (%set0! s i)))
(define (%or!    s i v) (if (not (zero? v)) (%set1! s i)))
(define (%minus! s i v) (if (not (zero? v)) (%set0! s i)))
(define (%xor!   s i v) (if (not (zero? v)) (setv! s i (- 1 (si s i)))))


(define (char-set-copy cs)
  (make-char-set (%string-copy (%char-set:s/check cs char-set-copy))))

(define (char-set= . rest)
  (or (null? rest)
      (let* ((cs1  (car rest))
             (rest (cdr rest))
             (s1 (%char-set:s/check cs1 char-set=)))
        (let lp ((rest rest))
          (or (not (pair? rest))
              (and (string=? s1 (%char-set:s/check (car rest) char-set=))
                   (lp (cdr rest))))))))

(define (char-set<= . rest)
  (or (null? rest)
      (let ((cs1  (car rest))
            (rest (cdr rest)))
        (let lp ((s1 (%char-set:s/check cs1 char-set<=))  (rest rest))
          (or (not (pair? rest))
              (let ((s2 (%char-set:s/check (car rest) char-set<=))
                    (rest (cdr rest)))
                (if (eq? s1 s2) (lp s2 rest)    ; Fast path
                    (let lp2 ((i 255))          ; Real test
                      (if (< i 0) (lp s2 rest)
                          (and (<= (si s1 i) (si s2 i))
                               (lp2 (- i 1))))))))))))

;;; Hash
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Compute (c + 37 c + 37^2 c + ...) modulo BOUND, with sleaze thrown in
;;; to keep the intermediate values small. (We do the calculation with just
;;; enough bits to represent BOUND, masking off high bits at each step in
;;; calculation. If this screws up any important properties of the hash
;;; function I'd like to hear about it. -Olin)
;;;
;;; If you keep BOUND small enough, the intermediate calculations will 
;;; always be fixnums. How small is dependent on the underlying Scheme system; 
;;; we use a default BOUND of 2^22 = 4194304, which should hack it in
;;; Schemes that give you at least 29 signed bits for fixnums. The core 
;;; calculation that you don't want to overflow is, worst case,
;;;     (+ 65535 (* 37 (- bound 1)))
;;; where 65535 is the max character code. Choose the default BOUND to be the
;;; biggest power of two that won't cause this expression to fixnum overflow, 
;;; and everything will be copacetic.

(define (char-set-hash cs . maybe-bound)
  (let* ((bound (:optional maybe-bound 4194304 (lambda (n) (and (integer? n)
                                                                (exact? n)
                                                                (<= 0 n)))))
         (bound (if (zero? bound) 4194304 bound))       ; 0 means default.
         (s (%char-set:s/check cs char-set-hash))
         ;; Compute a 111...1 mask that will cover BOUND-1:
         (mask (let lp ((i #x10000)) ; Let's skip first 16 iterations, eh?
                 (if (>= i bound) (- i 1) (lp (+ i i))))))

      (let lp ((i 255) (ans 0))
        (if (< i 0) (modulo ans bound)
            (lp (- i 1)
                (if (si=0? s i) ans
                    (bitwise-and mask (+ (* 37 ans) i))))))))


(define (char-set-contains? cs char)
  (si=1? (%char-set:s/check cs char-set-contains?)
         (%char->latin1 (check-arg char? char char-set-contains?))))

(define (char-set-size cs)
  (let ((s (%char-set:s/check cs char-set-size)))
    (let lp ((i 255) (size 0))
      (if (< i 0) size
          (lp (- i 1) (+ size (si s i)))))))

(define (char-set-count pred cset)
  (check-arg procedure? pred char-set-count)
  (let ((s (%char-set:s/check cset char-set-count)))
    (let lp ((i 255) (count 0))
      (if (< i 0) count
          (lp (- i 1)
              (if (and (si=1? s i) (pred (%latin1->char i)))
                  (+ count 1)
                  count))))))


;;; -- Adjoin & delete

(define (%set-char-set set proc cs chars)
  (let ((s (%string-copy (%char-set:s/check cs proc))))
    (for-each (lambda (c) (set s (%char->latin1 c)))
              chars)
    (make-char-set s)))

(define (%set-char-set! set proc cs chars)
  (let ((s (%char-set:s/check cs proc)))
    (for-each (lambda (c) (set s (%char->latin1 c)))
              chars))
  cs)

(define (char-set-adjoin cs . chars)
  (%set-char-set  %set1! char-set-adjoin cs chars))
(define (char-set-adjoin! cs . chars)
  (%set-char-set! %set1! char-set-adjoin! cs chars))
(define (char-set-delete cs . chars)
  (%set-char-set  %set0! char-set-delete cs chars))
(define (char-set-delete! cs . chars)
  (%set-char-set! %set0! char-set-delete! cs chars))


;;; Cursors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Simple implementation. A cursors is an integer index into the
;;; mark vector, and -1 for the end-of-char-set cursor.
;;;
;;; If we represented char sets as a bit set, we could do the following
;;; trick to pick the lowest bit out of the set: 
;;;   (count-bits (xor (- cset 1) cset))
;;; (But first mask out the bits already scanned by the cursor first.)

(define (char-set-cursor cset)
  (%char-set-cursor-next cset 256 char-set-cursor))
  
(define (end-of-char-set? cursor) (< cursor 0))

(define (char-set-ref cset cursor) (%latin1->char cursor))

(define (char-set-cursor-next cset cursor)
  (check-arg (lambda (i) (and (integer? i) (exact? i) (<= 0 i 255))) cursor
             char-set-cursor-next)
  (%char-set-cursor-next cset cursor char-set-cursor-next))

(define (%char-set-cursor-next cset cursor proc)        ; Internal
  (let ((s (%char-set:s/check cset proc)))
    (let lp ((cur cursor))
      (let ((cur (- cur 1)))
        (if (or (< cur 0) (si=1? s cur)) cur
            (lp cur))))))


;;; -- for-each map fold unfold every any

(define (char-set-for-each proc cs)
  (check-arg procedure? proc char-set-for-each)
  (let ((s (%char-set:s/check cs char-set-for-each)))
    (let lp ((i 255))
      (cond ((>= i 0)
             (if (si=1? s i) (proc (%latin1->char i)))
             (lp (- i 1)))))))

(define (char-set-map proc cs)
  (check-arg procedure? proc char-set-map)
  (let ((s (%char-set:s/check cs char-set-map))
        (ans (make-string 256 c0)))
    (let lp ((i 255))
      (cond ((>= i 0)
             (if (si=1? s i)
                 (%set1! ans (%char->latin1 (proc (%latin1->char i)))))
             (lp (- i 1)))))
    (make-char-set ans)))

(define (char-set-fold kons knil cs)
  (check-arg procedure? kons char-set-fold)
  (let ((s (%char-set:s/check cs char-set-fold)))
    (let lp ((i 255) (ans knil))
      (if (< i 0) ans
          (lp (- i 1)
              (if (si=0? s i) ans
                  (kons (%latin1->char i) ans)))))))

(define (char-set-every pred cs)
  (check-arg procedure? pred char-set-every)
  (let ((s (%char-set:s/check cs char-set-every)))
    (let lp ((i 255))
      (or (< i 0)
          (and (or (si=0? s i) (pred (%latin1->char i)))
               (lp (- i 1)))))))

(define (char-set-any pred cs)
  (check-arg procedure? pred char-set-any)
  (let ((s (%char-set:s/check cs char-set-any)))
    (let lp ((i 255))
      (and (>= i 0)
           (or (and (si=1? s i) (pred (%latin1->char i)))
               (lp (- i 1)))))))


(define (%char-set-unfold! proc p f g s seed)
  (check-arg procedure? p proc)
  (check-arg procedure? f proc)
  (check-arg procedure? g proc)
  (let lp ((seed seed))
    (cond ((not (p seed))                       ; P says we are done.
           (%set1! s (%char->latin1 (f seed)))  ; Add (F SEED) to set.
           (lp (g seed))))))                    ; Loop on (G SEED).

(define (char-set-unfold p f g seed . maybe-base)
  (let ((bs (%default-base maybe-base char-set-unfold)))
    (%char-set-unfold! char-set-unfold p f g bs seed)
    (make-char-set bs)))

(define (char-set-unfold! p f g seed base-cset)
  (%char-set-unfold! char-set-unfold! p f g
                     (%char-set:s/check base-cset char-set-unfold!)
                     seed)
  base-cset)



;;; list <--> char-set

(define (%list->char-set! chars s)
  (for-each (lambda (char) (%set1! s (%char->latin1 char)))
            chars))

(define (char-set . chars)
  (let ((s (make-string 256 c0)))
    (%list->char-set! chars s)
    (make-char-set s)))

(define (list->char-set chars . maybe-base)
  (let ((bs (%default-base maybe-base list->char-set)))
    (%list->char-set! chars bs)
    (make-char-set bs)))

(define (list->char-set! chars base-cs)
  (%list->char-set! chars (%char-set:s/check base-cs list->char-set!))
  base-cs)


(define (char-set->list cs)
  (let ((s (%char-set:s/check cs char-set->list)))
    (let lp ((i 255) (ans '()))
      (if (< i 0) ans
          (lp (- i 1)
              (if (si=0? s i) ans
                  (cons (%latin1->char i) ans)))))))



;;; string <--> char-set

(define (%string->char-set! str bs proc)
  (check-arg string? str proc)
  (do ((i (- (string-length str) 1) (- i 1)))
      ((< i 0))
    (%set1! bs (%char->latin1 (string-ref str i)))))

(define (string->char-set str . maybe-base)
  (let ((bs (%default-base maybe-base string->char-set)))
    (%string->char-set! str bs string->char-set)
    (make-char-set bs)))

(define (string->char-set! str base-cs)
  (%string->char-set! str (%char-set:s/check base-cs string->char-set!)
                      string->char-set!)
  base-cs)


(define (char-set->string cs)
  (let* ((s (%char-set:s/check cs char-set->string))
         (ans (make-string (char-set-size cs))))
    (let lp ((i 255) (j 0))
      (if (< i 0) ans
          (let ((j (if (si=0? s i) j
                       (begin (string-set! ans j (%latin1->char i))
                              (+ j 1)))))
            (lp (- i 1) j))))))


;;; -- UCS-range -> char-set

(define (%ucs-range->char-set! lower upper error? bs proc)
  (check-arg (lambda (x) (and (integer? x) (exact? x) (<= 0 x))) lower proc)
  (check-arg (lambda (x) (and (integer? x) (exact? x) (<= lower x))) upper proc)

  (if (and (< lower upper) (< 256 upper) error?)
      (error "Requested UCS range contains unavailable characters -- this implementation only supports Latin-1"
             proc lower upper))

  (let lp ((i (- (min upper 256) 1)))
    (cond ((<= lower i) (%set1! bs i) (lp (- i 1))))))

(define (ucs-range->char-set lower upper . rest)
  (let-optionals* rest ((error? #f) rest)
    (let ((bs (%default-base rest ucs-range->char-set)))
      (%ucs-range->char-set! lower upper error? bs ucs-range->char-set)
      (make-char-set bs))))

(define (ucs-range->char-set! lower upper error? base-cs)
  (%ucs-range->char-set! lower upper error?
                         (%char-set:s/check base-cs ucs-range->char-set!)
                         ucs-range->char-set)
  base-cs)


;;; -- predicate -> char-set

(define (%char-set-filter! pred ds bs proc)
  (check-arg procedure? pred proc)
  (let lp ((i 255))
    (cond ((>= i 0)
           (if (and (si=1? ds i) (pred (%latin1->char i)))
               (%set1! bs i))
           (lp (- i 1))))))

(define (char-set-filter predicate domain . maybe-base)
  (let ((bs (%default-base maybe-base char-set-filter)))
    (%char-set-filter! predicate
                       (%char-set:s/check domain char-set-filter!)
                       bs
                       char-set-filter)
    (make-char-set bs)))

(define (char-set-filter! predicate domain base-cs)
  (%char-set-filter! predicate
                     (%char-set:s/check domain char-set-filter!)
                     (%char-set:s/check base-cs char-set-filter!)
                     char-set-filter!)
  base-cs)


;;; {string, char, char-set, char predicate} -> char-set

(define (->char-set x)
  (cond ((char-set? x) x)
        ((string? x) (string->char-set x))
        ((char? x) (char-set x))
        (else (error "->char-set: Not a charset, string or char." x))))



;;; Set algebra
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The exported ! procs are "linear update" -- allowed, but not required, to
;;; side-effect their first argument when computing their result. In other
;;; words, you must use them as if they were completely functional, just like
;;; their non-! counterparts, and you must additionally ensure that their
;;; first arguments are "dead" at the point of call. In return, we promise a
;;; more efficient result, plus allowing you to always assume char-sets are
;;; unchangeable values.

;;; Apply P to each index and its char code in S: (P I VAL).
;;; Used by the set-algebra ops.

(define (%string-iter p s)
  (let lp ((i (- (string-length s) 1)))
    (cond ((>= i 0)
           (p i (%char->latin1 (string-ref s i)))
           (lp (- i 1))))))

;;; String S represents some initial char-set. (OP s i val) does some
;;; kind of s[i] := s[i] op val update. Do
;;;     S := S OP CSETi
;;; for all the char-sets in the list CSETS. The n-ary set-algebra ops
;;; all use this internal proc.

(define (%char-set-algebra s csets op proc)
  (for-each (lambda (cset)
              (let ((s2 (%char-set:s/check cset proc)))
                (let lp ((i 255))
                  (cond ((>= i 0)
                         (op s i (si s2 i))
                         (lp (- i 1)))))))
            csets))


;;; -- Complement

(define (char-set-complement cs)
  (let ((s (%char-set:s/check cs char-set-complement))
        (ans (make-string 256)))
    (%string-iter (lambda (i v) (%not! ans i v)) s)
    (make-char-set ans)))

(define (char-set-complement! cset)
  (let ((s (%char-set:s/check cset char-set-complement!)))
    (%string-iter (lambda (i v) (%not! s i v)) s))
  cset)


;;; -- Union

(define (char-set-union! cset1 . csets)
  (%char-set-algebra (%char-set:s/check cset1 char-set-union!)
                     csets %or! char-set-union!)
  cset1)

(define (char-set-union . csets)
  (if (pair? csets)
      (let ((s (%string-copy (%char-set:s/check (car csets) char-set-union))))
        (%char-set-algebra s (cdr csets) %or! char-set-union)
        (make-char-set s))
      (char-set-copy char-set:empty)))


;;; -- Intersection

(define (char-set-intersection! cset1 . csets)
  (%char-set-algebra (%char-set:s/check cset1 char-set-intersection!)
                     csets %and! char-set-intersection!)
  cset1)

(define (char-set-intersection . csets)
  (if (pair? csets)
      (let ((s (%string-copy (%char-set:s/check (car csets) char-set-intersection))))
        (%char-set-algebra s (cdr csets) %and! char-set-intersection)
        (make-char-set s))
      (char-set-copy char-set:full)))


;;; -- Difference

(define (char-set-difference! cset1 . csets)
  (%char-set-algebra (%char-set:s/check cset1 char-set-difference!)
                     csets %minus! char-set-difference!)
  cset1)

(define (char-set-difference cs1 . csets)
  (if (pair? csets)
      (let ((s (%string-copy (%char-set:s/check cs1 char-set-difference))))
        (%char-set-algebra s csets %minus! char-set-difference)
        (make-char-set s))
      (char-set-copy cs1)))


;;; -- Xor

(define (char-set-xor! cset1 . csets)
  (%char-set-algebra (%char-set:s/check cset1 char-set-xor!)
                      csets %xor! char-set-xor!)
  cset1)

(define (char-set-xor . csets)
  (if (pair? csets)
      (let ((s (%string-copy (%char-set:s/check (car csets) char-set-xor))))
        (%char-set-algebra s (cdr csets) %xor! char-set-xor)
        (make-char-set s))
      (char-set-copy char-set:empty)))


;;; -- Difference & intersection

(define (%char-set-diff+intersection! diff int csets proc)
  (for-each (lambda (cs)
              (%string-iter (lambda (i v)
                              (if (not (zero? v))
                                  (cond ((si=1? diff i)
                                         (%set0! diff i)
                                         (%set1! int  i)))))
                            (%char-set:s/check cs proc)))
            csets))

(define (char-set-diff+intersection! cs1 cs2 . csets)
  (let ((s1 (%char-set:s/check cs1 char-set-diff+intersection!))
        (s2 (%char-set:s/check cs2 char-set-diff+intersection!)))
    (%string-iter (lambda (i v) (if (zero? v)
                                    (%set0! s2 i)
                                    (if (si=1? s2 i) (%set0! s1 i))))
                  s1)
    (%char-set-diff+intersection! s1 s2 csets char-set-diff+intersection!))
  (values cs1 cs2))

(define (char-set-diff+intersection cs1 . csets)
  (let ((diff (string-copy (%char-set:s/check cs1 char-set-diff+intersection)))
        (int  (make-string 256 c0)))
    (%char-set-diff+intersection! diff int csets char-set-diff+intersection)
    (values (make-char-set diff) (make-char-set int))))


;;;; System character sets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; These definitions are for Latin-1.
;;;
;;; If your Scheme implementation allows you to mark the underlying strings
;;; as immutable, you should do so -- it would be very, very bad if a client's
;;; buggy code corrupted these constants.

(define char-set:empty (char-set))
(define char-set:full (char-set-complement char-set:empty))

(define char-set:lower-case
  (let* ((a-z (ucs-range->char-set #x61 #x7B))
         (latin1 (ucs-range->char-set! #xdf #xf7  #t a-z))
         (latin2 (ucs-range->char-set! #xf8 #x100 #t latin1)))
    (char-set-adjoin! latin2 (%latin1->char #xb5))))

(define char-set:upper-case
  (let ((A-Z (ucs-range->char-set #x41 #x5B)))
    ;; Add in the Latin-1 upper-case chars.
    (ucs-range->char-set! #xd8 #xdf #t
                          (ucs-range->char-set! #xc0 #xd7 #t A-Z))))

(define char-set:title-case char-set:empty)

(define char-set:letter
  (let ((u/l (char-set-union char-set:upper-case char-set:lower-case)))
    (char-set-adjoin! u/l
                      (%latin1->char #xaa)      ; FEMININE ORDINAL INDICATOR
                      (%latin1->char #xba))))   ; MASCULINE ORDINAL INDICATOR

(define char-set:digit     (string->char-set "0123456789"))
(define char-set:hex-digit (string->char-set "0123456789abcdefABCDEF"))

(define char-set:letter+digit
  (char-set-union char-set:letter char-set:digit))

(define char-set:punctuation
  (let ((ascii (string->char-set "!\"#%&'()*,-./:;?@[\\]_{}"))
        (latin-1-chars (map %latin1->char '(#xA1 ; INVERTED EXCLAMATION MARK
                                            #xAB ; LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
                                            #xAD ; SOFT HYPHEN
                                            #xB7 ; MIDDLE DOT
                                            #xBB ; RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
                                            #xBF)))) ; INVERTED QUESTION MARK
    (list->char-set! latin-1-chars ascii)))

(define char-set:symbol
  (let ((ascii (string->char-set "$+<=>^`|~"))
        (latin-1-chars (map %latin1->char '(#x00A2 ; CENT SIGN
                                            #x00A3 ; POUND SIGN
                                            #x00A4 ; CURRENCY SIGN
                                            #x00A5 ; YEN SIGN
                                            #x00A6 ; BROKEN BAR
                                            #x00A7 ; SECTION SIGN
                                            #x00A8 ; DIAERESIS
                                            #x00A9 ; COPYRIGHT SIGN
                                            #x00AC ; NOT SIGN
                                            #x00AE ; REGISTERED SIGN
                                            #x00AF ; MACRON
                                            #x00B0 ; DEGREE SIGN
                                            #x00B1 ; PLUS-MINUS SIGN
                                            #x00B4 ; ACUTE ACCENT
                                            #x00B6 ; PILCROW SIGN
                                            #x00B8 ; CEDILLA
                                            #x00D7 ; MULTIPLICATION SIGN
                                            #x00F7)))) ; DIVISION SIGN
    (list->char-set! latin-1-chars ascii)))
  

(define char-set:graphic
  (char-set-union char-set:letter+digit char-set:punctuation char-set:symbol))

(define char-set:whitespace
  (list->char-set (map %latin1->char '(#x09 ; HORIZONTAL TABULATION
                                       #x0A ; LINE FEED         
                                       #x0B ; VERTICAL TABULATION
                                       #x0C ; FORM FEED
                                       #x0D ; CARRIAGE RETURN
                                       #x20 ; SPACE
                                       #xA0))))

(define char-set:printing (char-set-union char-set:whitespace char-set:graphic)) ; NO-BREAK SPACE

(define char-set:blank
  (list->char-set (map %latin1->char '(#x09 ; HORIZONTAL TABULATION
                                       #x20 ; SPACE
                                       #xA0)))) ; NO-BREAK SPACE


(define char-set:iso-control
  (ucs-range->char-set! #x7F #xA0 #t (ucs-range->char-set 0 32)))

(define char-set:ascii (ucs-range->char-set 0 128))


;;; Porting & performance-tuning notes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; See the section at the beginning of this file on external dependencies.
;;;
;;; First and foremost, rewrite this code to use bit vectors of some sort.
;;; This will give big speedup and memory savings.
;;;
;;; - LET-OPTIONALS* macro.
;;; This is only used once. You can rewrite the use, port the hairy macro
;;; definition (which is implemented using a Clinger-Rees low-level
;;; explicit-renaming macro system), or port the simple, high-level
;;; definition, which is less efficient.
;;;
;;; - :OPTIONAL macro
;;; Very simply defined using an R5RS high-level macro.
;;;
;;; Implementations that can arrange for the base char sets to be immutable
;;; should do so. (E.g., Scheme 48 allows one to mark a string as immutable,
;;; which can be used to protect the underlying strings.) It would be very,
;;; very bad if a client's buggy code corrupted these constants.
;;;
;;; There is a fair amount of argument checking. This is, strictly speaking,
;;; unnecessary -- the actual body of the procedures will blow up if an
;;; illegal value is passed in. However, the error message will not be as good
;;; as if the error were caught at the "higher level." Also, a very, very
;;; smart Scheme compiler may be able to exploit having the type checks done
;;; early, so that the actual body of the procedures can assume proper values.
;;; This isn't likely; this kind of compiler technology isn't common any
;;; longer.
;;; 
;;; The overhead of optional-argument parsing is irritating. The optional
;;; arguments must be consed into a rest list on entry, and then parsed out.
;;; Function call should be a matter of a few register moves and a jump; it
;;; should not involve heap allocation! Your Scheme system may have a superior
;;; non-R5RS optional-argument system that can eliminate this overhead. If so,
;;; then this is a prime candidate for optimising these procedures,
;;; *especially* the many optional BASE-CS parameters.
;;;
;;; Note that optional arguments are also a barrier to procedure integration.
;;; If your Scheme system permits you to specify alternate entry points
;;; for a call when the number of optional arguments is known in a manner
;;; that enables inlining/integration, this can provide performance 
;;; improvements.
;;;
;;; There is enough *explicit* error checking that *all* internal operations
;;; should *never* produce a type or index-range error. Period. Feel like
;;; living dangerously? *Big* performance win to be had by replacing string
;;; and record-field accessors and setters with unsafe equivalents in the
;;; code. Similarly, fixnum-specific operators can speed up the arithmetic
;;; done on the index values in the inner loops. The only arguments that are
;;; not completely error checked are
;;;   - string lists (complete checking requires time proportional to the
;;;     length of the list)
;;;   - procedure arguments, such as char->char maps & predicates.
;;;     There is no way to check the range & domain of procedures in Scheme.
;;; Procedures that take these parameters cannot fully check their
;;; arguments. But all other types to all other procedures are fully
;;; checked.
;;;
;;; This does open up the alternate possibility of simply *removing* these 
;;; checks, and letting the safe primitives raise the errors. On a dumb
;;; Scheme system, this would provide speed (by eliminating the redundant
;;; error checks) at the cost of error-message clarity.
;;;
;;; In an interpreted Scheme, some of these procedures, or the internal
;;; routines with % prefixes, are excellent candidates for being rewritten
;;; in C.
;;;
;;; It would also be nice to have the ability to mark some of these
;;; routines as candidates for inlining/integration.
;;; 
;;; See the comments preceding the hash function code for notes on tuning
;;; the default bound so that the code never overflows your implementation's
;;; fixnum size into bignum calculation.
;;;
;;; All the %-prefixed routines in this source code are written
;;; to be called internally to this library. They do *not* perform
;;; friendly error checks on the inputs; they assume everything is
;;; proper. They also do not take optional arguments. These two properties
;;; save calling overhead and enable procedure integration -- but they
;;; are not appropriate for exported routines.

;;; Copyright notice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Copyright (c) 1988-1995 Massachusetts Institute of Technology
;;; 
;;; This material was developed by the Scheme project at the Massachusetts
;;; Institute of Technology, Department of Electrical Engineering and
;;; Computer Science.  Permission to copy and modify this software, to
;;; redistribute either the original software or a modified version, and
;;; to use this software for any purpose is granted, subject to the
;;; following restrictions and understandings.
;;; 
;;; 1. Any copy made of this software must include this copyright notice
;;; in full.
;;; 
;;; 2. Users of this software agree to make their best efforts (a) to
;;; return to the MIT Scheme project any improvements or extensions that
;;; they make, so that these may be included in future releases; and (b)
;;; to inform MIT of noteworthy uses of this software.
;;; 
;;; 3. All materials developed as a consequence of the use of this
;;; software shall duly acknowledge such use, in accordance with the usual
;;; standards of acknowledging credit in academic research.
;;; 
;;; 4. MIT has made no warrantee or representation that the operation of
;;; this software will be error-free, and MIT is under no obligation to
;;; provide any services, by way of maintenance, update, or otherwise.
;;; 
;;; 5. In conjunction with products arising from the use of this material,
;;; there shall be no use of the name of the Massachusetts Institute of
;;; Technology nor of any adaptation thereof in any advertising,
;;; promotional, or sales literature without prior written consent from
;;; MIT in each case.
