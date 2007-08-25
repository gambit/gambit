;==============================================================================

; File: "_guide#.scm", Time-stamp: <2007-04-04 11:32:46 feeley>

; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(define-type-of-repl-channel repl-channel-guide
  id: e188675f-7d4e-4e1f-8eb0-01a25aae640b
  extender: define-type-of-repl-channel-guide
  implementer: implement-type-repl-channel-guide
  macros:
  prefix: macro-
  opaque:
  equality-skip:
  unprintable:

  far-port
  GuideUiScheme
)

;==============================================================================
