(declare (extended-bindings) (not safe))

(##define-macro (case-target . clauses)
  (let ((target (if (and (pair? ##compilation-options)
                          (pair? (car ##compilation-options)))
                    (let ((t (assq 'target ##compilation-options)))
                      (if t (cadr t) 'c))
                    'c)))
    (let loop ((clauses clauses))
      (if (pair? clauses)
          (let* ((clause (car clauses))
                  (cases (car clause)))
            (if (or (eq? cases 'else)
                    (memq target cases))
                `(begin ,@(cdr clause))
                (loop (cdr clauses))))
          `(begin)))))

(##define-macro (define-target name . clauses)
  `(define ,name (case-target ,@clauses)))

(define-target num
  ((js php python ruby) "1")
  (else 1))

(define-target str
  ((js php python ruby) "\"a string\"")
  (else "a string"))

(define-target vd 
  ((js) "undefined")
  ((php) "NULL")
  ((python) "None")
  ((ruby) "nil")
  (else #!void))

(define-target flo
  ((js php python ruby) "2.5")
  (else 2.5))

#;
(define-target fn
  ((js) "function(x) {return x}")
  ((python) "lambda x : x")
  ((ruby) "Proc.new {|x| x}")
  (else (lambda (x) x)))

(case-target
 ((php)
  (##inline-host-declaration
"function ev($x) {
  eval(\"\\$x=$x;\");
  return $x;
}"))
 (else ""))

(define-target host
 ((js)
  (##inline-host-expression "((typeof Gambit_RTS !== 'undefined') ? Gambit_RTS.host_function2scm : gambit_host_function2scm)(eval)"))
 ((python)
  (##inline-host-expression "gambit_host_function2scm(eval)")
  #;(##inline-host-expression "Gambit_RTS.host_function2scm(eval)"))
 ((ruby)
  (##inline-host-expression "gambit_host_function2scm(Proc.new {|x| eval(x)})")
  #;(##inline-host-expression "Gambit_RTS.host_function2scm(Proc.new {|x| eval(x)})"))
 ((php)
  (##inline-host-expression "gambit_host_function2scm(\"ev\")")
  #;(##inline-host-expression "Gambit_RTS.host_function2scm(\"ev\")"))

 (else (lambda (x) x)))

(println (host num))
(println (host flo))
(println (host str))
(println (host vd))

