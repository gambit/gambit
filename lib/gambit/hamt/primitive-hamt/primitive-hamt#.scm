;;;============================================================================

;;; File: "gambit/hamt/primitive-hamt/primitive-hamt#.scm"

;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Immutable Hash Array Mapped Tries (HAMT).

;;; A HAMT is a data structure that behaves as a dictionary that maps
;;; keys to values.  It is similar to an association list, but looking
;;; up a key is more efficient because it uses hashing on the keys to
;;; search the data structure.

;;; The HAMT operations are:
;;;
;;;  (make)              create an empty HAMT
;;;  (ref hamt key)      lookup the key and return #f or the pair (key . value)
;;;  (set hamt key val)  return a copy of hamt where key maps to val
;;;  (remove hamt key)   return a copy of hamt with the entry for key removed
;;;  (search proc hamt)  call (proc key val) for each key in a left to right
;;;                      scan of the hamt, returning the first result that is
;;;                      not #f
;;;  (->list hamt)       return an association list representation of hamt
;;;  (<-list alist)      return a HAMT with the associations from alist

;;; The HAMT data structure is implemented through a macro called
;;; define-hamt.  It is a generator of the set of procedure
;;; definitions that implement the HAMT operations specialized for the
;;; equality and hashing procedures passed as arguments to the macro
;;; (i.e. the equ? and equ?-hash parameters).  The parameters make,
;;; ref, set, remove, search, ->list, <-list, alist-search, and
;;; alist-remove are identifiers that are the names of the procedures
;;; defined for those operations.  Any of those parameters can be #f
;;; to indicate the definition of that operation is not needed.  The
;;; length-inc!  parameter is the name of a procedure or macro that is
;;; called by the set procedure when the key does not exist in the
;;; hamt.  It can be #f when no length management is needed.  There is
;;; no need for a length-dec! parameter because the remove procedure
;;; is optimized to not allocate a new hamt when the key does not
;;; exist in the input hamt.  In other words, the number of elements
;;; in the hamt has been decreased by 1 if and only if (not (eq? hamt
;;; (remove hamt key))).  The implementer parameter is the name of the
;;; macro defined by the expansion of define-hamt.  Calling the
;;; implementer macro with no argument expands to the set of procedure
;;; definitions that implement the HAMT operations (this allows the
;;; call to define-hamt and the defines of the procedures to be in
;;; separate source files if needed).

;;; For example, to create a HAMT specialized for keys that are
;;; symbols the define-hamt macro could be called as follows:
;;;
;;; (define-hamt
;;;   implement-symhamt
;;;   symhamt-make
;;;   symhamt-ref
;;;   symhamt-set
;;;   symhamt-remove
;;;   symhamt-search
;;;   symhamt->list
;;;   symhamt<-list
;;;   symhamt-alist-search
;;;   symhamt-alist-remove
;;;   #f ;; no length-inc! method
;;;   eq?
;;;   symbol-hash)
;;;
;;; (implement-symhamt)
;;;
;;; This will expand to the following procedure definitions:
;;;
;;; (begin
;;;  (define (symhamt-make) ...)
;;;  (define (symhamt-ref symhamt sym) ...)
;;;  (define (symhamt-set symhamt sym val) ...)
;;;  (define (symhamt-remove symhamt sym) ...)
;;;  (define (symhamt-search proc symhamt) ...)
;;;  (define (symhamt->list symhamt) ...)
;;;  (define (symhamt<-list alist) ...)
;;;  (define (symhamt-alist-search sym alist) ...)
;;;  (define (symhamt-alist-remove sym alist) ...))

(##namespace ("gambit/hamt/primitive-hamt#"
              define-hamt))

(##define-macro (define-hamt
                  implementer
                  make
                  ref
                  set
                  remove
                  search
                  ->list
                  <-list
                  alist-search
                  alist-remove
                  length-inc!
                  equ?
                  equ?-hash
                  #!optional
                  (equ?-ctx '()))

  ;; The constraints on log2-arity are:
  ;;
  ;;   arity = 2 ^ log2-arity must be < fixnum width - 1 (room for stop bit)
  ;;   log2-arity * max-depth must be < fixnum width
  ;;
  ;; Given that fixnum width is 30 on 32 bit machines, the maximum
  ;; log2-arity is 4 and max-depth <= (quotient 28 log2-arity)

  (define log2-arity 4)
  (define arity      (expt 2 log2-arity))
  (define arity-mask (- arity 1))
  (define max-depth  (quotient 28 log2-arity))
  (define stop-bit   (expt 2 (* log2-arity max-depth)))
  (define hash-mask  (- stop-bit 1))

  (define local-declarations
    `(
      (##include "~~lib/_prim#.scm")

      (declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
      (declare (not safe))          ;; claim code has no type errors

      (define-macro (macro-hash x)
        `(fxior ,',stop-bit
                (fxand ,',hash-mask
                       (,',equ?-hash ,x ,@',equ?-ctx))))

      (define-macro (macro-alist-search key lst ,@equ?-ctx)
        `(let ()

           (define (search key lst ,@',equ?-ctx)
             (if (pair? lst)
                 (let ((x (car lst)))
                   (if (,',equ? (car x) key ,@',equ?-ctx)
                       x
                       (search key (cdr lst) ,@',equ?-ctx)))
                 #f))

           (search ,key ,lst ,@,(cons 'list equ?-ctx))))

      (define-macro (macro-alist-remove key lst ,@equ?-ctx)
        `(let ()

           (define (remove key lst ,@',equ?-ctx)
             (if (pair? lst)
                 (let ((x (car lst)))
                   (if (,',equ? (car x) key ,@',equ?-ctx)
                       (cdr lst)
                       (let* ((rest (cdr lst))
                              (lst2 (remove key rest ,@',equ?-ctx)))
                         (if (eq? rest lst2)
                             lst
                             (cons x lst2)))))
                 '()))

           (remove ,key ,lst ,@,(cons 'list equ?-ctx))))

      ;; Implementation of compressed vectors, which are used for the
      ;; internal nodes of the HAMT.

      (define-macro (macro-2^ i)
        `(fxarithmetic-shift-left 1 ,i))

      (define-macro (macro-bit-set? bm i)
        `(fxodd? (fxarithmetic-shift-right ,bm ,i)))

      (define-macro (macro-bit-set bm i)
        `(fxior ,bm (macro-2^ ,i)))

      (define-macro (macro-bit-clear bm i)
        `(fxand ,bm (fxnot (macro-2^ ,i))))

      (define-macro (macro-compressed-vector-0)
        `'#(0))

      (define-macro (macro-compressed-vector-1 i val)
        `(vector (macro-2^ ,i) ,val))

      (define-macro (macro-compressed-vector-2 i1 val1 i2 val2)
        `(let ((i1 ,i1) (val1 ,val1) (i2 ,i2) (val2 ,val2))
           (let ((bm (fxior (macro-2^ i1) (macro-2^ i2))))
             (if (fx< i1 i2)
                 (vector bm val1 val2)
                 (vector bm val2 val1)))))

      (define-macro (macro-compressed-vector-bitmap v)
        `(vector-ref ,v 0))

      (define-macro (macro-compressed-vector-bitmap-set! v bm)
        `(vector-set! ,v 0 ,bm))

      (define-macro (macro-bit-count-lower bm i)
        `(fxbit-count (fxand ,bm (fx- (macro-2^ ,i) 1))))

      (define-macro (macro-compressed-vector-ref v i fail found)
        `(let* ((v ,v)
                (i ,i)
                (bm (macro-compressed-vector-bitmap v))
                (ci (fx+ (macro-bit-count-lower bm i) 1)))
           (if (macro-bit-set? bm i)
               (,found (vector-ref v ci))
               ,fail)))

      (define-macro (macro-compressed-vector-compress-index v i cont)
        `(let* ((bm (macro-compressed-vector-bitmap ,v))
                (ci (fx+ (macro-bit-count-lower bm ,i) 1)))
           (,cont bm ci)))

      (define-macro (macro-compressed-vector-replace val)
        `(let ((result (vector-copy v)))
           (vector-set! result ci ,val)
           result))

      (define-macro (macro-compressed-vector-insert val)
        `(let ((result (##vector-insert v ci ,val)))
           (macro-compressed-vector-bitmap-set! result (macro-bit-set bm i))
           result))

      ;; never used, but kept for reference
      (define-macro (macro-compressed-vector-set v i val)
        `(let ((v ,v) (i ,i) (val ,val))
           (macro-compressed-vector-compress-index
            v
            i
            (lambda (bm ci)
              (if (macro-bit-set? bm i)
                  (macro-compressed-vector-replace val)
                  (macro-compressed-vector-insert val))))))

      (define-macro (macro-compressed-vector-del)
        `(let ((result (##vector-delete v ci)))
           (macro-compressed-vector-bitmap-set! result
                                                (macro-bit-clear bm i))
           result))

      ;; never used, but kept for reference
      (define-macro (macro-compressed-vector-delete v i)
        `(let ((v ,v) (i ,i))
           (macro-compressed-vector-compress-index
            v
            i
            (lambda (bm ci)
              (macro-compressed-vector-del)))))

      ))

  `(##begin

     (##define-macro (,implementer)
       '(##begin

          ,@(if make
                `((##define (,make)
                    ,@local-declarations
                    (macro-compressed-vector-0)))
                `())

          ,@(if ref
                `((##define (,ref hamt key ,@equ?-ctx)

                    ,@local-declarations

                    (define (ref curr key h ,@equ?-ctx)
                      ;; curr is a compressed vector
                      ;; h is >= arity
                      (let ((i (fxand h ,arity-mask)) ;; index for this level
                            (next-h (fxarithmetic-shift-right h ,log2-arity))) ;; other bits of hash
                        ;; next-h is >= 1
                        (macro-compressed-vector-ref
                         curr
                         i
                         #f ;; no element at index i
                         (lambda (x)
                           ;; x is the element at index i
                           ;; when next-h is 1, curr is a node at the max level and
                           ;; x is an alist,
                           ;; otherwise, curr is not at the max level and x is a pair or
                           ;; compressed vector
                           (if (fx= 1 next-h) ;; max level reached?
                               (,(or alist-search 'macro-alist-search) key x ,@equ?-ctx)
                               (if (pair? x)
                                   (and (,equ? (car x) key ,@equ?-ctx)
                                        x)
                                   (ref x key next-h ,@equ?-ctx)))))))

                    (let ((h (macro-hash key)))
                      (ref hamt key h ,@equ?-ctx))))
                `())

          ,@(if set
                `((##define (,set hamt key val ,@equ?-ctx)

                    ,@local-declarations

                    (define (set curr kv h ,@equ?-ctx)
                      ;; curr is a compressed vector
                      ;; h is >= arity
                      (let ((i (fxand h ,arity-mask)) ;; index for this level
                            (next-h (fxarithmetic-shift-right h ,log2-arity))) ;; other bits of hash
                        ;; next-h is >= 1
                        (macro-compressed-vector-ref
                         curr
                         i
                         (begin
                           ;; key is being added so update length if needed
                           ,@(if length-inc!
                                 `((,length-inc! ,@equ?-ctx))
                                 `())
                           (macro-compressed-vector-insert
                            (if (fx= 1 next-h) ;; max level reached?
                                (list kv) ;; create a 1 element alist containing kv
                                kv)))     ;; simply put kv here
                         (lambda (x)
                           ;; x is the element at index i
                           ;; when next-h is 1, curr is a node at the max level and
                           ;; x is an alist,
                           ;; otherwise, curr is not at the max level and
                           ;; x is a pair or compressed vector
                           (macro-compressed-vector-replace
                            (cond ((fx= 1 next-h) ;; max level reached?
                                   ;; put kv in alist
                                   (let ((alist
                                          (,(or alist-remove 'macro-alist-remove)
                                           (car kv)
                                           x
                                           ,@equ?-ctx)))
                                     ;; if alist did not change then key is
                                     ;; being added so update length if needed
                                     ,@(if length-inc!
                                           `((if (eq? x alist)
                                                 (,length-inc! ,@equ?-ctx)))
                                           `())
                                     (cons kv alist)))
                                  ((pair? x)
                                   (let* ((kv2 x)
                                          (k2 (car kv2)))
                                     (if (,equ? k2 (car kv) ,@equ?-ctx)
                                         kv ;; no length change
                                         (begin
                                           ;; key collision of different keys
                                           ;; so update length if needed
                                           ,@(if length-inc!
                                                 `((,length-inc! ,@equ?-ctx))
                                                 `())
                                           (let ((h2
                                                  (let loop ((b ,stop-bit)
                                                             (h2 (macro-hash k2)))
                                                    (if (fx= 0
                                                             (fxand b next-h))
                                                        (loop (fxarithmetic-shift-right b ,log2-arity)
                                                              (fxarithmetic-shift-right h2 ,log2-arity))
                                                        h2))))
                                             (collision kv next-h kv2 h2))))))
                                  (else
                                   (set x kv next-h ,@equ?-ctx))))))))

                    (define (collision kv1 h1 kv2 h2)
                      (let* ((i1 (fxand h1 ,arity-mask))
                             (i2 (fxand h2 ,arity-mask))
                             (next-h1 (fxarithmetic-shift-right h1 ,log2-arity)))
                        (if (fx= 1 next-h1) ;; max level reached?
                            (if (fx= i1 i2)
                                ;; create a 2 element alist at max level
                                (macro-compressed-vector-1
                                 i1
                                 (list kv1 kv2))
                                ;; create two 1 element alists at max level
                                (macro-compressed-vector-2
                                 i1
                                 (list kv1)
                                 i2
                                 (list kv2)))
                            (if (fx= i1 i2)
                                (macro-compressed-vector-1
                                 i1
                                 ;; continue collision resolution at next level
                                 (collision kv1
                                            next-h1
                                            kv2
                                            (fxarithmetic-shift-right h2 ,log2-arity)))
                                ;; resolved collision
                                (macro-compressed-vector-2 i1 kv1 i2 kv2)))))

                    (let* ((h (macro-hash key))
                           (kv (cons key val)))
                      (set hamt kv h ,@equ?-ctx))))
                `())

          ,@(if remove
                `((##define (,remove hamt key ,@equ?-ctx)

                    ,@local-declarations

                    (define (remove curr key h ,@equ?-ctx)
                      ;; curr is a compressed vector
                      ;; h is >= arity
                      (let ((i (fxand h ,arity-mask)) ;; index for this level
                            (next-h (fxarithmetic-shift-right h ,log2-arity))) ;; other bits of hash
                        ;; next-h is >= 1
                        (macro-compressed-vector-ref
                         curr
                         i
                         curr ;; no element at index i
                         (lambda (x)
                           ;; x is the element at index i
                           ;; when next-h is 1, curr is a node at the
                           ;; max level and x is an alist,
                           ;; otherwise, curr is not at the
                           ;; max level and x is a pair or compressed vector
                           (cond ((fx= 1 next-h) ;; max level reached?
                                  (let ((new-x
                                         (,(or alist-remove 'macro-alist-remove)
                                          key
                                          x
                                          ,@equ?-ctx)))
                                    (cond ((eq? new-x x)
                                           curr)
                                          ((pair? new-x)
                                           (if (or (fx>= (vector-length curr)
                                                         3) ;; >= 2 children
                                                   (pair? (cdr new-x)))
                                               (macro-compressed-vector-replace
                                                new-x)
                                               ;; delete node at max level
                                               (car new-x)))
                                          ((fx= (vector-length curr)
                                                3) ;; 2 children
                                           (let* ((ci2 (fxxor ci 3))
                                                  (x2 (vector-ref curr ci2)))
                                             (if (pair? (cdr x2))
                                                 (macro-compressed-vector-del)
                                                 (car x2))))
                                          (else
                                           (macro-compressed-vector-del)))))
                                 ((pair? x)
                                  (if (,equ? (car x) key ,@equ?-ctx)
                                      (if (or (fx>= h ,stop-bit) ;; root?
                                              (fx>= (vector-length curr)
                                                    4)) ;; >= 3 children
                                          (macro-compressed-vector-del)
                                          ;; node must have 2 children
                                          ;; because an internal node with 1
                                          ;; leaf child is impossible except
                                          ;; at the root (which is excluded)
                                          (let* ((ci2 (fxxor ci 3))
                                                 (x2 (vector-ref curr ci2)))
                                            (if (pair? x2)
                                                x2 ;; delete internal node
                                                (macro-compressed-vector-del))))
                                      curr))
                                 (else
                                  (let ((new-x
                                         (remove x key next-h ,@equ?-ctx)))
                                    (cond ((eq? new-x x)
                                           ;; didn't delete anything
                                           curr)
                                          ((or (not (pair? new-x))
                                               (fx>= h ,stop-bit) ;; root?
                                               (fx>= (vector-length curr)
                                                     3)) ;; >= 2 children
                                           ;; replace child
                                           (macro-compressed-vector-replace
                                            new-x))
                                          (else
                                           ;; sole leaf child, delete node
                                           new-x)))))))))

                    (let ((h (macro-hash key)))
                      (remove hamt key h ,@equ?-ctx))))
                `())

          ,@(if search
                `((##define (,search proc hamt)

                    ,@local-declarations

                    (define (search x level)
                      (if (fx= level ,max-depth)
                          (search-list x)
                          (if (pair? x)
                              (proc (car x) (cdr x))
                              (search-vect x
                                           (fx- (vector-length x) 1)
                                           (fx+ level 1)))))

                    (define (search-list x)
                      (and (pair? x)
                           (let ((kv (car x)))
                             (or (proc (car kv) (cdr kv))
                                 (search-list (cdr x))))))

                    (define (search-vect x i level)
                      (and (fx> i 0)
                           (or (search (vector-ref x i) level)
                               (search-vect x (fx- i 1) level))))

                    (search hamt 0)))
                `())

          ,@(if ->list
                `((##define (,->list hamt)

                    ,@local-declarations

                    (define (convert x level tail)
                      (if (fx= level ,max-depth)
                          (convert-list x
                                        tail)
                          (if (pair? x)
                              (cons x tail)
                              (convert-vect x
                                            (fx- (vector-length x) 1)
                                            (fx+ level 1)
                                            tail))))

                    (define (convert-list x tail)
                      (if (pair? x)
                          (let ((kv (car x)))
                            (convert-list (cdr x)
                                          (cons kv tail)))
                          tail))

                    (define (convert-vect x i level tail)
                      (if (fx> i 0)
                          (convert-vect x
                                        (fx- i 1)
                                        level
                                        (convert (vector-ref x i) level tail))
                          tail))

                    (convert hamt 0 '())))
                `())

          ,@(if (and make set <-list)
                `((##define (,<-list lst ,@equ?-ctx)

                    ,@local-declarations

                    (let loop ((lst lst) (hamt (,make)))
                      (if (pair? lst)
                          (loop (cdr lst)
                                (let ((x (car lst)))
                                  (,set hamt (car x) (cdr x) ,@equ?-ctx)))
                          hamt))))
                `())

          ,@(if alist-search
                `((##define (,alist-search key lst ,@equ?-ctx)
                    ,@local-declarations
                    (macro-alist-search key lst ,@equ?-ctx)))
                `())

          ,@(if alist-remove
                `((##define (,alist-remove key lst ,@equ?-ctx)
                    ,@local-declarations
                    (macro-alist-remove key lst ,@equ?-ctx)))
                `())

          ))))

;;;============================================================================
