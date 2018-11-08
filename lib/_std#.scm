;;;============================================================================

;;; File: "_std#.scm"

;;; Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception improper-length-list-exception
  id: 15d36810-b4bf-4609-83cc-761a8868e4a0
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (arg-num   unprintable: read-only:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type string 'string
  ##string?)

(define-check-type string-list 'string-list
  ##string?)

(define-check-type vector 'vector
  ##vector?)

(define-check-type vector-list 'vector-list
  ##vector?)

(define-check-type s8vector 's8vector
  ##s8vector?)

(define-check-type s8vector-list 's8vector-list
  ##s8vector?)

(define-check-type u8vector 'u8vector
  ##u8vector?)

(define-check-type u8vector-list 'u8vector-list
  ##u8vector?)

(define-check-type s16vector 's16vector
  ##s16vector?)

(define-check-type s16vector-list 's16vector-list
  ##s16vector?)

(define-check-type u16vector 'u16vector
  ##u16vector?)

(define-check-type u16vector-list 'u16vector-list
  ##u16vector?)

(define-check-type s32vector 's32vector
  ##s32vector?)

(define-check-type s32vector-list 's32vector-list
  ##s32vector?)

(define-check-type u32vector 'u32vector
  ##u32vector?)

(define-check-type u32vector-list 'u32vector-list
  ##u32vector?)

(define-check-type s64vector 's64vector
  ##s64vector?)

(define-check-type s64vector-list 's64vector-list
  ##s64vector?)

(define-check-type u64vector 'u64vector
  ##u64vector?)

(define-check-type u64vector-list 'u64vector-list
  ##u64vector?)

(define-check-type f32vector 'f32vector
  ##f32vector?)

(define-check-type f32vector-list 'f32vector-list
  ##f32vector?)

(define-check-type f64vector 'f64vector
  ##f64vector?)

(define-check-type f64vector-list 'f64vector-list
  ##f64vector?)

(define-check-type mutable 'mutable
  ##mutable?)

(define-check-type pair 'pair
  ##pair?)

(define-check-type pair-list 'pair-list
  ##pair?)

(define-check-type list 'list
  ##null?)

(define-check-type symbol 'symbol
  ##symbol?)

(define-check-type char 'char
  ##char?)

(define-check-type char-list 'char-list
  ##char?)

(define-check-type procedure 'procedure
  ##procedure?)

(define-check-type keyword 'keyword
  ##keyword?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(##define-macro (macro-fail-check-list arg-num form)

  (define (rest-param x)
    (if (pair? x)
        (rest-param (cdr x))
        x))

  (define (nonrest-params x)
    (if (pair? x)
      (cons (car x) (nonrest-params (cdr x)))
      '()))

  (define (key-params x)
    (if (pair? x)
      (if (keyword? (car x))
        (cons (car x) (cons (cadr x) (key-params (cddr x))))
        (key-params (cdr x)))
      '()))

  (define (prekey-params x)
    (if (or (not (pair? x)) (keyword? (car x)))
      '()
      (cons (car x) (prekey-params (cdr x)))))

  (define (failure name)
    (let* ((k (key-params (cdr form)))
           (r (rest-param (cdr form)))
           (nr (nonrest-params (cdr form)))
           (pk (prekey-params nr)))
      (if (and (null? k) (not (null? r)))
        `(,name ,arg-num '() ,(car form) ,@pk ,r)
        `(,name
          ,arg-num
          ,(if (and (null? k) (null? r))
             (car form)
             `(##list ,(car form) ,@k ,@(if (null? r) '() (list r))))
          ,@pk))))

  (failure '##fail-check-list))

(##define-macro (define-prim-vector-procedures
                  name
                  default-elem-value
                  macro-force-elem
                  macro-check-elem
                  macro-check-elem-list
                  elem=)

  (define (sym . lst)
    (string->symbol
     (apply string-append
            (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                 lst))))

  (let ()

    (define macro-check-vect (sym 'macro-check- name))
    (define vect-list        (sym name '-list))
    (define ##fail-check-vect (sym '##fail-check- name))
    (define ##fail-check-vect-list (sym '##fail-check- name '-list))

    (define ##vect?          (sym "##" name '?))
    (define ##make-vect      (sym '##make- name))
    (define ##vect           (sym "##" name))
    (define ##vect-length    (sym "##" name '-length))
    (define ##vect-ref       (sym "##" name '-ref))
    (define ##vect-set!      (sym "##" name '-set!))
    (define ##vect-set       (sym "##" name '-set))
    (define ##vect->list     (sym "##" name '->list))
    (define ##list->vect     (sym '##list-> name))
    (define ##vect-copy      (sym "##" name '-copy))
    (define ##vect-fill!     (sym "##" name '-fill!))
    (define ##subvect        (sym '##sub name))
    (define ##append-vects   (sym '##append- name 's))
    (define ##vect-append    (sym "##" name '-append))
    (define ##subvect-move!  (sym '##sub name '-move!))
    (define ##subvect-fill!  (sym '##sub name '-fill!))
    (define ##vect-shrink!   (sym "##" name '-shrink!))
    (define ##vect-equal?    (sym "##" name '-equal?))

    (define vect?            (sym name '?))
    (define make-vect        (sym 'make- name))
    (define vect             (sym name))
    (define vect-length      (sym name '-length))
    (define vect-ref         (sym name '-ref))
    (define vect-set!        (sym name '-set!))
    (define vect-set         (sym name '-set))
    (define vect->list       (sym name '->list))
    (define list->vect       (sym 'list-> name))
    (define vect-copy        (sym name '-copy))
    (define vect-fill!       (sym name '-fill!))
    (define subvect          (sym 'sub name))
    (define append-vects     (sym 'append- name 's))
    (define vect-append      (sym name '-append))
    (define subvect-move!    (sym 'sub name '-move!))
    (define subvect-fill!    (sym 'sub name '-fill!))
    (define vect-shrink!     (sym name '-shrink!))

    `(begin

       (define-fail-check-type ,name ',name)
       (define-fail-check-type ,vect-list ',vect-list)

       (define-prim (,##vect? obj))

       (define-prim (,vect? obj)
         (macro-force-vars (obj)
           (,##vect? obj)))

       (define-prim (,make-vect k #!optional (f (macro-absent-obj)))
         (macro-force-vars (k)
           (,macro-force-elem (f)
             (let ((fill
                    (if (##eq? f (macro-absent-obj))
                        ,default-elem-value
                        f)))
               (macro-check-index k 1 (,make-vect k f)
                 (,macro-check-elem fill 2 (,make-vect k f)
                   (,##make-vect k fill)))))))

       (define-prim (,##vect . lst)
         (,##list->vect lst))

       ,@(if (eq? name 'vector)
             `((define-prim (,vect
                             #!optional
                             (elem1 (macro-absent-obj))
                             (elem2 (macro-absent-obj))
                             (elem3 (macro-absent-obj))
                             (elem4 (macro-absent-obj))
                             #!rest
                             others)
                 (if (##eq? elem1 (macro-absent-obj))
                     (,##vect)
                     (,macro-force-elem (elem1)
                       (,macro-check-elem elem1 1 (,vect elem1 elem2 elem3 elem4 . others)
                         (if (##eq? elem2 (macro-absent-obj))
                             (,##vect elem1)
                             (,macro-force-elem (elem2)
                               (,macro-check-elem elem2 2 (,vect elem1 elem2 elem3 elem4 . others)
                                 (if (##eq? elem3 (macro-absent-obj))
                                     (,##vect elem1 elem2)
                                     (,macro-force-elem (elem3)
                                       (,macro-check-elem elem3 3 (,vect elem1 elem2 elem3 elem4 . others)
                                         (if (##eq? elem4 (macro-absent-obj))
                                             (,##vect elem1 elem2 elem3)
                                             (,macro-force-elem (elem4)
                                               (,macro-check-elem elem4 4 (,vect elem1 elem2 elem3 elem4 . others)
                                                 (if (##null? others)
                                                     (,##vect elem1 elem2 elem3 elem4)
                                                     (let loop1 ((x others)
                                                                 (n 4))
                                                       (if (##pair? x)
                                                           (loop1 (##cdr x)
                                                                  (##fx+ n 1))
                                                           (let ((vect (,##make-vect n)))
                                                             (,##vect-set! vect 0 elem1)
                                                             (,##vect-set! vect 1 elem2)
                                                             (,##vect-set! vect 2 elem3)
                                                             (,##vect-set! vect 3 elem4)
                                                             (let loop2 ((x others)
                                                                         (i 4))
                                                               (if (##pair? x)
                                                                   (let ((elem (##car x)))
                                                                     (,macro-force-elem (elem)
                                                                       (,macro-check-elem elem (##fx+ i 1) (,vect elem1 elem2 elem3 elem4 . others)
                                                                         (begin
                                                                           (,##vect-set! vect i elem)
                                                                           (loop2 (##cdr x)
                                                                                  (##fx+ i 1))))))
                                                                   vect))))))))))))))))))))
             `((define-prim (,vect . others)
                 (let loop1 ((x others) (n 0))
                   (if (##pair? x)
                       (loop1 (##cdr x) (##fx+ n 1))
                       (let ((vect (,##make-vect n)))
                         (let loop2 ((x others) (i 0))
                           (if (##pair? x)
                               (let ((elem (##car x)))
                                 (,macro-force-elem (elem)
                                   (,macro-check-elem elem (##fx+ i 1) (,vect . others)
                                     (begin
                                       (,##vect-set! vect i elem)
                                       (loop2 (##cdr x) (##fx+ i 1))))))
                               vect))))))))

       (define-prim (,##vect-length vect))

       (define-prim (,vect-length vect)
         (macro-force-vars (vect)
           (,macro-check-vect vect 1 (,vect-length vect)
             (,##vect-length vect))))

       (define-prim (,##vect-ref vect k))

       (define-prim (,vect-ref vect k)
         (macro-force-vars (vect k)
           (,macro-check-vect vect 1 (,vect-ref vect k)
             (macro-check-index-range
               k
               2
               0
               (,##vect-length vect)
               (,vect-ref vect k)
               (,##vect-ref vect k)))))

       (define-prim (,##vect-set! vect k val))

       (define-prim (,vect-set! vect k val)
         (macro-force-vars (vect k)
           (,macro-force-elem (val)
             (,macro-check-vect vect 1 (,vect-set! vect k val)
               (macro-check-mutable vect 1 (,vect-set! vect k val)
                 (macro-check-index-range
                   k
                   2
                   0
                   (,##vect-length vect)
                   (,vect-set! vect k val)
                   (,macro-check-elem val 3 (,vect-set! vect k val)
                     (begin
                       (,##vect-set! vect k val)
                       (##void)))))))))

       (define-prim (,##vect-set vect k val)
         (let ((result (,##vect-copy vect)))
           (,##vect-set! result k val)
           result))

       (define-prim (,vect-set vect k val)
         (macro-force-vars (vect k)
           (,macro-force-elem (val)
             (,macro-check-vect vect 1 (,vect-set vect k val)
               (macro-check-index-range
                 k
                 2
                 0
                 (,##vect-length vect)
                 (,vect-set vect k val)
                 (,macro-check-elem val 3 (,vect-set vect k val)
                   (,##vect-set vect k val)))))))

       (define-prim (,##vect->list vect)
         (let loop ((lst '()) (i (##fx- (,##vect-length vect) 1)))
           (if (##fx< i 0)
               lst
               (loop (##cons (,##vect-ref vect i) lst) (##fx- i 1)))))

       (define-prim (,vect->list vect)
         (macro-force-vars (vect)
           (,macro-check-vect vect 1 (,vect->list vect)
             (let loop ((lst '()) (i (##fx- (,##vect-length vect) 1)))
               (if (##fx< i 0)
                   lst
                   (loop (##cons (,##vect-ref vect i) lst) (##fx- i 1)))))))

       (define-prim (,##list->vect lst)
         (let loop1 ((x lst) (n 0))
           (if (##pair? x)
               (loop1 (##cdr x) (##fx+ n 1))
               (let ((vect (,##make-vect n ,default-elem-value)))
                 (let loop2 ((x lst) (i 0))
                   (if (and (##pair? x)  ;; double check in case another
                            (##fx< i n)) ;; thread mutates the list
                       (let ((elem (##car x)))
                         (,##vect-set! vect i elem)
                         (loop2 (##cdr x) (##fx+ i 1)))
                       vect))))))

       (define-prim (,list->vect lst)
         (let loop1 ((x lst) (n 0))
           (macro-force-vars (x)
             (if (##pair? x)
                 (loop1 (##cdr x) (##fx+ n 1))
                 (macro-check-list x 1 (,list->vect lst)
                   (let ((vect (,##make-vect n ,default-elem-value)))
                     (let loop2 ((x lst) (i 0))
                       (macro-force-vars (x)
                         (if (and (##pair? x)  ;; double check in case another
                                  (##fx< i n)) ;; thread mutates the list
                             (let ((elem (##car x)))
                               (,macro-check-elem-list elem 1 (,list->vect lst)
                                 (begin
                                   (,##vect-set! vect i elem)
                                   (loop2 (##cdr x) (##fx+ i 1)))))
                             vect)))))))))

       (define-prim (,##vect-fill! vect fill)
         (,##subvect-fill! vect 0 (,##vect-length vect) fill))

       (define-prim (,vect-fill! vect fill)
         (macro-force-vars (vect)
           (,macro-force-elem (fill)
             (,macro-check-vect vect 1 (,vect-fill! vect fill)
               (macro-check-mutable vect 1 (,vect-fill! vect fill)
                 (,macro-check-elem fill 2 (,vect-fill! vect fill)
                   (,##vect-fill! vect fill)))))))

       (define-prim (,##vect-copy vect)
         (let ((len (,##vect-length vect)))
           (,##subvect-move! vect 0 len (,##make-vect len) 0)))

       (define-prim (,vect-copy vect)
         (macro-force-vars (vect)
           (,macro-check-vect vect 1 (,vect-copy vect)
             (,##vect-copy vect))))

       (define-prim (,##subvect vect start end)
         (,##subvect-move!
          vect
          start
          end
          (,##make-vect (##fxmax (##fx- end start) 0))
          0))

       (define-prim (,subvect vect start end)
         (macro-force-vars (vect start end)
           (,macro-check-vect vect 1 (,subvect vect start end)
             (macro-check-index-range-incl
               start
               2
               0
               (,##vect-length vect)
               (,subvect vect start end)
               (macro-check-index-range-incl
                 end
                 3
                 start
                 (,##vect-length vect)
                 (,subvect vect start end)
                 (,##subvect vect start end))))))

       (define-prim (,##append-vects lst #!optional (vect-append? #f))
         (let loop1 ((n 0)
                     (lst1 lst)
                     (lst2 '())
                     (arg-num 1))
           (cond ((##pair? lst1)
                  (let ((vect (##car lst1)))
                    (macro-force-vars (vect)
                      (if (##not (,##vect? vect))
                          (if vect-append?
                              (,##fail-check-vect arg-num '() ,vect-append lst)
                              (,##fail-check-vect-list 1 ,append-vects lst))
                          (loop1 (##fx+ n (,##vect-length vect))
                                 (##cdr lst1)
                                 (##cons vect lst2)
                                 (##fx+ arg-num 1))))))
                 ((##null? lst1)
                  (let ((result (,##make-vect n)))
                    (let loop2 ((n n)
                                (lst2 lst2))
                      (if (##pair? lst2)
                          (let* ((vect (##car lst2))
                                 (len (,##vect-length vect))
                                 (new-n (##fx- n len)))
                            (,##subvect-move! vect 0 len result new-n)
                            (loop2 new-n (##cdr lst2)))
                          result))))
                 (else
                  (,##fail-check-vect-list 1 ,append-vects lst)))))

       (define-prim (,append-vects lst)
         (,##append-vects lst #f))

       (define-prim (,##vect-append . lst)
         (,##append-vects lst #t))

       (define-prim (,vect-append . lst)
         (,##append-vects lst #t))

       (macro-case-target

        ((c C)
         (define-prim ,##subvect-move!
           (c-lambda (scheme-object  ;; src-vect
                      scheme-object  ;; src-start
                      scheme-object  ;; src-end
                      scheme-object  ;; dst-vect
                      scheme-object) ;; dst-start
                     scheme-object
                     ,(string-append
                       (case ##subvect-move!
                         ((##subvector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FIELD(___arg1,___INT(___arg2)));
  void *dst = ___CAST(void*,&___FIELD(___arg4,___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * ___WS;
end-of-code
)
                         ((##substring-move!)
#<<end-of-code
  void *src =
        ___CAST(void*,
                ___CS_SELECT(&___FETCH_U8(___BODY(___arg1),___INT(___arg2)),
                             &___FETCH_U16(___BODY(___arg1),___INT(___arg2)),
                             &___FETCH_U32(___BODY(___arg1),___INT(___arg2))));
  void *dst =
        ___CAST(void*,
                ___CS_SELECT(&___FETCH_U8(___BODY(___arg4),___INT(___arg5)),
                             &___FETCH_U16(___BODY(___arg4),___INT(___arg5)),
                             &___FETCH_U32(___BODY(___arg4),___INT(___arg5))));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * ___CS;
end-of-code
)
                         ((##subs8vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S8(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S8(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S8);
end-of-code
)
                         ((##subu8vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U8(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U8(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U8);
end-of-code
)
                         ((##subs16vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S16(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S16(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S16);
end-of-code
)
                         ((##subu16vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U16(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U16(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U16);
end-of-code
)
                         ((##subs32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S32(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S32(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S32);
end-of-code
)
                         ((##subu32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U32(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U32(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U32);
end-of-code
)
                         ((##subs64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S64(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S64(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S64);
end-of-code
)
                         ((##subu64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U64(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U64(___BODY(___arg4),___INT(___arg5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U64);
end-of-code
)
                         ((##subf32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,___CAST(___F32*,___BODY(___arg1))+___INT(___arg2));
  void *dst = ___CAST(void*,___CAST(___F32*,___BODY(___arg4))+___INT(___arg5));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___F32);
end-of-code
)
                         ((##subf64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,___CAST(___F64*,___BODY(___arg1))+___INT(___arg2));
  void *dst = ___CAST(void*,___CAST(___F64*,___BODY(___arg4))+___INT(___arg5));
  ___SIZE_TS len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___F64);
end-of-code
))

#<<end-of-code
  memmove (dst, src, len);
  ___result = ___arg4;
end-of-code
))))

        (else
         (define-prim (,##subvect-move! src-vect src-start src-end dst-vect dst-start)
           ;; Copy direction must be selected in case src-vect and
           ;; dst-vect are the same object.
           (if (##fx< src-start dst-start)
               (let loop1 ((i (##fx- src-end 1))
                           (j (##fx-
                               (##fx+ dst-start
                                      (##fx- src-end src-start))
                               1)))
                 (if (##fx< i src-start)
                     dst-vect
                     (begin
                       (,##vect-set! dst-vect j (,##vect-ref src-vect i))
                       (loop1 (##fx- i 1)
                              (##fx- j 1)))))
               (let loop2 ((i src-start)
                           (j dst-start))
                 (if (##fx< i src-end)
                     (begin
                       (,##vect-set! dst-vect j (,##vect-ref src-vect i))
                       (loop2 (##fx+ i 1)
                              (##fx+ j 1)))
                     dst-vect))))))

       (define-prim (,subvect-move! src-vect src-start src-end dst-vect dst-start)
         (macro-force-vars (src-vect src-start src-end dst-vect dst-start)
           (,macro-check-vect
             src-vect
             1
             (,subvect-move! src-vect src-start src-end dst-vect dst-start)
             (macro-check-index-range-incl
               src-start
               2
               0
               (,##vect-length src-vect)
               (,subvect-move! src-vect src-start src-end dst-vect dst-start)
               (macro-check-index-range-incl
                 src-end
                 3
                 src-start
                 (,##vect-length src-vect)
                 (,subvect-move! src-vect src-start src-end dst-vect dst-start)
                 (,macro-check-vect
                   dst-vect
                   4
                   (,subvect-move! src-vect src-start src-end dst-vect dst-start)
                   (macro-check-mutable
                     dst-vect
                     4
                     (,subvect-move! src-vect src-start src-end dst-vect dst-start)
                     (macro-check-index-range-incl
                       dst-start
                       5
                       0
                       (##fx- (,##vect-length dst-vect)
                              (##fx- src-end src-start))
                       (,subvect-move! src-vect src-start src-end dst-vect dst-start)
                       (begin
                         (,##subvect-move! src-vect src-start src-end dst-vect dst-start)
                         (##void))))))))))

       (define-prim (,##subvect-fill! vect start end fill)
         (let loop ((i (##fx- end 1)))
           (if (##fx< i start)
               (##void)
               (begin
                 (,##vect-set! vect i fill)
                 (loop (##fx- i 1))))))

       (define-prim (,subvect-fill! vect start end fill)
         (macro-force-vars (vect start end)
           (,macro-force-elem (fill)
             (,macro-check-vect vect 1 (,subvect-fill! vect start end fill)
               (macro-check-mutable vect 1 (,subvect-fill! vect start end fill)
                 (macro-check-index-range-incl
                   start
                   2
                   0
                   (,##vect-length vect)
                   (,subvect-fill! vect start end fill)
                   (macro-check-index-range-incl
                     end
                     3
                     start
                     (,##vect-length vect)
                     (,subvect-fill! vect start end fill)
                     (,macro-check-elem
                       fill
                       4
                       (,subvect-fill! vect start end fill)
                       (,##subvect-fill! vect start end fill)))))))))

       (define-prim (,##vect-shrink! vect k))

       (define-prim (,vect-shrink! vect k)
         (macro-force-vars (vect k)
           (,macro-check-vect vect 1 (,vect-shrink! vect k)
             (macro-check-mutable vect 1 (,vect-shrink! vect k)
               (macro-check-index-range-incl
                 k
                 2
                 0
                 (,##vect-length vect)
                 (,vect-shrink! vect k)
                 (begin
                   (,##vect-shrink! vect k)
                   (##void)))))))

       (define-prim (,##vect-equal? vect1 vect2)
         (or (##eq? vect1 vect2)
             (let ((len (,##vect-length vect1)))
               (and (##fx= len (,##vect-length vect2))
                    (let loop ((i (##fx- len 1)))
                      (or (##fx< i 0)
                          (and (let ()
                                 (##declare (generic)) ;; avoid fixnum specific ##eqv?
                                 (,elem= (,##vect-ref vect1 i)
                                         (,##vect-ref vect2 i)))
                               (loop (##fx- i 1)))))))))
       )))

;;;============================================================================
