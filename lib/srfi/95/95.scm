(##supply-module srfi/95)

(##namespace ("srfi/95#"))                ;; in srfi/95#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc
(##include "95#.scm")

(define-macro 
  (type-dispatch types convert name body . else-clause) 
    (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))
  `(cond
     ,@(map 
        (lambda (type) 
          (cond 
            ((symbol=? type 'list) `((list? ,name) ,body))
            (convert 
              `((,(sym type '?) ,name) 
                (,(sym 'list-> type) (let ((,name (,(sym type '->list) ,name))) ,body))))
            (else `((,(sym type '?) ,name)  (let ((,name (,(sym type '->list) ,name))) ,body)))
          ))
        types)
        ,@(if (null? else-clause) '() `((else ,@else-clause)))
     ))

(define-procedure 
        (sorted? 
        (li object) ;; type system has no OR, therefore we use object. not great
        (less? procedure) 
        (key procedure (lambda (x) x))) 

    (define-procedure (sorted-list? (li list) (less? procedure) (key procedure))
      (cond
        ((or (null? li) (null? (cdr li))) #t)
        ((less? (key (cadr li)) (key (car li))) #f)
        (else (sorted-list? (cdr li) less? key))))

    (type-dispatch (list vector string 
            u8vector u16vector u32vector 
            u64vector f32vector f64vector) #f
            li (sorted-list? li less? key)
            (##raise-type-exception 1 'list sorted? (list li less? key))))

(define-procedure (merge (l1 list) (l2 list) (less? procedure) (key procedure (lambda (x) x)))   
    (letrec ((internal-merge
        (lambda (l1 l2 l3)
          (cond 
            ((and (null? l1) (null? l2)) l3)
            ((null? l1) (internal-merge '() (cdr l2) (cons (car l2) l3)))
            ((null? l2) (internal-merge (cdr l1) '() (cons (car l1) l3)))
            ((less? (key (car l1))  (key (car l2))) (internal-merge (cdr l1) l2 (cons (car l1) l3)))
            (else (internal-merge l1 (cdr l2) (cons (car l2) l3)))))))
      (reverse (internal-merge l1 l2 '()))))


(define-procedure (merge! (l1 list) (l2 list) (less? procedure) (key procedure (lambda (x) x)))   
    (letrec ((internal-merge
        (lambda (l1 l2 l3)
          (cond 
            ((and (null? l1) (null? l2)) l3)
            ((null? l1) (internal-merge '() (cdr l2) (cons (car l2) l3)))
            ((null? l2) (internal-merge (cdr l1) '() (cons (car l1) l3)))
            ((less? (key (car l1))  (key (car l2))) 
                (let ((saved-cdr (cdr l1))) 
                    (set-cdr! l1 l3) 
                    (internal-merge saved-cdr l2 l1)
                ))
            (else 
                (let ((saved-cdr (cdr l2))) 
                    (set-cdr! l2 l3) 
                    (internal-merge saved-cdr l1 l2)
                ))))))
      (reverse (internal-merge l1 l2 '()))))

(define-procedure (halfway (li list) (len number) (traversed number 0))
    (cond
      ((>= (* 2 traversed) len) li)
      (else (halfway (cdr li) len (+ 1 traversed)))))

(define (split li)
  (let* ((half (halfway li (length li))) (nxt (cdr half)))
    (set-cdr! half '())
    nxt))

(define-procedure 
  (sort!list (li list) 
        (less? procedure) 
        (key procedure (lambda (x) x)))
  (define (sort!2 li)
    (if (less? (cadr li) (car li)) 
      (let ((old-car (car li)))
        (set-car! li (cadr li))
        (set-car! (cdr li) old-car)))
    li)
  (define (sort!3 li)
    (sort!2 li)
    (sort!2 (cdr li))
    (sort!2 li)
    li)
  (cond
    ((or (null? li) (null? (cdr li))) li)
    ((null? (cddr li)) (sort!2 li))
    ((null? (cdddr li)) (sort!3 li))
    (else (merge! (sort!list (split li) less? key) (sort! li less? key) less? key)) ))


(define-procedure
    (sort (li object) (less? procedure) (key procedure (lambda (x) x)))
    (type-dispatch (list vector string 
            u8vector u16vector u32vector 
            u64vector f32vector f64vector) #t
            li (sort! li less? key)
            (##raise-type-exception 1 'list sorted? (list li less? key)))) 

(define-procedure
    (sort! (li object) (less? procedure) (key procedure (lambda (x) x)))
    (if (list? li) (sort!list li less? key)
      (begin
      (heapsort li 0 0 (lambda (x y) (less? (key x) (key y))))
      li
      )))
      

(define-macro
  (type-vector-dispatch types name body . else-clause) 
    (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))

  `(cond
     ,@(map 
        (lambda (type) 
            `((,(sym type '?) ,name)
              (let ((vector-ref ,(sym type '-ref))
                    (vector-set! ,(sym type '-set!))
                    (vector-length ,(sym type '-length))
                    (vector->listi,(sym type '->list)))
                ,body)))
        types)
        ,@(if (null? else-clause) '() `((else ,@else-clause)))
     ))

(define (heapsort vect start end less?)
   (type-vector-dispatch 
     (string vector u8vector u16vector 
     u32vector u64vector f32vector f64vector) vect
    (begin
      (define parent (lambda (x) (truncate-quotient (- x 1) 2)))
      (define left-child (lambda (x) (+ (* 2 x) 1)))
      (define right-child (lambda (x) (+ (* 2 x) 2)))
      (define get (lambda (x) (vector-ref vect x)))
      (define set (lambda (x y) (vector-set! vect x y)))
      (define swap (lambda (x y)
        (let ((save (get x)))
          (set x (get y))
          (set y save))))
    (define (heap-restore-child heap heap_end less?)
      (cond 
        ((= heap_end 0) '())
        ((less? (get (parent heap_end)) (get heap_end))
         (swap heap_end (parent heap_end))
         (heap-restore-child heap (parent heap_end) less?))
        (else '())))

    (define (heap-remove-top heap end position less?)
      (if (> (left-child position) end) #f
      (if (> (right-child position) end) 
        (if (less? (get position) (get (left-child position)))
           (begin
           (swap (left-child position) position) 
           (heap-remove-top heap end (left-child position) less?)))
      (if (less? (get (left-child position)) (get (right-child position)))
        (if (less? (get position) (get (right-child position)))
           (begin
           (swap (right-child position) position) 
           (heap-remove-top heap end (right-child position) less?)))
        (if (less? (get position) (get (left-child position)))
           (begin
           (swap (left-child position) position) 
           (heap-remove-top heap end (left-child position) less?)))))))
      (cond
        ((< (+ end 1) (vector-length vect)) 
         (heap-restore-child vect (+ end 1) less?)
         (heapsort vect (- (vector-length vect) 1) (+ end 1) less?))
        ((> start 0) 
         (swap 0 start)
         (heap-remove-top vect (- start 1) 0 less?)
         (heapsort vect (- start 1) end less?))
        ((less? (get 1) (get 0)) (swap 0 1))
        (else '())))
    (##raise-type-exception 1 'list sorted? (list vect less?))))
