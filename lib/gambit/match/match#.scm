;;;============================================================================

;;; File: "gambit/match/match#.scm"

;;; Copyright (c) 2008-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Pattern-matching 'match' special form.

(##namespace ("gambit/match#"

match

))

(##define-syntax match
  (lambda (src)
    (##import gambit/match/match-expand)
    (match-expand src #f #f #f)))

;;;============================================================================
