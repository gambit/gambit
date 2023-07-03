;;; The SRFI-32 sort package -- three-way quick sort		-*- Scheme -*-
;;; Copyright (c) 2002 by Olin Shivers.
;;; This code is open-source; see the end of the file for porting and
;;; more copyright information.
;;; Olin Shivers 2002/7.

;;; (quick-sort3! c v [start end]) -> unspecific
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Sort vector V[start,end) using three-way comparison function C:
;;;   (c x y) < 0    =>    x<y
;;;   (c x y) = 0    =>    x=y
;;;   (c x y) > 0    =>    x>y
;;; That is, C acts as a sort of "subtraction" procedure; using - for the
;;; comparison function will cause numbers to be sorted into increasing order.
;;;
;;; This algorithm is more efficient than standard, two-way quicksort if there
;;; are many duplicate items in the data set and the comparison function is
;;; relatively expensive (e.g., comparing large strings). It is due to Jon
;;; Bentley & Doug McIlroy; I learned it from Bentley.
;;;
;;; The algorithm is a standard quicksort, but the partition loop is fancier,
;;; arranging the vector into a left part that is <, a middle region that is
;;; =, and a right part that is > the pivot. Here's how it is done:
;;;   The partition loop divides the range being partitioned into five 
;;;   subranges:
;;;       =======<<<<<<<<<?????????>>>>>>>=======
;;;   where = marks a value that is equal the pivot, < marks a value that
;;;   is less than the pivot, ? marks a value that hasn't been scanned, and
;;;   > marks a value that is greater than the pivot. Let's consider the 
;;;   left-to-right scan. If it checks a ? value that is <, it keeps scanning.
;;;   If the ? value is >, we stop the scan -- we are ready to start the
;;;   right-to-left scan and then do a swap. But if the rightward scan checks 
;;;   a ? value that is =, we swap it *down* to the end of the initial chunk
;;;   of ====='s -- we exchange it with the leftmost < value -- and then
;;;   continue our rightward scan. The leftwards scan works in a similar 
;;;   fashion, scanning past > elements, stopping on a < element, and swapping
;;;   up = elements. When we are done, we have a picture like this
;;;       ========<<<<<<<<<<<<>>>>>>>>>>=========
;;;   Then swap the = elements up into the middle of the vector to get
;;;   this:
;;;       <<<<<<<<<<<<=================>>>>>>>>>>
;;;   Then recurse on the <'s and >'s. Work out all the tricky little
;;;   boundary cases, and you're done.
;;;
;;; Other tricks that make this implementation industrial strength:
;;; - This quicksort makes some effort to pick the pivot well -- it uses the
;;;   median of three elements as the partition pivot, so pathological n^2
;;;   run time is much rarer (but not eliminated completely). If you really
;;;   wanted to get fancy, you could use a random number generator to choose
;;;   pivots. The key to this trick is that you only need to pick one random
;;;   number for each *level* of recursion -- i.e. you only need (lg n) random
;;;   numbers. 
;;;
;;; - After the partition, we *recurse* on the smaller of the two pending
;;;   regions, then *tail-recurse* (iterate) on the larger one. This guarantees
;;;   we use no more than lg(n) stack frames, worst case.
;;;
;;; - There are two ways to finish off the sort.
;;;   A. Recurse down to regions of size 10, then sort each such region using
;;;      insertion sort.
;;;   B. Recurse down to regions of size 10, then sort *the entire vector*
;;;      using insertion sort.
;;;   We do A. Each choice has a cost. Choice A has more overhead to invoke
;;;   all the separate insertion sorts -- choice B only calls insertion sort
;;;   once. But choice B will call the comparison function *more times* --
;;;   it will unnecessarily compare elt 9 of one segment to elt 0 of the
;;;   following segment. The overhead of choice A is linear in the length
;;;   of the vector, but *otherwise independent of the algorithm's parameters*.
;;;   I.e., it's a *fixed*, *small* constant factor. The cost of the extra 
;;;   comparisons made by choice B, however, is dependent on an externality: 
;;;   the comparison function passed in by the client. This can be made 
;;;   arbitrarily bad -- that is, the constant factor *isn't* fixed by the
;;;   sort algorithm; instead, it's determined by the comparison function.
;;;   If your comparison function is very, very slow, you want to eliminate
;;;   every single one that you can. Choice A limits the potential badness, 
;;;   so that is what we do.

(define (vector-quick-sort3! c v . maybe-start+end)
  (call-with-values
      (lambda () (vector-start+end v maybe-start+end))
    (lambda (start end)
      (%quick-sort3! c v start end))))

(define (vector-quick-sort3 c v . maybe-start+end)
  (call-with-values
      (lambda () (vector-start+end v maybe-start+end))
    (lambda (start end)
      (let ((ans (make-vector (- end start))))
	(vector-portion-copy! ans v start end)
	(%quick-sort3! c ans 0 (- end start))
	ans))))

;;; %QUICK-SORT3! is not exported.
;;; Preconditions:
;;;   V vector
;;;   START END fixnums
;;;   0 <= START, END <= (vector-length V)
;;; If these preconditions are ensured by the cover functions, you
;;; can safely change this code to use unsafe fixnum arithmetic and vector
;;; indexing ops, for *huge* speedup.
;;;
;;; We bail out to insertion sort for small ranges; feel free to tune the
;;; crossover -- it's just a random guess. If you don't have the insertion
;;; sort routine, just kill that branch of the IF and change the recursion
;;; test to (< 1 (- r l)) -- the code is set up to work that way.

(define (%quick-sort3! c v start end)
  (define (swap l r n)			; Little utility -- swap the N 
    (if (> n 0)
	(let ((x (vector-ref v l))	; outer pairs of the range [l,r).
	      (r-1 (- r 1)))
	  (vector-set! v l (vector-ref v r-1))
	  (vector-set! v r-1 x)
	  (swap (+ l 1) r-1 (- n 1)))))

  (define (sort3 v1 v2 v3)
    (call-with-values
	(lambda () (if (< (c v1 v2) 0) (values v1 v2) (values v2 v1)))
      (lambda (little big)
	(if (< (c big v3) 0)
	    (values little big v3)
	    (if (< (c little v3) 0)
		(values little v3 big)
		(values v3 little big))))))

  (define (elt< v1 v2)
    (negative? (c v1 v2)))

  (let recur ((l start) (r end))      ; Sort the range [l,r).
    (if (< 10 (- r l))		      ; 10: the gospel according to Sedgewick.

	;; Choose the median of V[l], V[r-1], and V[middle] for the pivot. 
	;; We do this by sorting these three elts; call the results LO, PIVOT
	;; & HI. Put LO, PIVOT & HI where they should go in the vector. We
	;; will kick off the partition step with one elt (PIVOT) in the left=
	;; range, one elt (LO) in the < range, one elt (HI) in in the > range
	;; & no elts in the right= range.
	(let* ((r-1 (- r 1))				; Three handy
	       (mid (quotient (+ l r) 2))		; common
	       (l+1 (+ l 1))				; subexpressions
	       (pivot (call-with-values 
			  (lambda ()
			    (sort3 (vector-ref v l)
				   (vector-ref v mid)
				   (vector-ref v r-1)))
			(lambda (lo piv hi)
			  (let ((tmp (vector-ref v l+1)))	; Put LO, PIV & HI 
			    (vector-set! v l   piv)		; back into V
			    (vector-set! v r-1 hi)		; where they belong,
			    (vector-set! v l+1 lo)
			    (vector-set! v mid tmp)
			    piv)))))		; and return PIV as pivot.
	  

	  ;; Everything in these loops is driven by the invariants expressed
	  ;; in the little pictures, the corresponding l,i,j,k,m,r indices,
	  ;; & the associated ranges.
	    
	  ;; =======<<<<<<<<<?????????>>>>>>>=======		(picture)
	  ;; l      i        j       k      m       r		(indices)
	  ;; [l,i)  [i,j)      [j,k]    (k,m]  (m,r)		(ranges )
	  (letrec ((lscan (lambda (i j k m) ; left-to-right scan
			    (let lp ((i i) (j j))
			      (if (> j k)
				  (done i j m)
				  (let* ((x (vector-ref v j))
					 (sign (c x pivot)))
				    (cond ((< sign 0) (lp i (+ j 1)))

					  ((= sign 0)
					   (if (< i j)
					       (begin (vector-set! v j (vector-ref v i))
						      (vector-set! v i x)))
					   (lp (+ i 1) (+ j 1)))
				    
					  ((> sign 0) (rscan i j k m))))))))

		   ;; =======<<<<<<<<<>????????>>>>>>>=======
		   ;; l      i        j       k      m       r
		   ;; [l,i)  [i,j)    j (j,k]    (k,m]  (m,r)
		   (rscan (lambda (i j k m) ; right-to-left scan
			    (let lp ((k k) (m m))	
			      (if (<= k j)
				  (done i j m)
				  (let* ((x (vector-ref v k))
					 (sign (c x pivot)))
				    (cond ((> sign 0) (lp (- k 1) m))

					   ((= sign 0)
					    (if (< k m)
						(begin (vector-set! v k (vector-ref v m))
						       (vector-set! v m x)))
					    (lp (- k 1) (- m 1)))

					   ((< sign 0) ; Swap j & k & lscan.
					    (vector-set! v k (vector-ref v j))
					    (vector-set! v j x)
					    (lscan i (+ j 1) (- k 1) m))))))))

		   ;; =======<<<<<<<<<<<<<>>>>>>>>>>>=======
		   ;; l      i            j         m       r
		   ;; [l,i)  [i,j)        [j,m]        (m,r)
		   (done (lambda (i j m)
			   (let ((num< (- j i))
				 (num> (+ 1 (- m j)))
				 (num=l (- i l))
				 (num=r (- (- r m) 1)))
			     (swap l j (min num< num=l))	; Swap ='s into
			     (swap j r (min num> num=r))	; the middle.
			     ;; Recur on the <'s and >'s. Recurring on the
			     ;; smaller range and iterating on the bigger 
			     ;; range ensures O(lg n) stack frames, worst case.
			     (cond ((<= num< num>)
				    (recur l          (+ l num<))
				    (recur (- r num>) r))
				   (else
				    (recur (- r num>) r)
				    (recur l          (+ l num<))))))))

	    ;; To repeat: We kick off the partition step with one elt (PIVOT)
	    ;; in the left= range, one elt (LO) in the < range, one elt (HI) 
	    ;; in the > range & no elts in the right= range.
	    (lscan l+1 (+ l 2) (- r 2) r-1)))

	;; Small segment => punt to insert sort.
	;; Use the dangerous subprimitive.
	(%vector-insert-sort! elt< v l r))))

;;; Copyright
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This code is
;;;     Copyright (c) 1998 by Olin Shivers.
;;; The terms are: You may do as you please with this code, as long as
;;; you do not delete this notice or hold me responsible for any outcome
;;; related to its use.
;;;
;;; Blah blah blah.


;;; Code tuning & porting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; - The quicksort recursion bottoms out in a call to an insertion sort
;;;   routine, %INSERT-SORT!. But you could even punt this and go with pure
;;;   recursion in a pinch.
;;;
;;; This code is *tightly* bummed as far as I can go in portable Scheme.
;;;
;;; The internal primitive %QUICK-SORT! that does the real work can be
;;; converted to use unsafe vector-indexing and fixnum-specific arithmetic ops
;;; *if* you alter the two small cover functions to enforce the invariants.
;;; This should provide *big* speedups. In fact, all the code bumming I've
;;; done pretty much disappears in the noise unless you have a good compiler
;;; and also can dump the vector-index checks and generic arithmetic -- so
;;; I've really just set things up for you to exploit.
;;;
;;; The optional-arg parsing, defaulting, and error checking is done with a
;;; portable R4RS macro. But if your Scheme has a faster mechanism (e.g., 
;;; Chez), you should definitely port over to it. Note that argument defaulting
;;; and error-checking are interleaved -- you don't have to error-check 
;;; defaulted START/END args to see if they are fixnums that are legal vector
;;; indices for the corresponding vector, etc.
