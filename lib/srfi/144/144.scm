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
(rename (fl= fl< fl> fl<= fl>=) || ?)
(reexport (fl+ fl- flzero? flpositive? 
        flnegative? flodd? fleven? flfinite? flnan?
;        flnormalized? fldenormalized? flexp-1 fllog1+  flquotient  flremainder flremquo
        flmax flmin flexp flsquare flsqrt flexpt fllog
        flsin flcos fltan flasin flacos flatan flsinh flinteger?
        flcosh fltanh flasinh flacosh flatanh flfloor flceiling flround
        fltruncate
        fl+* fl* fl/ flabs))


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

(define a1 0.278393)
(define a2 0.230389)
(define a3 0.000972)
(define a4 0.078108)


      


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

(define-procedure (flremquo (x flonum) 
                            (y flonum))
    (values
      (flremainder x y)
      (inexact->exact (flquotient x y))))

(define-procedure
  (flinteger-fraction (x flonum))
  (values (flfloor x) (- x (flfloor x))))

(define (flsgn x) (flcopysign 1.0 x))

(define-procedure
  (flcopysign (x flonum) (y flonum))
  (cond
    ((>= y 0) (abs x))
    (else (* -1  (abs x)))))

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

(define snum #f64(
	23531376880.410759688572007674451636754734846804940
	42919803642.649098768957899047001988850926355848959
	35711959237.355668049440185451547166705960488635843
	17921034426.037209699919755754458931112671403265390
	6039542586.3520280050642916443072979210699388420708
	1439720407.3117216736632230727949123939715485786772
	248874557.86205415651146038641322942321632125127801
	31426415.585400194380614231628318205362874684987640
	2876370.6289353724412254090516208496135991145378768
	186056.26539522349504029498971604569928220784236328
	8071.6720023658162106380029022722506138218516325024
	210.82427775157934587250973392071336271166969580291
	2.5066282746310002701649081771338373386264310793408))

(define sden #f64(0.0  39916800.0  120543840.0  150917976.0  105258076.0  45995730.0  13339535.0 
	2637558.0  357423.0  32670.0  1925.0  66.0  1.0))


(define (flinteger-exponent x) (truncate (flexponent x)))
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
      (write x)
      (display "\n")
      x)

    (define-procedure (flfirst-bessel (x flonum)
                                      (n exact-integer))
    
        (fl*
          (flcos 
            (fl- x (fl*  (fx+ (fx* 2.0 (##exact-int->flonum n)) 1.0) fl-pi/4)))
            (flsqrt (fl* fl-pi (fl/ 2 x)))))

    (define-procedure (flsecond-bessel (x flonum)
                                       (n exact-integer))
        (fl*
          (flsin 
            (fl- x (fl* (fixnum->flonum (fx+ (fx* 2.0 n) 1.0)) fl-pi/4)))
            (flsqrt (fl* fl-pi (fl/ 2 x)))))
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

    (interpolate 
      (lambda (x)
        (define (accurate-gamma x steps result) ;; Incedibly slow but accurate gamma function
          (cond
            ((= x 0) +inf.0)
            ((= steps 0) (accurate-gamma x 1 (/ 1 x)))
            ((= steps 1000) result)
            (else
              (accurate-gamma
                x (+ steps 1)
                (* result
                   (* 
                     (/ 1 (+ 1 (/ x steps)))
                     (expt (+ 1 (/ 1 steps)) x)))))))
        (accurate-gamma x 0 0)) interpolated-gamma 0 1 0.001)
    (define-procedure
      (flgamma (z flonum))
      (define factorials (precompute
           (lambda (x)
            (define (factorial x n)
              (cond
                ((= x 0) n)
                (else
                  (factorial (- x 1) (* x n)))))
            (factorial x 1)) 0 1 170))
        (define (S x n num den)
          (cond
            ((= n 12) (fl/ num den))
            (else
              (S x (fx+ n 1)
                 (fl+ (fl/ num x) (vector-ref snum n))
                 (fl+ (fl/ num x) (vector-ref sden n))))))

      (define g 6.024680040776729583740234375)
      (cond
        ((fl>= z 170.0) +inf.0) ;; overflow
        ((fl= z -inf.0) +nan.0)
        ((fl<= z -184.0) 0.0) ;; underflow
        ((and (flinteger? z) (fl<= z 0.0)) +nan.0) ;; undefined on those values
        ((fl< z 0.0) (fl/ fl-pi (fl* (flsin (fl* fl-pi z)) (flgamma (fl- 1.0 z))))) ;; Euler's reflection formula
        ((and (flinteger? z) (<= z (vector-length factorials)))
         (vector-ref factorials (- (inexact->exact z) 1))) ;; precomputed factorials
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
          ))))))

(define fl-gamma-1/2 fl-sqrt-pi)
(define fl-gamma-2/3 1.3541179394264004169452880281545137855193272660567936983940224679637829654017425416758341479529729111064348236100330588541422615) ;; from https://www.wolframalpha.com/input?i=Gamma%282%2F3%29

(define fl-gamma-1/3 2.6789385347077476336556929409746776441286893779573011009504283275904176101677438195409828890411887894191590492000722633357190845) ;; from https://www.wolframalpha.com/input/?i=Gamma%281%2F3%29
      



