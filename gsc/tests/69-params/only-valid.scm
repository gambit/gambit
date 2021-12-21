(declare (extended-bindings) (not constant-fold) (not safe))

(define (display-newline obj)
  (cond ((##pair? obj)
         (println "(")
         (let loop ((lst obj))
           (if (##pair? lst)
               (begin
                 (display-newline (##car lst))
                 (loop (##cdr lst)))
               (println ")"))))
        ((##null? obj)
         (println "()"))
        (else
         (println obj))))

(define (##apply-global-with-procedure-check-nary gv . args)
  (##declare (not interrupts-enabled))
  (##apply-with-procedure-check (##global-var-ref gv) args))

(define (##apply-with-procedure-check-nary oper . args)
  (##declare (not interrupts-enabled))
  (##apply-with-procedure-check oper args))

(define (##apply-with-procedure-check oper args)
  (##declare (not interrupts-enabled))
  (if (##procedure? oper)
      (##apply oper args)
      (println "nonprocedure-operator-exception")))

;; Testing no optional parameters and no rest
(define (normal-0) 1)
(define (normal-flags a b c) c)
(define (normal-ps a b c d e f) f)
(define (f0) 0)
(define (f1 a) a)
(define (f2 a b) b)
(define (f3 a b c) c)
(define (f4 a b c d) d)
(define (f5 a b c d e) e)
(define (f6 a b c d e f) f)
(define (f7 a b c d e f g) g)
(define (f8 a b c d e f g h) h)
(define (f9 a b c d e f g h i) i)
(define (f9-1 a b c d e f g h i) a)
(define (f9-2 a b c d e f g h i) b)
(define (f9-3 a b c d e f g h i) c)
(define (f9-4 a b c d e f g h i) d)
(define (f9-5 a b c d e f g h i) e)
(define (f9-6 a b c d e f g h i) f)
(define (f9-7 a b c d e f g h i) g)
(define (f9-8 a b c d e f g h i) h)
(define (f9-9 a b c d e f g h i) i)

(display-newline "\nRegular:")

;; Valid calls
(display-newline (normal-0))              ;; 1
(display-newline (normal-flags 1 2 3))    ;; 3
(display-newline (normal-ps 1 2 3 4 5 6)) ;; 6
(display-newline (f0))                    ;; 0
(display-newline (f1 1))                  ;; 1
(display-newline (f2 1 2))                ;; 2
(display-newline (f3 1 2 3))              ;; 3
(display-newline (f4 1 2 3 4))            ;; 4
(display-newline (f5 1 2 3 4 5))          ;; 5
(display-newline (f6 1 2 3 4 5 6))        ;; 6
(display-newline (f7 1 2 3 4 5 6 7))      ;; 7
(display-newline (f8 1 2 3 4 5 6 7 8))    ;; 8
(display-newline (f9 1 2 3 4 5 6 7 8 9))  ;; 9

;; Invalid calls
; (display-newline (normal-0 1 2 3 4 5 6 7))
; (display-newline (normal-flags))
; (display-newline (normal-flags 1))
; (display-newline (normal-flags 1 2))
; (display-newline (normal-flags 1 2 3 4))
; (display-newline (normal-flags 1 2 3 4 5))
; (display-newline (normal-ps 1 2 3))
; (display-newline (normal-ps 1 2 3 4 5 6 7 8))

;; Testing optional parameters and no rest
(define (opt1a #!optional (a -1)) a)

(define (opt2-0a #!optional (a -1) (b -2)) a)
(define (opt2-0b #!optional (a -1) (b -2)) b)
(define (opt2-1a a #!optional (b -2)) a)
(define (opt2-1b a #!optional (b -2)) b)

(define (opt3-0a #!optional (a -1) (b -2) (c -3)) a)
(define (opt3-0b #!optional (a -1) (b -2) (c -3)) b)
(define (opt3-0c #!optional (a -1) (b -2) (c -3)) c)
(define (opt3-1a a #!optional (b -2) (c -3)) a)
(define (opt3-1b a #!optional (b -2) (c -3)) b)
(define (opt3-1c a #!optional (b -2) (c -3)) c)
(define (opt3-2a a b #!optional (c -3)) a)
(define (opt3-2b a b #!optional (c -3)) b)
(define (opt3-2c a b #!optional (c -3)) c)

(define (opt9-0a #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) a)
(define (opt9-0b #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) b)
(define (opt9-0c #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) c)
(define (opt9-0d #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) d)
(define (opt9-0e #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) e)
(define (opt9-0f #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) f)
(define (opt9-0g #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) g)
(define (opt9-0h #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) h)
(define (opt9-0i #!optional (a 1) (b 2) (c 3) (d 4) (e 5) (f 6) (g 7) (h 8) (i 9)) i)

; (define (opt5-0a #!optional (a -1) (b -2) (c -3) (d -4) (e -5)) a)
; (define (opt5-0b #!optional (a -1) (b -2) (c -3) (d -4) (e -5)) b)
; (define (opt5-0c #!optional (a -1) (b -2) (c -3) (d -4) (e -5)) c)
; (define (opt5-0d #!optional (a -1) (b -2) (c -3) (d -4) (e -5)) d)
; (define (opt5-0e #!optional (a -1) (b -2) (c -3) (d -4) (e -5)) e)
; (define (opt5-1a a #!optional (b -2) (c -3) (d -4) (e -5)) a)
; (define (opt5-1b a #!optional (b -2) (c -3) (d -4) (e -5)) b)
; (define (opt5-1c a #!optional (b -2) (c -3) (d -4) (e -5)) c)
; (define (opt5-1d a #!optional (b -2) (c -3) (d -4) (e -5)) d)
; (define (opt5-1e a #!optional (b -2) (c -3) (d -4) (e -5)) e)
; (define (opt5-2a a b #!optional (c -3) (d -4) (e -5)) a)
; (define (opt5-2b a b #!optional (c -3) (d -4) (e -5)) b)
; (define (opt5-2c a b #!optional (c -3) (d -4) (e -5)) c)
; (define (opt5-2d a b #!optional (c -3) (d -4) (e -5)) d)
; (define (opt5-2e a b #!optional (c -3) (d -4) (e -5)) e)

(display-newline "\nOptional:")

;; Valid calls
(display-newline (opt1a))         ;; -1
(display-newline (opt1a 1))       ;; 1

(display-newline (opt2-0a))       ;; -1
(display-newline (opt2-0a 1))     ;; 1
(display-newline (opt2-0a 1 2))   ;; 1
(display-newline (opt2-0b))       ;; -2
(display-newline (opt2-0b 1))     ;; -2
(display-newline (opt2-0b 1 2))   ;; 2
(display-newline (opt2-1a 1))     ;; 1
(display-newline (opt2-1a 1 2))   ;; 1
(display-newline (opt2-1b 1))     ;; -2
(display-newline (opt2-1b 1 2))   ;; 2

(display-newline (opt3-0a))       ;; -1
(display-newline (opt3-0a 1))     ;; 1
(display-newline (opt3-0a 1 2))   ;; 1
(display-newline (opt3-0a 1 2 3)) ;; 1
(display-newline (opt3-0b))       ;; -2
(display-newline (opt3-0b 1))     ;; -2
(display-newline (opt3-0b 1 2))   ;; 2
(display-newline (opt3-0b 1 2 3)) ;; 2
(display-newline (opt3-0c))       ;; -3
(display-newline (opt3-0c 1))     ;; -3
(display-newline (opt3-0c 1 2))   ;; -3
(display-newline (opt3-0c 1 2 3)) ;; 3
(display-newline (opt3-1a 1))     ;; 1
(display-newline (opt3-1a 1 2))   ;; 1
(display-newline (opt3-1a 1 2 3)) ;; 1
(display-newline (opt3-1b 1))     ;; -2
(display-newline (opt3-1b 1 2))   ;; 2
(display-newline (opt3-1b 1 2 3)) ;; 2
(display-newline (opt3-1c 1))     ;; -3
(display-newline (opt3-1c 1 2))   ;; -3
(display-newline (opt3-1c 1 2 3)) ;; 3
(display-newline (opt3-2a 1 2))   ;; 1
(display-newline (opt3-2a 1 2 3)) ;; 1
(display-newline (opt3-2b 1 2))   ;; 2
(display-newline (opt3-2b 1 2 3)) ;; 2
(display-newline (opt3-2c 1 2))   ;; -3
(display-newline (opt3-2c 1 2 3)) ;; 3

(display-newline (opt9-0a 1 2 3 4 5 6 7 8 9))  ;; 1
(display-newline (opt9-0b 1 2 3 4 5 6 7 8 9))  ;; 2
(display-newline (opt9-0c 1 2 3 4 5 6 7 8 9))  ;; 3
(display-newline (opt9-0d 1 2 3 4 5 6 7 8 9))  ;; 4
(display-newline (opt9-0e 1 2 3 4 5 6 7 8 9))  ;; 5
(display-newline (opt9-0f 1 2 3 4 5 6 7 8 9))  ;; 6
(display-newline (opt9-0g 1 2 3 4 5 6 7 8 9))  ;; 7
(display-newline (opt9-0h 1 2 3 4 5 6 7 8 9))  ;; 8
(display-newline (opt9-0i 1 2 3 4 5 6 7 8 9))  ;; 9

(display-newline (opt9-0a 1 2 3 4 5)) ;; 1
(display-newline (opt9-0b 1 2 3 4 5)) ;; 2
(display-newline (opt9-0c 1 2 3 4 5)) ;; 3
(display-newline (opt9-0d 1 2 3 4 5)) ;; 4
(display-newline (opt9-0e 1 2 3 4 5)) ;; 5
(display-newline (opt9-0f 1 2 3 4 5)) ;; 6
(display-newline (opt9-0g 1 2 3 4 5)) ;; 7
(display-newline (opt9-0h 1 2 3 4 5)) ;; 8
(display-newline (opt9-0i 1 2 3 4 5)) ;; 9

;; Invalid calls
;; ...

;; Testing no optional parameters and rest

(define (rest0-r . r) r)
(define (rest1-a a . r) a)
(define (rest1-r a . r) r)
(define (rest2-a a . r) a)
(define (rest2-b a b . r) b)
(define (rest2-r a b . r) r)
(define (rest3-a a . r) a)
(define (rest3-b a b . r) b)
(define (rest3-c a b c . r) c)
(define (rest3-r a b c . r) r)
(define (rest4-a a . r) a)
(define (rest4-b a b . r) b)
(define (rest4-c a b c . r) c)
(define (rest4-d a b c d . r) d)
(define (rest4-r a b c d . r) r)
(define (rest5-a a . r) a)
(define (rest5-b a b . r) b)
(define (rest5-c a b c . r) c)
(define (rest5-d a b c d . r) d)
(define (rest5-e a b c d e . r) e)
(define (rest5-r a b c d e . r) r)
(define (rest6-a a . r) a)
(define (rest6-b a b . r) b)
(define (rest6-c a b c . r) c)
(define (rest6-d a b c d . r) d)
(define (rest6-e a b c d e  . r) e)
(define (rest6-f a b c d e f . r) f)
(define (rest6-r a b c d e f . r) r)

(display-newline "\nRest:")

;; Valid calls
;; Some tests are redundant
(display-newline (rest0-r 0 1 2 3 4 5 6)) ;; (0 1 2 3 4 5 6)
(display-newline (rest1-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest1-r 0 1 2 3 4 5 6)) ;; (1 2 3 4 5 6)
(display-newline (rest2-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest2-b 0 1 2 3 4 5 6)) ;; 1
(display-newline (rest2-r 0 1 2 3 4 5 6)) ;; (2 3 4 5 6)
(display-newline (rest3-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest3-b 0 1 2 3 4 5 6)) ;; 1
(display-newline (rest3-c 0 1 2 3 4 5 6)) ;; 2
(display-newline (rest3-r 0 1 2 3 4 5 6)) ;; (3 4 5 6)
(display-newline (rest4-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest4-b 0 1 2 3 4 5 6)) ;; 1
(display-newline (rest4-c 0 1 2 3 4 5 6)) ;; 2
(display-newline (rest4-d 0 1 2 3 4 5 6)) ;; 3
(display-newline (rest4-r 0 1 2 3 4 5 6)) ;; (4 5 6)
(display-newline (rest5-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest5-b 0 1 2 3 4 5 6)) ;; 1
(display-newline (rest5-c 0 1 2 3 4 5 6)) ;; 2
(display-newline (rest5-d 0 1 2 3 4 5 6)) ;; 3
(display-newline (rest5-e 0 1 2 3 4 5 6)) ;; 4
(display-newline (rest5-r 0 1 2 3 4 5 6)) ;; (5 6)
(display-newline (rest6-a 0 1 2 3 4 5 6)) ;; 0
(display-newline (rest6-b 0 1 2 3 4 5 6)) ;; 1
(display-newline (rest6-c 0 1 2 3 4 5 6)) ;; 2
(display-newline (rest6-d 0 1 2 3 4 5 6)) ;; 3
(display-newline (rest6-e 0 1 2 3 4 5 6)) ;; 4
(display-newline (rest6-f 0 1 2 3 4 5 6)) ;; 5
(display-newline (rest6-r 0 1 2 3 4 5 6)) ;; (6)

;; Invalid calls
;; ...

;; Testing optional parameters and rest

(define (optrest1-0a #!optional (a -1) . r) a)
(define (optrest1-0r #!optional (a -1) . r) r)
(define (optrest2-0a #!optional (a -1) (b -2) . r) a)
(define (optrest2-0b #!optional (a -1) (b -2) . r) b)
(define (optrest2-0r #!optional (a -1) (b -2) . r) r)
(define (optrest2-1a a #!optional (b -2) . r) a)
(define (optrest2-1b a #!optional (b -2) . r) b)
(define (optrest2-1r a #!optional (b -2) . r) r)

(define (optrest3-0a #!optional (a -1) (b -2) (c -3) . r) a)
(define (optrest3-0b #!optional (a -1) (b -2) (c -3) . r) b)
(define (optrest3-0c #!optional (a -1) (b -2) (c -3) . r) c)
(define (optrest3-0r #!optional (a -1) (b -2) (c -3) . r) r)
(define (optrest3-1a a #!optional (b -2) (c -3) . r) a)
(define (optrest3-1b a #!optional (b -2) (c -3) . r) b)
(define (optrest3-1c a #!optional (b -2) (c -3) . r) c)
(define (optrest3-1r a #!optional (b -2) (c -3) . r) r)
(define (optrest3-2a a b #!optional (c -3) . r) a)
(define (optrest3-2b a b #!optional (c -3) . r) b)
(define (optrest3-2c a b #!optional (c -3) . r) c)
(define (optrest3-2r a b #!optional (c -3) . r) r)

(define (optrest8-0a #!optional (a -1) (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) a)
(define (optrest8-0b #!optional (a -1) (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) b)
(define (optrest8-0c #!optional (a -1) (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) c)
(define (optrest8-0d #!optional (a -1) (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) d)
(define (optrest8-0r #!optional (a -1) (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) r)
(define (optrest8-1a a #!optional (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) a)
(define (optrest8-1b a #!optional (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) b)
(define (optrest8-1c a #!optional (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) c)
(define (optrest8-1d a #!optional (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) d)
(define (optrest8-1r a #!optional (b -2) (c -3) (d -4) (e -5) (f -6) (g -7) (h -8) . r) r)
(define (optrest8-3a a b c #!optional (d -4) (e -5) (f -6) (g -7) (h -8) . r) a)
(define (optrest8-3b a b c #!optional (d -4) (e -5) (f -6) (g -7) (h -8) . r) b)
(define (optrest8-3c a b c #!optional (d -4) (e -5) (f -6) (g -7) (h -8) . r) c)
(define (optrest8-3d a b c #!optional (d -4) (e -5) (f -6) (g -7) (h -8) . r) d)
(define (optrest8-3r a b c #!optional (d -4) (e -5) (f -6) (g -7) (h -8) . r) r)
(define (optrest8-5a a b c d e #!optional (f -6) (g -7) (h -8) . r) a)
(define (optrest8-5b a b c d e #!optional (f -6) (g -7) (h -8) . r) b)
(define (optrest8-5c a b c d e #!optional (f -6) (g -7) (h -8) . r) c)
(define (optrest8-5d a b c d e #!optional (f -6) (g -7) (h -8) . r) d)
(define (optrest8-5r a b c d e #!optional (f -6) (g -7) (h -8) . r) r)

(display-newline "\nOptional and rest:")

(display-newline (optrest1-0a))               ;; -1
(display-newline (optrest1-0r))               ;; ()
(display-newline (optrest1-0a 1))             ;; 1
(display-newline (optrest1-0r 1))             ;; ()
(display-newline (optrest1-0a 1 2 3))         ;; 1
(display-newline (optrest1-0r 1 2 3))         ;; (2 3)
(display-newline (optrest1-0a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest1-0r 1 2 3 4 5 6 7)) ;; (2 3 4 5 6 7)

(display-newline (optrest2-0a))               ;; -1
(display-newline (optrest2-0b))               ;; -2
(display-newline (optrest2-0r))               ;; ()
(display-newline (optrest2-0a 1))             ;; 1
(display-newline (optrest2-0b 1))             ;; -2
(display-newline (optrest2-0r 1))             ;; ()
(display-newline (optrest2-0a 1 2 3))         ;; 1
(display-newline (optrest2-0b 1 2 3))         ;; 2
(display-newline (optrest2-0r 1 2 3))         ;; (3)
(display-newline (optrest2-0a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest2-0b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest2-0r 1 2 3 4 5 6 7)) ;; (3 4 5 6 7)

(display-newline (optrest2-1a 1))             ;; 1
(display-newline (optrest2-1b 1))             ;; -2
(display-newline (optrest2-1r 1))             ;; ()
(display-newline (optrest2-1a 1 2 3))         ;; 1
(display-newline (optrest2-1b 1 2 3))         ;; 2
(display-newline (optrest2-1r 1 2 3))         ;; (3)
(display-newline (optrest2-1a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest2-1b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest2-1r 1 2 3 4 5 6 7)) ;; (3 4 5 6 7)

(display-newline (optrest3-0a))               ;; -1
(display-newline (optrest3-0b))               ;; -2
(display-newline (optrest3-0c))               ;; -3
(display-newline (optrest3-0r))               ;; ()
(display-newline (optrest3-0a 1))             ;; 1
(display-newline (optrest3-0b 1))             ;; -2
(display-newline (optrest3-0c 1))             ;; -3
(display-newline (optrest3-0r 1))             ;; ()
(display-newline (optrest3-0a 1 2 3))         ;; 1
(display-newline (optrest3-0b 1 2 3))         ;; 2
(display-newline (optrest3-0c 1 2 3))         ;; 3
(display-newline (optrest3-0r 1 2 3))         ;; ()
(display-newline (optrest3-0a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest3-0b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest3-0c 1 2 3 4 5 6 7)) ;; 3
(display-newline (optrest3-0r 1 2 3 4 5 6 7)) ;; (4 5 6 7)

(display-newline (optrest3-1a 1))             ;; 1
(display-newline (optrest3-1b 1))             ;; -2
(display-newline (optrest3-1c 1))             ;; -3
(display-newline (optrest3-1r 1))             ;; ()
(display-newline (optrest3-1a 1 2 3))         ;; 1
(display-newline (optrest3-1b 1 2 3))         ;; 2
(display-newline (optrest3-1c 1 2 3))         ;; 3
(display-newline (optrest3-1r 1 2 3))         ;; ()
(display-newline (optrest3-1a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest3-1b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest3-1c 1 2 3 4 5 6 7)) ;; 3
(display-newline (optrest3-1r 1 2 3 4 5 6 7)) ;; (4 5 6 7)

(display-newline (optrest3-2a 1 2 3))         ;; 1
(display-newline (optrest3-2b 1 2 3))         ;; 2
(display-newline (optrest3-2c 1 2 3))         ;; 3
(display-newline (optrest3-2r 1 2 3))         ;; ()
(display-newline (optrest3-2a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest3-2b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest3-2c 1 2 3 4 5 6 7)) ;; 3
(display-newline (optrest3-2r 1 2 3 4 5 6 7)) ;; (4 5 6 7)

(display-newline (optrest8-0a))               ;; -1
(display-newline (optrest8-0b))               ;; -2
(display-newline (optrest8-0c))               ;; -3
(display-newline (optrest8-0d))               ;; -4
(display-newline (optrest8-0r))               ;; ()
(display-newline (optrest8-0a 1))             ;; 1
(display-newline (optrest8-0b 1))             ;; -2
(display-newline (optrest8-0c 1))             ;; -3
(display-newline (optrest8-0d 1))             ;; -4
(display-newline (optrest8-0r 1))             ;; ()
(display-newline (optrest8-0a 1 2 3 4))       ;; 1
(display-newline (optrest8-0b 1 2 3 4))       ;; 2
(display-newline (optrest8-0c 1 2 3 4))       ;; 3
(display-newline (optrest8-0d 1 2 3 4))       ;; 4
(display-newline (optrest8-0r 1 2 3 4))       ;; ()
(display-newline (optrest8-0a 1 2 3 4 5 6 7)) ;; 1
(display-newline (optrest8-0b 1 2 3 4 5 6 7)) ;; 2
(display-newline (optrest8-0c 1 2 3 4 5 6 7)) ;; 3
(display-newline (optrest8-0d 1 2 3 4 5 6 7)) ;; 4
(display-newline (optrest8-0r 1 2 3 4 5 6 7)) ;; ()
(display-newline (optrest8-0r 1 2 3 4 5 6 7 8 9 10 11)) ;; (9 10 11)

(display-newline "END")
