(include "#.scm")

(include "./_source-match.scm")

(define-macro (macro-srcs src-max)
  (let loop ((i 0))
    (cond
     ((<= i src-max)
      `(cons 
         ,(string->symbol 
            (string-append 
              "src" 
               (number->string i)))
         ,(loop (+ i 1))))
      (else
        `'()))))

(define src0 (##make-source 0 #f))
(define src1 (##make-source 'a #f))
(define src2 (##make-source #t #f))
(define src3 (##make-source '() #f))

(define src4 (##plain-datum->syntax `(,0)))
(define src5 (##plain-datum->syntax `(,0 ,0)))
(define src6 (##plain-datum->syntax `(,0 ,0 ,0)))
(define src7 (##plain-datum->syntax `((,0))))
(define src8 (##plain-datum->syntax `((,0 ,0) (,0 ,0))))

(define src9 (##plain-datum->syntax `(0 . 0)))
(define src10 (##plain-datum->syntax `((0 . 0) . (0 . 0))))


(define srcs (macro-srcs 10))

;;;----------------------------------------------------------------------------
;;; basic

; any
(for-each
  (lambda (src)
    (check-true
      (match-source src ()
        (_ #t))))
  srcs)

; next clause
(for-each
  (lambda (src)
    (check-true
      (match-source src ()
       (47162 #f)
       (_ #t))))
  srcs)

; match literals
(check-true
  (match-source src1 (a)
    (a #t)
    (_ #f)))

(check-true
  (match-source src0 (a)
    (a #f)
    (_ #t)))

;; match number
(check-true
  (match-source src0 ()
    (0 #t)
    (_ #f)))

(check-true
  (match-source src0 ()
    (1 #f)
    (_ #t)))

; match variable
(for-each
  (lambda (src)
    (check-equal?
      src
      (match-source src ()
        (a a)
        (_ #f))))
  srcs)

; match list
(check-true
  (match-source src3 () 
   (() #t) 
   (_ #f)))

(define (check-for-src src-true test)
  (for-each
    (lambda (src)
      (cond
        ((equal? src src-true)
         (check-true (test src)))
        (else
          (check-true 
            (not (test src))))))
    srcs))

(check-for-src src4
  (lambda (src)
    (match-source src () 
     ((0) #t) 
     (_ #f))))

(check-for-src src5
  (lambda (src)
    (match-source src () 
      ((0 0) #t) 
      (_ #f))))

(check-for-src src7
  (lambda (src)              
    (match-source src () 
     (((0)) #t) 
     (_ #f))))

(check-for-src src8
  (lambda (src)              
    (match-source src () 
     (((0 0) (0 0)) #t) 
     (_ #f))))

; match pair
(for-each
  (lambda (src)
    (check-true
      (match-source src ()
        ((0 . _) #t)
        (_       #f))))
  (list 
    src4 
    src5
    src6
    src9))

(for-each
  (lambda (src)
    (check-true
      (not
        (match-source src ()
          ((0 . _) #t)
          (_       #f)))))
  (list 
    src0
    src1
    src2
    src3
    src7
    src8
    src10))

(check-for-src src9
  (lambda (src)
    (match-source src ()
     ((0 . 0) #t)
     (_ #f))))

(check-for-src src10
  (lambda (src)
    (match-source src ()
     (((0 . 0) . (0 . 0)) #t)
     (_ #f))))

(check-for-src src6
  (lambda (src)
    (match-source src ()
     ((0 0 0 . _) #t)
     (_ #f))))

(check-for-src src7
  (lambda (src)
    (match-source src ()
     (((0 . _)) #t)
     (_ #f))))

(check-for-src src8
  (lambda (src)
    (match-source src ()
     (((0 . _) (0 . _) . _) #t)
     (_ #f))))

;; list as syntax
(check-true
  (match-source (##source-code src3) () 
   (() #t) 
   (_ #f)))

(define (check-for-src src-true test)
  (for-each
    (lambda (src)
      (cond
        ((equal? src src-true)
         (check-true (test src)))
        (else
          (check-true 
            (not (test src))))))
    srcs))

(check-for-src src4
  (lambda (src)
    (match-source (##source-code src) () 
     ((0) #t) 
     (_ #f))))

(check-for-src src5
  (lambda (src)
    (match-source (##source-code src) () 
      ((0 0) #t) 
      (_ #f))))

(check-for-src src7
  (lambda (src)              
    (match-source (##source-code src) () 
     (((0)) #t) 
     (_ #f))))

(check-for-src src8
  (lambda (src)              
    (match-source (##source-code src) () 
     (((0 0) (0 0)) #t) 
     (_ #f))))

; match pair
(for-each
  (lambda (src)
    (check-true
      (match-source (##source-code src) ()
        ((0 . _) #t)
        (_       #f))))
  (list 
    src4 
    src5
    src6
    src9))

(for-each
  (lambda (src)
    (check-true
      (not
        (match-source (##source-code src) ()
          ((0 . _) #t)
          (_       #f)))))
  (list 
    src0
    src1
    src2
    src3
    src7
    src8
    src10))

(check-for-src src9
  (lambda (src)
    (match-source (##source-code src) ()
     ((0 . 0) #t)
     (_ #f))))

(check-for-src src10
  (lambda (src)
    (match-source (##source-code src) ()
     (((0 . 0) . (0 . 0)) #t)
     (_ #f))))

(check-for-src src6
  (lambda (src)
    (match-source (##source-code src) ()
     ((0 0 0 . _) #t)
     (_ #f))))

(check-for-src src7
  (lambda (src)
    (match-source (##source-code src) ()
     (((0 . _)) #t)
     (_ #f))))

(check-for-src src8
  (lambda (src)
    (match-source (##source-code src) ()
     (((0 . _) (0 . _) . _) #t)
     (_ #f))))

; fender
(for-each
  (lambda (src)
    (check-true
      (match-source src ()
        (_ when #f #f)
        (_ when #t #t)
        (_         #f))))
  srcs)

(for-each
  (lambda (src)
    (check-true
      (match-source src ()
        (b when b #t)
        (_ #f))))
  srcs)

(check-for-src src1
  (lambda (src)
    (match-source src ()
      (b when (and (##source? b) 
                   (symbol? (##source-code b))) #t)
      (_ #f))))

(let ((src (plain-datum->syntax `(0 (0 1) 2))))
  (check-true
    (match-source src ()
      ((a (a b) c)
       #t)
      (_
        #f))))

(let ((src (plain-datum->syntax `(0 (3 1) 2))))
  (check-true
    (match-source src ()
      ((a (a b) c)
       #f)
      (_
        #t))))

;;;---------------------------------------
;;;

#;(let ((src (plain-datum->syntax `(0))))
  (check-true
    (match-source src ()
      ((a @ b)
       (equal? a b))
      (_
        #f))))

(let ((src (plain-datum->syntax `((0 1)))))
  (check-true
    (match-source src ()
      ((a @ (b c))
       (equal? (##source-code a)
               (list b c)))
      (_
        #f))))

(let ((src (plain-datum->syntax `((0 1)))))
  (check-true
    (match-source src ()
      ((a @ (b c) . rest)
       (equal? (##source-code a)
               (list b c)))
      (_
        #f))))


(let ((src (plain-datum->syntax `(##define (x a) x))))
    (match-source src ()
      ((_ binding @ (_ . _) . _)
       (##pretty-print 'asd))
      (_
        (##pretty-print 'dsa) #;#f)))

;;;----------------------------------------------------------------------------
