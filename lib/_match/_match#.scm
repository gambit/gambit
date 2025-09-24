;;;============================================================================

;;; File: "_match#.scm"

;;; Copyright (c) 2008-2025 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Pattern-matching 'match' and 'match-syntax' special forms.

(##namespace ("_match#"

match
match-syntax

))

(##define-syntax match
  (lambda (src)
    (##import _match/match-expand)
    (match-expand src
                  #f    ;; use-question-mark-prefix-pattern-variables?
                  #t    ;; use-exhaustive-cases?
                  #f    ;; use-else?
                  #f))) ;; allow-source?

(##define-syntax match-syntax
  (lambda (src)
    (##import _match/match-expand)
    (match-expand src
                  #f    ;; use-question-mark-prefix-pattern-variables?
                  #t    ;; use-exhaustive-cases?
                  #f    ;; use-else?
                  #t))) ;; allow-source?


;;;============================================================================
