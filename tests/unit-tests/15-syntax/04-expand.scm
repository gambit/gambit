(include "#.scm")

;(include "./_source-match.scm")

;;;----------------------------------------------------------------------------
;;; top-level id

(let* ((cte (##make-top-cte))
       (datum (plain-datum->syntax (##quote caaadr)))
       (stx    (add-scope datum core-scope)))
  (let ((expanded (##expand-identifier stx cte)))
    (check-equal?
      (##desourcify expanded)
      (##quote caaadr))))

(let* ((top-cte (##make-top-cte))
       (id  (##make-syntax-source (##quote x) #f))
       (key (hcte-add-new-top-level-binding! top-cte id)))
  ; simple insert
  (check-equal?
    id
    (##expand-identifier id top-cte))

  (let* ((id2 (##make-syntax-source (##quote y) #f))
         (key2 (hcte-add-new-top-level-binding! top-cte id2)))

    (check-equal?
      id
      (##expand-identifier id top-cte))

    (check-equal?
      id2
      (##expand-identifier id2 top-cte))

    (let* ((id3 id)
           (key3 (hcte-add-new-top-level-binding! top-cte id3))
           (binding3 (resolve-id id top-cte)))

      (check-equal?
        id3
        (##expand-identifier id3 top-cte))

      (check-equal?
        id3
        (##expand-identifier id top-cte))

      (let* ((id4 (add-scope (##make-syntax-source (##quote x) #f) core-scope))
             (key4 (hcte-add-new-top-level-binding! top-cte id4))
             (binding4 (resolve-id id4 top-cte)))

        (check-equal?
          id4
          (##expand-identifier id4 top-cte))

        (check-equal?
          id3
          (##expand-identifier id3 top-cte))

        (check-equal?
          id3
          (##expand-identifier id top-cte))))))

;;;----------------------------------------------------------------------------
;;; local id

(let* ((cte  (##make-top-cte))
       (scp1 (make-scope))
       (id1  (add-scope (##make-syntax-source (##quote x) #f) scp1)))
  (let* ((key1 (hcte-add-new-local-binding! cte id1))
         (cte1 (hcte-add-variable-cte cte key1 id1)))
    (let ((expanded (##expand-identifier id1 cte)))
      (check-equal? expanded id1))))

(let* ((cte  (##make-top-cte))
       (scp0 (make-scope))
       (scp1 (make-scope))
       (scp2 (make-scope))
       (id1  (add-scope (##make-syntax-source (##quote x) #f) scp0))
       (id2  (add-scope (add-scope 
                          (##make-syntax-source (##quote y) #f) 
                          scp0)
                        scp1))
       (id3  (add-scope (add-scope 
                          (##make-syntax-source (##quote x) #f) 
                          scp0)
                        scp1)))
  (let* ((key1 (hcte-add-new-local-binding! cte id1))
         (cte1 (hcte-add-variable-cte cte key1 id1)))

    (check-equal?
      id1
      (##expand-identifier id1 cte1))

    (check-equal?
      (##source-code id1)
      (##source-code (##expand-identifier id3 cte1)))

    (check-true
      (##scopes-subset? (syntax-source-scopes id1)
                        (syntax-source-scopes (##expand-identifier id3 cte1))))

    (let* ((key2 (hcte-add-new-local-binding! cte1 id2))
           (cte2 (hcte-add-variable-cte cte1 key2 id2)))

      (check-equal?
        id1
        (##expand-identifier id1 cte2))

      (check-equal?
        id2
        (##expand-identifier id2 cte2))


      (let* ((key3 (hcte-add-new-local-binding! cte2 id3))
             (cte3 (hcte-add-variable-cte cte2 key3 id3)))

        (check-equal?
          id3
          (##expand-identifier id3 cte3))

        (check-equal?
          id2
          (##expand-identifier id2 cte3))))))

;;;----------------------------------------------------------------------------

(##allow-unbound?-set! #f)

;;;----------------------------------------------------------------------------
;;; body

(let* ((cte (##make-top-cte))
       (datums (list (plain-datum->syntax 0) (plain-datum->syntax 1)))
       (stx    (add-scope datums core-scope)))
  (let ((expanded (##expand-body stx cte (list))))
    (check-equal?
      (map ##desourcify expanded)
      `((##quote 0) (##quote 1)))))

;;;----------------------------------------------------------------------------
;;; lambda

(let* ((cte (##make-top-cte))
       (datum `(lambda () 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda () (##quote 0)))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (x) 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x) (##quote 0)))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (x) x))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x) x))))
  
(let* ((cte (##make-top-cte))
       (datum `(lambda (a b c) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (a b c) a b c))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (a b . c) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (a b . c) a b c))))

(let* ((cte (##make-top-cte))
       (datum `(##lambda args 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##lambda args (##quote 0)))))

(let* ((cte (##make-top-cte))
       (datum `(##lambda args args))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##lambda args args))))

;;;----------------------------------------------------------------------------
;;; optional

(let* ((cte (##make-top-cte))
       (datum `(lambda (#!optional (a 1)) a))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (#!optional (a (##quote 1))) a))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!optional (a 1)) x a))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!optional (a (##quote 1))) x a))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!optional (a 1) (b 2)) x a b))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!optional (a (##quote 1)) (b (##quote 2))) x a b))))

(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!optional a (b 2)) x a b))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!optional a (b (##quote 2))) x a b))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!optional (a 1) (b 2) . c) x a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!optional (a (##quote 1)) (b (##quote 2)) . c) x a b c))))

;;;----------------------------------------------------------------------------
;;; #!key

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (#!key (a 1)) a))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (#!key (a (##quote 1))) a))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!key (a 1)) x a))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!key (a (##quote 1))) x a))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!key (a 1) (b 2)) x a b))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!key (a (##quote 1)) (b (##quote 2))) x a b))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!key a (b 2)) x a b))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!key a (b (##quote 2))) x a b))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (x #!key (a 1) (b 2) . c) x a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (x #!key (a (##quote 1)) (b (##quote 2)) . c) x a b c))))

;;;----------------------------------------------------------------------------
;;; #!rest

(let* ((cte (##make-top-cte))
       (datum `(lambda (#!rest x) x))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (#!rest x) x))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (a b #!rest c) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (a b #!rest c) a b c))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (a #!key (b 1) #!rest c) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (a #!key (b (##quote 1)) #!rest c) a b c))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (#!optional (a 1) #!key (b 1) #!rest c) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (#!optional (a (##quote 1)) #!key (b (##quote 1)) #!rest c) a b c))))

#;(let* ((cte (##make-top-cte))
       (datum `(lambda (#!optional (a 1) #!rest c #!key (b 1)) a b c))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand-lambda stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(lambda (#!optional (a (##quote 1)) #!rest c #!key (b (##quote 1))) a b c))))

;;; unbound local var
(let* ((cte (##make-top-cte))
       (datum `(lambda (x) y))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-lambda stx cte))))

;;;----------------------------------------------------------------------------
;;; expand body
;;; definer such as `define` and `define-syntax` forms
;;; must be present in the environment for correct body expansion. 

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(0))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte #f)))
    (check-equal?
      (map ##desourcify expanded)
      `((##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(0 1))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte #f)))
    (check-equal?
      (map ##desourcify expanded)
      `((##quote 0) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##define x 0) 1))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte #f)))
    (check-equal?
      (map ##desourcify expanded)
      `((##define x (##quote 0)) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##define x 0) x))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte #f)))
    (check-equal?
      (map ##desourcify expanded)
      `((##define x (##quote 0)) x))))

;;; unbound local var
(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##define x 0) y))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
    (check-exn error-exception? (lambda () (##expand-body stx cte #f))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##define x 0) (##define y x) x y))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte #f)))
    (check-equal?
      (map ##desourcify expanded)
      `((##define x (##quote 0)) (##define y x) x y))))


#;(let* ((cte (##make-top-cte))
       (datum (##quote ((##define-syntax) x (lambda (_) 0)) (x)))
       (stx   (map plain-datum->syntax datum))
       (stx   (map (lambda (e) (add-scope e core-scope)) stx)))
  (let ((expanded (##expand-body stx cte)))
    (check-equal?
      (map ##desourcify expanded)
      (##quote ('0)))))

;;;----------------------------------------------------------------------------
;;; core dispatch

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##lambda (#!optional (x 0)) x))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (##expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##lambda (#!optional (x (##quote 0))) x))))

;;;----------------------------------------------------------------------------
;;; application

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##lambda (x) 0) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (##expand-application stx cte)))
    (check-equal?
      (##desourcify expanded)
      `((##lambda (x) (##quote 0)) (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `((##lambda (x y) 0) 0 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (##expand-application stx cte)))
    (check-equal?
      (##desourcify expanded)
      `((##lambda (x y) (##quote 0)) (##quote 0) (##quote 1)))))

;;;----------------------------------------------------------------------------
;;; let forms

;;;---------------------------------------
;;; let

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0)) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let ((x (##quote 0))) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0)) x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let ((x (##quote 0))) x))))

(let* ((cte (##make-top-cte))
       (datum `(##let ((x x)) 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let stx cte))))

(let* ((cte (##make-top-cte))
       (datum `(##let ((x 0)) y))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let ((x (##quote 0)) (y (##quote 1))) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0) (y 1)) x y))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let ((x (##quote 0)) (y (##quote 1))) x y))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? 
             (lambda () (##expand-let stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x x) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? 
             (lambda () (##expand-let stx cte))))

;;---------------------------------------
;; let*

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x 0)) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let* ((x (##quote 0))) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x 0)) x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let* ((x (##quote 0))) x))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x x)) 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let* stx cte))))

(let* ((cte (##make-top-cte))
       (datum `(##let* ((x 0)) y))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let* stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x 0) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let* ((x (##quote 0)) (y (##quote 1))) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x 0) (y 1)) x y))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let* ((x (##quote 0)) (y (##quote 1))) x y))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x 0) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let* ((x (##quote 0)) (y x)) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let* ((x x) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? 
             (lambda () (##expand-let* stx cte))))

;;;---------------------------------------
;;; letrec

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x 0)) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x (##quote 0))) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x 0)) x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x (##quote 0))) x))))

(let* ((cte (##make-top-cte))
       (datum `(##letrec ((x x)) 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x x)) (##quote 0)))))

(let* ((cte (##make-top-cte))
       (datum `(##letrec ((x 0)) y))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-letrec stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x 0) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x (##quote 0)) (y (##quote 1))) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x 0) (y 1)) x y))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x (##quote 0)) (y (##quote 1))) x y))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x 0) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x (##quote 0)) (y x)) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x y) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x y) (y x)) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec ((x x) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
 (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec ((x x) (y (##quote 1))) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let ((x 0))
                 (##let* ((x ((lambda () x))) (y 1)) 2)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
 (let ((expanded (expand-letrec stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let ((x (##quote 0)))
        (##let* ((x ((##lambda () x))) (y (##quote 1))) (##quote 2))))))

;;;---------------------------------------
;;; letrec* = letrec

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x 0)) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x (##quote 0))) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x 0)) x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x (##quote 0))) x))))

(let* ((cte (##make-top-cte))
       (datum `(##letrec* ((x x)) 0))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x x)) (##quote 0)))))

(let* ((cte (##make-top-cte))
       (datum `(##letrec* ((x 0)) y))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-letrec* stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x 0) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x (##quote 0)) (y (##quote 1))) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x 0) (y 1)) x y))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x (##quote 0)) (y (##quote 1))) x y))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x 0) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x (##quote 0)) (y x)) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x y) (y x)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x y) (y x)) (##quote 2)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec* ((x x) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
 (let ((expanded (expand-letrec* stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x x) (y (##quote 1))) (##quote 2)))))

;;;---------------------------------------
;;; named let

#;(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let a ((x x) (y 1)) 2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
 (let ((expanded (compile (expand stx cte) cte)))
    (check-equal?
      (##desourcify expanded)
      `(##letrec* ((x x) (y (##quote 1))) (##quote 2)))))

;;;---------------------------------------
;;; let-syntax (create macro)

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0)))) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

;;;----------------------------------------------------------------------------
;;; expand-macro

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((m (##lambda (s) 
                                  (##quote-syntax 0))))
                 (m 1)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

;;;---------------------------------------
;;; let-syntax

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0)))) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (x)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let-syntax stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0)))
                              (t (##lambda (s) (##quote-syntax 1))))


                1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0)))
                              (y (##lambda (s) (##quote-syntax 1))))
                (x) (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (##quote-syntax 0))) 
                              (y (##lambda (s) (x))))
                2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? 
             (lambda () (##expand-let-syntax stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let-syntax ((x (##lambda (s) (x)))
                              (y (##lambda (s) (##quote-syntax 1))))
                2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? 
             (lambda () (##expand-let-syntax stx cte))))

;;;---------------------------------------
;;; let*

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0)))) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (x)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-let*-syntax stx cte))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0)))
                               (t (##lambda (s) (##quote-syntax 1))))


                1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0)))
                               (y (##lambda (s) (##quote-syntax 1))))
                (x) (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0))) 
                               (y (##lambda (s) (x))))
                2))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 2) ))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##let*-syntax ((x (##lambda (s) (##quote-syntax 0))) 
                               (y (##lambda (s) (##quote-syntax (x)))))
                (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0) ))))

;;;---------------------------------------
;;; letrec

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax 0)))) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax 0)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax (x))))) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax (x))))) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))
(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax 0)))
                                 (t (##lambda (s) (##quote-syntax 1))))


                1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax 0)))
                                 (y (##lambda (s) (##quote-syntax 1))))
                (x) (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec-syntax ((x (##lambda (s) (##quote-syntax 0)))
                                 (y (##lambda (s) (x))))
                (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (check-exn error-exception? (lambda () (##expand-letrec-syntax stx cte))))

;;;---------------------------------------
;;; letrec*-syntax

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax 0)))) 1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax 0)))) (x)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax (x))))) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax (x))))) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))
(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax 0)))
                                 (t (##lambda (s) (##quote-syntax 1))))


                1))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax 0)))
                                 (y (##lambda (s) (##quote-syntax 1))))
                (x) (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0) (##quote 1)))))

(let* ((cte (##top-cte-cte ##syntax-interaction-cte))
       (datum `(##letrec*-syntax ((x (##lambda (s) (##quote-syntax (##quote-syntax 0))))
                                  (y (##lambda (s) (x))))
                (y)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-letrec*-syntax stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##quote 0)))))

;;----------------------------------------------------------------------------
;; define

(let* ((cte ##syntax-interaction-cte)
       (datum `(##define xg0 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-define stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##define xg0 (##quote 0)))
    (let* ((datum `xg0)
           (stx  (plain-datum->syntax datum))
           (stx  (add-scope stx core-scope)))
      (let ((expanded (##expand-identifier stx cte)))
        (check-equal?
          (##desourcify expanded)
          `xg0)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##define (xg1) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-define stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##define (xg1) (##quote 0)))
    (let* ((datum `xg1)
           (stx  (plain-datum->syntax datum))
           (stx  (add-scope stx core-scope)))
      (let ((expanded (##expand-identifier stx cte)))
        (check-equal?
          (##desourcify expanded)
          `xg1)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##define (f . args) 0))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-define stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##define (f . args ) (##quote 0)))
    (let* ((datum `f)
           (stx  (plain-datum->syntax datum))
           (stx  (add-scope stx core-scope)))
      (let ((expanded (##expand-identifier stx cte)))
        (check-equal?
          (##desourcify expanded)
          `f)))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##let () (xg0 xg1)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand-let stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##let () (xg0 xg1)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##define (f x) (##define a 0) a x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##define (f x) (##define a (##quote 0)) a x))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin (##define x 0) x))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##define x (##quote 0)) x))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(begin (define (f x) 0) (f 1)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##define (f x) (##quote 0)) (f (##quote 1))))))

;; expand body 

(let* ((cte ##syntax-interaction-cte)
       (datum `(begin (define (f x) 
                        (define y 0)
                        y)
                      (f 1)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##define (f x) 
                  (##define y (##quote 0))
                  y)
                (f (##quote 1))))))

; TODO resugarize
(let* ((cte ##syntax-interaction-cte)
       (datum `(begin (define (f x) 
                        (define (ff x) 0) 
                        (ff 0))
                      (f 1)))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##begin (##define (f x) 
                  (##define (ff x) (##quote 0)) 
                  (ff (##quote 0)))
                (f (##quote 1))))))

;;;---------------------------------------
;;; define-syntax

(let* ((cte ##syntax-interaction-cte)
       (datum `(##define-syntax mg0 (##lambda (s) (##quote-syntax 0))))
       (stx   (plain-datum->syntax datum))
       (stx   (add-scope stx core-scope)))
  (let ((expanded (##expand-define-syntax stx cte)))
    ;(pp (table->list (##cte-top-global-binding-table cte)))
    (let* ((datum `(mg0))
           (stx  (plain-datum->syntax datum))
           (stx  (add-scope stx core-scope)))
      (let ((expanded (##expand stx cte)))
        (check-equal?
          (##desourcify expanded)
          `(##quote 0))))))

(let* ((cte ##syntax-interaction-cte))
  (let*((datum `(##define-syntax mg1 (##lambda (s) (##quote-syntax 0))))
        (stx   (plain-datum->syntax datum))
        (stx   (add-scope stx core-scope)))
    (let ((expanded (##expand-define-syntax stx cte)))
      (let* ((datum `(mg1))
             (stx  (plain-datum->syntax datum))
             (stx  (add-scope stx core-scope)))
        (let ((expanded (##expand stx cte)))
          (check-equal?
            (##desourcify expanded)
            `(##quote 0)
            ))))))

(let* ((cte ##syntax-interaction-cte))
  (let*((datum `(##define-syntax mg1 (##lambda (s) (##quote-syntax 0))))
        (stx   (plain-datum->syntax datum))
        (stx   (add-scope stx core-scope)))
    (let ((expanded (##expand-define-syntax stx cte)))
      (let* ((datum `(##lambda () (mg1)))
             (stx  (plain-datum->syntax datum))
             (stx  (add-scope stx core-scope)))
        (let ((expanded (##expand stx cte)))
          (check-equal?
            (##desourcify expanded)
            `(##lambda () (##quote 0))
            ))))))


(##allow-unbound?-set! #t)
(let* ((cte ##syntax-interaction-cte))
  (let*((datum `(##begin
                 (##define-syntax mg4 (##lambda (s) (##quote-syntax #f)))
                 (##define-syntax mg4 (##lambda (s) (##quote-syntax #t)))))
        (stx   (plain-datum->syntax datum))
        (stx   (add-scope stx core-scope)))
    (let ((expanded (##expand stx cte)))
      (let* ((datum `(##lambda () (mg4)))
             (stx  (plain-datum->syntax datum))
             (stx  (add-scope stx core-scope)))
        (let ((expanded (##expand stx cte)))
          (check-equal?
            (##desourcify expanded)
            `(##lambda () #t)
            ))))))
(##allow-unbound?-set! #f)

;;;----------------------------------------------------------------------------

(let* ((cte ##syntax-interaction-cte)
       (datum `(##case (##quote a)  ((a) 0) (else 1)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let* ((expanded (##expand-case stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##case (##quote a)  ((a) (##quote 0)) (else (##quote 1))))))

;;;----------------------------------------------------------------------------

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(##cond 
                (#t #t)
                (else #f)))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let* ((expanded (##expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##cond ((##quote #t) (##quote #t)) (else (##quote #f))))))

#;(let* ((cte ##syntax-interaction-cte)
       (datum `(cond 
                (#t ((lambda () #t)))
                (else ((lambda () #f)))))
       (stx (plain-datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let* ((expanded (##expand stx cte)))
    (check-equal?
      (##desourcify expanded)
      `(##cond ((##quote #t) (##quote #t)) (else (##quote #f))))))

;;;----------------------------------------------------------------------------
