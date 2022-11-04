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

(define (types-truncate types frame)
  (and types
       (locenv-resize
        types
        (length (frame-regs frame))
        (length (frame-slots frame))
        (length (frame-closed frame))
        0
        type-top)))

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
            #f ;; type-infer
            #f ;; type-narrow
            side-effects?
            strict-pat
            lift-pat
            type
            standard
            #f))) ;; dead-end?
    (proc-obj-specialize-set! proc-obj (lambda (env call) call))
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
(define (proc-obj-type-infer obj)             (vector-ref obj 16))
(define (proc-obj-type-narrow obj)            (vector-ref obj 17))

(define (proc-obj-side-effects? obj)          (vector-ref obj 18))
(define (proc-obj-strict-pat obj)             (vector-ref obj 19))
(define (proc-obj-lift-pat obj)               (vector-ref obj 20))
(define (proc-obj-type obj)                   (vector-ref obj 21))
(define (proc-obj-standard obj)               (vector-ref obj 22))
(define (proc-obj-dead-end? obj)              (vector-ref obj 23))
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
(define (proc-obj-type-infer-set! obj x)      (vector-set! obj 16 x))
(define (proc-obj-type-narrow-set! obj x)     (vector-set! obj 17 x))
(define (proc-obj-side-effects?-set! obj x)   (vector-set! obj 18 x))
(define (proc-obj-strict-pat-set! obj x)      (vector-set! obj 19 x))
(define (proc-obj-lift-pat-set! obj x)        (vector-set! obj 20 x))
(define (proc-obj-type-set! obj x)            (vector-set! obj 21 x))
(define (proc-obj-standard-set! obj x)        (vector-set! obj 22 x))
(define (proc-obj-dead-end?-set! obj x)       (vector-set! obj 23 x))

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

;; for representing procedure calls for specialization

(define (make-call proc args) (cons proc args))
(define (call-proc call) (car call))
(define (call-args call) (cdr call))

(define (make-call-arg val) (list val))
(define (call-arg-val x) (car x))

(define (fold-call-args old-args new-args init proc)

  (define (fold-args n-args o-args o-args-pos)
    (if (pair? n-args)
        (let ((n-arg (car n-args)))
          (proc n-arg
                (if (and (pair? o-args) (eq? (car o-args) n-arg))
                    o-args-pos ;; optimize common case
                    (pos-in-list n-arg old-args))
                (fold-args (cdr n-args)
                           (if (pair? o-args) (cdr o-args) o-args)
                           (+ o-args-pos 1))))
        init))

  (fold-args new-args old-args 0))

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
(define (bb-label-kind bb)               (label-kind (vector-ref bb 0)))
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

(define (gvm-instr-kind gvm-instr)    (vector-ref gvm-instr 0))
(define (gvm-instr-frame gvm-instr)   (vector-ref gvm-instr 1))
(define (gvm-instr-types gvm-instr)   (vector-ref gvm-instr 2))
(define (gvm-instr-types-set! gvm-instr x) (vector-set! gvm-instr 2 x))
(define (gvm-instr-comment gvm-instr) (vector-ref gvm-instr 3))

(define (gvm-instr-types-set!-returning-instr gvm-instr x)
  (gvm-instr-types-set! gvm-instr x)
  gvm-instr)

(define (gvm-instr-copy-types! gvm-instr1 gvm-instr2)
  (gvm-instr-types-set!-returning-instr
   gvm-instr2
   (gvm-instr-types gvm-instr1)))

(define (make-label-simple lbl-num frame comment)
  (vector 'label frame #f comment lbl-num 'simple))

(define (make-label-entry lbl-num nb-parms opts keys rest? closed? frame comment)
  (vector 'label frame #f comment lbl-num 'entry nb-parms opts keys rest? closed?))

(define (make-label-return lbl-num frame comment)
  (vector 'label frame #f comment lbl-num 'return))

(define (make-label-task-entry lbl-num frame comment)
  (vector 'label frame #f comment lbl-num 'task-entry))

(define (make-label-task-return lbl-num frame comment)
  (vector 'label frame #f comment lbl-num 'task-return))

(define (label-lbl-num gvm-instr)        (vector-ref gvm-instr 4))
(define (label-lbl-num-set! gvm-instr n) (vector-set! gvm-instr 4 n))
(define (label-kind gvm-instr)           (vector-ref gvm-instr 5))

(define (label-entry-nb-parms gvm-instr) (vector-ref gvm-instr 6))
(define (label-entry-opts gvm-instr)     (vector-ref gvm-instr 7))
(define (label-entry-keys gvm-instr)     (vector-ref gvm-instr 8))
(define (label-entry-rest? gvm-instr)    (vector-ref gvm-instr 9))
(define (label-entry-closed? gvm-instr)  (vector-ref gvm-instr 10))

(define (make-apply prim opnds loc frame comment)
  (vector 'apply frame #f comment prim opnds loc))
(define (apply-prim gvm-instr)  (vector-ref gvm-instr 4))
(define (apply-opnds gvm-instr) (vector-ref gvm-instr 5))
(define (apply-loc gvm-instr)   (vector-ref gvm-instr 6))

(define (make-copy opnd loc frame comment)
  (vector 'copy frame #f comment opnd loc))

(define (copy-opnd gvm-instr) (vector-ref gvm-instr 4))
(define (copy-loc gvm-instr)  (vector-ref gvm-instr 5))

(define (make-close parms frame comment)
  (vector 'close frame #f comment parms))
(define (close-parms gvm-instr) (vector-ref gvm-instr 4))

(define (make-closure-parms loc lbl opnds)
  (vector loc lbl opnds))
(define (closure-parms-loc x)   (vector-ref x 0))
(define (closure-parms-lbl x)   (vector-ref x 1))
(define (closure-parms-opnds x) (vector-ref x 2))

(define (make-ifjump test opnds true false poll? frame comment)
  (vector 'ifjump frame #f comment test opnds true false poll?))
(define (ifjump-test gvm-instr)  (vector-ref gvm-instr 4))
(define (ifjump-opnds gvm-instr) (vector-ref gvm-instr 5))
(define (ifjump-true gvm-instr)  (vector-ref gvm-instr 6))
(define (ifjump-false gvm-instr) (vector-ref gvm-instr 7))
(define (ifjump-poll? gvm-instr) (vector-ref gvm-instr 8))

(define (make-switch opnd cases default poll? frame comment)
  (vector 'switch frame #f comment opnd cases default poll?))
(define (switch-opnd gvm-instr)    (vector-ref gvm-instr 4))
(define (switch-cases gvm-instr)   (vector-ref gvm-instr 5))
(define (switch-default gvm-instr) (vector-ref gvm-instr 6))
(define (switch-poll? gvm-instr)   (vector-ref gvm-instr 7))

(define (make-switch-case obj lbl) (cons obj lbl))
(define (switch-case-obj switch-case) (car switch-case))
(define (switch-case-lbl switch-case) (cdr switch-case))

(define (make-jump opnd ret nb-args poll? safe? frame comment)
  (vector 'jump frame #f comment opnd ret nb-args poll? safe?))
(define (jump-opnd gvm-instr)    (vector-ref gvm-instr 4))
(define (jump-ret gvm-instr)     (vector-ref gvm-instr 5))
(define (jump-nb-args gvm-instr) (vector-ref gvm-instr 6))
(define (jump-poll? gvm-instr)   (vector-ref gvm-instr 7))
(define (jump-safe? gvm-instr)   (vector-ref gvm-instr 8))
(define (first-class-jump? gvm-instr) (jump-nb-args gvm-instr))

(define (gvm-instr-branch? gvm-instr)
  (case (gvm-instr-kind gvm-instr)
    ((ifjump switch jump)
     #t)
    (else
     #f)))

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

  (define (clone-instr instr)
    (case (gvm-instr-kind instr)

      ((label)
       (case (label-kind instr)

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

  (gvm-instr-copy-types! instr (clone-instr instr)))

(define (gvm-instr-clone instr)
  (gvm-instr-clone-replacing-lbls instr (lambda (lbl) lbl)))

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

  (case (gvm-instr-kind instr)

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
      "gvm-instr-determine-refs!, unknown GVM instruction kind"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'Purification' of basic block sets:
;; ----------------------------------

;; This step removes unreachable basic blocks (i.e. dead code), duplicate
;; basic blocks (i.e. common code), useless jumps and jump cascades from
;; a basic block set.  It also orders the basic blocks so that the destination
;; of a branch is put (if possible) right after the branch instruction.  The
;; 'references' and 'precedents' fields of each basic block are also filled in
;; through the process.  The first basic block of a 'purified' basic block set
;; is always the entry point.

(define (bbs-purify bbs)

  (define (purify-step bbs0)
    (let* ((bbs1 (bbs-remove-jump-cascades bbs0))
           (bbs2 (bbs-remove-dead-code bbs1))
           (bbs3 (bbs-remove-common-code bbs2))
           (bbs4 (bbs-remove-useless-jumps bbs3)))
      (cons bbs2 bbs4)))

  (let loop ((bbs0 (bbs-type-specialize (cdr (purify-step bbs)))))
    ;;(bbs-determine-refs! bbs0) (bbs-order bbs0) #;
    (let* ((bbs1-bbs2 (purify-step bbs0))
           (bbs1 (car bbs1-bbs2))
           (bbs2 (cdr bbs1-bbs2)))
      (if (not (eq? bbs1 bbs2)) ;; iterate until code does not change
          (loop bbs2)
          (bbs-order bbs2)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 1, Jump cascade removal:

(define (bbs-remove-jump-cascades bbs)

  (let ((new-bbs (make-bbs))
        (changed? #f)
        (lbl-changed? #f))

    (define (empty-bb? bb)
      (and (eq? (bb-label-kind bb) 'simple)     ;; simple label and
           (null? (bb-non-branch-instrs bb))))  ;; no non-branching instrs

    (define (jump-to-non-entry-lbl? branch)
      (and (eq? (gvm-instr-kind branch) 'jump)
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
                         (gvm-instr-copy-types!
                          last-jump/ret
                          (make-label-simple
                           lbl2
                           (gvm-instr-frame last-jump/ret)
                           (gvm-instr-comment last-jump/ret)))
                         new-bbs)))
                  (bb-branch-instr-set!
                   new-bb
                   (gvm-instr-copy-types!
                    last-jump/ret
                    (make-jump
                     (make-lbl lbl2)
                     (jump-ret last-jump/ret)
                     #f
                     #f
                     #f
                     (gvm-instr-frame last-jump/ret)
                     (gvm-instr-comment last-jump/ret))))
                  (bb-branch-instr-set! new-bb2 new-branch-instr)))))

        (stretchable-vector-set!
         (bbs-basic-blocks new-bbs)
         (bb-lbl-num bb)
         bb)

        (case (gvm-instr-kind branch)

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
                  (gvm-instr-copy-types!
                   branch
                   (make-ifjump
                    (ifjump-test branch)
                    (ifjump-opnds branch)
                    new-true
                    new-false
                    new-poll?
                    (gvm-instr-frame branch)
                    (gvm-instr-comment branch)))))))

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
                  (gvm-instr-copy-types!
                   branch
                   (make-switch
                    (switch-opnd branch)
                    new-cases
                    new-default
                    new-poll?
                    (gvm-instr-frame branch)
                    (gvm-instr-comment branch)))))))

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
                                   (case (gvm-instr-kind last-branch)
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
                                             new-fs))
                                 (new-types (types-truncate
                                             (gvm-instr-types branch)
                                             new-frame)))

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

                            (case (gvm-instr-kind last-branch)

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
                                  (gvm-instr-types-set!-returning-instr
                                   (make-ifjump
                                    (ifjump-test last-branch)
                                    (map adjust-opnd
                                         (ifjump-opnds last-branch))
                                    new-true
                                    new-false
                                    new-poll?
                                    new-frame
                                    (gvm-instr-comment last-branch))
                                   new-types))))

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
                                  (gvm-instr-types-set!-returning-instr
                                   (make-switch
                                    (adjust-opnd (switch-opnd last-branch))
                                    new-cases
                                    new-default
                                    new-poll?
                                    new-frame
                                    (gvm-instr-comment last-branch))
                                   new-types))))

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
                                      (gvm-instr-types-set!-returning-instr
                                       (make-jump
                                        (if (and ret (eqv? opnd return-addr-reg))
                                            (make-lbl ret)
                                            (adjust-opnd opnd))
                                        new-ret
                                        (jump-nb-args last-branch)
                                        new-poll?
                                        (jump-safe? last-branch)
                                        new-frame
                                        (gvm-instr-comment last-branch))
                                       new-types)))))

                              (else
                               (compiler-internal-error
                                "bbs-remove-jump-cascades, unknown branch kind"))))

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
                                (let* ((new-frame
                                        (frame-truncate
                                         (gvm-instr-frame branch)
                                         fs))
                                       (new-types
                                        (types-truncate
                                         (gvm-instr-types branch)
                                         new-frame)))
                                  (replace-branch-by
                                   #f
                                   (gvm-instr-types-set!-returning-instr
                                    (make-jump
                                     (make-lbl lbl)
                                     new-ret
                                     (jump-nb-args branch)
                                     new-poll?
                                     (jump-safe? branch)
                                     new-frame
                                     (gvm-instr-comment branch))
                                    new-types))))))))))))

          (else
           (compiler-internal-error
            "bbs-remove-jump-cascades, unknown branch kind")))))

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

  (define tctx (make-tctx))

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
         (case (gvm-instr-kind branch)
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

    (define (types-merge types1 types2)
      (and types1
           types2
           (locenv-merge types1
                         types2
                         0
                         (lambda (type1 type2)
                           (type-union tctx type1 type2 #f)))))

    (define (instr-merge instr1 instr2)
      (let ((new-instr (gvm-instr-clone instr1)))
        (gvm-instr-types-set!-returning-instr
         new-instr
         (types-merge (gvm-instr-types instr1)
                      (gvm-instr-types instr2)))))

    (define (add-bb bb lst) ;; add basic block 'bb' to list of basic blocks
      (if (pair? lst)
          (let ((bb2 (car lst))) ;; pick next basic block in list

            (add-map! bb bb2) ;; for now, assume that 'bb' = 'bb2'

            (if (eqv-bb? bb bb2) ;; are they the same?

                (begin
                  ;; merge types of bb to bb2
                  (bb-label-instr-set!
                   bb2
                   (instr-merge
                    (bb-label-instr bb2)
                    (bb-label-instr bb)))
                  (bb-non-branch-instrs-set!
                   bb2
                   (map instr-merge
                        (bb-non-branch-instrs bb2)
                        (bb-non-branch-instrs bb)))
                  (bb-branch-instr-set!
                   bb2
                   (instr-merge
                    (bb-branch-instr bb2)
                    (bb-branch-instr bb)))
                  (set! changed? #t)
                  lst)

                (begin
                  (remove-map! bb) ;; they are not the same!
                  (if (eqv-gvm-instr? (bb-branch-instr bb)
                                      (bb-branch-instr bb2))

                      (extract-common-tail ;; check if tail is the same
                       bb
                       bb2
                       (lambda (head1 head2 tail1 tail2)
                         (if (<= (length tail1) 10) ;; common tail long enough?

                             ;; no, so try rest of list
                             (cons bb2 (add-bb bb (cdr lst)))

                             ;; create bb for common tail
                             (let* ((lbl-common
                                     (bbs-new-lbl! new-bbs))
                                    (branch1
                                     (bb-branch-instr bb))
                                    (branch2
                                     (bb-branch-instr bb2))
                                    (fs-common
                                     (need-gvm-instrs tail1 branch1))
                                    (last1
                                     (if (pair? head1) (car head1) (bb-label-instr bb)))
                                    (last2
                                     (if (pair? head2) (car head2) (bb-label-instr bb2)))
                                    (frame-common
                                     (frame-truncate
                                      (gvm-instr-frame last1)
                                      fs-common))
                                    (types-join1
                                     (gvm-instr-types last1))
                                    (types-join2
                                     (gvm-instr-types last2))
                                    (types-common
                                     (types-truncate
                                      (types-merge types-join1 types-join2)
                                      frame-common))
                                    (comment-common
                                     (gvm-instr-comment (car tail1)))
                                    (bb-common
                                     (make-bb
                                      (gvm-instr-types-set!-returning-instr
                                       (make-label-simple
                                        lbl-common
                                        frame-common
                                        comment-common)
                                       types-common)
                                      new-bbs))
                                    (new-bb
                                     (make-bb (bb-label-instr bb) new-bbs))
                                    (new-bb2
                                     (make-bb (bb-label-instr bb2) new-bbs)))

                               ;; create bb for common part
                               (bb-non-branch-instrs-set!
                                bb-common
                                (map instr-merge tail1 tail2))
                               (bb-branch-instr-set!
                                bb-common
                                (instr-merge branch1 branch2))

                               ;; create trimmed bb2 jumping to common part
                               (bb-non-branch-instrs-set!
                                new-bb2
                                (reverse head2))
                               (bb-branch-instr-set!
                                new-bb2
                                (gvm-instr-copy-types!
                                 last2
                                 (make-jump
                                  (make-lbl lbl-common)
                                  #f
                                  #f
                                  #f
                                  #f
                                  frame-common
                                  comment-common)))

                               ;; create trimmed bb jumping to common part
                               (bb-non-branch-instrs-set!
                                new-bb
                                (reverse head1))
                               (bb-branch-instr-set!
                                new-bb
                                (gvm-instr-copy-types!
                                 last1
                                 (make-jump
                                  (make-lbl lbl-common)
                                  #f
                                  #f
                                  #f
                                  #f
                                  frame-common
                                  comment-common)))

                               (set! changed? #t)

                               (add-bb bb-common (cdr lst))))))

                      (cons bb2 (add-bb bb (cdr lst)))))))

          (list bb)))

    (define (extract-common-tail bb1 bb2 cont)
      (let loop ((lst1 (reverse (bb-non-branch-instrs bb1)))
                 (lst2 (reverse (bb-non-branch-instrs bb2)))
                 (tail1 '())
                 (tail2 '()))
        (if (and (pair? lst1) (pair? lst2))
            (let ((i1 (car lst1))
                  (i2 (car lst2)))
              (if (eqv-gvm-instr? i1 i2)
                  (loop (cdr lst1) (cdr lst2) (cons i1 tail1) (cons i2 tail2))
                  (cont lst1 lst2 tail1 tail2)))
            (cont lst1 lst2 tail1 tail2))))

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

      (let ((kind1 (gvm-instr-kind instr1))
            (kind2 (gvm-instr-kind instr2)))
        (and (eq? kind1 kind2)
             (frame-eq? (gvm-instr-frame instr1) (gvm-instr-frame instr2))
             (not (has-debug-info? instr1))
             (not (has-debug-info? instr2))
;;;;;;;;;;             (equal? (gvm-instr-types instr1) (gvm-instr-types instr2))
             (case kind1

               ((label)
                (let ((lkind1 (label-kind instr1))
                      (lkind2 (label-kind instr2)))
                  (and (eq? lkind1 lkind2)
                       (case lkind1
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
                           "eqv-gvm-instr?, unknown label kind"))))))

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
        (let* ((branch (bb-branch-instr bb))
               (branch-kind (gvm-instr-kind branch)))
          (cond
            ;; is it an if which then and else jump to the same location?
            ((and (eq? branch-kind 'ifjump)
                  (not (proc-obj-side-effects? (ifjump-test branch)))
                  (= (ifjump-true branch) (ifjump-false branch)))
              (let* ((new-bb (make-bb (bb-label-instr bb) new-bbs)))
                (bb-non-branch-instrs-set!
                 new-bb
                 (bb-non-branch-instrs bb))
                (bb-branch-instr-set!
                 new-bb
                 (make-jump
                   (make-lbl (ifjump-true branch)) ;; opnd
                   #f ;; ret
                   #f ;; nb-args
                   (ifjump-poll? branch) ;; poll?
                   #f ;; safe?
                   (gvm-instr-frame branch) ;; frame
                   (gvm-instr-comment branch) ;; comment
                   ))
                (set! changed? #t)
                (loop new-bb)))
            ;; is it a non-polling 'jump' to a label without a return address?
            ((and (eq? branch-kind 'jump)
                  (not (first-class-jump? branch))
                  (not (jump-ret branch))
                  (not (jump-poll? branch))
                  (jump-lbl? branch))
              (let* ((dest-bb (lbl-num->bb (jump-lbl? branch) bbs))
                     (frame1 (gvm-instr-frame (bb-last-non-branch-instr bb)))
                     (frame2 (gvm-instr-frame (bb-label-instr dest-bb))))

                ;; is it a 'simple' label with the same frame as the last
                ;; non-branch instruction?

                (if (and (eq? (bb-label-kind dest-bb) 'simple)
;;                         (frame-eq? frame1 frame2) ;; too restrictive, just use frame-size equality
                         (= (frame-size frame1) (frame-size frame2))
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
                      (loop new-bb)))))))))

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
          (case (gvm-instr-kind branch)
            ((ifjump) #t)
            ((switch) #t)
            ((jump) (lbl? (jump-opnd branch)))
            (else
             (compiler-internal-error
              "bbs-order, unknown branch kind")))))

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
        (case (gvm-instr-kind branch)

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
             "bbs-order, unknown branch kind")))))

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

;;      (set! new-bbs (bbs-type-analysis! new-bbs))

;;      (bbs-determine-refs! new-bbs)

;;      (bbs-dominators! new-bbs)

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
         (case (gvm-instr-kind gvm-instr)

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
  (case (gvm-instr-kind gvm-instr)

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
;; Dominators:
;; ----------

(define (bbs-dominators! bbs)

  (define all-lbls '())

  (define (intersect lbl a b)
    (keep (lambda (x) (or (= x lbl) (memv x b))) a))

  (define (intersect-multi lbl lst)
    (let loop ((lst lst) (result all-lbls))
      (if (pair? lst)
          (loop (cdr lst) (intersect lbl result (car lst)))
          result)))

  (bbs-for-each-bb
   (lambda (bb)
     (set! all-lbls (cons (bb-lbl-num bb) all-lbls)))
   bbs)

  (set! all-lbls (reverse all-lbls))

  (bbs-for-each-bb
   (lambda (bb)
     (let ((label (bb-label-instr bb)))
       (comment-put! (gvm-instr-comment label) 'doms all-lbls)))
   bbs)

  (let* ((entry-lbl (bbs-entry-lbl-num bbs))
         (bb (lbl-num->bb entry-lbl bbs))
         (label (bb-label-instr bb)))
    (comment-put! (gvm-instr-comment label) 'doms (list entry-lbl)))

  (let loop ()
    (define changed? #f)
    (bbs-for-each-bb
     (lambda (bb)
       (if (not (= (bbs-entry-lbl-num bbs) (bb-lbl-num bb)))
           (let* ((label
                   (bb-label-instr bb))
                  (precedents
                   (bb-precedents bb))
                  (old
                   (comment-get (gvm-instr-comment label)
                                'doms))
                  (new
                   (intersect-multi (bb-lbl-num bb)
                                    (map (lambda (p)
                                           (comment-get
                                            (gvm-instr-comment
                                             (bb-label-instr
                                              (lbl-num->bb p bbs)))
                                            'doms))
                                         precedents))))
             (if (not (equal? old new))
                 (begin
                   (comment-put! (gvm-instr-comment label) 'doms new)
                   (set! changed? #t))))))
     bbs)
    (if changed? (loop)))

  (bbs-for-each-bb
   (lambda (bb)
     (let* ((label (bb-label-instr bb))
            (doms
             (map (lambda (lbl)
                    (string-append " " (format-gvm-lbl lbl)))
                  (comment-get
                   (gvm-instr-comment label)
                   'doms))))
       (if (pair? doms)
           (comment-put!
            (gvm-instr-comment label)
            'cfg-bb-info
            (list (cons 'info (apply string-append doms)))))))
   bbs))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Type analysis:
;; -------------

(define debug-bbv? #f)

(define instr-cost 1)
(define call-cost 100)

(define (bbs-type-specialize bbs)

  (define tctx (make-tctx))

  (define new-bbs (make-bbs))

  (define versions (make-table))
  (define lbl-mapping (make-table))

  (define (generic-frame-types frame)
    (let ((nb-regs (length (frame-regs frame)))
          (nb-slots (length (frame-slots frame)))
          (nb-closed (length (frame-closed frame))))
      (make-locenv nb-regs nb-slots nb-closed type-top)))

  (define (resized-frame-types frame types)
    (locenv-resize
     types
     (length (frame-regs frame))
     (length (frame-slots frame))
     (length (frame-closed frame))
     0
     type-top))

  (define (type-distance tctx type1 type2)
    (let* ((t1 (type-motley-force tctx type1))
           (t2 (type-motley-force tctx type2)))
      (let* ((bitset1 (type-motley-bitset t1))
             (bitset2 (type-motley-bitset t2))
             (bs1
              (+ (bitwise-and bitset1 (- (expt 2 30) 1))
                 (if (type-motley-included? t1 type-fixnum)
                     (expt 2 30)
                     0)))
             (bs2
              (+ (bitwise-and bitset2 (- (expt 2 30) 1))
                 (if (type-motley-included? t2 type-fixnum)
                     (expt 2 30)
                     0))))
        (bit-count (bitwise-eqv bs1 bs2)))))

  (define (types-distance tctx types1 types2)
    (let ((len (vector-length types1)))
      (let loop ((i locenv-start-regs) (d 0))
        (if (< i len)
            (let* ((type1 (vector-ref types1 (+ i 1)))
                   (type2 (vector-ref types2 (+ i 1))))
              (loop (+ i locenv-entry-size)
                    (+ d (type-distance tctx type1 type2))))
            d))))

  (define (types-merge2 types1 types2 widen?)
    (locenv-merge types1
                  types2
                  0
                  (lambda (type1 type2)
                    (type-union tctx type1 type2 widen?))))

  (define (types-merge-multi types-list widen?)
    (let loop ((types (car types-list)) (lst (cdr types-list)))
      (if (pair? lst)
          (loop (types-merge2 types (car lst) widen?)
                (cdr lst))
          types)))

  (define step-count 0)

  (define nb-versions (make-table))

  (define (make-bbvctx types cost path) (vector types cost path))
  (define (bbvctx-types bbvctx) (vector-ref bbvctx 0))
  (define (bbvctx-cost bbvctx) (vector-ref bbvctx 1))
  (define (bbvctx-path bbvctx) (vector-ref bbvctx 2))

  (define (bb-version-limit bb)
    (let* ((instr-comment (gvm-instr-comment (bb-label-instr bb)))
           (node (comment-get instr-comment 'node))
           (env (node-env node)))
      (if env (version-limit env) 0)))

  (define (walk-bbs bbs)
    (let ()

      (define (reach lbl bbvctx)
#;
        (let ((nbv (table-ref nb-versions lbl 0)))
          (table-set! nb-versions lbl (+ nbv 1))
          (if (>= nbv 10)
              (set! types-before
                (make-locenv (vector-ref (vector-ref types-before 0) 0)
                             (vector-ref (vector-ref types-before 0) 1)
                             (vector-ref (vector-ref types-before 0) 2)
                             type-top))))
        (let* ((types-before (bbvctx-types bbvctx))
               (cost (bbvctx-cost bbvctx))
               (path (bbvctx-path bbvctx))
               (bb (lbl-num->bb lbl bbs))
               (label (bb-label-instr bb))
               (frame (gvm-instr-frame label))
               (types-before (resized-frame-types frame types-before))
               (key (list lbl types-before))
               (bb-versions (or (table-ref versions lbl #f)
                                (let ((bb-versions
                                       (vector '() (make-table))))
                                  (table-set! versions lbl bb-versions)
                                  bb-versions)))
               (do-later (lambda () #f))
               (types-lbl-alist (vector-ref bb-versions 0))
               (all-versions-tbl (vector-ref bb-versions 1)))

          (or (table-ref all-versions-tbl types-before #f)

              (let* ((bb (lbl-num->bb lbl bbs))
                     (new-lbl (bbs-new-lbl! new-bbs))
                     (step-num (begin (set! step-count (+ 1 step-count)) step-count))
                     (looping? (assoc lbl path))
                     (new-types-lbl-alist
                      (cons (cons types-before new-lbl)
                            types-lbl-alist)))

                #;
                (if looping?
                    (pp `(********************looping ,looping?)))

                (table-set! all-versions-tbl types-before new-lbl)

                (vector-set! bb-versions 0 new-types-lbl-alist)

                (if (> (length new-types-lbl-alist)
                       (max 1 (bb-version-limit bb)))

                    (let* ((types-lbl-vect
                            (list->vector new-types-lbl-alist))
                           (n
                            (vector-length types-lbl-vect))
                           (min-dist
                            99999999)
                           (min-dist-pair
                            #f)
                           (dist-matrix
                            (make-vector n)))

                      (define (get-distance i j)
                        (if (= i j)
                            0
                            (vector-ref
                             (vector-ref dist-matrix
                                         (max i j))
                             (min i j))))

                      (define (partition-distance i d)
                        (let loop ((j 0) (in '()) (out '()))
                          (if (< j n)
                              (if (= i j)
                                  (loop (+ j 1)
                                        (cons j in)
                                        out)
                                  (if (= (get-distance i j) d)
                                      (loop (+ j 1)
                                            (cons j in)
                                            out)
                                      (loop (+ j 1)
                                            in
                                            (cons j out))))
                              (cons in out))))

                      (let loop1 ((i 0))
                        (if (< i n)
                            (let ((row (make-vector i)))
                              (vector-set! dist-matrix i row)
                              (let loop2 ((j 0))
                                (if (< j i)
                                    (let ((d (types-distance
                                              tctx
                                              (car (vector-ref
                                                    types-lbl-vect
                                                    i))
                                              (car (vector-ref
                                                    types-lbl-vect
                                                    j)))))
                                      (vector-set! row j d)
                                      (if (< d min-dist)
                                          (begin
                                            (set! min-dist d)
                                            (set! min-dist-pair (cons i j))))
                                      (loop2 (+ j 1)))
                                    (loop1 (+ i 1)))))))

                      (let* ((i1 (car min-dist-pair))
                             (i2 (cdr min-dist-pair))
                             (p1 (partition-distance i1 min-dist))
                             (p2 (partition-distance i2 min-dist))
                             (p
                              (if (> (length (car p1)) (length (car p2)))
                                  p1
                                  p2))
                             (in
                              (car p))
                             (out
                              (cdr p)))

                        (if debug-bbv?
                            (pp (list (list 'in in) (list 'out out))))

                        (let* ((versions-to-merge
                                (map (lambda (i) (vector-ref types-lbl-vect i))
                                     in))
                               (versions-to-keep
                                (map (lambda (i) (vector-ref types-lbl-vect i))
                                     out))
                               (merged-types
                                (types-merge-multi
                                 (map car versions-to-merge)
                                 #t))
                               (merging-latest-version?
                                (member 0 in)) ;; merging latest version?
                               (new-lbl2
                                (if merging-latest-version?
                                    new-lbl
                                    (bbs-new-lbl! new-bbs))))

                          (for-each
                           (lambda (types-lbl)
                             (let ((types (car types-lbl))
                                   (lbl (cdr types-lbl)))
                               (if (not (= lbl new-lbl2))
                                   (begin
                                     (if debug-bbv?
                                         (pp (list 'adding lbl '--> new-lbl2)))
                                     (table-set! lbl-mapping lbl new-lbl2)))))
                           versions-to-merge)

                          (table-set! all-versions-tbl merged-types new-lbl2)

                          (vector-set!
                           bb-versions
                           0
                           (cons (cons merged-types new-lbl2)
                                 versions-to-keep))

                          (write (list 'MERGED-TYPES= merged-types))(newline)
                          (if merging-latest-version?
                              (set! types-before merged-types)
                              (begin
                                (print "\n[STEP " step-num "      #" lbl " ==> #" new-lbl "]\n")
                                (walk-bb bb merged-types cost path lbl new-lbl2)))))))

                (if debug-bbv?
                    (print "\n[step " step-num "      #" lbl " ==> #" new-lbl "]\n"))

                (walk-bb bb types-before cost path lbl new-lbl)

                (if debug-bbv?
                    (begin
                      (print "\nstep " step-num "      #" lbl " ==>\n")
                      (write-bb (lbl-num->bb new-lbl new-bbs) (current-output-port))
                      (print "\n")))

                new-lbl))))

      (define (walk-bb bb types-before cost path orig-lbl new-lbl)
;;        (pp `(walk-bb ,(bb-lbl-num bb) ,types-before ,cost ,path ,new-lbl))

        (let ((new-bb #f))

          (define show #t)
          (define (reach* lbl bbvctx)
            (if (and debug-bbv? show)
                (begin
                  (write-bb new-bb (current-output-port))
                  (print "...\n")
                  (set! show #f)))
            (reach lbl bbvctx))

        (define (walk-opnd gvm-opnd)
          (and gvm-opnd
               (if (lbl? gvm-opnd)
                   (let* ((lbl
                           (lbl-num gvm-opnd))
                          (bb
                           (lbl-num->bb lbl bbs))
                          (label
                           (bb-label-instr bb))
                          (types-bef
                           (generic-frame-types (gvm-instr-frame label)))
                          (bbvctx
                           (make-bbvctx types-bef cost path)))
                     (make-lbl (reach* lbl bbvctx)))
                   gvm-opnd)))

        (define (walk-loc gvm-opnd)
          (walk-opnd gvm-opnd))

        (define (walk-instr gvm-instr types-before)

          (define (opnd-type gvm-opnd types)
            (cond ((not gvm-opnd)
                   type-top)
                  ((locenv-loc? gvm-opnd)
                   (locenv-ref types
                               (gvm-loc->locenv-index types gvm-opnd)))
                  ((obj? gvm-opnd)
                   (make-type-singleton (obj-val gvm-opnd)))
                  (else
                   type-top)))

          (let ((types-after
                 (resized-frame-types
                  (gvm-instr-frame gvm-instr)
                  types-before)))

            (set! cost (+ cost instr-cost))

            (case (gvm-instr-kind gvm-instr)

              ((label)
               (set! cost (- cost instr-cost)) ;; undo cost for labels
;;               (pp '****label)
               (let ((new-instr
                      (case (label-kind gvm-instr)

                        ((simple)
                         (make-label-simple
                          new-lbl
                          (gvm-instr-frame gvm-instr)
                          (gvm-instr-comment gvm-instr)))

                        ((entry)
                         (make-label-entry
                          new-lbl
                          (label-entry-nb-parms gvm-instr)
                          (label-entry-opts gvm-instr)
                          (label-entry-keys gvm-instr)
                          (label-entry-rest? gvm-instr)
                          (label-entry-closed? gvm-instr)
                          (gvm-instr-frame gvm-instr)
                          (gvm-instr-comment gvm-instr)))

                        ((return)
                         (make-label-return
                          new-lbl
                          (gvm-instr-frame gvm-instr)
                          (gvm-instr-comment gvm-instr)))

                        ((task-entry)
                         (make-label-task-entry
                          new-lbl
                          (gvm-instr-frame gvm-instr)
                          (gvm-instr-comment gvm-instr)))

                        ((task-return)
                         (make-label-task-return
                          new-lbl
                          (gvm-instr-frame gvm-instr)
                          (gvm-instr-comment gvm-instr)))

                        (else
                         (compiler-internal-error
                          "walk-instr, unknown 'gvm-instr':" gvm-instr)))))
                 (gvm-instr-types-set! new-instr types-after)
                 new-instr))

              ((apply)
;;               (pp '****apply)
               (let* ((prim
                       (apply-prim gvm-instr))
#;
                      (prim
                       (if (equal? (proc-obj-name prim) "##fx-?")
                           ((target-prim-info target) (string->canonical-symbol "##fx-"))
                           prim))
                      (opnds
                       (map walk-opnd (apply-opnds gvm-instr)))
                      (type-opnds
                       (map (lambda (opnd)
                              (opnd-type opnd types-before))
                            opnds))
                      (call
                       (make-call prim (map make-call-arg type-opnds)))
                      (spec-call
                       (let* ((instr-comment (gvm-instr-comment gvm-instr))
                              (node (comment-get instr-comment 'node))
                              (env (node-env node)))
                         (if env
                             (specialize-call call env)
                             call)))
                      (prim2
                       (car spec-call))
                      (loc
                       (walk-loc (apply-loc gvm-instr)))
                      (types-after
                       (if (locenv-loc? loc)
                           (let* ((type-infer
                                   (proc-obj-type-infer prim2))
                                  (dst-loc
                                   (gvm-loc->locenv-index types-after loc))
                                  (dst-type
                                   (if type-infer
                                       (type-infer tctx type-opnds)
                                       type-top)))
                             (locenv-set types-after ;; change type of dst-loc
                                         dst-loc
                                         dst-type))
                           types-after)) ;; no change
                      (new-instr
                       (make-apply
                        prim2
                        opnds
                        loc
                        (gvm-instr-frame gvm-instr)
                        (gvm-instr-comment gvm-instr))))
                 (gvm-instr-types-set! new-instr types-after)
                 new-instr))

              ((copy)
;;               (pp '****copy)
               (let* ((opnd
                       (walk-opnd (copy-opnd gvm-instr)))
                      (loc
                       (walk-loc (copy-loc gvm-instr)))
                      (types-after
                       (if (locenv-loc? loc)
                           (let ((dst-loc
                                  (gvm-loc->locenv-index types-after loc)))
                             (if (locenv-loc? opnd)
                                 (let ((src-loc
                                        (gvm-loc->locenv-index types-after opnd)))
                                   (locenv-copy types-after dst-loc src-loc))
                                 (locenv-set types-after dst-loc (opnd-type opnd types-before))))
                           types-after)) ;; no change
                      (new-instr
                       (make-copy
                        opnd
                        loc
                        (gvm-instr-frame gvm-instr)
                        (gvm-instr-comment gvm-instr))))
                 (gvm-instr-types-set! new-instr types-after)
                 new-instr))

              ((close)
;;               (pp '****close) (exit 1)
               (let loop1 ((lst (close-parms gvm-instr))
                           (types-after types-after))
                 (if (pair? lst)
                     (loop1
                      (cdr lst)
                      (let* ((parms (car lst))
                             (loc (walk-loc (closure-parms-loc parms))))
                        (if (locenv-loc? loc)
                            (let ((dst-loc
                                   (gvm-loc->locenv-index types-after loc)))
                              (locenv-set types-after
                                          dst-loc
                                          type-procedure))
                            types-after)))
                     (let loop2 ((lst (close-parms gvm-instr))
                                 (rev-parms '()))
                       (if (pair? lst)
                           (loop2
                            (cdr lst)
                            (cons
                             (let* ((parms
                                     (car lst))
                                    (lbl
                                     (closure-parms-lbl parms))
                                    (entry-bb
                                     (lbl-num->bb lbl bbs))
                                    (entry-label
                                     (bb-label-instr entry-bb))
                                    (opnds
                                     (map walk-opnd
                                          (closure-parms-opnds parms)))
                                    (types-entry
                                     (let loop ((opnds opnds)
                                                (i 1)
                                                (types-entry
                                                 (generic-frame-types
                                                  (gvm-instr-frame entry-label))))
                                       (if (pair? opnds)
                                           (loop
                                            (cdr opnds)
                                            (+ i 1)
                                            (let* ((opnd
                                                    (car opnds))
                                                   (dst-loc
                                                    (gvm-loc->locenv-index
                                                     types-entry
                                                     (make-clo #f i)))
                                                   (type
                                                    (opnd-type opnd
                                                               types-after)))
                                              (locenv-set types-entry
                                                          dst-loc
                                                          type)))
                                           types-entry))))
                               (make-closure-parms
                                (closure-parms-loc parms)
                                (reach* lbl
                                        (make-bbvctx types-entry 0 '()))
                                opnds))
                             rev-parms))
                           (let ((new-instr
                                  (make-close
                                   (reverse rev-parms)
                                   (gvm-instr-frame gvm-instr)
                                   (gvm-instr-comment gvm-instr))))
                             (gvm-instr-types-set! new-instr types-after)
                             new-instr))))))

              ((ifjump)
;;               (pp '****ifjump)
               (let* ((test
                       (ifjump-test gvm-instr))
                      (opnds
                       (map walk-opnd (ifjump-opnds gvm-instr)))
                      (type-narrow
                       (proc-obj-type-narrow test))
#;
                      (type-narrow
                       (if (equal? (proc-obj-name test) "##fixnum?")
                           (lambda (tctx args) (cons args #f))
                           type-narrow))
                      (result-types
                       (and type-narrow
                            (type-narrow
                             tctx
                             (map (lambda (opnd)
                                    (opnd-type opnd types-before))
                                  opnds))))
                      (new-instr
                       (if (pair? result-types)

                           (let ()

                             (define (narrow opnd-types)
                               (and opnd-types
                                    (locenv-update types-after opnds opnd-types)))

                             (let* ((true-types
                                     (narrow (car result-types)))
                                    (true-lbl
                                     (and true-types
                                          (reach* (ifjump-true gvm-instr)
                                                  (make-bbvctx
                                                   true-types
                                                   cost
                                                   path))))
                                    (false-types
                                     (narrow (cdr result-types)))
                                    (false-lbl
                                     (and false-types
                                          (reach* (ifjump-false gvm-instr)
                                                  (make-bbvctx
                                                   false-types
                                                   cost
                                                   path)))))
                               (if true-lbl
                                   (if false-lbl
                                       (make-ifjump
                                        test
                                        opnds
                                        true-lbl
                                        false-lbl
                                        (ifjump-poll? gvm-instr)
                                        (gvm-instr-frame gvm-instr)
                                        (gvm-instr-comment gvm-instr))
                                       (make-jump
                                        (make-lbl true-lbl)
                                        #f
                                        #f
                                        (ifjump-poll? gvm-instr)
                                        #f
                                        (gvm-instr-frame gvm-instr)
                                        (gvm-instr-comment gvm-instr)))
                                   (if false-lbl
                                       (make-jump
                                        (make-lbl false-lbl)
                                        #f
                                        #f
                                        (ifjump-poll? gvm-instr)
                                        #f
                                        (gvm-instr-frame gvm-instr)
                                        (gvm-instr-comment gvm-instr))
                                       (error)))))

                           (make-ifjump
                            test
                            opnds
                            (reach* (ifjump-true gvm-instr)
                                    (make-bbvctx
                                     types-after
                                     cost
                                     path))
                            (reach* (ifjump-false gvm-instr)
                                    (make-bbvctx
                                     types-after
                                     cost
                                     path))
                            (ifjump-poll? gvm-instr)
                            (gvm-instr-frame gvm-instr)
                            (gvm-instr-comment gvm-instr)))))
                 (gvm-instr-types-set! new-instr types-after)
                 new-instr))

              ((switch)
;;               (pp '****switch) (exit 1)
               (let ((opnd (walk-opnd (switch-opnd gvm-instr))))
                 '(for-each (lambda (c) (scan-obj (switch-case-obj c)))
                            (switch-cases gvm-instr))
                 types-after))

              ((jump)
;;               (pp '****jump)
               (let* ((opnd
                       (jump-opnd gvm-instr))
                      (ret
                       (jump-ret gvm-instr))
#;(_                (if (and opnd (lbl? opnd) ret)
                      (begin (pp '*********error)(exit 1))))

                      (new-instr
                       (make-jump
                        (if (lbl? opnd)
                            (make-lbl (reach* (lbl-num opnd)
                                              (make-bbvctx
                                               types-after
                                               cost
                                               path)))
                            (walk-opnd opnd))
                        (and ret
                             (let* ((result-loc
                                     (gvm-loc->locenv-index types-after (make-reg 1)))
                                    (types-after*
                                     (if (and (jump-safe? gvm-instr)
                                              (locenv-loc? opnd))
                                         (locenv-set types-after
                                                     (gvm-loc->locenv-index types-after opnd)
                                                     type-procedure)
                                         types-after))
                                    (types-return
                                     (locenv-set types-after*
                                                 result-loc
                                                 type-top)))
                               (reach* ret
                                       (make-bbvctx
                                        types-return
                                        (+ (- cost instr-cost) call-cost)
                                        path)))) ;;;;;;;;;TODO
                        (jump-nb-args gvm-instr)
                        (jump-poll? gvm-instr)
                        (if (type-motley-included?
                             (type-motley-force tctx
                                                (opnd-type opnd types-before))
                             type-procedure)
                            #f
                            (jump-safe? gvm-instr))
                        (gvm-instr-frame gvm-instr)
                        (gvm-instr-comment gvm-instr))))
                 (gvm-instr-types-set! new-instr types-after)
                 new-instr)))))

          (set! path (cons (cons orig-lbl cost) path))

          (set! new-bb
            (make-bb (walk-instr (bb-label-instr bb) types-before)
                     new-bbs))

          (let ((instr-comment (gvm-instr-comment (bb-label-instr new-bb))))
            (comment-put!
             instr-comment
             'cfg-bb-info
             (list
               (cons 'info
                 (object->string
                   (list orig-lbl '-> new-lbl))
                 ;;(object->string
                 ;;(list orig-lbl '-> new-lbl 'cost= cost 'path= (map car (cdr path))))
                   )))
            (comment-put!
              instr-comment
              'orig-lbl
              orig-lbl))

          (let loop ((instrs
                      (bb-non-branch-instrs bb))
                     (types-before
                      (gvm-instr-types (bb-label-instr new-bb))))
            (if (pair? instrs)
                (let ((new-instr
                       (walk-instr (car instrs) types-before)))
                  (bb-put-non-branch! new-bb new-instr)
                  (loop (cdr instrs)
                        (gvm-instr-types new-instr)))
                (let ((new-instr
                       (walk-instr (bb-branch-instr bb) types-before)))
                  (bb-put-branch! new-bb new-instr))))))

      (let* ((entry-lbl
              (bbs-entry-lbl-num bbs))
             (entry-bb
              (lbl-num->bb entry-lbl bbs))
             (entry-label
              (bb-label-instr entry-bb))
             (types-before
              (generic-frame-types (gvm-instr-frame entry-label))))

        (bbs-entry-lbl-num-set! new-bbs
                                (reach entry-lbl
                                       (make-bbvctx types-before 0 '())))

        )))

;;  (write-bbs bbs (current-output-port))

  (let ((specialize? #f))

    (bbs-for-each-bb
     (lambda (bb)
       (if (> (bb-version-limit bb) 0)
           (set! specialize? #t)))
     bbs)

    (if (not specialize?)

        bbs

        (begin

          (walk-bbs bbs)

;;          (write-bbs new-bbs (current-output-port))

          (bbs-for-each-bb
           (lambda (bb)

             (define (replacement-lbl-num lbl)
               (let ((x (table-ref lbl-mapping lbl #f)))
                 (if x
                     (begin
                       (if debug-bbv?
                           (pp (list lbl '--> x)))
                       (replacement-lbl-num x))
                     lbl)))

             (bb-clone-replacing-lbls
              bb
              new-bbs
              replacement-lbl-num
              #f))
           new-bbs)

          new-bbs))))

#;
(define (bbs-type-analysis!-old bbs)

  (define tctx (make-tctx))

  (define (bbs-init! bbs)

    (define (bb-init! bb)

      (define (instr-init! gvm-instr init)
        (let* ((frame (gvm-instr-frame gvm-instr))
               (nb-regs (length (frame-regs frame)))
               (nb-slots (length (frame-slots frame)))
               (nb-closed (length (frame-closed frame)))
               (types (make-locenv nb-regs nb-slots nb-closed init)))
          (gvm-instr-types-set! gvm-instr types)))

      (let ((init
             (if (= (bb-lbl-num bb) (bbs-entry-lbl-num bbs))
                 type-top
                 type-bot)))
        (instr-init! (bb-label-instr bb) init))
      (for-each (lambda (gvm-instr) (instr-init! gvm-instr type-bot))
                (bb-non-branch-instrs bb))
      (instr-init! (bb-branch-instr bb) type-bot))

    (bbs-for-each-bb bb-init! bbs))

  (define (bbs-iterate! bbs iteration-count) (pp `(***********iteration-count= ,iteration-count))
    (let ((visited (make-stretchable-vector 0))
          (changed? #f))

      (define (reach lbl types)
        (let* ((bb (lbl-num->bb lbl bbs))
               (label (bb-label-instr bb))
               (bb-types (gvm-instr-types label))
               (widen?
                (= 1 (stretchable-vector-ref visited lbl)))
               (new-bb-types
                (locenv-merge bb-types
                              types
                              0
                              (lambda (type1 type2)
                                (type-union tctx type1 type2 widen?)))))

          (pp `(----------------------reach
                ,lbl
                ,types
                ,bb-types
                ,new-bb-types))
          (if (not (equal? bb-types new-bb-types)) (set! changed? #t))

          (gvm-instr-types-set! label new-bb-types)

          (if (= 0 (stretchable-vector-ref visited lbl))
              (begin
                (stretchable-vector-set! visited lbl 1)
                (bb-analyze! bb)
                (stretchable-vector-set! visited lbl 2)))))

      (define (bb-analyze! bb)

        (define (scan-opnd gvm-opnd)
          gvm-opnd)

        (define (instr-analyze! gvm-instr types)

(let ((xxx
          (let ((after
                 (let ((frame (gvm-instr-frame gvm-instr)))
                   (locenv-resize
                    types
                    (length (frame-regs frame))
                    (length (frame-slots frame))
                    (length (frame-closed frame))
                    0
                    type-bot))))

            (define (opnd-type gvm-opnd types)
              (cond ((not gvm-opnd)
                     type-top)
                    ((locenv-loc? gvm-opnd)
                     (locenv-ref types (gvm-loc->locenv-index types gvm-opnd)))
                    ((obj? gvm-opnd)
                     (make-type-singleton (obj-val gvm-opnd)))
                    (else
                     type-top)))

            (case (gvm-instr-kind gvm-instr)

              ((apply)
               (let ((opnds (map scan-opnd (apply-opnds gvm-instr)))
                     (loc (scan-opnd (apply-loc gvm-instr))))
                 (if (locenv-loc? loc)
                     (let ((dst-loc
                            (gvm-loc->locenv-index after loc))
                           (type-infer
                            (proc-obj-type-infer (apply-prim gvm-instr))))
                       (locenv-set after
                                   dst-loc
                                   (if type-infer
                                       (type-infer
                                        tctx
                                        (map (lambda (opnd)
                                               (opnd-type opnd types))
                                             opnds))
                                       type-top)))
                     after)))

              ((copy)
               (let* ((opnd (scan-opnd (copy-opnd gvm-instr)))
                      (loc (scan-opnd (copy-loc gvm-instr))))
                 (pp (list 'xxxxxxxxx (format-gvm-opnd loc) (format-gvm-opnd opnd)))
                 (if (locenv-loc? loc)
                     (let ((dst-loc
                            (gvm-loc->locenv-index after loc)))
                       (if (locenv-loc? opnd)
                           (let ((src-loc
                                  (gvm-loc->locenv-index after opnd)))
                             (locenv-copy after dst-loc src-loc))
                           (locenv-set after dst-loc (opnd-type opnd types))))
                     after)))

              ((close)
               (let loop1 ((lst (close-parms gvm-instr)) (after after))
                 (if (pair? lst)
                     (loop1
                      (cdr lst)
                      (let* ((parms (car lst))
                             (loc (scan-opnd (closure-parms-loc parms))))
                        (if (locenv-loc? loc)
                            (let ((dst-loc
                                   (gvm-loc->locenv-index after loc)))
                              (locenv-set after
                                          dst-loc
                                          type-procedure))
                            after)))
                     (begin
                       (for-each
                        (lambda (parms)
                          (let ((lbl
                                 (closure-parms-lbl parms))
                                (opnds
                                 (map scan-opnd (closure-parms-opnds parms))))
                            '...))
                        (close-parms gvm-instr))
                       after))))

              ((ifjump)
               (let* ((opnds
                       (map scan-opnd (ifjump-opnds gvm-instr)))
                      (type-narrow
                       (proc-obj-type-narrow (ifjump-test gvm-instr)))
                      (result
                       (and type-narrow
                            (type-narrow
                             tctx
                             (map (lambda (opnd)
                                    (opnd-type opnd types))
                                  opnds)))))
                 (if (pair? result)
                     (let ()
                       (define (narrow where opnd-types)
                         (and opnd-types
                              (let ((x (locenv-update after opnds opnd-types)))
                                (pp `(=========== ,where ,x))
                                x)))
                       (let* ((true (narrow 't (car result)))
                              (false (narrow 'f (cdr result))))
                         (if true (reach (ifjump-true gvm-instr) true))
                         (if false (reach (ifjump-false gvm-instr) false))
                         after))
                     (begin
                       (reach (ifjump-true gvm-instr) after)
                       (reach (ifjump-false gvm-instr) after)
                       after))))

              ((switch)
               (let ((opnd (scan-opnd (switch-opnd gvm-instr))))
                 '(for-each (lambda (c) (scan-obj (switch-case-obj c)))
                            (switch-cases gvm-instr))
                 after))

              ((jump)
               (let ((opnd (scan-opnd (jump-opnd gvm-instr))))
                 (if (lbl? opnd)
                     (reach (lbl-num opnd) after))
                 after))))))
  (gvm-instr-types-set! gvm-instr xxx) (pp xxx)
  xxx))

        (pp `(bb-analyze! ,(bb-lbl-num bb)))

        (let loop ((lst (bb-non-branch-instrs bb))
                   (types (gvm-instr-types (bb-label-instr bb))))
          (pp `(types= ,types))
          (if (pair? lst)
              (loop (cdr lst) (instr-analyze! (car lst) types))
              (instr-analyze! (bb-branch-instr bb) types))))

      (pp iteration-count)
      (bb-analyze! (lbl-num->bb (bbs-entry-lbl-num bbs) bbs))

      (if changed?
          (bbs-iterate! bbs (+ 1 iteration-count)))))



    ;;deprecated
    (define (bb-iterate2! bb)
      (let* ((branch
              (bb-branch-instr bb))
             (frame
              (gvm-instr-frame branch))
             (fs
              (frame-size frame))
             (sn
              (case (gvm-instr-kind branch)
                ((ifjump)
                 (need-gvm-opnds (ifjump-opnds gvm-instr) fs))
                ((switch)
                 (need-gvm-opnd (switch-opnd gvm-instr) fs))
                ((jump)
                 (need-gvm-opnd (jump-opnd gvm-instr) fs))
                (else
                 (compiler-internal-error
                  "bbs-type-analysis!, unknown branch kind"))))
             (types
              (make-locenv (length (frame-regs frame))
                           sn-rest
                           (length (frame-closed frame)))))
        (gvm-instr-types-set! branch types)))

  (bbs-init! bbs)
  (bbs-iterate! bbs 1))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Environments for virtual machine locations:
;; ------------------------------------------

;; The locenv structure is used to track the properties (currently
;; only the type) of the contents of virtual machine locations
;; (registers, stack slot and closed variables).  It also tracks if
;; two locations are in the same equivalence class (i.e. they contain
;; the same value).  There could be different equivalence classes for
;; eq?, eqv?, etc but currently only eq? equivalence is tracked.

(define locenv-start-regs 1)
(define locenv-entry-size 2)

(define (locenv-loc? gvm-opnd)
  (and gvm-opnd
       (or (reg? gvm-opnd)
           (stk? gvm-opnd)
           (clo? gvm-opnd))))

(define (gvm-loc->locenv-index locenv gvm-loc)
  (if (reg? gvm-loc)
      (+ locenv-start-regs
         (* locenv-entry-size (reg-num gvm-loc)))
      (let ((start-slots
             (+ locenv-start-regs
                (* locenv-entry-size
                   (vector-ref (vector-ref locenv 0) 0)))))
        (if (stk? gvm-loc)
            (+ start-slots
               (* locenv-entry-size
                  (- (stk-num gvm-loc) 1)))
            ;; (clo? gvm-loc) must be true
            (let ((start-closed
                   (+ start-slots
                      (* locenv-entry-size
                         (vector-ref (vector-ref locenv 0) 1)))))
              (+ start-closed
                 (* locenv-entry-size
                    (- (clo-index gvm-loc) 1))))))))

(define (locenv-val-eqv? locenv val1 val2)
  (type-eqv? val1 val2))

(define (make-locenv nb-regs nb-slots nb-closed init)
  (let* ((locenv
          (make-locenv-from-lengths (vector nb-regs nb-slots nb-closed)))
         (len
          (+ locenv-start-regs
             (* locenv-entry-size (+ nb-regs nb-slots nb-closed)))))
    (let loop ((i locenv-start-regs))
      (if (< i len)
          (begin
            (vector-set! locenv i i)
            (vector-set! locenv (+ i 1) init)
            (loop (+ i locenv-entry-size)))
          locenv))))

(define (make-locenv-from-lengths lengths)
  (let* ((nb-regs (vector-ref lengths 0))
         (nb-slots (vector-ref lengths 1))
         (nb-closed (vector-ref lengths 2))
         (len (+ locenv-start-regs
                 (* locenv-entry-size (+ nb-regs nb-slots nb-closed))))
         (locenv (make-vector len 0)))
    (vector-set! locenv 0 lengths)
    locenv))

(define (locenv-resize locenv nb-regs nb-slots nb-closed slot-shift init)
  (let ((lengths (vector-ref locenv 0)))
    (if (and (= nb-regs (vector-ref lengths 0))
             (= nb-slots (vector-ref lengths 1))
             (= nb-closed (vector-ref lengths 2))
             (= slot-shift 0))
        locenv ;; no change
        (locenv-resize-from-lengths locenv
                                    (vector nb-regs nb-slots nb-closed)
                                    slot-shift
                                    init))))

(define (locenv-resize-from-lengths locenv new-lengths slot-shift init)
  (let* ((new-locenv
          (make-locenv-from-lengths new-lengths))
         (lengths
          (vector-ref locenv 0))
         (nb-regs
          (vector-ref lengths 0))
         (nb-slots
          (vector-ref lengths 1))
         (nb-closed
          (vector-ref lengths 2))
         (start-slots
          (+ locenv-start-regs (* locenv-entry-size nb-regs)))
         (start-closed
          (+ start-slots (* locenv-entry-size nb-slots)))
         (new-nb-regs
          (vector-ref new-lengths 0))
         (new-nb-slots
          (vector-ref new-lengths 1))
         (new-nb-closed
          (vector-ref new-lengths 2))
         (new-start-slots
          (+ locenv-start-regs (* locenv-entry-size new-nb-regs)))
         (new-start-closed
          (+ new-start-slots (* locenv-entry-size new-nb-slots)))
         (len
          (+ locenv-start-regs
             (* locenv-entry-size (+ nb-regs nb-slots nb-closed)))))

    (define (index->new i) ;; map index from locenv to new-locenv
      (cond ((< i start-slots)
             (and (< i new-start-slots) i))
            ((< i start-closed)
             (let ((i* (+ (- i start-slots) (* locenv-entry-size slot-shift))))
               (and (>= i* 0)
                    (< i* (* locenv-entry-size new-nb-slots))
                    (+ i* new-start-slots))))
            (else
             (let ((i* (- i start-closed)))
               (and (< i* (* locenv-entry-size new-nb-closed))
                    (+ i* new-start-closed))))))

    (let loop1 ((i locenv-start-regs))
      (if (< i len)
          (let ((j (index->new i)))
            (if (not j) ;; location removed by resize?
                (loop1 (+ i locenv-entry-size))
                (let ((ec (vector-ref locenv i)))
                  (if (= ec i) ;; alone in equivalence class
                      (begin
                        (vector-set!
                         new-locenv
                         j
                         j)
                        (vector-set!
                         new-locenv
                         (+ j 1)
                         (vector-ref locenv (+ i 1)))
                        (loop1 (+ i locenv-entry-size)))
                      (let ((x (vector-ref new-locenv j)))
                        (if (not (eqv? x 0)) ;; not head of equivalence class
                            ;; new-locenv already ok for this i
                            (loop1 (+ i locenv-entry-size))
                            (let loop2 ((prev i)
                                        (curr ec)
                                        (new-prev j))
                              (if (= curr i) ;; finished iterating over class?
                                  (begin
                                    (vector-set!
                                     new-locenv
                                     new-prev
                                     j)
                                    (vector-set!
                                     new-locenv
                                     (+ new-prev 1)
                                     (vector-ref locenv (+ prev 1)))
                                    (loop1 (+ i locenv-entry-size)))
                                  (let ((new-curr (index->new curr)))
                                    (if (not new-curr) ;; removed by resize?
                                        (loop2 prev
                                               (vector-ref locenv curr)
                                               new-prev)
                                        (begin
                                          (vector-set!
                                           new-locenv
                                           new-prev
                                           new-curr)
                                          (vector-set!
                                           new-locenv
                                           (+ new-prev 1)
                                           (vector-ref locenv (+ prev 1)))
                                          (loop2 curr
                                                 (vector-ref locenv curr)
                                                 new-curr))))))))))))
          (let loop3 ((j locenv-start-regs))
            (if (< j (vector-length new-locenv))
                (begin
                  (if (eqv? (vector-ref new-locenv j) 0)
                      (begin
                        (vector-set!
                         new-locenv
                         j
                         j)
                        (vector-set!
                         new-locenv
                         (+ j 1)
                         init)))
                  (loop3 (+ j locenv-entry-size)))
                new-locenv))))))

(define (locenv-merge locenv other-locenv slot-shift union)
  (let* ((lengths
          (vector-ref locenv 0))
         (nb-regs
          (vector-ref lengths 0))
         (nb-slots
          (vector-ref lengths 1))
         (nb-closed
          (vector-ref lengths 2))
         (new-locenv
          (make-locenv-from-lengths lengths))
         (start-slots
          (+ locenv-start-regs (* locenv-entry-size nb-regs)))
         (start-closed
          (+ start-slots (* locenv-entry-size nb-slots)))
         (other-lengths
          (vector-ref other-locenv 0))
         (other-nb-regs
          (vector-ref other-lengths 0))
         (other-nb-slots
          (vector-ref other-lengths 1))
         (other-nb-closed
          (vector-ref other-lengths 2))
         (other-start-slots
          (+ locenv-start-regs (* locenv-entry-size other-nb-regs)))
         (other-start-closed
          (+ other-start-slots (* locenv-entry-size other-nb-slots)))
         (len
          (+ locenv-start-regs
             (* locenv-entry-size (+ nb-regs nb-slots nb-closed)))))

    (define (index->other i) ;; map index from locenv to other-locenv
      (cond ((< i start-slots)
             (and (< i other-start-slots) i))
            ((< i start-closed)
             (let ((i* (+ (- i start-slots) (* locenv-entry-size slot-shift))))
               (and (>= i* 0)
                    (< i* (* locenv-entry-size other-nb-slots))
                    (+ i* other-start-slots))))
            (else
             (let ((i* (- i start-closed)))
               (and (< i* (* locenv-entry-size other-nb-closed))
                    (+ i* other-start-closed))))))

    (let loop ((i locenv-start-regs))
      (if (< i len)
          (let* ((j (index->other i))
                 (type (vector-ref locenv (+ i 1))))
            (vector-set! new-locenv i i) ;; TODO: merge ec
            (vector-set!
             new-locenv
             (+ i 1)
             (if (not j)
                 type
                 (union type (vector-ref other-locenv (+ j 1)))))
            (loop (+ i locenv-entry-size)))
          new-locenv))))

(define (locenv-ec-detach locenv loc)

  ;; This procedure removes the location loc from its current
  ;; equivalence class.

  (let ((new-locenv (vector-copy locenv)))
    (locenv-ec-detach! new-locenv loc)))

(define (locenv-ec-detach! locenv loc)

  ;; This procedure removes the location loc from its current
  ;; equivalence class.

  (let ((ec (vector-ref locenv loc)))
    (if (= ec loc) ;; already in its own equivalence class?
        locenv
        (begin
          (vector-set! locenv loc loc)
          (let loop ((prev loc) (curr ec))
            (if (= curr loc)
                (begin
                  (vector-set! locenv prev ec)
                  locenv)
                (loop curr (vector-ref locenv curr))))))))

(define (locenv-add! locenv loc-dst loc-src)

  ;; This procedure adds the location loc-dst to the equivalence
  ;; class of the location loc-src.

  (vector-set! locenv loc-dst (vector-ref locenv loc-src))
  (vector-set! locenv (+ loc-dst 1) (vector-ref locenv (+ loc-src 1)))
  (vector-set! locenv loc-src loc-dst)
  locenv)

(define (locenv-copy locenv loc-dst loc-src)

  ;; This procedure adds the location loc-dst to the equivalence
  ;; class of the loc-src location (after removing the loc-dst
  ;; location from its current equivalence class).

  ;; As an optimization, check if the src and dst locations are in the
  ;; same equivalence class and the only ones in that class (this also
  ;; covers the case src = dst).

  (if (and (= (vector-ref locenv loc-src) loc-dst)
           (= (vector-ref locenv loc-dst) loc-src))

      locenv ;; nothing needs to change

      (let ((new-locenv (vector-copy locenv)))
        (locenv-ec-detach! new-locenv loc-dst)
        (locenv-add! new-locenv loc-dst loc-src))))

(define (locenv-set locenv loc val)

  ;; This procedure stores val in the location loc after removing it
  ;; from its current equivalence class.

  ;; As an optimization, check if the location loc is alone in its
  ;; equivalence class and it currently contains val.

  (if (and (= (vector-ref locenv loc) loc)
           (locenv-val-eqv? locenv (vector-ref locenv (+ loc 1)) val))

      locenv ;; nothing needs to change

      (let ((new-locenv (vector-copy locenv)))
        (locenv-ec-detach! new-locenv loc)
        (vector-set! new-locenv (+ loc 1) val)
        new-locenv)))

(define (locenv-update locenv opnds vals)

  ;; This procedure stores the values in vals in the corresponding
  ;; locations in opnds and the locations in its equivalence class.

  ;; As an optimization, only create a new locenv if there is a change.

  (let loop1 ((opnds opnds)
              (vals vals)
              (new-locenv #f))
    (if (pair? opnds)
        (let ((opnd (car opnds)))
          (if (locenv-loc? opnd)
              (let* ((le (or new-locenv locenv))
                     (loc (gvm-loc->locenv-index le opnd))
                     (val (vector-ref le (+ loc 1)))
                     (new-val (car vals)))
                (if (locenv-val-eqv? le val new-val)
                    (loop1 (cdr opnds)
                           (cdr vals)
                           new-locenv)
                    (let ((new-locenv
                           (or new-locenv
                               (vector-copy locenv))))
                      (let loop2 ((i (vector-ref new-locenv loc)))
                        (vector-set! new-locenv (+ i 1) new-val)
                        (if (= i loc)
                            (loop1 (cdr opnds)
                                   (cdr vals)
                                   new-locenv)
                            (loop2 (vector-ref new-locenv i)))))))
              (loop1 (cdr opnds)
                     (cdr vals)
                     new-locenv)))
        (or new-locenv locenv))))

(define (locenv-ref locenv loc)

  ;; This procedure retrieves the value associated with the location loc.

  (vector-ref locenv (+ loc 1)))

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
      (not (and (eq? (gvm-instr-kind gvm-instr) 'copy)
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

  (define node-entry-bgcolor dot-digraph-black)
  (define node-type-bgcolor  dot-digraph-gray60)
  (define node-info-default-bgcolor  dot-digraph-gray70)
  (define node-bgcolor       dot-digraph-gray80)

  (define (get-unique-node-info-bgcolor orig-lbl force-default-color)
    ;; loop through pre-selected distinct colors
    ;; https://stackoverflow.com/a/20298027/5079316
    (define colors
      #("#ff0056" "#00ff00" "#0000ff" "#ff0000" "#01fffe" "#ffa6fe"
        "#ffdb66" "#006401" "#010067" "#95003a" "#007db5" "#ff00f6"
        "#ffeee8" "#774d00" "#90fb92" "#0076ff" "#d5ff00" "#ff937e"
        "#6a826c" "#ff029d" "#fe8900" "#7a4782" "#7e2dd2" "#85a900"
        "#e85ebe" "#a42400" "#00ae7e" "#683d3b" "#bdc6ff" "#263400"
        "#bdd393" "#00b917" "#9e008e" "#001544" "#c28c9f" "#ff74a3"
        "#01d0ff" "#004754" "#e56ffe" "#788231" "#0e4ca1" "#91d0cb"
        "#be9970" "#968ae8" "#bb8800" "#43002c" "#deff74" "#00ffc6"
        "#ffe502" "#620e00" "#008f9c" "#98ff52" "#7544b1" "#b500ff"
        "#00ff78" "#ff6e41" "#005f39" "#6b6882" "#5fad4e" "#a75740"
        "#a5ffd2" "#ffb167" "#009bff"))

    (if (and orig-lbl (not force-default-color))
      (vector-ref colors (modulo orig-lbl (vector-length colors)))
      node-info-default-bgcolor))


  (let ((bbs-tbl (make-table 'test: eq?))
        (proc-tbl (make-table)))

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

      (define (make-versions-table)
        (define table (make-table))

        (define (add-to-table bb)
          (let* ((instr-comment (gvm-instr-comment (bb-label-instr bb)))
                 (orig-lbl (comment-get instr-comment 'orig-lbl))
                 (versions (table-ref table orig-lbl '())))
            (table-set! table orig-lbl (cons bb versions))))
        (bbs-for-each-bb add-to-table bbs)
        table)

      (define versions-table (make-versions-table))

      (define (bb-has-cousin-versions? bb)
        (let* ((instr-comment (gvm-instr-comment (bb-label-instr bb)))
               (orig-lbl (comment-get instr-comment 'orig-lbl)))
          (> (length (table-ref versions-table orig-lbl)) 1)))

      (define (dump-bb bb)
        (let ((id (bb-id (bb-lbl-num bb) proc-index))
              (port-count 0)
              (rev-rows '())
              (branch-counters (get-branch-counters (bb-branch-instr bb))))

          (define (add-row row)
            (set! rev-rows (cons row rev-rows)))

          (define (gen-port)
            (set! port-count (+ port-count 1))
            (number->string port-count))

          (define nb-ports 0) ;; need to count ports to work around dot bug

          (define (decorate-instr code-and-rest last-instr?)
            (let ((code (car code-and-rest))
                  (rest (cdr code-and-rest))
                  (line-id (gen-port)))

              (define (target-id ref)
                (if (pair? ref)
                    (proc-id (car ref) (cdr ref)) ;; a label outside of this bbs
                    (bb-id ref proc-index))) ;; a label in this bbs

              (define (reference? x)
                (or (table-ref proc-tbl x #f) ;; a label outside of this bbs?
                    (and (>= (string-length x) 2) ;; a label in this bbs?
                         (char=? (string-ref x 0) #\#)
                         (string->number (substring x 1 (string-length x))))))

              (define (add-edge from side targ-id width label)
                (dot-digraph-add-edge!
                 dd
                 (dot-digraph-gen-edge
                  (string-append id ":" from side)
                  targ-id
                  width
                  label)))

              (define (add-branch-edge from targ-bbs targ-lbl)
                (let* ((t (table-ref branch-counters targ-bbs #f))
                       (count (if t (table-ref t targ-lbl 0) 0)))
                  (add-branch-edge-with-count from targ-bbs targ-lbl count)))

              (define (add-branch-edge-with-count from targ-bbs targ-lbl count)
                (let ((info (table-ref bbs-tbl targ-bbs)))
                  (add-edge
                   from
                   ":s"
                   (bb-id targ-lbl (cdr info))
                   (if (> count 0) (if (>= count 100) 8 4) 1)
                   (if (> count 0) (number->string count) #f))))

              (define (add-branch-edges from ref)
                (cond ((not ref)
                       ;; general GVM operand (register, stack, etc)
                       ;; add all branches that were observed
                       (for-each
                        (lambda (targ-bbs-and-table)
                          (let ((targ-bbs (car targ-bbs-and-table)))
                            (for-each
                             (lambda (targ-lbl-and-count)
                               (let ((targ-lbl (car targ-lbl-and-count))
                                     (count (cdr targ-lbl-and-count)))
                                 (add-branch-edge-with-count from targ-bbs targ-lbl count)))
                             (table->list (cdr targ-bbs-and-table)))))
                        (table->list branch-counters)))
                      ((pair? ref)
                       ;; a label outside of this bbs
                       (add-branch-edge from (proc-obj-code (car ref)) (cdr ref)))
                      (else
                       ;; a label in this bbs
                       (add-branch-edge from bbs ref))))

              (define (add-ref-edge from side ref)
                (add-edge from side (target-id ref) 0 #f))

              (dot-digraph-gen-row
               (dot-digraph-gen-col
                #f
                "left"
                (dot-digraph-gen-table
                 line-id
                 #f
                 (dot-digraph-gen-row
                  (let loop1 ((before
                               (list (dot-digraph-gen-html-escape
                                      (car code))))
                              (code
                               (cdr code)))
                    (if (pair? code)
                        (let* ((x
                                (car code))
                               (branch-destination?
                                (and last-instr?
                                     (pair? before)
                                     (equal? (car before) "")))
                               (ref
                                (reference? x)))
                          (if (or branch-destination? ref)
                              (if last-instr? ;; should arrow exit south?
                                  (let ((ref-id (gen-port)))
                                    (set! nb-ports (+ nb-ports 1))
                                    (if branch-destination?
                                        (add-branch-edges ref-id ref)
                                        (add-ref-edge ref-id ":s" ref))
                                    `(,@(dot-digraph-gen-col
                                         #f
                                         "left"
                                         (reverse before))
                                      ,@(dot-digraph-gen-col
                                         ref-id
                                         "left"
                                         `(,(dot-digraph-gen-html-escape x)))
                                      ,@(loop1 '()
                                               (cdr code))))
                                  (begin
                                    (add-ref-edge line-id ":w" ref)
                                    (loop1 (cons
                                            (dot-digraph-gen-html-escape x)
                                            before)
                                           (cdr code))))
                              (loop1 (cons
                                      (dot-digraph-gen-html-escape x)
                                      before)
                                     (cdr code))))
                        `(,@(dot-digraph-gen-col
                             #f
                             "left"
                             (reverse before))
                          ,@(if (pair? rest)
                                (let loop2 ((n (* 2 (if last-instr? 0 nb-ports))))
                                  (if (> n 0)
                                      `(,@(dot-digraph-gen-col
                                           #f
                                           "left"
                                           `())
                                        ,@(loop2 (- n 1)))
                                      (dot-digraph-gen-col
                                       #f
                                       "left"
                                       (dot-digraph-gen-text-style
                                        'comment
                                        (map dot-digraph-gen-html-escape
                                             rest)))))
                                `()))))))))))

          (define (format-instr gvm-instr)
            (cons gvm-instr
                  (format-gvm-instr-code gvm-instr)))

          (define (format-length lst)
            (let loop ((lst lst) (len 0))
              (if (pair? lst)
                  (loop (cdr lst) (+ len (string-length (car lst))))
                  len)))

          (define (max-format-length lst)
            (let loop ((lst lst) (len 0))
              (if (pair? lst)
                  (loop (cdr lst) (max len (format-length (car lst))))
                  len)))

          (let* ((gvm-instrs
                  (cons (bb-label-instr bb)
                        (append (keep useful-gvm-instr?
                                      (bb-non-branch-instrs bb))
                                (list
                                 (bb-branch-instr bb)))))
                 (code-rows
                  (map format-gvm-instr-code gvm-instrs))
                 (rows
                  (if #f
                      (map list code-rows)
                      (let* ((frame-rows
                              (map format-gvm-instr-frame gvm-instrs))
                             (width-code
                              (max-format-length code-rows))
                             (width-frame
                              (max-format-length frame-rows)))
                        (map (lambda (code-row frame-row)
                               (cons `(,@code-row
                                       ,(make-string
                                         (+ 1 (- width-code (format-length code-row)))
                                         #\space))
                                     `(,@frame-row
                                       ,(make-string
                                         (- width-frame (format-length frame-row))
                                         #\space))))
                             code-rows
                             frame-rows))))
                 (bb-info
                  (append
                   (if (= (bbs-entry-lbl-num bbs)
                          (bb-lbl-num bb))
                       (list (cons 'entry (format-gvm-obj proc #f)))
                       '())
                   (or (comment-get (gvm-instr-comment (bb-label-instr bb))
                                    'cfg-bb-info)
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
                                            ((info)
                                              (let ((instr-comment (gvm-instr-comment (bb-label-instr bb))))
                                                 (get-unique-node-info-bgcolor
                                                   (comment-get
                                                     instr-comment
                                                     'orig-lbl)
                                                   (not (bb-has-cousin-versions? bb)))))
                                            (else
                                             #f)))
                                         (esc-line
                                          (list (dot-digraph-gen-html-escape
                                                 line)))
                                         (decorated-line
                                          (case style
                                            ((entry info)
                                             (dot-digraph-gen-text-style
                                              style
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
                                    "left"
                                    (dot-digraph-gen-table
                                     #f
                                     bgcolor
                                     (dot-digraph-gen-row
                                      (dot-digraph-gen-col
                                       #f
                                       align
                                       decorated-line)))))))
                                bb-info))
                  ,@(let loop ((lst (reverse rows))
                               (last-instr? #t)
                               (result '()))
                      (if (pair? lst)
                          (loop (cdr lst)
                                #f
                                `(,@(decorate-instr (car lst) last-instr?)
                                  ,@result))
                          result))))))))))

      (bbs-for-each-bb dump-bb bbs))

    (let ((rprocs
           (reachable-procs procs)))

      (let loop1 ((i 0) (lst rprocs))
        (if (pair? lst)
            (let* ((proc (car lst))
                   (info (cons proc i)))
              (table-set! bbs-tbl (proc-obj-code proc) info)
              (table-set! proc-tbl (proc-repr proc) info)
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
                    (if jump? 1 0) ;; solid or dotted line
                    #f))))) ;; no label
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
             (dot-digraph-gen-text-style
              'invert
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
          (case (gvm-instr-kind gvm-instr)

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
    "  node [fontname = \"" ,dot-digraph-font-default "\" shape = \"none\"];\n"
    ,@(dot-digraph-nodes dd)
    ,@(dot-digraph-edges dd)
    "}\n"))

(define (dot-digraph-gen-edge from to width label)
  `("  " ,from " -> " ,to
    ,@(if (and (= width 1) (not label))
          '()
          `(" ["
            ,@(if label `("headlabel=\"" ,label "\" labelfontsize=" ,(number->string (* 4 (max 3 width)))) '())
            ,@(if (= width 1)
                  '()
                  (if (< width 1)
                      `(" style=dotted")
                      `(" style=\"setlinewidth(" ,(number->string width) ")\"")))
            "]"))
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

(define (dot-digraph-gen-col id align content)
  `("<td"
    ,@(if align
          `(" align=\"" ,align "\"")
          '())
    ,@(if id
          `(" port=\"" ,id "\"")
          '())
    ">"
    ,@content
    "</td>"))

(define dot-digraph-font-default "Courier")
;;(define dot-digraph-font-default "Courier New")
;;(define dot-digraph-font-default "Andale Mono")
;;(define dot-digraph-font-default "Monaco")

(define (dot-digraph-gen-text-style style content)
  (let* ((x (assq style
                  '((plain   #f #f   #f        #f #f)
                    (invert  #f #f   "#ffffff" #f #f)
                    (comment #f "9"  "#000080" #t #f)
                    (info    #f "7"  #f        #t #f)
                    (entry   #f "18" "#ffffff" #t #f))))
         (face       (and x (list-ref x 1)))
         (point-size (and x (list-ref x 2)))
         (color      (and x (list-ref x 3)))
         (bold?      (and x (list-ref x 4)))
         (italic?    (and x (list-ref x 5))))
    (dot-digraph-gen-font face point-size color bold? italic? content)))

(define (dot-digraph-gen-font face point-size color bold? italic? content)
  `(,@(if (or face point-size color)
          `("<font"
            ,@(if face
                  `(" face=\"" ,face "\"")
                  '())
            ,@(if point-size
                  `(" point-size=\"" ,point-size "\"")
                  '())
            ,@(if color
                  `(" color=\"" ,color "\"")
                  '())
            ">")
          '(""))
    ,@(if bold? '("<b>") '(""))
    ,@(if italic? '("<i>") '(""))
    ,@content
    ,@(if italic? '("</i>") '(""))
    ,@(if bold? '("</b>") '(""))
    ,(if (or face point-size color)
         "</font>"
         "")))

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

(define dot-digraph-gray60 "gray60")
(define dot-digraph-gray70 "gray70")
(define dot-digraph-gray80 "gray80")
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
                    (apply format-gvm-instr-code (cons gvm-instr bb)))))
    (display str port)
    (spaces (- 43 (string-length str)))
    (display " " port)
    (if show-frame?
        (write-gvm-instr-frame gvm-instr port)))

  (let ((x (gvm-instr-comment gvm-instr)))
    (if x
      (let ((y (comment-get x 'text)))
        (if y
          (begin
            (display " ; " port)
            (display y port)))))))

(define (write-gvm-instr-frame gvm-instr port)
  (display (apply string-append (format-gvm-instr-frame gvm-instr))
           port))

(define (format-gvm-instr-frame gvm-instr)
  (let ((frame (gvm-instr-frame gvm-instr))
        (types (gvm-instr-types gvm-instr)))

    (define (format-type-gvm-loc gvm-loc)
      (if types
          (let ((type
                 (locenv-ref types (gvm-loc->locenv-index types gvm-loc))))
            (if (type-eqv? type type-top)
                '("")
                `("|" ,@(format-type type))))
          '("")))

    (define (format-var var)
      (cond ((eq? var closure-env-var)
             (let ((closed (frame-closed frame)))
               (let loop ((i (length closed))
                          (lst (reverse closed))
                          (sep `())
                          (result `(")")))
                 (if (pair? lst)
                     (loop (- i 1)
                           (cdr lst)
                           `(" ")
                           (let* ((var (car lst))
                                  (type (format-type-gvm-loc (make-clo #f i))))
                             `(,(symbol->string (var-name (car lst)))
                               ,@type
                               ,@sep
                               ,@result)))
                     `("(" ,@result)))))
            ((eq? var ret-var)
             `("#ret"))
            ((var-temp? var)
             `("#"))
            (else
             `(,(symbol->string (var-name var))))))

    (define (live? var)
      (let ((live (frame-live frame)))
        (or (varset-member? var live)
            (and (eq? var closure-env-var)
                 (varset-intersects?
                  live
                  (list->varset (frame-closed frame)))))))

    (let ((regs (frame-regs frame)))
      (let loop1 ((i (- (length regs) 1))
                  (lst (reverse regs))
                  (sep `())
                  (result `()))
        (if (pair? lst)
            (let ((var (car lst)))
              (if (live? var) ;; only include live registers
                  (loop1 (- i 1)
                         (cdr lst)
                         `(" ")
                         (let* ((reg (make-reg i))
                                (info (if var
                                          `("=" ,@(format-var var))
                                          `()))
                                (type (if var
                                          (format-type-gvm-loc reg)
                                          `())))
                           `(,(format-gvm-opnd reg)
                             ,@info
                             ,@type
                             ,@sep
                             ,@result)))
                  (loop1 (- i 1)
                         (cdr lst)
                         sep
                         result)))
            (let ((slots (frame-slots frame)))
              (let loop2 ((i (length slots))
                          (lst slots)
                          (sep `())
                          (result `("]" ,@sep ,@result)))
                (if (pair? lst)
                    (loop2 (- i 1)
                           (cdr lst)
                           `(" ")
                           (let ((var (car lst)))
                             (if (live? var)
                                 (let* ((stk (make-stk i))
                                        (info (format-var var))
                                        (type (format-type-gvm-loc stk)))
                                   `(,@info
                                     ,@type
                                     ,@sep
                                     ,@result))
                                 `("."
                                   ,@sep
                                   ,@result))))
                    `("[" ,@result)))))))))

(define (format-gvm-instr-code gvm-instr . bb)

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

  (case (gvm-instr-kind gvm-instr)

    ((label)
     `(,(format-gvm-lbl (label-lbl-num gvm-instr))
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       ,@(case (label-kind gvm-instr)
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
             "format-gvm-instr-code, unknown label kind")))))

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
       "" ;; tag as a branch destination
       ,(format-gvm-lbl (ifjump-true gvm-instr))
       " else "
       "" ;; tag as a branch destination
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
                 `(,(format-gvm-obj (switch-case-obj c) #f)
                   " => "
                   "" ;; tag as a branch destination
                   ,(format-gvm-lbl (switch-case-lbl c))
                   ,@(if (null? next)
                         '()
                         `(", "
                           ,@(loop next)))))
               '()))
       ") "
       "" ;; tag as a branch destination
       ,(format-gvm-lbl (switch-default gvm-instr))))

    ((jump)
     `("  "
       ,(if (jump-poll? gvm-instr)
            (if (jump-safe? gvm-instr) "jump/poll/safe" "jump/poll")
            (if (jump-safe? gvm-instr) "jump/safe" "jump"))
       " fs="
       ,(number->string (frame-size (gvm-instr-frame gvm-instr)))
       " "
       "" ;; tag as a branch destination
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
      "format-gvm-instr-code, unknown 'gvm-instr':"
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
         (format-gvm-obj (obj-val gvm-opnd) #t))
        (else
         (compiler-internal-error
           "format-gvm-opnd, unknown 'gvm-opnd':"
           gvm-opnd))))

(define (format-gvm-lbl lbl)
  (string-append "#" (number->string lbl)))

(define (format-gvm-obj val quote?)
  (let ((str
         (if (proc-obj? val)
             (string-append
              (if (proc-obj-primitive? val)
                  "#<primitive "
                  "#<procedure ")
              (proc-obj-name val)
              ">")
             (object->string val))))
    (if (or (not quote?)
            (proc-obj? val)
            (number? val)
            (boolean? val)
            (char? val)
            (string? val)
            (void-object? val))
        str
        (string-append "'" str))))

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

;;;----------------------------------------------------------------------------
;;
;; GVM interpret
;; -----------------------------------------

;; Branch counters

(define (increment-branch-counter branch-instr target-bbs target-lbl)
  (let* ((table1
          (get-branch-counters branch-instr))
         (table2
          (or (table-ref table1 target-bbs #f)
              (let ((t (make-table)))
                (table-set! table1 target-bbs t)
                t))))
    (table-set!
     table2
     target-lbl
     (+ 1 (table-ref table2 target-lbl 0)))))

(define (get-branch-counters branch-instr)
  (let* ((comment
          (gvm-instr-comment branch-instr))
         (table
          (or (comment-get comment 'branch-counter)
              (let ((t (make-table 'test: eq?)))
                (comment-put! comment 'branch-counter t)
                t))))
    table))

;; Object model

(define-type First-Class-Label
  bbs
  id)

(define-type Closure
  slots) ;; slot 0 is label so ##closure-ref works

(define primitive-call-counter
  (make-table))

(define (pp-primitive-call-counter)
  (pp '***primitive-call-counter)
  (table-for-each
    (lambda a (pp a))
    primitive-call-counter))

(define (make-gvm-primitives)
  (let ((registered-primitives-table (make-table)))
    (table-for-each
      (lambda (name proc-obj)
        (let ((scheme-proc
                (with-exception-handler
                  (lambda (exc) #f)
                  (lambda () (eval name)))))
          (if scheme-proc
            (table-set!
              registered-primitives-table
              (symbol->string name)
              (lambda args
                (interpret-debug-ln "***primitive-call")
                (interpret-debug-ln (cons name args))
                (table-set!
                  primitive-call-counter
                  name
                  (+ 1
                     (table-ref
                       primitive-call-counter
                       name
                       0)))
                (apply scheme-proc args))))))
      (make-prim-proc-table))
    registered-primitives-table))

(define gvm-primitives #f) ;; init on first execution
(define (init-gvm-primitives)
  (if (not gvm-primitives) (set! gvm-primitives (make-gvm-primitives))))

(define (get-primitive name) (table-ref gvm-primitives name))

(define (Closure-ref clo i) (vector-ref (Closure-slots clo) i))
(define (Closure-set! clo i val) (vector-set! (Closure-slots clo) i val))

;; Runtime

(define (make-global-env)
  (let ((env (make-table)))
    (table-for-each
      (lambda (name proc-obj) (table-set! env (symbol->string name) proc-obj))
      (make-prim-proc-table))
      env))
(define (global-ref env name) (table-ref env name))
(define (global-set! env name value) (table-set! env name value))

(define (make-stack) (vector (make-stretchable-vector 0) 0))
(define (stack-pointer stack) (vector-ref stack 1))
(define (stack-pointer-set! stack sp) (vector-set! stack 1 sp))
(define (stack-stack stack) (vector-ref stack 0))
(define (frame-index->stack-index i s fs) (+ i (- (stack-pointer s) 1 fs)))
(define (stack-ref stack fs index)
  (stretchable-vector-ref
    (stack-stack stack)
    (frame-index->stack-index index stack fs)))
(define (stack-set! stack fs index val)
  (stretchable-vector-set!
    (stack-stack stack)
    (frame-index->stack-index index stack fs)
    val))
(define (stack-exit-frame! stack bb)
  (let* ((enter-fs (bb-entry-frame-size bb))
         (exit-fs (bb-exit-frame-size bb)))
    (stack-pointer-set!
      stack
      (+ (stack-pointer stack) (- exit-fs enter-fs)))))

(define (make-registers) (make-stretchable-vector 0))
(define (register-ref registers n) (stretchable-vector-ref registers n))
(define (register-set! registers n val)
  (stretchable-vector-set! registers n val))

(define interpreter-trace? #f)

(define (interpret-debug-ln msg)
  (if interpreter-trace? (println msg)))

(define (interpret-debug msg)
  (if interpreter-trace? (display msg)))

(define (gvm-interpret module-procs)
  (pp '***GVM-Interpreter)

  (init-gvm-primitives)

  (let* ((global-env (make-global-env))
         (stack (make-stack))
         (registers (make-registers))
         (main-proc (car module-procs))
         (main-bbs (proc-obj-code main-proc))
         (entry-lbl-num (bbs-entry-lbl-num main-bbs)))
    ;; dummy empty return adress
    (register-set! registers 0 'exit-return-address)
    (bb-interpret main-bbs (lbl-num->bb entry-lbl-num main-bbs) global-env stack registers)
    (pp-primitive-call-counter)))

(define (bb-interpret bbs bb env stack registers)
  (define (get-value opnd)
    (cond
      ((reg? opnd)
        (register-ref registers (reg-num opnd)))
      ((stk? opnd)
        (let ((fs (bb-entry-frame-size bb)))
          (stack-ref stack fs (stk-num opnd))))
      ((glo? opnd)
        (global-ref env (glo-name opnd)))
      ((clo? opnd)
        (let ((clo (get-value (clo-base opnd))))
          (Closure-ref clo (clo-index opnd))))
      ((lbl? opnd)
        (make-First-Class-Label bbs (lbl-num opnd)))
      ((obj? opnd)
        (let ((val (obj-val opnd)))
          (cond
            ((proc-obj? val)
              val)
            (else
              (obj-val opnd)))))
      (else
        (error "unknown value to copy" opnd))))

  ;; HELPERS
  (define (pp-gvm-obj o)
    (define (pp-with-tag tag . names)
      (display "<") (display tag)
      (for-each (lambda (n) (display " ") (display n)) names)
      (display ">\n"))

    (cond
      ((proc-obj? o)
        (pp-with-tag "procedure" (proc-obj-name o)))
      ((First-Class-Label? o)
        (pp-with-tag
          "label"
          (First-Class-Label-id o)
          (bbs-entry-lbl-num (First-Class-Label-bbs o))))
      ((Closure? o)
        (pp-with-tag "closure"))
      ((eq? o 'empty-stack-slot)
        (display ".\n"))
      (else
        (display o) (display "\n"))))


  (define (debug-stk)
    (if interpreter-trace?
      (let* ((sp (stack-pointer stack))
             (fs (bb-entry-frame-size bb))
             (frame-bottom (frame-index->stack-index 0 stack fs))
             (len (stretchable-vector-length (stack-stack stack))))
        (for-each
          (lambda (i)
              (let ((frame-index (- i frame-bottom)))
                (if (= frame-index 1)
                  (begin
                    (display "--- fs=")
                    (display fs)
                    (display " ---\n")))
                (display (- i frame-bottom))
                (display ": ")
                (pp-gvm-obj (stretchable-vector-ref (stack-stack stack) i))))
          (iota len))
        (if (= (- len frame-bottom) 1) ;; add fs when current frame is yet unassigned
          (begin
            (display "--- fs=")
            (display fs)
            (display " ---\n"))))))

  (define (debug-reg)
    (if interpreter-trace?
      (let ((len (stretchable-vector-length registers)))
        (for-each
          (lambda (i)
            (display i)
            (display ": ")
            (pp-gvm-obj (stretchable-vector-ref registers i)))
          (iota len)))))

  (define (get-label-parameters-info nargs closed?)
    (pcontext-map ((target-label-info target) nargs closed?)))

  (define (get-jump-parameters-info nargs)
    (pcontext-map ((target-jump-info target) nargs)))

  (define (get-proc-result-loc)
    (target-proc-result target))

  (define (get-args-loc parameters-info)
    (let ((nargs (apply max 0 (filter number? (map car parameters-info))))) ;; params start at 1
      (map (lambda (i) (cdr (assq i parameters-info))) (iota nargs 1))))

  (define (get-ret-loc params-info)
    (cdr (assq 'return params-info)))

  (define (get-closure-loc params-info)
    (cdr (assq 'closure-env params-info)))

  (define (get-proc-obj-entry-lbl proc)
    (let* ((code (proc-obj-code proc))
           (bb (lbl-num->bb (bbs-entry-lbl-num code) code)))
      (bb-label-instr bb)))

  (define (get-proc-obj-nparams proc)
    (label-entry-nb-parms (get-proc-obj-entry-lbl proc)))

  (define (get-proc-obj-rest? proc)
    (label-entry-rest? (get-proc-obj-entry-lbl proc)))

  (define (set-return-label loc ret)
    (if ret (interpret-write loc (make-First-Class-Label bbs ret))))

  (define (align-args! args nparams keys opts rest? clo)
    ;; TODO opts is ignored
    ;; TODO keys are ignored and they default values are simply pluged-in
    (let* ((closed? (if clo #t #f))
           (keys (or keys '()))
           (args (append args (map obj-val (map cdr keys)))) ;; TODO: temporary hack
           (params-info (get-label-parameters-info nparams closed?))
           (args-loc (get-args-loc params-info))
           (nargs (length args))
           (nparams-without-rest (if rest? (- nparams 1) nparams))
           (args-with-rest
             (cond
               ((< nargs nparams-without-rest)
                (error "missing arguments"))
               (rest?
                  (let ((rest-arg (list-tail args nparams-without-rest)))
                    (append (map ;;sublist
                              (lambda (x y) x)
                              args
                              (iota nparams-without-rest))
                            (list rest-arg))))
               ((= nargs nparams)
                 args)
               (else
                 (error "too many arguments")))))
    (if closed? (interpret-write (get-closure-loc params-info) clo))
    (for-each interpret-write args-loc args-with-rest)))

  (define (jump-to instr target-bbs lbl-num from-bb nargs ret clo)
    (let* ((nargs (or nargs 0))
           (target-bb (lbl-num->bb lbl-num target-bbs))
           (target-label (bb-label-instr target-bb))
           (params-info (get-jump-parameters-info nargs))
           (ret-loc (get-ret-loc params-info))
           (args-loc (get-args-loc params-info))
           (args-values (map get-value args-loc))
           (expect-jump-to-closure (if clo #t #f)))
      (increment-branch-counter instr target-bbs lbl-num)
      (stack-exit-frame! stack from-bb)
      (if ret (set-return-label ret-loc ret))
      (if (eq? (label-kind target-label) 'entry)
        (let ((nparams (label-entry-nb-parms target-label))
              (has-rest (label-entry-rest? target-label))
              (opts (label-entry-opts target-label))
              (keys (label-entry-keys target-label))
              (closed? (label-entry-closed? target-label)))
          (if (not (boolean=? expect-jump-to-closure closed?))
              (error "jump-to closure-entry-point without closure"))
          (align-args! args-values nparams keys opts has-rest clo)))
      (if (eq? (label-kind target-label) 'return)
        (interpret-debug-ln "=========== JUMP OUT ==========="))
      (bb-interpret target-bbs target-bb env stack registers)))

  (define (jump-to-entry instr bbs from-bb nargs ret)
    (jump-to instr bbs (bbs-entry-lbl-num bbs) from-bb nargs ret #f))

  (define (jump-to-no-args instr bbs lbl-num from-bb ret)
    (jump-to instr bbs lbl-num from-bb 0 ret #f))

  (define (gvm-proc-obj-primitive? obj)
    (and (proc-obj? obj) (proc-obj-primitive? obj) (not (proc-obj-code obj))))

  (define (exec-prim name args)
    (apply (get-primitive name) args))

  (define (interpret-write target value)
    (cond
      ((reg? target)
        (register-set! registers (reg-num target) value))
      ((stk? target)
        (let ((fs (bb-entry-frame-size bb)))
          (stack-set! stack fs (stk-num target) value)))
      ((glo? target)
        (global-set! env (glo-name target) value))
      ((clo? target)
        (let ((clo (get-value (clo-base target))))
          (Closure-set! clo (clo-index target) value)))
      (else
        (error "cannot write to" target))))

  ;; COPY
  (define (copy-interpret instr)
    (let* ((opnd (copy-opnd instr))
           (value (if opnd
                      (get-value opnd)
                      'empty-stack-slot)) ;; #f opnd means allocation of a slot
           (target (copy-loc instr)))
      (interpret-write target value)))

  ;; CALL HELPERS
  (define (call-proc-obj-interpret instr proc nargs ret)
    (if (gvm-proc-obj-primitive? proc)
      ;; primitive
      (let* ((params-info (get-jump-parameters-info nargs))
             (args (map get-value (get-args-loc params-info)))
             (return-loc (get-ret-loc params-info))
             (result (exec-prim (proc-obj-name proc) args)))
        (interpret-write (get-proc-result-loc) result)
        (if ret (jump-to-no-args instr bbs ret bb ret)))
      ;; others
      (begin
        (interpret-debug "=========== JUMP IN ")
        (interpret-debug (proc-obj-name proc))
        (interpret-debug-ln " ===========")
        (jump-to-entry instr (proc-obj-code proc) bb nargs ret))))

  ;; JUMP
  (define (jump-interpret instr)
    (let ((opnd (jump-opnd instr))
          (ret (jump-ret instr))
          (nargs (jump-nb-args instr)))
      (if (and (lbl? opnd) (not nargs))
          (jump-to-no-args instr bbs (lbl-num opnd) bb ret) ;; static jump
          (let ((val (get-value opnd))) ;; call
            (cond
              ((eq? val 'exit-return-address)
                (interpret-debug-ln '***GVM-Interpreter-END)
                #f)
              ((proc-obj? val)
                (call-proc-obj-interpret instr val nargs ret))
              ((First-Class-Label? val)
                (let ((lbl-bbs (First-Class-Label-bbs val))
                      (lbl-id (First-Class-Label-id val)))
                  (jump-to instr lbl-bbs lbl-id bb nargs ret #f)))
              ((Closure? val)
                (let* ((clo-lbl (Closure-ref val 0))
                       (lbl-bbs (First-Class-Label-bbs clo-lbl))
                       (lbl-id (First-Class-Label-id clo-lbl)))
                  (jump-to instr lbl-bbs lbl-id bb nargs ret val)))
              (else
                (error "unknown JUMP to" val)))))))

  ;; IFJUMP
  (define (ifjump-interpret instr)
    (let* ((test (ifjump-test instr))
           (opnds (ifjump-opnds instr))
           (opnds-values (map get-value opnds)))
      (if (gvm-proc-obj-primitive? test)
        (let* ((result (exec-prim (proc-obj-name test) opnds-values)))
          (if result
            (jump-to-no-args instr bbs (ifjump-true instr) bb #f)
            (jump-to-no-args instr bbs (ifjump-false instr) bb #f)))
        (error "ifjump test is not a primitive"))))

  ;; APPLY
  (define (apply-interpret instr)
    (let* ((prim (apply-prim instr))
           (opnds (apply-opnds instr))
           (opnds-values (map get-value opnds))
           (loc (apply-loc instr))
           (result (exec-prim (proc-obj-name prim) opnds-values)))
      (if loc (interpret-write loc result))))

  ;; CLOSE
  (define (close-interpret instr)
    (let* ((parms (close-parms instr))
           (closures
             (map
               (lambda (p)
                 (let* ((loc (closure-parms-loc p))
                        (closure (make-Closure #f)))
                    (interpret-write loc closure)
                    closure))
               parms)))
      (for-each
        (lambda (p c)
          (let* ((lbl (closure-parms-lbl p))
                 (opnds (closure-parms-opnds p))
                 (slots
                   (list->vector
                     (cons (make-First-Class-Label bbs lbl)
                           (map get-value opnds)))))
          (Closure-slots-set! c slots)))
        parms closures)))


  ;; SWITCH
  (define (switch-interpret instr)
    (error "TODO switch" instr))

  (define (print-interpreter-trace instr)
    (interpret-debug "Registers:\n")
    (debug-reg)
    (interpret-debug "Stack:\n")
    (debug-stk)
    (interpret-debug "\n")
    (interpret-debug "Executing in #")
    (interpret-debug (bb-lbl-num bb))
    (interpret-debug " - ")
    (interpret-debug (gvm-instr-kind instr))
    (interpret-debug ":\n")
    (if interpreter-trace? (write-gvm-instr instr (current-output-port)))
    (interpret-debug "\n\n"))

  (define (instr-interpret instr)
    (print-interpreter-trace instr)
    (case (gvm-instr-kind instr)
      ((apply)
       (apply-interpret instr))
      ((copy)
       (copy-interpret instr))
      ((close)
       (close-interpret instr))
      ((ifjump)
       (ifjump-interpret instr))
      ((switch)
       (switch-interpret instr))
      ((jump)
       (jump-interpret instr))
      (else
        (error "unknown instruction" (gvm-instr-kind instr)))))

  (let* ((instructions (bb-non-branch-instrs bb))
         (branch (bb-branch-instr bb)))
    (for-each instr-interpret instructions)
    (instr-interpret branch)))
