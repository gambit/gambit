(##supply-module srfi/144)

(##namespace ("srfi/144#"))                
(##include "~~lib/gambit/prim/prim#.scm") 
(##include "~~lib/_gambit#.scm")          
(##include "144#.scm")

(define (sym . lst)
(string->symbol
  (apply string-append
         (map (lambda (s) (if (symbol? s) (symbol->string s) s))
              lst))))

(define-macro
  (def-sqrt vals)
(define (sym . lst)
(string->symbol
  (apply string-append
         (map (lambda (s) (if (symbol? s) (symbol->string s) s))
              lst))))
  `(begin 
     ,@(map 
         (lambda (val)
           `(define ,(sym 'fl-sqrt- (number->string val)) (flsqrt (exact->inexact ,val))))
         vals)))

(define-macro
  (inverse names)
(define (sym . lst)
(string->symbol
  (apply string-append
         (map (lambda (s) (if (symbol? s) (symbol->string s) s))
              lst))))
  `(begin 
     ,@(map 
         (lambda (name)
           `(define ,(sym 'fl-1/ name) (/ 1 ,(sym 'fl- name))))
         names)))



(define-macro
  (apply-op names prefix suffix function)
(define (sym . lst)
(string->symbol
  (apply string-append
         (map (lambda (s) (if (symbol? s) (symbol->string s) s))
              lst))))
(define (->valid-arg arg)
  (cond
    ((string? arg) arg)
    ((symbol? arg) arg)
    ((number? arg) (number->string arg))))
(define (->name arg)
  (cond
    ((string? arg) (sym 'fl- arg))
    ((symbol? arg) (sym 'fl- arg))
    (else arg)))
  `(begin 
     ,@(map 
         (lambda (name)
           `(define ,(sym 'fl- prefix (->valid-arg name) suffix) 
              (,function ,(->name name))))
         names)))
(define-macro 
  (rename names prefix suffix)
    (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))
    `(begin
       ,@(map
           (lambda (name)
             `(define ,(sym prefix name suffix) ,name)) names)))

(define-macro
  (reexport names)
    `(begin
       ,@(map
           (lambda (name)
             `(define ,name (let () (namespace ("")) ,name))) names)))
    


(define fl-pi 3.1415926535897932384626433832795028841971)
(define fl-euler 0.57721566490153286060651209008240243104215933593992) ;; according to https://en.wikipedia.org/wiki/Euler%27s_constant
(define fl-e (exp 1))
(define fl-e-euler (exp fl-euler))
(define fl-pi/4 (/ fl-pi 4)) 
(define fl-e-pi/4 (exp fl-pi/4))
(define fl-phi (/ (+ 1 (sqrt 5)) 2))
(define fl-pi-squared (* fl-pi fl-pi))
(define fl-degree (/ fl-pi 180))
(define fl-4thrt-2 (expt 2 (/ 1 4)))
(apply-op (2 3 5 10 pi) sqrt- || sqrt)
(apply-op  (2 3) cbrt- || (lambda (x) (expt x (/ 1 3))))
(apply-op (2 3 pi 10 phi) log- || log)
(inverse (e sqrt-2 pi log-2 log-10))
(apply-op (pi) "2" || (lambda (x) (* x 2)))
(apply-op (2 4) pi/ || (lambda (x) (/ fl-pi x)))
(apply-op (e) log-2- || (lambda (x) (log x 2)))
(apply-op (e) log10- || (lambda (x) (log x 10)))
(apply-op (pi sqrt-pi) "2/" || (lambda (x) (/ 2 x)))
(define fl-sin-1 (sin 1))
(define fl-cos-1 (cos 1))
(rename (fl= fl< fl> fl<= fl>=) || ?)
(reexport (fl+ fl- flzero? flpositive? 
        flnegative? flodd? fleven? flfinite? flnan?
;        flnormalized? fldenormalized? flexp-1 fllog1+  flquotient  flremainder flremquo
        flmax flmin flexp flsquare flsqrt flexpt fllog
        flsin flcos fltan flasin flacos flatan flsinh flinteger?
        flcosh fltanh flasinh flacosh flatanh 
        fl+* fl* fl/ flabs))


(define-procedure
  (fllog2 (z flonum))
  (fllog z 2))

(define-procedure
  (flloggamma (z flonum))
    (values (flabs (flgamma z)) (/ (flgamma z) (flabs (flgamma z)))))

(define-procedure
  (fllog10 (z flonum))
  (fllog z 10))

(define-procedure
  (make-fllog-base (z flonum))
  (lambda (x) (fllog x z)))

(define-procedure
  (flexponent (z flonum))
  (+ (vector-ref (##flonum->exact-exponential-format z) 1) 52))

(define-procedure
  (flsign-bit (z flonum))
  (fxxor 1 (fxarithmetic-shift-right (fx+ (vector-ref (##flonum->exact-exponential-format z) 2) 1) 1)))

(define-procedure
  (flunordered? (x flonum) (y flonum))
  (or (flnan? x) (flnan? y)))

(define-procedure
  (flexp2 (z flonum))
  (flexpt x 2))

(define-procedure
  (flinteger-fraction (x flonum))
  (values (flfloor x) (- x (flfloor x))))

(cond-expand
  ((compilation-target C)
    (define flgamma (c-lambda (double) (double) "tgamma"))
    (define flexponent (c-lambda (double) (double) "logb"))
    (define flcbrt (c-lambda (double) (double) "cbrt"))
    (define flhypot (c-lambda (double double) (double) "hypot"))
    (define flfirst-bessel (c-lambda (double double) (double) "jn"))
    (define flsecond-bessel (c-lambda (double double) (double) "yn"))
    (define flerf (c-lambda (double double) (double) "erf"))
    (define flerfc (c-lambda (double double) (double) "erfc"))
   )
  (else
    (define-procedure
      (flhypot (a flonum) (b flonum))
      (flsqrt (+ (flsquare a) (flsquare b))))-
    (define-procedure
      (flcbrt (z flonum))
      (flexpt z (/ 1.0 3.0)))
    (define-procedure
      (flgamma (z flonum))
        (fl*
          (sqrt (fl* fl-2pi z))
          (flexpt (/ z fl-e) z)))))

(apply-op (1/2 1/3 2/3) gamma- || (lambda (x) (flgamma (##ratnum->flonum x))))

      



