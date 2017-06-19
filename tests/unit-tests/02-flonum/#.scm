(include "../#.scm")

;;; We're going to compare two functional results, so we need a new
;;; epsilon

(set! epsilon 1e-12)

;;; naive definitions of hyperbolic functions from
;;; Will Clinger's SRFI-144 implementation.

(define (flsinh-144 x)
  (##fl/ (##fl- (##flexp x) (##flexp (##fl- x))) 2.0))

(define (flcosh-144 x)
  (##fl/ (##fl+ (##flexp x) (##flexp (##fl- x))) 2.0))

(define (fltanh-144 x)
  (##fl/ (flsinh-144 x) (flcosh-144 x)))

(define (flasinh-144 x)
  (##fllog (##fl+ x (##flsqrt (##fl+ (##fl* x x) 1.0)))))

(define (flacosh-144 x)
  (##fllog (##fl+ x (##flsqrt (##fl- (##fl* x x) 1.0)))))

(define (flatanh-144 x)
  (##fl* 0.5 (##fllog (##fl/ (##fl+ 1.0 x) (##fl- 1.0 x)))))
