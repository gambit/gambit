(include "#.scm")
(include "./_source-match.scm")

;;;----------------------------------------------------------------------------
;;;

;;;----------------------------------------------------------------------------

(define stx (make-syntax-source 0 #f))

(define scp1 (make-scope))
(define scp2 (make-scope))

;;;---------------------------------------
;;; add-scope / flip-scope

;;;base
(check-true
  (let ((lst 
          (scopes->list 
            (syntax-source-scopes
              (add-scope
                stx
                scp1)))))
    (and (= (length lst) 1)
         (eq? (car lst) scp1))))

;;; form
(check-tail-exn type-exception? (lambda () (add-scope stx 0)))

;;; 
(define stx1 (add-scope stx scp1))

(check-true
  (let ((lst 
          (scopes->list 
            (syntax-source-scopes
              (add-scopes
                stx
                (list scp1 scp2))))))
    (and (= (length lst) 2)
         (member scp1 lst)
         (member scp2 lst)
         #t)))

(check-true
  (let ((lst
          (scopes->list
            (syntax-source-scopes
              (flip-scope stx1 scp1)))))
    (= (length lst) 0)))

(check-true
  (let ((lst
          (scopes->list
            (syntax-source-scopes
              (flip-scope stx1 scp2)))))
    (and (= (length lst) 2)
         (member scp1 lst)
         (member scp2 lst)
         #t)))

(define (scopes-contain-scp1-exactly s)
  (check-true
    (and (syntax-source? s)
         (let ((lst (scopes->list (syntax-source-scopes s))))
           (and (= (length lst) 1)
                (equal? (car lst) scp1))))))

(define (scopes-contain-scp2-exactly s)
  (check-true
    (and (syntax-source? s)
         (let ((lst (scopes->list (syntax-source-scopes s))))
           (and (= (length lst) 1)
                (equal? (car lst) scp2))))))


(define stx2 (plain-datum->syntax `((0))))
(define stx3 (plain-datum->syntax `((a . b))))
(define stx4 (plain-datum->syntax `((a b) . (a b))))

(define stx2a (add-scope stx2 scp1))
(define stx3a (add-scope stx3 scp1))
(define stx4a (add-scope stx4 scp1))

(define stx2f (flip-scope stx2 scp1))
(define stx3f (flip-scope stx3 scp1))
(define stx4f (flip-scope stx4 scp1))


(match-source stx2a ()
  (((a))
   (scopes-contain-scp1-exactly a)))
;
;(match-source stx3a ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(match-source stx4a ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
;(match-source stx2f ()
;  (((a))
;   (scopes-contain-scp1-exactly a)))
;
;(match-source stx3f ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(match-source stx4f ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
;;;;----------------------------------------------------------------------------
;;;; mutatable operations
;
;(define stx5 (plain-datum->syntax `(a)))
;(define stx6 (plain-datum->syntax `((0))))
;(define stx7 (plain-datum->syntax `((a . b))))
;(define stx8 (plain-datum->syntax `((a b) . (a b))))
;
;(add-scope! stx5 scp1)
;(match-source stx5 ()
;  ((a) (scopes-contain-scp1-exactly a)))
;
;(add-scope! stx6 scp1)
;(match-source stx6 ()
;  (((a))
;   (scopes-contain-scp1-exactly a)))
;
;(add-scope! stx7 scp1)
;(match-source stx7 ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(add-scope! stx8 scp1)
;(match-source stx8 ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
;(define stx9  (plain-datum->syntax `(a)))
;(define stx10 (plain-datum->syntax `((0))))
;(define stx11 (plain-datum->syntax `((a . b))))
;(define stx12 (plain-datum->syntax `((a b) . (a b))))
;
;(add-scope! stx9 scp1)
;(match-source stx9 ()
;  ((a) (scopes-contain-scp1-exactly a)))
;
;(add-scope! stx10 scp1)
;(match-source stx10 ()
;  (((a))
;   (scopes-contain-scp1-exactly a)))
;
;(add-scope! stx11 scp1)
;(match-source stx11 ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(add-scope! stx12 scp1)
;(match-source stx12 ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
;(define s13   (add-scopes (make-syntax-source #f #f) (list scp1 scp2)))
;(define stx13 (plain-datum->syntax `(a) s13))
;(define stx14 (plain-datum->syntax `((0)) s13))
;(define stx15 (plain-datum->syntax `((a . b)) s13))
;(define stx16 (plain-datum->syntax `((a b) . (a b)) s13))
;
;(flip-scope! stx13 scp2)
;(match-source stx13 ()
;  ((a) (scopes-contain-scp1-exactly a)))
;
;(flip-scope! stx14 scp2)
;(match-source stx14 ()
;  (((a))
;   (scopes-contain-scp1-exactly a)))
;
;(flip-scope! stx15 scp2)
;(match-source stx15 ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(flip-scope! stx16 scp2)
;(match-source stx16 ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
;(define stx17  (plain-datum->syntax `(a)))
;(define stx18 (plain-datum->syntax `((0))))
;(define stx19 (plain-datum->syntax `((a . b))))
;(define stx20 (plain-datum->syntax `((a b) . (a b))))
;
;(flip-scope! stx17 scp2)
;(match-source stx17 ()
;  ((a) (scopes-contain-scp1-exactly a)))
;
;(flip-scope! stx18 scp2)
;(match-source stx18 ()
;  (((a))
;   (scopes-contain-scp1-exactly a)))
;
;(flip-scope! stx19 scp2)
;(match-source stx19 ()
;  (((a . b))
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)))
;
;(flip-scope! stx20 scp2)
;(match-source stx20 ()
;  (((a b) . (c d)) 
;   (scopes-contain-scp1-exactly a)
;   (scopes-contain-scp1-exactly b)
;   (scopes-contain-scp1-exactly c)
;   (scopes-contain-scp1-exactly d)))
;
