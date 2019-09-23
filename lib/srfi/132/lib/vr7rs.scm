;;;============================================================================

;;; File: "gambit/srfi/132/vr7rs.scm"

;;; 2018-2019 by Antoine Doucet.

;;;============================================================================

;;; Sort Libraries (srfi-132).


(define (r7rs-vector-copy vec #!optional (start 0) (end (vector-length vec)))
        (subvector vec start end))

(define (r7rs-vector-copy! vec2 start2 vec1 #!optional 
                                            (start 0) 
                                            (end (vector-length vec2)))
        (subvector-move! vec1 start end vec2 start2))

(define (r7rs-vector-fill! vec fill #!optional (start 0) (end (length vec)))
        (subvector-fill! vec start end fill))
;;;============================================================================
