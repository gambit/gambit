;;;============================================================================

;;; File: "digest#.scm", Time-stamp: <2009-02-19 16:22:22 feeley>

;;; Copyright (c) 2005-2009 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("digest#"

;; procedures

open-digest
close-digest

digest-update-subu8vector
digest-update-u8
digest-update-u16-le
digest-update-u16-be
digest-update-u32-le
digest-update-u32-be

digest-string
digest-substring
digest-u8vector
digest-subu8vector
digest-file

))

;;;============================================================================
