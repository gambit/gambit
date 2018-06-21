;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2011-2017 by Laurent Huberdeau, All Rights Reserved.

;; Todo: Check if all includes are necessary
;; Todo: Check if my utils can be refactored in _utils.scm or somewhere else

(include "_t-cpu-abstract-machine.scm")
(include "_t-cpu-function-sub.scm")
(include "_t-cpu-objects-desc.scm")
(include "_t-cpu-primitives.scm")
(include "_t-cpu-bench.scm")
(include "_t-cpu-backend-x64.scm")
(include "_t-cpu-utils.scm")

(include "generic.scm")

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

(define (make-backend-target
         abstract-machine-info
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
                      1)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set! targ
        (lambda (procs output c-intf module-descr unique-name)
          (cpu-dump targ procs
                    output c-intf
                    module-descr unique-name
                    sem-changing-opts sem-preserving-opts)))

      (target-link-info-set! targ
        (lambda (file) (cpu-link-info targ file)))

      (target-link-set! targ
        (lambda (extension? inputs output warnings?)
          (cpu-link targ extension? inputs output warnings?)))

      (target-prim-info-set! targ cpu-prim-info)

      (target-frame-constraints-set! targ
        (make-frame-constraints
          cpu-frame-reserve
          cpu-frame-alignment))

      (target-proc-result-set! targ (make-reg 1))
      (target-task-return-set! targ (make-reg 0))

      (target-switch-testable?-set! targ
       (lambda (obj) (cpu-switch-testable? targ obj)))

      (target-eq-testable?-set! targ
       (lambda (obj) (cpu-eq-testable? targ obj)))

      (target-object-type-set! targ
       (lambda (obj) (cpu-object-type targ obj)))

      (cpu-set-nb-regs targ sem-changing-opts max-nb-gvm-regs)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-extra-set! targ 0 abstract-machine-info)

    targ))

(target-add (x64-target))

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

(define cpu-frame-reserve 3) ;; no extra slots reserved
(define cpu-frame-alignment 4) ;; no alignment constraint

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
;; Todo: Move most of the code to abstract machine where it belongs more.

(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  unique-name
                  sem-changing-options
                  sem-preserving-options)

  (let ((cgc ((get-make-cgc-fun targ))))

    (codegen-context-target-set! cgc targ)

    (virtual.dump-gvm procs (current-output-port))
    (encode-procs cgc procs)
    (lambda ()
      (create-target-file output unique-name cgc)
      output)))

;;;----------------------------------------------------------------------------

;; ***** Procedures encoding

(define (encode-procs cgc procs)

  (define C_START_LBL (get-label cgc 'C_START_LBL))

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
        (codegen-context-current-code-set! cgc code)
        (encode-gvm-instr cgc code))
      (get-code-list proc)))

  (debug "Encode procs")
  (map encode-proc procs2)

  (am-end cgc)
  (am-error cgc)
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
            (prim-fun cgc (then-return label) args))

          ;; Prim is defined in C
          ;; We simply passthrough to C. Has some overhead, but calling C has lots of overhead anyway
          ;; Todo: Check if label can be references as entry-point. Maybe set label struct?
          (let* ((proc-name (proc-obj-name proc))
                 (proc-sym (string->symbol proc-name)))
            (get-extra-register cgc
              (lambda (reg)
                (put-entry-point-label cgc label 0 #f)
                (am-mov cgc reg (x86-imm-obj proc-sym))
                (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
                (am-mov cgc reg (mem-opnd cgc 0 reg))
                  (am-jmp cgc reg)))))))))

;;;----------------------------------------------------------------------------

;; ***** GVM Instruction encoding

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

;; ***** Label instruction encoding

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

      ; (debug "For proc: " label)
      ; (debug "Found: " (table-find-label proc-labels-table lbl-pos))

      (if proc-labels-table
        (table-find-label proc-labels-table lbl-pos)
        (compiler-internal-error "Procedure " proc-name " doesn't have associated label table")))))

(define (get-fun-fs cgc arg-count)
  (let* ((target (codegen-context-target cgc))
         (nargs-in-regs (target-nb-arg-regs target)))
    (max 0 (- arg-count nargs-in-regs))))

;; Todo: Fix proc-name-sym invalid when placing primitives
(define (put-entry-point-label cgc label nargs closure?)
  (define label-struct-position (codegen-context-label-struct-position cgc))
  (define proc (codegen-context-current-proc cgc))
  (define proc-name (proc-obj-name proc))
  (define proc-name-sym (string->symbol proc-name))
  (define proc-info #f)
  (define parent-label (get-parent-proc-label cgc proc))

  (asm-align cgc 8)
  (codegen-fixup-obj! cgc proc-name-sym 64)    ;; ##subprocedure-parent-name
  (codegen-fixup-obj! cgc proc-info 64)        ;; ##subprocedure-parent-info
  (codegen-fixup-obj! cgc 2 64)                ;; nb labels

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

  (x86-label cgc label)

  (codegen-context-label-struct-position-set! cgc
    (+ 1 label-struct-position)))

(define (encode-label-instr cgc code)
  (let* ((gvm-instr (code-gvm-instr code))
         (frame (gvm-instr-frame gvm-instr))
         (fs (frame-size frame))
         (label-struct-position (codegen-context-label-struct-position cgc))
         (proc (codegen-context-current-proc cgc))
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

              (am-check-nargs cgc label frame narg opts rest?
                (lambda (fun-label)
                  (set-proc-label-index cgc proc label label-struct-position)
                  (put-entry-point-label cgc label narg closure?)))))

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
        (let ((base (get-register cgc (reg-num (clo-base opnd))))
              (index (* 8 (- (clo-index opnd) 1))))
          (mem-opnd cgc index base)))
      ((glo? opnd)
        (x86-imm-glo (glo-name opnd)))
      (else
        (compiler-internal-error "make-jump-opnd: Unknown opnd: " opnd))))

  (debug "encode-jump-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (proc (codegen-context-current-proc cgc))
         (jmp-opnd (jump-opnd gvm-instr))
         (jmp-loc (make-jump-opnd (jump-opnd gvm-instr)))
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
        (get-extra-register cgc
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
         (then (then-move (make-opnd cgc (apply-loc gvm-instr))))
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
  (debug "encode-close-instr")
  (compiler-internal-error "encode-close-instr: Not implemented"))
  ; (debug (car (close-parms (code-gvm-instr code))))
  ; (let* ((gvm-instr (code-gvm-instr code))
  ;        (mk-opnd (lambda (opnd) (make-opnd cgc opnd)))
  ;        (parms (car (close-parms gvm-instr))) ;; Todo: Find why close-parms returns list
  ;        (loc (mk-opnd (closure-parms-loc parms)))
  ;       ;  (lbl (mk-opnd (closure-parms-lbl parms))) ;; WTF: Why not in opnd-table?
  ;        (lbl (lbl-opnd cgc (get-proc-label cgc proc (closure-parms-lbl parms))))
  ;        (opnds (map mk-opnd (closure-parms-opnds parms)))
  ;       ;  (opnds (closure-parms-opnds parms))
  ;        (size (* (get-word-width cgc) (+ 1 (length opnds)))))

  ;   (get-extra-register cgc
  ;     (lambda (reg)
  ;       (am-allocate-mem cgc size reg)
  ;       (let ((n 0))
  ;         (for-each
  ;           (lambda (opnd)
  ;             (am-mov cgc (mem-opnd cgc (* (get-word-width cgc) n) reg) opnd (get-word-width-bits cgc))
  ;             (set! n (+ n 1)))
  ;           (cons lbl opnds)))

  ;       ;; Todo: Remove mov if unecessary (Next GVM Instruction is often reg = loc)
  ;       (am-mov cgc loc reg)))))

;; ***** Switch instruction encoding

(define (encode-switch-instr cgc gvm-instr)
  (debug "encode-switch-instr")
  (compiler-internal-error
    "encode-switch-instr: switch instruction not implemented"))

;;;----------------------------------------------------------------------------

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

;;;=============================================================================

;; Config object

;; --enable-multiple-threaded-vms
;; use C backend
;; Use C interface
;; Fast pair test
;; Global variable table register
;; ...

(define config-object
  (let ((table (make-table test: equal?)))
    (table-set! table 'use-c-backend         #t)
    (table-set! table 'use-c-interface       #t)
    (table-set! table 'fast-pair-type-check  #t)
    (table-set! table 'glovar-table-register #t)
    (table-set! table 'force-load-store-arch #f)

    table))

(define (get-opt-val sym)
  (let* ((val (table-ref config-object sym 1243431)))
    (if (eq? val 1243431)
      (compiler-internal-error "(get-opt-val " sym ") Unknown option name")
      val)))
