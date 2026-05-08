(##supply-module srfi/95)

(##namespace ("srfi/95#"))                ;; in srfi/95#
(##include "~~lib/gambit/prim/prim#.scm") 
(##include "~~lib/_gambit#.scm")          
(##include "95#.scm")

(define-macro 
  (type-dispatch types convert name body . else-clause)
  (define 
    (sym . lst)
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
    (sequence object) ;; type system has no OR, therefore we use object. not great
    (less? procedure) 
    (key procedure (lambda (x) x))) 

  (define 
    (sorted-list? sequence less? key) 
    (cond
      ((or (null? sequence) (null? (cdr sequence))) #t)
      ((less? (key (cadr sequence)) (key (car sequence))) #f)
      (else (sorted-list? (cdr sequence) less? key))))

  (type-dispatch 
    (list vector string 
          u8vector u16vector u32vector 
          u64vector f32vector f64vector) #f
    sequence (sorted-list? sequence less? key)
    (##raise-type-exception 1 'list sorted? (list sequence less? key))))

(define-procedure 
  (merge (list1 proper-list) (list2 proper-list) (less? procedure) (key procedure (lambda (x) x)))   
  (define 
    (internal-merge list1 list2 list3)
    (cond 
      ((and (null? list1) (null? list2)) list3)
      ((null? list1) (internal-merge '() (cdr list2) (cons (car list2) list3)))
      ((null? list2) (internal-merge (cdr list1) '() (cons (car list1) list3)))
      ((less? (key (car list1))  (key (car list2))) (internal-merge (cdr list1) list2 (cons (car list1) list3)))
      (else (internal-merge list1 (cdr list2) (cons (car list2) list3)))))
  (reverse (internal-merge list1 list2 '())))


(define-procedure 
  (merge! (list1 (and proper-list mutable)) (list2 (and proper-list mutable)) (less? procedure) (key procedure (lambda (x) x)))   
  (define 
    (internal-merge list1 list2 list3)
    (cond 
      ((and (null? list1) (null? list2)) list3)
      ((null? list1) (internal-merge '() (cdr list2) (cons (car list2) list3)))
      ((null? list2) (internal-merge (cdr list1) '() (cons (car list1) list3)))
      ((less? (key (car list1))  (key (car list2))) 
       (let ((saved-cdr (cdr list1))) 
         (set-cdr! list1 list3) 
         (internal-merge saved-cdr list2 list1)
         ))
      (else 
        (let ((saved-cdr (cdr list2))) 
          (set-cdr! list2 list3) 
          (internal-merge saved-cdr list1 list2)
          ))))
  (reverse (internal-merge list1 list2 '())))


(define-procedure 
  (sort!list (li proper-list) 
             (less? procedure) 
             (key procedure (lambda (x) x)))

  (define 
    (halfway li len . traversed)
    (cond
      ((null? traversed) (halfway li len 0))
      ((>= (* 2 (car traversed)) len) li)
      (else (halfway (cdr li) len (+ 1 (car traversed))))))

  (define 
    (split li)
    (let* ((half (halfway li (length li))) (nxt (cdr half)))
      (set-cdr! half '())
      nxt))

  (define 
    (sort!2 li)
    (if (less? (cadr li) (car li)) 
      (let ((old-car (car li)))
        (set-car! li (cadr li))
        (set-car! (cdr li) old-car)))
    li)
  (define 
    (sort!3 li)
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
  (sort (sequence object) (less? procedure) (key procedure (lambda (x) x)))
  (type-dispatch (list vector string 
                       u8vector u16vector u32vector 
                       u64vector f32vector f64vector) #t
                 sequence (sort! sequence less? key)
                 (##raise-type-exception 1 'list sorted? (list sequence less? key)))) 

(define-procedure
  (sort! (sequence object) (less? procedure) (key procedure (lambda (x) x)))
  (if (list? sequence) (sort!list sequence less? key)
    (begin
      (heapsort sequence 0 0 (lambda (x y) (less? (key x) (key y))))
      sequence
      )))


(define-macro
  (type-vector-dispatch types name body . else-clause) 
  (define 
    (sym . lst)
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

(define 
  (heapsort vect start end less?)
  (type-vector-dispatch 
    (string vector u8vector u16vector 
            u32vector u64vector f32vector f64vector) vect
    (begin
      (define (parent x) (truncate-quotient (- x 1) 2))
      (define (left-child  x) (+ (* 2 x) 1))
      (define (right-child x) (+ (* 2 x) 2))
      (define (get  x) (vector-ref vect x))
      (define (set x y) (vector-set! vect x y))
      (define (swap  x y)
        (let ((save (get x)))
          (set x (get y))
          (set y save)))
      (define 
        (heap-restore-child heap heap_end less?)
        (cond 
          ((= heap_end 0) '())
          ((less? (get (parent heap_end)) (get heap_end))
           (swap heap_end (parent heap_end))
           (heap-restore-child heap (parent heap_end) less?))
          (else '())))

      (define 
        (heap-remove-top heap end position less?)
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
