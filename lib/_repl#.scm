;;;============================================================================

;;; File: "_repl#.scm", Time-stamp: <2009-01-29 14:51:38 feeley>

;;; Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define-type repl-context
  id: cd5f5bad-f96f-438d-8d63-ff887b7b39de
  constructor: macro-make-repl-context
  implementer: implement-type-repl-context
  macros:
  prefix: macro-
  opaque:
  unprintable:

  level
  depth
  cont
  initial-cont
  prev-level
  prev-depth
)

(define-type repl-channel
  id: 6bf088a7-814f-4139-860a-69a757570569
  extender: define-type-of-repl-channel
  constructor: macro-make-repl-channel
  implementer: implement-type-repl-channel
  macros:
  prefix: macro-
  opaque:
  unprintable:

  owner-mutex  ;; mutex to become owner of this repl-channel
  last-owner   ;; thread that last owned this repl-channel
  input-port
  output-port
  result-history

  read-command
  write-results
  display-monoline-message
  display-multiline-message
  display-continuation
  pinpoint-continuation
  really-exit?
  newline
)

(define-type-of-repl-channel repl-channel-ports
  id: 4e2301a4-27c7-4eef-b8fd-e046e192500c
  extender: define-type-of-repl-channel-ports
  constructor: macro-make-repl-channel-ports
  implementer: implement-type-repl-channel-ports
  macros:
  prefix: macro-
  opaque:
  unprintable:

  read-expr
)

;;;============================================================================
