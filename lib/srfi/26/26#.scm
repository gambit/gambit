(##namespace ("srfi/26#" cut cute))

(##define-syntax cut
  (lambda (src)
    (##import srfi/26/expand)
    (cut-expand src #f)))

(##define-syntax cute
  (lambda (src)
    (##import srfi/26/expand)
    (cut-expand src #t)))
