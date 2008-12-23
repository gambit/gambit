;;;============================================================================

;;; Install the syntax-case expander.

(define c#expand-source
  (lambda (src)
    src))

(set! c#expand-source ;; setup compiler's expander
  (lambda (src)
    (sc-expand src)))

(set! ##expand-source ;; setup interpreter's expander
  (lambda (src)
    (sc-expand src)))

;;;============================================================================
