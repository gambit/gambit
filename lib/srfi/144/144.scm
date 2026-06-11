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
(define-procedure (flonum (f number))
    (cond
      ((flonum? f) f)
      ((##ratnum? f) (##ratnum->flonum f))
      ((exact-integer? f) (##exact-int->flonum f))
      (else (error "This is a Bug in SRFI 144. it Should never happen"))))
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
(define fl-greatest (* 1.80 (expt 10 308)))
(define fl-least (* 4.94 (expt 10 -324)))
(define fl-epsilon (expt 2 -53))
(define fl-fast-fl+* #t)
(rename (fl= fl< fl> fl<= fl>=) || ?)
(reexport (fl+ fl- flzero? flpositive? 
        flnegative? flodd? fleven? flfinite? flnan?
;        flnormalized? fldenormalized? flexp-1 fllog1+  flquotient  flremainder flremquo
        flmax flmin flexp flsquare flsqrt flexpt fllog
        flsin flcos fltan flasin flacos flatan flsinh flinteger?
        flcosh fltanh flasinh flacosh flatanh flfloor flceiling flround
        fltruncate
        fl+* fl* fl/ flabs))

(define-procedure (flremquo (x flonum) (y flonum))
    (cond
      ((or (not (flfinite? x)) (not (flfinite? y))) (values +nan.0 0))
      ((flnegative? y) 
       (let-values (((a b) (flremquo x (fl- y))))
         (values
           a
           (- b))))
    (else
    (let* (
          (a (fl* 
               (flnumerator x)
               (fldenominator y)))
          (b (fl* 
               (flnumerator y)
               (fldenominator x)))
          (rem (fl/ 
                 (flremainder a b)
                 (fl* (fldenominator x) (fldenominator y)))))
      (values
        (if (fl> rem (fl/ y 2.0)) (fl- (fl- y rem)) rem)
        (+ 
          (##flonum->exact-int (flquotient a b))
          (if (fl> rem (fl/ y 2.0)) 1 0)) 
        )))))

(define-procedure
  (fllog2 (z flonum))
  (fllog z 2.0))

(define-procedure
  (flloggamma (z flonum))
    (values (fllog (flabs (flgamma z))) (/ (flgamma z) (flabs (flgamma z)))))

(define-procedure
  (fllog10 (z flonum))
  (fllog z 10.0))

(define-procedure
  (make-fllog-base (z flonum))
  (lambda (x) (fllog x z)))

(define-procedure
  (flsign-bit (z flonum))
  (fxxor 1 (fxarithmetic-shift-right (fx+ (vector-ref (##flonum->exact-exponential-format z) 2) 1) 1)))

(define-procedure
  (flunordered? (x flonum) (y flonum))
  (or (flnan? x) (flnan? y)))

(define-procedure (flquotient (x flonum) 
                              (y flonum))
    (flfloor (fl/ x y)))

(define-procedure (flremainder (x flonum)
                               (y flonum))
    (fl- x (fl* y (flquotient x y))))

(define-procedure
  (flexp2 (z flonum))
  (flexpt 2.0 z))


(define-procedure
  (flinteger-fraction (x flonum))
  (values (flfloor x) (- x (flfloor x))))

(define (flsgn x) (flcopysign 1.0 x))

(define-procedure
  (flcopysign (x flonum) (y flonum))
  (##flcopysign x y))

(define flexp-1 flexpm1)
(define fllog1+ fllog1p)

(define-procedure
  (flnormalized-fraction-exponent (x flonum))
  (let ((repr (##flonum->inexact-exponential-format x)))
  (values
    (* (##flonum->ratnum (fl* 0.5 (vector-ref repr 0))) (vector-ref repr 2))
    (fx+ (vector-ref repr 1) 1))))

(define-macro (interpolate fcn name start end step)
    (define (range-map start step end li fcn)
      (cond
        ((>= start end) li)
        (else
          (range-map
            (+ start step)
            step
            end
            (cons (fcn start (+ start step)) li)
            fcn))))
    `(begin
       (define (,name x)
           (cond
             ,@(range-map start step end '() 
                 (lambda (start end)
                   `((and 
                       (>= x ,start)
                       (<= x ,end))
                     (let ((b ,(eval `(,fcn ,start)))
                          (m ,(/ (- (eval `(,fcn ,end))
                                    (eval `(,fcn ,start)))
                                 (- end start))))
                       (+ b (* m (- x ,start)))))))))))
(define-macro (precompute fcn start end step)
    (define (range-map start step end li fcn)
      (cond
        ((>= start end) li)
        (else
          (range-map
            start
            step
            (- end step)
            (cons (fcn end) li)
            fcn))))
    `(vector ,@(range-map start end step '()
                (lambda (start)
                  (eval `(,fcn ,start))))))
(define (factorial x n)
  (cond
    ((= x 0) n)
    (else
      (factorial (- x 1) (* x n)))))


(cond-expand
  ((compilation-target C)
    (define flgamma (c-lambda (double) double "tgamma"))
    (define flexponent (c-lambda (double) double "logb")) 
    (define flcbrt (c-lambda (double) double "cbrt")) 
    (define flhypot (c-lambda (double double) double "hypot"))
    (define flfirst-bessel (c-lambda (double double) double "jn"))
    (define flsecond-bessel (c-lambda (double double) double "yn"))
    (define flerf (c-lambda (double double) double "erf"))
    (define flerfc (c-lambda (double double) double "erfc"))
    (define flexponent (c-lambda (double) double "logb"))
    (define flnormalized? (double) bool "isnormal")
    (define fldenormalized (double) bool "issubnormal")
   )
  (else
  
    (define-procedure
      (flnormalized? (z flonum))
        (fl>= z (* 2.23 (expt 10 -308))))

    (define-procedure
      (fldenormalized? (z flonum))
        (fl<= z (* 2.23 (expt 10 -308))))

    (define-procedure (flerf (z flonum))
        (fltanh
          (fl* 
          fl-2/sqrt-pi
          (fl+ z
            (fl* 
              (fl/ 11.0 123.0)
              (fl* z z z ))))))

    (define-procedure (flerfc (z flonum))
        (fl- 1.0 (flerf z)))

    (define (pass x)
      (display "\n")
      (write x)
      (display "\n")
      x)
  (define factorials (precompute
       (lambda (x)
        (define (factorial x n)
          (cond
            ((= x 0) n)
            (else
              (factorial (- x 1) (* x n)))))
        (exact->inexact (factorial x 1))) 0 1 170))

    (define (flfirst-bessel x n) #;(flfirst-bessel (x flonum)
                                      (n exact-integer))
        (define (taylor-n x k)
          (fl*
           (fl/ 
              (if (fxodd? k) -1.0 1.0)
              (fl* 
                (if (fx= k 0) 1.0 (vector-ref factorials (- k 1))) 
                (if (= (+ n k) 0) 1.0 (vector-ref factorials (- (+ n k) 1)))))
           (flexpt (fl/ x 2.0) (exact->inexact (+ (fx* 2 k) n)))
           ))

        (cond 
          ((<= x 20)
           (fold
             (lambda (a b) (fl+ a b))
             (taylor-n x 0)
             (map (lambda (n) (taylor-n x n))   
                  '(1 2 3 4 5 6 7 8 9 10 11 12 13 15 15 16 17 18 19 20 21 22 23))))
        (else
            (fl*
              (flcos 
                (fl- x (fl*  (fx+ (fx* 2.0 (##exact-int->flonum n)) 1.0) fl-pi/4)))
                (flsqrt (fl* fl-pi (fl/ 2.0 x)))))))


  ;;  (define-procedure (flsecond-bessel (x flonum) (n exact-integer))
        (define (flsecond-bessel x n)
          (define table-0u #f64(
            -7.38042951086872317523e-02 
             1.76666452509181115538e-01 
            -1.38185671945596898896e-02 
             3.47453432093683650238e-04 
            -3.81407053724364161125e-06 
             1.95590137035022920206e-08 
            -3.98205194132103398453e-11))
            (define table-0v #f64(
             1.00
             1.27304834834123699328e-02 
             7.60068627350353253702e-05 
             2.59150851840457805467e-07 
             4.41110311332675467403e-10)) 
            (define table-1u #f64(
           -1.96057090646238940668e-01
            5.04438716639811282616e-02
           -1.91256895875763547298e-03
            2.35252600561610495928e-05
           -9.19099158039878874504e-08))
            (define table-1v #f64(
            1.00
            1.99167318236649903973e-02
            2.02552581025135171496e-04
            1.35608801097516229404e-06
            6.22741452364621501295e-09
            1.66559246207992079114e-11))
            (define (apply-polynomial vect x end res)
              (if (< end 0)
                   res 
                   (apply-polynomial 
                     vect x (fx- end 1)
                     (fl+
                       (f64vector-ref vect end)
                       (fl* x res)))))
        (define tpi 6.36619772367581382433e-01)
                                    
        (cond
          ((fl< x 0.0) +nan.0)
          ((> n 170) +inf.0)
          ((< n -169) +inf.0)


          ((= n 0)
           (cond
             ((fl= x +inf.0) 0.0)
             ((fl= x 0.0) -inf.0)
             ((fl< x 0.0) +nan.0)
             (else 
               (let ((u (apply-polynomial 
                          table-0u 
                          (fl* x x)
                          (- (vector-length table-0u) 1)
                          0.0))
                     (v (apply-polynomial
                          table-0v
                          (fl* x x)
                          (- (vector-length table-0v) 1)
                          0.0)))
                 (fl+
                   (fl/ u v)
                   (fl* 
                      tpi
                      (flfirst-bessel x 0)
                      (fllog x)))))))
          ((= n 1)
            (let ((u (apply-polynomial  
                       table-1u
                       (fl* x x)
                       (- (vector-length table-1u) 1)
                       0.0))
                   (v (apply-polynomial
                        table-1v
                        (fl* x x)
                        (- (vector-length table-1v) 1)
                        0.0)))
              (fl+
              (fl* x (fl/ u v))
              (fl* 
                tpi
                (fl-
                (fl*
                    (flfirst-bessel x 1)
                    (fllog x))
                (fl/ 1.0 x))))))
          ((fl> x 20.0)
           (fl* 
             (flsqrt (fl/ 2.0 (fl* fl-pi x)))
             (flsin 
               (fl-
                 x 
                 (fl* 
                   fl-pi
                   (fl+
                     0.25
                     (fl/ (fixnum->flonum n) 2.0)))))))
          ((> n 0)
           (fl+
             (fl* -1.0
                (vector-ref factorials (- n 1))
                (fl/ 1.0 fl-pi)
                (flexpt (fl/ 2.0 x) (fixnum->flonum n)))
             (fl* 
               (flexpt (fl/ x 2.0) (fixnum->flonum n)) 
               (fl/ 1.0 (vector-ref factorials n))
               (fl/ 1.0 (fltan (fl* (fixnum->flonum n) x))))))
          ((< n 0)
           (fl* -1.0
            (if (odd? n) -1.0 1.0)
            (flgamma (fl- (fixnum->flonum n)))
            (fl/ 1.0 fl-pi)
            (flexpt (fl/ x 2.0) (fixnum->flonum n))))))
             

        
    (define-procedure
      (flhypot (a flonum) (b flonum))
      (flsqrt (+ (flsquare a) (flsquare b))))

    (define-procedure
      (flexponent (z flonum))
      (vector-ref (##flonum->inexact-exponential-format z) 1))

    (define-procedure
      (flcbrt (z flonum))
      (flcopysign
         (flexpt (flabs z) (/ 1.0 3.0))
         z))

    (define-procedure
      (flgamma (z flonum))

      (cond
        ((fl>= z 170.0) +inf.0) ;; overflow
        ((fl= z -inf.0) +nan.0)
        ((fl<= z -184.0) 0.0) ;; underflow
        ((and (flinteger? z) (fl<= z 0.0)) +nan.0) ;; undefined on those values
        ((fl< z 0.0) (fl/ fl-pi (fl* (flsin (fl* fl-pi z)) (flgamma (fl- 1.0 z))))) ;; Euler's reflection formula
        ((and (flinteger? z) (<= z (vector-length factorials)))
         (if (fl= z 1.0) 1.0 (vector-ref factorials (- (inexact->exact z) 2)))) ;; precomputed factorials
        (else 
          (fl/ 
          (let ((x (fl+ z 8.0)))
            (fl*
              (flsqrt (fl/ fl-2pi x))
              (flexpt (fl/ 
                  (fl*
                    x
                    (flsqrt 
                      (fl+
                          (fl* x (flsinh (fl/ 1.0 x)))
                          (fl/ 1.0 (fl* 810.0 (flexpt x 6.0))))))
                        fl-e) x)))
          (fl* 
            z
            (fl+ z 1.0)
            (fl+ z 2.0)
            (fl+ z 3.0)
            (fl+ z 4.0)
            (fl+ z 5.0)
            (fl+ z 6.0)
            (fl+ z 7.0))
          ))))
    ))


(define (flinteger-exponent x) (truncate (flexponent x)))
(define fl-integer-exponent-zero (flinteger-exponent 0.0))
(define fl-integer-exponent-nan (flinteger-exponent +nan.0))

(define fl-gamma-1/2 fl-sqrt-pi)
(define fl-gamma-2/3 1.3541179394264004169452880281545137855193272660567936983940224679637829654017425416758341479529729111064348236100330588541422615) ;; from https://www.wolframalpha.com/input?i=Gamma%282%2F3%29

(define fl-gamma-1/3 2.6789385347077476336556929409746776441286893779573011009504283275904176101677438195409828890411887894191590492000722633357190845) ;; from https://www.wolframalpha.com/input/?i=Gamma%281%2F3%29
      



