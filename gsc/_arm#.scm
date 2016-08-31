;;;============================================================================

;;; File: "_arm#.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(namespace (""

arm-implement

arm-registers-implement
arm-register-name
arm-reg?
arm-reg-field
arm-low-reg?
arm-r0
arm-r1
arm-r2
arm-r3
arm-r4
arm-r5
arm-r6
arm-r7
arm-r8
arm-r9
arm-r10
arm-sl
arm-r11
arm-fp
arm-r12
arm-ip
arm-r13
arm-sp
arm-r14
arm-lr
arm-r15
arm-pc

arm-conditions-implement
arm-condition-name
arm-cond-eq
arm-cond-ne
arm-cond-hs
arm-cond-cs
arm-cond-lo
arm-cond-cc
arm-cond-mi
arm-cond-pl
arm-cond-vs
arm-cond-vc
arm-cond-hi
arm-cond-ls
arm-cond-ge
arm-cond-lt
arm-cond-gt
arm-cond-le
arm-cond-al
;;arm-cond-nv

arm-arch-set!
arm-thumb-mode?

arm-imm-int
arm-imm-int?
arm-imm-int-value
arm-imm-int-imm12
arm-imm->imm12
arm-imm32->imm12
arm-imm12->imm32

arm-label
arm-db
arm-dw
arm-dd
arm-dq

arm-b
arm-bl

arm-bx

arm-lsl
arm-lsls
arm-lsr
arm-lsrs
arm-asr
arm-asrs
arm-ror
arm-rors

arm-add
arm-adds
arm-sub
arm-subs

arm-and
arm-ands
arm-eor
arm-eors
arm-adc
arm-adcs
arm-sbc
arm-sbcs
arm-orr
arm-orrs
arm-bic
arm-bics

arm-rsb
arm-rsbs
arm-rsc
arm-rscs

arm-neg
arm-negs

arm-tst
arm-teq
arm-cmp
arm-cmn

arm-mov
arm-movs
arm-mvn
arm-mvns

arm-mul
arm-muls
arm-mla
arm-mlas















arm-data-instructions-implement2;;;;;;;;;;;;;
arm-data-instructions-implement
arm-data-instruction-name
arm-data-instruction2;;;;;;;;;;;;;;;;;;
arm-data-instruction
arm-and
arm-eor
arm-sub
arm-rsb
arm-add
arm-adc
arm-sbc
arm-rsc
arm-tst
arm-teq
arm-cmp
arm-cmn
arm-orr
arm-mov
arm-bic
arm-mvn

arm-movt
arm-movw
arm-addw
arm-subw




thumb-alu-instructions-implement
thumb-alu-instruction-name
thumb-alu-instruction

thumb-lsl-imm
thumb-lsr-imm
thumb-asr-imm
thumb-adds
thumb-adds-imm
thumb-sub
thumb-sub-imm
thumb-mov-imm
thumb-cmp-imm
thumb-adds-imm
thumb-subs-imm

thumb-and
thumb-eor
thumb-lsl
thumb-lsr
thumb-asr
thumb-adc
thumb-sbc
thumb-ror
thumb-tst
thumb-neg
thumb-cmp
thumb-cmn
thumb-orr
thumb-mul
thumb-bic
thumb-mvn

thumb-mov
thumb-bx

))

;;;============================================================================

(define-macro (arm-implement)
  `(begin
     (arm-registers-implement)
     (arm-conditions-implement)
;;;;;;;;;     (arm-data-instructions-implement)
;;;;;;;;;;     (thumb-alu-instructions-implement)
))

(define-macro (arm-define-registers . regs)
  (let* ((names
          (make-vector 16))
         (defs
           (map (lambda (r)
                  (let ((name (symbol->string (car r)))
                        (code (cadr r)))
                    (vector-set! names code name)
                    `(define-macro (,(string->symbol
                                      (string-append "arm-" name)))
                       ,code)))
                regs)))
    `(begin
       (define-macro (arm-registers-implement)
         `(begin
            (define (arm-register-name reg)
              (vector-ref ',',names reg))))
       (define-macro (arm-reg? x)
         `(fixnum? ,x))
       (define-macro (arm-reg-field reg)
         reg)
       (define-macro (arm-low-reg? reg)
         `(fx<= (arm-reg-field ,reg) 7))
       ,@defs)))

(arm-define-registers
  (r0  0)
  (r1  1)
  (r2  2)
  (r3  3)
  (r4  4)
  (r5  5)
  (r6  6)
  (r7  7)
  (r8  8)
  (tr  9)  ;; thread register
  (r9  9)
  (r10 10)
  (r11 11)
  (r12 12)
  (ip  12) ;; intra-procedure-call scratch register
  (r13 13)
  (sp  13) ;; stack pointer
  (r14 14)
  (lr  14) ;; link register
  (r15 15)
  (pc  15) ;; program counter
)

(define-macro (arm-define-conditions . conds)
  (let* ((names
          (make-vector 16))
         (defs
           (map (lambda (c)
                  (let ((name (symbol->string (car c)))
                        (code (cadr c)))
                    (vector-set! names code name)
                    `(define-macro (,(string->symbol
                                      (string-append "arm-cond-" name)))
                       ,code)))
                conds)))
    `(begin
       (define-macro (arm-conditions-implement)
         `(begin
            (define (arm-condition-name condition)
              (vector-ref ',',names condition))))
       ,@defs)))

(arm-define-conditions
  (eq #b0000) ;; Z set (equal)
  (ne #b0001) ;; Z clear (not equal)
  (hs #b0010) ;; C set (unsigned higher or same)
  (cs #b0010) ;; C set (carry set)
  (lo #b0011) ;; C clear (unsigned lower)
  (cc #b0011) ;; C clear (carry clear)
  (mi #b0100) ;; N set (negative)
  (pl #b0101) ;; N clear (positive or zero)
  (vs #b0110) ;; V set (overflow)
  (vc #b0111) ;; V clear (no overflow)
  (hi #b1000) ;; C set and Z clear (unsigned higher)
  (ls #b1001) ;; C clear or Z set (unsigned lower or same)
  (ge #b1010) ;; N equal V (greater or equal)
  (lt #b1011) ;; N not equal V (less)
  (gt #b1100) ;; Z clear, and N equal V (greater)
  (le #b1101) ;; Z set, or N not equal V (less or equal)
  (al #b1110) ;; always
;; (nv #b1111) ;; never
)

(define-macro (arm-define-data-instructions . instrs)
  (let* ((names
          (make-vector 16))
         (defs
           (apply
            append
            (map (lambda (i)
                   (let ((name (symbol->string (car i)))
                         (code (cadr i)))
                     (vector-set! names code name)
                     `((define (,(string->symbol
                                  (string-append "arm-" name))
                                cgc
                                rd
                                rn
                                opnd2
                                #!optional
                                (condition (arm-cond-al)))
                         (arm-data-instruction cgc
                                               rd
                                               rn
                                               opnd2
                                               condition
                                               ,(* code 2)))
                       (define (,(string->symbol
                                  (string-append "arm-" name "s"))
                                cgc
                                rd
                                rn
                                opnd2
                                #!optional
                                (condition (arm-cond-al)))
                         (arm-data-instruction cgc
                                               rd
                                               rn
                                               opnd2
                                               condition
                                               ,(+ (* code 2) 1))))))
                 instrs))))
    `(begin
       (define-macro (arm-data-instructions-implement)
         `(begin
            (define (arm-data-instruction-name instr)
              (vector-ref ',',names instr))))
       ,@defs)))

#;
(arm-define-data-instructions
  (and #b0000) ;; and
  (eor #b0001) ;; exclusive or
  (sub #b0010) ;; substract
  (rsb #b0011) ;; reverse substract
  (add #b0100) ;; add
  (adc #b0101) ;; add with carry
  (sbc #b0110) ;; substract with carry
  (rsc #b0111) ;; reverse substract with carry
  (tst #b1000) ;; test
  (teq #b1001) ;; test for equal
  (cmp #b1010) ;; compare
  (cmn #b1011) ;; compare not
  (orr #b1100) ;; or
  (mov #b1101) ;; move
  (bic #b1110) ;; bit clear
  (mvn #b1111) ;; move not
)

(define-macro (thumb-define-alu-instructions . instrs)
  (let* ((names
          (make-vector 16))
         (defs
           (map (lambda (i)
                  (let ((name (symbol->string (car i)))
                        (code (cadr i)))
                    (vector-set! names code name)
                    `(define (,(string->symbol
                                (string-append "thumb-" name))
                              cgc
                              rd
                              rs)
                       (thumb-alu-instruction cgc
                                              rd
                                              rs
                                              ,code))))
                instrs)))
    `(begin
       (define-macro (thumb-alu-instructions-implement)
         `(begin
            (define (thumb-alu-instruction-name instr)
              (vector-ref ',',names instr))))
       ,@defs)))
#;
(thumb-define-alu-instructions
  (and #b0000) ;; and
  (eor #b0001) ;; exclusive or
  (lsl #b0010) ;; logical shift left
  (lsr #b0011) ;; logical shift right
  (asr #b0100) ;; arithmetic shift right
  (adc #b0101) ;; add with carry
  (sbc #b0110) ;; substract with carry
  (ror #b0111) ;; rotate right
  (tst #b1000) ;; test
  (neg #b1001) ;; negate
  (cmp #b1010) ;; compare
  (cmn #b1011) ;; compare not
  (orr #b1100) ;; or
  (mul #b1101) ;; multiply
  (bic #b1110) ;; bit clear
  (mvn #b1111) ;; move not
)


(define-macro (arm-define-data-instructions2 . instrs)
  (let* ((arm-names
          (make-vector 16))
         (thumb-names
          (make-vector 16))
         (defs
           (apply
            append
            (map (lambda (i)
                   (let ((name (symbol->string (car i)))
                         (code (cadr i))
                         (arm-signature (caddr i)))
                     (vector-set! (if arm-signature arm-names thumb-names)
                                  code
                                  name)
                     (case arm-signature
                       ((rd-rn-opnd2)
                        `((define (,(string->symbol
                                     (string-append "arm-" name))
                                   cgc
                                   rd
                                   rn
                                   opnd2
                                   #!optional
                                   (condition (arm-cond-al)))
                            (arm-data-instruction2 cgc
                                                  rd
                                                  rn
                                                  opnd2
                                                  condition
                                                  ,(* code 2)))
                          (define (,(string->symbol
                                     (string-append "arm-" name "s"))
                                   cgc
                                   rd
                                   rn
                                   opnd2
                                   #!optional
                                   (condition (arm-cond-al)))
                            (arm-data-instruction2 cgc
                                                  rd
                                                  rn
                                                  opnd2
                                                  condition
                                                  ,(+ (* code 2) 1)))))
                       ((rd-opnd2)
                        `((define (,(string->symbol
                                     (string-append "arm-" name))
                                   cgc
                                   rd
                                   opnd2
                                   #!optional
                                   (condition (arm-cond-al)))
                            (arm-data-instruction2 cgc
                                                  rd
                                                  #f
                                                  opnd2
                                                  condition
                                                  ,(* code 2)))
                          (define (,(string->symbol
                                     (string-append "arm-" name "s"))
                                   cgc
                                   rd
                                   opnd2
                                   #!optional
                                   (condition (arm-cond-al)))
                            (arm-data-instruction2 cgc
                                                  rd
                                                  #f
                                                  opnd2
                                                  condition
                                                  ,(+ (* code 2) 1)))))
                       ((rn-opnd2)
                        `((define (,(string->symbol
                                     (string-append "arm-" name))
                                   cgc
                                   rn
                                   opnd2
                                   #!optional
                                   (condition (arm-cond-al)))
                            (arm-data-instruction2 cgc
                                                  #f
                                                  rn
                                                  opnd2
                                                  condition
                                                  ,(+ (* code 2) 1)))))
                       (else
                        `((define (,(string->symbol
                                     (string-append "arm-" name))
                                   cgc
                                   rd
                                   rs)
                            (arm-data-instruction2 cgc
                                                  rd
                                                  rn
                                                  #f
                                                  #f
                                                  ,(* code 2))))))))
                 instrs))))
    `(begin
       (define-macro (arm-data-instructions-implement)
         `(begin
            (define (arm-data-instruction-name instr thumb?)
              (or (and thumb?
                       (vector-ref ',',thumb-names instr))
                  (vector-ref ',',arm-names instr)))))
       ,@defs)))

#;
(arm-define-data-instructions2
  ;;   code   arm-signature
  (and #b0000 rd-rn-opnd2) ;; and
  (eor #b0001 rd-rn-opnd2) ;; exclusive or
  (sub #b0010 rd-rn-opnd2) ;; substract
  (rsb #b0011 rd-rn-opnd2) ;; reverse substract
  (add #b0100 rd-rn-opnd2) ;; add
  (adc #b0101 rd-rn-opnd2) ;; add with carry
  (sbc #b0110 rd-rn-opnd2) ;; substract with carry
  (rsc #b0111 rd-rn-opnd2) ;; reverse substract with carry
  (tst #b1000    rn-opnd2) ;; test
  (teq #b1001    rn-opnd2) ;; test for equal
  (cmp #b1010    rn-opnd2) ;; compare
  (cmn #b1011    rn-opnd2) ;; compare not
  (orr #b1100 rd-rn-opnd2) ;; or
  (mov #b1101 rd-opnd2   ) ;; move
  (bic #b1110 rd-rn-opnd2) ;; bit clear
  (mvn #b1111 rd-opnd2   ) ;; move not
  (lsl #b0010 #f         ) ;; logical shift left
  (lsr #b0011 #f         ) ;; logical shift right
  (asr #b0100 #f         ) ;; arithmetic shift right
  (ror #b0111 #f         ) ;; rotate right
  (neg #b1001 #f         ) ;; negate
  (mul #b1101 #f         ) ;; multiply
)


#|

***ARM
Opcode Format
  Bit    Expl.
  31-28  Condition
  27-26  Must be 00b for this instruction
  25     I - Immediate 2nd Operand Flag (0=Register, 1=Immediate)
  24-21  Opcode (0-Fh)               ;*=Arithmetic, otherwise Logical
           0: AND{cond}{S} Rd,Rn,Op2    ;AND logical       Rd = Rn AND Op2
           1: EOR{cond}{S} Rd,Rn,Op2    ;XOR logical       Rd = Rn XOR Op2
           2: SUB{cond}{S} Rd,Rn,Op2 ;* ;subtract          Rd = Rn-Op2
           3: RSB{cond}{S} Rd,Rn,Op2 ;* ;subtract reversed Rd = Op2-Rn
           4: ADD{cond}{S} Rd,Rn,Op2 ;* ;add               Rd = Rn+Op2
           5: ADC{cond}{S} Rd,Rn,Op2 ;* ;add with carry    Rd = Rn+Op2+Cy
           6: SBC{cond}{S} Rd,Rn,Op2 ;* ;sub with carry    Rd = Rn-Op2+Cy-1
           7: RSC{cond}{S} Rd,Rn,Op2 ;* ;sub cy. reversed  Rd = Op2-Rn+Cy-1
           8: TST{cond}{P}    Rn,Op2    ;test            Void = Rn AND Op2
           9: TEQ{cond}{P}    Rn,Op2    ;test exclusive  Void = Rn XOR Op2
           A: CMP{cond}{P}    Rn,Op2 ;* ;compare         Void = Rn-Op2
           B: CMN{cond}{P}    Rn,Op2 ;* ;compare neg.    Void = Rn+Op2
           C: ORR{cond}{S} Rd,Rn,Op2    ;OR logical        Rd = Rn OR Op2
           D: MOV{cond}{S} Rd,Op2       ;move              Rd = Op2
           E: BIC{cond}{S} Rd,Rn,Op2    ;bit clear         Rd = Rn AND NOT Op2
           F: MVN{cond}{S} Rd,Op2       ;not               Rd = NOT Op2
  20     S - Set Condition Codes (0=No, 1=Yes) (Must be 1 for opcode 8-B)
  19-16  Rn - 1st Operand Register (R0..R15) (including PC=R15)
              Must be 0000b for MOV/MVN.
  15-12  Rd - Destination Register (R0..R15) (including PC=R15)
              Must be 0000b {or 1111b) for CMP/CMN/TST/TEQ{P}.
  When above Bit 25 I=0 (Register as 2nd Operand)
    When below Bit 4 R=0 - Shift by Immediate
      11-7   Is - Shift amount   (1-31, 0=Special/See below)
    When below Bit 4 R=1 - Shift by Register
      11-8   Rs - Shift register (R0-R14) - only lower 8bit 0-255 used
      7      Reserved, must be zero  (otherwise multiply or undefined opcode)
    6-5    Shift Type (0=LSL, 1=LSR, 2=ASR, 3=ROR)
    4      R - Shift by Register Flag (0=Immediate, 1=Register)
    3-0    Rm - 2nd Operand Register (R0..R15) (including PC=R15)
  When above Bit 25 I=1 (Immediate as 2nd Operand)
    11-8   Is - ROR-Shift applied to nn (0-30, in steps of 2)
    7-0    nn - 2nd Operand Unsigned 8bit Immediate

***THUMB
Opcode Format
  Bit    Expl.
  15-10  Must be 010000b for this type of instructions
  9-6    Opcode (0-Fh)
           0: AND Rd,Rs     ;AND logical       Rd = Rd AND Rs
           1: EOR Rd,Rs     ;XOR logical       Rd = Rd XOR Rs
           2: LSL Rd,Rs     ;log. shift left   Rd = Rd << (Rs AND 0FFh)
           3: LSR Rd,Rs     ;log. shift right  Rd = Rd >> (Rs AND 0FFh)
           4: ASR Rd,Rs     ;arit shift right  Rd = Rd SAR (Rs AND 0FFh)
           5: ADC Rd,Rs     ;add with carry    Rd = Rd + Rs + Cy
           6: SBC Rd,Rs     ;sub with carry    Rd = Rd - Rs - NOT Cy
           7: ROR Rd,Rs     ;rotate right      Rd = Rd ROR (Rs AND 0FFh)
           8: TST Rd,Rs     ;test            Void = Rd AND Rs
           9: NEG Rd,Rs     ;negate            Rd = 0 - Rs
           A: CMP Rd,Rs     ;compare         Void = Rd - Rs
           B: CMN Rd,Rs     ;neg.compare     Void = Rd + Rs
           C: ORR Rd,Rs     ;OR logical        Rd = Rd OR Rs
           D: MUL Rd,Rs     ;multiply          Rd = Rd * Rs
           E: BIC Rd,Rs     ;bit clear         Rd = Rd AND NOT Rs
           F: MVN Rd,Rs     ;not               Rd = NOT Rs
  5-3    Rs - Source Register       (R0..R7)
  2-0    Rd - Destination Register  (R0..R7)
ARM equivalent for NEG would be RSBS.
Return: Rd contains result (except TST,CMP,CMN),
|#

;;;============================================================================
