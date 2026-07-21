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

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!key (a 1)) a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!key (a '1)) a)))
    (check-equal?
      (evalued a: 0)
      ((##lambda (#!key (a '1)) a) a: 0))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1)) x a))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 5)
      ((##lambda (x #!key (a '1)) x a) 5))
    (check-equal?
      (evalued 5 a: 7)
      ((##lambda (x #!key (a '1)) x a) 5 a: 7))))


(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1) (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 5)
      ((##lambda (x #!key (a '1) (b '2)) x a b) 5))
    (check-equal?
      (evalued 5 a: 7 b: 9)
      ((##lambda (x #!key (a '1) (b '2)) x a b) 5 a: 7 b: 9))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key a (b 2)) x a b))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 5)
      ((##lambda (x #!key a (b '2)) x a b) 5))
    (check-equal?
      (evalued 5 a: 7 b: 9)
      ((##lambda (x #!key a (b '2)) x a b) 5 a: 7 b: 9))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (x #!key (a 1) (b 2) . c) x a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 5)
      ((##lambda (x #!key (a '1) (b '2) . c) x a b c) 5))
    (check-equal?
      (evalued 5 a: 7 b: 9)
      ((##lambda (x #!key (a '1) (b '2) . c) x a b c) 5 a: 7 b: 9))))

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

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (a #!key (b 1) #!rest c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued 5)
      ((##lambda (a #!key (b '1) #!rest c) a b c) 5))
    (check-equal?
      (evalued 5 b: 7)
      ((##lambda (a #!key (b '1) #!rest c) a b c) 5 b: 7))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!optional (a 1) #!key (b 1) #!rest c) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!optional (a '1) #!key (b '1) #!rest c) a b c)))
    (check-equal?
      (evalued 5)
      ((##lambda (#!optional (a '1) #!key (b '1) #!rest c) a b c) 5))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda (#!optional (a 1) #!rest c #!key (b 1)) a b c))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      (evalued)
      ((##lambda (#!optional (a '1) #!rest c #!key (b '1)) a b c)))
    (check-equal?
      (evalued 5)
      ((##lambda (#!optional (a '1) #!rest c #!key (b '1)) a b c) 5))))

;;;----------------------------------------------------------------------------
;;; quasiquote unquote-splicing

(let* ((cte ##syntax-interaction-cte)
       (datum `((##lambda (x) `#(,@x 3)) (##list 1 2)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      (vector 1 2 3))))

(let* ((cte ##syntax-interaction-cte)
       (datum `((##lambda (x) `#(0 ,@x ,(##car x))) (##list 1 2)))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let ((evalued (##eval-top-syntax stx cte)))
    (check-equal?
      evalued
      (vector 0 1 2 1))))

;;;----------------------------------------------------------------------------
;;; let / let* / letrec / letrec*

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let ((a 1) (b 2)) (##+ a b)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (let ((a 1) (b 2)) (+ a b))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let ((a 1)) (##let ((a 2) (b a)) (##+ a b))))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (let ((a 1)) (let ((a 2) (b a)) (+ a b)))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let* ((a 1) (b (##+ a 1))) b))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (let* ((a 1) (b (+ a 1))) b)))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##letrec ((a 1) (b 2)) (##+ a b)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (letrec ((a 1) (b 2)) (+ a b))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##letrec ((f (##lambda (n) (##if (##eq? n 0) 0 (f (##- n 1)))))) (f 5)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (letrec ((f (lambda (n) (if (eq? n 0) 0 (f (- n 1)))))) (f 5))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##letrec* ((a 1) (b (##+ a 1))) b))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (letrec* ((a 1) (b (+ a 1))) b)))

;;;----------------------------------------------------------------------------
;;; define

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##define eval-def-v 5)
                 (##define (eval-def-g x) (##+ x eval-def-v))
                 (eval-def-g 10)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-top-syntax stx cte)
                15))

;;;----------------------------------------------------------------------------
;;; case

(let* ((cte ##syntax-interaction-cte)
       (datum `(##case 2 ((1) 10) ((2) 20 21) (else 99)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (case 2 ((1) 10) ((2) 20 21) (else 99))))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##case 5 ((1) 10) (else 98 99)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                (case 5 ((1) 10) (else 98 99))))

;;;----------------------------------------------------------------------------
;;; let-syntax / let*-syntax / letrec-syntax

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let-syntax ((m (##lambda (s) (##syntax 7)))) (m)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                7))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##let*-syntax ((m (##lambda (s) (##syntax 8)))) (m)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                8))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##letrec-syntax ((m (##lambda (s) (##syntax 9)))) (m)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                9))

;;;----------------------------------------------------------------------------
;;; macro-scope / namespace-scope

(let* ((cte ##syntax-interaction-cte)
       (datum `(##macro-scope
                 (##define-syntax macro-scope-m (##lambda (s) (##syntax 11)))
                 (macro-scope-m)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-top-syntax stx cte)
                11))

(let* ((cte ##syntax-interaction-cte)
       (datum `(##begin
                 (##namespace-scope
                   (##namespace ("namespace-scope-ns#"))
                   (##define namespace-scope-x 7))
                 (##define namespace-scope-x 42)
                 (##+ namespace-scope-x namespace-scope-ns#namespace-scope-x)))
       (stx (add-scope (datum->syntax datum) core-scope)))
  (check-equal? (##eval-for-top-syntax stx cte)
                49))

;;;----------------------------------------------------------------------------
