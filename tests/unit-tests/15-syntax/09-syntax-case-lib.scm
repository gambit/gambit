
(include "#.scm")

;;;----------------------------------------------------------------------------
; base

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t0
                   (##syntax-rules (a)
                     (_ #t)))
                 (t0)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    ;(syntax->datum! evalued)
    (check-equal? evalued #t)))

;;; literals + wildcard 
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t1
                   (##syntax-rules (a)
                     (a #f)
                     (_ #t)))
                 (t1 0)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

;; elipsis
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t2
                   (##syntax-rules (b)
                       ((_ (a ...)) (list a ...))))
                 (t2 (0 1))))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list 0 1))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t2
                   (##syntax-rules (b)
                     ((_ (a ...) ...) (list (list a ...) ...))))
                 (t2 (0 1) (2 3))))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 0 1) (list 2 3)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t3
                   (##syntax-rules (c)
                     ((_ (a b) ...) (list (list a ...) (list b ...)))))
                 (t3 (0 1) (2 3))))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list (list 0 2) (list 1 3)))))

;;;----------------------------------------------------------------------------

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t4
                   (##lambda (s)
                     (##with-syntax ((b (##syntax 0)))
                       (##syntax b))))
                 (t4 #t)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t4
                   (##lambda (s)
                      (##syntax-case s ()
                       ((_ a)
                        (##with-syntax ((b (##syntax a)))
                         (##syntax b))))))
                 (t4 #t)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t4
                   (##lambda (s)
                      (##syntax-case s ()
                       ((_ a)
                        (##with-syntax ((b (##syntax a)))
                         (##syntax a))))))
                 (t4 #t)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                (##define-macro (t5 a b) a)
                (t5 #t #f)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                (##define-macro (t6 a) #t)
                (t6 #t)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))


(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                (##define-macro t7 (lambda () #t))
                (t7)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                (##define-macro (t7) #t)
                (t7)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued #t)))



(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                (##define-macro (t7 a) `(list ,a))
                (t7 #t)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (list #t))))

;;;----------------------------------------------------------------------------

;;; issue 636
;;;
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (define-syntax foo 
                   (syntax-rules (++) 
                     ((_ x ++ y) (list x 1 1 y))))
                 (foo 'a ++ 'b)))
       (stx (datum->core-syntax datum)))
  (check-equal?
    (##eval-for-syntax-binding stx cte)
    (list 'a 1 1 'b)))
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (define-syntax foo 
                   (syntax-rules (++) 
                     ((_ x ++ y) (list x 1 1 y))))
                 (let ((++ 10)) (foo 1 ++ 2))))
       (stx (datum->core-syntax datum)))
  (check-exn 
    error-exception?
    (lambda ()
      (##eval-for-syntax-binding stx cte))))

;;; issue #880
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax if+
                   (##syntax-rules (then else)
                     ((_ test then expr1 else expr2) (if test expr1 expr2))))
                 (let ((else #f) (x 10))
                   (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2)))))
       (stx (datum->core-syntax datum)))
  (check-exn 
    error-exception?
    (lambda ()
      (##eval-for-syntax-binding stx cte))))
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax if+
                   (##syntax-rules (then else)
                     ((_ test then expr1 else expr2) (if test expr1 expr2))))
                 (define else #f)
                 (let ((el_se #f) (x 10))
                   (if+ (even? x) then (/ x 2) else (/ (+ x 1) 2)))))
       (stx (datum->core-syntax datum)))
  (check-equal?
    (##eval-for-syntax-binding stx cte)
    5))

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
