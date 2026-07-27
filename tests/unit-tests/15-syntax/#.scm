(include "../#.scm")

(define (call-with-new-global-binding-table thunk)
  (let ((saved (##cte-top-global-binding-table ##syntax-interaction-cte))
        (new   (##make-syntax-global-binding-table)))

    (set! ##syntax-global-binding-table new)
    (##cte-top-global-binding-table-set! ##syntax-interaction-cte new)

    (let ((result (thunk)))

      (set! ##syntax-global-binding-table saved)
      (##cte-top-global-binding-table-set! ##syntax-interaction-cte saved)

      result)))
