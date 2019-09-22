;; ----------------------------------------------------------------------------
;; Erlang-style pattern matching for Scheme
;;
;; TODO
;; - handle vectors (!)

;; tree-based pattern matching optimization

;; see match.scm

(##supply-module termite/match-support)
(##namespace ("termite/match-support#"))
(##include "~~lib/_prim#.scm")
(##import termite/utils)

;; Clause manipulation

;; 2 possible clause expression:

;; (match data
;;   (clause (where guard) . code)
;;   (clause               . code))

(define-record-type clause/rt
                    (make-clause pattern guard code)
                    clause?
                    (pattern clause-pattern)
                    (guard   clause-guard)
                    (code    clause-code))

;; accumulate every part of the tree which satisfies PRED? and only go
;; down the child satisfying GO-DOWN?
(define (tree-filter pred? go-down? tree)
  (cond
    ((pred? tree)
     (list tree))
    ((and (pair? tree) (go-down? tree))
     (append (tree-filter pred? go-down? (car tree))
             (tree-filter pred? go-down? (cdr tree))))
    (else '())))

;; remove duplicates (bad name...)
(define (delete-duplicates lst)
  (cond
    ((null? lst)
     '())
    ((member (car lst)
             (cdr lst))
     (delete-duplicates (cdr lst)))
    (else
      (cons (car lst)
            (delete-duplicates (cdr lst))))))

;; compile-pattern-match: generate the code for the pattern matching
;;
;; on-success: code to insert when a clause matches
;; on-fail: code to execute when the whole pattern fail
;; clause-list: list of all the pattern clauses
;; args: the name of the variable holding the value we're matching
;;       against (bad name...)
(define (compile-pattern-match on-success on-fail clause-list args)

  ;; call the translation on each clause sequentially
  (define (translate clauses made uenv ienv)
    (if (null? clauses)
      on-fail
      (let ((clause (car clauses))
            (f-k (lambda (made uenv ienv)
                   (translate
                     (cdr clauses)
                     made
                     '()
                     ienv))))

        (pattern-walk (clause-pattern clause)
                      made
                      uenv
                      ienv
                      args
                      (lambda (made uenv ienv)
                        ;; TODO: remove this ugly test (and the
                        ;; on-success test...)
                        (if (eq? #t (clause-guard clause))

                          (if on-success
                            `(begin
                               ,on-success
                               ,((clause-code clause) uenv))
                            ((clause-code clause) uenv))

                          `(if (let ,uenv ,(clause-guard clause)) ;; ~if ?
                             ,(if on-success
                                `(begin
                                   ,on-success
                                   ,((clause-code clause) uenv))
                                ((clause-code clause) uenv))
                             ,(f-k made uenv ienv))))
                      f-k))))

  ;; is that variable already bound?
  (define (bound? var env)
    (assoc var env))

  ;; what code is it bound to
  (define (lookup var env)
    (cadr (assoc var env)))

  (define (rlookup val env)
    (let ((v (assoc val (map (lambda (p)
                               (cons (cadr p)
                                     (car p)))
                             env))))
      (if (not v)
        (error "can't find it:" (list val: val env: env))
        (cdr v))))

  ;; extend the env. with a new var
  (define (extend var val env)
    (cons (list var val) env))

  ;; this is the compilation function that goes 'down' a clause
  ;; patt: the pattern to match
  ;; made: the tests made, an a-list of (test-code . result)
  ;; uenv: the user env., ex. the x in (match 123 (x x))
  ;; ienv: the 'internal' env, bindings introduced by the macro
  ;; acc: the current 'accessor', that is the way to get to the current patt
  ;; s-k: success continuation, if the match succeeds
  ;; f-k: failure continuation, if the match fails
  (define (pattern-walk patt made uenv ienv acc s-k f-k)

    ;; has that test already been made
    (define (test-made? test)
      (assoc test made))

    ;; did it fail or succeed
    (define (test-result test)
      (cdr (assoc test made)))

    ;; build one of those test
    (define (make-test test var . val)
      (if (pair? val)
        `(,test ,var ,(car val))
        `(,test ,var)))

    ;; add a test that succeeded
    (define (add-t-test test)
      (cons (cons test #t) made))

    ;; add a test that failed
    (define (add-f-test test)
      (cons (cons test #f) made))

    ;; check to see if a test has already succeded in another context,
    ;; that would mean trying the current test would fail (I take this
    ;; assumes every test is mutually exclusive...)
    (define (test-would-fail? test)
      (let ((acc (cadr test))
            (successful-tests (filter cdr made)))
        (member acc (map cadar successful-tests))))

    ;; generate an IF if both branches are different
    (define (~if test succ fail)
      (if (equal? succ fail)
        succ
        `(if ,test
           ,succ
           ,fail)))

    ;; main body of pattern-walk
    (cond
      ;; if the pattern is null
      ((null? patt)
       (let ((test (make-test 'null? acc)))
         (cond
           ((test-made? test)
            (if (test-result test)
              (s-k made uenv ienv)
              (f-k made uenv ienv)))

           ((test-would-fail? test)
            (f-k made uenv ienv))

           (else
             (~if test
                  (s-k (add-t-test test) uenv ienv)
                  (f-k (add-f-test test) uenv ienv))))))

      ;; is the pattern some constant value?
      ((or (quoted-symbol? patt)
           (number? patt) ;; fixme: bignums wont work (because of eq?)
           (eq? #t patt)
           (eq? #f patt)
           (char? patt)
           (keyword? patt))
       (let ((test (make-test 'eq?
                              acc
                              (if (quoted-symbol? patt)
                                `',(cadr patt)
                                patt))))
         (cond
           ((test-made? test)
            (if (test-result test)
              (s-k made uenv ienv)
              (f-k made uenv ienv)))

           ((test-would-fail? test)
            (f-k made uenv ienv))

           (else
             (~if test
                  (s-k (add-t-test test) uenv ienv)
                  (f-k (add-f-test test) uenv ienv))))))

      ;; is the pattern an unquoted symbol (reference to the user env)?
      ((unquoted-symbol? patt)
       (let ((test (make-test 'eq? acc (cadr patt))))
         (~if test
              (s-k made uenv ienv)
              (f-k made uenv ienv))))

      ;; is the pattern a pair?
      ((pair? patt)
       (let ((test (make-test 'pair? acc)))

         (cond
           ;; test done already
           ((test-made? test)

            (if (test-result test)

              (pattern-walk (car patt)
                            made
                            uenv
                            ienv
                            (rlookup `(car ,acc) ienv)
                            (lambda (made uenv ienv)
                              (pattern-walk (cdr patt)
                                            made
                                            uenv
                                            ienv
                                            (rlookup `(cdr ,acc) ienv)
                                            s-k
                                            f-k))
                            f-k)
              (f-k made uenv ienv)))

           ;; another test succeded meaning this one would fail
           ((test-would-fail? test)
            (f-k made uenv ienv))

           ;; do the test
           (else
             (~if test

                  (let ((?car (gensym))
                        (?cdr (gensym)))

                    (let ((ienv (extend ?car
                                        `(car ,acc)
                                        (extend ?cdr
                                                `(cdr ,acc)
                                                ienv))))

                      `(let ((,?car (car ,acc))
                             (,?cdr (cdr ,acc)))

                         ,(pattern-walk (car patt)
                                        (add-t-test test)
                                        uenv
                                        ienv
                                        ?car
                                        (lambda (made uenv ienv)
                                          (pattern-walk (cdr patt)
                                                        made
                                                        uenv
                                                        ienv
                                                        ?cdr
                                                        s-k
                                                        f-k))
                                        f-k))))

                  (f-k (add-f-test test) uenv ienv))))))

      ;; is it a 'free' symbol, to be bound to a new value or compared
      ;; to a previous value which it was bound to during the pattern
      ;; matching?
      ((symbol? patt)
       (if (bound? patt uenv)
         (let ((test (make-test 'eq? acc (lookup patt uenv))))

           (if (test-made? test)
             (if (test-result test)
               (s-k made uenv ienv)
               (f-k made uenv ienv))
             (~if test
                  (s-k (add-t-test test) uenv ienv)
                  (f-k (add-f-test test) uenv ienv))))

         (if (eq? patt '_)
           (s-k made uenv ienv)
           (s-k made (extend patt acc uenv) ienv))))

      ;; maybe it's something we don't handle in here
      (else
        (error "unknown pattern" patt))))

  ;; compile-pattern-match main body

  ;; this code build clauses, then extract the [non-trivial]
  ;; CLAUSE-CODEs and lift them outside WARNING: hairy code, fixme
  (let* ((transform
           (map
             (lambda (clause)
               (let ((pattern (car clause))
                     (guard
                       (let ((g (map
                                  cadr
                                  (filter
                                    (lambda (x)
                                      (and (pair? x)
                                           (eq? (car x)
                                                'where)))
                                    (cdr clause)))))
                         (case (length g)
                           ((0) #t)
                           ((1) (car g))
                           (else `(and ,@g)))))
                     (code
                       (let ((c (remove
                                  (lambda (x)
                                    (and (pair? x)
                                         (eq? (car x)
                                              'where)))
                                  (cdr clause))))
                         (case (length c)
                           ((0) #t) ;; ???
                           ((1) (car c))
                           (else `(begin ,@c))))))
                 (make-clause pattern guard code)))
             clause-list))

         (data (map (lambda (clause)

                      (let ((code-label (gensym))
                            (var-list
                              (delete-duplicates
                                (tree-filter
                                  (lambda (t)
                                    (and (symbol? t)
                                         (not (eq? t '_))))
                                  (lambda (t)
                                    (not
                                      (or
                                        (unquoted-symbol? t)
                                        (quoted-symbol? t))))
                                  (clause-pattern clause))))
                            (code (clause-code clause)))

                        (let ((lifted `(,code-label
                                         (lambda ,var-list
                                           ,code)))

                              ;; trivial non-triviality test
                              (not-trivial? (and (pair? code)
                                                 (not (quoted-symbol? code)))))

                          (cons (and not-trivial? lifted)
                                (make-clause
                                  (clause-pattern clause)
                                  (clause-guard clause)
                                  (lambda (env)
                                    (if not-trivial?
                                      (cons code-label
                                            (map
                                              (lambda (var)
                                                (cadr (assoc var env)))
                                              var-list))
                                      (if (symbol? code)
                                        (cond
                                          ((assoc code env) => cadr)
                                          (else code))
                                        code))))))))
                    transform)))

    `(let ,(map car (filter car data))
       ,(translate (map cdr data) '() '() '()))))
