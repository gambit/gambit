;;;============================================================================

;;; File: "_source-match.scm"

;;; Copyright (c) 2023 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; WARNING: MUST MATCH ~~lib/_syntax/_source-match.scm
;;; TODO: reference instead
;;; TODO: rename file -> _##match-source.scm
;;; TODO: fail correctly

(define-macro (match-source src-obj literals . clauses)

  (define (##match-condition-pair seens code-obj condition next fail)
    (let ((code (##gensym 'code)))
     `(let ((,code ,code-obj))
       ,(cond
          ((##pair? condition) 
           (cond
             ((and (##symbol? (##car condition))
                   (##pair?   (##cdr condition))
                   (##eq?     (##cadr condition) '@)
                   (##pair?   (##caddr condition)))
              `(if (##pair? ,code)
                    ,(let* ((cont 
                              (lambda (seens) 
                                (##match-condition-pair seens code (##cddr condition) next fail))))
                       (##match-condition seens `(##car ,code) (##car condition) cont fail))
                    ,fail))
             (else
              `(if (##pair? ,code)
                   ,(let* ((cont 
                          (lambda (seens) 
                            (##match-condition-pair seens `(##cdr ,code) (##cdr condition) next fail))))
                      (##match-condition seens `(##car ,code) (##car condition) cont fail))
                   ,fail))))
          ((##null? condition)
           `(if (##null? ,code)
                ,(next seens)
                ,fail))
          (else
           (##match-condition seens code condition next fail))))))

  (define (##match-condition seens src-obj condition next fail)
    (let ((src (##gensym 'src)))
      `(let ((,src ,src-obj))
       ,(cond
          ((##symbol? condition)
           (cond
             ((##eq? condition '_)
              (next seens))
             ((##member condition literals)
              `(if (and (##source? ,src)
                        (##eq? ',condition (##source-code ,src)))
                   ,(next seens)
                   ,fail))
             ((##assoc condition seens)
                => (lambda (_+src)
                     (let ((seen-src (##cdr _+src)))
                       `(if (##eq? (##source-code ,seen-src) 
                                      (##source-code ,src))
                            ,(next seens)
                            ,fail))))
             (else
               `(let ((,condition ,src))
                   ,(next (##cons (##cons condition src) 
                                  seens))))))
          ((##pair? condition)
           `(and (##source? ,src)
                 ,(##match-condition-pair seens `(##source-code ,src) condition next fail)))
          ((##null? condition)
           `(if (and (##source? ,src)
                     (##null? (##source-code ,src)))
                ,(next seens)
                ,fail))
          (else
            `(if (and (##source? ,src)
                      (##eq? (##source-code ,src) ,condition))
                 ,(next seens)
                 ,fail))))))

  (define (##match-condition-fender fender src condition next fail)
    (let ((cont (lambda (_)
                  `(or (and ,fender ,(next (##list)))
                       ,fail))))
      (##match-condition (##list) src condition cont fail)))

  (define (##match-clause src clause fail)
    (or (and (##pair? clause)
             (let ((exprs (##cdr clause)))
               (and (##pair? exprs)
                    (let ((condition (##car clause)))
                      (if (and (pair? (cdr exprs))
                               (##eq? (##car exprs) 'when))
                          ; fender 
                          (let* ((exprs  (##cdr exprs))
                                 (fender (##car exprs)))
                            (##match-condition-fender 
                              fender 
                              src 
                              condition 
                              (lambda (_) 
                                `(begin ,@exprs))
                              fail))
                          (##match-condition 
                            (##list) 
                            src 
                            condition 
                            (lambda (_) 
                              `(begin ,@exprs)) 
                            fail))))))
         (error "source-match: ill formed clause" clause)))

  (define (##match-clauses src clauses)
    (cond
      ((##pair? clauses)
       (##match-clause src (##car clauses) (##match-clauses src (##cdr clauses))))
      (else
       `(##error "source-match : no match"))))


    (pp "reached")
  (let ((src (##gensym 'src)))
   `(let ((,src ,src-obj))
      ,(let ((src `(if (##source? ,src) ,src (##make-source ,src #f))))
        (##match-clauses src clauses)))))

;;;============================================================================
