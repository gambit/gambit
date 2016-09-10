;;; FFT - Fast Fourier Transform, translated from "Numerical Recipes in C"

(define (four1 data)
  (let ((n (FLOATvector-length data))
        (pi*2 6.28318530717959)) ; to compute the inverse, negate this value

    ; bit-reversal section

    (let loop1 ((i 0) (j 0))
      (if (< i n)
        (begin
          (if (< i j)
            (begin
              (let ((temp (FLOATvector-ref data i)))
                (FLOATvector-set! data i (FLOATvector-ref data j))
                (FLOATvector-set! data j temp))
              (let ((temp (FLOATvector-ref data (+ i 1))))
                (FLOATvector-set! data (+ i 1) (FLOATvector-ref data (+ j 1)))
                (FLOATvector-set! data (+ j 1) temp))))
          (let loop2 ((m (quotient n 2)) (j j))
            (if (and (>= m 2) (>= j m))
              (loop2 (quotient m 2) (- j m))
              (loop1 (+ i 2) (+ j m)))))))

    ; Danielson-Lanczos section

    (let loop3 ((mmax 2))
      (if (< mmax n)
        (let* ((theta
                (FLOAT/ pi*2 (exact->inexact mmax)))
               (wpr
                (let ((x (FLOATsin (FLOAT* 0.5 theta))))
                  (FLOAT* -2.0 (FLOAT* x x))))
               (wpi
                (FLOATsin theta)))
          (let loop4 ((wr 1.0) (wi 0.0) (m 0))
            (if (< m mmax)
              (begin
                (let loop5 ((i m))
                  (if (< i n)
                    (let* ((j
                            (+ i mmax))
                           (tempr
                            (FLOAT-
                              (FLOAT* wr (FLOATvector-ref data j))
                              (FLOAT* wi (FLOATvector-ref data (+ j 1)))))
                           (tempi
                            (FLOAT+
                              (FLOAT* wr (FLOATvector-ref data (+ j 1)))
                              (FLOAT* wi (FLOATvector-ref data j)))))
                      (FLOATvector-set! data j
                        (FLOAT- (FLOATvector-ref data i) tempr))
                      (FLOATvector-set! data (+ j 1)
                        (FLOAT- (FLOATvector-ref data (+ i 1)) tempi))
                      (FLOATvector-set! data i
                        (FLOAT+ (FLOATvector-ref data i) tempr))
                      (FLOATvector-set! data (+ i 1)
                        (FLOAT+ (FLOATvector-ref data (+ i 1)) tempi))
                      (loop5 (+ j mmax)));***))
                (loop4 (FLOAT+ (FLOAT- (FLOAT* wr wpr) (FLOAT* wi wpi)) wr)
                       (FLOAT+ (FLOAT+ (FLOAT* wi wpr) (FLOAT* wr wpi)) wi)
                       (+ m 2)))))
));******
          (loop3 (* mmax 2)))))))

(define data
  (FLOATmake-vector 1024 0.0))
 
(define (run data)
  (four1 data)
  (FLOATvector-ref data 0))

(define (main . args)
  (run-benchmark
    "fft"
    fft-iters
    (lambda (result) (equal? result 0.0))
    (lambda (data) (lambda () (run data)))
    data))
