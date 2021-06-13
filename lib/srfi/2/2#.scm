(##namespace ("srfi/2#" and-let*))

(##define-syntax and-let*
  (lambda (src)
    (include "syntax-utils.scm")
    (include "expand-and-let.scm")
    (expand-and-let* src)))
