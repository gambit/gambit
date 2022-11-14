;;;============================================================================

;;; File: "_utils.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(define (append-lists lst)

  (define (append1 lst)
    (if (pair? (cdr lst))
      (append2 (car lst) (append1 (cdr lst)))
      (car lst)))

  (define (append2 lst1 lst2)
    (if (pair? lst1)
      (let ((result (cons (car lst1) '())))
        (set-cdr!
          (let loop ((end result) (lst1 (cdr lst1)))
            (if (pair? lst1)
              (let ((tail (cons (car lst1) '())))
                (set-cdr! end tail)
                (loop tail (cdr lst1)))
              end))
          lst2)
        result)
      lst2))

  (if (pair? lst)
    (append1 lst)
    '()))

(begin;**************brad
;(##include "../gsc/_ptree1adt.scm")
;(##include "../gsc/_envadt.scm")

;;;----------------------------------------------------------------------------
;;
;; Utilities:
;; ---------

(define (reverse-append! xrev y)
  (if (null? xrev)
      y
      (let ((temp (cdr xrev)))
        (set-cdr! xrev y)
        (reverse-append! temp xrev))))

(define (list-length lst)
  (let loop ((n 0) (lst lst))
    (if (pair? lst)
        (loop (+ n 1) (cdr lst))
        n)))

(define (make-counter next)
  (lambda ()
    (let ((result next))
      (set! next (+ next 1))
      result)))

(define (for-each-index proc lst)
  (let loop ((lst lst) (i 0))
    (if (pair? lst)
      (begin
        (proc (car lst) i)
        (loop (cdr lst) (+ i 1))))))

(define (map-index proc lst)
  (let loop ((lst lst) (i 0) (rev-result '()))
    (if (pair? lst)
        (loop (cdr lst) (+ i 1) (cons (proc (car lst) i) rev-result))
        (reverse rev-result))))

(define (pos-in-list x l)
  (let loop ((l l) (i 0))
    (cond ((not (pair? l)) #f)
          ((eq? (car l) x) i)
          (else            (loop (cdr l) (+ i 1))))))

(define (object-pos-in-list x l)
  (let loop ((l l) (i 0))
    (cond ((not    (pair? l)) #f)
          ((equal? (car l) x) i)
          (else               (loop (cdr l) (+ i 1))))))

(define (string-pos-in-list x l)
  (let loop ((l l) (i 0))
    (cond ((not (pair? l))      #f)
          ((string=? (car l) x) i)
          (else                 (loop (cdr l) (+ i 1))))))

(define (pair-up l1 l2)
  (define (pair l1 l2)
    (if (pair? l1)
      (cons (cons (car l1) (car l2)) (pair (cdr l1) (cdr l2)))
      '()))
  (pair l1 l2))

(define (keep keep? lst)
  (let loop ((lst lst) (head '()))
    (cond ((null? lst)
           (reverse-append! head lst))
          ((keep? (car lst))
           (loop (cdr lst) (cons (car lst) head)))
          (else
           (loop (cdr lst) head)))))

(define (every? pred? lst)
  (or (null? lst)
      (and (pred? (car lst))
           (every? pred? (cdr lst)))))

(define (remq x lst)
  (let loop ((l lst) (head '()))
    (cond ((null? l) ; didn't find x, so just return lst
           lst)
          ((eq? (car l) x)
           (reverse-append! head (cdr l)))
          (else
           (loop (cdr l) (cons (car l) head))))))

(define (sort-list l <?)

  (define (mergesort l)

    (define (merge l1 l2)
      (cond ((null? l1) l2)
            ((null? l2) l1)
            (else
             (let ((e1 (car l1)) (e2 (car l2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr l1) l2))
                 (cons e2 (merge l1 (cdr l2))))))))

    (define (split l)
      (if (or (null? l) (null? (cdr l)))
        l
        (cons (car l) (split (cddr l)))))

    (if (or (null? l) (null? (cdr l)))
      l
      (let* ((l1 (mergesort (split l)))
             (l2 (mergesort (split (cdr l)))))
        (merge l1 l2))))

  (mergesort l))

(define (list->vect l)
  (let* ((n (list-length l))
         (v (make-vector n)))
    (let loop ((l l) (i 0))
      (if (pair? l)
        (begin
          (vector-set! v i (car l))
          (loop (cdr l) (+ i 1)))
        v))))

(define (vect->list v)
  (let loop ((l '()) (i (- (vector-length v) 1)))
    (if (< i 0)
      l
      (loop (cons (vector-ref v i) l) (- i 1)))))

(define (list->str l)
  (let* ((n (list-length l))
         (s (make-string n)))
    (let loop ((l l) (i 0))
      (if (pair? l)
        (begin
          (string-set! s i (car l))
          (loop (cdr l) (+ i 1)))
        s))))

(define (str->list s)
  (let loop ((l '()) (i (- (string-length s) 1)))
    (if (< i 0)
      l
      (loop (cons (string-ref s i) l) (- i 1)))))

(define (read-line* in)
  (let loop ((lst '()))
    (let ((c (read-char in)))
      (if (or (eof-object? c)
              (char=? c #\return)
              (char=? c #\newline))
          (list->str (reverse lst))
          (loop (cons c lst))))))

(define (string-substitute str delim proc-or-alist)

  (define (index-of c start)
    (let loop ((i start))
      (if (< i (string-length str))
          (if (char=? c (string-ref str i))
              i
              (loop (+ i 1)))
          i)))

  (let loop ((i 0) (j 0) (out '()))
    (let ((start (index-of delim j)))
      (if (< start (string-length str))
          (let ((end (index-of delim (+ start 1))))
            (if (< end (string-length str))
                (if (= start (- end 1)) ;; two delimiters in a row?
                    (loop (+ end 1)
                          (+ end 1)
                          (cons (substring str i end)
                                out))
                    (let* ((var
                            (substring str (+ start 1) end))
                           (subst
                            (if (procedure? proc-or-alist)
                                (proc-or-alist var)
                                (let ((x (assoc var proc-or-alist)))
                                  (and x (cdr x))))))
                      (if subst
                          (loop (+ end 1)
                                (+ end 1)
                                (cons subst
                                      (cons (substring str i start)
                                            out)))
                          (compiler-error "Unbound substitution variable in" str))))
                (compiler-error "Unbalanced delimiter in" str)))
          (reverse (cons (substring str i start) out))))))

;;;----------------------------------------------------------------------------

;; Strechable vectors
;; ------------------

(define (make-stretchable-vector init)
  (vector '#() init 0))

(define (stretchable-vector-length sv)
  (vector-ref sv 2))

(define (stretchable-vector-ref sv i)
  (let* ((v (vector-ref sv 0))
         (len (vector-length v)))
    (if (< i len)
      (vector-ref v i)
      (vector-ref sv 1))))

(define (stretchable-vector-set! sv i x)
  (let* ((v (vector-ref sv 0))
         (len (vector-length v)))
    (if (not (< i (vector-ref sv 2)))
        (vector-set! sv 2 (+ i 1)))
    (if (< i len)
      (vector-set! v i x)
      (let ((new-v
              (stretch-vector
                v
                (+ (max i (quotient (* len 3) 2)) 1) ; make 50% bigger at least
                (vector-ref sv 1))))
        (vector-set! sv 0 new-v)
        (vector-set! new-v i x)))))

(define (stretch-vector v n init)
  (let ((len (vector-length v))
        (new-v (make-vector n)))
    (let loop1 ((i 0))
      (if (< i len)
        (begin
          (vector-set! new-v i (vector-ref v i))
          (loop1 (+ i 1)))))
    (let loop2 ((i len))
      (if (< i n)
        (begin
          (vector-set! new-v i init)
          (loop2 (+ i 1)))))
    new-v))

(define (stretchable-vector-copy sv)
  (let* ((v1 (vector-ref sv 0))
         (n (vector-ref sv 2))
         (v2 (make-vector n)))
    (let loop ((i (- n 1)))
      (if (>= i 0)
        (begin
          (vector-set! v2 i (vector-ref v1 i))
          (loop (- i 1)))
        (vector v2 (vector-ref sv 1) n)))))

(define (stretchable-vector-for-each proc sv)
  (let ((v (vector-ref sv 0))
        (n (vector-ref sv 2)))
    (let loop ((i 0))
      (if (< i n)
        (begin
          (proc (vector-ref v i) i)
          (loop (+ i 1)))))))

(define (stretchable-vector->list sv)
  (let ((v (vector-ref sv 0))
        (n (vector-ref sv 2)))
    (let loop ((i (- n 1)) (lst '()))
      (if (< i 0)
          lst
          (loop (- i 1)
                (cons (vector-ref v i) lst))))))

;;;----------------------------------------------------------------------------

;; Ordered table
;; -------------

(define (make-ordered-table test)
  (vector (make-table 'test: test)
          (make-stretchable-vector #f)
          0))

(define (ordered-table-length ot)
  (vector-ref ot 2))

(define (ordered-table-index ot key)
  (table-ref (vector-ref ot 0) key #f))

(define (ordered-table-lookup ot key)
  (let ((i (table-ref (vector-ref ot 0) key #f)))
    (if i
      (cdr (stretchable-vector-ref (vector-ref ot 1) i))
      #f)))

(define (ordered-table-enter ot key proc)
  (let ((i (vector-ref ot 2)))
    (vector-set! ot 2 (+ i 1))
    (table-set! (vector-ref ot 0) key i)
    (let ((result (proc key i)))
      (stretchable-vector-set! (vector-ref ot 1) i (cons key result))
      result)))

(define (ordered-table->list ot)
  (let loop ((i (- (vector-ref ot 2) 1)) (lst '()))
    (if (< i 0)
      lst
      (loop (- i 1)
            (cons (stretchable-vector-ref (vector-ref ot 1) i) lst)))))

;;;----------------------------------------------------------------------------

;; Bitwise operations
;; ------------------

(define (bits-and x y) ; bitwise and of x and y, assumes x and y >= 0

  (define (band x y)
    (cond ((= x 0) 0)
          ((= y 0) 0)
          (else
           (let ((z (* (band (quotient x 2) (quotient y 2)) 2)))
             (if (and (odd? x) (odd? y))
               (+ z 1)
               z)))))

  (band x y))

(define (bits-or x y) ; bitwise or of x and y, assumes x and y >= 0

  (define (bor x y)
    (cond ((= x 0) y)
          ((= y 0) x)
          (else
           (let ((z (* (bor (quotient x 2) (quotient y 2)) 2)))
             (if (or (odd? x) (odd? y))
               (+ z 1)
               z)))))

  (bor x y))

(define (bits-shl x y) ; shift x left by y bits, assumes x>=0 and y>=0

  (define (shl x y)
    (if (> y 0)
      (shl (* x 2) (- y 1))
      x))

  (shl x y))

(define (bits-shr x y) ; shift x right by y bits, assumes x>=0 and y>=0

  (define (shr x y)
    (if (> y 0)
      (shr (quotient x 2) (- y 1))
      x))

  (shr x y))

;;;----------------------------------------------------------------------------
;;
;; Exception processing
;; --------------------

(define (with-exception-handling proc)
  (let ((old-exception-handler throw-to-exception-handler))
    (let ((val
            (call-with-current-continuation
              (lambda (cont)
                (set! throw-to-exception-handler cont)
                (proc)))))
    (set! throw-to-exception-handler old-exception-handler)
    val)))

(define (throw-to-exception-handler val)
  (fatal-err "Internal error, no exception handler at this point" val))

;;;----------------------------------------------------------------------------
;;
;; Compiler error processing
;; -------------------------

(define (compiler-error msg . args)
  (display "*** ERROR -- ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))

(define (compiler-user-error loc msg . args)
  (display "*** ERROR") (locat-show " IN " loc) (display " -- ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))

(define (compiler-user-warning loc msg . args)
  (if warnings-requested?
    (begin
      (display "*** WARNING") (locat-show " IN " loc) (display " -- ")
      (display msg)
      (for-each (lambda (x) (display " ") (write x)) args)
      (newline))))

(define (compiler-internal-error msg . args)
  (display "*** ERROR -- Compiler internal error detected") (newline)
  (display "*** in procedure ") (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))

(define (compiler-limitation-error msg . args)
  (display "*** ERROR -- Compiler limit reached") (newline)
  (display "*** ") (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))

(define (compiler-abort)
  (throw-to-exception-handler #f))

(define warnings-requested? #f)
(set! warnings-requested? #t)

;;;----------------------------------------------------------------------------
;;
;; Transitive closure and topological sorting.

(define (make-gnode var depvars) (vector var depvars)) ; graph node
(define (gnode-var x) (vector-ref x 0))
(define (gnode-depvars x) (vector-ref x 1))

(define (transitive-closure graph)
  (let* ((graph-vector
          (list->vect
           (sort-list graph
                      (lambda (x y) (varset-< (gnode-var x) (gnode-var y))))))
         (graph-size
          (vector-length graph-vector)))
    (let loop ((graph-vector graph-vector))
      (let ((changed? #f))

        (define (closure depvars)
          (varset-union-multi
           (cons depvars
                 (map (lambda (var) (gnode-find-depvars var graph-vector))
                      (varset->list depvars)))))

        (let ((new-graph-vector
               (let ((result (make-vector graph-size)))
                 (do ((i 0 (+ i 1)))
                     ((= i graph-size) result)
                   (let ((x (vector-ref graph-vector i)))
                     (let ((new-depvars (closure (gnode-depvars x))))
                       (if (not (= (varset-size new-depvars)
                                   (varset-size (gnode-depvars x))))
                         (set! changed? #t))
                       (vector-set!
                        result
                        i
                        (make-gnode (gnode-var x) new-depvars))))))))
          (if changed?
            (loop new-graph-vector)
            (vect->list new-graph-vector)))))))

(define (gnode-find-depvars var graph-vector)
  (let loop ((f 0) (l (- (vector-length graph-vector) 1)))
    (if (< l f)
      (varset-empty)
      (let* ((i (quotient (+ l f) 2))
             (node (vector-ref graph-vector i)))
        (cond ((eq? (gnode-var node) var)
               (gnode-depvars node))
              ((varset-< var (gnode-var node))
               (loop f (- i 1)))
              (else
               (loop (+ i 1) l)))))))

(define (gnodes-remove graph gnodes)
  (if (null? graph)
    '()
    (let ((node (car graph)))
      (if (memq node gnodes)
        (gnodes-remove (cdr graph) gnodes)
        (cons node (gnodes-remove (cdr graph) gnodes))))))

(define (topological-sort graph) ; topological sort fixed to handle cycles
  (if (null? graph)
    '()
    (let ((to-remove (or (remove-no-depvars graph) (remove-cycle graph))))
      (let ((vars (list->varset (map gnode-var to-remove))))
        (cons vars
              (topological-sort
                (map (lambda (x)
                       (make-gnode
                         (gnode-var x)
                         (varset-difference (gnode-depvars x) vars)))
                     (gnodes-remove graph to-remove))))))))

(define (remove-no-depvars graph)
  (let ((nodes-with-no-depvars
         (keep (lambda (x) (varset-empty? (gnode-depvars x))) graph)))
    (if (null? nodes-with-no-depvars)
      #f
      nodes-with-no-depvars)))

(define (remove-cycle graph)
  (define (remove l)
    (let* ((node (car l))
           (depvars (gnode-depvars node)))
      (define (equal-depvars? x) (varset-equal? (gnode-depvars x) depvars))
      (define (member-depvars? x) (varset-member? (gnode-var x) depvars))
      (if (member-depvars? node)
        (let ((depvar-graph (keep member-depvars? graph)))
          (if (every? equal-depvars? depvar-graph)
            depvar-graph
            (remove (cdr l))))
        (remove (cdr l)))))
  (remove graph))

;;;----------------------------------------------------------------------------
;;
;; SET manipulation stuff
;; ----------------------

;; Parse tree sets

(define (ptset-empty)              ; return the empty set
  (vector '() '() '() '() '() '() '() '() '() '() '()))

(define ptset-empty-set
  (ptset-empty))

(define (list->ptset lst)          ; convert list to set
  (let ((set (ptset-empty)))
    (let loop ((lst lst))
      (if (pair? lst)
          (begin
            (ptset-adjoin set (car lst))
            (loop (cdr lst)))
          set))))

(define (ptset->list set)          ; convert set to list
  (append-lists (vect->list set)))

(define (ptset-size set)           ; return cardinality of set
  (apply + (map list-length (vect->list set))))

(define (ptset-empty? set)         ; is 'x' the empty set?
  (equal? set ptset-empty-set))

(define (ptset-member? x set)      ; is 'x' a member of the 'set'?
  (let* ((hash-entry (modulo (node-stamp x) 11))
         (lst (vector-ref set hash-entry)))
    (memq x lst)))

(define (ptset-adjoin set x)       ; add the element 'x' to the 'set'
  (let* ((hash-entry (modulo (node-stamp x) 11))
         (lst (vector-ref set hash-entry)))
    (if (not (memq x lst))
      (vector-set! set hash-entry (cons x lst)))
    set))

(define (ptset-every? pred? set)   ; is 'pred?' true of every element

  (define (every? pred? lst)
    (or (null? lst)
        (and (pred? (car lst))
             (every? pred? (cdr lst)))))

  (every? (lambda (lst) (every? pred? lst)) (vect->list set)))

(define (ptset-remove set x)       ; remove the element 'x' from 'set'
  (let* ((hash-entry (modulo (node-stamp x) 11))
         (lst (vector-ref set hash-entry)))
    (cond ((null? lst) set)
          ((eq? x (car lst))
           (vector-set! set hash-entry (cdr lst))
           set)
          (else
           (let loop ((lst lst) (rest (cdr lst)))
             (cond ((null? rest)
                    set)
                   ((eq? (car rest) x)
                    (set-cdr! lst (cdr rest))
                    set)
                   (else
                    (loop rest (cdr rest)))))))))

;; Variable sets

(define (varset-reverse-append! xrev y)
  (if (null? xrev)
    (varset-wrap y)
    (let ((temp (cdr xrev)))
      (set-cdr! xrev y)
      (varset-reverse-append! temp xrev))))

(define (varset-wrap lst) ; when we know it is a sorted list
  (cons #f lst))

(define (varset-unwrap set)
  (cdr set))

(define (varset-empty)              ; return the empty set
  (varset-wrap '()))

(define (varset-singleton x)        ; create a set containing only 'x'
  (varset-wrap (list x)))

(define (list->varset lst)          ; convert list to set
  (if (null? lst)
    (varset-empty)
    (let loop ((last (car lst)) (next (cdr lst)))
      (cond ((null? next)
             (varset-wrap lst))             ; sorted
            ((varset-< last (car next))
             (loop (car next) (cdr next)))  ; OK so far
            (else
             (do ((lst lst (cdr lst))
                  (result '() (cons (varset-singleton (car lst)) result)))
                 ((null? lst) (varset-union-multi result))))))))   ; crude but effective sort

(define (varset->list set)          ; convert set to list
  (varset-unwrap set))

(define (varset-size set)           ; return cardinality of set
  (let ((v (car set)))
    (if v
      (vector-length v)
      (list-length (varset-unwrap set)))))

(define (varset-empty? set)         ; is 'x' the empty set?
  (null? (varset-unwrap set)))

(define (varset-< x y)
  (< (var-stamp x) (var-stamp y)))

(define (varset-member? x set)  ; is 'x' a member of the 'set'?
  (if (not (car set))
    (set-car! set (list->vect (cdr set))))
  (let ((v (car set)))
    (let loop ((f 0) (l (- (vector-length v) 1)))
      (and (<= f l)
           (let* ((index (quotient (+ f l) 2))
                  (y (vector-ref v index)))
             (or (eq? x y)
                 (if (varset-< x y)
                   (loop f (- index 1))
                   (loop (+ index 1) l))))))))

(define (varset-adjoin set x)       ; add the element 'x' to the 'set'
  (let loop ((s (varset-unwrap set)) (rev '()))
    (cond ((or (null? s)
               (varset-< x (car s)))
           (varset-reverse-append! rev (cons x s)))
          ((eq? (car s) x)
           set)
          (else
           (loop (cdr s) (cons (car s) rev))))))

(define (varset-remove set x)       ; remove the element 'x' from 'set'
  (let loop ((s (varset-unwrap set)) (rev '()))
    (cond ((or (null? s)
               (varset-< x (car s)))
           set)
          ((eq? (car s) x)
           (varset-reverse-append! rev (cdr s)))
          (else
           (loop (cdr s) (cons (car s) rev))))))

(define (varset-equal? s1 s2)       ; are 's1' and 's2' equal sets?
  (let loop ((s1 (varset-unwrap s1)) (s2 (varset-unwrap s2)))
    (cond ((null? s1)
           (null? s2))
          ((null? s2)
           #f)
          (else
           (and (eq? (car s1) (car s2))
                (loop (cdr s1) (cdr s2)))))))

(define (varset-difference s1 s2)
  (let loop ((s1 (varset-unwrap s1)) (s2 (varset-unwrap s2)) (revresult '()))
    (if (or (null? s1) (null? s2))
      (varset-reverse-append! revresult s1)
      (let ((x (car s1))
            (y (car s2)))
        (cond ((varset-< x y)
               (loop (cdr s1) s2 (cons x revresult)))
              ((eq? x y)
               (loop (cdr s1) (cdr s2) revresult))
              (else
               (loop s1 (cdr s2) revresult)))))))

(define (varset-union s1 s2)    ; return union of sets
  (let loop ((s1 (varset-unwrap s1)) (s2 (varset-unwrap s2)) (revresult '()))
    (cond ((null? s1)
           (varset-reverse-append! revresult s2))
          ((null? s2)
           (varset-reverse-append! revresult s1))
          (else
           (let ((x (car s1))
                 (y (car s2)))
             (cond ((eq? x y)
                    (loop (cdr s1) (cdr s2) (cons x revresult)))
                   ((varset-< x y)
                    (loop (cdr s1) s2 (cons x revresult)))
                   (else
                    (loop s1 (cdr s2) (cons y revresult)))))))))

(define (varset-intersection s1 s2) ; return intersection of sets
  (let loop ((s1 (varset-unwrap s1)) (s2 (varset-unwrap s2)) (revresult '()))
    (if (or (null? s1) (null? s2))
      (varset-reverse-append! revresult '())
      (let ((x (car s1))
            (y (car s2)))
        (cond ((eq? x y)
               (loop (cdr s1) (cdr s2) (cons x revresult)))
              ((varset-< x y)
               (loop (cdr s1) s2 revresult))
              (else
               (loop s1 (cdr s2) revresult)))))))

(define (varset-intersects? s1 s2) ; do sets 's1' and 's2' intersect?
  (let loop ((s1 (varset-unwrap s1)) (s2 (varset-unwrap s2)))
    (if (or (null? s1) (null? s2))
      #f
      (let ((x (car s1)) (y (car s2)))
        (cond ((eq? x y)
               #t)
              ((varset-< x y)
               (loop (cdr s1) s2))
              (else
               (loop s1 (cdr s2))))))))

(define (varset-union-multi sets)
  (cond ((null? sets)
         (varset-empty))
        ((null? (cdr sets))
         (car sets))
        (else
         (let loop ((sets sets) (newsets '()))
           (cond ((null? sets)
                  (varset-union-multi newsets))
                 ((null? (cdr sets))
                  (varset-union-multi (cons (car sets) newsets)))
                 (else
                  (loop (cddr sets) (cons (varset-union (car sets) (cadr sets)) newsets))))))))

(define (n-ary function first rest)
  (if (null? rest)
    first
    (n-ary function (function first (car rest)) (cdr rest))))

;;;----------------------------------------------------------------------------
;;
;; QUEUE manipulation stuff
;; ------------------------

(define (list->queue list)    ; convert list to queue
  (cons list (if (pair? list) (last-pair list) '())))

(define (queue->list queue)   ; convert queue to list
  (car queue))

(define (queue-empty)         ; the empty queue
  (cons '() '()))

(define (queue-empty? queue)  ; is the queue empty?
  (null? (car queue)))

(define (queue-get! queue)    ; remove the first element of the queue
  (if (null? (car queue))
    (compiler-internal-error "queue-get!, queue is empty")
    (let ((x (caar queue)))
      (set-car! queue (cdar queue))
      (if (null? (car queue)) (set-cdr! queue '()))
      x)))

(define (queue-put! queue x)  ; add an element to the end of the queue
  (let ((entry (cons x '())))
    (if (null? (car queue))
      (set-car! queue entry)
      (set-cdr! (cdr queue) entry))
    (set-cdr! queue entry)
    x))

;;;----------------------------------------------------------------------------

;; Base 92 encoding of 32 bit unsigned integer arrays.

(define (base92-encode uint32vect)

  ;; Arrays of non-negative 32 bit integer elements can be encoded
  ;; as a string using the following "base 92" encoding.
  ;;
  ;; The encoding is a sequence of packets of 1, 2, 3, or 6 bytes.
  ;; Each of these bytes holds a value from 0 to 91.  These bytes are
  ;; decoded from a string of characters.  Each character encodes one
  ;; byte using the characters that don't need escaping in a string
  ;; and excludes the space character and the ASCII control characters
  ;; ('#' for the value 0, '$' for the value 1, '%' for the value 3, etc).
  ;;
  ;; Because elements with a small value are typically more frequent
  ;; than larger values the encoding uses small packets for these
  ;; elements.  An element x in the range 0..63 is encoded with a
  ;; packet of length 1.  If x is in the range 64..255 it is encoded
  ;; with a packet of length 2.  If x is in the range 256..65535 it
  ;; is encoded with a packet of length 3.  If x >= 65536 it is encoded
  ;; with a packet of length 6.  The details are as follows:
  ;;
  ;;     a        b        c        d        e        f
  ;;
  ;; +--------+
  ;; | 0..63  |                   x = a
  ;; +--------+
  ;;
  ;; +--------+--------+
  ;; | 64..82 | 0..91  |          x = (a-64)*92 + b + 64
  ;; +--------+--------+
  ;;
  ;; +--------+--------+--------+
  ;; | 83..90 | 0..91  | 0..91  | x = ((a-83)*92 + b)*92 + c + 256
  ;; +--------+--------+--------+
  ;;
  ;; +--------+--------+--------+--------+--------+--------+
  ;; | 91     | 0..91  | 0..91  | 0..91  | 0..91  | 0..91  |
  ;; +--------+--------+--------+--------+--------+--------+
  ;;                              x = (((b*92 + c)*92 + d)*92 + e)*92 + f
  ;;                                  + 65536
  ;;
  ;; Note that a packet of 2 bytes yields a value for x that is in
  ;; the range 64..1811 .  When x >= 256 it encodes a repetition of
  ;; the last element added to the decoded array.  The last element
  ;; is repeated (x-255) times.  The highest repetition is thus 1556.
  ;;
  ;; Similarly a packet of 3 bytes yields a value for x that is in
  ;; the range 256..67967 .  When x >= 65536 it encodes a repetition of
  ;; the last 2 elements added to the decoded array.  The last 2 elements
  ;; are repeated (x-65535) times.  The highest repetition is thus 2432.
  ;;
  ;; A packet of 6 bytes yields a value of x that is in the range
  ;; 65536..6590880767 .  This range exceeds 2**32-1 .  The 2295913472
  ;; highest values are unused in the encoding.

  (define lo1   0) ;; 0..63 takes 1 byte
  (define hi1  63)
  (define lo2  64) ;; 64..82 takes 2 bytes
  (define hi2  82)
  (define lo3  83) ;; 83..90 takes 3 bytes
  (define hi3  90)
  (define lo6  91) ;; 91 takes 6 bytes
  (define base 92)

  (define max-repeat1 1556) ;; (- (* base (- lo3 lo2)) (- 256 lo2))
  (define max-repeat2 2432) ;; (- (* base base (- lo6 lo3)) (- 65536 256))

  (define (uint32vect->bytes uint32vect)
    (let loop1 ((i 0) (bytes '()))
      (if (< i (vector-length uint32vect))
          (let ((repeat1 ;; number of repetitions of previous element
                 (if (= i 0)
                     0
                     (let ((prev (vector-ref uint32vect (- i 1))))
                       (let loop2 ((j i))
                         (if (and (< j (vector-length uint32vect))
                                  (= (vector-ref uint32vect j) prev))
                             (loop2 (+ j 1))
                             (let ((r (- j i)))
                               (cond ((= r 0) 0)
                                     ((= r 1) (if (<= prev 255) 0 1))
                                     ((= r 2) (if (<= prev hi1) 0 2))
                                     (else    r)))))))))
            (if (> repeat1 0)
                (let repeat1-loop ((i i) (bytes bytes) (r repeat1))
                  (let* ((n (min r max-repeat1))
                         (new-r (- r n))
                         (new-i (+ i n))
                         (new-bytes (let* ((x (+ n (- 255 lo2)))
                                           (r1 (remainder x base))
                                           (q1 (quotient x base)))
                                      (cons r1
                                            (cons (+ q1 lo2)
                                                  bytes)))))
                    (if (> new-r 0)
                        (repeat1-loop new-i new-bytes new-r)
                        (loop1 new-i new-bytes))))
                (let ((repeat2 ;; number of repetitions of 2 previous elements
                       (if (<= i 1)
                           0
                           (let loop3 ((j i))
                             (if (and (< j (vector-length uint32vect))
                                      (= (vector-ref uint32vect j)
                                         (vector-ref uint32vect (- j 2))))
                                 (loop3 (+ j 1))
                                 (let ((r (quotient (- j i) 2)))
                                   (if (and (= r 1)
                                            (<= (vector-ref uint32vect i) hi1)
                                            (<= (vector-ref uint32vect (+ i 1)) hi1))
                                       0
                                       r)))))))
                  (if (> repeat2 0)
                      (let repeat2-loop ((i i) (bytes bytes) (r repeat2))
                        (let* ((n (min r max-repeat2))
                               (new-r (- r n))
                               (new-i (+ i (* 2 n)))
                               (new-bytes (let* ((x (+ n (- 65535 256)))
                                                 (r1 (remainder x base))
                                                 (q1 (quotient x base))
                                                 (r2 (remainder q1 base))
                                                 (q2 (quotient q1 base)))
                                            (cons r1
                                                  (cons r2
                                                        (cons (+ q2 lo3)
                                                              bytes))))))
                          (if (> new-r 0)
                              (repeat2-loop new-i new-bytes new-r)
                              (loop1 new-i new-bytes))))
                      (let ((elem (vector-ref uint32vect i)))
                        (cond ((<= elem hi1)
                               (loop1 (+ i 1)
                                      (cons (+ elem lo1)
                                            bytes)))
                              ((<= elem 255)
                               (let* ((x (- elem lo2))
                                      (r1 (remainder x base))
                                      (q1 (quotient x base)))
                                 (loop1 (+ i 1)
                                        (cons r1
                                              (cons (+ q1 lo2)
                                                    bytes)))))
                              ((<= elem 65535)
                               (let* ((x (- elem 256))
                                      (r1 (remainder x base))
                                      (q1 (quotient x base))
                                      (r2 (remainder q1 base))
                                      (q2 (quotient q1 base)))
                                 (loop1 (+ i 1)
                                        (cons r1
                                              (cons r2
                                                    (cons (+ q2 lo3)
                                                          bytes))))))
                              (else ;; (<= elem (- (expt 2 32) 1))
                               (let* ((x (- elem 65536))
                                      (r1 (remainder x base))
                                      (q1 (quotient x base))
                                      (r2 (remainder q1 base))
                                      (q2 (quotient q1 base))
                                      (r3 (remainder q2 base))
                                      (q3 (quotient q2 base))
                                      (r4 (remainder q3 base))
                                      (q4 (quotient q3 base)))
                                 (loop1 (+ i 1)
                                        (cons r1
                                              (cons r2
                                                    (cons r3
                                                          (cons r4
                                                                (cons q4
                                                                      (cons lo6
                                                                            bytes)))))))))))))))
          (reverse bytes))))

  (define (byte->char byte)
    (let ((c (integer->char (+ byte 35))))
      (if (char=? c #\\) #\! c)))

  (list->string (map byte->char (uint32vect->bytes uint32vect))))

;;;============================================================================
)
