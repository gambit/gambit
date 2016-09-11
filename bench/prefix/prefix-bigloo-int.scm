;------------------------------------------------------------------------------

(module prefix (main main-entry))

;INSERTCODE

(define (time* thunk)
  (thunk))

(define (run-bench name count ok? run)
  (let loop ((i 0) (result (list 'undefined)))
    (if (< i count)
      (loop (+ i 1) (run))
      result)))

(define (run-benchmark name count ok? run-maker . args)
  (newline)
  (let* ((run (apply run-maker args))
         (result (time* (lambda () (run-bench name count ok? run)))))
    (if (not (ok? result))
      (begin
        (display "*** wrong result ***")
        (newline)
        (display "*** got: ")
        (write result)
        (newline))))
  (exit 0))

(define (fatal-error . args)
  (for-each display args)
  (newline)
  (exit 1))

 (define (call-with-output-file/truncate filename proc)
   (call-with-output-file filename proc))

(define (main-entry args)
  (main))

;------------------------------------------------------------------------------

; Macros...

(define-macro (def-macro form . body)
  `(define-macro ,form (let () ,@body)))

(if-fixflo

(begin

; Specialize fixnum and flonum arithmetic.

(def-macro (FLOATvector-const . lst)   `',(list->vector lst))
(def-macro (FLOATvector? x)            `(vector? ,x))
(def-macro (FLOATvector . lst)         `(vector ,@lst))
(def-macro (FLOATmake-vector n . init) `(make-vector ,n ,@init))
(def-macro (FLOATvector-ref v i)       `(vector-ref ,v ,i))
(def-macro (FLOATvector-set! v i x)    `(vector-set! ,v ,i ,x))
(def-macro (FLOATvector-length v)      `(vector-length ,v))

(def-macro (nuc-const . lst)
  `',(list->vector lst))

(def-macro (FLOAT+ . lst)
  (cond ((null? lst)       `0.0)
        ((null? (cdr lst)) (car lst))
        (else              `(+fl ,(car lst) (FLOAT+ ,@(cdr lst))))))

(def-macro (FLOAT- . lst)
  (cond ((null? (cdr lst)) `(negfl ,(car lst)))
        (else              `(-fl ,(car lst) (FLOAT+ ,@(cdr lst))))))

(def-macro (FLOAT* . lst)
  (cond ((null? lst)       `1.0)
        ((null? (cdr lst)) (car lst))
        (else              `(*fl ,(car lst) (FLOAT* ,@(cdr lst))))))

(def-macro (FLOAT/ . lst)
  (cond ((null? (cdr lst)) `(/fl 1.0 ,(car lst)))
        (else              `(/fl ,(car lst) (FLOAT* ,@(cdr lst))))))

(def-macro (FLOAT= . lst)  `(=fl ,@lst))
(def-macro (FLOAT< . lst)  `(<fl ,@lst))
(def-macro (FLOAT<= . lst) `(<=fl ,@lst))
(def-macro (FLOAT> . lst)  `(>fl ,@lst))
(def-macro (FLOAT>= . lst) `(>=fl ,@lst))
(def-macro (FLOATnegative? . lst) `(negativefl? ,@lst))
(def-macro (FLOATpositive? . lst) `(positivefl? ,@lst))
(def-macro (FLOATzero? . lst)     `(zerofl? ,@lst))
(def-macro (FLOATabs . lst) `(abs ,@lst))
(def-macro (FLOATsin . lst) `(sin ,@lst))
(def-macro (FLOATcos . lst) `(cos ,@lst))
(def-macro (FLOATatan . lst) `(atan ,@lst))
(def-macro (FLOATsqrt . lst) `(sqrt ,@lst))
(def-macro (FLOATmin . lst) `(minfl ,@lst))
(def-macro (FLOATmax . lst) `(maxfl ,@lst))
(def-macro (FLOATround . lst) `(roundfl ,@lst))
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

(def-macro (+ . lst)
  (cond ((null? lst)       `0)
        ((null? (cdr lst)) (car lst))
        (else              `(+fx ,(car lst) (+ ,@(cdr lst))))))

(def-macro (- . lst)
  (cond ((null? (cdr lst)) `(negfx ,(car lst)))
        (else              `(-fx ,(car lst) (+ ,@(cdr lst))))))

(def-macro (* . lst)
  (cond ((null? lst)       `1)
        ((null? (cdr lst)) (car lst))
        (else              `(*fx ,(car lst) (* ,@(cdr lst))))))

;(def-macro (quotient . lst) `(quotient ,@lst))
;(def-macro (modulo . lst) `(modulo ,@lst))
;(def-macro (remainder . lst) `(remainder ,@lst))
(def-macro (= . lst)  `(=fx ,@lst))
(def-macro (< . lst)  `(<fx ,@lst))
(def-macro (<= . lst) `(<=fx ,@lst))
(def-macro (> . lst)  `(>fx ,@lst))
(def-macro (>= . lst) `(>=fx ,@lst))
(def-macro (negative? . lst) `(negativefx? ,@lst))
(def-macro (positive? . lst) `(positivefx? ,@lst))
(def-macro (zero? . lst) `(zerofx? ,@lst))
;(def-macro (odd? . lst) `(odd? ,@lst))
;(def-macro (even? . lst) `(even? ,@lst))
(def-macro (bitwise-or . lst) `(bit-or ,@lst))
(def-macro (bitwise-and . lst) `(bit-and ,@lst))
(def-macro (bitwise-not . lst) `(bit-not ,@lst))
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

(def-macro (bitwise-or . lst) `(bit-or ,@lst))
(def-macro (bitwise-and . lst) `(bit-and ,@lst))
(def-macro (bitwise-not . lst) `(bit-not ,@lst))
)
)

;------------------------------------------------------------------------------
