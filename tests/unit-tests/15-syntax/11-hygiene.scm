(include "#.scm")

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-swap!
                   (##syntax-rules ()
                     ((_ a b) (let ((tmp a)) (set! a b) (set! b tmp)))))
                 (let ((tmp 1) (x 2))
                   (hyg-swap! tmp x)
                   (list tmp x))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 2 1)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-with-ten
                   (##syntax-rules ()
                     ((_ body) (let ((x 10)) body))))
                 (let ((x 1))
                   (hyg-with-ten x))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                1))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-mk
                   (##syntax-rules () ((_ a) (list a a))))
                 (let ((list (lambda args (quote nope))))
                   (hyg-mk 5))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 5 5)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-inc
                   (##syntax-rules () ((_ n) (+ n 1))))
                 (##define-syntax hyg-inc2
                   (##syntax-rules () ((_ n) (hyg-inc (hyg-inc n)))))
                 (hyg-inc2 5)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                7))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-and
                   (##syntax-rules ()
                     ((_) #t)
                     ((_ e) e)
                     ((_ e1 e2 ...) (if e1 (hyg-and e2 ...) #f))))
                 (hyg-and 1 2 3)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                3))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-and
                   (##syntax-rules ()
                     ((_) #t)
                     ((_ e) e)
                     ((_ e1 e2 ...) (if e1 (hyg-and e2 ...) #f))))
                 (hyg-and 1 #f 3)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                #f))

;;;----------------------------------------------------------------------------

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let-syntax ((dbl (##syntax-rules ()
                                     ((_ x) (let ((t x)) (+ t t))))))
                 (let ((t 100))
                   (dbl t))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                200))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##letrec-syntax ((cnt (##syntax-rules ()
                                        ((_ ()) 0)
                                        ((_ (x . rest)) (+ 1 (cnt rest))))))
                 (cnt (a b c))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                3))

;;;----------------------------------------------------------------------------
;;; deliberate unhygiene

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-aif
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ test then els)
                        (##with-syntax ((it (datum->syntax (##quote it) (##syntax test))))
                          (##syntax (let ((it test)) (if it then els))))))))
                 (hyg-aif 42 it 0)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                42))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax hyg-hif
                   (##syntax-rules ()
                     ((_ test then els) (let ((it test)) (if it then els)))))
                 (hyg-hif 42 it 0)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-exn unbound-global-exception?
    (lambda () (##eval-for-syntax-binding stx cte))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-unhygienic-syntax hyg-uh
                   (##lambda (s) (##quote-syntax (let ((it 5)) it))))
                 (hyg-uh)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                5))

;;;----------------------------------------------------------------------------
