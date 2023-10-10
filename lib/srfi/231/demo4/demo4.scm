#!/usr/bin/env gsi-script

(import (srfi 231))

(display "
This example:

 1.  Reads and writes PGM files.
 2.  Builds separable transforms from 1-D transforms.
 3.  Defines the Haar wavelet transform.
 4.  De-noises images through wavelet shrinkage.

It writes three small image files into the directory in which it is invoked:

1. girl.pgm, a small image of a girl.
2. noisy-girl.pgm, the image girl.pgm to which noise has been added.
3. denoised-girl.pgm, which uses Haar wavelets to remove some of the noise
   from noisy-girl.pgm (which, perforce, also removes some image details).
")

;;; Reading and writing PGM image files.

(define make-pgm   cons)
(define pgm-greys  car)
(define pgm-pixels cdr)

(define (read-pgm file)

  (define (read-pgm-object port)
    (skip-white-space port)
    (let ((o (read port)))
      (read-char port) ; to skip the newline or next whitespace
      (if (eof-object? o)
          (error "reached end of pgm file")
          o)))

  (define (skip-to-end-of-line port)
    (let loop ((ch (read-char port)))
      (if (not (eq? ch #\newline))
          (loop (read-char port)))))

  (define (white-space? ch)
    (case ch
      ((#\newline #\space #\tab) #t)
      (else #f)))

  (define (skip-white-space port)
    (let ((ch (peek-char port)))
      (cond ((white-space? ch) (read-char port) (skip-white-space port))
            ((eq? ch #\#) (skip-to-end-of-line port)(skip-white-space port))
            (else #f))))

  (call-with-input-file
      (list path:          file
            char-encoding: 'ISO-8859-1
            eol-encoding:  'lf)
    (lambda (port)

      ;; We're going to read text for a while,
      ;; then switch to binary.
      ;; So we need to turn off buffering until
      ;; we switch to binary.

      (port-settings-set! port '(buffering: #f))

      (let* ((header (read-pgm-object port))
             (columns (read-pgm-object port))
             (rows (read-pgm-object port))
             (greys (read-pgm-object port)))

        ;; now we switch back to buffering
        ;; to speed things up

        (port-settings-set! port '(buffering: #t))

        (make-pgm greys
                  (array-copy!
                   (make-array
                    (make-interval (vector rows columns))
                    (cond ((or (eq? header 'p5)                                     ;; pgm binary
                               (eq? header 'P5))
                           (if (< greys 256)
                               (lambda (i j)                                        ;; one byte/pixel
                                 (char->integer (read-char port)))
                               (lambda (i j)                                        ;; two bytes/pixel, little-endian
                                 (let* ((first-byte (char->integer (read-char port)))
                                        (second-byte (char->integer (read-char port))))
                                   (+ (* second-byte 256) first-byte)))))
                          ((or (eq? header 'p2)                                     ;; pgm ascii
                               (eq? header 'P2))
                           (lambda (i j)
                             (read port)))
                          (else
                           (error "read-pgm: not a pgm file"))))))))))

(define (write-pgm pgm-data file #!optional force-ascii)
  (call-with-output-file
      (list path:          file
            char-encoding: 'ISO-8859-1
            eol-encoding:  'lf)
    (lambda (port)
      (let* ((greys     (pgm-greys pgm-data))
             (pgm-array (pgm-pixels pgm-data))
             (domain    (array-domain pgm-array))
             (rows      (interval-width domain 0))
             (columns   (interval-width domain 1)))
        (if force-ascii
            (display "P2" port)
            (display "P5" port))
        (newline port)
        (display columns port) (display " " port)
        (display rows port) (newline port)
        (display greys port) (newline port)
        (array-for-each (if force-ascii
                            (let ((next-pixel-in-line 1))
                              (lambda (p)
                                (write p port)
                                (if (fxzero? (fxand next-pixel-in-line 15))
                                    (begin
                                      (newline port)
                                      (set! next-pixel-in-line 1))
                                    (begin
                                      (display " " port)
                                      (set! next-pixel-in-line (fx+ 1 next-pixel-in-line))))))
                            (if (fx< greys 256)
                                (lambda (p)
                                  (write-u8 p port))
                                (lambda (p)
                                  (write-u8 (fxand p 255) port)
                                  (write-u8 (fxarithmetic-shift-right p 8) port))))
                        pgm-array)))))


;;; Haar wavelet transforms
;;; For simplicity we assume that images have 2^k x 2^k pixels
;;; for some k and their lower bounds are zero.

;; Separable transforms are multi-dimensional transforms that are
;; computed by apply a one-dimensional transform to all the
;; one-dimensional "pencils" in each coordinate direction.

(define (make-separable-transform 1D-transform)
  (lambda (a)
    (let ((n (array-dimension a)))
      (do ((d 0 (fx+ d 1)))
          ((fx= d n))
        (array-for-each
         1D-transform
         (array-curry (array-permute a (index-last n d)) 1))))))

;;; Wavelet transforms are computed by applying a single-scale
;;; transform and then downsampling the image in all directions
;;; by a factor of 2; the inverse transforms first downsamples the
;;; image in all directions by a factor of two and then applies the
;;; transform.

(define (recursively-apply-transform-and-downsample transform)
  (lambda (a)
    (let ((sample-vector (make-vector (array-dimension a) 2)))
      (define (helper a)
        (if (fx< 1 (interval-upper-bound (array-domain a) 0))
            (begin
              (transform a)
              (helper (array-sample a sample-vector)))))
      (helper a))))

(define (recursively-downsample-and-apply-transform transform)
  (lambda (a)
    (let ((sample-vector (make-vector (array-dimension a) 2)))
      (define (helper a)
        (if (fx< 1 (interval-upper-bound (array-domain a) 0))
            (begin
              (helper (array-sample a sample-vector))
              (transform a))))
      (helper a))))

;;; We define a one-dimensional loop for a single scale of
;;; the Haar transform.

(define (1D-Haar-loop a)
  (let ((a_ (array-getter a))
        (a! (array-setter a))
        (n (interval-upper-bound (array-domain a) 0)))
    (do ((i 0 (fx+ i 2)))
        ((fx= i n))
      (let* ((a_i               (a_ i))
             (a_i+1             (a_ (fx+ i 1)))
             (scaled-sum        (fl/ (fl+ a_i a_i+1) (flsqrt 2.0)))
             (scaled-difference (fl/ (fl- a_i a_i+1) (flsqrt 2.0))))
        (a! scaled-sum i)
        (a! scaled-difference (fx+ i 1))))))

;;; Now we can define the Haar wavelet transform:

(define Haar-transform
  (recursively-apply-transform-and-downsample
   (make-separable-transform 1D-Haar-loop)))  ;; apply the 1-D loop in all directions

(define Haar-inverse-transform
  (recursively-downsample-and-apply-transform
   (make-separable-transform 1D-Haar-loop)))  ;; apply the 1-D loop in all directions

;;; We'll do a denoising example, so we need to generate some Gaussian noise
;;; with mean 0 and standard deviation 1.
;;; We'll use the Box-Muller method for simplicity.

(define gaussian-random-number
  (let ((state #f)
        (twopi (fl* 8. (flatan 1.))))
    (lambda ()
      (if state
	  (let ((result state))
	    (set! state #f)
	    result)
	  (let ((x1 (flsqrt (fl- (fl* 2. (fllog (random-real))))))
		(x2 (random-real)))
	    (set! state (fl* x1 (flsin (fl* twopi x2))))
	    (fl* x1 (flcos (fl* twopi x2))))))))

;;; We'll apply shrinkage, or soft thresholding, to the wavelet coefficients.

(define (Shrink tau)
  (lambda (c_ij)
    (cond ((fl<= (flabs c_ij) tau)
           0.)
          ((flpositive? c_ij)
           (fl- c_ij tau))
          (else
           (fl+ c_ij tau)))))

(define (image->float-array image)
  (array-copy!
   (array-map inexact (pgm-pixels image))))

(define (float-array->image float-array greys)
  (make-pgm
   greys
   (array-copy!
    (array-map (lambda (pixel)
                 (fxmax 0
                        (fxmin greys
                               (exact (flround pixel)))))
               float-array)
    (if (< greys 256)
        u8-storage-class
        u16-storage-class))))

(let* ((image
        (read-pgm (path-expand "girl.pgm" (path-directory (this-source-file)))))
       (ignore
        (write-pgm image "girl.pgm"))
       (inexact-image
        (image->float-array image))
       (standard-deviation
        16.) ;; greyscales
       (noisy-inexact-image
        (array-copy!
         (array-map fl+
                    inexact-image
                    (make-array (array-domain inexact-image)
                                (lambda args
                                  (fl* standard-deviation (gaussian-random-number)))))))
       (S_tau
        (Shrink (fl* 2. standard-deviation)))
       (noisy-data    ;; we keep the noisy image for later
        (array-copy! noisy-inexact-image))
       (ignore
        (Haar-transform noisy-data))
       (average-grey-scale
        (array-ref noisy-data 0 0))
       (transformed-noisy-data ;; will have to put the average grey scale back later
        (array-copy!
         (array-map S_tau noisy-data)))
       (ignore
        (array-set! transformed-noisy-data average-grey-scale 0 0))
       (ignore
        (Haar-inverse-transform transformed-noisy-data)))
  (write-pgm (float-array->image noisy-inexact-image (pgm-greys image)) "noisy-girl.pgm")
  (write-pgm (float-array->image transformed-noisy-data (pgm-greys image)) "denoised-girl.pgm"))

(println "\nDemo source code: " (this-source-file))
