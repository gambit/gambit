;;;============================================================================

;;; File: "_codegen#.scm"

;;; Copyright (c) 2010-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(namespace ("_codegen#"

codegen-implement

make-codegen-context
codegen-context-listing-format
codegen-context-listing-format-set!
codegen-context-arch
codegen-context-arch-set!
codegen-context-fixup-locs
codegen-context-fixup-locs-set!
codegen-context-fixup-objs
codegen-context-fixup-objs-set!
codegen-context-target
codegen-context-target-set!
codegen-context-frame-size
codegen-context-frame-size-set!
codegen-context-nargs
codegen-context-nargs-set!

codegen-context-fixup-locs->vector
codegen-context-fixup-objs->vector
codegen-fixup-lbl!
codegen-fixup-obj!
codegen-fixup-glo!
codegen-fixup-prm!
codegen-fixup-handler!

))

;;;============================================================================

(define-macro (codegen-implement)
  `(begin))

;;;============================================================================
