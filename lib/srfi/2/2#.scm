(##namespace ("srfi/2#" and-let*))

(##define-syntax and-let*
  (let ()
    (import srfi/2/expand)
    and-let*-expand))
