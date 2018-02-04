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
                        ('x86     x86-backend)
                        ('x86-64  x86-64-backend)
                        ('arm     armv8-backend)
                        (else (compiler-internal-error "dispatch-target, unsupported target: " arch))))
               (cgc (make-codegen-context)))

          (codegen-context-listing-format-set! cgc 'gnu)

          (handler
            targ procs output c-intf
            module-descr unique-name
            sem-changing-options sem-preserving-options
            cgc)))

;;;----------------------------------------------------------------------------

;; ***** Label table

;; Key: Label id
;; Value: Pair (Label, optional Proc-obj)
(define proc-labels (make-table test: eq?))

(define (get-proc-label cgc proc gvm-lbl)
  (define (nat-label-ref label-id)
    (let ((x (table-ref proc-labels label-id #f)))
      (if x
          (car x)
          (let ((l (asm-make-label cgc label-id)))
            (table-set! proc-labels label-id (list l proc))
            l))))

  (let* ((id (if gvm-lbl gvm-lbl 0))
         (label-id (lbl->id id (replace_whitespace (proc-obj-name proc)))))
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
  (string->symbol (string-append "_"
                                 (number->string num)
                                 "_"
                                 proc_name)))

; ***** Object table and object creation

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
        (x64-encode-gvm-instr cgc proc code))
      proc))

  (debug "x86-64-backend\n")
  (asm-init-code-block cgc 0 'le)
  (x86-arch-set! cgc 'x86-64)

  (add-start-routine cgc)
  (map-on-procs encode-proc procs)
  (add-end-routine cgc)
  (show-listing cgc))

;; ***** Constants and helper functions

  (define WRONG_NARGS_LBL (asm-make-label cgc 'WRONG_NARGS_LBL))
  (define C_RETURN_LBL (asm-make-label cgc 'C_RETURN_LBL))

  (define r0 (x86-r15)) ;; GVM r0 = x86 r15
  (define r1 (x86-r14)) ;; GVM r1 = x86 r14
  (define r2 (x86-r13)) ;; GVM r2 = x86 r13
  (define r3 (x86-r12)) ;; GVM r3 = x86 r12
  (define r4 (x86-r11)) ;; GVM r4 = x86 r11
  (define r5 (x86-r10)) ;; GVM r4 = x86 r10
  (define na (x86-cl))  ;; number of arguments register
  (define sp (x86-rsp))
  (define fp (x86-rdx))
  (define stack-size 10000) ;; Scheme stack size
  (define offs 1) ;; stack offset so that frame[1] is at null offset from fp

  (define main-registers 
    (vector r0 r1 r2 r3 r4 r5))

  (define fixnum-tag 0)
  (define other-tag 0)
  (define cons-tag 0)
  (define empty-tag 0)
  (define tag-mult 1)

  (define (get-register n) 
    (vector-ref main-registers  n))

  (define (alloc-frame cgc n)
    (if (not (= 0 n))
      (x86-add cgc fp (x86-imm-int (* n -8)))))

  (define (frame cgc fs n)
    (x86-mem (* (+ fs (- n) offs) 8) fp))

  (define (x64-gvm-opnd->x86-opnd cgc proc code opnd context)
    (debug opnd)
    (debug "\n")
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
          (x86-imm-lbl (get-proc-label cgc proc (lbl-num opnd)))))
      ((obj? opnd)
        (debug "obj\n")
        (let ((val (obj-val opnd)))
          (cond
            ((fixnum? val)
              (x86-imm-int (+ (* val tag-mult) fixnum-tag) 64))
            ((null? val)
              (x86-imm-int empty-tag 64))
            ((proc-obj? val)
              (if (eqv? context 'jump)
                (get-proc-label cgc (obj-val opnd) 1)
                (x86-imm-lbl (get-proc-label cgc (obj-val opnd) 1))))
            ((string? val)
              (if (eqv? context 'jump)
                (make-object-label cgc (obj-val opnd))
                (x86-imm-lbl (make-object-label cgc (obj-val opnd)))))
            (else 
              (compiler-internal-error "x64-gvm-opnd->x86-opnd: Unknown object type")))))
      ((glo? opnd)
        (debug "glo\n") ; (debug (glo-name opnd))
        (compiler-internal-error "Opnd not implementeted global"))
      ((clo? opnd)
        (compiler-internal-error "Opnd not implementeted closure"))
      (else
        (compiler-internal-error "x64-gvm-opnd->x86-opnd: Unknown opnd: " opnd))))

  ;; Provides unique ids
  ;; No need for randomness or UUID
  ;; *** Obviously, NOT thread safe ***
  (define id 0)
  (define (get-unique-id)
    (set! id (+ id 1))
    id)

;; ***** Environment code and primitive functions

  (define (add-start-routine cgc)
    (debug "add-start-routine\n")
    (x86-mov cgc r0 (x86-imm-lbl C_RETURN_LBL))
    (x86-mov cgc na (x86-imm-int -64 64)) ;; na = -64. Used for passing narg with flag register 
    (x86-lea  cgc fp (x86-mem (* offs -8) sp)) ;; Align frame with offset
  )

  (define (add-end-routine cgc)
    (debug "add-end-routine\n")
    (asm-align cgc 4 1)
    (x86-label cgc C_RETURN_LBL)
    (x86-mov cgc (x86-rax) (x86-imm-int 0 64)) ;; Set exit code
    (x86-ret cgc 0) ;; Exit program

    (asm-align cgc 4 1)
    (x86-label cgc WRONG_NARGS_LBL)
    (x86-jmp  cgc WRONG_NARGS_LBL) ;; infinite loop if wrong number of arguments)

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
        (let* ((prim (get-prim-obj (proc-obj-name proc)))
               (fun (prim-info-lifted-encode-fun prim)))
          (asm-align cgc 4 1)
          (x86-label cgc label)
          (fun cgc label 64)))))

  ;; Value is Pair (Label, optional Proc-obj)
  (define (put-objects cgc obj label)
    (debug "put-objects\n")
    (debug "label: " label)

    (x86-label cgc label)

    (cond
      ((string? obj)
        (debug "Obj: " obj "\n")
        ;; Header: 158 (0x9E) + 256 * char_size(default:4) * length
        (x86-dd cgc (+ 158 (* (* 256 4) (string-length obj))))
        ;; String content=
        (apply x86-dd (cons cgc (map char->integer (string->list obj)))))
      (else 
        (compiler-internal-error "put-objects: Unknown object type"))))

;; ***** x64 : GVM Instruction encoding

  (define (x64-encode-gvm-instr cgc proc code)
    ; (debug "x64-encode-gvm-instr\n")
    (case (gvm-instr-type (code-gvm-instr code))
      ((label)  (x64-encode-label-instr   cgc proc code))
      ((jump)   (x64-encode-jump-instr    cgc proc code))
      ((ifjump) (x64-encode-ifjump-instr  cgc proc code))
      ((apply)  (x64-encode-apply-instr   cgc proc code))
      ((copy)   (x64-encode-copy-instr    cgc proc code))
      ((close)  (x64-encode-close-instr   cgc proc code))
      ((switch) (x64-encode-switch-instr  cgc proc code))
      (else
        (compiler-error
          "format-gvm-instr, unknown 'gvm-instr-type':" (gvm-instr-type gvm-instr)))))

;; ***** Label instruction encoding

  (define (x64-encode-label-instr cgc proc code)
    (debug "x64-encode-label-instr: ")
    (let* ((gvm-instr (code-gvm-instr code))
          (label-num (label-lbl-num gvm-instr))
          (label (get-proc-label cgc proc label-num))
          (narg (label-entry-nb-parms gvm-instr)))

      (if (not (eqv? 'simple (label-type gvm-instr)))
          (asm-align cgc 4 1))

      (x86-label cgc label)

      (debug label)
      (debug "\n")

      (if (eqv? 'entry (label-type gvm-instr))
        (add-narg-check cgc narg))))

  (define (add-narg-check cgc narg)
    (debug "add-narg-check\n")
    (debug narg)
    (cond
      ((= narg 0)
        (x86-jne cgc WRONG_NARGS_LBL))
      ((= narg 1)
        (x86-jp cgc WRONG_NARGS_LBL))
      ((= narg 2)
        (x86-jno cgc WRONG_NARGS_LBL))
      ((= narg 3)
        (x86-jns cgc WRONG_NARGS_LBL))
      ((<= narg 34)
          (x86-sub cgc na (x86-imm-int (make-parity-adjusted-valued narg)))
          (x86-jne cgc WRONG_NARGS_LBL))
      (else
        (compiler-internal-error "Number of argument not supported: " narg))))

  (define (make-parity-adjusted-valued n)
    (define (bit-count n)
      (if (= n 0)
        0
        (+ (modulo n 2) (bit-count (quotient n 2)))))
    (let* ((narg2 (* 2 (- n 3)))
          (bits (bit-count narg2))
          (parity (modulo bits 2)))
      (+ 64 parity narg2)))

;; ***** (if)Jump instruction encoding

  (define (x64-encode-jump-instr cgc proc code)
    (debug "x64-encode-jump-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
           (fs-lbl (proc-lbl-frame-size code))
           (fs-jmp (proc-jmp-frame-size code))
           (jmp-opnd (jump-opnd gvm-instr)))

      ;; Pop stack if necessary
      (alloc-frame cgc (- fs-jmp fs-lbl))

      ;; TODO
      ;; Poll/safe is specified (jump-poll?/jump-safe? gvm-instr)

      ;; Save return address if necessary 
      (if (jump-ret gvm-instr)
        (let* ((label-ret-num (jump-ret gvm-instr))
               (label-ret (get-proc-label cgc proc label-ret-num))
               (label-ret-opnd (x86-imm-lbl label-ret)))
          (x86-mov cgc r0 label-ret-opnd)))

      ;; Set arg count 
      (if (jump-nb-args gvm-instr)
        (add-narg-set cgc (jump-nb-args gvm-instr)))

      ; Jump to location 
      (x86-jmp cgc (x64-gvm-opnd->x86-opnd cgc proc code jmp-opnd 'jump))))

  (define (x64-encode-ifjump-instr cgc proc code)
    (debug "x64-encode-ifjump-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
           (fs-lbl (proc-lbl-frame-size code))
           (fs-jmp (proc-jmp-frame-size code))
           (true-label (get-proc-label cgc proc (ifjump-true gvm-instr)))
           (false-label (get-proc-label cgc proc (ifjump-false gvm-instr))))

      ;; Pop stack if necessary 
      (alloc-frame cgc (- fs-jmp fs-lbl))

      ;; TODO
      ;; Poll/safe is specified (jump-poll?/jump-safe? gvm-instr)

      (x64-encode-prim-ifjump 
        cgc
        proc
        code
        (get-prim-obj (proc-obj-name (apply-prim gvm-instr)))
        (ifjump-opnds gvm-instr)
        true-label
        false-label)))
        
  (define (add-narg-set cgc narg)
    (cond
      ((= narg 0)
        (x86-cmp cgc na na))
      ((= narg 1)
        (x86-cmp cgc na (x86-imm-int -65)))
      ((= narg 2)
        (x86-cmp cgc na (x86-imm-int 66)))
      ((= narg 3)
        (x86-cmp cgc na (x86-imm-int 0)))
      ((<= narg 34)
          (x86-add cgc na (x86-imm-int (make-parity-adjusted-valued narg))))
      (else
        (compiler-internal-error "Number of argument not supported: " narg))))

;; ***** Apply instruction encoding

  (define (x64-encode-apply-instr cgc proc code)
    (debug "x64-encode-apply-instr\n")
    (let ((gvm-instr (code-gvm-instr code)))
      (x64-encode-prim-affectation
        cgc 
        proc 
        code
        (get-prim-obj (proc-obj-name (apply-prim gvm-instr)))
        (apply-opnds gvm-instr)
        (apply-loc gvm-instr))))

;; ***** Copy instruction encoding

  (define (x64-encode-copy-instr cgc proc code)
    (debug "x64-encode-copy-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
          (src (x64-gvm-opnd->x86-opnd cgc proc code (copy-opnd gvm-instr) #f))
          (dst (x64-gvm-opnd->x86-opnd cgc proc code (copy-loc gvm-instr) #f)))
      (x86-mov cgc dst src 64)))

;; ***** Close instruction encoding

  (define (x64-encode-close-instr cgc proc gvm-instr)
    (debug "x64-encode-close-instr\n")
    (compiler-internal-error
      "x64-encode-close-instr: close instruction not implemented"))
    
;; ***** Switch instruction encoding

  (define (x64-encode-switch-instr cgc proc gvm-instr)
    (debug "x64-encode-switch-instr\n")
    (compiler-internal-error
      "x64-encode-switch-instr: switch instruction not implemented"))

;; ***** x64 primitives

  ;; symbol: prim symbol
  ;; extra-info: (return-type . more-info depending on type)
  ;; narg: Number of arguments accepted. #f is vararg (Is it possible?)
  ;; lifted-encode-fun: CGC -> Label -> Width (8|16|32|64) -> ().
  ;;    Generates function assembly code when called

  ;; inline-encode-fun: CGC -> Opnds* (Not in list) -> Width -> ().
  ;;    Generates inline assembly when called
  ;; args-need-reg: [Boolean]. #t if arg at the same index needs to be a register
  ;;    Otherwise, everything can be used (Do something for functions accepting memory loc by not constants)
  (define (make-prim-info symbol extra-info narg lifted-encode-fun)
    (vector symbol extra-info narg lifted-encode-fun))

  (define (make-inlinable-prim-info symbol extra-info narg lifted-encode-fun inline-encode-fun args-need-reg)
    (if (not (= (length args-need-reg) narg))
      (compiler-internal-error "make-inlinable-prim-info" symbol " narg /= (length args-need-reg)"))
    (vector symbol extra-info narg lifted-encode-fun inline-encode-fun args-need-reg))

  (define (prim-info-inline? vect) (= 6 (vector-length vect)))

  (define (prim-info-symbol vect) (vector-ref vect 0))
  (define (prim-info-extra-info vect) (vector-ref vect 1))
  (define (prim-info-narg vect) (vector-ref vect 2))
  (define (prim-info-lifted-encode-fun vect) (vector-ref vect 3))
  (define (prim-info-inline-encode-fun vect) (vector-ref vect 4))
  (define (prim-info-args-need-reg vect) (vector-ref vect 5))

  (define (prim-info-return-type vect) (car (prim-info-extra-info vect)))
  (define (prim-info-true-jump vect) (cadr (prim-info-extra-info vect)))
  (define (prim-info-false-jump vect) (caddr (prim-info-extra-info vect)))

  (define (get-prim-obj prim-name)
    (case (string->symbol prim-name)
        ('##fx+ (prim-info-fx+))
        ('##fx- (prim-info-fx-))
        ('##fx< (prim-info-fx<))
        ('display (prim-info-display))
        (else 
          (compiler-internal-error "Primitive not implemented: " prim-name))))

  (define (prim-info-fx+)
    (define (lifted-encode-fun cgc label width)
      (x64-encode-lifted-prim-inline cgc (prim-info-fx+)))
    (make-inlinable-prim-info '##fx+ (list 'fixnum) 2 lifted-encode-fun x86-add '(#f #f)))

  (define (prim-info-fx-)
    (define (lifted-encode-fun cgc label width)
      (x64-encode-lifted-prim-inline cgc (prim-info-fx-)))
    (make-inlinable-prim-info '##fx- (list 'fixnum) 2 lifted-encode-fun x86-sub '(#f #f)))

  (define (prim-info-fx<)
    (define (lifted-encode-fun cgc label width)
      (x64-encode-lifted-prim-inline cgc (prim-info-fx<)))
    (make-inlinable-prim-info '##fx< (list 'boolean x86-jle x86-jg) 2 lifted-encode-fun x86-cmp '(#f #f)))

  (define (prim-info-display)
    (define (lifted-encode-fun cgc label width)
      (x86-jmp cgc label)
      ;;(display "display : lifted-encode-fun")
      #f)
    (make-prim-info 'display (list 'fixnum) 1 lifted-encode-fun))

  (define (prim-guard prim args)
    (define (reg-check opnd need-reg)
      (if (and need-reg (not (reg? opnd)))
        (compiler-internal-error "prim-guard " (prim-info-symbol prim) " one of it's argument isn't reg but is specified as one")))

    (if (not (= (length args) (prim-info-narg prim)))
      (compiler-internal-error (prim-info-symbol prim) "primitive doesn't have " (prim-info-narg prim) " operands"))

    (map reg-check args (prim-info-args-need-reg prim)))

  (define (x64-encode-inline-prim cgc proc code prim args)
    (debug "x64-encode-inline-prim\n")
    (prim-guard prim args)
    (if (not (prim-info-inline? prim))
      (compiler-internal-error "x64-encode-inline-prim: " (prim-info-symbol prim) " isn't inlinable"))

    (let* ((opnds
            (map
              (lambda (opnd) (x64-gvm-opnd->x86-opnd cgc proc code opnd #f))
              args))
          (opnd1 (car opnds)))

      (apply (prim-info-inline-encode-fun prim) cgc (append opnds '(64)))))

  ;; Add mov necessary if operation only operates on register but args are not registers (todo? necessary?)
  ;; result-loc can be used to mov return after (False to disable)
  (define (x64-encode-prim-affectation cgc proc code prim args result-loc)
    (debug "x64-encode-prim-affectation\n")
    (x64-encode-inline-prim cgc proc code prim args)

      (if (and result-loc (not (equal? (car args) result-loc))) 
        (let ((x86-result-loc (x64-gvm-opnd->x86-opnd cgc proc code result-loc #f)))
      (if (eqv? (prim-info-return-type prim) 'boolean) ;; We suppose narg > 0
        ;; If operation returns boolean (Result is in flag register)
          (let* ((proc-name (proc-obj-name proc))
                 (suffix (string-append proc-name "_jump"))
                 (label (make-unique-label cgc suffix)))

              (x86-mov cgc x86-result-loc (x86-imm-int 1))
              ((prim-info-true-jump prim) cgc label)
              (x86-mov cgc x86-result-loc (x86-imm-int 0))
              (x86-label label))
        ;; Else
        (x86-mov cgc x86-result-loc (x64-gvm-opnd->x86-opnd cgc proc code (car args) #f))))))

  ;; Add mov necessary if operation only operates on register but args are not registers (todo? necessary?
  (define (x64-encode-prim-ifjump cgc proc code prim args true-loc-label false-loc-label)
    (debug "x64-encode-prim-ifjump\n")
    (x64-encode-inline-prim cgc proc code prim args)

    ((prim-info-true-jump prim) cgc true-loc-label)
    (x86-jmp cgc false-loc-label))
    
  ;; Defines lifted function using inline-encode-fun
  (define (x64-encode-lifted-prim-inline cgc prim)
    (debug "x64-encode-lifted-prim\n")
    (let* ((opnds
            (cdr (take 
              (vector->list main-registers)
              (prim-info-narg prim)))))

      (apply (prim-info-inline-encode-fun prim) cgc (append opnds '(64)))

      (if (eqv? (prim-info-return-type prim) 'boolean) ;; We suppose narg > 0
        ;; If operation returns boolean (Result is in flag register)
        (let* ((suffix "_jump")
               (label (make-unique-label cgc suffix))
               (result-loc r1))

            (x86-mov cgc r1 (x86-imm-int 1))
            ((prim-info-true-jump prim) cgc label)
            (x86-mov cgc r1 (x86-imm-int 0))
            (x86-label cgc label)))
        ;; Else, we suppose that arg1 is destination of operation. arg1 = r1

    (x86-jmp cgc r0)))

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

;;;============================================================================

;; ***** Utils

(define _debug #t)
(define (debug . str)
  (if _debug (for-each display str)))

(define (show-listing cgc)
  (asm-assemble-to-u8vector cgc)
  (asm-display-listing cgc (current-error-port) #f))

(define (replace_whitespace str)
  (let ((f (lambda (c) (if (equal? #\space c) #\_ c)))
        (str-list (string->list str)))
    (list->string (map f str-list))))
