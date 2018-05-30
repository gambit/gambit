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

(define (create-object-file filename cgc #!optional (show-listing? #t))

  (let* ((code (asm-assemble-to-u8vector cgc))
         (fixup-locs (codegen-context-fixup-locs->vector cgc))
         (fixup-objs (codegen-context-fixup-objs->vector cgc)))

    (if show-listing?
        (asm-display-listing cgc (current-output-port) #t))

    (display ";; code = ") (write code) (newline)
    (display ";; fixup-locs = ") (write fixup-locs) (newline)
    (display ";; fixup-objs = ") (write fixup-objs) (newline)

    ;; Call compiler to create objfile.o1 using the C backend.
    ;; When the file is loaded, it will execute the x86 code.

    (debug "Compiling")
    (compile-file "dummy.scm"
                  output: filename
                  options: '((target C))
                  expression: `((##machine-code-fixup
                                  ',code
                                  ',fixup-locs
                                  ',fixup-objs)))

    (debug "Output file: " filename)))

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