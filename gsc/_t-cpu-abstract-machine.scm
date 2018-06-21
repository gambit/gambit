;;==============================================================================

;;; File: "_t-cpu-abstract-machine.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; ***** Abstract machine (AM)
;;  We define an abstract instruction set which we program against for most of
;;  the backend. Most of the code is moving data between registers and the stack
;;  and jumping to locations, so it reduces the repetion between native backends
;;  (x86, x64, ARM, Risc V, etc.).
;;
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
;;          Operands: Register, Immediate, Memory (todo: And Label)
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
(define (make-backend info operands instructions routines)
  (vector
    info
    operands
    instructions
    routines))

(define info-index 0)
(define operands-index 1)
(define instructions-index 2)
(define routines-index 3)

;;  Fields:
;;    word-width : Machine word length in bytes
;;    endianness : 'le or 'be
;;    load-store : See note 3
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
(define (make-backend-info
          word-width
          endianness
          load-store
          frame-pointer-reg
          frame-offset
          primitive-table
          main-registers
          extra-registers
          make-cgc-fun)
  (vector
    word-width
    endianness
    load-store
    frame-pointer-reg
    frame-offset
    primitive-table
    main-registers
    extra-registers
    make-cgc-fun))

;; Vector of functions on operands
(define (make-operand-dictionnary
          int-opnd int-opnd?
          lbl-opnd lbl-opnd?
          mem-opnd mem-opnd?
          reg-opnd?
          int-opnd-value
          lbl-opnd-offset lbl-opnd-label
          mem-opnd-offset mem-opnd-reg)
  (vector
    int-opnd int-opnd?
    lbl-opnd lbl-opnd?
    mem-opnd mem-opnd?
    reg-opnd?
    int-opnd-value
    lbl-opnd-offset lbl-opnd-label
    mem-opnd-offset mem-opnd-reg))

(define (make-instruction-dictionnary
          am-lbl am-data
          am-mov am-load-mem-address
          am-push am-pop
          am-add am-sub
          am-bit-shift-right am-bit-shift-left
          am-not am-and
          am-or  am-xor
          am-jmp am-compare-jump)
  (vector
    am-lbl am-data
    am-mov am-load-mem-address
    am-push am-pop
    am-add am-sub
    am-bit-shift-right am-bit-shift-left
    am-not am-and
    am-or am-xor
    am-jmp am-compare-jump))

(define (make-routine-dictionnary
          poll
          set-narg
          check-narg
          allocate-memory
          init
          end
          error
          place-extra-data)
  (vector poll set-narg check-narg allocate-memory init end error place-extra-data))

(define (get-in-cgc cgc i1 i2)
  (let* ((target (codegen-context-target cgc))
         (info (target-extra target 0))
         (field (vector-ref (vector-ref info i1) i2)))
    field))

(define (exec-in-cgc cgc i1 i2 args)
  (apply (get-in-cgc cgc i1 i2) args))

;; ***** AM: Info fields

(define main-register-index 6)
(define extra-register-index 7)

(define (get-word-width cgc)        (get-in-cgc cgc info-index 0))
(define (get-word-width-bits cgc)   (* 8 (get-word-width cgc)))
(define (get-endianness cgc)        (get-in-cgc cgc info-index 1))
(define (is-load-store? cgc)        (get-in-cgc cgc info-index 2))
(define (get-frame-pointer-reg cgc) (get-in-cgc cgc info-index 3))
(define (get-frame-offset cgc)      (get-in-cgc cgc info-index 4))
(define (get-primitive-table cgc)   (get-in-cgc cgc info-index 5))
(define (get-main-registers  cgc)   (get-in-cgc cgc info-index main-register-index))
(define (get-extra-registers cgc)   (get-in-cgc cgc info-index extra-register-index))

;; NOTICE THAT IT TAKES A TARGET INSTEAD OF CGC
(define (get-make-cgc-fun target)
  (let* ((info (target-extra target 0))
         (field (vector-ref (vector-ref info info-index) 8)))
    field))

(define (get-primitive-object cgc name)
  (let* ((table (get-primitive-table cgc)))
    (table-ref table (string->symbol name) #f)))

;; ***** AM: Operands fields

(define (apply-opnd cgc index args)
  (exec-in-cgc cgc operands-index index args))

(define (int-opnd  cgc . args)       (apply-opnd cgc 0  args))
(define (int-opnd? cgc . args)       (apply-opnd cgc 1  args))
(define (lbl-opnd  cgc . args)       (apply-opnd cgc 2  args))
(define (lbl-opnd? cgc . args)       (apply-opnd cgc 3  args))
(define (mem-opnd  cgc . args)       (apply-opnd cgc 4  args))
(define (mem-opnd? cgc . args)       (apply-opnd cgc 5  args))
(define (reg-opnd? cgc . args)       (apply-opnd cgc 6  args))
(define (int-opnd-value  cgc . args) (apply-opnd cgc 7  args))
(define (lbl-opnd-offset cgc . args) (apply-opnd cgc 8  args))
(define (lbl-opnd-label  cgc . args) (apply-opnd cgc 9  args))
(define (mem-opnd-offset cgc . args) (apply-opnd cgc 10 args))
(define (mem-opnd-reg    cgc . args) (apply-opnd cgc 11 args))

(define (lbl-opnd-set-offset cgc lbl offset)
  (lbl-opnd cgc (lbl-opnd-label cgc lbl) offset))

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

;; ***** AM: Routines fields

(define (apply-routine cgc index args)
  (exec-in-cgc cgc routines-index index (cons cgc args)))

(define (am-poll cgc . args)             (apply-routine cgc 0 args))
(define (am-set-narg cgc . args)         (apply-routine cgc 1 args))
(define (am-check-nargs cgc . args)       (apply-routine cgc 2 args))
(define (am-allocate-memory cgc . args)  (apply-routine cgc 3 args))
(define (am-init cgc . args)             (apply-routine cgc 4 args))
(define (am-end cgc . args)              (apply-routine cgc 5 args))
(define (am-error cgc . args)            (apply-routine cgc 6 args))
(define (am-place-extra-data cgc . args) (apply-routine cgc 7 args))

;; ***** AM: State fields

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

;; ***** AM: Conditions

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

;; ***** Utils

;; ***** Utils - Register allocation

(define (choose-register cgc use registers allocation)
  (define (use-register index save?)
    (let ((register (vector-ref registers index))
          (ref-count (vector-ref allocation index)))
      (if save?
        (am-push cgc register))

      (vector-set! allocation index (+ ref-count 1))
      (use register)
      ;; Important: Don't use ref-count because (use-register) may have used the register
      (vector-set! allocation index (- (vector-ref allocation index) 1))

      (if save?
        (am-pop cgc register))))

  (debug "Choose-register")

  (let loop ((n 0))
    (if (< n (vector-length registers))
      (if (= 0 (vector-ref allocation n))
        (use-register n #f)
        (loop (+ n 1)))

      ;; Todo: Remove randomness
      (use-register (random-integer (vector-length registers)) #t))))

(define (get-register cgc n)
  (vector-ref (get-main-registers cgc) n))

(define (get-extra-register cgc use)
  (get-multiple-extra-register cgc 1 use))

(define (get-multiple-extra-register cgc number use)
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
      (get-extra-registers cgc)
      (codegen-context-extra-registers-allocation cgc)))

  (if (< (vector-length (get-extra-registers cgc)) number)
    (compiler-internal-error "get-extra-register: Not enough extra registers"))

  (accumulate-extra-register number))

;; ***** Utils - Operands

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
      (let ((base (get-register cgc (reg-num (clo-base opnd))))
            (index (* 8 (- (clo-index opnd) 1))))
        (debug "Base:" base)
        (debug "Index:" index)
        (mem-opnd cgc index base)))
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
    (get-frame-pointer-reg cgc)))

(define (alloc-frame cgc n)
  (if (not (= 0 n))
    (am-sub cgc
      (get-frame-pointer-reg cgc)
      (get-frame-pointer-reg cgc)
      (int-opnd cgc (* n (get-word-width cgc))))))

;; ***** Utils - Abstract machine shorthand

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

(define (am-call-c-function cgc sym args)
  (get-extra-register cgc
    (lambda (reg)
      (let* ((proc (codegen-context-current-proc cgc))
             (struct-position (codegen-context-label-struct-position cgc))
             (label (get-proc-label cgc proc (- struct-position))))

        ;; Check if global var can be **safely** used
        (am-mov cgc reg (x86-imm-obj sym))
        (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
        (am-mov cgc reg (mem-opnd cgc 0 reg))

        (am-mov cgc (get-register cgc 0) (lbl-opnd cgc label)) ;; Set return
        (am-put-args cgc 0 args) ;; Put arguments
        (am-set-narg cgc (length args))
        (am-jmp cgc reg)

        (set-proc-label-index cgc proc label struct-position)
        (put-return-point-label cgc label 0 0 0))))) ;; Return point)))

(define (am-put-args cgc start-fs args)
  (define (get-frames count)
    (map (lambda (i) (frame cgc start-fs i)) (iota 1 count)))

  (define (get-registers count)
    (map (lambda (i) (get-register cgc i)) (iota 1 count)))

  (let* ((target (codegen-context-target cgc))
         (narg-in-regs (target-nb-arg-regs target))
         (narg-in-frames (- (length args) narg-in-regs))
         (frames (reverse (get-frames narg-in-frames)))
         (regs (get-registers narg-in-regs)))
    (for-each
      (lambda (arg loc)
        (if (not (equal? loc arg))
          (am-mov cgc loc arg (get-word-width-bits cgc))))
      args
      (append frames regs))))

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

(define (am-data-word cgc word)
  (am-data cgc (get-word-width-bits cgc) word))

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

;; ***** Utils - Other

(define (reserve-space cgc bytes #!optional (value 0))
  (if (> bytes 0)
    (begin
      (am-data cgc 8 value)
      (reserve-space cgc (- bytes 1) value))))

;; ***** Default Routines

(define (default-check-narg cgc narg narg-loc error-lbl)
  (debug "default-check-narg: " narg)
  (let ((opnd2 (int-opnd cgc narg)))
    (am-compare-jump cgc narg-loc opnd2 condition-not-equal error-lbl #f)))

(define (default-set-narg cgc narg narg-loc)
  (debug "default-set-narg: " narg)
  (am-mov cgc narg-loc (int-opnd cgc narg)))

;; ***** High level instructions

;; ***** High level instructions - Utils

(define (with-result-opnd cgc result-action args commutative fun)
  (cond
    ((then-jump? result-action)
      (get-extra-register cgc fun))
    ((then-move? result-action)
      (let ((mov-loc (then-move-store-location result-action)))
        (cond
          ;; We can rearrange the expression to remove redundant move
          ((and (= 1 (elem-count mov-loc args)) commutative)
            (fun mov-loc))
          ;; We can overwrite mov-loc.
          ;; It is probably more efficient to do this when #args > 2
          ((equal? 'reg (opnd-type cgc mov-loc))
            (fun mov-loc))
          (else
            (get-extra-register cgc fun)))))
        ; (if (or (and (= 1 (elem-count mov-loc args))) (not commutative)) ;;
        ;         (not (equal? 'reg (opnd-type cgc mov-loc))))
        ;   (get-extra-register cgc fun)
        ;   (fun mov-loc))))
    ((then-return? result-action)
      (get-extra-register cgc fun))
    (else
      (compiler-internal-error "with-result-opnd - Unknown result-action" result-action))))

(define (check-nargs-if-necessary cgc result-action nargs #!optional (optional-args-values '()) (rest? #f))
  (if (then-return? result-action)
    (am-check-nargs
      cgc
      (then-return-label result-action)
      (get-fun-fs cgc nargs)
      nargs
      optional-args-values
      rest?
      (lambda (fun-label)
        (put-entry-point-label cgc fun-label nargs #f)))))

(define (call-with-nargs args nargs fun)
  (apply fun args))

;; ***** High level instructions - Instructions

;; Fold with no default-value.
;; nargs > 0
; (define (fold-prim default-value reduce-fun allowed-opnd)
;   (lambda (cgc result-action args)

;     ;; Optimize empty case
;     (if (null? args)
;       (return-const cgc result-action default-value))

;     (with-result-opnd cgc result-action
;       (lambda (accum)
;         (let loop ((lst args))
;           (if (not (null? lst))
;             (begin
;               (reduce-fun (car lst) accum)
;               (loop (cdr lst)))))))))

(define (foldl-prim default-value reduce-fun allowed-opnds commutative)
  (lambda (cgc result-action args)
    (debug "foldr-prim")
    ;; Optimize empty case
    (if (null? args)
      (am-return-const cgc result-action default-value))

    (debug "foldr-prim - After empty case")
    ;; Fold over arguments
    (with-result-opnd cgc result-action args commutative
      (lambda (accum)
        (debug "foldr-prim - accum: " accum)
        ;; Accum may be in args if commutative.
        ;; Remove accum from args in that case.
        ;; Conditions for accum to be in args are:
        ;;  Only appears once
        (let loop ((args
                    (if commutative
                      (filter (lambda (opnd) (not (equal? accum opnd))) args)
                      args)))
          (if (not (null? args))
            ;; Mov car args if necessary
            (let ((arg (car args)))
              (if (not (elem? (opnd-type cgc arg) allowed-opnds))
                (get-extra-register cgc
                  (lambda (tmp-reg)

                    (am-mov cgc tmp-reg arg)
                    (reduce-fun cgc accum tmp-reg)))
                (reduce-fun cgc accum arg))

              (loop (cdr args)))))

        (am-return-opnd cgc result-action accum #t)))))

(define (am-if cgc opnd1 opnd2 condition on-true on-false #!optional (actions-return #f) (opnds-width #f))
  (let ((true-label (make-unique-label cgc "if-true" #f))
        (false-label (make-unique-label cgc "if-false" #f))
        (continue-label (make-unique-label cgc "continue-label" #f)))
    (cond
      ((and on-true on-false)
        (am-compare-jump cgc opnd1 opnd2 condition #f false-label opnds-width)
        (on-true cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label))
        (am-lbl cgc false-label)
        (on-false cgc)
        (am-lbl cgc continue-label))
      (on-true
        (am-compare-jump cgc opnd1 opnd2 condition #f continue-label opnds-width)
        (on-true cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label)))
      (on-false
        (am-compare-jump cgc opnd1 opnd2 condition continue-label #f opnds-width)
        (on-false cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label))))))

(define (am-if-eq cgc opnd1 opnd2 on-true on-false #!optional (actions-return #f) (opnds-width #f))
  (am-if cgc opnd1 opnd2 condition-equal on-true on-false actions-return opnds-width))

(define (am-return-const cgc result-action value)
  (debug "am-return-const")
  (debug "result-action: " result-action)
  (cond
    ((then-jump? result-action)
      (if value
        (if (then-jump-true-location result-action)
          (am-jmp cgc (then-jump-true-location result-action)))
        (if (then-jump-false-location result-action)
          (am-jmp cgc (then-jump-false-location result-action)))))
    ((then-move? result-action)
      (am-mov
        cgc
        (then-move-store-location result-action)
        (make-obj-opnd cgc value)))
    ((then-return? result-action)
      (am-mov
        cgc
        (get-register cgc 1)
        (make-obj-opnd cgc value))
      (am-jmp cgc (get-register cgc 0)))
    (else
      (compiler-internal-error "prim-const-return - Unknown result-action" result-action))))

(define (am-return-opnd cgc result-action opnd check-truth-value)
  (debug "am-return-opnd")
  (debug "result-action: " result-action)
  (cond
    ((then-jump? result-action)
      (if check-truth-value
        (let ((false-opnd (make-obj-opnd cgc #t))
              (true-jmp (then-jump-true-location result-action))
              (false-jmp (then-jump-false-location result-action)))
          (am-compare-jump cgc opnd false-opnd condition-equal true-jmp false-jmp))
        (am-jmp cgc (then-jump-true-location result-action))))
    ((then-move? result-action)
      (let ((mov-loc (then-move-store-location result-action)))
        (if (not (equal? mov-loc opnd))
          (am-mov cgc mov-loc opnd))))
    ((then-return? result-action)
      (if (not (equal? (get-register cgc 1) opnd))
        (am-mov cgc (get-register cgc 1) opnd))
      (am-jmp cgc (get-register cgc 0)))
    (else
      (compiler-internal-error "prim-const-return - Unknown result-action" result-action))))

;; ***** Default Primitives
;; ***** Basic primitives (##Identity and ##not)

(define (##identity-primitive cgc result-action args)
  (check-nargs-if-necessary cgc result-action 1)
  (call-with-nargs args 1
    (lambda (arg1)
      (debug "identity prim")
      (am-if-eq cgc arg1 (make-obj-opnd cgc #t)
        (lambda (cgc) (am-return-const cgc result-action #t))
        (lambda (cgc) (am-return-const cgc result-action #t))
        #t
        (get-word-width-bits cgc)))))

(define (##identity-not cgc result-action args)
  (check-nargs-if-necessary cgc result-action 1)
  (call-with-nargs args 1
    (lambda (arg1)
      (debug "identity not")
      (am-if-eq cgc arg1 (make-obj-opnd cgc #t)
        (lambda (cgc) (am-return-const cgc result-action #f))
        (lambda (cgc) (am-return-const cgc result-action #t))
        #t
        (get-word-width-bits cgc)))))

;; ***** Default Primitives - Memory read/write/test

(define (read-reference cgc dest ref tag offset)
  (let* ((total-offset (- (* (get-word-width cgc) offset) tag))
         (mem-location (get-opnd-with-offset cgc ref total-offset)))
    (am-mov cgc dest mem-location)))

(define (get-opnd-with-offset cgc opnd offset)
  (case (opnd-type cgc opnd)
    ('reg
      (mem-opnd cgc offset opnd))
    ('mem
      (mem-opnd cgc (+ (mem-opnd-offset cgc opnd) offset) (mem-opnd-reg cgc opnd)))
    ('lbl
      (lbl-opnd cgc (lbl-opnd-label cgc opnd) (+ (lbl-opnd-offset cgc opnd) offset)))
    ('int
      (mem-opnd cgc (+ (int-opnd-value cgc opnd) offset)))))

(define (get-object-field desc field-index)
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))
  (lambda (cgc result-action args)
    (let* ((ref (car args))
           (tag (get-desc-pointer-tag desc))
           (lambd (lambda (reg)
            (read-reference cgc reg ref tag (+ 1 field-index)))))
      (cond
        ((then-jump? result-action)
          (get-extra-register cgc
            (lambda (reg)
              (let ((condition condition-not-equal)
                    (false-opnd (int-opnd cgc (format-imm-object #f)))
                    (true-jmp (then-jump-true-location result-action))
                    (false-jmp (then-jump-false-location result-action)))
                (lambd reg)
                (am-compare-jump cgc reg false-opnd condition-not-equal true-jmp false-jmp)))))

        ((then-move? result-action)
          (lambd (then-move-store-location result-action)))

        ((then-return? result-action)
          (lambd (get-register cgc 1))
          (am-jmp cgc (get-register cgc 0)))

        ((not result-action)
          ;; Do nothing
          ;; Todo: Decide if this is useful
          #f)

        (else
          (compiler-internal-error "get-object-field - Unknown result-action" result-action))))))
