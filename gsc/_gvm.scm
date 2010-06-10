;;;============================================================================

;;; File: "_gvm.scm", Time-stamp: <2010-06-10 16:31:50 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

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
            (lambda (env) #f) ; testable?
            #f ; test
            (lambda (env) #f) ; expandable?
            #f ; expand
            (lambda (env) #f) ; inlinable?
            #f ; inline
            (lambda (env) #f) ; jump-inlinable?
            #f ; jump-inline
            #f ; specialize
            #f ; simplify
            side-effects?
            strict-pat
            lift-pat
            type
            standard)))
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

(define (proc-obj-code-set! obj x)            (vector-set! obj 4 x))
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
          1                            ; 1 - next assignable label number
          (make-stretchable-vector #f) ; 2 - vector of basic blocks
          #f))                         ; 3 - entry label number

(define bbs-tag (list 'bbs))

(define (bbs? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) bbs-tag)))

(define (bbs-next-lbl-num bbs)               (vector-ref bbs 1))
(define (bbs-next-lbl-num-set! bbs lbl-num)  (vector-set! bbs 1 lbl-num))
(define (bbs-basic-blocks bbs)               (vector-ref bbs 2))
(define (bbs-basic-blocks-set! bbs blocks)   (vector-set! bbs 2 blocks))
(define (bbs-entry-lbl-num bbs)              (vector-ref bbs 3))
(define (bbs-entry-lbl-num-set! bbs lbl-num) (vector-set! bbs 3 lbl-num))

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

(define (lbl-num->bb lbl-num bbs)
  (stretchable-vector-ref (bbs-basic-blocks bbs) lbl-num))

;; Basic block manipulation procedures:

(define (make-bb label-instr bbs)
  (let ((bb (vector
              label-instr   ; 0 - 'label' instr
              (queue-empty) ; 1 - sequence of non-branching instrs
              '()           ; 2 - branch instruction
              '()           ; 3 - basic blocks referenced by this block
              '())))        ; 4 - basic blocks which jump to this block
                            ;     (both filled in by 'bbs-purify!')
    (stretchable-vector-set!
      (bbs-basic-blocks bbs)
      (label-lbl-num label-instr)
      bb)
    bb))

(define (bb-lbl-num bb)                  (label-lbl-num (vector-ref bb 0)))
(define (bb-label-type bb)               (label-type (vector-ref bb 0)))
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

(define (bb-add-reference! bb ref)
  (if (not (memq ref (vector-ref bb 3)))
    (vector-set! bb 3 (cons ref (vector-ref bb 3)))))

(define (bb-add-precedent! bb prec)
  (if (not (memq prec (vector-ref bb 4)))
    (vector-set! bb 4 (cons prec (vector-ref bb 4)))))

(define (bb-last-non-branch-instr bb)
  (let ((non-branch-instrs (bb-non-branch-instrs bb)))
    (if (null? non-branch-instrs)
      (bb-label-instr bb)
      (let loop ((l non-branch-instrs))
        (if (pair? (cdr l))
          (loop (cdr l))
          (car l))))))

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

(define (make-jump opnd nb-args poll? safe? frame comment)
  (vector 'jump frame comment opnd nb-args poll? safe?))
(define (jump-opnd gvm-instr)    (vector-ref gvm-instr 3))
(define (jump-nb-args gvm-instr) (vector-ref gvm-instr 4))
(define (jump-poll? gvm-instr)   (vector-ref gvm-instr 5))
(define (jump-safe? gvm-instr)   (vector-ref gvm-instr 6))
(define (first-class-jump? gvm-instr) (jump-nb-args gvm-instr))

(define (make-comment)
  (cons 'comment '()))

(define (comment-put! comment name val)
  (set-cdr! comment (cons (cons name val) (cdr comment))))

(define (comment-get comment name)
  (and comment
       (let ((x (assq name (cdr comment))))
         (if x (cdr x) #f))))

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

(define (bbs-purify! bbs)
  (let loop () ; iterate until code does not change
    (bbs-remove-jump-cascades! bbs)
    (bbs-remove-dead-code! bbs)
    (let* ((changed1? (bbs-remove-common-code! bbs))
           (changed2? (bbs-remove-useless-jumps! bbs)))
      (if (or changed1? changed2?) (loop) (bbs-order! bbs)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 1, Jump cascade removal:

(define (bbs-remove-jump-cascades! bbs)

  (define (empty-bb? bb)
    (and (eq? (bb-label-type bb) 'simple)     ; simple label and
         (null? (bb-non-branch-instrs bb))))  ; no non-branching instrs

  (define (jump-to-non-entry-lbl? branch)
    (and (eq? (gvm-instr-type branch) 'jump)
         (not (first-class-jump? branch)) ; not a jump to an entry label
         (jump-lbl? branch)))

  (define (jump-cascade-to lbl-num fs poll? seen thunk)
    (if (memq lbl-num seen) ; infinite loop?
      (thunk lbl-num fs poll?)
      (let ((bb (lbl-num->bb lbl-num bbs)))
        (if (and (empty-bb? bb) (<= (bb-slots-gained bb) 0))
          (let ((jump-lbl-num
                 (jump-to-non-entry-lbl? (bb-branch-instr bb))))
            (if jump-lbl-num
              (jump-cascade-to
                jump-lbl-num
                (+ fs (bb-slots-gained bb))
                (or poll? (jump-poll? (bb-branch-instr bb)))
                (cons lbl-num seen)
                thunk)
              (thunk lbl-num fs poll?)))
          (thunk lbl-num fs poll?)))))

  (define (equiv-lbl lbl-num seen)
    (if (memq lbl-num seen) ; infinite loop?
      lbl-num
      (let ((bb (lbl-num->bb lbl-num bbs)))
        (if (empty-bb? bb)
          (let ((jump-lbl-num
                 (jump-to-non-entry-lbl? (bb-branch-instr bb))))
            (if (and jump-lbl-num
                     (not (jump-poll? (bb-branch-instr bb)))
                     (= (bb-slots-gained bb) 0))
              (equiv-lbl jump-lbl-num (cons lbl-num seen))
              lbl-num))
          lbl-num))))

  (define (remove-cascade! bb)
    (let ((branch (bb-branch-instr bb)))

      (case (gvm-instr-type branch)

        ((ifjump)  ; branch is an 'ifjump'
         (bb-put-branch! bb
           (make-ifjump (ifjump-test branch)
                        (ifjump-opnds branch)
                        (equiv-lbl (ifjump-true branch) '())
                        (equiv-lbl (ifjump-false branch) '())
                        (ifjump-poll? branch)
                        (gvm-instr-frame branch)
                        (gvm-instr-comment branch))))

        ((switch)  ; branch is a 'switch'
         (bb-put-branch! bb
           (make-switch (switch-opnd branch)
                        (map (lambda (c)
                               (make-switch-case
                                (switch-case-obj c)
                                (equiv-lbl (switch-case-lbl c) '())))
                             (switch-cases branch))
                        (equiv-lbl (switch-default branch) '())
                        (switch-poll? branch)
                        (gvm-instr-frame branch)
                        (gvm-instr-comment branch))))

        ((jump)  ; branch is a 'jump'
         (if (not (first-class-jump? branch)) ; but not to an entry label
           (let ((dest-lbl-num (jump-lbl? branch)))
             (if dest-lbl-num

               (jump-cascade-to
                 dest-lbl-num
                 (frame-size (gvm-instr-frame branch))
                 (jump-poll? branch)
                 '()
                 (lambda (lbl-num fs poll?)
                   (let* ((dest-bb (lbl-num->bb lbl-num bbs))
                          (last-branch (bb-branch-instr dest-bb)))
                     (if (and (empty-bb? dest-bb)
                              (or (not poll?)
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
                            (bb-put-branch! bb
                              (make-ifjump (ifjump-test last-branch)
                                           (map adjust-opnd
                                                (ifjump-opnds last-branch))
                                           (equiv-lbl
                                             (ifjump-true last-branch)
                                             '())
                                           (equiv-lbl
                                             (ifjump-false last-branch)
                                             '())
                                           (or poll?
                                               (ifjump-poll? last-branch))
                                           new-frame
                                           (gvm-instr-comment last-branch))))

                           ((switch)
                            (bb-put-branch! bb
                              (make-switch (adjust-opnd (switch-opnd last-branch))
                                           (map (lambda (c)
                                                  (make-switch-case
                                                   (switch-case-obj c)
                                                   (equiv-lbl (switch-case-lbl c) '())))
                                                (switch-cases last-branch))
                                           (equiv-lbl (switch-default last-branch) '())
                                           (or poll?
                                               (switch-poll? last-branch))
                                           new-frame
                                           (gvm-instr-comment last-branch))))

                           ((jump)
                            (bb-put-branch! bb
                              (make-jump (adjust-opnd (jump-opnd last-branch))
                                         (jump-nb-args last-branch)
                                         (or poll?
                                             (jump-poll? last-branch))
                                         (jump-safe? last-branch)
                                         new-frame
                                         (gvm-instr-comment last-branch))))

                           (else
                            (compiler-internal-error
                              "bbs-remove-jump-cascades!, unknown branch type"))))

                       (bb-put-branch! bb
                         (make-jump (make-lbl lbl-num)
                                    (jump-nb-args branch)
                                    (or poll?
                                        (jump-poll? branch))
                                    (jump-safe? branch)
                                    (frame-truncate
                                      (gvm-instr-frame branch)
                                      fs)
                                    (gvm-instr-comment branch)))))))))))

        (else
         (compiler-internal-error
           "bbs-remove-jump-cascades!, unknown branch type")))))

  (bbs-for-each-bb remove-cascade! bbs))

(define (jump-lbl? branch)
  (let ((opnd (jump-opnd branch)))
    (if (lbl? opnd) (lbl-num opnd) #f)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 2, Dead code removal:

(define (bbs-remove-dead-code! bbs)

  (let ((new-basic-blocks (make-stretchable-vector #f))
        (left-to-examine (queue-empty)))

    (define (reachable ref bb)
      (let ((ref-lbl-num (bb-lbl-num ref)))
        (if bb (bb-add-reference! bb ref))
        (if (not (stretchable-vector-ref new-basic-blocks ref-lbl-num))
          (begin
            (bb-references-set! ref '())
            (bb-precedents-set! ref '())
            (stretchable-vector-set! new-basic-blocks ref-lbl-num ref)
            (queue-put! left-to-examine ref)))))

    (define (direct-jump to-bb from-bb)
      (reachable to-bb from-bb)
      (bb-add-precedent! to-bb from-bb))

    (define (scan-instr gvm-instr bb)

      (define (scan-opnd gvm-opnd)
        (cond ((not gvm-opnd))
              ((lbl? gvm-opnd)
               (reachable (lbl-num->bb (lbl-num gvm-opnd) bbs) bb))
              ((clo? gvm-opnd)
               (scan-opnd (clo-base gvm-opnd)))))

      (case (gvm-instr-type gvm-instr)

        ((label)
         '())

        ((apply)
         (for-each scan-opnd (apply-opnds gvm-instr))
         (if (apply-loc gvm-instr)
           (scan-opnd (apply-loc gvm-instr))))

        ((copy)
         (scan-opnd (copy-opnd gvm-instr))
         (scan-opnd (copy-loc gvm-instr)))

        ((close)
         (for-each (lambda (parm)
                     (reachable (lbl-num->bb (closure-parms-lbl parm) bbs) bb)
                     (scan-opnd (closure-parms-loc parm))
                     (for-each scan-opnd (closure-parms-opnds parm)))
                   (close-parms gvm-instr)))

        ((ifjump)
         (for-each scan-opnd (ifjump-opnds gvm-instr))
         (direct-jump (lbl-num->bb (ifjump-true gvm-instr) bbs) bb)
         (direct-jump (lbl-num->bb (ifjump-false gvm-instr) bbs) bb))

        ((switch)
         (scan-opnd (switch-opnd gvm-instr))
         (for-each (lambda (c)
                     (direct-jump (lbl-num->bb (switch-case-lbl c) bbs) bb))
                   (switch-cases gvm-instr))
         (direct-jump (lbl-num->bb (switch-default gvm-instr) bbs) bb))

        ((jump)
         (let ((opnd (jump-opnd gvm-instr)))
           (if (lbl? opnd)
             (direct-jump (lbl-num->bb (lbl-num opnd) bbs) bb)
             (scan-opnd (jump-opnd gvm-instr)))))

        (else
         (compiler-internal-error
           "bbs-remove-dead-code!, unknown GVM instruction type"))))

    (reachable (lbl-num->bb (bbs-entry-lbl-num bbs) bbs) #f)

    (let loop ()
      (if (not (queue-empty? left-to-examine))
        (let ((bb (queue-get! left-to-examine)))
          (begin
            (scan-instr (bb-label-instr bb) bb)
            (for-each (lambda (gvm-instr) (scan-instr gvm-instr bb))
                      (bb-non-branch-instrs bb))
            (scan-instr (bb-branch-instr bb) bb)
            (loop)))))

    (bbs-basic-blocks-set! bbs new-basic-blocks)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 3, Useless jump removal:

(define (bbs-remove-useless-jumps! bbs)
  (let ((changed? #f))

    (define (remove-useless-jump bb)
      (let ((branch (bb-branch-instr bb)))

        ; is it a non-polling 'jump' to a label?

        (if (and (eq? (gvm-instr-type branch) 'jump)
                 (not (first-class-jump? branch))
                 (not (jump-poll? branch))
                 (jump-lbl? branch))
          (let* ((dest-bb (lbl-num->bb (jump-lbl? branch) bbs))
                 (frame1 (gvm-instr-frame (bb-last-non-branch-instr bb)))
                 (frame2 (gvm-instr-frame (bb-label-instr dest-bb))))

            ; is it a 'simple' label with the same frame as the last
            ; non-branch instruction?

            (if (and (eq? (bb-label-type dest-bb) 'simple)
                     (frame-eq? frame1 frame2)
                     (= (length (bb-precedents dest-bb)) 1))

              (begin
                (set! changed? #t)
                (bb-non-branch-instrs-set! bb
                  (append (bb-non-branch-instrs bb)
                          (bb-non-branch-instrs dest-bb)
                          '()))
                (bb-branch-instr-set! bb
                  (bb-branch-instr dest-bb))
                (remove-useless-jump bb)))))))

    (bbs-for-each-bb remove-useless-jump bbs)

    changed?))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 4, Common code removal:

(define (bbs-remove-common-code! bbs)
  (let ((n (bbs-next-lbl-num bbs)))
    (if (> n 300) ; if code is too large, don't optimize

      #f

      (let* ((hash-table-length (if (< n 50) 43 403))
             (hash-table (make-vector hash-table-length '()))
             (prim-table '())
             (lbl-map (make-stretchable-vector #f))
             (changed? #f))

      (define (hash-prim prim)
        (let ((n (length prim-table))
              (i (pos-in-list prim prim-table)))
          (if i
            (- n i)
            (begin
              (set! prim-table (cons prim prim-table))
              (+ n 1)))))

      (define (hash-opnds l) ; this assumes that operands are encoded with nbs
        (let loop ((l l) (n 0))
          (if (pair? l)
            (loop (cdr l)
                  (let ((x (car l)))
                    (if (lbl? x)
                      n
                      (modulo (+ (* n 10000) x) hash-table-length))))
            n)))

      (define (hash-bb bb) ; compute hash address for a basic block
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

      (define (add-map! bb1 bb2) ; bb1 should be replaced by bb2
        (stretchable-vector-set!
          lbl-map
          (bb-lbl-num bb1)
          (bb-lbl-num bb2)))

      (define (remove-map! bb)
        (stretchable-vector-set!
          lbl-map
          (bb-lbl-num bb)
          #f))

      (define (enter-bb! bb) ; enter a basic block in the hash table
        (let ((h (hash-bb bb)))
          (vector-set! hash-table h
            (add-bb bb (vector-ref hash-table h)))))

      (define (add-bb bb l) ; add basic block 'bb' to list of basic blocks
        (if (pair? l)
          (let ((bb* (car l))) ; pick next basic block in list

            (add-map! bb bb*) ; for now, assume that 'bb' = 'bb*'

            (if (eqv-bb? bb bb*) ; are they the same?

              (begin
                (set! changed? #t)
                l)

              (begin
                (remove-map! bb) ; they are not the same!
                (if (eqv-gvm-instr? (bb-branch-instr bb) (bb-branch-instr bb*))

                  (extract-common-tail bb bb* ; check if tail is the same
                    (lambda (head head* tail)
                      (if (<= (length tail) 10) ; common tail long enough?

                        ; no, so try rest of list
                        (cons bb* (add-bb bb (cdr l)))

                        ; create bb for common tail
                        (let* ((lbl
                                (bbs-new-lbl! bbs))
                               (branch
                                (bb-branch-instr bb))
                               (fs**
                                (need-gvm-instrs tail branch))
                               (frame
                                (frame-truncate
                                 (gvm-instr-frame
                                  (if (null? head)
                                    (bb-label-instr bb)
                                    (car head)))
                                 fs**))
                               (comment
                                (gvm-instr-comment (car tail)))
                               (bb**
                                (make-bb (make-label-simple lbl frame comment)
                                         bbs)))
                          (bb-non-branch-instrs-set! bb** tail)
                          (bb-branch-instr-set! bb** branch)
                          (bb-non-branch-instrs-set! bb* (reverse head*))
                          (bb-branch-instr-set! bb*
                            (make-jump (make-lbl lbl) #f #f #f frame comment))
                          (bb-non-branch-instrs-set! bb (reverse head))
                          (bb-branch-instr-set! bb
                            (make-jump (make-lbl lbl) #f #f #f frame comment))
                          (set! changed? #t)
                          (cons bb (cons bb* (add-bb bb** (cdr l))))))))
                          ;********** bb and bb* should not be put in this list!!!!
                    (cons bb* (add-bb bb (cdr l)))))))

            (list bb)))

      (define (extract-common-tail bb1 bb2 cont)
        (let loop ((l1 (reverse (bb-non-branch-instrs bb1)))
                   (l2 (reverse (bb-non-branch-instrs bb2)))
                   (tail '()))
          (if (and (pair? l1) (pair? l2))
            (let ((i1 (car l1))
                  (i2 (car l2)))
              (if (eqv-gvm-instr? i1 i2)
                (loop (cdr l1) (cdr l2) (cons i1 tail))
                (cont l1 l2 tail)))
            (cont l1 l2 tail))))

      (define (eqv-bb? bb1 bb2)
        (let ((bb1-non-branch (bb-non-branch-instrs bb1))
              (bb2-non-branch (bb-non-branch-instrs bb2)))
          (and (= (length bb1-non-branch) (length bb2-non-branch))
               (eqv-gvm-instr? (bb-label-instr bb1) (bb-label-instr bb2))
               (eqv-gvm-instr? (bb-branch-instr bb1) (bb-branch-instr bb2))
               (eqv-list? eqv-gvm-instr? bb1-non-branch bb2-non-branch))))

      (define (eqv-list? pred? l1 l2)
        (if (pair? l1)
          (and (pair? l2)
               (pred? (car l1) (car l2))
               (eqv-list? pred? (cdr l1) (cdr l2)))
          (not (pair? l2))))

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
                       (eqv? (jump-nb-args instr1)
                             (jump-nb-args instr2))
                       (eq? (jump-poll? instr1)
                            (jump-poll? instr2))
                       (eq? (jump-safe? instr1)
                            (jump-safe? instr2))))

                 (else
                  (compiler-internal-error
                    "eqv-gvm-instr?, unknown 'gvm-instr':" instr1))))))

      ; Fill hash table, remove equivalent basic blocks and common tails

      (bbs-for-each-bb enter-bb! bbs)

      ; Reconstruct bbs

      (bbs-entry-lbl-num-set! bbs
        (replacement-lbl-num (bbs-entry-lbl-num bbs)))

      (bbs-for-each-bb
        (lambda (bb)
          (if bb
            (replace-label-references! bb replacement-lbl-num)))
        bbs)

      changed?))))

(define (replace-label-references! bb replacement-lbl-num)

  (define (update-gvm-opnd opnd)
    (if opnd
      (cond ((lbl? opnd)
             (make-lbl (replacement-lbl-num (lbl-num opnd))))
            ((clo? opnd)
             (make-clo (update-gvm-opnd (clo-base opnd)) (clo-index opnd)))
            (else
             opnd))
      opnd))

  (define (update-gvm-instr instr)

    (define (update-closure-parms p)
      (make-closure-parms
        (update-gvm-opnd (closure-parms-loc p))
        (replacement-lbl-num (closure-parms-lbl p))
        (map update-gvm-opnd (closure-parms-opnds p))))

    (case (gvm-instr-type instr)

      ((apply)
       (make-apply (apply-prim instr)
                   (map update-gvm-opnd (apply-opnds instr))
                   (update-gvm-opnd (apply-loc instr))
                   (gvm-instr-frame instr)
                   (gvm-instr-comment instr)))

      ((copy)
       (make-copy (update-gvm-opnd (copy-opnd instr))
                  (update-gvm-opnd (copy-loc instr))
                  (gvm-instr-frame instr)
                  (gvm-instr-comment instr)))

      ((close)
       (make-close
         (map update-closure-parms (close-parms instr))
         (gvm-instr-frame instr)
         (gvm-instr-comment instr)))

      ((ifjump)
       (make-ifjump (ifjump-test instr)
                    (map update-gvm-opnd (ifjump-opnds instr))
                    (replacement-lbl-num (ifjump-true instr))
                    (replacement-lbl-num (ifjump-false instr))
                    (ifjump-poll? instr)
                    (gvm-instr-frame instr)
                    (gvm-instr-comment instr)))

      ((switch)
       (make-switch (update-gvm-opnd (switch-opnd instr))
                    (map (lambda (c)
                           (make-switch-case (switch-case-obj c)
                                             (replacement-lbl-num
                                              (switch-case-lbl c))))
                         (switch-cases instr))
                    (replacement-lbl-num (switch-default instr))
                    (switch-poll? instr)
                    (gvm-instr-frame instr)
                    (gvm-instr-comment instr)))

      ((jump)
       (make-jump (update-gvm-opnd (jump-opnd instr))
                  (jump-nb-args instr)
                  (jump-poll? instr)
                  (jump-safe? instr)
                  (gvm-instr-frame instr)
                  (gvm-instr-comment instr)))

      (else
       (compiler-internal-error
         "update-gvm-instr, unknown 'instr':" instr))))

  (bb-non-branch-instrs-set! bb
    (map update-gvm-instr (bb-non-branch-instrs bb)))
  (bb-branch-instr-set! bb
    (update-gvm-instr (bb-branch-instr bb))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Step 5, Basic block set ordering:

(define (bbs-order! bbs)

  (let ((ordered-blocks (queue-empty))
        (left-to-schedule (stretchable-vector-copy (bbs-basic-blocks bbs))))

    ; test if a basic block is in 'left-to-schedule' and return the
    ; basic block if it is

    (define (left-to-schedule? bb)
      (stretchable-vector-ref left-to-schedule (bb-lbl-num bb)))

    ; remove basic block from 'left-to-schedule'

    (define (remove-bb! bb)
      (stretchable-vector-set! left-to-schedule (bb-lbl-num bb) #f)
      bb)

    ; return a basic block which ends with a branch to 'bb' (and that is
    ; still in 'left-to-schedule') or #f if there aren't any

    (define (prec-bb bb)
      (let loop ((lst (bb-precedents bb)) (best #f) (best-fs #f))
        (if (null? lst)
          best
          (let* ((x (car lst))
                 (x-fs (bb-exit-frame-size x)))
            (if (and (left-to-schedule? x)
                     (or (not best) (< x-fs best-fs)))
              (loop (cdr lst) x x-fs)
              (loop (cdr lst) best best-fs))))))

    ; return the basic block which 'bb' jumps to (and that is still in
    ; bbs) or #f if there aren't any

    (define (succ-bb bb)

      (define (branches-to-lbl? bb)
        (let ((branch (bb-branch-instr bb)))
          (case (gvm-instr-type branch)
            ((ifjump) #t)
            ((switch) #t)
            ((jump) (lbl? (jump-opnd branch)))
            (else
             (compiler-internal-error
              "bbs-order!, unknown branch type")))))

      (define (best-succ bb1 bb2)   ; heuristic that determines which
        (if (branches-to-lbl? bb1)  ; bb is most frequently executed
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
             "bbs-order!, unknown branch type")))))

    ; schedule a given basic block 'bb' with it's predecessors and
    ; successors.

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
        (lambda (x)
          (if (left-to-schedule? x)
            (schedule-around (remove-bb! x))))
        (bb-references bb)))

    (schedule-from (remove-bb! (lbl-num->bb (bbs-entry-lbl-num bbs) bbs)))

    (let ((basic-blocks (make-stretchable-vector #f))
          (lbl-map (make-stretchable-vector #f)))

      (define (replacement-lbl-num lbl)
        (or (stretchable-vector-ref lbl-map lbl) lbl))

      (let loop ((lst (queue->list ordered-blocks)) (i 1))
        (if (pair? lst)

          (let* ((bb (car lst))
                 (label-instr (bb-label-instr bb)))
            (stretchable-vector-set! basic-blocks i bb)
            (stretchable-vector-set! lbl-map (label-lbl-num label-instr) i)
            (label-lbl-num-set! label-instr i)
            (loop (cdr lst) (+ i 1)))

          (begin

            ; Reconstruct bbs

            (bbs-next-lbl-num-set! bbs i)

            (bbs-basic-blocks-set! bbs basic-blocks)

            (bbs-entry-lbl-num-set! bbs
              (replacement-lbl-num (bbs-entry-lbl-num bbs)))

            (bbs-for-each-bb
              (lambda (bb)
                (replace-label-references!
                  bb
                  replacement-lbl-num))
              bbs)))))))

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
  (write-gvm-instr (bb-label-instr bb) port)
  (display " [precedents=" port)
  (write (map bb-lbl-num (bb-precedents bb)) port)
  (display "]" port)
  (newline port)

  (for-each (lambda (x) (write-gvm-instr x port) (newline port))
            (bb-non-branch-instrs bb))

  (write-gvm-instr (bb-branch-instr bb) port))

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

(define (virtual.dump procs port)

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

    (define (dump-proc p)

      (define (scan-code code)
        (let ((gvm-instr (code-gvm-instr code)))

          (if show-slots-needed?
            (begin
              (display "sn=" port)
              (display (code-slots-needed code) port)
              (display " | " port)))

          (write-gvm-instr gvm-instr port)
          (newline port)
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
             (scan-opnd (jump-opnd gvm-instr)))

            (else
             '()))))

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
                       (if (and loc (string? (vector-ref loc 0)));;;;;;;;;;;;;
                         (vector-ref loc 0)
                         prev-filename))
                     (line
                       (if (and loc (string? (vector-ref loc 0)))
                         (+ (**filepos-line (vector-ref loc 1)) 1)
                         prev-line)))
                (if (or (not (string=? filename prev-filename))
                        (not (= line prev-line)))
                  (begin
                    (display "#line " port)
                    (display line port)
                    (if (not (string=? filename prev-filename))
                      (begin
                        (display " " port)
                        (write filename port)))
                    (newline port)))

                (scan-code code)
                (loop (cdr l) filename line))
              (newline port)))

          (begin
            (display "C procedure of arity " port)
            (display (c-proc-arity x) port)
            (display " and body:" port)
            (newline port)
            (display (c-proc-body x) port)
            (newline port)))))

    (for-each (lambda (proc) (scan-opnd (make-obj proc))) procs)

    (let loop ()
      (if (not (queue-empty? proc-left))
        (begin
          (dump-proc (queue-get! proc-left))
          (loop))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Virtual instruction writing:
;; ---------------------------

(define (write-gvm-instr gvm-instr port)

  (define (write-closure-parms parms)
    (display " " port)
    (let ((len (+ 1 (write-gvm-opnd (closure-parms-loc parms) port))))
      (display " = (" port)
      (let ((len (+ len (+ 4 (write-gvm-lbl (closure-parms-lbl parms) port)))))
        (+ len (write-spaced-opnd-list (closure-parms-opnds parms) port)))))

  (define (write-spaced-opnd-list l port)
    (let loop ((l l) (len 0))
      (if (pair? l)
        (let ((opnd (car l)))
          (display " " port)
          (loop (cdr l) (+ len (+ 1 (write-gvm-opnd opnd port)))))
        (begin
          (display ")" port)
          (+ len 1)))))

  (define (write-opnd-list l port)
    (if (pair? l)
      (let ((len (write-gvm-opnd (car l) port)))
        (+ len (write-spaced-opnd-list (cdr l) port)))
      (begin
        (display ")" port)
        1)))

  (define (write-key-pair-list keys port)
    (if keys
      (begin
        (display " (" port)
        (if (pair? keys)
          (let loop ((l keys))
            (let* ((key-pair (car l))
                   (key (car key-pair))
                   (opnd (cdr key-pair))
                   (rest (cdr l)))
              (display "(" port)
              (let ((len (+ 1 (write-returning-len key port))))
                (display " " port)
                (let ((len (+ len (+ 1 (write-gvm-opnd opnd port)))))
                  (display ")" port)
                  (if (pair? rest)
                    (begin
                      (display " " port)
                      (+ len (+ 2 (loop rest))))
                    (begin
                      (display ")" port)
                      (+ len 4)))))))
          (begin
            (display ")" port)
            3)))
      0))

  (define (write-param-pattern gvm-instr port)
    (let ((len (write-returning-len
                 (label-entry-nb-parms gvm-instr)
                 port)))
      (display " (" port)
      (let ((len (+ len
                    (+ 2
                       (write-opnd-list
                         (label-entry-opts gvm-instr)
                         port)))))
        (let ((len (+ len
                      (write-key-pair-list
                        (label-entry-keys gvm-instr)
                        port))))
          (if (label-entry-rest? gvm-instr)
            (begin (display " +" port) (+ len 2))
            len)))))

  (define (write-prim-applic prim opnds port)
    (display "(" port)
    (let ((len (+ 1 (display-returning-len (proc-obj-name prim) port))))
      (+ len (write-spaced-opnd-list opnds port))))

  (define (write-instr gvm-instr)
    (case (gvm-instr-type gvm-instr)

      ((label)
       (let ((len (write-gvm-lbl (label-lbl-num gvm-instr) port)))
         (display " " port)
         (let ((len (+ len
                       (+ 1 (write-returning-len
                              (frame-size (gvm-instr-frame gvm-instr))
                              port)))))
           (case (label-type gvm-instr)
             ((simple)
              len)
             ((entry)
              (if (label-entry-closed? gvm-instr)
                (begin
                  (display " closure-entry-point " port)
                  (+ len (+ 21 (write-param-pattern gvm-instr port))))
                (begin
                  (display " entry-point " port)
                  (+ len (+ 13 (write-param-pattern gvm-instr port))))))
             ((return)
              (display " return-point" port)
              (+ len 13))
             ((task-entry)
              (display " task-entry-point" port)
              (+ len 17))
             ((task-return)
              (display " task-return-point" port)
              (+ len 18))
             (else
              (compiler-internal-error
                "write-gvm-instr, unknown label type"))))))

      ((apply)
       (display "  " port)
       (let ((len (+ 2 (write-gvm-opnd (apply-loc gvm-instr) port))))
         (display " = " port)
         (+ len
            (+ 3
               (write-prim-applic (apply-prim gvm-instr)
                                  (apply-opnds gvm-instr)
                                  port)))))

      ((copy)
       (display "  " port)
       (let ((len (+ 2 (write-gvm-opnd (copy-loc gvm-instr) port))))
         (display " = " port)
         (+ len (+ 3 (write-gvm-opnd (copy-opnd gvm-instr) port)))))

      ((close)
       (display "  close" port)
       (let ((len (+ 7 (write-closure-parms (car (close-parms gvm-instr))))))
         (let loop ((l (cdr (close-parms gvm-instr))) (len len))
           (if (pair? l)
             (let ((x (car l)))
               (display "," port)
               (loop (cdr l) (+ len (+ 1 (write-closure-parms x)))))
             len))))

      ((ifjump)
       (display "  if " port)
       (let ((len (+ 5
                     (write-prim-applic (ifjump-test gvm-instr)
                                        (ifjump-opnds gvm-instr)
                                        port))))
         (let ((len (+ len
                       (if (ifjump-poll? gvm-instr)
                         (begin (display " jump* " port) 7)
                         (begin (display " jump " port) 6)))))
           (let ((len (+ len
                         (write-returning-len
                           (frame-size (gvm-instr-frame gvm-instr))
                           port))))
             (display " " port)
             (let ((len (+ len
                           (+ 1 (write-gvm-lbl
                                  (ifjump-true gvm-instr)
                                  port)))))
               (display " else " port)
               (+ len (+ 6 (write-gvm-lbl
                             (ifjump-false gvm-instr)
                             port))))))))

      ((switch)
       (display "  " port)
       (let ((len (+ 2
                     (if (switch-poll? gvm-instr)
                       (begin (display "switch* " port) 8)
                       (begin (display "switch " port) 7)))))
         (let ((len (+ len
                       (write-returning-len
                        (frame-size (gvm-instr-frame gvm-instr))
                        port))))
           (display " " port)
           (let ((len (+ len
                         (+ 1 (write-gvm-opnd (switch-opnd gvm-instr) port)))))
             (display " (" port)
             (let ((len
                    (let loop ((cases (switch-cases gvm-instr))
                               (len (+ len 2)))
                      (if (pair? cases)
                        (let ((c (car cases)))
                          (let ((len (+ len
                                        (write-gvm-obj (switch-case-obj c)
                                                       port))))
                            (display " => " port)
                            (let ((len (+ len
                                          (+ 4 (write-gvm-lbl (switch-case-lbl c)
                                                              port)))))
                              (let ((next (cdr cases)))
                                (if (null? next)
                                  len
                                  (begin
                                    (display ", " port)
                                    (loop next (+ len 2))))))))
                        len))))
               (display ") " port)
               (+ len
                  (+ 2 (write-gvm-lbl
                        (switch-default gvm-instr)
                        port))))))))

      ((jump)
       (display "  " port)
       (let ((len (+ 2
                     (if (jump-poll? gvm-instr)
                       (begin (display "jump*" port) 5)
                       (begin (display "jump" port) 4)))))
         (let ((len (+ len
                       (if (jump-safe? gvm-instr)
                         (begin (display "$ " port) 2)
                         (begin (display " " port) 1)))))
           (let ((len (+ len
                         (write-returning-len
                           (frame-size (gvm-instr-frame gvm-instr))
                           port))))
             (display " " port)
             (let ((len (+ len
                           (+ 1 (write-gvm-opnd (jump-opnd gvm-instr) port)))))
               (+ len
                  (if (jump-nb-args gvm-instr)
                    (begin
                      (display " " port)
                      (+ 1 (write-returning-len
                             (jump-nb-args gvm-instr)
                             port)))
                    0)))))))

      (else
       (compiler-internal-error
         "write-gvm-instr, unknown 'gvm-instr':"
         gvm-instr))))

  (define (spaces n)
    (if (> n 0)
      (if (> n 7)
        (begin (display "        " port) (spaces (- n 8)))
        (begin (display " " port) (spaces (- n 1))))))

  (let ((len (write-instr gvm-instr)))
    (spaces (- 43 len))
    (display " " port)
    (write-frame (gvm-instr-frame gvm-instr) port))

  (let ((x (gvm-instr-comment gvm-instr)))
    (if x
      (let ((y (comment-get x 'text)))
        (if y
          (begin
            (display " ; " port)
            (display y port)))))))

(define (write-frame frame port)

  (define (write-var var opnd sep)
    (display sep port)
    (write-gvm-opnd opnd port)
    (if var
      (begin
        (display "=" port)
        (cond ((eq? var closure-env-var)
               (write (map (lambda (var) (var-name var)) (frame-closed frame))
                      port))
              ((eq? var ret-var)
               (display "#" port))
              ((temp-var? var)
               (display "." port))
              (else
               (write (var-name var) port))))))

  (define (live? var)
    (let ((live (frame-live frame)))
      (or (varset-member? var live)
          (and (eq? var closure-env-var)
               (varset-intersects?
                 live
                 (list->varset (frame-closed frame)))))))

  (let loop1 ((i 1) (l (reverse (frame-slots frame))) (sep "; "))
    (if (pair? l)
      (let ((var (car l)))
        (write-var (if (live? var) var #f) (make-stk i) sep)
        (loop1 (+ i 1) (cdr l) " "))
      (let loop2 ((i 0) (l (frame-regs frame)) (sep sep))
        (if (pair? l)
          (let ((var (car l)))
            (if (live? var)
              (begin
                (write-var var (make-reg i) sep)
                (loop2 (+ i 1) (cdr l) " "))
              (loop2 (+ i 1) (cdr l) sep))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Operand writing:
;; ---------------

(define (write-gvm-opnd gvm-opnd port)
  (cond ((not gvm-opnd)
         (display "." port)
         1)
        ((reg? gvm-opnd)
         (display "+" port)
         (+ 1 (write-returning-len (reg-num gvm-opnd) port)))
        ((stk? gvm-opnd)
         (display "-" port)
         (+ 1 (write-returning-len (stk-num gvm-opnd) port)))
        ((glo? gvm-opnd)
         (write-returning-len (glo-name gvm-opnd) port))
        ((clo? gvm-opnd)
         (let ((len (write-gvm-opnd (clo-base gvm-opnd) port)))
           (display "(" port)
           (let ((len (+ len
                         (+ 1 (write-returning-len
                                (clo-index gvm-opnd)
                                port)))))
             (display ")" port)
             (+ len 1))))
        ((lbl? gvm-opnd)
         (write-gvm-lbl (lbl-num gvm-opnd) port))
        ((obj? gvm-opnd)
         (display "'" port)
         (+ (write-gvm-obj (obj-val gvm-opnd) port) 1))
        (else
         (compiler-internal-error
           "write-gvm-opnd, unknown 'gvm-opnd':"
           gvm-opnd))))

(define (write-gvm-lbl lbl port)
  (display "#" port)
  (+ (write-returning-len lbl port) 1))

(define (write-gvm-obj val port)
  (cond ((proc-obj? val)
         (if (proc-obj-primitive? val)
           (display "#<primitive " port)
           (display "#<procedure " port))
         (let ((len
                (write-returning-len
                  (string->canonical-symbol (proc-obj-name val))
                  port)))
           (display ">" port)
           (+ len 13)))
        (else
         (write-returning-len val port))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (virtual.begin!) ; initialize module
  (set! *opnd-table* '#())
  (set! *opnd-table-alloc* 0)
  '())

(define (virtual.end!) ; finalize module
  (set! *opnd-table* '())
  '())

;;;============================================================================
