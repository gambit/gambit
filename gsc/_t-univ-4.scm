;;============================================================================

;;; File: "_t-univ-4.scm"

;;; Copyright (c) 2011-2017 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_univadt.scm")

;;----------------------------------------------------------------------------

(univ-define-prim "##type" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj 0)))));;TODO: implement

(univ-define-prim "##type-cast" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return arg1))));;TODO: implement

(univ-define-prim "##subtype" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj 0)))));;TODO: implement

(univ-define-prim "##subtype-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return #f))));;TODO: implement

(univ-define-prim-bool "##not" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^eq? (^cast*-scmobj arg1) (^obj #f))))))

(univ-define-prim-bool "##boolean?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^boolean? arg1)))))

(univ-define-prim-bool "##null?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^null-obj? arg1)))))

(univ-define-prim-bool "##unbound?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^unbound? arg1)))))

(univ-define-prim-bool "##eq?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^eq? (^cast*-scmobj arg1) (^cast*-scmobj arg2))))))

;;TODO: ("##eqv?"               (2)   #f ()    0    boolean extended)
;;TODO: ("##equal?"             (2)   #f ()    0    boolean extended)

(univ-define-prim-bool "##eof-object?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^eq? (^cast*-scmobj arg1) (^eof))))))

;;TODO: ("##special?"                 (1)   #f ()    0    boolean extended)

;;TODO: ("##subtyped?"                (1)   #f ()    0    boolean extended)

;; TODO: test ##subtyped-mutable?

(univ-define-prim-bool "##subtyped-mutable?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj #t))))) ;; there are no immutable data (currently)

;;TODO: ("##subtyped.vector?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.symbol?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.flonum?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.bignum?"         (1)   #f ()    0    boolean extended)

;;TODO: ("##meroon?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##jazz?"                    (1)   #f ()    0    boolean extended)

;;TODO: ("##gc-hash-table?"           (1)   #f ()    0    boolean extended)
;;TODO: ("##mem-allocated?"           (1)   #f ()    0    boolean extended)

;; TODO: test ##procedure?

(univ-define-prim-bool "##procedure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^procedure? arg1)))))

;;TODO: ("##s8vector?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##s16vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##f32vector?"               (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##flonum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^flonum? arg1)))))

(univ-define-prim "##cpxnum-make" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^cpxnum-make arg1 arg2)))))

(univ-define-prim "##cpxnum-real" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'cpxnum arg1) 'real)))))

(univ-define-prim "##cpxnum-imag" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'cpxnum arg1) 'imag)))))

(univ-define-prim-bool "##cpxnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^cpxnum? arg1)))))

(univ-define-prim "##ratnum-make" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^ratnum-make arg1 arg2)))))

(univ-define-prim "##ratnum-numerator" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'ratnum arg1) 'num)))))

(univ-define-prim "##ratnum-denominator" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'ratnum arg1) 'den)))))

(univ-define-prim-bool "##ratnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^ratnum? arg1)))))

;;TODO: ("##subprocedure?"            (1)   #f ()    0    boolean extended)
;;TODO: ("##return-dynamic-env-bind?" (1)   #f ()    0    boolean extended)
;;TODO: ("##number?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##complex?"                 (1)   #f ()    0    boolean extended)
;;TODO: ("##real?"                    (1)   #f ()    0    boolean extended)
;;TODO: ("##rational?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##integer?"                 (1)   #f ()    0    boolean extended)
;;TODO: ("##exact?"                   (1)   #f ()    0    boolean extended)
;;TODO: ("##inexact?"                 (1)   #f ()    0    boolean extended)

(univ-define-prim "##flsquare" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^parens (^* (^flonum-unbox arg)
                                       (^flonum-unbox arg))))))))

(univ-define-prim-bool "##fixnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^fixnum? arg1)))))

(univ-define-prim "##fxsquare" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^parens (^* (^fixnum-unbox arg)
                                       (^fixnum-unbox arg))))))))

(univ-define-prim "##fxwrapsquare" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (univ-wrap* ctx (^fixnum-unbox arg)
                                          (^fixnum-unbox arg)))))))

(univ-define-prim "##fxsquare?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (let ((max-sqrt (inexact->exact (floor (sqrt univ-fixnum-max)))))
      (return (^if-expr (^or (^> (^fixnum-unbox arg) (^int max-sqrt))
                             (^< (^fixnum-unbox arg) (^int (- max-sqrt))))
                        (^obj #f)
                        (^fixnum-box (^* (^fixnum-unbox arg)
                                         (^fixnum-unbox arg)))))))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##fxmax" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^> (^fixnum-unbox arg1) (^fixnum-unbox arg2))
                       arg1
                       arg2)))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##fxmin" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^< (^fixnum-unbox arg1) (^fixnum-unbox arg2))
                       arg1
                       arg2)))))

(univ-define-prim "##fxwrap+" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (univ-wrap+ ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx+" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^+ arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx+?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (^fixnum-unbox arg1)
            " + "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (^fixnum-unbox arg1)
            " + "
            (^fixnum-unbox arg2)
            ")"))

        ((php ruby)
         (^and (^parens
                (^= (^parens
                     (^assign-expr
                      (^rts-field-use 'inttemp2)
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^rts-field-use 'inttemp1)
                             (^+ (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^rts-field-use 'inttemp1)))
               (^fixnum-box (^rts-field-use 'inttemp2))))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (^fixnum-unbox arg1)
             " + "
             (^fixnum-unbox arg2)
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

        (else
         (compiler-internal-error
          "##fx+?, unknown target")))))))

(univ-define-prim "##fxwrap*" #f
  (univ-fold-left
   (lambda (ctx)           (^int 1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (univ-wrap* ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx*" #f
  (univ-fold-left
   (lambda (ctx)           (^int 1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^* arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx*?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (^fixnum-unbox arg1)
            " * "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (^fixnum-unbox arg1)
            " * "
            (^fixnum-unbox arg2)
            ")"))

        ((php ruby)
         (^and (^parens
                (^= (^parens
                     (^assign-expr
                      (^rts-field-use 'inttemp2)
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^rts-field-use 'inttemp1)
                             (^* (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^rts-field-use 'inttemp1)))
               (^fixnum-box (^rts-field-use 'inttemp2))))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (^fixnum-unbox arg1)
             " * "
             (^fixnum-unbox arg2)
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

        (else
         (compiler-internal-error
          "##fx*?, unknown target")))))))

(univ-define-prim "##fxwrap-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (univ-wrap- ctx arg1))
   (lambda (ctx arg1 arg2) (univ-wrap- ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (^- arg1))
   (lambda (ctx arg1 arg2) (^- arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx-?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ")"))

        ((ruby)
         (^ "(" (^rts-field-use 'inttemp2) " = (((" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") == " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

        ((php)
         (^ "((" (^rts-field-use 'inttemp2) " = (((" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") === " (^rts-field-use 'inttemp1) ") ? " (^fixnum-box (^rts-field-use 'inttemp2)) " : false"))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (if arg2
                 (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                 (^ "- " (^fixnum-unbox arg1)))
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

        (else
         (compiler-internal-error
          "##fx-?, unknown target")))))))

(univ-define-prim "##fxquotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxquotient
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxwrapquotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^fixnum-box (univ-wrap/ ctx (^fixnum-unbox arg1)
                                          (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxremainder" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxremainder
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxmodulo" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxmodulo
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxnot" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box (^bitnot (^fixnum-unbox arg)))))))

(univ-define-prim "##fxand" #f
  (univ-fold-left
   (lambda (ctx)           (^int -1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitand arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxior" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitior arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxxor" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitxor arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxif" #f
  (make-translated-operand-generator
    (lambda (ctx return arg1 arg2 arg3)
      (return
        (^fixnum-box
          (^bitior (^parens (^bitand (^fixnum-unbox arg1)
                                     (^fixnum-unbox arg2)))
                   (^parens (^bitand (^bitnot (^fixnum-unbox arg1))
                                     (^fixnum-unbox arg3)))))))))

(univ-define-prim "##fxbit-count" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
       (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
          (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
          (^popcount! tmp)
          (return (^fixnum-box tmp)))))))

(univ-define-prim "##fxlength" #f
  (make-translated-operand-generator
    (lambda (ctx return arg)
      (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
        (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
           (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
           (let gen-shift ((s 1) (acc (^)))
             (if (>= s univ-word-bits)
                 acc
                 (gen-shift
                   (* s 2)
                   (^ acc
                      (^assign tmp (^bitior tmp (^parens (^>> tmp s))))))))
           (^popcount! tmp)
           (return (^fixnum-box tmp)))))))

(univ-define-prim "##fxfirst-bit-set" #f
  (make-translated-operand-generator
    (lambda (ctx return arg)
      (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
        (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
           (^assign tmp (^bitxor tmp (^- tmp (^int 1))))
           (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
           (^popcount! tmp)
           (return (^fixnum-box (^- tmp (^int 1)))))))))

(univ-define-prim-bool "##fxbit-set?" #f
  (make-translated-operand-generator
    (lambda (ctx return arg1 arg2)
      (return
        (^!=
          (^parens
           (^bitand
            (^parens (^>> (^fixnum-unbox arg2)
                          (^fixnum-unbox arg1)))
            (^int 1)))
          (^int 0))))))

(univ-define-prim "##fxwraparithmetic-shift" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^if-expr (^< (^fixnum-unbox arg2) (^int 0))
                 (^>> (^fixnum-unbox arg1) (^- (^fixnum-unbox arg2)))
                 (univ-wrap ctx (^<< (^fixnum-unbox arg1)
                                     (^fixnum-unbox arg2)))))))))

(univ-define-prim "##fxwraparithmetic-shift?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^if-expr (^< (^fixnum-unbox arg2) (^int 0))

                (^if-expr (^> (^- (^fixnum-unbox arg2))
                              (^int (- univ-word-bits univ-tag-bits)))
                          (^obj #f)
                          (^fixnum-box
                           (^>> (^fixnum-unbox arg1) (^- (^fixnum-unbox arg2)))))

                (^if-expr (^> (^fixnum-unbox arg2)
                              (^int (- univ-word-bits univ-tag-bits)))
                          (^obj #f)

                          (^fixnum-box
                           (univ-wrap ctx (^<< (^fixnum-unbox arg1)
                                               (^fixnum-unbox arg2))))))))))

(univ-define-prim "##fxarithmetic-shift" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
        (^if-expr (^< (^fixnum-unbox arg2) (^int 0))
                  (^>> (^fixnum-unbox arg1) (^- (^fixnum-unbox arg2)))
                  (^<< (^fixnum-unbox arg1) (^fixnum-unbox arg2))))))))

;; TODO: Use a single expression
;; TODO: Maybe test -(univ-word-bits - univ-tag-bits) <= arg2 <= univ-word-bits - univ-tag-bits
(univ-define-prim "##fxarithmetic-shift?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^if (^< (^fixnum-unbox arg2) (^int 0))

          (return (^fixnum-box (^>> (^fixnum-unbox arg1)
                                    (^- (^fixnum-unbox arg2)))))

          (^ (^assign (^rts-field-use 'inttemp1)
                      (univ-wrap ctx (^<< (^fixnum-unbox arg1)
                                          (^fixnum-unbox arg2))))
             (return
               (^if-expr (^= (^fixnum-unbox arg1)
                             (^>> (^rts-field-use 'inttemp1) (^fixnum-unbox arg2)))
                         (^fixnum-box (^rts-field-use 'inttemp1))
                         (^obj #f))))))))

(univ-define-prim "##fxwraparithmetic-shift-left" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^if-expr (^= (^fixnum-unbox arg2) (^int (- univ-word-bits univ-tag-bits 1)))
                          (^int 0)
                          (^fixnum-box (univ-wrap ctx
                                                  (^<< (^fixnum-unbox arg1)
                                                       (^fixnum-unbox arg2)))))))))

(univ-define-prim "##fxwraparithmetic-shift-left?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^if-expr (^or (^< (^fixnum-unbox arg2)
                         (^int 0))
                     (^> (^fixnum-unbox arg2)
                         (^int (- univ-word-bits univ-tag-bits))))
                (^obj #f)
                (^if-expr (^= (^fixnum-unbox arg2) (^int (- univ-word-bits univ-tag-bits 1)))
                          (^int 0)
                          (^fixnum-box (univ-wrap ctx
                                                  (^<< (^fixnum-unbox arg1)
                                                       (^fixnum-unbox arg2))))))))))

(univ-define-prim "##fxarithmetic-shift-left" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^<< (^fixnum-unbox arg1)
                        (^fixnum-unbox arg2)))))))

;; TODO: Use a single expression
(univ-define-prim "##fxarithmetic-shift-left?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^if (^< (^fixnum-unbox arg2) (^int 0))
          (return (^obj #f))
          (^
            (^assign (^rts-field-use 'inttemp1)
                     (^if-expr (^> (^fixnum-unbox arg2)
                                   (^int (- univ-word-bits univ-tag-bits)))
                               (^int (- univ-word-bits univ-tag-bits))
                               (^fixnum-unbox arg2)))

            (^assign (^rts-field-use 'inttemp2)
                     (^<< (^fixnum-unbox arg1)
                          (^rts-field-use 'inttemp1)))

            (return (^if-expr (^= (^>> (univ-wrap ctx (^rts-field-use 'inttemp2))
                                       (^rts-field-use 'inttemp1))
                                  (^fixnum-unbox arg1))
                              (^fixnum-box (^rts-field-use 'inttemp2))
                              (^obj #f))))))))

(univ-define-prim "##fxarithmetic-shift-right" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^>> (^fixnum-unbox arg1) (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxarithmetic-shift-right?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^if-expr (^< (^fixnum-unbox arg2) (^int 0))
                (^obj #f)

                (^fixnum-box
                 (^>> (^fixnum-unbox arg1)
                      (^parens
                       (^if-expr (^> (^fixnum-unbox arg2)
                                     (^int (- univ-word-bits univ-tag-bits)))
                                 (^int (- univ-word-bits univ-tag-bits))
                                 (^fixnum-unbox arg2))))))))))

(univ-define-prim "##fxwraplogical-shift-right" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
        (^>> (^parens (^if-expr (^> (^fixnum-unbox arg2) (^int 0))
                                    (^bitand (^fixnum-unbox arg1) (^int univ-fixnum-max*2+1))
                                    (^fixnum-unbox arg1)))
             (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxwraplogical-shift-right?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^if-expr (^< (^fixnum-unbox arg2) (^int 0))
                (^obj #f)
                (^fixnum-box
                  (^>> (^parens
                        (^if-expr (^> (^fixnum-unbox arg2) (^int 0))
                                  (^bitand (^fixnum-unbox arg1)
                                           (^int univ-fixnum-max*2+1))
                                  (^fixnum-unbox arg1)))
                       (^parens
                        (^if-expr
                          (^> (^fixnum-unbox arg2) (^int (- univ-word-bits univ-tag-bits)))
                          (^int (- univ-word-bits univ-tag-bits))
                          (^fixnum-unbox arg2))))))))))

(univ-define-prim "##fxwrapabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^if-expr (^= (^fixnum-unbox arg) (^int univ-fixnum-min))
                          arg
                          (^fixnum-box (^- (^fixnum-unbox arg)))))))))

(univ-define-prim "##fxabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^fixnum-box (^- (^fixnum-unbox arg))))))))

(univ-define-prim "##fxabs?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^if-expr (^= (^fixnum-unbox arg) (^int univ-fixnum-min))
                          (^obj #f)
                          (^fixnum-box (^- (^fixnum-unbox arg)))))))))

(univ-define-prim-bool "##fxzero?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxpositive?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^> (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxnegative?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^< (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxodd?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^parens (^bitand (^fixnum-unbox arg1) (^int 1)))
                 (^int 1))))))

(univ-define-prim-bool "##fxeven?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^parens (^bitand (^fixnum-unbox arg1) (^int 1)))
                 (^int 0))))))

(univ-define-prim-bool "##fx=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx<" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx>" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx<=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx>=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##char?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^char? arg1)))))

(univ-define-prim "##integer->char" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^char-box (^chr-fromint (^fixnum-unbox arg)))))))

(univ-define-prim "##char->integer" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^chr-toint (^char-unbox arg)))))))

(univ-define-prim "##flonum->fixnum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^float-toint (^flonum-unbox arg)))))))

(univ-define-prim "##fixnum->flonum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-fromint (^fixnum-unbox arg)))))))

(univ-define-prim-bool "##fixnum->flonum-exact?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^bool #t)))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##flmax" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^> (^flonum-unbox arg1) (^flonum-unbox arg2))
                       arg1
                       arg2)))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##flmin" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^< (^flonum-unbox arg1) (^flonum-unbox arg2))
                       arg1
                       arg2)))))

(univ-define-prim "##fl+" #f
  (univ-fold-left
   (lambda (ctx)           (^float targ-inexact-+0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^+ arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl*" #f
  (univ-fold-left
   (lambda (ctx)           (^float targ-inexact-+1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^* arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)
     (case (target-name (ctx-target ctx))
       ((php)
        (^* arg1 (^int -1)))
       (else
        (^- arg1))))
   (lambda (ctx arg1 arg2)
     (^- arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl/" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (univ-ieee/ ctx (^float targ-inexact-+1) arg1))
   (lambda (ctx arg1 arg2) (univ-ieee/ ctx arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(define (univ-ieee/ ctx arg1 arg2)
  (case (target-name (ctx-target ctx))

    ((python)
     ;;TODO: cleanup the Python code
     (^if-expr (^= arg2 (^float targ-inexact-+0))
               (^if-expr (^= arg1 (^float targ-inexact-+0))
                         "float('nan')"
                         (^ "math.copysign(float('inf')," (^* arg1 arg2) ")"))
               (^/ arg1 arg2)))

    ((php)
     ;;TODO: cleanup the PHP code
     (^if-expr (^= arg2 (^float targ-inexact-+0))
               (^if-expr (^= arg1 (^float targ-inexact-+0))
                         "NAN"
                         (^if-expr (^eq? (^call-prim "strval" (^* arg1 (^float targ-inexact-+0)))
                                         (^call-prim "strval" arg2))
                                   "INF"
                                   "-INF"))
               (^/ arg1 arg2)))

    (else
     (^/ arg1 arg2))))

(univ-define-prim "##flabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-abs (^flonum-unbox arg)))))))

(univ-define-prim "##flfloor" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-floor (^flonum-unbox arg)))))))

(univ-define-prim "##flceiling" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-ceiling (^flonum-unbox arg)))))))

(univ-define-prim "##fltruncate" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-truncate (^flonum-unbox arg)))))))

(univ-define-prim "##flround" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-round-half-to-even (^flonum-unbox arg)))))))

(univ-define-prim "##flexp" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-exp (^flonum-unbox arg)))))))

(univ-define-prim "##fllog" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-log (^flonum-unbox arg)))))))

(univ-define-prim "##flsin" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-sin (^flonum-unbox arg)))))))

(univ-define-prim "##flcos" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-cos (^flonum-unbox arg)))))))

(univ-define-prim "##fltan" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-tan (^flonum-unbox arg)))))))

(univ-define-prim "##flasin" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-asin (^flonum-unbox arg)))))))

(univ-define-prim "##flacos" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-acos (^flonum-unbox arg)))))))

(univ-define-prim "##flatan" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^flonum-box
       (if arg2
           (^float-atan2 (^flonum-unbox arg1) (^flonum-unbox arg2))
           (^float-atan (^flonum-unbox arg1))))))))

(univ-define-prim "##flsinh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-sinh (^flonum-unbox arg)))))))

(univ-define-prim "##flcosh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-cosh (^flonum-unbox arg)))))))

(univ-define-prim "##fltanh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-tanh (^flonum-unbox arg)))))))

(univ-define-prim "##flasinh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-asinh (^flonum-unbox arg)))))))

(univ-define-prim "##flacosh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-acosh (^flonum-unbox arg)))))))

(univ-define-prim "##flatanh" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-atanh (^flonum-unbox arg)))))))

(univ-define-prim "##flexpt" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^flonum-box (^float-expt (^flonum-unbox arg1) (^flonum-unbox arg2)))))))

(univ-define-prim "##flsqrt" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-sqrt (^flonum-unbox arg)))))))

(univ-define-prim "##flcopysign" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)

     (define (has-negative-sign expr)
       (^parens
        (^or (^parens (^< (^flonum-unbox expr)
                          (^float targ-inexact-+0)))
             (^parens (^< (^/ (^float targ-inexact-+1)
                              (^flonum-unbox expr))
                          (^float targ-inexact-+0))))))

     (case (target-name (ctx-target ctx))
       ((python)
        (return
         (^flonum-box
          (^float-math 'copysign
                       (^flonum-unbox arg1)
                       (^flonum-unbox arg2)))))

       ((php)
        (return
         (^flonum-box
          ;; arg2 = -0.0 requires a special case
          (^* (^call-prim 'abs (^flonum-unbox arg1))
              (^parens
               (^if-expr (^> (^flonum-unbox arg2)
                             (^float targ-inexact-+0))
                         (^int 1)
                         (^if-expr (^< (^flonum-unbox arg2)
                                       (^float targ-inexact-+0))
                                   (^int -1)
                                   (^if-expr (^eq? (^call-prim
                                                    'strval
                                                    (^flonum-unbox arg2))
                                                   (^str "-0"))
                                             (^int -1)
                                             (^int 1)))))))))

       (else
        (return
         (^if-expr (^= (has-negative-sign arg1)
                       (has-negative-sign arg2))
                   arg1
                   (^flonum-box (^- (^flonum-unbox arg1))))))))))

(univ-define-prim "##flscalbn" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^flonum-box (^float-scalbn (^flonum-unbox arg1)
                                         (^fixnum-unbox arg2)))))))

(univ-define-prim "##flilogb" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^float-ilogb (^flonum-unbox arg)))))))

(univ-define-prim "##flexpm1" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-expm1 (^flonum-unbox arg)))))))

(univ-define-prim "##fllog1p" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-log1p (^flonum-unbox arg)))))))

(univ-define-prim-bool "##flinteger?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-integer? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flzero?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^= (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flpositive?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^> (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flnegative?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^< (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flodd?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^&& (^float-integer? (^flonum-unbox arg))
                  (^!= (^flonum-unbox arg)
                       (^* (^float targ-inexact-+2)
                           (^float-floor
                            (^parens (^* (^float targ-inexact-+1/2)
                                         (^flonum-unbox arg)))))))))))

(univ-define-prim-bool "##fleven?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^&& (^float-integer? (^flonum-unbox arg))
                  (^= (^flonum-unbox arg)
                      (^* (^float targ-inexact-+2)
                          (^float-floor
                           (^parens (^* (^float targ-inexact-+1/2)
                                        (^flonum-unbox arg)))))))))))

(univ-define-prim-bool "##flfinite?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-finite? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flinfinite?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-infinite? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flnan?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-nan? (^flonum-unbox arg))))))

(univ-define-prim-bool "##fl=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl<" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl>" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl<=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl>=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fleqv?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^float-eqv? (^flonum-unbox arg1) (^flonum-unbox arg2))))))

(univ-define-prim-bool "##char=?" #f
  ;;TODO: implement as eq? if chars are interned
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char<?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char>?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char<=?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char>=?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-char-unbox))

;;TODO: ("##char-alphabetic?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-numeric?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##char-whitespace?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-upper-case?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-lower-case?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-upcase"                  (1)   #f ()    0    char    extended)
;;TODO: ("##char-downcase"                (1)   #f ()    0    char    extended)

(univ-define-prim-bool "##pair?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^pair? arg1)))))

;; TODO: test ##pair-mutable?

(univ-define-prim-bool "##pair-mutable?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj #t))))) ;; there are no immutable data (currently)

(univ-define-prim "##cons" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^cons arg1 arg2)))))

(univ-define-prim "##set-car!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setcar arg1 arg2)
        (return arg1)))))

(univ-define-prim "##set-cdr!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setcdr arg1 arg2)
        (return arg1)))))

(define (univ-cxxxxr-init)
  (let cxxxxr-loop ((n #b10))
    (if (<= n #b11111)
        (let ()

          (define (ad-name prefix x)
            (if (>= x #b10)
                (string-append (ad-name prefix (quotient x 2))
                               (string (string-ref "ad" (modulo x 2))))
                prefix))

          (univ-define-prim (string-append (ad-name "##c" n) "r") #f
            (make-translated-operand-generator
             (lambda (ctx return arg)

               (define (ad-expr expr x)
                 (if (>= x #b10)
                     (ad-expr (if (= (modulo x 2) 0)
                                  (^getcar expr)
                                  (^getcdr expr))
                              (quotient x 2))
                     expr))

               (return (ad-expr arg n)))))

          (cxxxxr-loop (+ n 1))))))

(univ-cxxxxr-init)

(univ-define-prim "##list" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (let loop ((lst (reverse args))
                (result (^obj '())))
       (if (pair? lst)
           (loop (cdr lst)
                 (^cons (car lst)
                        result))
           (return result))))))

;;TODO: ("##gc-hash-table-ref"            (2)   #f ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-set!"           (3)   #t ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-rehash!"        (2)   #t ()    0    (#f)    extended)

;; TODO: test box? primitive

(univ-define-prim-bool "##box?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^box? arg1)))))

(univ-define-prim "##box" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^box arg1)))))

(univ-define-prim "##unbox" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^unbox arg1)))))

(univ-define-prim "##set-box!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setbox (^cast* 'box arg1) arg2)
        (return arg1)))))

(univ-define-prim-bool "##values?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^values? arg1)))))

(univ-define-prim "##values" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (if (= (length args) 1)
          (car args)
          (^values-box (^array-literal 'scmobj args)))))))

(univ-define-prim "##make-values" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_values)
       (^fixnum-unbox arg1)
       (or arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##values-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^values-length arg))))))

(univ-define-prim "##values-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^values-ref arg1
                          (^fixnum-unbox arg2))))))

(univ-define-prim "##values-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^values-set! arg1
                      (^fixnum-unbox arg2)
                      arg3)
        (return arg1)))))

(univ-define-prim-bool "##vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^vector? arg1)))))

(univ-define-prim "##vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^vector-box
       (^array-literal 'scmobj args))))))

(univ-define-prim "##make-vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_vector)
       (^fixnum-unbox arg1)
       (or arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^vector-length arg))))))

(univ-define-prim "##vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^vector-ref arg1
                   (^fixnum-unbox arg2))))))

(univ-define-prim "##vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^vector-set! arg1
                      (^fixnum-unbox arg2)
                      arg3)
        (return arg1)))))

(univ-define-prim "##vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^vector-shrink! arg1
                         (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##u8vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u8vector? arg1)))))

(univ-define-prim "##u8vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^u8vector-box
       (^array-literal
        'u8
        (map (lambda (arg)
               (^cast* 'u8
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-u8vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u8vector)
       (^fixnum-unbox arg1)
       (^cast* 'u8
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##u8vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u8vector-length arg))))))

(univ-define-prim "##u8vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^u8vector-ref arg1
                      (^fixnum-unbox arg2)))))))

(univ-define-prim "##u8vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u8vector-set! arg1
                        (^fixnum-unbox arg2)
                        (^fixnum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##u8vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u8vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##u16vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u16vector? arg1)))))

(univ-define-prim "##u16vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^u16vector-box
       (^array-literal
        'u16
        (map (lambda (arg)
               (^cast* 'u16
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-u16vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u16vector)
       (^fixnum-unbox arg1)
       (^cast* 'u16
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##u16vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u16vector-length arg))))))

(univ-define-prim "##u16vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^u16vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##u16vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u16vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^fixnum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##u16vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u16vector-shrink! arg1
                            (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##u32vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u32vector? arg1)))))

(univ-define-prim "##u32vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^u32vector-box
       (^array-literal
        'u32
        (map (lambda (arg)
               (^u32-unbox arg))
             args)))))))

(univ-define-prim "##make-u32vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u32vector)
       (^fixnum-unbox arg1)
       (^u32-unbox
        (or arg2
            (^fixnum-box (^int 0)))))))))

(univ-define-prim "##u32vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u32vector-length arg))))))

(univ-define-prim "##u32vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^u32-box
       (^u32vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##u32vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u32vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^u32-unbox arg3))
        (return arg1)))))

(univ-define-prim "##u32vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u32vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##u64vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u64vector? arg1)))))

(univ-define-prim "##u64vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^u64vector-box
       (^array-literal
        'u64
        (map (lambda (arg)
               (^u64-unbox arg))
             args)))))))

(univ-define-prim "##make-u64vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u64vector)
       (^fixnum-unbox arg1)
       (^u64-unbox
        (or arg2
            (^fixnum-box (^int 0)))))))))

(univ-define-prim "##u64vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u64vector-length arg))))))

(univ-define-prim "##u64vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^u64-box
       (^u64vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##u64vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u64vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^u64-unbox arg3))
        (return arg1)))))

(univ-define-prim "##u64vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u64vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##s8vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^s8vector? arg1)))))

(univ-define-prim "##s8vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^s8vector-box
       (^array-literal
        's8
        (map (lambda (arg)
               (^cast* 's8
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-s8vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_s8vector)
       (^fixnum-unbox arg1)
       (^cast* 's8
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##s8vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^s8vector-length arg))))))

(univ-define-prim "##s8vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^s8vector-ref arg1
                      (^fixnum-unbox arg2)))))))

(univ-define-prim "##s8vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^s8vector-set! arg1
                        (^fixnum-unbox arg2)
                        (^fixnum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##s8vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^s8vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##s16vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^s16vector? arg1)))))

(univ-define-prim "##s16vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^s16vector-box
       (^array-literal
        's16
        (map (lambda (arg)
               (^cast* 's16
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-s16vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_s16vector)
       (^fixnum-unbox arg1)
       (^cast* 's16
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##s16vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^s16vector-length arg))))))

(univ-define-prim "##s16vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^s16vector-ref arg1
                      (^fixnum-unbox arg2)))))))

(univ-define-prim "##s16vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^s16vector-set! arg1
                        (^fixnum-unbox arg2)
                        (^fixnum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##s16vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^s16vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##s32vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^s32vector? arg1)))))

(univ-define-prim "##s32vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^s32vector-box
       (^array-literal
        's32
        (map (lambda (arg)
               (^s32-unbox arg))
             args)))))))

(univ-define-prim "##make-s32vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_s32vector)
       (^fixnum-unbox arg1)
       (^s32-unbox
        (or arg2
            (^fixnum-box (^int 0)))))))))

(univ-define-prim "##s32vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^s32vector-length arg))))))

(univ-define-prim "##s32vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^s32-box
       (^s32vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##s32vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^s32vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^s32-unbox arg3))
        (return arg1)))))

(univ-define-prim "##s32vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^s32vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##s64vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^s64vector? arg1)))))

(univ-define-prim "##s64vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^s64vector-box
       (^array-literal
        's64
        (map (lambda (arg)
               (^s64-unbox arg))
             args)))))))

(univ-define-prim "##make-s64vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_s64vector)
       (^fixnum-unbox arg1)
       (^s64-unbox
        (or arg2
            (^fixnum-box (^int 0)))))))))

(univ-define-prim "##s64vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^s64vector-length arg))))))

(univ-define-prim "##s64vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^s64-box
       (^s64vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##s64vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^s64vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^s64-unbox arg3))
        (return arg1)))))

(univ-define-prim "##s64vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^s64vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##f32vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^f32vector? arg1)))))

(univ-define-prim "##f32vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^f32vector-box
       (^array-literal
        'f32
        (map (lambda (arg)
               (^cast* 'f32
                       (^flonum-unbox arg)))
             args)))))))

(univ-define-prim "##make-f32vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_f32vector)
       (^fixnum-unbox arg1)
       (if arg2
           (^cast* 'f32 (^flonum-unbox arg2))
           (^float targ-inexact-+0)))))))

(univ-define-prim "##f32vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^f32vector-length arg))))))

(univ-define-prim "##f32vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^flonum-box
       (^f32vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##f32vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^f32vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^cast* 'f32 (^flonum-unbox arg3)))
        (return arg1)))))

(univ-define-prim "##f32vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^f32vector-shrink! arg1
                            (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##f64vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^f64vector? arg1)))))

(univ-define-prim "##f64vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^f64vector-box
       (^array-literal
        'f64
        (map (lambda (arg)
               (^cast* 'f64
                       (^flonum-unbox arg)))
             args)))))))

(univ-define-prim "##make-f64vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_f64vector)
       (^fixnum-unbox arg1)
       (if arg2
           (^flonum-unbox arg2)
           (^float targ-inexact-+0)))))))

(univ-define-prim "##f64vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^f64vector-length arg))))))

(univ-define-prim "##f64vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^flonum-box
       (^f64vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##f64vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^f64vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^flonum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##f64vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^f64vector-shrink! arg1
                            (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##string?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^string? arg1)))))

(univ-define-prim "##string" #f
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^string-box
       (^array-literal 'unicode (map (lambda (x) (^char-unbox x)) args)))))))

(univ-define-prim "##make-string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_string)
       (^fixnum-unbox arg1)
       (if arg2
           (^char-unbox arg2)
           (^chr-fromint 0)))))))

(univ-define-prim "##string-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^string-length arg))))))

(univ-define-prim "##string-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^char-box
       (^string-ref (^string-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##string-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^string-set! (^string-unbox arg1)
                      (^fixnum-unbox arg2)
                      (^char-unbox arg3))
        (return arg1)))))

(univ-define-prim "##string-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^string-shrink! arg1
                         (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim-bool "##structure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^structure? arg1)))))

(univ-define-prim-bool "##structure-direct-instance-of?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^&& (^structure? arg1)
                  (^eq? (^structure-ref (^structure-ref arg1 0) 1)
                        (^cast*-scmobj arg2)))))))

;;TODO: ("##structure-instance-of?"       (2)   #f ()    0    boolean extended)

(univ-define-prim "##structure-type" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^structure-ref arg1 0)))))

(univ-define-prim "##structure-type-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^structure-set! arg1 0 arg2)
        (return arg1)))))

(univ-define-prim "##make-structure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^call-prim
       (^rts-method-use 'make_structure)
       arg1
       (^fixnum-unbox arg2))))))

(univ-define-prim "##structure-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^structure-unbox arg1)))))))

(univ-define-prim "##structure" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^structure-box (^array-literal 'scmobj args))))))

;;TODO: ("##structure-ref"                (4)   #f ()    0    (#f)    extended)
;;TODO: ("##structure-set!"               (5)   #t ()    0    (#f)    extended)
;;TODO: ("##direct-structure-ref"         (4)   #f ()    0    (#f)    extended)
;;TODO: ("##direct-structure-set!"        (5)   #t ()    0    (#f)    extended)

(univ-define-prim "##unchecked-structure-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return (^structure-ref arg1
                             (^fixnum-unbox arg2))))))

(univ-define-prim "##unchecked-structure-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^structure-set! arg1
                         (^fixnum-unbox arg3)
                         arg2)
        (return arg1)))))

;;TODO: ("##type-id"                      (1)   #f ()    0    #f      extended)
;;TODO: ("##type-name"                    (1)   #f ()    0    #f      extended)
;;TODO: ("##type-flags"                   (1)   #f ()    0    #f      extended)
;;TODO: ("##type-super"                   (1)   #f ()    0    #f      extended)
;;TODO: ("##type-fields"                  (1)   #f ()    0    #f      extended)

(univ-define-prim-bool "##symbol?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^symbol? arg1)))))

(univ-define-prim "##symbol->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^str->string (^symbol-unbox arg1))))))

(univ-define-prim "##string->symbol" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^symbol-box (^string->str arg1))))))

(univ-define-prim "##make-uninterned-symbol" #f
  (make-translated-operand-generator
   (lambda (ctx return name hash)
     (return (^symbol-box-uninterned (^string->str name) hash)))))

(univ-define-prim "##symbol-name" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     ;;;;FIXME for host representation
     (return
       (^str->string (^member (^cast* 'symbol sym) 'name))))))

(univ-define-prim "##symbol-name-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym name)
     (^ (^assign (^member (^cast* 'symbol sym) 'name)
                 (^string->str name))
        (return sym)))))

(univ-define-prim "##symbol-hash" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     ;;;;FIXME for host representation
     (return (^member (^cast* 'symbol sym) 'hash)))))

(univ-define-prim "##symbol-hash-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym hash)
     (^ (^assign (^member (^cast* 'symbol sym) 'hash) hash)
        (return sym)))))

(univ-define-prim "##symbol-interned?" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     (return (^member (^cast* 'symbol sym) 'interned)))));;;;FIXME for host representation

(univ-define-prim-bool "##keyword?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^keyword? arg1)))))

(univ-define-prim "##keyword->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^str->string (^keyword-unbox arg1))))))

(univ-define-prim "##string->keyword" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^keyword-box (^string->str arg1))))))

(univ-define-prim "##make-uninterned-keyword" #f
  (make-translated-operand-generator
   (lambda (ctx return name hash)
     (return (^keyword-box-uninterned (^string->str name) hash)))))

(univ-define-prim "##keyword-name" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     ;;;;FIXME for host representation
     (return
       (^str->string (^member (^cast* 'keyword key) 'name))))))

(univ-define-prim "##keyword-name-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return key name)
     (^ (^assign (^member (^cast* 'keyword key) 'name)
                 (^string->str name))
        (return key)))))

(univ-define-prim "##keyword-hash" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     ;;;;FIXME for host representation
     (return (^member (^cast* 'keyword key) 'hash)))))

(univ-define-prim "##keyword-hash-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return key hash)
     (^ (^assign (^member (^cast* 'keyword key) 'hash) hash)
        (return key)))))

(univ-define-prim "##keyword-interned?" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     (return (^member (^cast* 'keyword key) 'interned)))));;;;FIXME for host representation

(univ-define-prim-bool "##closure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^closure? arg1)))))

(univ-define-prim "##make-closure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^call-prim
       (^rts-method-use 'make_closure)
       arg1
       (^fixnum-unbox arg2))))))

(univ-define-prim "##closure-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^closure-length arg))))))

(univ-define-prim "##closure-code" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^closure-code arg)))))

(univ-define-prim "##closure-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^closure-ref arg1
                           (^fixnum-unbox arg2))))))

(univ-define-prim "##closure-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^closure-set! arg1
                       (^fixnum-unbox arg2)
                       arg3)
        (return arg1)))))

(univ-define-prim "##make-subprocedure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^call-prim
       (^rts-method-use 'make_subprocedure)
       (^cast* 'parententrypt arg1)
       (^fixnum-unbox arg2))))))

(univ-define-prim "##subprocedure-id" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'ctrlpt
      'id
      (lambda (result)
        (return (^fixnum-box result)))))))

(define (univ-ctrlpt-reference-type ctx)
  (if (and (eq? (target-name (ctx-target ctx)) 'php)
           (eq? (univ-procedure-representation ctx) 'host))
      'str
      'ctrlpt))

(define (univ-ctrlpt-reference ctx lbl-num)
  (let ((lbl (make-lbl lbl-num)))
    (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
        (^str (^prefix (gvm-lbl-use-aux ctx lbl)))
        (gvm-lbl-use ctx lbl))))

(define (univ-prm-name ctx name)
  (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
      (^str name)
      (^obj (string->symbol name))))

(define (univ-ctrlpt-reference-to-ctrlpt ctx ref)
  ref
  ;; in PHP a function is a string!
  #;
  (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
      (^call-prim
       (^rts-method-use 'get_host_global_var)
       ref)
      ref))

(define (univ-parent-entry-point-has-null-parent? ctx)
  (and (eq? (univ-procedure-representation ctx) 'host)
       (case (target-name (ctx-target ctx))
         ((js) #f)
         ((php) (not (univ-php-pre53? ctx)))
         (else #t))))

(define (univ-method-reference ctx meth)
  (if (and (eq? (target-name (ctx-target ctx)) 'php)
           (univ-php-pre53? ctx))
      (univ-stringify-method meth)
      meth))

(define univ-stringify-delimiter (string #\"))

(define (univ-stringify-method meth)
  (list univ-stringify-delimiter meth univ-stringify-delimiter))

(define (univ-unstringify-method meth)
  (if (and (pair? meth) (eq? (car meth) univ-stringify-delimiter))
      (cadr meth)
      meth))

(univ-define-prim "##subprocedure-parent" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent ctx return arg1))))

(define (univ-subprocedure-parent ctx return arg1)
  (univ-call-with-ctrlpt-attrib
   ctx
   (^cast* 'ctrlpt arg1)
   'ctrlpt
   'parent
   (lambda (result)
     (return
      (if (univ-parent-entry-point-has-null-parent? ctx)
          (^if-expr (^null? result)
                    (^cast* 'ctrlpt arg1)
                    (univ-ctrlpt-reference-to-ctrlpt ctx result))
          result)))))

(univ-define-prim "##subprocedure-nb-parameters" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'entrypt
      'nb_parameters
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-nb-closed" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'entrypt
      'nfree
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-parent-name" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent
      ctx
      (lambda (result)
        (univ-call-with-ctrlpt-attrib
         ctx
         result
         'parententrypt
         (univ-proc-name-attrib ctx)
         (lambda (result)
           (return
            (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
                (^symbol-box result)
                result)))))
      arg1))))

(univ-define-prim "##subprocedure-parent-info" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent
      ctx
      (lambda (result)
        (univ-call-with-ctrlpt-attrib
         ctx
         result
         'parententrypt
         'info
         return))
      arg1))))

(univ-define-prim-bool "##promise?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^promise? arg1)))))

(univ-define-prim "##make-promise" #t
  (make-translated-operand-generator
   (lambda (ctx return thunk)
     (return (^new-promise thunk)))))

(univ-define-prim "##promise-thunk" #f
  (make-translated-operand-generator
   (lambda (ctx return prom)
     (return (^member (^cast* 'promise prom) 'thunk)))))

(univ-define-prim "##promise-thunk-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return prom thunk)
     (^ (^assign (^member (^cast* 'promise prom) 'thunk) thunk)
        (return prom)))))

(univ-define-prim "##promise-result" #f
  (make-translated-operand-generator
   (lambda (ctx return prom)
     (return (^member (^cast* 'promise prom) 'result)))))

(univ-define-prim "##promise-result-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return prom result)
     (^ (^assign (^member (^cast* 'promise prom) 'result) result)
        (return prom)))))


;;TODO: ("##force"                        (1)   #t 0     0    #f      extended)

(univ-define-prim "##void" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^void-obj)))))

(univ-define-prim "##current-thread" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^rts-field-use 'current_thread)))))

;;TODO: ("##run-queue"                    (0)   #f ()    0    #f      extended)

;;TODO: ("##thread-save!"                 1     #t ()    1113 (#f)    extended)
;;TODO: ("##thread-restore!"              2     #t ()    2203 #f      extended)

;;TODO: ("##continuation-capture"         1     #t ()    1113 (#f)    extended)
;;TODO: ("##continuation-graft"           2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-graft-no-winding" 2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-return"           (2)   #t ()    0    #f      extended)
;;TODO: ("##continuation-return-no-winding"(2)   #t ()    0    #f      extended)

(define (univ-end-of-cont-marker ctx)
  (^void-obj))

(univ-define-prim-bool "##continuation?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^continuation? arg1)))))

(univ-define-prim "##make-continuation" #t
  (make-translated-operand-generator
   (lambda (ctx return frame denv)
     (return (^new-continuation
              (^cast* 'frame frame)
              denv)))))

(univ-define-prim "##continuation-frame" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (^member (^cast* 'continuation cont) 'frame)))))

(univ-define-prim "##continuation-frame-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont frame)
     (^ (^assign (^member (^cast* 'continuation cont) 'frame) frame)
        (return cont)))))

(univ-define-prim "##continuation-denv" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (^member (^cast* 'continuation cont) 'denv)))))

(univ-define-prim "##continuation-denv-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont denv)
     (^ (^assign (^member (^cast* 'continuation cont) 'denv) denv)
        (return cont)))))

(univ-define-prim "##continuation-next" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return
      (^call-prim
       (^rts-method-use 'continuation_next)
       (^cast* 'continuation cont))))))

(univ-define-prim "##continuation-ret" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (univ-frame-ra ctx (^member (^cast* 'continuation cont) 'frame))))))

(define (univ-get-cont-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (univ-get-ra-field
      ctx
      return
      (univ-frame-ra ctx (^member (^cast* 'continuation cont) 'frame))
      attrib))))

(univ-define-prim "##continuation-fs"   #f (univ-get-cont-ra-field 'fs))
(univ-define-prim "##continuation-link" #f (univ-get-cont-ra-field 'link))

(univ-define-prim "##continuation-ref" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index)
     (return
      (univ-frame-ref
       ctx
       (^frame-unbox (^member (^cast* 'continuation cont) 'frame))
       (^fixnum-unbox index))))))

(univ-define-prim "##continuation-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index val)
     (^ (univ-frame-set!
         ctx
         (^frame-unbox (^member (^cast* 'continuation cont) 'frame))
         (^fixnum-unbox index)
         val)
        (return cont)))))

(univ-define-prim "##continuation-slot-live?" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index)
     (return
      (^boolean-box
       (univ-frame-slot-live? ctx (^member (^cast* 'continuation cont) 'frame) index))))))

(univ-define-prim-bool "##frame?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^frame? arg1)))))

(univ-define-prim "##make-frame" #t
  (make-translated-operand-generator
   (lambda (ctx return ra)
     (return
       (^call-prim
         (^rts-method-use 'make_frame)
         (^cast* 'returnpt ra))))))

(univ-define-prim "##frame-ret" #t
  (make-translated-operand-generator
   (lambda (ctx return frame)
     (return (univ-frame-ra ctx frame)))))

(define (univ-frame-ra ctx frame)
  (^cast* 'returnpt (^array-index (^frame-unbox frame) 0)))

(define (univ-get-frame-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return frame)
     (univ-get-ra-field
      ctx
      return
      (univ-frame-ra ctx frame)
      attrib))))

(univ-define-prim "##frame-fs"   #f (univ-get-frame-ra-field 'fs))
(univ-define-prim "##frame-link" #f (univ-get-frame-ra-field 'link))

(univ-define-prim "##frame-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return frame index)
     (return
      (univ-frame-ref
       ctx
       (^frame-unbox frame)
       (^fixnum-unbox index))))))

(univ-define-prim "##frame-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return frame index val)
     (^ (univ-frame-set!
         ctx
         (^frame-unbox frame)
         (^fixnum-unbox index)
         val)
        (return frame)))))

(univ-define-prim "##frame-slot-live?" #t
  (make-translated-operand-generator
   (lambda (ctx return frame index)
     (return
      (^boolean-box
       (univ-frame-slot-live? ctx frame index))))))

(define (univ-frame-ref ctx frame index)
  (^array-index frame index))

(define (univ-frame-set! ctx frame index val)
  (^assign (^array-index frame index) val))

(define (univ-frame-slot-live? ctx frame index)
  (^bool #t));;TODO implement

(define (univ-get-return-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return ret)
     (univ-get-ra-field
      ctx
      return
      ret
      attrib))))

(define (univ-get-ra-field ctx return ra attrib)
  (let ((ra-var (^local-var (univ-gensym ctx 'ra))))
    (^ (^var-declaration
        'returnpt
        ra-var
        ra)
       (univ-with-ctrlpt-attribs
        ctx
        #f
        ra-var
        (lambda ()
          (return
           (^fixnum-box
            (univ-get-ctrlpt-attrib ctx ra-var attrib))))))))

(univ-define-prim-bool "##return?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^return? arg1)))))

(univ-define-prim "##return-fs" #f
  (univ-get-return-ra-field 'fs))

(univ-define-prim-bool "##will?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^will? arg1)))))

(univ-define-prim "##make-will" #t
  (make-translated-operand-generator
   (lambda (ctx return testator action)
     (return (^new-will testator action)))))

(univ-define-prim "##will-testator" #t
  (make-translated-operand-generator
   (lambda (ctx return will)
     (return (^member (^cast* 'will will) 'testator)))))

(univ-define-prim "##will-testator-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return will testator)
     (^ (^assign (^member (^cast* 'will will) 'testator) testator)
        (return will)))))

(univ-define-prim "##will-action" #t
  (make-translated-operand-generator
   (lambda (ctx return will)
     (return (^member (^cast* 'will will) 'action)))))

(univ-define-prim "##will-action-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return will action)
     (^ (^assign (^member (^cast* 'will will) 'action) action)
        (return will)))))

(univ-define-prim-bool "##foreign?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^foreign? arg1)))))

(univ-define-prim "##foreign-tags" #t
  (make-translated-operand-generator
   (lambda (ctx return foreign)
     (return (^member (^cast* 'foreign foreign) 'tags)))))

(univ-define-prim "##apply" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "apply")))

;;TODO: ("##call-with-current-continuation"1     #t ()    1113 (#f)    extended)

(univ-define-prim-bool "##global-var?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^bool #f))))) ;;TODO: implement

(univ-define-prim "##make-global-var" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^rts-method-use 'make_glo_var)
       (^cast* 'symbol
               arg1))))))

(univ-define-prim "##global-var-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^glo-var-ref arg1)))))

(univ-define-prim "##global-var-primitive-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^glo-var-primitive-ref arg1)))))

(univ-define-prim "##global-var-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^glo-var-set! arg1 arg2)
        (return arg1)))))

(univ-define-prim "##global-var-primitive-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^glo-var-primitive-set! arg1 arg2)
        (return arg1)))))

(univ-define-prim "##first-argument" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 . rest)
     (return arg1))))

(univ-define-prim "##check-heap-limit" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^void-obj)))))

;;TODO: ("##quasi-append"                  0     #f 0     0    list    extended)
;;TODO: ("##quasi-list"                    0     #f ()    0    list    extended)
;;TODO: ("##quasi-cons"                    (2)   #f ()    0    pair    extended)
;;TODO: ("##quasi-list->vector"            (1)   #f 0     0    vector  extended)
;;TODO: ("##quasi-vector"                  0     #f ()    0    vector  extended)
;;TODO: ("##case-memv"                     (2)   #f 0     0    list    extended)

(univ-define-prim-bool "##bignum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^bignum? arg1)))))

(univ-define-prim-bool "##bignum.negative?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^> (^array-index (^bignum-digits arg1)
                        (^- (^array-length (^bignum-digits arg1))
                            (^int 1)))
          (^int 8191)))))) ;;TODO: adjust for digit size

(univ-define-prim "##bignum.adigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box
       (^array-length
        (^bignum-digits arg1)))))))

(univ-define-prim "##bignum.adigit-inc!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^parens (^+ (^rts-field-use 'inttemp1) (^int 1)))
                                  (^int 16383))))
        (return
         (^if-expr (^= (^rts-field-use 'inttemp1)
                       (^int 16383))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-dec!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^parens (^- (^rts-field-use 'inttemp1) (^int 1)))
                                  (^int 16383))))
        (return
         (^if-expr (^= (^rts-field-use 'inttemp1)
                       (^int 0))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-add!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^rts-field-use 'inttemp2)
                 (^bitand (^parens (^+ (^+ (^rts-field-use 'inttemp1)
                                           (^array-index (^bignum-digits arg3)
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^rts-field-use 'inttemp2)))
        (return
         (^if-expr (^< (^rts-field-use 'inttemp2)
                       (^+ (^rts-field-use 'inttemp1) (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-sub!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^rts-field-use 'inttemp2)
                 (^bitand (^parens (^- (^- (^rts-field-use 'inttemp1)
                                           (^array-index (^bignum-digits arg3)
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^rts-field-use 'inttemp2)))
        (return
         (^if-expr (^> (^rts-field-use 'inttemp2)
                       (^- (^rts-field-use 'inttemp1) (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.mdigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^bignum-digits arg1)))))))

(univ-define-prim "##bignum.mdigit-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^array-index (^bignum-digits arg1)
                                 (^fixnum-unbox arg2)))))))

(univ-define-prim "##bignum.mdigit-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^fixnum-unbox arg3)))
        (return arg1)))))

(univ-define-prim "##bignum.mdigit-mul!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^+ (^+ (^array-index (^bignum-digits arg1)
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^bignum-digits arg3)
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^rts-field-use 'inttemp1)
                                  (^int 16383))))
        (return
         (^fixnum-box (^>> (^rts-field-use 'inttemp1) (^int 14))))))))

(univ-define-prim "##bignum.mdigit-div!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^+ (^- (^array-index (^bignum-digits arg1)
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^bignum-digits arg3)
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^rts-field-use 'inttemp1)
                                  (^int 16383))))
        (^assign (^rts-field-use 'inttemp1)
                 (^>> (^rts-field-use 'inttemp1) (^int 14)))
        (return
         (^fixnum-box
          (^if-expr (^> (^rts-field-use 'inttemp1) (^int 0))
                    (^- (^rts-field-use 'inttemp1) (^int 16384))
                    (^rts-field-use 'inttemp1))))))))

(univ-define-prim "##bignum.mdigit-quotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^fixnum-box (univ-fxquotient
                    ctx
                    (^parens
                     (^+ (^parens
                          (^<< (^array-index (^bignum-digits arg1)
                                             (^fixnum-unbox arg2))
                               (^int 14)))
                         (^array-index (^bignum-digits arg1)
                                       (^- (^fixnum-unbox arg2)
                                           (^int 1)))))
                    (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.mdigit-remainder" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return
      (^fixnum-box (^- (^parens
                        (^+ (^parens
                             (^<< (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2))
                                  (^int 14)))
                            (^array-index (^bignum-digits arg1)
                                          (^- (^fixnum-unbox arg2)
                                              (^int 1)))))
                       (^* (^fixnum-unbox arg3)
                           (^fixnum-unbox arg4))))))))

(univ-define-prim-bool "##bignum.mdigit-test?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return
      (^> (^* (^fixnum-unbox arg1)
              (^fixnum-unbox arg2))
          (^+ (^parens
               (^<< (^fixnum-unbox arg3)
                    (^int 14)))
              (^fixnum-unbox arg4)))))))

(univ-define-prim-bool "##bignum.adigit-ones?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 16383))))))

(univ-define-prim-bool "##bignum.adigit-zero?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 0))))))

(univ-define-prim-bool "##bignum.adigit-negative?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^> (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 8191))))))

(univ-define-prim-bool "##bignum.adigit-=" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg3))
          (^array-index (^bignum-digits arg2)
                        (^fixnum-unbox arg3)))))))

(univ-define-prim-bool "##bignum.adigit-<" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^< (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg3))
          (^array-index (^bignum-digits arg2)
                        (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.make" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^call-prim
       (^rts-method-use 'bignum_make)
       (^fixnum-unbox arg1)
       arg2
       (^boolean-unbox arg3))))))

(univ-define-prim "##fixnum->bignum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^rts-method-use 'bignum_from_s32)
       (^fixnum-unbox arg1))))))

(univ-define-prim "##bignum.adigit-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^array-shrink! (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-copy!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^array-index (^bignum-digits arg3)
                               (^fixnum-unbox arg4)))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-cat!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6 arg7)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand
                          (^parens
                           (^+ (^parens
                                (^<< (^array-index (^bignum-digits arg3)
                                                   (^fixnum-unbox arg4))
                                     (^fixnum-unbox arg7)))
                               (^parens
                                (^>> (^array-index (^bignum-digits arg5)
                                                   (^fixnum-unbox arg6))
                                     (^- (^int 14)
                                         (^fixnum-unbox arg7))))))
                          16383)))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-and!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2))
                                  (^array-index (^bignum-digits arg3)
                                                (^fixnum-unbox arg4)))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-ior!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitior (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2))
                                  (^array-index (^bignum-digits arg3)
                                                (^fixnum-unbox arg4)))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-xor!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitxor (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2))
                                  (^array-index (^bignum-digits arg3)
                                                (^fixnum-unbox arg4)))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-not!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitnot (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2)))))
        (return arg1)))))

;;----------------------------------------------------------------------------

;;TODO: clean up and integrate to above

(define (univ-expand-inline-host-code ctx str args)
  (let ((nb-args (length args))
        (len (string-length str)))
    (let loop1 ((start 0) (i 0))

      (define (done)
        (^ (substring str start len)))

      (if (< i len)
          (let ((c (string-ref str i)))
            (if (not (char=? c #\@))
                (loop1 start (+ i 1))
                (let loop2 ((j (+ i 1)))
                  (if (< j len)
                      (let ((c (string-ref str j)))
                        (cond ((char-numeric? c)
                               (loop2 (+ j 1)))
                              ((and (char=? c #\@)
                                    (> j (+ i 1)))
                               (let ((n
                                      (string->number
                                       (substring str (+ i 1) j))))
                                 (if (and (>= n 1) (<= n nb-args))
                                     (^ (substring str start i)
                                        (^getopnd (list-ref args (- n 1)))
                                        (loop1 (+ j 1) (+ j 1)))
                                     (loop1 start (+ j 1)))))
                              (else
                               (loop1 start (+ j 1)))))
                      (done)))))
          (done)))))

(univ-define-prim "##inline-host-statement" #t

  (lambda (ctx return opnds)
    (univ-use-rtlib ctx 'ffi)
    (if (and (> (length opnds) 0)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (^ (univ-expand-inline-host-code ctx (obj-val (car opnds)) (cdr opnds))
           (return #f))
        (compiler-internal-error "##inline-host-statement requires a constant string argument"))))

(univ-define-prim "##inline-host-expression" #t

  (lambda (ctx return opnds)
    (univ-use-rtlib ctx 'ffi)
    (if (and (> (length opnds) 0)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (return
         (univ-expand-inline-host-code ctx (obj-val (car opnds)) (cdr opnds)))
        (compiler-internal-error "##inline-host-expression requires a constant string argument"))))

(univ-define-prim "##inline-host-declaration" #t

  (lambda (ctx return opnds)
    (univ-use-rtlib ctx 'ffi)
    (if (and (= (length opnds) 1)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (let ((decl (obj-val (car opnds))))
          (queue-put! (ctx-decls ctx) (^ decl "\n"))
          (return #f))
        (compiler-internal-error "##inline-host-declaration requires a constant string argument"))))

(univ-define-prim "##continuation-capture" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      1
                      4
                      poll?
                      safe?
                      fs
                      "continuation_capture")))

(univ-define-prim "##continuation-graft-no-winding" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "continuation_graft_no_winding")))

(univ-define-prim "##continuation-return-no-winding" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      2
                      2
                      poll?
                      safe?
                      fs
                      "continuation_return_no_winding")))

(define (univ-jump-inline ctx ret nb-args min-args max-args poll? safe? fs name)
  (and (>= nb-args min-args)
       (<= nb-args max-args)
       (with-stack-pointer-adjust
        ctx
        (+ fs
           (ctx-stack-base-offset ctx))
        (lambda (ctx)
          (let ((rtlib-name
                 (string->symbol
                  (string-append name (number->string nb-args)))))
            (^ (if ret
                   (^setloc (make-reg 0) (^getopnd (make-lbl ret)))
                   (^))
               (^return-poll
                (^rts-jumpable-use rtlib-name)
                poll?
                #t)))))))

(univ-define-prim "##thread-save!" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      1
                      4
                      poll?
                      safe?
                      fs
                      "thread_save")))

(univ-define-prim "##thread-restore!" #f

  #f
  #f

  (lambda (ctx ret nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      ret
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "thread_restore")))

;;;============================================================================
