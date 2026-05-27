(##supply-module srfi/143)

(##namespace ("srfi/143#"))                
(##include "~~lib/gambit/prim/prim#.scm") 
(##include "~~lib/_gambit#.scm")          
(##include "143#.scm")

(define fx-width (##fixnum-width))
(define fx-least (##least-fixnum))
(define fx-greatest (##greatest-fixnum))
(define fxsqrt exact-integer-sqrt)
(define-procedure (fxneg (i fixnum))
                  (- i))
(define-macro (rename procedures prefix suffix)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))
     `(begin
        ,@(map
            (lambda (proc)
              `(define ,(sym prefix proc suffix) ,proc)) procedures)))

(define-macro (double-rename procedures prefix prefix-orig)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))
     `(begin
        ,@(map
            (lambda (proc)
              `(define ,(sym prefix) ,(sym prefix-orig proc))) procedures)))
(define-macro
  (redefine-2
    procedures)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))
     `(begin
        ,@(map
            (lambda (proc)
              `(define-procedure 
                 (,proc (i fixnum) (j fixnum))  
                 ((let () (namespace ("")) ,proc) i j))
                 ) procedures)))
(define-macro
  (reexport 
    procedures)
  `(begin
     ,@(map
         (lambda (proc)
           `(define ,proc (let () (namespace ("")) ,proc))) procedures)))

(redefine-2 (fx+ fx- fx*))
(reexport 
  (fxquotient fixnum? fxzero? fxpositive?  fxnegative? 
    fxodd? fxeven? fxabs fxsquare fxbit-count 
    fxfirst-set-bit fxlength fxmax fxmin fxremainder
    fxand fxior fxif fxxor fxbit-set? 
    fxarithmetic-shift ))

(define-procedure (fxbit-field (i fixnum) 
                               (start (index-range-incl 0 fx-width)) 
                               (end (index-range-incl 0 fx-width)))
          (fxarithmetic-shift-right
          (fxand
          i
          (- (fxarithmetic-shift-left 1 end) (fxarithmetic-shift-left 1 start)))
          start))

(define-procedure (fxbit-field-reverse (i fixnum) 
                                       (start (index-range-incl 0 fx-width)) 
                                       (end (index-range-incl 0 fx-width)))
                  (bit-field-reverse i start end))

(rename (fx= fx< fx> fx<= fx>=) || ?)
(rename  (bit-field-rotate) fx ||)
(double-rename (and ior xor if) fx bitwise-)


(define-procedure (fxarithmetic-shift-right (i fixnum) 
                                            (j (index-range-incl 0 fx-width)))
                  (##fxarithmetic-shift-right i j))

(define-procedure (fxcopy-bit (i (index-range-incl 0 fx-width))
                              (j fixnum) (boolean boolean))
                  (copy-bit i j boolean))

(define (fx+/carry i j k)
(let*-values (((s) (+ i j k))
              ((q r) (balanced/ s (expt 2 fx-width))))
  (values r q)))

(define (fx-/carry i j k)
  (let*-values (((d) (- i j k))
                ((q r) (balanced/ d (expt 2 fx-width))))
    (values r q)))

(define (fx*/carry i j k)
  (let*-values (((s) (+ (* i j) k))
                ((q r) (balanced/ s (expt 2 fx-width))))
    (values r q)))
