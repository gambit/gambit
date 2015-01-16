; File: "mix.scm", Time-stamp: <2015-01-16 14:02:30 feeley>

; Copyright (c) 1998-2007 by Marc Feeley, All Rights Reserved.

(##declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

(define word-size (##u8vector-length '#(#f))) ; may not work in the future
(define string-char-size (##u8vector-length "a"))

;------------------------------------------------------------------------------

; This first part is the "PEVAL" benchmark (partial-evaluator)

; Utilities

(define (every? pred? l)
  (let loop ((l l))
    (or (null? l) (and (pred? (car l)) (loop (cdr l))))))

(define (some? pred? l)
  (let loop ((l l))
    (if (null? l) #f (or (pred? (car l)) (loop (cdr l))))))

(define (map2 f l1 l2)
  (let loop ((l1 l1) (l2 l2))
    (if (pair? l1)
      (cons (f (car l1) (car l2)) (loop (cdr l1) (cdr l2)))
      '())))

(define (get-last-pair l)
  (let loop ((l l))
    (let ((x (cdr l))) (if (pair? x) (loop x) l))))

; The partial evaluator.

(define (partial-evaluate proc args)
  (peval (alphatize proc '()) args))

(define (alphatize exp env) ; return a copy of 'exp' where each bound var has
  (define (alpha exp)       ; been renamed (to prevent aliasing problems)
    (cond ((const-expr? exp)
           (quot (const-value exp)))
          ((symbol? exp)
           (let ((x (assq exp env))) (if x (cdr x) exp)))
          ((or (eq? (car exp) 'if) (eq? (car exp) 'begin))
           (cons (car exp) (map alpha (cdr exp))))
          ((or (eq? (car exp) 'let) (eq? (car exp) 'letrec))
           (let ((new-env (new-variables (map car (cadr exp)) env)))
             (list (car exp)
                   (map (lambda (x)
                          (list (cdr (assq (car x) new-env))
                                (if (eq? (car exp) 'let)
                                  (alpha (cadr x))
                                  (alphatize (cadr x) new-env))))
                        (cadr exp))
                   (alphatize (caddr exp) new-env))))
          ((eq? (car exp) 'lambda)
           (let ((new-env (new-variables (cadr exp) env)))
             (list 'lambda
                   (map (lambda (x) (cdr (assq x new-env))) (cadr exp))
                   (alphatize (caddr exp) new-env))))
          (else
           (map alpha exp))))
  (alpha exp))

(define (const-expr? expr) ; is 'expr' a constant expression?
  (and (not (symbol? expr))
       (or (not (pair? expr))
           (eq? (car expr) 'quote))))

(define (const-value expr) ; return the value of a constant expression
  (if (pair? expr) ; then it must be a quoted constant
    (cadr expr)
    expr))

(define (quot val) ; make a quoted constant whose value is 'val'
  (list 'quote val))

(define (new-variables parms env)
  (append (map (lambda (x) (cons x (new-variable x))) parms) env))

(define *current-num* 0)

(define (new-variable name)
  (set! *current-num* (+ *current-num* 1))
  (string->symbol
    (string-append (symbol->string name)
                   "_"
                   (number->string *current-num*))))

; (peval proc args) will transform a procedure that is known to be called
; with constants as some of its arguments into a specialized procedure that
; is 'equivalent' but accepts only the non-constant parameters.  'proc' is the
; list representation of a lambda-expression and 'args' is a list of values,
; one for each parameter of the lambda-expression.  A special value (i.e.
; 'not-constant') is used to indicate an argument that is not a constant.
; The returned procedure is one that has as parameters the parameters of the
; original procedure which are NOT passed constants.  Constants will have been
; substituted for the constant parameters that are referenced in the body
; of the procedure.
;
; For example:
;
;   (peval
;     '(lambda (x y z) (f z x y)) ; the procedure
;     (list 1 not-constant #t))   ; the knowledge about x, y and z
;
; will return: (lambda (y) (f '#t '1 y))

(define (peval proc args)
  (simplify!
    (let ((parms (cadr proc))  ; get the parameter list
          (body (caddr proc))) ; get the body of the procedure
      (list 'lambda
            (remove-constant parms args) ; remove the constant parameters
            (beta-subst ; in the body, replace variable refs to the constant
              body      ; parameters by the corresponding constant
              (map2 (lambda (x y) (if (not-constant? y) '(()) (cons x (quot y))))
                    parms
                    args))))))

(define not-constant (list '?)) ; special value indicating non-constant parms.

(define (not-constant? x) (eq? x not-constant))

(define (remove-constant l a) ; remove from list 'l' all elements whose
  (cond ((null? l)            ; corresponding element in 'a' is a constant
         '())
        ((not-constant? (car a))
         (cons (car l) (remove-constant (cdr l) (cdr a))))
        (else
         (remove-constant (cdr l) (cdr a)))))

(define (extract-constant l a) ; extract from list 'l' all elements whose
  (cond ((null? l)             ; corresponding element in 'a' is a constant
         '())
        ((not-constant? (car a))
         (extract-constant (cdr l) (cdr a)))
        (else
         (cons (car l) (extract-constant (cdr l) (cdr a))))))

(define (beta-subst exp env) ; return a modified 'exp' where each var named in
  (define (bs exp)           ; 'env' is replaced by the corresponding expr (it
    (cond ((const-expr? exp) ; is assumed that the code has been alphatized)
           (quot (const-value exp)))
          ((symbol? exp)
           (let ((x (assq exp env))) 
             (if x (cdr x) exp)))
          ((or (eq? (car exp) 'if) (eq? (car exp) 'begin))
           (cons (car exp) (map bs (cdr exp))))
          ((or (eq? (car exp) 'let) (eq? (car exp) 'letrec))
           (list (car exp)
                 (map (lambda (x) (list (car x) (bs (cadr x)))) (cadr exp))
                 (bs (caddr exp))))
          ((eq? (car exp) 'lambda)
           (list 'lambda
                 (cadr exp)
                 (bs (caddr exp))))
          (else
           (map bs exp))))
  (bs exp))

; The expression simplifier.

(define (simplify! exp)     ; simplify the expression 'exp' destructively (it
                            ; is assumed that the code has been alphatized)
  (define (simp! where env)

    (define (s! where)
      (let ((exp (car where)))

        (cond ((const-expr? exp))  ; leave constants the way they are

              ((symbol? exp))      ; leave variable references the way they are

              ((eq? (car exp) 'if) ; dead code removal for conditionals
               (s! (cdr exp))      ; simplify the predicate
               (if (const-expr? (cadr exp)) ; is the predicate a constant?
                 (begin
                   (set-car! where
                     (if (memq (const-value (cadr exp)) '(#f ())) ; false?
                       (if (= (length exp) 3) ''() (cadddr exp))
                       (caddr exp)))
                   (s! where))
                 (for-each! s! (cddr exp)))) ; simplify consequent and alt.

              ((eq? (car exp) 'begin)
               (for-each! s! (cdr exp))
               (let loop ((exps exp)) ; remove all useless expressions
                 (if (not (null? (cddr exps))) ; not last expression?
                   (let ((x (cadr exps)))
                     (loop (if (or (const-expr? x)
                                   (symbol? x)
                                   (and (pair? x) (eq? (car x) 'lambda)))
                             (begin (set-cdr! exps (cddr exps)) exps)
                             (cdr exps))))))
               (if (null? (cddr exp)) ; only one expression in the begin?
                 (set-car! where (cadr exp))))

              ((or (eq? (car exp) 'let) (eq? (car exp) 'letrec))
               (let ((new-env (cons exp env)))
                 (define (keep i)
                   (if (>= i (length (cadar where)))
                     '()
                     (let* ((var (car (list-ref (cadar where) i)))
                            (val (cadr (assq var (cadar where))))
                            (refs (ref-count (car where) var))
                            (self-refs (ref-count val var))
                            (total-refs (- (car refs) (car self-refs)))
                            (oper-refs (- (cadr refs) (cadr self-refs))))
                       (cond ((= total-refs 0)
                              (keep (+ i 1)))
                             ((or (const-expr? val)
                                  (symbol? val)
                                  (and (pair? val)
                                       (eq? (car val) 'lambda)
                                       (= total-refs 1)
                                       (= oper-refs 1)
                                       (= (car self-refs) 0))
                                  (and (caddr refs)
                                       (= total-refs 1)))
                              (set-car! where
                                (beta-subst (car where)
                                            (list (cons var val))))
                              (keep (+ i 1)))
                             (else
                              (cons var (keep (+ i 1))))))))
                 (simp! (cddr exp) new-env)
                 (for-each! (lambda (x) (simp! (cdar x) new-env)) (cadr exp))
                 (let ((to-keep (keep 0)))
                   (if (< (length to-keep) (length (cadar where)))
                     (begin
                       (if (null? to-keep)
                         (set-car! where (caddar where))
                         (set-car! (cdar where)
                           (map (lambda (v) (assq v (cadar where))) to-keep)))
                       (s! where))
                     (if (null? to-keep)
                       (set-car! where (caddar where)))))))

              ((eq? (car exp) 'lambda)
               (simp! (cddr exp) (cons exp env)))

              (else
               (for-each! s! exp)
               (cond ((symbol? (car exp)) ; is the operator position a var ref?
                      (let ((frame (binding-frame (car exp) env)))
                        (if frame ; is it a bound variable?
                          (let ((proc (bound-expr (car exp) frame)))
                            (if (and (pair? proc)
                                     (eq? (car proc) 'lambda)
                                     (some? const-expr? (cdr exp)))
                              (let* ((args (arg-pattern (cdr exp)))
                                     (new-proc (peval proc args))
                                     (new-args (remove-constant (cdr exp) args)))
                                (set-car! where
                                  (cons (add-binding new-proc frame (car exp))
                                        new-args)))))
                          (set-car! where
                            (constant-fold-global (car exp) (cdr exp))))))
                     ((not (pair? (car exp))))
                     ((eq? (caar exp) 'lambda)
                      (set-car! where
                        (list 'let
                              (map2 list (cadar exp) (cdr exp))
                              (caddar exp)))
                      (s! where)))))))

    (s! where))

  (define (remove-empty-calls! where env)

    (define (rec! where)
      (let ((exp (car where)))

        (cond ((const-expr? exp))
              ((symbol? exp))
              ((eq? (car exp) 'if)
               (rec! (cdr exp))
               (rec! (cddr exp))
               (rec! (cdddr exp)))
              ((eq? (car exp) 'begin)
               (for-each! rec! (cdr exp)))
              ((or (eq? (car exp) 'let) (eq? (car exp) 'letrec))
               (let ((new-env (cons exp env)))
                 (remove-empty-calls! (cddr exp) new-env)
                 (for-each! (lambda (x) (remove-empty-calls! (cdar x) new-env))
                            (cadr exp))))
              ((eq? (car exp) 'lambda)
               (rec! (cddr exp)))
              (else
               (for-each! rec! (cdr exp))
               (if (and (null? (cdr exp)) (symbol? (car exp)))
                 (let ((frame (binding-frame (car exp) env)))
                   (if frame ; is it a bound variable?
                     (let ((proc (bound-expr (car exp) frame)))
                       (if (and (pair? proc)
                                (eq? (car proc) 'lambda))
                         (begin
                           (set! changed? #t)
                           (set-car! where (caddr proc))))))))))))

    (rec! where))

  (define changed? #f)

  (let ((x (list exp)))
    (let loop ()
      (set! changed? #f)
      (simp! x '())
      (remove-empty-calls! x '())
      (if changed? (loop) (car x)))))

(define (ref-count exp var) ; compute how many references to variable 'var'
  (let ((total 0)           ; are contained in 'exp'
        (oper 0)
        (always-evaled #t))
    (define (rc exp ae)
      (cond ((const-expr? exp))
            ((symbol? exp)
             (if (eq? exp var)
               (begin
                 (set! total (+ total 1))
                 (set! always-evaled (and ae always-evaled)))))
            ((eq? (car exp) 'if)
             (rc (cadr exp) ae)
             (for-each (lambda (x) (rc x #f)) (cddr exp)))
            ((eq? (car exp) 'begin)
             (for-each (lambda (x) (rc x ae)) (cdr exp)))
            ((or (eq? (car exp) 'let) (eq? (car exp) 'letrec))
             (for-each (lambda (x) (rc (cadr x) ae)) (cadr exp))
             (rc (caddr exp) ae))
            ((eq? (car exp) 'lambda)
             (rc (caddr exp) #f))
            (else
             (for-each (lambda (x) (rc x ae)) exp)
             (if (symbol? (car exp))
               (if (eq? (car exp) var) (set! oper (+ oper 1)))))))
    (rc exp #t)
    (list total oper always-evaled)))

(define (binding-frame var env)
  (cond ((null? env) #f)
        ((or (eq? (caar env) 'let) (eq? (caar env) 'letrec))
         (if (assq var (cadar env)) (car env) (binding-frame var (cdr env))))
        ((eq? (caar env) 'lambda)
         (if (memq var (cadar env)) (car env) (binding-frame var (cdr env))))
        (else
         (error "ill-formed environment"))))

(define (bound-expr var frame)
  (cond ((or (eq? (car frame) 'let) (eq? (car frame) 'letrec))
         (cadr (assq var (cadr frame))))
        ((eq? (car frame) 'lambda)
         not-constant)
        (else
         (error "ill-formed frame"))))

(define (add-binding val frame name)
  (define (find-val val bindings)
    (cond ((null? bindings) #f)
          ((equal? val (cadar bindings)) ; *kludge* equal? is not exactly what
           (caar bindings))              ; we want...
          (else
           (find-val val (cdr bindings)))))
  (or (find-val val (cadr frame))
      (let ((var (new-variable name)))
        (set-cdr! (get-last-pair (cadr frame)) (list (list var val)))
        var)))

(define (for-each! proc! l) ; call proc! on each CONS CELL in the list 'l'
  (if (not (null? l))
    (begin (proc! l) (for-each! proc! (cdr l)))))

(define (arg-pattern exps) ; return the argument pattern (i.e. the list of
  (if (null? exps)         ; constants in 'exps' but with the not-constant
    '()                    ; value wherever the corresponding expression in
    (cons (if (const-expr? (car exps)) ; 'exps' is not a constant)
            (const-value (car exps))
            not-constant)
          (arg-pattern (cdr exps)))))

; Knowledge about primitive procedures.

(define *primitives*
  (list
    (cons 'car (lambda (args)
                 (and (= (length args) 1)
                      (pair? (car args))
                      (quot (car (car args))))))
    (cons 'cdr (lambda (args)
                 (and (= (length args) 1)
                      (pair? (car args))
                      (quot (cdr (car args))))))
    (cons '+ (lambda (args)
               (and (every? number? args)
                    (quot (sum args 0)))))
    (cons '* (lambda (args)
               (and (every? number? args)
                    (quot (product args 1)))))
    (cons '- (lambda (args)
               (and (> (length args) 0)
                    (every? number? args)
                    (quot (if (null? (cdr args))
                            (- (car args))
                            (- (car args) (sum (cdr args) 0)))))))
    (cons '/ (lambda (args)
               (and (> (length args) 1)
                    (every? number? args)
                    (quot (if (null? (cdr args))
                            (/ (car args))
                            (/ (car args) (product (cdr args) 1)))))))
    (cons '< (lambda (args)
               (and (= (length args) 2)
                    (every? number? args)
                    (quot (< (car args) (cadr args))))))
    (cons '= (lambda (args)
               (and (= (length args) 2)
                    (every? number? args)
                    (quot (= (car args) (cadr args))))))
    (cons '> (lambda (args)
               (and (= (length args) 2)
                    (every? number? args)
                    (quot (> (car args) (cadr args))))))
    (cons 'eq? (lambda (args)
                 (and (= (length args) 2)
                      (quot (eq? (car args) (cadr args))))))
    (cons 'not (lambda (args)
                 (and (= (length args) 1)
                      (quot (not (car args))))))
    (cons 'null? (lambda (args)
                   (and (= (length args) 1)
                        (quot (null? (car args))))))
    (cons 'pair? (lambda (args)
                   (and (= (length args) 1)
                        (quot (pair? (car args))))))
    (cons 'symbol? (lambda (args)
                     (and (= (length args) 1)
                          (quot (symbol? (car args))))))
  )
)

(define (sum lst n)
  (if (null? lst)
    n
    (sum (cdr lst) (+ n (car lst)))))

(define (product lst n)
  (if (null? lst)
    n
    (product (cdr lst) (* n (car lst)))))

(define (reduce-global name args)
  (let ((x (assq name *primitives*)))
    (and x ((cdr x) args))))

(define (constant-fold-global name exprs)

  (define (flatten args op)
    (cond ((null? args)
           '())
          ((and (pair? (car args)) (eq? (caar args) op))
           (append (flatten (cdar args) op) (flatten (cdr args) op)))
          (else
           (cons (car args) (flatten (cdr args) op)))))

  (let ((args (if (or (eq? name '+) (eq? name '*)) ; associative ops
                (flatten exprs name)
                exprs)))
    (or (and (every? const-expr? args)
             (reduce-global name (map const-value args)))
        (let ((pattern (arg-pattern args)))
          (let ((non-const (remove-constant args pattern))
                (const (map const-value (extract-constant args pattern))))
            (cond ((eq? name '+) ; + is commutative
                   (let ((x (reduce-global '+ const)))
                     (if x
                       (let ((y (const-value x)))
                         (cons '+
                               (if (= y 0) non-const (cons x non-const))))
                       (cons name args))))
                  ((eq? name '*) ; * is commutative
                   (let ((x (reduce-global '* const)))
                     (if x
                       (let ((y (const-value x)))
                         (cons '*
                               (if (= y 1) non-const (cons x non-const))))
                       (cons name args))))
                  ((eq? name 'cons)
                   (cond ((and (const-expr? (cadr args))
                               (null? (const-value (cadr args))))
                          (list 'list (car args)))
                         ((and (pair? (cadr args))
                               (eq? (car (cadr args)) 'list))
                          (cons 'list (cons (car args) (cdr (cadr args)))))
                         (else
                          (cons name args))))
                  (else
                   (cons name args))))))))

; Examples:

(define (try-peval proc args)
  (partial-evaluate proc args))

(define example1
  '(lambda (a b c)
     (if (null? a) b (+ (car a) c))))

;(try-peval example1 (list '(10 11) not-constant '1))

(define example2
  '(lambda (x y)
     (let ((q (lambda (a b) (if (< a 0) b (- 10 b)))))
       (if (< x 0) (q (- y) (- x)) (q y x)))))

;(try-peval example2 (list not-constant '1))

(define example3
  '(lambda (l n)
     (letrec ((add-list
               (lambda (l n)
                 (if (null? l)
                   '()
                   (cons (+ (car l) n) (add-list (cdr l) n))))))
       (add-list l n))))

;(try-peval example3 (list not-constant '1))

;(try-peval example3 (list '(1 2 3) not-constant))

(define example4
  '(lambda (exp env)
     (letrec ((eval
               (lambda (exp env)
                 (letrec ((eval-list
                            (lambda (l env)
                              (if (null? l)
                                '()
                                (cons (eval (car l) env)
                                      (eval-list (cdr l) env))))))
                   (if (symbol? exp) (lookup exp env)
                     (if (not (pair? exp)) exp
                       (if (eq? (car exp) 'quote) (car (cdr exp))
                         (apply (eval (car exp) env)
                                (eval-list (cdr exp) env)))))))))
       (eval exp env))))

;(try-peval example4 (list 'x not-constant))

;(try-peval example4 (list '(f 1 2 3) not-constant))

(define example5
  '(lambda (a b)
     (letrec ((funct
               (lambda (x)
                 (+ x b (if (< x 1) 0 (funct (- x 1)))))))
       (funct a))))

;(try-peval example5 (list '5 not-constant))

(define example6
  '(lambda ()
     (letrec ((fib
               (lambda (x)
                 (if (< x 2) x (+ (fib (- x 1)) (fib (- x 2)))))))
       (fib 10))))

;(try-peval example6 '())

(define example7
  '(lambda (input)
     (letrec ((copy (lambda (in)
                      (if (pair? in)
                        (cons (copy (car in))
                              (copy (cdr in)))
                        in))))
       (copy input))))

;(try-peval example7 (list '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))

(define example8
  '(lambda (input)
     (letrec ((reverse (lambda (in result)
                         (if (pair? in)
                           (reverse (cdr in) (cons (car in) result))
                           result))))
       (reverse input '()))))

;(try-peval example8 (list '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))

(define (test1)
  (set! *current-num* 0)
  (pretty-print (try-peval example1 (list '(10 11) not-constant '1)))
  (pretty-print (try-peval example2 (list not-constant '1)))
  (pretty-print (try-peval example3 (list not-constant '1)))
  (pretty-print (try-peval example3 (list '(1 2 3) not-constant)))
  (pretty-print (try-peval example4 (list 'x not-constant)))
  (pretty-print (try-peval example4 (list '(f 1 2 3) not-constant)))
  (pretty-print (try-peval example5 (list '5 not-constant)))
  (pretty-print (try-peval example6 '()))
  (pretty-print (try-peval
                 example7
                 (list '(a b c d e f g h i j k l m n o p q r s t u v w x y z))))
  (pretty-print (try-peval
                 example8
                 (list '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))))

;------------------------------------------------------------------------------

; This second part tests keyword and optional parameters

(##declare (not inline))

(define (show msg proc)
  (display msg)
;(write proc)(newline)'
  (pp proc (current-output-port)))

(define (show2 msg proc)
;(newline)'
  (show msg proc))

(define (try thunk)
  (call-with-current-continuation
    (lambda (cont)
      (with-exception-handler
       (lambda (exc)
         (display "-----> ")
         (write exc)
         (show2 " on " thunk)
         (cont 0))
       (lambda ()
         (write (thunk))
         (show2 " on " thunk))))))

(##define-macro (test form expect)
  `(test-form (lambda () ,form) ',expect))

(define (test-form thunk expect)
  (##gc)
  (if (equal? (thunk) expect)
    (write 'ok)
    (write (list 'expected expect)))
  (newline))

(##define-macro (err form)
  `(let ()
     (##declare (safe) (generic))
     (err-form (lambda () ,form))))

(define (err-form thunk)
  (test-form
    (lambda ()
      (call-with-current-continuation
        (lambda (return)
          (with-exception-handler
           (lambda (exc)
             (continuation-capture
              (lambda (cont)
                (display-exception-in-context-but-not-heap-overflow
                 exc
                 (##continuation-first-frame cont #f)
                 (current-output-port))
                (return 'error))))
           thunk))))
    'error))

(define (display-exception-in-context-but-not-heap-overflow exc cont port)
  (##display-situation
   (##exception->kind exc)
   (##exception->procedure exc cont)
   (if (heap-overflow-exception? exc)
       #f
       (##exception->locat exc cont))
   port)
  (##write-string " -- " port)
  (##display-exception exc port))

(define max-fixnum ##max-fixnum)

(define max-fixnum-plus-1
  (let ()
    (##declare (safe) (generic))
    (+ max-fixnum 1)))

(define max-size-in-bytes-plus-1
  (let ()
    (##declare (safe) (generic))
    (quotient max-fixnum-plus-1 32)))

(define (f1) 'ok)
(define (f2 a) (list a))
(define (f3 . a) (list a))
(define (f4 a . b) (list a b))

(define (f5 a #!optional) (list a))
(define (f6 a #!optional b) (list a b))
(define (f7 a #!optional (b (list a b))) (list a b))

(define (f8 a #!rest b) (list a b))

(define (f9 a #!key) (list a))
(define (f10 a #!key b) (list a b))
(define (f11 a #!key (b (list a b))) (list a b))

(define (f12 a #!optional #!rest b) (list a b))
(define (f13 a #!optional b #!rest c) (list a b c))

(define (f14 a #!optional #!key) (list a))
(define (f15 a #!optional #!key b) (list a b))
(define (f16 a #!optional #!key (b (list a b))) (list a b))
(define (f17 a #!optional b #!key) (list a b))
(define (f18 a #!optional b #!key c) (list a b c))
(define (f19 a #!optional (b (list a b c)) #!key (c (list a b c))) (list a b c))

(define (f20 a #!rest b #!key) (list a b))
(define (f21 a #!rest b #!key c) (list a b c))
(define (f22 a #!rest b #!key (c (list a b c))) (list a b c))

(define (f23 a #!optional #!rest b #!key) (list a b))
(define (f24 a #!optional #!rest b #!key c) (list a b c))
(define (f25 a #!optional #!rest b #!key (c (list a b c))) (list a b c))
(define (f26 a #!optional b #!rest c #!key) (list a b c))
(define (f27 a #!optional (b (list a b c)) #!rest c #!key) (list a b c))
(define (f28 a #!optional b #!rest c #!key d) (list a b c d))
(define (f29 a #!optional (b (list a b c d)) #!rest c #!key (d (list a b c d))) (list a b c d))

(define (f30 a #!optional #!key . b) (list a b))
(define (f31 a #!optional #!key b . c) (list a b c))
(define (f32 a #!optional #!key (b (list a b)) . c) (list a b c))
(define (f33 a #!optional b #!key . c) (list a b c))
(define (f34 a #!optional (b (list a b c)) #!key . c) (list a b c))
(define (f35 a #!optional b #!key c . d) (list a b c d))
(define (f36 a #!optional (b (list a b c d)) #!key (c (list a b c d)) . d) (list a b c d))

(define a #f)
(define b #f)
(define c #f)
(define d #f)

(define (start f)
  (newline)
  (show "" f))

(define (run-f1)
  (start f1)
  (try (lambda () (f1)))
  (try (lambda () (f1 1)))
  (try (lambda () (f1 1 2)))
  (try (lambda () (f1 1 2 3)))
  (try (lambda () (f1 1 2 3 4)))
  (try (lambda () (f1 x: 1 y: 2))))

(define (run-f2)
  (start f2)
  (try (lambda () (f2)))
  (try (lambda () (f2 1)))
  (try (lambda () (f2 1 2)))
  (try (lambda () (f2 1 2 3)))
  (try (lambda () (f2 1 2 3 4)))
  (try (lambda () (f2 1 x: 2 y: 3))))

(define (run-f3)
  (start f3)
  (try (lambda () (f3)))
  (try (lambda () (f3 1)))
  (try (lambda () (f3 1 2)))
  (try (lambda () (f3 1 2 3)))
  (try (lambda () (f3 1 2 3 4)))
  (try (lambda () (f3 x: 1 y: 2))))

(define (run-f4)
  (start f4)
  (try (lambda () (f4)))
  (try (lambda () (f4 1)))
  (try (lambda () (f4 1 2)))
  (try (lambda () (f4 1 2 3)))
  (try (lambda () (f4 1 2 3 4)))
  (try (lambda () (f4 1 x: 2 y: 3))))

(define (run-f5)
  (start f5)
  (try (lambda () (f5)))
  (try (lambda () (f5 1)))
  (try (lambda () (f5 1 2)))
  (try (lambda () (f5 1 2 3)))
  (try (lambda () (f5 1 2 3 4)))
  (try (lambda () (f5 1 x: 2 y: 3))))

(define (run-f6)
  (start f6)
  (try (lambda () (f6)))
  (try (lambda () (f6 1)))
  (try (lambda () (f6 1 2)))
  (try (lambda () (f6 1 2 3)))
  (try (lambda () (f6 1 2 3 4)))
  (try (lambda () (f6 1 2 x: 3 y: 4))))

(define (run-f7)
  (start f7)
  (try (lambda () (f7)))
  (try (lambda () (f7 1)))
  (try (lambda () (f7 1 2)))
  (try (lambda () (f7 1 2 3)))
  (try (lambda () (f7 1 2 3 4)))
  (try (lambda () (f7 1 2 x: 3 y: 4))))

(define (run-f8)
  (start f8)
  (try (lambda () (f8)))
  (try (lambda () (f8 1)))
  (try (lambda () (f8 1 2)))
  (try (lambda () (f8 1 2 3)))
  (try (lambda () (f8 1 2 3 4)))
  (try (lambda () (f8 1 x: 2 y: 3))))

(define (run-f9)
  (start f9)
  (try (lambda () (f9)))
  (try (lambda () (f9 1)))
  (try (lambda () (f9 1 2)))
  (try (lambda () (f9 1 2 3)))
  (try (lambda () (f9 1 x: 2 y: 3))))

(define (run-f10)
  (start f10)
  (try (lambda () (f10)))
  (try (lambda () (f10 1)))
  (try (lambda () (f10 1 2)))
  (try (lambda () (f10 1 2 3)))
  (try (lambda () (f10 1 b: 2)))
  (try (lambda () (f10 1 x: 2)))
  (try (lambda () (f10 1 x: 2 b: 3))))

(define (run-f11)
  (start f11)
  (try (lambda () (f11)))
  (try (lambda () (f11 1)))
  (try (lambda () (f11 1 2)))
  (try (lambda () (f11 1 2 3)))
  (try (lambda () (f11 1 b: 2)))
  (try (lambda () (f11 1 x: 2)))
  (try (lambda () (f11 1 x: 2 b: 3))))

(define (run-f12)
  (start f12)
  (try (lambda () (f12)))
  (try (lambda () (f12 1)))
  (try (lambda () (f12 1 2)))
  (try (lambda () (f12 1 2 3)))
  (try (lambda () (f12 1 x: 2 y: 3))))

(define (run-f13)
  (start f13)
  (try (lambda () (f13)))
  (try (lambda () (f13 1)))
  (try (lambda () (f13 1 2)))
  (try (lambda () (f13 1 2 3)))
  (try (lambda () (f13 1 2 3 4)))
  (try (lambda () (f13 1 2 x: 3 y: 4))))

(define (run-f14)
  (start f14)
  (try (lambda () (f14)))
  (try (lambda () (f14 1)))
  (try (lambda () (f14 1 2)))
  (try (lambda () (f14 1 2 3)))
  (try (lambda () (f14 1 x: 2)))
  (try (lambda () (f14 1 x: 2 y: 3))))

(define (run-f15)
  (start f15)
  (try (lambda () (f15)))
  (try (lambda () (f15 1)))
  (try (lambda () (f15 1 2)))
  (try (lambda () (f15 1 2 3)))
  (try (lambda () (f15 1 b: 2)))
  (try (lambda () (f15 1 x: 2)))
  (try (lambda () (f15 1 x: 2 b: 3))))

(define (run-f16)
  (start f16)
  (try (lambda () (f16)))
  (try (lambda () (f16 1)))
  (try (lambda () (f16 1 2)))
  (try (lambda () (f16 1 2 3)))
  (try (lambda () (f16 1 b: 2)))
  (try (lambda () (f16 1 x: 2)))
  (try (lambda () (f16 1 x: 2 b: 3))))

(define (run-f17)
  (start f17)
  (try (lambda () (f17)))
  (try (lambda () (f17 1)))
  (try (lambda () (f17 1 2)))
  (try (lambda () (f17 1 2 3)))
  (try (lambda () (f17 1 2 3 4)))
  (try (lambda () (f17 1 2 x: 3)))
  (try (lambda () (f17 1 2 x: 3 y: 4))))

(define (run-f18)
  (start f18)
  (try (lambda () (f18)))
  (try (lambda () (f18 1)))
  (try (lambda () (f18 1 2)))
  (try (lambda () (f18 1 2 3)))
  (try (lambda () (f18 1 2 3 4)))
  (try (lambda () (f18 1 2 c: 3)))
  (try (lambda () (f18 1 2 x: 3)))
  (try (lambda () (f18 1 2 x: 3 c: 4))))

(define (run-f19)
  (start f19)
  (try (lambda () (f19)))
  (try (lambda () (f19 1)))
  (try (lambda () (f19 1 2)))
  (try (lambda () (f19 1 2 3)))
  (try (lambda () (f19 1 2 3 4)))
  (try (lambda () (f19 1 2 c: 3)))
  (try (lambda () (f19 1 2 x: 3)))
  (try (lambda () (f19 1 2 x: 3 c: 4))))

(define (run-f20)
  (start f20)
  (try (lambda () (f20)))
  (try (lambda () (f20 1)))
  (try (lambda () (f20 1 2)))
  (try (lambda () (f20 1 2 3)))
  (try (lambda () (f20 1 x: 2 y: 3))))

(define (run-f21)
  (start f21)
  (try (lambda () (f21)))
  (try (lambda () (f21 1)))
  (try (lambda () (f21 1 2)))
  (try (lambda () (f21 1 2 3)))
  (try (lambda () (f21 1 c: 2)))
  (try (lambda () (f21 1 x: 2)))
  (try (lambda () (f21 1 x: 2 c: 3))))

(define (run-f22)
  (start f22)
  (try (lambda () (f22)))
  (try (lambda () (f22 1)))
  (try (lambda () (f22 1 2)))
  (try (lambda () (f22 1 2 3)))
  (try (lambda () (f22 1 c: 2)))
  (try (lambda () (f22 1 x: 2)))
  (try (lambda () (f22 1 x: 2 c: 3))))

(define (run-f23)
  (start f23)
  (try (lambda () (f23)))
  (try (lambda () (f23 1)))
  (try (lambda () (f23 1 2)))
  (try (lambda () (f23 1 2 3)))
  (try (lambda () (f23 1 x: 2 y: 3))))

(define (run-f24)
  (start f24)
  (try (lambda () (f24)))
  (try (lambda () (f24 1)))
  (try (lambda () (f24 1 2)))
  (try (lambda () (f24 1 2 3)))
  (try (lambda () (f24 1 c: 2)))
  (try (lambda () (f24 1 x: 2)))
  (try (lambda () (f24 1 x: 2 c: 3))))

(define (run-f25)
  (start f25)
  (try (lambda () (f25)))
  (try (lambda () (f25 1)))
  (try (lambda () (f25 1 2)))
  (try (lambda () (f25 1 2 3)))
  (try (lambda () (f25 1 c: 2)))
  (try (lambda () (f25 1 x: 2)))
  (try (lambda () (f25 1 x: 2 c: 3))))

(define (run-f26)
  (start f26)
  (try (lambda () (f26)))
  (try (lambda () (f26 1)))
  (try (lambda () (f26 1 2)))
  (try (lambda () (f26 1 2 3)))
  (try (lambda () (f26 1 2 3 4)))
  (try (lambda () (f26 1 2 x: 3 y: 4))))

(define (run-f27)
  (start f27)
  (try (lambda () (f27)))
  (try (lambda () (f27 1)))
  (try (lambda () (f27 1 2)))
  (try (lambda () (f27 1 2 3)))
  (try (lambda () (f27 1 2 3 4)))
  (try (lambda () (f27 1 2 c: 3)))
  (try (lambda () (f27 1 2 x: 3)))
  (try (lambda () (f27 1 2 x: 3 c: 4))))

(define (run-f28)
  (start f28)
  (try (lambda () (f28)))
  (try (lambda () (f28 1)))
  (try (lambda () (f28 1 2)))
  (try (lambda () (f28 1 2 3)))
  (try (lambda () (f28 1 2 3 4)))
  (try (lambda () (f28 1 2 c: 3)))
  (try (lambda () (f28 1 2 x: 3)))
  (try (lambda () (f28 1 2 x: 3 c: 4))))

(define (run-f29)
  (start f29)
  (try (lambda () (f29)))
  (try (lambda () (f29 1)))
  (try (lambda () (f29 1 2)))
  (try (lambda () (f29 1 2 3)))
  (try (lambda () (f29 1 2 3 4)))
  (try (lambda () (f29 1 2 c: 3)))
  (try (lambda () (f29 1 2 x: 3)))
  (try (lambda () (f29 1 2 x: 3 c: 4))))

(define (run-f30)
  (start f30)
  (try (lambda () (f30)))
  (try (lambda () (f30 1)))
  (try (lambda () (f30 1 2)))
  (try (lambda () (f30 1 2 3)))
  (try (lambda () (f30 1 x: 2 y: 3))))

(define (run-f31)
  (start f31)
  (try (lambda () (f31)))
  (try (lambda () (f31 1)))
  (try (lambda () (f31 1 2)))
  (try (lambda () (f31 1 2 3)))
  (try (lambda () (f31 1 b: 2)))
  (try (lambda () (f31 1 b: 2 b:)))
  (try (lambda () (f31 1 b: 2 b: 3)))
  (try (lambda () (f31 1 b: 2 b: 3 4)))
  (try (lambda () (f31 1 b: 2 b: 3 4 5)))
  (try (lambda () (f31 1 x: 2)))
  (try (lambda () (f31 1 x: 2 b: 3))))

(define (run-f32)
  (start f32)
  (try (lambda () (f32)))
  (try (lambda () (f32 1)))
  (try (lambda () (f32 1 2)))
  (try (lambda () (f32 1 2 3)))
  (try (lambda () (f32 1 b: 2)))
  (try (lambda () (f32 1 b: 2 b:)))
  (try (lambda () (f32 1 b: 2 b: 3)))
  (try (lambda () (f32 1 b: 2 b: 3 4)))
  (try (lambda () (f32 1 b: 2 b: 3 4 5)))
  (try (lambda () (f32 1 x: 2)))
  (try (lambda () (f32 1 x: 2 b: 3))))

(define (run-f33)
  (start f33)
  (try (lambda () (f33)))
  (try (lambda () (f33 1)))
  (try (lambda () (f33 1 2)))
  (try (lambda () (f33 1 2 3)))
  (try (lambda () (f33 1 2 3 4)))
  (try (lambda () (f33 1 2 x: 3 y: 4))))

(define (run-f34)
  (start f34)
  (try (lambda () (f34)))
  (try (lambda () (f34 1)))
  (try (lambda () (f34 1 2)))
  (try (lambda () (f34 1 2 3)))
  (try (lambda () (f34 1 2 3 4)))
  (try (lambda () (f34 1 2 c: 3)))
  (try (lambda () (f34 1 2 x: 3)))
  (try (lambda () (f34 1 2 x: 3 c: 4))))

(define (run-f35)
  (start f35)
  (try (lambda () (f35)))
  (try (lambda () (f35 1)))
  (try (lambda () (f35 1 2)))
  (try (lambda () (f35 1 2 3)))
  (try (lambda () (f35 1 2 3 4)))
  (try (lambda () (f35 1 2 c: 3)))
  (try (lambda () (f35 1 2 c: 3 c:)))
  (try (lambda () (f35 1 2 c: 3 c: 4)))
  (try (lambda () (f35 1 2 c: 3 c: 4 5)))
  (try (lambda () (f35 1 2 c: 3 c: 4 5 6)))
  (try (lambda () (f35 1 2 x: 3)))
  (try (lambda () (f35 1 2 x: 3 c: 4))))

(define (run-f36)
  (start f36)
  (try (lambda () (f36)))
  (try (lambda () (f36 1)))
  (try (lambda () (f36 1 2)))
  (try (lambda () (f36 1 2 3)))
  (try (lambda () (f36 1 2 3 4)))
  (try (lambda () (f36 1 2 c: 3)))
  (try (lambda () (f36 1 2 c: 3 c:)))
  (try (lambda () (f36 1 2 c: 3 c: 4)))
  (try (lambda () (f36 1 2 c: 3 c: 4 5)))
  (try (lambda () (f36 1 2 c: 3 c: 4 5 6)))
  (try (lambda () (f36 1 2 x: 3)))
  (try (lambda () (f36 1 2 x: 3 c: 4))))

(define (test2)

  (set! a 6)
  (set! b 7)
  (set! c 8)
  (set! d 9)

  (run-f1)
  (run-f2)
  (run-f3)
  (run-f4)
  (run-f5)
  (run-f6)
  (run-f7)
  (run-f8)
  (run-f9)
  (run-f10)
  (run-f11)
  (run-f12)
  (run-f13)
  (run-f14)
  (run-f15)
  (run-f16)
  (run-f17)
  (run-f18)
  (run-f19)
  (run-f20)
  (run-f21)
  (run-f22)
  (run-f23)
  (run-f24)
  (run-f25)
  (run-f26)
  (run-f27)
  (run-f28)
  (run-f29)
  (run-f30)
  (run-f31)
  (run-f32)
  (run-f33)
  (run-f34)
  (run-f35)
  (run-f36))

;------------------------------------------------------------------------------

; This third part tests primitives on vector-like objects

(##declare
  (not standard-bindings)
  (not extended-bindings)
  (generic)
)

(define (run-strings)
  (test (string? "5678") #t)
  (test (string? 123456789012345678901) #f)
  (test (make-string 0) "")
  (test (make-string 3) "\0\0\0")
  (test (make-string 5 #\6) "66666")
  (test (string-length (make-string 4194303)) 4194303)
  (test (string) "")
  (test (string #\5 #\6) "56")
  (test (string-length "5678") 4)
  (test (string-ref "5678" 3) #\8)
  (test (let ((x (string #\5 #\6))) (string-set! x 1 #\3) x) "53")
  (test (string->list "56") (#\5 #\6))
  (test (list->string '(#\5 #\6)) "56")
  (err (make-string -1))
  (err (make-string (quotient max-size-in-bytes-plus-1 string-char-size)))
  (err (make-string max-fixnum))
  (err (make-string 123456789012345678901))
  (err (make-string 1.5))
  (err (make-string 1 'a))
  (err (string #\5 'b))
  (err (string-length 123456789012345678901))
  (err (string-ref 123456789012345678901 0))
  (err (string-ref "56" -1))
  (err (string-ref "56" 2))
  (err (string-ref "56" 123456789012345678901))
  (err (string-set! 123456789012345678901 0 #\3))
  (err (let ((x (string #\5 #\6))) (string-set! x -1 #\3) x))
  (err (let ((x (string #\5 #\6))) (string-set! x 2 #\3) x))
  (err (let ((x (string #\5 #\6))) (string-set! x 123456789012345678901 #\3) x))
  (err (let ((x (string #\5 #\6))) (string-set! x 1 'a) x))
  (err (string->list 123456789012345678901))
  (err (list->string 123456789012345678901))
  (err (list->string '(#\5 b))))

(define (run-vectors)
  (test (vector? '#(5 6 7 8)) #t)
  (test (vector? 123456789012345678901) #f)
  (test (make-vector 0) #())
  (test (make-vector 3) #(0 0 0))
  (test (make-vector 5 'a) #(a a a a a))
  (let ((n (quotient 16777215 word-size))) (test (= n (vector-length (make-vector n))) #t))
  (test (vector) #())
  (test (vector 5 'b) #(5 b))
  (test (vector-length '#(5 6 7 8)) 4)
  (test (vector-ref '#(5 6 7 8) 3) 8)
  (test (let ((x (vector 5 6))) (vector-set! x 1 3) x) #(5 3))
  (test (vector->list '#(5 6)) (5 6))
  (test (list->vector '(5 b)) #(5 b))
  (err (make-vector -1))
  (let ((n (quotient max-size-in-bytes-plus-1 word-size))) (err (make-vector n)))
  (err (make-vector max-fixnum))
  (err (make-vector 123456789012345678901))
  (err (make-vector 1.5))
  (err (vector-length 123456789012345678901))
  (err (vector-ref 123456789012345678901 0))
  (err (vector-ref '#(5 6) -1))
  (err (vector-ref '#(5 6) 2))
  (err (vector-ref '#(5 6) 123456789012345678901))
  (err (vector-set! 123456789012345678901 0 3))
  (err (let ((x (vector 5 6))) (vector-set! x -1 3) x))
  (err (let ((x (vector 5 6))) (vector-set! x 2 3) x))
  (err (let ((x (vector 5 6))) (vector-set! x 123456789012345678901 3) x))
  (err (vector->list 123456789012345678901))
  (err (list->vector 123456789012345678901)))

(define (run-s8vectors)
  (test (s8vector? '#s8(5 6 7 8)) #t)
  (test (s8vector? 123456789012345678901) #f)
  (test (make-s8vector 0) #s8())
  (test (make-s8vector 3) #s8(0 0 0))
  (test (make-s8vector 5 6) #s8(6 6 6 6 6))
  (test (s8vector-length (make-s8vector 16777215)) 16777215)
  (test (s8vector) #s8())
  (test (s8vector -128 127) #s8(-128 127))
  (test (s8vector-length '#s8(5 6 7 8)) 4)
  (test (s8vector-ref '#s8(5 6 7 8) 3) 8)
  (test (let ((x (s8vector 5 6))) (s8vector-set! x 1 127) x) #s8(5 127))
  (test (s8vector->list '#s8(5 6)) (5 6))
  (test (list->s8vector '(-128 127)) #s8(-128 127))
  (err (make-s8vector -1))
  (err (make-s8vector max-size-in-bytes-plus-1))
  (err (make-s8vector max-fixnum))
  (err (make-s8vector 123456789012345678901))
  (err (make-s8vector 1.5))
  (err (make-s8vector 1 'a))
  (err (s8vector 5 'b))
  (err (s8vector-length 123456789012345678901))
  (err (s8vector-ref 123456789012345678901 0))
  (err (s8vector-ref '#s8(5 6) -1))
  (err (s8vector-ref '#s8(5 6) 2))
  (err (s8vector-ref '#s8(5 6) 123456789012345678901))
  (err (s8vector-set! 123456789012345678901 0 3))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x -1 3) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 2 3) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 123456789012345678901 3) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 1 -129) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 1 128) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 1 123456789012345678901) x))
  (err (let ((x (s8vector 5 6))) (s8vector-set! x 1 'a) x))
  (err (s8vector->list 123456789012345678901))
  (err (list->s8vector 123456789012345678901))
  (err (list->s8vector '(5 b)))
  (err (list->s8vector '(128))))

(define (run-u8vectors)
  (test (u8vector? '#u8(5 6 7 8)) #t)
  (test (u8vector? 123456789012345678901) #f)
  (test (make-u8vector 0) #u8())
  (test (make-u8vector 3) #u8(0 0 0))
  (test (make-u8vector 5 6) #u8(6 6 6 6 6))
  (test (u8vector-length (make-u8vector 16777215)) 16777215)
  (test (u8vector) #u8())
  (test (u8vector 0 255) #u8(0 255))
  (test (u8vector-length '#u8(5 6 7 8)) 4)
  (test (u8vector-ref '#u8(5 6 7 8) 3) 8)
  (test (let ((x (u8vector 5 6))) (u8vector-set! x 1 255) x) #u8(5 255))
  (test (u8vector->list '#u8(5 6)) (5 6))
  (test (list->u8vector '(0 255)) #u8(0 255))
  (err (make-u8vector -1))
  (err (make-u8vector max-size-in-bytes-plus-1))
  (err (make-u8vector max-fixnum))
  (err (make-u8vector 123456789012345678901))
  (err (make-u8vector 1.5))
  (err (make-u8vector 1 'a))
  (err (u8vector 5 'b))
  (err (u8vector-length 123456789012345678901))
  (err (u8vector-ref 123456789012345678901 0))
  (err (u8vector-ref '#u8(5 6) -1))
  (err (u8vector-ref '#u8(5 6) 2))
  (err (u8vector-ref '#u8(5 6) 123456789012345678901))
  (err (u8vector-set! 123456789012345678901 0 3))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x -1 3) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 2 3) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 123456789012345678901 3) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 1 -1) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 1 256) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 1 123456789012345678901) x))
  (err (let ((x (u8vector 5 6))) (u8vector-set! x 1 'a) x))
  (err (u8vector->list 123456789012345678901))
  (err (list->u8vector 123456789012345678901))
  (err (list->u8vector '(5 b)))
  (err (list->u8vector '(256))))

(define (run-s16vectors)
  (test (s16vector? '#s16(5 6 7 8)) #t)
  (test (s16vector? 123456789012345678901) #f)
  (test (make-s16vector 0) #s16())
  (test (make-s16vector 3) #s16(0 0 0))
  (test (make-s16vector 5 6) #s16(6 6 6 6 6))
  (test (s16vector-length (make-s16vector 8388607)) 8388607)
  (test (s16vector) #s16())
  (test (s16vector -32768 32767) #s16(-32768 32767))
  (test (s16vector-length '#s16(5 6 7 8)) 4)
  (test (s16vector-ref '#s16(5 6 7 8) 3) 8)
  (test (let ((x (s16vector 5 6))) (s16vector-set! x 1 32767) x) #s16(5 32767))
  (test (s16vector->list '#s16(5 6)) (5 6))
  (test (list->s16vector '(-32768 32767)) #s16(-32768 32767))
  (err (make-s16vector -1))
  (err (make-s16vector (quotient max-size-in-bytes-plus-1 2)))
  (err (make-s16vector max-fixnum))
  (err (make-s16vector 123456789012345678901))
  (err (make-s16vector 1.5))
  (err (make-s16vector 1 'a))
  (err (s16vector 5 'b))
  (err (s16vector-length 123456789012345678901))
  (err (s16vector-ref 123456789012345678901 0))
  (err (s16vector-ref '#s16(5 6) -1))
  (err (s16vector-ref '#s16(5 6) 2))
  (err (s16vector-ref '#s16(5 6) 123456789012345678901))
  (err (s16vector-set! 123456789012345678901 0 3))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x -1 3) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 2 3) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 123456789012345678901 3) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 1 -32769) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 1 32768) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 1 123456789012345678901) x))
  (err (let ((x (s16vector 5 6))) (s16vector-set! x 1 'a) x))
  (err (s16vector->list 123456789012345678901))
  (err (list->s16vector 123456789012345678901))
  (err (list->s16vector '(5 b)))
  (err (list->s16vector '(32768))))

(define (run-u16vectors)
  (test (u16vector? '#u16(5 6 7 8)) #t)
  (test (u16vector? 123456789012345678901) #f)
  (test (make-u16vector 0) #u16())
  (test (make-u16vector 3) #u16(0 0 0))
  (test (make-u16vector 5 6) #u16(6 6 6 6 6))
  (test (u16vector-length (make-u16vector 8388607)) 8388607)
  (test (u16vector) #u16())
  (test (u16vector 0 65535) #u16(0 65535))
  (test (u16vector-length '#u16(5 6 7 8)) 4)
  (test (u16vector-ref '#u16(5 6 7 8) 3) 8)
  (test (let ((x (u16vector 5 6))) (u16vector-set! x 1 65535) x) #u16(5 65535))
  (test (u16vector->list '#u16(5 6)) (5 6))
  (test (list->u16vector '(0 65535)) #u16(0 65535))
  (err (make-u16vector -1))
  (err (make-u16vector (quotient max-size-in-bytes-plus-1 2)))
  (err (make-u16vector max-fixnum))
  (err (make-u16vector 123456789012345678901))
  (err (make-u16vector 1.5))
  (err (make-u16vector 1 'a))
  (err (u16vector 5 'b))
  (err (u16vector-length 123456789012345678901))
  (err (u16vector-ref 123456789012345678901 0))
  (err (u16vector-ref '#u16(5 6) -1))
  (err (u16vector-ref '#u16(5 6) 2))
  (err (u16vector-ref '#u16(5 6) 123456789012345678901))
  (err (u16vector-set! 123456789012345678901 0 3))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x -1 3) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 2 3) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 123456789012345678901 3) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 1 -1) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 1 65536) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 1 123456789012345678901) x))
  (err (let ((x (u16vector 5 6))) (u16vector-set! x 1 'a) x))
  (err (u16vector->list 123456789012345678901))
  (err (list->u16vector 123456789012345678901))
  (err (list->u16vector '(5 b)))
  (err (list->u16vector '(65536))))

(define (run-s32vectors)
  (test (s32vector? '#s32(5 6 7 8)) #t)
  (test (s32vector? 123456789012345678901) #f)
  (test (make-s32vector 0) #s32())
  (test (make-s32vector 3) #s32(0 0 0))
  (test (make-s32vector 5 6) #s32(6 6 6 6 6))
  (test (s32vector-length (make-s32vector 4194303)) 4194303)
  (test (s32vector) #s32())
  (test (s32vector -2147483648 2147483647) #s32(-2147483648 2147483647))
  (test (s32vector-length '#s32(5 6 7 8)) 4)
  (test (s32vector-ref '#s32(5 6 7 8) 3) 8)
  (test (let ((x (s32vector 5 6))) (s32vector-set! x 1 2147483647) x) #s32(5 2147483647))
  (test (s32vector->list '#s32(5 6)) (5 6))
  (test (s32vector->list (s32vector (- (expt 2 31)) (- -1 (expt 2 29)) (- (expt 2 29)) (- (expt 2 29) 1) (expt 2 29) (- (expt 2 31) 1))) (-2147483648 -536870913 -536870912 536870911 536870912 2147483647))
  (test (list->s32vector '(-2147483648 2147483647)) #s32(-2147483648 2147483647))
  (err (make-s32vector -1))
  (err (make-s32vector (quotient max-size-in-bytes-plus-1 4)))
  (err (make-s32vector max-fixnum))
  (err (make-s32vector 123456789012345678901))
  (err (make-s32vector 1.5))
  (err (make-s32vector 1 'a))
  (err (s32vector 5 'b))
  (err (s32vector-length 123456789012345678901))
  (err (s32vector-ref 123456789012345678901 0))
  (err (s32vector-ref '#s32(5 6) -1))
  (err (s32vector-ref '#s32(5 6) 2))
  (err (s32vector-ref '#s32(5 6) 123456789012345678901))
  (err (s32vector-set! 123456789012345678901 0 3))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x -1 3) x))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x 2 3) x))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x 123456789012345678901 3) x))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x 1 -2147483649) x))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x 1 2147483648) x))
  (err (let ((x (s32vector 5 6))) (s32vector-set! x 1 'a) x))
  (err (s32vector->list 123456789012345678901))
  (err (list->s32vector 123456789012345678901))
  (err (list->s32vector '(5 b)))
  (err (list->s32vector '(2147483648))))

(define (run-u32vectors)
  (test (u32vector? '#u32(5 6 7 8)) #t)
  (test (u32vector? 123456789012345678901) #f)
  (test (make-u32vector 0) #u32())
  (test (make-u32vector 3) #u32(0 0 0))
  (test (make-u32vector 5 6) #u32(6 6 6 6 6))
  (test (u32vector-length (make-u32vector 4194303)) 4194303)
  (test (u32vector) #u32())
  (test (u32vector 0 4294967295) #u32(0 4294967295))
  (test (u32vector-length '#u32(5 6 7 8)) 4)
  (test (u32vector-ref '#u32(5 6 7 8) 3) 8)
  (test (let ((x (u32vector 5 6))) (u32vector-set! x 1 4294967295) x) #u32(5 4294967295))
  (test (u32vector->list '#u32(5 6)) (5 6))
  (test (u32vector->list (u32vector (- (expt 2 29) 1) (expt 2 29) (- (expt 2 31) 1) (expt 2 31) (- (expt 2 32) 1))) (536870911 536870912 2147483647 2147483648 4294967295))
  (test (list->u32vector '(0 4294967295)) #u32(0 4294967295))
  (err (make-u32vector -1))
  (err (make-u32vector (quotient max-size-in-bytes-plus-1 4)))
  (err (make-u32vector max-fixnum))
  (err (make-u32vector 123456789012345678901))
  (err (make-u32vector 1.5))
  (err (make-u32vector 1 'a))
  (err (u32vector 5 'b))
  (err (u32vector-length 123456789012345678901))
  (err (u32vector-ref 123456789012345678901 0))
  (err (u32vector-ref '#u32(5 6) -1))
  (err (u32vector-ref '#u32(5 6) 2))
  (err (u32vector-ref '#u32(5 6) 123456789012345678901))
  (err (u32vector-set! 123456789012345678901 0 3))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x -1 3) x))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x 2 3) x))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x 123456789012345678901 3) x))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x 1 -1) x))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x 1 4294967296) x))
  (err (let ((x (u32vector 5 6))) (u32vector-set! x 1 'a) x))
  (err (u32vector->list 123456789012345678901))
  (err (list->u32vector 123456789012345678901))
  (err (list->u32vector '(5 b)))
  (err (list->u32vector '(4294967296))))

(define (run-s64vectors)
  (test (s64vector? '#s64(5 6 7 8)) #t)
  (test (s64vector? 123456789012345678901) #f)
  (test (make-s64vector 0) #s64())
  (test (make-s64vector 3) #s64(0 0 0))
  (test (make-s64vector 5 6) #s64(6 6 6 6 6))
  (test (s64vector-length (make-s64vector 2097151)) 2097151)
  (test (s64vector) #s64())
  (test (s64vector -9223372036854775808 9223372036854775807) #s64(-9223372036854775808 9223372036854775807))
  (test (s64vector-length '#s64(5 6 7 8)) 4)
  (test (s64vector-ref '#s64(5 6 7 8) 3) 8)
  (test (let ((x (s64vector 5 6))) (s64vector-set! x 1 9223372036854775807) x) #s64(5 9223372036854775807))
  (test (s64vector->list '#s64(5 6)) (5 6))
  (test (s64vector->list (s64vector (- (expt 2 63)) (- -1 (expt 2 61)) (- (expt 2 61)) (- -1 (expt 2 29)) (- (expt 2 29)) (- (expt 2 29) 1) (expt 2 29) (expt 2 31) (- (expt 2 61) 1) (expt 2 61) (- (expt 2 63) 1))) (-9223372036854775808 -2305843009213693953 -2305843009213693952 -536870913 -536870912 536870911 536870912 2147483648 2305843009213693951 2305843009213693952 9223372036854775807))
  (test (list->s64vector '(-9223372036854775808 9223372036854775807)) #s64(-9223372036854775808 9223372036854775807))
  (err (make-s64vector -1))
  (err (make-s64vector (quotient max-size-in-bytes-plus-1 4)))
  (err (make-s64vector max-fixnum))
  (err (make-s64vector 123456789012345678901))
  (err (make-s64vector 1.5))
  (err (make-s64vector 1 'a))
  (err (s64vector 5 'b))
  (err (s64vector-length 123456789012345678901))
  (err (s64vector-ref 123456789012345678901 0))
  (err (s64vector-ref '#s64(5 6) -1))
  (err (s64vector-ref '#s64(5 6) 2))
  (err (s64vector-ref '#s64(5 6) 123456789012345678901))
  (err (s64vector-set! 123456789012345678901 0 3))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x -1 3) x))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x 2 3) x))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x 123456789012345678901 3) x))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x 1 -9223372036854775809) x))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x 1 9223372036854775808) x))
  (err (let ((x (s64vector 5 6))) (s64vector-set! x 1 'a) x))
  (err (s64vector->list 123456789012345678901))
  (err (list->s64vector 123456789012345678901))
  (err (list->s64vector '(5 b)))
  (err (list->s64vector '(9223372036854775808))))

(define (run-u64vectors)
  (test (u64vector? '#u64(5 6 7 8)) #t)
  (test (u64vector? 123456789012345678901) #f)
  (test (make-u64vector 0) #u64())
  (test (make-u64vector 3) #u64(0 0 0))
  (test (make-u64vector 5 6) #u64(6 6 6 6 6))
  (test (u64vector-length (make-u64vector 2097151)) 2097151)
  (test (u64vector) #u64())
  (test (u64vector 0 18446744073709551615) #u64(0 18446744073709551615))
  (test (u64vector-length '#u64(5 6 7 8)) 4)
  (test (u64vector-ref '#u64(5 6 7 8) 3) 8)
  (test (let ((x (u64vector 5 6))) (u64vector-set! x 1 18446744073709551615) x) #u64(5 18446744073709551615))
  (test (u64vector->list '#u64(5 6)) (5 6))
  (test (u64vector->list (u64vector (- (expt 2 29) 1) (expt 2 29) (expt 2 31) (- (expt 2 61) 1) (expt 2 61) (- (expt 2 63) 1) (expt 2 63) (- (expt 2 64) 1))) (536870911 536870912 2147483648 2305843009213693951 2305843009213693952 9223372036854775807 9223372036854775808 18446744073709551615))
  (test (list->u64vector '(0 18446744073709551615)) #u64(0 18446744073709551615))
  (err (make-u64vector -1))
  (err (make-u64vector (quotient max-size-in-bytes-plus-1 4)))
  (err (make-u64vector max-fixnum))
  (err (make-u64vector 123456789012345678901))
  (err (make-u64vector 1.5))
  (err (make-u64vector 1 'a))
  (err (u64vector 5 'b))
  (err (u64vector-length 123456789012345678901))
  (err (u64vector-ref 123456789012345678901 0))
  (err (u64vector-ref '#u64(5 6) -1))
  (err (u64vector-ref '#u64(5 6) 2))
  (err (u64vector-ref '#u64(5 6) 123456789012345678901))
  (err (u64vector-set! 123456789012345678901 0 3))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x -1 3) x))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x 2 3) x))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x 123456789012345678901 3) x))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x 1 -1) x))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x 1 18446744073709551616) x))
  (err (let ((x (u64vector 5 6))) (u64vector-set! x 1 'a) x))
  (err (u64vector->list 123456789012345678901))
  (err (list->u64vector 123456789012345678901))
  (err (list->u64vector '(5 b)))
  (err (list->u64vector '(18446744073709551616))))

(define (run-f32vectors)
  (test (f32vector? '#f32(5. 6. 7. 8.)) #t)
  (test (f32vector? 123456789012345678901) #f)
  (test (make-f32vector 0) #f32())
  (test (make-f32vector 3) #f32(0. 0. 0.))
  (test (make-f32vector 5 6.) #f32(6. 6. 6. 6. 6.))
  (test (f32vector-length (make-f32vector 4194303)) 4194303)
  (test (f32vector) #f32())
  (test (f32vector 5. 6.) #f32(5. 6.))
  (test (f32vector-length '#f32(5. 6. 7. 8.)) 4)
  (test (f32vector-ref '#f32(5. 6. 7. 8.) 3) 8.)
  (test (let ((x (f32vector 5. 6.))) (f32vector-set! x 1 3.) x) #f32(5. 3.))
  (test (f32vector->list '#f32(5. 6.)) (5. 6.))
  (test (list->f32vector '(5. 6.)) #f32(5. 6.))
  (err (make-f32vector -1))
  (err (make-f32vector (quotient max-size-in-bytes-plus-1 4)))
  (err (make-f32vector max-fixnum))
  (err (make-f32vector 123456789012345678901))
  (err (make-f32vector 1.5))
  (err (make-f32vector 1 'a))
  (err (f32vector 5. 'b))
  (err (f32vector-length 123456789012345678901))
  (err (f32vector-ref 123456789012345678901 0))
  (err (f32vector-ref '#f32(5. 6.) -1))
  (err (f32vector-ref '#f32(5. 6.) 2))
  (err (f32vector-ref '#f32(5. 6.) 123456789012345678901))
  (err (f32vector-set! 123456789012345678901 0 3.))
  (err (let ((x (f32vector 5. 6.))) (f32vector-set! x -1 3.) x))
  (err (let ((x (f32vector 5. 6.))) (f32vector-set! x 2 3.) x))
  (err (let ((x (f32vector 5. 6.))) (f32vector-set! x 123456789012345678901 3.) x))
  (err (let ((x (f32vector 5. 6.))) (f32vector-set! x 1 'a) x))
  (err (f32vector->list 123456789012345678901))
  (err (list->f32vector 123456789012345678901))
  (err (list->f32vector '(5. b))))

(define (run-f64vectors)
  (test (f64vector? '#f64(5. 6. 7. 8.)) #t)
  (test (f64vector? 123456789012345678901) #f)
  (test (make-f64vector 0) #f64())
  (test (make-f64vector 3) #f64(0. 0. 0.))
  (test (make-f64vector 5 6.) #f64(6. 6. 6. 6. 6.))
  (test (f32vector-length (make-f32vector 2097151)) 2097151)
  (test (f64vector) #f64())
  (test (f64vector 5. 6.) #f64(5. 6.))
  (test (f64vector-length '#f64(5. 6. 7. 8.)) 4)
  (test (f64vector-ref '#f64(5. 6. 7. 8.) 3) 8.)
  (test (let ((x (f64vector 5. 6.))) (f64vector-set! x 1 3.) x) #f64(5. 3.))
  (test (f64vector->list '#f64(5. 6.)) (5. 6.))
  (test (list->f64vector '(5. 6.)) #f64(5. 6.))
  (err (make-f64vector -1))
  (err (make-f64vector (quotient max-size-in-bytes-plus-1 8)))
  (err (make-f64vector max-fixnum))
  (err (make-f64vector 123456789012345678901))
  (err (make-f64vector 1.5))
  (err (make-f64vector 1 'a))
  (err (f64vector 5. 'b))
  (err (f64vector-length 123456789012345678901))
  (err (f64vector-ref 123456789012345678901 0))
  (err (f64vector-ref '#f64(5. 6.) -1))
  (err (f64vector-ref '#f64(5. 6.) 2))
  (err (f64vector-ref '#f64(5. 6.) 123456789012345678901))
  (err (f64vector-set! 123456789012345678901 0 3.))
  (err (let ((x (f64vector 5. 6.))) (f64vector-set! x -1 3.) x))
  (err (let ((x (f64vector 5. 6.))) (f64vector-set! x 2 3.) x))
  (err (let ((x (f64vector 5. 6.))) (f64vector-set! x 123456789012345678901 3.) x))
  (err (let ((x (f64vector 5. 6.))) (f64vector-set! x 1 'a) x))
  (err (f64vector->list 123456789012345678901))
  (err (list->f64vector 123456789012345678901))
  (err (list->f64vector '(5. b))))

(define (test3)
  (run-strings)
  (run-vectors)
  (run-s8vectors)
  (run-u8vectors)
  (run-s16vectors)
  (run-u16vectors)
  (run-s32vectors)
  (run-u32vectors)
  (run-s64vectors)
  (run-u64vectors)
  (run-f32vectors)
  (run-f64vectors))

;------------------------------------------------------------------------------

; This fourth part is the "PI" benchmark (compute pi)

(##declare
  (standard-bindings)
  (extended-bindings)
  (safe)
  (generic)
)

; See http://www.astro.virginia.edu/~eww6n/math/Pi.html for the various
; algorithms.

; Utilities.

(define (width x)
  (let loop ((i 0) (n 1))
    (if (< x n) i (loop (+ i 1) (* n 2)))))

(define (root x y)
  (let loop ((g (expt 2 (quotient (+ (width x) (- y 1)) y))))
    (let ((a (expt g (- y 1))))
      (let ((b (* a y)))
        (let ((c (* a (- y 1))))
          (let ((d (quotient (+ x (* g c)) b)))
            (if (< d g) (loop d) g)))))))

(define (square-root x)
  (root x 2))

(define (quartic-root x)
  (root x 4))

;;(define (square x)
;;  (* x x))

; Compute pi using the 'brent-salamin' method.

(define (pi-brent-salamin nb-digits)
  (let ((one (expt 10 nb-digits)))
    (let loop ((a one)
               (b (square-root (quotient (* one one) 2)))
               (t (quotient one 4))
               (x 1))
      (if (= a b)
          (quotient (square (+ a b)) (* 4 t))
          (let ((new-a (quotient (+ a b) 2)))
            (loop new-a
                  (square-root (* a b))
                  (- t (quotient (* x (square (- new-a a))) one))
                  (* 2 x)))))))

; Compute pi using the quadratically converging 'borwein' method.

(define (pi-borwein2 nb-digits)
  (let* ((one (expt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (* one^2 2)))
         (qurt2 (quartic-root (* one^4 2))))
    (let loop ((x (quotient (* one (+ sqrt2 one)) (* 2 qurt2)))
               (y qurt2)
               (p (+ (* 2 one) sqrt2)))
      (let ((new-p (quotient (* p (+ x one)) (+ y one))))
        (if (= x one)
            new-p
            (let ((sqrt-x (square-root (* one x))))
              (loop (quotient (* one (+ x one)) (* 2 sqrt-x))
                    (quotient (* one (+ (* x y) one^2)) (* (+ y one) sqrt-x))
                    new-p)))))))

; Compute pi using the quartically converging 'borwein' method.

(define (pi-borwein4 nb-digits)
  (let* ((one (expt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (* one^2 2))))
    (let loop ((y (- sqrt2 one))
               (a (- (* 6 one) (* 4 sqrt2)))
               (x 8))
      (if (= y 0)
          (quotient one^2 a)
          (let* ((t1 (quartic-root (- one^4 (square (square y)))))
                 (t2 (quotient (* one (- one t1)) (+ one t1)))
                 (t3 (quotient (square (quotient (square (+ one t2)) one)) one))
                 (t4 (+ one (+ t2 (quotient (square t2) one)))))
            (loop t2
                  (quotient (- (* t3 a) (* x (* t2 t4))) one)
                  (* 4 x)))))))

; Try it.

(define (pies n m s)
  (if (< m n)
      '()
      (let ((bs (pi-brent-salamin n))
            (b2 (pi-borwein2 n))
            (b4 (pi-borwein4 n)))
        (cons (list b2 (- bs b2) (- b4 b2))
              (pies (+ n s) m s)))))

(define expected
  '((314158 -18 -39)
    (31415926532 -22 -127)
    (3141592653589792 -31 -32)
    (314159265358979323845 -42 -1)
    (31415926535897932384626430 -39 -53)
    (3141592653589793238462643383274 -62 -291)
    (314159265358979323846264338327950286 -41 -73)
    (31415926535897932384626433832795028841972 -49 -137)
    (3141592653589793238462643383279502884197169395 -62 137)
    (314159265358979323846264338327950288419716939937507 -54 124)))

(define (test4)
  (if (not (equal? (pies 5 50 5) expected))
    (display "incorrect result while computing pi")
    (display "OK"))
  (newline))

;------------------------------------------------------------------------------

(##declare
  (not safe)
  (fixnum)
  (separate)
)

(define c1 2.)
(define c2 209.177)
(define c3 1.)
(define c4 -1.)
(define c5 0.)
(define c6 -0.)
(define c7 +nan.0)
(define c8 +inf.0)
(define c9 -inf.0)
(define c10 1e40)
(define c11 -1e-291)

(define (test5)
  (write (sqrt c1)) (newline)
  (write (round c2)) (newline)
  (write (fl/ c3 c5)) (newline)
  (write (fl/ c4 c5)) (newline)
  (write (fl/ c3 c6)) (newline)
  (write (fl/ c4 c6)) (newline)
  (write c7) (newline)
  (write (fl+ c9 c8)) (newline)
  (write (fl< (fllog c5) -1.797693e308)) (newline)
  (write (fl< 1.797693e308 (flexp c10))) (newline)
  (write (fl/ c11 c10)) (newline)
  (if (not (equal? (number->string (fl* c3 -0.)) "-0."))
    (begin
      (display "*** warning: (fl* 0. -0.) != -0." (current-error-port))
      (newline (current-error-port))))
  (if (not (equal? (number->string (fl* c4 0.)) "-0."))
    (begin
      (display "*** warning: (fl* -0. 0.) != -0." (current-error-port))
      (newline (current-error-port))))
  (if (fl< c7 c5)
    (begin
      (display "*** warning: (fl< +nan.0 0.) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl< c5 c7)
    (begin
      (display "*** warning: (fl< 0. +nan.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl< c7 c8)
    (begin
      (display "*** warning: (fl< +nan.0 +inf.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl< c8 c7)
    (begin
      (display "*** warning: (fl< +inf.0 +nan.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl< c7 c9)
    (begin
      (display "*** warning: (fl< +nan.0 -inf.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl< c9 c7)
    (begin
      (display "*** warning: (fl< -inf.0 +nan.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl= c7 c8)
    (begin
      (display "*** warning: (fl= +nan.0 +inf.0) => #t" (current-error-port))
      (newline (current-error-port))))
  (if (fl= c7 c9)
    (begin
      (display "*** warning: (fl= +nan.0 -inf.0) => #t" (current-error-port))
      (newline (current-error-port))))
)

;------------------------------------------------------------------------------

(##declare (generic))

(define heartbeat-interval
  (##thread-heartbeat-interval-set! 0.001)) ; set small interval

(define intrs 0.0)

(define interrupt-thread
 (make-thread
  (lambda ()
    (let loop ()
      (thread-sleep! 0.0001) ; sleep until next heartbeat interrupt
      (set! intrs (+ intrs 1.0))
      (loop)))))

;; The interrupt-thread priority must be above the primordial thread's
;; priority which is 0.
(thread-base-priority-set! interrupt-thread 1)

(thread-start! interrupt-thread)

(define start-time (cpu-time))

(let loop ((i 20))
  (if (> i 0)
    (begin
      (test1)
      (test2)
      (loop (- i 1)))))

(let ((ct (time->seconds (current-time))))
  (if (< ct 964727878.343539) ; Thu Jul 27 15:57:58 EDT 2000
    (begin
      (display "real-time is low: ")
      (write ct))
    (display "real-time OK"))
  (newline))

(let* ((i
        intrs)
       (end-time
        (cpu-time))
       (cpu-time-according-to-os
        (- end-time start-time))
       (cpu-time-according-to-heartbeat
        (* i heartbeat-interval))
       (heartbeat-hz
        (/ i cpu-time-according-to-os))
       (heartbeat-hz-expected
        (/ 1 heartbeat-interval)))
  (display cpu-time-according-to-os (current-error-port))
  (display " secs elapsed cpu time" (current-error-port))
  (newline (current-error-port))
  (display "heartbeat frequency = " (current-error-port))
  (display heartbeat-hz (current-error-port))
  (display " Hz" (current-error-port))
  (newline (current-error-port))
  (if (or (< (/ (+ i 1) cpu-time-according-to-os)
             (* 0.92 heartbeat-hz-expected))
          (> (/ (- i 1) cpu-time-according-to-os)
             (* 1.08 heartbeat-hz-expected)))
    (begin
      (display "*** possible problem: expected heartbeat frequency = " (current-error-port))
      (display heartbeat-hz-expected (current-error-port))
      (display " Hz" (current-error-port))
      (newline (current-error-port)))))

(test3)
(test4)
(test5)

(force-output)

;------------------------------------------------------------------------------
