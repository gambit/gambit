;;;============================================================================

;;; File: "list.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; List operations.

(##include "list#.scm")

;;;----------------------------------------------------------------------------

(implement-check-type-pair)
(implement-check-type-pair-list)
(implement-check-type-list)
(implement-check-type-proper-list)
(implement-check-type-proper-or-circular-list)

;;;----------------------------------------------------------------------------

(define-prim&proc (pair? (obj object)))

(define-prim&proc (cons (obj1 object)
                        (obj2 object)))

(##define-macro (define-prim&proc-c...r from-length to-length)

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
        (let ((name (gen-name i)))

          (define (gen1 var pattern)
            (if (<= pattern 3)
                `(primitive (,(if (= pattern 3) `cdr `car) ,var))
                `(let ((x (primitive (,(if (odd? pattern) `cdr `car) ,var))))
                   ,(gen1 'x (quotient pattern 2)))))

          (define (gen2 var pattern)
            (let ((body
                   (if (<= pattern 3)
                       `(primitive (,(if (= pattern 3) `cdr `car) ,var))
                       `(let ((x (primitive (,(if (odd? pattern) `cdr `car) ,var))))
                          (macro-force-vars (x)
                            ,(gen2 'x (quotient pattern 2)))))))
              (if (eq? var 'pair) ;; avoid repeating initial pair check
                  body
                  `(macro-check-pair ,var '(1 . pair) (,name pair);;TODO: error message confusing?
                     ,body))))

          `((define-primitive (,name (pair pair))
              ,(gen1 'pair i))

            (define-procedure (,name (pair pair))
              (macro-force-vars (pair)
                ,(gen2 'pair i)))

            ,@(gen3 (+ i 1) j)))))

  `(begin ,@(gen3 (expt 2 from-length) (- (expt 2 (+ to-length 1)) 1))))

(define-prim&proc-c...r 1 4) ;; define car to cddddr

(define-prim&proc (set-car! (pair pair)
                            (obj  object))
  (set-car! pair obj)
  (void))

(define-prim&proc (set-cdr! (pair pair)
                            (obj  object))
  (set-cdr! pair obj)
  (void))

(define-prim&proc (null? (obj object))
  (null? obj))

;; Floyd's tortoise and hare algorithm for cycle detection

;; https://en.wikipedia.org/wiki/Cycle_detection

;; These procedures may get into an infinite loop if another thread
;; mutates "lst" (if fast and slow each point to disconnected cycles).

(define-primitive (possibly-cyclic-tail lst)
  (let loop ((fast lst) (slow lst))
    (macro-force-vars (fast)
      (if (not (pair? fast))
          fast
          (let ((fast (cdr fast)))
            (macro-force-vars (fast slow)
              (cond ((eq? fast slow)
                     ;; Cycle detected. Return some pair in the cycle.
                     fast)
                    ((not (pair? slow))
                     ;; This case is possible if other threads mutate
                     ;; the list.
                     slow)
                    ((pair? fast)
                     (loop (cdr fast) (cdr slow)))
                    (else
                     fast))))))))

(define-prim&proc (proper-list? (x object))
  (null? (primitive (possibly-cyclic-tail x))))

(define-prim&proc (circular-list? (x object))
  (pair? (primitive (possibly-cyclic-tail x))))

(define-prim&proc (dotted-list? (x object))
  (let ((tail (primitive (possibly-cyclic-tail x))))
    (not (or (null? tail) (pair? tail)))))

(define-prim&proc (list? (x object))
  (null? (primitive (possibly-cyclic-tail x))))

(define-prim&proc (list (objs object) ...)
  objs)

(define-primitive (length (list proper-list))

  ;; Note: this code enters an infinite loop when given a circular list

  (let loop ((x list) (n 0))
    (if (pair? x)
        (loop (cdr x) (fx+ n 1))
        n)))

(define-procedure (length (list proper-list))

  ;; Note: this code enters an infinite loop when given a circular list

  (let loop ((x list) (n 0))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (fx+ n 1))
          (macro-check-proper-list-null x '(1 . list) (length list)
            n)))))

(define-prim&proc (length+ (clist proper-or-circular-list))

  (define (err)
    (macro-fail-check-proper-or-circular-list '(1 . clist) (length+ clist)))

  (let loop ((len 0) (fast clist) (slow clist))
    (macro-force-vars (fast)
      (cond ((null? fast)
             (fx* 2 len))
            ((not (pair? fast))
             (err))
            (else
             (let ((fast (cdr fast)))
               (macro-force-vars (fast slow)
                 (cond ((eq? fast slow)
                        ;; Cycle detected.
                        #f)
                       ((null? slow)
                        len)
                       ((not (pair? slow))
                        ;; This case is possible if other threads mutate
                        ;; the list.
                        (err))
                       ((null? fast)
                        (fx+ 1 (fx* 2 len)))
                       ((not (pair? fast))
                        (err))
                       (else
                        (loop (fx+ len 1) (cdr fast) (cdr slow)))))))))))

(define-primitive (append2 list1 list2)
  (if (pair? list1)
      (cons (car list1) (primitive (append2 (cdr list1) list2)))
      list2))

(define-primitive (append-lists (list-of-lists proper-list))
  (if (pair? list-of-lists)
      (let ((rlst (reverse list-of-lists)))
        (let loop ((rlst (cdr rlst)) (result (car rlst)))
          (if (pair? rlst)
              (loop (cdr rlst)
                    (primitive (append2 (car rlst) result)))
              result)))
      '()))

(define-primitive (append (list1 object (macro-absent-obj))
                          (list2 object (macro-absent-obj))
                          (lists object) ...)
  (if (eq? list2 (macro-absent-obj))
      (if (eq? list1 (macro-absent-obj))
          '()
          list1)
      (if (null? lists)
          (primitive (append2 list1 list2))
          (primitive (append-lists (cons list1 (cons list2 lists)))))))

(define-procedure (append (list1 object (macro-absent-obj))
                          (list2 object (macro-absent-obj))
                          (lists object) ...)

  (define (append-multiple list1 other-lists arg-num1)
    (if (null? other-lists)
        list1
        (macro-force-vars (list1)
          (if (null? list1)
              (append-multiple (car other-lists)
                               (cdr other-lists)
                               (fx+ arg-num1 1))
              (list-expected-check
               (if (pair? list1)
                   (append-multiple-pair list1
                                         other-lists
                                         arg-num1
                                         (fx+ arg-num1 1))
                   (fx- arg-num1))))))) ;; error: list expected

  (define (append-multiple-pair list1 other-lists arg-num1 arg-num2)
    ;; list1 is a pair, returns fixnum on error
    (let ((list2 (car other-lists))
          (tail (cdr other-lists)))
      (if (null? tail)
          (append-2-pair list1 list2 arg-num1)
          (macro-force-vars (list2)
            (if (null? list2)
                (append-multiple-pair list1
                                      tail
                                      arg-num1
                                      (fx+ arg-num2 1))
                (if (pair? list2)
                    (let ((result
                           (append-multiple-pair list2
                                                 tail
                                                 arg-num2
                                                 (fx+ arg-num2 1))))
                      (macro-if-checks
                       (if (fixnum? result)
                           result
                           (append-2-pair list1 result arg-num1))
                       (append-2-pair list1 result arg-num1)))
                    (fx- arg-num2))))))) ;; error: list expected

  (define (append-2-pair list1 list2 arg-num1)
    ;; list1 is a pair, returns fixnum on error
    (let ((result (cons (car list1) '())))
      (let loop ((last result) (tail (cdr list1)))
        (macro-force-vars (tail)
          (if (pair? tail)
              (let ((next (cons (car tail) '())))
                (set-cdr! last next)
                (loop next (cdr tail)))
              (begin
                (set-cdr! last list2)
                (macro-if-checks
                 (if (null? tail)
                     result
                     arg-num1) ;; error: proper list expected
                 result)))))))

  (define (list-expected-check result)
    (macro-if-checks
     (if (fixnum? result)
         (if (fx< result 0)
             (macro-fail-check-list (fx- result) (append list1 list2 . lists))
             (macro-fail-check-proper-list result (append list1 list2 . lists)))
         result)
     result))

  (cond ((eq? list2 (macro-absent-obj))
         (if (eq? list1 (macro-absent-obj))
             '()
             list1))
        ((null? lists)
         (macro-force-vars (list1)
           (if (null? list1)
               list2
               (list-expected-check
                (if (pair? list1)
                    (append-2-pair list1 list2 1)
                    -1))))) ;; error: list expected
        (else
         (append-multiple list1 (cons list2 lists) 1))))

(define-primitive (reverse (list proper-list))
  (let loop ((x list) (result '()))
    (if (pair? x)
        (loop (cdr x) (cons (car x) result))
        result)))

(define-procedure (reverse (list proper-list))
  (let loop ((x list) (result '()))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (cons (car x) result))
          (macro-check-proper-list-null x '(1 . list) (reverse list)
            result)))))

(define-primitive (list-ref (list proper-list)
                            (k    index))
  (let loop ((x list) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        (car x))))

(define-procedure (list-ref (list proper-list)
                            (k    index))
  (let loop ((x list) (i k))
    (macro-force-vars (x)
      (macro-if-checks
       (if (not (pair? x))
           (primitive (raise-range-exception '(2 . k) list-ref list k))
           (if (fx< 0 i)
               (loop (cdr x) (fx- i 1))
               (car x)))
       (if (fx< 0 i)
           (loop (cdr x) (fx- i 1))
           (car x))))))

(define-primitive (list-set! (list proper-list)
                             (k    index)
                             (obj  object))
  (let loop ((x list) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        (begin
          (set-car! x obj)
          (void)))))

(define-procedure (list-set! (list proper-list)
                             (k    index)
                             (obj  object))
  (let loop ((x list) (i k))
    (macro-force-vars (x)
      (macro-if-checks
       (if (not (pair? x))
           (if (null? x)
               (primitive
                (raise-range-exception '(2 . k) list-set! list k obj))
               (primitive
                (fail-check-proper-list '(1 . list) list-set! list k obj)))
           (if (fx< 0 i)
               (loop (cdr x) (fx- i 1))
               (macro-check-mutable x '(1 . list) (list-set! list k obj)
                 (begin
                   (set-car! x obj)
                   (void)))))
       (if (fx< 0 i)
           (loop (cdr x) (fx- i 1))
           (begin
             (set-car! x obj)
             (void)))))))

(define-primitive (list-set (list proper-list)
                            (k    index)
                            (obj  object))

  (define (set x i)
    (if (fx< 0 i)
        (cons (car x) (set (cdr x) (fx- i 1)))
        (cons obj (cdr x))))

  (set list k))

(define-procedure (list-set (list proper-list)
                            (k    index)
                            (obj  object))

  (define (set x i)
    (macro-force-vars (x)
      (if (pair? x)
          (if (fx< 0 i)
              (let ((r (set (cdr x) (fx- i 1))))
                (if (pair? r)
                    (cons (car x) r)
                    r))
              (cons obj (cdr x)))
          (null? x) )))

  (let ((r (set list k)))
    (if (pair? r)
        r
        (if r
            (primitive
             (raise-range-exception '(2 . k) list-set list k obj))
            (primitive
             (fail-check-proper-list '(1 . list) list-set list k obj))))))

(define-primitive (memq (obj  object)
                        (list proper-list))
  (let loop ((x list))
    (if (pair? x)
        (if (eq? obj (car x))
            x
            (loop (cdr x)))
        #f)))

(define-procedure (memq (obj  object)
                        (list proper-list))
  (let loop ((x list))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((y (car x)))
            (macro-force-vars (y)
              (if (eq? obj y)
                  x
                  (loop (cdr x)))))
          (macro-check-proper-list-null x '(2 . list) (memq obj list)
            #f)))))

(define-primitive (memv (obj  object)
                        (list proper-list))
  (let loop ((x list))
    (if (pair? x)
        (if (let ()
              (declare (generic)) ;; avoid fixnum specific eqv?
              (eqv? obj (car x)))
            x
            (loop (cdr x)))
        #f)))

(define-procedure (memv (obj  object)
                        (list proper-list))
  (let loop ((x list))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((y (car x)))
            (macro-force-vars (y)
              (if (let ()
                    (declare (generic)) ;; avoid fixnum specific eqv?
                    (eqv? obj y))
                  x
                  (loop (cdr x)))))
          (macro-check-proper-list-null x '(2 . list) (memv obj list)
            #f)))))

(define-primitive (member (obj     object)
                          (list    proper-list)
                          (compare procedure (primitive equal?)))
  (let loop ((x list))
    (if (pair? x)
        (if (compare obj (car x))
            x
            (loop (cdr x)))
        #f)))

(define-procedure (member (obj     object)
                          (list    proper-list)
                          (compare procedure (primitive equal?)))
  (let loop ((x list))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((y (car x)))
            (if (compare obj y)
                x
                (loop (cdr x))))
          (macro-check-proper-list-null x '(2 . list) (member obj list %compare) ;; need to use %compare to avoid showing a third argument when none was given
            #f)))))

;; ##assq defined in _kernel.scm

(define-procedure (assq (obj   object)
                        (alist pair-list))
  (let loop ((x alist))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((couple (car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list-pair couple '(2 . alist) (assq obj alist)
                (let ((y (car couple)))
                  (macro-force-vars (y)
                    (if (eq? obj y)
                        couple
                        (loop (cdr x))))))))
          (macro-check-proper-list-null x '(2 . alist) (assq obj alist)
            #f)))))

(define-primitive (assv (obj object)
                        (alist pair-list))
  (let loop ((x alist))
    (if (pair? x)
        (let ((couple (car x)))
          (if (let ()
                (declare (generic)) ;; avoid fixnum specific eqv?
                (eqv? obj (car couple)))
              couple
              (loop (cdr x))))
        #f)))

(define-procedure (assv (obj object)
                        (alist pair-list))
  (let loop ((x alist))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((couple (car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list-pair couple '(2 . alist) (assv obj alist)
                (let ((y (car couple)))
                  (macro-force-vars (y)
                    (if (let ()
                          (declare (generic)) ;; avoid fixnum specific eqv?
                          (eqv? obj y))
                        couple
                        (loop (cdr x))))))))
          (macro-check-proper-list-null x '(2 . alist) (assv obj alist)
            #f)))))

(define-primitive (assoc (obj object)
                         (alist pair-list)
                         (compare procedure ##equal?))
  (let loop ((x alist))
    (if (pair? x)
        (let ((couple (car x)))
          (if (compare obj (car couple))
              couple
              (loop (cdr x))))
        #f)))

(define-procedure (assoc (obj object)
                         (alist pair-list)
                         (compare procedure ##equal?))
  (let loop ((x alist))
    (macro-force-vars (x)
      (if (pair? x)
          (let ((couple (car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list-pair couple '(2 . alist) (assoc obj alist %compare) ;; need to use %compare to avoid showing a third argument when none was given
                (let ((y (car couple)))
                  (if (compare obj y)
                      couple
                      (loop (cdr x)))))))
          (macro-check-proper-list-null x '(2 . alist) (assoc obj alist %compare) ;; need to use %compare to avoid showing a third argument when none was given
            #f)))))

(define-macro (macro-filter prim-call list var test-expr)
  `(let ()
     (define (filter-tail list)
       (if (pair? list)
           (let* ((,var (car list))
                  (matches? ,test-expr)
                  (old-tail (cdr list))
                  (new-tail (filter-tail old-tail)))
             (if (and (or (pair? new-tail) (null? new-tail))
                      matches?)
                 (if (eq? old-tail new-tail)
                     list
                     (cons x new-tail))
                 new-tail))
           list))
     (let ((new-list (filter-tail ,list)))
       (macro-if-checks (if (or (pair? new-list) (null? new-list))
                            new-list
                            (macro-fail-check-list 2 ,prim-call))
                        new-list))))

(define-prim&proc (filter (pred procedure) (list object))
  (macro-filter (filter pred list) list x (pred x)))

(define-prim&proc (remove (pred procedure) (list object))
  (macro-filter (remove pred list) list x (not (pred x))))

(define-prim&proc (remq (elem object) (list object))
  (macro-filter (remq elem list) list x (not (eq? x elem))))

;;;----------------------------------------------------------------------------

(define ##allow-length-mismatch? #t)

(define (##allow-length-mismatch?-set! x)
  (set! ##allow-length-mismatch? x))

(define-primitive (proper-list-length (list object))
  (let loop ((list list) (n 0))
    (macro-force-vars (list)
      (cond ((pair? list)
             (loop (cdr list) (fx+ n 1)))
            ((null? list)
             n)
            (else
             #f)))))

(define-primitive (cars (lists proper-list)
                        (end   object))

  (define (cars lists end) ;; assumes lists is a list of pairs
    (if (pair? lists)
        (let ((list1 (car lists)))
          (macro-force-vars (list1)
            (cons (car list1)
                  (cars (cdr lists) end))))
        end))

  (cars lists end))

(define-primitive (cdrs (lists proper-list))

  ;; This procedure computes (map cdr lists) and also checks for
  ;; special cases, such as one of the elements not being a pair.
  ;; The return value r depends on the case.  Here are the cases when
  ;; ##allow-length-mismatch? is #f:
  ;;
  ;; 1) r = () : lists is ()
  ;;
  ;; 2) r is a pair : all the elements of lists are pairs
  ;;
  ;; 3) r = #f : lists is not () and all the elements of lists are ()
  ;;
  ;; 4) r is a fixnum > 0 : at least one of the elements of lists is neither
  ;;                        () or a pair and the element at index r-1 is
  ;;                        the first such element
  ;;
  ;; 5) r is a fixnum < 0 : the elements of lists are a mix of () and pairs
  ;;                        and the element at index -r-1 is the first ()
  ;;                        (this case only happens when
  ;;                        ##allow-length-mismatch? is #f)

  (define (cdrs lists)
    (if (pair? lists)
        (let* ((tail (cdrs (cdr lists)))
               (list1 (car lists)))
          (macro-force-vars (list1)
            (cond ((pair? list1)
                   (cond ((fixnum? tail)
                          (if (fx< tail 0)
                              (fx- tail 1)
                              (fx+ tail 1)))
                         ((not tail)
                          (if ##allow-length-mismatch?
                              #f
                              -2)) ;; element at index 1 is ()
                         (else ;; () or pair
                          (cons (cdr list1) tail))))
                  ((null? list1)
                   (cond ((fixnum? tail)
                          (if (fx< tail 0)
                              -1 ;; element at index 0 is ()
                              (fx+ tail 1)))
                         ((pair? tail)
                          (if ##allow-length-mismatch?
                              #f
                              -1)) ;; element at index 0 is ()
                         (else ;; () or #f
                          #f)))
                  (else
                   1)))) ;; element at index 0 is not () or a pair
        '()))

  (cdrs lists))

(define-primitive (map (proc  procedure)
                       (list1 proper-list)
                       (lists proper-list) ...)

  (define (map-1 list1)

    (define (map-1 lst1)
      (if (pair? lst1)
          (let* ((result (proc (car lst1)))
                 (tail (map-1 (cdr lst1))))
            (cons result tail))
          '()))

    (map-1 list1))

  (define (map-n list1-lists)

    (define (map-n lsts)
      (let ((rests (primitive (cdrs lsts))))
        (if (pair? rests)
            (let* ((args (primitive (cars lsts '())))
                   (result (apply proc args))
                   (tail (map-n rests)))
              (cons result tail))
            '())))

    (map-n list1-lists))

  (if (null? lists)
      (map-1 list1)
      (map-n (cons list1 lists))))

(define-procedure (map (proc  procedure)
                       (list1 proper-list)
                       (lists proper-list) ...)

  (define (map-1 list1)

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
     (if (or (null? list1) (pair? list1))
         (let ((result (map-1 list1)))
           (or result
               (macro-fail-check-proper-list
                '(2 . list1)
                (map proc list1))))
         (macro-fail-check-list
          '(2 . list1)
          (map proc list1)))
     (map-1 list1)))

  (define (map-n list1-lists)

    (define (map-n* lsts rests)
      (if (not rests)
          '()
          (if (pair? rests)
              (let* ((args (primitive (cars lsts '())))
                     (result (apply proc args))
                     (tail (map-n* rests (primitive (cdrs rests)))))
                (macro-if-checks
                 (if (fixnum? tail)
                     tail
                     (cons result tail))
                 (cons result tail)))
              (macro-if-checks
               rests
               '()))))

    (let ((rests (primitive (cdrs list1-lists))))
      (macro-if-checks
       (if (and (fixnum? rests) (fx> rests 0))
           (macro-fail-check-list
            (argument-id (fx+ 1 rests))
            (map proc . list1-lists))
           (let ((result (map-n* list1-lists rests)))
             (if (fixnum? result)
                 (if (fx< result 0)
                     (primitive (raise-length-mismatch-exception
                                 (argument-id (fx- 1 result))
                                 '()
                                 map
                                 proc
                                 list1-lists))
                     (macro-fail-check-proper-list
                      (argument-id (fx+ 1 result))
                      (map proc . list1-lists)))
                 result)))
       (map-n* list1-lists rests))))

  (define (argument-id i)
    (if (fx= i 2) '(2 . list1) i))

  (if (null? lists)
      (map-1 list1)
      (map-n (cons list1 lists))))

(define-primitive (for-each (proc  procedure)
                            (list1 proper-list)
                            (lists proper-list) ...)

  (define (for-each-1 list1)

    (define (for-each-1 lst1)
      (if (pair? lst1)
          (begin
            (proc (car lst1))
            (for-each-1 (cdr lst1)))
          (void)))

    (for-each-1 list1))

  (define (for-each-n list1-lists)

    (define (for-each-n lsts)
      (let ((rests (primitive (cdrs lsts))))
        (if (pair? rests)
            (begin
              (apply proc (primitive (cars lsts '())))
              (for-each-n rests))
            (void))))

    (for-each-n list1-lists))

  (if (null? lists)
      (for-each-1 list1)
      (for-each-n (cons list1 lists))))

(define-procedure (for-each (proc  procedure)
                            (list1 proper-list)
                            (lists proper-list) ...)

  (define (for-each-1 list1)

    (define (for-each-1 lst1)
      (macro-force-vars (lst1)
        (if (pair? lst1)
            (begin
              (proc (car lst1))
              (for-each-1 (cdr lst1)))
            (macro-check-proper-list-null lst1 '(2 . list1) (for-each proc list1)
              (void)))))

    (macro-if-checks
     (if (or (null? list1) (pair? list1))
         (for-each-1 list1)
         (macro-fail-check-list
          '(2 . list1)
          (for-each proc list1)))
     (for-each-1 list1)))

  (define (for-each-n list1-lists)

    (define (for-each-n* lsts rests)
      (if (not rests)
          (void)
          (if (pair? rests)
              (begin
                (apply proc (primitive (cars lsts '())))
                (for-each-n* rests (primitive (cdrs rests))))
              (macro-if-checks
               (if (fx< rests 0)
                   (primitive (raise-length-mismatch-exception
                               (argument-id (fx- 1 rests))
                               '()
                               for-each
                               proc
                               list1-lists))
                   (macro-fail-check-proper-list
                    (argument-id (fx+ 1 rests))
                    (for-each proc . list1-lists)))
               (void)))))

    (let ((rests (primitive (cdrs list1-lists))))
      (macro-if-checks
       (if (and (fixnum? rests) (fx> rests 0))
           (macro-fail-check-list
            (argument-id (fx+ 1 rests))
            (for-each proc . list1-lists))
           (for-each-n* list1-lists rests))
       (for-each-n* list1-lists rests))))

  (define (argument-id i)
    (if (fx= i 2) '(2 . list1) i))

  (if (null? lists)
      (for-each-1 list1)
      (for-each-n (cons list1 lists))))

;;;----------------------------------------------------------------------------

;; R4RS Scheme procedures:

(define-primitive (list-tail (list proper-list)
                             (k    index))
  (let loop ((x list) (i k))
    (if (fx< 0 i)
        (loop (cdr x) (fx- i 1))
        x)))

(define-procedure (list-tail (list proper-list)
                             (k    index))
  (let loop ((x list) (i k))
    (if (fx< 0 i)
        (macro-force-vars (x)
          (macro-if-checks
           (if (pair? x)
               (loop (cdr x) (fx- i 1))
               (primitive (raise-range-exception '(2 . k) list-tail list k)))
           (loop (cdr x) (fx- i 1))))
        x)))

;;;----------------------------------------------------------------------------

;; SRFI-1 procedures:

(define-prim&proc (xcons (d object)
                         (a object))
  (cons a d))

(define-prim&proc (cons* (elt1 object)
                         (elts object) ...)
  (if (pair? elts)
      (let loop ((x elt1) (probe elts))
        (let ((y (car probe))
              (tail (cdr probe)))
          (set-car! probe x)
          (if (pair? tail)
              (loop y tail)
              (begin
                (set-cdr! probe y)
                elts))))
      elt1))

(define-prim&proc (make-list (n    index)
                             (fill object 0))
  (let loop ((i n) (result '()))
    (if (fx> i 0)
        (loop (fx- i 1) (cons fill result))
        result)))

(define-prim&proc (list-tabulate (n         index)
                                 (init-proc procedure))
  (let loop ((i n) (result '()))
    (if (fx> i 0)
        (let ((i (fx- i 1)))
          (loop i (cons (init-proc i) result)))
        result)))

(define-primitive (proper-list-copy (list object))
  (let loop ((probe list) (rev-result '()))
    (macro-force-vars (probe)
      (if (pair? probe)
          (loop (cdr probe) (cons (car probe) rev-result))
          (and (null? probe)
               (reverse! rev-result))))))

(define-prim&proc (list-copy (list object))
  (let loop ((probe list) (rev-result '()))
    (macro-force-vars (probe)
      (if (pair? probe)
          (loop (cdr probe) (cons (car probe) rev-result))
          (append-reverse! rev-result probe)))))

(define-prim&proc (circular-list (elt1 object)
                                 (elts object) ...)
  (let ((result (cons elt1 elts)))
    (set-cdr! (last-pair result) result)
    result))

(define-primitive (iota-fixnum (count index)
                               (start fixnum 0))
  (let loop ((i count) (result '()))
    (if (fx> i 0)
        (let ((i (fx- i 1)))
          (loop i (cons (fx+ start i) result)))
        result)))

(define-prim&proc (iota (count index)
                        (start number 0)
                        (step  number 1))
  (if (and (eqv? step 1)
           (fixnum? start)
           (primitive (fx+? (fx- count 1) start)))

      (primitive (iota-fixnum count start))

      (let loop ((i count) (result '()))
        (if (fx> i 0)
            (let ((i (fx- i 1)))
              (loop i (cons (+ start (* step i)) result)))
            result))))

(define-primitive (take (x object)
                        (i index))
  (let loop ((probe x)
             (j i)
             (rev-result '()))
    (if (fx> j 0)
        (loop (cdr probe)
              (fx- j 1)
              (cons (car probe) rev-result))
        (reverse! rev-result))))

(define-procedure (take (x object)
                        (i index))
  (let loop ((probe x)
             (j i)
             (rev-result '()))
    (if (fx> j 0)
        (macro-force-vars (probe)
          (macro-if-checks
           (if (pair? probe)
               (loop (cdr probe)
                     (fx- j 1)
                     (cons (car probe) rev-result))
               (primitive (raise-range-exception '(2 . i) take x i)))
           (loop (cdr probe)
                 (fx- j 1)
                 (cons (car probe) rev-result))))
        (reverse! rev-result))))

(define-primitive (drop (x object)
                        (i index))
  (let loop ((probe x)
             (j i))
    (if (fx> j 0)
        (loop (cdr probe)
              (fx- j 1))
        probe)))

(define-procedure (drop (x object)
                        (i index))
  (let loop ((probe x)
             (j i))
    (if (fx> j 0)
        (macro-force-vars (probe)
          (macro-if-checks
           (if (pair? probe)
               (loop (cdr probe)
                     (fx- j 1))
               (primitive (raise-range-exception '(2 . i) drop x i)))
           (loop (cdr probe)
                 (fx- j 1))))
        probe)))

(define-prim&proc (last-pair (pair pair))
  (let loop ((probe pair))
    (let ((tail (cdr probe)))
      (macro-force-vars (tail)
        (if (pair? tail)
            (loop tail)
            probe)))))

(define-prim&proc (last (pair pair))
  (let loop ((probe pair))
    (let ((tail (cdr probe)))
      (macro-force-vars (tail)
        (if (pair? tail)
            (loop tail)
            (car probe))))))

(define-primitive (butlast (pair pair))

  (define (butlast probe)
    (if (pair? (cdr probe))
        (cons (car probe) (butlast (cdr probe)))
        '()))

  (butlast pair))

;; ##reverse! defined in _kernel.scm

(define-procedure (reverse! (list proper-list))
  (let loop ((prev '()) (curr list))
    (macro-force-vars (curr)
      (if (pair? curr)
          (let ((next (cdr curr)))
            (set-cdr! curr prev)
            (loop curr next))
          (macro-check-proper-list-null curr '(1 . list) (reverse! list)
            prev)))))

(define-primitive (append-reverse (rev-head proper-list)
                                  (tail     object))
  (let loop ((x rev-head) (result tail))
    (if (pair? x)
        (loop (cdr x) (cons (car x) result))
        result)))

(define-procedure (append-reverse (rev-head proper-list)
                                  (tail     object))
  (let loop ((x rev-head) (result tail))
    (macro-force-vars (x)
      (if (pair? x)
          (loop (cdr x) (cons (car x) result))
          (macro-check-proper-list-null x '(1 . rev-head) (append-reverse rev-head tail)
            result)))))

;; ##append-reverse! defined in _kernel.scm

(define-procedure (append-reverse! (rev-head proper-list)
                                   (tail     object))
  (let loop ((prev tail) (curr rev-head))
    (macro-force-vars (curr)
      (if (pair? curr)
          (let ((next (cdr curr)))
            (set-cdr! curr prev)
            (loop curr next))
          (macro-check-proper-list-null curr '(1 . rev-head) (append-reverse! rev-head tail)
            prev)))))

(define-primitive (fold (kons   procedure)
                        (knil   object)
                        (clist1 proper-or-circular-list)
                        (clists proper-or-circular-list) ...)

  (define (fold-1 clist1)
    (let loop ((r knil) (x clist1))
      (if (pair? x)
          (loop (kons (car x) r)
                (cdr x))
          r)))

  (define (fold-n lsts)
    (let loop ((r knil) (x lsts))
      (let ((rests (primitive (cdrs x))))
        (if (pair? rests)
            (loop (apply kons (primitive (cars x (list r))))
                  rests)
            r))))

  (if (null? clists)
      (fold-1 clist1)
      (fold-n (cons clist1 clists))))

(define-procedure (fold (kons   procedure)
                        (knil   object)
                        (clist1 proper-or-circular-list)
                        (clists proper-or-circular-list) ...)

  (define (fold-1 clist1)

    (define (fold-1 clist1)
      (let loop ((r knil) (x clist1))
        (macro-force-vars (x)
          (if (pair? x)
              (loop (kons (car x) r)
                    (cdr x))
              (macro-check-proper-list-null x '(3 . clist1) (fold kons knil clist1)
                r)))))

    (macro-if-checks
     (if (or (null? clist1) (pair? clist1))
         (fold-1 clist1)
         (macro-fail-check-list '(3 . clist1) (fold kons knil clist1)))
     (fold-1 clist1)))

  (define (fold-n clist1-clists)

    (define (fold-n* r x rests)
      (if (not rests)
          r
          (if (pair? rests)
              (fold-n* (apply kons (primitive (cars x (list r))))
                       rests
                       (primitive (cdrs rests)))
              (macro-if-checks
               (if (fx< rests 0)
                   (primitive (raise-length-mismatch-exception
                               (argument-id (fx- 2 rests))
                               '()
                               fold
                               kons
                               knil
                               clist1-clists))
                   (macro-fail-check-proper-list
                    (argument-id (fx+ 2 rests))
                    (fold kons knil . clist1-clists)))
               r))))

    (let ((rests (primitive (cdrs clist1-clists))))
      (macro-if-checks
       (if (and (fixnum? rests) (fx> rests 0))
           (macro-fail-check-list
            (argument-id (fx+ 2 rests))
            (fold kons knil . clist1-clists))
           (fold-n* knil clist1-clists rests))
       (fold-n* knil clist1-clists rests))))

  (define (argument-id i)
    (if (fx= i 3) '(3 . clist1) i))

  (if (null? clists)
      (fold-1 clist1)
      (fold-n (cons clist1 clists))))

(define-primitive (fold-right (kons   procedure)
                              (knil   object)
                              (clist1 proper-or-circular-list)
                              (clists proper-or-circular-list) ...)

  (define (fold-right-1 x)
    (if (pair? x)
        (kons (car x)
              (fold-right-1 (cdr x)))
        knil))

  (define (fold-right-n x)
    (let ((rests (primitive (cdrs x))))
      (if (pair? rests)
          (apply kons (primitive (cars x (list (fold-right-n rests)))))
          knil)))

  (if (null? clists)
      (fold-right-1 clist1)
      (fold-right-n (cons clist1 clists))))

(define-procedure (fold-right (kons   procedure)
                              (knil   object)
                              (clist1 proper-or-circular-list)
                              (clists proper-or-circular-list) ...)

  (define (fold-right-1 clist1)

    (define (fold-right-1 x)
      (macro-force-vars (x)
        (if (pair? x)
            (let ((r (fold-right-1 (cdr x))))
              (and r
                   (list (kons (car x) (car r)))))
            (macro-if-checks
             (if (null? x)
                 (list knil)
                 #f)
             (list knil)))))

    (macro-if-checks
     (if (or (null? clist1) (pair? clist1))
         (let ((r (fold-right-1 clist1)))
           (if r
               (car r)
               (macro-fail-check-proper-list '(3 . clist1) (fold-right kons knil clist1))))
         (macro-fail-check-list '(3 . clist1) (fold-right kons knil clist1)))
     (fold-right-1 clist1)))

  (define (fold-right-n clist1-clists)

    (define (fold-right-n* x rests)
      (if (not rests)
          (list knil)
          (if (pair? rests)
              (let ((r (fold-right-n* rests (primitive (cdrs rests)))))
                (macro-if-checks
                 (if (fixnum? r)
                     r
                     (list (apply kons (primitive (cars x r)))))
                 (list (apply kons (primitive (cars x r))))))
              rests)))

    (let ((rests (primitive (cdrs clist1-clists))))
      (macro-if-checks
       (if (and (fixnum? rests) (fx> rests 0))
           (macro-fail-check-list
            (argument-id (fx+ 2 rests))
            (fold-right kons knil . clist1-clists))
           (let ((r (fold-right-n* clist1-clists rests)))
             (if (fixnum? r)
                 (if (fx< r 0)
                     (primitive (raise-length-mismatch-exception
                                 (argument-id (fx- 2 r))
                                 '()
                                 fold-right
                                 kons
                                 knil
                                 clist1-clists))
                     (macro-fail-check-proper-list
                      (argument-id (fx+ 2 r))
                      (fold-right kons knil . clist1-clists)))
                 (car r))))
       (car (fold-right-n* clist1-clists rests)))))

  (define (argument-id i)
    (if (fx= i 3) '(3 . clist1) i))

  (if (null? clists)
      (fold-right-1 clist1)
      (fold-right-n (cons clist1 clists))))

;;;----------------------------------------------------------------------------

;;; Sorting.

;;(declare-safe-define-procedure #t)

(define-primitive (list-sort! (proc procedure)
                              (list proper-list))

  ;; Stable mergesort algorithm

  (define (sort list len)
    (if (fx= len 1)
        (begin
          (set-cdr! list '())
          list)
        (let ((len1 (fxarithmetic-shift-right len 1)))
          (let loop ((n len1) (tail list))
            (if (fx> n 0)
                (loop (fx- n 1) (cdr tail))
                (let ((x (sort tail (fx- len len1))))
                  (merge (sort list len1) x)))))))

  (define (merge list1 list2)
    (if (pair? list1)
        (if (pair? list2)
            (let ((x1 (car list1))
                  (x2 (car list2)))
              (if (proc x2 x1)
                  (merge-loop list2 list2 list1 (cdr list2))
                  (merge-loop list1 list1 (cdr list1) list2)))
            list1)
        list2))

  (define (merge-loop result prev list1 list2)
    (if (pair? list1)
        (if (pair? list2)
            (let ((x1 (car list1))
                  (x2 (car list2)))
              (if (proc x2 x1)
                  (begin
                    (set-cdr! prev list2)
                    (merge-loop result list2 list1 (cdr list2)))
                  (begin
                    (set-cdr! prev list1)
                    (merge-loop result list1 (cdr list1) list2))))
            (begin
              (set-cdr! prev list1)
              result))
        (begin
          (set-cdr! prev list2)
          result)))

  (let ((len (primitive (proper-list-length list))))
    (and len
         (if (fx= len 0)
             '()
             (sort list len)))))

(define-procedure (list-sort! (proc procedure)
                              (list proper-list))
  (let ((result (primitive (list-sort! proc list))))
    (or result
        (macro-fail-check-list
         '(2 . list)
         (list-sort! proc list)))))

(define-primitive (list-sort (proc procedure)
                             (list proper-list))
  (list-sort! proc (list-copy list)))

(define-procedure (list-sort (proc procedure)
                             (list proper-list))
  (macro-if-checks
   (let ((copy (primitive (proper-list-copy list))))
     (if copy
         (list-sort! proc copy)
         (macro-fail-check-list
          '(2 . list)
          (list-sort proc list))))
   (list-sort! proc (list-copy list))))

;;;============================================================================
