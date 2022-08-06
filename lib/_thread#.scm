;;;============================================================================

;;; File: "_thread#.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(cond-expand (enable-smp

;;;============================================================================

;;; For SMP thread scheduler.

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

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception noncontinuable-exception
  id: 1bcc14ff-4be5-4573-a250-729b773bdd50
  constructor: #f
  opaque:

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception initialized-thread-exception
  id: e38351db-bef7-4c30-b610-b9b271e99ec3
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception uninitialized-thread-exception
  id: 71831161-39c1-4a10-bb79-04342e1981c3
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception inactive-thread-exception
  id: 339af4ff-3d44-4bec-a90b-d981fd13834d
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception started-thread-exception
  id: ed07bce3-b882-4737-ac5e-3035b7783b8a
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception terminated-thread-exception
  id: 85f41657-8a51-4690-abef-d76dc37f4465
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception uncaught-exception
  id: 7022e42c-4ecb-4476-be40-3ca2d45903a7
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
  (reason    unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception join-timeout-exception
  id: 7af7ca4a-ecca-445f-a270-de9d45639feb
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception mailbox-receive-timeout-exception
  id: 5f13e8c4-2c68-4eb5-b24d-249a9356c918
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception rpc-remote-error-exception
  id: 6469e5eb-3117-4c29-89df-c348479dac93
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
  (message   unprintable: read-only: no-functional-setter:)
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

(define-check-type vm 'vm
  macro-vm?)

(define-check-type processor 'processor
  macro-processor?)

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

(##define-macro (macro-started-thread? thread)
  `(##not (##eq? 'not-started (macro-thread-exception? ,thread))))

(##define-macro (macro-terminated-thread-given-initialized? thread)
  `(##not (macro-thread-end-condvar ,thread)))

(##define-macro (macro-check-initialized-thread thread form expr)
  `(if (##not (macro-initialized-thread? ,thread))
       (begin
         (macro-unlock-thread! ,thread)
         (##raise-uninitialized-thread-exception ,@form))
       ,expr))

(##define-macro (macro-check-not-initialized-thread thread form expr)
  `(if (macro-initialized-thread? ,thread)
       (begin
         (macro-unlock-thread! ,thread)
         (##raise-initialized-thread-exception ,@form))
       ,expr))

(##define-macro (macro-check-not-started-thread thread form expr)
  `(if (macro-started-thread? ,thread)
       (begin
         (macro-unlock-thread! ,thread)
         (##raise-started-thread-exception ,@form))
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
                 implementer
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
                 length
                 length-set!
                 leftmost
                 leftmost-set!
                 rightmost
                 rightmost-set!
                 container
                 container-set!)

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

  (define (def-insert!)
    `(define-prim (,insert! rbtree node)

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

       ,@(if length
             `((,length-set! rbtree (##fx+ (,length rbtree) 1)))
             `())

       ,@(if container-set!
             `((,container-set! node rbtree))
             `())

       (,(reden!) node)
       (,left-set! node rbtree)
       (,right-set! node rbtree)

       (insert-left! (,left rbtree) rbtree)

       (,parent-set! rbtree rbtree)))

  (define (def-remove!)
    `(define-prim (,remove! node)

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

         ,@(if length
               `((,length-set! rbtree (##fx- (,length rbtree) 1)))
               `())

         ,@(if container-set!
               `((,container-set! node #f))
               `())

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

         (,parent-set! rbtree rbtree))))

  (define (def-reposition!)
    `(define-prim (,reposition! node)

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
             (,insert! rbtree node))))))

  `(begin

     (##define-macro (,rbtree-init! rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          ,@',(if leftmost
                `((,leftmost-set! rbtree rbtree))
                `())

          ,@',(if rightmost
                `((,rightmost-set! rbtree rbtree))
                `())

          ,@',(if length
                `((,length-set! rbtree 0))
                `())

          (,',(blacken! 'rbtree) rbtree)
          (,',parent-set! rbtree rbtree)
          (,',left-set! rbtree rbtree)))

     (##define-macro (,node->rbtree node)
       (if ',container

           `(let ((node ,node))

              (##declare (not interrupts-enabled))

              (,',container node))

           `(let ((node ,node))

              (##declare (not interrupts-enabled))

              (or (,',color node)
                  (let ((parent-node (,',parent node)))
                    (and parent-node ;; make sure node is in a rbtree
                         (,',color parent-node)))))))

     (##define-macro (,singleton? rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          (let ((root (,',left rbtree)))
            (and (##not (##eq? root rbtree))
                 (##eq? (,',left root) rbtree)
                 (##eq? (,',right root) rbtree)
                 root))))

     (##define-macro (,implementer)
       `(begin
          ,',(def-insert!)
          ,',(def-remove!)
          ,',(def-reposition!)))))

;;;----------------------------------------------------------------------------

;;; Double-ended-queue generator macro.

(##define-macro (define-deq
                 init!
                 insert-at-head!
                 insert-at-tail!
                 remove!
                 empty?
                 head
                 tail
                 next
                 next-set!
                 prev
                 prev-set!)

  `(begin

     (##define-macro (,init! deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Initialize a deq.

          (,',next-set! deq deq)
          (,',prev-set! deq deq)))

     (##define-macro (,insert-at-head! deq item)
       `(let ((deq ,deq) (item ,item))

          (##declare (not interrupts-enabled))

          ;; Add item to head of deq.

          (let ((deq-first (,',next deq)))
            (,',next-set! item deq-first)
            (,',prev-set! item deq)
            (,',next-set! deq item)
            (,',prev-set! deq-first item))))

     (##define-macro (,insert-at-tail! deq item)
       `(let ((deq ,deq) (item ,item))

          (##declare (not interrupts-enabled))

          ;; Add item to tail of deq.

          (let ((deq-last (,',prev deq)))
            (,',next-set! deq-last item)
            (,',prev-set! deq item)
            (,',next-set! item deq)
            (,',prev-set! item deq-last))))

     (##define-macro (,remove! item)
       `(let ((item ,item))

          (##declare (not interrupts-enabled))

          ;; Remove an item from the deq containing it.

          (let ((item-next (,',next item))
                (item-prev (,',prev item)))
            (,',next-set! item-prev item-next)
            (,',prev-set! item-next item-prev))))

     (##define-macro (,empty? deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Test if deq is empty.

          (##eq? (,',next deq) deq)))

     (##define-macro (,head deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Get head of non-empty deq.

          (,',next deq)))

     (##define-macro (,tail deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Get tail of non-empty deq.

          (,',prev deq)))))

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

(##define-macro (macro-make-parameter-descr value hash set-filter get-filter)
  `(##vector ,value ,hash ,set-filter ,get-filter))

(##define-macro (macro-parameter-descr-value p)         `(macro-slot 0 ,p))
(##define-macro (macro-parameter-descr-value-set! p x)  `(macro-slot 0 ,p ,x))
(##define-macro (macro-parameter-descr-hash p)          `(macro-slot 1 ,p))
(##define-macro (macro-parameter-descr-hash-set! p x)   `(macro-slot 1 ,p ,x))
(##define-macro (macro-parameter-descr-set-filter p)    `(macro-slot 2 ,p))
(##define-macro (macro-parameter-descr-set-filter-set! p x) `(macro-slot 2 ,p ,x))
(##define-macro (macro-parameter-descr-get-filter p)    `(macro-slot 3 ,p))
(##define-macro (macro-parameter-descr-get-filter-set! p x) `(macro-slot 3 ,p ,x))

;;; Binding of special dynamic variables.

(##define-macro (macro-denv-set denv var val)
  `(let ((denv ,denv) (val ,val))

     (##declare (not interrupts-enabled))

     (macro-make-denv
      (macro-denv-local denv)
      ,(if (eq? var 'dynwind)
           `val
           `(macro-denv-dynwind denv))
      ,(if (eq? var 'interrupt-mask)
           `val
           `(macro-denv-interrupt-mask denv))
      ,(if (eq? var 'debugging-settings)
           `val
           `(macro-denv-debugging-settings denv))
      ,(if (eq? var 'exception-handler)
           `(##cons ##current-exception-handler val)
           `(macro-denv-exception-handler denv))
      ,(if (eq? var 'input-port)
           `(##cons ##current-input-port val)
           `(macro-denv-input-port denv))
      ,(if (eq? var 'output-port)
           `(##cons ##current-output-port val)
           `(macro-denv-output-port denv))
      ,(if (eq? var 'repl-context)
           `(##cons #f val)
           `(macro-denv-repl-context denv)))))

(##define-macro (macro-dynamic-bind var val thunk)
  `(##dynamic-env-bind
    (macro-denv-set (macro-thread-denv (macro-current-thread)) ,var ,val)
    ,thunk))

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
     (##declare
      (not safe) ;; avoid procedure check on the call to the handler
      (interrupts-enabled)) ;; make sure exceptions can be interrupted
     (if (macro-current-thread)
         ((macro-current-exception-handler) obj)
         (##exit-with-exception obj)))) ;; exit when exception is raised
                                        ;; before thread system is initialized

(##define-macro (macro-abort obj)
  `(let ((obj ,obj))
     (macro-raise obj)
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
  no-functional-setter:

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
  (exact->inexact 0))

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

(##define-macro (macro-btq-lock1 node)          `(macro-struct-slot 1 ,node))
(##define-macro (macro-btq-lock1-set! node x)   `(macro-struct-slot 1 ,node ,x))
(##define-macro (macro-btq-deq-next node)       `(macro-struct-slot 2 ,node))
(##define-macro (macro-btq-deq-next-set! node x)`(macro-struct-slot 2 ,node ,x))
(##define-macro (macro-btq-deq-prev node)       `(macro-struct-slot 3 ,node))
(##define-macro (macro-btq-deq-prev-set! node x)`(macro-struct-slot 3 ,node ,x))
(##define-macro (macro-btq-color node)          `(macro-struct-slot 4 ,node))
(##define-macro (macro-btq-color-set! node x)   `(macro-struct-slot 4 ,node ,x))
(##define-macro (macro-btq-parent node)         `(macro-struct-slot 5 ,node))
(##define-macro (macro-btq-parent-set! node x)  `(macro-struct-slot 5 ,node ,x))
(##define-macro (macro-btq-left node)           `(macro-struct-slot 6 ,node))
(##define-macro (macro-btq-left-set! node x)    `(macro-struct-slot 6 ,node ,x))
(##define-macro (macro-btq-right node)          `(macro-struct-slot 7 ,node))
(##define-macro (macro-btq-right-set! node x)   `(macro-struct-slot 7 ,node ,x))
(##define-macro (macro-btq-leftmost node)       `(macro-struct-slot 7 ,node))
(##define-macro (macro-btq-leftmost-set! node x)`(macro-struct-slot 7 ,node ,x))
(##define-macro (macro-btq-owner node)          `(macro-struct-slot 8 ,node))
(##define-macro (macro-btq-owner-set! node x)   `(macro-struct-slot 8 ,node ,x))
(##define-macro (macro-btq-lock2 node)          `(macro-struct-slot 9 ,node))
(##define-macro (macro-btq-lock2-set! node x)   `(macro-struct-slot 9 ,node ,x))

(define-rbtree
 implement-btq
 macro-btq-init!
 macro-thread->btq
 ##btq-insert!
 ##btq-remove!
 ##btq-reposition!
 macro-btq-singleton?
 macro-btq-color
 macro-btq-color-set!
 macro-btq-parent
 macro-btq-parent-set!
 macro-btq-left
 macro-btq-left-set!
 macro-btq-right
 macro-btq-right-set!
 macro-thread-higher-prio?
 #f
 #f
 macro-btq-leftmost
 macro-btq-leftmost-set!
 #f
 #f
 macro-thread-btq-container
 macro-thread-btq-container-set!
)

(macro-define-syntax macro-if-btq-next
  (lambda (stx)
    (syntax-case stx ()
      ((_ btq next yes)
       #'(let* ((next (macro-btq-leftmost btq)))
           (if (##not (##eq? next btq))
               yes)))
      ((_ btq next yes no)
       #'(let* ((next (macro-btq-leftmost btq)))
           (if (##not (##eq? next btq))
               yes
               no))))))

(##define-macro (macro-lock-btq! btq)    `(##primitive-lock! ,btq 1 9))
(##define-macro (macro-trylock-btq! btq) `(##primitive-trylock! ,btq 1 9))
(##define-macro (macro-unlock-btq! btq)  `(##primitive-unlock! ,btq 1 9))

(##define-macro (macro-lock-toq! toq)    `(##primitive-lock! ,toq 1 9))
(##define-macro (macro-trylock-toq! toq) `(##primitive-trylock! ,toq 1 9))
(##define-macro (macro-unlock-toq! toq)  `(##primitive-unlock! ,toq 1 9))

(##define-macro (macro-lock-mutex! mutex)    `(macro-lock-btq! ,mutex))
(##define-macro (macro-trylock-mutex! mutex) `(macro-trylock-btq! ,mutex))
(##define-macro (macro-unlock-mutex! mutex)  `(macro-unlock-btq! ,mutex))

(##define-macro (macro-lock-condvar! condvar)    `(macro-lock-btq! ,condvar))
(##define-macro (macro-trylock-condvar! condvar) `(macro-trylock-btq! ,condvar))
(##define-macro (macro-unlock-condvar! condvar)  `(macro-unlock-btq! ,condvar))

(##define-macro (macro-lock-thread! thread)    `(macro-lock-btq! ,thread))
(##define-macro (macro-trylock-thread! thread) `(macro-trylock-btq! ,thread))
(##define-macro (macro-unlock-thread! thread)  `(macro-unlock-btq! ,thread))

(##define-macro (macro-lock-tgroup! tgroup)    `(macro-lock-btq! ,tgroup))
(##define-macro (macro-trylock-tgroup! tgroup) `(macro-trylock-btq! ,tgroup))
(##define-macro (macro-unlock-tgroup! tgroup)  `(macro-unlock-btq! ,tgroup))

(##define-macro (macro-lock-processor! proc)    `(macro-lock-btq! ,proc))
(##define-macro (macro-trylock-processor! proc) `(macro-trylock-btq! ,proc))
(##define-macro (macro-unlock-processor! proc)  `(macro-unlock-btq! ,proc))

(##define-macro (macro-lock-vm! vm)    `(macro-lock-btq! ,vm))
(##define-macro (macro-trylock-vm! vm) `(macro-trylock-btq! ,vm))
(##define-macro (macro-unlock-vm! vm)  `(macro-unlock-btq! ,vm))

;;; Define operations on blocked thread queue double-ended-queues.

(define-deq
 macro-btq-deq-init!
 macro-btq-deq-insert-at-head!
 macro-btq-deq-insert-at-tail!
 macro-btq-deq-remove!
 macro-btq-deq-empty?
 macro-btq-deq-head
 macro-btq-deq-tail
 macro-btq-deq-next
 macro-btq-deq-next-set!
 macro-btq-deq-prev
 macro-btq-deq-prev-set!)

(##define-macro (macro-btq-link! mutex thread)
  `(let ((mutex ,mutex) (thread ,thread))

     (##declare (not interrupts-enabled))

     ;; Add the mutex to the set of mutexes owned by the thread
     ;; and remember which thread owns the mutex.
     ;;
     ;; Assumes that the mutex's low-level lock is acquired and
     ;; the thread's low-level lock is acquired.

     (macro-btq-deq-insert-at-tail! thread mutex)
     (macro-btq-owner-set! mutex thread)))

(##define-macro (macro-btq-unlink! mutex state)
  `(let ((mutex ,mutex) (state ,state))

     (##declare (not interrupts-enabled))

     ;; Cleanup deq links of the mutex and set the new mutex state.
     ;;
     ;; Assumes that the mutex's low-level lock is acquired.

     (macro-btq-deq-init! mutex)
     (macro-btq-owner-set! mutex state)))

;;; Representation of timeout queues.

(##define-macro (macro-toq-color node)         `(macro-struct-slot 10 ,node))
(##define-macro (macro-toq-color-set! node x)  `(macro-struct-slot 10 ,node ,x))
(##define-macro (macro-toq-parent node)        `(macro-struct-slot 11 ,node))
(##define-macro (macro-toq-parent-set! node x) `(macro-struct-slot 11 ,node ,x))
(##define-macro (macro-toq-left node)          `(macro-struct-slot 12 ,node))
(##define-macro (macro-toq-left-set! node x)   `(macro-struct-slot 12 ,node ,x))
(##define-macro (macro-toq-right node)         `(macro-struct-slot 13 ,node))
(##define-macro (macro-toq-right-set! node x)  `(macro-struct-slot 13 ,node ,x))
(##define-macro (macro-toq-leftmost node)      `(macro-struct-slot 13 ,node))
(##define-macro (macro-toq-leftmost-set! node x)`(macro-struct-slot 13 ,node ,x))

(define-rbtree
 implement-toq
 macro-toq-init!
 macro-thread->toq
 ##toq-insert!
 ##toq-remove!
 ##toq-reposition!
 macro-toq-singleton?
 macro-toq-color
 macro-toq-color-set!
 macro-toq-parent
 macro-toq-parent-set!
 macro-toq-left
 macro-toq-left-set!
 macro-toq-right
 macro-toq-right-set!
 macro-thread-sooner-or-simultaneous-and-higher-prio?
 #f
 #f
 macro-toq-leftmost
 macro-toq-leftmost-set!
 #f
 #f
 macro-thread-toq-container
 macro-thread-toq-container-set!
)

(macro-define-syntax macro-if-toq-next
  (lambda (stx)
    (syntax-case stx ()
      ((_ toq next yes)
       #'(let* ((next (macro-toq-leftmost toq)))
           (if (##not (##eq? next toq))
               yes)))
      ((_ toq next yes no)
       #'(let* ((next (macro-toq-leftmost toq)))
           (if (##not (##eq? next toq))
               yes
               no))))))

;;; Representation of threads.

;; The state of a thread is determined by the content of the
;; "end-condvar", "exception?" and "result" fields:
;;
;;  thread state               "end-condvar" "exception?" "result"
;;  not yet started            condvar       'not-started #f
;;  started                    condvar       #f           #f
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

  (lock1            init: 0)

  (btq-deq-next     init: #f) ;; blocked thread queues owned by thread
  (btq-deq-prev     init: #f)

  (btq-color        init: #f) ;; to keep thread in a blocked thread queue
  (btq-parent       init: #f)
  (btq-left         init: #f)
  (btq-leftmost     init: #f)

  (tgroup           init: #f) ;; thread-group this thread belongs to

  (lock2            init: 0)

  (toq-color        init: #f) ;; to keep thread in a timeout queue
  (toq-parent       init: #f)
  (toq-left         init: #f)
  (toq-leftmost     init: #f)

  (threads-deq-next init: #f) ;; threads in this thread group
  (threads-deq-prev init: #f)

  (floats           init: #f)

  (btq-container    init: #f) ;; processor, mutex or condvar whose blocked thread queue contains this thread or #f

  (toq-container    init: #f) ;; processor whose timeout queue contains this thread or #f

  (name             init: #f)
  (end-condvar      init: #f)
  (exception?       init: 'not-started)
  (result           init: #f)
  (cont             init: #f)
  (denv             init: #f)
  (denv-cache1      init: #f)
  (denv-cache2      init: #f)
  (denv-cache3      init: #f)
  (repl-channel     init: #f)
  (mailbox          init: #f)
  (specific         init: '#!void)
  (resume-thunk     init: #f)
  (interrupts-head  init: '())
  (interrupts-tail  init: '())
  (last-processor   init: #f)
  (pinned           init: #f)
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
  `(macro-make-continuation (macro-end-of-cont-marker) #f))

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
       (macro-thread-resume-thunk-set! thread
        (lambda ()
          (##thread-execute-and-end! thunk)))
       (macro-thread-cont-set! thread (macro-make-thread-cont p))
       (macro-thread-denv-set! thread (macro-make-thread-denv p))
       (macro-thread-denv-cache1-set! thread (macro-make-thread-denv-cache1 p))
       (macro-thread-denv-cache2-set! thread (macro-make-thread-denv-cache2 p))
       (macro-thread-denv-cache3-set! thread (macro-make-thread-denv-cache3 p))
       (macro-btq-deq-init! thread)
       (macro-lock-tgroup! tgroup)
       (macro-tgroup-threads-deq-insert-at-tail! tgroup thread)
       (macro-unlock-tgroup! tgroup)
       (macro-thread-last-processor-set! thread (macro-current-processor))
       thread)))

(##define-macro (macro-make-thread thunk name tgroup)
  `(let ((thunk ,thunk) (name ,name) (tgroup ,tgroup))

     (##declare (not interrupts-enabled))

     (macro-thread-init! (macro-construct-thread) thunk name tgroup)))

(##define-macro (macro-thread-btq-remove-if-in-btq! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     ;; Assumes that the thread's low-level lock is acquired.

     (let ((parent (macro-btq-parent thread)))
       (if parent
           (begin

             ;; btq is either a mutex or a condition variable

             ;;TODO: find way to combine the btq lock!/unlock! with caller
             (let ((btq (macro-thread->btq thread)))
               ;;TODO: don't busy wait!
               (let loop ()
                 (if (##not (macro-trylock-btq! btq))
                     (begin
                       ;;(##c-code "printf(\"macro-thread-btq-remove-if-in-btq! couldn't lock btq...\\n\");");;TODO: remove
                       (loop))))
               (##thread-btq-remove! thread)
               (macro-unlock-btq! btq)))))))

(##define-macro (macro-thread-toq-remove-if-in-toq! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     ;; Assumes that the thread's low-level lock is acquired.

     (let ((parent (macro-toq-parent thread)))
       (if parent
           (begin

             ;; toq is a processor

             ;;TODO: find way to combine the toq lock!/unlock! with caller
             (let ((toq (macro-thread->toq thread)))
               (macro-lock-toq! toq)
               (##thread-toq-remove! thread)
               (macro-unlock-toq! toq)))))))

(##define-macro (macro-thread-reschedule-if-needed!)
  `(let ()

     (##declare (not interrupts-enabled))

     ;;TODO: update this (running threads are no longer in the current-processor)
     (##void)#;
     (let ((leftmost (macro-btq-leftmost (macro-current-processor))))
       (if (##not (##eq? leftmost (macro-current-thread)))
         (##thread-reschedule!)
         (##void)))))

(macro-define-syntax macro-thread-save!
  (lambda (stx)
    (syntax-case stx ()
      ((_ proc args ...)
       #'(##thread-save! proc args ...)))))

(macro-define-syntax macro-thread-restore!
  (lambda (stx)
    (syntax-case stx ()
      ((_ thread proc args ...)
       #'(##thread-restore! thread proc args ...)))))

(##define-macro (macro-primordial-thread)
  `##primordial-thread)

(##define-macro (macro-current-thread)
  `(##current-thread))

(##define-macro (macro-lock-current-thread!)
  `(macro-lock-thread! (macro-current-thread)))

(##define-macro (macro-unlock-current-thread!)
  `(macro-unlock-thread! (macro-current-thread)))

(##define-macro (macro-current-processor)
  `(##current-processor))

(##define-macro (macro-lock-current-processor!)
  `(macro-lock-processor! (macro-current-processor)))

(##define-macro (macro-unlock-current-processor!)
  `(macro-unlock-processor! (macro-current-processor)))

(##define-macro (macro-current-vm)
  `(##current-vm))

(##define-macro (macro-lock-current-vm!)
  `(macro-lock-vm! (macro-current-vm)))

(##define-macro (macro-trylock-current-vm!)
  `(macro-trylock-vm! (macro-current-vm)))

(##define-macro (macro-unlock-current-vm!)
  `(macro-unlock-vm! (macro-current-vm)))

(##define-macro (macro-primordial-exception-handler)
  `##primordial-exception-handler)

(##define-macro (macro-thread-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##fl< (macro-effective-priority floats2) ;; high priority first
              (macro-effective-priority floats1)))))

(##define-macro (macro-thread-sooner? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##fl< (macro-timeout floats1)
              (macro-timeout floats2)))))

(##define-macro (macro-thread-sooner-or-simultaneous-and-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (if (##not (##fl= (macro-timeout floats1)
                         (macro-timeout floats2)))
         (##fl< (macro-timeout floats1)
                (macro-timeout floats2))
         (##fl< (macro-effective-priority floats2) ;; high priority first
                (macro-effective-priority floats1))))))

(##define-macro (macro-thread-boost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##fl= (##fl+ (macro-base-priority floats)
                                (macro-priority-boost floats))
                         (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-current-processor))
            (macro-boosted-priority floats))

           (macro-boosted-priority-set!
            floats
            (##fl+ (macro-base-priority floats)
                   (macro-priority-boost floats)))

            (##thread-boosted-priority-changed! thread))))))

(##define-macro (macro-thread-unboost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##fl= (macro-base-priority floats)
                         (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-current-processor))
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
       (if (##fl< (macro-effective-priority thread-floats)
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

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are for maintaining this mutex in a deq of btqs
  ;; fields 4 to 6 are for maintaining a queue of blocked threads
  ;; field 7 is the leftmost thread in the queue of blocked threads
  ;; field 8 is the owner of the mutex (or 'not-owned or 'abandoned
  ;; or 'not-abandoned)
  (lock1        init: 0)
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: 'not-abandoned) ;; see (macro-mutex-state-not-abandoned)
  (lock2        init: 0)

  (name
   macro-mutex-name
   macro-mutex-name-set!)
  (specific
   macro-mutex-specific
   macro-mutex-specific-set!)
)

;; Mutex states (aside from "owned")

(##define-macro (macro-mutex-state-not-owned)     ''not-owned)
(##define-macro (macro-mutex-state-abandoned)     ''abandoned)
(##define-macro (macro-mutex-state-not-abandoned) ''not-abandoned)

(##define-macro (macro-mutex-thread-owner? owner)
  `(##not (##symbol? ,owner)))

(##define-macro (macro-make-mutex name)
  `(let ((name ,name))
     (let ((mutex (macro-construct-mutex name (##void))))
       (macro-btq-deq-init! mutex)
       (macro-btq-init! mutex)
       mutex)))

(##define-macro (macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? mutex)
  `(##eq? (macro-btq-owner ,mutex)
          (macro-mutex-state-not-abandoned)))

(##define-macro (macro-mutex-lock! mutex absrel-timeout new-owner)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout) (new-owner ,new-owner))

     (##declare (not interrupts-enabled))

     ;; The call
     ;;
     ;;   (macro-mutex-lock! mutex absrel-timeout new-owner)
     ;;
     ;; where new-owner is a thread, has the same effect as
     ;;
     ;;   (begin
     ;;     (macro-lock-mutex! mutex)
     ;;     (macro-lock-thread! new-owner)
     ;;     (##mutex-lock-out-of-line! mutex absrel-timeout new-owner))
     ;;
     ;; However, the macro special cases the situation where the mutex's
     ;; state is unlocked/not-abandoned, allowing this common situation
     ;; to be handled without a function call.

     (##check-heap-limit) ;; prevent GC while mutex is locked

     ;; acquire low-level lock of mutex
     (macro-lock-mutex! mutex)

     ;; acquire low-level lock of thread
     (macro-lock-thread! new-owner)

     (let ((owner (macro-btq-owner mutex)))
       (if (and (##eq? owner (macro-mutex-state-not-abandoned))
                (##not (macro-terminated-thread-given-initialized? new-owner)))
           (begin

             ;; Fast path... the mutex's state is unlocked/not-abandoned.

             ;; thread becomes the mutex's owner
             (macro-btq-link! mutex new-owner)

             ;; release low-level lock of thread
             (macro-unlock-thread! new-owner)

             ;; release low-level lock of mutex
             (macro-unlock-mutex! mutex)

             #t) ;; signal success

           (begin

             ;; Slow path... the mutex's state is not unlocked/not-abandoned.

             ;; handle this case out of line
             (##mutex-lock-out-of-line! mutex absrel-timeout new-owner))))))

(##define-macro (macro-mutex-lock-anonymously! mutex absrel-timeout)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout))

     (##declare (not interrupts-enabled))

     ;; The call
     ;;
     ;;   (macro-mutex-lock-anonymously! mutex absrel-timeout)
     ;;
     ;; has the same effect as the call
     ;;
     ;;   (begin
     ;;     (macro-lock-mutex! mutex)
     ;;     (##mutex-lock-anonymously-out-of-line! mutex absrel-timeout))
     ;;
     ;; However, the macro special cases the situation where the mutex's
     ;; state is unlocked/not-abandoned, allowing this common situation
     ;; to be handled without a function call.

     (##check-heap-limit) ;; prevent GC while mutex is locked

     ;; acquire low-level lock of mutex
     (macro-lock-mutex! mutex)

     (let ((owner (macro-btq-owner mutex)))
       (if (##eq? owner (macro-mutex-state-not-abandoned))

           (begin

             ;; Fast path... the mutex's state is unlocked/not-abandoned.

             ;; change the mutex's state to not-owned
             (macro-btq-owner-set! mutex (macro-mutex-state-not-owned))

             ;; release low-level lock of mutex
             (macro-unlock-mutex! mutex)

             #t) ;; signal success

           (begin

             ;; Slow path... the mutex's state is not unlocked/not-abandoned.

             ;; handle this case out of line
             (##mutex-lock-anonymously-out-of-line! mutex absrel-timeout))))))

(##define-macro (macro-mutex-unlock! mutex)
  `(let ((mutex ,mutex))

     (##declare (not interrupts-enabled))

     (##check-heap-limit) ;; prevent GC while mutex is locked

     ;; acquire low-level lock of mutex
     (macro-lock-mutex! mutex)

     ;; get first waiting thread
     (macro-if-btq-next
      mutex
      first-thread

      (begin

        ;; Slow path... at least one thread is waiting on the mutex.

        ;; handle this case out of line
        (##mutex-unlock-out-of-line! mutex first-thread))

      (begin

        ;; Fast path... there are no threads waiting on the mutex.

        (let ((owner (macro-btq-owner mutex)))
          (if (macro-mutex-thread-owner? owner)

              (begin

                ;; Mutex is owned by a thread.

                ;; acquire low-level lock of owner
                (macro-lock-thread! owner)

                ;; remove mutex from the set of mutexes owned by the
                ;; thread
                (macro-btq-deq-remove! mutex)

                ;; change mutex state to unlocked/not-abandoned
                (macro-btq-unlink!
                 mutex
                 (macro-mutex-state-not-abandoned))

                ;; release low-level lock of thread
                (macro-unlock-thread! owner)

                ;; release low-level lock of mutex
                (macro-unlock-mutex! mutex)

                (##void))

              (begin

                ;; Mutex is not owned by a thread.

                ;; change mutex state to unlocked/not-abandoned
                (macro-btq-unlink!
                 mutex
                 (macro-mutex-state-not-abandoned))

                ;; release low-level lock of mutex
                (macro-unlock-mutex! mutex)

                (##void))))))))

(##define-macro (macro-mutex-unlock-no-reschedule! mutex)
  `(macro-mutex-unlock! ,mutex));;TODO: update

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

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are for maintaining this condition variable in a deq of btqs
  ;; fields 4 to 6 are for maintaining a queue of blocked threads
  ;; field 7 is the leftmost thread in the queue of blocked threads
  ;; field 8 is the owner of the condition variable
  (lock1        init: 0)
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: #f)
  (lock2        init: 0)

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

(define-type thread-groups
  id: EACE4200-EB43-4891-852A-03C7B5D385E4
  type-exhibitor: macro-type-tgroups
  constructor: macro-construct-tgroups
  implementer: implement-type-tgroups
  predicate: macro-tgroups?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  (lock1
   macro-tgroups-lock1)

  (tgroups-deq-next
   macro-tgroups-tgroups-deq-next
   macro-tgroups-tgroups-deq-next-set!)
  (tgroups-deq-prev
   macro-tgroups-tgroups-deq-prev
   macro-tgroups-tgroups-deq-prev-set!)
)

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

  (lock1
   macro-tgroup-lock1)

  (tgroups-deq-next
   macro-tgroup-tgroups-deq-next
   macro-tgroup-tgroups-deq-next-set!)
  (tgroups-deq-prev
   macro-tgroup-tgroups-deq-prev
   macro-tgroup-tgroups-deq-prev-set!)

  (tgroups
   macro-tgroup-tgroups)
  (name
   macro-tgroup-name)
  (specific
   macro-tgroup-specific
   macro-tgroup-specific-set!)

  unused-field7

  (parent ;; thread-group this thread-group belongs to
   macro-tgroup-parent)

  (lock2
   macro-tgroup-lock2)

  unused-field10
  unused-field11
  unused-field12
  unused-field13

  (threads-deq-next ;; must be at same pos as those fields in a thread
   macro-tgroup-threads-deq-next
   macro-tgroup-threads-deq-next-set!)
  (threads-deq-prev
   macro-tgroup-threads-deq-prev
   macro-tgroup-threads-deq-prev-set!)
)

(##define-macro (macro-make-tgroup name parent)
  `(let ((name ,name) (parent ,parent))
     (let* ((tgroups
             (macro-construct-tgroups #f #f #f))
            (tgroup
             (macro-construct-tgroup
              0
              #f
              #f
              tgroups
              name
              #f
              #f
              parent
              0
              #f
              #f
              #f
              #f
              #f
              #f)))
       (macro-tgroup-tgroups-deq-init! tgroups)
       (macro-tgroup-threads-deq-init! tgroup)
       (if parent
         (macro-tgroup-tgroups-deq-insert-at-tail!
          (macro-tgroup-tgroups parent)
          tgroup))
       tgroup)))

(define-deq
 macro-tgroup-tgroups-deq-init!
 macro-tgroup-tgroups-deq-insert-at-head!
 macro-tgroup-tgroups-deq-insert-at-tail!
 macro-tgroup-tgroups-deq-remove!
 macro-tgroup-tgroups-deq-empty?
 macro-tgroup-tgroups-deq-head
 macro-tgroup-tgroups-deq-tail
 macro-tgroup-tgroups-deq-next
 macro-tgroup-tgroups-deq-next-set!
 macro-tgroup-tgroups-deq-prev
 macro-tgroup-tgroups-deq-prev-set!)

(define-deq
 macro-tgroup-threads-deq-init!
 macro-tgroup-threads-deq-insert-at-head!
 macro-tgroup-threads-deq-insert-at-tail!
 macro-tgroup-threads-deq-remove!
 macro-tgroup-threads-deq-empty?
 macro-tgroup-threads-deq-head
 macro-tgroup-threads-deq-tail
 macro-tgroup-threads-deq-next
 macro-tgroup-threads-deq-next-set!
 macro-tgroup-threads-deq-prev
 macro-tgroup-threads-deq-prev-set!)

;;;----------------------------------------------------------------------------

;;; Representation of the processor state.  This is the part of the
;;; processor state that is implemented at the Scheme level (the other
;;; part of the processor state is implemented at the host language level).

;;; Note that this structure used to be called a "run queue" because it
;;; is mostly used by the scheduler to maintain the set of runnable threads.
;;; However it also includes other information which is conceptually part
;;; of the processor state.

;;; This structure is pre-allocated by the runtime system to reduce
;;; pressure on the garbage collector. For this reason, the length of
;;; the structure must match the definition of ___PROCESSOR_SIZE in
;;; include/gambit.h.in .

(define-type processor
  id: A6899D11-290C-42A6-B47A-57C6B908698F
  type-exhibitor: macro-type-processor
  constructor: macro-construct-processor
  implementer: implement-type-processor
  predicate: macro-processor?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are the deq links of blocking device condvars
  ;; fields 4 to 6 are for maintaining a queue of runnable threads
  ;; field 7 is the leftmost thread in the queue of runnable threads
  ;; field 8 must be #f (the queue of runnable threads has no owner)
  ;; fields 10 to 12 are for maintaining a timeout queue of threads
  ;; field 13 is the leftmost thread in the timeout queue of threads
  ;; field 14 is the thread currently running on this processor
  ;; field 16 is for storing the current time, heartbeat interval and a
  ;; temporary float
  ;; fields 17 and 18 are the deq links of blocked processors
  ;; field 19 is the id of the processor
  ;; field 20 is the head of the queue of pending high-level interrupts
  ;; field 21 is the tail of the queue of pending high-level interrupts
  lock1
  condvar-deq-next
  condvar-deq-prev
  btq-color
  btq-parent
  btq-left
  btq-leftmost
  false
  lock2
  toq-color
  toq-parent
  toq-left
  toq-leftmost
  current-thread
  unused-field15
  floats
  processor-deq-next
  processor-deq-prev
  id
  interrupts-head
  interrupts-tail
)

(##define-macro (macro-make-floats)
  `(##f64vector (macro-inexact-+0)
                (macro-inexact-+0)
                (macro-inexact-+0)))

(##define-macro (macro-current-time f)             `(##f64vector-ref ,f 0))
(##define-macro (macro-current-time-set! f x)      `(##f64vector-set! ,f 0 ,x))
(##define-macro (macro-heartbeat-interval f)       `(##f64vector-ref ,f 1))
(##define-macro (macro-heartbeat-interval-set! f x)`(##f64vector-set! ,f 1 ,x))
(##define-macro (macro-temp f)                     `(##f64vector-ref ,f 2))
(##define-macro (macro-temp-set! f x)              `(##f64vector-set! ,f 2 ,x))

(##define-macro (macro-get-heartbeat-interval f)
  `(begin
     (##get-heartbeat-interval! ,f 1)
     (macro-heartbeat-interval ,f)))

(##define-macro (macro-update-current-time!)
  `(##get-current-time! (macro-thread-floats (macro-current-processor)) 0))

(##define-macro (macro-make-processor id)
  `(let ((processor
          (macro-construct-processor
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0
           #f
           #f
           #f
           #f
           #f
           #f
           (macro-make-floats)
           #f
           #f
           ,id
           '()
           '())))
     (macro-btq-deq-init! processor)
     (macro-btq-init! processor)
     (macro-toq-init! processor)
     (macro-processor-deq-init! processor)
     processor))

(##define-macro (macro-processor-init! processor id)
  `(let ((processor ,processor) (id ,id))
     (##structure-type-set! processor (macro-type-processor))
     (macro-processor-floats-set!
      processor
      (macro-make-floats))
     (macro-btq-deq-init! processor)
     (macro-btq-init! processor)
     (macro-toq-init! processor)
     (macro-processor-deq-init! processor)
     (macro-processor-id-set! processor id)
     (macro-processor-interrupts-head-set! processor '())
     (macro-processor-interrupts-tail-set! processor '())
     processor))

;;;----------------------------------------------------------------------------

;;; Representation of processor queues.

(##define-macro (macro-processor-deq-next node)
  `(macro-struct-slot 17 ,node))
(##define-macro (macro-processor-deq-next-set! node x)
  `(macro-struct-slot 17 ,node ,x))
(##define-macro (macro-processor-deq-prev node)
  `(macro-struct-slot 18 ,node))
(##define-macro (macro-processor-deq-prev-set! node x)
  `(macro-struct-slot 18 ,node ,x))

;;; Define operations on processor queues.

(define-deq
 macro-processor-deq-init!
 macro-processor-deq-insert-at-head!
 macro-processor-deq-insert-at-tail!
 macro-processor-deq-remove!
 macro-processor-deq-empty?
 macro-processor-deq-head
 macro-processor-deq-tail
 macro-processor-deq-next
 macro-processor-deq-next-set!
 macro-processor-deq-prev
 macro-processor-deq-prev-set!)

;;;----------------------------------------------------------------------------

;;; Representation of the VM state.  This is the part of the VM state
;;; that is implemented at the Scheme level (the other part of the VM
;;; state is implemented at the host language level).

;;; This structure is pre-allocated by the runtime system to reduce
;;; pressure on the garbage collector. For this reason, the length of
;;; the structure must match the definition of ___VM_SIZE in
;;; include/gambit.h.in .

(define-type vm
  id: F86D8C06-0129-4798-B170-49E593E6A7FD
  type-exhibitor: macro-type-vm
  constructor: macro-construct-vm
  implementer: implement-type-vm
  predicate: macro-vm?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 17 and 18 are the deq links of blocked processors
  ;; field 19 is count of processors blocked and not waiting for a timeout
  lock1
  unused-field2
  unused-field3
  unused-field4
  unused-field5
  unused-field6
  unused-field7
  unused-field8
  lock2
  unused-field10
  unused-field11
  unused-field12
  unused-field13
  unused-field14
  unused-field15
  unused-field16
  processor-deq-next
  processor-deq-prev
  idle-processor-count
)

(##define-macro (macro-make-vm)
  `(let ((vm
          (macro-construct-vm
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0)))
     (macro-processor-deq-init! vm)
     vm))

(##define-macro (macro-vm-init! vm)
  `(let ((vm ,vm))
     (##structure-type-set! vm (macro-type-vm))
     (macro-processor-deq-init! vm)
     (macro-vm-idle-processor-count-set! vm 0)
     vm))

;;;----------------------------------------------------------------------------

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

  (result unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-abnormally-terminated
  id: 291e311e-93e0-4765-8132-56a719dc84b3
  constructor: #f
  opaque:

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-waiting
  id: eb5a81e1-5061-4074-a27e-cc706735d39a
  constructor: #f
  opaque:

  (for     unprintable: read-only: no-functional-setter:)
  (timeout unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-running
  id: f839d55a-1d42-4b64-97a6-2d16921dc0b7
  constructor: #f
  opaque:

  (processor unprintable: read-only: no-functional-setter:)
)

;;;============================================================================

) (else

;;;============================================================================

;;; For non-SMP thread scheduler.

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

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception noncontinuable-exception
  id: 1bcc14ff-4be5-4573-a250-729b773bdd50
  constructor: #f
  opaque:

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception initialized-thread-exception
  id: e38351db-bef7-4c30-b610-b9b271e99ec3
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception uninitialized-thread-exception
  id: 71831161-39c1-4a10-bb79-04342e1981c3
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception inactive-thread-exception
  id: 339af4ff-3d44-4bec-a90b-d981fd13834d
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception started-thread-exception
  id: ed07bce3-b882-4737-ac5e-3035b7783b8a
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception terminated-thread-exception
  id: 85f41657-8a51-4690-abef-d76dc37f4465
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception uncaught-exception
  id: 7022e42c-4ecb-4476-be40-3ca2d45903a7
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
  (reason    unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception join-timeout-exception
  id: 7af7ca4a-ecca-445f-a270-de9d45639feb
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception mailbox-receive-timeout-exception
  id: 5f13e8c4-2c68-4eb5-b24d-249a9356c918
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception rpc-remote-error-exception
  id: 6469e5eb-3117-4c29-89df-c348479dac93
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
  (message   unprintable: read-only: no-functional-setter:)
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

(define-check-type vm 'vm
  macro-vm?)

(define-check-type processor 'processor
  macro-processor?)

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
  `(or (##not (##eq? 'not-started (macro-thread-exception? ,thread)))
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
                 implementer
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
                 length
                 length-set!
                 leftmost
                 leftmost-set!
                 rightmost
                 rightmost-set!
                 container
                 container-set!)

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

  (define (def-insert!)
    `(define-prim (,insert! rbtree node)

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

       ,@(if length
             `((,length-set! rbtree (##fx+ (,length rbtree) 1)))
             `())

       ,@(if container-set!
             `((,container-set! node rbtree))
             `())

       (,(reden!) node)
       (,left-set! node rbtree)
       (,right-set! node rbtree)

       (insert-left! (,left rbtree) rbtree)

       (,parent-set! rbtree rbtree)))

  (define (def-remove!)
    `(define-prim (,remove! node)

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

         ,@(if length
               `((,length-set! rbtree (##fx- (,length rbtree) 1)))
               `())

         ,@(if container-set!
               `((,container-set! node #f))
               `())

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

         (,parent-set! rbtree rbtree))))

  (define (def-reposition!)
    `(define-prim (,reposition! node)

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
             (,insert! rbtree node))))))

  `(begin

     (##define-macro (,rbtree-init! rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          ,@',(if leftmost
                `((,leftmost-set! rbtree rbtree))
                `())

          ,@',(if rightmost
                `((,rightmost-set! rbtree rbtree))
                `())

          ,@',(if length
                `((,length-set! rbtree 0))
                `())

          (,',(blacken! 'rbtree) rbtree)
          (,',parent-set! rbtree rbtree)
          (,',left-set! rbtree rbtree)))

     (##define-macro (,node->rbtree node)
       (if ',container

           `(let ((node ,node))

              (##declare (not interrupts-enabled))

              (,',container node))

           `(let ((node ,node))

              (##declare (not interrupts-enabled))

              (or (,',color node)
                  (let ((parent-node (,',parent node)))
                    (and parent-node ;; make sure node is in a rbtree
                         (,',color parent-node)))))))

     (##define-macro (,singleton? rbtree)
       `(let ((rbtree ,rbtree))

          (##declare (not interrupts-enabled))

          (let ((root (,',left rbtree)))
            (and (##not (##eq? root rbtree))
                 (##eq? (,',left root) rbtree)
                 (##eq? (,',right root) rbtree)
                 root))))

     (##define-macro (,implementer)
       `(begin
          ,',(def-insert!)
          ,',(def-remove!)
          ,',(def-reposition!)))))

;;;----------------------------------------------------------------------------

;;; Double-ended-queue generator macro.

(##define-macro (define-deq
                 init!
                 insert-at-head!
                 insert-at-tail!
                 remove!
                 empty?
                 head
                 tail
                 next
                 next-set!
                 prev
                 prev-set!)

  `(begin

     (##define-macro (,init! deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Initialize a deq.

          (,',next-set! deq deq)
          (,',prev-set! deq deq)))

     (##define-macro (,insert-at-head! deq item)
       `(let ((deq ,deq) (item ,item))

          (##declare (not interrupts-enabled))

          ;; Add item to head of deq.

          (let ((deq-first (,',next deq)))
            (,',next-set! item deq-first)
            (,',prev-set! item deq)
            (,',next-set! deq item)
            (,',prev-set! deq-first item))))

     (##define-macro (,insert-at-tail! deq item)
       `(let ((deq ,deq) (item ,item))

          (##declare (not interrupts-enabled))

          ;; Add item to tail of deq.

          (let ((deq-last (,',prev deq)))
            (,',next-set! deq-last item)
            (,',prev-set! deq item)
            (,',next-set! item deq)
            (,',prev-set! item deq-last))))

     (##define-macro (,remove! item)
       `(let ((item ,item))

          (##declare (not interrupts-enabled))

          ;; Remove an item from the deq containing it.

          (let ((item-next (,',next item))
                (item-prev (,',prev item)))
            (,',next-set! item-prev item-next)
            (,',prev-set! item-next item-prev))))

     (##define-macro (,empty? deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Test if deq is empty.

          (##eq? (,',next deq) deq)))

     (##define-macro (,head deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Get head of non-empty deq.

          (,',next deq)))

     (##define-macro (,tail deq)
       `(let ((deq ,deq))

          (##declare (not interrupts-enabled))

          ;; Get tail of non-empty deq.

          (,',prev deq)))))

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

(##define-macro (macro-make-parameter-descr value hash set-filter get-filter)
  `(##vector ,value ,hash ,set-filter ,get-filter))

(##define-macro (macro-parameter-descr-value p)         `(macro-slot 0 ,p))
(##define-macro (macro-parameter-descr-value-set! p x)  `(macro-slot 0 ,p ,x))
(##define-macro (macro-parameter-descr-hash p)          `(macro-slot 1 ,p))
(##define-macro (macro-parameter-descr-hash-set! p x)   `(macro-slot 1 ,p ,x))
(##define-macro (macro-parameter-descr-set-filter p)    `(macro-slot 2 ,p))
(##define-macro (macro-parameter-descr-set-filter-set! p x) `(macro-slot 2 ,p ,x))
(##define-macro (macro-parameter-descr-get-filter p)    `(macro-slot 3 ,p))
(##define-macro (macro-parameter-descr-get-filter-set! p x) `(macro-slot 3 ,p ,x))

;;; Binding of special dynamic variables.

(##define-macro (macro-denv-set denv var val)
  `(let ((denv ,denv) (val ,val))

     (##declare (not interrupts-enabled))

     (macro-make-denv
      (macro-denv-local denv)
      ,(if (eq? var 'dynwind)
           `val
           `(macro-denv-dynwind denv))
      ,(if (eq? var 'interrupt-mask)
           `val
           `(macro-denv-interrupt-mask denv))
      ,(if (eq? var 'debugging-settings)
           `val
           `(macro-denv-debugging-settings denv))
      ,(if (eq? var 'exception-handler)
           `(##cons ##current-exception-handler val)
           `(macro-denv-exception-handler denv))
      ,(if (eq? var 'input-port)
           `(##cons ##current-input-port val)
           `(macro-denv-input-port denv))
      ,(if (eq? var 'output-port)
           `(##cons ##current-output-port val)
           `(macro-denv-output-port denv))
      ,(if (eq? var 'repl-context)
           `(##cons #f val)
           `(macro-denv-repl-context denv)))))

(##define-macro (macro-dynamic-bind var val thunk)
  `(##dynamic-env-bind
    (macro-denv-set (macro-thread-denv (macro-current-thread)) ,var ,val)
    ,thunk))

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
     (##declare
      (not safe) ;; avoid procedure check on the call to the handler
      (interrupts-enabled)) ;; make sure exceptions can be interrupted
     (if (macro-current-thread)
         ((macro-current-exception-handler) obj)
         (##exit-with-exception obj)))) ;; exit when exception is raised
                                        ;; before thread system is initialized

(##define-macro (macro-abort obj)
  `(let ((obj ,obj))
     (macro-raise obj)
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
  (exact->inexact 0))

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

(##define-macro (macro-btq-lock1 node)          `(macro-struct-slot 1 ,node))
(##define-macro (macro-btq-lock1-set! node x)   `(macro-struct-slot 1 ,node ,x))
(##define-macro (macro-btq-deq-next node)       `(macro-struct-slot 2 ,node))
(##define-macro (macro-btq-deq-next-set! node x)`(macro-struct-slot 2 ,node ,x))
(##define-macro (macro-btq-deq-prev node)       `(macro-struct-slot 3 ,node))
(##define-macro (macro-btq-deq-prev-set! node x)`(macro-struct-slot 3 ,node ,x))
(##define-macro (macro-btq-color node)          `(macro-struct-slot 4 ,node))
(##define-macro (macro-btq-color-set! node x)   `(macro-struct-slot 4 ,node ,x))
(##define-macro (macro-btq-parent node)         `(macro-struct-slot 5 ,node))
(##define-macro (macro-btq-parent-set! node x)  `(macro-struct-slot 5 ,node ,x))
(##define-macro (macro-btq-left node)           `(macro-struct-slot 6 ,node))
(##define-macro (macro-btq-left-set! node x)    `(macro-struct-slot 6 ,node ,x))
(##define-macro (macro-btq-right node)          `(macro-struct-slot 7 ,node))
(##define-macro (macro-btq-right-set! node x)   `(macro-struct-slot 7 ,node ,x))
(##define-macro (macro-btq-leftmost node)       `(macro-struct-slot 7 ,node))
(##define-macro (macro-btq-leftmost-set! node x)`(macro-struct-slot 7 ,node ,x))
(##define-macro (macro-btq-owner node)          `(macro-struct-slot 8 ,node))
(##define-macro (macro-btq-owner-set! node x)   `(macro-struct-slot 8 ,node ,x))
(##define-macro (macro-btq-lock2 node)          `(macro-struct-slot 9 ,node))
(##define-macro (macro-btq-lock2-set! node x)   `(macro-struct-slot 9 ,node ,x))

(define-rbtree
 implement-btq
 macro-btq-init!
 macro-thread->btq
 ##btq-insert!
 ##btq-remove!
 ##btq-reposition!
 macro-btq-singleton?
 macro-btq-color
 macro-btq-color-set!
 macro-btq-parent
 macro-btq-parent-set!
 macro-btq-left
 macro-btq-left-set!
 macro-btq-right
 macro-btq-right-set!
 macro-thread-higher-prio?
 #f
 #f
 macro-btq-leftmost
 macro-btq-leftmost-set!
 #f
 #f
 #f
 #f
)

;;; Define operations on blocked thread queue double-ended-queues.

(define-deq
 macro-btq-deq-init!
 macro-btq-deq-insert-at-head!
 macro-btq-deq-insert-at-tail!
 macro-btq-deq-remove!
 macro-btq-deq-empty?
 macro-btq-deq-head
 macro-btq-deq-tail
 macro-btq-deq-next
 macro-btq-deq-next-set!
 macro-btq-deq-prev
 macro-btq-deq-prev-set!)

(##define-macro (macro-btq-link! mutex thread)
  `(let ((mutex ,mutex) (thread ,thread))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-insert-at-tail! thread mutex)
     (macro-btq-owner-set! mutex thread)))

(##define-macro (macro-btq-unlink! mutex state)
  `(let ((mutex ,mutex) (state ,state))

     (##declare (not interrupts-enabled))

     (macro-btq-deq-init! mutex)
     (macro-btq-owner-set! mutex state)))

;;; Representation of timeout queues.

(##define-macro (macro-toq-color node)         `(macro-struct-slot 10 ,node))
(##define-macro (macro-toq-color-set! node x)  `(macro-struct-slot 10 ,node ,x))
(##define-macro (macro-toq-parent node)        `(macro-struct-slot 11 ,node))
(##define-macro (macro-toq-parent-set! node x) `(macro-struct-slot 11 ,node ,x))
(##define-macro (macro-toq-left node)          `(macro-struct-slot 12 ,node))
(##define-macro (macro-toq-left-set! node x)   `(macro-struct-slot 12 ,node ,x))
(##define-macro (macro-toq-right node)         `(macro-struct-slot 13 ,node))
(##define-macro (macro-toq-right-set! node x)  `(macro-struct-slot 13 ,node ,x))
(##define-macro (macro-toq-leftmost node)      `(macro-struct-slot 13 ,node))
(##define-macro (macro-toq-leftmost-set! node x)`(macro-struct-slot 13 ,node ,x))

(define-rbtree
 implement-toq
 macro-toq-init!
 macro-thread->toq
 ##toq-insert!
 ##toq-remove!
 ##toq-reposition!
 macro-toq-singleton?
 macro-toq-color
 macro-toq-color-set!
 macro-toq-parent
 macro-toq-parent-set!
 macro-toq-left
 macro-toq-left-set!
 macro-toq-right
 macro-toq-right-set!
 macro-thread-sooner-or-simultaneous-and-higher-prio?
 #f
 #f
 macro-toq-leftmost
 macro-toq-leftmost-set!
 #f
 #f
 #f
 #f
)

;;; Representation of threads.

;; The state of a thread is determined by the content of the
;; "end-condvar", "exception?" and "result" fields:
;;
;;  thread state               "end-condvar" "exception?" "result"
;;  not yet started            condvar       'not-started #f
;;  started                    condvar       #f           #f
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

  (lock1            init: 0)

  (btq-deq-next     init: #f) ;; blocked thread queues owned by thread
  (btq-deq-prev     init: #f)

  (btq-color        init: #f) ;; to keep thread in a blocked thread queue
  (btq-parent       init: #f)
  (btq-left         init: #f)
  (btq-leftmost     init: #f)

  (tgroup           init: #f) ;; thread-group this thread belongs to

  (lock2            init: 0)

  (toq-color        init: #f) ;; to keep thread in a timeout queue
  (toq-parent       init: #f)
  (toq-left         init: #f)
  (toq-leftmost     init: #f)

  (threads-deq-next init: #f) ;; threads in this thread group
  (threads-deq-prev init: #f)

  (floats           init: #f)

  (btq-container    init: #f) ;; unused

  (toq-container    init: #f) ;; unused

  (name             init: #f)
  (end-condvar      init: #f)
  (exception?       init: 'not-started)
  (result           init: #f)
  (cont             init: #f)
  (denv             init: #f)
  (denv-cache1      init: #f)
  (denv-cache2      init: #f)
  (denv-cache3      init: #f)
  (repl-channel     init: #f)
  (mailbox          init: #f)
  (specific         init: '#!void)
  (resume-thunk     init: #f)
  (interrupts-head  init: '())
  (interrupts-tail  init: '())
  (last-processor   init: #f) ;; last processor that executed thread or #f
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
  `(macro-make-continuation (macro-end-of-cont-marker) #f))

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
       (macro-thread-resume-thunk-set! thread
        (lambda ()
          (##thread-execute-and-end! thunk)))
       (macro-thread-cont-set! thread (macro-make-thread-cont p))
       (macro-thread-denv-set! thread (macro-make-thread-denv p))
       (macro-thread-denv-cache1-set! thread (macro-make-thread-denv-cache1 p))
       (macro-thread-denv-cache2-set! thread (macro-make-thread-denv-cache2 p))
       (macro-thread-denv-cache3-set! thread (macro-make-thread-denv-cache3 p))
       (macro-btq-deq-init! thread)
       (macro-tgroup-threads-deq-insert-at-tail! tgroup thread)
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

     (let ((leftmost (macro-btq-leftmost (macro-current-processor))))
       (if (##not (##eq? leftmost (macro-current-thread)))
         (##thread-reschedule!)
         (##void)))))

(##define-macro (macro-thread-save! proc . args)
  `(##thread-save! ,proc ,@args))

(##define-macro (macro-thread-restore! thread proc . args)
  `(##thread-restore! ,thread ,proc ,@args))

(##define-macro (macro-current-processor)
  `(##current-processor))

(##define-macro (macro-primordial-thread)
  `##primordial-thread)

(##define-macro (macro-current-thread)
  `(##current-thread))

(##define-macro (macro-primordial-exception-handler)
  `##primordial-exception-handler)

(##define-macro (macro-thread-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##fl< (macro-effective-priority floats2) ;; high priority first
              (macro-effective-priority floats1)))))

(##define-macro (macro-thread-sooner? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (##fl< (macro-timeout floats1)
              (macro-timeout floats2)))))

(##define-macro (macro-thread-sooner-or-simultaneous-and-higher-prio? t1 t2)
  `(let ((t1 ,t1) (t2 ,t2))
     (let ((floats1 (macro-thread-floats t1))
           (floats2 (macro-thread-floats t2)))
       (if (##not (##fl= (macro-timeout floats1)
                         (macro-timeout floats2)))
         (##fl< (macro-timeout floats1)
                (macro-timeout floats2))
         (##fl< (macro-effective-priority floats2) ;; high priority first
                (macro-effective-priority floats1))))))

(##define-macro (macro-thread-boost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##fl= (##fl+ (macro-base-priority floats)
                                (macro-priority-boost floats))
                         (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-current-processor))
            (macro-boosted-priority floats))

           (macro-boosted-priority-set!
            floats
            (##fl+ (macro-base-priority floats)
                   (macro-priority-boost floats)))

            (##thread-boosted-priority-changed! thread))))))

(##define-macro (macro-thread-unboost-and-clear-quantum-used! thread)
  `(let ((thread ,thread))

     (##declare (not interrupts-enabled))

     (let ((floats (macro-thread-floats thread)))
       (macro-quantum-used-set! floats (macro-inexact-+0))
       (if (##not (##fl= (macro-base-priority floats)
                         (macro-boosted-priority floats)))
         (begin

           ;; save old boosted priority for ##thread-boosted-priority-changed!

           (macro-temp-set!
            (macro-thread-floats (macro-current-processor))
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
       (if (##fl< (macro-effective-priority thread-floats)
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

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are for maintaining this mutex in a deq of btqs
  ;; fields 4 to 6 are for maintaining a queue of blocked threads
  ;; field 7 is the leftmost thread in the queue of blocked threads
  ;; field 8 is the owner of the mutex (or 'not-owned or 'abandoned
  ;; or 'not-abandoned)
  (lock1        init: 0)
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: 'not-abandoned) ;; see (macro-mutex-state-not-abandoned)
  (lock2        init: 0)

  (name
   macro-mutex-name
   macro-mutex-name-set!)
  (specific
   macro-mutex-specific
   macro-mutex-specific-set!)
)

;; Mutex states (aside from "owned")

(##define-macro (macro-mutex-state-not-owned)     ''not-owned)
(##define-macro (macro-mutex-state-abandoned)     ''abandoned)
(##define-macro (macro-mutex-state-not-abandoned) ''not-abandoned)

(##define-macro (macro-make-mutex name)
  `(let ((name ,name))
     (let ((mutex (macro-construct-mutex name (##void))))
       (macro-btq-deq-init! mutex)
       (macro-btq-init! mutex)
       mutex)))

(##define-macro (macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? mutex)
  `(##eq? (macro-btq-owner ,mutex)
          (macro-mutex-state-not-abandoned)))

(##define-macro (macro-mutex-lock! mutex absrel-timeout new-owner)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout) (new-owner ,new-owner))

     (##declare (not interrupts-enabled))

     (##primitive-lock! mutex 1 9)
     (let ((owner (macro-btq-owner mutex)))
       (if (##eq? owner (macro-mutex-state-not-abandoned))
           (begin
             (macro-btq-link! mutex new-owner)
             (##primitive-unlock! mutex 1 9)
             #t)
           (begin
             (##primitive-unlock! mutex 1 9)
             (##mutex-lock-out-of-line! mutex absrel-timeout owner new-owner))))))

(##define-macro (macro-mutex-lock-anonymously! mutex absrel-timeout)
  `(let ((mutex ,mutex) (absrel-timeout ,absrel-timeout))

     (##declare (not interrupts-enabled))

     (##primitive-lock! mutex 1 9)
     (let ((owner (macro-btq-owner mutex)))
       (if (##eq? owner (macro-mutex-state-not-abandoned))
           (begin
             (macro-btq-owner-set! mutex (macro-mutex-state-not-owned))
             (##primitive-unlock! mutex 1 9)
             #t)
           (begin
             (##primitive-unlock! mutex 1 9)
             (##mutex-lock-out-of-line! mutex absrel-timeout owner #f))))))

(##define-macro (macro-mutex-unlock! mutex)
  `(let ((mutex ,mutex))

     (##declare (not interrupts-enabled))

     (##primitive-lock! mutex 1 9)
     (macro-btq-deq-remove! mutex)
     (let ((leftmost (macro-btq-leftmost mutex)))
       (if (##eq? leftmost mutex)
           (begin
             (macro-btq-unlink! mutex (macro-mutex-state-not-abandoned))
             (##primitive-unlock! mutex 1 9)
             (##void))
           (##mutex-signal! mutex leftmost #f)))))

(##define-macro (macro-mutex-unlock-no-reschedule! mutex)
  `(let ((mutex ,mutex))

     (##declare (not interrupts-enabled))

     (##primitive-lock! mutex 1 9)
     (macro-btq-deq-remove! mutex)
     (let ((leftmost (macro-btq-leftmost mutex)))
       (if (##eq? leftmost mutex)
           (begin
             (macro-btq-unlink! mutex (macro-mutex-state-not-abandoned))
             (##primitive-unlock! mutex 1 9)
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

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are for maintaining this condition variable in a deq of btqs
  ;; fields 4 to 6 are for maintaining a queue of blocked threads
  ;; field 7 is the leftmost thread in the queue of blocked threads
  ;; field 8 is the owner of the condition variable
  (lock1        init: 0)
  (btq-deq-next init: #f)
  (btq-deq-prev init: #f)
  (btq-color    init: #f)
  (btq-parent   init: #f)
  (btq-left     init: #f)
  (btq-leftmost init: #f)
  (btq-owner    init: #f)
  (lock2        init: 0)

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

(define-type thread-groups
  id: EACE4200-EB43-4891-852A-03C7B5D385E4
  type-exhibitor: macro-type-tgroups
  constructor: macro-construct-tgroups
  implementer: implement-type-tgroups
  predicate: macro-tgroups?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  (tgroups-deq-next
   macro-tgroups-tgroups-deq-next
   macro-tgroups-tgroups-deq-next-set!)
  (tgroups-deq-prev
   macro-tgroups-tgroups-deq-prev
   macro-tgroups-tgroups-deq-prev-set!)
)

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
  (specific
   macro-tgroup-specific
   macro-tgroup-specific-set!)
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
  (unused6
   macro-tgroup-unused6
   macro-tgroup-unused6-set!)
  (threads-deq-next ;; must be at same pos as the same name field in a thread
   macro-tgroup-threads-deq-next
   macro-tgroup-threads-deq-next-set!)
  (threads-deq-prev ;; must be at same pos as the same name field in a thread
   macro-tgroup-threads-deq-prev
   macro-tgroup-threads-deq-prev-set!)
)

(##define-macro (macro-make-tgroup name parent)
  `(let ((name ,name) (parent ,parent))
     (let* ((tgroups
             (macro-construct-tgroups #f #f))
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
              #f
              #f
              #f)))
       (macro-tgroup-tgroups-deq-init! tgroups)
       (macro-tgroup-threads-deq-init! tgroup)
       (if parent
         (macro-tgroup-tgroups-deq-insert-at-tail!
          (macro-tgroup-tgroups parent)
          tgroup))
       tgroup)))

(define-deq
 macro-tgroup-tgroups-deq-init!
 macro-tgroup-tgroups-deq-insert-at-head!
 macro-tgroup-tgroups-deq-insert-at-tail!
 macro-tgroup-tgroups-deq-remove!
 macro-tgroup-tgroups-deq-empty?
 macro-tgroup-tgroups-deq-head
 macro-tgroup-tgroups-deq-tail
 macro-tgroup-tgroups-deq-next
 macro-tgroup-tgroups-deq-next-set!
 macro-tgroup-tgroups-deq-prev
 macro-tgroup-tgroups-deq-prev-set!)

(define-deq
 macro-tgroup-threads-deq-init!
 macro-tgroup-threads-deq-insert-at-head!
 macro-tgroup-threads-deq-insert-at-tail!
 macro-tgroup-threads-deq-remove!
 macro-tgroup-threads-deq-empty?
 macro-tgroup-threads-deq-head
 macro-tgroup-threads-deq-tail
 macro-tgroup-threads-deq-next
 macro-tgroup-threads-deq-next-set!
 macro-tgroup-threads-deq-prev
 macro-tgroup-threads-deq-prev-set!)

;;;----------------------------------------------------------------------------

;;; Representation of the processor state.  This is the part of the
;;; processor state that is implemented at the Scheme level (the other
;;; part of the processor state is implemented at the host language level).

;;; Note that this structure used to be called a "run queue" because it
;;; is mostly used by the scheduler to maintain the set of runnable threads.
;;; However it also includes other information which is conceptually part
;;; of the processor state.

;;; TODO: consider pre-allocating this structure so there is less
;;; pressure on the garbage collector.

(define-type processor
  id: A6899D11-290C-42A6-B47A-57C6B908698F
  type-exhibitor: macro-type-processor
  constructor: macro-construct-processor
  implementer: implement-type-processor
  predicate: macro-processor?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 2 and 3 are the deq links of blocking device condvars
  ;; fields 4 to 6 are for maintaining a queue of runnable threads
  ;; field 7 is the leftmost thread in the queue of runnable threads
  ;; field 8 must be #f (the queue of runnable threads has no owner)
  ;; fields 10 to 12 are for maintaining a timeout queue of threads
  ;; field 13 is the leftmost thread in the timeout queue of threads
  ;; field 14 is the thread currently running on this processor
  ;; field 16 is for storing the current time, heartbeat interval and a
  ;; temporary float
  ;; fields 17 and 18 are the deq links of blocked processors
  ;; field 19 is the id of the processor
  ;; field 20 is the head of the queue of pending high-level interrupts
  ;; field 21 is the tail of the queue of pending high-level interrupts
  lock1
  condvar-deq-next
  condvar-deq-prev
  btq-color
  btq-parent
  btq-left
  btq-leftmost
  false
  lock2
  toq-color
  toq-parent
  toq-left
  toq-leftmost
  current-thread
  unused-field15
  floats
  processor-deq-next
  processor-deq-prev
  id
  interrupts-head
  interrupts-tail
)

(##define-macro (macro-make-floats)
  `(##f64vector (macro-inexact-+0)
                (macro-inexact-+0)
                (macro-inexact-+0)))

(##define-macro (macro-current-time f)             `(##f64vector-ref ,f 0))
(##define-macro (macro-current-time-set! f x)      `(##f64vector-set! ,f 0 ,x))
(##define-macro (macro-heartbeat-interval f)       `(##f64vector-ref ,f 1))
(##define-macro (macro-heartbeat-interval-set! f x)`(##f64vector-set! ,f 1 ,x))
(##define-macro (macro-temp f)                     `(##f64vector-ref ,f 2))
(##define-macro (macro-temp-set! f x)              `(##f64vector-set! ,f 2 ,x))

(##define-macro (macro-get-heartbeat-interval f)
  `(begin
     (##get-heartbeat-interval! ,f 1)
     (macro-heartbeat-interval ,f)))

(##define-macro (macro-update-current-time!)
  `(##get-current-time! (macro-thread-floats (macro-current-processor)) 0))

(##define-macro (macro-make-processor id)
  `(let ((processor
          (macro-construct-processor
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0
           #f
           #f
           #f
           #f
           #f
           #f
           (macro-make-floats)
           #f
           #f
           ,id
           '()
           '())))
     (macro-btq-deq-init! processor)
     (macro-btq-init! processor)
     (macro-toq-init! processor)
     (macro-processor-deq-init! processor)
     processor))

(##define-macro (macro-processor-init! processor id)
  `(let ((processor ,processor) (id ,id))
     (##structure-type-set! processor (macro-type-processor))
     (macro-processor-floats-set!
      processor
      (##f64vector (macro-inexact-+0)
                   (macro-inexact-+0)
                   (macro-inexact-+0)))
     (macro-btq-deq-init! processor)
     (macro-btq-init! processor)
     (macro-toq-init! processor)
     (macro-processor-deq-init! processor)
     (macro-processor-id-set! processor id)
     (macro-processor-interrupts-head-set! processor '())
     (macro-processor-interrupts-tail-set! processor '())
     processor))

;;;----------------------------------------------------------------------------

;;; Representation of processor queues.

(##define-macro (macro-processor-deq-next node)
  `(macro-struct-slot 17 ,node))
(##define-macro (macro-processor-deq-next-set! node x)
  `(macro-struct-slot 17 ,node ,x))
(##define-macro (macro-processor-deq-prev node)
  `(macro-struct-slot 18 ,node))
(##define-macro (macro-processor-deq-prev-set! node x)
  `(macro-struct-slot 18 ,node ,x))

;;; Define operations on processor queues.

(define-deq
 macro-processor-deq-init!
 macro-processor-deq-insert-at-head!
 macro-processor-deq-insert-at-tail!
 macro-processor-deq-remove!
 macro-processor-deq-empty?
 macro-processor-deq-head
 macro-processor-deq-tail
 macro-processor-deq-next
 macro-processor-deq-next-set!
 macro-processor-deq-prev
 macro-processor-deq-prev-set!)

;;;----------------------------------------------------------------------------

;;; Representation of the VM state.  This is the part of the VM state
;;; that is implemented at the Scheme level (the other part of the VM
;;; state is implemented at the host language level).

;;; TODO: consider pre-allocating this structure so there is less
;;; pressure on the garbage collector.

(define-type vm
  id: F86D8C06-0129-4798-B170-49E593E6A7FD
  type-exhibitor: macro-type-vm
  constructor: macro-construct-vm
  implementer: implement-type-vm
  predicate: macro-vm?
  opaque:
  macros:
  prefix: macro-

  unprintable:

  ;; fields 1 and 9 are for locking in a multiprocessor system
  ;; fields 17 and 18 are the deq links of blocked processors
  ;; field 19 is count of processors blocked and not waiting for a timeout
  lock1
  unused-field2
  unused-field3
  unused-field4
  unused-field5
  unused-field6
  unused-field7
  unused-field8
  lock2
  unused-field10
  unused-field11
  unused-field12
  unused-field13
  unused-field14
  unused-field15
  unused-field16
  processor-deq-next
  processor-deq-prev
  idle-processor-count
)

(##define-macro (macro-make-vm)
  `(let ((vm
          (macro-construct-vm
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           #f
           0)))
     (macro-processor-deq-init! vm)
     vm))

(##define-macro (macro-vm-init! vm)
  `(let ((vm ,vm))
     (##structure-type-set! vm (macro-type-vm))
     (macro-processor-deq-init! vm)
     (macro-vm-idle-processor-count-set! vm 0)
     vm))

;;;----------------------------------------------------------------------------

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

  (result unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-abnormally-terminated
  id: 291e311e-93e0-4765-8132-56a719dc84b3
  constructor: #f
  opaque:

  (reason unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-waiting
  id: eb5a81e1-5061-4074-a27e-cc706735d39a
  constructor: #f
  opaque:

  (for     unprintable: read-only: no-functional-setter:)
  (timeout unprintable: read-only: no-functional-setter:)
)

(define-library-type thread-state-running
  id: f839d55a-1d42-4b64-97a6-2d16921dc0b7
  constructor: #f
  opaque:

  (processor unprintable: read-only: no-functional-setter:)
)

;;;============================================================================

))

;; Common stuff.

(##define-macro (macro-thread-interrupts-insert-at-tail! thread intr)
  `(let ((thread ,thread) (intr ,intr))

     (##declare (not interrupts-enabled))

     ;; Add item to tail of queue of interrupts

     (let ((tail (macro-thread-interrupts-tail thread)))
       (macro-thread-interrupts-tail-set! thread intr)
       (if (##null? tail)
           (macro-thread-interrupts-head-set! thread intr)
           (##vector-set! tail 0 intr)))))

(##define-macro (macro-thread-interrupts-remove-from-head! interrupt yes no)
  `(let ()

     (##declare (not interrupts-enabled))

     ;; Remove item from head of queue of interrupts

     (let ((,interrupt (macro-thread-interrupts-head (macro-current-thread))))
       (if (##null? ,interrupt)
           (begin
             ,no)
           (let (($$next (##vector-ref ,interrupt 0)))
             (##vector-set! ,interrupt 0 '())
             (macro-thread-interrupts-head-set! (macro-current-thread) $$next)
             (if (##null? $$next)
                 (macro-thread-interrupts-tail-set! (macro-current-thread) '()))
             ,yes)))))
