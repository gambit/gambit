;;==============================================================================

;;; File: "_t-cpu-bench.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Some functions for generating and executing machine code.

;; The function u8vector->procedure converts a u8vector containing a
;; sequence of bytes into a Scheme procedure that can be called.
;; The code in the u8vector must obey the C calling conventions of
;; the host architecture.

(define (u8vector->procedure code fixups)
 (machine-code-block->procedure
  (u8vector->machine-code-block code fixups)))

(define (u8vector->machine-code-block code fixups)
 (let* ((len (u8vector-length code))
        (mcb (##make-machine-code-block len)))
   (let loop ((i (fx- len 1)))
     (if (fx>= i 0)
         (begin
           (##machine-code-block-set! mcb i (u8vector-ref code i))
           (loop (fx- i 1)))
         (apply-fixups mcb fixups)))))

;; Add mcb's base address to every label that needs to be fixed up.
;; Currently assumes 32 bit width.
(define (apply-fixups mcb fixups)
  (let ((base-addr (##foreign-address mcb)))
    (let loop ((fixups fixups))
      (if (null? fixups)
          mcb
          (let* ((pos (asm-label-pos (caar fixups)))
                 (size (quotient (cdar fixups) 8))
                 (n (+ base-addr (machine-code-block-int-ref mcb pos size))))
            (machine-code-block-int-set! mcb pos size n)
            (loop (cdr fixups)))))))

(define (machine-code-block-int-ref mcb start size)
  (let loop ((n 0) (i (- size 1)))
    (if (>= i 0)
        (loop (+ (* n 256) (##machine-code-block-ref mcb (+ start i)))
              (- i 1))
        n)))

(define (machine-code-block-int-set! mcb start size n)
  (let loop ((n n) (i 0))
    (if (< i size)
        (begin
          (##machine-code-block-set! mcb (+ start i) (modulo n 256))
          (loop (quotient n 256) (+ i 1))))))

(define (machine-code-block->procedure mcb)
  (lambda (#!optional (arg1 0) (arg2 0) (arg3 0))
    (##machine-code-block-exec mcb arg1 arg2 arg3)))

(define (create-procedure cgc show-listing #!optional (show-bytes #t))
  (let* ((code (asm-assemble-to-u8vector cgc))
         (fixups (codegen-context-fixup-list cgc))
         (procedure (u8vector->procedure code fixups)))
    (if show-listing
      (asm-display-listing cgc (current-error-port) show-bytes))
    procedure))

;;------------------------------------------------------------------------------

;; Some functions to execute and time the generated machine code

(define (time-cgc cgc #!optional (show-listing #f))
  (pp (time ((create-procedure cgc show-listing #t)))))

; Used somewhere in the code to change a value for the test
(define test-value #f)
(define test-results '())

(define (test-values targ values sample-count procs)
  ; (set! _debug #f)

  (if (not (null? values))
    (let* ((cgc ((get-make-cgc-fun targ)))
           (value (car values)))

      (codegen-context-target-set! cgc targ)

      (debug "Number of test remaining: ")
      (debug (length values))
      (debug "\n")
      (debug "Current value: ")
      (debug value)
      (debug "\n")

      ;; Test value
      (set! test-value value)
      ;; Encodes procs in CGC
      (encode-procs cgc procs)
      ;; Take sample
      (time-test-with-value cgc sample-count)
      ;; Loop
      (test-values targ (cdr values) sample-count procs))))

(define (time-test-with-value cgc sample-count)
  (let* ((procedure (create-procedure cgc #t))
         (samples (map
                  (lambda (x) (##exec-stats procedure))
                  (iota 1 sample-count))))

    (display (car samples))
    (newline)

    (set! test-results (cons (cons test-value samples) test-results))))

(define (print-results-csv)
  (display "Results: \n")
  (display "Value,Time \n")
  (for-each
    (lambda (result)
      (let* ((current-value (car result))
             (samples (cdr result)))

        (display current-value)
        (for-each
          (lambda (sample)
            (display ",")
            (display (cdr (list-ref sample 3))))
          samples)
        (newline)))
    (reverse test-results)))