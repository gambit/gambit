(##namespace ("srfi/26#" cut cute))

(##define-syntax cut
  (lambda (src)
    (include "expand-cut.scm")
    (expand-cut #f src)))

(##define-syntax cute
  (lambda (src)
    (include "expand-cut.scm")
    (expand-cut #t src)))
