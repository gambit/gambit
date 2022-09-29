;;;============================================================================

;;; File: "_gvm.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include     "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

;;;----------------------------------------------------------------------------
;;
;; Gambit virtual machine abstraction module:
;; -----------------------------------------

;; (See file 'doc/gvm' for details on the virtual machine)

(define return-addr-reg (make-reg 0)) ;; register used to pass return address

;; Utilities:
;; ---------

(define *opnd-table* #f)
(define *opnd-table-alloc* #f)

(define (extend-opnd-table!)
  (let* ((n (vector-length *opnd-table*))
         (new-table (make-vector (+ (quotient (* 3 n) 2) 1) #f)))
    (let loop ((i 0))
      (if (< i n)
        (begin
          (vector-set! new-table i (vector-ref *opnd-table* i))
          (loop (+ i 1)))
        (set! *opnd-table* new-table)))))

(define (enter-opnd arg1 arg2)
  (let loop ((i 0))
    (if (< i *opnd-table-alloc*)
      (let ((x (vector-ref *opnd-table* i)))
        (if (and (eqv? (car x) arg1) (eqv? (cdr x) arg2))
          i
          (loop (+ i 1))))
      (begin
        (set! *opnd-table-alloc* (+ *opnd-table-alloc* 1))
        (if (> *opnd-table-alloc* (vector-length *opnd-table*))
          (extend-opnd-table!))
        (vector-set! *opnd-table* i (cons arg1 arg2))
        i))))

(define (contains-opnd? opnd1 opnd2) ; does opnd2 contain opnd1?
  (cond ((eqv? opnd1 opnd2)
         #t)
        ((clo? opnd2)
         (contains-opnd? opnd1 (clo-base opnd2)))
        (else
         #f)))

(define (any-contains-opnd? opnd opnds)
  (if (null? opnds)
    #f
    (or (contains-opnd? opnd (car opnds))
        (any-contains-opnd? opnd (cdr opnds)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Processor context descriptions:
;; ------------------------------

(define (make-pcontext fs map)
  (vector fs map))

(define (pcontext-fs  x) (vector-ref x 0))
(define (pcontext-map x) (vector-ref x 1))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Frame description:
;; -----------------

(define (make-frame size slots regs closed live)
  (vector size slots regs closed live))

(define (frame-size x)   (vector-ref x 0))
(define (frame-slots x)  (vector-ref x 1))
(define (frame-regs x)   (vector-ref x 2))
(define (frame-closed x) (vector-ref x 3))
(define (frame-live x)   (vector-ref x 4))

(define (frame-eq? frame1 frame2)

  ; two frames are "equal" if they have the same number of slots and
  ; for all slots and registers in a frame the corresponding slot or
  ; register in the other frame has the same liveness and the return
  ; address is in the same place.

  (define (same-liveness? var1 var2)
    (eq? (varset-member? var1 (frame-live frame1))
         (varset-member? var2 (frame-live frame2))))

  (define (same-liveness-list? lst1 lst2)
    (if (pair? lst1)
      (let ((var1 (car lst1)))
        (if (pair? lst2)
          (let ((var2 (car lst2)))
            (and (eq? (eq? var1 ret-var) (eq? var2 ret-var))
                 (same-liveness? var1 var2)
                 (same-liveness-list? (cdr lst1) (cdr lst2))))
          (and (same-liveness? var1 empty-var)
               (same-liveness-list? (cdr lst1) lst2))))
      (if (pair? lst2)
        (let ((var2 (car lst2)))
          (and (same-liveness? empty-var var2)
               (same-liveness-list? lst1 (cdr lst2))))
        #t)))

  (and (= (frame-size frame1) (frame-size frame2))
       (let ((slots1 (frame-slots frame1))
             (slots2 (frame-slots frame2)))
         (same-liveness-list? slots1 slots2))
       (let ((regs1 (frame-regs frame1))
             (regs2 (frame-regs frame2)))
         (same-liveness-list? regs1 regs2))))

(define (frame-truncate frame nb-slots)
  (let ((fs (frame-size frame)))
    (make-frame nb-slots
                (drop (frame-slots frame) (- fs nb-slots))
                (frame-regs frame)
                (frame-closed frame)
                (frame-live frame))))

(define (frame-live? var frame)
  (let ((live (frame-live frame)))
    (if (eq? var closure-env-var)
      (let ((closed (frame-closed frame)))
        (if (or (varset-member? var live)
                (varset-intersects? live (list->varset closed)))
          closed
          #f))
      (if (varset-member? var live)
        var
        #f))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Procedure objects:
;; -----------------

(define (make-proc-obj
          name
          c-name
          primitive?
          code
          call-pat
          side-effects?
          strict-pat
          lift-pat
          type
          standard)
  (let ((proc-obj
          (vector
            proc-obj-tag
            name
            c-name
            primitive?
            code
            call-pat
            (lambda (env) #f) ;; testable?
            #f ;; test
            (lambda (env) #f) ;; expandable?
            #f ;; expand
            (lambda (env) #f) ;; inlinable?
            #f ;; inline
            (lambda (env) #f) ;; jump-inlinable?
            #f ;; jump-inline
            #f ;; specialize
            #f ;; simplify
            side-effects?
            strict-pat
            lift-pat
            type
            standard
            #f))) ;; dead-end?
    (proc-obj-specialize-set! proc-obj (lambda (env args) proc-obj))
    proc-obj))

(define proc-obj-tag (list 'proc-obj))

(define (proc-obj? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) proc-obj-tag)))

(define (proc-obj-name obj)                   (vector-ref obj 1))
(define (proc-obj-c-name obj)                 (vector-ref obj 2))
(define (proc-obj-primitive? obj)             (vector-ref obj 3))
(define (proc-obj-code obj)                   (vector-ref obj 4))
(define (proc-obj-call-pat obj)               (vector-ref obj 5))
(define (proc-obj-testable? obj)              (vector-ref obj 6))
(define (proc-obj-test obj)                   (vector-ref obj 7))
(define (proc-obj-expandable? obj)            (vector-ref obj 8))
(define (proc-obj-expand obj)                 (vector-ref obj 9))
(define (proc-obj-inlinable? obj)             (vector-ref obj 10))
(define (proc-obj-inline obj)                 (vector-ref obj 11))
(define (proc-obj-jump-inlinable? obj)        (vector-ref obj 12))
(define (proc-obj-jump-inline obj)            (vector-ref obj 13))
(define (proc-obj-specialize obj)             (vector-ref obj 14))
(define (proc-obj-simplify obj)               (vector-ref obj 15))
(define (proc-obj-side-effects? obj)          (vector-ref obj 16))
(define (proc-obj-strict-pat obj)             (vector-ref obj 17))
(define (proc-obj-lift-pat obj)               (vector-ref obj 18))
(define (proc-obj-type obj)                   (vector-ref obj 19))
(define (proc-obj-standard obj)               (vector-ref obj 20))
(define (proc-obj-dead-end? obj)              (vector-ref obj 21))

(define (proc-obj-name-set! obj x)            (vector-set! obj 1 x))
(define (proc-obj-c-name-set! obj x)          (vector-set! obj 2 x))
(define (proc-obj-primitive?-set! obj x)      (vector-set! obj 3 x))
(define (proc-obj-code-set! obj x)            (vector-set! obj 4 x))
(define (proc-obj-call-pat-set! obj x)        (vector-set! obj 5 x))
(define (proc-obj-testable?-set! obj x)       (vector-set! obj 6 x))
(define (proc-obj-test-set! obj x)            (vector-set! obj 7 x))
(define (proc-obj-expandable?-set! obj x)     (vector-set! obj 8 x))
(define (proc-obj-expand-set! obj x)          (vector-set! obj 9 x))
(define (proc-obj-inlinable?-set! obj x)      (vector-set! obj 10 x))
(define (proc-obj-inline-set! obj x)          (vector-set! obj 11 x))
(define (proc-obj-jump-inlinable?-set! obj x) (vector-set! obj 12 x))
(define (proc-obj-jump-inline-set! obj x)     (vector-set! obj 13 x))
(define (proc-obj-specialize-set! obj x)      (vector-set! obj 14 x))
(define (proc-obj-simplify-set! obj x)        (vector-set! obj 15 x))
(define (proc-obj-side-effects?-set! obj x)   (vector-set! obj 16 x))
(define (proc-obj-strict-pat-set! obj x)      (vector-set! obj 17 x))
(define (proc-obj-lift-pat-set! obj x)        (vector-set! obj 18 x))
(define (proc-obj-type-set! obj x)            (vector-set! obj 19 x))
(define (proc-obj-standard-set! obj x)        (vector-set! obj 20 x))
(define (proc-obj-dead-end?-set! obj x)       (vector-set! obj 21 x))

(define (make-pattern nb-parms nb-opts nb-keys rest?)
  (let* ((max-pos-args (- nb-parms nb-keys (if rest? 1 0)))
         (min-args (- max-pos-args nb-opts)))
    (let loop ((i
                (- max-pos-args 1))
               (pattern
                (if (or (> nb-keys 0) rest?)
                  max-pos-args
                  (list max-pos-args))))
      (if (>= i min-args)
        (loop (- i 1) (cons i pattern))
        pattern))))

(define (pattern-member? n pat) ; tests if 'n' is a member of pattern 'pat'
  (cond ((pair? pat)
         (if (= (car pat) n) #t (pattern-member? n (cdr pat))))
        ((null? pat)
         #f)
        (else
         (<= pat n))))

(define (type-name type)
  (if (pair? type) (car type) type))

(define (type-pot-fut? type)
  (pair? type))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Basic block set manipulation:
;; ----------------------------

;; Virtual instructions have a linear structure.  However, this is not
;; how they are put together to form a piece of code.  Rather, virtual
;; instructions are grouped into 'basic blocks' which are 'linked'
;; together.  A basic block is a 'label' instruction followed by a
;; sequence of non-branching instructions (i.e. 'apply', 'copy' or
;; 'close') terminated by a single branch instruction (i.e. 'ifjump',
;; 'jump' or 'switch').  Links between basic blocks are denoted using
;; label references.  When a basic block ends with an 'ifjump'
;; instruction, the block is linked to the two basic blocks
;; corresponding to the two possible control paths out of the 'ifjump'
;; instruction.  When a basic block ends with a 'switch' instruction, the
;; block is linked to as many basic blocks as there are cases and the
;; default.  When a basic block ends with a 'jump' instruction, there
;; is either zero or one link.
;;
;; Basic blocks naturally group together to form 'basic block sets'.  A
;; basic block set describes all the code of a procedure.

(define (make-bbs)
  (vector bbs-tag
          bbs-first-lbl                ;; 1 - next assignable label number
          (make-stretchable-vector #f) ;; 2 - vector of basic blocks
          #f))                         ;; 3 - entry label number

(define bbs-first-lbl 1)

(define bbs-tag (list 'bbs))

(define (bbs? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) bbs-tag)))

(define (bbs-next-lbl-num bbs)             (vector-ref bbs 1))
(define (bbs-next-lbl-num-set! bbs lbl)    (vector-set! bbs 1 lbl))
(define (bbs-basic-blocks bbs)             (vector-ref bbs 2))
(define (bbs-basic-blocks-set! bbs blocks) (vector-set! bbs 2 blocks))
(define (bbs-entry-lbl-num bbs)            (vector-ref bbs 3))
(define (bbs-entry-lbl-num-set! bbs lbl)   (vector-set! bbs 3 lbl))

(define (bbs-for-each-bb proc bbs)
  (stretchable-vector-for-each
    (lambda (bb i) (if bb (proc bb)))
    (bbs-basic-blocks bbs)))

(define (bbs-bb-remove! bbs lbl)
  (stretchable-vector-set! (bbs-basic-blocks bbs) lbl #f))

(define (bbs-new-lbl! bbs)
  (let ((n (bbs-next-lbl-num bbs)))
    (bbs-next-lbl-num-set! bbs (+ n 1))
    n))

(define (lbl-num->bb lbl bbs)
  (stretchable-vector-ref (bbs-basic-blocks bbs) lbl))

;; Basic block manipulation procedures:

(define (make-bb label-instr bbs)
  (let ((bb (vector
              label-instr   ; 0 - 'label' instr
              (queue-empty) ; 1 - sequence of non-branching instrs
              '()           ; 2 - branch instruction
              '()           ; 3 - basic blocks referenced by this block
              '())))        ; 4 - basic blocks which jump to this block
                            ;     (both filled in by 'bbs-purify')
    (stretchable-vector-set!
      (bbs-basic-blocks bbs)
      (label-lbl-num label-instr)
      bb)
    bb))

(define (bb-lbl-num bb)                  (label-lbl-num (vector-ref bb 0)))
(define (bb-label-type bb)               (if (not bb) (step)) (label-type (vector-ref bb 0)))
(define (bb-label-instr bb)              (vector-ref bb 0))
(define (bb-label-instr-set! bb l)       (vector-set! bb 0 l))
(define (bb-non-branch-instrs bb)        (queue->list (vector-ref bb 1)))
(define (bb-non-branch-instrs-set! bb l) (vector-set! bb 1 (list->queue l)))
(define (bb-branch-instr bb)             (vector-ref bb 2))
(define (bb-branch-instr-set! bb b)      (vector-set! bb 2 b))
(define (bb-references bb)               (vector-ref bb 3))
(define (bb-references-set! bb l)        (vector-set! bb 3 l))
(define (bb-precedents bb)               (vector-ref bb 4))
(define (bb-precedents-set! bb l)        (vector-set! bb 4 l))

(define (bb-entry-frame-size bb)
  (frame-size (gvm-instr-frame (bb-label-instr bb))))

(define (bb-exit-frame-size bb)
  (frame-size (gvm-instr-frame (bb-branch-instr bb))))

(define (bb-slots-gained bb)
  (- (bb-exit-frame-size bb) (bb-entry-frame-size bb)))

(define (bb-put-non-branch! bb gvm-instr)
  (queue-put! (vector-ref bb 1) gvm-instr))

(define (bb-put-branch! bb gvm-instr)
  (vector-set! bb 2 gvm-instr))

(define (bb-add-reference! bb lbl)
  (if (not (memv lbl (vector-ref bb 3)))
      (vector-set! bb 3 (cons lbl (vector-ref bb 3))))
  lbl)

(define (bb-add-precedent! bb lbl)
  (if (not (memv lbl (vector-ref bb 4)))
      (vector-set! bb 4 (cons lbl (vector-ref bb 4))))
  lbl)

(define (bb-last-non-branch-instr bb)
  (let ((non-branch-instrs (bb-non-branch-instrs bb)))
    (if (null? non-branch-instrs)
        (bb-label-instr bb)
        (let loop ((lst non-branch-instrs))
          (if (pair? (cdr lst))
              (loop (cdr lst))
              (car lst))))))

;; Virtual machine instruction representation:

(define (gvm-instr-type gvm-instr)    (vector-ref gvm-instr 0))
(define (gvm-instr-frame gvm-instr)   (vector-ref gvm-instr 1))
(define (gvm-instr-comment gvm-instr) (vector-ref gvm-instr 2))

(define (make-label-simple lbl-num frame comment)
  (vector 'label frame comment lbl-num 'simple))

(define (make-label-entry lbl-num nb-parms opts keys rest? closed? frame comment)
  (vector 'label frame comment lbl-num 'entry nb-parms opts keys rest? closed?))

(define (make-label-return lbl-num frame comment)
  (vector 'label frame comment lbl-num 'return))

(define (make-label-task-entry lbl-num frame comment)
  (vector 'label frame comment lbl-num 'task-entry))

(define (make-label-task-return lbl-num frame comment)
  (vector 'label frame comment lbl-num 'task-return))

(define (label-lbl-num gvm-instr)        (vector-ref gvm-instr 3))
(define (label-lbl-num-set! gvm-instr n) (vector-set! gvm-instr 3 n))
(define (label-type gvm-instr)           (vector-ref gvm-instr 4))

(define (label-entry-nb-parms gvm-instr) (vector-ref gvm-instr 5))
(define (label-entry-opts gvm-instr)     (vector-ref gvm-instr 6))
(define (label-entry-keys gvm-instr)     (vector-ref gvm-instr 7))
(define (label-entry-rest? gvm-instr)    (vector-ref gvm-instr 8))
(define (label-entry-closed? gvm-instr)  (vector-ref gvm-instr 9))

(define (make-apply prim opnds loc frame comment)
  (vector 'apply frame comment prim opnds loc))
(define (apply-prim gvm-instr)  (vector-ref gvm-instr 3))
(define (apply-opnds gvm-instr) (vector-ref gvm-instr 4))
(define (apply-loc gvm-instr)   (vector-ref gvm-instr 5))

(define (make-copy opnd loc frame comment)
  (vector 'copy frame comment opnd loc))

(define (copy-opnd gvm-instr) (vector-ref gvm-instr 3))
(define (copy-loc gvm-instr)  (vector-ref gvm-instr 4))

(define (make-close parms frame comment)
  (vector 'close frame comment parms))
(define (close-parms gvm-instr) (vector-ref gvm-instr 3))

(define (make-closure-parms loc lbl opnds)
  (vector loc lbl opnds))
(define (closure-parms-loc x)   (vector-ref x 0))
(define (closure-parms-lbl x)   (vector-ref x 1))
(define (closure-parms-opnds x) (vector-ref x 2))

(define (make-ifjump test opnds true false poll? frame comment)
  (vector 'ifjump frame comment test opnds true false poll?))
(define (ifjump-test gvm-instr)  (vector-ref gvm-instr 3))
(define (ifjump-opnds gvm-instr) (vector-ref gvm-instr 4))
(define (ifjump-true gvm-instr)  (vector-ref gvm-instr 5))
(define (ifjump-false gvm-instr) (vector-ref gvm-instr 6))
(define (ifjump-poll? gvm-instr) (vector-ref gvm-instr 7))

(define (make-switch opnd cases default poll? frame comment)
  (vector 'switch frame comment opnd cases default poll?))
(define (switch-opnd gvm-instr)    (vector-ref gvm-instr 3))
(define (switch-cases gvm-instr)   (vector-ref gvm-instr 4))
(define (switch-default gvm-instr) (vector-ref gvm-instr 5))
(define (switch-poll? gvm-instr)   (vector-ref gvm-instr 6))

(define (make-switch-case obj lbl) (cons obj lbl))
(define (switch-case-obj switch-case) (car switch-case))
(define (switch-case-lbl switch-case) (cdr switch-case))

(define (make-jump opnd ret nb-args poll? safe? frame comment)
  (vector 'jump frame comment opnd ret nb-args poll? safe?))
(define (jump-opnd gvm-instr)    (vector-ref gvm-instr 3))
(define (jump-ret gvm-instr)     (vector-ref gvm-instr 4))
(define (jump-nb-args gvm-instr) (vector-ref gvm-instr 5))
(define (jump-poll? gvm-instr)   (vector-ref gvm-instr 6))
(define (jump-safe? gvm-instr)   (vector-ref gvm-instr 7))
(define (first-class-jump? gvm-instr) (jump-nb-args gvm-instr))

(define (make-comment)
  (cons 'comment '()))

(define (comment-put! comment name val)
  (set-cdr! comment (cons (cons name val) (cdr comment))))

(define (comment-get comment name)
  (and comment
       (let ((x (assq name (cdr comment))))
         (if x (cdr x) #f))))

;; Cloning of basic blocks.

(define (bb-clone bb bbs)
  (let ((new-bb (make-bb (bb-label-instr bb) bbs)))
    (bb-non-branch-instrs-set! new-bb (bb-non-branch-instrs bb))
    (bb-branch-instr-set! new-bb (bb-branch-instr bb))
    new-bb))

(define (bb-clone-replacing-lbls bb bbs replacement-lbl-num update-label-instr?)

  (let ((new-bb
         (make-bb (if update-label-instr?
                      (gvm-instr-clone-replacing-lbls
                       (bb-label-instr bb)
                       replacement-lbl-num)
                      (bb-label-instr bb))
                  bbs)))

    (define (clone instr)
      (gvm-instr-clone-replacing-lbls instr replacement-lbl-num))

    (bb-non-branch-instrs-set! new-bb (map clone (bb-non-branch-instrs bb)))

    (bb-branch-instr-set! new-bb (clone (bb-branch-instr bb)))

    new-bb))

(define (gvm-instr-clone-replacing-lbls instr replacement-lbl-num)

  (define (clone-gvm-opnd opnd)
    (if opnd
        (cond ((lbl? opnd)
               (make-lbl (replacement-lbl-num (lbl-num opnd))))
              ((clo? opnd)
               (make-clo (clone-gvm-opnd (clo-base opnd)) (clo-index opnd)))
              (else
               opnd))
        opnd))

  (define (clone-closure-parms p)
    (make-closure-parms
     (clone-gvm-opnd (closure-parms-loc p))
     (replacement-lbl-num (closure-parms-lbl p))
     (map clone-gvm-opnd (closure-parms-opnds p))))

  (case (gvm-instr-type instr)

    ((label)
     (case (label-type instr)

       ((simple)
        (make-label-simple
         (replacement-lbl-num (label-lbl-num instr))
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

       ((entry)
        (make-label-entry
         (replacement-lbl-num (label-lbl-num instr))
         (label-entry-nb-parms instr)
         (label-entry-opts instr)
         (label-entry-keys instr)
         (label-entry-rest? instr)
         (label-entry-closed? instr)
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

       ((return)
        (make-label-return
         (replacement-lbl-num (label-lbl-num instr))
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

       ((task-entry)
        (make-label-task-entry
         (replacement-lbl-num (label-lbl-num instr))
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

       ((task-return)
        (make-label-task-return
         (replacement-lbl-num (label-lbl-num instr))
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

       (else
        (compiler-internal-error
         "gvm-instr-clone-replacing-lbls, unknown 'instr':" instr))))

    ((apply)
     (make-apply
      (apply-prim instr)
      (map clone-gvm-opnd (apply-opnds instr))
      (clone-gvm-opnd (apply-loc instr))
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    ((copy)
     (make-copy
      (clone-gvm-opnd (copy-opnd instr))
      (clone-gvm-opnd (copy-loc instr))
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    ((close)
     (make-close
      (map clone-closure-parms (close-parms instr))
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    ((ifjump)
     (make-ifjump
      (ifjump-test instr)
      (map clone-gvm-opnd (ifjump-opnds instr))
      (replacement-lbl-num (ifjump-true instr))
      (replacement-lbl-num (ifjump-false instr))
      (ifjump-poll? instr)
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    ((switch)
     (make-switch
      (clone-gvm-opnd (switch-opnd instr))
      (map (lambda (c)
             (make-switch-case
              (switch-case-obj c)
              (replacement-lbl-num (switch-case-lbl c))))
           (switch-cases instr))
      (replacement-lbl-num (switch-default instr))
      (switch-poll? instr)
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    ((jump)
     (make-jump
      (clone-gvm-opnd (jump-opnd instr))
      (and (jump-ret instr) (replacement-lbl-num (jump-ret instr)))
      (jump-nb-args instr)
      (jump-poll? instr)
      (jump-safe? instr)
      (gvm-instr-frame instr)
      (gvm-instr-comment instr)))

    (else
     (compiler-internal-error
      "gvm-instr-clone-replacing-lbls, unknown 'instr':" instr))))

;; Determining basic block references and precedents.

(define (bbs-determine-refs! bbs)

  (define (get-bb lbl)
    (lbl-num->bb lbl bbs))

  (bbs-for-each-bb
   (lambda (bb)
     (bb-precedents-set! bb '()))
   bbs)

  (bbs-for-each-bb
   (lambda (bb)
     (bb-determine-refs! bb get-bb))
   bbs))

(define (bb-determine-refs! bb get-bb)

  (bb-references-set! bb '())

  (gvm-instr-determine-refs! (bb-label-instr bb) bb get-bb)
  (for-each (lambda (instr) (gvm-instr-determine-refs! instr bb get-bb))
            (bb-non-branch-instrs bb))
  (gvm-instr-determine-refs! (bb-branch-instr bb) bb get-bb))

(define (gvm-instr-determine-refs! instr bb get-bb)

  (define (reference lbl)
    (bb-add-reference! bb lbl))

  (define (direct-branch lbl)
    (bb-add-precedent! (get-bb (reference lbl)) (bb-lbl-num bb)))

  (define (scan-opnd gvm-opnd)
    (cond ((not gvm-opnd))
          ((lbl? gvm-opnd)
           (reference (lbl-num gvm-opnd)))
          ((clo? gvm-opnd)
           (scan-opnd (clo-base gvm-opnd)))))

  (case (gvm-instr-type instr)

    ((label)
     '())

    ((apply)
     (for-each scan-opnd (apply-opnds instr))
     (if (apply-loc instr)
         (scan-opnd (apply-loc instr))))

    ((copy)
     (scan-opnd (copy-opnd instr))
     (scan-opnd (copy-loc instr)))

    ((close)
     (for-each (lambda (parm)
                 (reference (closure-parms-lbl parm))
                 (scan-opnd (closure-parms-loc parm))
                 (for-each scan-opnd (closure-parms-opnds parm)))
               (close-parms instr)))

    ((ifjump)
     (for-each scan-opnd (ifjump-opnds instr))
     (direct-branch (ifjump-true instr))
     (direct-branch (ifjump-false instr)))

    ((switch)
     (scan-opnd (switch-opnd instr))
     (for-each (lambda (c)
                 (direct-branch (switch-case-lbl c)))
               (switch-cases instr))
     (direct-branch (switch-default instr)))

    ((jump)
     (let ((opnd (jump-opnd instr)))
       (if (lbl? opnd)
           (direct-branch (lbl-num opnd))
           (scan-opnd (jump-opnd instr))))
     (let ((ret (jump-ret instr)))
       (if ret
           (reference ret))))

    (else
     (compiler-internal-error
      "gvm-instr-determine-refs!, unknown GVM instruction type"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'Purification' of basic block sets:
;; ----------------------------------

(define (purify-procs procs)

  (for-each
   (lambda (proc)
     (let ((bbs (proc-obj-code proc)))
       (if (bbs? bbs)
           (proc-obj-code-set! proc (bbs-purify bbs)))))
   procs)

  procs)

;; This step removes unreachable basic blocks (i.e. dead code), duplicate
;; basic blocks (i.e. common code), useless jumps and jump cascades from
;; a basic block set.  It also orders the basic blocks so that the destination
;; of a branch is put (if possible) right after the branch instruction.  The
;; 'references' and 'precedents' fields of each basic block are also filled in
;; through the process.  The first basic block of a 'purified' basic block set
;; is always the entry point.

(define (bbs-purify bbs)
  (let loop ((bbs1 bbs))
    (let* ((bbs2 (bbs-remove-jump-cascades bbs1))
           (bbs3 (bbs-remove-dead-code bbs2))
           (bbs4 (bbs-remove-common-code bbs3))
           (bbs5 (bbs-remove-useless-jumps bbs4)))
      (if (not (eq? bbs3 bbs5)) ;; iterate until code does not change
          (loop bbs5)
          (bbs-order bbs5)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 1, Jump cascade removal:

(define (bbs-remove-jump-cascades bbs)

  (let ((new-bbs (make-bbs))
        (changed? #f)
        (lbl-changed? #f))

    (define (empty-bb? bb)
      (and (eq? (bb-label-type bb) 'simple)     ;; simple label and
           (null? (bb-non-branch-instrs bb))))  ;; no non-branching instrs

    (define (jump-to-non-entry-lbl? branch)
      (and (eq? (gvm-instr-type branch) 'jump)
           (not (first-class-jump? branch)) ;; not a jump to an entry label
           (jump-lbl? branch)))

    (define (jump-cascade-to dest-lbl first-jump thunk)
      (let loop ((lbl dest-lbl)
                 (last-jump/ret (and (jump-ret first-jump) first-jump))
                 (fs (frame-size (gvm-instr-frame first-jump)))
                 (poll? (jump-poll? first-jump))
                 (seen '()))
        (if (memv lbl seen) ;; infinite loop?
            (thunk lbl fs last-jump/ret poll?)
            (let ((bb (lbl-num->bb lbl bbs)))
              (if (and (empty-bb? bb) (<= (bb-slots-gained bb) 0))
                  (let* ((branch
                          (bb-branch-instr bb))
                         (jump-lbl
                          (jump-to-non-entry-lbl? branch)))
                    (if jump-lbl
                        (loop
                         jump-lbl
                         (if (jump-ret branch) branch last-jump/ret)
                         (+ fs (bb-slots-gained bb))
                         (or (jump-poll? branch)
                             poll?)
                         (cons lbl seen))
                        (thunk lbl fs last-jump/ret poll?)))
                  (thunk lbl fs last-jump/ret poll?))))))

    (define (find-equiv-lbl start-lbl poll?)
      (let loop ((lbl start-lbl) (seen '()))
        (if (memv lbl seen) ;; infinite loop?
            lbl
            (let ((bb (lbl-num->bb lbl bbs)))
              (if (empty-bb? bb)
                  (let* ((branch
                          (bb-branch-instr bb))
                         (jump-lbl
                          (jump-to-non-entry-lbl? branch)))
                    (if (and jump-lbl
                             (not (jump-ret branch))
                             (or poll?
                                 (not (jump-poll? branch)))
                             (= (bb-slots-gained bb) 0))
                        (loop jump-lbl (cons lbl seen))
                        lbl))
                  lbl)))))

    (define (equiv-lbl start-lbl poll?)
      (let ((lbl (find-equiv-lbl start-lbl poll?)))
        (if (not (eqv? lbl start-lbl))
            (set! lbl-changed? #t))
        lbl))

    (define (remove-cascade! bb)
      (let ((branch (bb-branch-instr bb)))

        (define (replace-branch-by last-jump/ret new-branch-instr)
          (set! changed? #t)
          (let ((new-bb (make-bb (bb-label-instr bb) new-bbs)))
            (bb-non-branch-instrs-set! new-bb (bb-non-branch-instrs bb))
            (if (not last-jump/ret)
                (bb-branch-instr-set! new-bb new-branch-instr)
                (let* ((lbl2
                        (bbs-new-lbl! new-bbs))
                       (new-bb2
                        (make-bb
                         (make-label-simple
                          lbl2
                          (gvm-instr-frame last-jump/ret)
                          (gvm-instr-comment last-jump/ret))
                         new-bbs)))
                  (bb-branch-instr-set!
                   new-bb
                   (make-jump
                    (make-lbl lbl2)
                    (jump-ret last-jump/ret)
                    #f
                    #f
                    #f
                    (gvm-instr-frame last-jump/ret)
                    (gvm-instr-comment last-jump/ret)))
                  (bb-branch-instr-set! new-bb2 new-branch-instr)))))

        (stretchable-vector-set!
         (bbs-basic-blocks new-bbs)
         (bb-lbl-num bb)
         bb)

        (case (gvm-instr-type branch)

          ((ifjump) ;; branch is an 'ifjump'
           (set! lbl-changed? #f)
           (let* ((new-poll?
                   (ifjump-poll? branch))
                  (new-true
                   (equiv-lbl (ifjump-true branch)
                              new-poll?))
                  (new-false
                   (equiv-lbl (ifjump-false branch)
                              new-poll?)))
             (if lbl-changed?
                 (replace-branch-by
                  #f
                  (make-ifjump
                   (ifjump-test branch)
                   (ifjump-opnds branch)
                   new-true
                   new-false
                   new-poll?
                   (gvm-instr-frame branch)
                   (gvm-instr-comment branch))))))

          ((switch) ;; branch is a 'switch'
           (set! lbl-changed? #f)
           (let* ((new-poll?
                   (switch-poll? branch))
                  (new-cases
                   (map (lambda (c)
                          (make-switch-case
                           (switch-case-obj c)
                           (equiv-lbl (switch-case-lbl c)
                                      new-poll?)))
                        (switch-cases branch)))
                  (new-default
                   (equiv-lbl (switch-default branch)
                              new-poll?)))
             (if lbl-changed?
                 (replace-branch-by
                  #f
                  (make-switch
                   (switch-opnd branch)
                   new-cases
                   new-default
                   new-poll?
                   (gvm-instr-frame branch)
                   (gvm-instr-comment branch))))))

          ((jump) ;; branch is a 'jump'
           (let ((dest-lbl (jump-lbl? branch)))
             (if (and dest-lbl
                      (not (first-class-jump? branch))) ;; but not to an entry label
                 (jump-cascade-to
                  dest-lbl
                  branch
                  (lambda (lbl fs last-jump/ret poll?)
                    (let* ((dest-bb (lbl-num->bb lbl bbs))
                           (last-branch (bb-branch-instr dest-bb)))
                      (if (and (empty-bb? dest-bb)
                               (or (not poll?) ;;TODO: remove this part
                                   (case (gvm-instr-type last-branch)
                                     ((ifjump)
                                      (ifjump-poll? last-branch))
                                     ((switch)
                                      (switch-poll? last-branch))
                                     ((jump)
                                      (jump-poll? last-branch))
                                     (else
                                      #f))))

                          (let* ((new-fs (+ fs (bb-slots-gained dest-bb)))
                                 (new-frame (frame-truncate
                                             (gvm-instr-frame branch)
                                             new-fs)))

                            (define (adjust-opnd opnd)
                              (cond ((stk? opnd)
                                     (make-stk
                                      (+ (- fs (bb-entry-frame-size dest-bb))
                                         (stk-num opnd))))
                                    ((clo? opnd)
                                     (make-clo (adjust-opnd (clo-base opnd))
                                               (clo-index opnd)))
                                    (else
                                     opnd)))

                            (case (gvm-instr-type last-branch)

                              ((ifjump)
                               (let* ((new-poll?
                                       (or (ifjump-poll? last-branch)
                                           poll?))
                                      (new-true
                                       (equiv-lbl (ifjump-true last-branch)
                                                  new-poll?))
                                      (new-false
                                       (equiv-lbl (ifjump-false last-branch)
                                                  new-poll?)))
                                 (replace-branch-by
                                  last-jump/ret
                                  (make-ifjump
                                   (ifjump-test last-branch)
                                   (map adjust-opnd
                                        (ifjump-opnds last-branch))
                                   new-true
                                   new-false
                                   new-poll?
                                   new-frame
                                   (gvm-instr-comment last-branch)))))

                              ((switch)
                               (let* ((new-poll?
                                       (or (switch-poll? last-branch)
                                           poll?))
                                      (new-cases
                                       (map (lambda (c)
                                              (make-switch-case
                                               (switch-case-obj c)
                                               (equiv-lbl (switch-case-lbl c)
                                                          new-poll?)))
                                            (switch-cases last-branch)))
                                      (new-default
                                       (equiv-lbl (switch-default last-branch)
                                                  new-poll?)))
                                 (replace-branch-by
                                  last-jump/ret
                                  (make-switch
                                   (adjust-opnd (switch-opnd last-branch))
                                   new-cases
                                   new-default
                                   new-poll?
                                   new-frame
                                   (gvm-instr-comment last-branch)))))

                              ((jump)
                               (let* ((ret
                                       (and last-jump/ret
                                            (jump-ret last-jump/ret)))
                                      (new-ret
                                       (or (jump-ret last-branch)
                                           ret))
                                      (new-poll?
                                       (or (jump-poll? last-branch)
                                           poll?))
                                      (opnd
                                       (jump-opnd last-branch))
                                      (dead-end?
                                       (and (obj? opnd)
                                            (let ((val (obj-val opnd)))
                                              (and (proc-obj? val)
                                                   (proc-obj-dead-end? val))))))
                                 (if (not dead-end?)
                                     (replace-branch-by
                                      #f
                                      (make-jump
                                       (if (and ret (eqv? opnd return-addr-reg))
                                           (make-lbl ret)
                                           (adjust-opnd opnd))
                                       new-ret
                                       (jump-nb-args last-branch)
                                       new-poll?
                                       (jump-safe? last-branch)
                                       new-frame
                                       (gvm-instr-comment last-branch))))))

                              (else
                               (compiler-internal-error
                                "bbs-remove-jump-cascades, unknown branch type"))))

                          (let* ((ret
                                  (and last-jump/ret
                                       (jump-ret last-jump/ret)))
                                 (new-ret
                                  (or (jump-ret branch)
                                      ret))
                                 (new-poll?
                                  (or (jump-poll? branch)
                                      poll?)))
                            (if (or (not (eqv? new-ret ret))
                                    (not (eqv? new-poll? poll?))
                                    (not (= lbl dest-lbl)))
                                (replace-branch-by
                                 #f
                                 (make-jump
                                  (make-lbl lbl)
                                  new-ret
                                  (jump-nb-args branch)
                                  new-poll?
                                  (jump-safe? branch)
                                  (frame-truncate
                                   (gvm-instr-frame branch)
                                   fs)
                                  (gvm-instr-comment branch))))))))))))

          (else
           (compiler-internal-error
            "bbs-remove-jump-cascades, unknown branch type")))))

    (bbs-next-lbl-num-set! new-bbs (bbs-next-lbl-num bbs))
    (bbs-entry-lbl-num-set! new-bbs (bbs-entry-lbl-num bbs))

    (bbs-for-each-bb remove-cascade! bbs)

    (if changed? new-bbs bbs)))

(define (jump-lbl? branch)
  (let ((opnd (jump-opnd branch)))
    (if (lbl? opnd) (lbl-num opnd) #f)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 2, Dead code removal:

(define (bbs-remove-dead-code bbs)

  (let ((new-bbs (make-bbs))
        (work-list (queue-empty)))

    (define (get-bb lbl)
      (reachable lbl))

    (define (reachable lbl)
      (or (lbl-num->bb lbl new-bbs)
          (let ((new-bb (bb-clone (lbl-num->bb lbl bbs) new-bbs)))
            (queue-put! work-list new-bb)
            new-bb)))

    (bbs-next-lbl-num-set! new-bbs (bbs-next-lbl-num bbs))
    (bbs-entry-lbl-num-set! new-bbs (bbs-entry-lbl-num bbs))

    (reachable (bbs-entry-lbl-num bbs))

    (let loop ()
      (if (not (queue-empty? work-list))
          (let ((bb (queue-get! work-list)))
            (begin
              (bb-determine-refs! bb get-bb)
              (for-each reachable (bb-references bb))
              (loop)))))

    new-bbs))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 3, Common code removal:

(define (bbs-remove-common-code bbs)
  (let ((n (bbs-next-lbl-num bbs)))
    (if (> n 300) ;; if code is too large, don't optimize
        bbs
        (bbs-remove-common-code-aux bbs))))

(define (bbs-remove-common-code-aux bbs)

  (let* ((n (bbs-next-lbl-num bbs))
         (hash-table-length (if (< n 50) 43 403))
         (hash-table (make-vector hash-table-length '()))
         (prim-table '())
         (lbl-map (make-stretchable-vector #f))
         (new-bbs (make-bbs))
         (changed? #f))

    (define (hash-prim prim)
      (let ((n (length prim-table))
            (i (pos-in-list prim prim-table)))
        (if i
            (- n i)
            (begin
              (set! prim-table (cons prim prim-table))
              (+ n 1)))))

    (define (hash-opnds l)
      ;; assumes that operands are encoded with numbers
      (let loop ((l l) (n 0))
        (if (pair? l)
            (loop (cdr l)
                  (let ((x (car l)))
                    (if (lbl? x)
                        n ;; labels must be ignored (they might end up equal)
                        (modulo (+ (* n 10000) x) hash-table-length))))
            n)))

    (define (hash-bb bb)
      ;; compute hash address for a basic block using the branch
      ;; instruction and ignoring labels
      (let ((branch (bb-branch-instr bb)))
        (modulo
         (case (gvm-instr-type branch)
           ((ifjump)
            (+ (hash-opnds (ifjump-opnds branch))
               (* 10 (hash-prim (ifjump-test branch)))
               (* 100 (frame-size (gvm-instr-frame branch)))))
           ((switch)
            (+ (hash-opnds (list (switch-opnd branch)))
               (* 10 (length (switch-cases branch)))
               (* 100 (frame-size (gvm-instr-frame branch)))))
           ((jump)
            (+ (hash-opnds (list (jump-opnd branch)))
               (* 10 (or (jump-nb-args branch) -1))
               (* 100 (frame-size (gvm-instr-frame branch)))))
           (else
            0))
         hash-table-length)))

    (define (replacement-lbl-num lbl)
      (or (stretchable-vector-ref lbl-map lbl) lbl))

    (define (add-map! bb1 bb2) ;; bb1 should be replaced by bb2
      (stretchable-vector-set!
       lbl-map
       (bb-lbl-num bb1)
       (bb-lbl-num bb2)))

    (define (remove-map! bb)
      (stretchable-vector-set!
       lbl-map
       (bb-lbl-num bb)
       #f))

    (define (enter-bb! bb) ;; enter a basic block in the hash table

      (stretchable-vector-set!
       (bbs-basic-blocks new-bbs)
       (bb-lbl-num bb)
       bb)

      (let ((h (hash-bb bb)))
        (vector-set! hash-table
                     h
                     (add-bb bb (vector-ref hash-table h)))))

    (define (add-bb bb lst) ;; add basic block 'bb' to list of basic blocks
      (if (pair? lst)
          (let ((bb2 (car lst))) ;; pick next basic block in list

            (add-map! bb bb2) ;; for now, assume that 'bb' = 'bb2'

            (if (eqv-bb? bb bb2) ;; are they the same?

                (begin
                  (set! changed? #t)
                  lst)

                (begin
                  (remove-map! bb) ;; they are not the same!
                  (if (eqv-gvm-instr? (bb-branch-instr bb)
                                      (bb-branch-instr bb2))

                      (extract-common-tail ;; check if tail is the same
                       bb
                       bb2
                       (lambda (head head2 tail)
                         (if (<= (length tail) 10) ;; common tail long enough?

                             ;; no, so try rest of list
                             (cons bb2 (add-bb bb (cdr lst)))

                             ;; create bb for common tail
                             (let* ((lbl-common
                                     (bbs-new-lbl! new-bbs))
                                    (branch
                                     (bb-branch-instr bb))
                                    (fs-common
                                     (need-gvm-instrs tail branch))
                                    (frame-common
                                     (frame-truncate
                                      (gvm-instr-frame
                                       (if (null? head)
                                           (bb-label-instr bb)
                                           (car head)))
                                      fs-common))
                                    (comment-common
                                     (gvm-instr-comment (car tail)))
                                    (bb-common
                                     (make-bb
                                      (make-label-simple
                                       lbl-common
                                       frame-common
                                       comment-common)
                                      new-bbs))
                                    (new-bb
                                     (make-bb (bb-label-instr bb) new-bbs))
                                    (new-bb2
                                     (make-bb (bb-label-instr bb2) new-bbs)))

                               ;; create bb for common part
                               (bb-non-branch-instrs-set! bb-common tail)
                               (bb-branch-instr-set! bb-common branch)

                               ;; create trimmed bb2 jumping to common part
                               (bb-non-branch-instrs-set!
                                new-bb2
                                (reverse head2))
                               (bb-branch-instr-set!
                                new-bb2
                                (make-jump
                                 (make-lbl lbl-common)
                                 #f
                                 #f
                                 #f
                                 #f
                                 frame-common
                                 comment-common))

                               ;; create trimmed bb jumping to common part
                               (bb-non-branch-instrs-set!
                                new-bb
                                (reverse head))
                               (bb-branch-instr-set!
                                new-bb
                                (make-jump
                                 (make-lbl lbl-common)
                                 #f
                                 #f
                                 #f
                                 #f
                                 frame-common
                                 comment-common))

                               (set! changed? #t)

                               (add-bb bb-common (cdr lst))))))

                      (cons bb2 (add-bb bb (cdr lst)))))))

          (list bb)))

    (define (extract-common-tail bb1 bb2 cont)
      (let loop ((lst1 (reverse (bb-non-branch-instrs bb1)))
                 (lst2 (reverse (bb-non-branch-instrs bb2)))
                 (tail '()))
        (if (and (pair? lst1) (pair? lst2))
            (let ((i1 (car lst1))
                  (i2 (car lst2)))
              (if (eqv-gvm-instr? i1 i2)
                  (loop (cdr lst1) (cdr lst2) (cons i1 tail))
                  (cont lst1 lst2 tail)))
            (cont lst1 lst2 tail))))

    (define (eqv-bb? bb1 bb2)
      (let ((bb1-non-branch (bb-non-branch-instrs bb1))
            (bb2-non-branch (bb-non-branch-instrs bb2)))
        (and (= (length bb1-non-branch) (length bb2-non-branch))
             (eqv-gvm-instr? (bb-label-instr bb1) (bb-label-instr bb2))
             (eqv-gvm-instr? (bb-branch-instr bb1) (bb-branch-instr bb2))
             (eqv-list? eqv-gvm-instr? bb1-non-branch bb2-non-branch))))

    (define (eqv-list? pred? lst1 lst2)
      (if (pair? lst1)
          (and (pair? lst2)
               (pred? (car lst1) (car lst2))
               (eqv-list? pred? (cdr lst1) (cdr lst2)))
          (not (pair? lst2))))

    (define (eqv-lbl-num? lbl1 lbl2)
      (= (replacement-lbl-num lbl1)
         (replacement-lbl-num lbl2)))

    (define (eqv-gvm-opnd? opnd1 opnd2)
      (if (not opnd1)
          (not opnd2)
          (and opnd2
               (cond ((lbl? opnd1)
                      (and (lbl? opnd2)
                           (eqv-lbl-num? (lbl-num opnd1) (lbl-num opnd2))))
                     ((clo? opnd1)
                      (and (clo? opnd2)
                           (= (clo-index opnd1) (clo-index opnd2))
                           (eqv-gvm-opnd? (clo-base opnd1)
                                          (clo-base opnd2))))
                     (else
                      (eqv? opnd1 opnd2))))))

    (define (eqv-key-pair? key-pair1 key-pair2)
      (and (eq? (car key-pair1) (car key-pair2))
           (eqv-gvm-opnd? (cdr key-pair1) (cdr key-pair2))))

    (define (eqv-gvm-instr? instr1 instr2)

      (define (eqv-closure-parms? p1 p2)
        (and (eqv-gvm-opnd? (closure-parms-loc p1)
                            (closure-parms-loc p2))
             (eqv-lbl-num? (closure-parms-lbl p1)
                           (closure-parms-lbl p2))
             (eqv-list? eqv-gvm-opnd?
                        (closure-parms-opnds p1)
                        (closure-parms-opnds p2))))

      (define (has-debug-info? instr)
        (let ((node (comment-get (gvm-instr-comment instr) 'node)))
          (and node
               (let ((env (node-env node)))
                 (and (debug? env)
                      (or (debug-location? env)
                          (debug-source? env)
                          (debug-environments? env)))))))

      (let ((type1 (gvm-instr-type instr1))
            (type2 (gvm-instr-type instr2)))
        (and (eq? type1 type2)
             (frame-eq? (gvm-instr-frame instr1) (gvm-instr-frame instr2))
             (not (has-debug-info? instr1))
             (not (has-debug-info? instr2))
             (case type1

               ((label)
                (let ((ltype1 (label-type instr1))
                      (ltype2 (label-type instr2)))
                  (and (eq? ltype1 ltype2)
                       (case ltype1
                         ((simple return task-entry task-return)
                          #t)
                         ((entry)
                          (and (= (label-entry-nb-parms instr1)
                                  (label-entry-nb-parms instr2))
                               (eqv-list? eqv-gvm-opnd?
                                          (label-entry-opts instr1)
                                          (label-entry-opts instr2))
                               (if (label-entry-keys instr1)
                                   (and (label-entry-keys instr2)
                                        (eqv-list? eqv-key-pair?
                                                   (label-entry-keys instr1)
                                                   (label-entry-keys instr2)))
                                   (not (label-entry-keys instr2)))
                               (eq? (label-entry-rest? instr1)
                                    (label-entry-rest? instr2))
                               (eq? (label-entry-closed? instr1)
                                    (label-entry-closed? instr2))))
                         (else
                          (compiler-internal-error
                           "eqv-gvm-instr?, unknown label type"))))))

               ((apply)
                (and (eq? (apply-prim instr1) (apply-prim instr2))
                     (eqv-list? eqv-gvm-opnd?
                                (apply-opnds instr1)
                                (apply-opnds instr2))
                     (eqv-gvm-opnd? (apply-loc instr1)
                                    (apply-loc instr2))))

               ((copy)
                (and (eqv-gvm-opnd? (copy-opnd instr1)
                                    (copy-opnd instr2))
                     (eqv-gvm-opnd? (copy-loc instr1)
                                    (copy-loc instr2))))

               ((close)
                (eqv-list? eqv-closure-parms?
                           (close-parms instr1)
                           (close-parms instr2)))

               ((ifjump)
                (and (eq? (ifjump-test instr1)
                          (ifjump-test instr2))
                     (eqv-list? eqv-gvm-opnd?
                                (ifjump-opnds instr1)
                                (ifjump-opnds instr2))
                     (eqv-lbl-num? (ifjump-true instr1)
                                   (ifjump-true instr2))
                     (eqv-lbl-num? (ifjump-false instr1)
                                   (ifjump-false instr2))
                     (eq? (ifjump-poll? instr1)
                          (ifjump-poll? instr2))))

               ((switch)
                (and (eqv-gvm-opnd? (switch-opnd instr1)
                                    (switch-opnd instr2))
                     (every? (lambda (x)
                               (and (eqv? (switch-case-obj (car x))
                                          (switch-case-obj (cdr x)))
                                    (eqv-lbl-num? (switch-case-lbl (car x))
                                                  (switch-case-lbl (cdr x)))))
                             (map cons
                                  (switch-cases instr1)
                                  (switch-cases instr2)))
                     (eqv-lbl-num? (switch-default instr1)
                                   (switch-default instr2))
                     (eq? (switch-poll? instr1)
                          (switch-poll? instr2))))

               ((jump)
                (and (eqv-gvm-opnd? (jump-opnd instr1)
                                    (jump-opnd instr2))
                     (let ((ret1 (jump-ret instr1))
                           (ret2 (jump-ret instr2)))
                       (if ret1
                           (and ret2
                                (eqv-lbl-num? ret1 ret2))
                           (not ret2)))
                     (eqv? (jump-nb-args instr1)
                           (jump-nb-args instr2))
                     (eq? (jump-poll? instr1)
                          (jump-poll? instr2))
                     (eq? (jump-safe? instr1)
                          (jump-safe? instr2))))

               (else
                (compiler-internal-error
                 "eqv-gvm-instr?, unknown 'gvm-instr':" instr1))))))

    (bbs-next-lbl-num-set! new-bbs (bbs-next-lbl-num bbs))

    ;; Fill hash table, remove equivalent basic blocks and common tails

    (bbs-for-each-bb enter-bb! bbs)

    (if changed?

        (begin

          ;; Reconstruct bbs

          (bbs-entry-lbl-num-set!
           new-bbs
           (replacement-lbl-num (bbs-entry-lbl-num bbs)))

          (bbs-for-each-bb
           (lambda (bb)
             (bb-clone-replacing-lbls bb new-bbs replacement-lbl-num #f))
           new-bbs)

          (bbs-determine-refs! new-bbs)

          new-bbs)

        bbs)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 4, Useless jump removal:

(define (bbs-remove-useless-jumps bbs)

  (let ((new-bbs (make-bbs))
        (changed? #f))

    (define (remove-useless-jump bb)

      (stretchable-vector-set!
       (bbs-basic-blocks new-bbs)
       (bb-lbl-num bb)
       bb)

      (let loop ((bb bb))
        (let ((branch (bb-branch-instr bb)))

          ;; is it a non-polling 'jump' to a label without a return address?

          (if (and (eq? (gvm-instr-type branch) 'jump)
                   (not (first-class-jump? branch))
                   (not (jump-ret branch))
                   (not (jump-poll? branch))
                   (jump-lbl? branch))
              (let* ((dest-bb (lbl-num->bb (jump-lbl? branch) bbs))
                     (frame1 (gvm-instr-frame (bb-last-non-branch-instr bb)))
                     (frame2 (gvm-instr-frame (bb-label-instr dest-bb))))

                ;; is it a 'simple' label with the same frame as the last
                ;; non-branch instruction?

                (if (and (eq? (bb-label-type dest-bb) 'simple)
                         (frame-eq? frame1 frame2)
                         (= (length (bb-precedents dest-bb)) 1))

                    (let* ((new-bb (make-bb (bb-label-instr bb) new-bbs)))
                      (bb-non-branch-instrs-set!
                       new-bb
                       (append (bb-non-branch-instrs bb)
                               (bb-non-branch-instrs dest-bb)
                               '()))
                      (bb-branch-instr-set!
                       new-bb
                       (bb-branch-instr dest-bb))
                      (set! changed? #t)
                      (loop new-bb))))))))

    (bbs-next-lbl-num-set! new-bbs (bbs-next-lbl-num bbs))
    (bbs-entry-lbl-num-set! new-bbs (bbs-entry-lbl-num bbs))

    (bbs-for-each-bb remove-useless-jump bbs)

    (if changed? new-bbs bbs)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 5, Basic block set ordering:

(define (bbs-order bbs)

  (let ((ordered-blocks (queue-empty))
        (left-to-schedule (stretchable-vector-copy (bbs-basic-blocks bbs))))

    ;; test if a basic block is in 'left-to-schedule' and return the
    ;; basic block if it is

    (define (left-to-schedule? bb)
      (stretchable-vector-ref left-to-schedule (bb-lbl-num bb)))

    ;; remove basic block from 'left-to-schedule'

    (define (remove-bb! bb)
      (stretchable-vector-set! left-to-schedule (bb-lbl-num bb) #f)
      bb)

    ;; return a basic block which ends with a branch to 'bb' (and that is
    ;; still in 'left-to-schedule') or #f if there aren't any

    (define (prec-bb bb)
      (let loop ((lst (bb-precedents bb)) (best #f) (best-fs #f))
        (if (null? lst)
          best
          (let* ((lbl (car lst))
                 (x (lbl-num->bb lbl bbs))
                 (x-fs (bb-exit-frame-size x)))
            (if (and (left-to-schedule? x)
                     (or (not best) (< x-fs best-fs)))
              (loop (cdr lst) x x-fs)
              (loop (cdr lst) best best-fs))))))

    ;; return the basic block which 'bb' jumps to (and that is still in
    ;; bbs) or #f if there aren't any

    (define (succ-bb bb)

      (define (branches-to-lbl? bb)
        (let ((branch (bb-branch-instr bb)))
          (case (gvm-instr-type branch)
            ((ifjump) #t)
            ((switch) #t)
            ((jump) (lbl? (jump-opnd branch)))
            (else
             (compiler-internal-error
              "bbs-order, unknown branch type")))))

      (define (best-succ bb1 bb2)   ;; heuristic that determines which
        (if (branches-to-lbl? bb1)  ;; bb is most frequently executed
           bb1
           (if (branches-to-lbl? bb2)
             bb2
             (if (< (bb-exit-frame-size bb1)
                    (bb-exit-frame-size bb2))
               bb2
               bb1))))

      (let ((branch (bb-branch-instr bb)))
        (case (gvm-instr-type branch)

          ((ifjump)
           (let* ((true-bb
                   (left-to-schedule?
                     (lbl-num->bb (ifjump-true branch) bbs)))
                  (false-bb
                   (left-to-schedule?
                     (lbl-num->bb (ifjump-false branch) bbs))))
             (if (and true-bb false-bb)
               (best-succ true-bb false-bb)
               (or true-bb false-bb))))

          ((switch)
           (left-to-schedule?
            (lbl-num->bb (switch-default branch) bbs)))

          ((jump)
           (let ((opnd (jump-opnd branch)))
             (and (lbl? opnd)
                  (left-to-schedule?
                    (lbl-num->bb (lbl-num opnd) bbs)))))

          (else
           (compiler-internal-error
             "bbs-order, unknown branch type")))))

    ;; schedule a given basic block 'bb' with it's predecessors and
    ;; successors.

    (define (schedule-from bb)
      (queue-put! ordered-blocks bb)
      (let ((x (succ-bb bb)))
        (if x
          (begin
            (schedule-around (remove-bb! x))
            (let ((y (succ-bb bb)))
              (if y
                (schedule-around (remove-bb! y)))))))
      (schedule-refs bb))

    (define (schedule-around bb)
      (let ((x (prec-bb bb)))
        (if x
          (let ((bb-list (schedule-back (remove-bb! x) '())))
            (queue-put! ordered-blocks x)
            (schedule-forw bb)
            (for-each schedule-refs bb-list))
          (schedule-from bb))))

    (define (schedule-back bb bb-list)
      (let ((bb-list* (cons bb bb-list))
            (x (prec-bb bb)))
        (if x
          (let ((bb-list (schedule-back (remove-bb! x) bb-list*)))
            (queue-put! ordered-blocks x)
            bb-list)
          bb-list*)))

    (define (schedule-forw bb)
      (queue-put! ordered-blocks bb)
      (let ((x (succ-bb bb)))
        (if x
          (begin
            (schedule-forw (remove-bb! x))
            (let ((y (succ-bb bb)))
              (if y
                (schedule-around (remove-bb! y)))))))
      (schedule-refs bb))

    (define (schedule-refs bb)
      (for-each
        (lambda (lbl)
          (let ((x (lbl-num->bb lbl bbs)))
            (if (left-to-schedule? x)
                (schedule-around (remove-bb! x)))))
        (bb-references bb)))

    (schedule-from (remove-bb! (lbl-num->bb (bbs-entry-lbl-num bbs) bbs)))

    (let ((new-bbs (make-bbs))
          (basic-blocks (make-stretchable-vector #f))
          (lbl-map (make-stretchable-vector #f)))

      (define (replacement-lbl-num lbl)
        (or (stretchable-vector-ref lbl-map lbl) lbl))

      (for-each
       (lambda (bb)
         (let* ((old-num (label-lbl-num (bb-label-instr bb)))
                (new-num (bbs-new-lbl! new-bbs)))
           (stretchable-vector-set! basic-blocks new-num bb)
           (stretchable-vector-set! lbl-map old-num new-num)))
       (queue->list ordered-blocks))

      (let loop ((i bbs-first-lbl))
        (if (< i (bbs-next-lbl-num new-bbs))
            (begin
              (bb-clone-replacing-lbls
               (stretchable-vector-ref basic-blocks i)
               new-bbs
               replacement-lbl-num
               #t)
              (loop (+ i 1)))))

      (bbs-entry-lbl-num-set!
       new-bbs
       (replacement-lbl-num (bbs-entry-lbl-num bbs)))

      (bbs-determine-refs! new-bbs)

      new-bbs)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Sequentialization of a basic block set:
;; --------------------------------------

;; The procedure 'bbs->code-list' transforms a 'purified' basic block set
;; into a sequence of virtual machine instructions.  Each element of the
;; resulting list is a 'code' object that contains a GVM instruction,
;; a pointer to the basic block it came from and a `slots needed' index
;; that specifies the minimum number of slots that have to be kept (relative
;; to the start of the frame) after the instruction is executed.
;; The first element of the code list is the entry label for the piece of code.

(define (make-code bb gvm-instr sn)     (vector bb gvm-instr sn))
(define (code-bb code)                  (vector-ref code 0))
(define (code-gvm-instr code)           (vector-ref code 1))
(define (code-slots-needed code)        (vector-ref code 2))
(define (code-slots-needed-set! code n) (vector-set! code 2 n))

(define (bbs->code-list bbs)
  (let ((code-list (linearize bbs)))
    (setup-slots-needed! code-list)
    code-list))

(define (linearize bbs) ; convert bbs into list of GVM instructions
  (let ((code-queue (queue-empty)))

    (define (put-bb bb)

      (define (put-instr gvm-instr)
        (queue-put! code-queue (make-code bb gvm-instr #f)))

      (put-instr (bb-label-instr bb))
      (for-each put-instr (bb-non-branch-instrs bb))
      (put-instr (bb-branch-instr bb)))

    (bbs-for-each-bb put-bb bbs)
    (queue->list code-queue)))

(define (setup-slots-needed! code-list) ; setup slots-needed field

  ; Backward pass to set slots-needed field

  (let loop1 ((lst (reverse code-list)) (sn-rest #f))
    (if (pair? lst)
      (let* ((code (car lst))
             (gvm-instr (code-gvm-instr code)))
        (loop1
         (cdr lst)
         (case (gvm-instr-type gvm-instr)

           ((label)
            (if (> sn-rest (frame-size (gvm-instr-frame gvm-instr)))
              (compiler-internal-error
                "setup-slots-needed!, incoherent slots needed for label"))
            (code-slots-needed-set! code sn-rest)
            #f)

           ((ifjump switch jump)
            (let ((sn (frame-size (gvm-instr-frame gvm-instr))))
              (code-slots-needed-set! code sn)
              (need-gvm-instr gvm-instr sn)))

           (else
            (code-slots-needed-set! code sn-rest)
            (need-gvm-instr gvm-instr sn-rest))))))))

(define (need-gvm-instrs non-branch branch)
  (if (pair? non-branch)
    (need-gvm-instr (car non-branch)
                    (need-gvm-instrs (cdr non-branch) branch))
    (need-gvm-instr branch
                    (frame-size (gvm-instr-frame branch)))))

(define (need-gvm-instr gvm-instr sn-rest)
  (case (gvm-instr-type gvm-instr)

    ((label)
     sn-rest)

    ((apply)
     (let ((loc (apply-loc gvm-instr)))
       (need-gvm-opnds (apply-opnds gvm-instr)
         (need-gvm-loc-opnd loc
           (need-gvm-loc loc sn-rest)))))

    ((copy)
     (let ((loc (copy-loc gvm-instr)))
       (need-gvm-opnd (copy-opnd gvm-instr)
         (need-gvm-loc-opnd loc
           (need-gvm-loc loc sn-rest)))))

    ((close)
     (let ((parms (close-parms gvm-instr)))

       (define (need-parms-opnds p)
         (if (null? p)
           sn-rest
           (need-gvm-opnds (closure-parms-opnds (car p))
             (need-parms-opnds (cdr p)))))

       (define (need-parms-loc p)
         (if (null? p)
           (need-parms-opnds parms)
           (let ((loc (closure-parms-loc (car p))))
             (need-gvm-loc-opnd loc
               (need-gvm-loc loc (need-parms-loc (cdr p)))))))

       (need-parms-loc parms)))

    ((ifjump)
     (need-gvm-opnds (ifjump-opnds gvm-instr) sn-rest))

    ((switch)
     (need-gvm-opnd (switch-opnd gvm-instr) sn-rest))

    ((jump)
     (need-gvm-opnd (jump-opnd gvm-instr) sn-rest))

    (else
     (compiler-internal-error
       "need-gvm-instr, unknown 'gvm-instr':" gvm-instr))))

(define (need-gvm-loc loc sn-rest)
  (if (and loc (stk? loc) (>= (stk-num loc) sn-rest))
    (- (stk-num loc) 1)
    sn-rest))

(define (need-gvm-loc-opnd gvm-loc slots-needed)
  (if (and gvm-loc (clo? gvm-loc))
    (need-gvm-opnd (clo-base gvm-loc) slots-needed)
    slots-needed))

(define (need-gvm-opnd gvm-opnd slots-needed)
  (if gvm-opnd
    (cond ((stk? gvm-opnd)
           (max (stk-num gvm-opnd) slots-needed))
          ((clo? gvm-opnd)
           (need-gvm-opnd (clo-base gvm-opnd) slots-needed))
          (else
           slots-needed))
    slots-needed))

(define (need-gvm-opnds gvm-opnds slots-needed)
  (if (null? gvm-opnds)
    slots-needed
    (need-gvm-opnd (car gvm-opnds)
                   (need-gvm-opnds (cdr gvm-opnds) slots-needed))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Basic block writing:
;; -------------------

(define (write-bb bb port)
  (write-gvm-instr (bb-label-instr bb) port bb)
  (newline port)

  (for-each (lambda (gvm-instr)
              (if (useful-gvm-instr? gvm-instr)
                  (begin
                    (write-gvm-instr gvm-instr port)
                    (newline port))))
            (bb-non-branch-instrs bb))

  (if (not (null? (bb-branch-instr bb)))
      (write-gvm-instr (bb-branch-instr bb) port)))

(define (useful-gvm-instr? gvm-instr)
  (or show-frame-padding?
      (not (and (eq? (gvm-instr-type gvm-instr) 'copy)
                (not (copy-opnd gvm-instr))))))

(define (write-bbs bbs port)
  (bbs-for-each-bb
    (lambda (bb)
      (if (= (bb-lbl-num bb) (bbs-entry-lbl-num bbs))
        (begin (display "**** Entry block:" port) (newline port)))
      (write-bb bb port)
      (newline port))
    bbs))

(define show-slots-needed? #f)
(set! show-slots-needed? #f)

(define show-frame-padding? #f)
(set! show-frame-padding? #f)

(define show-frame? #f)
(set! show-frame? #t)

(define show-source-location? #f)
(set! show-source-location? #f)

(define (virtual.dump-gvm procs port)

  (define (dump-proc p)

    (define (dump-code code)
      (let ((gvm-instr (code-gvm-instr code)))
        (if (useful-gvm-instr? gvm-instr)
            (begin

              (if show-slots-needed?
                  (begin
                    (display "sn=" port)
                    (display (code-slots-needed code) port)
                    (display " | " port)))

              (write-gvm-instr gvm-instr port (code-bb code))
              (newline port)))))

    (if (proc-obj-primitive? p)
        (display "**** #<primitive " port)
        (display "**** #<procedure " port))
    (write (string->canonical-symbol (proc-obj-name p)) port)
    (display "> =" port)
    (newline port)

    (let ((x (proc-obj-code p)))
      (if (bbs? x)

          (let loop ((l (bbs->code-list x))
                     (prev-filename "")
                     (prev-line 0))
            (if (pair? l)
                (let* ((code (car l))
                       (instr (code-gvm-instr code))
                       (node (comment-get (gvm-instr-comment instr) 'node))
                       (src (node-source node))
                       (loc (and src (source-locat src)))
                       (filename
                        (if (and loc (string? (vector-ref loc 0))) ;;;;;;;;;;;;;
                            (vector-ref loc 0)
                            prev-filename))
                       (line
                        (if (and loc (string? (vector-ref loc 0)))
                            (+ (**filepos-line (vector-ref loc 1)) 1)
                            prev-line)))
                  (if (and show-source-location?
                           (or (not (string=? filename prev-filename))
                               (not (= line prev-line))))
                      (begin
                        (display "#line " port)
                        (display line port)
                        (if (not (string=? filename prev-filename))
                            (begin
                              (display " " port)
                              (write filename port)))
                        (newline port)))

                  (dump-code code)
                  (loop (cdr l) filename line))
                (newline port)))

          (begin
            (display "C procedure of arity " port)
            (display (c-proc-arity x) port)
            (display " and body:" port)
            (newline port)
            (display (c-proc-body x) port)
            (newline port)))))

  (for-each dump-proc (reachable-procs procs)))

(define (virtual.dump-cfg procs port)

  ;; For generating visual representation of control flow graph with "dot".

  (define dd (make-dot-digraph (proc-obj-name (car procs))))

  (define node-bgcolor       dot-digraph-gray80)
  (define node-type-bgcolor  dot-digraph-gray60)
  (define node-entry-bgcolor dot-digraph-black)

  (let ((proc-tbl (make-table)))

    (define (proc-repr proc)
      (format-gvm-opnd (make-obj proc)))

    (define (proc-id proc proc-index)
      (bb-id (let ((x (proc-obj-code proc)))
               (if (bbs? x)
                   (bbs-entry-lbl-num x)
                   0))
             proc-index))

    (define (bb-id bb-index proc-index)
      (string-append "proc"
                     (number->string proc-index)
                     "_"
                     (number->string bb-index)))

    (define (dump-proc proc proc-index)
      (let ((x (proc-obj-code proc)))
        (if (bbs? x)
            (dump-proc-bbs proc proc-index x))))

    (define (dump-proc-bbs proc proc-index bbs)

      (define (dump-bb bb)
        (let ((id (bb-id (bb-lbl-num bb) proc-index))
              (port-count 0)
              (rev-rows '()))

          (define (add-row row)
            (set! rev-rows (cons row rev-rows)))

          (define (gen-port)
            (set! port-count (+ port-count 1))
            (number->string port-count))

          (define (decorate-instr lst last-instr?)
            (let ((line-id (gen-port)))

              (define (target-id ref)
                (or (table-ref proc-tbl ref #f)
                    (bb-id (string->number
                            (substring ref 1 (string-length ref)))
                           proc-index)))

              (define (reference? x)
                (or (table-ref proc-tbl x #f)
                    (and (>= (string-length x) 2)
                         (char=? (string-ref x 0) #\#)
                         (string->number (substring x 1 (string-length x))))))

              (define (add-ref from side to dotted?)
                (dot-digraph-add-edge!
                 dd
                 (dot-digraph-gen-edge
                  (string-append id ":" from side)
                  to
                  dotted?)))

              (dot-digraph-gen-row
               (dot-digraph-gen-col
                #f
                #f
                "left"
                (dot-digraph-gen-table
                 line-id
                 #f
                 (dot-digraph-gen-row
                  (let loop ((before
                              (list (dot-digraph-gen-html-escape
                                     (car lst))))
                             (lst
                              (cdr lst)))
                    (if (pair? lst)
                        (let ((x (car lst)))
                          (if (reference? x)
                              (let ((jump?
                                     (and (pair? before)
                                          (equal? (car before) ""))))
                                (if last-instr?
                                    (let ((ref-id (gen-port)))
                                      (add-ref ref-id
                                               ":s"
                                               (target-id x)
                                               (not jump?))
                                      `(,@(dot-digraph-gen-col
                                           #f
                                           #f
                                           "left"
                                           (reverse before))
                                        ,@(dot-digraph-gen-col
                                           ref-id
                                           #f
                                           "left"
                                           `(,(dot-digraph-gen-html-escape x)))
                                        ,@(loop '()
                                                (cdr lst))))
                                    (begin
                                      (add-ref line-id
                                               ":w"
                                               (target-id x)
                                               (not jump?))
                                      (loop (cons
                                             (dot-digraph-gen-html-escape x)
                                             before)
                                            (cdr lst)))))
                              (loop (cons
                                     (dot-digraph-gen-html-escape x)
                                     before)
                                    (cdr lst))))
                        (dot-digraph-gen-col
                         #f
                         #t
                         "left"
                         (reverse before))))))))))

          (let ((instrs
                 (cons (format-gvm-instr (bb-label-instr bb))
                       (append (map format-gvm-instr
                                    (keep useful-gvm-instr?
                                          (bb-non-branch-instrs bb)))
                               (list
                                (format-gvm-instr (bb-branch-instr bb))))))
                (gv-bb-info
                 (append
                  (if (= (bbs-entry-lbl-num bbs)
                         (bb-lbl-num bb))
                      (list (cons 'entry (format-gvm-obj proc)))
                      '())
                  (or (comment-get (gvm-instr-comment (bb-label-instr bb))
                                   'gv-bb-info)
                      '()))))
            (dot-digraph-add-node!
             dd
             (dot-digraph-gen-node
              id
              (dot-digraph-gen-html-label
               (dot-digraph-gen-table
                #f
                node-bgcolor
                `(,@(apply append
                           (map (lambda (x)
                                  (let* ((style (if (pair? x) (car x) 'plain))
                                         (line (if (pair? x) (cdr x) x))
                                         (bgcolor
                                          (case style
                                            ((entry)
                                             node-entry-bgcolor)
                                            ((type)
                                             node-type-bgcolor)
                                            (else
                                             #f)))
                                         (esc-line
                                          (list (dot-digraph-gen-html-escape
                                                 line)))
                                         (decorated-line
                                          (case style
                                            ((entry)
                                             (dot-digraph-gen-font
                                              "Courier Bold"
                                              "white"
                                              esc-line))
                                            (else
                                             esc-line)))
                                         (align
                                          (case style
                                            ((entry)
                                             #f)
                                            (else
                                             "left"))))
                                  (dot-digraph-gen-row
                                   (dot-digraph-gen-col
                                    #f
                                    #f
                                    "left"
                                    (dot-digraph-gen-table
                                     #f
                                     bgcolor
                                     (dot-digraph-gen-row
                                      (dot-digraph-gen-col
                                       #f
                                       #f
                                       align
                                       decorated-line)))))))
                                gv-bb-info))
                  ,@(let loop ((lst instrs))
                      (if (pair? lst)
                          (let ((rest (cdr lst)))
                            `(,@(decorate-instr (car lst) (null? rest))
                              ,@(loop rest)))
                          '()))))))))))

      (bbs-for-each-bb dump-bb bbs))

    (let ((rprocs
           (reachable-procs procs)))

      (let loop1 ((i 0) (lst rprocs))
        (if (pair? lst)
            (let ((proc (car lst)))
              (table-set! proc-tbl (proc-repr proc) (proc-id proc i))
              (loop1 (+ i 1) (cdr lst)))))

      (let loop2 ((i 0) (lst rprocs))
        (if (pair? lst)
            (let ((proc (car lst)))
              (dump-proc proc i)
              (loop2 (+ i 1) (cdr lst)))))

      (dot-digraph-write dd port))))

(define (virtual.dump-dg name dependency-graph port)

  ;; For generating visual representation of dependency graph with "dot".

  (define dd (make-dot-digraph name))

  (define (gen-label referrer)
    (object->string (gen-label-string referrer)))

  (define (gen-label-string referrer)
    (object->string referrer))

  (define (interesting? sym)
    ;; modify to filter out some symbols
    #t)

  (define (sort-syms t)
   (sort-list (table->list t)
              (lambda (x y)
                (string<? (symbol->string (car x))
                          (symbol->string (car y))))))

  (define not-defined (make-table 'test: eq?))

  (for-each
   (lambda (referrer-dependencies)
     (let ((referrer (car referrer-dependencies))
           (deps (cdr referrer-dependencies)))

       (define (add dependencies jump?)
         (for-each
          (lambda (var)
            (if (and (not (eq? var referrer)) ;; avoid self cycle
                     (interesting? var))
                (begin
                  (if (not (table-ref dependency-graph var #f))
                      (table-set! not-defined var #t))
                  (dot-digraph-add-edge!
                   dd
                   (dot-digraph-gen-edge
                    (gen-label referrer)
                    (gen-label var)
                    (not jump?))))))
          (sort-list (map var-name (varset->list dependencies))
                     (lambda (x y)
                       (string<? (symbol->string x)
                                 (symbol->string y))))))

       (if (interesting? referrer)
           (begin

             '
             (dot-digraph-add-node!
              dd
              (dot-digraph-gen-node
               (gen-label referrer)
               (list (gen-label referrer))))

             (add (vector-ref deps 0) #t)
             (add (vector-ref deps 1) #f)))))

   (sort-syms dependency-graph))

  (for-each
   (lambda (x)
     (let ((var (car x)))
       (dot-digraph-add-node!
        dd
        (dot-digraph-gen-node
         (gen-label var)
         (dot-digraph-gen-html-label
          (dot-digraph-gen-table
           #f
           dot-digraph-black
           (dot-digraph-gen-row
            (dot-digraph-gen-col
             #f
             #f
             #f
             (dot-digraph-gen-font
              "Courier Bold"
              "white"
              (list
               " "
               (dot-digraph-gen-html-escape (gen-label-string var))
               " "))))))))))
   (sort-syms not-defined))

  (dot-digraph-write dd port))

(define (reachable-procs procs)
  (let ((proc-seen (queue-empty))
        (proc-left (queue-empty)))

    (define (scan-obj obj)
      (if (and (proc-obj? obj)
               (proc-obj-code obj)
               (not (memq obj (queue->list proc-seen))))
        (begin
          (queue-put! proc-seen obj)
          (queue-put! proc-left obj))))

    (define (scan-opnd gvm-opnd)
      (cond ((not gvm-opnd))
            ((obj? gvm-opnd)
             (scan-obj (obj-val gvm-opnd)))
            ((clo? gvm-opnd)
             (scan-opnd (clo-base gvm-opnd)))))

    (define (scan-proc proc)

      (define (scan-bb bb)

        (define (scan-gvm-instr gvm-instr)
          (case (gvm-instr-type gvm-instr)

            ((apply)
             (for-each scan-opnd (apply-opnds gvm-instr))
             (if (apply-loc gvm-instr)
                 (scan-opnd (apply-loc gvm-instr))))

            ((copy)
             (scan-opnd (copy-opnd gvm-instr))
             (scan-opnd (copy-loc gvm-instr)))

            ((close)
             (for-each (lambda (parms)
                         (scan-opnd (closure-parms-loc parms))
                         (for-each scan-opnd (closure-parms-opnds parms)))
                       (close-parms gvm-instr)))

            ((ifjump)
             (for-each scan-opnd (ifjump-opnds gvm-instr)))

            ((switch)
             (scan-opnd (switch-opnd gvm-instr))
             (for-each (lambda (c) (scan-obj (switch-case-obj c)))
                       (switch-cases gvm-instr)))

            ((jump)
             (scan-opnd (jump-opnd gvm-instr)))))

        (scan-gvm-instr (bb-label-instr bb))
        (for-each (lambda (gvm-instr) (scan-gvm-instr gvm-instr))
                  (bb-non-branch-instrs bb))
        (scan-gvm-instr (bb-branch-instr bb)))

      (let ((x (proc-obj-code proc)))
        (if (bbs? x)
            (bbs-for-each-bb (lambda (bb) (scan-bb bb)) x))))

    (for-each (lambda (proc) (scan-opnd (make-obj proc))) procs)

    (let loop ()
      (if (not (queue-empty? proc-left))
        (begin
          (scan-proc (queue-get! proc-left))
          (loop))))

    (queue->list proc-seen)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'dot' graph generation:
;; ----------------------

(define (make-dot-digraph name)
  (vector '() '() name))

(define (dot-digraph-nodes dd)            (vector-ref dd 0))
(define (dot-digraph-nodes-set! dd nodes) (vector-set! dd 0 nodes))

(define (dot-digraph-edges dd)            (vector-ref dd 1))
(define (dot-digraph-edges-set! dd edges) (vector-set! dd 1 edges))

(define (dot-digraph-name dd)           (vector-ref dd 2))
(define (dot-digraph-name-set! dd name) (vector-set! dd 2 name))

(define (dot-digraph-add-node! dd node)
  (dot-digraph-nodes-set!
   dd
   `(,@node
     ,@(dot-digraph-nodes dd))))

(define (dot-digraph-add-edge! dd edge)
  (dot-digraph-edges-set!
   dd
   `(,@edge
     ,@(dot-digraph-edges dd))))

(define (dot-digraph-gen-digraph dd)
  `("digraph \"" ,(dot-digraph-name dd) "\" {\n"
    "  graph [splines = true overlap = false rankdir = \"TD\"];\n"
    "  node [fontname = \"Courier New\" shape = \"none\"];\n"
    ,@(dot-digraph-nodes dd)
    ,@(dot-digraph-edges dd)
    "}\n"))

(define (dot-digraph-gen-edge from to dotted?)
  `("  " ,from " -> " ,to
    ,(if dotted?
         " [style = dotted]"
         "")
    ";\n"))

(define (dot-digraph-gen-node id label)
  `("  " ,id " [label = "
    ,@label
    "];\n"))

(define (dot-digraph-gen-table id bgcolor content)
  `("<table border=\"0\" cellborder=\"0\" cellspacing=\"0\" cellpadding=\"0\""
    ,@(if bgcolor
          `(" bgcolor=\"" ,bgcolor "\"")
          '())
    ,@(if id
          `(" port=\"" ,id "\"")
          '())
    ">"
    ,@content
    "</table>"))

(define (dot-digraph-gen-row content)
  `("<tr>"
    ,@content
    "</tr>"))

(define (dot-digraph-gen-col id last? align content)
  `("<td"
    ,@(if align
          `(" align=\"" ,align "\"")
          '())
    ,@(if id
          `(" port=\"" ,id "\"")
          '())
    ,(if last?
         " colspan=\"20\""
         "")
    ">"
    ,@content
    "</td>"))

(define (dot-digraph-gen-font face color content)
  `("<font face=\"" ,face "\""
    ,@(if color
          `(" color=\"" ,color "\"")
          '())
    ">"
    ,@content
    "</font>"))

(define (dot-digraph-gen-html-label content)
  `("<"
    ,@content
    ">"))

(define (dot-digraph-gen-html-escape str)
  (apply string-append
         (map (lambda (c)
                (cond ((char=? c #\<) "&lt;")
                      ((char=? c #\>) "&gt;")
                      ((char=? c #\&) "&amp;")
                      (else           (string c))))
              (string->list str))))

(define (dot-digraph-write dd port)
  (for-each
   (lambda (str)
     (display str port))
   (dot-digraph-gen-digraph dd)))

(define dot-digraph-gray80 "gray80")
(define dot-digraph-gray60 "gray60")
(define dot-digraph-black  "black")

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Virtual instruction writing:
;; ---------------------------

(define (write-gvm-instr gvm-instr port . bb)

  (define (spaces n)
    (if (> n 0)
      (if (> n 7)
        (begin (display "        " port) (spaces (- n 8)))
        (begin (display " " port) (spaces (- n 1))))))

  (let ((str (apply string-append
                    (apply format-gvm-instr (cons gvm-instr bb)))))
    (display str port)
    (spaces (- 43 (string-length str)))
    (display " " port)
    (if show-frame?
        (write-frame (gvm-instr-frame gvm-instr) port)))

  (let ((x (gvm-instr-comment gvm-instr)))
    (if x
      (let ((y (comment-get x 'text)))
        (if y
          (begin
            (display " ; " port)
            (display y port)))))))

(define (write-frame frame port)

  (define (write-opnd var opnd sep)
    (display sep port)
    (write-gvm-opnd opnd port)
    (if var
        (begin
          (display "=" port)
          (write-var var port))))

  (define (write-var var sep)
    (cond ((not var)
           (display "." port))
          ((eq? var closure-env-var)
           (write (map var-name (frame-closed frame))
                  port))
          ((eq? var ret-var)
           (display "#ret" port))
          ((var-temp? var)
           (display "#" port))
          (else
           (write (var-name var) port))))

  (define (live? var)
    (let ((live (frame-live frame)))
      (or (varset-member? var live)
          (and (eq? var closure-env-var)
               (varset-intersects?
                 live
                 (list->varset (frame-closed frame)))))))

  (let ((slots (reverse (frame-slots frame)))
        (regs (frame-regs frame)))
    (display "[" port)
    (let loop1 ((i 1) (l slots) (sep ""))
      (if (pair? l)
          (let ((var (car l)))
            (display sep port)
            (write-var (if (live? var) var #f) sep)
            (loop1 (+ i 1) (cdr l) " "))
          (display "]" port)))
    (if (pair? regs)
        (begin
          (let loop2 ((i 0) (l regs) (sep " "))
            (if (pair? l)
                (let ((var (car l)))
                  (if (live? var)
                      (begin
                        (write-opnd var (make-reg i) sep)
                        (loop2 (+ i 1) (cdr l) " "))
                      (loop2 (+ i 1) (cdr l) sep)))))))))

(define (format-gvm-instr gvm-instr . bb)

  (define (format-closure-parms parms)
    `(" "
      ,(format-gvm-opnd (closure-parms-loc parms))
      " = ("
      ,(format-gvm-lbl (closure-parms-lbl parms))
      ,@(format-spaced-opnd-list (closure-parms-opnds parms))))

  (define (format-spaced-opnd-list lst)
    (let loop ((lst lst)
               (rev-result '()))
      (if (pair? lst)
          (loop (cdr lst)
                `(,(format-gvm-opnd (car lst))
                  " "
                  ,@rev-result))
          (reverse `(")" ,@rev-result)))))

  (define (format-opnd-list lst)
    (if (pair? lst)
        `(,(format-gvm-opnd (car lst))
          ,@(format-spaced-opnd-list (cdr lst)))
        (format-spaced-opnd-list lst)))

  (define (format-key-pair-list keys)
    (if keys
        `(" ("
          ,@(if (pair? keys)
                (let loop ((lst keys))
                  (let* ((key-pair (car lst))
                         (key (car key-pair))
                         (opnd (cdr key-pair))
                         (rest (cdr lst)))
                    `(,(string-append "(" (object->string key))
                      " "
                      ,(format-gvm-opnd opnd)
                      ")"
                      ,@(if (pair? rest)
                            `(" "
                              ,@(loop rest))
                            `(")")))))
                `(")")))
        '()))

  (define (format-param-pattern gvm-instr)
    `("nparams="
      ,(number->string (label-entry-nb-parms gvm-instr))
      " ("
      ,@(format-opnd-list (label-entry-opts gvm-instr))
      ,@(format-key-pair-list (label-entry-keys gvm-instr))
      ,@(if (label-entry-rest? gvm-instr)
            `(" +")
            '())))

  (define (format-prim-applic prim opnds)
    (if (eq? prim **identity-proc-obj)
        `(,(format-gvm-opnd (car opnds)))
        (cons (string-append "(" (proc-obj-name prim))
              (format-spaced-opnd-list opnds))))

  (case (gvm-instr-type gvm-instr)

    ((label)
     `(,(format-gvm-lbl (label-lbl-num gvm-instr))
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       ,@(case (label-type gvm-instr)
           ((simple)
            (let ((precedents (if (pair? bb) (bb-precedents (car bb)) '())))
              (if (pair? precedents)
                  (cons "   <-"
                        (apply
                         append
                         (map (lambda (i)
                                (list " " (format-gvm-lbl i)))
                              precedents)))
                  '())))
           ((entry)
            `(,(if (label-entry-closed? gvm-instr)
                   " closure-entry-point "
                   " entry-point ")
              ,@(format-param-pattern gvm-instr)))
           ((return)
            `(" return-point"))
           ((task-entry)
            `(" task-entry-point"))
           ((task-return)
            `(" task-return-point"))
           (else
            (compiler-internal-error
             "format-gvm-instr, unknown label type")))))

    ((apply)
     `("  "
       ,(format-gvm-opnd (apply-loc gvm-instr))
       " = "
       ,@(format-prim-applic (apply-prim gvm-instr)
                             (apply-opnds gvm-instr))))

    ((copy)
     `("  "
       ,(format-gvm-opnd (copy-loc gvm-instr))
       " = "
       ,(format-gvm-opnd (copy-opnd gvm-instr))))

    ((close)
     (let loop ((lst (close-parms gvm-instr))
                (sep "  close"))
       (if (pair? lst)
           `(,sep
             ,@(format-closure-parms (car lst))
             ,@(loop (cdr lst)
                     ","))
           '())))

    ((ifjump)
     `("  if "
       ,@(format-prim-applic (ifjump-test gvm-instr)
                             (ifjump-opnds gvm-instr))
       ,(if (ifjump-poll? gvm-instr)
            " jump/poll"
            " jump")
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       " "
       "" ;; tag as a direct jump
       ,(format-gvm-lbl (ifjump-true gvm-instr))
       " else "
       "" ;; tag as a direct jump
       ,(format-gvm-lbl (ifjump-false gvm-instr))))

    ((switch)
     `("  "
       ,(if (switch-poll? gvm-instr)
            "switch/poll"
            "switch")
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       " "
       ,(format-gvm-opnd (switch-opnd gvm-instr))
       " ("
       ,@(let loop ((cases (switch-cases gvm-instr)))
           (if (pair? cases)
               (let ((c (car cases))
                     (next (cdr cases)))
                 `(,(format-gvm-obj (switch-case-obj c))
                   " => "
                   "" ;; tag as a direct jump
                   ,(format-gvm-lbl (switch-case-lbl c))
                   ,@(if (null? next)
                         '()
                         `(", "
                           ,@(loop next)))))
               '()))
       ") "
       "" ;; tag as a direct jump
       ,(format-gvm-lbl (switch-default gvm-instr))))

    ((jump)
     `("  "
       ,(if (jump-poll? gvm-instr)
            "jump/poll"
            "jump")
       ,(if (jump-safe? gvm-instr)
            "/safe"
            "")
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       " "
       "" ;; tag as a direct jump
       ,(format-gvm-opnd (jump-opnd gvm-instr))
       ,@(if (jump-ret gvm-instr)
             `(" "
               ,(format-gvm-opnd return-addr-reg)
               "="
               ,(format-gvm-opnd (make-lbl (jump-ret gvm-instr))))
             '())
       ,@(if (jump-nb-args gvm-instr)
             `(" nargs="
               ,(number->string (jump-nb-args gvm-instr)))
             '())))

    (else
     (compiler-internal-error
      "format-gvm-instr, unknown 'gvm-instr':"
      gvm-instr))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Operand writing:
;; ---------------

(define (write-gvm-opnd gvm-opnd port)
  (let ((str (format-gvm-opnd gvm-opnd)))
    (display str port)
    (string-length str)))

(define (format-gvm-opnd gvm-opnd)
  (cond ((not gvm-opnd)
         ".")
        ((reg? gvm-opnd)
         (string-append "r" (number->string (reg-num gvm-opnd))))
        ((stk? gvm-opnd)
         (string-append "frame[" (number->string (stk-num gvm-opnd)) "]"))
        ((glo? gvm-opnd)
         (string-append "global[" (object->string (glo-name gvm-opnd)) "]"))
        ((clo? gvm-opnd)
         (string-append (format-gvm-opnd (clo-base gvm-opnd))
                        "["
                        (number->string (clo-index gvm-opnd))
                        "]"))
        ((lbl? gvm-opnd)
         (format-gvm-lbl (lbl-num gvm-opnd)))
        ((obj? gvm-opnd)
         (string-append "'" (format-gvm-obj (obj-val gvm-opnd))))
        (else
         (compiler-internal-error
           "format-gvm-opnd, unknown 'gvm-opnd':"
           gvm-opnd))))

(define (format-gvm-lbl lbl)
  (string-append "#" (number->string lbl)))

(define (format-gvm-obj val)
  (cond ((proc-obj? val)
         (string-append
          (if (proc-obj-primitive? val)
              "#<primitive "
              "#<procedure ")
          (proc-obj-name val)
          ">"))
        (else
         (object->string val))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (make-debug-info-state)
  (vector #f              ;; debug-info?
          (queue-empty)   ;; first-class-label-queue
          (queue-empty))) ;; var-descr-queue

(define (debug-info-generate debug-info-state get-id sharing-table)

  (define (assign-ids i lst)
    (if (null? lst)
      '()
      (cons (list->vect (cons (get-id i) (car lst)))
            (assign-ids (+ i 1) (cdr lst)))))

  (debug-info-compact-using-sharing
   sharing-table
   (if (vector-ref debug-info-state 0) ;; debug-info?
       (vector (list->vect
                (assign-ids
                 0
                 (queue->list
                  (vector-ref debug-info-state 1)))) ;; first-class-label-queue
               (list->vect
                (queue->list
                 (vector-ref debug-info-state 2)))) ;; var-descr-queue
       #f)))

(define (debug-info-compact-using-sharing sharing-table obj)

  (define (compact obj)
    (if (or (string? obj)
            (pair? obj)
            (box-object? obj)
            (vector-object? obj))
        (let ((x (table-ref sharing-table obj #f)))
          (or x
              (cond ((string? obj)
                     (table-set! sharing-table obj obj)
                     obj)
                    ((pair? obj)
                     (let ((p (cons #f #f)))
                       (table-set! sharing-table obj p)
                       (set-car! p (compact (car obj)))
                       (set-cdr! p (compact (cdr obj)))
                       p))
                    ((box-object? obj)
                     (let ((b (box-object #f)))
                       (table-set! sharing-table obj b)
                       (set-box-object! b (compact (unbox-object obj)))
                       b))
                    (else
                     (let* ((len (vector-length obj))
                            (v (make-vector len)))
                       (table-set! sharing-table obj v)
                       (let loop ((i (- len 1)))
                         (if (< i 0)
                             v
                             (begin
                               (vector-set! v i (compact (vector-ref obj i)))
                               (loop (- i 1))))))))))
        obj))

  (compact obj))

(define (debug-info-add! debug-info-state node slots frame)

  (define first-class-label-queue (vector-ref debug-info-state 1))
  (define var-descr-queue (vector-ref debug-info-state 2))

  (define (add-var-descr! descr)

    (define (index x lst)
      (let loop ((lst lst) (i 0))
        (cond ((not (pair? lst))    #f)
              ((equal? (car lst) x) i)
              (else                 (loop (cdr lst) (+ i 1))))))

    (let ((n (index descr (queue->list var-descr-queue))))
      (if n
          n
          (let ((m (length (queue->list var-descr-queue))))
            (queue-put! var-descr-queue descr)
            m))))

  (define (encode slot)
    (let ((v (car slot))
          (i (cdr slot)))
      (+ (* i 32768)
         (if (pair? v)
           (* (add-var-descr! (map encode v)) 2)
           (+ (* (add-var-descr! (var-name v)) 2)
              (if (var-boxed? v) 1 0))))))

  (define (closure-env-slot closure-vars stack-slots)
    (let loop ((i 1) (lst1 closure-vars) (lst2 '()))
      (if (null? lst1)
        lst2
        (let ((x (car lst1)))
          (if (not (frame-live? x frame))
            (loop (+ i 1)
                  (cdr lst1)
                  lst2)
            (let ((y (assq (var-name x) stack-slots)))
              (if (and y (not (eq? x (cadr y))))
                (begin
                  (if (< (var-lexical-level (cadr y))
                         (var-lexical-level x))
                      (let ()
                        (##namespace ("" pp));****************
                        (pp (list
                             'closure-vars: (map var-name closure-vars)
                             'stack-slots: (map car stack-slots)
                             'source: (source->expression (node-source node))
                             ))
                        (compiler-internal-error
                         "debug-info-add!, variable conflict")))
                  (loop (+ i 1)
                        (cdr lst1)
                        lst2))
                (loop (+ i 1)
                      (cdr lst1)
                      (cons (cons x i) lst2)))))))))

  (define (accessible-slots)
    (let loop1 ((i 1)
                (lst1 slots)
                (lst2 '())
                (closure-env #f)
                (closure-env-index #f))
      (if (pair? lst1)
        (let* ((var (car lst1))
               (x (frame-live? var frame)))
          (cond ((pair? x) ; closure environment?
                 (if (or (not closure-env) (eq? var closure-env))
                   (loop1 (+ i 1)
                          (cdr lst1)
                          lst2
                          var
                          i)
                   (compiler-internal-error
                    "debug-info-add!, multiple closure environments")))
                ((or (not x) (var-temp? x)) ; not live or temporary var
                 (loop1 (+ i 1)
                        (cdr lst1)
                        lst2
                        closure-env
                        closure-env-index))
                (else
                 (let* ((name (var-name x))
                        (y (assq name lst2)))
                   (if (and y (not (eq? x (cadr y))))
                     (let ((level-x (var-lexical-level x))
                           (level-y (var-lexical-level (cadr y))))
                       (cond ((< level-x level-y)
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     lst2
                                     closure-env
                                     closure-env-index))
                             ((< level-y level-x)
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     (cons (cons name (cons x i)) (remq y lst2))
                                     closure-env
                                     closure-env-index))
                             (else
                              ; Two different live variables have the same
                              ; name and lexical level, both variables will
                              ; be kept in the debugging information
                              ; descriptor even though in the actual program
                              ; only one of the two variables is in scope.
                              ; "flatten" causes this condition to happen.
                              ; TODO: take variable scopes into account.
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     (cons (cons name (cons x i)) lst2)
                                     closure-env
                                     closure-env-index))))
                     (loop1 (+ i 1)
                            (cdr lst1)
                            (cons (cons name (cons x i)) lst2)
                            closure-env
                            closure-env-index))))))
        (let* ((x
                (if closure-env
                  (closure-env-slot (frame-live? closure-env frame) lst2)
                  '()))
               (accessible-stack-slots
                (map cdr lst2)))
          (if (null? x)
            accessible-stack-slots
            (cons (cons x closure-env-index)
                  accessible-stack-slots))))))

  (let* ((env
          (and node (node-env node)))
         (label-descr
          (cons (if (and env
                         (debug? env)
                         (or (debug-location? env)
                             (debug-source? env)))
                    (let ((src (node-source node)))
                      (vector-set! debug-info-state 0 #t) ;; debug-info? = #t
                      (if (debug-location? env)
                          (if (debug-source? env)
                              src
                              (source-locat src))
                          (source->expression src)))
                    #f)
                (if (and env
                         (or (and (debug? env)
                                  (debug-environments? env))
                             (environment-map? env)))
                    (begin
                      (vector-set! debug-info-state 0 #t) ;; debug-info? = #t
                      (map encode (accessible-slots)))
                    '()))))

    (queue-put! first-class-label-queue label-descr)

    label-descr))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (virtual.begin!) ; initialize module
  (set! *opnd-table* '#())
  (set! *opnd-table-alloc* 0)
  '())

(define (virtual.end!) ; finalize module
  (set! *opnd-table* '())
  '())

;;;============================================================================
