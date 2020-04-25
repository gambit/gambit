(include "#.scm")

(define ##x1 0.5)
(define ##x2 1.5)
(define ##x3 1.0)
(define ##x4 2.0)

(check-same-behavior ("" "##" "~~lib/gambit/prim/flonum#.scm")

;; Gambit

(fixnum->flonum 0) (fixnum->flonum ##min-fixnum) (fixnum->flonum ##max-fixnum)

(fl*) (fl* 2.) (fl* 3. 4.) (fl* 5. 6. 7.)
(fl+) (fl+ 1.) (fl+ 2. 3.) (fl+ 4. 5. 6.)
(fl- 1.) (fl- 2. 3.) (fl- 4. 5. 6.)
(fl/ 2.) (fl/ 3. 4.) (fl/ 5. 6. 7.)

(fl<) (fl< 1.) (fl< 1. 2.) (fl< -0. 0.) (fl< 2. 1.) (fl< 1. 2. 3.) (fl< 1. 1. 1.) (fl< 3. 2. 1.)
(fl<=)(fl<= 1.)(fl<= 1. 2.)(fl<= -0. 0.)(fl<= 2. 1.)(fl<= 1. 2. 3.)(fl<= 1. 1. 1.)(fl<= 3. 2. 1.)
(fl=) (fl= 1.) (fl= 1. 2.) (fl= -0. 0.) (fl= 2. 1.) (fl= 1. 2. 3.) (fl= 1. 1. 1.) (fl= 3. 2. 1.)
(fl>) (fl> 1.) (fl> 1. 2.) (fl> -0. 0.) (fl> 2. 1.) (fl> 1. 2. 3.) (fl> 1. 1. 1.) (fl> 3. 2. 1.)
(fl>=)(fl>= 1.)(fl>= 1. 2.)(fl>= -0. 0.)(fl>= 2. 1.)(fl>= 1. 2. 3.)(fl>= 1. 1. 1.)(fl>= 3. 2. 1.)

(flabs -42.) (flabs 42.) (flabs -0.) (flabs -inf.0)
(flacos ##x1)
(flacosh ##x2)
(flasin ##x1)
(flasinh ##x1)
(flatan ##x1) (flatan ##x3 ##x4)
(flatanh ##x1)

(flceiling -1.5)(flceiling -1.1)(flceiling -1.)(flceiling -.9)(flceiling -.5)
(flceiling -0.)(flceiling 0.)
(flceiling .5)(flceiling .9)(flceiling 1.)(flceiling 1.1)(flceiling 1.5)

(flcos 2.)
(flcosh .5)
(fldenominator -0.0) (fldenominator 0.1) (fldenominator 1e100)
(fleven? -1.) (fleven? 0.) (fleven? 1.)
(flexp 2.)
(flexpm1 2.)
(flexpt 1.5 10.)
(flfinite? -0.)   (flfinite? 1.)    (flfinite? +inf.0) (flfinite? +nan.0)

(flfloor -1.5)(flfloor -1.1)(flfloor -1.)(flfloor -.9)(flfloor -.5)
(flfloor -0.)(flfloor 0.)
(flfloor .5)(flfloor .9)(flfloor 1.)(flfloor 1.1)(flfloor 1.5)

(flhypot 1. 2.)
(flilogb 1024.)
(flinfinite? -0.) (flinfinite? 1.)  (flinfinite? +inf.0) (flinfinite? +nan.0)
(flinteger? -.5)  (flinteger? -0.)  (flinteger? +inf.0) (flinteger? +nan.0)
(fllog 10.) (fllog 10. 2.)
(fllog1p 10.)
(flmax 1.) (flmax 1. 2.) (flmax 2. 1.) (flmax 1. 3. 2.) (flmax 2. 4. 1. 3.)
(flmin 1.) (flmin 1. 2.) (flmin 2. 1.) (flmin 1. 3. 2.) (flmin 2. 4. 1. 3.)
(flnan? -0.)      (flnan? 1.)       (flnan? +inf.0)  (flnan? +nan.0)
(flnegative? -1.) (flnegative? -0.) (flnegative? 0.) (flnegative? 1.)
(flnumerator -0.0) (flnumerator 0.1) (flnumerator 1e100)
(flodd? -1.)  (flodd? 0.)  (flodd? 1.)
(flonum? 'a) (flonum? 1.) (flonum? +inf.0) (flonum? +nan.0)
(flpositive? -1.) (flpositive? -0.) (flpositive? 0.) (flpositive? 1.)

(flround -1.5)(flround -1.1)(flround -1.)(flround -.9)(flround -.5)
(flround -0.)(flround 0.)
(flround .5)(flround .9)(flround 1.)(flround 1.1)(flround 1.5)

(flscalbn 1.5 2)

(flsin 2.)
(flsinh .5)
(flsqrt 1.5)
(flsquare 1.5)
(fltan 2.)
(fltanh .5)

(fltruncate -1.5)(fltruncate -1.1)(fltruncate -1.)(fltruncate -.9)(fltruncate -.5)
(fltruncate -0.)(fltruncate 0.)
(fltruncate .5)(fltruncate .9)(fltruncate 1.)(fltruncate 1.1)(fltruncate 1.5)

(flzero? -1.)     (flzero? -0.)     (flzero? 0.)     (flzero? 1.)

)
