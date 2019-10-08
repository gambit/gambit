;;;============================================================================

;;; File: "_riscv#.scm"

;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

;;;============================================================================

(namespace ("_riscv#"

riscv-implement

riscv-registers-implement
riscv-register-name
riscv-reg?
riscv-reg-field

riscv-x0
riscv-x1
riscv-x2
riscv-x3
riscv-x4
riscv-x5
riscv-x6
riscv-x7
riscv-x8
riscv-x9
riscv-x10
riscv-x11
riscv-x12
riscv-x13
riscv-x14
riscv-x15
riscv-x16
riscv-x17
riscv-x18
riscv-x19
riscv-x20
riscv-x21
riscv-x22
riscv-x23
riscv-x24
riscv-x25
riscv-x26
riscv-x27
riscv-x28
riscv-x29
riscv-x30
riscv-x31
riscv-pc

riscv-zero
riscv-ra
riscv-sp
riscv-gp
riscv-tp
riscv-t0
riscv-t1
riscv-t2
riscv-s0
riscv-fp
riscv-s1
riscv-a0
riscv-a1
riscv-a2
riscv-a3
riscv-a4
riscv-a5
riscv-a6
riscv-a7
riscv-s2
riscv-s3
riscv-s4
riscv-s5
riscv-s6
riscv-s7
riscv-s8
riscv-s9
riscv-s10
riscv-s11
riscv-t3
riscv-t4
riscv-t5
riscv-t6

riscv-arch-set!
riscv-64bit-mode?
riscv-word-width

riscv-imm?
riscv-imm-int
riscv-imm-int?
riscv-imm-int-type
riscv-imm-int-value
riscv-imm-lbl
riscv-imm-lbl?
riscv-imm-lbl-offset
riscv-imm-lbl-label
riscv-imm->instr

riscv-listing

riscv-label
riscv-db
riscv-d2b
riscv-dh
riscv-ds
riscv-d4b
riscv-dw
riscv-dl
riscv-d8b
riscv-dd
riscv-dq

riscv-nop
riscv-li
riscv-mv
riscv-not
riscv-neg
riscv-negw
riscv-sext.w
riscv-seqz
riscv-snez
riscv-sltz
riscv-sgtz

riscv-beqz
riscv-bnez
riscv-blez
riscv-bgez
riscv-bltz
riscv-bgtz

riscv-bgt
riscv-ble
riscv-bgtu
riscv-bleu

riscv-j
riscv-jr
riscv-ret
riscv-call
riscv-tail

riscv-add
riscv-sub
riscv-sll
riscv-slt
riscv-sltu
riscv-xor
riscv-srl
riscv-sra
riscv-or
riscv-and
riscv-addw
riscv-subw
riscv-sllw
riscv-srlw
riscv-sraw
riscv-jalr
riscv-lb
riscv-lh
riscv-lw
riscv-lbu
riscv-lhu
riscv-addi
riscv-slti
riscv-sltiu
riscv-xori
riscv-ori
riscv-andi
riscv-slli
riscv-srli
riscv-srai
riscv-lwu
riscv-ld
riscv-addiw
riscv-slliw
riscv-srliw
riscv-sraiw

riscv-sb
riscv-sh
riscv-sw
riscv-sd

riscv-beq
riscv-bne
riscv-blt
riscv-bge
riscv-bltu
riscv-bgeu

riscv-lui
riscv-auipc

riscv-jal

riscv-fence
riscv-fence.i
riscv-ecall
riscv-ebreak

))

;;;============================================================================

(define-macro (riscv-implement)
  `(begin
     (riscv-registers-implement)))

(define-macro (riscv-define-registers . regs)
  (let* ((names (make-vector 33))
         (defs (apply
                 append
                 (map (lambda (r)
                        (let ((code (car r)))
                          (vector-set! names code (symbol->string (cadr r)))
                          (map (lambda (name)
                                 `(define-macro (,(string->symbol
                                                    (string-append "riscv-"
                                                                   (symbol->string name))))
                                    ,code))
                               (cdr r))))
                      regs)))) ; XXX
    `(begin
       (define-macro (riscv-registers-implement)
         `(begin
            (define (riscv-register-name reg)
              (vector-ref ',',names reg))))
       (define-macro (riscv-reg? x)
         `(fixnum? ,x))
       (define-macro (riscv-reg-field reg)
         reg)
       ,@defs)))

(riscv-define-registers
  (0 x0 zero)  ;; hardwired to 0, ignores writes
  (1 x1 ra)    ;; return address for jumps
  (2 x2 sp)    ;; stack pointer
  (3 x3 gp)    ;; global pointer
  (4 x4 tp)    ;; thread pointer
  (5 x5 t0)    ;; temporary register 0
  (6 x6 t1)    ;; temporary register 1
  (7 x7 t2)    ;; temporary register 2
  (8 x8 s0 fp) ;; saved register 0 or frame pointer
  (9 x9 s1)    ;; saved register 1
  (10 x10 a0)  ;; return value or function argument 0
  (11 x11 a1)  ;; return value or function argument 1
  (12 x12 a2)  ;; function argument 2
  (13 x13 a3)  ;; function argument 3
  (14 x14 a4)  ;; function argument 4
  (15 x15 a5)  ;; function argument 5
  (16 x16 a6)  ;; function argument 6
  (17 x17 a7)  ;; function argument 7
  (18 x18 s2)  ;; saved register 2
  (19 x19 s3)  ;; saved register 3
  (20 x20 s4)  ;; saved register 4
  (21 x21 s5)  ;; saved register 5
  (22 x22 s6)  ;; saved register 6
  (23 x23 s7)  ;; saved register 7
  (24 x24 s8)  ;; saved register 8
  (25 x25 s9)  ;; saved register 9
  (26 x26 s10) ;; saved register 10
  (27 x27 s11) ;; saved register 11
  (28 x28 t3)  ;; temporary register 3
  (29 x29 t4)  ;; temporary register 4
  (30 x30 t5)  ;; temporary register 5
  (31 x31 t6)  ;; temporary register 6
  (32 pc))     ;; program counter

;;;============================================================================
