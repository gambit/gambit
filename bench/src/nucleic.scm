;;; NUCLEIC -- 3D structure determination of a nucleic acid.

; Author: Marc Feeley (feeley@iro.umontreal.ca)
;
; Last modified: January 27, 1996
;
; This program is a modified version of the program described in the paper:
;
;   M. Feeley, M. Turcotte, G. Lapalme, "Using Multilisp for Solving
;   Constraint Satisfaction Problems: an Application to Nucleic Acid 3D
;   Structure Determination" published in the journal "Lisp and Symbolic
;   Computation".
;
; The differences between this program and the original are described in
; the paper:
;
;   "???" published in the "Journal of Functional Programming".

; -- MATH UTILITIES -----------------------------------------------------------

(define constant-pi          3.14159265358979323846)
(define constant-minus-pi   -3.14159265358979323846)
(define constant-pi/2        1.57079632679489661923)
(define constant-minus-pi/2 -1.57079632679489661923)

(define (math-atan2 y x)
  (cond ((FLOAT> x 0.0)
         (FLOATatan (FLOAT/ y x)))
        ((FLOAT< y 0.0)
         (if (FLOAT= x 0.0)
           constant-minus-pi/2
           (FLOAT+ (FLOATatan (FLOAT/ y x)) constant-minus-pi)))
        (else
         (if (FLOAT= x 0.0)
           constant-pi/2
           (FLOAT+ (FLOATatan (FLOAT/ y x)) constant-pi)))))

; -- POINTS -------------------------------------------------------------------

(define (make-pt x y z)
  (FLOATvector x y z))

(define (pt-x pt) (FLOATvector-ref pt 0))
(define (pt-x-set! pt val) (FLOATvector-set! pt 0 val))
(define (pt-y pt) (FLOATvector-ref pt 1))
(define (pt-y-set! pt val) (FLOATvector-set! pt 1 val))
(define (pt-z pt) (FLOATvector-ref pt 2))
(define (pt-z-set! pt val) (FLOATvector-set! pt 2 val))

(define (pt-sub p1 p2)
  (make-pt (FLOAT- (pt-x p1) (pt-x p2))
           (FLOAT- (pt-y p1) (pt-y p2))
           (FLOAT- (pt-z p1) (pt-z p2))))

(define (pt-dist p1 p2)
  (let ((dx (FLOAT- (pt-x p1) (pt-x p2)))
        (dy (FLOAT- (pt-y p1) (pt-y p2)))
        (dz (FLOAT- (pt-z p1) (pt-z p2))))
    (FLOATsqrt (FLOAT+ (FLOAT* dx dx) (FLOAT* dy dy) (FLOAT* dz dz)))))

(define (pt-phi p)
  (let* ((x (pt-x p))
         (y (pt-y p))
         (z (pt-z p))
         (b (math-atan2 x z)))
    (math-atan2 (FLOAT+ (FLOAT* (FLOATcos b) z) (FLOAT* (FLOATsin b) x)) y)))

(define (pt-theta p)
  (math-atan2 (pt-x p) (pt-z p)))

; -- COORDINATE TRANSFORMATIONS -----------------------------------------------

; The notation for the transformations follows "Paul, R.P. (1981) Robot
; Manipulators.  MIT Press." with the exception that our transformation
; matrices don't have the perspective terms and are the transpose of
; Paul's one.  See also "M\"antyl\"a, M. (1985) An Introduction to
; Solid Modeling, Computer Science Press" Appendix A.
;
; The components of a transformation matrix are named like this:
;
;  a  b  c
;  d  e  f
;  g  h  i
; tx ty tz
;
; The components tx, ty, and tz are the translation vector.

(define (make-tfo a b c d e f g h i tx ty tz)
  (FLOATvector a b c d e f g h i tx ty tz))

(define (tfo-a tfo) (FLOATvector-ref tfo 0))
(define (tfo-a-set! tfo val) (FLOATvector-set! tfo 0 val))
(define (tfo-b tfo) (FLOATvector-ref tfo 1))
(define (tfo-b-set! tfo val) (FLOATvector-set! tfo 1 val))
(define (tfo-c tfo) (FLOATvector-ref tfo 2))
(define (tfo-c-set! tfo val) (FLOATvector-set! tfo 2 val))
(define (tfo-d tfo) (FLOATvector-ref tfo 3))
(define (tfo-d-set! tfo val) (FLOATvector-set! tfo 3 val))
(define (tfo-e tfo) (FLOATvector-ref tfo 4))
(define (tfo-e-set! tfo val) (FLOATvector-set! tfo 4 val))
(define (tfo-f tfo) (FLOATvector-ref tfo 5))
(define (tfo-f-set! tfo val) (FLOATvector-set! tfo 5 val))
(define (tfo-g tfo) (FLOATvector-ref tfo 6))
(define (tfo-g-set! tfo val) (FLOATvector-set! tfo 6 val))
(define (tfo-h tfo) (FLOATvector-ref tfo 7))
(define (tfo-h-set! tfo val) (FLOATvector-set! tfo 7 val))
(define (tfo-i tfo) (FLOATvector-ref tfo 8))
(define (tfo-i-set! tfo val) (FLOATvector-set! tfo 8 val))
(define (tfo-tx tfo) (FLOATvector-ref tfo 9))
(define (tfo-tx-set! tfo val) (FLOATvector-set! tfo 9 val))
(define (tfo-ty tfo) (FLOATvector-ref tfo 10))
(define (tfo-ty-set! tfo val) (FLOATvector-set! tfo 10 val))
(define (tfo-tz tfo) (FLOATvector-ref tfo 11))
(define (tfo-tz-set! tfo val) (FLOATvector-set! tfo 11 val))

(define tfo-id  ; the identity transformation matrix
  (FLOATvector-const
     1.0 0.0 0.0
     0.0 1.0 0.0
     0.0 0.0 1.0
     0.0 0.0 0.0))

; The function "tfo-apply" multiplies a transformation matrix, tfo, by a
; point vector, p.  The result is a new point.

(define (tfo-apply tfo p)
  (let ((x (pt-x p))
        (y (pt-y p))
        (z (pt-z p)))
    (make-pt
     (FLOAT+ (FLOAT* x (tfo-a tfo)) 
             (FLOAT* y (tfo-d tfo)) 
             (FLOAT* z (tfo-g tfo)) 
             (tfo-tx tfo))
     (FLOAT+ (FLOAT* x (tfo-b tfo)) 
             (FLOAT* y (tfo-e tfo))
             (FLOAT* z (tfo-h tfo))
             (tfo-ty tfo))
     (FLOAT+ (FLOAT* x (tfo-c tfo)) 
             (FLOAT* y (tfo-f tfo))
             (FLOAT* z (tfo-i tfo))
             (tfo-tz tfo)))))

; The function "tfo-combine" multiplies two transformation matrices A and B.
; The result is a new matrix which cumulates the transformations described
; by A and B.

(define (tfo-combine A B)
  (make-tfo
   (FLOAT+ (FLOAT* (tfo-a A) (tfo-a B))
           (FLOAT* (tfo-b A) (tfo-d B))
           (FLOAT* (tfo-c A) (tfo-g B)))
   (FLOAT+ (FLOAT* (tfo-a A) (tfo-b B))
           (FLOAT* (tfo-b A) (tfo-e B))
           (FLOAT* (tfo-c A) (tfo-h B)))
   (FLOAT+ (FLOAT* (tfo-a A) (tfo-c B))
           (FLOAT* (tfo-b A) (tfo-f B))
           (FLOAT* (tfo-c A) (tfo-i B)))
   (FLOAT+ (FLOAT* (tfo-d A) (tfo-a B))
           (FLOAT* (tfo-e A) (tfo-d B))
           (FLOAT* (tfo-f A) (tfo-g B)))
   (FLOAT+ (FLOAT* (tfo-d A) (tfo-b B))
           (FLOAT* (tfo-e A) (tfo-e B))
           (FLOAT* (tfo-f A) (tfo-h B)))
   (FLOAT+ (FLOAT* (tfo-d A) (tfo-c B))
           (FLOAT* (tfo-e A) (tfo-f B))
           (FLOAT* (tfo-f A) (tfo-i B)))
   (FLOAT+ (FLOAT* (tfo-g A) (tfo-a B))
           (FLOAT* (tfo-h A) (tfo-d B))
           (FLOAT* (tfo-i A) (tfo-g B)))
   (FLOAT+ (FLOAT* (tfo-g A) (tfo-b B))
           (FLOAT* (tfo-h A) (tfo-e B))
           (FLOAT* (tfo-i A) (tfo-h B)))
   (FLOAT+ (FLOAT* (tfo-g A) (tfo-c B))
           (FLOAT* (tfo-h A) (tfo-f B))
           (FLOAT* (tfo-i A) (tfo-i B)))
   (FLOAT+ (FLOAT* (tfo-tx A) (tfo-a B))
           (FLOAT* (tfo-ty A) (tfo-d B))
           (FLOAT* (tfo-tz A) (tfo-g B))
           (tfo-tx B))
   (FLOAT+ (FLOAT* (tfo-tx A) (tfo-b B))
           (FLOAT* (tfo-ty A) (tfo-e B))
           (FLOAT* (tfo-tz A) (tfo-h B))
           (tfo-ty B))
   (FLOAT+ (FLOAT* (tfo-tx A) (tfo-c B))
           (FLOAT* (tfo-ty A) (tfo-f B))
           (FLOAT* (tfo-tz A) (tfo-i B))
           (tfo-tz B))))

; The function "tfo-inv-ortho" computes the inverse of a homogeneous
; transformation matrix.

(define (tfo-inv-ortho tfo)
  (let* ((tx (tfo-tx tfo))
         (ty (tfo-ty tfo))
         (tz (tfo-tz tfo)))
    (make-tfo
     (tfo-a tfo) (tfo-d tfo) (tfo-g tfo)
     (tfo-b tfo) (tfo-e tfo) (tfo-h tfo)
     (tfo-c tfo) (tfo-f tfo) (tfo-i tfo)
     (FLOAT- (FLOAT+ (FLOAT* (tfo-a tfo) tx)
                     (FLOAT* (tfo-b tfo) ty)
                     (FLOAT* (tfo-c tfo) tz)))
     (FLOAT- (FLOAT+ (FLOAT* (tfo-d tfo) tx)
                     (FLOAT* (tfo-e tfo) ty)
                     (FLOAT* (tfo-f tfo) tz)))
     (FLOAT- (FLOAT+ (FLOAT* (tfo-g tfo) tx)
                     (FLOAT* (tfo-h tfo) ty)
                     (FLOAT* (tfo-i tfo) tz))))))

; Given three points p1, p2, and p3, the function "tfo-align" computes
; a transformation matrix such that point p1 gets mapped to (0,0,0), p2 gets
; mapped to the Y axis and p3 gets mapped to the YZ plane.

(define (tfo-align p1 p2 p3)
  (let* ((x1 (pt-x p1))       (y1 (pt-y p1))       (z1 (pt-z p1))
         (x3 (pt-x p3))       (y3 (pt-y p3))       (z3 (pt-z p3))
         (x31 (FLOAT- x3 x1)) (y31 (FLOAT- y3 y1)) (z31 (FLOAT- z3 z1))
         (rotpY (pt-sub p2 p1))
         (Phi (pt-phi rotpY))
         (Theta (pt-theta rotpY))
         (sinP (FLOATsin Phi))
         (sinT (FLOATsin Theta))
         (cosP (FLOATcos Phi))
         (cosT (FLOATcos Theta))
         (sinPsinT (FLOAT* sinP sinT))
         (sinPcosT (FLOAT* sinP cosT))
         (cosPsinT (FLOAT* cosP sinT))
         (cosPcosT (FLOAT* cosP cosT))
         (rotpZ 
          (make-pt 
           (FLOAT- (FLOAT* cosT x31)
                   (FLOAT* sinT z31))
           (FLOAT+ (FLOAT* sinPsinT x31)
                   (FLOAT* cosP y31)
                   (FLOAT* sinPcosT z31))
           (FLOAT+ (FLOAT* cosPsinT x31)
                   (FLOAT- (FLOAT* sinP y31))
                   (FLOAT* cosPcosT z31))))
         (Rho (pt-theta rotpZ))
         (cosR (FLOATcos Rho))
         (sinR (FLOATsin Rho))
         (x (FLOAT+ (FLOAT- (FLOAT* x1 cosT))
                    (FLOAT* z1 sinT)))
         (y (FLOAT- (FLOAT- (FLOAT- (FLOAT* x1 sinPsinT))
                            (FLOAT* y1 cosP))
                    (FLOAT* z1 sinPcosT)))
         (z (FLOAT- (FLOAT+ (FLOAT- (FLOAT* x1 cosPsinT))
                            (FLOAT* y1 sinP))
                    (FLOAT* z1 cosPcosT))))
    (make-tfo
     (FLOAT- (FLOAT* cosT cosR) (FLOAT* cosPsinT sinR))
     sinPsinT
     (FLOAT+ (FLOAT* cosT sinR) (FLOAT* cosPsinT cosR))
     (FLOAT* sinP sinR)
     cosP
     (FLOAT- (FLOAT* sinP cosR))
     (FLOAT- (FLOAT- (FLOAT* sinT cosR)) (FLOAT* cosPcosT sinR))
     sinPcosT
     (FLOAT+ (FLOAT- (FLOAT* sinT sinR)) (FLOAT* cosPcosT cosR))
     (FLOAT- (FLOAT* x cosR) (FLOAT* z sinR))
     y
     (FLOAT+ (FLOAT* x sinR) (FLOAT* z cosR)))))

; -- NUCLEIC ACID CONFORMATIONS DATA BASE -------------------------------------

; Numbering of atoms follows the paper:
;
; IUPAC-IUB Joint Commission on Biochemical Nomenclature (JCBN)
; (1983) Abbreviations and Symbols for the Description of
; Conformations of Polynucleotide Chains.  Eur. J. Biochem 131,
; 9-15.
;
; In the atom names, we have used "*" instead of "'".

; Define part common to all 4 nucleotide types.

(define (nuc-dgf-base-tfo nuc) (vector-ref nuc 0))
(define (nuc-dgf-base-tfo-set! nuc val) (vector-set! nuc 0 val))
(define (nuc-P-O3*-275-tfo nuc) (vector-ref nuc 1))
(define (nuc-P-O3*-275-tfo-set! nuc val) (vector-set! nuc 1 val))
(define (nuc-P-O3*-180-tfo nuc) (vector-ref nuc 2))
(define (nuc-P-O3*-180-tfo-set! nuc val) (vector-set! nuc 2 val))
(define (nuc-P-O3*-60-tfo nuc) (vector-ref nuc 3))
(define (nuc-P-O3*-60-tfo-set! nuc val) (vector-set! nuc 3 val))
(define (nuc-P nuc) (vector-ref nuc 4))
(define (nuc-P-set! nuc val) (vector-set! nuc 4 val))
(define (nuc-O1P nuc) (vector-ref nuc 5))
(define (nuc-O1P-set! nuc val) (vector-set! nuc 5 val))
(define (nuc-O2P nuc) (vector-ref nuc 6))
(define (nuc-O2P-set! nuc val) (vector-set! nuc 6 val))
(define (nuc-O5* nuc) (vector-ref nuc 7))
(define (nuc-O5*-set! nuc val) (vector-set! nuc 7 val))
(define (nuc-C5* nuc) (vector-ref nuc 8))
(define (nuc-C5*-set! nuc val) (vector-set! nuc 8 val))
(define (nuc-H5* nuc) (vector-ref nuc 9))
(define (nuc-H5*-set! nuc val) (vector-set! nuc 9 val))
(define (nuc-H5** nuc) (vector-ref nuc 10))
(define (nuc-H5**-set! nuc val) (vector-set! nuc 10 val))
(define (nuc-C4* nuc) (vector-ref nuc 11))
(define (nuc-C4*-set! nuc val) (vector-set! nuc 11 val))
(define (nuc-H4* nuc) (vector-ref nuc 12))
(define (nuc-H4*-set! nuc val) (vector-set! nuc 12 val))
(define (nuc-O4* nuc) (vector-ref nuc 13))
(define (nuc-O4*-set! nuc val) (vector-set! nuc 13 val))
(define (nuc-C1* nuc) (vector-ref nuc 14))
(define (nuc-C1*-set! nuc val) (vector-set! nuc 14 val))
(define (nuc-H1* nuc) (vector-ref nuc 15))
(define (nuc-H1*-set! nuc val) (vector-set! nuc 15 val))
(define (nuc-C2* nuc) (vector-ref nuc 16))
(define (nuc-C2*-set! nuc val) (vector-set! nuc 16 val))
(define (nuc-H2** nuc) (vector-ref nuc 17))
(define (nuc-H2**-set! nuc val) (vector-set! nuc 17 val))
(define (nuc-O2* nuc) (vector-ref nuc 18))
(define (nuc-O2*-set! nuc val) (vector-set! nuc 18 val))
(define (nuc-H2* nuc) (vector-ref nuc 19))
(define (nuc-H2*-set! nuc val) (vector-set! nuc 19 val))
(define (nuc-C3* nuc) (vector-ref nuc 20))
(define (nuc-C3*-set! nuc val) (vector-set! nuc 20 val))
(define (nuc-H3* nuc) (vector-ref nuc 21))
(define (nuc-H3*-set! nuc val) (vector-set! nuc 21 val))
(define (nuc-O3* nuc) (vector-ref nuc 22))
(define (nuc-O3*-set! nuc val) (vector-set! nuc 22 val))
(define (nuc-N1 nuc) (vector-ref nuc 23))
(define (nuc-N1-set! nuc val) (vector-set! nuc 23 val))
(define (nuc-N3 nuc) (vector-ref nuc 24))
(define (nuc-N3-set! nuc val) (vector-set! nuc 24 val))
(define (nuc-C2 nuc) (vector-ref nuc 25))
(define (nuc-C2-set! nuc val) (vector-set! nuc 25 val))
(define (nuc-C4 nuc) (vector-ref nuc 26))
(define (nuc-C4-set! nuc val) (vector-set! nuc 26 val))
(define (nuc-C5 nuc) (vector-ref nuc 27))
(define (nuc-C5-set! nuc val) (vector-set! nuc 27 val))
(define (nuc-C6 nuc) (vector-ref nuc 28))
(define (nuc-C6-set! nuc val) (vector-set! nuc 28 val))

; Define remaining atoms for each nucleotide type.

(define (make-rA dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
                 P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
                 H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
                 N6 N7 N9 C8 H2 H61 H62 H8)
  (vector dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
          P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
          H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
          'rA N6 N7 N9 C8 H2 H61 H62 H8))

(define (rA? nuc) (eq? (vector-ref nuc 29) 'rA))

(define (rA-N6 nuc) (vector-ref nuc 30))
(define (rA-N6-set! nuc val) (vector-set! nuc 30 val))
(define (rA-N7 nuc) (vector-ref nuc 31))
(define (rA-N7-set! nuc val) (vector-set! nuc 31 val))
(define (rA-N9 nuc) (vector-ref nuc 32))
(define (rA-N9-set! nuc val) (vector-set! nuc 32 val))
(define (rA-C8 nuc) (vector-ref nuc 33))
(define (rA-C8-set! nuc val) (vector-set! nuc 33 val))
(define (rA-H2 nuc) (vector-ref nuc 34))
(define (rA-H2-set! nuc val) (vector-set! nuc 34 val))
(define (rA-H61 nuc) (vector-ref nuc 35))
(define (rA-H61-set! nuc val) (vector-set! nuc 35 val))
(define (rA-H62 nuc) (vector-ref nuc 36))
(define (rA-H62-set! nuc val) (vector-set! nuc 36 val))
(define (rA-H8 nuc) (vector-ref nuc 37))
(define (rA-H8-set! nuc val) (vector-set! nuc 37 val))

(define (make-rC dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
                 P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
                 H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
                 N4 O2 H41 H42 H5 H6)
  (vector dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
          P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
          H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
          'rC N4 O2 H41 H42 H5 H6))

(define (rC? nuc) (eq? (vector-ref nuc 29) 'rC))

(define (rC-N4 nuc) (vector-ref nuc 30))
(define (rC-N4-set! nuc val) (vector-set! nuc 30 val))
(define (rC-O2 nuc) (vector-ref nuc 31))
(define (rC-O2-set! nuc val) (vector-set! nuc 31 val))
(define (rC-H41 nuc) (vector-ref nuc 32))
(define (rC-H41-set! nuc val) (vector-set! nuc 32 val))
(define (rC-H42 nuc) (vector-ref nuc 33))
(define (rC-H42-set! nuc val) (vector-set! nuc 33 val))
(define (rC-H5 nuc) (vector-ref nuc 34))
(define (rC-H5-set! nuc val) (vector-set! nuc 34 val))
(define (rC-H6 nuc) (vector-ref nuc 35))
(define (rC-H6-set! nuc val) (vector-set! nuc 35 val))

(define (make-rG dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
                 P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
                 H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
                 N2 N7 N9 C8 O6 H1 H21 H22 H8)
  (vector dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
          P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
          H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
          'rG N2 N7 N9 C8 O6 H1 H21 H22 H8))

(define (rG? nuc) (eq? (vector-ref nuc 29) 'rG))

(define (rG-N2 nuc) (vector-ref nuc 30))
(define (rG-N2-set! nuc val) (vector-set! nuc 30 val))
(define (rG-N7 nuc) (vector-ref nuc 31))
(define (rG-N7-set! nuc val) (vector-set! nuc 31 val))
(define (rG-N9 nuc) (vector-ref nuc 32))
(define (rG-N9-set! nuc val) (vector-set! nuc 32 val))
(define (rG-C8 nuc) (vector-ref nuc 33))
(define (rG-C8-set! nuc val) (vector-set! nuc 33 val))
(define (rG-O6 nuc) (vector-ref nuc 34))
(define (rG-O6-set! nuc val) (vector-set! nuc 34 val))
(define (rG-H1 nuc) (vector-ref nuc 35))
(define (rG-H1-set! nuc val) (vector-set! nuc 35 val))
(define (rG-H21 nuc) (vector-ref nuc 36))
(define (rG-H21-set! nuc val) (vector-set! nuc 36 val))
(define (rG-H22 nuc) (vector-ref nuc 37))
(define (rG-H22-set! nuc val) (vector-set! nuc 37 val))
(define (rG-H8 nuc) (vector-ref nuc 38))
(define (rG-H8-set! nuc val) (vector-set! nuc 38 val))

(define (make-rU dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
                 P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
                 H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
                 O2 O4 H3 H5 H6)
  (vector dgf-base-tfo P-O3*-275-tfo P-O3*-180-tfo P-O3*-60-tfo
          P O1P O2P O5* C5* H5* H5** C4* H4* O4* C1* H1* C2*
          H2** O2* H2* C3* H3* O3* N1 N3 C2 C4 C5 C6
          'rU O2 O4 H3 H5 H6))

(define (rU? nuc) (eq? (vector-ref nuc 29) 'rU))

(define (rU-O2 nuc) (vector-ref nuc 30))
(define (rU-O2-set! nuc val) (vector-set! nuc 30 val))
(define (rU-O4 nuc) (vector-ref nuc 31))
(define (rU-O4-set! nuc val) (vector-set! nuc 31 val))
(define (rU-H3 nuc) (vector-ref nuc 32))
(define (rU-H3-set! nuc val) (vector-set! nuc 32 val))
(define (rU-H5 nuc) (vector-ref nuc 33))
(define (rU-H5-set! nuc val) (vector-set! nuc 33 val))
(define (rU-H6 nuc) (vector-ref nuc 34))
(define (rU-H6-set! nuc val) (vector-set! nuc 34 val))

; Database of nucleotide conformations:

(define rA
  (nuc-const
    #( -0.0018  -0.8207   0.5714  ; dgf-base-tfo
        0.2679  -0.5509  -0.7904
        0.9634   0.1517   0.2209
        0.0073   8.4030   0.6232)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4550   8.2120  -2.8810) ; C5* 
    #(  5.4546   8.8508  -1.9978) ; H5* 
    #(  5.7588   8.6625  -3.8259) ; H5**
    #(  6.4970   7.1480  -2.5980) ; C4* 
    #(  7.4896   7.5919  -2.5214) ; H4* 
    #(  6.1630   6.4860  -1.3440) ; O4* 
    #(  6.5400   5.1200  -1.4190) ; C1* 
    #(  7.2763   4.9681  -0.6297) ; H1* 
    #(  7.1940   4.8830  -2.7770) ; C2* 
    #(  6.8667   3.9183  -3.1647) ; H2**
    #(  8.5860   5.0910  -2.6140) ; O2* 
    #(  8.9510   4.7626  -1.7890) ; H2* 
    #(  6.5720   6.0040  -3.6090) ; C3* 
    #(  5.5636   5.7066  -3.8966) ; H3* 
    #(  7.3801   6.3562  -4.7350) ; O3* 
    #(  4.7150   0.4910  -0.1360) ; N1  
    #(  6.3490   2.1730  -0.6020) ; N3  
    #(  5.9530   0.9650  -0.2670) ; C2  
    #(  5.2900   2.9790  -0.8260) ; C4  
    #(  3.9720   2.6390  -0.7330) ; C5  
    #(  3.6770   1.3160  -0.3660) ; C6  
    rA
    #(  2.4280   0.8450  -0.2360) ; N6  
    #(  3.1660   3.7290  -1.0360) ; N7  
    #(  5.3170   4.2990  -1.1930) ; N9  
    #(  4.0100   4.6780  -1.2990) ; C8  
    #(  6.6890   0.1903  -0.0518) ; H2  
    #(  1.6470   1.4460  -0.4040) ; H61 
    #(  2.2780  -0.1080  -0.0280) ; H62 
    #(  3.4421   5.5744  -1.5482) ; H8  
  ))

(define rA01
  (nuc-const
    #( -0.0043  -0.8175   0.5759  ; dgf-base-tfo
        0.2617  -0.5567  -0.7884
        0.9651   0.1473   0.2164
        0.0359   8.3929   0.5532)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4352   8.2183  -2.7757) ; C5* 
    #(  5.3830   8.7883  -1.8481) ; H5* 
    #(  5.7729   8.7436  -3.6691) ; H5**
    #(  6.4830   7.1518  -2.5252) ; C4* 
    #(  7.4749   7.5972  -2.4482) ; H4* 
    #(  6.1626   6.4620  -1.2827) ; O4* 
    #(  6.5431   5.0992  -1.3905) ; C1* 
    #(  7.2871   4.9328  -0.6114) ; H1* 
    #(  7.1852   4.8935  -2.7592) ; C2* 
    #(  6.8573   3.9363  -3.1645) ; H2**
    #(  8.5780   5.1025  -2.6046) ; O2* 
    #(  8.9516   4.7577  -1.7902) ; H2* 
    #(  6.5522   6.0300  -3.5612) ; C3* 
    #(  5.5420   5.7356  -3.8459) ; H3* 
    #(  7.3487   6.4089  -4.6867) ; O3* 
    #(  4.7442   0.4514  -0.1390) ; N1  
    #(  6.3687   2.1459  -0.5926) ; N3  
    #(  5.9795   0.9335  -0.2657) ; C2  
    #(  5.3052   2.9471  -0.8125) ; C4  
    #(  3.9891   2.5987  -0.7230) ; C5  
    #(  3.7016   1.2717  -0.3647) ; C6  
    rA
    #(  2.4553   0.7925  -0.2390) ; N6  
    #(  3.1770   3.6859  -1.0198) ; N7  
    #(  5.3247   4.2695  -1.1710) ; N9  
    #(  4.0156   4.6415  -1.2759) ; C8  
    #(  6.7198   0.1618  -0.0547) ; H2  
    #(  1.6709   1.3900  -0.4039) ; H61 
    #(  2.3107  -0.1627  -0.0373) ; H62 
    #(  3.4426   5.5361  -1.5199) ; H8  
  ))

(define rA02
  (nuc-const
    #(  0.5566   0.0449   0.8296  ; dgf-base-tfo
        0.5125   0.7673  -0.3854
       -0.6538   0.6397   0.4041
       -9.1161  -3.7679  -2.9968)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.5778   6.6594  -4.0364) ; C5* 
    #(  4.9220   7.1963  -4.9204) ; H5* 
    #(  3.7996   5.9091  -4.1764) ; H5**
    #(  5.7873   5.8869  -3.5482) ; C4* 
    #(  6.0405   5.0875  -4.2446) ; H4* 
    #(  6.9135   6.8036  -3.4310) ; O4* 
    #(  7.7293   6.4084  -2.3392) ; C1* 
    #(  8.7078   6.1815  -2.7624) ; H1* 
    #(  7.1305   5.1418  -1.7347) ; C2* 
    #(  7.2040   5.1982  -0.6486) ; H2**
    #(  7.7417   4.0392  -2.3813) ; O2* 
    #(  8.6785   4.1443  -2.5630) ; H2* 
    #(  5.6666   5.2728  -2.1536) ; C3* 
    #(  5.1747   5.9805  -1.4863) ; H3* 
    #(  4.9997   4.0086  -2.1973) ; O3* 
    #( 10.3245   8.5459   1.5467) ; N1  
    #(  9.8051   6.9432  -0.1497) ; N3  
    #( 10.5175   7.4328   0.8408) ; C2  
    #(  8.7523   7.7422  -0.4228) ; C4  
    #(  8.4257   8.9060   0.2099) ; C5  
    #(  9.2665   9.3242   1.2540) ; C6  
    rA
    #(  9.0664  10.4462   1.9610) ; N6  
    #(  7.2750   9.4537  -0.3428) ; N7  
    #(  7.7962   7.5519  -1.3859) ; N9  
    #(  6.9479   8.6157  -1.2771) ; C8  
    #( 11.4063   6.9047   1.1859) ; H2  
    #(  8.2845  11.0341   1.7552) ; H61 
    #(  9.6584  10.6647   2.7198) ; H62 
    #(  6.0430   8.9853  -1.7594) ; H8  
  ))

(define rA03
  (nuc-const
    #( -0.5021   0.0731   0.8617  ; dgf-base-tfo
       -0.8112   0.3054  -0.4986
       -0.2996  -0.9494  -0.0940
        6.4273  -5.1944  -3.7807)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.1214   6.7116  -1.9049) ; C5* 
    #(  3.3465   5.9610  -2.0607) ; H5* 
    #(  4.0789   7.2928  -0.9837) ; H5**
    #(  5.4170   5.9293  -1.8186) ; C4* 
    #(  5.4506   5.3400  -0.9023) ; H4* 
    #(  5.5067   5.0417  -2.9703) ; O4* 
    #(  6.8650   4.9152  -3.3612) ; C1* 
    #(  7.1090   3.8577  -3.2603) ; H1* 
    #(  7.7152   5.7282  -2.3894) ; C2* 
    #(  8.5029   6.2356  -2.9463) ; H2**
    #(  8.1036   4.8568  -1.3419) ; O2* 
    #(  8.3270   3.9651  -1.6184) ; H2* 
    #(  6.7003   6.7565  -1.8911) ; C3* 
    #(  6.5898   7.5329  -2.6482) ; H3* 
    #(  7.0505   7.2878  -0.6105) ; O3* 
    #(  9.6740   4.7656  -7.6614) ; N1  
    #(  9.0739   4.3013  -5.3941) ; N3  
    #(  9.8416   4.2192  -6.4581) ; C2  
    #(  7.9885   5.0632  -5.6446) ; C4  
    #(  7.6822   5.6856  -6.8194) ; C5  
    #(  8.5831   5.5215  -7.8840) ; C6  
    rA
    #(  8.4084   6.0747  -9.0933) ; N6  
    #(  6.4857   6.3816  -6.7035) ; N7  
    #(  6.9740   5.3703  -4.7760) ; N9  
    #(  6.1133   6.1613  -5.4808) ; C8  
    #( 10.7627   3.6375  -6.4220) ; H2  
    #(  7.6031   6.6390  -9.2733) ; H61 
    #(  9.1004   5.9708  -9.7893) ; H62 
    #(  5.1705   6.6830  -5.3167) ; H8  
  ))

(define rA04
  (nuc-const
    #( -0.5426  -0.8175   0.1929  ; dgf-base-tfo
        0.8304  -0.5567  -0.0237
        0.1267   0.1473   0.9809
       -0.5075   8.3929   0.2229)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4352   8.2183  -2.7757) ; C5* 
    #(  5.3830   8.7883  -1.8481) ; H5* 
    #(  5.7729   8.7436  -3.6691) ; H5**
    #(  6.4830   7.1518  -2.5252) ; C4* 
    #(  7.4749   7.5972  -2.4482) ; H4* 
    #(  6.1626   6.4620  -1.2827) ; O4* 
    #(  6.5431   5.0992  -1.3905) ; C1* 
    #(  7.2871   4.9328  -0.6114) ; H1* 
    #(  7.1852   4.8935  -2.7592) ; C2* 
    #(  6.8573   3.9363  -3.1645) ; H2**
    #(  8.5780   5.1025  -2.6046) ; O2* 
    #(  8.9516   4.7577  -1.7902) ; H2* 
    #(  6.5522   6.0300  -3.5612) ; C3* 
    #(  5.5420   5.7356  -3.8459) ; H3* 
    #(  7.3487   6.4089  -4.6867) ; O3* 
    #(  3.6343   2.6680   2.0783) ; N1  
    #(  5.4505   3.9805   1.2446) ; N3  
    #(  4.7540   3.3816   2.1851) ; C2  
    #(  4.8805   3.7951   0.0354) ; C4  
    #(  3.7416   3.0925  -0.2305) ; C5  
    #(  3.0873   2.4980   0.8606) ; C6  
    rA
    #(  1.9600   1.7805   0.7462) ; N6  
    #(  3.4605   3.1184  -1.5906) ; N7  
    #(  5.3247   4.2695  -1.1710) ; N9  
    #(  4.4244   3.8244  -2.0953) ; C8  
    #(  5.0814   3.4352   3.2234) ; H2  
    #(  1.5423   1.6454  -0.1520) ; H61 
    #(  1.5716   1.3398   1.5392) ; H62 
    #(  4.2675   3.8876  -3.1721) ; H8  
  ))

(define rA05
  (nuc-const
    #( -0.5891   0.0449   0.8068  ; dgf-base-tfo
        0.5375   0.7673   0.3498
       -0.6034   0.6397  -0.4762
       -0.3019  -3.7679  -9.5913)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.5778   6.6594  -4.0364) ; C5* 
    #(  4.9220   7.1963  -4.9204) ; H5* 
    #(  3.7996   5.9091  -4.1764) ; H5**
    #(  5.7873   5.8869  -3.5482) ; C4* 
    #(  6.0405   5.0875  -4.2446) ; H4* 
    #(  6.9135   6.8036  -3.4310) ; O4* 
    #(  7.7293   6.4084  -2.3392) ; C1* 
    #(  8.7078   6.1815  -2.7624) ; H1* 
    #(  7.1305   5.1418  -1.7347) ; C2* 
    #(  7.2040   5.1982  -0.6486) ; H2**
    #(  7.7417   4.0392  -2.3813) ; O2* 
    #(  8.6785   4.1443  -2.5630) ; H2* 
    #(  5.6666   5.2728  -2.1536) ; C3* 
    #(  5.1747   5.9805  -1.4863) ; H3* 
    #(  4.9997   4.0086  -2.1973) ; O3* 
    #( 10.2594  10.6774  -1.0056) ; N1  
    #(  9.7528   8.7080  -2.2631) ; N3  
    #( 10.4471   9.7876  -1.9791) ; C2  
    #(  8.7271   8.5575  -1.3991) ; C4  
    #(  8.4100   9.3803  -0.3580) ; C5  
    #(  9.2294  10.5030  -0.1574) ; C6  
    rA
    #(  9.0349  11.3951   0.8250) ; N6  
    #(  7.2891   8.9068   0.3121) ; N7  
    #(  7.7962   7.5519  -1.3859) ; N9  
    #(  6.9702   7.8292  -0.3353) ; C8  
    #( 11.3132  10.0537  -2.5851) ; H2  
    #(  8.2741  11.2784   1.4629) ; H61 
    #(  9.6733  12.1368   0.9529) ; H62 
    #(  6.0888   7.3990   0.1403) ; H8  
  ))

(define rA06
  (nuc-const
    #( -0.9815   0.0731  -0.1772  ; dgf-base-tfo
        0.1912   0.3054  -0.9328
       -0.0141  -0.9494  -0.3137
        5.7506  -5.1944   4.7470)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.1214   6.7116  -1.9049) ; C5* 
    #(  3.3465   5.9610  -2.0607) ; H5* 
    #(  4.0789   7.2928  -0.9837) ; H5**
    #(  5.4170   5.9293  -1.8186) ; C4* 
    #(  5.4506   5.3400  -0.9023) ; H4* 
    #(  5.5067   5.0417  -2.9703) ; O4* 
    #(  6.8650   4.9152  -3.3612) ; C1* 
    #(  7.1090   3.8577  -3.2603) ; H1* 
    #(  7.7152   5.7282  -2.3894) ; C2* 
    #(  8.5029   6.2356  -2.9463) ; H2**
    #(  8.1036   4.8568  -1.3419) ; O2* 
    #(  8.3270   3.9651  -1.6184) ; H2* 
    #(  6.7003   6.7565  -1.8911) ; C3* 
    #(  6.5898   7.5329  -2.6482) ; H3* 
    #(  7.0505   7.2878  -0.6105) ; O3* 
    #(  6.6624   3.5061  -8.2986) ; N1  
    #(  6.5810   3.2570  -5.9221) ; N3  
    #(  6.5151   2.8263  -7.1625) ; C2  
    #(  6.8364   4.5817  -5.8882) ; C4  
    #(  7.0116   5.4064  -6.9609) ; C5  
    #(  6.9173   4.8260  -8.2361) ; C6  
    rA
    #(  7.0668   5.5163  -9.3763) ; N6  
    #(  7.2573   6.7070  -6.5394) ; N7  
    #(  6.9740   5.3703  -4.7760) ; N9  
    #(  7.2238   6.6275  -5.2453) ; C8  
    #(  6.3146   1.7741  -7.3641) ; H2  
    #(  7.2568   6.4972  -9.3456) ; H61 
    #(  7.0437   5.0478 -10.2446) ; H62 
    #(  7.4108   7.6227  -4.8418) ; H8  
  ))

(define rA07
  (nuc-const
    #(  0.2379   0.1310  -0.9624  ; dgf-base-tfo
       -0.5876  -0.7696  -0.2499
       -0.7734   0.6249  -0.1061
       30.9870 -26.9344  42.6416)
    #(  0.7529   0.1548   0.6397  ; P-O3*-275-tfo
        0.2952  -0.9481  -0.1180
        0.5882   0.2777  -0.7595
      -58.8919 -11.3095   6.0866)
    #( -0.0239   0.9667  -0.2546  ; P-O3*-180-tfo
        0.9731  -0.0359  -0.2275
       -0.2290  -0.2532  -0.9399
        3.5401 -29.7913  52.2796)
    #( -0.8912  -0.4531   0.0242  ; P-O3*-60-tfo
       -0.1183   0.1805  -0.9764
        0.4380  -0.8730  -0.2145
       19.9023  54.8054  15.2799)
    #( 41.8210   8.3880  43.5890) ; P   
    #( 42.5400   8.0450  44.8330) ; O1P 
    #( 42.2470   9.6920  42.9910) ; O2P 
    #( 40.2550   8.2030  43.7340) ; O5* 
    #( 39.3505   8.4697  42.6565) ; C5* 
    #( 39.1377   7.5433  42.1230) ; H5* 
    #( 39.7203   9.3119  42.0717) ; H5**
    #( 38.0405   8.9195  43.2869) ; C4* 
    #( 37.3687   9.3036  42.5193) ; H4* 
    #( 37.4319   7.8146  43.9387) ; O4* 
    #( 37.1959   8.1354  45.3237) ; C1* 
    #( 36.1788   8.5202  45.3970) ; H1* 
    #( 38.1721   9.2328  45.6504) ; C2* 
    #( 39.1555   8.7939  45.8188) ; H2**
    #( 37.7862  10.0617  46.7013) ; O2* 
    #( 37.3087   9.6229  47.4092) ; H2* 
    #( 38.1844  10.0268  44.3367) ; C3* 
    #( 39.1578  10.5054  44.2289) ; H3* 
    #( 37.0547  10.9127  44.3441) ; O3* 
    #( 34.8811   4.2072  47.5784) ; N1  
    #( 35.1084   6.1336  46.1818) ; N3  
    #( 34.4108   5.1360  46.7207) ; C2  
    #( 36.3908   6.1224  46.6053) ; C4  
    #( 36.9819   5.2334  47.4697) ; C5  
    #( 36.1786   4.1985  48.0035) ; C6  
    rA
    #( 36.6103   3.2749  48.8452) ; N6  
    #( 38.3236   5.5522  47.6595) ; N7  
    #( 37.3887   7.0024  46.2437) ; N9  
    #( 38.5055   6.6096  46.9057) ; C8  
    #( 33.3553   5.0152  46.4771) ; H2  
    #( 37.5730   3.2804  49.1507) ; H61 
    #( 35.9775   2.5638  49.1828) ; H62 
    #( 39.5461   6.9184  47.0041) ; H8  
  ))

(define rA08
  (nuc-const
    #(  0.1084  -0.0895  -0.9901  ; dgf-base-tfo
        0.9789  -0.1638   0.1220
       -0.1731  -0.9824   0.0698
       -2.9039  47.2655  33.0094)
    #(  0.7529   0.1548   0.6397  ; P-O3*-275-tfo
        0.2952  -0.9481  -0.1180
        0.5882   0.2777  -0.7595
      -58.8919 -11.3095   6.0866)
    #( -0.0239   0.9667  -0.2546  ; P-O3*-180-tfo
        0.9731  -0.0359  -0.2275
       -0.2290  -0.2532  -0.9399
        3.5401 -29.7913  52.2796)
    #( -0.8912  -0.4531   0.0242  ; P-O3*-60-tfo
       -0.1183   0.1805  -0.9764
        0.4380  -0.8730  -0.2145
       19.9023  54.8054  15.2799)
    #( 41.8210   8.3880  43.5890) ; P   
    #( 42.5400   8.0450  44.8330) ; O1P 
    #( 42.2470   9.6920  42.9910) ; O2P 
    #( 40.2550   8.2030  43.7340) ; O5* 
    #( 39.4850   8.9301  44.6977) ; C5* 
    #( 39.0638   9.8199  44.2296) ; H5* 
    #( 40.0757   9.0713  45.6029) ; H5**
    #( 38.3102   8.0414  45.0789) ; C4* 
    #( 37.7842   8.4637  45.9351) ; H4* 
    #( 37.4200   7.9453  43.9769) ; O4* 
    #( 37.2249   6.5609  43.6273) ; C1* 
    #( 36.3360   6.2168  44.1561) ; H1* 
    #( 38.4347   5.8414  44.1590) ; C2* 
    #( 39.2688   5.9974  43.4749) ; H2**
    #( 38.2344   4.4907  44.4348) ; O2* 
    #( 37.6374   4.0386  43.8341) ; H2* 
    #( 38.6926   6.6079  45.4637) ; C3* 
    #( 39.7585   6.5640  45.6877) ; H3* 
    #( 37.8238   6.0705  46.4723) ; O3* 
    #( 33.9162   6.2598  39.7758) ; N1  
    #( 34.6709   6.5759  42.0215) ; N3  
    #( 33.7257   6.5186  41.0858) ; C2  
    #( 35.8935   6.3324  41.5018) ; C4  
    #( 36.2105   6.0601  40.1932) ; C5  
    #( 35.1538   6.0151  39.2537) ; C6  
    rA
    #( 35.3088   5.7642  37.9649) ; N6  
    #( 37.5818   5.8677  40.0507) ; N7  
    #( 37.0932   6.3197  42.1810) ; N9  
    #( 38.0509   6.0354  41.2635) ; C8  
    #( 32.6830   6.6898  41.3532) ; H2  
    #( 36.2305   5.5855  37.5925) ; H61 
    #( 34.5056   5.7512  37.3528) ; H62 
    #( 39.1318   5.8993  41.2285) ; H8  
  ))

(define rA09
  (nuc-const
    #(  0.8467   0.4166  -0.3311  ; dgf-base-tfo
       -0.3962   0.9089   0.1303
        0.3552   0.0209   0.9346
      -42.7319 -26.6223 -29.8163)
    #(  0.7529   0.1548   0.6397  ; P-O3*-275-tfo
        0.2952  -0.9481  -0.1180
        0.5882   0.2777  -0.7595
      -58.8919 -11.3095   6.0866)
    #( -0.0239   0.9667  -0.2546  ; P-O3*-180-tfo
        0.9731  -0.0359  -0.2275
       -0.2290  -0.2532  -0.9399
        3.5401 -29.7913  52.2796)
    #( -0.8912  -0.4531   0.0242  ; P-O3*-60-tfo
       -0.1183   0.1805  -0.9764
        0.4380  -0.8730  -0.2145
       19.9023  54.8054  15.2799)
    #( 41.8210   8.3880  43.5890) ; P   
    #( 42.5400   8.0450  44.8330) ; O1P 
    #( 42.2470   9.6920  42.9910) ; O2P 
    #( 40.2550   8.2030  43.7340) ; O5* 
    #( 39.3505   8.4697  42.6565) ; C5* 
    #( 39.1377   7.5433  42.1230) ; H5* 
    #( 39.7203   9.3119  42.0717) ; H5**
    #( 38.0405   8.9195  43.2869) ; C4* 
    #( 37.6479   8.1347  43.9335) ; H4* 
    #( 38.2691  10.0933  44.0524) ; O4* 
    #( 37.3999  11.1488  43.5973) ; C1* 
    #( 36.5061  11.1221  44.2206) ; H1* 
    #( 37.0364  10.7838  42.1836) ; C2* 
    #( 37.8636  11.0489  41.5252) ; H2**
    #( 35.8275  11.3133  41.7379) ; O2* 
    #( 35.6214  12.1896  42.0714) ; H2* 
    #( 36.9316   9.2556  42.2837) ; C3* 
    #( 37.1778   8.8260  41.3127) ; H3* 
    #( 35.6285   8.9334  42.7926) ; O3* 
    #( 38.1482  15.2833  46.4641) ; N1  
    #( 37.3641  13.0968  45.9007) ; N3  
    #( 37.5032  14.1288  46.7300) ; C2  
    #( 37.9570  13.3377  44.7113) ; C4  
    #( 38.6397  14.4660  44.3267) ; C5  
    #( 38.7473  15.5229  45.2609) ; C6  
    rA
    #( 39.3720  16.6649  45.0297) ; N6  
    #( 39.1079  14.3351  43.0223) ; N7  
    #( 38.0132  12.4868  43.6280) ; N9  
    #( 38.7058  13.1402  42.6620) ; C8  
    #( 37.0731  14.0857  47.7306) ; H2  
    #( 39.8113  16.8281  44.1350) ; H61 
    #( 39.4100  17.3741  45.7478) ; H62 
    #( 39.0412  12.9660  41.6397) ; H8  
  ))

(define rA10
  (nuc-const
    #(  0.7063   0.6317  -0.3196  ; dgf-base-tfo
       -0.0403  -0.4149  -0.9090
       -0.7068   0.6549  -0.2676
        6.4402 -52.1496  30.8246)
    #(  0.7529   0.1548   0.6397  ; P-O3*-275-tfo
        0.2952  -0.9481  -0.1180
        0.5882   0.2777  -0.7595
      -58.8919 -11.3095   6.0866)
    #( -0.0239   0.9667  -0.2546  ; P-O3*-180-tfo
        0.9731  -0.0359  -0.2275
       -0.2290  -0.2532  -0.9399
        3.5401 -29.7913  52.2796)
    #( -0.8912  -0.4531   0.0242  ; P-O3*-60-tfo
       -0.1183   0.1805  -0.9764
        0.4380  -0.8730  -0.2145
       19.9023  54.8054  15.2799)
    #( 41.8210   8.3880  43.5890) ; P   
    #( 42.5400   8.0450  44.8330) ; O1P 
    #( 42.2470   9.6920  42.9910) ; O2P 
    #( 40.2550   8.2030  43.7340) ; O5* 
    #( 39.4850   8.9301  44.6977) ; C5* 
    #( 39.0638   9.8199  44.2296) ; H5* 
    #( 40.0757   9.0713  45.6029) ; H5**
    #( 38.3102   8.0414  45.0789) ; C4* 
    #( 37.7099   7.8166  44.1973) ; H4* 
    #( 38.8012   6.8321  45.6380) ; O4* 
    #( 38.2431   6.6413  46.9529) ; C1* 
    #( 37.3505   6.0262  46.8385) ; H1* 
    #( 37.8484   8.0156  47.4214) ; C2* 
    #( 38.7381   8.5406  47.7690) ; H2**
    #( 36.8286   8.0368  48.3701) ; O2* 
    #( 36.8392   7.3063  48.9929) ; H2* 
    #( 37.3576   8.6512  46.1132) ; C3* 
    #( 37.5207   9.7275  46.1671) ; H3* 
    #( 35.9985   8.2392  45.9032) ; O3* 
    #( 39.9117   2.2278  48.8527) ; N1  
    #( 38.6207   3.6941  47.4757) ; N3  
    #( 38.9872   2.4888  47.9057) ; C2  
    #( 39.2961   4.6720  48.1174) ; C4  
    #( 40.2546   4.5307  49.0912) ; C5  
    #( 40.5932   3.2189  49.4985) ; C6  
    rA
    #( 41.4938   2.9317  50.4229) ; N6  
    #( 40.7195   5.7755  49.5060) ; N7  
    #( 39.1730   6.0305  47.9170) ; N9  
    #( 40.0413   6.6250  48.7728) ; C8  
    #( 38.5257   1.5960  47.4838) ; H2  
    #( 41.9907   3.6753  50.8921) ; H61 
    #( 41.6848   1.9687  50.6599) ; H62 
    #( 40.3571   7.6321  49.0452) ; H8  
  ))

(define rAs 
  (list rA01 rA02 rA03 rA04 rA05 rA06 rA07 rA08 rA09 rA10))

(define rC
  (nuc-const
    #( -0.0359  -0.8071   0.5894  ; dgf-base-tfo
       -0.2669   0.5761   0.7726
       -0.9631  -0.1296  -0.2361
        0.1584   8.3434   0.5434)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2430  -8.2420   2.8260) ; C5* 
    #(  5.1974  -8.8497   1.9223) ; H5* 
    #(  5.5548  -8.7348   3.7469) ; H5**
    #(  6.3140  -7.2060   2.5510) ; C4* 
    #(  7.2954  -7.6762   2.4898) ; H4* 
    #(  6.0140  -6.5420   1.2890) ; O4* 
    #(  6.4190  -5.1840   1.3620) ; C1* 
    #(  7.1608  -5.0495   0.5747) ; H1* 
    #(  7.0760  -4.9560   2.7270) ; C2* 
    #(  6.7770  -3.9803   3.1099) ; H2**
    #(  8.4500  -5.1930   2.5810) ; O2* 
    #(  8.8309  -4.8755   1.7590) ; H2* 
    #(  6.4060  -6.0590   3.5580) ; C3* 
    #(  5.4021  -5.7313   3.8281) ; H3* 
    #(  7.1570  -6.4240   4.7070) ; O3* 
    #(  5.2170  -4.3260   1.1690) ; N1  
    #(  4.2960  -2.2560   0.6290) ; N3  
    #(  5.4330  -3.0200   0.7990) ; C2  
    #(  2.9930  -2.6780   0.7940) ; C4  
    #(  2.8670  -4.0630   1.1830) ; C5  
    #(  3.9570  -4.8300   1.3550) ; C6  
    rC
    #(  2.0187  -1.8047   0.5874) ; N4  
    #(  6.5470  -2.5560   0.6290) ; O2  
    #(  1.0684  -2.1236   0.7109) ; H41 
    #(  2.2344  -0.8560   0.3162) ; H42 
    #(  1.8797  -4.4972   1.3404) ; H5  
    #(  3.8479  -5.8742   1.6480) ; H6  
  ))

(define rC01
  (nuc-const
    #( -0.0137  -0.8012   0.5983  ; dgf-base-tfo
       -0.2523   0.5817   0.7733
       -0.9675  -0.1404  -0.2101
        0.2031   8.3874   0.4228)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2416  -8.2422   2.8181) ; C5* 
    #(  5.2050  -8.8128   1.8901) ; H5* 
    #(  5.5368  -8.7738   3.7227) ; H5**
    #(  6.3232  -7.2037   2.6002) ; C4* 
    #(  7.3048  -7.6757   2.5577) ; H4* 
    #(  6.0635  -6.5092   1.3456) ; O4* 
    #(  6.4697  -5.1547   1.4629) ; C1* 
    #(  7.2354  -5.0043   0.7018) ; H1* 
    #(  7.0856  -4.9610   2.8521) ; C2* 
    #(  6.7777  -3.9935   3.2487) ; H2**
    #(  8.4627  -5.1992   2.7423) ; O2* 
    #(  8.8693  -4.8638   1.9399) ; H2* 
    #(  6.3877  -6.0809   3.6362) ; C3* 
    #(  5.3770  -5.7562   3.8834) ; H3* 
    #(  7.1024  -6.4754   4.7985) ; O3* 
    #(  5.2764  -4.2883   1.2538) ; N1  
    #(  4.3777  -2.2062   0.7229) ; N3  
    #(  5.5069  -2.9779   0.9088) ; C2  
    #(  3.0693  -2.6246   0.8500) ; C4  
    #(  2.9279  -4.0146   1.2149) ; C5  
    #(  4.0101  -4.7892   1.4017) ; C6  
    rC
    #(  2.1040  -1.7437   0.6331) ; N4  
    #(  6.6267  -2.5166   0.7728) ; O2  
    #(  1.1496  -2.0600   0.7287) ; H41 
    #(  2.3303  -0.7921   0.3815) ; H42 
    #(  1.9353  -4.4465   1.3419) ; H5  
    #(  3.8895  -5.8371   1.6762) ; H6  
  ))

(define rC02
  (nuc-const
    #(  0.5141   0.0246   0.8574  ; dgf-base-tfo
       -0.5547  -0.7529   0.3542
        0.6542  -0.6577  -0.3734
       -9.1111  -3.4598  -3.2939)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  4.3825  -6.6585   4.0489) ; C5* 
    #(  4.6841  -7.2019   4.9443) ; H5* 
    #(  3.6189  -5.8889   4.1625) ; H5**
    #(  5.6255  -5.9175   3.5998) ; C4* 
    #(  5.8732  -5.1228   4.3034) ; H4* 
    #(  6.7337  -6.8605   3.5222) ; O4* 
    #(  7.5932  -6.4923   2.4548) ; C1* 
    #(  8.5661  -6.2983   2.9064) ; H1* 
    #(  7.0527  -5.2012   1.8322) ; C2* 
    #(  7.1627  -5.2525   0.7490) ; H2**
    #(  7.6666  -4.1249   2.4880) ; O2* 
    #(  8.5944  -4.2543   2.6981) ; H2* 
    #(  5.5661  -5.3029   2.2009) ; C3* 
    #(  5.0841  -6.0018   1.5172) ; H3* 
    #(  4.9062  -4.0452   2.2042) ; O3* 
    #(  7.6298  -7.6136   1.4752) ; N1  
    #(  8.6945  -8.7046  -0.2857) ; N3  
    #(  8.6943  -7.6514   0.6066) ; C2  
    #(  7.7426  -9.6987  -0.3801) ; C4  
    #(  6.6642  -9.5742   0.5722) ; C5  
    #(  6.6391  -8.5592   1.4526) ; C6  
    rC
    #(  7.9033 -10.6371  -1.3010) ; N4  
    #(  9.5840  -6.8186   0.6136) ; O2  
    #(  7.2009 -11.3604  -1.3619) ; H41 
    #(  8.7058 -10.6168  -1.9140) ; H42 
    #(  5.8585 -10.3083   0.5822) ; H5  
    #(  5.8197  -8.4773   2.1667) ; H6  
  ))

(define rC03
  (nuc-const
    #( -0.4993   0.0476   0.8651  ; dgf-base-tfo
        0.8078  -0.3353   0.4847
        0.3132   0.9409   0.1290
        6.2989  -5.2303  -3.8577)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  3.9938  -6.7042   1.9023) ; C5* 
    #(  3.2332  -5.9343   2.0319) ; H5* 
    #(  3.9666  -7.2863   0.9812) ; H5**
    #(  5.3098  -5.9546   1.8564) ; C4* 
    #(  5.3863  -5.3702   0.9395) ; H4* 
    #(  5.3851  -5.0642   3.0076) ; O4* 
    #(  6.7315  -4.9724   3.4462) ; C1* 
    #(  7.0033  -3.9202   3.3619) ; H1* 
    #(  7.5997  -5.8018   2.4948) ; C2* 
    #(  8.3627  -6.3254   3.0707) ; H2**
    #(  8.0410  -4.9501   1.4724) ; O2* 
    #(  8.2781  -4.0644   1.7570) ; H2* 
    #(  6.5701  -6.8129   1.9714) ; C3* 
    #(  6.4186  -7.5809   2.7299) ; H3* 
    #(  6.9357  -7.3841   0.7235) ; O3* 
    #(  6.8024  -5.4718   4.8475) ; N1  
    #(  7.9218  -5.5700   6.8877) ; N3  
    #(  7.8908  -5.0886   5.5944) ; C2  
    #(  6.9789  -6.3827   7.4823) ; C4  
    #(  5.8742  -6.7319   6.6202) ; C5  
    #(  5.8182  -6.2769   5.3570) ; C6  
    rC
    #(  7.1702  -6.7511   8.7402) ; N4  
    #(  8.7747  -4.3728   5.1568) ; O2  
    #(  6.4741  -7.3461   9.1662) ; H41 
    #(  7.9889  -6.4396   9.2429) ; H42 
    #(  5.0736  -7.3713   6.9922) ; H5  
    #(  4.9784  -6.5473   4.7170) ; H6  
  ))

(define rC04
  (nuc-const
    #( -0.5669  -0.8012   0.1918  ; dgf-base-tfo
       -0.8129   0.5817   0.0273
       -0.1334  -0.1404  -0.9811
       -0.3279   8.3874   0.3355)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2416  -8.2422   2.8181) ; C5* 
    #(  5.2050  -8.8128   1.8901) ; H5* 
    #(  5.5368  -8.7738   3.7227) ; H5**
    #(  6.3232  -7.2037   2.6002) ; C4* 
    #(  7.3048  -7.6757   2.5577) ; H4* 
    #(  6.0635  -6.5092   1.3456) ; O4* 
    #(  6.4697  -5.1547   1.4629) ; C1* 
    #(  7.2354  -5.0043   0.7018) ; H1* 
    #(  7.0856  -4.9610   2.8521) ; C2* 
    #(  6.7777  -3.9935   3.2487) ; H2**
    #(  8.4627  -5.1992   2.7423) ; O2* 
    #(  8.8693  -4.8638   1.9399) ; H2* 
    #(  6.3877  -6.0809   3.6362) ; C3* 
    #(  5.3770  -5.7562   3.8834) ; H3* 
    #(  7.1024  -6.4754   4.7985) ; O3* 
    #(  5.2764  -4.2883   1.2538) ; N1  
    #(  3.8961  -3.0896  -0.1893) ; N3  
    #(  5.0095  -3.8907  -0.0346) ; C2  
    #(  3.0480  -2.6632   0.8116) ; C4  
    #(  3.4093  -3.1310   2.1292) ; C5  
    #(  4.4878  -3.9124   2.3088) ; C6  
    rC
    #(  2.0216  -1.8941   0.4804) ; N4  
    #(  5.7005  -4.2164  -0.9842) ; O2  
    #(  1.4067  -1.5873   1.2205) ; H41 
    #(  1.8721  -1.6319  -0.4835) ; H42 
    #(  2.8048  -2.8507   2.9918) ; H5  
    #(  4.7491  -4.2593   3.3085) ; H6  
  ))

(define rC05
  (nuc-const
    #( -0.6298   0.0246   0.7763  ; dgf-base-tfo
       -0.5226  -0.7529  -0.4001
        0.5746  -0.6577   0.4870
       -0.0208  -3.4598  -9.6882)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  4.3825  -6.6585   4.0489) ; C5* 
    #(  4.6841  -7.2019   4.9443) ; H5* 
    #(  3.6189  -5.8889   4.1625) ; H5**
    #(  5.6255  -5.9175   3.5998) ; C4* 
    #(  5.8732  -5.1228   4.3034) ; H4* 
    #(  6.7337  -6.8605   3.5222) ; O4* 
    #(  7.5932  -6.4923   2.4548) ; C1* 
    #(  8.5661  -6.2983   2.9064) ; H1* 
    #(  7.0527  -5.2012   1.8322) ; C2* 
    #(  7.1627  -5.2525   0.7490) ; H2**
    #(  7.6666  -4.1249   2.4880) ; O2* 
    #(  8.5944  -4.2543   2.6981) ; H2* 
    #(  5.5661  -5.3029   2.2009) ; C3* 
    #(  5.0841  -6.0018   1.5172) ; H3* 
    #(  4.9062  -4.0452   2.2042) ; O3* 
    #(  7.6298  -7.6136   1.4752) ; N1  
    #(  8.5977  -9.5977   0.7329) ; N3  
    #(  8.5951  -8.5745   1.6594) ; C2  
    #(  7.7372  -9.7371  -0.3364) ; C4  
    #(  6.7596  -8.6801  -0.4476) ; C5  
    #(  6.7338  -7.6721   0.4408) ; C6  
    rC
    #(  7.8849 -10.7881  -1.1289) ; N4  
    #(  9.3993  -8.5377   2.5743) ; O2  
    #(  7.2499 -10.8809  -1.9088) ; H41 
    #(  8.6122 -11.4649  -0.9468) ; H42 
    #(  6.0317  -8.6941  -1.2588) ; H5  
    #(  5.9901  -6.8809   0.3459) ; H6  
  ))

(define rC06
  (nuc-const
    #( -0.9837   0.0476  -0.1733  ; dgf-base-tfo
       -0.1792  -0.3353   0.9249
       -0.0141   0.9409   0.3384
        5.7793  -5.2303   4.5997)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  3.9938  -6.7042   1.9023) ; C5* 
    #(  3.2332  -5.9343   2.0319) ; H5* 
    #(  3.9666  -7.2863   0.9812) ; H5**
    #(  5.3098  -5.9546   1.8564) ; C4* 
    #(  5.3863  -5.3702   0.9395) ; H4* 
    #(  5.3851  -5.0642   3.0076) ; O4* 
    #(  6.7315  -4.9724   3.4462) ; C1* 
    #(  7.0033  -3.9202   3.3619) ; H1* 
    #(  7.5997  -5.8018   2.4948) ; C2* 
    #(  8.3627  -6.3254   3.0707) ; H2**
    #(  8.0410  -4.9501   1.4724) ; O2* 
    #(  8.2781  -4.0644   1.7570) ; H2* 
    #(  6.5701  -6.8129   1.9714) ; C3* 
    #(  6.4186  -7.5809   2.7299) ; H3* 
    #(  6.9357  -7.3841   0.7235) ; O3* 
    #(  6.8024  -5.4718   4.8475) ; N1  
    #(  6.6920  -5.0495   7.1354) ; N3  
    #(  6.6201  -4.5500   5.8506) ; C2  
    #(  6.9254  -6.3614   7.4926) ; C4  
    #(  7.1046  -7.2543   6.3718) ; C5  
    #(  7.0391  -6.7951   5.1106) ; C6  
    rC
    #(  6.9614  -6.6648   8.7815) ; N4  
    #(  6.4083  -3.3696   5.6340) ; O2  
    #(  7.1329  -7.6280   9.0324) ; H41 
    #(  6.8204  -5.9469   9.4777) ; H42 
    #(  7.2954  -8.3135   6.5440) ; H5  
    #(  7.1753  -7.4798   4.2735) ; H6  
  ))

(define rC07
  (nuc-const
    #(  0.0033   0.2720  -0.9623  ; dgf-base-tfo
        0.3013  -0.9179  -0.2584
       -0.9535  -0.2891  -0.0850
       43.0403  13.7233  34.5710)
    #(  0.9187   0.2887   0.2694  ; P-O3*-275-tfo
        0.0302  -0.7316   0.6811
        0.3938  -0.6176  -0.6808
      -48.4330  26.3254  13.6383)
    #( -0.1504   0.7744  -0.6145  ; P-O3*-180-tfo
        0.7581   0.4893   0.4311
        0.6345  -0.4010  -0.6607
      -31.9784 -13.4285  44.9650)
    #( -0.6236  -0.7810  -0.0337  ; P-O3*-60-tfo
       -0.6890   0.5694  -0.4484
        0.3694  -0.2564  -0.8932
       12.1105  30.8774  46.0946)
    #( 33.3400  11.0980  46.1750) ; P   
    #( 34.5130  10.2320  46.4660) ; O1P 
    #( 33.4130  12.3960  46.9340) ; O2P 
    #( 31.9810  10.3390  46.4820) ; O5* 
    #( 30.8152  11.1619  46.2003) ; C5* 
    #( 30.4519  10.9454  45.1957) ; H5* 
    #( 31.0379  12.2016  46.4400) ; H5**
    #( 29.7081  10.7448  47.1428) ; C4* 
    #( 28.8710  11.4416  47.0982) ; H4* 
    #( 29.2550   9.4394  46.8162) ; O4* 
    #( 29.3907   8.5625  47.9460) ; C1* 
    #( 28.4416   8.5669  48.4819) ; H1* 
    #( 30.4468   9.2031  48.7952) ; C2* 
    #( 31.4222   8.9651  48.3709) ; H2**
    #( 30.3701   8.9157  50.1624) ; O2* 
    #( 30.0652   8.0304  50.3740) ; H2* 
    #( 30.1622  10.6879  48.6120) ; C3* 
    #( 31.0952  11.2399  48.7254) ; H3* 
    #( 29.1076  11.1535  49.4702) ; O3* 
    #( 29.7883   7.2209  47.5235) ; N1  
    #( 29.1825   5.0438  46.8275) ; N3  
    #( 28.8008   6.2912  47.2263) ; C2  
    #( 30.4888   4.6890  46.7186) ; C4  
    #( 31.5034   5.6405  47.0249) ; C5  
    #( 31.1091   6.8691  47.4156) ; C6  
    rC
    #( 30.8109   3.4584  46.3336) ; N4  
    #( 27.6171   6.5989  47.3189) ; O2  
    #( 31.7923   3.2301  46.2638) ; H41 
    #( 30.0880   2.7857  46.1215) ; H42 
    #( 32.5542   5.3634  46.9395) ; H5  
    #( 31.8523   7.6279  47.6603) ; H6  
  ))

(define rC08
  (nuc-const
    #(  0.0797  -0.6026  -0.7941  ; dgf-base-tfo
        0.7939   0.5201  -0.3150
        0.6028  -0.6054   0.5198
      -36.8341  41.5293   1.6628)
    #(  0.9187   0.2887   0.2694  ; P-O3*-275-tfo
        0.0302  -0.7316   0.6811
        0.3938  -0.6176  -0.6808
      -48.4330  26.3254  13.6383)
    #( -0.1504   0.7744  -0.6145  ; P-O3*-180-tfo
        0.7581   0.4893   0.4311
        0.6345  -0.4010  -0.6607
      -31.9784 -13.4285  44.9650)
    #( -0.6236  -0.7810  -0.0337  ; P-O3*-60-tfo
       -0.6890   0.5694  -0.4484
        0.3694  -0.2564  -0.8932
       12.1105  30.8774  46.0946)
    #( 33.3400  11.0980  46.1750) ; P   
    #( 34.5130  10.2320  46.4660) ; O1P 
    #( 33.4130  12.3960  46.9340) ; O2P 
    #( 31.9810  10.3390  46.4820) ; O5* 
    #( 31.8779   9.9369  47.8760) ; C5* 
    #( 31.3239  10.6931  48.4322) ; H5* 
    #( 32.8647   9.6624  48.2489) ; H5**
    #( 31.0429   8.6773  47.9401) ; C4* 
    #( 31.0779   8.2331  48.9349) ; H4* 
    #( 29.6956   8.9669  47.5983) ; O4* 
    #( 29.2784   8.1700  46.4782) ; C1* 
    #( 28.8006   7.2731  46.8722) ; H1* 
    #( 30.5544   7.7940  45.7875) ; C2* 
    #( 30.8837   8.6410  45.1856) ; H2**
    #( 30.5100   6.6007  45.0582) ; O2* 
    #( 29.6694   6.4168  44.6326) ; H2* 
    #( 31.5146   7.5954  46.9527) ; C3* 
    #( 32.5255   7.8261  46.6166) ; H3* 
    #( 31.3876   6.2951  47.5516) ; O3* 
    #( 28.3976   8.9302  45.5933) ; N1  
    #( 26.2155   9.6135  44.9910) ; N3  
    #( 27.0281   8.8961  45.8192) ; C2  
    #( 26.7044  10.3489  43.9595) ; C4  
    #( 28.1088  10.3837  43.7247) ; C5  
    #( 28.8978   9.6708  44.5535) ; C6  
    rC
    #( 25.8715  11.0249  43.1749) ; N4  
    #( 26.5733   8.2371  46.7484) ; O2  
    #( 26.2707  11.5609  42.4177) ; H41 
    #( 24.8760  10.9939  43.3427) ; H42 
    #( 28.5089  10.9722  42.8990) ; H5  
    #( 29.9782   9.6687  44.4097) ; H6  
  ))

(define rC09
  (nuc-const
    #(  0.8727   0.4760  -0.1091  ; dgf-base-tfo
       -0.4188   0.6148  -0.6682
       -0.2510   0.6289   0.7359
       -8.1687 -52.0761 -25.0726)
    #(  0.9187   0.2887   0.2694  ; P-O3*-275-tfo
        0.0302  -0.7316   0.6811
        0.3938  -0.6176  -0.6808
      -48.4330  26.3254  13.6383)
    #( -0.1504   0.7744  -0.6145  ; P-O3*-180-tfo
        0.7581   0.4893   0.4311
        0.6345  -0.4010  -0.6607
      -31.9784 -13.4285  44.9650)
    #( -0.6236  -0.7810  -0.0337  ; P-O3*-60-tfo
       -0.6890   0.5694  -0.4484
        0.3694  -0.2564  -0.8932
       12.1105  30.8774  46.0946)
    #( 33.3400  11.0980  46.1750) ; P   
    #( 34.5130  10.2320  46.4660) ; O1P 
    #( 33.4130  12.3960  46.9340) ; O2P 
    #( 31.9810  10.3390  46.4820) ; O5* 
    #( 30.8152  11.1619  46.2003) ; C5* 
    #( 30.4519  10.9454  45.1957) ; H5* 
    #( 31.0379  12.2016  46.4400) ; H5**
    #( 29.7081  10.7448  47.1428) ; C4* 
    #( 29.4506   9.6945  47.0059) ; H4* 
    #( 30.1045  10.9634  48.4885) ; O4* 
    #( 29.1794  11.8418  49.1490) ; C1* 
    #( 28.4388  11.2210  49.6533) ; H1* 
    #( 28.5211  12.6008  48.0367) ; C2* 
    #( 29.1947  13.3949  47.7147) ; H2**
    #( 27.2316  13.0683  48.3134) ; O2* 
    #( 27.0851  13.3391  49.2227) ; H2* 
    #( 28.4131  11.5507  46.9391) ; C3* 
    #( 28.4451  12.0512  45.9713) ; H3* 
    #( 27.2707  10.6955  47.1097) ; O3* 
    #( 29.8751  12.7405  50.0682) ; N1  
    #( 30.7172  13.1841  52.2328) ; N3  
    #( 30.0617  12.3404  51.3847) ; C2  
    #( 31.1834  14.3941  51.8297) ; C4  
    #( 30.9913  14.8074  50.4803) ; C5  
    #( 30.3434  13.9610  49.6548) ; C6  
    rC
    #( 31.8090  15.1847  52.6957) ; N4  
    #( 29.6470  11.2494  51.7616) ; O2  
    #( 32.1422  16.0774  52.3606) ; H41 
    #( 31.9392  14.8893  53.6527) ; H42 
    #( 31.3632  15.7771  50.1491) ; H5  
    #( 30.1742  14.2374  48.6141) ; H6  
  ))

(define rC10
  (nuc-const
    #(  0.1549   0.8710  -0.4663  ; dgf-base-tfo
        0.6768  -0.4374  -0.5921
       -0.7197  -0.2239  -0.6572
       25.2447 -14.1920  50.3201)
    #(  0.9187   0.2887   0.2694  ; P-O3*-275-tfo
        0.0302  -0.7316   0.6811
        0.3938  -0.6176  -0.6808
      -48.4330  26.3254  13.6383)
    #( -0.1504   0.7744  -0.6145  ; P-O3*-180-tfo
        0.7581   0.4893   0.4311
        0.6345  -0.4010  -0.6607
      -31.9784 -13.4285  44.9650)
    #( -0.6236  -0.7810  -0.0337  ; P-O3*-60-tfo
       -0.6890   0.5694  -0.4484
        0.3694  -0.2564  -0.8932
       12.1105  30.8774  46.0946)
    #( 33.3400  11.0980  46.1750) ; P   
    #( 34.5130  10.2320  46.4660) ; O1P 
    #( 33.4130  12.3960  46.9340) ; O2P 
    #( 31.9810  10.3390  46.4820) ; O5* 
    #( 31.8779   9.9369  47.8760) ; C5* 
    #( 31.3239  10.6931  48.4322) ; H5* 
    #( 32.8647   9.6624  48.2489) ; H5**
    #( 31.0429   8.6773  47.9401) ; C4* 
    #( 30.0440   8.8473  47.5383) ; H4* 
    #( 31.6749   7.6351  47.2119) ; O4* 
    #( 31.9159   6.5022  48.0616) ; C1* 
    #( 31.0691   5.8243  47.9544) ; H1* 
    #( 31.9300   7.0685  49.4493) ; C2* 
    #( 32.9024   7.5288  49.6245) ; H2**
    #( 31.5672   6.1750  50.4632) ; O2* 
    #( 31.8416   5.2663  50.3200) ; H2* 
    #( 30.8618   8.1514  49.3749) ; C3* 
    #( 31.1122   8.9396  50.0850) ; H3* 
    #( 29.5351   7.6245  49.5409) ; O3* 
    #( 33.1890   5.8629  47.7343) ; N1  
    #( 34.4004   4.2636  46.4828) ; N3  
    #( 33.2062   4.8497  46.7851) ; C2  
    #( 35.5600   4.6374  47.0822) ; C4  
    #( 35.5444   5.6751  48.0577) ; C5  
    #( 34.3565   6.2450  48.3432) ; C6  
    rC
    #( 36.6977   4.0305  46.7598) ; N4  
    #( 32.1661   4.5034  46.2348) ; O2  
    #( 37.5405   4.3347  47.2259) ; H41 
    #( 36.7033   3.2923  46.0706) ; H42 
    #( 36.4713   5.9811  48.5428) ; H5  
    #( 34.2986   7.0426  49.0839) ; H6  
  ))

(define rCs 
  (list rC01 rC02 rC03 rC04 rC05 rC06 rC07 rC08 rC09 rC10))

(define rG
  (nuc-const
    #( -0.0018  -0.8207   0.5714  ; dgf-base-tfo
        0.2679  -0.5509  -0.7904
        0.9634   0.1517   0.2209
        0.0073   8.4030   0.6232)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4550   8.2120  -2.8810) ; C5* 
    #(  5.4546   8.8508  -1.9978) ; H5* 
    #(  5.7588   8.6625  -3.8259) ; H5**
    #(  6.4970   7.1480  -2.5980) ; C4* 
    #(  7.4896   7.5919  -2.5214) ; H4* 
    #(  6.1630   6.4860  -1.3440) ; O4* 
    #(  6.5400   5.1200  -1.4190) ; C1* 
    #(  7.2763   4.9681  -0.6297) ; H1* 
    #(  7.1940   4.8830  -2.7770) ; C2* 
    #(  6.8667   3.9183  -3.1647) ; H2**
    #(  8.5860   5.0910  -2.6140) ; O2* 
    #(  8.9510   4.7626  -1.7890) ; H2* 
    #(  6.5720   6.0040  -3.6090) ; C3* 
    #(  5.5636   5.7066  -3.8966) ; H3* 
    #(  7.3801   6.3562  -4.7350) ; O3* 
    #(  4.7150   0.4910  -0.1360) ; N1  
    #(  6.3490   2.1730  -0.6020) ; N3  
    #(  5.9530   0.9650  -0.2670) ; C2  
    #(  5.2900   2.9790  -0.8260) ; C4  
    #(  3.9720   2.6390  -0.7330) ; C5  
    #(  3.6770   1.3160  -0.3660) ; C6  
    rG
    #(  6.8426   0.0056  -0.0019) ; N2  
    #(  3.1660   3.7290  -1.0360) ; N7  
    #(  5.3170   4.2990  -1.1930) ; N9  
    #(  4.0100   4.6780  -1.2990) ; C8  
    #(  2.4280   0.8450  -0.2360) ; O6  
    #(  4.6151  -0.4677   0.1305) ; H1  
    #(  6.6463  -0.9463   0.2729) ; H21 
    #(  7.8170   0.2642  -0.0640) ; H22 
    #(  3.4421   5.5744  -1.5482) ; H8  
  ))

(define rG01
  (nuc-const
    #( -0.0043  -0.8175   0.5759  ; dgf-base-tfo
        0.2617  -0.5567  -0.7884
        0.9651   0.1473   0.2164
        0.0359   8.3929   0.5532)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4352   8.2183  -2.7757) ; C5* 
    #(  5.3830   8.7883  -1.8481) ; H5* 
    #(  5.7729   8.7436  -3.6691) ; H5**
    #(  6.4830   7.1518  -2.5252) ; C4* 
    #(  7.4749   7.5972  -2.4482) ; H4* 
    #(  6.1626   6.4620  -1.2827) ; O4* 
    #(  6.5431   5.0992  -1.3905) ; C1* 
    #(  7.2871   4.9328  -0.6114) ; H1* 
    #(  7.1852   4.8935  -2.7592) ; C2* 
    #(  6.8573   3.9363  -3.1645) ; H2**
    #(  8.5780   5.1025  -2.6046) ; O2* 
    #(  8.9516   4.7577  -1.7902) ; H2* 
    #(  6.5522   6.0300  -3.5612) ; C3* 
    #(  5.5420   5.7356  -3.8459) ; H3* 
    #(  7.3487   6.4089  -4.6867) ; O3* 
    #(  4.7442   0.4514  -0.1390) ; N1  
    #(  6.3687   2.1459  -0.5926) ; N3  
    #(  5.9795   0.9335  -0.2657) ; C2  
    #(  5.3052   2.9471  -0.8125) ; C4  
    #(  3.9891   2.5987  -0.7230) ; C5  
    #(  3.7016   1.2717  -0.3647) ; C6  
    rG
    #(  6.8745  -0.0224  -0.0058) ; N2  
    #(  3.1770   3.6859  -1.0198) ; N7  
    #(  5.3247   4.2695  -1.1710) ; N9  
    #(  4.0156   4.6415  -1.2759) ; C8  
    #(  2.4553   0.7925  -0.2390) ; O6  
    #(  4.6497  -0.5095   0.1212) ; H1  
    #(  6.6836  -0.9771   0.2627) ; H21 
    #(  7.8474   0.2424  -0.0653) ; H22 
    #(  3.4426   5.5361  -1.5199) ; H8  
  ))

(define rG02
  (nuc-const
    #(  0.5566   0.0449   0.8296  ; dgf-base-tfo
        0.5125   0.7673  -0.3854
       -0.6538   0.6397   0.4041
       -9.1161  -3.7679  -2.9968)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.5778   6.6594  -4.0364) ; C5* 
    #(  4.9220   7.1963  -4.9204) ; H5* 
    #(  3.7996   5.9091  -4.1764) ; H5**
    #(  5.7873   5.8869  -3.5482) ; C4* 
    #(  6.0405   5.0875  -4.2446) ; H4* 
    #(  6.9135   6.8036  -3.4310) ; O4* 
    #(  7.7293   6.4084  -2.3392) ; C1* 
    #(  8.7078   6.1815  -2.7624) ; H1* 
    #(  7.1305   5.1418  -1.7347) ; C2* 
    #(  7.2040   5.1982  -0.6486) ; H2**
    #(  7.7417   4.0392  -2.3813) ; O2* 
    #(  8.6785   4.1443  -2.5630) ; H2* 
    #(  5.6666   5.2728  -2.1536) ; C3* 
    #(  5.1747   5.9805  -1.4863) ; H3* 
    #(  4.9997   4.0086  -2.1973) ; O3* 
    #( 10.3245   8.5459   1.5467) ; N1  
    #(  9.8051   6.9432  -0.1497) ; N3  
    #( 10.5175   7.4328   0.8408) ; C2  
    #(  8.7523   7.7422  -0.4228) ; C4  
    #(  8.4257   8.9060   0.2099) ; C5  
    #(  9.2665   9.3242   1.2540) ; C6  
    rG
    #( 11.6077   6.7966   1.2752) ; N2  
    #(  7.2750   9.4537  -0.3428) ; N7  
    #(  7.7962   7.5519  -1.3859) ; N9  
    #(  6.9479   8.6157  -1.2771) ; C8  
    #(  9.0664  10.4462   1.9610) ; O6  
    #( 10.9838   8.7524   2.2697) ; H1  
    #( 12.2274   7.0896   2.0170) ; H21 
    #( 11.8502   5.9398   0.7984) ; H22 
    #(  6.0430   8.9853  -1.7594) ; H8  
  ))

(define rG03
  (nuc-const
    #( -0.5021   0.0731   0.8617  ; dgf-base-tfo
       -0.8112   0.3054  -0.4986
       -0.2996  -0.9494  -0.0940
        6.4273  -5.1944  -3.7807)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.1214   6.7116  -1.9049) ; C5* 
    #(  3.3465   5.9610  -2.0607) ; H5* 
    #(  4.0789   7.2928  -0.9837) ; H5**
    #(  5.4170   5.9293  -1.8186) ; C4* 
    #(  5.4506   5.3400  -0.9023) ; H4* 
    #(  5.5067   5.0417  -2.9703) ; O4* 
    #(  6.8650   4.9152  -3.3612) ; C1* 
    #(  7.1090   3.8577  -3.2603) ; H1* 
    #(  7.7152   5.7282  -2.3894) ; C2* 
    #(  8.5029   6.2356  -2.9463) ; H2**
    #(  8.1036   4.8568  -1.3419) ; O2* 
    #(  8.3270   3.9651  -1.6184) ; H2* 
    #(  6.7003   6.7565  -1.8911) ; C3* 
    #(  6.5898   7.5329  -2.6482) ; H3* 
    #(  7.0505   7.2878  -0.6105) ; O3* 
    #(  9.6740   4.7656  -7.6614) ; N1  
    #(  9.0739   4.3013  -5.3941) ; N3  
    #(  9.8416   4.2192  -6.4581) ; C2  
    #(  7.9885   5.0632  -5.6446) ; C4  
    #(  7.6822   5.6856  -6.8194) ; C5  
    #(  8.5831   5.5215  -7.8840) ; C6  
    rG
    #( 10.9733   3.5117  -6.4286) ; N2  
    #(  6.4857   6.3816  -6.7035) ; N7  
    #(  6.9740   5.3703  -4.7760) ; N9  
    #(  6.1133   6.1613  -5.4808) ; C8  
    #(  8.4084   6.0747  -9.0933) ; O6  
    #( 10.3759   4.5855  -8.3504) ; H1  
    #( 11.6254   3.3761  -7.1879) ; H21 
    #( 11.1917   3.0460  -5.5593) ; H22 
    #(  5.1705   6.6830  -5.3167) ; H8  
  ))

(define rG04
  (nuc-const
    #( -0.5426  -0.8175   0.1929  ; dgf-base-tfo
        0.8304  -0.5567  -0.0237
        0.1267   0.1473   0.9809
       -0.5075   8.3929   0.2229)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  5.4352   8.2183  -2.7757) ; C5* 
    #(  5.3830   8.7883  -1.8481) ; H5* 
    #(  5.7729   8.7436  -3.6691) ; H5**
    #(  6.4830   7.1518  -2.5252) ; C4* 
    #(  7.4749   7.5972  -2.4482) ; H4* 
    #(  6.1626   6.4620  -1.2827) ; O4* 
    #(  6.5431   5.0992  -1.3905) ; C1* 
    #(  7.2871   4.9328  -0.6114) ; H1* 
    #(  7.1852   4.8935  -2.7592) ; C2* 
    #(  6.8573   3.9363  -3.1645) ; H2**
    #(  8.5780   5.1025  -2.6046) ; O2* 
    #(  8.9516   4.7577  -1.7902) ; H2* 
    #(  6.5522   6.0300  -3.5612) ; C3* 
    #(  5.5420   5.7356  -3.8459) ; H3* 
    #(  7.3487   6.4089  -4.6867) ; O3* 
    #(  3.6343   2.6680   2.0783) ; N1  
    #(  5.4505   3.9805   1.2446) ; N3  
    #(  4.7540   3.3816   2.1851) ; C2  
    #(  4.8805   3.7951   0.0354) ; C4  
    #(  3.7416   3.0925  -0.2305) ; C5  
    #(  3.0873   2.4980   0.8606) ; C6  
    rG
    #(  5.1433   3.4373   3.4609) ; N2  
    #(  3.4605   3.1184  -1.5906) ; N7  
    #(  5.3247   4.2695  -1.1710) ; N9  
    #(  4.4244   3.8244  -2.0953) ; C8  
    #(  1.9600   1.7805   0.7462) ; O6  
    #(  3.2489   2.2879   2.9191) ; H1  
    #(  4.6785   3.0243   4.2568) ; H21 
    #(  5.9823   3.9654   3.6539) ; H22 
    #(  4.2675   3.8876  -3.1721) ; H8  
  ))

(define rG05
  (nuc-const
    #( -0.5891   0.0449   0.8068  ; dgf-base-tfo
        0.5375   0.7673   0.3498
       -0.6034   0.6397  -0.4762
       -0.3019  -3.7679  -9.5913)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.5778   6.6594  -4.0364) ; C5* 
    #(  4.9220   7.1963  -4.9204) ; H5* 
    #(  3.7996   5.9091  -4.1764) ; H5**
    #(  5.7873   5.8869  -3.5482) ; C4* 
    #(  6.0405   5.0875  -4.2446) ; H4* 
    #(  6.9135   6.8036  -3.4310) ; O4* 
    #(  7.7293   6.4084  -2.3392) ; C1* 
    #(  8.7078   6.1815  -2.7624) ; H1* 
    #(  7.1305   5.1418  -1.7347) ; C2* 
    #(  7.2040   5.1982  -0.6486) ; H2**
    #(  7.7417   4.0392  -2.3813) ; O2* 
    #(  8.6785   4.1443  -2.5630) ; H2* 
    #(  5.6666   5.2728  -2.1536) ; C3* 
    #(  5.1747   5.9805  -1.4863) ; H3* 
    #(  4.9997   4.0086  -2.1973) ; O3* 
    #( 10.2594  10.6774  -1.0056) ; N1  
    #(  9.7528   8.7080  -2.2631) ; N3  
    #( 10.4471   9.7876  -1.9791) ; C2  
    #(  8.7271   8.5575  -1.3991) ; C4  
    #(  8.4100   9.3803  -0.3580) ; C5  
    #(  9.2294  10.5030  -0.1574) ; C6  
    rG
    #( 11.5110  10.1256  -2.7114) ; N2  
    #(  7.2891   8.9068   0.3121) ; N7  
    #(  7.7962   7.5519  -1.3859) ; N9  
    #(  6.9702   7.8292  -0.3353) ; C8  
    #(  9.0349  11.3951   0.8250) ; O6  
    #( 10.9013  11.4422  -0.9512) ; H1  
    #( 12.1031  10.9341  -2.5861) ; H21 
    #( 11.7369   9.5180  -3.4859) ; H22 
    #(  6.0888   7.3990   0.1403) ; H8  
  ))

(define rG06
  (nuc-const
    #( -0.9815   0.0731  -0.1772  ; dgf-base-tfo
        0.1912   0.3054  -0.9328
       -0.0141  -0.9494  -0.3137
        5.7506  -5.1944   4.7470)
    #( -0.8143  -0.5091  -0.2788  ; P-O3*-275-tfo
       -0.0433  -0.4257   0.9038
       -0.5788   0.7480   0.3246
        1.5227   6.9114  -7.0765)
    #(  0.3822  -0.7477   0.5430  ; P-O3*-180-tfo
        0.4552   0.6637   0.5935
       -0.8042   0.0203   0.5941
       -6.9472  -4.1186  -5.9108)
    #(  0.5640   0.8007  -0.2022  ; P-O3*-60-tfo
       -0.8247   0.5587  -0.0878
        0.0426   0.2162   0.9754
        6.2694  -7.0540   3.3316)
    #(  2.8930   8.5380  -3.3280) ; P   
    #(  1.6980   7.6960  -3.5570) ; O1P 
    #(  3.2260   9.5010  -4.4020) ; O2P 
    #(  4.1590   7.6040  -3.0340) ; O5* 
    #(  4.1214   6.7116  -1.9049) ; C5* 
    #(  3.3465   5.9610  -2.0607) ; H5* 
    #(  4.0789   7.2928  -0.9837) ; H5**
    #(  5.4170   5.9293  -1.8186) ; C4* 
    #(  5.4506   5.3400  -0.9023) ; H4* 
    #(  5.5067   5.0417  -2.9703) ; O4* 
    #(  6.8650   4.9152  -3.3612) ; C1* 
    #(  7.1090   3.8577  -3.2603) ; H1* 
    #(  7.7152   5.7282  -2.3894) ; C2* 
    #(  8.5029   6.2356  -2.9463) ; H2**
    #(  8.1036   4.8568  -1.3419) ; O2* 
    #(  8.3270   3.9651  -1.6184) ; H2* 
    #(  6.7003   6.7565  -1.8911) ; C3* 
    #(  6.5898   7.5329  -2.6482) ; H3* 
    #(  7.0505   7.2878  -0.6105) ; O3* 
    #(  6.6624   3.5061  -8.2986) ; N1  
    #(  6.5810   3.2570  -5.9221) ; N3  
    #(  6.5151   2.8263  -7.1625) ; C2  
    #(  6.8364   4.5817  -5.8882) ; C4  
    #(  7.0116   5.4064  -6.9609) ; C5  
    #(  6.9173   4.8260  -8.2361) ; C6  
    rG
    #(  6.2717   1.5402  -7.4250) ; N2  
    #(  7.2573   6.7070  -6.5394) ; N7  
    #(  6.9740   5.3703  -4.7760) ; N9  
    #(  7.2238   6.6275  -5.2453) ; C8  
    #(  7.0668   5.5163  -9.3763) ; O6  
    #(  6.5754   2.9964  -9.1545) ; H1  
    #(  6.1908   1.1105  -8.3354) ; H21 
    #(  6.1346   0.9352  -6.6280) ; H22 
    #(  7.4108   7.6227  -4.8418) ; H8  
  ))

(define rG07
  (nuc-const
    #(  0.0894  -0.6059   0.7905  ; dgf-base-tfo
       -0.6810   0.5420   0.4924
       -0.7268  -0.5824  -0.3642
       34.1424  45.9610 -11.8600)
    #( -0.8644  -0.4956  -0.0851  ; P-O3*-275-tfo
       -0.0427   0.2409  -0.9696
        0.5010  -0.8345  -0.2294
        4.0167  54.5377  12.4779)
    #(  0.3706  -0.6167   0.6945  ; P-O3*-180-tfo
       -0.2867  -0.7872  -0.5460
        0.8834   0.0032  -0.4686
      -52.9020  18.6313  -0.6709)
    #(  0.4155   0.9025  -0.1137  ; P-O3*-60-tfo
        0.9040  -0.4236  -0.0582
       -0.1007  -0.0786  -0.9918
       -7.6624 -25.2080  49.5181)
    #( 31.3810   0.1400  47.5810) ; P   
    #( 29.9860   0.6630  47.6290) ; O1P 
    #( 31.7210  -0.6460  48.8090) ; O2P 
    #( 32.4940   1.2540  47.2740) ; O5* 
    #( 33.8709   0.7918  47.2113) ; C5* 
    #( 34.1386   0.5870  46.1747) ; H5* 
    #( 34.0186  -0.0095  47.9353) ; H5**
    #( 34.7297   1.9687  47.6685) ; C4* 
    #( 35.7723   1.6845  47.8113) ; H4* 
    #( 34.6455   2.9768  46.6660) ; O4* 
    #( 34.1690   4.1829  47.2627) ; C1* 
    #( 35.0437   4.7633  47.5560) ; H1* 
    #( 33.4145   3.7532  48.4954) ; C2* 
    #( 32.4340   3.3797  48.2001) ; H2**
    #( 33.3209   4.6953  49.5217) ; O2* 
    #( 33.2374   5.6059  49.2295) ; H2* 
    #( 34.2724   2.5970  48.9773) ; C3* 
    #( 33.6373   1.8935  49.5157) ; H3* 
    #( 35.3453   3.1884  49.7285) ; O3* 
    #( 34.0511   7.8930  43.7791) ; N1  
    #( 34.9937   6.3369  45.3199) ; N3  
    #( 35.0882   7.3126  44.4200) ; C2  
    #( 33.7190   5.9650  45.5374) ; C4  
    #( 32.5845   6.4770  44.9458) ; C5  
    #( 32.7430   7.5179  43.9914) ; C6  
    rG
    #( 36.3030   7.7827  44.1036) ; N2  
    #( 31.4499   5.8335  45.4368) ; N7  
    #( 33.2760   4.9817  46.4043) ; N9  
    #( 31.9235   4.9639  46.2934) ; C8  
    #( 31.8602   8.1000  43.3695) ; O6  
    #( 34.2623   8.6223  43.1283) ; H1  
    #( 36.5188   8.5081  43.4347) ; H21 
    #( 37.0888   7.3524  44.5699) ; H22 
    #( 31.0815   4.4201  46.7218) ; H8  
  ))

(define rG08
  (nuc-const
    #(  0.2224   0.6335   0.7411  ; dgf-base-tfo
       -0.3644  -0.6510   0.6659
        0.9043  -0.4181   0.0861
      -47.6824  -0.5823 -31.7554)
    #( -0.8644  -0.4956  -0.0851  ; P-O3*-275-tfo
       -0.0427   0.2409  -0.9696
        0.5010  -0.8345  -0.2294
        4.0167  54.5377  12.4779)
    #(  0.3706  -0.6167   0.6945  ; P-O3*-180-tfo
       -0.2867  -0.7872  -0.5460
        0.8834   0.0032  -0.4686
      -52.9020  18.6313  -0.6709)
    #(  0.4155   0.9025  -0.1137  ; P-O3*-60-tfo
        0.9040  -0.4236  -0.0582
       -0.1007  -0.0786  -0.9918
       -7.6624 -25.2080  49.5181)
    #( 31.3810   0.1400  47.5810) ; P   
    #( 29.9860   0.6630  47.6290) ; O1P 
    #( 31.7210  -0.6460  48.8090) ; O2P 
    #( 32.4940   1.2540  47.2740) ; O5* 
    #( 32.5924   2.3488  48.2255) ; C5* 
    #( 33.3674   2.1246  48.9584) ; H5* 
    #( 31.5994   2.5917  48.6037) ; H5**
    #( 33.0722   3.5577  47.4258) ; C4* 
    #( 33.0310   4.4778  48.0089) ; H4* 
    #( 34.4173   3.3055  47.0316) ; O4* 
    #( 34.5056   3.3910  45.6094) ; C1* 
    #( 34.7881   4.4152  45.3663) ; H1* 
    #( 33.1122   3.1198  45.1010) ; C2* 
    #( 32.9230   2.0469  45.1369) ; H2**
    #( 32.7946   3.6590  43.8529) ; O2* 
    #( 33.5170   3.6707  43.2207) ; H2* 
    #( 32.2730   3.8173  46.1566) ; C3* 
    #( 31.3094   3.3123  46.2244) ; H3* 
    #( 32.2391   5.2039  45.7807) ; O3* 
    #( 39.3337   2.7157  44.1441) ; N1  
    #( 37.4430   3.8242  45.0824) ; N3  
    #( 38.7276   3.7646  44.7403) ; C2  
    #( 36.7791   2.6963  44.7704) ; C4  
    #( 37.2860   1.5653  44.1678) ; C5  
    #( 38.6647   1.5552  43.8235) ; C6  
    rG
    #( 39.5123   4.8216  44.9936) ; N2  
    #( 36.2829   0.6110  44.0078) ; N7  
    #( 35.4394   2.4314  44.9931) ; N9  
    #( 35.2180   1.1815  44.5128) ; C8  
    #( 39.2907   0.6514  43.2796) ; O6  
    #( 40.3076   2.8048  43.9352) ; H1  
    #( 40.4994   4.9066  44.7977) ; H21 
    #( 39.0738   5.6108  45.4464) ; H22 
    #( 34.3856   0.4842  44.4185) ; H8  
  ))

(define rG09
  (nuc-const
    #( -0.9699  -0.1688  -0.1753  ; dgf-base-tfo
       -0.1050  -0.3598   0.9271
       -0.2196   0.9176   0.3312
       45.6217 -38.9484 -12.3208)
    #( -0.8644  -0.4956  -0.0851  ; P-O3*-275-tfo
       -0.0427   0.2409  -0.9696
        0.5010  -0.8345  -0.2294
        4.0167  54.5377  12.4779)
    #(  0.3706  -0.6167   0.6945  ; P-O3*-180-tfo
       -0.2867  -0.7872  -0.5460
        0.8834   0.0032  -0.4686
      -52.9020  18.6313  -0.6709)
    #(  0.4155   0.9025  -0.1137  ; P-O3*-60-tfo
        0.9040  -0.4236  -0.0582
       -0.1007  -0.0786  -0.9918
       -7.6624 -25.2080  49.5181)
    #( 31.3810   0.1400  47.5810) ; P   
    #( 29.9860   0.6630  47.6290) ; O1P 
    #( 31.7210  -0.6460  48.8090) ; O2P 
    #( 32.4940   1.2540  47.2740) ; O5* 
    #( 33.8709   0.7918  47.2113) ; C5* 
    #( 34.1386   0.5870  46.1747) ; H5* 
    #( 34.0186  -0.0095  47.9353) ; H5**
    #( 34.7297   1.9687  47.6685) ; C4* 
    #( 34.5880   2.8482  47.0404) ; H4* 
    #( 34.3575   2.2770  49.0081) ; O4* 
    #( 35.5157   2.1993  49.8389) ; C1* 
    #( 35.9424   3.2010  49.8893) ; H1* 
    #( 36.4701   1.2820  49.1169) ; C2* 
    #( 36.1545   0.2498  49.2683) ; H2**
    #( 37.8262   1.4547  49.4008) ; O2* 
    #( 38.0227   1.6945  50.3094) ; H2* 
    #( 36.2242   1.6797  47.6725) ; C3* 
    #( 36.4297   0.8197  47.0351) ; H3* 
    #( 37.0289   2.8480  47.4426) ; O3* 
    #( 34.3005   3.5042  54.6070) ; N1  
    #( 34.7693   3.7936  52.2874) ; N3  
    #( 34.4484   4.2541  53.4939) ; C2  
    #( 34.9354   2.4584  52.2785) ; C4  
    #( 34.8092   1.5915  53.3422) ; C5  
    #( 34.4646   2.1367  54.6085) ; C6  
    rG
    #( 34.2514   5.5708  53.6503) ; N2  
    #( 35.0641   0.2835  52.9337) ; N7  
    #( 35.2669   1.6690  51.1915) ; N9  
    #( 35.3288   0.3954  51.6563) ; C8  
    #( 34.3151   1.5317  55.6650) ; O6  
    #( 34.0623   3.9797  55.4539) ; H1  
    #( 33.9950   6.0502  54.5016) ; H21 
    #( 34.3512   6.1432  52.8242) ; H22 
    #( 35.5414  -0.6006  51.2679) ; H8  
  ))

(define rG10
  (nuc-const
    #( -0.0980  -0.9723   0.2122  ; dgf-base-tfo
       -0.9731   0.1383   0.1841
       -0.2083  -0.1885  -0.9597
       17.8469  38.8265  37.0475)
    #( -0.8644  -0.4956  -0.0851  ; P-O3*-275-tfo
       -0.0427   0.2409  -0.9696
        0.5010  -0.8345  -0.2294
        4.0167  54.5377  12.4779)
    #(  0.3706  -0.6167   0.6945  ; P-O3*-180-tfo
       -0.2867  -0.7872  -0.5460
        0.8834   0.0032  -0.4686
      -52.9020  18.6313  -0.6709)
    #(  0.4155   0.9025  -0.1137  ; P-O3*-60-tfo
        0.9040  -0.4236  -0.0582
       -0.1007  -0.0786  -0.9918
       -7.6624 -25.2080  49.5181)
    #( 31.3810   0.1400  47.5810) ; P   
    #( 29.9860   0.6630  47.6290) ; O1P 
    #( 31.7210  -0.6460  48.8090) ; O2P 
    #( 32.4940   1.2540  47.2740) ; O5* 
    #( 32.5924   2.3488  48.2255) ; C5* 
    #( 33.3674   2.1246  48.9584) ; H5* 
    #( 31.5994   2.5917  48.6037) ; H5**
    #( 33.0722   3.5577  47.4258) ; C4* 
    #( 34.0333   3.3761  46.9447) ; H4* 
    #( 32.0890   3.8338  46.4332) ; O4* 
    #( 31.6377   5.1787  46.5914) ; C1* 
    #( 32.2499   5.8016  45.9392) ; H1* 
    #( 31.9167   5.5319  48.0305) ; C2* 
    #( 31.1507   5.0820  48.6621) ; H2**
    #( 32.0865   6.8890  48.3114) ; O2* 
    #( 31.5363   7.4819  47.7942) ; H2* 
    #( 33.2398   4.8224  48.2563) ; C3* 
    #( 33.3166   4.5570  49.3108) ; H3* 
    #( 34.2528   5.7056  47.7476) ; O3* 
    #( 28.2782   6.3049  42.9364) ; N1  
    #( 30.4001   5.8547  43.9258) ; N3  
    #( 29.6195   6.1568  42.8913) ; C2  
    #( 29.7005   5.7006  45.0649) ; C4  
    #( 28.3383   5.8221  45.2343) ; C5  
    #( 27.5519   6.1461  44.0958) ; C6  
    rG
    #( 30.1838   6.3385  41.6890) ; N2  
    #( 27.9936   5.5926  46.5651) ; N7  
    #( 30.2046   5.3825  46.3136) ; N9  
    #( 29.1371   5.3398  47.1506) ; C8  
    #( 26.3361   6.3024  44.0495) ; O6  
    #( 27.8122   6.5394  42.0833) ; H1  
    #( 29.7125   6.5595  40.8235) ; H21 
    #( 31.1859   6.2231  41.6389) ; H22 
    #( 28.9406   5.1504  48.2059) ; H8  
  ))

(define rGs
  (list rG01 rG02 rG03 rG04 rG05 rG06 rG07 rG08 rG09 rG10))

(define rU
  (nuc-const
    #( -0.0359  -0.8071   0.5894  ; dgf-base-tfo
       -0.2669   0.5761   0.7726
       -0.9631  -0.1296  -0.2361
        0.1584   8.3434   0.5434)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2430  -8.2420   2.8260) ; C5* 
    #(  5.1974  -8.8497   1.9223) ; H5* 
    #(  5.5548  -8.7348   3.7469) ; H5**
    #(  6.3140  -7.2060   2.5510) ; C4* 
    #(  7.2954  -7.6762   2.4898) ; H4* 
    #(  6.0140  -6.5420   1.2890) ; O4* 
    #(  6.4190  -5.1840   1.3620) ; C1* 
    #(  7.1608  -5.0495   0.5747) ; H1* 
    #(  7.0760  -4.9560   2.7270) ; C2* 
    #(  6.7770  -3.9803   3.1099) ; H2**
    #(  8.4500  -5.1930   2.5810) ; O2* 
    #(  8.8309  -4.8755   1.7590) ; H2* 
    #(  6.4060  -6.0590   3.5580) ; C3* 
    #(  5.4021  -5.7313   3.8281) ; H3* 
    #(  7.1570  -6.4240   4.7070) ; O3* 
    #(  5.2170  -4.3260   1.1690) ; N1  
    #(  4.2960  -2.2560   0.6290) ; N3  
    #(  5.4330  -3.0200   0.7990) ; C2  
    #(  2.9930  -2.6780   0.7940) ; C4  
    #(  2.8670  -4.0630   1.1830) ; C5  
    #(  3.9570  -4.8300   1.3550) ; C6  
    rU
    #(  6.5470  -2.5560   0.6290) ; O2  
    #(  2.0540  -1.9000   0.6130) ; O4  
    #(  4.4300  -1.3020   0.3600) ; H3  
    #(  1.9590  -4.4570   1.3250) ; H5  
    #(  3.8460  -5.7860   1.6240) ; H6  
  ))

(define rU01
  (nuc-const
    #( -0.0137  -0.8012   0.5983  ; dgf-base-tfo
       -0.2523   0.5817   0.7733
       -0.9675  -0.1404  -0.2101
        0.2031   8.3874   0.4228)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2416  -8.2422   2.8181) ; C5* 
    #(  5.2050  -8.8128   1.8901) ; H5* 
    #(  5.5368  -8.7738   3.7227) ; H5**
    #(  6.3232  -7.2037   2.6002) ; C4* 
    #(  7.3048  -7.6757   2.5577) ; H4* 
    #(  6.0635  -6.5092   1.3456) ; O4* 
    #(  6.4697  -5.1547   1.4629) ; C1* 
    #(  7.2354  -5.0043   0.7018) ; H1* 
    #(  7.0856  -4.9610   2.8521) ; C2* 
    #(  6.7777  -3.9935   3.2487) ; H2**
    #(  8.4627  -5.1992   2.7423) ; O2* 
    #(  8.8693  -4.8638   1.9399) ; H2* 
    #(  6.3877  -6.0809   3.6362) ; C3* 
    #(  5.3770  -5.7562   3.8834) ; H3* 
    #(  7.1024  -6.4754   4.7985) ; O3* 
    #(  5.2764  -4.2883   1.2538) ; N1  
    #(  4.3777  -2.2062   0.7229) ; N3  
    #(  5.5069  -2.9779   0.9088) ; C2  
    #(  3.0693  -2.6246   0.8500) ; C4  
    #(  2.9279  -4.0146   1.2149) ; C5  
    #(  4.0101  -4.7892   1.4017) ; C6  
    rU
    #(  6.6267  -2.5166   0.7728) ; O2  
    #(  2.1383  -1.8396   0.6581) ; O4  
    #(  4.5223  -1.2489   0.4716) ; H3  
    #(  2.0151  -4.4065   1.3290) ; H5  
    #(  3.8886  -5.7486   1.6535) ; H6  
  ))

(define rU02
  (nuc-const
    #(  0.5141   0.0246   0.8574  ; dgf-base-tfo
       -0.5547  -0.7529   0.3542
        0.6542  -0.6577  -0.3734
       -9.1111  -3.4598  -3.2939)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  4.3825  -6.6585   4.0489) ; C5* 
    #(  4.6841  -7.2019   4.9443) ; H5* 
    #(  3.6189  -5.8889   4.1625) ; H5**
    #(  5.6255  -5.9175   3.5998) ; C4* 
    #(  5.8732  -5.1228   4.3034) ; H4* 
    #(  6.7337  -6.8605   3.5222) ; O4* 
    #(  7.5932  -6.4923   2.4548) ; C1* 
    #(  8.5661  -6.2983   2.9064) ; H1* 
    #(  7.0527  -5.2012   1.8322) ; C2* 
    #(  7.1627  -5.2525   0.7490) ; H2**
    #(  7.6666  -4.1249   2.4880) ; O2* 
    #(  8.5944  -4.2543   2.6981) ; H2* 
    #(  5.5661  -5.3029   2.2009) ; C3* 
    #(  5.0841  -6.0018   1.5172) ; H3* 
    #(  4.9062  -4.0452   2.2042) ; O3* 
    #(  7.6298  -7.6136   1.4752) ; N1  
    #(  8.6945  -8.7046  -0.2857) ; N3  
    #(  8.6943  -7.6514   0.6066) ; C2  
    #(  7.7426  -9.6987  -0.3801) ; C4  
    #(  6.6642  -9.5742   0.5722) ; C5  
    #(  6.6391  -8.5592   1.4526) ; C6  
    rU
    #(  9.5840  -6.8186   0.6136) ; O2  
    #(  7.8505 -10.5925  -1.2223) ; O4  
    #(  9.4601  -8.7514  -0.9277) ; H3  
    #(  5.9281 -10.2509   0.5782) ; H5  
    #(  5.8831  -8.4931   2.1028) ; H6  
  ))

(define rU03
  (nuc-const
    #( -0.4993   0.0476   0.8651  ; dgf-base-tfo
        0.8078  -0.3353   0.4847
        0.3132   0.9409   0.1290
        6.2989  -5.2303  -3.8577)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  3.9938  -6.7042   1.9023) ; C5* 
    #(  3.2332  -5.9343   2.0319) ; H5* 
    #(  3.9666  -7.2863   0.9812) ; H5**
    #(  5.3098  -5.9546   1.8564) ; C4* 
    #(  5.3863  -5.3702   0.9395) ; H4* 
    #(  5.3851  -5.0642   3.0076) ; O4* 
    #(  6.7315  -4.9724   3.4462) ; C1* 
    #(  7.0033  -3.9202   3.3619) ; H1* 
    #(  7.5997  -5.8018   2.4948) ; C2* 
    #(  8.3627  -6.3254   3.0707) ; H2**
    #(  8.0410  -4.9501   1.4724) ; O2* 
    #(  8.2781  -4.0644   1.7570) ; H2* 
    #(  6.5701  -6.8129   1.9714) ; C3* 
    #(  6.4186  -7.5809   2.7299) ; H3* 
    #(  6.9357  -7.3841   0.7235) ; O3* 
    #(  6.8024  -5.4718   4.8475) ; N1  
    #(  7.9218  -5.5700   6.8877) ; N3  
    #(  7.8908  -5.0886   5.5944) ; C2  
    #(  6.9789  -6.3827   7.4823) ; C4  
    #(  5.8742  -6.7319   6.6202) ; C5  
    #(  5.8182  -6.2769   5.3570) ; C6  
    rU
    #(  8.7747  -4.3728   5.1568) ; O2  
    #(  7.1154  -6.7509   8.6509) ; O4  
    #(  8.7055  -5.3037   7.4491) ; H3  
    #(  5.1416  -7.3178   6.9665) ; H5  
    #(  5.0441  -6.5310   4.7784) ; H6  
  ))

(define rU04
  (nuc-const
    #( -0.5669  -0.8012   0.1918  ; dgf-base-tfo
       -0.8129   0.5817   0.0273
       -0.1334  -0.1404  -0.9811
       -0.3279   8.3874   0.3355)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2416  -8.2422   2.8181) ; C5* 
    #(  5.2050  -8.8128   1.8901) ; H5* 
    #(  5.5368  -8.7738   3.7227) ; H5**
    #(  6.3232  -7.2037   2.6002) ; C4* 
    #(  7.3048  -7.6757   2.5577) ; H4* 
    #(  6.0635  -6.5092   1.3456) ; O4* 
    #(  6.4697  -5.1547   1.4629) ; C1* 
    #(  7.2354  -5.0043   0.7018) ; H1* 
    #(  7.0856  -4.9610   2.8521) ; C2* 
    #(  6.7777  -3.9935   3.2487) ; H2**
    #(  8.4627  -5.1992   2.7423) ; O2* 
    #(  8.8693  -4.8638   1.9399) ; H2* 
    #(  6.3877  -6.0809   3.6362) ; C3* 
    #(  5.3770  -5.7562   3.8834) ; H3* 
    #(  7.1024  -6.4754   4.7985) ; O3* 
    #(  5.2764  -4.2883   1.2538) ; N1  
    #(  3.8961  -3.0896  -0.1893) ; N3  
    #(  5.0095  -3.8907  -0.0346) ; C2  
    #(  3.0480  -2.6632   0.8116) ; C4  
    #(  3.4093  -3.1310   2.1292) ; C5  
    #(  4.4878  -3.9124   2.3088) ; C6  
    rU
    #(  5.7005  -4.2164  -0.9842) ; O2  
    #(  2.0800  -1.9458   0.5503) ; O4  
    #(  3.6834  -2.7882  -1.1190) ; H3  
    #(  2.8508  -2.8721   2.9172) ; H5  
    #(  4.7188  -4.2247   3.2295) ; H6  
  ))

(define rU05
  (nuc-const
    #( -0.6298   0.0246   0.7763  ; dgf-base-tfo
       -0.5226  -0.7529  -0.4001
        0.5746  -0.6577   0.4870
       -0.0208  -3.4598  -9.6882)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  4.3825  -6.6585   4.0489) ; C5* 
    #(  4.6841  -7.2019   4.9443) ; H5* 
    #(  3.6189  -5.8889   4.1625) ; H5**
    #(  5.6255  -5.9175   3.5998) ; C4* 
    #(  5.8732  -5.1228   4.3034) ; H4* 
    #(  6.7337  -6.8605   3.5222) ; O4* 
    #(  7.5932  -6.4923   2.4548) ; C1* 
    #(  8.5661  -6.2983   2.9064) ; H1* 
    #(  7.0527  -5.2012   1.8322) ; C2* 
    #(  7.1627  -5.2525   0.7490) ; H2**
    #(  7.6666  -4.1249   2.4880) ; O2* 
    #(  8.5944  -4.2543   2.6981) ; H2* 
    #(  5.5661  -5.3029   2.2009) ; C3* 
    #(  5.0841  -6.0018   1.5172) ; H3* 
    #(  4.9062  -4.0452   2.2042) ; O3* 
    #(  7.6298  -7.6136   1.4752) ; N1  
    #(  8.5977  -9.5977   0.7329) ; N3  
    #(  8.5951  -8.5745   1.6594) ; C2  
    #(  7.7372  -9.7371  -0.3364) ; C4  
    #(  6.7596  -8.6801  -0.4476) ; C5  
    #(  6.7338  -7.6721   0.4408) ; C6  
    rU
    #(  9.3993  -8.5377   2.5743) ; O2  
    #(  7.8374 -10.6990  -1.1008) ; O4  
    #(  9.2924 -10.3081   0.8477) ; H3  
    #(  6.0932  -8.6982  -1.1929) ; H5  
    #(  6.0481  -6.9515   0.3446) ; H6  
  ))

(define rU06
  (nuc-const
    #( -0.9837   0.0476  -0.1733  ; dgf-base-tfo
       -0.1792  -0.3353   0.9249
       -0.0141   0.9409   0.3384
        5.7793  -5.2303   4.5997)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  3.9938  -6.7042   1.9023) ; C5* 
    #(  3.2332  -5.9343   2.0319) ; H5* 
    #(  3.9666  -7.2863   0.9812) ; H5**
    #(  5.3098  -5.9546   1.8564) ; C4* 
    #(  5.3863  -5.3702   0.9395) ; H4* 
    #(  5.3851  -5.0642   3.0076) ; O4* 
    #(  6.7315  -4.9724   3.4462) ; C1* 
    #(  7.0033  -3.9202   3.3619) ; H1* 
    #(  7.5997  -5.8018   2.4948) ; C2* 
    #(  8.3627  -6.3254   3.0707) ; H2**
    #(  8.0410  -4.9501   1.4724) ; O2* 
    #(  8.2781  -4.0644   1.7570) ; H2* 
    #(  6.5701  -6.8129   1.9714) ; C3* 
    #(  6.4186  -7.5809   2.7299) ; H3* 
    #(  6.9357  -7.3841   0.7235) ; O3* 
    #(  6.8024  -5.4718   4.8475) ; N1  
    #(  6.6920  -5.0495   7.1354) ; N3  
    #(  6.6201  -4.5500   5.8506) ; C2  
    #(  6.9254  -6.3614   7.4926) ; C4  
    #(  7.1046  -7.2543   6.3718) ; C5  
    #(  7.0391  -6.7951   5.1106) ; C6  
    rU
    #(  6.4083  -3.3696   5.6340) ; O2  
    #(  6.9679  -6.6901   8.6800) ; O4  
    #(  6.5626  -4.3957   7.8812) ; H3  
    #(  7.2781  -8.2254   6.5350) ; H5  
    #(  7.1657  -7.4312   4.3503) ; H6  
  ))

(define rU07
  (nuc-const
    #( -0.9434   0.3172   0.0971  ; dgf-base-tfo
        0.2294   0.4125   0.8816
        0.2396   0.8539  -0.4619
        8.3625 -52.7147   1.3745)
    #(  0.2765  -0.1121  -0.9545  ; P-O3*-275-tfo
       -0.8297   0.4733  -0.2959
        0.4850   0.8737   0.0379
      -14.7774 -45.2464  21.9088)
    #(  0.1063  -0.6334  -0.7665  ; P-O3*-180-tfo
       -0.5932  -0.6591   0.4624
       -0.7980   0.4055  -0.4458
       43.7634   4.3296  28.4890)
    #(  0.7136  -0.5032  -0.4873  ; P-O3*-60-tfo
        0.6803   0.3317   0.6536
       -0.1673  -0.7979   0.5791
      -17.1858  41.4390 -27.0751)
    #( 21.3880  15.0780  45.5770) ; P   
    #( 21.9980  14.5500  46.8210) ; O1P 
    #( 21.1450  14.0270  44.5420) ; O2P 
    #( 22.1250  16.3600  44.9460) ; O5* 
    #( 21.5037  16.8594  43.7323) ; C5* 
    #( 20.8147  17.6663  43.9823) ; H5* 
    #( 21.1086  16.0230  43.1557) ; H5**
    #( 22.5654  17.4874  42.8616) ; C4* 
    #( 22.1584  17.7243  41.8785) ; H4* 
    #( 23.0557  18.6826  43.4751) ; O4* 
    #( 24.4788  18.6151  43.6455) ; C1* 
    #( 24.9355  19.0840  42.7739) ; H1* 
    #( 24.7958  17.1427  43.6474) ; C2* 
    #( 24.5652  16.7400  44.6336) ; H2**
    #( 26.1041  16.8773  43.2455) ; O2* 
    #( 26.7516  17.5328  43.5149) ; H2* 
    #( 23.8109  16.5979  42.6377) ; C3* 
    #( 23.5756  15.5686  42.9084) ; H3* 
    #( 24.2890  16.7447  41.2729) ; O3* 
    #( 24.9420  19.2174  44.8923) ; N1  
    #( 25.2655  20.5636  44.8883) ; N3  
    #( 25.1663  21.2219  43.8561) ; C2  
    #( 25.6911  21.1219  46.0494) ; C4  
    #( 25.8051  20.4068  47.2048) ; C5  
    #( 26.2093  20.9962  48.2534) ; C6  
    rU
    #( 25.4692  19.0221  47.2053) ; O2  
    #( 25.0502  18.4827  46.0370) ; O4  
    #( 25.9599  22.1772  46.0966) ; H3  
    #( 25.5545  18.4409  48.1234) ; H5  
    #( 24.7854  17.4265  45.9883) ; H6  
  ))

(define rU08
  (nuc-const
    #( -0.0080  -0.7928   0.6094  ; dgf-base-tfo
       -0.7512   0.4071   0.5197
       -0.6601  -0.4536  -0.5988
       44.1482  30.7036   2.1088)
    #(  0.2765  -0.1121  -0.9545  ; P-O3*-275-tfo
       -0.8297   0.4733  -0.2959
        0.4850   0.8737   0.0379
      -14.7774 -45.2464  21.9088)
    #(  0.1063  -0.6334  -0.7665  ; P-O3*-180-tfo
       -0.5932  -0.6591   0.4624
       -0.7980   0.4055  -0.4458
       43.7634   4.3296  28.4890)
    #(  0.7136  -0.5032  -0.4873  ; P-O3*-60-tfo
        0.6803   0.3317   0.6536
       -0.1673  -0.7979   0.5791
      -17.1858  41.4390 -27.0751)
    #( 21.3880  15.0780  45.5770) ; P   
    #( 21.9980  14.5500  46.8210) ; O1P 
    #( 21.1450  14.0270  44.5420) ; O2P 
    #( 22.1250  16.3600  44.9460) ; O5* 
    #( 23.5096  16.1227  44.5783) ; C5* 
    #( 23.5649  15.8588  43.5222) ; H5* 
    #( 23.9621  15.4341  45.2919) ; H5**
    #( 24.2805  17.4138  44.7151) ; C4* 
    #( 25.3492  17.2309  44.6030) ; H4* 
    #( 23.8497  18.3471  43.7208) ; O4* 
    #( 23.4090  19.5681  44.3321) ; C1* 
    #( 24.2595  20.2496  44.3524) ; H1* 
    #( 23.0418  19.1813  45.7407) ; C2* 
    #( 22.0532  18.7224  45.7273) ; H2**
    #( 23.1307  20.2521  46.6291) ; O2* 
    #( 22.8888  21.1051  46.2611) ; H2* 
    #( 24.0799  18.1326  46.0700) ; C3* 
    #( 23.6490  17.4370  46.7900) ; H3* 
    #( 25.3329  18.7227  46.5109) ; O3* 
    #( 22.2515  20.1624  43.6698) ; N1  
    #( 22.4760  21.0609  42.6406) ; N3  
    #( 23.6229  21.3462  42.3061) ; C2  
    #( 21.3986  21.6081  42.0236) ; C4  
    #( 20.1189  21.3012  42.3804) ; C5  
    #( 19.1599  21.8516  41.7578) ; C6  
    rU
    #( 19.8919  20.3745  43.4387) ; O2  
    #( 20.9790  19.8423  44.0440) ; O4  
    #( 21.5235  22.3222  41.2097) ; H3  
    #( 18.8732  20.1200  43.7312) ; H5  
    #( 20.8545  19.1313  44.8608) ; H6  
  ))

(define rU09
  (nuc-const
    #( -0.0317   0.1374   0.9900  ; dgf-base-tfo
       -0.3422  -0.9321   0.1184
        0.9391  -0.3351   0.0765
      -32.1929  25.8198 -28.5088)
    #(  0.2765  -0.1121  -0.9545  ; P-O3*-275-tfo
       -0.8297   0.4733  -0.2959
        0.4850   0.8737   0.0379
      -14.7774 -45.2464  21.9088)
    #(  0.1063  -0.6334  -0.7665  ; P-O3*-180-tfo
       -0.5932  -0.6591   0.4624
       -0.7980   0.4055  -0.4458
       43.7634   4.3296  28.4890)
    #(  0.7136  -0.5032  -0.4873  ; P-O3*-60-tfo
        0.6803   0.3317   0.6536
       -0.1673  -0.7979   0.5791
      -17.1858  41.4390 -27.0751)
    #( 21.3880  15.0780  45.5770) ; P   
    #( 21.9980  14.5500  46.8210) ; O1P 
    #( 21.1450  14.0270  44.5420) ; O2P 
    #( 22.1250  16.3600  44.9460) ; O5* 
    #( 21.5037  16.8594  43.7323) ; C5* 
    #( 20.8147  17.6663  43.9823) ; H5* 
    #( 21.1086  16.0230  43.1557) ; H5**
    #( 22.5654  17.4874  42.8616) ; C4* 
    #( 23.0565  18.3036  43.3915) ; H4* 
    #( 23.5375  16.5054  42.4925) ; O4* 
    #( 23.6574  16.4257  41.0649) ; C1* 
    #( 24.4701  17.0882  40.7671) ; H1* 
    #( 22.3525  16.9643  40.5396) ; C2* 
    #( 21.5993  16.1799  40.6133) ; H2**
    #( 22.4693  17.4849  39.2515) ; O2* 
    #( 23.0899  17.0235  38.6827) ; H2* 
    #( 22.0341  18.0633  41.5279) ; C3* 
    #( 20.9509  18.1709  41.5846) ; H3* 
    #( 22.7249  19.3020  41.2100) ; O3* 
    #( 23.8580  15.0648  40.5757) ; N1  
    #( 25.1556  14.5982  40.4523) ; N3  
    #( 26.1047  15.3210  40.7448) ; C2  
    #( 25.3391  13.3315  40.0020) ; C4  
    #( 24.2974  12.5148  39.6749) ; C5  
    #( 24.5450  11.3410  39.2610) ; C6  
    rU
    #( 22.9633  12.9979  39.8053) ; O2  
    #( 22.8009  14.2648  40.2524) ; O4  
    #( 26.3414  12.9194  39.8855) ; H3  
    #( 22.1227  12.3533  39.5486) ; H5  
    #( 21.7989  14.6788  40.3650) ; H6  
  ))

(define rU10
  (nuc-const
    #( -0.9674   0.1021  -0.2318  ; dgf-base-tfo
       -0.2514  -0.2766   0.9275
        0.0306   0.9555   0.2933
       27.8571 -42.1305 -24.4563)
    #(  0.2765  -0.1121  -0.9545  ; P-O3*-275-tfo
       -0.8297   0.4733  -0.2959
        0.4850   0.8737   0.0379
      -14.7774 -45.2464  21.9088)
    #(  0.1063  -0.6334  -0.7665  ; P-O3*-180-tfo
       -0.5932  -0.6591   0.4624
       -0.7980   0.4055  -0.4458
       43.7634   4.3296  28.4890)
    #(  0.7136  -0.5032  -0.4873  ; P-O3*-60-tfo
        0.6803   0.3317   0.6536
       -0.1673  -0.7979   0.5791
      -17.1858  41.4390 -27.0751)
    #( 21.3880  15.0780  45.5770) ; P   
    #( 21.9980  14.5500  46.8210) ; O1P 
    #( 21.1450  14.0270  44.5420) ; O2P 
    #( 22.1250  16.3600  44.9460) ; O5* 
    #( 23.5096  16.1227  44.5783) ; C5* 
    #( 23.5649  15.8588  43.5222) ; H5* 
    #( 23.9621  15.4341  45.2919) ; H5**
    #( 24.2805  17.4138  44.7151) ; C4* 
    #( 23.8509  18.1819  44.0720) ; H4* 
    #( 24.2506  17.8583  46.0741) ; O4* 
    #( 25.5830  18.0320  46.5775) ; C1* 
    #( 25.8569  19.0761  46.4256) ; H1* 
    #( 26.4410  17.1555  45.7033) ; C2* 
    #( 26.3459  16.1253  46.0462) ; H2**
    #( 27.7649  17.5888  45.6478) ; O2* 
    #( 28.1004  17.9719  46.4616) ; H2* 
    #( 25.7796  17.2997  44.3513) ; C3* 
    #( 25.9478  16.3824  43.7871) ; H3* 
    #( 26.2154  18.4984  43.6541) ; O3* 
    #( 25.7321  17.6281  47.9726) ; N1  
    #( 25.5136  18.5779  48.9560) ; N3  
    #( 25.2079  19.7276  48.6503) ; C2  
    #( 25.6482  18.1987  50.2518) ; C4  
    #( 25.9847  16.9266  50.6092) ; C5  
    #( 26.0918  16.6439  51.8416) ; C6  
    rU
    #( 26.2067  15.9515  49.5943) ; O2  
    #( 26.0713  16.3497  48.3080) ; O4  
    #( 25.4890  18.9105  51.0618) ; H3  
    #( 26.4742  14.9310  49.8682) ; H5  
    #( 26.2346  15.6394  47.4975) ; H6  
  ))

(define rUs
  (list rU01 rU02 rU03 rU04 rU05 rU06 rU07 rU08 rU09 rU10))

(define rG*
  (nuc-const
    #( -0.2067  -0.0264   0.9780  ; dgf-base-tfo
        0.9770  -0.0586   0.2049
        0.0519   0.9979   0.0379
        1.0331 -46.8078 -36.4742)
    #( -0.8644  -0.4956  -0.0851  ; P-O3*-275-tfo
       -0.0427   0.2409  -0.9696
        0.5010  -0.8345  -0.2294
        4.0167  54.5377  12.4779)
    #(  0.3706  -0.6167   0.6945  ; P-O3*-180-tfo
       -0.2867  -0.7872  -0.5460
        0.8834   0.0032  -0.4686
      -52.9020  18.6313  -0.6709)
    #(  0.4155   0.9025  -0.1137  ; P-O3*-60-tfo
        0.9040  -0.4236  -0.0582
       -0.1007  -0.0786  -0.9918
       -7.6624 -25.2080  49.5181)
    #( 31.3810   0.1400  47.5810) ; P   
    #( 29.9860   0.6630  47.6290) ; O1P 
    #( 31.7210  -0.6460  48.8090) ; O2P 
    #( 32.4940   1.2540  47.2740) ; O5* 
    #( 32.1610   2.2370  46.2560) ; C5* 
    #( 31.2986   2.8190  46.5812) ; H5* 
    #( 32.0980   1.7468  45.2845) ; H5**
    #( 33.3476   3.1959  46.1947) ; C4* 
    #( 33.2668   3.8958  45.3630) ; H4* 
    #( 33.3799   3.9183  47.4216) ; O4* 
    #( 34.6515   3.7222  48.0398) ; C1* 
    #( 35.2947   4.5412  47.7180) ; H1* 
    #( 35.1756   2.4228  47.4827) ; C2* 
    #( 34.6778   1.5937  47.9856) ; H2**
    #( 36.5631   2.2672  47.4798) ; O2* 
    #( 37.0163   2.6579  48.2305) ; H2* 
    #( 34.6953   2.5043  46.0448) ; C3* 
    #( 34.5444   1.4917  45.6706) ; H3* 
    #( 35.6679   3.3009  45.3487) ; O3* 
    #( 37.4804   4.0914  52.2559) ; N1  
    #( 36.9670   4.1312  49.9281) ; N3  
    #( 37.8045   4.2519  50.9550) ; C2  
    #( 35.7171   3.8264  50.3222) ; C4  
    #( 35.2668   3.6420  51.6115) ; C5  
    #( 36.2037   3.7829  52.6706) ; C6  
    rG
    #( 39.0869   4.5552  50.7092) ; N2  
    #( 33.9075   3.3338  51.6102) ; N7  
    #( 34.6126   3.6358  49.5108) ; N9  
    #( 33.5805   3.3442  50.3425) ; C8  
    #( 35.9958   3.6512  53.8724) ; O6  
    #( 38.2106   4.2053  52.9295) ; H1  
    #( 39.8218   4.6863  51.3896) ; H21 
    #( 39.3420   4.6857  49.7407) ; H22 
    #( 32.5194   3.1070  50.2664) ; H8  
  ))

(define rU*
  (nuc-const
    #( -0.0109   0.5907   0.8068  ; dgf-base-tfo
        0.2217  -0.7853   0.5780
        0.9751   0.1852  -0.1224
       -1.4225 -11.0956  -2.5217)
    #( -0.8313  -0.4738  -0.2906  ; P-O3*-275-tfo
        0.0649   0.4366  -0.8973
        0.5521  -0.7648  -0.3322
        1.6833   6.8060  -7.0011)
    #(  0.3445  -0.7630   0.5470  ; P-O3*-180-tfo
       -0.4628  -0.6450  -0.6082
        0.8168  -0.0436  -0.5753
       -6.8179  -3.9778  -5.9887)
    #(  0.5855   0.7931  -0.1682  ; P-O3*-60-tfo
        0.8103  -0.5790   0.0906
       -0.0255  -0.1894  -0.9816
        6.1203  -7.1051   3.1984)
    #(  2.6760  -8.4960   3.2880) ; P   
    #(  1.4950  -7.6230   3.4770) ; O1P 
    #(  2.9490  -9.4640   4.3740) ; O2P 
    #(  3.9730  -7.5950   3.0340) ; O5* 
    #(  5.2430  -8.2420   2.8260) ; C5* 
    #(  5.1974  -8.8497   1.9223) ; H5* 
    #(  5.5548  -8.7348   3.7469) ; H5**
    #(  6.3140  -7.2060   2.5510) ; C4* 
    #(  5.8744  -6.2116   2.4731) ; H4* 
    #(  7.2798  -7.2260   3.6420) ; O4* 
    #(  8.5733  -6.9410   3.1329) ; C1* 
    #(  8.9047  -6.0374   3.6446) ; H1* 
    #(  8.4429  -6.6596   1.6327) ; C2* 
    #(  9.2880  -7.1071   1.1096) ; H2**
    #(  8.2502  -5.2799   1.4754) ; O2* 
    #(  8.7676  -4.7284   2.0667) ; H2* 
    #(  7.1642  -7.4416   1.3021) ; C3* 
    #(  7.4125  -8.5002   1.2260) ; H3* 
    #(  6.5160  -6.9772   0.1267) ; O3* 
    #(  9.4531  -8.1107   3.4087) ; N1  
    #( 11.5931  -9.0015   3.6357) ; N3  
    #( 10.8101  -7.8950   3.3748) ; C2  
    #( 11.1439 -10.2744   3.9206) ; C4  
    #(  9.7056 -10.4026   3.9332) ; C5  
    #(  8.9192  -9.3419   3.6833) ; C6  
    rU
    #( 11.3013  -6.8063   3.1326) ; O2  
    #( 11.9431 -11.1876   4.1375) ; O4  
    #( 12.5840  -8.8673   3.6158) ; H3  
    #(  9.2891 -11.2898   4.1313) ; H5  
    #(  7.9263  -9.4537   3.6977) ; H6  
  ))



; -- PARTIAL INSTANTIATIONS ---------------------------------------------------

(define (make-var id tfo nuc)
  (vector id tfo nuc))

(define (var-id var) (vector-ref var 0))
(define (var-id-set! var val) (vector-set! var 0 val))
(define (var-tfo var) (vector-ref var 1))
(define (var-tfo-set! var val) (vector-set! var 1 val))
(define (var-nuc var) (vector-ref var 2))
(define (var-nuc-set! var val) (vector-set! var 2 val))

(define (atom-pos atom var)
  (tfo-apply (var-tfo var) (atom (var-nuc var))))

(define (get-var id lst)
  (let ((v (car lst)))
    (if (= id (var-id v))
      v
      (get-var id (cdr lst)))))

(define (make-relative-nuc tfo n)
  (cond ((rA? n)
         (make-rA
           (nuc-dgf-base-tfo  n)
           (nuc-P-O3*-275-tfo n)
           (nuc-P-O3*-180-tfo n)
           (nuc-P-O3*-60-tfo  n)
           (tfo-apply tfo (nuc-P    n))
           (tfo-apply tfo (nuc-O1P  n))
           (tfo-apply tfo (nuc-O2P  n))
           (tfo-apply tfo (nuc-O5*  n))
           (tfo-apply tfo (nuc-C5*  n))
           (tfo-apply tfo (nuc-H5*  n))
           (tfo-apply tfo (nuc-H5** n))
           (tfo-apply tfo (nuc-C4*  n))
           (tfo-apply tfo (nuc-H4*  n))
           (tfo-apply tfo (nuc-O4*  n))
           (tfo-apply tfo (nuc-C1*  n))
           (tfo-apply tfo (nuc-H1*  n))
           (tfo-apply tfo (nuc-C2*  n))
           (tfo-apply tfo (nuc-H2** n))
           (tfo-apply tfo (nuc-O2*  n))
           (tfo-apply tfo (nuc-H2*  n))
           (tfo-apply tfo (nuc-C3*  n))
           (tfo-apply tfo (nuc-H3*  n))
           (tfo-apply tfo (nuc-O3*  n))
           (tfo-apply tfo (nuc-N1   n))
           (tfo-apply tfo (nuc-N3   n))
           (tfo-apply tfo (nuc-C2   n))
           (tfo-apply tfo (nuc-C4   n))
           (tfo-apply tfo (nuc-C5   n))
           (tfo-apply tfo (nuc-C6   n))
           (tfo-apply tfo (rA-N6    n))
           (tfo-apply tfo (rA-N7    n))
           (tfo-apply tfo (rA-N9    n))
           (tfo-apply tfo (rA-C8    n))
           (tfo-apply tfo (rA-H2    n))
           (tfo-apply tfo (rA-H61   n))
           (tfo-apply tfo (rA-H62   n))
           (tfo-apply tfo (rA-H8    n))))
        ((rC? n)
         (make-rC
           (nuc-dgf-base-tfo  n)
           (nuc-P-O3*-275-tfo n)
           (nuc-P-O3*-180-tfo n)
           (nuc-P-O3*-60-tfo  n)
           (tfo-apply tfo (nuc-P    n))
           (tfo-apply tfo (nuc-O1P  n))
           (tfo-apply tfo (nuc-O2P  n))
           (tfo-apply tfo (nuc-O5*  n))
           (tfo-apply tfo (nuc-C5*  n))
           (tfo-apply tfo (nuc-H5*  n))
           (tfo-apply tfo (nuc-H5** n))
           (tfo-apply tfo (nuc-C4*  n))
           (tfo-apply tfo (nuc-H4*  n))
           (tfo-apply tfo (nuc-O4*  n))
           (tfo-apply tfo (nuc-C1*  n))
           (tfo-apply tfo (nuc-H1*  n))
           (tfo-apply tfo (nuc-C2*  n))
           (tfo-apply tfo (nuc-H2** n))
           (tfo-apply tfo (nuc-O2*  n))
           (tfo-apply tfo (nuc-H2*  n))
           (tfo-apply tfo (nuc-C3*  n))
           (tfo-apply tfo (nuc-H3*  n))
           (tfo-apply tfo (nuc-O3*  n))
           (tfo-apply tfo (nuc-N1   n))
           (tfo-apply tfo (nuc-N3   n))
           (tfo-apply tfo (nuc-C2   n))
           (tfo-apply tfo (nuc-C4   n))
           (tfo-apply tfo (nuc-C5   n))
           (tfo-apply tfo (nuc-C6   n))
           (tfo-apply tfo (rC-N4    n))
           (tfo-apply tfo (rC-O2    n))
           (tfo-apply tfo (rC-H41   n))
           (tfo-apply tfo (rC-H42   n))
           (tfo-apply tfo (rC-H5    n))
           (tfo-apply tfo (rC-H6    n))))
        ((rG? n)
         (make-rG
           (nuc-dgf-base-tfo  n)
           (nuc-P-O3*-275-tfo n)
           (nuc-P-O3*-180-tfo n)
           (nuc-P-O3*-60-tfo  n)
           (tfo-apply tfo (nuc-P    n))
           (tfo-apply tfo (nuc-O1P  n))
           (tfo-apply tfo (nuc-O2P  n))
           (tfo-apply tfo (nuc-O5*  n))
           (tfo-apply tfo (nuc-C5*  n))
           (tfo-apply tfo (nuc-H5*  n))
           (tfo-apply tfo (nuc-H5** n))
           (tfo-apply tfo (nuc-C4*  n))
           (tfo-apply tfo (nuc-H4*  n))
           (tfo-apply tfo (nuc-O4*  n))
           (tfo-apply tfo (nuc-C1*  n))
           (tfo-apply tfo (nuc-H1*  n))
           (tfo-apply tfo (nuc-C2*  n))
           (tfo-apply tfo (nuc-H2** n))
           (tfo-apply tfo (nuc-O2*  n))
           (tfo-apply tfo (nuc-H2*  n))
           (tfo-apply tfo (nuc-C3*  n))
           (tfo-apply tfo (nuc-H3*  n))
           (tfo-apply tfo (nuc-O3*  n))
           (tfo-apply tfo (nuc-N1   n))
           (tfo-apply tfo (nuc-N3   n))
           (tfo-apply tfo (nuc-C2   n))
           (tfo-apply tfo (nuc-C4   n))
           (tfo-apply tfo (nuc-C5   n))
           (tfo-apply tfo (nuc-C6   n))
           (tfo-apply tfo (rG-N2    n))
           (tfo-apply tfo (rG-N7    n))
           (tfo-apply tfo (rG-N9    n))
           (tfo-apply tfo (rG-C8    n))
           (tfo-apply tfo (rG-O6    n))
           (tfo-apply tfo (rG-H1    n))
           (tfo-apply tfo (rG-H21   n))
           (tfo-apply tfo (rG-H22   n))
           (tfo-apply tfo (rG-H8    n))))
        (else
         (make-rU
           (nuc-dgf-base-tfo  n)
           (nuc-P-O3*-275-tfo n)
           (nuc-P-O3*-180-tfo n)
           (nuc-P-O3*-60-tfo  n)
           (tfo-apply tfo (nuc-P    n))
           (tfo-apply tfo (nuc-O1P  n))
           (tfo-apply tfo (nuc-O2P  n))
           (tfo-apply tfo (nuc-O5*  n))
           (tfo-apply tfo (nuc-C5*  n))
           (tfo-apply tfo (nuc-H5*  n))
           (tfo-apply tfo (nuc-H5** n))
           (tfo-apply tfo (nuc-C4*  n))
           (tfo-apply tfo (nuc-H4*  n))
           (tfo-apply tfo (nuc-O4*  n))
           (tfo-apply tfo (nuc-C1*  n))
           (tfo-apply tfo (nuc-H1*  n))
           (tfo-apply tfo (nuc-C2*  n))
           (tfo-apply tfo (nuc-H2** n))
           (tfo-apply tfo (nuc-O2*  n))
           (tfo-apply tfo (nuc-H2*  n))
           (tfo-apply tfo (nuc-C3*  n))
           (tfo-apply tfo (nuc-H3*  n))
           (tfo-apply tfo (nuc-O3*  n))
           (tfo-apply tfo (nuc-N1   n))
           (tfo-apply tfo (nuc-N3   n))
           (tfo-apply tfo (nuc-C2   n))
           (tfo-apply tfo (nuc-C4   n))
           (tfo-apply tfo (nuc-C5   n))
           (tfo-apply tfo (nuc-C6   n))
           (tfo-apply tfo (rU-O2    n))
           (tfo-apply tfo (rU-O4    n))
           (tfo-apply tfo (rU-H3    n))
           (tfo-apply tfo (rU-H5    n))
           (tfo-apply tfo (rU-H6    n))))))

; -- SEARCH -------------------------------------------------------------------

; Sequential backtracking algorithm

(define (search partial-inst domains constraint?)
  (if (null? domains)
    (list partial-inst)
    (let ((remaining-domains (cdr domains)))

      (define (try-assignments lst)
        (if (null? lst)
          '()
          (let ((var (car lst)))
            (if (constraint? var partial-inst)
              (let* ((subsols1
                       (search
                         (cons var partial-inst)
                         remaining-domains
                         constraint?))
                     (subsols2
                       (try-assignments (cdr lst))))
                (append subsols1 subsols2))
              (try-assignments (cdr lst))))))

      (try-assignments ((car domains) partial-inst)))))

; -- DOMAINS ------------------------------------------------------------------

; Primary structure:   strand A CUGCCACGUCUG, strand B CAGACGUGGCAG
;
; Secondary structure: strand A CUGCCACGUCUG
;                               ||||||||||||
;                               GACGGUGCAGAC strand B
;
; Tertiary structure:
;
;    5' end of strand A C1----G12 3' end of strand B
;                     U2-------A11
;                    G3-------C10
;                    C4-----G9
;                     C5---G8
;                        A6
;                      G6-C7
;                     C5----G8
;                    A4-------U9
;                    G3--------C10
;                     A2-------U11
;   5' end of strand B C1----G12 3' end of strand A
;
; "helix", "stacked" and "connected" describe the spatial relationship
; between two consecutive nucleotides. E.g. the nucleotides C1 and U2
; from the strand A.
;
; "wc" (stands for Watson-Crick and is a type of base-pairing),
; and "wc-dumas" describe the spatial relationship between 
; nucleotides from two chains that are growing in opposite directions.
; E.g. the nucleotides C1 from strand A and G12 from strand B.

; Dynamic Domains

; Given,
;   "ref" a nucleotide which is already positioned,
;   "nuc" the nucleotide to be placed,
;   and "tfo" a transformation matrix which expresses the desired
;   relationship between "ref" and "nuc",
; the function "dgf-base" computes the transformation matrix that
; places the nucleotide "nuc" in the given relationship to "ref".

(define (dgf-base tfo ref nuc)
  (let* ((ref-nuc (var-nuc ref))
         (align
          (tfo-inv-ortho
            (cond ((rA? ref-nuc)
                   (tfo-align (atom-pos nuc-C1* ref)
                              (atom-pos rA-N9   ref)
                              (atom-pos nuc-C4  ref)))
                  ((rC? ref-nuc)
                   (tfo-align (atom-pos nuc-C1* ref)
                              (atom-pos nuc-N1  ref)
                              (atom-pos nuc-C2  ref)))
                  ((rG? ref-nuc)
                   (tfo-align (atom-pos nuc-C1* ref)
                              (atom-pos rG-N9   ref)
                              (atom-pos nuc-C4  ref)))
                  (else
                   (tfo-align (atom-pos nuc-C1* ref)
                              (atom-pos nuc-N1  ref)
                              (atom-pos nuc-C2  ref)))))))
    (tfo-combine (nuc-dgf-base-tfo nuc)
                 (tfo-combine tfo align))))

; Placement of first nucleotide.

(define (reference nuc i)
  (lambda (partial-inst)
    (list (make-var i tfo-id nuc))))

; The transformation matrix for wc is from:
;
; Chandrasekaran R. et al (1989) A Re-Examination of the Crystal
; Structure of A-DNA Using Fiber Diffraction Data. J. Biomol.
; Struct. & Dynamics 6(6):1189-1202.

(define wc-tfo
  (FLOATvector-const
     -1.0000  0.0028 -0.0019
      0.0028  0.3468 -0.9379
     -0.0019 -0.9379 -0.3468
     -0.0080  6.0730  8.7208))

(define (wc nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base wc-tfo ref nuc)))
      (list (make-var i tfo nuc)))))

(define wc-Dumas-tfo
  (FLOATvector-const
     -0.9737 -0.1834  0.1352
     -0.1779  0.2417 -0.9539
      0.1422 -0.9529 -0.2679
      0.4837  6.2649  8.0285))
         
(define (wc-Dumas nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base wc-Dumas-tfo ref nuc)))
      (list (make-var i tfo nuc)))))

(define helix5*-tfo
  (FLOATvector-const
      0.9886 -0.0961  0.1156
      0.1424  0.8452 -0.5152
     -0.0482  0.5258  0.8492
     -3.8737  0.5480  3.8024))

(define (helix5* nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base helix5*-tfo ref nuc)))
      (list (make-var i tfo nuc)))))

(define helix3*-tfo
  (FLOATvector-const
      0.9886  0.1424 -0.0482
     -0.0961  0.8452  0.5258
      0.1156 -0.5152  0.8492
      3.4426  2.0474 -3.7042))

(define (helix3* nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base helix3*-tfo ref nuc)))
      (list (make-var i tfo nuc)))))

(define G37-A38-tfo
  (FLOATvector-const
      0.9991  0.0164 -0.0387
     -0.0375  0.7616 -0.6470
      0.0189  0.6478  0.7615
     -3.3018  0.9975  2.5585))

(define (G37-A38 nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base G37-A38-tfo ref nuc)))
      (make-var i tfo nuc))))

(define (stacked5* nuc i j)
  (lambda (partial-inst)
    (cons ((G37-A38 nuc i j) partial-inst)
          ((helix5* nuc i j) partial-inst))))

(define A38-G37-tfo
  (FLOATvector-const
      0.9991 -0.0375  0.0189
      0.0164  0.7616  0.6478 
     -0.0387 -0.6470  0.7615
      3.3819  0.7718 -2.5321))

(define (A38-G37 nuc i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (tfo (dgf-base A38-G37-tfo ref nuc)))
      (make-var i tfo nuc))))
   
(define (stacked3* nuc i j)
  (lambda (partial-inst)
    (cons ((A38-G37 nuc i j) partial-inst)
          ((helix3* nuc i j) partial-inst))))

(define (P-O3* nucs i j)
  (lambda (partial-inst)
    (let* ((ref (get-var j partial-inst))
           (align
             (tfo-inv-ortho
               (tfo-align (atom-pos nuc-O3* ref)
                          (atom-pos nuc-C3* ref)
                          (atom-pos nuc-C4* ref)))))
      (let loop ((lst nucs) (domains '()))
        (if (null? lst)
          domains
          (let ((nuc (car lst)))
            (let ((tfo-60 (tfo-combine (nuc-P-O3*-60-tfo nuc) align))
                  (tfo-180 (tfo-combine (nuc-P-O3*-180-tfo nuc) align))
                  (tfo-275 (tfo-combine (nuc-P-O3*-275-tfo nuc) align)))
              (loop (cdr lst)
                    (cons (make-var i tfo-60 nuc)
                          (cons (make-var i tfo-180 nuc)
                                (cons (make-var i tfo-275 nuc) domains)))))))))))

; -- PROBLEM STATEMENT --------------------------------------------------------

; Define anticodon problem -- Science 253:1255 Figure 3a, 3b and 3c

(define anticodon-domains
  (list 
   (reference rC  27   )
   (helix5*   rC  28 27)
   (helix5*   rA  29 28)
   (helix5*   rG  30 29)
   (helix5*   rA  31 30)
   (wc        rU  39 31)
   (helix5*   rC  40 39)
   (helix5*   rU  41 40)
   (helix5*   rG  42 41)
   (helix5*   rG  43 42)
   (stacked3* rA  38 39)
   (stacked3* rG  37 38)
   (stacked3* rA  36 37)
   (stacked3* rA  35 36)
   (stacked3* rG  34 35);<-. Distance
   (P-O3*     rCs 32 31);  | Constraint
   (P-O3*     rUs 33 32);<-' 3.0 Angstroms
   ))

; Anticodon constraint

(define (anticodon-constraint? v partial-inst)
  (if (= (var-id v) 33)
    (let ((p   (atom-pos nuc-P (get-var 34 partial-inst))) ; P in nucleotide 34
          (o3* (atom-pos nuc-O3* v)))                      ; O3' in nucl. 33
      (FLOAT<= (pt-dist p o3*) 3.0))                       ; check distance
    #t))

(define (anticodon)
  (search '() anticodon-domains anticodon-constraint?))

; Define pseudoknot problem -- Science 253:1255 Figure 4a and 4b

(define pseudoknot-domains
  (list
   (reference rA  23   )
   (wc-Dumas  rU   8 23)
   (helix3*   rG  22 23)
   (wc-Dumas  rC   9 22)
   (helix3*   rG  21 22)
   (wc-Dumas  rC  10 21)
   (helix3*   rC  20 21)
   (wc-Dumas  rG  11 20)
   (helix3*   rU* 19 20);<-.
   (wc-Dumas  rA  12 19);  | Distance
;                       ;  | Constraint
; Helix 1               ;  | 4.0 Angstroms
   (helix3*   rC   3 19);  |
   (wc-Dumas  rG  13  3);  |
   (helix3*   rC   2  3);  |
   (wc-Dumas  rG  14  2);  |
   (helix3*   rC   1  2);  |
   (wc-Dumas  rG* 15  1);  |
;                       ;  |
; L2 LOOP               ;  |
   (P-O3*     rUs 16 15);  |
   (P-O3*     rCs 17 16);  |
   (P-O3*     rAs 18 17);<-'
;
; L1 LOOP
   (helix3*   rU   7  8);<-.
   (P-O3*     rCs  4  3);  | Constraint
   (stacked5* rU   5  4);  | 4.5 Angstroms
   (stacked5* rC   6  5);<-'
   ))
  
; Pseudoknot constraint

(define (pseudoknot-constraint? v partial-inst)
  (case (var-id v)
    ((18)
     (let ((p   (atom-pos nuc-P (get-var 19 partial-inst)))
           (o3* (atom-pos nuc-O3* v)))
       (FLOAT<= (pt-dist p o3*) 4.0)))
    ((6)
     (let ((p   (atom-pos nuc-P (get-var 7 partial-inst)))
           (o3* (atom-pos nuc-O3* v)))
       (FLOAT<= (pt-dist p o3*) 4.5)))
    (else
     #t)))

(define (pseudoknot)
  (search '() pseudoknot-domains pseudoknot-constraint?))

; -- TESTING -----------------------------------------------------------------

(define (list-of-atoms n)
  (append (list-of-common-atoms n)
          (list-of-specific-atoms n)))

(define (list-of-common-atoms n)
  (list
    (nuc-P    n)
    (nuc-O1P  n)
    (nuc-O2P  n)
    (nuc-O5*  n)
    (nuc-C5*  n)
    (nuc-H5*  n)
    (nuc-H5** n)
    (nuc-C4*  n)
    (nuc-H4*  n)
    (nuc-O4*  n)
    (nuc-C1*  n)
    (nuc-H1*  n)
    (nuc-C2*  n)
    (nuc-H2** n)
    (nuc-O2*  n)
    (nuc-H2*  n)
    (nuc-C3*  n)
    (nuc-H3*  n)
    (nuc-O3*  n)
    (nuc-N1   n)
    (nuc-N3   n)
    (nuc-C2   n)
    (nuc-C4   n)
    (nuc-C5   n)
    (nuc-C6   n)))

(define (list-of-specific-atoms n)
  (cond ((rA? n)
         (list
           (rA-N6   n)
           (rA-N7   n)
           (rA-N9   n)
           (rA-C8   n)
           (rA-H2   n)
           (rA-H61  n)
           (rA-H62  n)
           (rA-H8   n)))
        ((rC? n)
         (list
           (rC-N4   n)
           (rC-O2   n)
           (rC-H41  n)
           (rC-H42  n)
           (rC-H5   n)
           (rC-H6   n)))
        ((rG? n)
         (list
           (rG-N2   n)
           (rG-N7   n)
           (rG-N9   n)
           (rG-C8   n)
           (rG-O6   n)
           (rG-H1   n)
           (rG-H21  n)
           (rG-H22  n)
           (rG-H8   n)))
        (else
         (list
           (rU-O2   n)
           (rU-O4   n)
           (rU-H3   n)
           (rU-H5   n)
           (rU-H6   n)))))

(define (var-most-distant-atom v)

  (define (distance pos)
    (let ((abs-pos (tfo-apply (var-tfo v) pos)))
      (let ((x (pt-x abs-pos)) (y (pt-y abs-pos)) (z (pt-z abs-pos)))
        (FLOATsqrt (FLOAT+ (FLOAT* x x) (FLOAT* y y) (FLOAT* z z))))))

  (maximum (map distance (list-of-atoms (var-nuc v)))))

(define (sol-most-distant-atom s)
  (maximum (map var-most-distant-atom s)))

(define (most-distant-atom sols)
  (maximum (map sol-most-distant-atom sols)))

(define (maximum lst)
  (let loop ((m (car lst)) (l (cdr lst)))
    (if (null? l)
      m
      (let ((x (car l)))
        (loop (if (FLOAT> x m) x m) (cdr l))))))

(define (run)
  (most-distant-atom (pseudoknot)))

(define (main . args)
  (run-benchmark
    "nucleic"
    nucleic-iters
    (lambda (result)
      (and (number? result)
           (let ((x (FLOAT/ result 33.797594890762724)))
             (and (FLOAT> x 0.999999) (FLOAT< x 1.000001)))))
    (lambda () (lambda () (run)))))
