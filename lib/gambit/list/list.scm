;;;============================================================================

;;; File: "list.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; List operations.

(##include "list#.scm")

;;;----------------------------------------------------------------------------

(define-fail-check-type pair 'pair)
(define-fail-check-type pair-list 'pair-list)
(define-fail-check-type list 'list)

(define-prim (##pair? obj))

(define-prim (pair? obj)
  (macro-force-vars (obj)
    (##pair? obj)))

(define-prim (##cons obj1 obj2))

(define-prim (cons obj1 obj2)
  (##cons obj1 obj2))

(##define-macro (define-prim-c...r-procedures from-length to-length)

  (define (gen-name pattern)

    (define (ads pattern)
      (if (= pattern 1)
          ""
          (string-append (ads (quotient pattern 2))
                         (if (odd? pattern) "d" "a"))))

    (string->symbol (string-append "c" (ads pattern) "r")))

  (define (gen3 i j)
    (if (> i j)
        `()
        (let* ((name
                (gen-name i))
               (##name
                (string->symbol (string-append "##" (symbol->string name)))))

          (define (gen1 var pattern)
            (if (<= pattern 3)
                (if (= pattern 3) `(##cdr ,var) `(##car ,var))
                `(let ((x ,(if (odd? pattern) `(##cdr ,var) `(##car ,var))))
                   ,(gen1 'x (quotient pattern 2)))))

          (define (gen2 var pattern)
            `(macro-check-pair ,var 1 (,name pair);;TODO: error message confusing?
               ,(if (<= pattern 3)
                    (if (= pattern 3) `(##cdr ,var) `(##car ,var))
                    `(let ((x ,(if (odd? pattern) `(##cdr ,var) `(##car ,var))))
                       (macro-force-vars (x)
                         ,(gen2 'x (quotient pattern 2)))))))

          `((define-prim (,##name pair)
              ,(gen1 'pair i))

            (define-prim (,name pair)
              (macro-force-vars (pair)
                ,(gen2 'pair i)))

            ,@(gen3 (+ i 1) j)))))

  `(begin ,@(gen3 (expt 2 from-length) (- (expt 2 (+ to-length 1)) 1))))

(define-prim-c...r-procedures 1 4) ;; define car to cddddr

(define-prim (##set-car! pair val))

(define-prim (set-car! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-car! pair val)
      (macro-check-mutable pair 1 (set-car! pair val)
        (begin
          (##set-car! pair val)
          (##void))))))

(define-prim (##set-cdr! pair val))

(define-prim (set-cdr! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-cdr! pair val)
      (macro-check-mutable pair 1 (set-cdr! pair val)
        (begin
          (##set-cdr! pair val)
          (##void))))))

(define-prim (##null? obj)
  (##eq? obj '()))

(define-prim (null? obj)
  (macro-force-vars (obj)
    (##null? obj)))

(define-prim (##list? lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  ;; This procedure may get into an infinite loop if another thread
  ;; mutates "lst" (if lst1 and lst2 each point to disconnected cycles).

  (let loop ((lst1 lst) (lst2 lst))
    (macro-force-vars (lst1)
      (if (not (pair? lst1))
          (null? lst1)
          (let ((lst1 (cdr lst1)))
            (macro-force-vars (lst1 lst2)
              (cond ((eq? lst1 lst2)
                     #f)
                    ((not (pair? lst2))
                     ;; this case is possible if other threads mutate the list
                     (null? lst2))
                    ((pair? lst1)
                     (loop (cdr lst1) (cdr lst2)))
                    (else
                     (null? lst1)))))))))

(define-prim (list? lst)
  (##list? lst))

(define-prim (##list . lst)
  lst)

(define-prim (list . lst)
  lst)

(define-prim (##length lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst) (n 0))
    (if (pair? x)
        (loop (cdr x) (fx+ n 1))
        n)))

(define-prim (length lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" length)) ;; but not length to ##length

  (let loop ((x lst) (n 0))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (fx+ n 1))
          (macro-check-list x 1 (length lst)
            n)))))

(define-prim (##append2 lst1 lst2)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (if (pair? lst1)
      (cons (car lst1) (##append2 (cdr lst1) lst2))
      lst2))

(define-prim (##append-lists lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (if (pair? lst)
      (let ((rev-lst (reverse lst)))
        (let loop ((rev-lst (cdr rev-lst)) (result (car rev-lst)))
          (if (pair? rev-lst)
              (loop (cdr rev-lst)
                    (##append2 (car rev-lst) result))
              result)))
      '()))

(define-prim (##append
              #!optional
              (lst1 (macro-absent-obj))
              (lst2 (macro-absent-obj))
              #!rest
              others)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (if (eq? lst2 (macro-absent-obj))
      (if (eq? lst1 (macro-absent-obj))
          '()
          lst1)
      (##append-lists (cons lst1 (cons lst2 others)))))

(define-prim (append
              #!optional
              (lst1 (macro-absent-obj))
              (lst2 (macro-absent-obj))
              #!rest
              others)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" append)) ;; but not append to ##append

  (define (append-multiple head tail arg-num)
    (if (null? tail)
        head
        (macro-force-vars (head)
          (if (null? head)
              (append-multiple (car tail) (cdr tail) (fx+ arg-num 1))
              (list-expected-check
               (append-multiple-non-null head
                                         tail
                                         arg-num
                                         (fx+ arg-num 1)))))))

  (define (append-multiple-non-null x lsts arg-num1 arg-num2)
    ;; x!=(), returns fixnum on error
    (let ((head (car lsts))
          (tail (cdr lsts)))
      (if (null? tail)
          (append-2-non-null x head arg-num1)
          (macro-force-vars (head)
            (if (null? head)
                (append-multiple-non-null x
                                          tail
                                          arg-num1
                                          (fx+ arg-num2 1))
                (let ((result
                       (append-multiple-non-null head
                                                 tail
                                                 arg-num2
                                                 (fx+ arg-num2 1))))
                  (macro-if-checks
                   (if (fixnum? result)
                       result
                       (append-2-non-null x result arg-num1))
                   (append-2-non-null x result arg-num1))))))))

  (define (append-2-non-null x y arg-num)
    ;; x!=(), returns fixnum on error
    (if (pair? x)
        (let ((result (cons (car x) '())))
          (let loop ((last result) (tail (cdr x)))
            (macro-force-vars (tail)
              (if (pair? tail)
                  (let ((next (cons (car tail) '())))
                    (set-cdr! last next)
                    (loop next (cdr tail)))
                  (begin
                    (set-cdr! last y)
                    (macro-if-checks
                     (if (null? tail)
                         result
                         arg-num) ;; error: list expected
                     result))))))
        (macro-if-checks
         arg-num ;; error: list expected
         y)))

  (define (list-expected-check result)
    (macro-if-checks
     (if (fixnum? result)
         (macro-fail-check-list result (append lst1 lst2 . others))
         result)
     result))

  (cond ((eq? lst2 (macro-absent-obj))
         (if (eq? lst1 (macro-absent-obj))
             '()
             lst1))
        ((null? others)
         (macro-force-vars (lst1)
           (if (null? lst1)
               lst2
               (list-expected-check (append-2-non-null lst1 lst2 1)))))
        (else
         (append-multiple lst1 (cons lst2 others) 1))))

(define-prim (##reverse lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst) (result '()))
    (if (pair? x)
        (loop (cdr x) (cons (car x) result))
        result)))

(define-prim (reverse lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" reverse)) ;; but not reverse to ##reverse

  (let loop ((x lst) (result '()))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (cons (car x) result))
          (macro-check-list x 1 (reverse lst)
            result)))))

(define-prim (##list-ref lst k)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" list-ref)) ;; but not list-ref to ##list-ref

  (let loop ((x lst) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        (car x))))

(define-prim (list-ref lst k)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" list-ref)) ;; but not list-ref to ##list-ref

  (macro-force-vars (k)
    (macro-check-index k 2 (list-ref lst k)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-ref lst k);;;;;;;error message confusing?
            (if (fx< 0 i)
                (loop (cdr x) (fx- i 1))
                (car x))))))))

(define-prim (##list-set! lst k val)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        (begin
          (set-car! x val)
          (void)))))

(define-prim (list-set! lst k val)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" list-set!)) ;; but not list-set! to ##list-set!

  (macro-force-vars (k)
    (macro-check-index k 2 (list-set! lst k val)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-set! lst k val)
            (if (fx< 0 i)
                (loop (cdr x) (fx- i 1))
                (macro-check-mutable x 1 (list-set! lst k val)
                  (begin
                    (set-car! x val)
                    (void))))))))))

(define-prim (##list-set lst k val)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (set x i)
    (if (fx< 0 i)
        (cons (car x) (set (cdr x) (fx- i 1)))
        (cons val (cdr x))))

  (set lst k))

(define-prim (list-set lst k val)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" list-set)) ;; but not list-set to ##list-set

  (macro-force-vars (k)
    (macro-check-index k 2 (list-set lst k val)

      (let ()

        (define (set x i)
          (macro-force-vars (x)
            (if (pair? x)
                (if (fx< 0 i)
                    (let ((r (set (cdr x) (fx- i 1))))
                      (if (pair? r)
                          (cons (car x) r)
                          r))
                    (cons val (cdr x)))
                #f)))

        (or (set lst k)
            (##fail-check-pair 1 list-set lst k val))))))

(define-prim (##memq obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst))
    (if (pair? x)
        (if (eq? obj (car x))
            x
            (loop (cdr x)))
        #f)))

(define-prim (memq obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" memq)) ;; but not memq to ##memq

  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (pair? x)
            (let ((y (car x)))
              (macro-force-vars (y)
                (if (eq? obj y)
                    x
                    (loop (cdr x)))))
            (macro-check-list x 2 (memq obj lst)
              #f))))))

(define-prim (##memv obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst))
    (if (pair? x)
        (if (let ()
              (##declare (generic)) ;; avoid fixnum specific eqv?
              (eqv? obj (car x)))
            x
            (loop (cdr x)))
        #f)))

(define-prim (memv obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" memv)) ;; but not memv to ##memv

  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (pair? x)
            (let ((y (car x)))
              (macro-force-vars (y)
                (if (let ()
                      (##declare (generic)) ;; avoid fixnum specific eqv?
                      (eqv? obj y))
                    x
                    (loop (cdr x)))))
            (macro-check-list x 2 (memv obj lst)
              #f))))))

(define-prim (##member obj lst #!optional (compare ##equal?))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst))
    (if (pair? x)
        (if (compare obj (car x))
            x
            (loop (cdr x)))
        #f)))

(define-prim (member obj lst #!optional (c (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" member)) ;; but not member to ##member

  (macro-force-vars (c)
    (let ((compare (if (eq? c (macro-absent-obj)) ##equal? c)))
      (macro-check-procedure compare 3 (member obj lst c)
        (let loop ((x lst))
          (macro-force-vars (x)
            (if (pair? x)
                (let ((y (car x)))
                  (if (compare obj y)
                      x
                      (loop (cdr x))))
                (macro-check-list x 2 (member obj lst c)
                  #f))))))))

;; ##assq defined in _kernel.scm

(define-prim (assq obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" assq)) ;; but not assq to ##assq

  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (pair? x)
            (let ((couple (car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list couple 2 (assq obj lst)
                  (let ((y (car couple)))
                    (macro-force-vars (y)
                      (if (eq? obj y)
                          couple
                          (loop (cdr x))))))))
            (macro-check-list x 2 (assq obj lst)
              #f))))))

(define-prim (##assv obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst))
    (if (pair? x)
        (let ((couple (car x)))
          (if (let ()
                (##declare (generic)) ;; avoid fixnum specific eqv?
                (eqv? obj (car couple)))
              couple
              (loop (cdr x))))
        #f)))

(define-prim (assv obj lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" assv)) ;; but not assv to ##assv

  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (pair? x)
            (let ((couple (car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list couple 2 (assv obj lst)
                  (let ((y (car couple)))
                    (macro-force-vars (y)
                      (if (let ()
                            (##declare (generic)) ;; avoid fixnum specific eqv?
                            (eqv? obj y))
                          couple
                          (loop (cdr x))))))))
            (macro-check-list x 2 (assv obj lst)
              #f))))))

(define-prim (##assoc obj lst #!optional (compare ##equal?))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst))
    (if (pair? x)
        (let ((couple (car x)))
          (if (compare obj (car couple))
              couple
              (loop (cdr x))))
        #f)))

(define-prim (assoc obj lst #!optional (c (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" assoc)) ;; but not assoc to ##assoc

  (macro-force-vars (c)
    (let ((compare (if (eq? c (macro-absent-obj)) ##equal? c)))
      (macro-check-procedure compare 3 (assoc obj lst c)
        (let loop ((x lst))
          (macro-force-vars (x)
            (if (pair? x)
                (let ((couple (car x)))
                  (macro-force-vars (couple)
                    (macro-check-pair-list couple 2 (assoc obj lst c)
                      (let ((y (car couple)))
                        (if (compare obj y)
                            couple
                            (loop (cdr x)))))))
                (macro-check-list x 2 (assoc obj lst c)
                  #f))))))))

(define-prim (##remq elem lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (rem elem lst)
    (if (pair? lst)
        (let* ((lst2 (rem elem (cdr lst)))
               (x (car lst)))
          (if (eq? x elem)
              lst2
              (if (eq? lst2 (cdr lst))
                  lst
                  (cons x lst2))))
        '()))

  (rem elem lst))

;;;----------------------------------------------------------------------------

(define ##allow-length-mismatch? #t)

(define-prim (##allow-length-mismatch?-set! x)
  (set! ##allow-length-mismatch? x))

(define (##proper-list-length lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((lst lst) (n 0))
    (macro-force-vars (lst)
      (cond ((pair? lst)
             (loop (cdr lst) (fx+ n 1)))
            ((null? lst)
             n)
            (else
             #f)))))

(define (##cars lsts end)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (cars lsts end) ;; assumes lsts is a list of pairs
    (if (pair? lsts)
        (let ((lst1 (car lsts)))
          (macro-force-vars (lst1)
            (cons (car lst1)
                  (cars (cdr lsts) end))))
        end))

  (cars lsts end))

(define (##cdrs lsts)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (cdrs lsts)
    (if (pair? lsts)
        (let ((tail (cdrs (cdr lsts))))

          ;; tail is either
          ;; 1) () : (cdr lsts) is ()
          ;; 2) #f : all the elements of (cdr lsts) are not pairs
          ;; 3) a pair : all the elements of (cdr lsts) are pairs
          ;; 4) a fixnum >= 0 : at least one of (cdr lsts) is ()
          ;;                    and at index tail of (cdr lsts) is a pair
          ;; 5) a fixnum < 0 : at least one of (cdr lsts) is not a pair and
          ;;                   at index tail - ##min-fixnum of (cdr lsts) is
          ;;                   the first element that is neither a pair or ()

          (let ((lst1 (car lsts)))
            (macro-force-vars (lst1)
              (cond ((pair? lst1)
                     (cond ((fixnum? tail)
                            (if (fx< tail 0)
                                (fx+ tail 1)
                                0))
                           ((not tail)
                            (if ##allow-length-mismatch?
                                #f
                                0))
                           (else
                            (cons (cdr lst1) tail))))
                    ((null? lst1)
                     (cond ((fixnum? tail)
                            (fx+ tail 1))
                           ((pair? tail)
                            (if ##allow-length-mismatch?
                                #f
                                1))
                           (else
                            #f)))
                    (else
                     ##min-fixnum)))))
        '()))

  (cdrs lsts))

(define-prim (##map proc x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (map-1 x)

    (define (map-1 lst1)
      (if (pair? lst1)
          (let* ((result (proc (car lst1)))
                 (tail (map-1 (cdr lst1))))
            (cons result tail))
          '()))

    (map-1 x))

  (define (map-n x-y)

    (define (map-n lsts)
      (let ((rests (##cdrs lsts)))
        (if (not rests)
            '()
            (if (pair? rests)
                (let* ((args (##cars lsts '()))
                       (result (apply proc args))
                       (tail (map-n rests)))
                  (cons result tail))
                '()))))

    (map-n x-y))

  (if (null? y)
      (map-1 x)
      (map-n (cons x y))))

(define-prim (map proc x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" map)) ;; but not map to ##map

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (map proc x . y)
      (let ()

        (define (map-1 x)

          (define (map-1 lst1)
            (macro-force-vars (lst1)
              (if (pair? lst1)
                  (let* ((result (proc (car lst1)))
                         (tail (map-1 (cdr lst1))))
                    (macro-if-checks
                     (and tail
                          (cons result tail))
                     (cons result tail)))
                  (macro-if-checks
                   (if (null? lst1)
                       '()
                       #f)
                   '()))))

          (macro-if-checks
           (let ((result (map-1 x)))
             (or result
                 (macro-fail-check-list
                  2
                  (map proc x))))
           (map-1 x)))

        (define (map-n x-y)

          (define (map-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (not rests)
                  '()
                  (if (pair? rests)
                      (let* ((args (##cars lsts '()))
                             (result (apply proc args))
                             (tail (map-n rests)))
                        (macro-if-checks
                         (if (fixnum? tail)
                             tail
                             (cons result tail))
                         (cons result tail)))
                      (macro-if-checks
                       rests
                       '())))))

          (macro-if-checks
           (let ((result (map-n x-y)))
             (if (fixnum? result)
                 (if (fx< result 0)
                     (macro-fail-check-list
                      (fx- (fx+ 2 result) ##min-fixnum)
                      (map proc . x-y))
                     (##raise-length-mismatch-exception
                      (fx+ 2 result)
                      '()
                      map
                      proc
                      x-y))
                 result))
           (map-n x-y)))

        (if (null? y)
            (map-1 x)
            (map-n (cons x y)))))))

(define-prim (##for-each proc x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (for-each-1 x)

    (define (for-each-1 lst1)
      (if (pair? lst1)
          (begin
            (proc (car lst1))
            (for-each-1 (cdr lst1)))
          (void)))

    (for-each-1 x))

  (define (for-each-n x-y)

    (define (for-each-n lsts)
      (let ((rests (##cdrs lsts)))
        (if (not rests)
            (void)
            (if (pair? rests)
                (begin
                  (apply proc (##cars lsts '()))
                  (for-each-n rests))
                (void)))))

    (for-each-n x-y))

  (if (null? y)
      (for-each-1 x)
      (for-each-n (cons x y))))

(define-prim (for-each proc x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" for-each)) ;; but not for-each to ##for-each

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (for-each proc x . y)
      (let ()

        (define (for-each-1 x)

          (define (for-each-1 lst1)
            (macro-force-vars (lst1)
              (if (pair? lst1)
                  (begin
                    (proc (car lst1))
                    (for-each-1 (cdr lst1)))
                  (macro-check-list lst1 2 (for-each proc x)
                    (void)))))

          (for-each-1 x))

        (define (for-each-n x-y)

          (define (for-each-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (not rests)
                  (void)
                  (if (pair? rests)
                      (begin
                        (apply proc (##cars lsts '()))
                        (for-each-n rests))
                      (macro-if-checks
                       (if (fx< rests 0)
                           (macro-fail-check-list
                            (fx- (fx+ 2 rests) ##min-fixnum)
                            (for-each proc . x-y))
                           (##raise-length-mismatch-exception
                            (fx+ 2 rests)
                            '()
                            for-each
                            proc
                            x-y))
                       (void))))))

          (for-each-n x-y))

        (if (null? y)
            (for-each-1 x)
            (for-each-n (cons x y)))))))

;;;----------------------------------------------------------------------------

;; R4RS Scheme procedures:

(define-prim (##list-tail lst k)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        x)))

(define-prim (list-tail lst k)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" list-tail)) ;; but not list-tail to ##list-tail

  (macro-force-vars (k)
    (macro-check-index k 2 (list-tail lst k)
      (let loop ((x lst) (i k))
        (if (fx< 0 i)
            (macro-force-vars (x)
              (macro-check-pair x 1 (list-tail lst k);;TODO: error message confusing?
                (loop (cdr x) (fx- i 1))))
            x)))))

;;;----------------------------------------------------------------------------

;; SRFI-1 procedures:

(define-prim (##xcons d a)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (cons a d))

(define-prim (xcons d a)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (cons a d))

(define-prim (##cons*-aux x rest)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (if (pair? rest)
      (let loop ((x x) (probe rest))
        (let ((y (car probe))
              (tail (cdr probe)))
          (set-car! probe x)
          (if (pair? tail)
              (loop y tail)
              (begin
                (set-cdr! probe y)
                rest))))
      x))

(define-prim (##cons* x . rest)
  (##cons*-aux x rest))

(define-prim (cons* x . rest)
  (##cons*-aux x rest))

(define-prim (##make-list n #!optional (fill 0))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((i n) (result '()))
    (if (fx> i 0)
        (loop (fx- i 1) (cons fill result))
        result)))

(define-prim (make-list n #!optional (fill (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" make-list)) ;; but not make-list to ##make-list

  (macro-force-vars (n fill)
    (macro-check-index n 1 (make-list n fill)
      (if (eq? fill (macro-absent-obj))
          (##make-list n)
          (##make-list n fill)))))

(define-prim (##list-tabulate n init-proc)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((i n) (result '()))
    (if (fx> i 0)
        (let ((i (fx- i 1)))
          (loop i (cons (init-proc i) result)))
        result)))

(define-prim (list-tabulate n init-proc)
  (macro-force-vars (n init-proc)
    (macro-check-index n 1 (list-tabulate n init-proc)
      (macro-check-procedure init-proc 2 (list-tabulate n init-proc)
        (##list-tabulate n init-proc)))))

(define-prim (##proper-list-copy lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((lst lst) (rev-result '()))
    (macro-force-vars (lst)
      (if (pair? lst)
          (loop (cdr lst) (cons (car lst) rev-result))
          (and (null? lst)
               (reverse! rev-result))))))

(define-prim (##list-copy lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((lst lst) (rev-result '()))
    (macro-force-vars (lst)
      (if (pair? lst)
          (loop (cdr lst) (cons (car lst) rev-result))
          (append-reverse! rev-result lst)))))

(define-prim (list-copy lst)
  (##list-copy lst))

(define-prim (##circular-list x . rest)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let ((result (cons x rest)))
    (set-cdr! (last-pair result) result)
    result))

(define-prim (circular-list x . rest)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let ((result (cons x rest)))
    (set-cdr! (last-pair result) result)
    result))

(define-prim (##iota count #!optional (start 0) (step 1))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" step)) ;; but not step to ##step

  (if (and (eqv? step 1)
           (fixnum? start)
           (##fx+? (fx- count 1) start))

      (let loop ((i count) (result '()))
        (if (fx> i 0)
            (let ((i (fx- i 1)))
              (loop i (cons (fx+ start i) result)))
            result))

      (let loop ((i count) (result '()))
        (if (fx> i 0)
            (let ((i (fx- i 1)))
              (loop i (cons (+ start (* step i)) result)))
            result))))

(define-prim (iota count
                   #!optional
                   (start (macro-absent-obj))
                   (step (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" iota step)) ;; but not iota to ##iota, and step to ##step

  (macro-force-vars (count start step)
    (macro-check-index count 1 (iota count start step)
      (if (eq? start (macro-absent-obj))
          (##iota count 0 1)
          (if (not (number? start))
              (##fail-check-number 2 iota count start step)
              (if (eq? step (macro-absent-obj))
                  (##iota count start 1)
                  (if (not (number? step))
                      (##fail-check-number 3 iota count start step)
                      (##iota count start step))))))))

(define-prim (##take x i)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((probe x)
             (j i)
             (rev-result '()))
    (if (fx> j 0)
        (loop (cdr probe)
              (fx- j 1)
              (cons (car probe) rev-result))
        (reverse! rev-result))))

(define-prim (take x i)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" take)) ;; but not take to ##take

  (macro-force-vars (i)
    (macro-check-index i 2 (take x i)
      (let loop ((probe x)
                 (j i)
                 (rev-result '()))
        (if (fx> j 0)
            (macro-force-vars (probe)
              (macro-check-pair probe 1 (take x i)
                (loop (cdr probe)
                      (fx- j 1)
                      (cons (car probe) rev-result))))
            (reverse! rev-result))))))

(define-prim (##drop x i)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((probe x)
             (j i))
    (if (fx> j 0)
        (loop (cdr probe)
              (fx- j 1))
        probe)))

(define-prim (drop x i)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" drop)) ;; but not drop to ##drop

  (macro-force-vars (i)
    (macro-check-index i 2 (drop x i)
      (let loop ((probe x)
                 (j i))
        (if (fx> j 0)
            (macro-force-vars (probe)
              (macro-check-pair probe 1 (drop x i)
                (loop (cdr probe)
                      (fx- j 1))))
            probe)))))

(define-prim (##last-pair lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((lst lst))
    (let ((tail (cdr lst)))
      (if (pair? tail)
          (loop tail)
          lst))))

(define-prim (last-pair lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" last-pair)) ;; but not last-pair to ##last-pair

  (macro-force-vars (lst)
    (macro-check-pair lst 1 (last-pair lst)
      (let loop ((lst lst))
        (let ((tail (cdr lst)))
          (macro-force-vars (tail)
            (if (pair? tail)
                (loop tail)
                lst)))))))

(define-prim (##last lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (car (##last-pair lst)))

(define-prim (last lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" last)) ;; but not last to ##last

  (macro-force-vars (lst)
    (macro-check-pair lst 1 (last lst)
      (let loop ((lst lst))
        (let ((tail (cdr lst)))
          (macro-force-vars (tail)
            (if (pair? tail)
                (loop tail)
                (car lst))))))))

(define-prim (##butlast lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (butlast lst)
    (if (pair? (cdr lst))
        (cons (car lst) (butlast (cdr lst)))
        '()))

  (butlast lst))

;; ##reverse! and ##append-reverse! defined in _kernel.scm

(define-prim (reverse! lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" reverse!)) ;; but not reverse! to ##reverse!

  (let loop ((prev '()) (curr lst))
    (macro-force-vars (curr)
      (if (pair? curr)
          (let ((next (cdr curr)))
            (set-cdr! curr prev)
            (loop curr next))
          (macro-check-list curr 1 (reverse! lst)
            prev)))))

(define-prim (##append-reverse lst tail)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((x lst) (result tail))
    (if (pair? x)
        (loop (cdr x) (cons (car x) result))
        result)))

(define-prim (append-reverse lst tail)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" append-reverse)) ;; but not append-reverse to ##append-reverse

  (let loop ((x lst) (result tail))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (cons (car x) result))
          (macro-check-list x 1 (append-reverse lst tail)
            result)))))

(define-prim (append-reverse! lst tail)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" append-reverse!)) ;; but not append-reverse! to ##append-reverse!

  (let loop ((prev tail) (curr lst))
    (macro-force-vars (curr)
      (if (pair? curr)
          (let ((next (cdr curr)))
            (set-cdr! curr prev)
            (loop curr next))
          (macro-check-list curr 1 (append-reverse! lst tail)
            prev)))))

(define-prim (##fold proc base lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((r base) (x lst))
    (if (pair? x)
        (loop (proc (car x) r)
              (cdr x))
        r)))

(define-prim (fold proc base x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" fold)) ;; but not fold to ##fold

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (fold proc base x . y)
      (let ()

        (define (fold-1 x)

          (define (fold-1 r lst1)
            (macro-force-vars (lst1)
              (if (pair? lst1)
                  (fold-1 (proc (car lst1) r)
                          (cdr lst1))
                  (macro-check-list lst1 3 (fold proc base x)
                    r))))

          (fold-1 base x))

        (define (fold-n x-y)

          (define (fold-n r lsts)
            (let ((rests (##cdrs lsts)))
              (if (not rests)
                  r
                  (if (pair? rests)
                      (fold-n (apply proc (##cars lsts (list r)))
                              rests)
                      (macro-if-checks
                       (if (fx< rests 0)
                           (macro-fail-check-list
                            (fx- (fx+ 3 rests) ##min-fixnum)
                            (fold proc base . x-y))
                           (##raise-length-mismatch-exception
                            (fx+ 3 rests)
                            '()
                            fold
                            proc
                            base
                            x-y))
                       r)))))

          (fold-n base x-y))

        (if (null? y)
            (fold-1 x)
            (fold-n (cons x y)))))))

(define-prim (##fold-right proc base lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (fold-right x)
    (if (pair? x)
        (proc (car x)
              (fold-right (cdr x)))
        base))

  (fold-right lst))

(define-prim (fold-right proc base x . y)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" fold-right)) ;; but not fold-right to ##fold-right

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (fold-right proc base x . y)
      (let ()

        (define (fold-right-1 x)

          (define (fold-right-1 lst1)
            (macro-force-vars (lst1)
              (if (pair? lst1)
                  (let ((tail (fold-right-1 (cdr lst1))))
                    (macro-if-checks
                     (and tail
                          (list (proc (car lst1) (car tail))))
                     (proc (car lst1) tail)))
                  (macro-if-checks
                   (if (null? lst1)
                       (list base)
                       #f)
                   (list base)))))

          (macro-if-checks
           (let ((result (fold-right-1 x)))
             (if result
                 (car result)
                 (macro-fail-check-list
                  3
                  (fold-right proc base x))))
           (fold-right-1 x)))

        (define (fold-right-n x-y)

          (define (fold-right-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (not rests)
                  (macro-if-checks
                   (list base)
                   base)
                  (if (pair? rests)
                      (let ((tail (fold-right-n rests)))
                        (macro-if-checks
                         (if (fixnum? tail)
                             tail
                             (list (apply proc (##cars lsts tail))))
                         (apply proc (##cars lsts (list tail)))))
                      (macro-if-checks
                       rests
                       base)))))

          (macro-if-checks
           (let ((result (fold-right-n x-y)))
             (if (fixnum? result)
                 (if (fx< result 0)
                     (macro-fail-check-list
                      (fx- (fx+ 3 result) ##min-fixnum)
                      (fold-right proc base . x-y))
                     (##raise-length-mismatch-exception
                      (fx+ 3 result)
                      '()
                      fold-right
                      proc
                      base
                      x-y))
                 (car result)))
           (fold-right-n x-y)))

        (if (null? y)
            (fold-right-1 x)
            (fold-right-n (cons x y)))))))

;;;----------------------------------------------------------------------------

;;; Sorting.

;;(declare-safe-define-procedure #t)

(define-primitive (list-sort! (proc procedure)
                              (lst  object))

  ;; Stable mergesort algorithm

  (define (sort lst len)
    (if (fx= len 1)
        (begin
          (set-cdr! lst '())
          lst)
        (let ((len1 (fxarithmetic-shift-right len 1)))
          (let loop ((n len1) (tail lst))
            (if (fx> n 0)
                (loop (fx- n 1) (cdr tail))
                (let ((x (sort tail (fx- len len1))))
                  (merge (sort lst len1) x)))))))

  (define (merge lst1 lst2)
    (if (pair? lst1)
        (if (pair? lst2)
            (let ((x1 (car lst1))
                  (x2 (car lst2)))
              (if (proc x2 x1)
                  (merge-loop lst2 lst2 lst1 (cdr lst2))
                  (merge-loop lst1 lst1 (cdr lst1) lst2)))
            lst1)
        lst2))

  (define (merge-loop result prev lst1 lst2)
    (if (pair? lst1)
        (if (pair? lst2)
            (let ((x1 (car lst1))
                  (x2 (car lst2)))
              (if (proc x2 x1)
                  (begin
                    (set-cdr! prev lst2)
                    (merge-loop result lst2 lst1 (cdr lst2)))
                  (begin
                    (set-cdr! prev lst1)
                    (merge-loop result lst1 (cdr lst1) lst2))))
            (begin
              (set-cdr! prev lst1)
              result))
        (begin
          (set-cdr! prev lst2)
          result)))

  (let ((len (primitive (proper-list-length lst))))
    (and len
         (if (fx= len 0)
             '()
             (sort lst len)))))

(define-primitive (list-sort (proc procedure)
                             (lst  object))
  (list-sort! proc (list-copy lst)))

(define-procedure (list-sort (proc procedure)
                             (lst  object))
  (macro-if-checks
   (let ((lst-copy (primitive (proper-list-copy lst))))
     (if lst-copy
         (list-sort! proc lst-copy)
         (macro-fail-check-list
          '(2 . lst)
          (list-sort proc lst))))
   (list-sort! proc (list-copy lst))))

(define-procedure (list-sort! (proc procedure)
                              (lst  object))
  (let ((result (primitive (list-sort! proc lst))))
    (or result
        (macro-fail-check-list
         '(2 . lst)
         (list-sort! proc lst)))))

;;;============================================================================
