;;;============================================================================

;;; File: "_thread#.scm", Time-stamp: <2008-09-23 10:54:49 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception deadlock-exception
  id: 54294cd7-1c33-40e1-940e-7400e1126a5a
  constructor: #f
  opaque:
)

(define-library-type-of-exception abandoned-mutex-exception
  id: e0e435ae-0097-47c9-8d4a-9d761979522c
  constructor: #f
  opaque:
)

(define-library-type-of-exception scheduler-exception
  id: 0d164889-74b4-48ca-b291-f5ec9e0499fe
  constructor: #f
  opaque:

  unprintable:
  read-only:

  reason
)

(define-library-type-of-exception noncontinuable-exception
  id: 1bcc14ff-4be5-4573-a250-729b773bdd50
  constructor: #f
  opaque:

  unprintable:
  read-only:

  reason
)

(define-library-type-of-exception initialized-thread-exception
  id: e38351db-bef7-4c30-b610-b9b271e99ec3
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception uninitialized-thread-exception
  id: 71831161-39c1-4a10-bb79-04342e1981c3
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception inactive-thread-exception
  id: 339af4ff-3d44-4bec-a90b-d981fd13834d
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception started-thread-exception
  id: ed07bce3-b882-4737-ac5e-3035b7783b8a
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception terminated-thread-exception
  id: 85f41657-8a51-4690-abef-d76dc37f4465
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception uncaught-exception
  id: 7022e42c-4ecb-4476-be40-3ca2d45903a7
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
  reason
)

(define-library-type-of-exception join-timeout-exception
  id: 7af7ca4a-ecca-445f-a270-de9d45639feb
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception mailbox-receive-timeout-exception
  id: 5f13e8c4-2c68-4eb5-b24d-249a9356c918
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type continuation 'continuation
  ##continuation?)

(define-check-type time (macro-type-time)
  macro-time?)

(define-check-type absrel-time 'absrel-time
  macro-absrel-time?)

(define-check-type absrel-time-or-false 'absrel-time-or-false
  macro-absrel-time-or-false?)

(define-check-type thread 'thread
  macro-thread?)

(define-check-type mutex (macro-type-mutex)
  macro-mutex?)

(define-check-type condvar (macro-type-condvar)
  macro-condvar?)

(define-check-type tgroup (macro-type-tgroup)
  macro-tgroup?)

(##define-macro (macro-initialized-thread? thread)
  `(macro-thread-cont ,thread))

(##define-macro (macro-started-thread-given-initialized? thread)
  `(or (##not (##procedure? (macro-thread-exception? ,thread)))
       (macro-thread-result ,thread)))

(##define-macro (macro-terminated-thread-given-initialized? thread)
  `(##not (macro-thread-end-condvar ,thread)))

(##define-macro (macro-check-initialized-thread thread form expr)
  `(if (##not (macro-initialized-thread? ,thread))
       (##raise-uninitialized-thread-exception ,@form)
       ,expr))

(##define-macro (macro-check-not-initialized-thread thread form expr)
  `(if (macro-initialized-thread? ,thread)
       (##raise-initialized-thread-exception ,@form)
       ,expr))

(##define-macro (macro-check-not-started-thread-given-initialized thread form expr)
  `(if (let ((thread ,thread))
         (or (macro-terminated-thread-given-initialized? thread)
             (macro-started-thread-given-initialized? thread)))
       (##raise-started-thread-exception ,@form)
       ,expr))

;;;----------------------------------------------------------------------------

;;; Priority queue generator macro.

;; The red-black tree implementation used here is inspired from the
;; code in the MIT-Scheme runtime (file "rbtree.scm").  That code is
;; based on the algorithms presented in the book "Introduction to
;; Algorithms" by Cormen, Leiserson, and Rivest.
;;
;; The main differences with the MIT-Scheme code are:
;;
;;   1) Nil pointers are replaced by a special sentinel that is also
;;      the cell that contains a pointer (in the "left child" field)
;;      to the root of the red-black tree.  The "right child" field of
;;      the sentinel is never accessed.  The sentinel is black.
;;
;;   2) The color field contains #f when the node is red and a
;;      reference to the sentinel when the node is black.  It is thus
;;      possible to find the sentinel from any node in constant time
;;      (if the node is black extract the color field, otherwise
;;      extract the color field of the parent, which must be black).
;;
;;   3) One field of the sentinel always points to the leftmost node of
;;      the red-black tree.  This allows constant time access to the
;;      "minimum" node, which is a frequent operation of priority queues.
;;
;;   4) Several cases are handled specially (see the code for details).
;;
;;   5) Macros are used to generate code specialized for each case of
;;      symmetrical operations (e.g. left and right rotation).
;;
;;   6) Nodes are assumed to be preallocated.  Inserting and deleting a
;;      node from a red-black tree does not perform any heap
;;      allocation.  Moreover, all algorithms consume a constant amount
;;      of stack space.

(##define-macro (define-rbtree
                 rbtree-init!
                 node->rbtree
                 insert!
                 remove!
                 reposition!
                 singleton?
                 color
                 color-set!
                 parent
                 parent-set!
                 left
                 left-set!
                 right
                 right-set!
                 before?
                 leftmost
                 leftmost-set!
                 rightmost
                 rightmost-set!)

  (define (black rbtree)
    rbtree)

  (define (black? rbtree)
    `(lambda (node)
       (,color node)))

  (define (blacken! rbtree)
    `(lambda (node)
       (,color-set! node ,(black rbtree))))

  (define (red)
    #f)

  (define (red?)
    `(lambda (node)
       (##not (,color node))))

  (define (reden!)
    `(lambda (node)
       (,color-set! node ,(red))))

  (define (copy-color!)
    `(lambda (node1 node2)
       (,color-set! node1 (,color node2))))

  (define (exchange-color!)
    `(lambda (node1 node2)
       (let ((color-node1 (,color node1)))
         (,color-set! node1 (,color node2))
         (,color-set! node2 color-node1))))

  (define (update-parent!)
    `(lambda (parent-node old-node new-node)
       (if (##eq? old-node (,left parent-node))
         (,left-set! parent-node new-node)
         (,right-set! parent-node new-node))))

  (define (rotate! side1 side1-set! side2 side2-set!)
    `(lambda (node)
       (let ((side2-node (,side2 node)))
         (let ((side1-side2-node (,side1 side2-node)))
           (,side2-set! node side1-side2-node)
           (,parent-set! side1-side2-node node))
         (let ((parent-node (,parent node)))
           (,side1-set! side2-node node)
           (,parent-set! node side2-node)
           (,parent-set! side2-node parent-node)
           (,(update-parent!) parent-node node side2-node)))))

  (define (rotate-left!)
    (rotate! left left-set! right right-set!))

  (define (rotate-right!)
    (rotate! right right-set! left left-set!))

  (define (neighbor side other-side)
    `(lambda (node rbtree)
       (let ((side-node (,side node)))
         (if (##eq? side-node rbtree)
           (let ((parent-node (,parent node)))
             (if (or (##eq? parent-node rbtree)
                     (##eq? node (,side parent-node)))
               rbtree
               parent-node))
           (let loop ((x side-node))
             (let ((other-side-x (,other-side x)))
               (if (##eq? other-side-x rbtree)
                 x
                 (loop other-side-x))))))))

  `(begin

     (##define-macro (,rbtree-init! rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          ,',@(if leftmost
                `((,leftmost-set! rbtree rbtree))
                `())

          (,',(blacken! 'rbtree) rbtree)
          (,',parent-set! rbtree rbtree)
          (,',left-set! rbtree rbtree)))

     (##define-macro (,node->rbtree node)
       `(let ((node ,node))

          (##declare (not interrupts-enabled))

          (or (,',color node)
              (let ((parent-node (,',parent node)))
                (and parent-node ;; make sure node is in a rbtree
                     (,',color parent-node))))))

     (define-prim (,insert! rbtree node)

       (##declare (not interrupts-enabled))

       (define (fixup!)

         (let loop ((x node))
           (let ((parent-x (,parent x)))
             (if (,(red?) parent-x)
               (let ((parent-parent-x (,parent parent-x)))

                 (##define-macro (body
                                  side1
                                  rotate-side1!
                                  side2
                                  rotate-side2!)
                   `(let ((side2-parent-parent-x (,side2 parent-parent-x)))
                      (if (,',(red?) side2-parent-parent-x)
                        (begin
                          (,',(blacken! 'rbtree) parent-x)
                          (,',(blacken! 'rbtree) side2-parent-parent-x)
                          (,',(reden!) parent-parent-x)
                          (loop parent-parent-x))
                        (let ((y
                               (if (##eq? x (,side2 parent-x))
                                 (begin
                                   (,rotate-side1! parent-x)
                                   (,',parent parent-x))
                                 (,',parent x))))
                          (,',(blacken! 'rbtree) y)
                          (let ((parent-y (,',parent y)))
                            (,',(reden!) parent-y)
                            (,rotate-side2! parent-y))))))

                 (if (##eq? parent-x (,left parent-parent-x))
                   (body ,left
                         ,(rotate-left!)
                         ,right
                         ,(rotate-right!))
                   (body ,right
                         ,(rotate-right!)
                         ,left
                         ,(rotate-left!)))))))

         (,(blacken! 'rbtree) (,left rbtree))
         (##void))

       (##define-macro (insert-below! x)
         `(let ((x ,x))
            (if (,',before? node x)
              (insert-left! (,',left x) x)
              (insert-right! (,',right x) x))))

       (define (insert-left! left-x x)
         (if (##eq? left-x rbtree)
           (begin
             (,left-set! x node)
             (,parent-set! node x)

             ;; check if leftmost must be updated

             ,@(if leftmost
                 `((if (##eq? x (,leftmost rbtree))
                     (,leftmost-set! rbtree node)))
                 `())

             (fixup!))
           (insert-below! left-x)))

       (define (insert-right! right-x x)
         (if (##eq? right-x rbtree)
           (begin
             (,right-set! x node)
             (,parent-set! node x)

             ;; check if rightmost must be updated

             ,@(if rightmost
                 `((if (##eq? x (,rightmost rbtree))
                     (,rightmost-set! rbtree node)))
                 `())

             (fixup!))
           (insert-below! right-x)))

       (,(reden!) node)
       (,left-set! node rbtree)
       (,right-set! node rbtree)

       (insert-left! (,left rbtree) rbtree)

       (,parent-set! rbtree rbtree))

     (define-prim (,remove! node)

       (##declare (not interrupts-enabled))

       (let ((rbtree (,node->rbtree node)))

         (define (fixup! parent-node node)

           (##define-macro (body side1 rotate-side1! side2 rotate-side2!)
             `(let ((x
                     (let ((side2-parent-node (,side2 parent-node)))
                       (if (,',(red?) side2-parent-node)
                         (begin
                           (,',(blacken! 'rbtree) side2-parent-node)
                           (,',(reden!) parent-node)
                           (,rotate-side1! parent-node)
                           (,side2 parent-node))
                         side2-parent-node))))

                (define (common-case y)
                  (,',(copy-color!) y parent-node)
                  (,',(blacken! 'rbtree) parent-node)
                  (,',(blacken! 'rbtree) (,side2 y))
                  (,rotate-side1! parent-node)
                  (,',(blacken! 'rbtree) (,',left rbtree)))

                (if (,',(red?) (,side2 x))
                  (common-case x)
                  (let ((side1-x (,side1 x)))
                    (if (,',(black? 'rbtree) side1-x)
                      (begin
                        (,',(reden!) x)
                        (fixup! (,',parent parent-node) parent-node))
                      (begin
                        (,',(blacken! 'rbtree) side1-x)
                        (,',(reden!) x)
                        (,rotate-side2! x)
                        (common-case (,side2 parent-node))))))))

           (cond ((or (##eq? parent-node rbtree) (,(red?) node))
                  (,(blacken! 'rbtree) node))
                 ((##eq? node (,left parent-node))
                  (body ,left
                        ,(rotate-left!)
                        ,right
                        ,(rotate-right!)))
                 (else
                  (body ,right
                        ,(rotate-right!)
                        ,left
                        ,(rotate-left!)))))

         (let ((parent-node (,parent node))
               (left-node (,left node))
               (right-node (,right node)))

           (,parent-set! node #f) ;; to avoid leaks
           (,left-set! node #f)
           (,right-set! node #f)

           (cond ((##eq? left-node rbtree)

                  ;; check if leftmost must be updated

                  ,@(if leftmost
                      `((if (##eq? node (,leftmost rbtree))
                          (,leftmost-set!
                           rbtree
                           (if (##eq? right-node rbtree)
                             parent-node
                             right-node))))
                      `())

                  (,parent-set! right-node parent-node)
                  (,(update-parent!) parent-node node right-node)

                  (if (,(black? 'rbtree) node)
                    (begin
                      (,(reden!) node) ;; to avoid leaks
                      (fixup! parent-node right-node))))

                 ((##eq? right-node rbtree)

                  ;; check if rightmost must be updated

                  ,@(if rightmost
                      `((if (##eq? node (,rightmost rbtree))
                          (,rightmost-set!
                           rbtree
                           left-node)))
                      `())

                  (,parent-set! left-node parent-node)
                  (,(update-parent!) parent-node node left-node)

                  ;; At this point we know that the node is black.
                  ;; This is because the right child is nil and the
                  ;; left child is red (if the left child was black
                  ;; the tree would not be balanced)

                  (,(reden!) node) ;; to avoid leaks
                  (fixup! parent-node left-node))

                 (else
                  (let loop ((x right-node) (parent-x node))
                    (let ((left-x (,left x)))
                      (if (##eq? left-x rbtree)
                        (begin
                          (,(exchange-color!) x node)
                          (,parent-set! left-node x)
                          (,left-set! x left-node)
                          (,parent-set! x parent-node)
                          (,(update-parent!) parent-node node x)
                          (if (##eq? x right-node)
                            (if (,(black? 'rbtree) node)
                              (begin
                                (,(reden!) node) ;; to avoid leaks
                                (fixup! x (,right x))))
                            (let ((right-x (,right x)))
                              (,parent-set! right-x parent-x)
                              (,left-set! parent-x right-x)
                              (,parent-set! right-node x)
                              (,right-set! x right-node)
                              (if (,(black? 'rbtree) node)
                                (begin
                                  (,(reden!) node) ;; to avoid leaks
                                  (fixup! parent-x right-x))))))
                        (loop left-x x)))))))

         (,parent-set! rbtree rbtree)))

     (##define-macro (,singleton? rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          (let ((root (,',left rbtree)))
            (and (##not (##eq? root rbtree))
                 (##eq? (,',left root) rbtree)
                 (##eq? (,',right root) rbtree)
                 root))))

     (define-prim (,reposition! node)

       (##declare (not interrupts-enabled))

       (let* ((rbtree
               (,node->rbtree node))
              (predecessor-node
               (,(neighbor left right) node rbtree))
              (successor-node
               (,(neighbor right left) node rbtree)))
         (if (or (and (##not (##eq? predecessor-node rbtree))
                      (,before? node predecessor-node))
                 (and (##not (##eq? successor-node rbtree))
                      (,before? successor-node node)))
           (begin
             (,remove! node)
             (,insert! rbtree node)))))))

;;;----------------------------------------------------------------------------

;;; Representation of dynamic environments.

;; The dynamic environment contains the set of dynamically bound
;; "parameters" (such as the current input port and current exception
;; handler) that is attached to a continuation, and thereby to a
;; thread.

;; The dynamic environment stores the bindings of normal parameters in
;; a binary tree ordered using an integer identifier attached to the
;; parameter.  Some frequently used parameters (such as the current
;; input port and exception handler) are stored separately.

(##define-macro (macro-make-denv local dynwind im ds eh ip op rc)
  `(##vector ,local ,dynwind ,im ,ds ,eh ,ip ,op ,rc))
(##define-macro (macro-denv-local d)                    `(macro-slot 0 ,d))
(##define-macro (macro-denv-local-set! d x)             `(macro-slot 0 ,d ,x))
(##define-macro (macro-denv-dynwind d)                  `(macro-slot 1 ,d))
(##define-macro (macro-denv-dynwind-set! d x)           `(macro-slot 1 ,d ,x))
(##define-macro (macro-denv-interrupt-mask d)           `(macro-slot 2 ,d))
(##define-macro (macro-denv-interrupt-mask-set! d x)    `(macro-slot 2 ,d ,x))
(##define-macro (macro-denv-debugging-settings d)       `(macro-slot 3 ,d))
(##define-macro (macro-denv-debugging-settings-set! d x)`(macro-slot 3 ,d ,x))
(##define-macro (macro-denv-exception-handler d)        `(macro-slot 4 ,d))
(##define-macro (macro-denv-exception-handler-set! d x) `(macro-slot 4 ,d ,x))
(##define-macro (macro-denv-input-port d)               `(macro-slot 5 ,d))
(##define-macro (macro-denv-input-port-set! d x)        `(macro-slot 5 ,d ,x))
(##define-macro (macro-denv-output-port d)              `(macro-slot 6 ,d))
(##define-macro (macro-denv-output-port-set! d x)       `(macro-slot 6 ,d ,x))
(##define-macro (macro-denv-repl-context d)             `(macro-slot 7 ,d))
(##define-macro (macro-denv-repl-context-set! d x)      `(macro-slot 7 ,d ,x))

;;; Environment tree nodes.

(##define-macro (macro-make-env pv l r)        `(##vector ,pv ,l ,r))
(##define-macro (macro-env-param-val e)        `(macro-slot 0 ,e))
(##define-macro (macro-env-param-val-set! e x) `(macro-slot 0 ,e ,x))
(##define-macro (macro-env-left e)             `(macro-slot 1 ,e))
(##define-macro (macro-env-left-set! e x)      `(macro-slot 1 ,e ,x))
(##define-macro (macro-env-right e)            `(macro-slot 2 ,e))
(##define-macro (macro-env-right-set! e x)     `(macro-slot 2 ,e ,x))

;;; Dynamic-wind frames.

(##define-macro (macro-make-dynwind level before after cont)
  `(##vector ,level ,before ,after ,cont))
(##define-macro (macro-dynwind-level d)         `(macro-slot 0 ,d))
(##define-macro (macro-dynwind-level-set! d x)  `(macro-slot 0 ,d ,x))
(##define-macro (macro-dynwind-before d)        `(macro-slot 1 ,d))
(##define-macro (macro-dynwind-before-set! d x) `(macro-slot 1 ,d ,x))
(##define-macro (macro-dynwind-after d)         `(macro-slot 2 ,d))
(##define-macro (macro-dynwind-after-set! d x)  `(macro-slot 2 ,d ,x))
(##define-macro (macro-dynwind-cont d)          `(macro-slot 3 ,d))
(##define-macro (macro-dynwind-cont-set! d x)   `(macro-slot 3 ,d ,x))

;;; Parameter descriptors.

(##define-macro (macro-make-parameter-descr value hash filter)
  `(##vector ,value ,hash ,filter))

(##define-macro (macro-parameter-descr-value p)         `(macro-slot 0 ,p))
(##define-macro (macro-parameter-descr-value-set! p x)  `(macro-slot 0 ,p ,x))
(##define-macro (macro-parameter-descr-hash p)          `(macro-slot 1 ,p))
(##define-macro (macro-parameter-descr-hash-set! p x)   `(macro-slot 1 ,p ,x))
(##define-macro (macro-parameter-descr-filter p)        `(macro-slot 2 ,p))
(##define-macro (macro-parameter-descr-filter-set! p x) `(macro-slot 2 ,p ,x))

;;; Binding of special dynamic variables.

(##define-macro (macro-dynamic-bind var val thunk)
  `(let ((val ,val) (thunk ,thunk))

     (##declare (not interrupts-enabled))

     (let ((current-denv (macro-thread-denv (macro-current-thread))))
       (##dynamic-env-bind
        (macro-make-denv
         (macro-denv-local current-denv)
         ,(if (eq? var 'dynwind)
            `val
            `(macro-denv-dynwind current-denv))
         ,(if (eq? var 'interrupt-mask)
            `val
            `(macro-denv-interrupt-mask current-denv))
         ,(if (eq? var 'debugging-settings)
            `val
            `(macro-denv-debugging-settings current-denv))
         ,(if (eq? var 'exception-handler)
            `(##cons ##current-exception-handler val)
            `(macro-denv-exception-handler current-denv))
         ,(if (eq? var 'input-port)
            `(##cons ##current-input-port val)
            `(macro-denv-input-port current-denv))
         ,(if (eq? var 'output-port)
            `(##cons ##current-output-port val)
            `(macro-denv-output-port current-denv))
         ,(if (eq? var 'repl-context)
            `(##cons #f val)
            `(macro-denv-repl-context current-denv)))
        thunk))))

(##define-macro (macro-current-interrupt-mask)
  `(macro-denv-interrupt-mask (macro-thread-denv (macro-current-thread))))

(##define-macro (macro-debugging-settings-port)
  `(macro-denv-debugging-settings (macro-thread-denv (macro-current-thread))))

(##define-macro (macro-current-exception-handler)
  `(##cdr
    (macro-denv-exception-handler (macro-thread-denv (macro-current-thread)))))

(##define-macro (macro-current-exception-handler-set! val)
  `(##set-cdr!
    (macro-denv-exception-handler (macro-thread-denv (macro-current-thread)))
    ,val))

(##define-macro (macro-current-input-port)
  `(##cdr
    (macro-denv-input-port (macro-thread-denv (macro-current-thread)))))

(##define-macro (macro-current-input-port-set! val)
  `(##set-cdr!
    (macro-denv-input-port (macro-thread-denv (macro-current-thread)))
    ,val))

(##define-macro (macro-current-output-port)
  `(##cdr
    (macro-denv-output-port (macro-thread-denv (macro-current-thread)))))

(##define-macro (macro-current-output-port-set! val)
  `(##set-cdr!
    (macro-denv-output-port (macro-thread-denv (macro-current-thread)))
    ,val))

(##define-macro (macro-current-repl-context)
  `(##cdr
    (macro-denv-repl-context (macro-thread-denv (macro-current-thread)))))

(##define-macro (macro-current-repl-context-set! val)
  `(##set-cdr!
    (macro-denv-repl-context (macro-thread-denv (macro-current-thread)))
    ,val))

;;; Exception raising.

(##define-macro (macro-raise obj)
  `(let ((obj ,obj))
     (##declare (not safe)) ;; avoid procedure check on the call to the handler
     ((macro-current-exception-handler) obj)))

(##define-macro (macro-abort obj)
  `(let ((obj ,obj))
     (##declare (not safe)) ;; avoid procedure check on the call to the handler
     ((macro-current-exception-handler) obj)
     (##abort (macro-make-noncontinuable-exception obj))))

;;;----------------------------------------------------------------------------

;;; Representation of time objects.

(define-type time
  id: 9700b02a-724f-4888-8da8-9b0501836d8e
  type-exhibitor: macro-type-time
  constructor: macro-make-time
  implementer: implement-type-time
  opaque:
  macros:
  prefix: macro-

  unprintable:

  point
  ;; the following fields are for eventual compatibility with srfi-19
  type
  second
  nanosecond
)

(##define-macro (macro-absrel-time? obj)
  `(let ((obj ,obj))
     (or (##real? obj)
         (macro-time? obj))))

(##define-macro (macro-absrel-time-or-false? obj)
  `(let ((obj ,obj))
     (or (##not obj)
         (macro-absrel-time? obj))))

;;;----------------------------------------------------------------------------

;;; Root thread settings.

(##define-macro (macro-thread-root-base-priority)
  (exact->inexact (- (expt 10 10))))

(##define-macro (macro-thread-root-quantum)
  (exact->inexact 2/100))

(##define-macro (macro-thread-root-priority-boost)
  (exact->inexact (expt 10 -6)))

(##define-macro (macro-default-heartbeat-interval)
  (exact->inexact 1/100))

;;;----------------------------------------------------------------------------

;;; Representation of thread groups, threads, mutexes and condition variables.

;; A thread group contains a double-ended-queue of the threads that are
;; in the group and a double-ended-queue of the thread groups that are
;; in the group.  A thread contains a double-ended-queue of the mutexes
;; that are owned by the thread.  Conversely, a mutex contains a queue
;; of the threads blocked on the mutex.  A condition variable also
;; contains a queue of the threads blocked on the condition variable.

;;; Representation of blocked thread queues.

(##define-macro (macro-btq-deq-next node)        `(macro-slot 1 ,node))
(##define-macro (macro-btq-deq-next-set! node x) `(macro-slot 1 ,node ,x))
(##define-macro (macro-btq-deq-prev node)        `(macro-slot 2 ,node))
(##define-macro (macro-btq-deq-prev-set! node x) `(macro-slot 2 ,node ,x))
(##define-macro (macro-btq-color node)           `(macro-slot 3 ,node))
(##define-macro (macro-btq-color-set! node x)    `(macro-slot 3 ,node ,x))
(##define-macro (macro-btq-parent node)          `(macro-slot 4 ,node))
(##define-macro (macro-btq-parent-set! node x)   `(macro-slot 4 ,node ,x))
(##define-macro (macro-btq-left node)            `(macro-slot 5 ,node))
(##define-macro (macro-btq-left-set! node x)     `(macro-slot 5 ,node ,x))
(##define-macro (macro-btq-right node)           `(macro-slot 6 ,node))
(##define-macro (macro-btq-right-set! node x)    `(macro-slot 6 ,node ,x))
(##define-macro (macro-btq-leftmost node)        `(macro-slot 6 ,node))
(##define-macro (macro-btq-leftmost-set! node x) `(macro-slot 6 ,node ,x))
(##define-macro (macro-btq-owner node)           `(macro-slot 7 ,node))
(##define-macro (macro-btq-owner-set! node x)    `(macro-slot 7 ,node ,x))

(##define-macro (macro-btq-deq-init! deq)
  `(let ((deq ,deq))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-next-set! deq deq)
     (macro-btq-deq-prev-set! deq deq)))

(##define-macro (macro-btq-deq-remove! item)
  `(let ((item ,item))

     (##declare (not interrupts-enabled))

     (let ((item-next (macro-btq-deq-next item))
           (item-prev (macro-btq-deq-prev item)))
       (macro-btq-deq-next-set! item-prev item-next)
       (macro-btq-deq-prev-set! item-next item-prev))))

(##define-macro (macro-btq-deq-insert! deq item)
  `(let ((deq ,deq) (item ,item))

     (##declare (not interrupts-enabled))

     ;; add item to tail of deq

     (let ((deq-last (macro-btq-deq-prev deq)))
       (macro-btq-deq-next-set! deq-last item)
       (macro-btq-deq-prev-set! deq item)
       (macro-btq-deq-next-set! item deq)
       (macro-btq-deq-prev-set! item deq-last))))

(##define-macro (macro-btq-link! mutex thread)
  `(let ((mutex ,mutex) (thread ,thread))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-insert! thread mutex)
     (macro-btq-owner-set! mutex thread)))

(##define-macro (macro-btq-unlink! mutex state)
  `(let ((mutex ,mutex) (state ,state))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-init! mutex)
     (macro-btq-owner-set! mutex state)))

;;; Representation of timeout queues.

(##define-macro (macro-toq-color node)           `(macro-slot 8 ,node))
(##define-macro (macro-toq-color-set! node x)    `(macro-slot 8 ,node ,x))
(##define-macro (macro-toq-parent node)          `(macro-slot 9 ,node))
(##define-macro (macro-toq-parent-set! node x)   `(macro-slot 9 ,node ,x))
(##define-macro (macro-toq-left node)            `(macro-slot 10 ,node))
(##define-macro (macro-toq-left-set! node x)     `(macro-slot 10 ,node ,x))
(##define-macro (macro-toq-right node)           `(macro-slot 11 ,node))
(##define-macro (macro-toq-right-set! node x)    `(macro-slot 11 ,node ,x))
(##define-macro (macro-toq-leftmost node)        `(macro-slot 11 ,node))
(##define-macro (macro-toq-leftmost-set! node x) `(macro-slot 11 ,node ,x))

;;; Representation of threads.

;; The state of a thread is determined by the content of the
;; "end-condvar", "exception?" and "result" fields:
;;
;;  thread state               "end-condvar" "exception?" "result"
;;  not yet started            condvar       thunk        #f
;;  started, never run         condvar       thunk        ##thread-start-action!
;;  started, has run           condvar       #f           action procedure/#f/#t
;;  terminated with result     #f            #f           result object
;;  terminated with exception  #f            #t           exception object

(define-type thread
  id: d05e0aa7-e235-441d-aa41-c1ac02065460
  extender: macro-define-type-of-thread
  type-exhibitor: macro-type-thread
  constructor: macro-construct-thread
  implementer: implement-type-thread
  opaque:
  macros:
  prefix: macro-

  unprintable:

  (btq-deq-next     init: #f) ;; blocked thread queues owned by thread
  (btq-deq-prev     init: #f)

  (btq-color        init: #f) ;; to keep thread in a blocked thread queue
  (btq-parent       init: #f)
  (btq-left         init: #f)
  (btq-leftmost     init: #f)

  (tgroup           init: #f) ;; thread-group this thread belongs to

  (toq-color        init: #f) ;; to keep thread in a timeout queue
  (toq-parent       init: #f)
  (toq-left         init: #f)
  (toq-leftmost     init: #f)

  (threads-deq-next init: #f) ;; threads in this thread group
  (threads-deq-prev init: #f)

  (floats           init: #f)
  (name             init: #f)
  (end-condvar      init: #f)
  (exception?       init: #f)
  (result           init: #f)
  (cont             init: #f)
  (denv             init: #f)
  (denv-cache1      init: #f)
  (denv-cache2      init: #f)
  (denv-cache3      init: #f)
  (repl-channel     init: #f)
  (mailbox          init: #f)
  (specific         init: #f)
)

;;; Access to floating point fields.

(##define-macro (macro-timeout f)                  `(##f64vector-ref ,f 0))
(##define-macro (macro-timeout-set! f x)           `(##f64vector-set! ,f 0 ,x))
(##define-macro (macro-base-priority f)            `(##f64vector-ref ,f 1))
(##define-macro (macro-base-priority-set! f x)     `(##f64vector-set! ,f 1 ,x))
(##define-macro (macro-quantum f)                  `(##f64vector-ref ,f 2))
(##define-macro (macro-quantum-set! f x)           `(##f64vector-set! ,f 2 ,x))
(##define-macro (macro-quantum-used f)             `(##f64vector-ref ,f 3))
(##define-macro (macro-quantum-used-set! f x)      `(##f64vector-set! ,f 3 ,x))
(##define-macro (macro-priority-boost f)           `(##f64vector-ref ,f 4))
(##define-macro (macro-priority-boost-set! f x)    `(##f64vector-set! ,f 4 ,x))
(##define-macro (macro-boosted-priority f)         `(##f64vector-ref ,f 5))
(##define-macro (macro-boosted-priority-set! f x)  `(##f64vector-set! ,f 5 ,x))
(##define-macro (macro-effective-priority f)       `(##f64vector-ref ,f 6))
(##define-macro (macro-effective-priority-set! f x)`(##f64vector-set! ,f 6 ,x))

(##define-macro (macro-thread-timeout t)
  `(macro-timeout (macro-thread-floats ,t)))

(##define-macro (macro-thread-timeout-set! t x)
  `(macro-timeout-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-base-priority t)
  `(macro-base-priority (macro-thread-floats ,t)))

(##define-macro (macro-thread-base-priority-set! t x)
  `(macro-base-priority-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-quantum t)
  `(macro-quantum (macro-thread-floats ,t)))

(##define-macro (macro-thread-quantum-set! t x)
  `(macro-quantum-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-quantum-used t)
  `(macro-quantum-used (macro-thread-floats ,t)))

(##define-macro (macro-thread-quantum-used-set! t x)
  `(macro-quantum-used-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-priority-boost t)
  `(macro-priority-boost (macro-thread-floats ,t)))

(##define-macro (macro-thread-priority-boost-set! t x)
  `(macro-priority-boost-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-boosted-priority t)
  `(macro-boosted-priority (macro-thread-floats ,t)))

(##define-macro (macro-thread-boosted-priority-set! t x)
  `(macro-boosted-priority-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-thread-effective-priority t)
  `(macro-effective-priority (macro-thread-floats ,t)))

(##define-macro (macro-thread-effective-priority-set! t x)
  `(macro-effective-priority-set! (macro-thread-floats ,t) ,x))

(##define-macro (macro-make-thread-floats parent-thread)
  `(let* ((floats
           (macro-thread-floats ,parent-thread))
          (base-priority
           (macro-base-priority floats))
          (priority-boost
           (macro-priority-boost floats)))
     (##f64vector
      (macro-inexact-+0)
      base-priority
      (macro-quantum floats)
      (macro-inexact-+0)
      priority-boost
      base-priority
      base-priority)))

(##define-macro (macro-make-thread-end-condvar parent-thread)
  `(macro-make-condvar #f))

(##define-macro (macro-make-thread-cont parent-thread)
  `(let ((cont (##vector 0)))
     (##subtype-set! cont (macro-subtype-continuation))
     cont))

(##define-macro (macro-make-thread-denv parent-thread)
  `(let ((denv (macro-thread-denv ,parent-thread)))
     (macro-make-denv
      (macro-denv-local denv)
      ##initial-dynwind
      (macro-denv-interrupt-mask denv)
      (macro-denv-debugging-settings denv)
      (##cons ##current-exception-handler
              (macro-primordial-exception-handler))
      (macro-denv-input-port denv)
      (macro-denv-output-port denv)
      (##cons #f
              #f))))

(##define-macro (macro-make-thread-denv-cache1 parent-thread)
  `(macro-thread-denv-cache1 ,parent-thread))

(##define-macro (macro-make-thread-denv-cache2 parent-thread)
  `(macro-thread-denv-cache2 ,parent-thread))

(##define-macro (macro-make-thread-denv-cache3 parent-thread)
  `(macro-thread-denv-cache3 ,parent-thread))

(##define-macro (macro-thread-init! thread thunk name tgroup)
  `(let ((thread ,thread) (thunk ,thunk) (name ,name) (tgroup ,tgroup))

     (##declare (not interrupts-enabled))

     (let ((p (macro-current-thread)))
       (macro-thread-tgroup-set! thread tgroup)
       (macro-thread-floats-set! thread (macro-make-thread-floats p))
       (macro-thread-name-set! thread name)
       (macro-thread-end-condvar-set! thread (macro-make-thread-end-condvar p))
       (macro-thread-exception?-set! thread thunk)
       (macro-thread-cont-set! thread (macro-make-thread-cont p))
       (macro-thread-denv-set! thread (macro-make-thread-denv p))
       (macro-thread-denv-cache1-set! thread (macro-make-thread-denv-cache1 p))
       (macro-thread-denv-cache2-set! thread (macro-make-thread-denv-cache2 p))
       (macro-thread-denv-cache3-set! thread (macro-make-thread-denv-cache3 p))
       (macro-btq-deq-init! thread)
       (macro-tgroup-threads-deq-insert! tgroup thread)
       thread)))

(##define-macro (macro-make-thread thunk name tgroup)
  `(let ((thunk ,thunk) (name ,name) (tgroup ,tgroup))

     (##declare (not interrupts-enabled))

     (macro-thread-init! (macro-construct-thread) thunk name tgroup)))

(##define-macro (macro-thread-btq-remove-if-in-btq! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (if (macro-btq-parent thread)
       (##thread-btq-remove! thread))))

(##define-macro (macro-thread-toq-remove-if-in-toq! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (if (macro-toq-parent thread)
       (##thread-toq-remove! thread))))

(##define-macro (macro-thread-reschedule-if-needed!)
  `(let ()

     (##declare (not interrupts-enabled))

     (let ((leftmost (macro-btq-leftmost (macro-run-queue))))
       (if (##not (##eq? leftmost (macro-current-thread)))
         (##thread-reschedule!)
         (##void)))))

(##define-macro (macro-thread-save! proc . args)
  `(##thread-save! ,proc ,@args))

(##define-macro (macro-thread-restore! thread proc . args)
  `(##thread-restore! ,thread ,proc ,@args))

(##define-macro (macro-run-queue)
  `(##run-queue))

(##define-macro (macro-primordial-thread)
  `(macro-run-queue-primordial-thread (macro-run-queue)))

(##define-macro (macro-current-thread)
  `(##current-thread))

(##define-macro (macro-primordial-exception-handler)
  `##primordial-exception-handler)

(##define-macro (macro-thread-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##flonum.< (macro-effective-priority floats2) ;; high priority first
                   (macro-effective-priority floats1)))))

(##define-macro (macro-thread-sooner? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##flonum.< (macro-timeout floats1)
                   (macro-timeout floats2)))))

(##define-macro (macro-thread-sooner-or-simultaneous-and-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (if (##not (##flonum.= (macro-timeout floats1)
                              (macro-timeout floats2)))
         (##flonum.< (macro-timeout floats1)
                     (macro-timeout floats2))
         (##flonum.< (macro-effective-priority floats2) ;; high priority first
                     (macro-effective-priority floats1))))))

(##define-macro (macro-thread-boost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##flonum.= (##flonum.+ (macro-base-priority floats)
                                          (macro-priority-boost floats))
                              (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-run-queue))
            (macro-boosted-priority floats))

           (macro-boosted-priority-set!
            floats
            (##flonum.+ (macro-base-priority floats)
                        (macro-priority-boost floats)))

            (##thread-boosted-priority-changed! thread))))))

(##define-macro (macro-thread-unboost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##flonum.= (macro-base-priority floats)
                              (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-run-queue))
            (macro-boosted-priority floats))

           (macro-boosted-priority-set!
            floats
            (macro-base-priority floats))

            (##thread-boosted-priority-changed! thread))))))

(##define-macro (macro-thread-inherit-priority! thread parent);;;;;;;;;;;;;;;
  `(let ((thread ,thread) (parent ,parent))

     (##declare (not interrupts-enabled))

     (let ((thread-floats (macro-thread-floats thread))
           (parent-floats (macro-thread-floats parent)))
       (if (##flonum.< (macro-effective-priority thread-floats)
                       (macro-effective-priority parent-floats))
         (begin
           (macro-effective-priority-set!
            thread-floats
            (macro-effective-priority parent-floats))
           (##thread-effective-priority-changed! thread #t))))))

;;; Representation of thread mailboxes.

(define-type mailbox
  id: f1bd59e2-25fc-49af-b624-e00f0c5975f8
  type-exhibitor: macro-type-mailbox
  constructor: macro-construct-mailbox
  implementer: implement-type-mailbox
  predicate: macro-mailbox?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  mutex
  condvar
  fifo
  cursor
)

(##define-macro (macro-make-mailbox)
  `(let ((mutex (macro-make-mutex #f))
         (condvar (macro-make-condvar #f))
         (fifo (macro-make-fifo)))
     (macro-construct-mailbox mutex condvar fifo #f)))

;;; Representation of mutexes.

(define-type mutex
  id: 42fe9aac-e9c6-4227-893e-a0ad76f58932
  type-exhibitor: macro-type-mutex
  constructor: macro-construct-mutex
  implementer: implement-type-mutex
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 2 are for maintaining this mutex in a deq of btqs
  ;; fields 3 to 5 are for maintaining a queue of blocked threads
  ;; field 6 is the leftmost thread in the queue of blocked threads
  ;; field 7 is the owner of the mutex (or 'not-owned or 'abandoned or #f)
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: #f)

  (name
   macro-mutex-name
   macro-mutex-name-set!)
  (specific
   macro-mutex-specific
   macro-mutex-specific-set!)
)

(##define-macro (macro-make-mutex name)
  `(let ((name ,name))
     (let ((mutex (macro-construct-mutex name (##void))))
       (macro-btq-deq-init! mutex)
       (macro-btq-init! mutex)
       mutex)))

(##define-macro (macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? mutex)
  `(##not (macro-btq-owner ,mutex)))

(##define-macro (macro-mutex-lock! mutex absrel-timeout owner)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout) (owner ,owner))

     (##declare (not interrupts-enabled))

     (let ((state (macro-btq-owner mutex)))
       (if state
         (##mutex-lock-out-of-line! mutex absrel-timeout owner)
         (begin
           (macro-btq-link! mutex owner)
           #t)))))

(##define-macro (macro-mutex-lock-anonymously! mutex absrel-timeout)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout))

     (##declare (not interrupts-enabled))

     (let ((state (macro-btq-owner mutex)))
       (if state
         (##mutex-lock-out-of-line! mutex absrel-timeout #f)
         (begin
           (macro-btq-owner-set! mutex 'not-owned)
           #t)))))

(##define-macro (macro-mutex-unlock! mutex)
  `(let ((mutex ,mutex))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-remove! mutex)
     (let ((leftmost (macro-btq-leftmost mutex)))
       (if (##eq? leftmost mutex)
         (begin
           (macro-btq-unlink! mutex #f)
           (##void))
         (##mutex-signal! mutex leftmost #f)))))

(##define-macro (macro-mutex-unlock-no-reschedule! mutex)
  `(let ((mutex ,mutex))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-remove! mutex)
     (let ((leftmost (macro-btq-leftmost mutex)))
       (if (##eq? leftmost mutex)
         (begin
           (macro-btq-unlink! mutex #f)
           (##void))
         (##mutex-signal-no-reschedule! mutex leftmost #f)))))

;;; Representation of condition variables.

(define-type condition-variable
  id: 6bd864f0-27ec-4639-8044-cf7c0135d716
  type-exhibitor: macro-type-condvar
  constructor: macro-construct-condvar
  implementer: implement-type-condvar
  predicate: macro-condvar?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 2 are for maintaining this condition variable in a deq of btqs
  ;; fields 3 to 5 are for maintaining a queue of blocked threads
  ;; field 6 is the leftmost thread in the queue of blocked threads
  ;; field 7 is the owner of the condition variable
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: #f)

  (name
   macro-condvar-name
   macro-condvar-name-set!)
  (specific
   macro-condvar-specific
   macro-condvar-specific-set!)
)

(##define-macro (macro-make-condvar name)
  `(let ((name ,name))
     (let ((condvar (macro-construct-condvar name (##void))))
       (macro-btq-deq-init! condvar)
       (macro-btq-init! condvar)
       condvar)))

;;; Representation of thread groups.

(define-type thread-group
  id: 713f0ba8-1d76-4a68-8dfa-eaebd4aef1e3
  type-exhibitor: macro-type-tgroup
  constructor: macro-construct-tgroup
  implementer: implement-type-tgroup
  predicate: macro-tgroup?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  (tgroups-deq-next
   macro-tgroup-tgroups-deq-next
   macro-tgroup-tgroups-deq-next-set!)
  (tgroups-deq-prev
   macro-tgroup-tgroups-deq-prev
   macro-tgroup-tgroups-deq-prev-set!)
  (tgroups
   macro-tgroup-tgroups
   macro-tgroup-tgroups-set!)
  (parent
   macro-tgroup-parent
   macro-tgroup-parent-set!)
  (name
   macro-tgroup-name
   macro-tgroup-name-set!)
  (suspend-condvar
   macro-tgroup-suspend-condvar
   macro-tgroup-suspend-condvar-set!)
  (unused1
   macro-tgroup-unused1
   macro-tgroup-unused1-set!)
  (unused2
   macro-tgroup-unused2
   macro-tgroup-unused2-set!)
  (unused3
   macro-tgroup-unused3
   macro-tgroup-unused3-set!)
  (unused4
   macro-tgroup-unused4
   macro-tgroup-unused4-set!)
  (unused5
   macro-tgroup-unused5
   macro-tgroup-unused5-set!)
  (threads-deq-next
   macro-tgroup-threads-deq-next
   macro-tgroup-threads-deq-next-set!)
  (threads-deq-prev
   macro-tgroup-threads-deq-prev
   macro-tgroup-threads-deq-prev-set!)
)

(##define-macro (macro-make-tgroup name parent)
  `(let ((name ,name) (parent ,parent))
     (let* ((tgroups
             (##vector #f #f #f))
            (tgroup
             (macro-construct-tgroup
              #f
              #f
              tgroups
              parent
              name
              #f
              #f
              #f
              #f
              #f
              #f
              #f
              #f)))
       (macro-tgroup-tgroups-deq-init! tgroups)
       (macro-tgroup-threads-deq-init! tgroup)
       (if parent
         (macro-tgroup-tgroups-deq-insert!
          (macro-tgroup-tgroups parent)
          tgroup))
       tgroup)))

(##define-macro (macro-tgroup-tgroups-deq-init! deq)
  `(let ((deq ,deq))

     (##declare (not interrupts-enabled))

     (macro-tgroup-tgroups-deq-next-set! deq deq)
     (macro-tgroup-tgroups-deq-prev-set! deq deq)))

(##define-macro (macro-tgroup-tgroups-deq-remove! item)
  `(let ((item ,item))

     (##declare (not interrupts-enabled))

     (let ((item-next (macro-tgroup-tgroups-deq-next item))
           (item-prev (macro-tgroup-tgroups-deq-prev item)))
       (macro-tgroup-tgroups-deq-next-set! item-prev item-next)
       (macro-tgroup-tgroups-deq-prev-set! item-next item-prev))))

(##define-macro (macro-tgroup-tgroups-deq-insert! deq item)
  `(let ((deq ,deq) (item ,item))

     (##declare (not interrupts-enabled))

     ;; add item to tail of deq

     (let ((deq-last (macro-tgroup-tgroups-deq-prev deq)))
       (macro-tgroup-tgroups-deq-next-set! deq-last item)
       (macro-tgroup-tgroups-deq-prev-set! deq item)
       (macro-tgroup-tgroups-deq-next-set! item deq)
       (macro-tgroup-tgroups-deq-prev-set! item deq-last))))

(##define-macro (macro-tgroup-threads-deq-init! deq)
  `(let ((deq ,deq))

     (##declare (not interrupts-enabled))

     (macro-tgroup-threads-deq-next-set! deq deq)
     (macro-tgroup-threads-deq-prev-set! deq deq)))

(##define-macro (macro-tgroup-threads-deq-remove! item)
  `(let ((item ,item))

     (##declare (not interrupts-enabled))

     (let ((item-next (macro-tgroup-threads-deq-next item))
           (item-prev (macro-tgroup-threads-deq-prev item)))
       (macro-tgroup-threads-deq-next-set! item-prev item-next)
       (macro-tgroup-threads-deq-prev-set! item-next item-prev))))

(##define-macro (macro-tgroup-threads-deq-insert! deq item)
  `(let ((deq ,deq) (item ,item))

     (##declare (not interrupts-enabled))

     ;; add item to tail of deq

     (let ((deq-last (macro-tgroup-threads-deq-prev deq)))
       (macro-tgroup-threads-deq-next-set! deq-last item)
       (macro-tgroup-threads-deq-prev-set! deq item)
       (macro-tgroup-threads-deq-next-set! item deq)
       (macro-tgroup-threads-deq-prev-set! item deq-last))))

;;; Representation of the run queue.

(define-type run-queue
  id: 2dbd1deb-107f-4730-a7ba-c191bcf132fe
  type-exhibitor: macro-type-run-queue
  constructor: macro-construct-run-queue
  implementer: implement-type-run-queue
  predicate: macro-run-queue?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 2 are the deq links of blocking device condvars
  ;; fields 3 to 5 are for maintaining a queue of runnable threads
  ;; field 6 is the leftmost thread in the queue of runnable threads
  ;; field 7 must be #f (the queue of runnable threads has no owner)
  ;; fields 8 to 10 are for maintaining a timeout queue of threads
  ;; field 11 is the leftmost thread in the timeout queue of threads
  ;; field 14 is for storing the current time, heartbeat interval and a
  ;; temporary float
  condvar-deq-next
  condvar-deq-prev
  btq-color
  btq-parent
  btq-left
  btq-leftmost
  false
  toq-color
  toq-parent
  toq-left
  toq-leftmost
  primordial-thread
  unused
  floats
)

(##define-macro (macro-current-time f)             `(##f64vector-ref ,f 0))
(##define-macro (macro-current-time-set! f x)      `(##f64vector-set! ,f 0 ,x))
(##define-macro (macro-heartbeat-interval f)       `(##f64vector-ref ,f 1))
(##define-macro (macro-heartbeat-interval-set! f x)`(##f64vector-set! ,f 1 ,x))
(##define-macro (macro-temp f)                     `(##f64vector-ref ,f 2))
(##define-macro (macro-temp-set! f x)              `(##f64vector-set! ,f 2 ,x))

(##define-macro (macro-update-current-time!)
  `(##get-current-time! (macro-thread-floats (macro-run-queue))))

(##define-macro (macro-make-run-queue)
  `(let ((run-queue
          (macro-construct-run-queue
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           (##f64vector (macro-inexact-+0)
                        (macro-inexact-+0)
                        (macro-inexact-+0)))))
     (macro-btq-deq-init! run-queue)
     (macro-btq-init! run-queue)
     (macro-toq-init! run-queue)
     run-queue))

;;; Representation of thread states.

(define-library-type thread-state-uninitialized
  id: c63af440-d5ef-4f02-8fe6-40836a312fae
  constructor: #f
  opaque:
)

(define-library-type thread-state-initialized
  id: 47368926-951d-4451-92b0-dd9b4132eca9
  constructor: #f
  opaque:
)

(define-library-type thread-state-normally-terminated
  id: c475ff99-c959-4784-a847-b0c52aff8f2a
  constructor: #f
  opaque:

  (result printable: read-only:)
)

(define-library-type thread-state-abnormally-terminated
  id: 291e311e-93e0-4765-8132-56a719dc84b3
  constructor: #f
  opaque:

  (reason printable: read-only:)
)

(define-library-type thread-state-active
  id: dc963fdc-4b54-45a2-8af6-01654a6dc6cd
  constructor: #f
  opaque:

  (waiting-for printable: read-only:)
  (timeout    printable: read-only:)
)

;;;============================================================================
