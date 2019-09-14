;;; GAMBIT_OPTIMISED done

;;; This file extracts four merge procedures from lmsort.scm and vmsort.scm
;;; files written by Olin Shivers.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Start of code extracted from Olin's lmsort.scm file.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; list merge & list merge-sort	-*- Scheme -*-
;;; Copyright (c) 1998 by Olin Shivers.
;;; This code is open-source; see the end of the file for porting and
;;; more copyright information.
;;; Olin Shivers

;;; Exports:
;;; (%list-merge  < lis lis) -> list
;;; (%list-merge! < lis lis) -> list

;;; Merge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; These two merge procedures are stable -- ties favor list A.

(define (%list-merge < a b)
  (cond ((not (pair? a)) b)
	((not (pair? b)) a)
	(else (let recur ((x (car a)) (a a)	; A is a pair; X = (CAR A).
			  (y (car b)) (b b))	; B is a pair; Y = (CAR B).
		(if (< y x)

		    (let ((b (cdr b)))
		      (if (pair? b)
			  (cons y (recur x a (car b) b))
			  (cons y a)))

		    (let ((a (cdr a)))
		      (if (pair? a)
			  (cons x (recur (car a) a y b))
			  (cons x b))))))))


;;; This destructive merge does as few SET-CDR!s as it can -- for example, if
;;; the list is already sorted, it does no SET-CDR!s at all. It is also
;;; iterative, running in constant stack.

(define (%list-merge! < a b)
  ;; The logic of these two loops is completely driven by these invariants:
  ;;   SCAN-A: (CDR PREV) = A. X = (CAR A). Y = (CAR B).
  ;;   SCAN-B: (CDR PREV) = B. X = (CAR A). Y = (CAR B).
  (letrec ((scan-a (lambda (prev a x b y)		; Zip down A doing
		     (if (< y x)			; no SET-CDR!s until
			 (let ((next-b (cdr b)))	; we hit a B elt that
			   (set-cdr! prev b)		; has to be inserted.
			   (if (pair? next-b)
			       (scan-b b a x next-b (car next-b))
			       (set-cdr! b a)))

			 (let ((next-a (cdr a)))
			   (if (pair? next-a)
			       (scan-a a next-a (car next-a) b y)
			       (set-cdr! a b))))))

	   (scan-b (lambda (prev a x b y)		; Zip down B doing
		     (if (< y x)			; no SET-CDR!s until 
			 (let ((next-b (cdr b)))	; we hit an A elt that
			   (if (pair? next-b)			  ; has to be
			       (scan-b b a x next-b (car next-b)) ; inserted.
			       (set-cdr! b a))) 

			 (let ((next-a (cdr a)))
			   (set-cdr! prev a)
			   (if (pair? next-a)
			       (scan-a a next-a (car next-a) b y)
			       (set-cdr! a b)))))))

    (cond ((not (pair? a)) b)
	  ((not (pair? b)) a)

	  ;; B starts the answer list.
	  ((< (car b) (car a))
	   (let ((next-b (cdr b)))
	     (if (null? next-b)
		 (set-cdr! b a)
		 (scan-b b a (car a) next-b (car next-b))))
	   b)

	  ;; A starts the answer list.
	  (else (let ((next-a (cdr a)))
		  (if (null? next-a)
		      (set-cdr! a b)
		      (scan-a a next-a (car next-a) b (car b))))
		a))))


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
;;; This is very portable code. It's R4RS with the following exceptions:
;;; - The R5RS multiple-value VALUES & CALL-WITH-VALUES procedures for
;;;   handling multiple-value return.
;;;
;;; This code is *tightly* bummed as far as I can go in portable Scheme.
;;;
;;; - The fixnum arithmetic in LIST-MERGE-SORT! and COUNTED-LIST-MERGE!
;;;    that could be safely switched over to unsafe, fixnum-specific ops,
;;;    if you're sure that 2*maxlen is a fixnum, where maxlen is the length
;;;    of the longest list you could ever have.
;;;
;;; - I typically write my code in a style such that every CAR and CDR 
;;;   application is protected by an upstream PAIR?. This is the case in this
;;;   code, so all the CAR's and CDR's could safely switched over to unsafe
;;;   versions. But check over the code before you do it, in case the source
;;;   has been altered since I wrote this.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; End of code extracted from Olin's lmsort.scm file.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Start of code extracted from Olin's vmsort.scm file.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; The sort package -- stable vector merge & merge sort -*- Scheme -*-
;;; Copyright (c) 1998 by Olin Shivers.
;;; This code is open-source; see the end of the file for porting and
;;; more copyright information.
;;; Olin Shivers 10/98.

;;; Exports:
;;; (%vector-merge  < v1 v2 [start1 end1 start2 end2])          -> vector
;;; (%vector-merge! < v v1 v2 [start0 start1 end1 start2 end2]) -> unspecific
;;;
;;; (vector-merge-sort  < v [start end temp]) -> vector
;;; (vector-merge-sort! < v [start end temp]) -> unspecific


;;; Merge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (%vector-merge < v1 v2 [start1 end1 start2 end2]) -> vector
;;; (%vector-merge! < v v1 v2 [start start1 end1 start2 end2]) -> unspecific
;;;
;;; Stable vector merge -- V1's elements come out ahead of equal V2 elements.

(define (%vector-merge < v1 v2 #!optional (start1 0) 
                                         (end1 (vector-length v1)) 
                                         (start2 0)
                                         (end2 (vector-length v2)))
      (let ((ans (make-vector (+ (- end1 start1) (- end2 start2)))))
        (%vector-merge! < ans v1 v2 0 start1 end1 start2 end2)
        ans))



;;; This routine is not exported. The code is tightly bummed.
;;;
;;; If these preconditions hold, the routine can be bummed to run with 
;;; unsafe vector-indexing and fixnum arithmetic ops:
;;;   - V V1 V2 are vectors.
;;;   - START START1 END1 START2 END2 are fixnums.
;;;   - (<= 0 START END0 (vector-length V),
;;;     where end0 = start + (end1 - start1) + (end2 - start2)
;;;   - (<= 0 START1 END1 (vector-length V1))
;;;   - (<= 0 START2 END2 (vector-length V2))
;;; If you put these error checks in the two client procedures above, you can
;;; safely convert this procedure to use unsafe ops -- which is why it isn't
;;; exported. This will provide *huge* speedup.

(define (%vector-merge! elt< v v1 v2 #!optional (start 0)
                                                (start1 0)
                                                (end1 (vector-length v1))
                                                (start2 0)
                                                (end2 (vector-length v2)))
  (letrec ((vblit (lambda (fromv j i end) ; Blit FROMV[J,END) to V[I,?].
		    (let lp ((j j) (i i))
		      (vector-set! v i (vector-ref fromv j))
		      (let ((j (+ j 1)))
			(if (< j end) (lp j (+ i 1))))))))

    (cond ((<= end1 start1) (if (< start2 end2) (vblit v2 start2 start end2)))
          ((<= end2 start2) (vblit v1 start1 start end1))

	  ;; Invariants: I is next index of V to write; X = V1[J]; Y = V2[K].
	  (else (let lp ((i start)
			 (j start1)  (x (vector-ref v1 start1))
			 (k start2)  (y (vector-ref v2 start2)))
		  (let ((i1 (+ i 1)))	; "i+1" is a complex number in R4RS!
		    (if (elt< y x)
			(let ((k (+ k 1)))
			  (vector-set! v i y)
			  (if (< k end2)
			      (lp i1 j x k (vector-ref v2 k))
			      (vblit v1 j i1 end1)))
			(let ((j (+ j 1)))
			  (vector-set! v i x)
			  (if (< j end1)
			      (lp i1 j (vector-ref v1 j) k y)
			      (vblit v2 k i1 end2))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; End of code extracted from Olin's vmsort.scm file.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
