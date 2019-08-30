
(define-library (example grid)
  (export make rows cols ref each
          (rename put! set!))

  (import (scheme base))

  (begin
    ;; Create an NxM grid.
    (define (make n m)
      (let ((grid (make-vector n)))
        (do ((i 0 (+ i 1)))
            ((= i n) grid)
          (let ((v (make-vector m #f)))
            (vector-set! grid i v)))))

    (define (rows grid)
      (vector-length grid))

    (define (cols grid)
      (vector-length (vector-ref grid 0)))

    ;; Return #f if out of range.
    (define (ref grid n m)
      (and (< -1 n (rows grid))
           (< -1 m (cols grid))
           (vector-ref (vector-ref grid n) m)))

    (define (put! grid n m v)
      (vector-set! (vector-ref grid n) m v))

    (define (each grid proc)
      (do ((j 0 (+ j 1)))
          ((= j (rows grid)))
        (do ((k 0 (+ k 1)))
            ((= k (cols grid)))
          (proc j k (ref grid j k)))))))
