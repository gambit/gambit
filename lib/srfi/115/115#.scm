;;;============================================================================

;;; File: "115#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 115, Scheme Regular Expressions

(##namespace ("srfi/115#"

regexp regexp? valid-sre? rx regexp->sre char-set->sre
regexp-matches regexp-matches? regexp-search
regexp-replace regexp-replace-all regexp-match->list
regexp-fold regexp-extract regexp-split regexp-partition
regexp-match? regexp-match-count
regexp-match-submatch
regexp-match-submatch-start regexp-match-submatch-end

))

;;;============================================================================
