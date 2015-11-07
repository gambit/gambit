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

(define-target (bijective-fn x)
 ((js)
  (let ((tmp (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.scm_procedure2host : g_scm_procedure2host)(@1@)" x)))
    (let ((res (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.host_function2scm : g_host_function2scm)(@1@)" tmp)))
      res)))
 ((php ruby python)
  (let ((tmp (##inline-host-expression "g_scm_procedure2host(@1@)" x)))
    (let ((res (##inline-host-expression "g_host_function2scm(@1@)" tmp)))
      res)))
; ((module)
;  (let ((tmp (##inline-host-expression "G_RTS.scm_procedure2host(@1@)" x)))
;    (let ((res (##inline-host-expression "G_RTS.host_function2scm(@1@)" tmp)))
;      res)))
 (else (bijective x)))

(define-target (bijective x)
 ((js)
  (let ((tmp (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.scm2host : g_scm2host)(@1@)" x)))
    (let ((res (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.host2scm : g_host2scm)(@1@)" tmp)))
      res)))
 ((php ruby python)
  (let ((tmp (##inline-host-expression "g_scm2host(@1@)" x)))
    (let ((res (##inline-host-expression "g_host2scm(@1@)" tmp)))
      res)))
;   ((module)
;    (let ((tmp (##inline-host-expression "G_RTS.host2scm(@1@)" x)))
;     (let ((res (##inline-host-expression "G_RTS.host2scm(@1@)" tmp)))
;       res)))

 (else x))

;;----------------------------------------------------------------------------

(define (id x) x)

(define (rest a b . c) (##car c))
  
(println ((bijective-fn id) "id"))
(println ((bijective-fn rest) "a" "b" "c" "d" "e"))

(case-target
 ((php)
  (begin
   (println ((bijective-fn id) "id"))
   (println ((bijective-fn rest) "a" "b" "c" "d" "e"))))
 (else
  (begin
   (println ((bijective id) "id")))
   (println ((bijective rest) "a" "b" "c" "d" "e"))))
