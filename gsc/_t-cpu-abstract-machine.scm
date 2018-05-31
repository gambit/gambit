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
    routines
    (make-state info)))

(define info-index 0)
(define operands-index 1)
(define instructions-index 2)
(define routines-index 3)
(define state-index 4)

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
;;    spill-registers : (Vector) Registers that can be pushed.  Must be a subset of main-registers.
;;    extra-registers : (Vector) Extra registers that can be overwritten at any time.
;;      Note: #spill-registers + #extra-registers must >= 3.
(define (make-backend-info
          word-width
          endianness
          load-store
          frame-pointer-reg
          frame-offset
          primitive-table
          main-registers
          spill-registers
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
    spill-registers
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
          allocate-mem
          init
          end
          error
          place-extra-data)
  (vector poll set-narg check-narg allocate-mem init end error place-extra-data))

(define (get-in-cgc cgc i1 i2)
  (let* ((target (codegen-context-target cgc))
         (info (target-extra target 0))
         (field (vector-ref (vector-ref info i1) i2)))
    field))

(define (exec-in-cgc cgc i1 i2 args)
  (apply (get-in-cgc cgc i1 i2) args))

;; ***** AM: Info fields

(define main-register-index 6)
(define spill-register-index 7)
(define extra-register-index 8)

(define (get-word-width cgc)        (get-in-cgc cgc info-index 0))
(define (get-word-width-bits cgc)   (* 8 (get-word-width cgc)))
(define (get-endianness cgc)        (get-in-cgc cgc info-index 1))
(define (is-load-store? cgc)        (get-in-cgc cgc info-index 2))
(define (get-frame-pointer-reg cgc) (get-in-cgc cgc info-index 3))
(define (get-frame-offset cgc)      (get-in-cgc cgc info-index 4))
(define (get-primitive-table cgc)   (get-in-cgc cgc info-index 5))
(define (get-main-registers  cgc)   (get-in-cgc cgc info-index main-register-index))
(define (get-spill-registers cgc)   (get-in-cgc cgc info-index spill-register-index))
(define (get-extra-registers cgc)   (get-in-cgc cgc info-index extra-register-index))

;; NOTICE THAT IT TAKES A TARGET INSTEAD OF CGC
(define (get-make-cgc-fun target)
  (let* ((info (target-extra target 0))
         (field (vector-ref (vector-ref info info-index) 9)))
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
(define (am-not cgc . args)              (apply-instruction cgc 10  args))
(define (am-and cgc . args)              (apply-instruction cgc 11  args))
(define (am-or cgc . args)               (apply-instruction cgc 12 args))
(define (am-xor cgc . args)              (apply-instruction cgc 13 args))
(define (am-jmp cgc . args)              (apply-instruction cgc 14 args))
(define (am-compare-jump cgc . args)     (apply-instruction cgc 15 args))

;; ***** AM: Routines fields

(define (apply-routine cgc index args)
  (exec-in-cgc cgc routines-index index (cons cgc args)))

(define (am-poll cgc . args)             (apply-routine cgc 0 args))
(define (am-set-narg cgc . args)         (apply-routine cgc 1 args))
(define (am-check-narg cgc . args)       (apply-routine cgc 2 args))
(define (am-allocate-mem cgc . args)     (apply-routine cgc 3 args))
(define (am-init cgc . args)             (apply-routine cgc 4 args))
(define (am-end cgc . args)              (apply-routine cgc 5 args))
(define (am-error cgc . args)            (apply-routine cgc 6 args))
(define (am-place-extra-data cgc . args) (apply-routine cgc 7 args))

;; ***** AM: State fields

(define (get-state-field cgc index)
  (get-in-cgc cgc state-index index))

(define (get-proc-label-table cgc)          (get-state-field cgc 0))
(define (get-object-label-table cgc)        (get-state-field cgc 1))
(define (get-global-var-table cgc)          (get-state-field cgc 2))
(define (get-label-table cgc)               (get-state-field cgc 3))
(define (get-spill-register-allocation cgc) (get-state-field cgc 4))
(define (get-extra-register-allocation cgc) (get-state-field cgc 5))

(define (make-state info)
  (define (const a)
    (lambda (b) a))
  (define (make-allocation-vector length)
    (apply vector (map (const 0) (iota 1 length))))

  (vector
    (make-table test: equal?) ;; Labels of proc. (Key, Value) == (Label id, (Label, Maybe Proc-obj))
    (make-table test: equal?) ;; Labels for objects
    (make-table test: equal?) ;; Labels for global variables
    (make-table test: equal?) ;; Other labels
    (make-allocation-vector (vector-length (vector-ref info spill-register-index)))
    (make-allocation-vector (vector-length (vector-ref info extra-register-index)))
    ))

(define (table-get-or-set table key def-val)
  (let ((x (table-ref table key #f)))
    (if x
      x
      (begin
        (table-set! table key def-val)
        def-val))))

(define (get-proc-label cgc proc gvm-lbl)
  (define (lbl->id num proc_name)
    (string->symbol (string-append "_proc_" (number->string num) "_" proc_name)))

  (let* ((table (get-proc-label-table cgc))
         (id (if gvm-lbl gvm-lbl 0))
         (lbl-id (lbl->id id (proc-obj-name proc)))
         (def-lbl (list (asm-make-label cgc lbl-id) proc)))
    (car (table-get-or-set table lbl-id def-lbl))))

(define (get-obj-label cgc obj)
  (define (obj->id)
    (string->symbol (string-append "_obj_" (number->string (get-unique-id)))))

  (let* ((table (get-object-label-table cgc))
         (val (asm-make-label cgc (obj->id))))
    (table-get-or-set table obj val)))

(define (get-global-var-label cgc name)
  (define (obj->id)
    (string->symbol (string-append "_glo_" (number->string (get-unique-id)))))

  (let* ((table (get-global-var-table cgc))
         (val (asm-make-label cgc (obj->id))))
    (table-get-or-set table name val)))

(define (get-label cgc sym)
  (let* ((table (get-label-table cgc))
         (def-lbl (asm-make-label cgc sym)))
    (table-get-or-set table sym def-lbl)))

;; Useful for branching
(define (make-unique-label cgc prefix)
  (define (lbl->id num proc_name)
    (string->symbol (string-append (if prefix prefix "other") (number->string num))))
  (let* ((id (get-unique-id))
         (label-id (lbl->id id suffix))
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
(define (condition-not-greater and-equal? signed) (list 'not-greater and-equal? signed))

(define (get-condition cond) (car cond))

(define (cond-is-equal cond)
  (case (car cond)
    ((equal) #t)
    ((not-equal) #f)
    ((greater) (cadr cond))
    ((not-greater) (cadr cond))))

(define (cond-is-signed cond)
  (case (car cond)
    ((equal) #t)
    ((not-equal) #t)
    ((greater) (caddr cond))
    ((not-greater) (caddr cond))))

(define (inverse-condition cond)
  (case (car cond)
    ((equal)
      condition-not-equal)
    ((not-equal)
      condition-equal)
    ((greater)
      (condition-not-greater (not (cond-is-equal cond)) (cond-is-signed cond)))
    ((not-greater)
      (condition-greater (not (cond-is-equal cond)) (cond-is-signed cond)))))

;; ***** Utils

;; ***** Utils - Register allocation

(define (choose-register cgc use registers allocation)
  (define (use-register index save?)
    (let ((register (vector-ref registers index))
          (ref-count (vector-ref allocation index)))
      (debug "Use-register: " register " (" ref-count ") ")
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

      (use-register (random-integer (vector-length registers)) #t))))

(define (get-register cgc n)
  (vector-ref (get-main-registers cgc) n))

(define (get-spill-register cgc use)
  (choose-register cgc use (get-spill-registers cgc) (get-spill-register-allocation cgc)))

(define (get-extra-register cgc use)
  (choose-register cgc use (get-extra-registers cgc) (get-extra-register-allocation cgc)))

;; ***** Utils - Operands

;; Version of make-opnd not using proc and code.
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

(define (make-opnd cgc proc code opnd)
  (define (make-obj val)
    (cond
      ((proc-obj? val)
        ;; 1 is used to get the first label of a procedure, if it exists.
        ;; If not 1, the procedure will look like a primitive that was used
        ;; but not defined and it will look for a primitive called the name
        ;; of the procedure. It crashes the program, DO NOT CHANGE!
        (lbl-opnd cgc (get-proc-label cgc (obj-val opnd) 1)))
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
      (compiler-internal-error "opnd-type - Unknown opnd: " : opnd))))

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

(define (am-call-c-function cgc sym args)
  (get-extra-register cgc
    (lambda (reg)
      (let ((label (make-unique-label cgc #f)))
        ;; Check if global var can be **safely** used
        (am-mov cgc reg (x86-imm-obj sym))
        (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
        (am-mov cgc reg (mem-opnd cgc 0 reg))

        (am-mov cgc (get-register cgc 0) (lbl-opnd cgc label)) ;; Set return
        (am-put-args cgc 0 args) ;; Put arguments
        (am-set-narg cgc (length args))
        (am-jmp cgc reg)
        (put-return-point-label cgc label 0 0 0))))) ;; Return point)))

(define (am-put-args cgc jump-fs args)
  (define (get-frames count)
    (map (lambda (i) (frame cgc jump-fs i)) (iota 1 count)))

  (define (get-registers count)
    (map (lambda (i) (get-register cgc i)) (iota 1 count)))

  (let* ((target (codegen-context-target cgc))
         (narg-in-regs (target-nb-arg-regs target))
         (narg-in-frames (- (length args) narg-in-regs))
         (frames (reverse (get-frames narg-in-frames)))
         (regs (get-registers narg-in-regs)))
    (for-each
      (lambda (arg loc) (am-mov cgc loc arg (get-word-width-bits cgc)))
      args
      (append frames regs))))

; (define (am-get-args cgc nargs))

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

(define (reserve-space cgc bytes #!optional (value 0))
  (if (> bytes 0)
    (begin
      (am-data cgc 8 value)
      (reserve-space cgc (- bytes 1) value))))

(define (make-poll check-interrupt check-underflow check-overflow)
  (lambda (cgc proc code)
    (debug "default-poll")
    (let ((gvm-instr (code-gvm-instr code))
          (fs-gain (proc-frame-slots-gained code)))
      (if (jump-poll? gvm-instr)
        (begin
          (cond
            ((< 0 fs-gain) (check-overflow cgc))
            ((> 0 fs-gain) (check-underflow cgc)))
          (check-interrupt cgc))))))

;; ***** Default Routines

(define (default-check-narg cgc narg narg-loc error-lbl)
  (debug "default-check-narg: " narg)
  (let ((opnd2 (int-opnd cgc narg)))
    (am-compare-jump cgc narg-loc opnd2 condition-not-equal error-lbl #f)))

(define (default-set-narg cgc narg narg-loc)
  (debug "default-set-narg: " narg)
  (am-mov cgc narg-loc (int-opnd cgc narg)))


;; ***** Default Primitives
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
