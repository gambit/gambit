
(define-library (example life)
  
  (export life)

  (import (except (scheme base) when set!) ;; when not implemented in gambit.
          (only (scheme thread) thread-sleep!)
          (only (when-unless) when)
          (scheme write)
          (example grid))

  (begin
    (define (life-count grid i j)

      (define (count i j)
        (if (ref grid i j) 1 0))

      (+ (count (- i 1) (- j 1))
         (count (- i 1) j)
         (count (- i 1) (+ j 1))
         (count i (- j 1))
         (count i (+ j 1))
         (count (+ i 1) (- j 1))
         (count (+ i 1) j)
         (count (+ i 1) (+ j 1))))

    (define (life-alive? grid i j)
      (case (life-count grid i j)
        ((3) #t)
        ((2) (ref grid i j))
        (else #f)))

    (define (life-print grid)
      (display "\x1B;[1H\x1B;[J") ; clear vt100
      (each grid
            (lambda (i j v)
              (display (if v "*" " "))
              (when (= j (- (cols grid) 1))
                (newline)))))
    (define (life grid iterations #!optional (step-duration 1))
      (life-print grid)
      (thread-sleep! step-duration)
      (do ((i 0 (+ i 1))
           (grid0 grid grid1)
           (grid1 (make (rows grid) (cols grid))
                  grid0))
          ((= i iterations))
        (each grid0
          (lambda (j k v)
            (let ((a (life-alive? grid0 j k)))
              (set! grid1 j k a))))
        (life-print grid1)
        (thread-sleep! step-duration)))))
