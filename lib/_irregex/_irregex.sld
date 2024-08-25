;;;============================================================================

;;; File: "_irregex.sld"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Alex Shinn's IrRegular Expressions library

;;; The upstream repository is: https://github.com/ashinn/irregex

(define-library (_irregex)

  (export

irregex string->irregex sre->irregex
string->sre maybe-string->sre
irregex? irregex-match-data?
irregex-new-matches irregex-reset-matches!
irregex-search irregex-search/matches irregex-match
irregex-search/chunked irregex-match/chunked make-irregex-chunker
irregex-match-substring irregex-match-subchunk
irregex-match-start-chunk irregex-match-start-index
irregex-match-end-chunk irregex-match-end-index
irregex-match-num-submatches irregex-match-names
irregex-match-valid-index?
irregex-fold irregex-replace irregex-replace/all
irregex-dfa irregex-dfa/search
irregex-nfa irregex-flags irregex-lengths irregex-names
irregex-num-submatches irregex-extract irregex-split

)

  (include "_irregex.scm"))

;;;============================================================================
