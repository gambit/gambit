(include "#.scm")

;;;---------------------------------------
;;; global bindings


(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("a#"))
                 (##define x 1)
                 (##define y (##+ x x))
                 (##namespace (""))
                 (define z (+ a#y a#x))
                 z))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued  (##eval-for-top-syntax stx cte)))
    (check-equal? evalued 3)))

(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("b#" x))
                 (##define x 1)
                 (##define y (##+ x x))
                 (##namespace (""))
                 (define z (+ y b#x))
                 z))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued  (##eval-for-top-syntax stx cte)))
    (check-equal? evalued 3)))

(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("aa#"))
                 (##define-syntax x (##lambda (s) (##syntax 1)))
                 (##define-syntax y (##lambda (s) (##syntax (##+ (aa#x) (aa#x)))))
                 (y)
                 (##namespace (""))
                 (define-syntax z (lambda (s) (+ (aa#y) (aa#x))))
                 (z)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued  (##eval-for-top-syntax stx cte)))
    (check-equal? evalued 3)))

;;;---------------------------------------
;;; local bindings
;;;
;;; (local bindings are unaffected)

(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("c#"))
                 (##let ((x 0))
                   x)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued  (##eval-for-top-syntax stx cte)))
    (check-equal? evalued 0)))


(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("d#"))
                 (##let ((x 0))
                   d#x)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn
    unbound-global-exception?
    (lambda () (##eval-for-top-syntax stx cte))))


;;; replicate non-hygienic behavior
;;;
(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("e#"))
                 (##let ((x 0))
                   (##namespace (""))
                   x)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn
    unbound-global-exception?
    (lambda () (##eval-for-top-syntax stx cte))))

;;; replicate non-hygienic behavior
;;;
(let* ((cte ##syntax-interaction-cte)
      (datum `(##begin
                 (##namespace ("f#"))
                 (##let ((x 0))
                   (##namespace (""))
                   f#x)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn
    unbound-global-exception?
    (lambda () (##eval-for-top-syntax stx cte))))

