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

(define-target (bijective x)
 ((js)
  (let ((tmp (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.scm2host : g_scm2host)(@1@)" x)))
    (let ((res (##inline-host-expression "((typeof G_RTS !== 'undefined') ? G_RTS.host2scm : g_host2scm)(@1@)" tmp)))
      res)))
 ((php ruby python)
  (let ((tmp (##inline-host-expression "g_scm2host(@1@)" x)))
    (let ((res (##inline-host-expression "g_host2scm(@1@)" tmp)))
      res)))
; ((module)
;  (let ((tmp (##inline-host-expression "G_RTS.scm2host(@1@)" x)))
;    (let ((res (##inline-host-expression "G_RTS.host2scm(@1@)" tmp)))
;      res)))

 (else x))

;;----------------------------------------------------------------------------

;; null
(println (if (##null? (bijective '())) "'()" ""))

;; void
(println (bijective #!void))

;; boolean
(println (bijective #t))
(println (bijective #f))

;; integer
(println (bijective 0))
(println (bijective -1))

;; float
(println (bijective 1.5))
(println (bijective -1.5))

;; string
(println (bijective ""))
(println (bijective "string"))

;; array
;(println (bijective '(1 2 3 4)))
