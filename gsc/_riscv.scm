;;;============================================================================

;;; File: "_riscv.scm"

;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

;;;============================================================================

;;; This module implements the RISC-V instruction encoding.

(namespace ("_riscv#") ("" include))
(include "~~lib/gambit#.scm")

(include "_assert#.scm")
(include "_asm#.scm")
(include "_riscv#.scm")
(include "_codegen#.scm")

(riscv-implement)

;;;============================================================================

;;; Architecture selection (either RV32I or RV64I).

(define (riscv-arch-set! cgc arch)
  (codegen-context-arch-set! cgc arch))

(define (riscv-64bit-mode? cgc)
  (eq? (codegen-context-arch cgc) 'RV64I))

(define (riscv-word-width cgc)
  (if (riscv-64bit-mode? cgc) 64 32))

(define-macro (riscv-assert-64bit-mode cgc)
  `(assert (riscv-64bit-mode? ,cgc)
    "instruction only valid for RV64I"))

(define-macro (riscv-assert-32bit-mode cgc)
  `(assert (not (riscv-64bit-mode? ,cgc))
    "instruction only valid for RV32I"))

;;;----------------------------------------------------------------------------

;;; Instruction operands.

(define (riscv-imm? x) (pair? x))

(define (riscv-imm-int value #!optional (type 'I)) (cons type value))
(define (riscv-imm-int? x) (and (pair? x) (symbol? (car x)) (number? (cdr x)))) ; XXX
(define (riscv-imm-int-type x) (car x))
(define (riscv-imm-int-value x) (cdr x))

(define (riscv-imm-lbl label #!optional (offset 4)) (cons offset label)) ; XXX
(define (riscv-imm-lbl? x) (and (pair? x) (fixnum? (car x)) (vector? (cdr x))))
(define (riscv-imm-lbl-offset x) (car x))
(define (riscv-imm-lbl-label x) (cdr x))

(define (riscv-imm->instr imm)
  (let ((val (riscv-imm-int-value imm)))
    (fxand
      #xffffffff
      (case (riscv-imm-int-type imm)
        ((I) (fxarithmetic-shift val 20))
        ((S) (fx+ (fxarithmetic-shift (fxand val #x1f) 7)
                  (fxarithmetic-shift (fxand val #xfe0) 20)))
        ((B) (assert (fxeven? val)
                     "invalid immediate value")
             (fx+ (fxarithmetic-shift (fxand val #x800) -4)
                  (fxarithmetic-shift (fxand val #x1e) 7)
                  (fxarithmetic-shift (fxand val #x7e0) 20)
                  (fxarithmetic-shift (fxand val #x1000) 19)))
        ((U) (assert (fxzero? (fxand val #xfff))
                     "invalid immediate value")
             val)
        ((J) (assert (fxeven? val)
                     "invalid immediate value")
             (fx+ (fxand val #xff000)
                  (fxarithmetic-shift (fxand val #x800) 9)
                  (fxarithmetic-shift (fxand val #x7fe) 20)
                  (fxarithmetic-shift (fxand val #x100000) 11)))
        (else (error "invalid immediate type" imm))))))

;;;----------------------------------------------------------------------------

;;; Listing generation.

(define (riscv-listing cgc mnemonic . opnds)

  (define (opnd-format opnd)
    (cond ((riscv-reg? opnd)
           (riscv-register-name opnd))
          ((riscv-imm? opnd)
           (cond ((riscv-imm-int? opnd)
                  (riscv-imm-int-value opnd))
                 ((riscv-imm-lbl? opnd)
                  (asm-label-name (riscv-imm-lbl-label opnd)))
                 (else
                   (error "unsupported immediate" opnd))))
          (else
            opnd)))

  (define (instr-format)
    (let ((operands (asm-separated-list (map opnd-format opnds) ", ")))
      (cons #\tab
            (cons mnemonic
                  (if (pair? operands)
                      (cons #\tab operands)
                      '())))))

  (asm-listing cgc (instr-format)))

;;;----------------------------------------------------------------------------

;;; Pseudo operations.

(define (riscv-label cgc label)
  (asm-label cgc label)
  (if (codegen-context-listing-format cgc)
      (asm-listing cgc (list (asm-label-name label) ":"))))

(define (riscv-db cgc . elems)
  (riscv-data-elems cgc elems 8))

(define (riscv-d2b cgc . elems)
  (riscv-data-elems cgc elems 16))

(define (riscv-dh cgc . elems)
  (riscv-data-elems cgc elems 16))

(define (riscv-ds cgc . elems)
  (riscv-data-elems cgc elems 16))

(define (riscv-d4b cgc . elems)
  (riscv-data-elems cgc elems 32))

(define (riscv-dw cgc . elems)
  (riscv-data-elems cgc elems 32))

(define (riscv-dl cgc . elems)
  (riscv-data-elems cgc elems 32))

(define (riscv-d8b cgc . elems)
  (riscv-data-elems cgc elems 64))

(define (riscv-dd cgc . elems)
  (riscv-data-elems cgc elems 64))

(define (riscv-dq cgc . elems)
  (riscv-data-elems cgc elems 64))

(define (riscv-data-elems cgc elems width) ; XXX

  (define max-per-line 4)

  (let ((v (list->vector elems)))
    (let loop1 ((i 0))
      (if (fx< i (vector-length v))
          (let ((lim (fxmin (fx+ i max-per-line) (vector-length v))))
            (let loop2 ((j i) (rev-lst '()))
              (if (fx< j lim)
                  (let ((x (vector-ref v j)))
                    (asm-int-le cgc x width)
                    (loop2 (fx+ j 1) (cons x rev-lst)))
                  (begin
                    (if (codegen-context-listing-format cgc)
                        (asm-listing
                          cgc
                          (list #\tab
                                (cond ((fx= width 8)  ".byte")
                                      ((fx= width 16) ".half")
                                      ((fx= width 32) ".word")
                                      ((fx= width 64) ".dword")
                                      (else (error "unknown data width")))
                                #\tab
                                (asm-separated-list (reverse rev-lst) ","))))
                    (loop1 lim)))))))))

;;;----------------------------------------------------------------------------

;;; XXX Pseudo instructions.

; (define (riscv-la cgc rd symbol))
; (define (riscv-lb cgc rd symbol))
; (define (riscv-lh cgc rd symbol))
; (define (riscv-lw cgc rd symbol))
; (define (riscv-ld cgc rd symbol))
; (define (riscv-sb cgc rd symbol rt))
; (define (riscv-sh cgc rd symbol rt))
; (define (riscv-sw cgc rd symbol rt))
; (define (riscv-sd cgc rd symbol rt))

(define (riscv-nop cgc)
  (riscv-addi cgc (riscv-x0) (riscv-x0) (riscv-imm-int 0)))
(define (riscv-li cgc rd immediate) ; XXX Implementation inspired from LLVM
  (let* ((val (riscv-imm-int-value immediate))
         (lo12 (- (bitwise-and (+ val #x800) #xfff) #x800))
         (hi52 (arithmetic-shift (+ val #x800) -12)))
    (if (and (>= val -2147483648) (<= val 2147483647))
        (let ((hi20 (bitwise-and hi52 #xfffff)))
          (if (not (zero? hi20))
              (riscv-lui cgc rd (riscv-imm-int (arithmetic-shift hi20 12) 'U)))
          (if (or (not (zero? lo12)) (zero? hi20))
              (let ((instr (if (riscv-64bit-mode? cgc) riscv-addiw riscv-addi))
                    (rs (if (zero? hi20) (riscv-x0) rd)))
                (instr cgc rd rs (riscv-imm-int lo12)))))
        (begin
          (riscv-assert-64bit-mode cgc)
          (let* ((shamt (+ 12 (first-set-bit (asm-unsigned-lo64 hi52))))
                 (hi52 (arithmetic-shift
                         (asm-signed-lo64 (arithmetic-shift
                                            (arithmetic-shift hi52 (- (- shamt 12)))
                                            shamt))
                         (- shamt))))
            (riscv-li cgc rd (riscv-imm-int hi52))
            (riscv-slli cgc rd rd shamt)
            (if (not (zero? lo12))
                (riscv-addi cgc rd rd (riscv-imm-int lo12))))))))
(define (riscv-mv cgc rd rs)
  (riscv-addi cgc rd rs (riscv-imm-int 0)))
(define (riscv-not cgc rd rs)
  (riscv-xori cgc rd rs (riscv-imm-int -1)))
(define (riscv-neg cgc rd rs)
  (riscv-sub cgc rd (riscv-x0) rs))
(define (riscv-negw cgc rd rs)
  (riscv-subw cgc rd (riscv-x0) rs))
(define (riscv-sext.w cgc rd rs)
  (riscv-addiw cgc rd rs (riscv-imm-int 0)))
(define (riscv-seqz cgc rd rs)
  (riscv-sltiu cgc rd rs (riscv-imm-int 1)))
(define (riscv-snez cgc rd rs)
  (riscv-sltu cgc rd (riscv-x0) rs))
(define (riscv-sltz cgc rd rs)
  (riscv-slt cgc rd rs (riscv-x0)))
(define (riscv-sgtz cgc rd rs)
  (riscv-slt cgc rd (riscv-x0) rs))

(define (riscv-beqz cgc rs offset)
  (riscv-beq cgc rs (riscv-x0) offset))
(define (riscv-bnez cgc rs offset)
  (riscv-bne cgc rs (riscv-x0) offset))
(define (riscv-blez cgc rs offset)
  (riscv-bge cgc (riscv-x0) rs offset))
(define (riscv-bgez cgc rs offset)
  (riscv-bge cgc rs (riscv-x0) offset))
(define (riscv-bltz cgc rs offset)
  (riscv-blt cgc rs (riscv-x0) offset))
(define (riscv-bgtz cgc rs offset)
  (riscv-blt cgc (riscv-x0) rs offset))

(define (riscv-bgt cgc rs rt offset)
  (riscv-blt cgc rt rs offset))
(define (riscv-ble cgc rs rt offset)
  (riscv-bge cgc rt rs offset))
(define (riscv-bgtu cgc rs rt offset)
  (riscv-bltu cgc rt rs offset))
(define (riscv-bleu cgc rs rt offset)
  (riscv-bgeu cgc rt rs offset))

(define (riscv-j cgc offset)
  (riscv-jal cgc (riscv-x0) offset))
(define (riscv-jal* cgc offset)
  (riscv-jal cgc (riscv-x1) offset))
(define (riscv-jr cgc rs)
  (riscv-jalr cgc (riscv-x0) rs (riscv-imm-int 0)))
(define (riscv-jalr* cgc rs)
  (riscv-jalr cgc (riscv-x1) rs (riscv-imm-int 0)))
(define (riscv-ret cgc)
  (riscv-jalr cgc (riscv-x0) (riscv-x1) (riscv-imm-int 0)))
; XXX Repetition
(define (riscv-call cgc offset)
  (riscv-auipc cgc (riscv-x6)
               (riscv-imm-int (fxand (riscv-imm-int-value offset) #xfffff000) 'U)) ; XXX
  (riscv-jalr cgc (riscv-x1) (riscv-x6)
              (riscv-imm-int (fxand (riscv-imm-int-value offset) #xfff)))) ; XXX
(define (riscv-tail cgc offset)
  (riscv-auipc cgc (riscv-x6)
               (riscv-imm-int (fxand (riscv-imm-int-value offset) #xfffff000) 'U)) ; XXX
  (riscv-jalr cgc (riscv-x0) (riscv-x6)
              (riscv-imm-int (fxand (riscv-imm-int-value offset) #xfff)))) ; XXX

;; TODO Pseudoinstructions for accessing control and status registers

;;;----------------------------------------------------------------------------

;;; RISC-V R-type instructions: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND,
;;; ADDW, SUBW, SLLW, SRLW, SRAW.

(define (riscv-add cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x0000))

(define (riscv-sub cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x0000 #x33 #x40000000))

(define (riscv-sll cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x1000))

(define (riscv-slt cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x2000))

(define (riscv-sltu cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x3000))

(define (riscv-xor cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x4000))

(define (riscv-srl cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x5000))

(define (riscv-sra cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x5000 #x33 #x40000000))

(define (riscv-or cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x6000))

(define (riscv-and cgc rd rs1 rs2)
  (riscv-type-r cgc rd rs1 rs2 #x7000))

(define (riscv-addw cgc rd rs1 rs2)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-r cgc rd rs1 rs2 #x0000 #x3b))

(define (riscv-subw cgc rd rs1 rs2)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-r cgc rd rs1 rs2 #x0000 #x3b #x40000000))

(define (riscv-sllw cgc rd rs1 rs2)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-r cgc rd rs1 rs2 #x1000 #x3b))

(define (riscv-srlw cgc rd rs1 rs2)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-r cgc rd rs1 rs2 #x5000 #x3b))

(define (riscv-sraw cgc rd rs1 rs2)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-r cgc rd rs1 rs2 #x5000 #x3b #x40000000))

(define (riscv-type-r cgc rd rs1 rs2 funct3 #!optional (opcode #x33) (funct7 #x0))

  (assert (and (riscv-reg? rd)
               (riscv-reg? rs1)
               (riscv-reg? rs2))
          "invalid operands")

  (asm-32-le cgc
             (fx+ opcode
                  (fxarithmetic-shift
                    (riscv-reg-field rd)
                    7)
                  funct3
                  (fxarithmetic-shift
                    (riscv-reg-field rs1)
                    15)
                  (fxarithmetic-shift
                    (riscv-reg-field rs2)
                    20)
                  funct7))

  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc
                     (list (vector-ref
                             (if (fx= funct7 #x0)
                                 #("add" "sll" "slt" "sltu" "xor" "srl" "or" "and")
                                 #("sub" "???" "???" "????" "???" "sra" "??" "???"))
                             (fxarithmetic-shift funct3 -12))
                           (if (fx= opcode #x3b) "w" ""))
                     rd
                     rs1
                     rs2)))

;;;----------------------------------------------------------------------------

;;; RISC-V I-type instructions: JALR, LB, LH, LW, LBU, LHU, ADDI, SLTI, SLTIU,
;;; XORI, ORI, ANDI, SLLI, SRLI, SRAI, LWU, LD, ADDIW, SLLIW, SRLIW, SRAIW.

(define (riscv-jalr cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x0000 #x67)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "jalr" rd rs1 imm)))

(define (riscv-lb cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x0000 #x03))

(define (riscv-lh cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x1000 #x03))

(define (riscv-lw cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x2000 #x03))

(define (riscv-lbu cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x4000 #x03))

(define (riscv-lhu cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x5000 #x03))

(define (riscv-addi cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x0000))

(define (riscv-slti cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x2000))

(define (riscv-sltiu cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x3000))

(define (riscv-xori cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x4000))

(define (riscv-ori cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x6000))

(define (riscv-andi cgc rd rs1 imm)
  (riscv-type-i cgc rd rs1 imm #x7000))

(define (riscv-slli cgc rd rs1 shamt) ; XXX
  (assert (and (fx>= shamt 0) (fx< shamt (riscv-word-width cgc)))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int shamt) #x1000))

(define (riscv-srli cgc rd rs1 shamt) ; XXX
  (assert (and (fx>= shamt 0) (fx< shamt (riscv-word-width cgc)))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int shamt) #x5000))

(define (riscv-srai cgc rd rs1 shamt) ; XXX
  (assert (and (fx>= shamt 0) (fx< shamt (riscv-word-width cgc)))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int (fx+ #x400 shamt)) #x5000))

(define (riscv-lwu cgc rd rs1 imm)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-i cgc rd rs1 imm #x6000 #x03))

(define (riscv-ld cgc rd rs1 imm)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-i cgc rd rs1 imm #x3000 #x03))

(define (riscv-addiw cgc rd rs1 imm)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-i cgc rd rs1 imm #x0000 #x1b))

(define (riscv-slliw cgc rd rs1 shamt) ; XXX
  (riscv-assert-64bit-mode cgc)
  (assert (and (fx>= shamt 0) (fx< shamt 32))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int shamt) #x1000 #x1b))

(define (riscv-srliw cgc rd rs1 shamt) ; XXX
  (riscv-assert-64bit-mode cgc)
  (assert (and (fx>= shamt 0) (fx< shamt 32))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int shamt) #x5000 #x1b))

(define (riscv-sraiw cgc rd rs1 shamt) ; XXX
  (riscv-assert-64bit-mode cgc)
  (assert (and (fx>= shamt 0) (fx< shamt 32))
          "improper shift amount")
  (riscv-type-i cgc rd rs1 (riscv-imm-int (fx+ #x400 shamt)) #x5000 #x1b))

(define (riscv-type-i cgc rd rs1 imm funct3 #!optional (opcode #x13))

  (assert (and (riscv-reg? rd)
               (riscv-reg? rs1)
               (riscv-imm? imm))
          "invalid operands")

  (assert (and (riscv-imm-int? imm)
               (eq? (riscv-imm-int-type imm) 'I))
          "incorrect immediate type")

  (asm-32-le cgc
             (fx+ opcode
                  (fxarithmetic-shift
                    (riscv-reg-field rd)
                    7)
                  funct3
                  (fxarithmetic-shift
                    (riscv-reg-field rs1)
                    15)
                  (riscv-imm->instr imm)))

  (if (codegen-context-listing-format cgc)
      (cond ((fx= opcode #x03)
             (riscv-listing cgc
                            (vector-ref
                              #("lb" "lh" "lw" "ld" "lbu" "lhu" "lwu")
                              (fxarithmetic-shift funct3 -12))
                            rd
                            (string-append (number->string (riscv-imm-int-value imm))
                                           "(" (riscv-register-name rs1) ")")))
            ((or (fx= opcode #x13) (fx= opcode #x1b)) ; XXX
             (riscv-listing cgc
                            (list (vector-ref
                                    (vector "addi" "slli" "slti" "sltiu" "xori"
                                            (if (fxbit-set? 30 (riscv-imm-int-value imm)) "srai" "srli")
                                            "ori" "andi")
                                    (fxarithmetic-shift funct3 -12))
                                  (if (fx= opcode #x1b) "w" ""))
                            rd
                            rs1
                            (if (or (fx= funct3 #x1000) (fx= funct3 #x5000))
                                (fxand (if (and (riscv-64bit-mode? cgc) (fx= opcode #x13)) #x3f #x1f)
                                       (fxarithmetic-shift (riscv-imm-int-value imm) -20))
                                imm))))))

;;;----------------------------------------------------------------------------

;;; RISC-V S-type instructions: SB, SH, SW, SD.

(define (riscv-sb cgc rs1 rs2 imm)
  (riscv-type-s cgc rs1 rs2 imm #x0000))

(define (riscv-sh cgc rs1 rs2 imm)
  (riscv-type-s cgc rs1 rs2 imm #x1000))

(define (riscv-sw cgc rs1 rs2 imm)
  (riscv-type-s cgc rs1 rs2 imm #x2000))

(define (riscv-sd cgc rs1 rs2 imm)
  (riscv-assert-64bit-mode cgc)
  (riscv-type-s cgc rs1 rs2 imm #x3000))

(define (riscv-type-s cgc rs1 rs2 imm funct3 #!optional (opcode #x23))

  (assert (and (riscv-reg? rs1)
               (riscv-reg? rs2)
               (riscv-imm? imm))
          "invalid operands")

  (assert (and (riscv-imm-int? imm)
               (eq? (riscv-imm-int-type imm) 'S))
          "incorrect immediate type")

  (asm-32-le cgc
             (fx+ opcode
                  funct3
                  (fxarithmetic-shift
                    (riscv-reg-field rs1)
                    15)
                  (fxarithmetic-shift
                    (riscv-reg-field rs2)
                    20)
                  (riscv-imm->instr imm)))

  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc
                     (vector-ref
                       #("sb" "sh" "sw" "sd")
                       (fxarithmetic-shift funct3 -12))
                     rs2
                     (string-append (number->string (riscv-imm-int-value imm))
                                    "(" (riscv-register-name rs1) ")"))))

;;;----------------------------------------------------------------------------

;;; RISC-V B-type instructions: BEQ, BNE, BLT, BGE, BLTU, BGEU.

(define (riscv-beq cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x0000))

(define (riscv-bne cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x1000))

(define (riscv-blt cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x4000))

(define (riscv-bge cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x5000))

(define (riscv-bltu cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x6000))

(define (riscv-bgeu cgc rs1 rs2 imm)
  (riscv-type-b cgc rs1 rs2 imm #x7000))

(define (riscv-type-b cgc rs1 rs2 imm funct3 #!optional (opcode #x63))

  (define (label-dist self imm)
    (fx- (asm-label-pos (riscv-imm-lbl-label imm))
         (fx+ self (riscv-imm-lbl-offset imm))))

  (define (instr-code imm)
    (asm-32-le cgc
               (fx+ opcode
                    funct3
                    (fxarithmetic-shift
                      (riscv-reg-field rs1)
                      15)
                    (fxarithmetic-shift
                      (riscv-reg-field rs2)
                      20)
                    (riscv-imm->instr imm))))

  (assert (and (riscv-reg? rs1)
               (riscv-reg? rs2)
               (riscv-imm? imm))
          "invalid operands")

  (assert (or (riscv-imm-lbl? imm)
              (and (riscv-imm-int? imm)
                   (eq? (riscv-imm-int-type imm) 'B)))
          "incorrect immediate type")

  (if (riscv-imm-int? imm)
      (instr-code imm)
      (asm-at-assembly cgc
                       (lambda (cgc self)
                         4) ; XXX
                       (lambda (cgc self)
                         (let* ((dist (label-dist self imm))
                                (imm (riscv-imm-int dist 'B))) ; XXX

                           (assert (and (fx>= dist -4096) (fx<= dist 4094))
                                   "branch label too far")

                           (instr-code imm)))))

  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc
                     (vector-ref
                       #("beq" "bne" "????" "????"
                         "blt" "bge" "bltu" "bgeu")
                       (fxarithmetic-shift funct3 -12))
                     rs1
                     rs2
                     imm)))

;;;----------------------------------------------------------------------------

;;; RISC-V U-type instructions: LUI, AUIPC.

(define (riscv-lui cgc rd imm)
  (riscv-type-u cgc rd imm #x37)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "lui" rd imm)))

(define (riscv-auipc cgc rd imm)
  (riscv-type-u cgc rd imm #x17)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "auipc" rd imm)))

(define (riscv-type-u cgc rd imm opcode)

  (assert (and (riscv-reg? rd)
               (riscv-imm? imm))
          "invalid operands")

  (assert (and (riscv-imm-int? imm)
               (eq? (riscv-imm-int-type imm) 'U))
          "incorrect immediate type")

  (asm-32-le cgc
             (fx+ opcode
                  (fxarithmetic-shift
                    (riscv-reg-field rd)
                    7)
                  (riscv-imm->instr imm))))

;;;----------------------------------------------------------------------------

;;; RISC-V J-type instructions: JAL.

(define (riscv-jal cgc rd imm)
  (riscv-type-j cgc rd imm #x6f)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "jal" rd imm)))

(define (riscv-type-j cgc rd imm opcode)

  (define (label-dist self imm)
    (fx- (asm-label-pos (riscv-imm-lbl-label imm))
         (fx+ self (riscv-imm-lbl-offset imm))))

  (define (instr-code imm)
    (asm-32-le cgc
               (fx+ opcode
                    (fxarithmetic-shift
                      (riscv-reg-field rd)
                      7)
                    (riscv-imm->instr imm))))

  (assert (and (riscv-reg? rd)
               (riscv-imm? imm))
          "invalid operands")

  (assert (or (riscv-imm-lbl? imm)
              (and (riscv-imm-int? imm)
                   (eq? (riscv-imm-int-type imm) 'J)))
          "incorrect immediate type")

  (if (riscv-imm-int? imm)
      (instr-code imm)
      (asm-at-assembly cgc
                       (lambda (cgc self)
                         4) ; XXX
                       (lambda (cgc self)
                         (let* ((dist (label-dist self imm))
                                (imm (riscv-imm-int dist 'J))) ; XXX

                           (assert (and (fx>= dist -1048576) (fx<= dist 1048574))
                                   "branch label too far")

                           (instr-code imm))))))

;;;----------------------------------------------------------------------------

;;; RISC-V instructions: FENCE, FENCE.I, ECALL, EBREAK.

(define (riscv-fence cgc #!optional (pred #b1111) (succ #b1111)) ; XXX

  (define (print-iorw val)
    (string-append (if (fxbit-set? 3 val) "i" "")
                   (if (fxbit-set? 2 val) "o" "")
                   (if (fxbit-set? 1 val) "r" "")
                   (if (fxbit-set? 0 val) "w" "")))

  (assert (and (fx> pred 0) (fx< pred 16))
          "improper predecessor value")
  (assert (and (fx> succ 0) (fx< succ 16))
          "improper successor value")

  (asm-32-le cgc (fx+ #xf
                      (fxarithmetic-shift succ 20)
                      (fxarithmetic-shift pred 24)))

  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "fence" (print-iorw pred) (print-iorw succ))))

(define (riscv-fence.i cgc)
  (asm-32-le cgc #x100f)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "fence.i")))

(define (riscv-ecall cgc)
  (asm-32-le cgc #x73)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "ecall")))

(define (riscv-ebreak cgc)
  (asm-32-le cgc #x100073)
  (if (codegen-context-listing-format cgc)
      (riscv-listing cgc "ebreak")))

;;;----------------------------------------------------------------------------

;;; TODO RISC-V CSR instructions: CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI.

;;;============================================================================
