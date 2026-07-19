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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 0 2) (list 1 3)))))

;;; ellipsis followed by a tail element

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-et
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a ... z) (##syntax (list (list a ...) z))))))
                 (t-et 1 2 3 9)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 1 2 3) 9))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-et2
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a ... y z) (##syntax (list (list a ...) y z))))))
                 (t-et2 1 2 3 8 9)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 1 2 3) 8 9))))

;;; ellipsis followed by a dotted tail

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-ed
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a ... . r) (##syntax (list (list a ...) r))))))
                 (t-ed 1 2 . 9)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 1 2) 9))))

;;; double ellipsis in template

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-de
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ (a ...) ...) (##syntax (list a ... ...))))))
                 (t-de (1 2) (3 4 5))))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list 1 2 3 4 5))))

;;; compound ellipsis sub-pattern matched against zero elements

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-empty
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ (a b) ...) (##syntax (list (list a ...) (list b ...)))))))
                 (t-empty)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list) (list)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t3
                   (##lambda (s)
                     (##syntax-case s ()
                       ((a . b) (##syntax 0)))))
                 (t3 2 3)))
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
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
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (datum->core-syntax 0))))


(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax tt
                   (##syntax-rules ()
                     ((_ a b) (+ a . b))))
                 (tt 0 ())))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

;;;----------------------------------------------------------------------------
