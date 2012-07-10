;;;============================================================================

;;; File: "_t-x86.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.
;;; Copyright (c) 2012 by Vincent Foley, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(include "_gvm.scm")

(include "_asm#.scm")
(include "_x86#.scm")
(include "_codegen#.scm")


;; Return the architecture of the compiler.
;; x86-32 for Intel 32
;; x86-64 for Intel 64
;; arm    for ARM
(define (auto-detect-arch)
  (define auto-detect-arch-code '#u8(
                    ;;       ARM              X86-32            X86-64
                    ;;
#xEB #x0A #xA0 #xE3 ;;      mov r0,#962560    jmp x86           jmp x86
#x03 #x00 #xE0 #xE3 ;;      mov r0,#-4        ...               ...
#x1E #xFF #x2F #xE1 ;;      bx  lr            ...               ...
                    ;; x86:
#x48                ;;                        dec eax           xor rax,rax
#x31 #xC0           ;;                        xor eax,eax
#x48                ;;                        dec eax           inc rax
#xFF #xC0           ;;                        inc eax
#xC1 #xE0 #x02      ;;                        shl eax,0x2       shl eax,0x2
#xC3                ;;                        ret               ret
                    ;;
                    ;;      returns -4        returns 0         returns 4
))

  (define (run-code code #!optional (arg1 0) (arg2 0) (arg3 0))
    (let* ((len (u8vector-length code))
           (mcb (##make-machine-code-block len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
            (begin
              (##machine-code-block-set! mcb i (u8vector-ref code i))
              (loop (- i 1)))))
      (##machine-code-block-exec mcb arg1 arg2 arg3)))

 (case (run-code auto-detect-arch-code)
   ((-1) 'arm)
   ((0)  'x86-32)
   ((1)  'x86-64)
   (else #f)))


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
                 (n (+ base-addr (machine-code-block-extract-number mcb pos size))))
            (machine-code-block-insert-number! mcb pos size n)
            (loop (cdr fixups)))))))

;; Extract `size` bytes from `mcb` at position `start` and accumulate
;; them into a number. Use little endian.
(define (machine-code-block-extract-number mcb start size)
  (let loop ((n 0) (i (- size 1)))
    (if (>= i 0)
        (loop (+ (* n 256) (##machine-code-block-ref mcb (+ start i)))
              (- i 1))
        n)))

;; Insert into `mcb` at position `start` the number `n` as `size` bytes.
;; Use little endian.
(define (machine-code-block-insert-number! mcb start size n)
  (let loop ((n n) (i 0))
    (if (< i size)
        (begin
          (##machine-code-block-set! mcb (+ start i) (modulo n 256))
          (loop (quotient n 256) (+ i 1))))))



(define (machine-code-block->procedure mcb)
 (lambda (#!optional (arg1 0) (arg2 0) (arg3 0))
   (##machine-code-block-exec mcb arg1 arg2 arg3)))

;; Take a code generation context, assemble it,
;; fix the addresses, and convert the code to
;; a procedure.  Optionally display the resulting
;; assembly code.
(define (create-procedure cgc #!optional (show-listing? #f))
  (let ((targ (codegen-context-target cgc)))
    (let* ((code (asm-assemble-to-u8vector cgc))
           (fixups (codegen-context-fixup-list cgc)))
      (if show-listing?
          (asm-display-listing cgc (current-error-port) #t))

      (u8vector->procedure code fixups))))



(define (nat-target-info-port x)               (vector-ref x 16))
(define (nat-target-info-port-set! x y)        (vector-set! x 16 y))
(define (nat-target-arch x)                    (vector-ref x 17))
(define (nat-target-arch-set! x y)             (vector-set! x 17 y))
(define (nat-target-word-width x)              (vector-ref x 18))
(define (nat-target-word-width-set! x y)       (vector-set! x 18 y))
(define (nat-target-nb-arg-regs x)             (vector-ref x 19))
(define (nat-target-nb-arg-regs-set! x y)      (vector-set! x 19 y))
(define (nat-target-gvm-reg-map x)             (vector-ref x 20))
(define (nat-target-gvm-reg-map-set! x y)      (vector-set! x 20 y))
(define (nat-target-pstate-ptr-reg x)          (vector-ref x 21))
(define (nat-target-pstate-ptr-reg-set! x y)   (vector-set! x 21 y))
(define (nat-target-heap-ptr-reg x)            (vector-ref x 22))
(define (nat-target-heap-ptr-reg-set! x y)     (vector-set! x 22 y))
(define (nat-target-stack-ptr-reg x)           (vector-ref x 23))
(define (nat-target-stack-ptr-reg-set! x y)    (vector-set! x 23 y))
(define (nat-target-prim-proc-table x)         (vector-ref x 24))
(define (nat-target-prim-proc-table-set! x y)  (vector-set! x 24 y))
(define (nat-target-prc-objs x)                (vector-ref x 25))
(define (nat-target-prc-objs-set! x y)         (vector-set! x 25 y))
(define (nat-target-prc-objs-seen x)           (vector-ref x 26))
(define (nat-target-prc-objs-seen-set! x y)    (vector-set! x 26 y))
(define (nat-target-prc-objs-to-scan x)        (vector-ref x 27))
(define (nat-target-prc-objs-to-scan-set! x y) (vector-set! x 27 y))
(define (nat-target-nb-arg-gvm-reg x)          (vector-ref x 28))
(define (nat-target-nb-arg-gvm-reg-set! x y)   (vector-set! x 28 y))


;; Initialization/finalization of back-end.
(define (x86-setup target-language arch file-extension)
  (let ((targ (make-target 9 target-language 13))) ; We need 13 extra fields (see above).

    (define (begin! info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf script-line options)
         (x86-dump targ procs output c-intf script-line options)))


      (target-nb-regs-set! targ x86-nb-gvm-regs)

      (target-prim-info-set!
       targ
       (lambda (name)
         (x86-prim-info targ name)))

      (target-label-info-set!
       targ
       (lambda (nb-parms closed?)
         (x86-label-info targ nb-parms closed?)))

      (target-jump-info-set!
       targ
       (lambda (nb-args)
         (x86-jump-info targ nb-args)))

      (target-frame-constraints-set!
       targ
       (make-frame-constraints x86-frame-reserve x86-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

      (target-task-return-set!
       targ
       (make-reg 0))

      (target-switch-testable?-set!
       targ
       (lambda (obj)
         (x86-switch-testable? targ obj)))

      (target-eq-testable?-set!
       targ
       (lambda (obj)
         (x86-eq-testable? targ obj)))

      (target-object-type-set!
       targ
       (lambda (obj)
         (x86-object-type targ obj)))

      (target-file-extension-set!
       targ
       file-extension)

      (nat-target-arch-set! targ arch)
      (case arch
        ((x86-32)
         (begin
           (nat-target-word-width-set! targ 4)
           (nat-target-gvm-reg-map-set! targ (vector (x86-esi)
                                                     (x86-eax)
                                                     (x86-ebx)
                                                     (x86-edi)
                                                     (x86-edx)))
           (nat-target-nb-arg-gvm-reg-set! targ (x86-cl))
           (nat-target-pstate-ptr-reg-set! targ (x86-ecx))
           (nat-target-heap-ptr-reg-set! targ (x86-esp))
           (nat-target-stack-ptr-reg-set! targ (x86-ebp))))
        ((x86-64)
         (begin
           (nat-target-word-width-set! targ 8)
           (nat-target-gvm-reg-map-set! targ (vector (x86-rsi)
                                                     (x86-rax)
                                                     (x86-rbx)
                                                     (x86-rdi)
                                                     (x86-rdx)))
           (nat-target-nb-arg-gvm-reg-set! targ (x86-cl))
           (nat-target-pstate-ptr-reg-set! targ (x86-rcx))
           (nat-target-heap-ptr-reg-set! targ (x86-rsp))
           (nat-target-stack-ptr-reg-set! targ (x86-rbp)))))
      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

;; Install the backend.
(x86-setup 'nat (auto-detect-arch) ".s")


;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define x86-nb-gvm-regs 5)
(define x86-nb-arg-regs 3)

(define (x86-label-info targ nb-parms closed?)

;; After a GVM "entry-point" or "closure-entry-point" label, the following
;; is true:
;;
;;  * return address is in GVM register 0
;;
;;  * if nb-parms <= nb-arg-regs
;;
;;      then parameter N is in GVM register N
;;
;;      else parameter N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-parms - nb-arg-regs
;;
;;  * for a "closure-entry-point" GVM register nb-arg-regs+1 contains
;;    a pointer to the closure object
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-parms x86-nb-arg-regs))))

    (define (location-of-parms i)
      (if (> i nb-parms)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-parms (+ i 1)))))

    (let ((x (cons (cons 'return 0) (location-of-parms 1))))
      (make-pcontext nb-stacked
                     (if closed?
                         (cons (cons 'closure-env
                                     (make-reg (+ x86-nb-arg-regs 1)))
                               x)
                         x)))))

(define (x86-jump-info targ nb-args)

;; After a GVM "jump" instruction with argument count, the following
;; is true:
;;
;;  * the return address is in GVM register 0
;;
;;  * if nb-args <= nb-arg-regs
;;
;;      then argument N is in GVM register N
;;
;;      else argument N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-args - nb-arg-regs
;;
;;  * GVM register nb-arg-regs+1 contains a pointer to the closure object
;;    if a closure is being jumped to
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-args x86-nb-arg-regs))))

    (define (location-of-args i)
      (if (> i nb-args)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-args (+ i 1)))))

    (make-pcontext nb-stacked
                   (cons (cons 'return (make-reg 0))
                         (location-of-args 1)))))

;; The frame constraints are defined by the parameters
;; x86-frame-reserve and x86-frame-alignment.

(define x86-frame-reserve 0) ;; no extra slots reserved
(define x86-frame-alignment 1) ;; no alignment constraint

;; ***** PRIMITIVE PROCEDURE DATABASE

(define (x86-prim-info targ name)
  (x86-prim-info* name))

(define (x86-prim-info* name)
  (table-ref x86-prim-proc-table name #f))

(define x86-prim-proc-table (make-table))

(define (x86-prim-proc-add! x)
  (let ((name (string->canonical-symbol (car x))))
    (table-set! x86-prim-proc-table
                name
                (apply make-proc-obj (car x) #f #t #f (cdr x)))))

(for-each x86-prim-proc-add! prim-procs)

(define (x86-switch-testable? targ obj)
;  (pretty-print (list 'x86-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x86-eq-testable? targ obj)
;  (pretty-print (list 'x86-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (x86-object-type targ obj)
;  (pretty-print (list 'x86-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;



;;;; ***** DUMPING OF A COMPILATION MODULE

;; nat-label-ref: finds the label associated with a symbol. Creates it if
;;                it doesn't exist.
;; nat-label-set!: insert or update a symbol/label association in the table.
(define nat-label-ref  #f)
(define nat-label-set! #f)
(let ((labels (make-table test: eq?)))
  (set! nat-label-ref
        (lambda (cgc label-name)
          (let ((x (table-ref labels label-name #f)))
            (if x
                x
                (let ((l  (asm-make-label cgc label-name)))
                  (table-set! labels label-name l)
                  l)))))
  (set! nat-label-set!
        (lambda (cgc label-name val)
          (table-set! labels label-name val))))


;; Queue containing the procs we've seen so far. (Could we use a set instead?)
(define procs-seen (queue-empty))

;; Queue containing the procs that have been seen, but not yet generated.
(define procs-not-visited (queue-empty))

;; Add obj to the procs-seen and procs-visited queues if it's
;; a procedure object and has not been seen before.
(define (scan-obj obj)
  (if (and (proc-obj? obj)
           (proc-obj-code obj)
           (not (memq obj (queue->list procs-seen))))
      (begin
        (queue-put! procs-seen obj)
        (queue-put! procs-not-visited obj))))

;; Scan an operand only if it is an object or a closure.
(define (scan-opnd opnd)
  (cond ((not opnd))
        ((obj? opnd) (scan-obj (obj-val opnd)))
        ((clo? opnd) (scan-obj (clo-base opnd)))))

;; Create a new codegen context for the specified architecture and
;; endianness.  The style of the resulting listing can also be
;; specified, and defaults to GNU (AT&T).
(define (make-cgc arch endianness #!optional (style 'gnu))
  (let ((cgc (make-codegen-context)))
    (asm-init-code-block cgc 0 endianness)
    (codegen-context-listing-format-set! cgc style)
    (x86-arch-set! cgc arch)
    cgc))


(define (x86-dump targ procs output c-intf script-line options)
  ;; Allows gsc to fall into the REPL when there's an error.
  (set! throw-to-exception-handler
      (lambda (val) (error val)))

  (for-each (lambda (p) (scan-opnd (make-obj p))) procs)
  (let* ((cgc (make-cgc (nat-target-arch targ) 'le))
         (main-lbl (nat-label-ref cgc 'main))
         (println-lbl (nat-label-ref cgc 'println)))
    (codegen-context-target-set! cgc targ)
    (x86-jmp cgc main-lbl)
    (generate-println cgc println-lbl)
    (x86-translate-procs cgc)
    (entry-point cgc (list-ref procs 0))

    (let ((f (create-procedure cgc #t)))
      (f)))
  #f)


;; Define the entry point (main) of the program.  Do all the
;; register shuffling, and jump to the main procedure of the
;; program.
(define (entry-point cgc main-proc)
  (let* ((targ (codegen-context-target cgc))
         (main-lbl  (nat-label-ref cgc 'main))
         (exit-lbl  (nat-label-ref cgc 'exit))
         (entry-lbl (nat-label-ref cgc (lbl->id 1 (proc-obj-name main-proc)))))
    (x86-label cgc main-lbl)
    (x86-push cgc (nat-target-stack-ptr-reg targ))
    (x86-mov  cgc (nat-target-stack-ptr-reg targ) (nat-target-heap-ptr-reg targ))
    (x86-mov  cgc (vector-ref (nat-target-gvm-reg-map targ) 0) (x86-imm-lbl exit-lbl))
    (x86-jmp  cgc entry-lbl)
    (x86-label cgc exit-lbl)
    (x86-pop cgc (nat-target-stack-ptr-reg targ))
    (x86-ret cgc)))

;; Pop and translate every proc in procs-not-visited.
(define (x86-translate-procs cgc)
  (if (queue-empty? procs-not-visited)
      '()
      (begin
        (translate-proc cgc (queue-get! procs-not-visited))
        (x86-translate-procs cgc))))


;; Do the code generation for a procedure.
(define (translate-proc cgc proc)
  (let* ((code (proc-obj-code proc))
         (lst (bbs->code-list code))
         (targ (codegen-context-target cgc))
         (ctx (make-ctx targ (proc-obj-name proc))))
    (for-each
     (lambda (bb)
       (let* ((gvm-instr (code-gvm-instr bb))
              (gvm-type (gvm-instr-type gvm-instr)))
         (case gvm-type
           ((label)
            (let* ((lbl (make-lbl (label-lbl-num gvm-instr)))
                   (lbl-name (translate-lbl ctx lbl))
                   (asm-lbl (nat-label-ref cgc lbl-name))
                   (fs (frame-size (gvm-instr-frame gvm-instr))))
              (codegen-context-frame-size-set! cgc fs)
              (x86-label cgc asm-lbl)))

           ((copy)
            (let* ((loc (copy-loc gvm-instr))
                   (opnd (copy-opnd gvm-instr)))
              (scan-opnd opnd)
              (scan-opnd loc)
              (let ((opnd* (nat-opnd cgc ctx opnd)))
                (x86-mov cgc
                         (nat-opnd cgc ctx loc)
                         (if (asm-label? opnd*) (x86-imm-lbl opnd*) opnd*)))))

           ((jump)
            (let ((opnd (jump-opnd gvm-instr))
                  (nargs (jump-nb-args gvm-instr))
                  (jump-size (frame-size (gvm-instr-frame gvm-instr))))
              (scan-opnd opnd)
              (if nargs
                  (x86-mov cgc (nat-target-nb-arg-gvm-reg targ) (x86-imm-int nargs)))
              (let ((offset (* (nat-target-word-width targ)
                               (- (codegen-context-frame-size cgc)
                                  jump-size))))
                (if (not (= offset 0))
                    (x86-add cgc (nat-target-stack-ptr-reg targ) (x86-imm-int offset)))
                (x86-jmp cgc (nat-opnd cgc ctx opnd)))))

           ;; ((ifjump)
           ;;  (x86-nop cgc))


           (else
            (compiler-internal-error "unrecognized type:" gvm-type)))
       ))
     lst)))

(define (translate-lbl ctx lbl)
  (lbl->id (lbl-num lbl) (ctx-ns ctx)))

(define (lbl->id num ns)
  (string->symbol (string-append "lbl_"
                                 (number->string num)
                                 "_"
                                 (scheme-id->c-id ns))))


(define (nat-opnd cgc ctx opnd) ;; fetch GVM operand
  (let ((targ (codegen-context-target cgc)))
    (cond ((reg? opnd)
           (let ((n (reg-num opnd)))
             (vector-ref (nat-target-gvm-reg-map targ) n)))

          ((stk? opnd)
           (let ((n (stk-num opnd)))
             (x86-mem (* (nat-target-word-width targ)
                         (+ (codegen-context-frame-size cgc) n 1))
                      (nat-target-stack-ptr-reg targ))))

          ((glo? opnd)
           (let ((name (glo-name opnd)))
             (nat-label-ref cgc name)))

          ((clo? opnd)
           (let ((base (clo-base opnd))
                 (index (clo-index opnd)))
             (let ((reg (nat-opnd-reg targ base)))
               (x86-mem (+ 1 (* 4 index)) reg)))) ;;;;;;;;;;;;;;;;

          ((lbl? opnd)
           (let* ((lbl-name (translate-lbl ctx opnd))
                  (asm-lbl (nat-label-ref cgc lbl-name)))
             ;;      (asm-lbl (asm-make-label cgc lbl-name)))
             ;; (nat-label-set! cgc lbl-name asm-lbl)
             asm-lbl))
           ;; (let ((n (lbl-num opnd)))
           ;;   (let ((lbl (nat-label-lookup targ n 'current-code-variant)))
           ;;     (x86-imm-lbl lbl 0))))

          ((obj? opnd)
           (let ((val (obj-val opnd)))
             (cond ((and (integer? val) (exact? val))
                    (x86-imm-int (* val 4)))
                   ((proc-obj? val)
                    (nat-label-ref cgc val))
                   ((eq? val #f)
                    (x86-imm-int -2))
                   ((eq? val #t)
                    (x86-imm-int -6))
                   ((eq? val '())
                    (x86-imm-int -10))
                   (else
                    (x86-imm-int 0)))));;;;;;;;;;;;;;;;;;;;;;;;;

          (else
           (compiler-internal-error
            "nat-opnd, unknown 'opnd'" opnd)))))



(define (make-ctx target ns)
  (vector target ns 0))

(define (ctx-target ctx)                   (vector-ref ctx 0))
(define (ctx-target-set! ctx x)            (vector-set! ctx 0 x))

(define (ctx-ns ctx)                       (vector-ref ctx 1))
(define (ctx-ns-set! ctx x)                (vector-set! ctx 1 x))

(define (ctx-stack-base-offset ctx)        (vector-ref ctx 2))
(define (ctx-stack-base-offset-set! ctx x) (vector-set! ctx 2 x))

(define (with-stack-base-offset ctx n proc)
  (let ((save (ctx-stack-base-offset ctx)))
    (ctx-stack-base-offset-set! ctx n)
    (let ((result (proc ctx)))
      (ctx-stack-base-offset-set! ctx save)
      result)))

(define (with-stack-pointer-adjust ctx n proc)
  (gen (if (= n 0)
           (gen "")
           (x86-increment ctx (x86-global ctx (x86-prefix ctx "sp")) n))
       (with-stack-base-offset
        ctx
        (- (ctx-stack-base-offset ctx) n)
        proc)))




(define x86-tag-bits 2)
(define x86-word-bits 32)



(define (generate-println cgc println-lbl)
  (let* ((targ (codegen-context-target cgc))
         (print-lbl (asm-make-label cgc 'print))
         (print_other-lbl (asm-make-label cgc 'print_other))
         (print_false-lbl (asm-make-label cgc 'print_false))
         (print_true-lbl (asm-make-label cgc 'print_true))
         (print_int-lbl (asm-make-label cgc 'print_int))
         (write_int-lbl (asm-make-label cgc 'write_int))
         (write_int_neg-lbl (asm-make-label cgc 'write_int_neg))
         (write_int_pos-lbl (asm-make-label cgc 'write_int_pos))
         (write_int_loop-lbl (asm-make-label cgc 'write_int_loop))
         (write_digit-lbl (asm-make-label cgc 'write_digit))
         (write_int_zero-lbl (asm-make-label cgc 'write_int_zero))
         (write_char-lbl (asm-make-label cgc 'write_char)))

    (define (reg x)
      (case x
        ((0 1 2 3 4) (vector-ref (nat-target-gvm-reg-map targ) x))
        ((sp) (nat-target-stack-ptr-reg targ))
        ((hp) (nat-target-heap-ptr-reg targ))
        (else (compiler-internal-error "invalid register" x))))

    (nat-label-set! cgc 'println println-lbl)

    (x86-label cgc println-lbl)
    (x86-call cgc print-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 10))
    (x86-call cgc write_char-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int -2))
    (x86-jmp  cgc (reg 0))

    (x86-label cgc print-lbl)
    (x86-test cgc (reg 1) (x86-imm-int 3))
    (x86-je   cgc print_int-lbl)
    (x86-cmp  cgc (reg 1) (x86-imm-int -2))
    (x86-je   cgc print_false-lbl)
    (x86-cmp  cgc (reg 1) (x86-imm-int -6))
    (x86-je   cgc print_true-lbl)

    (x86-label cgc print_other-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 63))
    (x86-call cgc write_char-lbl)
    (x86-ret  cgc)

    (x86-label cgc print_false-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 35))
    (x86-call cgc write_char-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 102))
    (x86-call cgc write_char-lbl)
    (x86-ret  cgc)

    (x86-label cgc print_true-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 35))
    (x86-call cgc write_char-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 116))
    (x86-call cgc write_char-lbl)
    (x86-ret  cgc)

    (x86-label cgc print_int-lbl)
    (x86-sar  cgc (reg 1) (x86-imm-int 2))
    (x86-call cgc write_int-lbl)
    (x86-ret  cgc)

    (x86-label cgc write_int-lbl)
    (x86-cmp  cgc (reg 1) (x86-imm-int 0))
    (x86-je   cgc write_int_zero-lbl)
    (x86-jge  cgc write_int_pos-lbl)

    (x86-label cgc write_int_neg-lbl)
    (x86-push cgc (reg 1))
    (x86-mov  cgc (reg 1) (x86-imm-int #x2d))
    (x86-call cgc write_char-lbl)
    (x86-pop  cgc (reg 1))
    (x86-neg  cgc (reg 1))

    (x86-label cgc write_int_pos-lbl)
    (x86-neg  cgc (reg 1))
    (x86-push cgc (reg 2))
    (x86-push cgc (reg 4))
    (x86-call cgc write_int_loop-lbl)
    (x86-pop  cgc (reg 4))
    (x86-pop  cgc (reg 2))
    (x86-ret  cgc)

    (x86-label cgc write_int_loop-lbl)
    (x86-mov  cgc (reg 4) (x86-imm-int -1))
    (x86-mov  cgc (reg 2) (x86-imm-int 10))
    (x86-idiv cgc (reg 2))
    (x86-cmp  cgc (reg 1) (x86-imm-int 0))
    (x86-je   cgc write_digit-lbl)
    (x86-push cgc (reg 4))
    (x86-call cgc write_int_loop-lbl)
    (x86-pop  cgc (reg 4))

    (x86-label cgc write_digit-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 48))
    (x86-sub  cgc (reg 1) (reg 4))
    (x86-call cgc write_char-lbl)
    (x86-ret  cgc)

    (x86-label cgc write_int_zero-lbl)
    (x86-mov  cgc (reg 1) (x86-imm-int 48))
    (x86-call cgc write_char-lbl)
    (x86-ret  cgc)

    ;; Mac OS X version of write_char
    (if (memq (caddr (system-type)) '(darwin9 darwin11.3.0))
        (case (nat-target-arch targ)
          ((x86-32)
           (x86-label cgc write_char-lbl)
           (x86-push cgc (x86-eax))           ;; put character to write on stack
           (x86-mov  cgc (x86-eax) (x86-esp)) ;; get address of character in %rax
           (x86-push cgc (x86-imm-int 1))     ;; number of bytes to write = 1
           (x86-push cgc (x86-eax))           ;; address of byte to write
           (x86-push cgc (x86-imm-int 1))     ;; "stdout" is file descriptor 1
           (x86-push cgc (x86-imm-int 0))     ;; reserve space for system call
           (x86-mov  cgc (x86-eax) (x86-imm-int 4)) ;; "write" system call is 4
           (x86-int  cgc #x80)                ;; perform system call (int 0x80)
           (x86-add  cgc (x86-esp) (x86-imm-int 20)) ;; pop what was pushed
           (x86-ret cgc))
          ((x86-64)
           (x86-label cgc write_char-lbl)
           (x86-push cgc (x86-rsi))
           (x86-push cgc (x86-rdx))
           (x86-push cgc (x86-rdi))
           (x86-push cgc (x86-rax))           ;; put character to write on stack
           (x86-mov  cgc (x86-rsi) (x86-rsp)) ;; get address of character in %eax
           (x86-mov  cgc (x86-rdx) (x86-imm-int 1)) ;; number of bytes to write = 1
           (x86-mov  cgc (x86-rdi) (x86-imm-int 1)) ;; "stdout" is file descriptor 1
           (x86-mov  cgc (x86-rax) (x86-imm-int #x2000004)) ;; "write" system call is 0x2000004
           (x86-syscall cgc)
           (x86-add  cgc (x86-rsp) (x86-imm-int 8)) ;; pop what was pushed
           (x86-pop cgc (x86-rdi))
           (x86-pop cgc (x86-rdx))
           (x86-pop cgc (x86-rsi))
           (x86-ret cgc))))

    ;; Linux version of write_char
    (if (memq (caddr (system-type)) '(linux-gnu))
        (case (nat-target-arch targ)
          ((x86-32)
           (x86-label cgc write_char-lbl)
           (x86-push cgc (x86-ebx))
           (x86-push cgc (x86-ecx))
           (x86-push cgc (x86-edx))
           (x86-push cgc (x86-eax))           ;; put character to write on stack
           (x86-mov  cgc (x86-ecx) (x86-esp)) ;; get address of character in %ecx
           (x86-mov  cgc (x86-edx) (x86-imm-int 1)) ;; number of bytes to write = 1
           (x86-mov  cgc (x86-ebx) (x86-imm-int 1)) ;; "stdout" is file descriptor 1
           (x86-mov  cgc (x86-eax) (x86-imm-int 4)) ;; "write" system call is 4
           (x86-int  cgc #x80)                      ;; perform system call (int 0x80)
           (x86-add  cgc (x86-esp) (x86-imm-int 4)) ;; pop what was pushed
           (x86-pop  cgc (x86-edx))
           (x86-pop  cgc (x86-ecx))
           (x86-pop  cgc (x86-ebx))
           (x86-ret cgc))

          ((x86-64)
           (x86-label cgc write_char-lbl)
           ;; Save args + destroyed registers
           (x86-push cgc (x86-rdi))
           (x86-push cgc (x86-rsi))
           (x86-push cgc (x86-rdx))
           (x86-push cgc (x86-rcx))
           (x86-push cgc (x86-r11))
           (x86-push cgc (x86-rax))

           ;; Prepare write syscall
           (x86-mov cgc (x86-rdi) (x86-imm-int 1)) ; fd = stdout
           (x86-mov cgc (x86-rsi) (x86-rsp))       ; buf = 0(%esp)
           (x86-mov cgc (x86-rdx) (x86-imm-int 1)) ; count = 1
           (x86-mov cgc (x86-rax) (x86-imm-int 1)) ; write
           (x86-syscall cgc)

           (x86-pop cgc (x86-rax))
           (x86-pop cgc (x86-r11))
           (x86-pop cgc (x86-rcx))
           (x86-pop cgc (x86-rdx))
           (x86-pop cgc (x86-rsi))
           (x86-pop cgc (x86-rdi))
           (x86-ret cgc))))
))


;;;============================================================================
