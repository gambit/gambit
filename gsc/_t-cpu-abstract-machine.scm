;;==============================================================================

;;; File: "_t-cpu-abstract-machine.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------
;;-----------------------  Abstract Machine definition  ------------------------
;;------------------------------------------------------------------------------
;;
;;  We define an abstract instruction set which we program against for most of
;;  the backend. Most of the code is moving data between registers and the stack
;;  and jumping to locations, so it reduces the repetion between native backends
;;  (x86, x64, ARM, Risc V, etc.).
;;
;;  Notes:
;;    1 - Some instructions have a default implementation when possible.
;;
;;    2 - Unless specified, the args of the instructions is:
;;        CGC, Destination register, Operand 1, Operand 2
;;        If the architecture is load store,
;;          Destination register: Register
;;          Operands: Register, Immediate
;;        Else
;;          Destination register: Register, Memory, Label
;;          Operands: Register, Immediate, Memory
;;
;;        The am-mov instruction acts like both load and store.
;;
;;  The following non-branching instructions are required:
;;    am-lbl  : Place label.
;;       Args : CGC, Label, Alignment (Multiple . Offset)
;;    am-mov  : Move value between operands.
;;       Args : CGC, reg/mem/label, reg/mem/imm/label
;;    am-load-mem-address : Load address of memory location.
;;       Args : CGC, reg, mem
;;    am-push : Place operand on top of stack
;;       Args : CGC, reg/mem/imm/label
;;    am-pop  : Take operand on top of stack
;;       Args : CGC, reg/mem/imm/label
;;
;;    am-add  : Operand 1 = Operand 2 + Operand 3
;;    am-sub  : Operand 1 = Operand 2 - Operand 3
;;
;;    am-bit-shift-right : Shifts register to the right by some constant
;;    am-bit-shift-left  : Shifts register to the left by some constant
;;                  Args : CGC, Destination register, Shifted register, constant
;;
;;    am-not  : Logical not
;;    am-and  : Logical and
;;    am-or   : Logical or
;;    am-xor  : Logical xor
;;
;;  The following branching instructions are required:
;;    am-jmp          : Jump to location
;;               Args : CGC, jmp-opnd
;;    am-compare-jump : Jump to location only if condition is set after comparison
;;               Args : CGC, location-true(jmp-opnd), location-false(jmp-opnd), operand1, operand2 condition (optional) opnds-width
;;      Where jmp-opnd = reg/mem/label
;;            data Condition = Equal
;;                           | NotEqual
;;                           | Greater eq(bool) signed(bool)
;;                           | NotGreater eq(bool) signed(bool)
;;
;;  The following non-instructions function have to be defined
;;    am-data  : Place at current location the value with given width.
;;               Width is 8, 16, 32 or 64 bits
;;               Args : cgc width value
;;
;;    int-opnd : Create int immediate object   (See int-opnd)
;;    lbl-opnd : Create label immediate object (See x86-imm-lbl)
;;    mem-opnd : Create memory location object (See x86-mem)
;;
;;  The operand objects have to follow the x86 operands objects formats.
;;
;;  To add new backend, see x64 backend as example.

;; Backend object: Has all the information to encode the GVM instructions.
(define (make-backend make-cgc-fun info operands instructions routines)
  (vector
    make-cgc-fun
    info
    operands
    instructions
    routines))

(define info-index 1)
(define operands-index 2)
(define instructions-index 3)
(define routines-index 4)

;;  Fields:
;;    word-width : Machine word length in bytes
;;    endianness : 'le or 'be
;;    load-store : See note 3
;;    self-register: r4 gvm register
;;    frame-pointer-reg: Register pointing to current frame
;;    frame-offset: Offset to frame
;;
;;    primitive-table : Table between symbol and primitive object
;;      For symbols: see _prims.scm
;;      data Primitive = (function: cgc -> operands -> ())
;;                       (arity: int)
;;                       (inlinable: bool)
;;                       (testable: bool)
;;
;;    main-registers  : (Vector) Registers that map directly to GVM registers
;;    extra-registers : (Vector) Extra registers that can be overwritten at any time.
;;      Note: #extra-registers must >= 3.
(define (make-cpu-info
          word-width endianness load-store frame-offset
          primitive-table
          gvm-reg-count gvm-arg-reg-count registers
          pstate-pointer frame-pointer heap-pointer)
  (vector
    word-width endianness load-store frame-offset
    primitive-table
    gvm-reg-count gvm-arg-reg-count registers
    pstate-pointer frame-pointer heap-pointer))

;; Vector of functions on operands
(define (make-operand-dictionnary
          reg-opnd?
          int-opnd int-opnd? int-opnd-value
          lbl-opnd lbl-opnd? lbl-opnd-offset lbl-opnd-label
          mem-opnd mem-opnd? mem-opnd-offset mem-opnd-reg)
  (vector
    reg-opnd?
    int-opnd int-opnd? int-opnd-value
    lbl-opnd lbl-opnd? lbl-opnd-offset lbl-opnd-label
    mem-opnd mem-opnd? mem-opnd-offset mem-opnd-reg))

(define (make-instruction-dictionnary
          am-lbl am-data
          am-mov am-load-mem-address
          am-push am-pop
          am-add am-sub
          am-bit-shift-right am-bit-shift-left
          am-not am-and
          am-or  am-xor
          am-jmp am-compare-jump
          am-compare-move)
  (vector
    am-lbl am-data
    am-mov am-load-mem-address
    am-push am-pop
    am-add am-sub
    am-bit-shift-right am-bit-shift-left
    am-not am-and
    am-or am-xor
    am-jmp am-compare-jump
    am-compare-move))

(define (make-routine-dictionnary
          poll
          set-narg
          check-narg
          check-narg-simple
          allocate-memory
          place-extra-data)
  (vector poll set-narg check-narg check-narg-simple allocate-memory place-extra-data))

(define (get-in-target target i1 i2)
  (let* ((info (target-extra target 0))
         (field (vector-ref (vector-ref info i1) i2)))
    field))

(define (get-in-cgc cgc i1 i2)
  (let* ((target (codegen-context-target cgc))
         (info (target-extra target 0))
         (field (vector-ref (vector-ref info i1) i2)))
    field))

(define (exec-in-cgc cgc i1 i2 args)
  (apply (get-in-cgc cgc i1 i2) args))

;; ***** AM: Info fields

;; NOTICE THAT IT TAKES A TARGET INSTEAD OF CGC
(define (get-make-cgc-fun target)
  (let* ((info (target-extra target 0))
         (field (vector-ref info 0)))
    field))

(define (get-word-width cgc)        (get-in-cgc cgc info-index 0))
(define (get-word-width-bits cgc)   (* 8 (get-word-width cgc)))
(define (get-endianness cgc)        (get-in-cgc cgc info-index 1))
(define (is-load-store? cgc)        (get-in-cgc cgc info-index 2))
(define (get-frame-offset cgc)      (get-in-cgc cgc info-index 3))
(define (get-primitive-table cgc)   (get-in-cgc cgc info-index 4))
(define (get-gvm-reg-count cgc)     (get-in-cgc cgc info-index 5))
(define (get-gvm-arg-reg-count cgc) (get-in-cgc cgc info-index 6))
(define (get-registers  cgc)        (get-in-cgc cgc info-index 7))
(define (get-pstate-pointer cgc)    (get-in-cgc cgc info-index 8))
(define (get-frame-pointer cgc)     (get-in-cgc cgc info-index 9))
(define (get-heap-pointer cgc)      (get-in-cgc cgc info-index 10))

(define (get-primitive-table-target targ) (get-in-target targ info-index 4))

(define (get-primitive-object cgc name)
  (let* ((table (get-primitive-table cgc)))
    (table-ref table (string->symbol name) #f)))

;; ***** AM: Operands fields

(define (apply-opnd cgc index args)
  (exec-in-cgc cgc operands-index index args))

(define (reg-opnd? cgc . args)       (apply-opnd cgc 0  args))
(define (int-opnd  cgc . args)       (apply-opnd cgc 1  args))
(define (int-opnd? cgc . args)       (apply-opnd cgc 2  args))
(define (int-opnd-value  cgc . args) (apply-opnd cgc 3  args))
(define (lbl-opnd  cgc . args)       (apply-opnd cgc 4  args))
(define (lbl-opnd? cgc . args)       (apply-opnd cgc 5  args))
(define (lbl-opnd-offset cgc . args) (apply-opnd cgc 6  args))
(define (lbl-opnd-label  cgc . args) (apply-opnd cgc 7  args))
(define (mem-opnd  cgc . args)       (apply-opnd cgc 8  args))
(define (mem-opnd? cgc . args)       (apply-opnd cgc 9  args))
(define (mem-opnd-offset cgc . args) (apply-opnd cgc 10 args))
(define (mem-opnd-reg    cgc . args) (apply-opnd cgc 11 args))

;; ***** AM: Instructions fields

(define (apply-instruction cgc index args)
  (exec-in-cgc cgc instructions-index index (cons cgc args)))

(define (am-lbl cgc . args)              (apply-instruction cgc 0  args))
(define (am-data cgc . args)             (apply-instruction cgc 1  args))
(define (am-mov cgc . args)              (apply-instruction cgc 2  args))
(define (am-load-mem-address cgc . args) (apply-instruction cgc 3  args))
(define (am-push cgc . args)             (apply-instruction cgc 4  args))
(define (am-pop  cgc . args)             (apply-instruction cgc 5  args))
(define (am-add cgc . args)              (apply-instruction cgc 6  args))
(define (am-sub cgc . args)              (apply-instruction cgc 7  args))
(define (am-bit-shift-right cgc . args)  (apply-instruction cgc 8  args))
(define (am-bit-shift-left cgc . args)   (apply-instruction cgc 9  args))
(define (am-not cgc . args)              (apply-instruction cgc 10 args))
(define (am-and cgc . args)              (apply-instruction cgc 11 args))
(define (am-or cgc . args)               (apply-instruction cgc 12 args))
(define (am-xor cgc . args)              (apply-instruction cgc 13 args))
(define (am-jmp cgc . args)              (apply-instruction cgc 14 args))
(define (am-compare-jump cgc . args)     (apply-instruction cgc 15 args))
(define (am-compare-move cgc . args)     (apply-instruction cgc 16 args))

(define (am-data-word cgc word)
  (am-data cgc (get-word-width-bits cgc) word))

;; ***** AM: Routines fields

(define (apply-routine cgc index args)
  (exec-in-cgc cgc routines-index index (cons cgc args)))

(define (am-poll cgc . args)               (apply-routine cgc 0 args))
(define (am-set-narg cgc . args)           (apply-routine cgc 1 args))
(define (am-check-nargs cgc . args)        (apply-routine cgc 2 args))
(define (am-check-nargs-simple cgc . args) (apply-routine cgc 3 args))
(define (am-allocate-memory cgc . args)    (apply-routine cgc 4 args))
(define (am-place-extra-data cgc . args)   (apply-routine cgc 5 args))

;;------------------------------------------------------------------------------
;;-----------------------------  Label functions  ------------------------------
;;------------------------------------------------------------------------------

(define (table-get-or-set table key def-val)
  (let ((x (table-ref table key #f)))
    (if x
      x
      (begin
        (table-set! table key def-val)
        def-val))))

;; If identifier is a number, will return the bb at index of the proc passed as argument
(define (get-proc-label cgc proc identifier)
  (define (make-label-id proc-name)
    (cond
      ((number? identifier)
        (string->symbol (string-append
          "_proc_"
          proc-name
          "_"
          (number->string identifier))))
      (else
        identifier)))

  (let* ((proc-name (proc-obj-name proc))
         (label-id (make-label-id proc-name))
         (label (asm-make-label cgc label-id))
         (primitive-table (codegen-context-primitive-labels-table cgc))
         (procs-labels-table (codegen-context-proc-labels-table cgc))
         (proc-labels-table ;; Table of (label, label-id, index)
            (table-get-or-set
              procs-labels-table
              proc-name
              (make-table 'test: equal?))))

    ;; Add label to primitive table only if entry point
    (if (eq? 1 identifier)
      (car (table-get-or-set primitive-table label-id (cons label proc))))

    (car (table-get-or-set proc-labels-table label-id (cons label -1)))))

(define (set-proc-label-index cgc proc label index)
  (let* ((proc-name (proc-obj-name proc))
         (lbl-id (asm-label-name label))
         (procs-labels-table (codegen-context-proc-labels-table cgc))
         (proc-labels-table ;; Table of (label, label-id, index)
           (table-get-or-set
             procs-labels-table
             proc-name
             (make-table 'test: equal?))))
    (let ((ref (table-get-or-set proc-labels-table lbl-id (cons label index))))
      (set-cdr! ref index))))

(define (get-label cgc sym)
  (let* ((table (codegen-context-other-labels-table cgc))
         (def-lbl (asm-make-label cgc sym)))
    (table-get-or-set table sym def-lbl)))

;; Useful for branching
(define (make-unique-label cgc prefix #!optional (add-suffix #t))
  (define (lbl->id num)
    (string->symbol (string-append
      (if prefix prefix "other")
      (if add-suffix (number->string num) ""))))

  (let* ((id (get-unique-id))
         (label-id (lbl->id id))
         (lbl (asm-make-label cgc label-id)))
    lbl))

;; Return unique id
(define unique-id 0)
(define (get-unique-id)
  (set! unique-id (+ unique-id 1))
  unique-id)

;;------------------------------------------------------------------------------
;;------------------------- Abstract machine operands --------------------------
;;------------------------------------------------------------------------------

(define (make-obj-opnd cgc val)
  (cond
    ((immediate-object? val)
      (debug "make-obj-opnd: obj imm: " val)
      (int-opnd cgc
        (format-imm-object val)
        (get-word-width-bits cgc)))
    ((reference-object? val)
      (debug "make-obj-opnd: obj ref: " val)
      (x86-imm-obj val))
    (else
      (compiler-internal-error "make-obj-opnd: Unknown object: " val))))
  ; (x86-imm-obj val))

(define (make-opnd cgc opnd)
  (define proc (codegen-context-current-proc cgc))
  (define code (codegen-context-current-code cgc))

  (define (make-obj val)
    (cond
      ((proc-obj? val)
        (lbl-opnd cgc (get-parent-proc-label cgc (obj-val opnd))))
      ((immediate-object? val)
        (debug "make-opnd: obj imm: " val)
        (int-opnd cgc
          (format-imm-object val)
          (get-word-width-bits cgc)))
      ((reference-object? val)
        (debug "make-opnd: obj ref: " val)
        (x86-imm-obj val))
      (else
        (compiler-internal-error "make-opnd: Unknown object: " val))))
      ; (else
      ;   (x86-imm-obj val))))
  (cond
    ((reg? opnd)
      (debug "make-opnd: reg")
      (get-register cgc (reg-num opnd)))
    ((stk? opnd)
      (debug "make-opnd: stk")
      (frame cgc (proc-lbl-frame-size code) (stk-num opnd)))
    ((lbl? opnd)
      (debug "make-opnd: lbl")
      (lbl-opnd cgc (get-proc-label cgc proc (lbl-num opnd))))
    ((obj? opnd)
      (make-obj (obj-val opnd)))
    ((clo? opnd)
      (debug "make-opnd: clo")
      ;; Todo: Refactor with _t-cpu.scm::encode-close-instr
      (let ((r4 (get-self-register cgc))
            (offset (- (* (get-word-width cgc) (clo-index opnd)) 1)))
        (mem-opnd cgc offset r4)))
    ((glo? opnd)
      (debug "make-opnd: glo")
      (x86-imm-glo (glo-name opnd)))
    (else
      (compiler-internal-error "make-opnd: Unknown opnd: " opnd))))

(define (opnd-type cgc opnd)
  (cond
    ((int-opnd? cgc opnd) 'int)
    ((reg-opnd? cgc opnd) 'reg)
    ((mem-opnd? cgc opnd) 'mem)
    ((lbl-opnd? cgc opnd) 'lbl)
    ((x86-imm-obj? opnd)  'lbl) ;; Todo: Do something generic
    ((x86-imm-glo? opnd)  'ind) ;; Todo: Do something generic
    (else
      (compiler-internal-error "opnd-type - Unknown opnd: " opnd))))

(define (frame cgc fs n)
  (mem-opnd cgc
    (*
      (+ fs (- n) (get-frame-offset cgc))
      (get-word-width cgc))
    (get-frame-pointer cgc)))

(define (alloc-frame cgc n)
  (if (not (= 0 n))
    (am-sub cgc
      (get-frame-pointer cgc)
      (get-frame-pointer cgc)
      (int-opnd cgc (* n (get-word-width cgc))))))

(define (get-opnd-with-offset cgc opnd offset)
  (case (opnd-type cgc opnd)
    ('reg
      (mem-opnd cgc offset opnd))
    ('mem
      (mem-opnd cgc (+ (mem-opnd-offset cgc opnd) offset) (mem-opnd-reg cgc opnd)))
    ('lbl
      (lbl-opnd cgc (lbl-opnd-label cgc opnd) (+ (lbl-opnd-offset cgc opnd) offset)))
    ('int
      (mem-opnd cgc (+ (int-opnd-value cgc opnd) offset)))
    ('glo
      (compiler-internal-error "get-opnd-with-offset - global doesn't support offset (todo)"))
    (else
      (compiler-internal-error "get-opnd-with-offset - unknown opnd: " opnd))))

;;------------------------------------------------------------------------------
;;--------------------------------- Conditions ---------------------------------
;;------------------------------------------------------------------------------

(define condition-equal (list 'equal))
(define condition-not-equal (list 'not-equal))

(define (condition-greater and-equal? signed) (list 'greater and-equal? signed))
(define (condition-lesser and-equal? signed) (list 'lesser and-equal? signed))

(define (get-condition cond) (car cond))

(define (cond-is-equal cond)
  (case (car cond)
    ((equal) #t)
    ((not-equal) #f)
    ((greater) (cadr cond))
    ((lesser) (cadr cond))))

(define (cond-is-signed cond)
  (case (car cond)
    ((equal) #t)
    ((not-equal) #t)
    ((greater) (caddr cond))
    ((lesser) (caddr cond))))

(define (inverse-condition cond)
  (case (car cond)
    ((equal)
      condition-not-equal)
    ((not-equal)
      condition-equal)
    ((greater)
      (condition-lesser (not (cond-is-equal cond)) (cond-is-signed cond)))
    ((lesser)
      (condition-greater (not (cond-is-equal cond)) (cond-is-signed cond)))))

;;------------------------------------------------------------------------------
;;----------------------------- Register Selection -----------------------------
;;------------------------------------------------------------------------------

(define (get-register cgc n)
  (vector-ref (get-registers cgc) n))

(define (get-self-register cgc)
  (get-register cgc (- (get-gvm-reg-count cgc) 1)))

(define (get-register-index cgc reg)
  (let ((registers (get-registers cgc)))
    (let loop ((i 0))
      (if (< i (vector-length registers))
        (if (equal? reg (vector-ref registers i))
          i
          (loop (+ i 1)))
      -1))))

(define (get-free-register cgc needed-opnds action)
  (get-multiple-free-registers cgc 1 needed-opnds action))

; (define (mov-in-reg cgc opnd fun)
;   (get-free-register cgc
;     (lambda (reg)
;       (am-mov cgc reg opnd)
;       (fun reg)
;       (filled-register opnd))))

;; data Value = Dead | Filled Opnd Time | Live | LiveSaved Opnd
;; data Opnd  = Register Int | Stack Int | Closure Int | Global Symbol

(define dead-register 'dead)
(define (dead-register? sym) (equal? 'dead sym))

(define live-register 'live)
(define (live-register? sym) (equal? 'live sym))

(define (filled-register opnd #!optional (time -1)) (list 'filled opnd time))
(define (filled-register? pair) (and (pair? pair) (equal? 'filled (car pair))))
(define (filled-register-opnd pair) (cadr pair))
(define (filled-register-time pair) (caddr pair))

(define (live-saved-register opnd) (cons 'live-saved opnd))
(define (live-saved-register? pair) (and (pair? pair) (equal? 'live-saved (car pair))))
(define (live-saved-register-opnd pair) (cdr pair))

(define (reset-registers-status cgc)
  (let* ((registers (get-registers cgc))
         (size (vector-length registers))
         (alloc-vector (make-vector size dead-register)))
    ;; All registers are now available
    (codegen-context-registers-status-set! cgc alloc-vector)))

;; Return time id
(define selection-id 0)
(define (get-time-id)
  (set! selection-id (+ selection-id 1))
  selection-id)

(define (update-registers-status-from-frame cgc frame old-frame)
  (define registers-status (codegen-context-registers-status cgc))

  (define live-vars (frame-live frame))
  (define (live? var)
    (and var
      (or (varset-member? var live-vars)
          (and (eq? var closure-env-var)
               (varset-intersects?
                  live-vars
                  (list->varset (frame-closed frame)))))))

  (let loop ((reg-index 0)
             (regs (frame-regs frame))
             (regs-old (if old-frame (frame-regs old-frame) '())))

    (if (or (pair? regs) (pair? regs-old))
      (begin
        (cond
          ;; The status doesn't change
          ((eq? (live? (safe-car regs)) (live? (safe-car regs-old))) #f)
          ;; old reg is not in old-frame.
          ;; The register is now live.
          ((and (live? (safe-car regs)) (not (live? (safe-car regs-old))))
            (vector-set! registers-status reg-index live-register))
          ;; reg is not in frame.
          ;; We update the status of the register so it's empty/free
          ((and (not (live? (safe-car regs))) (live? (safe-car regs-old)))
            (vector-set! registers-status reg-index dead-register)))

        (loop (+ 1 reg-index) (safe-cdr regs) (safe-cdr regs-old))))))

(define (get-multiple-free-registers cgc count needed-opnds use)
  (define registers '())
  (define (accumulate-extra-register count)
    (choose-register cgc
      (lambda (reg)
        (if (>= count 1)
          (begin
            (set! registers (cons reg registers))
            (accumulate-extra-register (- count 1)))
          (begin
            (apply use registers))))
      (get-registers cgc)
      needed-opnds))

  (accumulate-extra-register count))

(define (choose-register cgc use registers reserved-opnds)
  (define registers-status (codegen-context-registers-status cgc))
  (define registers-status-list (vector->list registers-status))
  (define registers-list (vector->list registers))

  (define (use-register info)
    (let* ((reg (car info))
           (status (cadr info))
           (index (caddr info))
           (save? (live-register? reg))
           (save-loc (find-save-loc)))
      (if save?
        (am-mov cgc save-loc reg))

      (vector-set! registers-status index
        (if save? (live-saved-register save-loc) live-register))
      (let ((new-status (use reg)))
        (if (and
              (not save?)
              (or
                (dead-register? new-status)
                (live-register? new-status)
                (live-saved-register? new-status)
                (filled-register? new-status)))
          (vector-set! registers-status index new-status)))

      (if save?
        (am-mov cgc reg save-loc))))

  (define (find-save-loc)
    (let* ((current-frame (codegen-context-frame cgc))
           (frame-size (frame-size current-frame)))
      (let loop ((i 2))
        (if (not (elem? (frame cgc frame-size (+ frame-size 1)) reserved-opnds))
          (frame cgc frame-size (+ frame-size 2))
          (loop (+ i 1))))))

  (define (sort-fun info1 info2)
    (define (status-priority status)
      (cond
        ((dead-register? status) -1000)
        ((filled-register? status) (filled-register-time status))
        (else (compiler-internal-error "Invalid priority"))))

    (let* ((reg1 (car info1))
           (reg2 (car info2))
           (status1 (cadr info1))
           (status2 (cadr info2))
           (index1 (caddr info1))
           (index2 (caddr info2)))
      (if (= (status-priority status1) (status-priority status2))
        (> index1 index2) ;; Extra registers before GVM registers
        (< (status-priority status1) (status-priority status2)))))

  (define (filter-available-reg info)
    (and
      (not (elem? (car info) reserved-opnds))
      (not (live-register? (cadr info)))
      (not (live-saved-register? (cadr info)))))

  (define (filter-live-reg info)
    (and (not (elem? (car info) reserved-opnds)) (live-register? (cadr info))))

  (debug "Choose-register")
  (let* ((lst
          (map list
            registers-list
            registers-status-list
            (iota 0 (length registers-list))))
         (live-registers (filter filter-live-reg lst))
         (filtered (filter filter-available-reg lst))
         (sorted (sort-list filtered sort-fun)))
    (if (not (null? sorted))
      (use-register (car sorted))
      (if (not (null? live-registers))
        (use-register (car live-registers))
        (compiler-internal-error "No free or saveable live registers to use")))))

;;------------------------------------------------------------------------------
;;----------------------------------- Utils ------------------------------------
;;------------------------------------------------------------------------------

;;  Utils: Jumps and calls with return

;; Must set arguments before calling this function
(define (jump-with-return-point cgc location return-lbl frame internal?)
  (debug "jump-with-return-point")
  (let* ((proc (codegen-context-current-proc cgc))
         (struct-position (codegen-context-label-struct-position cgc)))

    (debug "jump: " location)
    (am-jmp cgc location)

    ;; Return point
    (set-proc-label-index cgc proc return-lbl struct-position)
    (put-return-point-label
      cgc return-lbl
      (frame-size frame)
      (get-frame-ret-pos frame)
      (get-frame-gcmap frame)
      internal?)))

;;  Utils: Function call arguments

;; Count starts at 1
;; Todo: Optimize. This is not very efficient...
(define (get-nth-arg cgc start-fs total nth)
  (define (get-frames count)
    (map (lambda (i) (frame cgc start-fs i)) (iota 1 count)))

  (define (get-registers count)
    (map (lambda (i) (get-register cgc i)) (iota 1 count)))

  (let* ((target (codegen-context-target cgc))
         (narg-in-regs (target-nb-arg-regs target))
         (narg-in-frames (- total narg-in-regs))
         (frames (get-frames narg-in-frames))
         (regs (get-registers narg-in-regs))
         (arg-opnds (append frames regs)))
    (debug "get-nth-arg: " arg-opnds)
    (list-ref arg-opnds (- nth 1))))

(define (get-args-opnds cgc start-fs total)
  (map
    (lambda (n) (get-nth-arg cgc start-fs total n))
    (iota 1 total)))

;; ***** Utils - Abstract machine definition helper

;; Get appropriate am-db, am-dw, am-dd, am-dq
(define (make-am-data am-db am-dw am-dd am-dq)
  (lambda (cgc width data)
    (let ((fun
            (case width
              ((8)  am-db)
              ((16) am-dw)
              ((32) am-dd)
              ((64) am-dq)
              (else (compiler-internal-error "am-data - Unknown width: " width)))))
      (if (list? data)
        (for-each (lambda (datum) (fun cgc datum)) data)
        (fun cgc data)))))

;;------------------------------------------------------------------------------
;;----------------------------- GVM proc encoding ------------------------------
;;------------------------------------------------------------------------------

(define (encode-procs cgc procs)
  (define procs2 (reachable-procs procs))

  (define (get-main-label)
    (let* ((main-proc (car procs2))
           (bb1 (car (get-code-list main-proc)))
           (instr (code-gvm-instr bb1)))
      (get-proc-label cgc main-proc (label-lbl-num instr))))

  (define (encode-proc proc)
    (debug "Encoding proc")
    (codegen-context-current-proc-set! cgc proc)
    (codegen-context-label-struct-position-set! cgc 1)
    (map
      (lambda (code)
        (let* ((gvm-instr (code-gvm-instr code))
               (current-frame (gvm-instr-frame gvm-instr))
               (old-frame (codegen-context-frame cgc)))

          (codegen-context-current-code-set! cgc code)
          (codegen-context-frame-set! cgc current-frame)

          (if (equal? 'label (gvm-instr-type gvm-instr))
            (begin
              (reset-registers-status cgc)
              (update-registers-status-from-frame cgc current-frame #f))
            (begin
              (update-registers-status-from-frame cgc current-frame old-frame)))

          (encode-gvm-instr cgc code)))
      (get-code-list proc)))

  (debug "Encode procs")
  (map encode-proc procs2)

  (am-place-extra-data cgc)

  (debug "Adding primitives")
  (table-for-each
    (lambda (key val) (put-primitive-if-needed cgc key val))
    (codegen-context-primitive-labels-table cgc))

  (debug "Finished!")

  ;; specify value returned by create-procedure (i.e. procedure reference)
  (let ((main-lbl (get-main-label)))
    (codegen-fixup-lbl! cgc main-lbl 0 #f 64)))

;; Value is Pair (Label, optional Proc-obj)
(define (put-primitive-if-needed cgc key pair)
  (let* ((label (car pair))
         (proc (cdr pair))
         (proc-name (proc-obj-name proc))
         (prim-obj (get-primitive-object cgc (proc-obj-name proc)))
         (defined? (or (vector-ref label 1) (not proc)))) ;; See asm-label-pos (Same but without error if undefined)

    (if (not defined?)
      (begin
        (debug "Putting primitive: " (proc-obj-name proc))
        (if prim-obj
          ;; Prim is defined in native backend
          (let* ((prim-fun (get-primitive-function prim-obj))
                 (arity (get-primitive-arity prim-obj))
                 (args (get-args-opnds cgc (get-fun-fs cgc arity) arity)))
            (put-entry-point-label cgc label proc-name #f 0 #f) ;; Place label in prim-fun
            (prim-fun cgc (then-return label proc-name) args))

          ;; Prim is defined in C
          ;; We simply passthrough to C. Has some overhead, but calling C has lots of overhead anyway
          (get-free-register cgc '()
            (lambda (reg)
              (put-entry-point-label cgc label proc-name #f 0 #f)
              (am-mov cgc reg (x86-imm-obj (string->symbol proc-name)))
              (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
              (am-mov cgc reg (mem-opnd cgc 0 reg))
              (am-jmp cgc reg))))))))

;;  GVM Instruction Encoding

(define (encode-gvm-instr cgc code)
  (debug (gvm-instr-type (code-gvm-instr code)))
  (case (gvm-instr-type (code-gvm-instr code))
    ((label)  (encode-label-instr   cgc code))
    ((jump)   (encode-jump-instr    cgc code))
    ((ifjump) (encode-ifjump-instr  cgc code))
    ((apply)  (encode-apply-instr   cgc code))
    ((copy)   (encode-copy-instr    cgc code))
    ((close)  (encode-close-instr   cgc code))
    ((switch) (encode-switch-instr  cgc code))
    (else
      (compiler-error
        "encode-gvm-instr, unknown 'gvm-instr-type':" (gvm-instr-type (code-gvm-instr code))))))

;;  Label Instruction Encoding

(define (table-find-label table index)
  (let loop ((lst (table->list table)))
    (if (null? lst)
      #f
      (let* ((val (cdr (car lst)))
             (label (car val))
             (val-index (cdr val)))
        (if (eq? val-index index)
          label
          (loop (cdr lst)))))))

(define (get-next-label cgc proc-name lbl-pos label)
  (lambda ()
    (let* ((procs-labels-table (codegen-context-proc-labels-table cgc))
           (proc-labels-table (table-ref procs-labels-table proc-name #f)))

      (if proc-labels-table
        (table-find-label proc-labels-table lbl-pos)
        (compiler-internal-error "Procedure " proc-name " doesn't have associated label table")))))

(define (get-fun-fs cgc arg-count)
  (let* ((target (codegen-context-target cgc))
         (nargs-in-regs (target-nb-arg-regs target)))
    (max 0 (- arg-count nargs-in-regs))))

;; Todo: Fix proc-name-sym invalid when placing primitives
(define (put-entry-point-label cgc label proc-name proc-info nargs closure?)
  (define label-struct-position (codegen-context-label-struct-position cgc))
  (define proc (codegen-context-current-proc cgc))
  (define parent-label (get-parent-proc-label cgc proc))

  (asm-align cgc 8)
  (codegen-fixup-obj! cgc (string->symbol proc-name) 64) ;; ##subprocedure-parent-name
  (codegen-fixup-obj! cgc proc-info 64)                  ;; ##subprocedure-parent-info
  (codegen-fixup-obj! cgc 2 64)                          ;; nb labels

  ;; next label struct
  (codegen-fixup-lbl-late! cgc
    (get-next-label cgc proc-name (+ 1 label-struct-position) label)
    #f 64
    'next-label-with-structure
    )
  ;; parent label struct
  (if parent-label
    (codegen-fixup-lbl! cgc parent-label 0 #f 64 'parent-label)
    (am-data-word cgc 0))

  (codegen-fixup-handler! cgc '___lowlevel_exec (get-word-width-bits cgc))
  (am-data-word cgc (+ 6                               ;; PERM
                      (* 8 14)                         ;; PROCEDURE
                      (* 256 (+ nargs                  ;; Number of arguments
                        (* 4096 (if closure? 1 0)))))) ;; Is closure?

  (codegen-fixup-lbl! cgc label 0 #f 64 'self-label) ;; self ptr
  (am-data cgc 8 0) ;; so that label reference has tag ___tSUBTYPED
  (am-lbl cgc label)

  (codegen-context-label-struct-position-set! cgc
    (+ 1 label-struct-position)))

;; Todo: Make sure ret-pos is valid when using this function
(define (put-return-point-label cgc label frame-size ret-pos gcmap #!optional (internal? #f))
  (define label-struct-position (codegen-context-label-struct-position cgc))
  (define proc (codegen-context-current-proc cgc))
  (define proc-name (proc-obj-name proc))
  (define proc-name-sym (string->symbol proc-name))
  (define proc-info #f)
  (define parent-label (get-parent-proc-label cgc proc))

  (asm-align cgc 8)
  ;; next label struct
  (codegen-fixup-lbl-late! cgc
    (get-next-label cgc proc-name (+ 1 label-struct-position) label)
    #f 64
    'next-label-with-structure)
  ;; parent label struct
  (if parent-label
    (codegen-fixup-lbl! cgc parent-label 0 #f 64 'parent-label)
    (am-data-word cgc 0))

  (codegen-fixup-handler! cgc '___lowlevel_exec 64)
  (asm-64 cgc (+ 6 (* 8 15)))        ;; PERM RETURN
  (asm-64 cgc (+ (if internal? 2 1)  ;; RETI or RETN (2 or 1)
                 (* 4 frame-size) ;; frame size
                 (* 128 ret-pos)  ;; link
                 (* 4096 gcmap))) ;; gcmap
  (asm-8 cgc 0) ;; so that label reference has tag ___tSUBTYPED

  (am-lbl cgc label)

  (codegen-context-label-struct-position-set! cgc
    (+ 1 label-struct-position)))

(define (encode-label-instr cgc code)
  (let* ((gvm-instr (code-gvm-instr code))
         (frame (gvm-instr-frame gvm-instr))
         (fs (frame-size frame))
         (label-struct-position (codegen-context-label-struct-position cgc))
         (proc (codegen-context-current-proc cgc))
         (proc-name (proc-obj-name proc))
         (label-num (label-lbl-num gvm-instr))
         (label (get-proc-label cgc proc label-num)))

    (debug "encode-label-instr: " label)

    (case (label-type gvm-instr)
      ((entry)
        (let ((narg (label-entry-nb-parms gvm-instr))
              (opts (label-entry-opts gvm-instr))
              (rest? (label-entry-rest? gvm-instr))
              (keys (label-entry-keys gvm-instr))
              (closure? (label-entry-closed? gvm-instr)))

              (am-check-nargs cgc label (frame-size frame) narg opts rest?
                (lambda (fun-label)
                  (set-proc-label-index cgc proc label label-struct-position)
                  (put-entry-point-label cgc label proc-name #f narg closure?)))

              (if closure?
                (let ((r4 (get-self-register cgc)))
                  (am-pop cgc r4)
                  (am-sub cgc r4 r4 (int-opnd cgc 6))))))

      ((return)
          (set-proc-label-index cgc proc label label-struct-position)
          (put-return-point-label cgc
            label
            fs
            (get-frame-ret-pos frame)
            (get-frame-gcmap frame)))

      (else
        (am-lbl cgc label)))))

;; ***** (if)Jump instruction encoding

(define (get-next-label-type proc code)
  (let* ((bb-index (bb-lbl-num (code-bb code)))
         (next-bb (get-bb proc (+ 1 bb-index))))
    (if next-bb
      (bb-label-type next-bb)
      next-bb)))

(define (encode-jump-instr cgc code)
  (define (make-jump-opnd opnd)
    (define (make-obj val)
      (cond
        ((proc-obj? val)
          (get-proc-label cgc (obj-val opnd) 1))
        ((immediate-object? val)
          (int-opnd cgc
            (format-imm-object val)
            (get-word-width-bits cgc)))
        ((reference-object? val)
          (x86-imm-obj val))
        (else
          (compiler-internal-error "make-jump-opnd: Unknown object type"))))
    (cond
      ((reg? opnd)
        (get-register cgc (reg-num opnd)))
      ((stk? opnd)
        (frame cgc (proc-jmp-frame-size code) (stk-num opnd)))
      ((lbl? opnd)
        (get-proc-label cgc (codegen-context-current-proc cgc) (lbl-num opnd)))
      ((obj? opnd)
        (make-obj (obj-val opnd)))
      ((clo? opnd)
        ;; Todo: Refactor with _t-cpu.scm::encode-close-instr
        (let ((r4 (get-self-register cgc))
              (offset (- (* (get-word-width cgc) (clo-index opnd)) 1)))
          (mem-opnd cgc offset r4)))
      ((glo? opnd)
        (x86-imm-glo (glo-name opnd)))
      (else
        (compiler-internal-error "make-jump-opnd: Unknown opnd: " opnd))))

  (debug "encode-jump-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (proc (codegen-context-current-proc cgc))
         (jmp-opnd (jump-opnd gvm-instr))
         (jmp-loc (make-jump-opnd jmp-opnd))
         (label-num (label-lbl-num (bb-label-instr (code-bb code)))))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (if (jump-poll? gvm-instr)
      (am-poll cgc (gvm-instr-frame gvm-instr)))

    ;; Save return address if necessary
    (if (jump-ret gvm-instr)
      (let* ((label-ret-num (jump-ret gvm-instr))
             (label-ret (get-proc-label cgc proc label-ret-num))
             (label-ret-opnd (lbl-opnd cgc label-ret)))
        (am-mov cgc (get-register cgc 0) label-ret-opnd)))

    ;; Set arg count
    (if (jump-nb-args gvm-instr)
      (am-set-narg cgc (jump-nb-args gvm-instr)))

    (cond
      ;; We need to dereference before jumping
      ((x86-imm-glo? jmp-loc)
        (get-free-register cgc (list jmp-loc)
          (lambda (reg)
            (am-mov cgc reg jmp-loc)
            (am-jmp cgc reg))))

      ;; Jump to next label?
      ((and
        (lbl? jmp-opnd)
        (= (lbl-num jmp-opnd) (+ 1 label-num))
        (equal? 'simple (get-next-label-type proc code)))
        ;; Jump to next label AND Next label is simple => No need to jump
        #f)

      (else
        (am-jmp cgc jmp-loc)))))

(define (encode-ifjump-instr cgc code)
  (debug "encode-ifjump-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (proc (codegen-context-current-proc cgc))
         (next-label-num (+ 1 (label-lbl-num (bb-label-instr (code-bb code)))))
         (true-label-num (ifjump-true gvm-instr))
         (false-label-num (ifjump-false gvm-instr))
         (true-label (get-proc-label cgc proc true-label-num))
         (false-label (get-proc-label cgc proc false-label-num))
         (prim-sym (proc-obj-name (ifjump-test gvm-instr)))
         (prim-obj (get-primitive-object cgc prim-sym)))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (if (not prim-obj)
      (compiler-internal-error "encode-ifjump-instr - Primitive not implemented: " prim-sym))

    (let* ((prim-fun (get-primitive-function prim-obj))
           (opnds (ifjump-opnds gvm-instr))
           (args (map (lambda (opnd) (make-opnd cgc opnd)) opnds))
           (next-label-type (get-next-label-type proc code))
           (simple? (equal? next-label-type 'simple)))
      (prim-fun cgc
        (then-jump
          (if (and simple? (= next-label-num true-label-num)) #f true-label)
          (if (and simple? (= next-label-num false-label-num)) #f false-label))
        args))))

;; ***** Apply instruction encoding

(define (encode-apply-instr cgc code)
  (debug "encode-apply-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (prim-sym (proc-obj-name (apply-prim gvm-instr)))
         (prim-obj (get-primitive-object cgc prim-sym))
         (prim-fun (get-primitive-function prim-obj))
         (loc (apply-loc gvm-instr))
         (then (if loc (then-move (make-opnd cgc loc)) then-nothing))
         (args (map (lambda (opnd) (make-opnd cgc opnd)) (apply-opnds gvm-instr))))
    (prim-fun cgc then args)))

;; ***** Copy instruction encoding

(define (encode-copy-instr cgc code)
  (define empty-frame-val #f); (int-opnd cgc 0))
  (debug "encode-copy-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (src (copy-opnd gvm-instr))
         (dst (copy-loc gvm-instr))
         (src-opnd (if src (make-opnd cgc src) empty-frame-val))
         (dst-opnd (make-opnd cgc dst)))
    (if src-opnd
      (am-mov cgc dst-opnd src-opnd (get-word-width-bits cgc)))))

;; ***** Close instruction encoding

(define (encode-close-instr cgc code)
  (define (mov-at-clo-index index reg opnd)
    (am-mov cgc
      (mem-opnd cgc (- (* (get-word-width cgc) index) 1) reg)
      opnd
      (get-word-width-bits cgc)))
  (debug "encode-close-instr")
  (let* ((proc (codegen-context-current-proc cgc))
         (gvm-instr (code-gvm-instr code))
         (frame (gvm-instr-frame gvm-instr))
         (mk-opnd (lambda (opnd) (make-opnd cgc opnd)))
         (clo-parms (car (close-parms gvm-instr)))
         (loc (mk-opnd (closure-parms-loc clo-parms)))
         (clo-lbl (get-proc-label cgc proc (closure-parms-lbl clo-parms)))
         (clo-opnds (map mk-opnd (closure-parms-opnds clo-parms)))
         (size (* (get-word-width cgc) (+ 3 (length clo-opnds)))))

    (get-free-register cgc clo-opnds
      (lambda (reg)
        (am-allocate-memory cgc reg size (+ 1 (* 2 (get-word-width cgc))) frame)

        (mov-at-clo-index -2 reg                   ;; Place header
          (int-opnd cgc (+ (* 8 14) (* 256 (- size (get-word-width cgc))))))
        (mov-at-clo-index -1 reg (lbl-opnd cgc clo-lbl)) ;; Place entry
        (get-free-register cgc '()
          (lambda (reg2)
            ;; Because can't move 64 bit value in mem
            ; (am-mov cgc reg2 (int-opnd cgc (* 8 #xff15f1ffffff))) ;; Encoded: jmp [rip-15]
            (am-mov cgc reg2 (int-opnd cgc (* 256 #xffffffF115ff))) ;; Encoded: jmp [rip-15]
            (mov-at-clo-index 0 reg reg2))) ;; Place code

        ;; Place value of free variables
        (let loop ((opnds clo-opnds) (n 1))
          (if (not (null? opnds))
            (begin
              (mov-at-clo-index n reg (car opnds))
              (loop (cdr opnds) (+ n 1)))))
        ;; Todo: Remove mov if unnecessary (Next GVM Instruction is often reg = loc)
        (am-mov cgc loc reg)))))

;; ***** Switch instruction encoding

(define (encode-switch-instr cgc gvm-instr)
  (debug "encode-switch-instr")
  (compiler-internal-error
    "encode-switch-instr: switch instruction not implemented"))

;; ***** GVM helper methods

(define (get-code-list proc)
  (let ((bbs (proc-obj-code proc)))
    (if (bbs? bbs)
      (bbs->code-list bbs)
      #f)))

(define (get-bb proc index)
  (let ((bbs (proc-obj-code proc)))
    (if (bbs? bbs)
      (if (< index (stretchable-vector-length (bbs-basic-blocks bbs)))
      (lbl-num->bb index bbs)
        #f)
      #f)))

;; First label always start with 1
(define (get-parent-proc-label cgc proc)
  (get-proc-label cgc proc 1))

(define (proc-lbl-frame-size code)
  (bb-entry-frame-size (code-bb code)))

(define (proc-jmp-frame-size code)
  (bb-exit-frame-size (code-bb code)))

(define (proc-frame-slots-gained code)
  (bb-slots-gained (code-bb code)))

(define (label-instr-label cgc proc label-num)
  (get-proc-label cgc proc label-num))

(define (get-frame-gcmap frame)
  (define (live? var)
    (let ((live (frame-live frame)))
      (or (varset-member? var live)
          (and (eq? var closure-env-var)
                (varset-intersects?
                  live
                  (list->varset (frame-closed frame)))))))
  (make-bitmap
    (map
      (lambda (slot) (live? slot))
      (frame-slots frame))))

(define (get-frame-ret-pos frame)
  (index-of 'ret (map var-name (frame-slots frame))))

;;------------------------------------------------------------------------------
;;------------------------------ Lowlevel Bridge -------------------------------
;;------------------------------------------------------------------------------

;; Processor state table

;; The ps register points at the start of processor state structure.
;;
;;  Start: Low level exec processor state structure
;;  End: Low level exec processor state structure
;;  Start: Regular processor state structure <-- ps register
;;  End: Regular processor state structure

;; Todo: Support gvm-reg other than 0|1|2|3|4
(define (get-processor-state-field cgc sym)
  (define word-width (get-word-width cgc))

  (define (fields-lowlevelexec) `(
    (return-stack-pointer    ,word-width)
    (return-handler          ,word-width)
    ))

  (define (fields-regular) `(
    (stack-trip              ,word-width)
    (stack-limit             ,word-width)
    (frame-pointer           ,word-width)
    (stack-start             ,word-width)
    (stack-break             ,word-width)
    (heap-limit              ,word-width)
    (heap-pointer            ,word-width)
    (gvm-reg0                ,word-width)
    (gvm-reg1                ,word-width)
    (gvm-reg2                ,word-width)
    (gvm-reg3                ,word-width)
    (gvm-reg4                ,word-width)
    (program-counter         ,word-width)
    (nargs                   ,word-width)
    (handler_sfun_conv_error ,word-width)
    (handler_cfun_conv_error ,word-width)
    (handler_stack_limit     ,word-width)
    (handler_heap_limit      ,word-width)
    (handler_not_proc        ,word-width)
    (handler_not_proc_glo    ,word-width)
    (handler_wrong_nargs     ,word-width)
    (handler_get_rest        ,word-width)
    (handler_get_key         ,word-width)
    (handler_get_key_rest    ,word-width)
    (handler_force           ,word-width)
    (handler_return_to_c     ,word-width)
    (handler_break           ,word-width)
    (internal_return         ,word-width)
    (dynamic_env_bind_return ,word-width)
    (temp1                   ,word-width)
    (temp2                   ,word-width)
    (temp3                   ,word-width)
    (temp4                   ,word-width)
    ))

  ;; Returns a pair of the offset from start of lst and the width of the field
  (define (find-field lst accum)
    (if (null? lst)
      -1 ;; Error value
      (let* ((field (car lst))
             (field-sym (car field))
             (width (cadr field)))
        (if (equal? sym field-sym)
          (cons accum (* 8 width))
          (find-field (cdr lst) (+ width accum))))))

  (let* ((fields
          (if USE_BRIDGE
            (append (fields-lowlevelexec) (fields-regular))
            (fields-regular)))
         (offset
          (if USE_BRIDGE
            (- (apply + (map cadr (fields-lowlevelexec))))
            0))
         (field (find-field fields 0)))

  (if (eq? -1 field)
    (compiler-internal-error "Unknown processor state field: " sym))

    ;; Cons of mem-opnd and width
    (cons
      (mem-opnd cgc (+ offset (car field)) (get-pstate-pointer cgc))
      (cdr field))))
