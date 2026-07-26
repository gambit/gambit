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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
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
       (stx (##add-scope stx ##core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued (##datum->core-syntax 0))))


(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax tt
                   (##syntax-rules ()
                     ((_ a b) (+ a . b))))
                 (tt 0 ())))
       (stx (datum->syntax datum))
       (stx (##add-scope stx ##core-scope)))
  (let ((evalued (##eval-for-syntax-binding stx cte)))
    (check-equal? evalued 0)))

;;;----------------------------------------------------------------------------
;;; negative cases: no clause matches

;; too few arguments for the only pattern
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-nomatch
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ a b) (##syntax 0)))))
                 (t-nomatch 1)))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-exn error-exception?
    (lambda () (##eval-for-syntax-binding stx cte))))

;; a required literal is not supplied
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-litbad
                   (##lambda (s)
                     (##syntax-case s (lit)
                       ((_ lit) (##syntax 0)))))
                 (t-litbad nope)))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-exn error-exception?
    (lambda () (##eval-for-syntax-binding stx cte))))

;; positive control: the literal supplied correctly matches
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-litok
                   (##lambda (s)
                     (##syntax-case s (lit)
                       ((_ lit) (##syntax 7)))))
                 (t-litok lit)))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte) 7))

;;;----------------------------------------------------------------------------
;;; _ wildcard: matches without binding, may repeat

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-wild
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ _ b) (##syntax b)))))
                 (t-wild 1 2)))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte) 2))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-wild2
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ _ _) (##syntax 9)))))
                 (t-wild2 1 2)))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte) 9))

;;;----------------------------------------------------------------------------
;;; vector patterns: a vector pattern destructures a vector argument

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-vec
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ #(a b)) (##syntax (list a b))))))
                 (t-vec #(1 2))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 1 2)))

;; ellipsis inside a vector pattern
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-vec-ell
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ #(a ...)) (##syntax (list a ...))))))
                 (t-vec-ell #(1 2 3))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 1 2 3)))

;; nested vector pattern
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-vec-nest
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ #(a #(b c))) (##syntax (list a b c))))))
                 (t-vec-nest #(1 #(2 3)))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 1 2 3)))

;; a vector pattern of fixed length does not match a longer vector
(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax t-vec-len
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ #(a b)) (##syntax 0)))))
                 (t-vec-len #(1 2 3))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-exn error-exception?
    (lambda () (##eval-for-syntax-binding stx cte))))

;;;----------------------------------------------------------------------------
