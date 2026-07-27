(include "#.scm")

;;;----------------------------------------------------------------------------
;;; bound-identifier=?

(let* ((scp1 (##make-scope))
       (scp2 (##make-scope))
       (ix   (##make-syntax-source 'x #f))
       (ix2  (##make-syntax-source 'x #f))
       (iy   (##make-syntax-source 'y #f))
       (inum (##make-syntax-source 0 #f))
       (ixs  (##add-scope ix scp1)))

  ; same symbol, both scope-free
  (check-true (bound-identifier=? ix ix2))

  ; same identifier
  (check-true (bound-identifier=? ix ix))

  ; same symbol, different scope sets
  (check-false (bound-identifier=? ix ixs))
  (check-false (bound-identifier=? ixs ix))

  ; different symbol
  (check-false (bound-identifier=? ix iy))

  ; same symbol, same scope
  (check-true (bound-identifier=? (##add-scope ix2 scp1) ixs))

  ; scopes are sets: insertion order does not matter
  (check-true (bound-identifier=? (##add-scope (##add-scope ix scp1) scp2)
                                  (##add-scope (##add-scope ix2 scp2) scp1)))

  ; a strict subset of scopes is not an equal scope set
  (check-false (bound-identifier=? ixs (##add-scope ixs scp2)))

  ; flipping the same scope twice restores the scope set
  (check-true (bound-identifier=? ix (##flip-scope (##flip-scope ix scp1) scp1)))

  ; non-identifier argument
  (check-false (bound-identifier=? inum ix))
  (check-false (bound-identifier=? ix inum))
  (check-false (bound-identifier=? inum inum))

  ; arguments that are not syntax objects at all
  (check-false (bound-identifier=? 'x 'x))
  (check-false (bound-identifier=? ix 'x))
  (check-false (bound-identifier=? 'x ix))
  (check-false (bound-identifier=? "x" 5))

  ; datum->syntax without a reference identifier yields a scope-free identifier
  (check-true (bound-identifier=? (datum->syntax 'x) ix))
  (check-false (bound-identifier=? (datum->syntax 'x) ixs)))

;;;----------------------------------------------------------------------------
;;; free-identifier=?

(let* ((scp1 (##make-scope))
       (scp2 (##make-scope))
       (ix   (##make-syntax-source 'x #f))
       (iy   (##make-syntax-source 'y #f))
       (inum (##make-syntax-source 0 #f))
       (ixs  (##add-scope ix scp1)))

  ; same symbol, no binding either side: differing scopes are irrelevant
  (check-true (free-identifier=? ix ixs))
  (check-true (free-identifier=? ixs ix))
  (check-true (free-identifier=? (##add-scope ix scp1) (##add-scope ix scp2)))

  ; different symbol
  (check-false (free-identifier=? ix iy))

  ; non-identifier argument
  (check-false (free-identifier=? inum ix))
  (check-false (free-identifier=? ix inum))
  (check-false (free-identifier=? 'x 'x))
  (check-false (free-identifier=? ix 'x)))

(let* ((scp1 (##make-scope))
       (car1 (##add-scope (##make-syntax-source 'car #f) ##core-scope))
       (car2 (##add-scope car1 scp1))
       (cdr1 (##add-scope (##make-syntax-source 'cdr #f) ##core-scope)))

  ; adding a scope preserves the binding an identifier refers to
  (check-true (free-identifier=? car1 car2))
  (check-true (free-identifier=? car2 car1))
  (check-false (bound-identifier=? car1 car2))
  (check-false (free-identifier=? car1 cdr1)))

;;;----------------------------------------------------------------------------
;;; free-identifier=?

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define id-glob 7)
                 (##define-syntax id-same-glob?
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u)
                        (if (free-identifier=? (##syntax u) (##syntax id-glob))
                            (##syntax 'same)
                            (##syntax 'diff))))))
                 (list (id-same-glob? id-glob)
                       (id-same-glob? other)
                       (let ((id-glob 0)) (id-same-glob? id-glob)))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'same 'diff 'diff)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax id-kw
                   (##lambda (s) (##syntax 'kw)))
                 (##define-syntax id-kw?
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u)
                        (if (free-identifier=? (##syntax u) (##syntax id-kw))
                            (##syntax 'yes)
                            (##syntax 'no))))))
                 (list (id-kw? id-kw)
                       (id-kw? other)
                       (let ((id-kw 1)) (id-kw? id-kw)))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'yes 'no 'no)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax id-kw2
                   (##lambda (s) (##syntax 'kw)))
                 (##define-syntax id-symmetric?
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u)
                        (if (##eq? (free-identifier=? (##syntax u) (##syntax id-kw2))
                                   (free-identifier=? (##syntax id-kw2) (##syntax u)))
                            (##syntax 'symmetric)
                            (##syntax 'asymmetric))))))
                 (list (id-symmetric? id-kw2)
                       (id-symmetric? other)
                       (let ((id-kw2 1)) (id-symmetric? id-kw2)))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'symmetric 'symmetric 'symmetric)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax id-lit
                   (##syntax-rules (else)
                     ((_ else) 'literal)
                     ((_ x) 'other)))
                 (list (id-lit else)
                       (id-lit foo)
                       (let ((else 1)) (id-lit else)))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'literal 'other 'other)))

;;;----------------------------------------------------------------------------
;;; bound-identifier=?

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax id-intro?
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u)
                        (if (bound-identifier=? (##syntax u) (##syntax x))
                            (##syntax 'same)
                            (##syntax 'diff))))))
                 (##define-syntax id-both
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u1 u2)
                        (if (bound-identifier=? (##syntax u1) (##syntax u2))
                            (##syntax 'same)
                            (##syntax 'diff))))))
                 (##define-syntax id-pass-one
                   (##syntax-rules () ((_) (id-intro? x))))
                 (##define-syntax id-pass-two
                   (##syntax-rules () ((_) (id-both x x))))
                 (list (id-both x x)
                       (id-intro? x)
                       (id-pass-one)
                       (id-pass-two))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'same 'diff 'diff 'same)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define-syntax id-rebuild
                   (##lambda (s)
                     (##syntax-case s ()
                       ((_ u)
                        (if (bound-identifier=? (##syntax u)
                              (datum->syntax (##syntax->datum (##syntax u))
                                             (##syntax u)))
                            (##syntax 'same)
                            (##syntax 'diff))))))
                 (##define-syntax id-rebuild-outer
                   (##syntax-rules () ((_ v) (id-rebuild v))))
                 (list (id-rebuild q) (id-rebuild-outer q))))
       (stx (##add-scope (datum->syntax datum) ##core-scope)))
  (check-equal? (##eval-for-syntax-binding stx cte)
                (list 'same 'same)))

;;;----------------------------------------------------------------------------
