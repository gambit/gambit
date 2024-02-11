(include "#.scm")

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

;;;----------------------------------------------------------------------------

(check-true
  (##source? (##make-source 0 #f)))

(check-true
  (not (syntax-source? (##make-source 0 #f))))

(check-true
  (not (syntax-source? (##vector 0 0 0 0))))

;;;----------------------------------------------------------------------------
;;; source->syntax!

(define (##make-test-source #!optional (id #f))
  (let ((src (##make-source id #f)))
    (vector-set! src 2 'a-locat)
    (vector-set! src 3 'a-path)
    src))

(let ((src (##make-test-source)))
  (##source->syntax! src)
  (check-equal? 'a-locat (vector-ref src 2))
  (check-equal? 'a-path  (vector-ref src 3))
  (check-true   (not (not (vector-ref src 4)))))

(let ((src (##make-test-source))
      (stx (##make-syntax-source #f #f)))
  (##source->syntax! src stx)
  (check-equal? 'a-locat (vector-ref src 2))
  (check-equal? 'a-path  (vector-ref src 3))
  (check-true   (not (not (vector-ref src 4)))))

(let ((src (##make-source #f #f))
      (stx (let ((stx (##make-test-source)))
             (##source->syntax! stx)
             stx)))
  (##source->syntax! src stx)
  (check-equal? 'a-locat (vector-ref src 2))
  (check-equal? 'a-path  (vector-ref src 3))
  (check-true   (not (not (vector-ref src 4)))))

(let* ((src (##make-source #f #f))
       (stx (let ((stx (##make-test-source)))
              (##source->syntax! stx)
              (add-scope stx (make-scope))))
       (scopes (syntax-source-scopes stx)))
  (##source->syntax! src stx)
  (check-equal? 'a-locat (vector-ref src 2))
  (check-equal? 'a-path  (vector-ref src 3))
  (check-equal? scopes   (vector-ref src 4)))

;;;----------------------------------------------------------------------------
;;; ##datum->syntax

(let* ((datum (##make-test-source `(,(##make-test-source 0) ,(##make-test-source 1))))
       (stx   (##datum->syntax datum)))
  (check-true (syntax-source? stx))
  (check-equal? 'a-locat (vector-ref stx 2))
  (check-true (pair? (syntax-source-code stx)))
  (check-true (syntax-source? (car (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (car (syntax-source-code stx)) 2))
  (check-true (syntax-source? (cadr (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (cadr (syntax-source-code stx)) 2)))

(let* ((datum (##make-source `(,(##make-source 0 #f) ,(##make-source 1 #f)) #f))
       (ref   (let ((stx (##make-test-source)))
                (##source->syntax! stx)
                (add-scope stx (make-scope))))
       (stx   (##datum->syntax datum ref))
       (scopes (syntax-source-scopes stx)))
  (check-true (syntax-source? stx))
  (check-equal? 'a-locat (vector-ref stx 2))
  (check-true (pair? (syntax-source-code stx)))
  (check-true (syntax-source? (car (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (car (syntax-source-code stx)) 2))
  (check-equal? scopes   (vector-ref (car (syntax-source-code stx)) 4))
  (check-true (syntax-source? (cadr (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (cadr (syntax-source-code stx)) 2))
  (check-equal? scopes   (vector-ref (car (syntax-source-code stx)) 4)))

;;;----------------------------------------------------------------------------
;;; ##plain-datum->syntax

(let* ((datum (##make-test-source `(,(##make-test-source 0) ,(##make-test-source 1))))
       (stx   (##datum->syntax datum)))
  (check-true (syntax-source? stx))
  (check-equal? 'a-locat (vector-ref stx 2))
  (check-true (pair? (syntax-source-code stx)))
  (check-true (syntax-source? (car (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (car (syntax-source-code stx)) 2))
  (check-true (syntax-source? (cadr (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (cadr (syntax-source-code stx)) 2)))

(let* ((datum (##make-source `(,(##make-source 0 #f) ,(##make-source 1 #f)) #f))
       (ref   (let ((stx (##make-test-source)))
                (##source->syntax! stx)
                (add-scope stx (make-scope))))
       (stx   (##datum->syntax datum ref))
       (scopes (syntax-source-scopes stx)))
  (check-true (syntax-source? stx))
  (check-equal? 'a-locat (vector-ref stx 2))
  (check-true (pair? (syntax-source-code stx)))
  (check-true (syntax-source? (car (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (car (syntax-source-code stx)) 2))
  (check-equal? scopes   (vector-ref (car (syntax-source-code stx)) 4))
  (check-true (syntax-source? (cadr (syntax-source-code stx))))
  (check-equal? 'a-locat (vector-ref (cadr (syntax-source-code stx)) 2))
  (check-equal? scopes   (vector-ref (car (syntax-source-code stx)) 4)))

;;;----------------------------------------------------------------------------
