;;==============================================================================

;;; File: "_t-cpu-abstract-machine.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")

;;------------------------------------------------------------------------------

;; ***** Abstract machine (AM)
;;  We define an abstract instruction set which we program against for most of
;;  the backend. Most of the code is moving data between registers and the stack
;;  and jumping to locations, so it reduces the repetion between native backends
;;  (x86, x64, ARM, Risc V, etc.).
;;
;;
;;  To reduce the overhead the following high-level instructions are defined in
;;  the native assembly:
;;    apply-primitive cgc primName ...
;;    set-narg/check-narg cgc narg
;;    poll cgc ...
;;    make-opnd cgc ...
;;
;;  Notes:
;;    1 - Default methods are given if possible
;;    2 - In case the native architecture is load-store, set load-store-only to true.
;;        The am-mov instruction acts like both load and store.
;;
;;
;;  The following non-branching instructions are required:
;;    am-lbl  : Place label
;;    am-ret  : Exit program
;;    am-mov  : Move value between 2 registers/memory/immediate
;;
;;    am-cmp  : Compare 2 operands. Sets flag
;;    am-add  : (Add imm/reg to register). If load-store-only, mem can be used as opn
;;    am-sub  : (Add imm/reg to register). If load-store-only, mem can be used as opn
;;
;;    am-bit-shift-right : Shifts register to the right by some constant
;;    am-bit-shift-left  : Shifts register to the left by some constant
;;
;;    am-not  : Logical not
;;    am-and  : Logical and
;;    am-or   : Logical or
;;    am-xor  : Logical xor
;;    am-test : Logical and, but only sets flag
;;
;;
;;  The following branching instructions are required:
;;    am-jmp      : Jump to location
;;    am-jmplink  : Jump and store location. (Branch and link)
;;    am-je       : Jump if equal
;;    am-jne      : Jump if not equal
;;    am-jg       : Jump if greater (signed)
;;    am-jng      : Jump if not greater (signed)
;;    am-jge      : Jump if greater or equal (signed)
;;    am-jnge     : Jump if not greater or equal (signed)
;;    am-jgu      : Jump if greater (unsigned)
;;    am-jngu     : Jump if not greater (unsigned)
;;    am-jgeu     : Jump if greater or equal (unsigned)
;;    am-jngeu    : Jump if not greater or equal (unsigned)
;;    execute-cond: NOT IMPLEMENTED. Execute code given only if condition is true.
;;                  This may be useful with conditionnal instructions in ARM
;;                  On other arch, it still provides a nice abstraction for entering small branches
;;
;;  Note: Branching instructions on overflow/carry/sign/parity/etc. are not needed.
;;
;;
;;  The following instructions have a default implementation:
;;    am-lda  : Load address of memory location. Does not support labels.
;;    ...
;;
;;
;;  The following non-instructions function have to be defined
;;    int-opnd: Create int immediate object   (See int-opnd)
;;    lbl-opnd: Create label immediate object (See x86-imm-lbl)
;;    mem-opnd: Create memory location object (See x86-mem)
;;
;;
;;  The operand objects have to follow the x86 operands objects formats.
;;  The default implementations assume they follow the format.
;;
;;  To add new native backend, see x64-setup function

;; ***** AM: Caracteristics

(define word-width 64)
(define word-width-bytes 8)
(define endianness 'be)
(define load-store-only #f)
(define enable-poll #t)

;; ***** AM: Operands

(define int-opnd #f)
(define lbl-opnd #f)
(define mem-opnd #f)

(define int-opnd? #f)
(define lbl-opnd? #f)
(define mem-opnd? #f)
(define reg-opnd? #f)

(define int-opnd-value  #f)
(define lbl-opnd-offset #f)
(define lbl-opnd-label  #f)
(define mem-opnd-offset #f)
(define mem-opnd-reg    #f)

;; ***** AM: Instructions
;; ***** AM: Instructions: Misc

(define am-lbl #f)
(define am-ret #f)
(define am-mov #f)
(define am-lda default-lda)

(define am-check-narg default-check-narg)
(define am-set-narg   default-set-narg)
(define am-poll       default-poll)
(define make-opnd     default-make-opnd)

;; ***** AM: Instructions: Arithmetic

(define am-cmp #f)
(define am-add #f)
(define am-sub #f)

;; ***** AM: Instructions: Boolean arithmetic

(define am-not  #f)
(define am-and  #f)
(define am-or   #f)
(define am-xor  #f)
(define am-test #f)

;; ***** AM: Instructions: Branch

;; Jump
(define am-jmp   #f)
;; Call (Branch and link). Has default implementation
(define am-jmplink default-jmplink)

;; Equal
(define am-je    #f)
(define am-jne   #f)
;; Signed
(define am-jg    #f) ;; Greater. Equivalent to: less or equal
(define am-jng   #f) ;; Not greater
(define am-jge   #f) ;; Greater or equal. Equivalent to: not less
(define am-jnge  #f) ;; Not greater or equal. Equivalent to: less
;; Unsigned
(define am-jgu   #f) ;; Greater
(define am-jngu  #f) ;; Not greater
(define am-jgeu  #f) ;; Greater or equal
(define am-jngeu #f) ;; Not greater or equal

;; ***** AM: Data

(define am-db #f)
(define am-dw #f)
(define am-dd #f)
(define am-dq #f)

;; ***** AM: Default implementations

(define (default-lda cgc reg opnd)
  (debug "default-lda\n")
  (cond
    ((mem-opnd? opnd)
      (am-mov cgc reg (int-opnd (mem-opnd-offset opnd)))
      (am-add cgc reg (mem-opnd-reg opnd)))
    (else
      (compiler-internal-error
        "default-lda: Unknown opnd" opnd))))

(define (default-jmplink cgc opnd)
  (am-mov cgc (get-register 0) opnd)
  (am-jmp opnd))

(define (default-check-narg cgc narg)
  (debug "default-check-narg: " narg "\n")
  (let ((opnd (load-opnd-if-necessary cgc (thread-descriptor 'narg))))
    (am-cmp cgc opnd (int-opnd narg))
    (am-jne cgc WRONG_NARGS_LBL)))

(define (default-set-narg cgc narg)
  (debug "default-set-narg: " narg "\n")
  (am-mov cgc (thread-descriptor 'narg) (int-opnd narg)))

(define (default-poll cgc code)
  ;; Reminder: sp is the real stack pointer and fp is the simulated stack pointer
  ;; In memory
  ;; +++: underflow location
  ;; ++ : fp
  ;; +  : sp
  ;; 0  :
  ;; sp < fp < underflow
  (define (check-overflow)
    (debug "check-overflow\n")
    (am-cmp cgc fp sp)
    (am-jngu cgc OVERFLOW_LBL))
  (define (check-underflow)
    (debug "check-underflow\n")
    (let ((opnd (load-opnd-if-necessary cgc (thread-descriptor 'underflow-position))))
      (am-cmp cgc opnd fp)
      (am-jnge cgc UNDERFLOW_LBL)))

  (define (check-interrupt)
    (debug "check-interrupt\n")
    (let ((opnd (load-opnd-if-necessary cgc (thread-descriptor 'interrupt-flag))))
      ;; Todo: Compare exec time for 1 byte vs 8 bytes opnd
      (am-cmp cgc opnd (int-opnd 0) word-width)
      (am-jnge cgc INTERRUPT_LBL)))

  (debug "default-poll\n")
  (let ((gvm-instr (code-gvm-instr code))
        (fs-gain (proc-frame-slots-gained code)))
    (if (and (jump-poll? gvm-instr) enable-poll)
      (begin
        (cond
          ((< 0 fs-gain) (check-overflow))
          ((> 0 fs-gain) (check-underflow)))
        (check-interrupt)))))

(define (default-make-opnd cgc proc code opnd context)
  (define (make-obj val)
    (debug "make-obj")
    (cond
      ((proc-obj? val)
        (if (eqv? context 'jump)
          ;; 1 is used to get the first label of a procedure, if it exists.
          ;; If not 1, the procedure will look like a primitive that was used
          ;; but not defined and it will look for a primitive called the name
          ;; of the procedure. It crashes the program, DO NOT CHANGE!
          (get-proc-label cgc (obj-val opnd) 1)
          (lbl-opnd (get-proc-label cgc (obj-val opnd) 1))))
      ((immediate-desc? (get-object-description val))
          (int-opnd
            (car (format-object (get-object-description val) val))
            word-width))
      ((reference-desc? (get-object-description val))
        (if (eqv? context 'jump)
          (make-object-label cgc (obj-val opnd))
          (lbl-opnd
            (make-object-label cgc (obj-val opnd))
            (get-desc-pointer-tag (get-object-description val)))))
      (else
        (compiler-internal-error "default-make-opnd: Unknown object type"))))
  (cond
    ((reg? opnd)
      (debug "reg\n")
      (get-register (reg-num opnd)))
    ((stk? opnd)
      (debug "stk\n")
      (if (eqv? context 'jump)
        (frame cgc (proc-jmp-frame-size code) (stk-num opnd))
        (frame cgc (proc-lbl-frame-size code) (stk-num opnd))))
    ((lbl? opnd)
      (debug "lbl\n")
      ;;todo : Check if correct.
      (if (eqv? context 'jump)
        (get-proc-label cgc proc (lbl-num opnd))
        (lbl-opnd (get-proc-label cgc proc (lbl-num opnd)))))
    ((obj? opnd)
      (debug "obj\n")
      (make-obj (obj-val opnd)))
    ((glo? opnd)
      (debug "glo\n")
      (compiler-internal-error "default-make-opnd: Opnd not implementeted global"))
    ((clo? opnd)
      (debug "clo\n")
      (compiler-internal-error "default-make-opnd: Opnd not implementeted closure"))
    (else
      (compiler-internal-error "default-make-opnd: Unknown opnd: " opnd))))

;; ***** AM: Label table

;; Key: Label id
;; Value: Pair (Label, optional Proc-obj)
(define (reset-proc-labels) (set! proc-labels (make-table test: equal?)))
(define proc-labels (make-table test: equal?))

(define (get-proc-label cgc proc gvm-lbl)
  (define (nat-label-ref label-id)
    (let ((x (table-ref proc-labels label-id #f)))
      (if x
          (car x)
          (let ((l (asm-make-label cgc label-id)))
            (table-set! proc-labels label-id (list l proc))
            l))))

  (let* ((id (if gvm-lbl gvm-lbl 0))
         (label-id (lbl->id id (proc-obj-name proc))))
    (nat-label-ref label-id)))

;; Useful for branching
(define (make-unique-label cgc suffix?)
  (let* ((id (get-unique-id))
         (suffix (if suffix? suffix? "other"))
         (label-id (lbl->id id suffix))
         (l (asm-make-label cgc label-id)))
    (table-set! proc-labels label-id (list l #f))
    l))

(define (lbl->id num proc_name)
  (string->symbol (string-append "_proc_"
                                 (number->string num)
                                 "_"
                                 proc_name)))

; ***** AM: Object table and object creation

(define (reset-obj-labels) (set! obj-labels (make-table test: equal?)))
(define obj-labels (make-table test: equal?))

;; Store object reference or as int ???
(define (make-object-label cgc obj)
  (define (obj->id)
    (string->symbol (string-append "_obj_" (number->string (get-unique-id)))))

  (let* ((x (table-ref obj-labels obj #f)))
    (if x
        x
        (let* ((label (asm-make-label cgc (obj->id))))
          (table-set! obj-labels obj label)
          label))))

;; Provides unique ids
;; No need for randomness or UUID
;; *** Obviously, NOT thread safe ***
(define unique-id 0)
(define (get-unique-id)
  (set! unique-id (+ unique-id 1))
  unique-id)

;; ***** AM: Important labels

(define (reset-labels)
  (set! THREAD_DESCRIPTOR (asm-make-label cgc 'THREAD_DESCRIPTOR))
  (set! C_START_LBL (asm-make-label cgc 'C_START_LBL))
  (set! C_RETURN_LBL (asm-make-label cgc 'C_RETURN_LBL))
  (set! WRONG_NARGS_LBL (asm-make-label cgc 'WRONG_NARGS_LBL))
  (set! OVERFLOW_LBL (asm-make-label cgc 'OVERFLOW_LBL))
  (set! UNDERFLOW_LBL (asm-make-label cgc 'UNDERFLOW_LBL))
  (set! INTERRUPT_LBL (asm-make-label cgc 'INTERRUPT_LBL))
  (set! TEST_CODE_LBL (asm-make-label cgc 'TEST_CODE_LBL))
  (set! TYPE_ERROR_LBL (asm-make-label cgc 'TYPE_ERROR_LBL))
  (set! TEST_DATA_LBL (asm-make-label cgc 'TEST_DATA)))

(define THREAD_DESCRIPTOR (asm-make-label cgc 'THREAD_DESCRIPTOR))
(define C_START_LBL (asm-make-label cgc 'C_START_LBL))
(define C_RETURN_LBL (asm-make-label cgc 'C_RETURN_LBL))
(define TEST_CODE_LBL (asm-make-label cgc 'TEST_CODE_LBL))

;; Exception handling procedures
(define WRONG_NARGS_LBL (asm-make-label cgc 'WRONG_NARGS_LBL))
(define OVERFLOW_LBL (asm-make-label cgc 'OVERFLOW_LBL))
(define UNDERFLOW_LBL (asm-make-label cgc 'UNDERFLOW_LBL))
(define INTERRUPT_LBL (asm-make-label cgc 'INTERRUPT_LBL))
(define TYPE_ERROR_LBL (asm-make-label cgc 'TYPE_ERROR_LBL))

(define TEST_DATA_LBL (asm-make-label cgc 'TEST_DATA))

;; ***** AM: Implementation constants

(define stack-size 10000) ;; Scheme stack size (bytes)
;; 500 is the safe minimum for (fib 40)
(define thread-descriptor-size 32) ;; Thread descriptor size (bytes)
(define stack-underflow-padding 128) ;; Prevent underflow from writing thread descriptor (bytes)
(define frame-offset 1) ;; stack offset so that frame[1] is at null offset from fp
(define runtime-result-register #f)

;; 64 = 01000000_2 = 0x40. -64 = 11000000_2 = 0xC0
;; 0xC0 unsigned = 192
(define na-reg-default-value -64)
(define na-reg-default-value-abs 192)

(define na #f) ;; number of arguments register
(define sp #f) ;; Real stack limit
(define fp #f) ;; Simulated stack current pos
(define dp #f) ;; Thread descriptor register

;; Registers that map directly to GVM registers
(define main-registers #f)
;; Registers that can be overwritten at any moment!
;; Used when need extra register. Has to have at least 3 register.
(define work-registers #f)

;; ***** AM: Helper functions

(define (get-register n)
  (list-ref main-registers n))

(define (get-extra-register n)
  (list-ref work-registers n))

(define (alloc-frame cgc n)
  (if (not (= 0 n))
    (am-sub cgc fp (int-opnd (* n word-width-bytes)))))

(define (frame cgc fs n)
  (mem-opnd (* (+ fs (- n) frame-offset) word-width-bytes) fp))

;; Can return either a memory location or a register
(define (thread-descriptor sym)
  (let ((opnd
          (case sym
            ('underflow-position (* 0 word-width-bytes))
            ('interrupt-flag (* 1 word-width-bytes))
            ('narg      (* 2 word-width-bytes))
            (else (compiler-internal-error "Unknown thread-descriptor symbol:" sym)))))

    ;; (not (fixnum? opnd)) <=> not mem-opnd
    (if (fixnum? opnd)
      (mem-opnd (- opnd na-reg-default-value-abs) dp)
      opnd)))

(define (load-opnd-if-necessary cgc opnd-to-load #!optional (register-index 0))
  (if load-store-only
    (begin
      (am-mov cgc (get-extra-register register-index) opnd-to-load)
      (get-extra-register register-index))
    opnd-to-load))

(define (reserve-space cgc bytes #!optional (value 0))
  (if (> bytes 0)
    (begin
      (am-db cgc value)
      (reserve-space cgc (- bytes 1) value))))

;; ***** Utils

(define (reset-state)
  (reset-proc-labels)
  (reset-obj-labels)
  (reset-labels))

(define (opnd-type opnd)
  (cond
    ((reg-opnd? opnd) 'reg)
    ((mem-opnd? opnd) 'mem)
    ((lbl-opnd? opnd) 'lbl)
    ((int-opnd? opnd) 'int)))

;; Get appropriate am-db, am-dw, am-dd, am-dq
(define (am-data-width width)
  (case width
    ((8)  am-db)
    ((16) am-dw)
    ((32) am-dd)
    ((64) am-dq)
    (else (compiler-internal-error "am-data-width - Unknown width: " width))))

;; ***** Routines

;; Places data used by the default functions
(define (am-place-data-routine cgc)
  ;; Thread descriptor reserved space
  ;; Aligns address to 2^8 so the 8 least significant bits are 0
  ;; The 8 lower bytes can be used to store something else. ie: narg
  ;; Also, it aligns descriptor to cache lines.
  ;; ##Check if it changes something## Does nothing!!!
  (asm-align cgc 256)
  (am-lbl cgc THREAD_DESCRIPTOR)
  (reserve-space cgc thread-descriptor-size 0)) ;; Reserve space for thread-descriptor-size bytes