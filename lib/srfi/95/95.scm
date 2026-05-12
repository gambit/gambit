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


(define-macro (dispatch-sort types)
              (define (sym . lst)
                (string->symbol
                  (apply string-append
                         (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                              lst))))
              `(cond
                 ,@(map 
                     (lambda (type) 
                          (define prim-vect?             (sym "##" type '?))
                          (define prim-make-vect         (sym '##make- type))
                          (define prim-vect-length       (sym "##" type '-length))
                          (define prim-vect-ref          (sym "##" type '-ref))
                          (define prim-vect-ref-fixnum   (sym "##" type '-ref-fixnum))
                          (define prim-vect-set!         (sym "##" type '-set!))
                          (define prim-vect-set!-fixnum  (sym "##" type '-set!-fixnum))
                          (define prim-vect-set          (sym "##" type '-set))
                          (define prim-vect-set-small    (sym "##" type '-set-small))
                          (define prim-vect-swap!        (sym "##" type '-swap!))
                          (define prim-subvect-move!     (sym '##sub type '-move!))
                      `((,prim-vect? sequence) (let* ((len (,prim-vect-length sequence))
                              (temp (,prim-make-vect len)))

                         (define (merge! lo mid hi)

                           (let loop1 ((i lo))
                             (if (fx< i hi)
                               (begin
                                 (,prim-vect-set! temp i (,prim-vect-ref sequence i))
                                 (loop1 (fx+ i 1)))))

                           (let loop2 ((i lo) (j mid) (k lo))
                             (cond ((and (fx< i mid) (fx< j hi))
                                    (let ((a (,prim-vect-ref temp i))
                                          (b (,prim-vect-ref temp j)))
                                      (if (less? b a)
                                        (begin
                                          (,prim-vect-set! sequence k b)
                                          (loop2 i (fx+ j 1) (fx+ k 1)))
                                        (begin
                                          (,prim-vect-set! sequence k a)
                                          (loop2 (fx+ i 1) j (fx+ k 1))))))
                                   ((fx< i mid)
                                    (,prim-vect-set! sequence k (,prim-vect-ref temp i))
                                    (loop2 (fx+ i 1) j (fx+ k 1)))
                                   ((fx< j hi)
                                    (,prim-vect-set! sequence k (,prim-vect-ref temp j))
                                    (loop2 i (fx+ j 1) (fx+ k 1))))))

                         (define (sort! lo hi)
                           (let ((n (fx- hi lo)))
                             (if (fx< 1 n)
                               (let ((mid (fx+ lo (fxarithmetic-shift-right n 1))))
                                 (sort! lo mid)
                                 (sort! mid hi)
                                 (merge! lo mid hi)))))
                         (sort! 0 len)
                        sequence)))
                     types)
                 (else (##raise-type-exception 1 'list sort! (list sequence less? key)))
                 ))



(define-procedure 
  (sort! (sequence object) (less? procedure) (key procedure (lambda (x) x)))
  (if (list? sequence) (list-sort! (lambda (x y) (less? (key x) (key y))) sequence)
    (dispatch-sort (string vector u8vector u16vector u32vector u64vector f32vector f64vector))))



(define-procedure 
  (sort (sequence object) (less? procedure) (key procedure (lambda (x) x)))
          (type-dispatch 
            (list vector string 
                  u8vector u16vector u32vector 
                  u64vector f32vector f64vector) #t
            sequence (list-sort (lambda (x y) (less? (key x) (key y)))  sequence)
            (##raise-type-exception 1 'list sort (list sequence less? key))
            ))
