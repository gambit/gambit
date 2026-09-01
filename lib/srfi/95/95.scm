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
                      `((,prim-vect? sequence) 
                        (macro-vect-mergesort! less? sequence 0 (,prim-vect-length sequence) ,prim-make-vect ,prim-vect-ref ,prim-vect-set!)))
                     types)
                 (else (##raise-type-exception 1 'list sort! (list sequence less? key)))
                 ))



(define-procedure 
  (sort! (sequence object) (less? procedure) (key procedure (lambda (x) x)))
  (if (list? sequence) (list-sort! (lambda (x y) (less? (key x) (key y))) sequence)
    (begin
    (dispatch-sort (string vector u8vector u16vector u32vector u64vector f32vector f64vector))
    sequence)))



(define-procedure 
  (sort (sequence object) (less? procedure) (key procedure (lambda (x) x)))
          (type-dispatch 
            (list vector string 
                  u8vector u16vector u32vector 
                  u64vector f32vector f64vector) #t
            sequence (list-sort (lambda (x y) (less? (key x) (key y)))  sequence)
            (##raise-type-exception 1 'list sort (list sequence less? key))
            ))
