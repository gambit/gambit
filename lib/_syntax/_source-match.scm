;;;============================================================================

;;; File: "_source-match.scm"

;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define-macro (match-source src-obj literals . clauses)

  (define (match-condition-pair seens code-obj condition next fail)
    (let ((code (gensym 'code)))
     `(let ((,code ,code-obj))
       ,(cond
          ((and (pair? condition)
                (or (symbol? (car condition)) (keyword? (car condition)))
                (pair?   (cdr condition))
                (equal?  (cadr condition) '@)
                (pair?   (caddr condition)))
            `(cond
              ((pair? ,code)
               ,(let* ((cont 
                       (lambda (seens) 
                         (match-condition-pair seens code (cddr condition) next fail))))
                  (match-condition seens `(car ,code) (car condition) cont fail)))
              (else 
                ,fail)))
          ((pair? condition) 
           `(cond
              ((pair? ,code)
               ,(let* ((cont 
                       (lambda (seens) 
                         (match-condition-pair seens `(cdr ,code) (cdr condition) next fail))))
                  (match-condition seens `(car ,code) (car condition) cont fail)))
              (else 
                ,fail)))
          ((null? condition)
           `(cond
              ((null? ,code)
               ,(next seens))
              (else
                ,fail)))
          (else
           (match-condition seens code condition next fail))))))

  (define (match-condition seens src-obj condition next fail)
    (let ((src (gensym 'src)))
      `(let ((,src ,src-obj))
       ,(cond
          ((or (symbol? condition)
               (keyword? condition))
           (cond
             ((equal? condition '_)
              (next seens))
             ((member condition literals)
              `(cond
                 ((and (##source? ,src)
                       (equal? ',condition (##source-code ,src)))
                  ,(next seens))
                 (else
                   ,fail)))
             ((assoc condition seens)
                => (lambda (_+src)
                     (let ((seen-src (cdr _+src)))
                       `(if (equal? (##source-code ,seen-src) 
                                    (##source-code ,src))
                            ,(next seens)
                            ,fail))))
             (else
               `(let ((,condition ,src))
                   ,(next (cons (cons condition src) seens))))))
          ((pair? condition)
           `(and (##source? ,src)
                 ,(match-condition-pair seens `(##source-code ,src) condition next fail)))
          ((null? condition)
           `(cond
               ((and (##source? ,src)
                     (null? (##source-code ,src)))
                ,(next seens))
               (else
                 ,fail)))
          (else
            `(cond
               ((and (##source? ,src)
                     (equal? (##source-code ,src) ,condition))
                ,(next seens))
               (else
                 ,fail)))))))

  (define (match-condition-fender fender src condition next fail)
    (let ((cont (lambda (_)
                  `(or (and ,fender ,(next (list)))
                       ,fail))))
      (match-condition (list) src condition cont fail)))

  (define (match-clause src clause fail)
    (let ((len (length clause)))
      (cond
        ((and (>= len 3)
              (equal? (cadr clause) 'when))
         (let ((condition (car clause))
               (fender    (caddr clause))
               (exprs     (cdddr clause)))
           (match-condition-fender fender src condition (lambda (_) `(begin ,@exprs)) fail)))
        ((>= len 2)
         (let ((condition (car clause))
               (exprs     (cdr clause)))
           (match-condition (list) src condition (lambda (_) `(begin ,@exprs)) fail)))
        (else
         (error "source-match: ill formed clause" clause)))))

  (define (match-clauses src clauses)
    (cond
      ((pair? clauses)
       (match-clause src (car clauses) (match-clauses src (cdr clauses))))
      (else
       `(##error "source-match : no match"))))

  (let ((src (gensym 'src)))
   `(let ((,src ,src-obj))
      ,(let ((src `(if (##source? ,src) ,src (##make-source ,src #f))))
        (match-clauses src clauses)))))

;;;============================================================================
