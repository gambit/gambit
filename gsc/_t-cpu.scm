;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2011-2017 by Marc Feeley, All Rights Reserved.

(include "generic.scm")
(include "_utils.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;-----------------------------------------------------------------------------

;; Some functions for generating and executing machine code.

;; The function u8vector->procedure converts a u8vector containing a
;; sequence of bytes into a Scheme procedure that can be called.
;; The code in the u8vector must obey the C calling conventions of
;; the host architecture.

(define (u8vector->procedure code fixups)
 (machine-code-block->procedure
  (u8vector->machine-code-block code fixups)))

(define (u8vector->machine-code-block code fixups)
 (let* ((len (u8vector-length code))
        (mcb (##make-machine-code-block len)))
   (let loop ((i (fx- len 1)))
     (if (fx>= i 0)
         (begin
           (##machine-code-block-set! mcb i (u8vector-ref code i))
           (loop (fx- i 1)))
         (apply-fixups mcb fixups)))))

;; Add mcb's base address to every label that needs to be fixed up.
;; Currently assumes 32 bit width.
(define (apply-fixups mcb fixups)
  (let ((base-addr (##foreign-address mcb)))
    (let loop ((fixups fixups))
      (if (null? fixups)
          mcb
          (let* ((pos (asm-label-pos (caar fixups)))
                 (size (quotient (cdar fixups) 8))
                 (n (+ base-addr (machine-code-block-int-ref mcb pos size))))
            (machine-code-block-int-set! mcb pos size n)
            (loop (cdr fixups)))))))

(define (machine-code-block-int-ref mcb start size)
  (let loop ((n 0) (i (- size 1)))
    (if (>= i 0)
        (loop (+ (* n 256) (##machine-code-block-ref mcb (+ start i)))
              (- i 1))
        n)))

(define (machine-code-block-int-set! mcb start size n)
  (let loop ((n n) (i 0))
    (if (< i size)
        (begin
          (##machine-code-block-set! mcb (+ start i) (modulo n 256))
          (loop (quotient n 256) (+ i 1))))))

(define (machine-code-block->procedure mcb)
  (lambda (#!optional (arg1 0) (arg2 0) (arg3 0))
    (##machine-code-block-exec mcb arg1 arg2 arg3)))

(define (time-cgc cgc)
  (let* ((code (asm-assemble-to-u8vector cgc))
         (fixups (codegen-context-fixup-list cgc))
         (procedure (u8vector->procedure code fixups)))
    (display "time-cgc: \n\n\n\n")
    (asm-display-listing cgc (current-error-port) #f)
    (pp (time (procedure)))))

;;;----------------------------------------------------------------------------
;;
;; "CPU" back-end that targets hardware processors.

;; Initialization/finalization of back-end.

(define (cpu-setup
         target-arch
         file-extensions
         max-nb-gvm-regs
         default-nb-gvm-regs
         default-nb-arg-regs
         semantics-changing-options
         semantics-preserving-options)

  (define common-semantics-changing-options
    '())

  (define common-semantics-preserving-options
    '((asm symbol)))

  (let ((targ
         (make-target 12
                      target-arch
                      file-extensions
                      (append semantics-changing-options
                              common-semantics-changing-options)
                      (append semantics-preserving-options
                              common-semantics-preserving-options)
                      0)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf module-descr unique-name)
         (cpu-dump targ
                   procs
                   output
                   c-intf
                   module-descr
                   unique-name
                   sem-changing-opts
                   sem-preserving-opts)))

      (target-link-info-set!
       targ
       (lambda (file)
         (cpu-link-info targ file)))

      (target-link-set!
       targ
       (lambda (extension? inputs output warnings?)
         (cpu-link targ extension? inputs output warnings?)))

      (target-prim-info-set! targ cpu-prim-info)

      (target-frame-constraints-set!
       targ
       (make-frame-constraints
        cpu-frame-reserve
        cpu-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

      (target-task-return-set!
       targ
       (make-reg 0))

      (target-switch-testable?-set!
       targ
       (lambda (obj)
         (cpu-switch-testable? targ obj)))

      (target-eq-testable?-set!
       targ
       (lambda (obj)
         (cpu-eq-testable? targ obj)))

      (target-object-type-set!
       targ
       (lambda (obj)
         (cpu-object-type targ obj)))

      (cpu-set-nb-regs targ sem-changing-opts max-nb-gvm-regs)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(cpu-setup 'x86-32 '((".s" . X86-32))  5 5 3 '() '())
(cpu-setup 'x86-64 '((".s" . X86-64)) 13 5 3 '() '())
(cpu-setup 'arm    '((".s" . ARM))    13 5 3 '() '())

;;;----------------------------------------------------------------------------

;; ***** REGISTERS AVAILABLE

;; The registers available in the virtual machine default to
;; cpu-default-nb-gvm-regs and cpu-default-nb-arg-regs but can be
;; changed with the gsc options -nb-gvm-regs and -nb-arg-regs.
;;
;; nb-gvm-regs = total number of registers available
;; nb-arg-regs = maximum number of arguments passed in registers

(define cpu-default-nb-gvm-regs 5)
(define cpu-default-nb-arg-regs 3)

(define (cpu-set-nb-regs targ sem-changing-opts max-nb-gvm-regs)
  (let ((nb-gvm-regs
         (get-option sem-changing-opts
                     'nb-gvm-regs
                     cpu-default-nb-gvm-regs))
        (nb-arg-regs
         (get-option sem-changing-opts
                     'nb-arg-regs
                     cpu-default-nb-arg-regs)))

    (if (not (and (<= 3 nb-gvm-regs)
                  (<= nb-gvm-regs max-nb-gvm-regs)))
        (compiler-error
         (string-append "-nb-gvm-regs option must be between 3 and "
                        (number->string max-nb-gvm-regs))))

    (if (not (and (<= 1 nb-arg-regs)
                  (<= nb-arg-regs (- nb-gvm-regs 2))))
        (compiler-error
         (string-append "-nb-arg-regs option must be between 1 and "
                        (number->string (- nb-gvm-regs 2)))))

    (target-nb-regs-set! targ nb-gvm-regs)
    (target-nb-arg-regs-set! targ nb-arg-regs)))

;;;----------------------------------------------------------------------------

;; The frame constraints are defined by the parameters
;; cpu-frame-reserve and cpu-frame-alignment.

(define cpu-frame-reserve 0) ;; no extra slots reserved
(define cpu-frame-alignment 1) ;; no alignment constraint

;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define (cpu-label-info targ nb-params closed?)
  ((target-label-info targ) nb-params closed?))

(define (cpu-jump-info targ nb-args)
  ((target-jump-info targ) nb-args))

;;;----------------------------------------------------------------------------

;; ***** PRIMITIVE PROCEDURE DATABASE

(define cpu-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
     (lambda (x) (prim-proc-add! t x))
     '())
    t))

(define (cpu-prim-info name)
  (prim-proc-info cpu-prim-proc-table name))

(define (cpu-get-prim-info name)
  (let ((proc (cpu-prim-info (string->canonical-symbol name))))
    (if proc
        proc
        (compiler-internal-error
         "cpu-get-prim-info, unknown primitive:" name))))

;;;----------------------------------------------------------------------------

;; ***** OBJECT PROPERTIES

(define (cpu-switch-testable? targ obj)
  ;;(pretty-print (list 'cpu-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cpu-eq-testable? targ obj)
  ;;(pretty-print (list 'cpu-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cpu-object-type targ obj)
  ;;(pretty-print (list 'cpu-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;

;;;----------------------------------------------------------------------------

;; ***** LINKING

(define (cpu-link-info file)
  (pretty-print (list 'cpu-link-info file))
  #f)

(define (cpu-link extension? inputs output warnings?)
  (pretty-print (list 'cpu-link extension? inputs output warnings?))
  #f)

;;;----------------------------------------------------------------------------

;; ***** INLINING OF PRIMITIVES

(define (cpu-inlinable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-inlinable?-set! prim (lambda (env) #t))))

(define (cpu-testable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-testable?-set! prim (lambda (env) #t))))

(define (cpu-jump-inlinable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-jump-inlinable?-set! prim (lambda (env) #t))))

(cpu-inlinable "##fx+")
(cpu-inlinable "##fx-")

(cpu-testable "##fx<")

;;;----------------------------------------------------------------------------

;; ***** DUMPING OF A COMPILATION MODULE

(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  unique-name
                  sem-changing-options
                  sem-preserving-options)

  (pretty-print (list 'cpu-dump
                      (target-name targ)
                      (map proc-obj-name procs)
                      output
                      unique-name))

  (let ((port (current-output-port)))
      (virtual.dump-gvm procs port)
      (dispatch-target targ procs output c-intf module-descr unique-name sem-changing-options sem-preserving-options)
  #f))

;;;----------------------------------------------------------------------------

;; ***** Dispatching

(define (dispatch-target targ
                         procs
                         output
                         c-intf
                         module-descr
                         unique-name
                         sem-changing-options
                         sem-preserving-options)
  (let* ((arch (target-name targ))
          (handler (case arch
                  ('x86-32  x86-backend)
                  ('x86-64  x86-64-backend)
                  ('arm     armv8-backend)
                  (else (compiler-internal-error "dispatch-target, unsupported target: " arch))))
          (cgc (make-codegen-context)))

    (codegen-context-listing-format-set! cgc 'gnu)

    (handler
      targ procs output c-intf
      module-descr unique-name
      sem-changing-options sem-preserving-options
      cgc)

    (time-cgc cgc)))

;;;----------------------------------------------------------------------------

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
;;  Default methods are given if possible
;;
;;
;;  In case the native architecture is load-store, set load-store-only to true.
;;  The am-mov instruction acts like both load and store.
;;
;;
;;  The following non-branching instructions are required:
;;    am-label: Place label
;;    am-ret  : Exit program
;;    am-mov  : Move value between 2 registers/memory/immediate
;;    am-cmp  : Compare 2 operands. Sets flag
;;    am-add  : (Add imm/reg to register). If load-store-only, mem can be used as opn
;;    am-sub  : (Add imm/reg to register). If load-store-only, mem can be used as opn
;;    ...
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

(define int-opnd-value #f)
(define lbl-opnd-offset #f)
(define lbl-opnd-label #f)
(define mem-opnd-offset #f)
(define mem-opnd-reg #f)

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
  (load-mem-if-necessary cgc (thread-descriptor narg-offset)
    (lambda (opnd)
      (am-cmp cgc opnd (int-opnd narg))
      (am-jne cgc WRONG_NARGS_LBL))))
  ; (if load-store-only
  ;   (begin
  ;     (am-mov cgc (get-extra-register 0) (thread-descriptor narg-offset))
  ;     )
  ;   (begin
  ;     (am-cmp cgc (thread-descriptor narg-offset) (int-opnd narg))
  ;     (am-jne cgc WRONG_NARGS_LBL))))

(define (default-set-narg cgc narg)
  (debug "default-set-narg: " narg "\n")
  (am-mov cgc (thread-descriptor narg-offset) (int-opnd narg)))

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
    (load-mem-if-necessary cgc (thread-descriptor underflow-position-offset)
      (lambda (opnd)
        (am-cmp cgc opnd fp)
        (am-jnge cgc UNDERFLOW_LBL))))
  (define (check-interrupt)
    (debug "check-interrupt\n")
    (load-mem-if-necessary cgc (thread-descriptor interrupt-offset)
      (lambda (opnd)
        (am-cmp cgc opnd (int-opnd 0) word-width)
        (am-jnge cgc INTERRUPT_LBL))))

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
    (cond
      ((fixnum? val)
        (int-opnd (tag-number val tag-mult fixnum-tag) word-width))
      ((null? val)
        (int-opnd (tag-number nil-object-val tag-mult special-int-tag) word-width))
      ((boolean? val)
        (int-opnd
          (if val
            (tag-number true-object-val  tag-mult special-int-tag)
            (tag-number false-object-val tag-mult special-int-tag)) word-width))
      ((proc-obj? val)
        (if (eqv? context 'jump)
          (get-proc-label cgc (obj-val opnd) 1)
          (lbl-opnd (get-proc-label cgc (obj-val opnd) 1))))
      ((string? val)
        (if (eqv? context 'jump)
          (make-object-label cgc (obj-val opnd))
          (lbl-opnd (make-object-label cgc (obj-val opnd)))))
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
      (if (eqv? context 'jump)
        (get-proc-label cgc proc (lbl-num opnd))
        (lbl-opnd (get-proc-label cgc proc (lbl-num opnd)))))
    ((obj? opnd)
      (debug "obj\n")
      (make-obj (obj-val opnd)))
    ((glo? opnd)
      (debug "glo: " (glo-name opnd) "\n")
      (compiler-internal-error "default-make-opnd: Opnd not implementeted global"))
    ((clo? opnd)
      (compiler-internal-error "default-make-opnd: Opnd not implementeted closure"))
    (else
      (compiler-internal-error "default-make-opnd: Unknown opnd: " opnd))))

;; ***** AM: Label table

;; Key: Label id
;; Value: Pair (Label, optional Proc-obj)
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
(define id 0)
(define (get-unique-id)
  (set! id (+ id 1))
  id)

;; ***** AM: Important labels

(define THREAD_DESCRIPTOR (asm-make-label cgc 'THREAD_DESCRIPTOR))
(define C_START_LBL (asm-make-label cgc 'C_START_LBL))
(define C_RETURN_LBL (asm-make-label cgc 'C_RETURN_LBL))
;; Exception handling procedures
(define WRONG_NARGS_LBL (asm-make-label cgc 'WRONG_NARGS_LBL))
(define OVERFLOW_LBL (asm-make-label cgc 'OVERFLOW_LBL))
(define UNDERFLOW_LBL (asm-make-label cgc 'UNDERFLOW_LBL))
(define INTERRUPT_LBL (asm-make-label cgc 'INTERRUPT_LBL))

;; ***** AM: Implementation constants

(define stack-size 10000) ;; Scheme stack size (bytes)
(define thread-descriptor-size 256) ;; Thread descriptor size (bytes) (Probably too much)
(define stack-underflow-padding 128) ;; Prevent underflow from writing thread descriptor (bytes)
(define offs 1) ;; stack offset so that frame[1] is at null offset from fp
(define runtime-result-register #f)

;; Thread descriptor offsets:
(define underflow-position-offset 8)
(define interrupt-offset 16)
(define narg-offset 24)

;; 64 = 01000000_2 = 0x40. -64 = 11000000_2 = 0xC0
;; 0xC0 unsigned = 192
(define na-reg-default-value -64)
(define na-reg-default-value-abs 192)

;; Pointer tagging constants
(define fixnum-tag 0)
(define object-tag 1)
(define special-int-tag 2)
(define pair-tag 3)

(define tag-mult 4)

;; Special int values
(define false-object-val 0) ;; Default value for false
(define true-object-val -1) ;; Default value for true
(define eof-object-val -100)
(define nil-object-val -1000)

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
  (mem-opnd (* (+ fs (- n) offs) 8) fp))

(define (thread-descriptor offset)
  (mem-opnd (- offset na-reg-default-value-abs) dp))

(define (tag-number val mult tag)
  (+ (* mult val) tag))

(define (load-mem-if-necessary cgc mem-to-load f)
  (if load-store-only
    (begin
      (am-mov cgc (get-extra-register 0) mem-to-load)
      (f (get-extra-register 0)))
    (f mem-to-load)))

(define (opnd-type opnd)
  (cond
    ((reg-opnd? opnd) 'reg)
    ((mem-opnd? opnd) 'mem)
    ((lbl-opnd? opnd) 'lbl)
    ((int-opnd? opnd) 'int)))

;;;----------------------------------------------------------------------------

;; ***** x64 code generation

(define (x86-64-backend targ
                        procs
                        output
                        c-intf
                        module-descr
                        unique-name
                        sem-changing-options
                        sem-preserving-options
                        cgc)

  (define (encode-proc proc)
    (map-proc-instrs
      (lambda (code)
        (encode-gvm-instr cgc proc code))
      proc))

  (debug "x86-64-backend\n")
  (asm-init-code-block cgc 0 'le)
  (x86-arch-set! cgc 'x86-64)
  (x64-setup)

  (add-start-routine cgc)
  (map-on-procs encode-proc procs)
  (add-end-routine cgc))

(define (x64-setup)
  (define (register-setup)
    (set! main-registers
      (list (x86-r15) (x86-r14) (x86-r13) (x86-r12) (x86-r11) (x86-r10)))
    (set! work-registers
      (list (x86-r9) (x86-r8)))
    (set! na (x86-cl))
    (set! sp (x86-rsp))
    (set! fp (x86-rdx))
    (set! dp (x86-rcx))
    (set! runtime-result-register (x86-rax)))

  (define (opnds-setup)
    (set! int-opnd x86-imm-int)
    (set! lbl-opnd x86-imm-lbl)
    (set! mem-opnd x86-mem)

    ;; Copied from _x86.scm
    (set! int-opnd? (lambda (x) (and (pair? x) (number? (cdr x)))))
    (set! lbl-opnd? (lambda (x) (and (pair? x) (vector? (cdr x)))))
    (set! mem-opnd? (lambda (x) (and (vector? x) (fx= (vector-length x) 4))))
    (set! reg-opnd? fixnum?)

    (set! int-opnd-value  (lambda (x) (cdr x)))
    (set! lbl-opnd-offset (lambda (x) (car x)))
    (set! lbl-opnd-label  (lambda (x) (cdr x)))
    (set! mem-opnd-offset (lambda (x) (vector-ref x 0)))
    (set! mem-opnd-reg    (lambda (x) (vector-ref x 1))))

  (define (instructions-setup)
    (set! am-lbl x86-label)
    (set! am-mov
      (wrap-function x86-mov
        (list
          (make-rule
            "mov R 0 -> xor R R"
            (all-rules (match-reg 1 #f) (match-int 2 0))
            x86-xor
            (reorganize-args '(0 1 1))))))
    (set! am-lda x86-lea)
    (set! am-ret x86-ret)
    (set! am-cmp x86-cmp)
    (set! am-add
      (wrap-function x86-add
        (list
          (make-rule "add _ 0 -> nop" (match-int 2 0) NOP)
          (make-rule "add _ 1 -> inc _" (match-int 2 1) x86-inc (reorganize-args '(0 1))))))
    (set! am-sub x86-sub)

    (set! am-jmp    x86-jmp)
    ; (set! am-jmplink  doesnt-exist)
    (set! am-je     x86-je)
    (set! am-jne    x86-jne)
    (set! am-jg     x86-jg)
    (set! am-jng    x86-jle)
    (set! am-jge    x86-jge)
    (set! am-jnge   x86-jl)
    (set! am-jgu    x86-ja)
    (set! am-jngu   x86-jbe)
    (set! am-jgeu   x86-jae)
    (set! am-jngeu  x86-jb))

  (define (data-setup)
    (set! am-db x86-db)
    (set! am-dw x86-dw)
    (set! am-dd x86-dd)
    (set! am-dq x86-dq))

  (define (helper-setup)
    (set! am-set-narg   x64-set-narg)
    (set! am-check-narg x64-check-narg)
    ; (set! am-poll default-poll)
    ; (set! make-opnd default-make-opnd)
  )

  (define (make-parity-adjusted-valued n)
    (define (bit-count n)
      (if (= n 0)
        0
        (+ (modulo n 2) (bit-count (quotient n 2)))))
    (let* ((narg2 (* 2 (- n 3)))
          (bits (bit-count narg2))
          (parity (modulo bits 2)))
      (+ 64 parity narg2)))

  (define (x64-check-narg cgc narg)
    (debug "x64-check-narg: " narg "\n")
    (cond
      ((= narg 0)
        (am-jne cgc WRONG_NARGS_LBL))
      ((= narg 1)
        (x86-jp cgc WRONG_NARGS_LBL))
      ((= narg 2)
        (x86-jno cgc WRONG_NARGS_LBL))
      ((= narg 3)
        (x86-jns cgc WRONG_NARGS_LBL))
      ((<= narg 34)
          (am-sub cgc na (int-opnd (make-parity-adjusted-valued narg)))
          (am-jne cgc WRONG_NARGS_LBL))
      (else
        (default-check-narg cgc narg))))

  (define (x64-set-narg cgc narg)
    (debug "x64-set-narg: " narg "\n")
    (cond
      ((= narg 0)
        (am-cmp cgc na na))
      ((= narg 1)
        (am-cmp cgc na (int-opnd -65)))
      ((= narg 2)
        (am-cmp cgc na (int-opnd 66)))
      ((= narg 3)
        (am-cmp cgc na (int-opnd 0)))
      ((<= narg 34)
          (am-add cgc na (int-opnd (make-parity-adjusted-valued narg))))
      (else
        (default-set-narg cgc narg))))

  (debug "x64-setup\n")

  (set! load-store-only #f)
  (set! enable-poll #t)
  (register-setup)
  (opnds-setup)
  (instructions-setup)
  (data-setup)
  (helper-setup))

;; ***** Environment code and primitive functions

(define (add-start-routine cgc)
  (debug "add-start-routine\n")

  (am-lbl cgc C_START_LBL) ;; Initial procedure label
  ;; Thread descriptor initialization
  ;; Set thread descriptor address
  (am-mov cgc dp (lbl-opnd THREAD_DESCRIPTOR))
  ;; Set lower bytes of descriptor register used for passing narg
  (am-mov cgc na (int-opnd na-reg-default-value word-width))
  ;; Set underflow position to current stack pointer position
  (am-mov cgc (thread-descriptor underflow-position-offset) sp)
  ;; Set interrupt flag to current stack pointer position
  (am-mov cgc (thread-descriptor interrupt-offset) (int-opnd 0) word-width)

  (am-mov cgc (get-register 0) (lbl-opnd C_RETURN_LBL)) ;; Set return address for main
  (am-lda cgc fp (mem-opnd (* offs (- word-width-bytes)) sp)) ;; Align frame with offset
  (am-sub cgc sp (int-opnd stack-size)) ;; Allocate space for stack
  (am-set-narg cgc 0))

(define (add-end-routine cgc)
  (debug "add-end-routine\n")

  ;; Terminal procedure
  (am-lbl cgc C_RETURN_LBL)
  (am-add cgc sp (int-opnd stack-size))
  (am-mov cgc runtime-result-register (get-register 1))
  (am-ret cgc) ;; Exit program

  ;; Incorrect narg handling
  (am-lbl cgc WRONG_NARGS_LBL)
  ;; Overflow handling
  (am-lbl cgc OVERFLOW_LBL)
  ;; Underflow handling
  (am-lbl cgc UNDERFLOW_LBL)
  ;; Interrupts handling
  (am-lbl cgc INTERRUPT_LBL)
  ;; Pop stack
  (am-mov cgc fp (thread-descriptor underflow-position-offset))
  (am-mov cgc (get-register 0) (int-opnd -1)) ;; Error value
  ;; Pop remaining stack (Everything allocated but stack size
  (am-add cgc sp (int-opnd stack-size))
  (am-mov cgc runtime-result-register (int-opnd -4))
  (am-ret cgc 0)

  ;; Thread descriptor reserved space
  ;; Aligns address to 2^8 so the 8 least significant bits are 0
  ;; The 8 lower bytes can be used to store something else. ie: narg
  ;; Also, it aligns descriptor to cache lines. todo: Check if it changes something
  (asm-align cgc 256)
  (am-lbl cgc THREAD_DESCRIPTOR)
  (reserve-space cgc thread-descriptor-size 0) ;; Reserve space for thread-descriptor-size bytes

  ;; Add primitives
  (table-for-each
    (lambda (key val) (put-primitive-if-needed cgc key val))
    proc-labels)
  ;; Add objects
  (table-for-each
    (lambda (key val) (put-objects cgc key val))
    obj-labels)
)

;; Value is Pair (Label, optional Proc-obj)
(define (put-primitive-if-needed cgc key pair)
  (debug "put-primitive-if-needed\n")
  (let* ((label (car pair))
          (proc (cadr pair))
          (defined? (or (vector-ref label 1) (not proc)))) ;; See asm-label-pos (Same but without error if undefined)
    (if (not defined?)
      (let ((prim (get-prim-obj (proc-obj-name proc))))
          ;; todo: Complete here
          (am-lbl cgc label)
          (prim cgc (then-return) (get-register 1) (get-register 2) (get-register 3) (get-register 4)) ;; todo : Find way to get arity
        ))))

(define (put-objects cgc obj label)
  (debug "put-objects\n")
  (debug "label: " label)

  (am-lbl cgc label)

  (cond
    ((string? obj)
      (debug "Obj: " obj "\n")
      ;; Header: 158 (0x9E) + 256 * char_size(default:4) * length
      (am-dd cgc (+ 158 (* (* 256 4) (string-length obj))))
      ;; String content=
      (apply am-dd (cons cgc (map char->integer (string->list obj)))))
    (else
      (compiler-internal-error "put-objects: Unknown object type"))))

;; ***** x64 : GVM Instruction encoding

(define (encode-gvm-instr cgc proc code)
  ; (debug "encode-gvm-instr\n")
  (case (gvm-instr-type (code-gvm-instr code))
    ((label)  (encode-label-instr   cgc proc code))
    ((jump)   (encode-jump-instr    cgc proc code))
    ((ifjump) (encode-ifjump-instr  cgc proc code))
    ((apply)  (encode-apply-instr   cgc proc code))
    ((copy)   (encode-copy-instr    cgc proc code))
    ((close)  (encode-close-instr   cgc proc code))
    ((switch) (encode-switch-instr  cgc proc code))
    (else
      (compiler-error
        "encode-gvm-instr, unknown 'gvm-instr-type':" (gvm-instr-type gvm-instr)))))

;; ***** Label instruction encoding

(define (encode-label-instr cgc proc code)
  (debug "encode-label-instr: ")
  (let* ((gvm-instr (code-gvm-instr code))
         (label-num (label-lbl-num gvm-instr))
         (label (get-proc-label cgc proc label-num))
         (narg (label-entry-nb-parms gvm-instr)))

  (debug label "\n")

  ;; Todo: Check if alignment is necessary for task-entry/return
  (if (not (eqv? 'simple (label-type gvm-instr)))
    (asm-align cgc 4 1 144))

    (am-lbl cgc label)

    (if (eqv? 'entry (label-type gvm-instr))
      (am-check-narg cgc narg))))

;; ***** (if)Jump instruction encoding

(define (encode-jump-instr cgc proc code)
  (debug "encode-jump-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
         (jmp-opnd (jump-opnd gvm-instr)))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (am-poll cgc code)

    ;; Save return address if necessary
    (if (jump-ret gvm-instr)
      (let* ((label-ret-num (jump-ret gvm-instr))
              (label-ret (get-proc-label cgc proc label-ret-num))
              (label-ret-opnd (lbl-opnd label-ret)))
        (am-mov cgc (get-register 0) label-ret-opnd)))

    ;; How to use am-jumplink (Branch with link like in ARM)
    ;; Problem: add-narg-set may change flag register
    ;; If isa support deactivating effects to register (Use global variable to toggle ex: (enable-flag-effects) (disable-flag-effects))
    ;;    Invert save-return-address and set-arg-count
    ;; Else, keep order

    ;; Set arg count
    (if (jump-nb-args gvm-instr)
      (am-set-narg cgc (jump-nb-args gvm-instr)))

    ;; Jump to location. Checks if jump is NOP.
    (let* ((label-num (label-lbl-num (bb-label-instr (code-bb code)))))
      (if (not (and (lbl? jmp-opnd) (= (lbl-num jmp-opnd) (+ 1 label-num))))
        (am-jmp cgc (make-opnd cgc proc code jmp-opnd 'jump))))))

(define (encode-ifjump-instr cgc proc code)
  (debug "encode-ifjump-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
          (true-label (get-proc-label cgc proc (ifjump-true gvm-instr)))
          (false-label (get-proc-label cgc proc (ifjump-false gvm-instr))))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (am-poll cgc code)

    (let* ((prim (get-prim-obj (proc-obj-name (ifjump-test gvm-instr))))
           (then (then-jump true-label false-label))
           (args (map (lambda (opnd) (make-opnd cgc proc code opnd #f)) (ifjump-opnds gvm-instr)))
           (opnds (append (list cgc then) args)))
      (apply prim opnds))))

;; ***** Apply instruction encoding

(define (encode-apply-instr cgc proc code)
  (debug "encode-apply-instr\n")
  (let ((gvm-instr (code-gvm-instr code)))

    (let* ((prim (get-prim-obj (proc-obj-name (apply-prim gvm-instr))))
           (then (then-move (make-opnd cgc proc code (apply-loc gvm-instr) #f)))
           (args (map (lambda (opnd) (make-opnd cgc proc code opnd #f)) (apply-opnds gvm-instr)))
           (opnds (append (list cgc then) args)))
      (apply prim opnds))))

;; ***** Copy instruction encoding

(define (encode-copy-instr cgc proc code)
  (debug "encode-copy-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
        (src (make-opnd cgc proc code (copy-opnd gvm-instr) #f))
        (dst (make-opnd cgc proc code (copy-loc gvm-instr) #f)))
    (am-mov cgc dst src word-width)))

;; ***** Close instruction encoding

(define (encode-close-instr cgc proc gvm-instr)
  (debug "encode-close-instr\n")
  (compiler-internal-error
    "x64-encode-close-instr: close instruction not implemented"))

;; ***** Switch instruction encoding

(define (encode-switch-instr cgc proc gvm-instr)
  (debug "encode-switch-instr\n")
  (compiler-internal-error
    "x64-encode-switch-instr: switch instruction not implemented"))

;; ***** x64 primitives

(define (get-prim-obj prim-name)
  (debug "get-prim-obj: " prim-name "\n")
  (case (string->symbol prim-name)
      ('##fx+ (x86-prim-fx+))
      ('##fx- (x86-prim-fx-))
      ('##fx< (x86-prim-fx<))
      ; ('##fx* (x86-prim-fx-))
      ; ('##fx/ (x86-prim-fx-))
      ; ('display (prim-info-display))
      (else
        (compiler-internal-error "Primitive not implemented: " prim-name))))

;;  A primitive is a function taking:
;;  CGC
;;  ResultAction
;;  Arguments
;;    ResultAction = Copy location-opnd | Branch true-jump-location false-jump-location | Return

(define (then-jump true-location false-location) (list 'jump true-location false-location))
(define (then-jump? then) (eqv? 'jump (car then)))
(define (then-jump-true-location then) (cadr then))
(define (then-jump-false-location then) (caddr then))

(define (then-move  store-location) (cons 'mov store-location))
(define (then-move? then) (eqv? 'mov (car then)))
(define (then-move-store-location then) (cdr then))

(define (then-return) '(return))
(define (then-return? then) (eqv? 'return (car then)))

(define (x86-prim-fx+)
  (arithmetic-prim am-add 'number (default-arithmetic-allowed-opnds) #t))

(define (x86-prim-fx-)
  (arithmetic-prim am-sub 'number (default-arithmetic-allowed-opnds) #f))

(define (x86-prim-fx<)
  (arithmetic-prim am-cmp (list 'boolean x86-jle x86-jg) (default-arithmetic-allowed-opnds) #f))

(define (default-arithmetic-allowed-opnds)
  (if load-store-only
    '((reg) (reg int))
    '((reg) (reg int mem))))

(define (arithmetic-prim asm-fun return-type allowed-opnds  commutative)
  (let ((commutative-prologue (if commutative prologue-commute idlogue)))
    (make-primitive
      (compose-prologues
        commutative-prologue
        (prologue-mov-args allowed-opnds))

      (lambda (cgc result-action args) (apply asm-fun (cons cgc args)))

      (if (equal? 'boolean (car return-type))
          (apply epilogue-use-result-boolean (cdr return-type))
          epilogue-use-result-default))))

(define (make-primitive prologue asm-fun epilogue)
  (lambda (cgc result-action . args)
    (debug "Before prologue\n")
    (let* ((prologue-result (prologue cgc result-action args)))
      (debug "After prologue\n")
      (asm-fun cgc result-action prologue-result)
      (debug "After asm-fun\n")
      (epilogue cgc result-action prologue-result)
      (debug "After epilogue\n"))))

;; Apply prologues linearly.
;; Applies the modifies arguments returned by the prologue into the next
(define (compose-prologues . progs)
  (define (loop prologues)
    (if (null? prologues)
      idlogue
      (lambda (cgc result-action args)
        (let* ((prologue (car prologues))
               (new-args (prologue cgc result-action args)))
          ((loop (cdr prologues)) cgc result-action new-args)))))

  (loop progs))

(define compose-epilogues compose-prologues)

;; Identity prologue
(define (idlogue cgc result-action args) args)

;; Prologue for primitives that are commutative.
;; Reduces the number of mov by commuting the operands.
;; Suppose that the result is put in the first argument (like epilogue-use-result-default)
;; (Isn't specific to x86)
(define prologue-commute
  (lambda (cgc result-action args)
    (debug "prologue-commute\n")
    (if (then-move? result-action)
      (let ((result-loc-index (index-of (then-move-store-location result-action) args)))
        (if (not (= -1 result-loc-index))
            (swap-index 0 result-loc-index args)
            args))
      args)))

;; Prologue for primitives that may not support some types of operands.
;; This prologue mov every operands not supported in the extra registers.
;; todo :: Do something if need more registers. (Save some less important registers on stack)
;; (Isn't specific to x86)
(define (prologue-mov-args allowed-opnds)
  (define (mov-arg cgc result-reg index arg)
    (debug "mov-arg\n")
    (let* ((allowed-opnd (list-ref allowed-opnds index))
           (in? (not (= -1 (index-of (opnd-type arg) allowed-opnd)))))
      (if in?
        arg
          (let ((new-register
                  ;; Check if result-reg can be used as extra register.
                  (if (and (= 0 index) (not (= result-reg #f)))
                    result-reg
                    (get-extra-register index))))
            (am-mov cgc new-register arg)
            new-register))))

  (lambda (cgc result-action args)
    (debug "prologue-mov-args\n")
    (let* ((store-location (then-move-store-location result-action))
           (result-reg (if (and
                            (then-move? result-action)
                            (reg-opnd? store-location)
                            (= -1 (index-of store-location args)))
                          store-location
                          #f)))
      (map
        (lambda (index arg) (mov-arg cgc result-reg index arg))
        (iota 0 (- (length args) 1))
        args))))

;; Default epilogue for primitives that put their results in their first arguments
;; Ex x86-add r1 r2 == r1 <- r1 + r2
;; (Isn't specific to x86)
(define (epilogue-use-result-default cgc result-action args)
  (debug "epilogue-use-result-default\n")
    (cond
      ((then-jump? result-action)
        ;; The function doesn't return a boolean => result is always true
        (am-jmp cgc (then-jump-true-location result-action)))
      ((then-move? result-action)
        (let ((result-action-location (then-move-store-location result-action)))
          (if (and (not (null? args))
                (not (equal? result-action-location (car args))))
            (am-mov cgc result-action-location (car args)))))
      ((then-return? result-action)
        (am-jmp cgc  (get-register 0)))
      (else
        (compiler-internal-error "epilogue-use-result-default - Unknown result-action" result-action))))

;; Default epilogue for primitives that put their results in flag register
;; (Isn't specific to x86)
(define (epilogue-use-result-boolean true-test-jump false-test-jump)
  (lambda (cgc result-action args)
    (cond
      ((then-jump? result-action)
        ;; The function doesn't return a boolean => result is always true
        (true-test-jump cgc (then-jump-true-location result-action))
        (am-jmp cgc (then-jump-false-location result-action)))
      ((then-move? result-action)
        ;; Extract boolean
        (let* ((suffix "_jump")
               (label (make-unique-label cgc suffix))
               (result-loc (then-move-store-location result-action)))

            (am-mov cgc result-loc (int-opnd 1)) ;; todo true value
            (true-test cgc label)
            (am-mov cgc result-loc (int-opnd 0)) ;; todo false value
            (am-label cgc label)))
      ((then-return? result-action)
        ;; Extract boolean then jump
        (let* ((suffix "_jump")
               (label (make-unique-label cgc suffix))
               (result-loc (get-register 1))
               (return-loc (get-register 0)))

            (am-mov cgc result-loc (int-opnd 1)) ;; todo true value
            (true-test cgc return-loc)
            (am-mov cgc result-loc (int-opnd 0)) ;; todo false value
            (am-jmp cgc return-loc)))
      (else
        (compiler-internal-error "epilogue-use-result-boolean - Unknown result-action" result-action)))))

;;;----------------------------------------------------------------------------

;; ***** GVM helper methods

(define (map-on-procs fn procs)
  (map fn (reachable-procs procs)))

(define (map-proc-instrs fn proc)
  (let ((p (proc-obj-code proc)))
        (if (bbs? p)
          (map fn (bbs->code-list p)))))

(define (proc-lbl-frame-size code)
  (bb-entry-frame-size (code-bb code)))

(define (proc-jmp-frame-size code)
  (bb-exit-frame-size (code-bb code)))

(define (proc-frame-slots-gained code)
  (bb-slots-gained (code-bb code)))

;;;============================================================================

;; ***** Instruction substitution
;; ***** Instruction substitution - Base

;; Create an rule.
;; Pred :: [Arg] -> Bool
;; Replacment :: Function
;; map-args :: [Arg] -> [Arg]
(define (rule pred replacement #!optional (map-args id))
  (vector 'rule pred replacement map-args))

(define (rule? vect)
  (and (= 4 (length vect)) (eqv? 'rule (vect-ref vect 0))))
(define (rule-pred vect) (vector-ref vect 1))
(define (rule-replacement vect) (vector-ref vect 2))
(define (rule-map-args vect) (vector-ref vect 3))

;; Wrap func in lambda that does
;; 1. Check if any rule-pred is true with its argument.
;;    The first one that's true is used to override func
;; 2. If no rule match, execute func with its argument
(define (wrap-function func rules)
  (define (iter . args)
    (let loop ((rules rules))
      (if (null? rules)
        (apply func args)
        (let* ((rule (car rules))
               (pred (rule-pred rule))
               (repl (rule-replacement rule))
               (map-args (rule-map-args rule)))
          (if (pred args)
            (apply repl (map-args args))
            (loop (cdr rules)))))))
  iter)

;; ***** Instruction substitution - Predicate helper functions

(define (NOP . args) #f)
(define (id . args) args)

;; Builds a substitution rule from an Expression
;; The goal of the function is to make it easier to express complex substitution
;; conditions while keeping expressions short and easy to understand.
;; Using an Haskell-like syntax, an expression is defined as:
;; data Expr = And [Expr]
;;           | Or [Expr]
;;             ;; Apply arguments to pred.
;;           | Relative { pred :: [Opnd] -> Bool }
;;
;; type OpndType = Int | Reg | Mem
;; Currently no use for OpndType Obj and Label.

(define (make-rule rule-id expr sub #!optional (args-map id))
  (define (match? args expr)
    (case (car expr)
      ('or
        (any (map (lambda (subconds) (match? args subconds)) (cdr expr))))

      ('and
        (all (map (lambda (subconds) (match? args subconds)) (cdr expr))))

      ('rel
        ((cadr expr) args))

      (else
        (compiler-internal-error "make-rule: Unknown tag: " (car expr)))))

  (rule
    (lambda (args)
      (let ((does-match? (match? args expr))
            (enabled (rule-enabled? rule-id)))
        (cond
          ((and does-match? (not enabled))
            (begin
              (debug "Not applying rule with id: " rule-id "\n")
              #f))
          ((and does-match? enabled)
            (begin
              (debug "Applying rule with id: " rule-id "\n")
              #t))
          (else
            #f))))
    sub
    args-map))

(define (all-rules . rules)
  (cons 'and rules))

(define (any-rules . rules)
  (cons 'or rules))

(define (rel-rule pred)
  (list 'rel pred))

(define (rel-rule-index index pred)
  (rel-rule
    (lambda (args) (pred (list-ref args index)))))

(define (match-opnd arg-index val opnd? mk-opnd)
  (rel-rule-index
    arg-index
    (lambda (arg)
      (and (opnd? arg)
        (or (not val) (equal? arg (mk-opnd val)))))))

(define (match-int arg-index val)
  (match-opnd arg-index val int-opnd? int-opnd))

(define (match-reg arg-index val)
  (match-opnd arg-index val reg-opnd? get-register))

(define (match-mem arg-index val)
  (match-opnd arg-index val mem-opnd?
    (lambda (mem-params) (apply mem-opnd mem-params))))

;; ***** Instruction substitution - Arguments helper functions

(define (map-argument arg-index fun)
  (lambda (args)
    (map-nth args arg-index fun)))

(define (reorganize-args list)
  (lambda (args)
    (reorder-list args list)))

(define (all bools)
  (if (null? bools)
    #t
    (and (car bools) (all (cdr bools)))))

(define (any bools)
  (if (null? bools)
    #f
    (or (car bools) (all (cdr bools)))))

;; ***** Instruction substitution - Enabling/Disabling rules

(define (rule-enabled? id)
  (let loop ((ids enabled-rules))
    (if (null? ids)
      #f
      (if (equal? id (car ids))
        #t
        (loop (cdr ids))))))

;; Todo: Replace with hash table
;; Naming convention: original_operation opnd1_type opnd2_type -> substituted_operation new_opnd1_type new_opnd2_type
;; Operand types are: (R)egister, (M)emory, (L)abel, _ for Any, Int or other constants
(define enabled-rules (list
  "mov R 0 -> xor R R"
  "add _ 0 -> nop"
  "add _ 1 -> inc _"))

;;;============================================================================

;; ***** Utils

(define _debug #t)
(define (debug . str)
  (if _debug (for-each display str)))

(define (show-listing cgc)
  (asm-assemble-to-u8vector cgc)
  (asm-display-listing cgc (current-error-port) #t))

(define (reserve-space cgc bytes #!optional (value 0))
  (if (> bytes 0)
    (begin
      (am-db cgc value)
      (reserve-space cgc (- bytes 1) value))))

;; ***** Utils - Lists

(define (find pred elems #!optional (index 0))
  (if (null? elems)
    -1
    (if (pred (car elems))
      index
      (find pred (cdr elems) (+ 1 index)))))

(define (index-of elem elems)
  (find (lambda (var) (equal? var elem)) elems))

(define (iota start end)
  (if (> start end)
    '()
    (cons start (iota (+ start 1) end))))

(define (filter pred elems)
  (if (null? elems)
    '()
    (if (pred (car elems))
      (cons (car elems) (filter pred (cdr elems)))
      (filter pred (cdr elems)))))

(define (map-nth list nth fun)
  (if (= 0 nth)
    (cons (fun (car list)) (cdr list))
    (cons (car list) (map-nth (cdr list) (- nth 1) fun))))

(define (reorder-list elems indexes)
  (if (null? indexes)
    '()
    (cons
      (list-ref elems (car indexes))
      (reorder-list elems (cdr indexes)))))

(define (swap-index index1 index2 elems)
  (define (build-list elems index elem1 elem2)
    (cond ((null? elems)
           '())
          ((= index index1)
           (cons elem2 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          ((= index index2)
           (cons elem1 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          (else
           (cons (car elems) (build-list (cdr elems) (+ 1 index) elem1 elem2)))))
  (build-list elems 0 (list-ref elems index1) (list-ref elems index2)))