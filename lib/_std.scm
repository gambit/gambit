;;;============================================================================

;;; File: "_std.scm", Time-stamp: <2007-04-04 11:26:46 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "header.scm")

;;;============================================================================

;; Implementation of exceptions.

(implement-library-type-improper-length-list-exception)

(define-prim (##raise-improper-length-list-exception arg-num proc . args);;;;;;;;;;;
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   #f
   #f
   (lambda (procedure arguments arg-num dummy1 dummy2)
     (macro-raise
      (macro-make-improper-length-list-exception procedure arguments arg-num)))))

;;;----------------------------------------------------------------------------

;; Definition of vector-like data types (i.e. string, vector, s8vector, ...).

(##define-macro (define-prim-vector-procedures
                 name
                 default-elem-value
                 macro-force-elem
                 macro-check-elem
                 macro-check-elem-list)

  (define (sym . lst)
    (string->symbol (apply string-append (map symbol->string lst))))

  (let ()

    (define macro-check-vect (sym 'macro-check- name))
    (define vect-list        (sym name '-list))

    (define ##vect?          (sym '## name '?))
    (define ##make-vect      (sym '##make- name))
    (define ##vect           (sym '## name))
    (define ##vect-length    (sym '## name '-length))
    (define ##vect-ref       (sym '## name '-ref))
    (define ##vect-set!      (sym '## name '-set!))
    (define ##vect->list     (sym '## name '->list))
    (define ##list->vect     (sym '##list-> name))
    (define ##vect-copy      (sym '## name '-copy))
    (define ##vect-fill!     (sym '## name '-fill!))
    (define ##subvect        (sym '##sub name))
    (define ##append-vects   (sym '##append- name 's))
    (define ##vect-append    (sym '## name '-append))
    (define ##subvect-move!  (sym '##sub name '-move!))
    (define ##subvect-fill!  (sym '##sub name '-fill!))
    (define ##vect-shrink!   (sym '## name '-shrink!))

    (define vect?            (sym name '?))
    (define make-vect        (sym 'make- name))
    (define vect             (sym name))
    (define vect-length      (sym name '-length))
    (define vect-ref         (sym name '-ref))
    (define vect-set!        (sym name '-set!))
    (define vect->list       (sym name '->list))
    (define list->vect       (sym 'list-> name))
    (define vect-copy        (sym name '-copy))
    (define vect-fill!       (sym name '-fill!))
    (define subvect          (sym 'sub name))
    (define vect-append      (sym name '-append))

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
                                                    (##fixnum.+ n 1))
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
                                                       (,macro-check-elem elem (##fixnum.+ i 1) (,vect elem1 elem2 elem3 elem4 . others)
                                                         (begin
                                                           (,##vect-set! vect i elem)
                                                           (loop2 (##cdr x)
                                                                  (##fixnum.+ i 1))))))
                                                   vect))))))))))))))))))))
           `((define-prim (,vect . others)
               (let loop1 ((x others) (n 0))
                 (if (##pair? x)
                   (loop1 (##cdr x) (##fixnum.+ n 1))
                   (let ((vect (,##make-vect n)))
                     (let loop2 ((x others) (i 0))
                       (if (##pair? x)
                         (let ((elem (##car x)))
                           (,macro-force-elem (elem)
                             (,macro-check-elem elem (##fixnum.+ i 1) (,vect . others)
                               (begin
                                 (,##vect-set! vect i elem)
                                 (loop2 (##cdr x) (##fixnum.+ i 1))))))
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
               (macro-check-subtyped-mutable vect 1 (,vect-set! vect k val)
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

       (define-prim (,##vect->list vect)
         (let loop ((lst '()) (i (##fixnum.- (,##vect-length vect) 1)))
           (if (##fixnum.< i 0)
             lst
             (loop (##cons (,##vect-ref vect i) lst) (##fixnum.- i 1)))))

       (define-prim (,vect->list vect)
         (macro-force-vars (vect)
           (,macro-check-vect vect 1 (,vect->list vect)
             (let loop ((lst '()) (i (##fixnum.- (,##vect-length vect) 1)))
               (if (##fixnum.< i 0)
                 lst
                 (loop (##cons (,##vect-ref vect i) lst) (##fixnum.- i 1)))))))

       (define-prim (,##list->vect lst)
         (let loop1 ((x lst) (n 0))
           (if (##pair? x)
             (loop1 (##cdr x) (##fixnum.+ n 1))
             (let ((vect (,##make-vect n ,default-elem-value)))
               (let loop2 ((x lst) (i 0))
                 (if (and (##pair? x)      ;; double check in case another
                          (##fixnum.< i n));; thread mutates the list
                   (let ((elem (##car x)))
                     (,##vect-set! vect i elem)
                     (loop2 (##cdr x) (##fixnum.+ i 1)))
                   vect))))))

       (define-prim (,list->vect lst)
         (let loop1 ((x lst) (n 0))
           (macro-force-vars (x)
             (if (##pair? x)
               (loop1 (##cdr x) (##fixnum.+ n 1))
               (macro-check-list x 1 (,list->vect lst)
                 (let ((vect (,##make-vect n ,default-elem-value)))
                   (let loop2 ((x lst) (i 0))
                     (macro-force-vars (x)
                       (if (and (##pair? x)      ;; double check in case another
                                (##fixnum.< i n));; thread mutates the list
                         (let ((elem (##car x)))
                           (,macro-check-elem-list elem 1 (,list->vect lst)
                             (begin
                               (,##vect-set! vect i elem)
                               (loop2 (##cdr x) (##fixnum.+ i 1)))))
                         vect)))))))))

       (define-prim (,##vect-fill! vect fill)
         (,##subvect-fill! vect 0 (,##vect-length vect) fill))

       (define-prim (,vect-fill! vect fill)
         (macro-force-vars (vect)
           (,macro-force-elem (fill)
             (,macro-check-vect vect 1 (,vect-fill! vect fill)
               (,macro-check-elem fill 2 (,vect-fill! vect fill)
                 (,##vect-fill! vect fill))))))

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
          (,##make-vect (##fixnum.max (##fixnum.- end start) 0))
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

       (define-prim (,##append-vects lst)
         (let loop1 ((n 0)
                     (lst1 lst)
                     (lst2 '())
                     (arg-num 1))
           (if (##pair? lst1)
             (let ((vect (##car lst1)))
               (macro-force-vars (vect)
                 (,macro-check-vect vect arg-num (,vect-append . lst)
                   (loop1 (##fixnum.+ n (,##vect-length vect))
                          (##cdr lst1)
                          (##cons vect lst2)
                          (##fixnum.+ arg-num 1)))))
             (let ((result (,##make-vect n)))
               (let loop2 ((n n)
                           (lst2 lst2))
                 (if (##pair? lst2)
                   (let* ((vect (##car lst2))
                          (len (,##vect-length vect))
                          (new-n (##fixnum.- n len)))
                     (,##subvect-move! vect 0 len result new-n)
                     (loop2 new-n (##cdr lst2)))
                   result))))))

       (define-prim (,##vect-append . lst)
         (,##append-vects lst))

       (define-prim (,vect-append . lst)
         (,##append-vects lst))

#;
       (define-prim (,##subvect-move! src-vect src-start src-end dst-vect dst-start)
         ;; Copy direction must be selected in case src-vect and
         ;; dst-vect are the same object.
         (if (##fixnum.< src-start dst-start)
           (let loop1 ((i (##fixnum.- src-end 1))
                       (j (##fixnum.-
                           (##fixnum.+ dst-start
                                       (##fixnum.- src-end src-start))
                           1)))
             (if (##fixnum.< i src-start)
               dst-vect
               (begin
                 (,##vect-set! dst-vect j (,##vect-ref src-vect i))
                 (loop1 (##fixnum.- i 1)
                        (##fixnum.- j 1)))))
           (let loop2 ((i src-start)
                       (j dst-start))
             (if (##fixnum.< i src-end)
               (begin
                 (,##vect-set! dst-vect j (,##vect-ref src-vect i))
                 (loop2 (##fixnum.+ i 1)
                        (##fixnum.+ j 1)))
               dst-vect))))

       (define-prim (,##subvect-fill! vect start end fill)
         (let loop ((i (##fixnum.- end 1)))
           (if (##fixnum.< i start)
             (##void)
             (begin
               (,##vect-set! vect i fill)
               (loop (##fixnum.- i 1))))))

       (define-prim (,##vect-shrink! vect k)))))

(define-prim-vector-procedures
  string
  #\nul
  macro-force-vars
  macro-check-char
  macro-check-char-list)

(define-prim-vector-procedures
  vector
  0
  macro-no-force
  macro-no-check
  macro-no-check)

(define-prim-vector-procedures
  s8vector
  0
  macro-force-vars
  macro-check-exact-signed-int8
  macro-check-exact-signed-int8-list)

(define-prim-vector-procedures
  u8vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list)

(define-prim-vector-procedures
  s16vector
  0
  macro-force-vars
  macro-check-exact-signed-int16
  macro-check-exact-signed-int16-list)

(define-prim-vector-procedures
  u16vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int16
  macro-check-exact-unsigned-int16-list)

(define-prim-vector-procedures
  s32vector
  0
  macro-force-vars
  macro-check-exact-signed-int32
  macro-check-exact-signed-int32-list)

(define-prim-vector-procedures
  u32vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int32
  macro-check-exact-unsigned-int32-list)

(define-prim-vector-procedures
  s64vector
  0
  macro-force-vars
  macro-check-exact-signed-int64
  macro-check-exact-signed-int64-list)

(define-prim-vector-procedures
  u64vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int64
  macro-check-exact-unsigned-int64-list)

(define-prim-vector-procedures
  f32vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list)

(define-prim-vector-procedures
  f64vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list)

;;;----------------------------------------------------------------------------

(c-declare #<<c-declare-end

#include "os.h"

c-declare-end
)

(define-prim ##subvector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FIELD(___arg1,___INT(___arg2)));
  void *dst = ___CAST(void*,&___FIELD(___arg4,___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * ___WS;

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##substring-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
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
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * ___CS;

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subs8vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_S8(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S8(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S8);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subu8vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_U8(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U8(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U8);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subs16vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_S16(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S16(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S16);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subu16vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_U16(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U16(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U16);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subs32vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_S32(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S32(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S32);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subu32vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_U32(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U32(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U32);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subs64vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_S64(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_S64(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___S64);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subu64vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,&___FETCH_U64(___BODY(___arg1),___INT(___arg2)));
  void *dst = ___CAST(void*,&___FETCH_U64(___BODY(___arg4),___INT(___arg5)));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___U64);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subf32vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,___CAST(___F32*,___BODY(___arg1))+___INT(___arg2));
  void *dst = ___CAST(void*,___CAST(___F32*,___BODY(___arg4))+___INT(___arg5));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___F32);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))

(define-prim ##subf64vector-move!
  (c-lambda (scheme-object  ;; src-vect
             scheme-object  ;; src-start
             scheme-object  ;; src-end
             scheme-object  ;; dst-vect
             scheme-object) ;; dst-start
            scheme-object
#<<end-of-code

  void *src = ___CAST(void*,___CAST(___F64*,___BODY(___arg1))+___INT(___arg2));
  void *dst = ___CAST(void*,___CAST(___F64*,___BODY(___arg4))+___INT(___arg5));
  long len = ___INT(___FIXSUB(___arg3,___arg2)) * sizeof (___F64);

  memmove (dst, src, len);

  ___result = ___arg4;

end-of-code
))
;;;----------------------------------------------------------------------------

;; IEEE Scheme procedures:

(define-prim (##not obj)
  (if obj #f #t))

(define-prim (not obj)
  (macro-force-vars (obj)
    (##not obj)))

(define-prim (boolean? obj)
  (macro-force-vars (obj)
    (or (##eq? obj #t) (##eq? obj #f))))

;; eqv? is defined in "_num.scm"
;; eq? and equal? are defined in "_kernel.scm"

(define-fail-check-type pair-mutable 'mutable)
(define-fail-check-type subtyped-mutable 'mutable)
(define-fail-check-type pair 'pair)
(define-fail-check-type pair-list 'pair-list)
(define-fail-check-type list 'list)

(define-prim (##pair? obj))

(define-prim (##pair-mutable? obj))

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
          `(macro-check-pair ,var 1 (,name pair);;;;;;error message confusing?
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
      (macro-check-pair-mutable pair 1 (set-car! pair val)
        (begin
          (##set-car! pair val)
          (##void))))))

(define-prim (##set-cdr! pair val))

(define-prim (set-cdr! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-cdr! pair val)
      (macro-check-pair-mutable pair 1 (set-cdr! pair val)
        (begin
          (##set-cdr! pair val)
          (##void))))))

(define-prim (##null? obj)
  (##eq? obj '()))

(define-prim (null? obj)
  (macro-force-vars (obj)
    (##null? obj)))

(define-prim (list? lst)
  ;; This procedure may get into an infinite loop if another thread
  ;; mutates "lst" (if lst1 and lst2 each point to disconnected cycles).
  (let loop ((lst1 lst) (lst2 lst))
    (macro-force-vars (lst1)
      (if (##not (##pair? lst1))
        (##null? lst1)
        (let ((lst1 (##cdr lst1)))
          (macro-force-vars (lst1 lst2)
            (cond ((##eq? lst1 lst2)
                   #f)
                  ((##not (##pair? lst2))
                   ;; this case is possible if other threads mutate the list
                   (##null? lst2))
                  ((##pair? lst1)
                   (loop (##cdr lst1) (##cdr lst2)))
                  (else
                   (##null? lst1)))))))))

(define-prim (##list . lst)
  lst)

(define-prim (list . lst)
  lst)

(define-prim (##length lst)
  (let loop ((x lst) (n 0))
    (if (##pair? x)
      (loop (##cdr x) (##fixnum.+ n 1))
      n)))

(define-prim (length lst)
  (let loop ((x lst) (n 0))
    (macro-force-vars (x)
      (if (##pair? x)
        (loop (##cdr x) (##fixnum.+ n 1))
        (macro-check-list x 1 (length lst)
          n)))))

(define-prim (##append lst1 lst2)
  (if (##pair? lst1)
    (##cons (##car lst1) (##append (##cdr lst1) lst2))
    lst2))

(define-prim (append
              #!optional
              (lst1 (macro-absent-obj))
              (lst2 (macro-absent-obj))
              #!rest
              others)

  (define (append-multiple head tail arg-num)
    (if (##null? tail)
      head
      (macro-force-vars (head)
        (if (##null? head)
          (append-multiple (##car tail) (##cdr tail) (##fixnum.+ arg-num 1))
          (list-expected-check
           (append-multiple-non-null head
                                     tail
                                     arg-num
                                     (##fixnum.+ arg-num 1)))))))

  (define (append-multiple-non-null x lsts arg-num1 arg-num2)
    ;; x!=(), returns fixnum on error
    (let ((head (##car lsts))
          (tail (##cdr lsts)))
      (if (##null? tail)
        (append-2-non-null x head arg-num1)
        (macro-force-vars (head)
          (if (##null? head)
            (append-multiple-non-null x
                                      tail
                                      arg-num1
                                      (##fixnum.+ arg-num2 1))
            (let ((result
                   (append-multiple-non-null head
                                             tail
                                             arg-num2
                                             (##fixnum.+ arg-num2 1))))
              (macro-if-checks
                (if (##fixnum? result)
                  result
                  (append-2-non-null x result arg-num1))
                (append-2-non-null x result arg-num1))))))))

  (define (append-2-non-null x y arg-num)
    ;; x!=(), returns fixnum on error
    (if (##pair? x)
      (let ((head (##car x))
            (tail (##cdr x)))
        (macro-force-vars (tail)
          (if (##null? tail)
            (##cons head y)
            (let ((result (append-2-non-null tail y arg-num)))
              (macro-if-checks
                (if (##fixnum? result)
                  result
                  (##cons head result))
                (##cons head result))))))
      (macro-if-checks
        arg-num ;; error: list expected
        y)))

  (define (list-expected-check result)
    (macro-if-checks
      (if (##fixnum? result)
        (macro-fail-check-list result (append lst1 lst2 . others))
        result)
      result))

  (cond ((##eq? lst2 (macro-absent-obj))
         (if (##eq? lst1 (macro-absent-obj))
           '()
           lst1))
        ((##null? others)
         (macro-force-vars (lst1)
           (if (##null? lst1)
             lst2
             (list-expected-check (append-2-non-null lst1 lst2 1)))))
        (else
         (append-multiple lst1 (##cons lst2 others) 1))))

(define-prim (##reverse lst)
  (let loop ((x lst) (result '()))
    (if (##pair? x)
      (loop (##cdr x) (##cons (##car x) result))
      result)))

(define-prim (reverse lst)
  (let loop ((x lst) (result '()))
    (macro-force-vars (x)
      (if (##pair? x)
        (loop (##cdr x) (##cons (##car x) result))
        (macro-check-list x 1 (reverse lst)
          result)))))

(define-prim (list-ref lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-ref lst k)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-ref lst k);;;;;;;error message confusing?
            (if (##fixnum.< 0 i)
              (loop (##cdr x) (##fixnum.- i 1))
              (##car x))))))))

(define-prim (##memq obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (if (##eq? obj (##car x))
        x
        (loop (##cdr x)))
      #f)))

(define-prim (memq obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
          (let ((y (##car x)))
            (macro-force-vars (y)
              (if (##eq? obj y)
                x
                (loop (##cdr x)))))
          (macro-check-list x 2 (memq obj lst)
            #f))))))

(define-prim (memv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
          (let ((y (##car x)))
            (macro-force-vars (y)
              (if (let ()
                    (##declare (generic)) ;; avoid fixnum specific ##eqv?
                    (##eqv? obj y))
                x
                (loop (##cdr x)))))
          (macro-check-list x 2 (memv obj lst)
            #f))))))

(define-prim (##member obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (if (##equal? obj (##car x))
        x
        (loop (##cdr x)))
      #f)))

(define-prim (member obj lst)
  (let loop ((x lst))
    (macro-force-vars (x)
      (if (##pair? x)
        (let ((y (##car x)))
          (if (##equal? obj y)
            x
            (loop (##cdr x))))
        (macro-check-list x 2 (member obj lst)
          #f)))))

(define-prim (##assq-cdr obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (let ((couple (##car x)))
        (if (##eq? obj (##cdr couple))
          couple
          (loop (##cdr x))))
        #f)))

(define-prim (##assq obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (let ((couple (##car x)))
        (if (##eq? obj (##car couple))
          couple
          (loop (##cdr x))))
        #f)))

(define-prim (assq obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
          (let ((couple (##car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list couple 2 (assq obj lst)
                (let ((y (##car couple)))
                  (macro-force-vars (y)
                    (if (##eq? obj y)
                      couple
                      (loop (##cdr x))))))))
          (macro-check-list x 2 (assq obj lst)
            #f))))))

(define-prim (assv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
          (let ((couple (##car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list couple 2 (assv obj lst)
                (let ((y (##car couple)))
                  (macro-force-vars (y)
                    (if (let ()
                          (##declare (generic)) ;; avoid fixnum specific ##eqv?
                          (##eqv? obj y))
                      couple
                      (loop (##cdr x))))))))
          (macro-check-list x 2 (assv obj lst)
            #f))))))

(define-prim (##assoc obj lst)
  (let loop ((x lst))
    (if (##pair? x)
      (let ((couple (##car x)))
        (if (##equal? obj (##car couple))
          couple
          (loop (##cdr x))))
      #f)))

(define-prim (assoc obj lst)
  (let loop ((x lst))
    (macro-force-vars (x)
      (if (##pair? x)
        (let ((couple (##car x)))
          (macro-force-vars (couple)
            (macro-check-pair-list couple 2 (assoc obj lst)
              (let ((y (##car couple)))
                (if (##equal? obj y)
                  couple
                  (loop (##cdr x)))))))
        (macro-check-list x 2 (assoc obj lst)
          #f)))))

(define-fail-check-type symbol 'symbol)

(define-prim (##symbol? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-symbol))))

(define-prim (symbol? obj)
  (macro-force-vars (obj)
    (##symbol? obj)))

(define-prim (##symbol->string sym)
  (let ((name (macro-symbol-name sym)))
    (if (##fixnum? name)
      (let ((str (##string-append "g" (##number->string name 10))))
        (##declare (not interrupts-enabled))
        (let ((name (macro-symbol-name sym)))
          ;; Double-check in case a different thread has also called
          ;; and completed the call to ##symbol->string on this symbol.
          (if (##fixnum? name)
            (begin
              (macro-symbol-name-set! sym str)
              str)
            name)))
      name)))

(define-prim (symbol->string sym)
  (macro-force-vars (sym)
    (macro-check-symbol sym 1 (symbol->string sym)
      (##symbol->string sym))))

(define-prim (##string->symbol str)
  (##make-interned-symbol str))

(define-prim (string->symbol str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->symbol str)
      (##string->symbol str))))

(define-prim (##uninterned-symbol? obj)
  (and (##symbol? obj)
       (##not (macro-symbol-next obj))))

(define-prim (uninterned-symbol? obj)
  (macro-force-vars (obj)
    (##uninterned-symbol? obj)))

(define ##symbol-counter 0)

(define-prim (##make-uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
    (let ((n (##fixnum.+ ##symbol-counter 1)))
      ;; Note: it is unimportant if the increment of ##symbol-counter
      ;; is not atomic; it simply means a possible close repetition
      ;; of the same hash code
      (set! ##symbol-counter n)
      (macro-make-uninterned-symbol str (##partial-bit-reverse n)))
    (macro-make-uninterned-symbol str hash)))

(define-prim (make-uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (make-uninterned-symbol str hash)
      (if (##eq? hash (macro-absent-obj))
        (##make-uninterned-symbol str)
        (macro-check-fixnum-range-incl hash 2 0 536870911 (make-uninterned-symbol str hash)
          (##make-uninterned-symbol str hash))))))

;; Number related procedures are in "_num.scm"

(define-fail-check-type char 'char)
(define-fail-check-type char-list 'char-list)

(define-prim (##char? obj))

(define-prim (char? obj)
  (macro-force-vars (obj)
    (##char? obj)))

(define-prim-nary-bool (##char=? x y)
  #t
  #t
  (##char=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char=? x y)
  #t
  #t
  (##char=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<? x y)
  #t
  #t
  (##char<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<? x y)
  #t
  #t
  (##char<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>? x y)
  #t
  #t
  (##char<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>? x y)
  #t
  #t
  (##char<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-force-vars
  macro-check-char)

(##define-macro (case-independent-char=? x y)
  `(##char=? (##char-downcase ,x) (##char-downcase ,y)))

(##define-macro (case-independent-char<? x y)
  `(##char<? (##char-downcase ,x) (##char-downcase ,y)))

(define-prim-nary-bool (##char-ci=? x y)
  #t
  #t
  (case-independent-char=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci=? x y)
  #t
  #t
  (case-independent-char=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<? x y)
  #t
  #t
  (case-independent-char<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<? x y)
  #t
  #t
  (case-independent-char<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>? x y)
  #t
  #t
  (case-independent-char<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>? x y)
  #t
  #t
  (case-independent-char<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<=? x y)
  #t
  #t
  (##not (case-independent-char<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<=? x y)
  #t
  #t
  (##not (case-independent-char<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>=? x y)
  #t
  #t
  (##not (case-independent-char<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>=? x y)
  #t
  #t
  (##not (case-independent-char<? x y))
  macro-force-vars
  macro-check-char)

(define-prim (##char-alphabetic? c))

(define-prim (char-alphabetic? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-alphabetic? c)
      (##char-alphabetic? c))))

(define-prim (##char-numeric? c))

(define-prim (char-numeric? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-numeric? c)
      (##char-numeric? c))))

(define-prim (##char-whitespace? c))

(define-prim (char-whitespace? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-whitespace? c)
      (##char-whitespace? c))))

(define-prim (##char-upper-case? c))

(define-prim (char-upper-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upper-case? c)
      (##char-upper-case? c))))

(define-prim (##char-lower-case? c))

(define-prim (char-lower-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-lower-case? c)
      (##char-lower-case? c))))

(define-prim (char->integer c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char->integer c)
      (##fixnum.<-char c))))

(define-prim (integer->char n)
  (macro-force-vars (n)
    (macro-check-fixnum-range-incl n 1 0 ##max-char (integer->char n)
      (if (or (##fixnum.< n #xd800)
              (##fixnum.< #xdfff n))
        (##fixnum.->char n)
        (##raise-range-exception 1 integer->char n)))))

(define-prim (##char-upcase c))

(define-prim (char-upcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upcase c)
      (##char-upcase c))))

(define-prim (##char-downcase c))

(define-prim (char-downcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-downcase c)
      (##char-downcase c))))

(define-prim (##string=? str1 str2)
  (or (##eq? str1 str2)
      (let ((len1 (##string-length str1)))
        (if (##eq? len1 (##string-length str2))
          (let loop ((i (##fixnum.- len1 1)))
            (cond ((##fixnum.< i 0)
                   #t)
                  ((##char=? (##string-ref str1 i) (##string-ref str2 i))
                   (loop (##fixnum.- i 1)))
                  (else
                   #f)))
          #f))))

(define-prim-nary-bool (string=? str1 str2)
  #t
  #t
  (##string=? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string<? str1 str2)
  (and (##not (##eq? str1 str2))
       (let ((len1 (##string-length str1))
             (len2 (##string-length str2)))
         (let ((n (##fixnum.min len1 len2)))
           (let loop ((i 0))
             (if (##fixnum.< i n)
               (let ((c1 (##string-ref str1 i))
                     (c2 (##string-ref str2 i)))
                 (if (##char=? c1 c2)
                   (loop (##fixnum.+ i 1))
                   (##char<? c1 c2)))
               (##fixnum.< n len2)))))))

(define-prim-nary-bool (string<? str1 str2)
  #t
  #t
  (##string<? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string>? str1 str2)
  #t
  #t
  (##string<? str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string<=? str1 str2)
  #t
  #t
  (##not (##string<? str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string>=? str1 str2)
  #t
  #t
  (##not (##string<? str1 str2))
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci=? str1 str2)
  (or (##eq? str1 str2)
      (let ((len1 (##string-length str1)))
        (if (##eq? len1 (##string-length str2))
          (let loop ((i (##fixnum.- len1 1)))
            (cond ((##fixnum.< i 0)
                   #t)
                  ((##char=? (##char-downcase (##string-ref str1 i))
                             (##char-downcase (##string-ref str2 i)))
                   (loop (##fixnum.- i 1)))
                  (else
                   #f)))
          #f))))

(define-prim-nary-bool (string-ci=? str1 str2)
  #t
  #t
  (##string-ci=? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci<? str1 str2)
  (and (##not (##eq? str1 str2))
       (let ((len1 (##string-length str1))
             (len2 (##string-length str2)))
         (let ((n (##fixnum.min len1 len2)))
           (let loop ((i 0))
             (if (##fixnum.< i n)
               (let ((c1 (##char-downcase (##string-ref str1 i)))
                     (c2 (##char-downcase (##string-ref str2 i))))
                 (if (##char=? c1 c2)
                   (loop (##fixnum.+ i 1))
                   (##char<? c1 c2)))
               (##fixnum.< n len2)))))))

(define-prim-nary-bool (string-ci<? str1 str2)
  #t
  #t
  (##string-ci<? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci>? str1 str2)
  #t
  #t
  (##string-ci<? str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<? str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<? str1 str2))
  macro-force-vars
  macro-check-string)

(define-prim (##copy-string-list lst)

  (define (copy lst i)
    (macro-force-vars (lst)
      (cond ((##pair? lst)
             (let ((str (##car lst)))
               (macro-force-vars (str)
                 (if (##string? str)
                   (let ((x (copy (##cdr lst) (##fixnum.+ i 1))))
                     (if (##fixnum? x)
                       x
                       (##cons str x)))
                   i))))
            ((##null? lst)
             '())
            (else
             0))))

  (copy lst 1))

(define-fail-check-type procedure 'procedure)

(define-prim (##procedure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-procedure))))

(define-prim (procedure? obj)
  (macro-force-vars (obj)
    (##procedure? obj)))

;; apply is in "_kernel.scm"

(define-prim (##map proc lst)
  (let loop ((x lst))
    (if (##pair? x)
      (##cons (proc (##car x)) (loop (##cdr x)))
      '())))

(define-prim (map proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (map proc x . y)
      (let ()

        (define (proper-list-length lst)
          (let loop ((lst lst) (n 0))
            (macro-force-vars (lst)
              (cond ((##pair? lst)
                     (loop (##cdr lst) (##fixnum.+ n 1)))
                    ((##null? lst)
                     n)
                    (else
                     #f)))))

        (define (map-1 lst1)
          (macro-force-vars (lst1)
            (if (##pair? lst1)
              (let ((result (proc (##car lst1))))
                (##cons result (map-1 (##cdr lst1))))
              '())))

        (define (cars lsts)
          (if (##pair? lsts)
            (let ((lst1 (##car lsts)))
              (macro-force-vars (lst1)
                (let ((head (##car lst1)))
                  (let ((tail (cars (##cdr lsts))))
                    (##cons head tail)))))
            '()))

        (define (cdrs lsts)
          (if (##pair? lsts)
            (let ((lst1 (##car lsts)))
              (macro-force-vars (lst1)
                (let ((head (##cdr lst1)))
                  (if (##pair? head)
                    (let ((tail (cdrs (##cdr lsts))))
                      (and tail
                           (##cons head tail)))
                    #f))))
            '()))

        (define (map-n lsts)
          (if lsts
            (let ((result (##apply proc (cars lsts))))
              (##cons result (map-n (cdrs lsts))))
            '()))

        (cond ((##null? y)
               (macro-if-checks
                 (let ((len1 (proper-list-length x)))
                   (if len1
                     (map-1 x)
                     (macro-fail-check-list 2 (map proc x . y))))
                 (map-1 x)))
              (else
               (macro-if-checks
                 (let ((len1 (proper-list-length x)))
                   (if len1
                     (let loop ((lsts y) (arg-num 3))
                       (if (##null? lsts)
                         (if (##null? x)
                           '()
                           (map-n (##cons x y)))
                         (let ((len2 (proper-list-length (##car lsts))))
                           (if (##eq? len1 len2)
                             (loop (##cdr lsts) (##fixnum.+ arg-num 1))
                             (if len2
                               (##raise-improper-length-list-exception
                                arg-num
                                '()
                                map
                                proc
                                x
                                y)
                               (macro-fail-check-list
                                arg-num
                                (map proc x . y)))))))
                     (macro-fail-check-list 2 (map proc x . y))))
                 (if (##null? x)
                   '()
                   (map-n (##cons x y))))))))))

(define-prim (##for-each proc lst)
  (let loop ((x lst))
    (if (##pair? x)
      (begin
        (proc (##car x))
        (loop (##cdr x)))
      (##void))))

(define-prim (for-each proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (for-each proc x . y)
      (let ()

        (define (proper-list-length lst)
          (let loop ((lst lst) (n 0))
            (macro-force-vars (lst)
              (cond ((##pair? lst)
                     (loop (##cdr lst) (##fixnum.+ n 1)))
                    ((##null? lst)
                     n)
                    (else
                     #f)))))

        (define (for-each-1 lst1)
          (macro-force-vars (lst1)
            (if (##pair? lst1)
              (let ((result (proc (##car lst1))))
                (for-each-1 (##cdr lst1)))
              (##void))))

        (define (cars lsts)
          (if (##pair? lsts)
            (let ((lst1 (##car lsts)))
              (macro-force-vars (lst1)
                (let ((head (##car lst1)))
                  (let ((tail (cars (##cdr lsts))))
                    (##cons head tail)))))
            '()))

        (define (cdrs lsts)
          (if (##pair? lsts)
            (let ((lst1 (##car lsts)))
              (macro-force-vars (lst1)
                (let ((head (##cdr lst1)))
                  (if (##pair? head)
                    (let ((tail (cdrs (##cdr lsts))))
                      (and tail
                           (##cons head tail)))
                    #f))))
            '()))

        (define (for-each-n lsts)
          (let ((tails (cdrs lsts)))
            (if tails
              (begin
                (##apply proc (cars lsts))
                (for-each-n tails))
              (##apply proc (cars lsts)))))

        (cond ((##null? y)
               (macro-if-checks
                 (let ((len1 (proper-list-length x)))
                   (if len1
                     (for-each-1 x)
                     (macro-fail-check-list 2 (for-each proc x . y))))
                 (for-each-1 x)))
              (else
               (macro-if-checks
                 (let ((len1 (proper-list-length x)))
                   (if len1
                     (let loop ((lsts y) (arg-num 3))
                       (if (##null? lsts)
                         (if (##pair? x)
                           (for-each-n (##cons x y))
                           (##void))
                         (let ((len2 (proper-list-length (##car lsts))))
                           (if (##eq? len1 len2)
                             (loop (##cdr lsts) (##fixnum.+ arg-num 1))
                             (if len2
                               (##raise-improper-length-list-exception
                                arg-num
                                '()
                                for-each
                                proc
                                x
                                y)
                               (macro-fail-check-list
                                arg-num
                                (for-each proc x . y)))))))
                     (macro-fail-check-list 2 (for-each proc x . y))))
                 (if (##pair? x)
                   (for-each-n (##cons x y))
                   (##void)))))))))

;; call-with-current-continuation is in "_kernel.scm"

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

;; R4RS Scheme procedures:

(define-prim (list-tail lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-tail lst k)
      (let loop ((x lst) (i k))
        (if (##fixnum.< 0 i)
          (macro-force-vars (x)
            (macro-check-pair x 1 (list-tail lst k);;;;;;;;;;error message confusing?
              (loop (##cdr x) (##fixnum.- i 1))))
          x)))))

(define-prim (##make-promise thunk))

(define-prim (##force obj))

(define-prim (force obj)
  (##force obj))

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

;; R5RS Scheme procedures:

;; values, call-with-values and dynamic-wind are in "_thread.scm"

;;(eval expr env)
;;(scheme-report-environment version)
;;(null-environment version)
;;(interaction-environment)

;;;----------------------------------------------------------------------------

;; Multilisp procedures:

(define-prim (touch obj)
  (##force obj))

;;;----------------------------------------------------------------------------

;; DSSSL procedures:

(define-fail-check-type keyword 'keyword)

(define-prim (##keyword? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-keyword))))

(define-prim (keyword? obj)
  (##keyword? obj))

(define-prim (##keyword->string key)
  (let ((name (macro-keyword-name key)))
    (if (##fixnum? name)
      (let ((str (##string-append "g" (##number->string name 10))))
        (##declare (not interrupts-enabled))
        (let ((name (macro-keyword-name key)))
          ;; Double-check in case a different thread has also called
          ;; and completed the call to ##keyword->string on this keyword.
          (if (##fixnum? name)
            (begin
              (macro-keyword-name-set! key str)
              str)
            name)))
      name)))

(define-prim (keyword->string key)
  (macro-force-vars (key)
    (macro-check-keyword key 1 (keyword->string key)
      (##keyword->string key))))

(define-prim (##string->keyword str)
  (##make-interned-keyword str))

(define-prim (string->keyword str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->keyword str)
      (##string->keyword str))))

(define-prim (##uninterned-keyword? obj)
  (and (##keyword? obj)
       (##not (macro-keyword-next obj))))

(define-prim (uninterned-keyword? obj)
  (macro-force-vars (obj)
    (##uninterned-keyword? obj)))

(define ##keyword-counter 0)

(define-prim (##make-uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
    (let ((n (##fixnum.+ ##keyword-counter 1)))
      ;; Note: it is unimportant if the increment of ##keyword-counter
      ;; is not atomic; it simply means a possible close repetition
      ;; of the same hash code
      (set! ##keyword-counter n)
      (macro-make-uninterned-keyword str (##partial-bit-reverse n)))
    (macro-make-uninterned-keyword str hash)))

(define-prim (make-uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (make-uninterned-keyword str hash)
      (if (##eq? hash (macro-absent-obj))
        (##make-uninterned-keyword str)
        (macro-check-fixnum-range-incl hash 2 0 536870911 (make-uninterned-keyword str hash)
          (##make-uninterned-keyword str hash))))))

(define-prim (##partial-bit-reverse i)

  (##define-macro (bit n)
    `(##fixnum.arithmetic-shift-left
      (##fixnum.bitwise-and i ,(expt 2 n)) ,(- 28 (* 2 n))))

  (##fixnum.+
   (bit 0)
   (##fixnum.+
    (bit 1)
    (##fixnum.+
     (bit 2)
     (##fixnum.+
      (bit 3)
      (##fixnum.+
       (bit 4)
       (##fixnum.+
        (bit 5)
        (##fixnum.+
         (bit 6)
         (##fixnum.+
          (bit 7)
          (##fixnum.+
           (bit 8)
           (##fixnum.+
            (bit 9)
            (##fixnum.+
             (bit 10)
             (##fixnum.+
              (bit 11)
              (##fixnum.+
               (bit 12)
               (##fixnum.+
                (bit 13)
                (bit 14))))))))))))))))

;;;============================================================================
