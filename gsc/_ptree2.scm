;;;============================================================================

;;; File: "_ptree2.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;**********brad
(##include "../gsc/_utilsadt.scm")
(##include "../gsc/_envadt.scm")
(##include "../gsc/_ptree1adt.scm")
(##include "../gsc/_hostadt.scm")
)

;;;----------------------------------------------------------------------------
;;
;; Parse tree manipulation module: (part 2)
;; ------------------------------

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (normalize-program ptrees)
  (let* ((lst ptrees)
         (lst (expand-primitive-calls lst))
         (lst (assignment-convert lst))
         (lst (remove-dead-definitions lst))
         (lst (beta-reduce lst))
         (lst (remove-dead-definitions lst))
         (lst (lambda-lift lst)))

    (if (null? lst) ;; must return at least one ptree
        (list (new-cst (expression->source void-object #f) (node-env (car ptrees))
                void-object))
        lst)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (delete-ptree ptree) removes parse tree 'ptree' from program and updates
;; references and assignments to variables.

(define (delete-ptree ptree)

  (cond ((ref? ptree)
         (let ((var (ref-var ptree)))
           (var-refs-set! var (ptset-remove (var-refs var) ptree))))

        ((set? ptree)
         (let ((var (set-var ptree)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))))

        ((def? ptree)
         (let ((var (def-var ptree)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree)))))

  (for-each delete-ptree (node-children ptree)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (clone-ptree ptree) returns a fresh copy of 'ptree'.  All the
;; bound variables (i.e. not free variables) in ptree are also copied.
;; It is assumed that 'ptree' has already been assignment-converted.

(define (clone-ptree ptree)
  (cp ptree '()))

(define (cp ptree substs)

  (define (rename-var var)
    (let ((x (assq var substs)))
      (if x (cdr x) var)))

  (cond ((cst? ptree)
         (new-cst (node-source ptree) (node-env ptree)
           (cst-val ptree)))

        ((ref? ptree)
         (let ((var (rename-var (ref-var ptree))))
           (new-ref (node-source ptree) (node-env ptree)
             var)))

        ((set? ptree)
         (let ((var (rename-var (set-var ptree))))
           (new-set (node-source ptree) (node-env ptree)
             var
             (cp (set-val ptree) substs))))

        ((def? ptree) ; guaranteed to be a toplevel definition
         (new-def (node-source ptree) (node-env ptree)
           (def-var ptree)
           (cp (def-val ptree) substs)))

        ((tst? ptree)
         (new-tst (node-source ptree) (node-env ptree)
           (cp (tst-pre ptree) substs)
           (cp (tst-con ptree) substs)
           (cp (tst-alt ptree) substs)))

        ((conj? ptree)
         (new-conj (node-source ptree) (node-env ptree)
           (cp (conj-pre ptree) substs)
           (cp (conj-alt ptree) substs)))

        ((disj? ptree)
         (new-disj (node-source ptree) (node-env ptree)
           (cp (disj-pre ptree) substs)
           (cp (disj-alt ptree) substs)))

        ((prc? ptree)
         (let* ((parms (prc-parms ptree))
                (vars (clone-vars parms)))
           (new-prc (node-source ptree) (node-env ptree)
             (prc-name ptree)
             (prc-c-name ptree)
             vars
             (prc-opts ptree)
             (prc-keys ptree)
             (prc-rest? ptree)
             (cp (prc-body ptree)
                 (append (pair-up parms vars) substs)))))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (let* ((parms (prc-parms oper))
                    (vars (clone-vars parms))
                    (new-substs (append (pair-up parms vars) substs)))
               (new-let ptree
                        oper
                        vars
                        (map (lambda (x) (cp x new-substs)) args)
                        (cp (prc-body oper) new-substs)))
             (new-call (node-source ptree) (node-env ptree)
               (cp (app-oper ptree) substs)
               (map (lambda (x) (cp x substs)) (app-args ptree))))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (cp (fut-val ptree) substs)))

        (else
         (compiler-internal-error "cp, unknown parse tree node type"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Expansion of primitive calls
;; ----------------------------

;; (expand-primitive-calls lst) takes a list of parse-trees and returns
;; a list where each parse-tree has been replaced with an equivalent
;; parse-tree where some calls to primitive procedures have been
;; expanded into an equivalent, but probably faster, Scheme expression.

(define (expand-primitive-calls lst)
  (map epc lst))

(define (epc ptree)
  (cond ((ref? ptree)
         (epc-ref ptree))
        ((app? ptree)
         (epc-app ptree))
        (else
         (node-children-set! ptree
           (map epc
                (node-children ptree)))
         ptree)))

(define (epc-ref ptree)
  (let ((proc (and (global? (ref-var ptree))
                   (global-proc-obj ptree))))
    (if (and proc (proc-obj-standard proc))
        (let ((proc-node
               (new-cst (node-source ptree) (node-env ptree)
                 proc)))
          (delete-ptree ptree)
          proc-node)
        ptree)))

(define (epc-app ptree)

  (define (spec-call-with-vars call spec-call source env all-vars dead-end?)
    (let* ((vars-vect
            (list->vector all-vars))
           (args
            (fold-call-args
             (call-args call)
             (call-args spec-call)
             '()
             (lambda (arg index tail)
               (cons
                (if index
                    (let ((var (vector-ref vars-vect index)))
                      (new-ref source env
                        var))
                    (new-cst source env
                      arg))
                tail))))
           (call-ptree
            (gen-call-maybe-dead-end source env
              (new-cst source env
                (call-proc spec-call))
              args
              dead-end?)))
      call-ptree))

  (define (spec-call-with-args call spec-call source env all-args dead-end?)
    (let* ((all-args-vect
            (list->vector all-args))
           (args
            (fold-call-args
             (call-args call)
             (call-args spec-call)
             '()
             (lambda (arg index tail)
               (cons
                (if index
                    (let ((arg-ptree (vector-ref all-args-vect index)))
                      (vector-set! all-args-vect index #f)
                      arg-ptree)
                    (new-cst source env
                      arg))
                tail))))
           (call-ptree
            (gen-call-maybe-dead-end source env
              (new-cst source env
                (call-proc spec-call))
              args
              dead-end?)))
      (let loop ((index (- (vector-length all-args-vect) 1))
                 (inner call-ptree))
        (if (>= index 0)
            (loop (- index 1)
                  (let ((arg (vector-ref all-args-vect index)))
                    (if arg
                        (new-seq source env
                          arg
                          inner)
                        inner)))
            inner))))

  (define (replace-oper ptree new-oper args)
    (let ((old-oper (app-oper ptree)))
      (if (not (eq? old-oper new-oper))
          (delete-ptree old-oper)))
    (node-children-set! ptree
      (cons (epc new-oper)
            args))
    ptree)

  (let* ((oper
          (app-oper ptree))
         (args
          (map epc (app-args ptree)))
         (source
          (node-source ptree))
         (env
          (node-env ptree)))

    (cond ((ref? oper)
           (let ((var (ref-var oper)))
             (if (not (global? var))
                 (replace-oper ptree oper args)
                 (let* ((name
                         (var-name var))
                        (proc
                         (target.prim-info name))
                        (call
                         (and proc
                              (inline-primitive? name env)
                              (make-specialization-call proc args)))
                        (spec-call
                         (and call
                              (specialize-call call env)))
                        (spec
                         (and spec-call
                              (call-proc spec-call))))

                   (define (generate-spec-call vars dead-end?)
                     (spec-call-with-vars
                      call
                      spec-call
                      source
                      env
                      vars
                      dead-end?))

                   (define (generate-original-call vars dead-end?)
                     (gen-call-maybe-dead-end source env
                       (new-ref source (remove-std-ext-rt-bindings env)
                         var)
                       (gen-var-refs source env vars)
                       dead-end?))

                   (define (generate-run-time-binding-test gen-body)
                     (let ((vars (gen-temp-vars source args)))
                       (gen-prc source env
                         vars
                         (new-tst source env
                           (gen-eq-proc source env
                             (new-ref source env
                               var)
                             proc)
                           (gen-body vars #f)
                           (generate-original-call vars #f)))))

                   (if (and spec
                            (or (not (eq? spec proc))
                                ((proc-obj-inlinable? spec) env)
                                ((proc-obj-expandable? spec) env)))
                       (let* ((std?
                               ;; true iff it is OK to assume that the
                               ;; global variable "name" is bound to its
                               ;; predefined procedure
                               (standard-proc-obj proc name env))
                              (rtb?
                               ;; true iff the binding of the global
                               ;; variable "name" should be checked at
                               ;; run time
                               (and (not std?)
                                    (run-time-binding? name env)))
                              (use-original-call?
                               ;; true iff the original call should be
                               ;; used for the out-of-line case (this
                               ;; makes it possible to share the code
                               ;; generated for each branch)
                               rtb?))

                         (if (not ((proc-obj-expandable? spec) env))

                             ;; the specialized procedure does not
                             ;; have an expansion, so just call
                             ;; the specialized procedure

                             (cond (std?
                                    (delete-ptree oper)
                                    (spec-call-with-args
                                     call
                                     spec-call
                                     source
                                     env
                                     args
                                     #f))
                                   (rtb?
                                    (replace-oper
                                     ptree
                                     (generate-run-time-binding-test
                                      generate-spec-call)
                                     args))
                                   (else
                                    (replace-oper ptree oper args)))

                             ;; the specialized procedure has an
                             ;; expansion so use it if "name" has
                             ;; a standard binding or a run time
                             ;; binding declaration

                             (if (or std?
                                     rtb?)

                                 (replace-oper
                                  ptree
                                  ((proc-obj-expand spec)
                                   ptree
                                   oper
                                   args
                                   (if use-original-call?
                                       generate-original-call
                                       generate-spec-call)
                                   (and rtb?
                                        use-original-call?
                                        (lambda ()
                                          (gen-eq-proc source env
                                            (new-ref source env
                                              var)
                                            proc))))
                                  args)

                                 (replace-oper ptree oper args))))

                       (replace-oper ptree oper args))))))


          ((cst? oper)
           (let ((proc
                  (cst-val oper)))
             (if (not (proc-obj? proc))
                 (replace-oper ptree oper args)
                 (let* ((call
                         (make-specialization-call proc args))
                        (spec-call
                         (specialize-call call env))
                        (spec
                         (and spec-call
                              (call-proc spec-call))))
                   (replace-oper
                    ptree
                    (if (and spec
                             (inline-primitive? (proc-obj-name spec) env)
                             ((proc-obj-expandable? spec) env))
                        ((proc-obj-expand spec)
                         ptree
                         oper
                         args
                         (lambda (vars dead-end?)
                           (spec-call-with-vars
                            call
                            spec-call
                            source
                            env
                            vars
                            dead-end?))
                         #f)
                        oper)
                    args)))))

          (else
           (replace-oper ptree oper args)))))

(define (gen-prc source env params body)
  (new-prc source env #f #f params '() #f #f body))

(define (gen-disj-multi source env nodes)
  (if (pair? (cdr nodes))
    (new-disj source env
      (car nodes)
      (gen-disj-multi source env (cdr nodes)))
    (car nodes)))

(define (gen-var-type-checks source env vars type-checks tail)

  (define (cdr-type-checks type-checks)
    (if (pair? (cdr type-checks))
        (cdr type-checks)
        type-checks))

  (define (loop result lst type-checks)
    (if (pair? lst)
        (loop (new-conj source env
                ((car type-checks) (car lst))
                result)
              (cdr lst)
              type-checks)
        result))

  (cond (tail
         (loop tail vars type-checks))
        ((pair? vars)
         (loop ((car type-checks) (car vars))
               (cdr vars)
               (cdr-type-checks type-checks)))
        (else
         #f)))

(define (gen-temp-vars source args)
  (let loop ((args args) (rev-vars '()))
    (if (null? args)
      (reverse rev-vars)
      (loop (cdr args)
            (cons (new-temp-variable source 'temp)
                  rev-vars)))))

(define (gen-var-refs source env vars)
  (map (lambda (var)
         (new-ref source env
           var))
       vars))

(define (gen-call-prim-vars source env prim vars)
  (gen-call-prim source env
    prim
    (gen-var-refs source env vars)))

(define (gen-call-prim-vars-notsafe source env prim vars)
  (gen-call-prim-vars source (add-not-safe env) prim vars))

(define (gen-call-prim source env prim args)
  (gen-call-maybe-dead-end source env
    (new-cst source env
      (target.prim-info prim))
    args
    #f))

(define (gen-call-prim-notsafe source env prim args)
  (gen-call-prim source (add-not-safe env) prim args))

(define (gen-call-maybe-dead-end source env proc args dead-end?)
  (new-call source (add-not-inline-primitives (if dead-end? (add-dead-end-calls env) env))
    proc
    args))

(define (dead-end-calls? env)
  (declaration-value 'dead-end-calls #f #f env))

(define (add-dead-end-calls env)
  (env-declare env (list 'dead-end-calls #t)))

(define (gen-eq-proc source env arg proc)
  (gen-call-prim-notsafe source env
    **eq?-sym
    (list
     arg
     (new-cst source env
       proc))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Assignment conversion:
;; ---------------------

;; (assignment-convert lst) takes a list of parse-trees and returns a
;; list where each parse-tree has been replaced with an equivalent
;; parse-tree containing no assignments to non-global variables.  In
;; the converted parse-tree, 'box' objects are used to implement mutable
;; variables and calls to the procedures:
;;
;;   ##box
;;   ##unbox
;;   ##set-box!
;;
;; are added to create and access the boxes.

(define (assignment-convert lst)
  (map (lambda (ptree) (ac ptree '()))
       lst))

(define (ac ptree mut)

  (cond ((cst? ptree)
         ptree)

        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (if (global? var)
             ptree
             (let ((x (assq var mut)))
               (if x
                 (let ((source (node-source ptree)))
                   (var-refs-set! var (ptset-remove (var-refs var) ptree))
                   (gen-call-prim-notsafe source (node-env ptree)
                     **unbox-sym
                     (list (new-ref source (node-env ptree) (cdr x)))))
                 ptree)))))

        ((set? ptree)
         (let ((var (set-var ptree))
               (source (node-source ptree))
               (val (ac (set-val ptree) mut)))
           (if (global? var)
             (begin
               (var-sets-set! var (ptset-remove (var-sets var) ptree))
               (new-set source (node-env ptree)
                 var
                 val))
             (gen-call-prim-notsafe source (node-env ptree)
               **set-box!-sym
               (list (new-ref source (node-env ptree) (cdr (assq var mut)))
                     val)))))

        ((def? ptree) ; guaranteed to be a toplevel definition
         (let ((var (def-var ptree))
               (val (ac (def-val ptree) mut)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))
           (new-def (node-source ptree) (node-env ptree)
             var
             val)))

        ((tst? ptree)
         (new-tst (node-source ptree) (node-env ptree)
           (ac (tst-pre ptree) mut)
           (ac (tst-con ptree) mut)
           (ac (tst-alt ptree) mut)))

        ((conj? ptree)
         (new-conj (node-source ptree) (node-env ptree)
           (ac (conj-pre ptree) mut)
           (ac (conj-alt ptree) mut)))

        ((disj? ptree)
         (new-disj (node-source ptree) (node-env ptree)
           (ac (disj-pre ptree) mut)
           (ac (disj-alt ptree) mut)))

        ((prc? ptree)
         (ac-proc ptree mut))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (ac-let ptree mut)
             (new-call (node-source ptree) (node-env ptree)
               (ac oper mut)
               (map (lambda (x) (ac x mut)) args)))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (ac (fut-val ptree) mut)))

        (else
         (compiler-internal-error "ac, unknown parse tree node type"))))

(define (ac-proc ptree mut)
  (let* ((mut-parms (ac-mutables (prc-parms ptree)))
         (cloned-mut-parms (clone-vars mut-parms)))

    (for-each (lambda (var) (var-sets-set! var (ptset-empty)))
              mut-parms)

    (for-each (lambda (var) (var-boxed?-set! var #t))
              cloned-mut-parms)

    (new-prc (node-source ptree) (node-env ptree)
      (prc-name ptree)
      (prc-c-name ptree)
      (prc-parms ptree)
      (prc-opts ptree)
      (prc-keys ptree)
      (prc-rest? ptree)
      (new-let ptree
               ptree
               cloned-mut-parms
               (map (lambda (var)
                      (gen-call-prim-notsafe (var-source var) (node-env ptree)
                        **box-sym
                        (list (new-ref (var-source var)
                                       (node-env ptree)
                                       var))))
                    mut-parms)
               (ac (prc-body ptree)
                   (append (pair-up mut-parms cloned-mut-parms) mut))))))

(define (ac-let ptree mut)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (vals-fv (varset-union-multi (map bound-free-variables vals)))
         (mut-parms (ac-mutables vars))
         (cloned-mut-parms (clone-vars mut-parms))
         (mut (append (pair-up mut-parms cloned-mut-parms) mut)))

    (for-each (lambda (var) (var-sets-set! var (ptset-empty)))
              mut-parms)

    (for-each (lambda (var) (var-boxed?-set! var #t))
              cloned-mut-parms)

    (let loop ((l1 vars)
               (l2 vals)
               (new-vars '())
               (new-vals '())
               (new-body (ac (prc-body proc) mut)))
      (if (null? l1)

        (new-let ptree proc new-vars new-vals new-body)

        (let ((var (car l1))
              (val (car l2)))

          (if (memq var mut-parms)

            (let ((src (node-source val))
                  (env (node-env val))
                  (var* (cdr (assq var mut))))

              (if (varset-member? var vals-fv)

                (loop (cdr l1)
                      (cdr l2)
                      (cons var* new-vars)
                      (cons (gen-call-prim-notsafe src env
                              **box-sym
                              (list (new-cst src env void-object)))
                            new-vals)
                      (new-seq src env
                        (gen-call-prim-notsafe src env
                          **set-box!-sym
                          (list (new-ref src env var*)
                                (ac val mut)))
                        new-body))

                (loop (cdr l1)
                      (cdr l2)
                      (cons var* new-vars)
                      (cons (gen-call-prim-notsafe src env
                              **box-sym
                              (list (ac val mut)))
                            new-vals)
                      new-body)))

            (loop (cdr l1)
                  (cdr l2)
                  (cons var new-vars)
                  (cons (ac val mut) new-vals)
                  new-body)))))))

(define (ac-mutables lst)
  (keep mutable? lst))

(define (clone-vars vars)
  (map (lambda (var)
         (let ((cloned-var
                (make-var (var-name var)
                          #t
                          (ptset-empty)
                          (ptset-empty)
                          (var-source var)
                          (var-temp? var))))
           (var-boxed?-set! cloned-var (var-boxed? var))
           cloned-var))
       vars))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Removal of dead definitions:
;; ---------------------------

;; (remove-dead-definitions ptrees) takes a list of parse-trees and
;; removes all top-level definitions that are not live.  The liveness of
;; top-level definitions is related to the liveness of global variables.
;;
;; For a top-level expression expr that is not a global variable
;; definition, the free variables of expr are live global variables.
;;
;; A top-level definition (define var expr) is live iff at that
;; definition the declaration (optimize-dead-definitions var) is not in
;; effect or, the global variable var is live and there isn't a top-level
;; definition of var later in the program or there is a set! of var in
;; a live part of the program.  If the definition is live then var and
;; the free variables of expr are live global variables.

(define (remove-dead-definitions ptrees)

  (define (mutated-globals ptree)
    ;; returns set of all mutated global variables in ptree
    (let ((mg (varset-union-multi
               (map mutated-globals
                    (node-children ptree)))))
      (if (set? ptree)
          (let ((var (set-var ptree)))
            (if (global? var)
                (varset-adjoin mg var)
                mg))
          mg)))

  (define (dead-defs-fixpoint live mutated possibly-dead-defs)
    (let loop ((rev-lst (reverse possibly-dead-defs))
               (live live)
               (mutated mutated)
               (remaining-possibly-dead-defs '())
               (changed? #f))
      (if (pair? rev-lst)
          (let* ((x (car rev-lst))
                 (defined-later? (car x))
                 (ptree (cdr x))
                 (var (def-var ptree)))
            (if (and (varset-member? var live)
                     (or (not defined-later?)
                         (varset-member? var mutated)))
                (loop (cdr rev-lst)
                      (varset-union live (free-variables ptree))
                      (varset-union mutated (mutated-globals ptree))
                      remaining-possibly-dead-defs
                      #t)
                (loop (cdr rev-lst)
                      live
                      mutated
                      (cons x remaining-possibly-dead-defs)
                      changed?)))
          (if changed?
              ;; repeat when set of remaining-possibly-dead-defs changed
              (dead-defs-fixpoint live
                                  mutated
                                  remaining-possibly-dead-defs)
              ;; remaining-possibly-dead-defs are really dead
              (list->ptset (map cdr remaining-possibly-dead-defs))))))

  (define (dead-defs)
    (let loop ((rev-lst (reverse ptrees)) ;; visit definitions in reverse order
               (later-defs (varset-empty))
               (live (varset-empty))
               (mutated (varset-empty))
               (possibly-dead-defs '()))
      (if (pair? rev-lst)
          (let ((ptree (car rev-lst)))
            (if (def? ptree)
                (let* ((var
                        (def-var ptree))
                       (defined-later?
                         (varset-member? var later-defs))
                       (certainly-live-def?
                        (or
                         ;; this definition isn't marked for optimization
                         (not (optimize-dead-definitions?
                               (var-name var)
                               (node-env ptree)))
                         ;; var certainly live and no following def of this var
                         (and (varset-member? var live)
                              (not defined-later?)))))
                  (if certainly-live-def?
                      (loop (cdr rev-lst)
                            (varset-adjoin later-defs var)
                            (varset-union live (free-variables ptree))
                            (varset-union mutated (mutated-globals ptree))
                            possibly-dead-defs)
                      (loop (cdr rev-lst)
                            (varset-adjoin later-defs var)
                            live
                            mutated
                            (cons (cons defined-later? ptree)
                                  possibly-dead-defs))))
                (loop (cdr rev-lst)
                      later-defs
                      (varset-union live (free-variables ptree))
                      (varset-union mutated (mutated-globals ptree))
                      possibly-dead-defs)))
          (dead-defs-fixpoint live
                              mutated
                              possibly-dead-defs))))

  (let ((dead (dead-defs)))
    (if (ptset-empty? dead)

        ;; no defs to remove so return the same list of parse trees...
        ;; (allows using eq? on resulting list)
        ptrees

        (keep (lambda (ptree)
                (if (ptset-member? ptree dead)
                    (begin
                      (delete-ptree ptree)
                      #f)
                    #t))
              ptrees))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Beta-reduction:
;; --------------

;; (beta-reduce ptrees) takes a list of parse-trees and transforms
;; each parse-tree with the following transformations:
;;
;;  - constant propagation
;;  - copy propagation
;;  - useless variable elimination
;;
;; It is assumed that the parse-trees have already been assignment-converted.

(define beta-reduce #f);***************

(set! beta-reduce (lambda (ptrees)

  (define (vars-with-duplicates->varset vars);********brad avoids this because list->set removes duplicates
    (let loop ((set (varset-empty)) (lst vars))
      (if (pair? lst)
        (loop (varset-adjoin set (car lst)) (cdr lst))
        set)))

  (define (transform-defs-in-dependency-order! ptrees)
    (let* ((defs
            (keep def? ptrees))
           (defined-vars
            (vars-with-duplicates->varset (map def-var (reverse defs))))
           (depgraph
            (map (lambda (var)
                   (make-gnode var
                               (varset-union-multi
                                (map (lambda (def)
                                       (varset-intersection
                                        defined-vars
                                        (free-variables (def-val def))))
                                     (keep def?
                                           (ptset->list (var-sets var)))))))
                 (varset->list defined-vars)))
           (order
            (topological-sort
             (transitive-closure depgraph))))
      (for-each
       (lambda (vars)
         (for-each
          (lambda (var)
            (for-each
             (lambda (def)
               (node-children-set!
                def
                (list (br (def-val def) '() 'need #f))))
             (keep def? (ptset->list (var-sets var)))))
          (varset->list vars)))
       order)))

  (define (transform-non-defs-from-top-to-bottom ptrees)
    (let loop ((lst1 ptrees) (lst2 '()))
      (if (pair? lst1)
        (let ((ptree (car lst1)))
          (loop (cdr lst1)
                (cons (if (def? ptree)
                          ptree
                          (br ptree '() 'need #f))
                      lst2)))
        (reverse lst2))))

  (define (remove-non-core-ptrees ptrees)
    (let loop ((lst1 ptrees) (lst2 '()))
      (if (pair? lst1)
        (let ((ptree (car lst1)))
          (loop (cdr lst1)
                (if (core? (node-env ptree))
                    (cons ptree
                          lst2)
                    lst2)))
        (reverse lst2))))

  (transform-defs-in-dependency-order! ptrees)

  (remove-non-core-ptrees
   (transform-non-defs-from-top-to-bottom ptrees)))
)

(define (br ptree substs reason expansion-limit)

  (cond ((cst? ptree)
         (new-cst (node-source ptree) (node-env ptree)
           (cst-val ptree)))

        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (var-refs-set! var (ptset-remove (var-refs var) ptree))
           (let ((new-var (var-subst var substs)))
             (let ((x (var-to-val new-var substs)))
               (if (and x (or (cst? x) (ref? x)))
                 (clone-ptree x)
                 (new-ref (node-source ptree) (node-env ptree)
                   new-var))))))

        ((set? ptree) ; variable guaranteed to be a global variable
         (let ((var (set-var ptree))
               (val (br (set-val ptree) substs 'need expansion-limit)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))
           (new-set (node-source ptree) (node-env ptree)
             var
             val)))

        ((tst? ptree)
         (let ((pre (br (tst-pre ptree) substs 'pred expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree pre)
                 (delete-ptree (tst-con ptree))
                 (br (tst-alt ptree) substs reason expansion-limit))
               (begin
                 (delete-ptree pre)
                 (delete-ptree (tst-alt ptree))
                 (br (tst-con ptree) substs reason expansion-limit)))
             (new-tst (node-source ptree) (node-env ptree)
               pre
               (br (tst-con ptree) substs reason expansion-limit)
               (br (tst-alt ptree) substs reason expansion-limit)))))

        ((conj? ptree)
         (let ((pre (br (conj-pre ptree) substs reason expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree (conj-alt ptree))
                 pre)
               (begin
                 (delete-ptree pre)
                 (br (conj-alt ptree) substs reason expansion-limit)))
             (let ((alt (br (conj-alt ptree) substs reason expansion-limit)))
               (cond ((and (cst? alt)
                           (false-object? (cst-val alt)))
                      (if (side-effects-impossible? pre)
                        (begin
                          ; (and X #f) => #f
                          (delete-ptree pre)
                          alt)
                        (begin
                          ; (and X #f) => (begin X #f)
                          ; this transform should be generalized
                          (new-seq (node-source ptree) (node-env ptree)
                            pre
                            alt))))
                     ((and (cst? alt)
                           (not (false-object? (cst-val alt)))
                           (eq? reason 'pred))
                      ; (if (and X non-#f) ...) => (if X ...)
                      (delete-ptree alt)
                      pre)
                     (else
                      (new-conj (node-source ptree) (node-env ptree)
                        pre
                        alt)))))))

        ((disj? ptree)
         (let ((pre (br (disj-pre ptree) substs reason expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree pre)
                 (br (disj-alt ptree) substs reason expansion-limit))
               (begin
                 (delete-ptree (disj-alt ptree))
                 pre))
             (let ((alt (br (disj-alt ptree) substs reason expansion-limit)))
               (if (and (cst? alt)
                        (false-object? (cst-val alt)))
                 (begin
                   ; (or X #f) => X
                   (delete-ptree alt)
                   pre)
                 (new-disj (node-source ptree) (node-env ptree)
                   pre
                   alt))))))

        ((prc? ptree)
         (new-prc (node-source ptree) (node-env ptree)
           (prc-name ptree)
           (prc-c-name ptree)
           (prc-parms ptree)
           (prc-opts ptree)
           (prc-keys ptree)
           (prc-rest? ptree)
           (br (prc-body ptree) substs 'need expansion-limit)))

        ((br-let? ptree)
         (br-let ptree substs reason expansion-limit))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (or (cst? oper) (ref? oper))
             (let ((br-oper (br oper substs 'need expansion-limit)))
               ; at this point (or (cst? br-oper) (ref? br-oper))
               (or (br-app-inline ptree br-oper args substs reason expansion-limit)
                   (br-app-simplify ptree br-oper args substs reason expansion-limit)))
             (br-app ptree oper args substs reason expansion-limit))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (br (fut-val ptree) substs 'need expansion-limit)))

        (else
         (compiler-internal-error "br, unknown parse tree node type"))))

(define (var-subst var substs)
  (if (null? substs)
    var
    (let ((couple (car substs)))
      (if (eq? (car couple) var)
        (if (ref? (cdr couple))
          (var-subst (ref-var (cdr couple)) (cdr substs))
          var)
        (var-subst var (cdr substs))))))

(define (var-to-val var substs)
  (if (global? var)
    (global-single-def var)
    (let ((x (assq var substs)))
      (if x (cdr x) #f))))

(define (br-let? ptree)
  (and (app? ptree)
       (let ((oper (app-oper ptree))
             (args (app-args ptree)))
         (and (prc? oper) ; applying a lambda-expr is like a 'let'
              (prc-req-and-opt-parms-only? oper)
              (= (length (prc-parms oper)) (length args))))))

(define (br-app ptree oper args substs reason expansion-limit)

  (if (and (br-let? oper)
           (let ((body (prc-body (app-oper oper))))
             (or (cst? body)
                 (and (ref? body)
                      (or (bound? (ref-var body))
                          (global-singly-bound? body))))))

      ;; let-floating transformation when the code is of the
      ;; form:
      ;;
      ;; ((let (...) var) E1 E2) -> (let (...) (var E1 E2))

      (let ((proc (app-oper oper)))
        (br (new-call (node-source oper) (node-env oper)
              (new-prc (node-source proc) (node-env proc)
                (prc-name proc)
                (prc-c-name proc)
                (prc-parms proc)
                (prc-opts proc)
                (prc-keys proc)
                (prc-rest? proc)
                (new-call (node-source ptree) (node-env ptree)
                  (prc-body proc)
                  args))
              (app-args oper))
            substs
            reason
            expansion-limit))

      (let ((call
             (new-call (node-source ptree) (node-env ptree)
               (br oper substs 'need expansion-limit)
               (map (lambda (arg) (br arg substs 'need expansion-limit))
                    args))))
        (if (br-let? call)
            (br-let call substs reason expansion-limit)
            call))))

(define (br-let ptree substs reason expansion-limit)
  (let* ((proc
          (app-oper ptree))
         (vals
          (app-args ptree))
         (vars
          (prc-parms proc))
         (vars-varset
          (list->varset vars))
         (var-val-map
          (pair-up vars vals))
         (new-substs
          (br-extend-substs vars vals substs))
         (br-vals
          (map (lambda (x) (br x new-substs 'need expansion-limit)) vals))
         (new-substs2
          (br-extend-substs vars br-vals substs))
         (new-body
          (br (prc-body proc) new-substs2 reason expansion-limit)))

    (define (var->val var) (cdr (assq var var-val-map)))

    (define (reachable-vars-from starting-point)
      (let loop ((old-reachable-vars
                  (varset-empty))
                 (reachable-vars
                  (varset-intersection
                   vars-varset
                   starting-point)))
        (if (varset-equal? reachable-vars old-reachable-vars)
          reachable-vars
          (loop reachable-vars
                (varset-union-multi
                 (cons reachable-vars
                       (map (lambda (var)
                              (varset-intersection
                               vars-varset
                               (bound-free-variables (var->val var))))
                            (varset->list
                             (varset-difference reachable-vars
                                                old-reachable-vars)))))))))

    ; remove useless bindings

    (let ((reachable-vars
           (reachable-vars-from
            (varset-union-multi
             (cons (bound-free-variables new-body)
                   (map (lambda (br-val)
                          (if (prc? br-val)
                            (varset-empty) ; reachable only if called
                            (bound-free-variables br-val)))
                        br-vals))))))
      (let loop ((l1 vars)
                 (l2 br-vals)
                 (new-vars '())
                 (new-vals '()))
        (if (null? l1)
          (new-let ptree
                   proc
                   (reverse new-vars)
                   (reverse new-vals)
                   new-body)
          (let ((var (car l1))
                (br-val (car l2)))
            (if (and (not (varset-member? var reachable-vars))
                     (or (cst? br-val)
                         (ref? br-val)
                         (prc? br-val)))
              (begin
                (delete-ptree br-val)
                (loop (cdr l1)
                      (cdr l2)
                      new-vars
                      new-vals))
              (loop (cdr l1)
                    (cdr l2)
                    (cons var new-vars)
                    (cons br-val new-vals)))))))))

(define (br-extend-substs vars vals substs)
  (let loop ((l1 vars)
             (l2 vals)
             (new-substs substs))
    (if (null? l1)
      new-substs
      (let ((var (car l1))
            (val (car l2)))
        (cond ((or (cst? val)
                   (and (ref? val)
                        (or (bound? (ref-var val))
                            (global-singly-bound? val)))
                   (and (prc? val)
                        (ptset-every? oper-pos? (var-refs var))))
               (loop (cdr l1)
                     (cdr l2)
                     (cons (cons var val) new-substs)))
              (else
               (loop (cdr l1)
                     (cdr l2)
                     new-substs)))))))

(define (br-app-inline ptree br-oper args substs reason expansion-limit)

  ; invariant: (or (cst? br-oper) (ref? br-oper))

  (and (ref? br-oper)
       (let* ((var (ref-var br-oper))
              (val (var-to-val var substs)))

         (define (inline-procedure new-expansion-limit)
           (let ((cloned-oper (clone-ptree val)))
             (delete-ptree br-oper)
             (br-app ptree cloned-oper args substs reason
                     new-expansion-limit)))

         (and val
              (prc? val)
              (inline? (node-env val))
              (if (and (bound? var)
                       (= (ptset-size (var-refs var)) 1)
                       (not (varset-member? var (bound-free-variables val))))

                ; Procedure is referenced once and it is not direcly
                ; recursive so inline it without changing the
                ; expansion limit (the original code will be removed
                ; by br-let).

                (inline-procedure expansion-limit)

                ; Procedure is referenced more than once or it is
                ; directly recursive so we inline it only if we
                ; don't exceed the expansion limit.

                (let* ((size-val
                        (ptree-size val))
                       (size-ptree
                        (ptree-size ptree))
                       (new-limit
                        (- (if expansion-limit
                             (car expansion-limit)
                             (quotient (* (inlining-limit (node-env ptree))
                                          size-ptree)
                                       100))
                           (- size-val 1))))
                  (and (>= new-limit 0)
                       (if expansion-limit
                         (begin
                           (set-car! expansion-limit new-limit)
                           (inline-procedure expansion-limit))
                         (inline-procedure (list new-limit))))))))))

(define (br-app-simplify ptree br-oper args substs reason expansion-limit)

  ; invariant: (or (cst? br-oper) (ref? br-oper))

  (let* ((br-args
          (map (lambda (arg) (br arg substs 'need expansion-limit)) args))
         (proc
          (and (constant-fold? (node-env ptree))
               (specialize-app br-oper br-args (node-env ptree))))
         (simp
          (and proc
               (nb-args-conforms? (length args) (proc-obj-call-pat proc))
               (proc-obj-simplify proc)))
         (simplified-ptree
          (and simp
               (simp ptree br-args))))
    (if simplified-ptree
      (begin
        (delete-ptree br-oper)
        (for-each delete-ptree br-args)
        simplified-ptree)
      (new-call (node-source ptree) (node-env ptree)
        br-oper
        br-args))))

(define (ptree-size ptree)
  (let loop ((lst (node-children ptree)) (n 1))
    (if (null? lst)
      n
      (loop (cdr lst) (+ n (ptree-size (car lst)))))))

(define (side-effects-impossible? ptree)

  (cond ((cst? ptree)
         #t)

        ((ref? ptree)
         #t)

        ((set? ptree) ; variable guaranteed to be a global variable
         #f)

        ((def? ptree) ; variable guaranteed to be a global variable
         (side-effects-impossible? (def-val ptree)))

        ((tst? ptree)
         (and (side-effects-impossible? (tst-pre ptree))
              (side-effects-impossible? (tst-con ptree))
              (side-effects-impossible? (tst-alt ptree))))

        ((conj? ptree)
         (and (side-effects-impossible? (conj-pre ptree))
              (side-effects-impossible? (conj-alt ptree))))

        ((disj? ptree)
         (and (side-effects-impossible? (disj-pre ptree))
              (side-effects-impossible? (disj-alt ptree))))

        ((prc? ptree)
         #t)

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (and (every? side-effects-impossible? args)
                (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                         (prc-req-and-opt-parms-only? oper)
                         (= (length (prc-parms oper)) (length args)))
                  (side-effects-impossible? (prc-body oper))
                  (let ((proc (app->specialized-proc ptree)))
                    (and proc
                         (not (proc-obj-side-effects? proc))))))))

        ((fut? ptree)
         (side-effects-impossible? (fut-val ptree)))

        (else
         (compiler-internal-error "side-effects-impossible?, unknown parse tree node type"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Lambda-lifting procedure:
;; ------------------------

;; (lambda-lift lst) takes a list of parse-trees and returns a list
;; where each parse-tree has been modified so that some of its
;; procedures (i.e. lambda-expressions) are replaced with weaker ones
;; (i.e. lambda-expressions having fewer or no closed variables).  It
;; is assumed that 'ptree' has already been assignment-converted.  The
;; only procedures that are lambda-lifted are named procedures and
;; procedures which are passed to some primitive higher-order functions
;; (such as call-with-current-continuation).

(define (lambda-lift lst)
  (for-each (lambda (ptree)
              (ll! ptree (varset-empty) '()))
            lst)
  lst)

(define (ll! ptree cst-procs env)

  (define (new-env env vars)
    (define (loop i l)
      (if (pair? l)
        (let ((var (car l)))
          (cons (cons var (cons (ptset-size (var-refs var)) i))
                (loop (+ i 1) (cdr l))))
        env))
    (loop (length env) vars))

  (cond ((or (cst? ptree)
             (ref? ptree)
             (set? ptree)
             (def? ptree) ; guaranteed to be a toplevel definition
             (tst? ptree)
             (conj? ptree)
             (disj? ptree)
             (fut? ptree))
         (for-each (lambda (child) (ll! child cst-procs env))
                   (node-children ptree)))

        ((prc? ptree)
         (ll! (prc-body ptree) cst-procs (new-env env (prc-parms ptree))))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (ll!-let ptree cst-procs (new-env env (prc-parms oper)))
             (ll!-call ptree cst-procs env))))

        (else
         (compiler-internal-error "ll!, unknown parse tree node type"))))

(define (ll!-call ptree cst-procs env)

  (for-each (lambda (child) (ll! child cst-procs env))
            (node-children ptree))

  (let* ((oper (app-oper ptree))
         (proc (cond ((cst? oper) (cst-val oper))
                     ((ref? oper) (and (global? (ref-var oper))
                                       (global-proc-obj oper)))
                     (else        #f))))
    (if (proc-obj? proc)
        (let* ((lift-pat
                (proc-obj-lift-pat proc))
               (receiver-arg-pos
                (modulo (quotient lift-pat 1000) 10))
               (min-nb-args
                (modulo (quotient lift-pat 100) 10))
               (nb-req-and-opt-parms
                (modulo (quotient lift-pat 10) 10))
               (max-lifted-vars
                (modulo lift-pat 10))
               (args
                (app-args ptree))
               (nb-args
                (length args)))
          (if (and (< 0 receiver-arg-pos)
                   (<= min-nb-args nb-args))
              (let ((receiver
                     (list-ref args (- receiver-arg-pos 1))))
                (if (and (prc? receiver)
                         (lambda-lift? (node-env receiver))
                         (prc-req-and-opt-parms-only? receiver)
                         (<= nb-req-and-opt-parms
                             (length (prc-parms receiver)))
                         (= (- (length (prc-parms receiver))
                               nb-req-and-opt-parms)
                            (- nb-args min-nb-args)))
                    (let ((vars
                           (ll-lifted-vars (bound-free-variables receiver)
                                           cst-procs
                                           env)))
                      (if (and (not (null? vars))
                               (<= (+ (length vars) (- nb-args min-nb-args))
                                   max-lifted-vars))
                          (let ((cloned-vars (clone-vars vars)))

                            ;; modify call site

                            (define (new-ref* var)
                              (new-ref (var-source var) (node-env ptree) var))

                            (node-children-set!
                             ptree
                             (cons oper
                                   (append (take args min-nb-args)
                                           (map new-ref* vars)
                                           (drop args min-nb-args))))

                            ;; modify receiver procedure

                            (prc-parms-set!
                             receiver
                             (append (take (prc-parms receiver)
                                           nb-req-and-opt-parms)
                                     cloned-vars
                                     (drop (prc-parms receiver)
                                           nb-req-and-opt-parms)))
                            (for-each (lambda (x) (var-bound-set! x receiver))
                                      cloned-vars)
                            (node-fv-invalidate! receiver)
                            (for-each (lambda (x y) (var-clone-set! x y))
                                      vars
                                      cloned-vars)
                            (ll-rename! receiver)
                            (for-each (lambda (x) (var-clone-set! x #f))
                                      vars)))))))))))

(define (ll!-let ptree cst-procs env)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (var-val-map (pair-up vars vals)))

    (define (var->val var) (cdr (assq var var-val-map)))

    (define (liftable-proc-vars vars)
      (let loop ((cst-proc-vars-list
                   (keep (lambda (var)
                           (let ((val (var->val var)))
                             (and (prc? val)
                                  (lambda-lift? (node-env val))
                                  (ptset-every? oper-pos? (var-refs var)))))
                         vars)))
        (let* ((cst-proc-vars
                 (list->varset cst-proc-vars-list))
               (non-cst-proc-vars-list
                 (keep (lambda (var)
                         (let ((val (var->val var)))
                           (and (prc? val)
                                (not (varset-member? var cst-proc-vars)))))
                       vars))
               (non-cst-proc-vars
                 (list->varset non-cst-proc-vars-list))
               (cst-proc-vars-list*
                 (keep (lambda (var)
                         (not (varset-intersects?
                                (bound-free-variables (var->val var))
                                non-cst-proc-vars)))
                       cst-proc-vars-list)))
          (if (= (length cst-proc-vars-list)
                 (length cst-proc-vars-list*))
            cst-proc-vars-list
            (loop cst-proc-vars-list*)))))

    (define (transitively-closed-bound-free-variables vars)
      (let ((tcbfv-map
              (map (lambda (var)
                     (cons var (bound-free-variables (var->val var))))
                   vars)))
        (let loop ()
          (let ((changed? #f))
            (for-each (lambda (var-tcbfv)
                        (let ((tcbfv (cdr var-tcbfv)))
                          (let loop2 ((l (varset->list tcbfv))
                                      (fv tcbfv))
                            (if (null? l)
                              (if (not (= (varset-size fv)
                                          (varset-size tcbfv)))
                                (begin
                                  (set-cdr! var-tcbfv fv)
                                  (set! changed? #t)))
                              (let ((x (assq (car l) tcbfv-map)))
                                (loop2 (cdr l)
                                       (if x
                                         (varset-union fv (cdr x))
                                         fv)))))))
                      tcbfv-map)
            (if changed?
              (loop)
              tcbfv-map)))))

    (let* ((tcbfv-map
             (transitively-closed-bound-free-variables
              (liftable-proc-vars vars)))
           (cst-proc-vars-list
             (map car tcbfv-map))
           (cst-procs*
             (varset-union (list->varset cst-proc-vars-list) cst-procs)))

      (define (var->tcbfv var) (cdr (assq var tcbfv-map)))

      (define (lifted-vars var)
        (ll-lifted-vars (var->tcbfv var) cst-procs* env))

      (define (lift-app! var)
        (let* ((val (var->val var))
               (vars (lifted-vars var)))
          (if (not (null? vars))
            (for-each (lambda (oper)
                        (let ((node (node-parent oper)))

                          (define (new-ref* var)
                            (new-ref (var-source var) (node-env node) var))

                          (node-children-set! node
                            (cons (app-oper node)
                                  (append (map new-ref* vars)
                                          (app-args node))))))
                      (ptset->list (var-refs var))))))

      (define (lift-prc! var)
        (let* ((val (var->val var))
               (vars (lifted-vars var)))
          (if (not (null? vars))
            (let ((cloned-vars (clone-vars vars)))
              (prc-parms-set! val (append cloned-vars (prc-parms val)))
              (for-each (lambda (x) (var-bound-set! x val)) cloned-vars)
              (node-fv-invalidate! val)
              (for-each (lambda (x y) (var-clone-set! x y)) vars cloned-vars)
              (ll-rename! val)
              (for-each (lambda (x) (var-clone-set! x #f)) vars)))))

      (for-each lift-app! cst-proc-vars-list)
      (for-each lift-prc! cst-proc-vars-list)
      (for-each (lambda (node) (ll! node cst-procs* env)) vals)
      (ll! (prc-body proc) cst-procs* env))))

(define (ll-lifted-vars bfv cst-procs env)

  (define (order-vars vars)
    (map car
         (sort-list (map (lambda (var) (assq var env)) vars)
                    (lambda (x y)
;;;;                      (if (= (cadr x) (cadr y))
;;;;                        (< (cddr x) (cddr y))
;;;;                        (< (cadr x) (cadr y)))
                      (< (cddr x) (cddr y))))))

  (order-vars
   (varset->list (varset-difference bfv cst-procs))))

(define (ll-rename! ptree)

  (if (ref? ptree)
    (let* ((var (ref-var ptree))
           (x (var-clone var)))
      (if x
        (begin
          (var-refs-set! var (ptset-remove (var-refs var) ptree))
          (var-refs-set! x (ptset-adjoin (var-refs x) ptree))
          (ref-var-set! ptree x)))))

  (node-fv-set! ptree #t)
  (node-bfv-set! ptree #t)

  (for-each (lambda (child) (ll-rename! child))
            (node-children ptree)))

;;;----------------------------------------------------------------------------
;;
;; Debugging stuff:

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; (parse-tree->expression ptree [location-table [annotations]]) returns
;; the Scheme expression corresponding to the parse tree 'ptree' and, if
;; location-table is supplied, it accumulates in that table the
;; correspondence between generated expressions and the source-code
;; location.

(define (parse-tree->expression ptree . rest)
  (let* ((loc-table (and (pair? rest) (car rest)))
         (annotations? (and (pair? rest) (pair? (cdr rest)) (cadr rest))))
    (se ptree '() (list 0) (vector loc-table annotations?))))

(define (se ptree env num ctx)

  (cond ((cst? ptree)
         (let ((val (cst-val ptree)))
           (se-constant val ptree ctx)))

        ((ref? ptree)
         (se-gen
          (se-var->id (ref-var ptree) env)
          ptree
          ctx))

        ((set? ptree)
         (se-gen
          (list set!-sym
                (se-var->id (set-var ptree) env)
                (se (set-val ptree) env num ctx))
          ptree
          ctx))

        ((def? ptree)
         (se-gen
          (list define-sym
                (se-var->id (def-var ptree) env)
                (se (def-val ptree) env num ctx))
          ptree
          ctx))

        ((tst? ptree)
         (se-gen
          (list if-sym (se (tst-pre ptree) env num ctx)
                       (se (tst-con ptree) env num ctx)
                       (se (tst-alt ptree) env num ctx))
          ptree
          ctx))

        ((conj? ptree)
         (se-gen
          (list and-sym (se (conj-pre ptree) env num ctx)
                        (se (conj-alt ptree) env num ctx))
          ptree
          ctx))

        ((disj? ptree)
         (se-gen
          (list or-sym (se (disj-pre ptree) env num ctx)
                       (se (disj-alt ptree) env num ctx))
          ptree
          ctx))

        ((prc? ptree)
         (let ((new-env (se-rename ptree env num)))
           (se-gen
            (list lambda-sym
                  (se-parameters (prc-parms ptree)
                                 (prc-opts ptree)
                                 (prc-keys ptree)
                                 (prc-rest? ptree)
                                 new-env
                                 num
                                 ptree
                                 ctx)
                  (se (prc-body ptree) new-env num ctx))
            ptree
            ctx)))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
               (let ((recursive?
                      (varset-intersects?
                       (list->varset (prc-parms oper))
                       (varset-union-multi (map bound-free-variables args)))))
                 (if (and use-begin-when-possible-in-expression?
                          (not recursive?)
                          (= (length args) 1)
                          (not (varset-member?
                                (car (prc-parms oper))
                                (bound-free-variables (prc-body oper)))))

                     (let* ((expr1 (se (car args) env num ctx))
                            (expr2 (se (prc-body oper) env num ctx)))
                       (se-gen
                        (cons begin-sym
                              (cons expr1
                                    (if (and (pair? expr2)
                                             (eq? (car expr2) begin-sym))
                                        (cdr expr2)
                                        (list expr2))))
                        ptree
                        ctx))

                     (let ((new-env (se-rename oper env num)))
                       (se-gen
                        (list (if recursive?
                                  letrec-sym
                                  let-sym)
                              (se-bindings (prc-parms oper) args new-env num ctx)
                              (se (prc-body oper) new-env num ctx))
                        ptree
                        ctx))))

               (let ((call
                      (se-gen
                       (map (lambda (x) (se x env num ctx))
                            (cons oper args))
                       ptree
                       ctx)))
                 (if (vector-ref ctx 1)
                     (cons (if (safe? (node-env ptree)) 'SAFE 'NOT-SAFE) call)
                     call)))))

        ((fut? ptree)
         (se-gen
          (list future-sym (se (fut-val ptree) env num ctx))
          ptree
          ctx))

        (else
         (compiler-internal-error "se, unknown parse tree node type"))))

(define (se-gen expr ptree ctx)
  (let ((loc-table (vector-ref ctx 0)))
    (if loc-table
        (let ((src (node-source ptree)))
          (let ((locat (source-locat src)))
            (table-set! loc-table expr locat))))
    expr))

(define use-actual-primitives-in-expression? #f)
(set! use-actual-primitives-in-expression? #t)

(define use-begin-when-possible-in-expression? #f)
(set! use-begin-when-possible-in-expression? #t)

(define (se-constant val ptree ctx)
  (se-gen
   (cond ((proc-obj? val)
          (let ((name (string->symbol (proc-obj-name val))))
            (if use-actual-primitives-in-expression?
                (list quote-sym (eval name))
                (list 'PRIM name))))
         ((self-evaluating? val)
          val)
         (else
          (list quote-sym val)))
   ptree
   ctx))

(define (se-var->id var env)
  (let ((id (let ((x (assq var env)))
              (if x (cdr x) (var-name var)))))
;; for debugging:
;;    (string->symbol
;;     (string-append (symbol->string id)
;;                    ":"
;;                    (number->string (##object->serial-number var))))
    id))

(define use-dotted-rest-parameter-when-possible? #f)
(set! use-dotted-rest-parameter-when-possible? #t)

(define (se-parameters parms opts keys rest? env num ptree ctx)

  (define (se-required parms n)
    (if (= n 0)
      (se-opts parms)
      (let ((parm (se-var->id (car parms) env)))
        (cons parm (se-required (cdr parms) (- n 1))))))

  (define (se-opts parms)
    (if (null? opts)
      (se-rest-and-keys parms)
      (cons optional-object
            (let loop ((parms parms) (opts opts))
              (if (null? opts)
                (se-rest-and-keys parms)
                (let ((parm (se-var->id (car parms) env)))
                  (cons (list parm (se-constant (car opts) ptree ctx))
                        (loop (cdr parms) (cdr opts)))))))))

  (define (se-rest-and-keys parms)

    (define (se-rest-at-end parm)
      (if use-dotted-rest-parameter-when-possible?
        parm
        (cons rest-object (cons parm '()))))

    (if rest?
      (let ((parm (se-var->id (car (last-pair parms)) env)))
        (if (not keys)
          (se-rest-at-end parm)
          (if (eq? rest? 'dsssl)
            (cons rest-object (cons parm (se-keys parms '())))
            (se-keys parms (se-rest-at-end parm)))))
      (se-keys parms '())))

  (define (se-keys parms tail)
    (if (not keys)
      tail
      (cons key-object
            (let loop ((parms parms) (keys keys))
              (if (null? keys)
                tail
                (let ((parm (se-var->id (car parms) env)))
                  (cons (list parm (se-constant (cdr (car keys)) ptree ctx))
                        (loop (cdr parms) (cdr keys)))))))))

  (se-required parms
               (- (length parms)
                  (length opts)
                  (if keys (length keys) 0)
                  (if rest? 1 0))))

(define (se-bindings vars vals env num ctx)
  (if (null? vars)
    '()
    (cons (list (se-var->id (car vars) env) (se (car vals) env num ctx))
          (se-bindings (cdr vars) (cdr vals) env num ctx))))

(define (se-rename proc env num)
  (let* ((parms
          (prc-parms proc))
         (free-vars
          (varset->list (free-variables (prc-body proc))))
         (p-names
          (map var-name parms))
         (fv-names
          (map var-name free-vars))
         (names
          (append p-names fv-names))
         (n
          (length p-names)))

    (define (conflict? var i)
      (let* ((p (pos-in-list var free-vars))
             (k (if p (+ p n) i)))
        (let loop ((lst names) (j 0))
          (if (null? lst)
            #f
            (let ((x (car lst)))
              (if (and (not (= i j))
                       (not (= k j))
                       (eq? x (var-name var)))
                #t
                (loop (cdr lst) (+ j 1))))))))

    (define (rename vars i)
      (if (null? vars)
        env
        (let* ((var (car vars))
               (id (var-name var)))
          (cons (cons var
                      (if (conflict? var i)
                        (begin
                          (set-car! num (+ (car num) 1))
                          (string->symbol
                           (string-append (symbol->string id)
                                          "#"
                                          (number->string (car num)))))
                        id))
                (rename (cdr vars) (+ i 1))))))


    (rename parms 0)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; C-interface stuff:

(define (c-interface-begin module-ref)
  (set! c-interface-module-ref module-ref)
  (set! c-interface-proc-count 0)
  (set! c-interface-obj-count 0)
  (set! c-interface-types scheme-to-c-notation)
  (set! c-interface-release-fns '())
  (set! c-interface-release-fn-count 0)
  (set! c-interface-converters '())
  (set! c-interface-converter-count 0)
  (set! c-interface-decls '())
  (set! c-interface-procs '())
  (set! c-interface-inits '())
  (set! c-interface-objs '())
  #f)

(define (c-interface-end)
  (let ((i (make-c-intf (reverse c-interface-decls)
                        (reverse c-interface-procs)
                        (reverse c-interface-inits)
                        (reverse c-interface-objs))))
    (set! c-interface-module-ref #f)
    (set! c-interface-proc-count #f)
    (set! c-interface-obj-count #f)
    (set! c-interface-types #f)
    (set! c-interface-release-fns #f)
    (set! c-interface-release-fn-count #f)
    (set! c-interface-converters #f)
    (set! c-interface-converter-count #f)
    (set! c-interface-decls #f)
    (set! c-interface-procs #f)
    (set! c-interface-inits #f)
    (set! c-interface-objs #f)
    i))

(define c-interface-module-ref #f)
(define c-interface-proc-count #f)
(define c-interface-obj-count #f)
(define c-interface-types #f)
(define c-interface-release-fns #f)
(define c-interface-release-fn-count #f)
(define c-interface-converters #f)
(define c-interface-converter-count #f)
(define c-interface-decls #f)
(define c-interface-procs #f)
(define c-interface-inits #f)
(define c-interface-objs #f)

(define (add-c-type name type)
  (set! c-interface-types
    (cons (cons name type) c-interface-types))
  #f)

(define (add-c-decl declaration-string)
  (set! c-interface-decls
    (cons declaration-string c-interface-decls))
  #f)

(define (add-c-proc c-proc)
  (set! c-interface-proc-count (+ c-interface-proc-count 1))
  (set! c-interface-procs
    (cons c-proc c-interface-procs))
  #f)

(define (add-c-init initialization-code-string)
  (set! c-interface-inits
    (cons initialization-code-string c-interface-inits))
  #f)

(define (add-c-obj name obj)
  (let ((name
         (or name
             (string-append
              c-id-prefix
              "C_OBJ_"
              (number->string c-interface-obj-count)))))
    (if (not (assoc name c-interface-objs))
        (begin
          (set! c-interface-obj-count (+ c-interface-obj-count 1))
          (set! c-interface-objs (cons (cons name obj) c-interface-objs))))
    name))

(define (make-c-intf decls procs inits objs) (vector decls procs inits objs))
(define (c-intf-decls c-intf)        (vector-ref c-intf 0))
(define (c-intf-decls-set! c-intf x) (vector-set! c-intf 0 x))
(define (c-intf-procs c-intf)        (vector-ref c-intf 1))
(define (c-intf-procs-set! c-intf x) (vector-set! c-intf 1 x))
(define (c-intf-inits c-intf)        (vector-ref c-intf 2))
(define (c-intf-inits-set! c-intf x) (vector-set! c-intf 2 x))
(define (c-intf-objs c-intf)         (vector-ref c-intf 3))
(define (c-intf-objs-set! c-intf x)  (vector-set! c-intf 3 x))

(define (make-c-proc scheme-name c-name arity body)
  (vector c-proc-tag scheme-name c-name arity body))

(define c-proc-tag (list 'c-proc))

(define (c-proc? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) c-proc-tag)))

(define (c-proc-scheme-name x) (vector-ref x 1))
(define (c-proc-c-name x)      (vector-ref x 2))
(define (c-proc-arity x)       (vector-ref x 3))
(define (c-proc-body x)        (vector-ref x 4))

(define (**c-define-type-expr? source env)
  (and (match **c-define-type-sym -3 source env)
       (or (let ((len (length (source-code source))))
             (and (or (= len 3) (= len 6))
                  (proper-c-type-definition? source)))
           (ill-formed-special-form source))))

(define (proper-c-type-definition? source)
  (let* ((code (source-code source))
         (name-source (cadr code))
         (name (source-code name-source)))
    (cond ((not (symbol-object? name))
           (pt-syntax-error
             name-source
             "C type's name must be an identifier"))
          ((assq name c-interface-types)
           (pt-syntax-error
             name-source
             "C type's name is already defined"))
          ((= (length code) 3)
           (let ((type-source (caddr code)))
             (check-c-type type-source #f #t))) ; allow all types
          (else
           (let* ((ctype-source (caddr code))
                  (ctype (source-code ctype-source))
                  (ctos-source (cadddr code))
                  (ctos (source-code ctos-source))
                  (stoc-source (cadddr (cdr code)))
                  (stoc (source-code stoc-source))
                  (cleanup-source (cadddr (cddr code)))
                  (cleanup (source-code cleanup-source)))
             (cond ((not (string? ctype))
                    (pt-syntax-error
                      ctype-source
                      "Second argument to 'c-define-type' must be a string"))
                   ((not (string? ctos))
                    (pt-syntax-error
                      ctos-source
                      "Third argument to 'c-define-type' must be a string"))
                   ((not (valid-c-or-c++-function-id? ctos))
                    (pt-syntax-error
                      ctos-source
                      "Ill-formed C function identifier"))
                   ((not (string? stoc))
                    (pt-syntax-error
                      stoc-source
                      "Fourth argument to 'c-define-type' must be a string"))
                   ((not (valid-c-or-c++-function-id? stoc))
                    (pt-syntax-error
                      stoc-source
                      "Ill-formed C function identifier"))
                   ((not (or (false-object? cleanup)
                             (eq? cleanup #t)))
                    (pt-syntax-error
                      stoc-source
                      "Fifth argument to 'c-define-type' must be a boolean"))
                   (else
                    #t)))))))

(define (c-type-definition-name source)
  (let ((code (source-code source)))
    (cadr code)))

(define (c-type-definition-type source)
  (let ((code (source-code source)))
    (if (= (length code) 3)
      (vector 'alias
              (caddr code))
      (vector 'c-type
              (source-code (caddr code))
              (source-code (cadddr code))
              (source-code (cadddr (cdr code)))
              (source-code (cadddr (cddr code)))))))

(define (**c-declare-expr? source env)
  (and (match **c-declare-sym 2 source env)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
               source
               "Argument to 'c-declare' must be a string")))))

(define (c-declaration-body source)
  (cadr (source-code source)))

(define (**c-initialize-expr? source env)
  (and (match **c-initialize-sym 2 source env)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
               source
               "Argument to 'c-initialize' must be a string")))))

(define (c-initialization-body source)
  (cadr (source-code source)))

(define (**c-lambda-expr? source env)
  (and (match **c-lambda-sym 4 source env)
       (let ((code (source-code source)))
         (if (not (string? (source-code (cadddr code))))
           (pt-syntax-error
             source
             "Third argument to 'c-lambda' must be a string")
           (check-c-function-type (cadr code) (caddr code) #f)))))

(define (**c-define-expr? source env)
  (and (match **c-define-sym -7 source env)
       (proper-c-definition? source env)))

(define (proper-c-definition? source env)
  (let* ((code (source-code source))
         (pattern-source (cadr code))
         (pattern (source-code pattern-source))
         (arg-typs-source (caddr code))
         (res-typ-source (cadddr code))
         (name-source (car (cddddr code)))
         (name (source-code name-source))
         (scope-source (cadr (cddddr code)))
         (scope (source-code scope-source)))
    (cond ((not (pair? pattern))
           (pt-syntax-error
             pattern-source
             "Ill-formed definition pattern"))
          ((not (bindable-var? (car pattern) env))
           (pt-syntax-error
             (car pattern)
             "Procedure name must be an identifier"))
          (else
           (and (check-c-function-type arg-typs-source res-typ-source #f)
                (cond ((not (string? name))
                       (pt-syntax-error
                         name-source
                         "Fourth argument to 'c-define' must be a string"))
                      ((not (valid-c-or-c++-function-id? name))
                       (pt-syntax-error
                         name-source
                         "Ill-formed C function identifier"))
                      ((not (string? scope))
                       (pt-syntax-error
                         scope-source
                         "Fifth argument to 'c-define' must be a string"))
                      (else
                       #t)))))))

(define (c-definition-name source)
  (let ((code (source-code source)))
    (car (source-code (cadr code)))))

(define (c-definition-value source)
  (let ((code (source-code source))
        (loc (source-locat source)))
    (make-source
      (cons (make-source **lambda-sym loc)
            (cons (parms->source (cdr (source-code (cadr code))) loc)
                  (cdr (cddddr code))))
      loc)))

(define (c-definition-param-types source)
  (source-code (caddr (source-code source))))

(define (c-definition-result-type source)
  (cadddr (source-code source)))

(define (c-definition-proc-name source)
  (car (cddddr (source-code source))))

(define (c-definition-scope source)
  (cadr (cddddr (source-code source))))

(define (c-type-pt-syntax-error source err-source msg . args)
  (apply pt-syntax-error (cons (or err-source source) (cons msg args))))

(define (check-c-function-type arg-typs-source res-typ-source err-source)
  (and (check-c-arg-types arg-typs-source err-source)
       (check-c-result-type res-typ-source err-source)))

(define (check-c-arg-types arg-typs-source err-source)
  (let ((arg-typs (source-code arg-typs-source)))
    (if (not (proper-length arg-typs))
      (c-type-pt-syntax-error
        arg-typs-source
        err-source
        "Ill-terminated C function argument type list")
      (let loop ((lst arg-typs))
        (if (pair? lst)
          (and (check-c-type (car lst) err-source #f) ; void not allowed
               (loop (cdr lst)))
          #t)))))

(define (check-c-result-type res-typ-source err-source)
  (check-c-type res-typ-source err-source #t)) ; allow all types

(define (check-c-type typ-source err-source void-allowed?)

  (define (ill-formed-c-type)
    (c-type-pt-syntax-error typ-source err-source "Ill-formed C type"))

  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((len (proper-length (cdr typ))))
             (if len
               (let ((head (source-code (car typ))))

                 (define (check pointer? err-msg)
                   (or (and (>= len 1)
                            (<= len 3)
                            (let* ((x-source (cadr typ))
                                   (x (source-code x-source)))
                              (if pointer?
                                (check-c-type
                                 x-source
                                 err-source
                                 #t) ; allow all types
                                (and (string? x)
                                     (valid-c-or-c++-type-id? x))))
                            (or (< len 2)
                                (let ((tag (source-code (caddr typ))))
                                  (or (false-object? tag)
                                      (symbol-object? tag)
                                      (and (pair? tag)
                                           (proper-length tag)
                                           (every?
                                            (lambda (x)
                                              (symbol-object?
                                               (source-code x)))
                                            tag)))))
                            (or (< len 3)
                                (let ((id (source-code (cadddr typ))))
                                  (or (false-object? id)
                                      (and (string? id)
                                           (valid-c-or-c++-function-id? id))))))
                       (c-type-pt-syntax-error
                        typ-source
                        err-source
                        err-msg)))

                 (define (check-function err-msg)
                   (if (= len 2)
                     (check-c-function-type
                      (cadr typ)
                      (caddr typ)
                      err-source)
                     (c-type-pt-syntax-error
                      typ-source
                      err-source
                      err-msg)))

                 (cond ((eq? head struct-sym)
                        (check #f "Ill-formed C STRUCT type"))
                       ((eq? head union-sym)
                        (check #f "Ill-formed C UNION type"))
                       ((eq? head type-sym)
                        (check #f "Ill-formed C TYPE type"))
                       ((eq? head pointer-sym)
                        (check #t "Ill-formed C POINTER type"))
                       ((eq? head nonnull-pointer-sym)
                        (check #t "Ill-formed C NONNULL POINTER type"))
                       ((eq? head function-sym)
                        (check-function "Ill-formed C FUNCTION type"))
                       ((eq? head nonnull-function-sym)
                        (check-function "Ill-formed C NONNULL FUNCTION type"))
                       (else
                        (ill-formed-c-type))))

               (c-type-pt-syntax-error
                 typ-source
                 err-source
                 "Ill-terminated C type"))))
          ((string? typ)
           (or (valid-c-or-c++-type-id? typ)
               (c-type-pt-syntax-error
                typ-source
                err-source
                "Ill-formed C type identifier")))
          ((symbol-object? typ)
           (if (eq? typ void-sym)
             (or void-allowed?
                 (c-type-pt-syntax-error
                   typ-source
                   err-source
                   "Ill-placed C VOID type"))
             (let ((x (assq typ c-interface-types)))
               (if x
                 (let ((def (cdr x)))
                   (case (vector-ref def 0)
                     ((c-type)
                      #t)
                     (else
                      (check-c-type
                        (vector-ref def 1)
                        typ-source
                        void-allowed?))))
                 (c-type-pt-syntax-error
                   typ-source
                   err-source
                   "Undefined C type identifier:"
                   typ)))))
          (else
           (ill-formed-c-type)))))

(define (resolve-type typ-source)
  (let ((typ (source-code typ-source)))
    (if (symbol-object? typ)
      (let ((x (assq typ c-interface-types)))
        (if x
          (let ((def (cdr x)))
            (if (eq? (vector-ref def 0) 'alias)
              (resolve-type (vector-ref def 1))
              typ-source))
          typ-source))
      typ-source)))

(define (void-type? typ-source)
  (eq? (source-code (resolve-type typ-source)) void-sym))

(define (scmobj-type? typ-source)
  (eq? (source-code (resolve-type typ-source)) scheme-object-sym))

(define (type-needs-cleanup? typ-source)
  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((head (source-code (car typ))))
             (or (eq? head struct-sym)
                 (eq? head union-sym)
                 (eq? head type-sym)
                 (eq? head function-sym)
                 (eq? head nonnull-function-sym))))
          ((string? typ)
           #t)
          ((symbol-object? typ)
           (let ((x (assq typ c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    (vector-ref def 4))
                   (else
                    (type-needs-cleanup? (vector-ref def 1)))))
               #f)))
          (else
           #f))))

(define (type-accessed-indirectly? typ-source)
  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((head (source-code (car typ))))
             (cond ((eq? head struct-sym)
                    (vector "STRUCT" (source-code (cadr typ))))
                   ((eq? head union-sym)
                    (vector "UNION" (source-code (cadr typ))))
                   ((eq? head type-sym)
                    (vector "TYPE" (source-code (cadr typ))))
                   ((eq? head pointer-sym)
                    '#("POINTER" #f))
                   ((eq? head nonnull-pointer-sym)
                    '#("NONNULLPOINTER" #f))
                   ((eq? head function-sym)
                    '#("FUNCTION" #f))
                   ((eq? head nonnull-function-sym)
                    '#("NONNULLFUNCTION" #f))
                   (else
                    #f))))
          ((string? typ)
           (vector "TYPE" typ))
          ((symbol-object? typ)
           (let ((x (assq typ c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    #f)
                   (else
                    (type-accessed-indirectly? (vector-ref def 1)))))
               #f)))
          (else
           #f))))

(define (pt-c-lambda source env use)
  (let ((name
         (build-c-lambda
           (c-lambda-param-types source)
           (c-lambda-result-type source)
           (source-code (c-lambda-proc-name source)))))
    (new-ref source
             env
             (env-lookup-global-var env (string->symbol name)))))

(define (c-lambda-param-types source)
  (source-code (cadr (source-code source))))

(define (c-lambda-result-type source)
  (caddr (source-code source)))

(define (c-lambda-proc-name source)
  (cadddr (source-code source)))

(define (number-from-1 lst)
  (let loop ((i 1) (lst1 lst) (lst2 '()))
    (if (pair? lst1)
      (loop (+ i 1) (cdr lst1) (cons (cons (car lst1) i) lst2))
      (reverse lst2))))

(define (c-type-converter to-scmobj? typ from to)

  (define (err)
    (compiler-internal-error "c-type-converter, unknown C type"))

  (define (convert kind name tag id)
    (let ((tag-str
           (if (false-object? tag)
             (string-append c-id-prefix "FAL")
             (let* ((tag-list (if (symbol-object? tag) (list tag) tag))
                    (name (and (symbol-object? (car tag-list))
                               (string-append
                                c-id-prefix
                                "C_TAG_"
                                (scheme-id->c-id
                                 (symbol->string (car tag-list)))))))
               (add-c-obj name tag-list)))))
      (if to-scmobj?

        (string-append
         (cond ((eq? kind pointer-sym)
                "POINTER_TO_SCMOBJ(")
               ((eq? kind nonnull-pointer-sym)
                "NONNULLPOINTER_TO_SCMOBJ(")
               (else
                (string-append
                 (cond ((eq? kind struct-sym)
                        "STRUCT_TO_SCMOBJ(")
                       ((eq? kind union-sym)
                        "UNION_TO_SCMOBJ(")
                       (else
                        "TYPE_TO_SCMOBJ("))
                 name
                 ",")))
         from "_voidstar," tag-str ","
         (if (false-object? id)
           (if (or (eq? kind pointer-sym)
                   (eq? kind nonnull-pointer-sym))
             (string-append
              c-id-prefix
              "RELEASE_POINTER")
             (let* ((descr
                     (cons kind name))
                    (x
                     (assoc descr c-interface-release-fns)))
               (if x
                 (cdr x)
                 (let* ((i
                         c-interface-release-fn-count)
                        (release-fn
                         (string-append
                          c-id-prefix
                          "release_fn"
                          (number->string i))))
                   (set! c-interface-release-fn-count
                     (+ i 1))
                   (set! c-interface-release-fns
                     (cons (cons descr release-fn)
                           c-interface-release-fns))
                   (add-c-decl
                    (string-append
                     c-id-prefix
                     (cond ((eq? kind struct-sym)
                            "DEF_RELEASE_FN_STRUCT(")
                           ((eq? kind union-sym)
                            "DEF_RELEASE_FN_UNION(")
                           (else
                            "DEF_RELEASE_FN_TYPE("))
                     name
                     ","
                     release-fn
                     ")"))
                   release-fn))))
           id)
         "," to)

        (string-append
         (cond ((eq? kind pointer-sym)
                "SCMOBJ_TO_POINTER(")
               ((eq? kind nonnull-pointer-sym)
                "SCMOBJ_TO_NONNULLPOINTER(")
               (else
                (string-append
                 (cond ((eq? kind struct-sym)
                        "SCMOBJ_TO_STRUCT(")
                       ((eq? kind union-sym)
                        "SCMOBJ_TO_UNION(")
                       (else
                        "SCMOBJ_TO_TYPE("))
                 name
                 ",")))
         from "," to "_voidstar," tag-str))))

  (let ((t (source-code typ)))
    (cond ((pair? t)
           (let ((head (source-code (car t)))
                 (len (length (cdr t))))
             (cond ((or (eq? head struct-sym)
                        (eq? head union-sym)
                        (eq? head type-sym)
                        (eq? head pointer-sym)
                        (eq? head nonnull-pointer-sym))
                    (convert
                     head
                     (source-code (cadr t))
                     (if (>= len 2)
                       (source->expression (caddr t))
                       (string->symbol (c-type-decl typ "")))
                     (if (>= len 3)
                       (source-code (cadddr t))
                       false-object)))
                   ((or (eq? head function-sym)
                        (eq? head nonnull-function-sym))
                    (if to-scmobj?
                      (string-append
                       (if (eq? head function-sym)
                         "FUNCTION_TO_SCMOBJ("
                         "NONNULLFUNCTION_TO_SCMOBJ(")
                       from "_voidstar," to)
                      (let ((converter
                             (fn-param-converter typ)))
                        (string-append
                         (if (eq? head function-sym)
                           "SCMOBJ_TO_FUNCTION("
                           "SCMOBJ_TO_NONNULLFUNCTION(")
                         from "," converter "," to "_voidstar"))))
                   (else
                    (err)))))
          ((string? t)
           (convert
            type-sym
            t
            false-object
            false-object))
          ((symbol-object? t)
           (let ((x (assq t c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    (if to-scmobj?
                      (string-append
                       (vector-ref def 2)
                       "(" from "," to)
                      (string-append
                       (vector-ref def 3)
                       "(" from "," to)))
                   (else
                    (c-type-converter
                      to-scmobj?
                      (vector-ref def 1)
                      from
                      to))))
               (err))))
          (else
           (err)))))

(define nl-str (string #\newline))

(define (c-preproc-define id params val body)
  (string-append
    "#define " id params " " val nl-str
    body
    "#undef " id nl-str))

(define (c-preproc-define-default-empty id body)
  (string-append
    "#undef " id nl-str
    body
    "#ifndef " id nl-str
    "#define " id nl-str
    "#endif" nl-str))

(define (c-result sfun? scheme-side?)
  (string-append
    c-id-prefix
    (if scheme-side?
      (if sfun? "SFUN_RESULT" "CFUN_RESULT")
      "result")))

(define (c-argument scheme-side? numbered-typ)
  (let ((i (number->string (cdr numbered-typ))))
    (string-append
      c-id-prefix
      (if scheme-side? "ARG" "arg")
      i)))

(define (c-declare-argument sfun? numbered-typ body)
  (let* ((c-id (c-argument #f numbered-typ))
         (scm-id (c-argument #t numbered-typ))
         (typ (car numbered-typ))
         (i (number->string (cdr numbered-typ)))
         (scmobj? (scmobj-type? typ))
         (indirect-access (type-accessed-indirectly? typ)))
    (string-append
      c-id-prefix
      (if scmobj?
        (if sfun? "BEGIN_SFUN_ARG_SCMOBJ(" "BEGIN_CFUN_ARG_SCMOBJ(")
        (if sfun? "BEGIN_SFUN_ARG(" "BEGIN_CFUN_ARG("))
      i
      (if scmobj?
        ""
        (string-append
         ","
         (if sfun?
           scm-id
           (if indirect-access
             (string-append "void* " c-id "_voidstar")
             (c-type-decl typ c-id)))))
      ")" nl-str
      (if indirect-access
        (if sfun?
          (if (vector-ref indirect-access 1)
            (let ((tail
                   (string-append
                    (vector-ref indirect-access 0)
                    "("
                    (vector-ref indirect-access 1)
                    ","
                    c-id "_voidstar,"
                    c-id
                    ")" nl-str)))
              (string-append
               c-id-prefix "BEGIN_SFUN_COPY_" tail
               body
               c-id-prefix "END_SFUN_COPY_" tail))
            (c-preproc-define
             (string-append c-id "_voidstar")
             ""
             (string-append c-id-prefix "SFUN_CAST(void*," c-id ")")
             body))
          (c-preproc-define
           c-id
           ""
           (string-append
            c-id-prefix
            (if (vector-ref indirect-access 1)
              (string-append
               "CFUN_CAST_AND_DEREF("
               (c-type-decl typ "*"))
              (string-append
               "CFUN_CAST("
               (c-type-decl typ "")))
            ","
            c-id "_voidstar)")
           body))
        body)
      c-id-prefix
      (if scmobj?
        (if sfun? "END_SFUN_ARG_SCMOBJ(" "END_CFUN_ARG_SCMOBJ(")
        (if sfun? "END_SFUN_ARG(" "END_CFUN_ARG("))
      i ")" nl-str)))

(define (c-convert-representation sfun? to-scmobj? typ from to i body)
  (let ((tail
         (string-append
          (c-type-converter to-scmobj? typ from to)
          (if i (string-append "," i) "")
          ")" nl-str)))
    (string-append
     c-id-prefix (if sfun? "BEGIN_SFUN_" "BEGIN_CFUN_") tail
     body
     c-id-prefix (if sfun? "END_SFUN_" "END_CFUN_") tail)))

(define (c-convert-argument sfun? numbered-typ body)
  (let* ((typ
          (car numbered-typ))
         (from
          (c-argument (not sfun?) numbered-typ))
         (to
          (c-argument sfun? numbered-typ))
         (i
          (number->string (cdr numbered-typ)))
         (decl
          (c-declare-argument
            sfun?
            numbered-typ
            (if (scmobj-type? typ)
              (c-preproc-define to "" from body)
              (c-convert-representation sfun? sfun? typ from to i body)))))
    (if sfun?
      decl
      (c-preproc-define
        from
        ""
        (string-append
          c-id-prefix
          "CFUN_ARG("
          i
          ")")
        decl))))

(define (c-set-result sfun? result-typ)
  (cond ((void-type? result-typ)
         (string-append
           c-id-prefix
           (if sfun? "SFUN_SET_RESULT_VOID" "CFUN_SET_RESULT_VOID")
           nl-str))
        ((scmobj-type? result-typ)
         (string-append
           c-id-prefix
           (if sfun? "SFUN_SET_RESULT_SCMOBJ" "CFUN_SET_RESULT_SCMOBJ")
           nl-str))
        (else
         (c-convert-representation
           sfun?
           (not sfun?)
           result-typ
           (c-result sfun? sfun?)
           (c-result sfun? (not sfun?))
           #f
           (string-append
             c-id-prefix
             (if sfun? "SFUN_SET_RESULT" "CFUN_SET_RESULT")
             nl-str)))))

(define (c-make-function sfun? name param-typs result-typ make-body)
  (let ((cleanup?
         (not (every? (lambda (t) (not (type-needs-cleanup? t)))
                      param-typs))))

    (define (convert-param-list)

      (define (scmobj-typ? numbered-typ)
        (scmobj-type? (car numbered-typ)))

      (define (not-scmobj-typ? numbered-typ)
        (not (scmobj-typ? numbered-typ)))

      (let ((numbered-param-typs (number-from-1 param-typs)))
        (let convert ((numbered-typs
                        (append (keep scmobj-typ? numbered-param-typs)
                                (keep not-scmobj-typ? numbered-param-typs))))
          (if (null? numbered-typs)
            (make-body (c-set-result sfun? result-typ) cleanup?)
            (c-convert-argument
              sfun?
              (car numbered-typs)
              (convert (cdr numbered-typs)))))))

    (c-preproc-define

      (string-append c-id-prefix "NARGS")

      ""

      (number->string (length param-typs))

      (if (void-type? result-typ)

        (string-append
          c-id-prefix
          (if sfun?
            (string-append
             "BEGIN_SFUN_VOID("
             sfun?
             ")")
            (string-append
             "BEGIN_CFUN_VOID("
             name
             ")"))
          nl-str
          (convert-param-list)
          c-id-prefix
          (if sfun?
            "SFUN_ERROR_VOID"
            (if cleanup? "CFUN_ERROR_CLEANUP_VOID" "CFUN_ERROR_VOID"))
          nl-str
          (if sfun?
            (c-set-result sfun? result-typ)
            "")
          c-id-prefix
          (if sfun? "END_SFUN_VOID" "END_CFUN_VOID") nl-str)

        (let* ((c-id
                (c-result sfun? #f))
               (scmobj-result?
                (scmobj-type? result-typ))
               (indirect-access-result
                (type-accessed-indirectly? result-typ))
               (body
                (string-append
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun?
                      (string-append
                       "BEGIN_SFUN_SCMOBJ("
                       sfun?
                       ")")
                      (string-append
                       "BEGIN_CFUN_SCMOBJ("
                       name
                       ")"))
                    (string-append
                      (if sfun?
                        (string-append
                          "BEGIN_SFUN("
                          sfun?
                          ",")
                        (string-append
                          "BEGIN_CFUN("
                          name
                          ","))
                      (if indirect-access-result
                        (string-append "void* " c-id "_voidstar"
                                       (if sfun? " = 0" ""))
                        (c-type-decl result-typ c-id))
                      ")"))
                  nl-str
                  (convert-param-list)
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun?
                      "SFUN_ERROR_SCMOBJ"
                      (if cleanup? "CFUN_ERROR_CLEANUP_SCMOBJ" "CFUN_ERROR_SCMOBJ"))
                    (if sfun?
                      "SFUN_ERROR"
                      (if cleanup? "CFUN_ERROR_CLEANUP" "CFUN_ERROR")))
                  nl-str
                  (if sfun?
                    (c-set-result sfun? result-typ)
                    "")
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun? "END_SFUN_SCMOBJ" "END_CFUN_SCMOBJ")
                    (if sfun? "END_SFUN" "END_CFUN"))
                  nl-str
                  (if sfun?
                    (string-append "return " c-id ";" nl-str) ;
                    ""))))
               (if indirect-access-result

                   (c-preproc-define
                    c-id
                    ""
                    (string-append
                     c-id-prefix
                     (if sfun? "SFUN_CAST_AND_DEREF(" "CFUN_CAST_AND_DEREF(")
                     (c-type-decl result-typ "*")
                     ","
                     (if (vector-ref indirect-access-result 1)
                         ""
                         "&")
                     c-id "_voidstar)")
                    body)

                   body))))))

(define (comma-separated strs)
  (if (null? strs)
      ""
      (string-append
       (car strs)
       (apply string-append
              (map (lambda (s) (string-append "," s)) (cdr strs))))))

(define (c-type-decl typ inner)

  (define (err)
    (compiler-internal-error "c-type-decl, unknown C type"))

  (define (prefix-inner str)
    (if (and (> (string-length inner) 0)
             (c-id-subsequent? (string-ref inner 0)))
        (string-append str " " inner)
        (string-append str inner)))

  (let ((t (source-code typ)))
    (cond ((pair? t)
           (let ((head (source-code (car t))))
             (cond ((eq? head struct-sym)
                    (prefix-inner
                     (string-append "struct " (source-code (cadr t)))))
                   ((eq? head union-sym)
                    (prefix-inner
                     (string-append "union " (source-code (cadr t)))))
                   ((eq? head type-sym)
                    (prefix-inner
                     (source-code (cadr t))))
                   ((or (eq? head pointer-sym)
                        (eq? head nonnull-pointer-sym))
                    (c-type-decl (cadr t)
                                 (string-append "*" inner)))
                   ((or (eq? head function-sym)
                        (eq? head nonnull-function-sym))
                    (c-type-decl (caddr t)
                                 (string-append
                                  "(*" inner ") "
                                  (c-param-list-with-types
                                   (source-code (cadr t))))))
                   (else
                    (err)))))
          ((string? t)
           (prefix-inner t))
          ((symbol-object? t)
           (let ((x (assq t c-interface-types)))
             (if x
                 (let ((def (cdr x)))
                   (case (vector-ref def 0)
                     ((c-type)
                      (prefix-inner (vector-ref def 1)))
                     (else
                      (c-type-decl (vector-ref def 1) inner))))
                 (err))))
          (else
           (err)))))

(define (c-param-list-with-types typs)
  (if (null? typs)
      (string-append c-id-prefix "PVOID")
      (string-append
       c-id-prefix
       "P(("
       (comma-separated (map (lambda (typ) (c-type-decl typ "")) typs))
       "),())")))

(define (c-param-id numbered-typ)
  (c-argument #f numbered-typ))

(define (c-param-list-with-ids numbered-typs)
  (if (null? numbered-typs)
      (string-append c-id-prefix "PVOID")
      (string-append
       c-id-prefix
       "P(("
       (comma-separated
        (map (lambda (t) (c-type-decl (car t) (c-param-id t)))
             numbered-typs))
       "),("
       (comma-separated (map c-param-id numbered-typs))
       ")"
       (apply string-append
              (map (lambda (t)
                     (string-append
                      nl-str
                      (c-type-decl (car t) (c-param-id t))
                      ";"))
                   numbered-typs))
       ")")))

(define (c-function-decl param-typs result-typ id scope body)
  (let ((numbered-typs (number-from-1 param-typs)))
    (let ((function-decl
           (c-type-decl result-typ
                        (string-append
                         id
                         " "
                         (if body
                             (c-param-list-with-ids numbered-typs)
                             (c-param-list-with-types param-typs))))))
      (if body
          (string-append
           scope " "
           function-decl nl-str
           "{" nl-str body "}" nl-str)
          (string-append
           function-decl ";" nl-str)))))

(define (c-function param-typs result-typ proc-name c-defined? scope)
  (let ((proc-val
         (if c-defined?
             (string-append
              c-id-prefix "MLBL(" c-id-prefix "C_LBL_" proc-name ")")
             (string-append
              c-id-prefix "FAL"))))

    (define (make-body set-result-code cleanup?)
      (string-append
       c-id-prefix "BEGIN_SFUN_BODY" nl-str
       (let convert ((numbered-typs (number-from-1 param-typs)))
         (if (null? numbered-typs)
             (string-append
              c-id-prefix
              (cond ((void-type? result-typ)
                     "SFUN_CALL_VOID")
                    ((scmobj-type? result-typ)
                     "SFUN_CALL_SCMOBJ")
                    (else
                     "SFUN_CALL"))
              nl-str)
             (let ((numbered-typ (car numbered-typs)))
               (string-append
                c-id-prefix
                "SFUN_ARG("
                (number->string (cdr numbered-typ))
                ","
                (c-argument #t numbered-typ)
                ")" nl-str
                (convert (cdr numbered-typs))))))
       set-result-code
       c-id-prefix "END_SFUN_BODY" nl-str))

    (add-c-decl
     (c-function-decl param-typs
                      result-typ
                      proc-name
                      scope
                      (c-make-function proc-val
                                       #f
                                       param-typs
                                       result-typ
                                       make-body)))))

(define (fn-param-converter typ)
  (let ((function-c-type (c-type-decl typ "")))
    (cond ((assoc function-c-type c-interface-converters)
           =>
           cdr)
          (else
           (let* ((t
                   (source-code typ))
                  (param-typs
                   (source-code (cadr t)))
                  (result-typ
                   (caddr t))
                  (i
                   c-interface-converter-count)
                  (converter
                   (string-append
                    c-id-prefix
                    "converter"
                    (number->string i))))
             (set! c-interface-converter-count
                   (+ i 1))
             (set! c-interface-converters
                   (cons (cons function-c-type converter)
                         c-interface-converters))
             (c-function
              param-typs
              result-typ
              converter
              #f
              (string-append c-id-prefix "LOCAL"))
             converter)))))

(define (build-c-define param-typs result-typ proc-name scope)
  (c-function param-typs result-typ proc-name #t scope))

(define (strip-param-typs param-typs)
  param-typs) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (build-c-lambda param-typs result-typ proc-name)
  (let* ((index
          (number->string c-interface-proc-count))
         (scheme-name
          (string-append (symbol->string c-interface-module-ref) "#" index))
         (c-name
          (string-append c-id-prefix (scheme-id->c-id scheme-name)))
         (arity
          (length param-typs))
         (stripped-param-typs
          (strip-param-typs param-typs)))

    (define (make-body set-result-code cleanup?)
      (string-append
       c-id-prefix
       (if cleanup? "BEGIN_CFUN_BODY_CLEANUP" "BEGIN_CFUN_BODY")
       nl-str
       (c-preproc-define-default-empty
        (string-append c-id-prefix "AT_END")
        (let ((c-id
               (c-result #f #f))
              (indirect-access-result
               (type-accessed-indirectly? result-typ)))

          (define (assign-result result)
            (cond ((void-type? result-typ)
                   (string-append result ";"))
                  (indirect-access-result
                   (if (vector-ref indirect-access-result 1)
                       (string-append
                        c-id-prefix
                        "CFUN_ASSIGN_"
                        (vector-ref indirect-access-result 0)
                        "("
                        (vector-ref indirect-access-result 1)
                        ","
                        c-id "_voidstar,"
                        result
                        ")")
                       (string-append
                        c-id-prefix
                        "CFUN_ASSIGN_"
                        (vector-ref indirect-access-result 0)
                        "("
                        c-id "_voidstar,"
                        result
                        ")")))
                  (else
                   (string-append
                    c-id-prefix
                    "CFUN_ASSIGN("
                    c-id ","
                    result
                    ")"))))

          (if (valid-c-or-c++-function-id? proc-name)

              (string-append
               (assign-result
                (string-append
                 proc-name "("
                 (comma-separated
                  (map c-param-id (number-from-1 stripped-param-typs)))
                 ")"))
               nl-str)

              (let ((end-of-code
                     (string-append c-id-prefix
                                    "return_"
                                    (scheme-id->c-id scheme-name))))
                (if (void-type? result-typ)
                    (c-preproc-define
                     (string-append c-id-prefix "return")
                     ""
                     (string-append
                      "goto " end-of-code)
                     (string-append
                      proc-name nl-str
                      end-of-code ":;" nl-str))
                    (c-preproc-define
                     (string-append c-id-prefix "return")
                     (string-append "(" c-id-prefix "val" ")")
                     (string-append
                      "do { " (assign-result (string-append c-id-prefix "val"))
                      " goto " end-of-code "; } while (0)")
                     (string-append
                      proc-name nl-str
                      end-of-code ":;" nl-str)))))))

       set-result-code
       c-id-prefix
       (if cleanup? "END_CFUN_BODY_CLEANUP" "END_CFUN_BODY")
       nl-str))

    (add-c-proc
     (make-c-proc scheme-name
                  c-name
                  arity
                  (c-make-function #f
                                   c-name
                                   stripped-param-typs
                                   result-typ
                                   make-body)))
    scheme-name))

(define (nonneg-integer->c-id n)

  (declare (generic))

  ;; With the parameters below, n must be in 0..3002032123531 (~41 bit int).

  ;; For n in 0..51 (a lowercase or uppercase ASCII letter) the result is a
  ;; one character string.
  ;;
  ;; For n in 52..259 (which covers the rest of the latin-1 characters) the
  ;; result is a two character string.
  ;;
  ;; For n in 260..3483 the result is a three character string. Etc.

  (define nb-initial 52) ;; upper and lowercase letters
  (define nb-subseq  10) ;; digits 0..9
  (define nb-bicodes  3) ;; integer in 0..9
  (define nb-digits  62) ;; (+ nb-initial nb-subseq)
  (define digits
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

  (define (digit d)
    (string-ref digits d))

  (if (< n nb-initial)
      (string (digit n))
      (let* ((n (- n nb-initial))
             (q (quotient n nb-initial)))
        (if (< q nb-bicodes)
            (string (digit (modulo n nb-initial))
                    (digit (+ q nb-initial)))
            (let ((n (- n (* nb-bicodes nb-initial))))
              (let loop1 ((m n)
                          (len 1))
                (let ((range (* nb-initial (expt nb-digits (- len 1)))))
                  (if (>= m range)
                      (and (< len (- nb-subseq nb-bicodes))
                           (loop1 (- m range)
                                  (+ len 1)))
                      (let loop2 ((i 1)
                                  (n (quotient m nb-initial))
                                  (lst (list (digit (modulo m nb-initial)))))
                        (if (< i len)
                            (loop2 (+ i 1)
                                   (quotient n nb-digits)
                                   (cons (digit (modulo n nb-digits)) lst))
                            (list->string
                             (let ((x (+ len nb-initial nb-bicodes -1)))
                               (reverse (cons (digit x) lst))))))))))))))

(define (char->c-id c)
  (nonneg-integer->c-id
   (let ((n (char->integer c)))
     (if (<= n 90)            ;; #\Z
         (if (>= n 65)        ;; #\A
             (+ n (+ 26 -65)) ;; #\A
             (+ n 52))
         (if (<= n 122)    ;; #\z
             (if (>= n 97) ;; #\a
                 (+ n -97) ;; #\a
                 (+ n 26))
             n)))))

(define (string->c-id str)
  (let loop ((i (- (string-length str) 1)) (lst '()))
    (if (>= i 0)
        (loop (- i 1)
              (cons (char->c-id (string-ref str i)) lst))
        (string-concatenate lst))))

(define (scheme-id->c-id s)
  (let loop1 ((i (- (string-length s) 1)) (lst '()))
    (if (>= i 0)
        (let ((c (string-ref s i)))
          (cond ((char=? c #\_)
                 (loop1 (- i 1) (cons c (cons c lst))))
                ((c-id-subsequent? c)
                 (loop1 (- i 1) (cons c lst)))
                (else
                 (let ((n (character->unicode c)))
                   (if (= n 0)
                       (loop1 (- i 1) (cons #\_ (cons #\0 (cons #\_ lst))))
                       (let loop2 ((n n) (lst (cons #\_ lst)))
                         (if (> n 0)
                             (loop2 (quotient n 16)
                                    (cons (string-ref "0123456789abcdef"
                                                      (modulo n 16))
                                          lst))
                             (loop1 (- i 1) (cons #\_ lst)))))))))
        (list->str lst))))

(define (c-id-initial? c) ; c is one of #\A..#\Z, #\a..#\z, #\_
  (let ((n (character->unicode c)))
    (or (and (>= n 65) (<= n 90))
        (and (>= n 97) (<= n 122))
        (= n 95))))

(define (c-id-subsequent? c) ; c is one of #\A..#\Z, #\a..#\z, #\_, #\0..#\9
  (let ((n (character->unicode c)))
    (or (and (>= n 65) (<= n 90))
        (and (>= n 97) (<= n 122))
        (= n 95)
        (and (>= n 48) (<= n 57)))))

(define (valid-c-id? id type?)
  (let ((n (string-length id)))
    (and (> n 0)
         (c-id-initial? (string-ref id 0))
         (let loop ((i 1) (depth 0))
           (if (< i n)
               (let ((c (string-ref id i)))
                 (cond ((and (< (+ i 2) n)
                             (char=? #\: c)
                             (char=? #\: (string-ref id (+ i 1)))
                             (c-id-initial? (string-ref id (+ i 2))))
                        (loop (+ i 3) depth))
                       ((and type?
                             (< (+ i 1) n)
                             (char=? #\< c)
                             (c-id-initial? (string-ref id (+ i 1))))
                        (loop (+ i 2) (+ depth 1)))
                       ((and (< (+ i 1) n)
                             (char=? #\, c)
                             (c-id-initial? (string-ref id (+ i 1)))
                             (> depth 0))
                        (loop (+ i 2) depth))
                       ((and (char=? #\> c)
                             (> depth 0))
                        (loop (+ i 1) (- depth 1)))
                       ((c-id-subsequent? c)
                        (loop (+ i 1) depth))
                       (else
                        #f)))
               (= depth 0))))))

(define (valid-c-or-c++-function-id? id)
  (valid-c-id? id #f))

(define (valid-c-or-c++-type-id? id)
  (valid-c-id? id #t))

;;;============================================================================
