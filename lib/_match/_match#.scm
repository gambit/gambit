;;;============================================================================

;;; File: "_match#.scm"

;;; Copyright (c) 2008-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Pattern-matching 'match' special form.

(##namespace ("_match#"

match

))

(##define-syntax match
  (lambda (src)
    (##import _match/match-expand)
    (match-expand src
                  #f    ;; use-question-mark-prefix-pattern-variables?
                  #t    ;; use-exhaustive-cases?
                  #f))) ;; use-else?


;;;============================================================================
