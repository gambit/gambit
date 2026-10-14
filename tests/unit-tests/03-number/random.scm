(include "#.scm")

;; Test the documented bounds and replay contract, without depending on a
;; particular pseudo-random sequence or requiring samples to be distinct.

(test-eq #t (random-source? (make-random-source)))
(test-eq #f (random-source? #f))
(test-eq #f (random-source? '#(1 2 3)))
(test-eqv 0 (random-integer 1))
(test-assert
 (let ((n (random-integer (expt 2 80))))
   (and (exact? n) (integer? n) (<= 0 n) (< n (expt 2 80)))))
(test-assert
 (let ((n (random-real)))
   (and (inexact? n) (< 0 n 1))))
(test-equal '#u8() (random-u8vector 0))
(test-eqv 17 (u8vector-length (random-u8vector 17)))
(test-equal '#f64() (random-f64vector 0))
(test-assert
 (let ((v (random-f64vector 17)))
   (and (= 17 (f64vector-length v))
        (every (lambda (x) (< 0 x 1)) (f64vector->list v)))))

(test-assert
 (let* ((source (make-random-source))
        (integers (random-source-make-integers source))
        (reals (random-source-make-reals source))
        (bytes (random-source-make-u8vectors source))
        (floats (random-source-make-f64vectors source))
        (saved (random-source-state-ref source)))
   (define (draw-sequence)
     (let* ((i (integers (expt 2 80)))
            (r (reals)) (b (bytes 17)) (f (floats 9)))
       (list i r b f)))
   (let ((first (draw-sequence)))
     (random-source-state-set! source saved)
     (equal? first (draw-sequence)))))

(test-assert
 (let ((a (make-random-source))
       (b (make-random-source)))
   (random-source-pseudo-randomize! a 123 456)
   (random-source-pseudo-randomize! b 123 456)
   (equal? ((random-source-make-u8vectors a) 100)
           ((random-source-make-u8vectors b) 100))))

(test-assert
 (let ((source (make-random-source)))
   (random-source-randomize! source)
   ;; A randomized source must remain usable and support saving/restoring.
   (let* ((saved (random-source-state-ref source))
          (draw (random-source-make-integers source))
          (first (draw 100000)))
     (random-source-state-set! source saved)
     (= first (draw 100000)))))

(test-eqv 0 ((random-source-make-integers (make-random-source)) 1))
(test-equal '#u8() ((random-source-make-u8vectors (make-random-source)) 0))
(test-equal '#f64() ((random-source-make-f64vectors (make-random-source)) 0))
(test-assert
 (let ((n ((random-source-make-reals (make-random-source) 1/16))))
   (and (inexact? n) (< 0 n 1))))
(test-assert
 (let ((v ((random-source-make-f64vectors (make-random-source) 1/16) 16)))
   (and (= 16 (f64vector-length v))
        (every (lambda (x) (< 0 x 1)) (f64vector->list v)))))

(test-error range-exception? (random-integer 0))
(test-error range-exception? (random-integer -1))
(test-error type-exception? (random-integer #f))
(test-error range-exception? (random-u8vector -1))
(test-error range-exception? (random-f64vector -1))
(test-error type-exception? (random-source-state-ref #f))
(test-error type-exception? (random-source-state-set! #f '#()))
(test-error type-exception? (random-source-randomize! #f))
(test-error type-exception? (random-source-pseudo-randomize! #f 0 0))
(test-error range-exception? (random-source-pseudo-randomize! (make-random-source) -1 0))
(test-error range-exception? (random-source-pseudo-randomize! (make-random-source) 0 -1))
(test-error type-exception? (random-source-make-integers #f))
(test-error type-exception? (random-source-make-reals #f))
(test-error type-exception? (random-source-make-u8vectors #f))
(test-error type-exception? (random-source-make-f64vectors #f))
