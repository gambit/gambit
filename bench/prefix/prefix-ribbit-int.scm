;INSERTCODE
;------------------------------------------------------------------------------

(define (time x) x) ;; noop until ribbit has a way of measuring time

(define (run-bench name count ok? run)
  (letrec ((loop 
             (lambda (i result)
               (if (< 0 i)
                 (loop (- i 1) (run))
                 result))))
    (loop count '(undefined))))

(define (run-benchmark name count ok? run-maker . args)
  (newline)
  (let ((run (apply run-maker args)))
    (let ((result (time (run-bench name count ok? run))))
      (if (not (ok? result))
        (begin
          (display "*** wrong result ***")
          (newline)
          (display "*** got: ")
          (write result)
          (newline))))))

(define (fatal-error . args)
  (for-each display args)
  (newline)
  (##exit 1))

 (define (call-with-output-file/truncate filename proc)
   (call-with-output-file filename proc))

