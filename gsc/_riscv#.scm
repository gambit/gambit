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
  (let* ((names
           (make-vector 33))
         (defs
           (map (lambda (r)
                  (let ((name (symbol->string (car r)))
                        (code (cadr r)))
                    (vector-set! names code name)
                    `(define-macro (,(string->symbol
                                       (string-append "riscv-" name)))
                       ,code)))
                regs)))
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
  (x0   0)  ;; hardwired to 0, ignores writes
  (x1   1)  ;; return address for jumps
  (x2   2)  ;; stack pointer
  (x3   3)  ;; global pointer
  (x4   4)  ;; thread pointer
  (x5   5)  ;; temporary register 0
  (x6   6)  ;; temporary register 1
  (x7   7)  ;; temporary register 2
  (x8   8)  ;; saved register 0 or frame pointer
  (x9   9)  ;; saved register 1
  (x10 10)  ;; return value or function argument 0
  (x11 11)  ;; return value or function argument 1
  (x12 12)  ;; function argument 2
  (x13 13)  ;; function argument 3
  (x14 14)  ;; function argument 4
  (x15 15)  ;; function argument 5
  (x16 16)  ;; function argument 6
  (x17 17)  ;; function argument 7
  (x18 18)  ;; saved register 2
  (x19 19)  ;; saved register 3
  (x20 20)  ;; saved register 4
  (x21 21)  ;; saved register 5
  (x22 22)  ;; saved register 6
  (x23 23)  ;; saved register 7
  (x24 24)  ;; saved register 8
  (x25 25)  ;; saved register 9
  (x26 26)  ;; saved register 10
  (x27 27)  ;; saved register 11
  (x28 28)  ;; temporary register 3
  (x29 29)  ;; temporary register 4
  (x30 30)  ;; temporary register 5
  (x31 31)  ;; temporary register 6
  (pc  32)) ;; program counter

;;;============================================================================
