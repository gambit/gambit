;;;============================================================================

;;; File: "_std#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception length-mismatch-exception
  id: C5CC1F94-644C-46FD-8655-674A3C3E517A
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
  (arg-id    unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception invalid-utf8-encoding-exception
  id: C31D88DD-26F4-4EC3-A30D-BE96C0120CB0
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
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

(define-check-type char-vector 'char-vector
  ##char?)

(define-check-type procedure 'procedure
  ##procedure?)

(define-check-type keyword 'keyword
  ##keyword?)

(define-check-type boolean 'boolean
  ##boolean?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(##define-macro (macro-fail-check-list arg-id form)

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
        `(,name ,arg-id '() ,(car form) ,@pk ,r)
        `(,name
          ,arg-id
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
                  macro-test-elem
                  ##fail-check-elem
                  define-map-and-for-each
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
    (define ##vect-copy!     (sym "##" name '-copy!))
    (define ##vect-delete    (sym "##" name '-delete))
    (define ##vect-insert    (sym "##" name '-insert))
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
    (define vect->string     (sym name '->string))
    (define string->vect     (sym 'string-> name))
    (define vect-copy        (sym name '-copy))
    (define vect-copy!       (sym name '-copy!))
    (define vect-fill!       (sym name '-fill!))
    (define subvect          (sym 'sub name))
    (define append-vects     (sym 'append- name 's))
    (define vect-append      (sym name '-append))
    (define subvect-move!    (sym 'sub name '-move!))
    (define subvect-fill!    (sym 'sub name '-fill!))
    (define vect-shrink!     (sym name '-shrink!))
    (define vect-map         (sym name '-map))
    (define vect-for-each    (sym name '-for-each))

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

       (define-prim (,##vect->list
                     vect
                     #!optional
                     (start 0)
                     (end (,##vect-length vect)))
         (let loop ((lst '()) (i (##fx- end 1)))
           (if (##fx< i start)
               lst
               (loop (##cons (,##vect-ref vect i) lst) (##fx- i 1)))))

       (define-prim (,vect->list
                     vect
                     #!optional
                     (start (macro-absent-obj))
                     (end (macro-absent-obj)))
         (macro-force-vars (vect start end)
           (,macro-check-vect vect 1 (,vect->list vect start end)
             (if (##eq? start (macro-absent-obj))
                 (,##vect->list vect)
                 (macro-check-index-range-incl
                   start
                   2
                   0
                   (,##vect-length vect)
                   (,vect->list vect start end)
                   (if (##eq? end (macro-absent-obj))
                       (,##vect->list vect start)
                       (macro-check-index-range-incl
                         end
                         3
                         start
                         (,##vect-length vect)
                         (,vect->list vect start end)
                         (,##vect->list vect start end))))))))

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

       ,@(if (eq? name 'vector)
             `(
               (define-prim (,vect->string
                             vect
                             #!optional
                             (start (macro-absent-obj))
                             (end (macro-absent-obj)))

                 (define (convert s e)
                   (let* ((len (##fx- e s))
                          (result (##make-string len)))
                     (let loop ((i (##fx- len 1)))
                       (if (##fx< i 0)
                           result
                           (let ((elem (,##vect-ref vect (##fx+ i s))))
                             (macro-check-char-vector
                               elem
                               1
                               (,vect->string vect start end)
                               (begin
                                 (##string-set! result i elem)
                                 (loop (##fx- i 1)))))))))

                 (macro-force-vars (vect start end)
                   (,macro-check-vect
                     vect
                     1
                     (,vect->string vect start end)
                     (if (##eq? start (macro-absent-obj))
                         (convert 0 (,##vect-length vect))
                         (macro-check-index-range-incl
                           start
                           2
                           0
                           (,##vect-length vect)
                           (,vect->string vect start end)
                           (if (##eq? end (macro-absent-obj))
                               (convert start (,##vect-length vect))
                               (macro-check-index-range-incl
                                 end
                                 3
                                 start
                                 (,##vect-length vect)
                                 (,vect->string vect start end)
                                 (convert start end))))))))

               (define-prim (,string->vect
                             str
                             #!optional
                             (start (macro-absent-obj))
                             (end (macro-absent-obj)))

                 (define (convert s e)
                   (let* ((len (##fx- e s))
                          (result (,##make-vect len)))
                     (let loop ((i (##fx- len 1)))
                       (if (##fx< i 0)
                           result
                           (let ((elem (##string-ref str (##fx+ i s))))
                             (,##vect-set! result i elem)
                             (loop (##fx- i 1)))))))

                 (macro-force-vars (str start end)
                   (macro-check-string
                     str
                     1
                     (,string->vect str start end)
                     (if (##eq? start (macro-absent-obj))
                         (convert 0 (##string-length str))
                         (macro-check-index-range-incl
                           start
                           2
                           0
                           (##string-length str)
                           (,string->vect str start end)
                           (if (##eq? end (macro-absent-obj))
                               (convert start (##string-length str))
                               (macro-check-index-range-incl
                                 end
                                 3
                                 start
                                 (##string-length str)
                                 (,string->vect str start end)
                                 (convert start end))))))))
               ))

       (define-prim (,##vect-fill!
                     vect
                     fill
                     #!optional
                     (start 0)
                     (end (,##vect-length vect)))
         (,##subvect-fill! vect start end fill))

       (define-prim (,vect-fill!
                     vect
                     fill
                     #!optional
                     (start (macro-absent-obj))
                     (end (macro-absent-obj)))
         (macro-force-vars (vect start end)
           (,macro-force-elem (fill)
             (,macro-check-vect vect 1 (,vect-fill! vect fill start end)
               (macro-check-mutable vect 1 (,vect-fill! vect fill start end)
                 (,macro-check-elem fill 2 (,vect-fill! vect fill start end)
                   (if (##eq? start (macro-absent-obj))
                       (,##vect-fill! vect fill)
                       (macro-check-index-range-incl
                         start
                         3
                         0
                         (,##vect-length vect)
                         (,vect-fill! vect fill start end)
                         (if (##eq? end (macro-absent-obj))
                             (,##vect-fill! vect fill start)
                             (macro-check-index-range-incl
                               end
                               4
                               start
                               (,##vect-length vect)
                               (,vect-fill! vect fill start end)
                               (,##vect-fill! vect fill start end)))))))))))

       (define-prim (,##vect-copy
                     vect
                     #!optional
                     (start 0)
                     (end (,##vect-length vect)))
         (let ((len (##fx- end start)))
           (,##subvect-move! vect start end (,##make-vect len) 0)))

       (define-prim (,vect-copy
                     vect
                     #!optional
                     (start (macro-absent-obj))
                     (end (macro-absent-obj)))
         (macro-force-vars (vect start end)
           (,macro-check-vect vect 1 (,vect-copy vect start end)
             (if (##eq? start (macro-absent-obj))
                 (,##vect-copy vect)
                 (macro-check-index-range-incl
                   start
                   2
                   0
                   (,##vect-length vect)
                   (,vect-copy vect start end)
                   (if (##eq? end (macro-absent-obj))
                       (,##vect-copy vect start)
                       (macro-check-index-range-incl
                         end
                         3
                         start
                         (,##vect-length vect)
                         (,vect-copy vect start end)
                         (,##vect-copy vect start end))))))))

       (define-prim (,##vect-copy!
                     dst-vect
                     dst-start
                     src-vect
                     #!optional
                     (src-start 0)
                     (src-end (,##vect-length src-vect)))
         (,##subvect-move!
          src-vect
          src-start
          src-end
          dst-vect
          dst-start))

       (define-prim (,vect-copy!
                     dst-vect
                     dst-start
                     src-vect
                     #!optional
                     (src-start (macro-absent-obj))
                     (src-end (macro-absent-obj)))
         (macro-force-vars (dst-vect dst-start src-vect src-start src-end)
           (let ()

             (define (cont s e)
               (if (##fx> (##fx- e s)
                          (##fx- (,##vect-length dst-vect) dst-start))
                   (##raise-range-exception
                    2
                    ,vect-copy!
                    dst-vect
                    dst-start
                    src-vect
                    src-start
                    src-end)
                   (begin
                     (,##subvect-move!
                      src-vect
                      s
                      e
                      dst-vect
                      dst-start)
                     (##void))))

             (,macro-check-vect
               dst-vect
               1
               (,vect-copy! dst-vect dst-start src-vect src-start src-end)
               (macro-check-mutable
                 dst-vect
                 1
                 (,vect-copy! dst-vect dst-start src-vect src-start src-end)
                 (macro-check-index-range-incl
                   dst-start
                   2
                   0
                   (,##vect-length dst-vect)
                   (,vect-copy! dst-vect dst-start src-vect src-start src-end)
                   (,macro-check-vect
                     src-vect
                     3
                     (,vect-copy! dst-vect dst-start src-vect src-start src-end)
                     (if (##eq? src-start (macro-absent-obj))
                         (cont 0 (,##vect-length src-vect))
                         (macro-check-index-range-incl
                           src-start
                           4
                           0
                           (,##vect-length src-vect)
                           (,vect-copy! dst-vect dst-start src-vect src-start src-end)
                           (if (##eq? src-end (macro-absent-obj))
                               (cont src-start (,##vect-length src-vect))
                               (macro-check-index-range-incl
                                 src-end
                                 5
                                 src-start
                                 (,##vect-length src-vect)
                                 (,vect-copy! dst-vect dst-start src-vect src-start src-end)
                                 (cont src-start src-end))))))))))))

       (define-prim (,##vect-delete vect i)
         (let* ((len (,##vect-length vect))
                (result (,##make-vect (##fx- len 1))))
           (,##subvect-move! vect 0 i result 0)
           (,##subvect-move! vect (##fx+ i 1) len result i)
           result))

       (define-prim (,##vect-insert vect i x)
         (let* ((len (,##vect-length vect))
                (result (,##make-vect (##fx+ len 1))))
           (,##subvect-move! vect 0 i result 0)
           (,##subvect-move! vect i len result (##fx+ i 1))
           (,##vect-set! result i x)
           result))

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

       (define-prim (,##append-vects
                     lst
                     #!optional
                     (sep (macro-absent-obj)))
         (let loop1 ((n 0)
                     (probe lst)
                     (arg-num 1))
           (cond ((##pair? probe)
                  (let ((vect (##car probe)))
                    (macro-force-vars (vect)
                      (if (##not (,##vect? vect))
                          (if (##eq? sep (macro-deleted-obj))
                              (,##fail-check-vect arg-num '() ,vect-append lst)
                              (,##fail-check-vect-list 1 ,append-vects lst sep))
                          (loop1 (##fx+ n (,##vect-length vect))
                                 (##cdr probe)
                                 (##fx+ arg-num 1))))))
                 ((##null? probe)
                  (if (##not (or (##eq? sep (macro-deleted-obj)) ;; for vect-append
                                 (##eq? sep (macro-absent-obj))
                                 (,##vect? sep)))
                      (,##fail-check-vect 2 '() ,append-vects lst sep)
                      (if (##not (##pair? lst))
                          (,##make-vect 0)
                          (let* ((n
                                  (if (,##vect? sep)
                                      (##fx+ n
                                             (##fx* (##fx- arg-num 2)
                                                    (,##vect-length sep)))
                                      n))
                                 (result
                                  (,##make-vect n)))
                            (let loop2 ((i 0)
                                        (probe lst))
                              (let* ((vect (##car probe))
                                     (len (,##vect-length vect)))
                                (,##subvect-move! vect 0 len result i)
                                (let* ((i+len (##fx+ i len))
                                       (rest (##cdr probe)))
                                  (if (##pair? rest)
                                      (if (,##vect? sep)
                                          (let ((len-sep (,##vect-length sep)))
                                            (,##subvect-move! sep 0 len-sep result i+len)
                                            (loop2 (##fx+ i+len len-sep)
                                                   rest))
                                          (loop2 i+len
                                                 rest))
                                      result))))))))
                 (else
                  (,##fail-check-vect-list 1 ,append-vects lst sep)))))

       (define-prim (,append-vects lst #!optional (sep (macro-absent-obj)))
         (,##append-vects lst sep))

       (define-prim (,##vect-append . lst)
         (,##append-vects lst (macro-deleted-obj)))

       (define-prim (,vect-append . lst)
         (,##append-vects lst (macro-deleted-obj)))

       (macro-case-target

        ((c C)
         (define-prim (,##subvect-move! src-vect src-start src-end dst-vect dst-start)
           (##c-code
            ,(string-append
#<<end-of-code
{
end-of-code
              (case ##subvect-move!
                ((##subvector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FIELD(___ARG1,___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FIELD(___ARG4,___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * ___WS;
end-of-code
)
                ((##substring-move!)
#<<end-of-code
  void *src =
        ___CAST(void*,
                ___CS_SELECT(&___FETCH_U8(___BODY(___ARG1),___INT(___ARG2)),
                             &___FETCH_U16(___BODY(___ARG1),___INT(___ARG2)),
                             &___FETCH_U32(___BODY(___ARG1),___INT(___ARG2))));
  void *dst =
        ___CAST(void*,
                ___CS_SELECT(&___FETCH_U8(___BODY(___ARG4),___INT(___ARG5)),
                             &___FETCH_U16(___BODY(___ARG4),___INT(___ARG5)),
                             &___FETCH_U32(___BODY(___ARG4),___INT(___ARG5))));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * ___CS;
end-of-code
)
                ((##subs8vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S8(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_S8(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___S8);
end-of-code
)
                ((##subu8vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U8(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_U8(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___U8);
end-of-code
)
                ((##subs16vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S16(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_S16(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___S16);
end-of-code
)
                ((##subu16vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U16(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_U16(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___U16);
end-of-code
)
                ((##subs32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S32(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_S32(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___S32);
end-of-code
)
                ((##subu32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U32(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_U32(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___U32);
end-of-code
)
                ((##subs64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_S64(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_S64(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___S64);
end-of-code
)
                ((##subu64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,&___FETCH_U64(___BODY(___ARG1),___INT(___ARG2)));
  void *dst = ___CAST(void*,&___FETCH_U64(___BODY(___ARG4),___INT(___ARG5)));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___U64);
end-of-code
)
                ((##subf32vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,___CAST(___F32*,___BODY(___ARG1))+___INT(___ARG2));
  void *dst = ___CAST(void*,___CAST(___F32*,___BODY(___ARG4))+___INT(___ARG5));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___F32);
end-of-code
)
                ((##subf64vector-move!)
#<<end-of-code
  void *src = ___CAST(void*,___CAST(___F64*,___BODY(___ARG1))+___INT(___ARG2));
  void *dst = ___CAST(void*,___CAST(___F64*,___BODY(___ARG4))+___INT(___ARG5));
  ___SIZE_TS len = ___INT(___FIXSUB(___ARG3,___ARG2)) * sizeof (___F64);
end-of-code
))

#<<end-of-code
  memmove (dst, src, len);
  ___RESULT = ___ARG4;
}
end-of-code
)

            src-vect
            src-start
            src-end
            dst-vect
            dst-start)))

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

       ,@(if define-map-and-for-each

             `(
               (define-prim (,vect-map proc x . y)
                 (macro-force-vars (proc x)
                   (macro-check-procedure proc 1 (,vect-map proc x . y)
                     (,macro-check-vect x 2 (,vect-map proc x . y)
                       (let ()

                         (define (vect-map-1 x)

                           ,(if macro-test-elem

                                `(define (vect-map-1 i)
                                   (if (##fx< i (,##vect-length x))
                                       (let err ((result
                                                  (proc (,##vect-ref x i))))
                                         (,macro-force-elem (result)
                                           (if (,macro-test-elem result)
                                               (let ((vect
                                                      (vect-map-1
                                                       (##fx+ i 1))))
                                                 (,##vect-set! vect i result)
                                                 vect)
                                                (err (,##fail-check-elem
                                                      0
                                                      proc
                                                      (,##vect-ref x i))))))
                                       (,##make-vect i)))

                                `(define (vect-map-1 i)
                                   (if (##fx< i (,##vect-length x))
                                       (let ((result (proc (,##vect-ref x i))))
                                         (,macro-force-elem (result)
                                           (let ((vect
                                                  (vect-map-1
                                                   (##fx+ i 1))))
                                             (,##vect-set! vect i result)
                                             vect)))
                                       (,##make-vect i))))

                           (vect-map-1 0))

                         (define (vect-map-n len rev-x-y)

                           ,(if macro-test-elem

                                `(define (vect-map-n i)
                                   (if (##fx< i len)
                                       (let loop ((lst rev-x-y) (args '()))
                                         (if (##pair? lst)
                                             (loop (##cdr lst)
                                                   (##cons
                                                    (,##vect-ref (##car lst) i)
                                                    args))
                                             (let err ((result
                                                        (##apply proc args)))
                                               (,macro-force-elem (result)
                                                 (if (,macro-test-elem result)
                                                     (let ((vect
                                                            (vect-map-n
                                                             (##fx+ i 1))))
                                                       (,##vect-set! vect i result)
                                                       vect)
                                                     (err (,##fail-check-elem
                                                           0
                                                           proc
                                                           (,##vect-ref x i))))))))
                                       (,##make-vect i)))

                                `(define (vect-map-n i)
                                   (if (##fx< i len)
                                       (let loop ((lst rev-x-y) (args '()))
                                         (if (##pair? lst)
                                             (loop (##cdr lst)
                                                   (##cons
                                                    (,##vect-ref (##car lst) i)
                                                    args))
                                             (let ((result
                                                    (##apply proc args)))
                                               (,macro-force-elem (result)
                                                 (let ((vect
                                                        (vect-map-n
                                                         (##fx+ i 1))))
                                                   (,##vect-set! vect i result)
                                                   vect)))))
                                       (,##make-vect i))))

                           (vect-map-n 0))

                         (if (##null? y)
                             (vect-map-1 x)
                             (if ##allow-length-mismatch?

                                 (let ((len-x (,##vect-length x))
                                       (x-y (##cons x y)))
                                   (let loop ((lst y)
                                              (rev-x-y (##cons x '()))
                                              (min-len len-x)
                                              (arg-num 3))
                                     (if (##pair? lst)
                                         (let ((arg (##car lst)))
                                           (macro-force-vars (arg)
                                             (,macro-check-vect
                                               arg
                                               arg-num
                                               (,vect-map proc . x-y)
                                               (let ((len-arg (,##vect-length arg)))
                                                 (loop (##cdr lst)
                                                       (##cons arg rev-x-y)
                                                       (##fxmin min-len len-arg)
                                                       (##fx+ arg-num 1))))))
                                         (vect-map-n min-len rev-x-y))))

                                 (let ((len-x (,##vect-length x))
                                       (x-y (##cons x y)))
                                   (let loop ((lst y)
                                              (rev-x-y (##cons x '()))
                                              (min-len len-x)
                                              (max-len len-x)
                                              (max-arg 2)
                                              (arg-num 3))
                                     (if (##pair? lst)
                                         (let ((arg (##car lst)))
                                           (macro-force-vars (arg)
                                             (,macro-check-vect
                                               arg
                                               arg-num
                                               (,vect-map proc . x-y)
                                               (let ((len-arg (,##vect-length arg)))
                                                 (if (##fx> len-arg max-len)
                                                     (loop (##cdr lst)
                                                           (##cons arg rev-x-y)
                                                           len-arg
                                                           max-len
                                                           arg-num
                                                           (##fx+ arg-num 1))
                                                     (loop (##cdr lst)
                                                           (##cons arg rev-x-y)
                                                           (##fxmin min-len len-arg)
                                                           max-len
                                                           max-arg
                                                           (##fx+ arg-num 1)))))))
                                         (if (##fx= min-len max-len)
                                             (vect-map-n min-len rev-x-y)
                                             (##raise-length-mismatch-exception
                                              max-arg
                                              '()
                                              ,vect-map
                                              proc
                                              x-y))))))))))))

               (define-prim (,vect-for-each proc x . y)
                 (macro-force-vars (proc x)
                   (macro-check-procedure proc 1 (,vect-for-each proc x . y)
                     (,macro-check-vect x 2 (,vect-for-each proc x . y)
                       (let ()

                         (define (vect-for-each-1 x)

                           (define (vect-for-each-1 i)
                             (if (##fx< i (,##vect-length x))
                                 (begin
                                   (proc (,##vect-ref x i))
                                   (vect-for-each-1 (##fx+ i 1)))
                                 (##void)))

                           (vect-for-each-1 0))

                         (define (vect-for-each-n len rev-x-y)

                           (define (vect-for-each-n i)
                             (if (##fx< i len)
                                 (let loop ((lst rev-x-y) (args '()))
                                   (if (##pair? lst)
                                       (loop (##cdr lst)
                                             (##cons
                                              (,##vect-ref (##car lst) i)
                                              args))
                                       (begin
                                         (##apply proc args)
                                         (vect-for-each-n (##fx+ i 1)))))
                                 (##void)))

                           (vect-for-each-n 0))

                         (if (##null? y)
                             (vect-for-each-1 x)
                             (if ##allow-length-mismatch?

                                 (let ((len-x (,##vect-length x))
                                       (x-y (##cons x y)))
                                   (let loop ((lst y)
                                              (rev-x-y (##cons x '()))
                                              (min-len len-x)
                                              (arg-num 3))
                                     (if (##pair? lst)
                                         (let ((arg (##car lst)))
                                           (macro-force-vars (arg)
                                             (,macro-check-vect
                                               arg
                                               arg-num
                                               (,vect-for-each proc . x-y)
                                               (let ((len-arg
                                                      (,##vect-length arg)))
                                                 (loop (##cdr lst)
                                                       (##cons arg rev-x-y)
                                                       (##fxmin min-len len-arg)
                                                       (##fx+ arg-num 1))))))
                                         (vect-for-each-n min-len rev-x-y))))

                                 (let ((len-x (,##vect-length x))
                                       (x-y (##cons x y)))
                                   (let loop ((lst y)
                                              (rev-x-y (##cons x '()))
                                              (min-len len-x)
                                              (max-len len-x)
                                              (max-arg 2)
                                              (arg-num 3))
                                     (if (##pair? lst)
                                         (let ((arg (##car lst)))
                                           (macro-force-vars (arg)
                                             (,macro-check-vect
                                               arg
                                               arg-num
                                               (,vect-for-each proc . x-y)
                                               (let ((len-arg
                                                      (,##vect-length arg)))
                                                 (if (##fx> len-arg max-len)
                                                     (loop (##cdr lst)
                                                           (##cons arg rev-x-y)
                                                           len-arg
                                                           max-len
                                                           arg-num
                                                           (##fx+ arg-num 1))
                                                     (loop (##cdr lst)
                                                           (##cons arg rev-x-y)
                                                           (##fxmin min-len
                                                                    len-arg)
                                                           max-len
                                                           max-arg
                                                           (##fx+ arg-num 1)))))))
                                         (if (##fx= min-len max-len)
                                             (vect-for-each-n min-len rev-x-y)
                                             (##raise-length-mismatch-exception
                                              max-arg
                                              '()
                                              ,vect-for-each
                                              proc
                                              x-y))))))))))))
               )

             '())
       )))

;;;============================================================================
