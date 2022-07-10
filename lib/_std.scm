;;;============================================================================

;;; File: "_std.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Implementation of exceptions.

(implement-library-type-length-mismatch-exception)

(define-prim (##raise-length-mismatch-exception arg-num proc . args);;;;;;;;;;;
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   #f
   #f
   (lambda (procedure arguments arg-num dummy1 dummy2)
     (macro-raise
      (macro-make-length-mismatch-exception procedure arguments arg-num)))))

;;;----------------------------------------------------------------------------

(macro-case-target
 ((C)
  (c-declare "#include \"os.h\"")))

;;;----------------------------------------------------------------------------

(define-fail-check-type mutable 'mutable)

(define-prim (##mutable? obj))

;;;----------------------------------------------------------------------------

(##include "~~lib/gambit/boolean/boolean.scm")
(##include "~~lib/gambit/symkey/symkey.scm")
(##include "~~lib/gambit/char/char.scm")
(##include "~~lib/gambit/list/list.scm")
(##include "~~lib/gambit/vector/vector.scm")
(##include "~~lib/gambit/string/string.scm")
(##include "~~lib/gambit/procedure/procedure.scm")
(##include "~~lib/gambit/promise/promise.scm")
(##include "~~lib/gambit/parameter/parameter.scm")

;;;============================================================================
