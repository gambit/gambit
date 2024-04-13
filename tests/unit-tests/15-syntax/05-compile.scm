(include "#.scm")

(include "./_source-match.scm")

;;;----------------------------------------------------------------------------

;;;---------------------------------------
;;; lambda

(let* ((cte ##syntax-interaction-cte)
       (datum `(##lambda () 0))
       (stx (datum->syntax datum))
       (stx (add-scope stx core-scope)))
  (let* ((expanded (##expand-lambda stx cte))
         (compiled (##compile-lambda expanded cte)))
    (check-true
      (match-source compiled (##lambda)
        ((##lambda () '0) #t)
        (_ #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda (a b) a b))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda)
;        ((##lambda (a b) a b)
;         #t)
;        (_ #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda (a b . c) a b c))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda)
;        ((##lambda (a b . c) a b c)
;         #t)
;        (_
;          #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda (a b #!optional (c 0)) a b c))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda #!optional)
;        ((##lambda (a b #!optional (c '0)) a b c)
;         #t)
;        (_
;          #f)))))
;
;#;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda (a b #!key (c 0)) a b c))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda #!key)
;        ((##lambda (a b #!key (c '0)) a b c)
;         #t)
;        (_
;          #f)))))
;
;#;(let* ((cte ##syntax-interaction-cte)
;       (datum `((##lambda (a b #!key (c 0)) a b c) 0 1 c: 1))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (pp expanded)
;    (pp compiled)
;    (check-true
;      (match-source compiled (##lambda #!key)
;        ((##lambda (a b #!key (c '0)) a b c)
;         #t)
;        (_
;          #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda (a b #!rest c) a b c))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda #!rest)
;        ((##lambda (a b #!rest c) a b c)
;         #t)
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##lambda args args))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-lambda stx cte))
;         (compiled (##compile-lambda expanded cte)))
;    (check-true
;      (match-source compiled (##lambda #!rest)
;        ((##lambda args args)
;         #t)
;        (_
;         #f)))))
;
;;;;----------------------------------------------------------------------------
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##let ((x 0)) x))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-let stx cte))
;         (compiled (##compile-let-forms expanded cte)))
;    (check-true
;      (match-source compiled (##let)
;        ((##let ((x '0)) x)
;         #t)
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##let ((x 0) (y 1)) x y))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-let stx cte))
;         (compiled (##compile-let-forms expanded cte)))
;    (check-true
;      (match-source compiled (##let)
;        ((##let ((x '0) (y '1)) x y)
;         #t)
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##let* ((x 0) (y 1)) x y))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-let* stx cte))
;         (compiled (##compile-let-forms expanded cte)))
;    (check-true
;      (match-source compiled (##let*)
;        ((##let* ((x '0) (y '1)) x1 y1)
;         (and (equal? (##source-code x) (##source-code x1))
;              (equal? (##source-code y) (##source-code y1))))
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##letrec ((x 0) (y 1)) x y))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-letrec stx cte))
;         (compiled (##compile-let-forms expanded cte)))
;    (check-true
;      (match-source compiled (##letrec)
;        ((##letrec ((x '0) (y '1)) x y)
;         #t)
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##letrec* ((x 0) (y 1)) x y))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-letrec* stx cte))
;         (compiled (##compile-let-forms expanded cte)))
;    (check-true
;      (match-source compiled (##letrec*)
;        ((##letrec* ((x '0) (y '1)) x y)
;         #t)
;        (_
;         #f)))))
;
;;;;----------------------------------------------------------------------------
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##define x x))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-define stx cte))
;         (compiled (##compile-define expanded cte)))
;    (check-true
;      (match-source compiled (##define)
;        ((##define x x)
;         #t)
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(##define (x a . b) x))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-define stx cte))
;         (compiled (##compile-define expanded cte)))
;    (check-true
;      (match-source compiled (##define)
;        ((##define (x a . b) x-body)
;         (and (equal? (syntax-source-code x) (syntax-source-code x-body))
;              (equal? (syntax-source-code x) 'x)
;              (not (equal? (syntax-source-code a) 'a))
;              #t))
;        (_
;         #f)))))
;
;(let* ((cte ##syntax-interaction-cte)
;       (datum `(case 'a  ((a) 0) (else 1)))
;       (stx (datum->syntax datum))
;       (stx (add-scope stx core-scope)))
;  (let* ((expanded (##expand-case stx cte))
;         (compiled (##compile-case expanded cte)))
;    (check-true
;      (match-source compiled (##case )
;        ((case 'a  ((a) (##quote 0)) (else (##quote 1)))
;         #t)
;        (_
;         #f)))))
;
;;;;============================================================================
