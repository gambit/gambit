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
;; TODO : java
; ((module)
;  (let ((tmp (##inline-host-expression "G_RTS.scm2host(@1@)" x)))
;    (let ((res (##inline-host-expression "G_RTS.host2scm(@1@)" tmp)))
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
(test (lambda (a) (##eq? a #!void)) (bijective #!void))

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
