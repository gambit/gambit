;INSERTCODE
;------------------------------------------------------------------------------

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
  (exit 1))

 (define (call-with-output-file/truncate filename proc)
   (call-with-output-file filename proc))

;------------------------------------------------------------------------------

; Macros...

(##define-macro (def-macro form . body)
  `(##define-macro ,form (let () ,@body)))

(if-fixflo

(begin

; Specialize fixnum and flonum arithmetic.

;; This code should be used when f64vectors are available.
(def-macro (FLOATvector-const . lst)   `',(list->f64vector lst))
(def-macro (FLOATvector? x)            `(f64vector? ,x))
(def-macro (FLOATvector . lst)         `(f64vector ,@lst))
(def-macro (FLOATmake-vector n . init) `(make-f64vector ,n ,@init))
(def-macro (FLOATvector-ref v i)       `(f64vector-ref ,v ,i))
(def-macro (FLOATvector-set! v i x)    `(f64vector-set! ,v ,i ,x))
(def-macro (FLOATvector-length v)      `(f64vector-length ,v))

(def-macro (nuc-const . lst)
  `',(list->vector
       (map (lambda (x)
              (if (vector? x)
                (list->f64vector (vector->list x))
                x))
            lst)))

;(def-macro (FLOATvector-const . lst)   `',(list->vector lst))
;(def-macro (FLOATvector? x)            `(vector? ,x))
;(def-macro (FLOATvector . lst)         `(vector ,@lst))
;(def-macro (FLOATmake-vector n . init) `(make-vector ,n ,@init))
;(def-macro (FLOATvector-ref v i)       `(vector-ref ,v ,i))
;(def-macro (FLOATvector-set! v i x)    `(vector-set! ,v ,i ,x))
;(def-macro (FLOATvector-length v)      `(vector-length ,v))
;
;(def-macro (nuc-const . lst)
;  `',(list->vector lst))

(def-macro (FLOAT+ . lst) `(fl+ ,@lst))
(def-macro (FLOAT- . lst) `(fl- ,@lst))
(def-macro (FLOAT* . lst) `(fl* ,@lst))
(def-macro (FLOAT/ . lst) `(fl/ ,@lst))
(def-macro (FLOAT= . lst)  `(fl= ,@lst))
(def-macro (FLOAT< . lst)  `(fl< ,@lst))
(def-macro (FLOAT<= . lst) `(fl<= ,@lst))
(def-macro (FLOAT> . lst)  `(fl> ,@lst))
(def-macro (FLOAT>= . lst) `(fl>= ,@lst))
(def-macro (FLOATnegative? . lst) `(flnegative? ,@lst))
(def-macro (FLOATpositive? . lst) `(flpositive? ,@lst))
(def-macro (FLOATzero? . lst)     `(flzero? ,@lst))
(def-macro (FLOATabs . lst) `(flabs ,@lst))
(def-macro (FLOATsin . lst) `(flsin ,@lst))
(def-macro (FLOATcos . lst) `(flcos ,@lst))
(def-macro (FLOATatan . lst) `(flatan ,@lst))
(def-macro (FLOATsqrt . lst) `(flsqrt ,@lst))
(def-macro (FLOATmin . lst) `(flmin ,@lst))
(def-macro (FLOATmax . lst) `(flmax ,@lst))
(def-macro (FLOATround . lst) `(flround ,@lst))
(def-macro (FLOATinexact->exact . lst) `(inexact->exact ,@lst))

(define (GENERIC+ x y) (+ x y))
(define (GENERIC- x y) (- x y))
(define (GENERIC* x y) (* x y))
(define (GENERIC/ x y) (/ x y))
(define (GENERICquotient x y) (quotient x y))
(define (GENERICremainder x y) (remainder x y))
(define (GENERICmodulo x y) (modulo x y))
(define (GENERIC= x y) (= x y))
(define (GENERIC< x y) (< x y))
(define (GENERIC<= x y) (<= x y))
(define (GENERIC> x y) (> x y))
(define (GENERIC>= x y) (>= x y))
(define (GENERICexpt x y) (expt x y))

(def-macro (+ . lst) `(fxwrap+ ,@lst))
(def-macro (- . lst) `(fxwrap- ,@lst))
(def-macro (* . lst) `(fxwrap* ,@lst))
(def-macro (quotient . lst) `(fxwrapquotient ,@lst))
(def-macro (modulo . lst) `(fxmodulo ,@lst))
(def-macro (remainder . lst) `(fxremainder ,@lst))
(def-macro (= . lst)  `(fx= ,@lst))
(def-macro (< . lst)  `(fx< ,@lst))
(def-macro (<= . lst) `(fx<= ,@lst))
(def-macro (> . lst)  `(fx> ,@lst))
(def-macro (>= . lst) `(fx>= ,@lst))
(def-macro (negative? . lst) `(fxnegative? ,@lst))
(def-macro (positive? . lst) `(fxpositive? ,@lst))
(def-macro (zero? . lst) `(fxzero? ,@lst))
(def-macro (odd? . lst) `(fxodd? ,@lst))
(def-macro (even? . lst) `(fxeven? ,@lst))
(def-macro (bitwise-or . lst) `(fxior ,@lst))
(def-macro (bitwise-and . lst) `(fxand ,@lst))
(def-macro (bitwise-not . lst) `(fxnot ,@lst))
)

(begin

; Don't specialize fixnum and flonum arithmetic.

(def-macro (FLOATvector-const . lst)   `',(list->vector lst))
(def-macro (FLOATvector? x)            `(vector? ,x))
(def-macro (FLOATvector . lst)         `(vector ,@lst))
(def-macro (FLOATmake-vector n . init) `(make-vector ,n ,@init))
(def-macro (FLOATvector-ref v i)       `(vector-ref ,v ,i))
(def-macro (FLOATvector-set! v i x)    `(vector-set! ,v ,i ,x))
(def-macro (FLOATvector-length v)      `(vector-length ,v))

(def-macro (nuc-const . lst)
  `',(list->vector lst))

(def-macro (FLOAT+ . lst) `(+ ,@lst))
(def-macro (FLOAT- . lst) `(- ,@lst))
(def-macro (FLOAT* . lst) `(* ,@lst))
(def-macro (FLOAT/ . lst) `(/ ,@lst))
(def-macro (FLOAT= . lst)  `(= ,@lst))
(def-macro (FLOAT< . lst)  `(< ,@lst))
(def-macro (FLOAT<= . lst) `(<= ,@lst))
(def-macro (FLOAT> . lst)  `(> ,@lst))
(def-macro (FLOAT>= . lst) `(>= ,@lst))
(def-macro (FLOATnegative? . lst) `(negative? ,@lst))
(def-macro (FLOATpositive? . lst) `(positive? ,@lst))
(def-macro (FLOATzero? . lst)     `(zero? ,@lst))
(def-macro (FLOATabs . lst) `(abs ,@lst))
(def-macro (FLOATsin . lst) `(sin ,@lst))
(def-macro (FLOATcos . lst) `(cos ,@lst))
(def-macro (FLOATatan . lst) `(atan ,@lst))
(def-macro (FLOATsqrt . lst) `(sqrt ,@lst))
(def-macro (FLOATmin . lst) `(min ,@lst))
(def-macro (FLOATmax . lst) `(max ,@lst))
(def-macro (FLOATround . lst) `(round ,@lst))
(def-macro (FLOATinexact->exact . lst) `(inexact->exact ,@lst))

(def-macro (GENERIC+ . lst) `(+ ,@lst))
(def-macro (GENERIC- . lst) `(- ,@lst))
(def-macro (GENERIC* . lst) `(* ,@lst))
(def-macro (GENERIC/ . lst) `(/ ,@lst))
(def-macro (GENERICquotient . lst)  `(quotient ,@lst))
(def-macro (GENERICremainder . lst) `(remainder ,@lst))
(def-macro (GENERICmodulo . lst)    `(modulo ,@lst))
(def-macro (GENERIC= . lst)  `(= ,@lst))
(def-macro (GENERIC< . lst)  `(< ,@lst))
(def-macro (GENERIC<= . lst) `(<= ,@lst))
(def-macro (GENERIC> . lst)  `(> ,@lst))
(def-macro (GENERIC>= . lst) `(>= ,@lst))
(def-macro (GENERICexpt . lst) `(expt ,@lst))
)
)

;------------------------------------------------------------------------------
