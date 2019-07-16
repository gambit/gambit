(define-macro (match/action on-success on-fail datum . clauses)
  (let ((tmp (gensym))
        (succ (gensym))	
        (fail (gensym)))

    `(let ((,tmp ,datum)
           (,succ (lambda () ,on-success)) ;; the thunk for success is lifted
           (,fail (lambda () ,on-fail)))   ;; the thunk for failure is lifted

       ,(compile-pattern-match `(,succ) `(,fail) clauses tmp))))


(define-macro (match datum . clauses)
  (let ((tmp (gensym))
        (fail (gensym)))

    `(let* ((,tmp ,datum)
            (,fail (lambda ()
                     (raise
                       (list bad-match: ,tmp)))))
       ,(compile-pattern-match
          #f
          `(,fail)
          clauses
          tmp))))
