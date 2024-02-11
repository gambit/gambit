(include "#.scm")

; TODO

(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("a#" x))
                 (##define x 0)
                 (##+ x x)
                 (##define y (##+ x x))
                 (##namespace (""))
                 a#x
                 ;(define z (+ a#x a#x))
                 #;z))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))


(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##namespace ("a#"))
                 (##define-syntax x (##lambda (s) (##quote-syntax 0)))
                 (##+ (x) (x))
                 (##define y (##+ (x) (x)))
                 (##namespace (""))
                 (a#x)
                 (define z (+ (a#x) (a#x)))
                 z))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##namespace ("a#") ("" define))
                 (define (x) 0)
                 a#x))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (define-macro (t)
                   `(##begin
                      (namespace ("a#") ("" a-proc))
                      (a-proc)))
                 (define (a-proc) 0)
                 (t)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

