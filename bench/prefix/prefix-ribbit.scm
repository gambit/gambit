;INSERTCODE
;------------------------------------------------------------------------------

(define (time x) x) ;; noop until ribbit has a way of measuring time

(define (run-bench name count ok? run)
  (let loop ((i count) (result '(undefined)))
    (if (< 0 i)
      (loop (- i 1) (run))
      result)))

(define (run-benchmark name count ok? run-maker . args)
  (newline)
  (let* ((run (apply run-maker args))
         (result (time (run-bench name count ok? run))))
    (if (not (ok? result))
      (begin
        (display "*** wrong result ***")
        (newline)
        (display "*** got: ")
        (write result)
        (newline)))))

(define (fatal-error . args)
  (for-each display args)
  (newline)
  (##exit 1))

 (define (call-with-output-file/truncate filename proc)
   (call-with-output-file filename proc))

;------------------------------------------------------------------------------

; Macros...

; Don't specialize fixnum and flonum arithmetic.

(define-macro (FLOATvector-const . lst)   `',(list->vector lst))
(define-macro (FLOATvector? x)            `(vector? ,x))
(define-macro (FLOATvector . lst)         `(vector ,@lst))
(define-macro (FLOATmake-vector n . init) 
  (if (not (null? init))
    (error "Ribbit only supports the one arg form of 'make-vector")
    `(make-vector ,n ,@init)))
(define-macro (FLOATvector-ref v i)       `(vector-ref ,v ,i))
(define-macro (FLOATvector-set! v i x)    `(vector-set! ,v ,i ,x))
(define-macro (FLOATvector-length v)      `(vector-length ,v))

(define-macro (nuc-const . lst)
  `',(list->vector lst))

(define-macro (FLOAT+ . lst) `(+ ,@lst))
(define-macro (FLOAT- . lst) `(- ,@lst))
(define-macro (FLOAT* . lst) `(* ,@lst))
(define-macro (FLOAT/ . lst) `(/ ,@lst))
(define-macro (FLOAT= . lst)  `(= ,@lst))
(define-macro (FLOAT< . lst)  `(< ,@lst))
(define-macro (FLOAT<= . lst) `(<= ,@lst))
(define-macro (FLOAT> . lst)  `(> ,@lst))
(define-macro (FLOAT>= . lst) `(>= ,@lst))
(define-macro (FLOATnegative? . lst) `(negative? ,@lst))
(define-macro (FLOATpositive? . lst) `(positive? ,@lst))
(define-macro (FLOATzero? . lst)     `(zero? ,@lst))
(define-macro (FLOATabs . lst) `(abs ,@lst))
(define-macro (FLOATsin . lst) (error "sin is not supported by Ribbit"))   ;`(sin ,@lst))
(define-macro (FLOATcos . lst) (error "cos is not supported by Ribbit"))   ;`(cos ,@lst))
(define-macro (FLOATatan . lst) (error "tan is not supported by Ribbit"))  ;`(atan ,@lst))
(define-macro (FLOATsqrt . lst) (error "sqrt is not supported by Ribbit")) ;`(sqrt ,@lst))
(define-macro (FLOATmin . lst) `(min ,@lst))
(define-macro (FLOATmax . lst) `(max ,@lst))
(define-macro (FLOATround . lst) `(round ,@lst))
(define-macro (FLOATinexact->exact . lst) `(inexact->exact ,@lst))

(define-macro (GENERIC+ . lst) `(+ ,@lst))
(define-macro (GENERIC- . lst) `(- ,@lst))
(define-macro (GENERIC* . lst) `(* ,@lst))
(define-macro (GENERIC/ . lst) `(/ ,@lst))
(define-macro (GENERICquotient . lst)  `(quotient ,@lst))
(define-macro (GENERICremainder . lst) `(remainder ,@lst))
(define-macro (GENERICmodulo . lst)    `(modulo ,@lst))
(define-macro (GENERIC= . lst)  `(= ,@lst))
(define-macro (GENERIC< . lst)  `(< ,@lst))
(define-macro (GENERIC<= . lst) `(<= ,@lst))
(define-macro (GENERIC> . lst)  `(> ,@lst))
(define-macro (GENERIC>= . lst) `(>= ,@lst))
(define-macro (GENERICexpt . lst) (error "expt is not supported by Ribbit")) ;`(expt ,@lst))

;; ;------------------------------------------------------------------------------
