;;;============================================================================

;;; File: "_x86#.scm"

;;; Copyright (c) 2010-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(namespace ("_x86#"

x86-implement

x86-register-name
x86-reg?
x86-reg8?
x86-reg8-h?
x86-xmm?
x86-mm?
x86-fpu?
x86-reg16?
x86-reg32?
x86-reg64?
x86-reg-field
x86-reg8
x86-reg16
x86-reg32
x86-reg64
x86-fpu
x86-reg-width

x86-al
x86-cl
x86-dl
x86-bl
x86-ah
x86-ch
x86-dh
x86-bh
x86-spl
x86-bpl
x86-sil
x86-dil
x86-r8b
x86-r9b
x86-r10b
x86-r11b
x86-r12b
x86-r13b
x86-r14b
x86-r15b

x86-ax
x86-cx
x86-dx
x86-bx
x86-sp
x86-bp
x86-si
x86-di
x86-r8w
x86-r9w
x86-r10w
x86-r11w
x86-r12w
x86-r13w
x86-r14w
x86-r15w

x86-eax
x86-ecx
x86-edx
x86-ebx
x86-esp
x86-ebp
x86-esi
x86-edi
x86-r8d
x86-r9d
x86-r10d
x86-r11d
x86-r12d
x86-r13d
x86-r14d
x86-r15d

x86-rax
x86-rcx
x86-rdx
x86-rbx
x86-rsp
x86-rbp
x86-rsi
x86-rdi
x86-r8
x86-r9
x86-r10
x86-r11
x86-r12
x86-r13
x86-r14
x86-r15

x86-st
x86-st1
x86-st2
x86-st3
x86-st4
x86-st5
x86-st6
x86-st7

x86-mm0
x86-mm1
x86-mm2
x86-mm3
x86-mm4
x86-mm5
x86-mm6
x86-mm7

x86-xmm0
x86-xmm1
x86-xmm2
x86-xmm3
x86-xmm4
x86-xmm5
x86-xmm6
x86-xmm7
x86-xmm8
x86-xmm9
x86-xmm10
x86-xmm11
x86-xmm12
x86-xmm13
x86-xmm14
x86-xmm15

x86-es
x86-cs
x86-ss
x86-ds
x86-fs
x86-gs

x86-arch-set!
x86-64bit-mode?
x86-word-width

x86-imm-int
x86-imm-int?
x86-imm-int-value
x86-imm-lbl
x86-mem

x86-imm?

x86-imm-int
x86-imm-int?
x86-imm-int-width
x86-imm-int-value

x86-imm-lbl
x86-imm-lbl?
x86-imm-lbl-offset
x86-imm-lbl-label

x86-imm-late
x86-imm-late?
x86-imm-late-width
x86-imm-late-handler

x86-imm-obj
x86-imm-obj?
x86-imm-obj-value

x86-label
x86-db
x86-dw
x86-dd
x86-dq

x86-add
x86-or
x86-adc
x86-sbb
x86-and
x86-sub
x86-xor
x86-cmp
x86-mov

x86-inc
x86-dec

x86-lea

x86-ret

x86-enter

x86-nop
x86-leave
x86-hlt
x86-cmc
x86-clc
x86-stc
x86-cli
x86-sti
x86-cld
x86-std

x86-int
x86-int3

x86-syscall
x86-sysret
x86-wrmsr
x86-rdtsc
x86-rdmsr
x86-rdpmc
x86-cpuid

x86-jmp
x86-call
x86-jo
x86-jno
x86-jb
x86-jae
x86-je
x86-jne
x86-jbe
x86-ja
x86-js
x86-jns
x86-jp
x86-jnp
x86-jl
x86-jge
x86-jle
x86-jg

x86-push
x86-pop
x86-pushf
x86-popf

x86-cwde
x86-cdq
x86-cbw
x86-cwd
x86-cdqe
x86-cqo

x86-rol
x86-ror
x86-rcl
x86-rcr
x86-shl
x86-shr
x86-sar

x86-neg
x86-not

x86-test

x86-xchg

x86-mul
x86-imul
x86-div
x86-idiv

x86-movzx
x86-movsx

x86-bt
x86-bts
x86-btr
x86-btc

x86-comment

))

;;;============================================================================

;; Define x86 register classes.

(define-macro (x86-define-registers . definitions)

  (define names (make-vector (+ 96 8) "invalidreg"))

  (define (get d attrib)
    (let ((x (member attrib (cdr d))))
      (if x (cadr x) #f)))

  (define (gen-def d)
    (let ((id (car d)))
      (let ((class (get d 'class:))
            (field (get d 'field:))
            (mode  (get d 'mode:))
            (name  (or (get d 'name:) id)))
        (if (member class '(r8 r16 r32 r64 fpu mm xmm))
            (let ((i (+ field
                        (if (and (eq? class 'r8)
                                 (>= field 4)
                                 (< field 8)
                                 (not (eq? mode 'long)))
                            16
                            0)
                        (case class
                          ((r64) 0)
                          ((r32) 16)
                          ((r16) 32)
                          ((fpu) 48)
                          ((mm)  56)
                          ((xmm) 64)
                          ((r8)  80)))))
              (vector-set! names i name)
              `((define-macro (,(string->symbol (string-append "x86-" (symbol->string id))))
                  ,i)))
            `()))))

  (let* ((defs
           (apply append (map gen-def definitions)))
         (code
          `(begin
             (define-macro (x86-implement)
               `(begin
                  (define (x86-register-name reg)
                    (vector-ref ',',names reg))))
             (define-macro (x86-reg? x)
               `(fixnum? ,x))
             (define-macro (x86-reg8? reg)
               `(let ((n ,reg)) (fx>= n 80)))
             (define-macro (x86-reg8-h? reg)
               `(let ((n ,reg)) (fx>= n 96)))
             (define-macro (x86-xmm? reg)
               `(let ((n ,reg)) (and (fx>= n 64) (fx< n 80))))
             (define-macro (x86-mm? reg)
               `(let ((n ,reg)) (and (fx>= n 56) (fx< n 64))))
             (define-macro (x86-fpu? reg)
               `(let ((n ,reg)) (and (fx>= n 48) (fx< n 56))))
             (define-macro (x86-reg16? reg)
               `(let ((n ,reg)) (and (fx>= n 32) (fx< n 48))))
             (define-macro (x86-reg32? reg)
               `(let ((n ,reg)) (and (fx>= n 16) (fx< n 32))))
             (define-macro (x86-reg64? reg)
               `(let ((n ,reg)) (fx< n 16)))
             (define-macro (x86-reg-field reg)
               `(fxand ,reg 15))
             (define-macro (x86-reg8 n)
               `(fx+ 80 ,n))
             (define-macro (x86-reg16 n)
               `(fx+ 32 ,n))
             (define-macro (x86-reg32 n)
               `(fx+ 16 ,n))
             (define-macro (x86-reg64 n)
               n)
             (define-macro (x86-fpu n)
               `(fx+ 48 ,n))
             (define-macro (x86-reg-width reg)
               `(let ((n ,reg))
                  (cond ((fx< n 16) 64)
                        ((fx< n 32) 32)
                        ((fx< n 48) 16)
                        ((fx< n 64) 80)
                        ((fx< n 80) 128)
                        (else       8))))
             ,@defs)))
    ;;(pp code)
    ;;(pp names)
    code))

(x86-define-registers

  (al      class: r8  field: 0 )
  (cl      class: r8  field: 1 )
  (dl      class: r8  field: 2 )
  (bl      class: r8  field: 3 )
  (ah      class: r8  field: 4 )
  (ch      class: r8  field: 5 )
  (dh      class: r8  field: 6 )
  (bh      class: r8  field: 7 )
  (spl     class: r8  field: 4  mode: long)
  (bpl     class: r8  field: 5  mode: long)
  (sil     class: r8  field: 6  mode: long)
  (dil     class: r8  field: 7  mode: long)
  (r8b     class: r8  field: 8  mode: long)
  (r9b     class: r8  field: 9  mode: long)
  (r10b    class: r8  field: 10 mode: long)
  (r11b    class: r8  field: 11 mode: long)
  (r12b    class: r8  field: 12 mode: long)
  (r13b    class: r8  field: 13 mode: long)
  (r14b    class: r8  field: 14 mode: long)
  (r15b    class: r8  field: 15 mode: long)

  (ax      class: r16 field: 0 )
  (cx      class: r16 field: 1 )
  (dx      class: r16 field: 2 )
  (bx      class: r16 field: 3 )
  (sp      class: r16 field: 4 )
  (bp      class: r16 field: 5 )
  (si      class: r16 field: 6 )
  (di      class: r16 field: 7 )
  (r8w     class: r16 field: 8  mode: long)
  (r9w     class: r16 field: 9  mode: long)
  (r10w    class: r16 field: 10 mode: long)
  (r11w    class: r16 field: 11 mode: long)
  (r12w    class: r16 field: 12 mode: long)
  (r13w    class: r16 field: 13 mode: long)
  (r14w    class: r16 field: 14 mode: long)
  (r15w    class: r16 field: 15 mode: long)

  (eax     class: r32 field: 0 )
  (ecx     class: r32 field: 1 )
  (edx     class: r32 field: 2 )
  (ebx     class: r32 field: 3 )
  (esp     class: r32 field: 4 )
  (ebp     class: r32 field: 5 )
  (esi     class: r32 field: 6 )
  (edi     class: r32 field: 7 )
  (r8d     class: r32 field: 8  mode: long)
  (r9d     class: r32 field: 9  mode: long)
  (r10d    class: r32 field: 10 mode: long)
  (r11d    class: r32 field: 11 mode: long)
  (r12d    class: r32 field: 12 mode: long)
  (r13d    class: r32 field: 13 mode: long)
  (r14d    class: r32 field: 14 mode: long)
  (r15d    class: r32 field: 15 mode: long)

  (rax     class: r64 field: 0 )
  (rcx     class: r64 field: 1 )
  (rdx     class: r64 field: 2 )
  (rbx     class: r64 field: 3 )
  (rsp     class: r64 field: 4 )
  (rbp     class: r64 field: 5 )
  (rsi     class: r64 field: 6 )
  (rdi     class: r64 field: 7 )
  (r8      class: r64 field: 8  mode: long)
  (r9      class: r64 field: 9  mode: long)
  (r10     class: r64 field: 10 mode: long)
  (r11     class: r64 field: 11 mode: long)
  (r12     class: r64 field: 12 mode: long)
  (r13     class: r64 field: 13 mode: long)
  (r14     class: r64 field: 14 mode: long)
  (r15     class: r64 field: 15 mode: long)

  (st      class: fpu field: 0 )
  (st1     class: fpu field: 1 name: |st(1)|)
  (st2     class: fpu field: 2 name: |st(2)|)
  (st3     class: fpu field: 3 name: |st(3)|)
  (st4     class: fpu field: 4 name: |st(4)|)
  (st5     class: fpu field: 5 name: |st(5)|)
  (st6     class: fpu field: 6 name: |st(6)|)
  (st7     class: fpu field: 7 name: |st(7)|)

  (mm0     class: mm  field: 0 )
  (mm1     class: mm  field: 1 )
  (mm2     class: mm  field: 2 )
  (mm3     class: mm  field: 3 )
  (mm4     class: mm  field: 4 )
  (mm5     class: mm  field: 5 )
  (mm6     class: mm  field: 6 )
  (mm7     class: mm  field: 7 )

  (xmm0    class: xmm field: 0 )
  (xmm1    class: xmm field: 1 )
  (xmm2    class: xmm field: 2 )
  (xmm3    class: xmm field: 3 )
  (xmm4    class: xmm field: 4 )
  (xmm5    class: xmm field: 5 )
  (xmm6    class: xmm field: 6 )
  (xmm7    class: xmm field: 7 )
  (xmm8    class: xmm field: 8  mode: long)
  (xmm9    class: xmm field: 9  mode: long)
  (xmm10   class: xmm field: 10 mode: long)
  (xmm11   class: xmm field: 11 mode: long)
  (xmm12   class: xmm field: 12 mode: long)
  (xmm13   class: xmm field: 13 mode: long)
  (xmm14   class: xmm field: 14 mode: long)
  (xmm15   class: xmm field: 15 mode: long)

  (es      class: seg field: 0 )
  (cs      class: seg field: 1 )
  (ss      class: seg field: 2 )
  (ds      class: seg field: 3 )
  (fs      class: seg field: 4 )
  (gs      class: seg field: 5 )

)

;;;============================================================================
