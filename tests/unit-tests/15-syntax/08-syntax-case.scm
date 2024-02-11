(include "#.scm")

;;;----------------------------------------------------------------------------
;; base
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       (_ ((lambda _ (##syntax #t)))))))
                 (t0)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

;; literals + wildcard
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t1
                   (##lambda (s)
                     (##syntax-case s (a)
                       (a (##make-syntax-source #f #f))
                       (_ (##make-syntax-source #t #f)))))
                 (t1 (0 1) (2 3))))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

;;; elipsis
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t2
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ (a ...)) (##syntax (list a ...))))))
                 (t2 (0 1))))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list 0 1))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t2
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ (a ...) ...) (##syntax (list (list a ...) ...))))))
                 (t2 (0 1) (2 3))))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 0 1) (list 2 3)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t3
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ (a b) ...) (##syntax (list (list a ...) (list b ...)))))))
                 (t3 (0 1) (2 3))))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 0 2) (list 1 3)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t3
                   (##lambda (s)
                     (##syntax-case s ()
                       ((a . b) (##syntax 0)))))
                 (t3 2 3)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

;;;----------------------------------------------------------------------------
;;; nested syntax-case expressions
;; base

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       (_ 
                         ((##lambda () (##syntax #t)))))))
                 (t0)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a) 
                        (##syntax-case (##syntax a) ()
                          (b (##syntax b)))))))
                 (t0 #t)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a) 
                        (##syntax-case (##syntax a) ()
                          (b (##syntax b)))))))
                 (t0 0)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a) 
                        (##syntax-case (##syntax a) ()
                          (b (##syntax a)))))))
                 (t0 0)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a) 
                        (##syntax
                         (##syntax-case (##syntax a) ()
                           (b (##syntax b))))))))
                 (t0 0)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (plain-datum->core-syntax 0))))

;;;;----------------------------------------------------------------------------
