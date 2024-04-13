(include "#.scm")

;;;----------------------------------------------------------------------------

(let* ((cte ##syntax-interaction-cte)
       (datum (##let ((a (lambda _ (##quote-sytnax 0)))) 0))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal? evalued
                  0)))

;;;---------------------------------------
;;; ##lambda


(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda () 0))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal? (evalued)
                  ((lambda () 0)))))
      
(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x) 0))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal? (evalued 1)
                  ((lambda (x) 0) 1))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x) x))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0)
      ((##lambda (x) x) 0))))
  
(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (a b c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0 1 2)
      ((##lambda (a b c) a b c) 0 1 2))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (a b . c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0 1)
      ((##lambda (a b . c) a b c) 0 1))
    (check-equal?
      (evalued 0 1 2 3)
      ((##lambda (a b . c) a b c) 0 1 2 3))))

;;----------------------------------------------------------------------------
;; optional

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!optional (a 1)) a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!optional (a '1)) a)))
    (check-equal?
      (evalued 0)
      ((##lambda (#!optional (a '1)) a) 0))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!optional (a 1)) x a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0)
      ((##lambda (x #!optional (a '1)) x a) 0))
    (check-equal?
      (evalued 0 0)
      ((##lambda (x #!optional (a '1)) x a) 0 0))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!optional (a 1) (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0)
      ((##lambda (x #!optional (a '1) (b '2)) x a b) 0))
    (check-equal?
      (evalued 0 0)
      ((##lambda (x #!optional (a '1) (b '2)) x a b) 0 0))
    (check-equal?
      (evalued 0 0 0)
      ((##lambda (x #!optional (a '1) (b '2)) x a b) 0 0 0))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!optional a (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0)
      ((##lambda (x #!optional a (b '2)) x a b) 0))
    (check-equal?
      (evalued 0 0)
      ((##lambda (x #!optional a (b '2)) x a b) 0 0))
    (check-equal?
      (evalued 0 0 0)
      ((##lambda (x #!optional a (b '2)) x a b) 0 0 0))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!optional (a 1) (b 2) . c) x a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0)
      ((##lambda (x #!optional (a '1) (b '2) . c) x a b c) 0))
    (check-equal?
      (evalued 0 0)
      ((##lambda (x #!optional (a '1) (b '2) . c) x a b c) 0 0))
    (check-equal?
      (evalued 0 0 0)
      ((##lambda (x #!optional (a '1) (b '2) . c) x a b c) 0 0 0))
    (check-equal?
      (evalued 0 0 0 0 0)
      ((##lambda (x #!optional (a '1) (b '2) . c) x a b c) 0 0 0 0 0))))

;;;----------------------------------------------------------------------------
;;; #!key

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!key (a 1)) a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!key (a '1)) a)))
    (check-equal?
      (evalued a: 0)
      ((##lambda (#!key (a '1)) a) a 0))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1)) x a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      (##lambda (x #!key (a '1)) x a))))


#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1) (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (x #!key (a '1) (b '2)) x a b))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key a (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (x #!key a (b '2)) x a b))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1) (b 2) . c) x a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (x #!key (a '1) (b '2) . c) x a b c))))

;;;----------------------------------------------------------------------------
;;; #!rest

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!rest x) x))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!rest x) x)))
    (check-equal?
      (evalued 0 1)
      ((##lambda (#!rest x) x) 0 1))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (a b #!rest c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 0 1)
      ((##lambda (a b #!rest c) a b c) 0 1))
    (check-equal?
      (evalued 0 1 2 3)
      ((##lambda (a b #!rest c) a b c) 0 1 2 3))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (a #!key (b 1) #!rest c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (a #!key (b '1) #!rest c) a b c))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!optional (a 1) #!key (b 1) #!rest c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (#!optional (a '1) #!key (b '1) #!rest c) a b c))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!optional (a 1) #!rest c #!key (b 1)) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      `(##lambda (#!optional (a '1) #!rest c #!key (b '1)) a b c))))

;;;----------------------------------------------------------------------------
