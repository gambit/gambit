(##namespace ("srfi/219#" define))

(##define-syntax define
  (syntax-rules ()
    ((define ((head . outer-args) . args) . body)
     (define (head . outer-args) (lambda args . body)))
    ((define head . body)
     (##define head . body))))
