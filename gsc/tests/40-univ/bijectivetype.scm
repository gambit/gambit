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
  (let ((tmp (##inline-host-expression "((typeof Gambit_RTS !== 'undefined') ? Gambit_RTS.scm_procedure2host : gambit_scm_procedure2host)(@1@)" x)))
    (let ((res (##inline-host-expression "((typeof Gambit_RTS !== 'undefined') ? Gambit_RTS.host_function2scm : gambit_host_function2scm)(@1@)" tmp)))
      res)))
 ((php ruby python)
  (let ((tmp (##inline-host-expression "gambit_scm_procedure2host(@1@)" x)))
    (let ((res (##inline-host-expression "gambit_host_function2scm(@1@)" tmp)))
      res)))
; ((module)
;  (let ((tmp (##inline-host-expression "Gambit_RTS.scm_procedure2host(@1@)" x)))
;    (let ((res (##inline-host-expression "Gambit_RTS.host_function2scm(@1@)" tmp)))
;      res)))

 (else (bijective x)))

(define-target (bijective x)
 ((js)
  (let ((tmp (##inline-host-expression "((typeof Gambit_RTS !== 'undefined') ? Gambit_RTS.scm2host : gambit_scm2host)(@1@)" x)))
    (let ((res (##inline-host-expression "((typeof Gambit_RTS !== 'undefined') ? Gambit_RTS.host2scm : gambit_host2scm)(@1@)" tmp)))
      res)))
 ((php ruby python)
  (let ((tmp (##inline-host-expression "gambit_scm2host(@1@)" x)))
    (let ((res (##inline-host-expression "gambit_host2scm(@1@)" tmp)))
      res)))
; ((module)
;  (let ((tmp (##inline-host-expression "Gambit_RTS.scm2host(@1@)" x)))
;    (let ((res (##inline-host-expression "Gambit_RTS.host2scm(@1@)" tmp)))
;       res)))

 (else x))

;;----------------------------------------------------------------------------

;;
(##define-macro (test type? x)
  `(println (if (,type? ,x) "type check: OK" "type check: ERR")))

(define (id x) x)

;; null
(test ##null? (bijective '()))

;; void
;(test ##void? (bijective #!void))

;; boolean
(test ##boolean? (bijective #t))
(test ##boolean? (bijective #f))

;; integer
(test ##fixnum? (bijective 0))
(test ##fixnum? (bijective 1))
(test ##fixnum? (bijective -1))

;; float
(test ##flonum? (bijective 1.5))
(test ##flonum? (bijective -1.5))

;; string
(test ##string? (bijective ""))
(test ##string? (bijective "string"))

;; procedure
(test ##procedure? (bijective-fn id))
