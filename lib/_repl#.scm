;;;============================================================================

;;; File: "_repl#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

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
  reason
  prev-level
  prev-depth
)

(define-type repl-channel
  id: F351CF0B-9C1B-4352-8CA2-032C14F7DE99
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
  error-port
  result-history

  read-command
  write-results
  display-monoline-message
  display-multiline-message
  display-continuation
  pinpoint-continuation
  really-exit?
  newline
  ask
  confirm
)

(define-type-of-repl-channel repl-channel-ports
  id: D7D5784C-16DC-4453-8832-CC05A6FE9353
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
