;;;============================================================================

;;; File: "_arm.scm"

;;; Copyright (c) 2011-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; This module implements the ARM instruction encoding.

(namespace ("_arm#") ("" include))
(include "~~lib/gambit#.scm")

(include "_assert#.scm")
(include "_asm#.scm")
(include "_arm#.scm")
(include "_codegen#.scm")

(arm-implement)

;;;============================================================================

;;; Architecture selection (either arm or thumb).

(define (arm-arch-set! cgc arch)
  (codegen-context-arch-set! cgc arch)
  (if (codegen-context-listing-format cgc)
      (asm-listing
       cgc
       (list #\tab (if (arm-thumb-mode? cgc) ".thumb" ".arm")))))

(define (arm-thumb-mode? cgc)
  (eq? (codegen-context-arch cgc) 'thumb))

(define-macro (arm-assert-arm-mode cgc)
  `(assert (not (arm-thumb-mode? ,cgc))
           "instruction only valid for arm"))

(define-macro (arm-assert-thumb-mode cgc)
  `(assert (arm-thumb-mode? ,cgc)
           "instruction only valid for thumb"))

;;;----------------------------------------------------------------------------

;;; Instruction operands.

(define (arm-imm? x) (pair? x))

(define (arm-imm-int value #!optional (imm12 -1)) (cons value imm12))
(define (arm-imm-int? x) (and (pair? x) (fixnum? (cdr x))))
(define (arm-imm-int-value x) (car x))

(define (arm-imm-int-imm12 x)
  (let ((imm12 (cdr x)))
    (if (fx< imm12 0)
        (arm-imm->imm12 (arm-imm-int-value x))
        imm12)))

(define (arm-imm->imm12 imm)
  (arm-imm32->imm12 (asm-unsigned-lo32 imm)))

(define (arm-imm32->imm12 imm32)
  (let loop ((shift 0))
    (if (fx< shift 32)
        (let ((n
               (bitwise-and
                #xffffffff
                (+ (arithmetic-shift imm32 shift)
                   (arithmetic-shift imm32 (fx- shift 32))))))
          (if (<= n #xff)
              (fx+ n (fxarithmetic-shift-left shift 7))
              (loop (fx+ shift 2))))
        #f))) ;; imm32 can't be encoded as a imm12

(define (arm-imm12->imm32 imm12)
  (let* ((shift (fx* 2 (fxarithmetic-shift-right imm12 8)))
         (lo8 (fxand imm12 #xff)))
    (bitwise-and
     #xffffffff
     (+ (arithmetic-shift lo8 (fx- 32 shift))
        (arithmetic-shift lo8 (fx- shift))))))

#|
(define (thumb-imm32->imm12 imm32)
  (if (<= imm32 #xff)
      imm32
      (let* ((lo16 (bitwise-and imm32 #xffff))
             (hi16 (arithmetic-shift imm32 -16)))

        (define (other)
          (let* ((shift (fx- (integer-length imm32) 8))
                 (bits (arithmetic-shift imm32 (fx- shift))))
            (if (= imm32 (arithmetic-shift bits shift))
                (fx+ (fxarithmetic-shift-left (fx- 32 shift) 7)
                     (fxand bits #x7f))
                #f))) ;; imm32 can't be encoded as a imm12

        (cond ((not (fx= lo16 hi16))
               (other))
              ((fx<= lo16 #xff)
               (fx+ #x100 lo16))
              (else
               (let* ((lo8 (fxand lo16 #xff))
                      (hi8 (fxarithmetic-shift-right lo16 8)))
                 (cond ((fx= 0 lo8)
                        (fx+ #x200 hi8))
                       ((fx= hi8 lo8)
                        (fx+ #x300 lo8))
                       (else
                        (other)))))))))

(define (thumb-imm12->imm32 imm12)
  (let ((hi4 (fxarithmetic-shift-right imm12 8)))
    (if (fx<= hi4 3)

        (let ((lo8 (fxand imm12 #xff)))
          (cond ((fx= hi4 0)
                 lo8)
                ((fx= lo8 0)
                 #f) ;; unpredictable encoding
                (else
                 (* (case hi4
                      ((1)    #x10001)
                      ((2)  #x1000100)
                      (else #x1010101))
                    lo8))))

        (let* ((hi5 (fxarithmetic-shift-right imm12 7))
               (lo7 (fxand imm12 #x7f)))
          (arithmetic-shift
           (arithmetic-shift (fx+ #x80 lo7) 24)
           (fx- 8 hi5))))))
|#

;;;----------------------------------------------------------------------------

;;; Listing generation.

(define (arm-listing cgc mnemonic . opnds)

  (define (opnd-format opnd)
    (cond ((arm-reg? opnd)
           (arm-register-name opnd))
          ((arm-imm? opnd)
           (if (arm-imm-int? opnd)
               (list "#" (arm-imm-int-value opnd))
               (error "unsupported immediate int" opnd)))
          (else
           opnd)))

  (define (instr-format)
    (let ((operands
           (asm-separated-list
            (apply
             append
             (map (lambda (opnd) (if opnd (list (opnd-format opnd)) '()))
                  opnds))
            ", ")))
      (cons #\tab
            (cons mnemonic
                  (if (pair? operands)
                      (cons #\tab
                            operands)
                      '())))))

  (asm-listing cgc (instr-format)))

(define (arm-condition-name* condition)
  (if (eqv? condition (arm-cond-al))
      ""
      (arm-condition-name condition)))

;;;----------------------------------------------------------------------------

;;; ARM pseudo operations.

(define (arm-label cgc label)
  (asm-label cgc label)
  (if (codegen-context-listing-format cgc)
      (asm-listing cgc (list (asm-label-name label) ":"))))

(define (arm-db cgc . elems)
  (arm-data-elems cgc elems 8))

(define (arm-dw cgc . elems)
  (arm-data-elems cgc elems 16))

(define (arm-dd cgc . elems)
  (arm-data-elems cgc elems 32))

(define (arm-dq cgc . elems)
  (arm-data-elems cgc elems 64))

(define (arm-data-elems cgc elems width)

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
                                     ((fx= width 16) ".word")
                                     ((fx= width 32) ".long")
                                     ((fx= width 64) ".quad")
                                     (else (error "unknown data width")))
                               #\tab
                               (asm-separated-list (reverse rev-lst) ","))))
                    (loop1 lim)))))))))

;;;----------------------------------------------------------------------------

;;; ARM instructions: B and BL.

(define (arm-b cgc label #!optional (condition (arm-cond-al)))
  (arm-branch cgc label condition 'b))

(define (arm-bl cgc label #!optional (condition (arm-cond-al)))
  (arm-branch cgc label condition 'bl))

(define (arm-branch cgc label condition kind)

  (define (label-dist label self offset)
    (fx- (asm-label-pos label) (fx+ self offset)))

  (define (listing cgc kind condition label)
    (if (codegen-context-listing-format cgc)
        (arm-listing
         cgc
         (list kind
               (arm-condition-name* condition))
         (asm-label-name label))))

  (define (thumb-branch-and-link cgc label offs)

    (assert (and (fx>= offs -2097152)
                 (fx<= offs 2097151))
            "branch label too far")

    (asm-16-le cgc
               (fx+ #xf000
                    (fxand (fxarithmetic-shift-right offs 11)
                           #x7ff)))
    (asm-16-le cgc
               (fx+ #xf800
                    (fxand offs #x7ff)))

    (listing cgc 'bl (arm-cond-al) label))

  (if (arm-thumb-mode? cgc)

      (if (eqv? condition (arm-cond-al))

          (asm-at-assembly

           cgc

           (lambda (cgc self)
             (if (eq? kind 'b)
                 (let ((dist (label-dist label self 4)))
                   (if (and (fx>= dist -2048)
                            (fx<= dist 2047))
                       2
                       6))
                 4))
           (lambda (cgc self)
             (let* ((dist (label-dist label self 4))
                    (offs (fxarithmetic-shift-right dist 1)))

               (assert (fx= (fx* 2 offs) dist)
                       "branch address not a multiple of 2")

               (cond ((and (eq? kind 'b)
                           (fx>= offs -1024)
                           (fx<= offs 1023))

                      (asm-16-le cgc
                                 (fx+ #xe000
                                      (fxand offs #x7ff)))

                      (listing cgc kind condition label))

                     (else

                      ;; When the instruction is an unconditional branch
                      ;; and the branch distance doesn't fit in 11 bits,
                      ;; then a branch and link instruction is substituted.
                      ;; For this reason the content of the link
                      ;; register should be considered undefined after
                      ;; an unconditional branch instruction.

                      (thumb-branch-and-link cgc label offs))))))

          (asm-at-assembly

           cgc

           (lambda (cgc self)
             (if (eq? kind 'b)
                 (let ((dist (label-dist label self 4)))
                   (cond ((and (fx>= dist -256)
                               (fx<= dist 255))
                          2)
                         ((and (fx>= dist -2046) ;; -2048 + 2
                               (fx<= dist 2049)) ;;  2047 + 2
                          4)
                         (else
                          6)))
                 6))
           (lambda (cgc self)
             (let* ((dist (label-dist label self 4))
                    (offs (fxarithmetic-shift-right dist 1)))

               (assert (fx= (fx* 2 offs) dist)
                       "branch address not a multiple of 2")

               (cond ((and (eq? kind 'b)
                           (fx>= offs -128)
                           (fx<= offs 127))

                      (asm-16-le cgc
                                 (fx+ #xd000
                                      (fxarithmetic-shift-left condition 8)
                                      (fxand offs #xff)))

                      (listing cgc kind condition label))

                     ((and (eq? kind 'b)
                           (fx>= dist -2046) ;; -2048 + 2
                           (fx<= dist 2049)) ;;  2047 + 2

                      ;; conditional branch on inverse condition to skip
                      ;; the unconditional branch that follows

                      (let ((inv-cond (fxxor condition 1)))

                        (asm-16-le cgc
                                   (fx+ #xd000
                                        (fxarithmetic-shift-left
                                         inv-cond
                                         8)
                                        0)) ;; (distance - 2) / 2

                        (listing cgc kind inv-cond (asm-make-label cgc ".+4")))

                      ;; unconditional branch to label

                      (asm-16-le cgc
                                 (fx+ #xe000
                                      (fxand (fx- offs 1) #x7ff)))

                      (listing cgc kind (arm-cond-al) label))

                     (else

                      ;; When the instruction is a conditional branch
                      ;; and the branch distance doesn't fit in 11 bits,
                      ;; then a branch and link instruction is substituted.
                      ;; For this reason the content of the link
                      ;; register should be considered undefined after
                      ;; a conditional branch instruction.

                      ;; conditional branch on inverse condition to skip
                      ;; the branch and link that follows

                      (let ((inv-cond (fxxor condition 1)))

                        (asm-16-le cgc
                                   (fx+ #xd000
                                        (fxarithmetic-shift-left
                                         inv-cond
                                         8)
                                        1)) ;; (distance - 2) / 2

                        (listing cgc kind inv-cond (asm-make-label cgc ".+6")))

                      ;; branch and link to label

                      (thumb-branch-and-link cgc label (fx- offs 1))))))))

      (asm-at-assembly

       cgc

       (lambda (cgc self)
         4)
       (lambda (cgc self)
         (let* ((dist (label-dist label self 8))
                (offs (fxarithmetic-shift-right dist 2)))

           (assert (fx= (fx* 4 offs) dist)
                   "branch address not a multiple of 4")

           (assert (and (fx>= dist -33554432)
                        (fx<= dist 33554431))
                   "branch label too far")

           (asm-16-le cgc
                      offs)
           (asm-16-le cgc
                      (fx+ (fxarithmetic-shift-left condition 12)
                           (fxand (fxarithmetic-shift-right offs 16) #xff)
                           (if (eq? kind 'b) #x0a00 #x0b00)))

           (listing cgc kind condition label))))))

;;;----------------------------------------------------------------------------

;;; ARM instruction: BX.

(define (arm-bx cgc rn #!optional (condition (arm-cond-al)))

  (assert (arm-reg? rn)
          "invalid operands")

  (let ((n (arm-reg-field rn)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (asm-16-le cgc
                     (fx+ (fxarithmetic-shift-left n 3)
                          #x4700)))

        (begin
          (asm-16-le cgc
                     (fx+ n
                          #xff10))
          (asm-16-le cgc
                     (fx+ (fxarithmetic-shift-left condition 12)
                          #x012f)))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list "bx"
             (arm-condition-name* condition))
       rn)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: LSL, LSR, ASR, and ROR.

(define (arm-lsl cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 0 0))

(define (arm-lsls cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 0 1))

(define (arm-lsr cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 1 0))

(define (arm-lsrs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 1 1))

(define (arm-asr cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 2 0))

(define (arm-asrs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 2 1))

(define (arm-ror cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 3 0))

(define (arm-rors cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-shift cgc rd opnd1 opnd2 condition 3 1))

(define (arm-shift cgc rd opnd1 opnd2 condition op set-flags)

  (assert (and (arm-reg? rd)
               (or (arm-reg? opnd1)
                   (arm-imm-int? opnd1))
               (or (not opnd2)
                   (and (arm-reg? opnd1)
                        (or (arm-reg? opnd2)
                            (arm-imm-int? opnd2)))))
          "invalid operands")

  (let* ((d (arm-reg-field rd))
         (s (if opnd2 (arm-reg-field opnd1) d))
         (opnd (if opnd2 opnd2 opnd1)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (fx= set-flags 1)
                  "thumb instruction implicitly sets flags")

          (assert (and (fx<= d 7) (fx<= s 7))
                  "thumb instruction must use low registers")

          (cond ((arm-imm-int? opnd)

                 (let ((imm (arm-imm-int-value opnd)))

                   (assert (not (fx= op 3))
                           "thumb does not support ror with immediate operand")

                   (asm-16-le cgc
                              (fx+ d
                                   (fxarithmetic-shift-left s 3)
                                   (fxarithmetic-shift-left
                                    (fxand imm 31)
                                    6)
                                   (fxarithmetic-shift-left
                                    (if (fx= imm 0) 0 op)
                                    11)))))

                (else

                 (assert (and (fx= d s)
                              (arm-reg? opnd)
                              (arm-low-reg? opnd))
                         "invalid operands")

                 (asm-16-le cgc
                            (fx+ d
                                 (fxarithmetic-shift-left
                                  (arm-reg-field opnd)
                                  3)
                                 (fxarithmetic-shift-left
                                  (if (fx= op 3) 7 (fx+ op 2))
                                  6)
                                 #x4000)))))


        (begin

          (cond ((arm-imm-int? opnd)

                 (let ((imm (arm-imm-int-value opnd)))
                   (asm-16-le cgc
                              (fx+ s
                                   (fxarithmetic-shift-left
                                    (if (fx= imm 0) 0 op)
                                    5)
                                   (fxarithmetic-shift-left
                                    (fxand imm 31)
                                    7)
                                   (fxarithmetic-shift-left d 12)))))

                (else

                 (assert (arm-reg? opnd)
                         "invalid operands")

                 (asm-16-le cgc
                            (fx+ s
                                 (fxarithmetic-shift-left op 5)
                                 (fxarithmetic-shift-left
                                  (arm-reg-field opnd)
                                  8)
                                 (fxarithmetic-shift-left d 12)
                                 #x0010))))

          (asm-16-le cgc
                     (fx+ (fxarithmetic-shift-left set-flags 4)
                          (fxarithmetic-shift-left condition 12)
                          #x01a0)))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("lsl" "lsr" "asr" "ror")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       opnd1
       opnd2)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: ADD and SUB.

(define (arm-add cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-add-sub cgc rd opnd1 opnd2 condition 0 0))

(define (arm-adds cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-add-sub cgc rd opnd1 opnd2 condition 0 1))

(define (arm-sub cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-add-sub cgc rd opnd1 opnd2 condition 1 0))

(define (arm-subs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-add-sub cgc rd opnd1 opnd2 condition 1 1))

(define (arm-add-sub cgc rd opnd1 opnd2 condition op set-flags)

  (assert (and (arm-reg? rd)
               (or (arm-reg? opnd1)
                   (arm-imm-int? opnd1))
               (or (not opnd2)
                   (and (arm-reg? opnd1)
                        (or (arm-reg? opnd2)
                            (arm-imm-int? opnd2)))))
          "invalid operands")

  (let* ((d (arm-reg-field rd))
         (s (if opnd2 (arm-reg-field opnd1) d))
         (opnd (if opnd2 opnd2 opnd1)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (cond ((arm-imm-int? opnd)

                 (let ((imm (arm-imm-int-value opnd)))
                   (cond ((and (fx= d 13) (fx= s 13)) ;; add/sub sp, #imm10

                          (assert (and (fx>= imm 0)
                                       (fx<= imm 511)
                                       (fx= 0 (fxand imm 3)))
                                  "invalid operands")

                          (assert (fx= set-flags 0)
                                  "thumb instruction can't set flags")

                          (asm-16-le cgc
                                     (fx+ (fxarithmetic-shift-right imm 2)
                                          (fxarithmetic-shift-left op 7)
                                          #xb000)))

                         ((or (fx= s 13) (fx= s 15)) ;; add rd, sp/pc, #imm10

                          (assert (fx= op 0)
                                  "invalid operands for sub")

                          (assert (and (fx>= imm 0)
                                       (fx<= imm 1023)
                                       (fx= 0 (fxand imm 3)))
                                  "invalid operands")

                          (assert (fx= set-flags 0)
                                  "thumb instruction can't set flags")

                          (asm-16-le cgc
                                     (fx+ (fxarithmetic-shift-right imm 2)
                                          (fxarithmetic-shift-left d 8)
                                          (if (fx= s 13) #xa800 #xa000))))

                         ((fx<= imm 7) ;; add/sub rd, rs, #imm3

                          (assert (fx>= imm 0)
                                  "invalid operands")

                          (asm-16-le cgc
                                     (fx+ d
                                          (fxarithmetic-shift-left s 3)
                                          (fxarithmetic-shift-left imm 6)
                                          (fxarithmetic-shift-left op 9)
                                          #x1c00)))

                         (else

                          (assert (and (fx>= imm 0)
                                       (fx<= imm 255)
                                       (fx= d s)) ;; add/sub rd, #imm8
                                  "invalid operands")

                          (assert (fx= set-flags 1)
                                  "thumb instruction implicitly sets flags")

                          (asm-16-le cgc
                                     (fx+ imm
                                          (fxarithmetic-shift-left d 8)
                                          (fxarithmetic-shift-left op 11)
                                          #x3000))))))

                (else

                 (assert (arm-reg? opnd)
                         "invalid operands")

                 (let ((n (arm-reg-field opnd)))
                   (cond ((and (fx<= d 7) (fx<= s 7) (fx<= n 7))

                          (assert (fx= set-flags 1)
                                  "thumb instruction implicitly sets flags")

                          (asm-16-le cgc
                                     (fx+ d
                                          (fxarithmetic-shift-left s 3)
                                          (fxarithmetic-shift-left n 6)
                                          (fxarithmetic-shift-left op 9)
                                          #x1800)))

                         (else

                          (assert (fx= op 0)
                                  "invalid operands for sub")

                          (assert (fx= d s)
                                  "invalid operands")

                          (assert (fx= set-flags 0)
                                  "thumb instruction can't set flags")

                          (asm-16-le cgc
                                     (fx+ (fxand d 7)
                                          (fxarithmetic-shift-left n 3)
                                          (fxarithmetic-shift-left (fxand d 8) 4)
                                          #x4400))))))))

        (arm-data-instr cgc
                        d
                        s
                        opnd
                        condition
                        (fx+ set-flags
                             (if (fx= op 0) 8 4)))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("add" "sub")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       opnd1
       opnd2)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: AND, EOR, ADC, SBC, ORR, and BIC.

(define (arm-and cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0000 0))

(define (arm-ands cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0000 1))

(define (arm-eor cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0001 0))

(define (arm-eors cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0001 1))

(define (arm-adc cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0101 0))

(define (arm-adcs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0101 1))

(define (arm-sbc cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0110 0))

(define (arm-sbcs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b0110 1))

(define (arm-orr cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b1100 0))

(define (arm-orrs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b1100 1))

(define (arm-bic cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b1110 0))

(define (arm-bics cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition #b1110 1))

(define (arm-and-eor-adc-sbc-orr-bic cgc rd opnd1 opnd2 condition op set-flags)

  (assert (and (arm-reg? rd)
               (or (arm-reg? opnd1)
                   (arm-imm-int? opnd1))
               (or (not opnd2)
                   (and (arm-reg? opnd1)
                        (or (arm-reg? opnd2)
                            (arm-imm-int? opnd2)))))
          "invalid operands")

  (let* ((d (arm-reg-field rd))
         (s (if opnd2 (arm-reg-field opnd1) d))
         (opnd (if opnd2 opnd2 opnd1)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (arm-reg? opnd)
                  "invalid operands")

          (let ((n (arm-reg-field opnd)))

            (assert (and (fx<= d 7) (fx= s d) (fx<= n 7))
                    "thumb instruction must use low registers")

            (assert (fx= set-flags 1)
                    "thumb instruction implicitly sets flags")

            (asm-16-le cgc
                       (fx+ d
                            (fxarithmetic-shift-left n 3)
                            (fxarithmetic-shift-left op 6)
                            #x4000))))

        (arm-data-instr cgc
                        d
                        s
                        opnd
                        condition
                        (fx+ set-flags
                             (fxarithmetic-shift-left op 1)))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("and" "eor" "???" "???"
                 "???" "adc" "sbc" "???"
                 "???" "???" "???" "???"
                 "orr" "???" "bic")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       opnd1
       opnd2)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: RSB and RSC.

(define (arm-rsb cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-rev-sub cgc rd opnd1 opnd2 condition 0 0))

(define (arm-rsbs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-rev-sub cgc rd opnd1 opnd2 condition 0 1))

(define (arm-rsc cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-rev-sub cgc rd opnd1 opnd2 condition 1 0))

(define (arm-rscs cgc rd opnd1 #!optional (opnd2 #f) (condition (arm-cond-al)))
  (arm-rev-sub cgc rd opnd1 opnd2 condition 1 1))

(define (arm-rev-sub cgc rd opnd1 opnd2 condition op set-flags)

  (assert (and (arm-reg? rd)
               (or (arm-reg? opnd1)
                   (arm-imm-int? opnd1))
               (or (not opnd2)
                   (and (arm-reg? opnd1)
                        (or (arm-reg? opnd2)
                            (arm-imm-int? opnd2)))))
          "invalid operands")

  (assert (not (arm-thumb-mode? cgc))
          "invalid instruction on thumb")

  (let* ((d (arm-reg-field rd))
         (s (if opnd2 (arm-reg-field opnd1) d))
         (opnd (if opnd2 opnd2 opnd1)))

    (arm-data-instr cgc
                    d
                    s
                    opnd
                    condition
                    (fx+ set-flags
                         (fxarithmetic-shift-left op 3)
                         #b00110)))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("rsb" "rsc")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       opnd1
       opnd2)))

;;;----------------------------------------------------------------------------

;;; ARM instruction: NEG.

(define (arm-neg cgc rd rs #!optional (condition (arm-cond-al)))
  (arm-negate cgc rd rs condition 0))

(define (arm-negs cgc rd rs #!optional (condition (arm-cond-al)))
  (arm-negate cgc rd rs condition 1))

(define (arm-negate cgc rd rs condition set-flags)

  (assert (and (arm-reg? rd)
               (arm-reg? rs))
          "invalid operands")

  (let ((d (arm-reg-field rd))
        (s (arm-reg-field rs)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (and (fx<= d 7) (fx<= s 7))
                  "thumb instruction must use low registers")

          (assert (fx= set-flags 1)
                  "thumb instruction implicitly sets flags")

          (asm-16-le cgc
                     (fx+ d
                          (fxarithmetic-shift-left s 3)
                          (fxarithmetic-shift-left #b1001 6)
                          #x4000)))

        (arm-data-instr cgc
                        d
                        s
                        (arm-imm-int 0)
                        condition
                        (fx+ set-flags
                             #b00110))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list "neg"
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       rs)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: TST, TEQ, and CMN.

(define (arm-tst cgc rs opnd #!optional (condition (arm-cond-al)))
  (arm-tst-teq-cmn cgc rs opnd condition #b1000))

(define (arm-teq cgc rs opnd #!optional (condition (arm-cond-al)))
  (arm-tst-teq-cmn cgc rs opnd condition #b1001))

(define (arm-cmn cgc rs opnd #!optional (condition (arm-cond-al)))
  (arm-tst-teq-cmn cgc rs opnd condition #b1011))

(define (arm-tst-teq-cmn cgc rs opnd condition op)

  (assert (and (arm-reg? rs)
               (or (arm-reg? opnd)
                   (arm-imm-int? opnd)))
          "invalid operands")

  (let ((s (arm-reg-field rs)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (not (fx= op 9))
                  "thumb does not support teq")

          (assert (arm-reg? opnd)
                  "invalid operands")

          (let ((n (arm-reg-field opnd)))

            (assert (and (fx<= s 7) (fx<= n 7))
                    "thumb instruction must use low registers")

            (asm-16-le cgc
                       (fx+ s
                            (fxarithmetic-shift-left n 3)
                            (fxarithmetic-shift-left op 6)
                            #x4000))))

        (arm-data-instr cgc
                        0
                        s
                        opnd
                        condition
                        (fx+ 1
                             (fxarithmetic-shift-left op 1)))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("tst" "teq" "cmp" "cmn")
              (fx- op 8))
             (arm-condition-name* condition))
       rs
       opnd)))

;;;----------------------------------------------------------------------------

;;; ARM instruction: CMP.

(define (arm-cmp cgc rs opnd #!optional (condition (arm-cond-al)))

  (assert (and (arm-reg? rs)
               (or (arm-reg? opnd)
                   (arm-imm-int? opnd)))
          "invalid operands")

  (let ((s (arm-reg-field rs)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (cond ((arm-imm-int? opnd)

                 (let ((imm (arm-imm-int-value opnd)))

                   (assert (and (fx>= imm 0)
                                (fx<= imm 255))
                           "invalid operands")

                   (asm-16-le cgc
                              (fx+ imm
                                   (fxarithmetic-shift-left s 8)
                                   #x2800))))

                (else

                 (assert (arm-reg? opnd)
                         "invalid operands")

                 (let ((n (arm-reg-field opnd)))
                   (cond ((and (fx<= s 7) (fx<= n 7))

                          (asm-16-le cgc
                                     (fx+ s
                                          (fxarithmetic-shift-left n 3)
                                          #x4280)))

                         (else

                          (asm-16-le cgc
                                     (fx+ (fxand s 7)
                                          (fxarithmetic-shift-left n 3)
                                          (fxarithmetic-shift-left (fxand s 8) 4)
                                          #x4500))))))))

        (arm-data-instr cgc
                        0
                        s
                        opnd
                        condition
                        #b10101)))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list "cmp"
             (arm-condition-name* condition))
       rs
       opnd)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: MOV and MVN.

(define (arm-mov cgc rd opnd #!optional (condition (arm-cond-al)))
  (arm-move cgc rd opnd condition 0 0))

(define (arm-movs cgc rd opnd #!optional (condition (arm-cond-al)))
  (arm-move cgc rd opnd condition 0 1))

(define (arm-mvn cgc rd opnd #!optional (condition (arm-cond-al)))
  (arm-move cgc rd opnd condition 1 0))

(define (arm-mvns cgc rd opnd #!optional (condition (arm-cond-al)))
  (arm-move cgc rd opnd condition 1 1))

(define (arm-move cgc rd opnd condition op set-flags)

  (assert (and (arm-reg? rd)
               (or (arm-reg? opnd)
                   (arm-imm-int? opnd)))
          "invalid operands")

  (let ((d (arm-reg-field rd)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (cond ((and (fx= op 0) ;; mov?
                      (arm-imm-int? opnd))

                 (let ((imm (arm-imm-int-value opnd)))

                   (assert (and (fx>= imm 0)
                                (fx<= imm 255))
                           "invalid operands")

                   (assert (fx= set-flags 1)
                           "thumb instruction implicitly sets flags")

                   (asm-16-le cgc
                              (fx+ imm
                                   (fxarithmetic-shift-left d 8)
                                   #x2000))))

                (else

                 (assert (arm-reg? opnd)
                         "invalid operands")

                 (let ((n (arm-reg-field opnd)))
                   (cond ((and (fx<= d 7) (fx<= n 7))

                          (assert (fx= set-flags 1)
                                  "thumb instruction implicitly sets flags")

                          (asm-16-le cgc
                                     (fx+ d
                                          (fxarithmetic-shift-left n 3)
                                          (if (fx= op 0)
                                              #x1c00
                                              #x43c0))))

                         (else

                          (assert (fx= op 0)
                                  "invalid operands")

                          (assert (fx= set-flags 0)
                                  "thumb instruction can't set flags")

                          (asm-16-le cgc
                                     (fx+ (fxand d 7)
                                          (fxarithmetic-shift-left n 3)
                                          (fxarithmetic-shift-left (fxand d 8) 4)
                                          #x4600))))))))

        (arm-data-instr cgc
                        d
                        0
                        opnd
                        condition
                        (fx+ set-flags
                             (fxarithmetic-shift-left op 2)
                             #b11010))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("mov" "mvn")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       opnd)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: MUL and MLA.

(define (arm-mul cgc rd rm #!optional (rs #f) (rn #f) (condition (arm-cond-al)))
  (arm-multiply cgc rd rm rs rn condition 0 0))

(define (arm-muls cgc rd rm #!optional (rs #f) (rn #f) (condition (arm-cond-al)))
  (arm-multiply cgc rd rm rs rn condition 0 1))

(define (arm-mla cgc rd rm #!optional (rs #f) (rn #f) (condition (arm-cond-al)))
  (arm-multiply cgc rd rm rs rn condition 1 0))

(define (arm-mlas cgc rd rm #!optional (rs #f) (rn #f) (condition (arm-cond-al)))
  (arm-multiply cgc rd rm rs rn condition 1 1))

(define (arm-multiply cgc rd rm rs rn condition op set-flags)

  (assert (and (arm-reg? rd)
               (arm-reg? rm)
               (if (fx= op 0)
                   (and (or (not rs)
                            (arm-reg? rs))
                        (not rn))
                   (and (arm-reg? rs)
                        (arm-reg? rn))))
          "invalid operands")

  (let* ((d (arm-reg-field rd))
         (m (if rs (arm-reg-field rm) d))
         (s (if rs (arm-reg-field rs) (arm-reg-field rm)))
         (n (if rn (arm-reg-field rn) 0)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (fx= op 0)
                  "thumb does not support multiply-accumulate")

          (assert (fx= set-flags 1)
                  "thumb instruction implicitly sets flags")

          (assert (and (fx<= d 7) (fx<= s 7) (fx= m d))
                  "thumb instruction must use low registers")

          (asm-16-le cgc
                     (fx+ d
                          (fxarithmetic-shift-left s 3)
                          #x4340)))

        (begin

          (asm-16-le cgc
                     (fx+ m
                          (fxarithmetic-shift-left s 8)
                          (fxarithmetic-shift-left n 12)
                          #x0090))
          (asm-16-le cgc
                     (fx+ d
                          (fxarithmetic-shift-left set-flags 4)
                          (fxarithmetic-shift-left op 5)
                          (fxarithmetic-shift-left condition 12))))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("mul" "mla")
              op)
             (arm-condition-name* condition)
             (if (and (fx= set-flags 1) (not (arm-thumb-mode? cgc))) "s" ""))
       rd
       rm
       rs
       rn)))

;;;----------------------------------------------------------------------------

;;; ARM instructions: LDR, LDRB, STR, and STRB.

(define (arm-ldr cgc
                 rd
                 rb
                 offset
                 #!optional
                 (pre? #t)
                 (write-back? #f)
                 (condition (arm-cond-al)))
  (arm-load-store cgc rd rb offset pre? write-back? condition #t #f))

(define (arm-ldrb cgc
                  rd
                  rb
                  offset
                  #!optional
                  (pre? #t)
                  (write-back? #f)
                  (condition (arm-cond-al)))
  (arm-load-store cgc rd rb offset pre? write-back? condition #t #t))

(define (arm-str cgc
                 rd
                 rb
                 offset
                 #!optional
                 (pre? #t)
                 (write-back? #f)
                 (condition (arm-cond-al)))
  (arm-load-store cgc rd rb offset pre? write-back? condition #f #f))

(define (arm-strb cgc
                  rd
                  rb
                  offset
                  #!optional
                  (pre? #t)
                  (write-back? #f)
                  (condition (arm-cond-al)))
  (arm-load-store cgc rd rb offset pre? write-back? condition #f #t))

(define (arm-load-store cgc rd rb offset pre? write-back? condition load? byte?)

  (assert (and (arm-reg? rd)
               (arm-reg? rb))
          "invalid operands")

  (let* ((d (arm-reg-field rd))
         (b (arm-reg-field rb)))

    (if (arm-thumb-mode? cgc)

        (begin

          (assert (eqv? condition (arm-cond-al))
                  "thumb instructions are unconditionnal")

          (assert (and (fx<= d 7) (fx<= b 7))
                  "thumb instruction must use low registers")

          (assert (if byte?
                      (and (fx>= offset 0)
                           (fx<= offset 31))
                      (and (fx>= offset 0)
                           (fx<= offset 127)))
                  (if byte?
                      "offset must fit in 5 bits"
                      "offset must fit in 7 bits"))

          (assert pre?
                  "postincrement addressing mode does not exist on thumb")

          (assert (not write-back?)
                  "write-back addressing mode does not exist on thumb")

          (let ((o (if byte? offset (quotient offset 4))))
            (asm-16-le cgc
                       (fx+ d
                            (fxarithmetic-shift-left b 3)
                            (fxarithmetic-shift-left o 6)
                            (if load? #x800  0)
                            (if byte? #x1000 0)
                            #x6000))))

        (begin

          (assert (and (fx>= offset -4095)
                       (fx<= offset 4095))
                  "absolute offset must fit in 12 bits")

          (let ((o (abs offset)))
            (asm-16-le cgc
                       (fx+ o
                            (fxarithmetic-shift-left d 12))))

          (asm-16-le cgc
                     (fx+ b
                          (if load?         #x10  0)
                          (if write-back?   #x20  0)
                          (if byte?         #x40  0)
                          (if (>= offset 0) #x80  0)
                          (if pre?          #x100 0)
                          #x400
                          (fxarithmetic-shift-left condition 12))))))

  (if (codegen-context-listing-format cgc)
      (arm-listing
       cgc
       (list (vector-ref
              '#("str" "strb" "ldr" "ldrb")
              (fx+ (if load? 2 0) (if byte? 1 0)))
             (arm-condition-name* condition))
       rd
       (if pre?
           (string-append "["
                          (arm-register-name rb)
                          (if (fx= offset 0)
                              ""
                              (string-append ",#"
                                             (number->string offset)))
                          (if write-back? "]!" "]"))
           (string-append "["
                          (arm-register-name rb)
                          "], #"
                          (number->string offset))))))

;;;----------------------------------------------------------------------------





#|

MUL Rd, Rs                 MULS Rd, Rs, Rd
MVN Rd, Rs                 MVNS Rd, Rs


  (rsb #b0011 rd-rn-opnd2) ;; reverse substract
  (rsc #b0111 rd-rn-opnd2) ;; reverse substract with carry
  (mov #b1101 rd-opnd2   ) ;; move
  (mvn #b1111 rd-opnd2   ) ;; move not
  (mul #b1101 #f         ) ;; multiply


  (and #b0000 rd-rn-opnd2) ;; and
  (eor #b0001 rd-rn-opnd2) ;; exclusive or

  (sub #b0010 rd-rn-opnd2) ;; substract
  (rsb #b0011 rd-rn-opnd2) ;; reverse substract
  (add #b0100 rd-rn-opnd2) ;; add
  (rsc #b0111 rd-rn-opnd2) ;; reverse substract with carry

  (adc #b0101 rd-rn-opnd2) ;; add with carry
  (sbc #b0110 rd-rn-opnd2) ;; substract with carry
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



AND Rd, Rs                 ANDS Rd, Rd, Rs
EOR Rd, Rs                 EORS Rd, Rd, Rs
ADC Rd, Rs                 ADCS Rd, Rd, Rs
SBC Rd, Rs                 SBCS Rd, Rd, Rs
TST Rd, Rs                 TST  Rd, Rs
NEG Rd, Rs                 RSBS Rd, Rs, #0
CMP Rd, Rs                 CMP  Rd, Rs
CMN Rd, Rs                 CMN  Rd, Rs
ORR Rd, Rs                 ORRS Rd, Rd, Rs
MUL Rd, Rs                 MULS Rd, Rs, Rd
BIC Rd, Rs                 BICS Rd, Rd, Rs
MVN Rd, Rs                 MVNS Rd, Rs
|#

;;;----------------------------------------------------------------------------

(define (arm-data-instr cgc d s opnd condition instr)
  (let ((code
         (cond ((arm-imm-int? opnd)

                (let ((imm12 (arm-imm-int-imm12 opnd)))

                  (assert imm12
                          "immediate operand can't be encoded in 12 bits" opnd)

                  (asm-16-le cgc
                             (fx+ imm12
                                  (fxarithmetic-shift-left d 12)))

                  #x0200))

               (else

                (assert (arm-reg? opnd)
                        "invalid operands")

                (let ((o (arm-reg-field opnd)))

                  (asm-16-le cgc
                             (fx+ o
                                  (fxarithmetic-shift-left d 12)))

                  0)))))

    (asm-16-le cgc
               (fx+ s
                    (fxarithmetic-shift-left instr 4)
                    (fxarithmetic-shift-left condition 12)
                    code))))

;;;----------------------------------------------------------------------------

#|



THUMB                      ARM

LSL Rd, Rs                 MOVS Rd, Rd, LSL Rs
LSR Rd, Rs                 MOVS Rd, Rd, LSR Rs
ASR Rd, Rs                 MOVS Rd, Rd, ASR Rs
ROR Rd, Rs                 MOVS Rd, Rd, ROR Rs


ADD Rd, Rs, Rn             ADDS Rd, Rs, Rn
SUB Rd, Rs, Rn             SUBS Rd, Rs, Rn
ADD Rd, Rs, #Offset3       ADDS Rd, Rs, #Offset3
SUB Rd, Rs, #Offset3       SUBS Rd, Rs, #Offset3
ADD Rd, #Offset8           ADDS Rd, Rd, #Offset8
SUB Rd, #Offset8           SUBS Rd, Rd, #Offset8

ADD Rd, Hs                 ADD Rd, Rd, Hs
ADD Hd, Rs                 ADD Hd, Hd, Rs
ADD Hd, Hs                 ADD Hd, Hd, Hs

ADD Rd, PC, #Imm           ADD Rd, R15, #Imm
SUB Rd, PC, #Imm           SUB Rd, R15, #Imm
ADD Rd, SP, #Imm           ADD Rd, R13, #Imm
SUB Rd, SP, #Imm           SUB Rd, R13, #Imm

ADD SP, #Imm               ADD R13, R13, #Imm
SUB SP, #Imm               SUB R13, R13, #Imm





MOV Rd, #Offset8           MOVS Rd, #Offset8
CMP Rd, #Offset8           CMP  Rd, #Offset8

AND Rd, Rs                 ANDS Rd, Rd, Rs
EOR Rd, Rs                 EORS Rd, Rd, Rs
ADC Rd, Rs                 ADCS Rd, Rd, Rs
SBC Rd, Rs                 SBCS Rd, Rd, Rs
TST Rd, Rs                 TST  Rd, Rs
NEG Rd, Rs                 RSBS Rd, Rs, #0
CMP Rd, Rs                 CMP  Rd, Rs
CMN Rd, Rs                 CMN  Rd, Rs
ORR Rd, Rs                 ORRS Rd, Rd, Rs
MUL Rd, Rs                 MULS Rd, Rs, Rd
BIC Rd, Rs                 BICS Rd, Rd, Rs
MVN Rd, Rs                 MVNS Rd, Rs

CMP Rd, Hs                 CMP Rd, Rd, Hs
CMP Hd, Rs                 CMP Hd, Hd, Rs
CMP Hd, Hs                 CMP Hd, Hd, Hs

MOV Rd, Hs                 MOV Rd, Rd, Hs
MOV Hd, Rs                 MOV Hd, Hd, Rs
MOV Hd, Hs                 MOV Hd, Hd, Hs

BX Rs                      BX Rs
BX Hs                      BX Hs





;;;----------------------------------------------------------------------------

;;; ARM instructions: AND, EOR, SUB, RSB, ADD, ADC, SBC, RSC, TST,
;;; TEQ, CMP, CMN, ORR, MOV, BIC, and MVN.

(define (arm-data-instruction cgc rd rn opnd2 condition instr)

  (arm-assert-arm-mode cgc)

  (assert (arm-reg? rd)
          "destination must be a register" rd)

  (assert (arm-reg? rn)
          "first operand must be a register" rn)

  (let* ((code
          (fxarithmetic-shift-right instr 1))
         (test-instr?
          (or (fx= code 8)     ;; TST
              (fx= code 9)     ;; TEQ
              (fx= code 10)    ;; CMP
              (fx= code 11)))  ;; CMN
         (move-instr?
          (or (fx= code 13)    ;; MOV
              (fx= code 15)))) ;; MVN

    (define (listing)
      (if (codegen-context-listing-format cgc)
          (arm-listing cgc
                       (list (arm-data-instruction-name code)
                             (arm-condition-name* condition)
                             (if (and (fxodd? instr) (not test-instr?))
                                 "s"
                                 ""))
                       (if (and (fx= (arm-reg-field rd) 0)
                                test-instr?)
                           #f
                           rd)
                       (if (and (fx= (arm-reg-field rn) 0)
                                move-instr?)
                           #f
                           rn)
                       opnd2)))

    (if test-instr?
        (set! instr (fxior instr 1))) ;; force S bit

    (let* ((d (arm-reg-field rd))
           (n (arm-reg-field rn)))

      (cond ((arm-reg? opnd2)
             (let ((o (arm-reg-field opnd2)))

               (asm-16-le cgc
                          (fx+ o
                               (fxarithmetic-shift-left d 12)))
               (asm-16-le cgc
                          (fx+ n
                               (fxarithmetic-shift-left instr 4)
                               (fxarithmetic-shift-left condition 12))))

             (listing))

            ((arm-imm? opnd2)
             (let ((imm12 (arm-imm-int-imm12 opnd2)))

               (assert imm12
                       "second operand is an immediate value that can't be encoded in 12 bits" opnd2)

               (asm-16-le cgc
                          (fx+ imm12
                               (fxarithmetic-shift-left d 12)))
               (asm-16-le cgc
                          (fx+ n
                               (fxarithmetic-shift-left instr 4)
                               (fxarithmetic-shift-left condition 12)
                               #x0200)))

             (listing))

            (else
             (assert #f
                     "second operand must be a register or an immediate value" opnd2))))))

(define (arm-data-instruction2 cgc rd rn opnd2 condition instr)

  (assert (or (and opnd2 condition)
              (and (not opnd2) (not condition)))
          "invalid combination of operands")

  (assert (or (not rd)
              (arm-reg? rd))
          "destination must be a register" rd)

  (assert (or (not rn)
              (arm-reg? rn))
          "source operand must be a register" rn)

  (let ((code (fxarithmetic-shift-right instr 1)))

    (define (listing)
      (if (codegen-context-listing-format cgc)
          (arm-listing cgc
                       (list (arm-data-instruction-name code (not opnd2))
                             (arm-condition-name* (or condition (arm-cond-al)))
                             (if (and (fxodd? instr)
                                      (not (or (fx= code 8)     ;; TST
                                               (fx= code 9)     ;; TEQ
                                               (fx= code 10)    ;; CMP
                                               (fx= code 11)))) ;; CMN
                                 "s"
                                 ""))
                       rd
                       rn
                       opnd2)))

    (let* ((d (if rd (arm-reg-field rd) 0))
           (n (if rn (arm-reg-field rn) 0)))

      (cond ((not opnd2)
             'thumb);;;;;;;;;;;;;;;;;;;;;

            ((arm-reg? opnd2)
             (let ((o (arm-reg-field opnd2)))

               (asm-16-le cgc
                          (fx+ o
                               (fxarithmetic-shift-left d 12)))
               (asm-16-le cgc
                          (fx+ n
                               (fxarithmetic-shift-left instr 4)
                               (fxarithmetic-shift-left condition 12))))

             (listing))

            ((arm-imm? opnd2)
             (let ((imm12 (arm-imm-int-imm12 opnd2)))

               (assert imm12
                       "immediate value that can't be encoded in 12 bits" opnd2)

               (asm-16-le cgc
                          (fx+ imm12
                               (fxarithmetic-shift-left d 12)))
               (asm-16-le cgc
                          (fx+ n
                               (fxarithmetic-shift-left instr 4)
                               (fxarithmetic-shift-left condition 12)
                               #x0200)))

             (listing))

            (else
             (assert #f
                     "register or immediate value expected" opnd2))))))

;;;----------------------------------------------------------------------------

;;; ARM instructions: MOVW and MOVT.

;; Note these are ARMv7 instructions.

(define (arm-instr-movw-movt cgc rd imm16 op)

  (arm-assert-arm-mode cgc)

  (assert (arm-reg? rd)
          "first operand must be a register" rd)

  (let ((d (arm-reg-field rd)))

    (asm-16-le cgc
               (fx+ (fxand #xff imm16)
                    (fxarithmetic-shift-left d 8)
                    (fxarithmetic-shift-left (fxand #x700 imm16) 4)))
    (asm-16-le cgc
               (fx+ (fxarithmetic-shift-right (fxand #x7800 imm16) 11)
                    (fxarithmetic-shift-right (fxand #x8000 imm16) 5)
                    (fxarithmetic-shift-left op 7)
                    #xf240)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   (vector-ref
                    '#("movw" "movt")
                    op)
                   rd
                   (arm-imm-int imm16))))

(define (arm-movw cgc rd imm16)
  (arm-instr-movw-movt cgc rd imm16 0))

(define (arm-movt cgc rd imm16)
  (arm-instr-movw-movt cgc rd imm16 1))

;;;----------------------------------------------------------------------------

;;; ARM instructions: ADDW and SUBW.

;(define (arm-addw cgc rd rn imm12)
;1111 0i10 0000 nnnn 0iii dddd iiii iiii

;(define (arm-subw cgc rd rn imm12)
;1111 0i10 1010 nnnn 0iii dddd iiii iiii

;;;----------------------------------------------------------------------------

;;; THUMB instructions: ANDS, EORS, LSLS, LSRS, ASRS, ADCS, SBCS,
;;; RORS, TSTS, NEGS, CMPS, CMNS, ORRS, MULS, BICS, and MVNS.

(define (thumb-alu-instruction cgc rd rs instr)

  (arm-assert-thumb-mode cgc)

  (assert (and (arm-reg? rd)
               (arm-low-reg? rd))
          "first operand must be a low register" rd)

  (assert (and (arm-reg? rs)
               (arm-low-reg? rs))
          "second operand must be a low register" rs)

  (let* ((d (arm-reg-field rd))
         (s (arm-reg-field rs)))

    (asm-16-le cgc
               (fx+ d
                    (fxarithmetic-shift-left s 3)
                    (fxarithmetic-shift-left instr 6)
                    #x4000)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   (thumb-alu-instruction-name instr)
                   rd
                   rs)))

;;;----------------------------------------------------------------------------

;;; THUMB instruction: MOV.

(define (thumb-mov cgc rd rm)

  (arm-assert-thumb-mode cgc)

  (assert (arm-reg? rd)
          "first operand must be a register" rd)

  (assert (arm-reg? rm)
          "second operand must be a register" rm)

  (let* ((d (arm-reg-field rd))
         (m (arm-reg-field rm)))

    (asm-16-le cgc
               (fx+ (fxand d 7)
                    (fxarithmetic-shift-left (fxand d 8) 4)
                    (fxarithmetic-shift-left m 3)
                    #x4600)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   "mov"
                   rd
                   rm)))

;;;----------------------------------------------------------------------------

;;; THUMB instruction: BX.

(define (thumb-bx cgc rm)

  (arm-assert-thumb-mode cgc)

  (assert (arm-reg? rm)
          "first operand must be a register" rm)

  (let ((m (arm-reg-field rm)))

    (asm-16-le cgc
               (fx+ (fxarithmetic-shift-left m 3)
                    #x4700)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   "bx"
                   rm)))

;;;----------------------------------------------------------------------------

;;; THUMB instructions: ADDS and SUBS.

(define (thumb-instr-adds-subs-reg cgc rd rs rn op)

  (arm-assert-thumb-mode cgc)

  (assert (and (arm-reg? rd)
               (arm-low-reg? rd))
          "first operand must be a low register" rd)

  (assert (and (arm-reg? rs)
               (arm-low-reg? rs))
          "second operand must be a low register" rs)

  (assert (and (arm-reg? rn)
               (arm-low-reg? rn))
          "third operand must be a low register" rn)

  (let* ((d (arm-reg-field rd))
         (s (arm-reg-field rs))
         (n (arm-reg-field rn)))

    (asm-16-le cgc
               (fx+ d
                    (fxarithmetic-shift-left s 3)
                    (fxarithmetic-shift-left n 6)
                    (fxarithmetic-shift-left op 9)
                    #x1800)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   (vector-ref
                    '#("adds" "subs")
                    op)
                   rd
                   rs
                   rn)))

(define (thumb-adds cgc rd rs rn)
  (thumb-instr-adds-subs-reg cgc rd rs rn 0))

(define (thumb-subs cgc rd rs rn)
  (thumb-instr-adds-subs-reg cgc rd rs rn 1))

(define (thumb-instr-adds-subs-imm3 cgc rd rs imm3 op)

  (arm-assert-thumb-mode cgc)

  (assert (and (arm-reg? rd)
               (arm-low-reg? rd))
          "first operand must be a low register" rd)

  (assert (and (arm-reg? rs)
               (arm-low-reg? rs))
          "second operand must be a low register" rs)

  ;; TODO: check imm3

  (let* ((d (arm-reg-field rd))
         (s (arm-reg-field rs)))

    (asm-16-le cgc
               (fx+ d
                    (fxarithmetic-shift-left s 3)
                    (fxarithmetic-shift-left imm3 6)
                    (fxarithmetic-shift-left op 9)
                    #x1c00)))

  (if (codegen-context-listing-format cgc)
      (arm-listing cgc
                   (vector-ref
                    '#("adds" "subs")
                    op)
                   rd
                   rs
                   (string-append "#" (number->string imm3)))))

(define (thumb-adds-imm3 cgc rd rs imm3)
  (thumb-instr-adds-subs-imm3 cgc rd rs imm3 0))

(define (thumb-subs-imm3 cgc rd rs imm3)
  (thumb-instr-adds-subs-imm3 cgc rd rs imm3 1))

;;;----------------------------------------------------------------------------


(define (thumb-movs cgc rd n)
  (asm-8 cgc n)
  (asm-8 cgc (fx+ #x20 rd))
  "movs r3, #255")

(define (thumb-adds cgc rd rs n)
  (number->string (+ (fx+ (fxarithmetic-shift-left n 6)
                  (fxarithmetic-shift-left rs 3)
                  rd)
(* 256
               (fx+ #x1c (fxarithmetic-shift-right n 1))))
16))

(define (thumb-adds cgc rd rs n)
  (asm-8 cgc (fx+ (fxarithmetic-shift-left n 6)
                  (fxarithmetic-shift-left rs 3)
                  rd))
  (asm-8 cgc (fx+ #x1c (fxarithmetic-shift-right n 2)))
  "adds r1, r2, #7")

(define (thumb-instr-mov-cmp-add-sub-imm cgc op rd offset8)

  (asm-16-le cgc
             (fx+ offset8
                  (fxarithmetic-shift-left rd 8)
                  (fxarithmetic-shift-left op 11)
                  #x2000))

  (if '(asm-code-block-listing? cgc)
      (asm-listing
       cgc
       (thumb-instr-format (vector-ref
                            '#("mov" "cmp" "add" "sub")
                            op)
                           rd
                           (string-append "#" (number->string offset8))))))

(define (thumb-mov-imm cgc rd offset8)
  (thumb-instr-mov-cmp-add-sub-imm cgc 0 rd offset8))

(define (thumb-cmp-imm cgc rd offset8)
  (thumb-instr-mov-cmp-add-sub-imm cgc 1 rd offset8))

(define (thumb-add-imm cgc rd offset8)
  (thumb-instr-mov-cmp-add-sub-imm cgc 2 rd offset8))

(define (thumb-sub-imm cgc rd offset8)
  (thumb-instr-mov-cmp-add-sub-imm cgc 3 rd offset8))

|#

;;;============================================================================
