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

codegen-context-target
codegen-context-target-set!

codegen-context-fixup-locs
codegen-context-fixup-locs-set!
codegen-context-fixup-objs
codegen-context-fixup-objs-set!

codegen-context-current-proc
codegen-context-current-proc-set!
codegen-context-current-code
codegen-context-current-code-set!
codegen-context-frame
codegen-context-frame-set!
codegen-context-nargs
codegen-context-nargs-set!
codegen-context-delayed-actions
codegen-context-delayed-actions-set!
codegen-context-label-struct-position
codegen-context-label-struct-position-set!

codegen-context-registers-status
codegen-context-registers-status-set!
codegen-context-memory-allocated
codegen-context-memory-allocated-set!

codegen-context-primitive-labels-table
codegen-context-primitive-labels-table-set!
codegen-context-proc-labels-table
codegen-context-proc-labels-table-set!
codegen-context-other-labels-table
codegen-context-other-labels-table-set!

codegen-context-fixup-locs->vector
codegen-context-fixup-objs->vector
codegen-fixup-lbl!
codegen-fixup-lbl-late!
codegen-fixup-obj!
codegen-fixup-glo!
codegen-fixup-prm!
codegen-fixup-handler!

))

;;;============================================================================

(define-macro (codegen-implement)
  `(begin))

;;;============================================================================
