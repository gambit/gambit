'(;;;;;;;;;;;;;;;;;
(define (make-source code locat)
  (vector code
          (vector-ref locat 0)
          (vector-ref locat 1)))

(define (source-code x)
  (vector-ref x 0))

(define (source-locat x)
  (vector (vector-ref x 1)
          (vector-ref x 2)))
)

(define (make-source code locat)
  (##make-source code locat))

(define (source-code x)
  (##source-code x))

(define (source-locat x)
  (##source-locat x))
