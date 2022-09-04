;;;============================================================================

;;; File: "six-expand.scm"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

(##supply-module _six/six-expand)

(##namespace ("_six/six-expand#"))        ;; in _six/six-expand#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "six-expand#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(define-type conversion-ctx
  target
  operators
  parameters
  globals
  literal
  procedure
  unsupported
  incall)

(define C-operators
  (list->table
   '(
     ;;                   _____precedence
     ;;                  / ____associativity (0=LR, 1=RL, 2=not assoc.)
     ;;                 / / ___operand count (-1 for postfix unary operator)
     ;;                / / / __target operator
     ;;               / / / /
     (quasiquote     0 0)
     (six.identifier 0 0)
     (six.literal    0 0)

     (six.index      1 0)
     (six.call       1 0)
     (six.dot        1 0)
     (six.arrow      1 0)

     (six.x++        1 0 -1 "++")
     (six.x--        1 0 -1 "--")

     (six.+x         2 1 1 "+") ;; note: RL associative
     (six.-x         2 1 1 "-")
     (six.!x         2 1 1 "!")
     (six.~x         2 1 1 "~")
     (six.*x         2 1 1 "*")
     (six.&x         2 1 1 "&")
     (six.++x        2 1 1 "++")
     (six.--x        2 1 1 "--")

     (six.x*y        3 0 2 "*")
     (six.x/y        3 0 2 "/")
     (six.x%y        3 0 2 "%")

     (six.x+y        4 0 2 "+")
     (six.x-y        4 0 2 "-")

     (six.x<<y       5 0 2 "<<")
     (six.x>>y       5 0 2 ">>")

     (six.x<y        6 0 2 "<")
     (six.x<=y       6 0 2 "<=")
     (six.x>y        6 0 2 ">")
     (six.x>=y       6 0 2 ">=")

     (six.x==y       7 0 2 "==")
     (six.x!=y       7 0 2 "!=")

     (six.x&y        8 0 2 "&")

     (six.x^y        9 0 2 "^")

     (|six.x\|y|    10 0 2 "|")

     (six.x&&y      11 0 2 "&&")

     (|six.x\|\|y|  12 0 2 "||")

;;     (six.x?y:z     13 1) ;; note: RL associative

     (six.x=y       14 1 2 "=") ;; note: RL associative
     (six.x+=y      14 1 2 "+=")
     (six.x-=y      14 1 2 "-=")
     (six.x**=y     14 1 2 "**=")
     (six.x*=y      14 1 2 "*=")
     (six.x/=y      14 1 2 "/=")
     (six.x%=y      14 1 2 "%=")
     (six.x<<=y     14 1 2 "<<=")
     (six.x>>=y     14 1 2 ">>=")
     (six.x&=y      14 1 2 "&=")
     (six.x^=y      14 1 2 "^=")
     (|six.x\|=y|   14 1 2 "|=")
     (six.x&&=y     14 1 2 "&&=")
     (six.x||=y     14 1 2 "||=")

;;     (six.x,=y      15 0 2 ",")
)))

(define js-operators
  (list->table
   '(
     ;;                   _____precedence
     ;;                  / ____associativity (0=LR, 1=RL, 2=not assoc.)
     ;;                 / / ___operand count (-1 for postfix unary operator)
     ;;                / / / __target operator
     ;;               / / / /
     (quasiquote     0 0)
     (six.identifier 0 0)
     (six.literal    0 0)
     (six.list       0 0)
     (six.null       0 0)
     (six.asyncx     0 1 1 "async ") ;; note: RL associative

     (six.index      1 0)
     (six.call       1 0)
     (six.dot        1 0)
     (six.new        1 0)

     (six.x++        3 0 -1 "++")
     (six.x--        3 0 -1 "--")

     (six.+x         4 1 1 "+") ;; note: RL associative
     (six.-x         4 1 1 "-")
     (six.!x         4 1 1 "!")
     (six.~x         4 1 1 "~")
     (six.++x        4 1 1 "++")
     (six.--x        4 1 1 "--")
     (six.awaitx     4 1 1 "await ")
     (six.typeofx    4 1 1 "typeof ")

     (six.x**y       5 1 2 "**") ;; note: RL associative

     (six.x*y        6 0 2 "*")
     (six.x/y        6 0 2 "/")
     (six.x%y        6 0 2 "%")

     (six.x+y        7 0 2 "+")
     (six.x-y        7 0 2 "-")

     (six.x<<y       8 0 2 "<<")
     (six.x>>y       8 0 2 ">>")
     (six.x>>>y      8 0 2 ">>>")

     (six.x<y        9 0 2 "<")
     (six.x<=y       9 0 2 "<=")
     (six.x>y        9 0 2 ">")
     (six.x>=y       9 0 2 ">=")
     (six.xiny       9 0 2 " in ")
     (six.xinstanceofy 9 0 2 " instanceof ")

     (six.x==y      10 0 2 "==")
     (six.x!=y      10 0 2 "!=")
     (six.x===y     10 0 2 "===")
     (six.x!==y     10 0 2 "!==")

     (six.x&y       11 0 2 "&")

     (six.x^y       12 0 2 "^")

     (|six.x\|y|    13 0 2 "|")

     (six.x&&y      14 0 2 "&&")

     (|six.x\|\|y|  15 0 2 "||")

;;     (six.x?y:z     17 1) ;; note: RL associative

     (six.x=y       18 1 2 "=") ;; note: RL associative
     (six.x+=y      18 1 2 "+=")
     (six.x-=y      18 1 2 "-=")
     (six.x**=y     18 1 2 "**=")
     (six.x*=y      18 1 2 "*=")
     (six.x/=y      18 1 2 "/=")
     (six.x%=y      18 1 2 "%=")
     (six.x<<=y     18 1 2 "<<=")
     (six.x>>=y     18 1 2 ">>=")
     (six.x>>>=y    18 1 2 ">>>=")
     (six.x&=y      18 1 2 "&=")
     (six.x^=y      18 1 2 "^=")
     (|six.x\|=y|   18 1 2 "|=")
     (six.x&&=y     18 1 2 "&&=")
     (six.x||=y     18 1 2 "||=")

     (six.yieldx    20 1 1 "yield ") ;; note: RL associative

;;     (six.x,=y      21 0 2 ",")

     (six.procedure 99 0)
)))

(define python-operators
  (list->table
   '(
     ;;                   _____precedence
     ;;                  / ____associativity (0=LR, 1=RL, 2=not assoc.)
     ;;                 / / ___operand count (-1 for postfix unary operator)
     ;;                / / / __target operator
     ;;               / / / /
     (quasiquote     0 0)
     (six.identifier 0 0)
     (six.literal    0 0)
     (six.list       0 0)
     (six.null       0 0)

     (six.index      1 0)
     (six.call       1 0)
     (six.dot        1 0)


     (six.xasy       1 1 2 " as ")

     (|six.x,y|      2 1 2 ", ")

     (six.x**y       3 1 2 "**") ;; note: RL associative

     (six.+x         4 1 1 "+") ;; note: RL associative
     (six.-x         4 1 1 "-")
     (six.~x         4 1 1 "~")

     (six.x*y        5 0 2 "*")
     (six.x@y        5 0 2 "@")
     (six.x/y        5 0 2 "/")
     (six.x//y       5 0 2 "//")
     (six.x%y        5 0 2 "%")

     (six.x+y        6 0 2 "+")
     (six.x-y        6 0 2 "-")

     (six.x<<y       7 0 2 "<<")
     (six.x>>y       7 0 2 ">>")

     (six.x&y        8 0 2 "&")

     (six.x^y        9 0 2 "^")

     (|six.x\|y|    10 0 2 "|")

     (six.x<y       11 2 2 "<") ;; note: not associative
     (six.x<=y      11 2 2 "<=")
     (six.x>y       11 2 2 ">")
     (six.x>=y      11 2 2 ">=")
     (six.x==y      11 2 2 "==")
     (six.x!=y      11 2 2 "!=")
     (six.xiny      11 2 2 " in ")
     (six.xisy      11 2 2 " is ")

     (six.notx      12 1 1 "not ") ;; note: RL associative

     (six.xandy     13 0 2 " and ")

     (six.xory      14 0 2 " or ")

     (six.x=y       15 1 2 "=") ;; note: RL associative

     (six.procedure 99 0)
)))

(define (six->C ast-src)

  (define (convert-literal cctx src)
    (##deconstruct-call
     src
     2
     (lambda (val-src)
       (let ((val (##source-strip val-src)))
         (cond ((number? val)
                (number->string val)) ;; TODO: use C number syntax
               ((boolean? val)
                (if val "1" "0"))
               ((string? val)
                (object->string val)) ;; TODO: use C string syntax
               (else
                (unsupported cctx src)))))))

  (define (convert-procedure cctx ast-src params return-type stmts-src)
    (unsupported cctx ast-src))

  (define (unsupported cctx src)
    (##raise-expression-parsing-exception
     'ill-formed-expression
     src))

  (define cctx
    (make-conversion-ctx
     'C
     C-operators
     '()
     (make-table)
     convert-literal
     convert-procedure
     unsupported
     #f))

  (let ((target-expr (six-expression-to-infix cctx ast-src)))
    (cons (flatten-string target-expr)
          (reverse (conversion-ctx-parameters cctx)))))

(define (six->js ast-src)

  (define (convert-literal cctx src)
    (##deconstruct-call
     src
     2
     (lambda (val-src)
       (let ((val (##source-strip val-src)))
         (cond ((number? val)
                (number->string val)) ;; TODO: use JavaScript number syntax
               ((boolean? val)
                (if val "true" "false"))
               ((string? val)
                (object->string val)) ;; TODO: use JavaScript string syntax
               (else
                (unsupported cctx src)))))))

  (define (statement cctx ast-src)
    (let ((ast (##source-strip ast-src)))
      (if (not (pair? ast))
          (unsupported ast-src)
          (let* ((head
                  (##source-strip (car ast)))
                 (rest
                  (cdr ast)))
            (case head
              ((six.return)
               (list "return "
                     (six-expression-to-infix cctx (car rest))
                     "; "))
              (else
               (list (six-expression-to-infix cctx ast)
                     "; ")))))))

  (define (convert-procedure cctx ast-src params return-type stmts-src)
    (list "function ("
          (comma-separated
           (map (lambda (param)
                  (symbol->string (cadr (car param))))
                params))
          ") { "
          (map (lambda (stmt-src)
                 (statement cctx stmt-src))
               stmts-src)
          "}"))

  (define (unsupported cctx src)
    (##raise-expression-parsing-exception
     'ill-formed-expression
     src))

  (define cctx
    (make-conversion-ctx
     'js
     js-operators
     '()
     (make-table)
     convert-literal
     convert-procedure
     unsupported
     #f))

  (let ((target-expr (six-expression-to-infix cctx ast-src)))
    (cons (flatten-string target-expr)
          (reverse (conversion-ctx-parameters cctx)))))

;; Expand six.infix for JavaScript.
(define (six.infix-js-expand src)
  (##deconstruct-call
   src
   2
   (lambda (ast-src)
     (let ((ast (##source-strip ast-src)))
       (if (and (pair? ast)
                (eq? 'six.import (##source-strip (car ast)))
                (pair? (cdr ast))
                (null? (cddr ast)))
           (let ((ident (##source-strip (cadr ast))))
             (if (and (pair? ident)
                      (eq? 'six.identifier (##source-strip (car ident)))
                      (pair? (cdr ident))
                      (null? (cddr ident)))
                 `(begin
                    (error "JavaScript import not implemented")
                    (js-import ,(symbol->string (##source-strip (cadr ident))))
                    (void))
                 (error "invalid import")))

           (let* ((x (six->js ast-src))
                  (body (car x))
                  (params (cdr x))
                  (def
                   (string-append "(async function ("
                                  (flatten-string
                                   (comma-separated (map car params)))
                                  ") {"
                                  "\n return " 
                                  body ";\n})")))
             `((##host-function-memoized ',(box def)) ;; literal box
               ,@(map cdr params))))))))

(define (six->python ast-src)

  (define (convert-literal cctx src)
    (##deconstruct-call
     src
     2
     (lambda (val-src)
       (let ((val (##source-strip val-src)))
         (cond ((number? val)
                (number->string val)) ;; TODO: use Python number syntax
               ((boolean? val)
                (if val "True" "False"))
               ((string? val)
                (object->string val)) ;; TODO: use Python string syntax
               (else
                (unsupported cctx src)))))))

  ;; Unsupported in Python
  (define (convert-procedure cctx ast-src params return-type stmts-src) #!void)
  (define (statement cctx ast-src) #!void)

  (define (unsupported cctx src)
    (##raise-expression-parsing-exception
     'ill-formed-expression
     src))

  (define cctx
    (make-conversion-ctx
     'python
     python-operators
     '()
     (make-table)
     convert-literal
     convert-procedure
     unsupported
     #f))

  (let ((target-expr (six-expression-to-infix cctx ast-src)))
    (cons (flatten-string target-expr)
          (reverse (conversion-ctx-parameters cctx)))))

;; Expand six.infix for Python.
(define (six.infix-python-expand src)
  (##deconstruct-call
   src
   2
   (lambda (ast-src)
     (let ((ast (##source-strip ast-src)))
       (cond
        ((and (pair? ast)
              (eq? 'six.from-import-* (##source-strip (car ast))))
         (let ((stmt (string-concatenate
                       `("from "
                         ,@(six->python (##source-strip (cadr ast)))
                         " import *"))))
               `(begin
                  (python-exec ,stmt)
                  (void))))
        ((and (pair? ast)
              (eq? 'six.from-import (##source-strip (car ast))))
         (let ((stmt (string-concatenate
                      `("from "
                        ,@(six->python (##source-strip (cadr ast)))
                        " import "
                        ,(flatten-string
                          (comma-separated
                           (map (lambda (e) (six->python e))
                                (##source-strip (cddr ast)))))))))
               `(begin
                  (python-exec ,stmt)
                  (void))))
        ((and (pair? ast)
              (eq? 'six.import (##source-strip (car ast)))
              (pair? (cdr ast)))
         (let ((stmt `(string-concatenate
                       (list "import "
                             ,(flatten-string
                               (comma-separated
                                (map (lambda (e) (six->python e))
                                     (##source-strip (cdr ast)))))))))
           `(begin
              (python-exec ,stmt)
              (void))))
        (else (let* ((x (six->python ast-src))
                     (body (car x))
                     (params (cdr x))
                     (def
                      (string-append "lambda "
                                     (flatten-string
                                      (comma-separated (map car params)))
                                     ": "
                                     body)))
                `((##py-function-memoized ',(box def)) ;; literal box
                  ,@(map cdr params)))))))))

(define (six->target ast-src target)
  (case target
    ((C)
     (six->C ast-src))
    ((js)
     (six->js ast-src))
    ((python)
     (six->python ast-src))
    (else
     (error "unsupported target" target))))

(define (six-expression-to-infix cctx ast-src)

  (define (unsupported ast-src)
    ((conversion-ctx-unsupported cctx) cctx ast-src))

  (define (precedence op) (car op))
  (define (associativity op) (cadr op))

  (define (parens-optional? pos inner-op outer-op)
    (let ((inner-prec (precedence inner-op))
          (outer-prec (precedence outer-op)))
      (or (< inner-prec outer-prec)
          (and (= inner-prec outer-prec)
               (let ((inner-assoc (associativity inner-op)))
                 (and (< inner-assoc 2) ;; 2 = non associative
                      (= inner-assoc pos)))))))

  (define (infix ast-src pos outer-op)
    (let ((ast (##source-strip ast-src)))
      (if (not (pair? ast))
          (unsupported ast-src)
          (let* ((head
                  (##source-strip (car ast)))
                 (rest
                  (cdr ast))
                 (inner-op
                  (table-ref (conversion-ctx-operators cctx) head #f)))
            (if (not inner-op)
                (unsupported ast-src)
                (let* ((x
                        (cddr inner-op))
                       (expr
                        (if (not (pair? x))
                            (infix* ast-src pos inner-op)
                            (let ((operand-count (car x))
                                  (target-op (cadr x)))
                              (case (length rest)
                                ((0)
                                 target-op)
                                ((1)
                                 (list target-op
                                       (infix (car rest) 1 inner-op)))
                                ((2)
                                ;; Handle six.x=y assignments for Python
                                (if (and (eq? (conversion-ctx-target cctx) 'python)
                                         (not (conversion-ctx-incall cctx))
                                         (equal? target-op "="))
                                    (let ((lhs (infix (car rest) 0 inner-op)))
                                      (list "set_global('" lhs "', " (infix (cadr rest) 1 inner-op) ")"))
                                    (list (infix (car rest) 0 inner-op)
                                        target-op
                                        (infix (cadr rest) 1 inner-op))))
                                ((3)
                                 ...) ;; TODO: ternary operator
                                (else
                                 (unsupported ast)))))))
                  (if (parens-optional? pos inner-op outer-op)
                      expr
                      (list "(" expr ")"))))))))

  (define (infix* ast-src pos inner-op)
    (let ((ast (##source-strip ast-src)))
      (case (##source-strip (car ast))

        ((quasiquote)
         (##deconstruct-call
          ast-src
          2
          (lambda (expr-src)
            (let* ((params
                    (conversion-ctx-parameters cctx))
                   (param-id
                    (string-append "___"
                                   (number->string (+ 1 (length params))))))
              (conversion-ctx-parameters-set!
               cctx
               (cons (cons param-id expr-src)
                     params))
              param-id))))

        ((six.identifier)
         (##deconstruct-call
          ast-src
          2
          (lambda (ident-src)
            (let* ((ident-sym (##source-strip ident-src))
                   (ident (symbol->string ident-sym)))
              (table-set! (conversion-ctx-globals cctx) ident-sym ident)
              ident))))

        ((six.literal)
         ((conversion-ctx-literal cctx) cctx ast-src))

        ((six.list six.null)
         (let loop ((ast-src ast-src) (rev-elems '()))
           (let ((ast (##source-strip ast-src)))
             (case (##source-strip (car ast))
               ((six.list)
                (##deconstruct-call
                 ast-src
                 3
                 (lambda (head-src tail-src)
                   (loop tail-src (cons (cvt head-src) rev-elems)))))
               ((six.null)
                (##deconstruct-call
                 ast-src
                 0
                 (lambda ()
                   (list "["
                         (comma-separated (reverse rev-elems))
                         "]"))))
               (else
                (unsupported ast-src))))))

        ((six.index)
         (##deconstruct-call
          ast-src
          3
          (lambda (obj-src index-src)
            (list (infix obj-src 0 inner-op)
                  "["
                  (cvt index-src)
                  "]"))))

        ((six.call)
         (##deconstruct-call
          ast-src
          -2
          (lambda (fn-src . args-src)
            (conversion-ctx-incall-set! cctx #t)
            ;; Named/keyword argument handling
            (let loop ((args-src args-src) (args '()))
                (if (pair? args-src)
                    (if (keyword? (car args-src))
                        (loop (cddr args-src) (cons (string-append
                                                      (keyword->string (car args-src))
                                                      "="
                                                      (cvt (cadr args-srcs)))
                                                    args))
                        (loop (cdr args-src) (cons (cvt (car args-src)) args)))
                    (let ((res (list (infix fn-src 0 inner-op)
                                "("
                                (comma-separated (reverse args))
                                ")")))
                      (conversion-ctx-incall-set! cctx #f)
                      res))))))

        ((six.new)
         (##deconstruct-call
          ast-src
          -2
          (lambda (constructor-src . args-src)
            (let ((args (map cvt args-src)))
              (list "new "
                    (infix constructor-src 0 inner-op)
                    "("
                    (comma-separated args)
                    ")")))))

        ((six.dot)
         (##deconstruct-call
          ast-src
          3
          (lambda (obj-src attr-src)
            ;; TODO: check that attr-src is (six.identifier ...)
            (##deconstruct-call
             attr-src
             2
             (lambda (ident-src)
               (list (infix obj-src 0 inner-op)
                     "."
                     (symbol->string (##source-strip ident-src))))))))

        ((six.procedure)
         (##deconstruct-call
          ast-src
          4
          (lambda (return-type-src params-src procedure-body-src)
            ;; TODO: check that procedure-body-src is correct
            (##deconstruct-call
             procedure-body-src
             -1
             (lambda stmts-src
               ((conversion-ctx-procedure cctx)
                cctx
                ast-src
                (##desourcify params-src)
                (##desourcify return-type-src)
                stmts-src))))))

        (else
         (unsupported ast-src)))))

  (define (cvt ast-src)
    ;; pretend wrapped in infinitely low precedence operator to prevent
    ;; outer level of parentheses
    (infix ast-src 0 '(9999 0)))

  (cvt ast-src))

(define (comma-separated lst)
  (if (pair? lst)
      (cons (car lst)
            (map (lambda (x) (list "," x)) (cdr lst)))
      ""))

(define (flatten-string x)
  (call-with-output-string (lambda (p) (##print-aux x p))))

;;;============================================================================
